extends SceneTree
## TEST_ONLY 보조 GUI. 빠른 시간 이동/자금 fixture를 제품 경로 증거와 구분한다.

const FX = preload("res://tests/game/construction_ui_fixtures.gd")
const ConstructionPanel = preload("res://scenes/construction_panel.tscn")
const Host = preload("res://scripts/ui/stage1_view.gd")
const View = preload("res://scripts/ui/construction_view.gd")

const Q12_CASES = [
	"LTXT-G07",
	"LTXT-G01",
	"LTXT-G02",
	"LTXT-G03",
	"FAILED-lf",
	"LTXT-G04",
	"LTXT-G05",
	"LTXT-G06",
	"Q12-CMD-01",
	"Q12-REV-01",
	"Q12-ORD-01",
	"Q12-HIS-01",
	"Q12-FIN-01",
	"Q12-FIN-02",
	"Q12-FIN-03",
	"Q12-FIN-04"
]

var _session: FX.BidFX.Session
var _panel: View
var _content: VBoxContainer
var _clock: Label
var _case_id: String = "CONTRACT"
var _last_usec: int = 0
var _refresh_usec: int = 0
var _old_packet: Dictionary = {}
var _scroll: ScrollContainer
var _focus_sequence: int = 0
var _q12_case: String = ""
var _q12_product: bool = false
var _q12_host: Control
var _q12_display: Dictionary = {}
var _q12_seen: Dictionary = {}
var _q12_order_index: int = 0


func _initialize() -> void:
	call_deferred("_build")


func _build() -> void:
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--q12-case="):
			_q12_case = arg.trim_prefix("--q12-case=")
		if arg == "--q12-host=product":
			_q12_product = true
	if not _q12_case.is_empty():
		_build_q12()
		return
	root.title = "MetroManager · DEV021 TEST_ONLY"
	root.size = Vector2i(1100, 900)
	if "--small" in OS.get_cmdline_user_args():
		root.size = Vector2i(1104, 900)
	_scroll = ScrollContainer.new()
	_scroll.follow_focus = true
	_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(_scroll)
	_scroll.resized.connect(_focus_resized)
	_content = VBoxContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll.add_child(_content)
	var title := Label.new()
	title.text = "DEV021 TEST_ONLY · 검증 전용 시간/자금 입력 · 제품 정상 경로 아님"
	_content.add_child(title)
	var tools := HFlowContainer.new()
	_content.add_child(tools)
	var menu := OptionButton.new()
	for id: String in FX.CASES:
		menu.add_item(id)
	menu.item_selected.connect(func(index: int) -> void: _load_case(FX.CASES[index]))
	tools.add_child(menu)
	_button(tools, "정지/재개", _pause)
	for speed: int in [1, 2, 4]:
		_button(tools, "%d×" % speed, _speed.bind(speed))
	for minutes: int in [1, 30, 60]:
		_button(tools, "+%d분 TEST" % minutes, _advance.bind(minutes))
	_button(tools, "이전 조회 실패 TEST", _stale)
	_button(tools, "완료까지 TEST", _finish)
	_button(tools, "종료", func() -> void: quit(0))
	_clock = Label.new()
	_content.add_child(_clock)
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--case=") and arg.trim_prefix("--case=") in FX.CASES:
			_case_id = arg.trim_prefix("--case=")
	menu.select(FX.CASES.find(_case_id))
	_load_case(_case_id)
	if not root.gui_focus_changed.is_connected(_focus_changed):
		root.gui_focus_changed.connect(_focus_changed)
	if not root.window_input.is_connected(_record_input):
		root.window_input.connect(_record_input)
	_last_usec = Time.get_ticks_usec()
	if "--obs01-self-test" in OS.get_cmdline_user_args():
		_run_focus_probe.call_deferred()


func _button(parent: Node, text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.pressed.connect(callback)
	parent.add_child(button)


func _load_case(id: String) -> void:
	_case_id = id
	_session = FX.create(id)
	if "--run" in OS.get_cmdline_user_args():
		_session.pipeline.clock.paused = false
		_session.pipeline.clock.set_speed(4)
	_old_packet = _session.snapshot().construction_ui
	if _panel != null:
		_content.remove_child(_panel)
		_panel.queue_free()
	_panel = ConstructionPanel.instantiate()
	_content.add_child(_panel)
	_panel.select_project("P-A")
	_panel.command_requested.connect(_command)
	_panel.refresh_requested.connect(_refresh)
	_panel.exit_requested.connect(func() -> void: quit(0))
	_panel.focus_region_requested.connect(_ensure_focus_region)
	_present()
	_log("LOAD_CASE")


func _process(_delta: float) -> bool:
	if _session == null:
		return false
	var now := Time.get_ticks_usec()
	_session.advance_usec(maxi(0, now - _last_usec))
	_refresh_usec += now - _last_usec
	_last_usec = now
	if _refresh_usec >= 200000:
		_refresh_usec = 0
		_present()
	return false


func _present() -> void:
	if not _q12_case.is_empty():
		_present_q12()
		return
	_panel.present(FX.packet(_session, _case_id))
	_clock.text = (
		"TEST 완료분 %d / %s / %d×"
		% [
			_session.pipeline.clock.minute,
			"일시정지" if _session.pipeline.clock.paused else "진행 중",
			_session.pipeline.clock.speed
		]
	)


func _command(id: String, action: String, confirmed: Dictionary) -> void:
	_session.request_construction(id, action, confirmed)
	_present()
	_log("COMMAND")


func _refresh() -> void:
	if not _q12_case.is_empty():
		_scroll.follow_focus = true
		_session.refresh_construction()
		_present_q12()
		var region: Control = _panel.focus_region()
		if region != null:
			_ensure_focus_region(region)
		_log("Q12_REFRESH")
		return
	_case_id = "CONTRACT" if _case_id in ["ERROR", "UNAVAILABLE", "EMPTY"] else _case_id
	_session.refresh_construction()
	_present()
	_log("REFRESH")


func _pause() -> void:
	_session.pipeline.clock.paused = not _session.pipeline.clock.paused
	_present()
	_log("PAUSE")


func _speed(value: int) -> void:
	_session.pipeline.clock.set_speed(value)
	_present()
	_log("SPEED")


func _advance(minutes: int) -> void:
	FX.BidFX.advance_to(_session, _session.pipeline.clock.minute + minutes)
	_present()
	_log("ADVANCE_TEST_ONLY")


func _finish() -> void:
	var row := FX.row(_session)
	if not row.is_empty():
		var target: int = _session.pipeline.clock.minute
		if not row.procedure.is_empty():
			target = row.procedure_completes_at
		elif row.status == "BUILDING":
			target += int(row.duration_minutes) - int(row.elapsed_minutes)
		FX.BidFX.advance_to(_session, target)
	_present()
	_log("FINISH_TEST_ONLY")


func _stale() -> void:
	var stale := _old_packet.duplicate(true)
	stale.view_revision = -1
	stale.status = "FAILED"
	stale.reason = "LATE_TEST_FAILURE"
	print("DEV021_GUI_STALE accepted=", _panel.present(stale))
	_log("STALE_FAILURE_TEST_ONLY")


func _log(action: String) -> void:
	print(
		"DEV021_GUI ",
		JSON.stringify(
			{
				"case_id": _case_id,
				"kind": "TEST_ONLY",
				"action": action,
				"clock": _session.pipeline.clock.snapshot(),
				"actual": _session.snapshot().construction_ui
			}
		)
	)


func _record_input(event: InputEvent) -> void:
	if not _q12_case.is_empty() and not _q12_product and event is InputEventMouseButton:
		Host.read_construction_key(_scroll, _panel, event)
	if not _q12_case.is_empty() and event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F12:
			_q12_case = Q12_CASES[(Q12_CASES.find(_q12_case) + 1) % Q12_CASES.size()]
			if _q12_case.begins_with("Q12-"):
				_session = null
			_q12_order_index = 0
			_rebuild_q12()
		if event.keycode == KEY_F5:
			_panel.controls.open.grab_focus()
		if event.keycode == KEY_F8:
			_q12_request()
		if event.keycode == KEY_F9:
			_advance(1)
		if event.keycode == KEY_F10 and _q12_case.begins_with("Q12-REV"):
			_session.pipeline.get("_construction")._projects["P-A"].invalidate_conditions()
			_present_q12()
			_log("Q12_CONDITION_CHANGE_TEST_ONLY")
		if event.keycode == KEY_F11:
			_finish()
		if event.keycode == KEY_F6:
			_refresh()
		if event.keycode == KEY_F7:
			_q12_case = "NORMAL"
			_rebuild_q12()
		if not _q12_product and Host.read_construction_key(_scroll, _panel, event):
			root.set_input_as_handled()
	if event is InputEventKey and event.pressed and not event.echo:
		_log_focus.call_deferred("KEY " + event.as_text())


func _focus_changed(_control: Control) -> void:
	_log_focus.call_deferred("FOCUS_CHANGED")


func _log_focus(action: String) -> void:
	_focus_sequence += 1
	var focus := root.gui_get_focus_owner()
	var row: Control = focus
	if focus != null and focus.get_parent() is VBoxContainer and focus.get_parent() != _panel:
		row = focus.get_parent()
	var envelope: Dictionary = _session.snapshot().construction_ui.snapshot
	print(
		"DEV021_OBS01_GUI ",
		JSON.stringify(
			{
				"sequence": _focus_sequence,
				"event": action,
				"fixture": _case_id if _q12_case.is_empty() else _q12_case,
				"minute": envelope.simulation_minute,
				"snapshot_revision": envelope.snapshot_revision,
				"focus_path": str(focus.get_path()) if focus != null else "",
				"focus_rect": _rect(focus.get_global_rect()) if focus != null else {},
				"row_rect": _rect(row.get_global_rect()) if row != null else {},
				"disabled": focus.disabled if focus is BaseButton else null,
				"scroll_rect": _rect(_scroll.get_global_rect()),
				"scroll": [_scroll.scroll_horizontal, _scroll.scroll_vertical],
				"window_raw_size": [root.size.x, root.size.y],
				"viewport_rect": _rect(root.get_visible_rect()),
				"canvas_transform": str(root.canvas_transform),
				"reported_screen_scale": DisplayServer.screen_get_scale(),
				"reported_screen_dpi": DisplayServer.screen_get_dpi(),
				"effective_window_dpi": "NOT_VERIFIED",
				"funds": envelope.funds,
				"project": FX.row(_session),
				"requests": _session.snapshot().construction_ui.requests
			}
		)
	)


func _rect(value: Rect2) -> Dictionary:
	return {
		"x": value.position.x, "y": value.position.y, "width": value.size.x, "height": value.size.y
	}


func _focus_resized() -> void:
	if _panel != null:
		_scroll.follow_focus = true
		var region := _panel.focus_region()
		if region != null:
			_ensure_focus_region(region)


func _ensure_focus_region(region: Control) -> void:
	await process_frame
	if not is_instance_valid(region) or not region.is_visible_in_tree():
		return
	if not _scroll.follow_focus:
		return
	var owner := root.gui_get_focus_owner()
	if owner != null and (owner == region or region.is_ancestor_of(owner)):
		_scroll.ensure_control_visible(region)


func _run_focus_probe() -> void:
	var failures := 0
	var checks := 0
	var before: Dictionary = _session.snapshot().construction_ui.snapshot
	for window_size: Vector2i in [Vector2i(1104, 900), Vector2i(1280, 720), Vector2i(1280, 960)]:
		root.size = window_size
		for action: String in ["back", "refresh", "contract", "safety", "repair", "open"]:
			_panel.controls[action].grab_focus()
			for frame: int in 4:
				await process_frame
			var region := _panel.focus_region()
			checks += 1
			if region == null or not _probe_visible(region):
				failures += 1
				printerr("FAIL OBS01_GUI_ROW ", action, " ", window_size)
		for reverse: bool in [false, true]:
			for index: int in 16:
				var key := InputEventKey.new()
				key.keycode = KEY_TAB
				key.shift_pressed = reverse
				key.pressed = true
				root.push_input(key)
				key = key.duplicate() as InputEventKey
				key.pressed = false
				root.push_input(key)
				for frame: int in 4:
					await process_frame
				var focus := root.gui_get_focus_owner()
				checks += 1
				if focus == null or not _probe_visible(focus):
					failures += 1
					printerr("FAIL OBS01_GUI_KEYBOARD ", reverse, " ", window_size)
	checks += 1
	if _session.snapshot().construction_ui.snapshot != before:
		failures += 1
	print("DEV021_OBS01_GUI_TEST_RESULT checks=", checks, " failures=", failures)
	quit(0 if failures == 0 else 1)


func _probe_visible(control: Control) -> bool:
	var clip := _scroll.get_global_rect()
	if _scroll.get_v_scroll_bar().visible:
		clip.size.x -= _scroll.get_v_scroll_bar().size.x
	return clip.grow(1.0).encloses(control.get_global_rect())


func _build_q12() -> void:
	root.title = "MetroManager · Q12 TEST_ONLY"
	root.size = Vector2i(1104 if "--small" in OS.get_cmdline_user_args() else 1100, 900)
	if _session == null:
		_session = FX.q12_session(_q12_case)
		_q12_seen = FX.confirmed(_session)
	if _q12_product:
		_q12_host = preload("res://scenes/stage1.tscn").instantiate()
		_q12_host.session = _session
		root.add_child(_q12_host)
		_q12_host.set_process(false)
		_q12_host.controls.open_tenders.pressed.emit()
		_q12_host._open_construction("P-A")
		_panel = _q12_host.construction_view
		_scroll = _q12_host.get("_scroll")
		_panel.refresh_requested.disconnect(_q12_host._refresh_construction)
		_panel.refresh_requested.connect(_refresh)
	else:
		_scroll = ScrollContainer.new()
		_scroll.follow_focus = true
		_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		root.add_child(_scroll)
		_content = VBoxContainer.new()
		_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_scroll.add_child(_content)
		_panel = ConstructionPanel.instantiate()
		_content.add_child(_panel)
		if _q12_case.begins_with("Q12-"):
			_panel.command_requested.connect(_command)
		_panel.refresh_requested.connect(_refresh)
		_panel.exit_requested.connect(func() -> void: quit(0))
		_panel.focus_region_requested.connect(_ensure_focus_region)
	_scroll.resized.connect(_focus_resized)
	if not root.gui_focus_changed.is_connected(_focus_changed):
		root.gui_focus_changed.connect(_focus_changed)
	if not root.window_input.is_connected(_record_input):
		root.window_input.connect(_record_input)
	_present_q12()
	print(
		"Q12_INPUT ",
		JSON.stringify({"display": _q12_display, "model": _session.snapshot().construction_ui})
	)
	_last_usec = Time.get_ticks_usec()


func _present_q12() -> void:
	_q12_display = FX.q12_display(_session, _q12_case)
	_panel.select_project(_q12_display.selected_id)
	if _q12_product:
		var snapshot := _session.snapshot()
		snapshot.construction_ui = _q12_display.packet
		_q12_host.present(snapshot)
	else:
		_panel.present(_q12_display.packet)


func _rebuild_q12() -> void:
	var container: Node = _q12_host if _q12_product else _scroll
	root.remove_child(container)
	container.queue_free()
	_panel = null
	_q12_host = null
	_build_q12()


func _q12_request() -> void:
	if not _q12_case.begins_with("Q12-"):
		return
	if _q12_case.begins_with("Q12-ORD"):
		var record := {
			"command":
			{
				"command_id": "q12-old-success",
				"project_id": "P-A",
				"action": "open",
				"requested_at": 1
			},
			"result":
			{
				"command_id": "q12-old-success",
				"pending": _q12_order_index == 2,
				"accepted": true,
				"reason_codes": [],
				"effective_at": 2,
				"result_revision": 2
			}
		}
		var accepted: bool
		if _q12_order_index == 1:
			var old: Dictionary = _session.snapshot().construction_ui
			old.view_revision = -1
			accepted = _panel.present(old)
		else:
			accepted = _panel.accept_result(record)
			_panel.present(_q12_display.packet)
		print("Q12_ORDER ", JSON.stringify({"index": _q12_order_index, "accepted": accepted}))
		_q12_order_index += 1
	else:
		var action := "contract"
		var seen := _q12_seen
		if _q12_case.begins_with("Q12-REV"):
			action = "start"
		elif _q12_case.begins_with("Q12-FIN"):
			action = "repair"
			seen = FX.confirmed(_session)
		elif _q12_case.begins_with("Q12-HIS"):
			var project := FX.row(_session)
			action = (
				"repair"
				if project.defects > 0
				else ("trial" if project.trial_status != "PASSED" else "safety")
			)
			seen = FX.confirmed(_session)
		var id := (
			"q12-fixed-command"
			if not _q12_case.begins_with("Q12-HIS")
			else "q12-history-" + str(_session.pipeline.clock.minute)
		)
		_session.request_construction(id, action, seen)
	_present_q12()
	_log("Q12_CONTROL_TEST_ONLY")
