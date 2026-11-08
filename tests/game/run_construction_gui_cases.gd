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


func _initialize() -> void:
	call_deferred("_build")


func _build() -> void:
	root.title = "MetroManager · DEV021 TEST_ONLY"
	root.size = Vector2i(1100, 900)
	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(scroll)
	_content = VBoxContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_content)
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
	_last_usec = Time.get_ticks_usec()


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
