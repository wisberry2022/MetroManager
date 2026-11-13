extends SceneTree
## TEST_ONLY 보조 GUI. 빠른 시간 이동/자금 fixture를 제품 경로 증거와 구분한다.

const FX = preload("res://tests/game/construction_ui_fixtures.gd")
const ConstructionPanel = preload("res://scenes/construction_panel.tscn")
const View = preload("res://scripts/ui/construction_view.gd")

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


func _initialize() -> void:
	call_deferred("_build")


func _build() -> void:
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
	root.gui_focus_changed.connect(_focus_changed)
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
				"fixture": _case_id,
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
		var region := _panel.focus_region()
		if region != null:
			_ensure_focus_region(region)


func _ensure_focus_region(region: Control) -> void:
	await process_frame
	if not is_instance_valid(region) or not region.is_visible_in_tree():
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
