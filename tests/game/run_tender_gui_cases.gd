extends SceneTree
## 검증 전용 GUI. 정상 제품 main 경로와 분리한다.

const FX = preload("res://tests/game/w019_ui_fixtures.gd")
const TenderPanel = preload("res://scenes/tender_panel.tscn")
const TenderView = preload("res://scripts/ui/tender_view.gd")

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


func _initialize() -> void:
	call_deferred("_build")


func _build() -> void:
	root.title = "MetroManager · DEV019 검증 전용"
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
	_button(tools, "+1분 (검증)", func() -> void: _advance(_session.pipeline.clock.minute + 1))
	_button(tools, "마감까지 (검증)", func() -> void: _advance(1800))
	_button(tools, "이전 snapshot (검증)", _stale)
	for speed: int in [1, 2, 4]:
		_button(tools, str(speed) + "×", _speed.bind(speed))
	_clock = Label.new()
	_content.add_child(_clock)
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--case=") and arg.trim_prefix("--case=") in FX.CASES:
			_case_id = arg.trim_prefix("--case=")
	_menu.select(FX.CASES.find(_case_id))
	_load_case(_case_id)
	_last_usec = Time.get_ticks_usec()


func _button(parent: Node, text: String, action: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.pressed.connect(action)
	parent.add_child(button)


func _load_case(id: String) -> void:
	_case_id = id
	_session = FX.create(id)
	_old_packet = _session.snapshot().tender_ui
	if _panel != null:
		_content.remove_child(_panel)
		_panel.queue_free()
	_panel = TenderPanel.instantiate()
	_content.add_child(_panel)
	_panel.bid_requested.connect(_bid)
	_panel.refresh_requested.connect(_refresh)
	_panel.exit_requested.connect(func() -> void: quit(0))
	_present()
	print("DEV019_GUI_CASE ", id)


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
		"검증 완료분 %d · %s · %d×"
		% [
			_session.pipeline.clock.minute,
			"일시정지" if _session.pipeline.clock.paused else "진행 중",
			_session.pipeline.clock.speed
		]
	)


func _bid(id: String, tender: String, confirmed: Dictionary) -> void:
	_session.request_bid(id, tender, confirmed)
	_present()


func _refresh() -> void:
	_session.refresh_tenders()
	if _case_id in ["EMPTY", "ERROR", "UNAVAILABLE", "PAYMENT_MISSING"]:
		_case_id = "NORMAL"
	_present()


func _advance(minute: int) -> void:
	FX.advance_to(_session, minute)
	_present()


func _stale() -> void:
	_sequence += 1
	print("DEV019_STALE_APPLIED ", _panel.present(_old_packet), " request ", _sequence)


func _toggle_pause() -> void:
	_session.pipeline.clock.paused = not _session.pipeline.clock.paused
	_present()


func _speed(value: int) -> void:
	_session.pipeline.clock.set_speed(value)
	_present()
