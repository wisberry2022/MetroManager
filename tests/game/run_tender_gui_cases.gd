extends SceneTree
## 검증 전용 GUI. 정상 제품 main 경로와 분리한다.

const FX = preload("res://tests/game/w019_ui_fixtures.gd")
const TenderPanel = preload("res://scenes/tender_panel.tscn")
const TenderView = preload("res://scripts/ui/tender_view.gd")


class InputObserver:
	extends Node
	var receive: Callable

	func _input(event: InputEvent) -> void:
		receive.call(event)


var _session: FX.Session
var _panel: TenderView
var _content: VBoxContainer
var _menu: OptionButton
var _clock: Label
var _case_id: String = "NORMAL"
var _old_packet: Dictionary = {}
var _last_usec: int = 0
var _refresh_usec: int = 0
var _sequence: int = 0
var _start_minute: int = -1
var _stop_minute: int = -1
var _start_speed: int = 1
var _run_id: String = "manual"
var _evidence_dir: String = ""
var _records: Array[Dictionary] = []
var _frames: Array[Dictionary] = []
var _inputs: Array[Dictionary] = []
var _last_results: String = ""
var _capture_index: int = 0
var _stopped: bool = false
var _finishing: bool = false
var _write_failed: bool = false
var _diagnostic: Label
var _strict_elapsed: bool = false


func _initialize() -> void:
	call_deferred("_build")


func _build() -> void:
	_parse_args()
	root.title = "MetroManager · DEV019 검증 전용 · " + _run_id
	auto_accept_quit = false
	root.close_requested.connect(_finish)
	var observer := InputObserver.new()
	observer.receive = _record_input
	root.add_child(observer)
	if not _evidence_dir.is_empty():
		DirAccess.make_dir_recursive_absolute(_evidence_dir)
		if FileAccess.file_exists(_evidence_dir.path_join("run.json")):
			printerr("Evidence already exists; choose a new run directory")
			quit(2)
			return
	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(scroll)
	_content = VBoxContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_content)
	var title := Label.new()
	title.text = "DEV019 검증 전용 · 제품 정상 경로 아님 · P05 읽기 전용"
	_content.add_child(title)
	var tools := HBoxContainer.new()
	_content.add_child(tools)
	_menu = OptionButton.new()
	for id: String in FX.CASES:
		_menu.add_item(id)
	_menu.item_selected.connect(func(index: int) -> void: _load_case(FX.CASES[index]))
	tools.add_child(_menu)
	_button(tools, "정지/재개", _toggle_pause)
	if not _strict_elapsed:
		_button(tools, "+1분 (검증)", func() -> void: _advance(_session.pipeline.clock.minute + 1))
		_button(tools, "마감까지 (검증)", func() -> void: _advance(1800))
	_button(tools, "이전 snapshot (검증)", _stale)
	for speed: int in [1, 2, 4]:
		_button(tools, str(speed) + "×", _speed.bind(speed))
	_clock = Label.new()
	_content.add_child(_clock)
	var qa_tools := HBoxContainer.new()
	_content.add_child(qa_tools)
	if not _strict_elapsed:
		_button(qa_tools, "F6 직접 B01 (검증 전용)", _direct.bind("B01"))
		_button(qa_tools, "F7 직접 B-X (검증 전용)", _direct.bind("B-X"))
	_button(qa_tools, "F8 관측·원장·화면 저장", _checkpoint.bind("manual"))
	_button(qa_tools, "종료·증거 저장", _finish)
	_diagnostic = Label.new()
	_diagnostic.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_content.add_child(_diagnostic)
	_menu.select(FX.CASES.find(_case_id))
	_menu.disabled = not _evidence_dir.is_empty()
	_load_case(_case_id)
	_last_usec = Time.get_ticks_usec()
	_checkpoint("initial")
	_save_run(-1)


func _parse_args() -> void:
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--case=") and arg.trim_prefix("--case=") in FX.CASES:
			_case_id = arg.trim_prefix("--case=")
		elif arg.begins_with("--start-minute="):
			_start_minute = arg.trim_prefix("--start-minute=").to_int()
		elif arg.begins_with("--stop-minute="):
			_stop_minute = arg.trim_prefix("--stop-minute=").to_int()
		elif arg.begins_with("--speed="):
			_start_speed = arg.trim_prefix("--speed=").to_int()
		elif arg.begins_with("--run-id="):
			_run_id = arg.trim_prefix("--run-id=")
		elif arg.begins_with("--evidence-dir="):
			_evidence_dir = arg.trim_prefix("--evidence-dir=")
	_strict_elapsed = _run_id.begins_with("Q05-")


func _button(parent: Node, text: String, action: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.pressed.connect(action)
	parent.add_child(button)


func _load_case(id: String) -> void:
	_case_id = id
	_session = FX.create(id, _start_minute)
	_session.pipeline.clock.set_speed(_start_speed)
	_stopped = false
	_last_results = ""
	_old_packet = _session.snapshot().tender_ui
	if _panel != null:
		_content.remove_child(_panel)
		_panel.queue_free()
	_panel = TenderPanel.instantiate()
	_content.add_child(_panel)
	_panel.bid_requested.connect(_bid)
	_panel.refresh_requested.connect(_refresh)
	_panel.exit_requested.connect(_finish)
	_present()
	print("DEV019_GUI_CASE ", id)


func _process(_delta: float) -> bool:
	if _session == null or _finishing:
		return false
	var now := Time.get_ticks_usec()
	var frame := FX.advance_observed(_session, maxi(0, now - _last_usec), _stop_minute)
	frame["wall_usec"] = now
	frame["speed"] = _session.pipeline.clock.speed
	frame["paused"] = _session.pipeline.clock.paused
	if not _evidence_dir.is_empty():
		_frames.append(frame)
	_refresh_usec += now - _last_usec
	_last_usec = now
	if _refresh_usec >= 200000:
		_refresh_usec = 0
		_present()
	var requests: Array = _session.snapshot().tender_ui.requests
	var signature := JSON.stringify(requests)
	if signature != _last_results:
		_last_results = signature
		if not requests.is_empty() and not requests[-1].result.get("pending", false):
			_present()
			_checkpoint("effective_result")
	if frame.reached_stop and not _stopped:
		_stopped = true
		_present()
		_checkpoint("stop_T_COMPLETE")
		_save_run(-1)
	return false


func _present() -> void:
	_panel.present(FX.packet(_session, _case_id))
	_clock.text = (
		"검증 완료분 %d · %s · %d×"
		% [
			_session.pipeline.clock.minute,
			"일시정지" if _session.pipeline.clock.paused else "진행 중",
			_session.pipeline.clock.speed
		]
	)
	var funds := _session.pipeline.ledger.snapshot()
	var requests: Array = _session.snapshot().tender_ui.requests
	var result_text := "실제 요청 없음"
	if not requests.is_empty():
		var request: Dictionary = requests[-1]
		var result: Dictionary = request.result
		result_text = (
			"%s · 요청 %s → 효력 %s · %s"
			% [
				request.command.command_id,
				str(request.command.requested_at),
				str(result.get("effective_at", request.command.effective_at)),
				"PENDING" if result.get("pending", false) else str(result.get("reason", "ACCEPTED"))
			]
		)
	var note := "실제 Session 공급"
	if _case_id in ["DURATION", "OUTSIDE_REASON"]:
		note = "소비 fixture: 표시 사본만 변경 / 실제 모델 판정과 분리"
	_diagnostic.text = (
		"%s · %s · 정지 목표 T=%d · F9 정지/재개\nC=%d R=%d K=%d B=%d\n%s"
		% [
			_run_id,
			note,
			_stop_minute,
			funds.cash,
			funds.restricted,
			funds.reserved,
			funds.unpaid,
			result_text
		]
	)


func _bid(id: String, tender: String, confirmed: Dictionary) -> void:
	_session.request_bid(id, tender, confirmed)
	_present()
	_checkpoint("product_request_pending")


func _refresh() -> void:
	_session.refresh_tenders()
	if _case_id in ["EMPTY", "ERROR", "UNAVAILABLE", "PAYMENT_MISSING"]:
		_case_id = "NORMAL"
	_present()
	_checkpoint("refresh")


func _advance(minute: int) -> void:
	if _strict_elapsed:
		return
	FX.advance_to(_session, minute)
	_present()
	_checkpoint("test_time_jump_not_speed_evidence")


func _stale() -> void:
	_sequence += 1
	print("DEV019_STALE_APPLIED ", _panel.present(_old_packet), " request ", _sequence)


func _toggle_pause() -> void:
	if _stopped:
		_checkpoint("stop_remains_paused")
		return
	_session.pipeline.clock.paused = not _session.pipeline.clock.paused
	# 버튼 처리 전의 벽시간을 재개 이후 시간으로 전용하지 않는다.
	_last_usec = Time.get_ticks_usec()
	_present()
	_checkpoint("pause" if _session.pipeline.clock.paused else "resume")


func _speed(value: int) -> void:
	_session.pipeline.clock.set_speed(value)
	_last_usec = Time.get_ticks_usec()
	_present()
	_checkpoint("speed")


func _direct(target: String) -> void:
	_sequence += 1
	FX.direct_request(_session, "%s-direct-%d" % [_run_id, _sequence], target)
	_present()
	_checkpoint("test_direct_request_pending")


func _record_input(event: InputEvent) -> void:
	if _session == null or _finishing:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		_inputs.append({"wall_usec": Time.get_ticks_usec(), "key": event.as_text()})
		match event.keycode:
			KEY_F6:
				if not _strict_elapsed:
					_direct("B01")
			KEY_F7:
				if not _strict_elapsed:
					_direct("B-X")
			KEY_F8:
				_checkpoint("manual")
			KEY_F9:
				_toggle_pause()
	elif event is InputEventMouseButton and event.pressed:
		_inputs.append(
			{
				"wall_usec": Time.get_ticks_usec(),
				"button": event.button_index,
				"position": [event.position.x, event.position.y]
			}
		)


func _checkpoint(label: String) -> void:
	if _session == null:
		return
	var value := FX.observation(_session)
	value["event"] = label
	value["wall_usec"] = Time.get_ticks_usec()
	value["display_packet"] = FX.packet(_session, _case_id)
	value["view"] = {
		"page": _panel.page,
		"selected_id": _panel.selected_id,
		"submit_disabled": _panel.controls.submit.disabled,
		"eligibility": _panel.labels.eligibility.text,
		"request": _panel.labels.request.text,
		"decision": _panel.labels.decision.text,
		"focus": str(root.gui_get_focus_owner().name) if root.gui_get_focus_owner() else ""
	}
	_records.append(value)
	print("DEV019_Q345 ", label, " minute=", value.pipeline.simulation_minute)
	if not _evidence_dir.is_empty():
		_capture_index += 1
		var stem := "%03d-%s" % [_capture_index, label]
		_write_json(stem + ".json", value)
		_capture(stem)


func _capture(stem: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	await process_frame
	await RenderingServer.frame_post_draw
	# 사건 관측과 렌더링 시점은 다를 수 있으므로 실제 캡처 시점도 별도로 기록한다.
	var captured := FX.observation(_session)
	captured["wall_usec"] = Time.get_ticks_usec()
	captured["page"] = _panel.page
	captured["selected_id"] = _panel.selected_id
	_write_json(stem + ".capture.json", captured)
	var error := root.get_texture().get_image().save_png(_evidence_dir.path_join(stem + ".png"))
	if error != OK:
		_write_failed = true
		printerr("Capture failed: ", error)


func _write_json(name: String, value: Dictionary) -> void:
	var file := FileAccess.open(_evidence_dir.path_join(name), FileAccess.WRITE)
	if file == null:
		_write_failed = true
		printerr("Evidence write failed: ", name)
		return
	file.store_string(JSON.stringify(value, "  ") + "\n")


func _save_run(exit_code: int) -> void:
	if _evidence_dir.is_empty():
		return
	var sources: Dictionary = {}
	for path: String in [
		"tests/game/w019_ui_fixtures.gd",
		"tests/game/run_tender_gui_cases.gd",
		"scripts/ui/tender_view.gd",
		"scripts/ui/stage1_session.gd",
		"scripts/simulation/game_clock.gd",
		"scripts/simulation/minute_pipeline.gd",
		"scripts/simulation/tender_service.gd",
		"scripts/model/company_ledger.gd"
	]:
		sources[path] = FileAccess.get_sha256("res://" + path)
	_write_json(
		"run.json",
		{
			"run_id": _run_id,
			"case_id": _case_id,
			"engine": Engine.get_version_info().string,
			"source_sha256": sources,
			"start_minute": _start_minute,
			"stop_minute": _stop_minute,
			"initial_speed": _start_speed,
			"strict_wall_elapsed": _strict_elapsed,
			"exit_code": exit_code,
			"write_failed": _write_failed,
			"records": _records,
			"frames": _frames,
			"inputs": _inputs
		}
	)


func _finish() -> void:
	if _finishing:
		return
	_finishing = true
	_session.pipeline.clock.paused = true
	_present()
	_checkpoint("exit")
	await process_frame
	await process_frame
	_save_run(1 if _write_failed else 0)
	print("DEV019_Q345_EXIT ", _run_id, " code=", 1 if _write_failed else 0)
	quit(1 if _write_failed else 0)
