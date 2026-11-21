extends SceneTree
## TEST_ONLY: 실제 OS 입력용 소비 반례 호스트. 자동 단언/독립 심사와 구분한다.

const FX = preload("res://tests/game/w026_ui_fixtures.gd")

var _view: Control
var _shell: VBoxContainer
var _banner: Label
var _output: String
var _events: FileAccess
var _sequence: int = 0


func _initialize() -> void:
	call_deferred("_build")


func _build() -> void:
	_output = "res://.local/validation/DEV-026/gui-%d" % Time.get_unix_time_from_system()
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--output="):
			_output = arg.trim_prefix("--output=")
	_output = ProjectSettings.globalize_path(_output)
	if DirAccess.dir_exists_absolute(_output):
		push_error("Output exists: " + _output)
		quit(2)
		return
	DirAccess.make_dir_recursive_absolute(_output)
	_events = FileAccess.open(_output.path_join("events.jsonl"), FileAccess.WRITE)
	root.title = "MetroManager DEV-026 · 경계 검증"
	root.size = Vector2i(1440, 1000)
	_shell = VBoxContainer.new()
	_shell.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(_shell)
	_banner = Label.new()
	_banner.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_banner.text = "DEV-026 TEST_ONLY · 소비 사본 주입 / 실제 제품 정상 완주 아님 · F5 캡처"
	_shell.add_child(_banner)
	var actions := HFlowContainer.new()
	_shell.add_child(actions)
	for id: String in [
		"NORMAL",
		"EX-01",
		"EX-02",
		"EX-09",
		"EX-10",
		"EX-13",
		"EX-14",
		"EX-17",
		"EX-19",
		"EX-20",
		"NEW_SESSION",
		"FIXED_DAY"
	]:
		var button := Button.new()
		button.text = id
		button.name = "Fixture_" + id
		button.pressed.connect(_case.bind(id))
		actions.add_child(button)
	_view = FX.Host.instantiate()
	_view.session = FX.session()
	_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_shell.add_child(_view)
	_view.set_process(false)
	root.window_input.connect(_input_event)
	root.close_requested.connect(_finish)
	await _capture("READY")


func _case(id: String) -> void:
	if id == "NEW_SESSION":
		_view = _view.replace_session(_view, FX.session("QA-M01"))
		_view.set_process(false)
	elif id == "FIXED_DAY":
		var value := FX.session("QA-M01")
		value.pipeline.clock.paused = false
		FX.Ops.advance_to(value, 2880)
		value.pipeline.clock.paused = true
		value.select_finance_report(1)
		_view = _view.replace_session(_view, value)
		_view.set_process(false)
		_view._open_reading("finance")
	else:
		_view.present(FX.sample(_view.session, id))
	_banner.text = "DEV-026 TEST_ONLY · " + id + " · NORMAL은 같은 Session 정상 공급 복귀"
	await _capture(id)


func _input_event(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		_record("OS_KEY", {"key": event.as_text()})
		if event.keycode == KEY_F2:
			call_deferred("_case", "EX-02")
		if event.keycode == KEY_F3:
			call_deferred("_case", "NORMAL")
		if event.keycode == KEY_F5:
			call_deferred("_capture", "MANUAL")
	if event is InputEventMouseButton and event.pressed:
		_record("OS_MOUSE", {"position": str(event.position), "button": event.button_index})
		call_deferred("_capture", "AFTER_INPUT")


func _capture(label: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	_sequence += 1
	var file := "%03d-%s.png" % [_sequence, label]
	var result := root.get_texture().get_image().save_png(_output.path_join(file))
	_record("CAPTURE", {"label": label, "file": file, "save_error": result})


func _record(kind: String, detail: Dictionary) -> void:
	_events.store_line(
		JSON.stringify(
			{
				"kind": kind,
				"detail": detail,
				"ticks_usec": Time.get_ticks_usec(),
				"state": FX.tree_state(_view)
			}
		)
	)
	_events.flush()


func _finish() -> void:
	_record("CLOSE", {})
	quit(0)
