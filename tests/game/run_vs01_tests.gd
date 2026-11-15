extends SceneTree
## TEST_ONLY: 정상 main을 관측한다. 게임 명령·시간·상태를 대행/주입하지 않는다.

const Main = preload("res://scenes/main.tscn")
const View = preload("res://scripts/ui/stage1_view.gd")
const SAMPLE_USEC := 1000000

var _host: Control
var _sink: FileAccess
var _directory: String = ""
var _run_id: String = ""
var _mode: String = ""
var _sequence: int = 0
var _input_sequence: int = 0
var _ledger_seen: int = 0
var _trace_seen: int = 0
var _last_sample: int = 0
var _sample_pending: bool = false
var _closing: bool = false
var _capture_pending: bool = false
var _capture_index: int = 0
var _milestone: String = ""
var _checks: Array[Dictionary] = []
var _failures: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var options := _options()
	if not options.ok:
		_abort("INVALID_OPTIONS")
		return
	_mode = options.mode
	_directory = options.directory
	_run_id = options.run_id
	if _mode == "OBSERVE" and DisplayServer.get_name() == "headless":
		_abort("OBSERVE_REQUIRES_GUI")
		return
	if not _open_output():
		_abort("OUTPUT_UNAVAILABLE_OR_EXISTS")
		return
	auto_accept_quit = false
	_record("RUN_START", _environment())
	var main := Main.instantiate()
	root.add_child(main)
	for child: Node in main.get_children():
		if child.get_script() == View:
			_host = child
	if _host == null:
		_abort("NORMAL_MAIN_HOST_UNAVAILABLE")
		return
	_sample("INITIAL")
	if _mode != "OBSERVE":
		_self_test()
		return
	root.window_input.connect(_input_log)
	root.close_requested.connect(_close_gui)
	process_frame.connect(_on_frame)
	_capture("INITIAL")
	print("DEV024_OBSERVER_READY ", _run_id)


func _options() -> Dictionary:
	var value := {"ok": true, "mode": "", "directory": "", "run_id": ""}
	for arg: String in OS.get_cmdline_user_args():
		if arg in ["--observe", "--self-test", "--verify-failure-exit"]:
			if not value.mode.is_empty():
				value.ok = false
			value.mode = {
				"--observe": "OBSERVE",
				"--self-test": "SELF_TEST",
				"--verify-failure-exit": "INTENTIONAL_FAILURE"
			}[arg]
		elif arg.begins_with("--run-id="):
			value.run_id = arg.trim_prefix("--run-id=")
		elif arg.begins_with("--evidence-dir="):
			value.directory = arg.trim_prefix("--evidence-dir=")
		else:
			value.ok = false
	value.ok = (
		value.ok
		and not value.mode.is_empty()
		and not value.run_id.is_empty()
		and value.run_id.is_valid_filename()
		and value.directory.is_absolute_path()
	)
	return value


func _open_output() -> bool:
	if DirAccess.make_dir_recursive_absolute(_directory) != OK:
		return false
	for file: String in DirAccess.get_files_at(_directory):
		if not file.is_empty():
			return false
	_sink = FileAccess.open(_directory.path_join("events.jsonl"), FileAccess.WRITE)
	return _sink != null


func _environment() -> Dictionary:
	return {
		"run_id": _run_id,
		"mode": _mode,
		"evidence_type": "DEV_SELF_GUI" if _mode == "OBSERVE" else "AUTO_OBSERVER",
		"main_scene": "res://scenes/main.tscn",
		"observer_sha256": FileAccess.get_sha256("res://tests/game/run_vs01_tests.gd"),
		"engine": Engine.get_version_info(),
		"os": OS.get_name(),
		"os_version": OS.get_version(),
		"display_server": DisplayServer.get_name(),
		"window_size": [root.size.x, root.size.y],
		"render_method": ProjectSettings.get_setting("rendering/renderer/rendering_method"),
		"render_driver": ProjectSettings.get_setting("rendering/rendering_device/driver.windows"),
		"intervention": "normal main host; read/capture/input logging; no gameplay automation"
	}


func _record(kind: String, payload: Dictionary) -> int:
	if _closing:
		return -1
	_sequence += 1
	var record := {
		"sequence": _sequence,
		"run_id": _run_id,
		"kind": kind,
		"mode": _mode,
		"utc_unix_usec": int(Time.get_unix_time_from_system() * 1000000),
		"monotonic_usec": Time.get_ticks_usec(),
		"payload": payload
	}
	_sink.store_line(JSON.stringify(record))
	_sink.flush()
	if _sink.get_error() != OK:
		_abort("EVIDENCE_WRITE_FAILED")
	return _sequence


func _on_frame() -> void:
	if _closing or _sample_pending or Time.get_ticks_usec() - _last_sample < SAMPLE_USEC:
		return
	_sample_pending = true
	call_deferred("_sample", "PERIODIC")


func _sample(reason: String, input_sequence: int = 0) -> void:
	if _closing:
		return
	_sample_pending = false
	_last_sample = Time.get_ticks_usec()
	var started := Time.get_ticks_usec()
	var state: Dictionary = _host.session.snapshot()
	var entries: Array = _host.session.pipeline.ledger.entries()
	var trace: Array = state.current.trace
	_record("LEDGER_DELTA", {"from": _ledger_seen, "entries": entries.slice(_ledger_seen)})
	_record("TRACE_DELTA", {"from": _trace_seen, "entries": trace.slice(_trace_seen)})
	_ledger_seen = entries.size()
	_trace_seen = trace.size()
	state.current.erase("trace")
	var reading := _reading()
	var data := {
		"reason": reason,
		"after_input_sequence": input_sequence,
		"state": state,
		"reading": reading,
		"ledger_count": _ledger_seen,
		"trace_count": _trace_seen,
		"read_elapsed_usec": Time.get_ticks_usec() - started
	}
	var sequence := _record("STATE", data)
	data["event_sequence"] = sequence
	_write_json("latest.json", data)
	if _mode == "OBSERVE":
		var key := _milestone_key(state, reading)
		if key != _milestone:
			_milestone = key
			_record("MILESTONE", {"key": key, "state_sequence": sequence})
			_capture("MILESTONE")


func _reading() -> Dictionary:
	var value: Dictionary = _host._reading_context()
	var focus: Variant = value.focus
	value.focus = str(focus.get_path()) if is_instance_valid(focus) else ""
	value["window_size"] = [root.size.x, root.size.y]
	value["viewport"] = str(root.get_visible_rect())
	value["displayed_minute"] = _host.shown.get("current", {}).get("simulation_minute")
	return value


func _milestone_key(state: Dictionary, reading: Dictionary) -> String:
	var values: Array = [reading.screen, state.finance_ui.report.day_id]
	for row: Dictionary in state.current.tenders.tenders:
		values.append([row.terms.tender_id, row.state])
	for row: Dictionary in state.current.construction.projects:
		values.append(
			[row.project_id, row.status, row.trial_status, row.safety_status, row.opened_at]
		)
	values.append(state.next_business_ui.first_valid_report)
	return JSON.stringify(values)


func _event_data(event: InputEvent) -> Dictionary:
	var value := {"text": event.as_text(), "class": event.get_class()}
	if event is InputEventKey:
		value.merge({"pressed": event.pressed, "echo": event.echo, "keycode": int(event.keycode)})
	if event is InputEventMouseButton:
		value.merge(
			{
				"pressed": event.pressed,
				"button": int(event.button_index),
				"position": [event.position.x, event.position.y]
			}
		)
	return value


func _input_log(event: InputEvent) -> void:
	if _closing or not (event is InputEventKey or event is InputEventMouseButton):
		return
	_input_sequence += 1
	var value := _event_data(event)
	value["input_sequence"] = _input_sequence
	value["minute_at_receipt"] = _host.session.pipeline.clock.minute
	value["reading"] = _reading()
	_record("WINDOW_INPUT", value)
	call_deferred("_sample", "AFTER_INPUT", _input_sequence)
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F12:
		_capture("F12")


func _capture(label: String) -> void:
	if _capture_pending or _closing or DisplayServer.get_name() == "headless":
		return
	_capture_pending = true
	await process_frame
	await RenderingServer.frame_post_draw
	if _closing:
		return
	_capture_index += 1
	var filename := "capture-%03d.png" % _capture_index
	var image := root.get_texture().get_image()
	var result := image.save_png(_directory.path_join(filename))
	_record(
		"CAPTURE",
		{
			"label": label,
			"file": filename,
			"error": result,
			"minute": _host.session.pipeline.clock.minute,
			"reading": _reading(),
			"image_size": [image.get_width(), image.get_height()]
		}
	)
	_capture_pending = false
	if result != OK:
		_abort("CAPTURE_WRITE_FAILED")


func _write_json(filename: String, value: Dictionary) -> void:
	if _closing:
		return
	var file := FileAccess.open(_directory.path_join(filename), FileAccess.WRITE)
	if file == null:
		_abort("JSON_OPEN_FAILED")
		return
	file.store_string(JSON.stringify(value, "\t") + "\n")
	file.flush()
	if file.get_error() != OK:
		_abort("JSON_WRITE_FAILED")


func _close_gui() -> void:
	if _closing:
		return
	_sample("CLOSE_REQUESTED")
	_record("RUN_END", {"requested_exit": 0, "input_events": _input_sequence})
	_closing = true
	_sink.close()
	quit(0)


func _abort(reason: String) -> void:
	_closing = true
	print("DEV024_OBSERVER_ERROR ", reason)
	if _sink != null:
		_sink.close()
	quit(1)


func _self_test() -> void:
	var before: Dictionary = _host.session.snapshot()
	var ledger: Array = _host.session.pipeline.ledger.entries()
	_expect("normal_main_initial_minute", before.clock.simulation_minute, 360)
	_expect("normal_main_cash", before.current.funds.cash, 1000000)
	_expect("normal_main_restricted", before.current.funds.restricted, 0)
	_expect("normal_main_reserved", before.current.funds.reserved, 0)
	_expect("normal_main_unpaid", before.current.funds.unpaid, 0)
	_expect("normal_main_operations", before.operations_ui.status, "READY")
	_expect("normal_main_no_fixture", before.fixture_label, "")
	_expect("normal_main_no_construction", before.current.construction.projects, [])
	_expect("normal_main_no_report", before.next_business_ui.first_valid_report, {})
	_expect("normal_main_no_service", before.current.operations.daily.service_minutes, 0)
	_expect("normal_main_no_completed", before.current.operations.daily.completed, 0)
	_expect("normal_main_no_business", before.current.tenders.tenders[0].business_contract, {})
	for index: int in 3:
		_sample("SELF_TEST_READ")
	_expect("observation_state_unchanged", _host.session.snapshot(), before)
	_expect("observation_ledger_unchanged", _host.session.pipeline.ledger.entries(), ledger)
	_expect("no_injected_real_input", _input_sequence, 0)
	var key := InputEventKey.new()
	key.keycode = KEY_F12
	key.pressed = true
	_expect("key_serialization", _event_data(key).keycode, KEY_F12)
	var mouse := InputEventMouseButton.new()
	mouse.button_index = MOUSE_BUTTON_LEFT
	mouse.position = Vector2(12, 34)
	_expect("pointer_serialization", _event_data(mouse).position, [12.0, 34.0])
	var latest: Dictionary = JSON.parse_string(
		FileAccess.get_file_as_string(_directory.path_join("latest.json"))
	)
	_expect("record_roundtrip_minute", int(latest.state.clock.simulation_minute), 360)
	_expect("record_roundtrip_sequence", int(latest.event_sequence), _sequence)
	var rows := FileAccess.get_file_as_string(_directory.path_join("events.jsonl")).split(
		"\n", false
	)
	for index: int in rows.size():
		var row: Dictionary = JSON.parse_string(rows[index])
		_expect("ordered_record_%d" % index, int(row.sequence), index + 1)
		_expect("run_record_%d" % index, row.run_id, _run_id)
	var original_hash := FileAccess.get_sha256(_directory.path_join("events.jsonl"))
	_expect("existing_evidence_refused", _open_output(), false)
	_expect(
		"existing_evidence_preserved",
		FileAccess.get_sha256(_directory.path_join("events.jsonl")),
		original_hash
	)
	# 기존 파일을 지우지 않고 파일 아래 잘못된 경로의 쓰기 실패를 확인한다.
	var invalid := FileAccess.open(
		_directory.path_join("events.jsonl/invalid.json"), FileAccess.WRITE
	)
	_expect("output_failure_detectable", invalid == null, true)
	if _mode == "INTENTIONAL_FAILURE":
		_expect("intentional_failure", false, true)
	_write_json("self-test.json", {"checks": _checks, "failures": _failures})
	_record("RUN_END", {"requested_exit": 0 if _failures == 0 else 1})
	_sink.close()
	print("DEV024_TEST_RESULT checks=", _checks.size(), " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _expect(label: String, actual: Variant, expected: Variant) -> void:
	var passed: bool = actual == expected
	_checks.append(
		{"label": label, "passed": passed, "actual": str(actual), "expected": str(expected)}
	)
	if not passed:
		_failures += 1
		print("FAIL ", label, " actual=", actual, " expected=", expected)
