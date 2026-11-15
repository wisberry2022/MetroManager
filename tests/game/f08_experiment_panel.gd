extends VBoxContainer
## Isolated A/B technical alternatives; not a production design or rules implementation.

signal observed(kind: String, detail: Dictionary)

const Fixtures = preload("res://tests/game/f08_fixtures.gd")
const MapView = preload("res://scripts/ui/stage1_map.gd")

var session: RefCounted
var case_id := "pa"
var layout_id := "A"
var display_sample := false
var long_text := false
var overlap := false
var selected_id := "S12"
var model_commands := 0
var map_view: Control
var candidates: Dictionary = {}
var actions: Dictionary = {}
var sections: Dictionary = {}
var plan_list: ItemList
var sample_payload: Dictionary = {}
var _scroll: ScrollContainer
var _content: VBoxContainer
var _work: BoxContainer
var _plan_ids: Array = []
var _sequence := 0
var _rendered := ""
var _pixel_nodes: Array[TextureRect] = []


func _ready() -> void:
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll = ScrollContainer.new()
	_scroll.follow_focus = true
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(_scroll)
	_content = VBoxContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll.add_child(_content)
	_label(_content, "source")
	_label(_content, "clock")
	_label(_content, "validation")
	_label(_content, "funds")
	_work = BoxContainer.new()
	_content.add_child(_work)
	var left := VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_work.add_child(left)
	map_view = MapView.new()
	map_view.station_requested.connect(activate_station)
	map_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_child(map_view)
	_label(left, "selected")
	var right := VBoxContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.custom_minimum_size.x = 300
	_work.add_child(right)
	var grid := GridContainer.new()
	grid.columns = 4
	right.add_child(grid)
	for row: Dictionary in Fixtures.samples().stations:
		var id: String = row.id
		var button := _button(grid, "Candidate_" + id, id, activate_station.bind(id))
		candidates[id] = button
	plan_list = ItemList.new()
	plan_list.name = "PlanList"
	plan_list.custom_minimum_size.y = 140
	plan_list.item_selected.connect(func(index: int) -> void: choose_info(_plan_ids[index]))
	right.add_child(plan_list)
	var edits := HFlowContainer.new()
	right.add_child(edits)
	for action: String in ["up", "down", "remove", "undo", "predict", "refresh"]:
		actions[action] = _button(edits, "Action_" + action, action, command.bind(action))
	for key: String in ["activity", "prediction", "previous", "report", "history", "message"]:
		_label(_content, key)
	_label(_content, "stress")
	_build_pixels()
	resized.connect(_reflow)
	_reflow()


func _label(parent: Node, key: String) -> Label:
	var label := Label.new()
	label.name = "Section_" + key
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(label)
	sections[key] = label
	return label


func _button(parent: Node, id: String, text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.name = id
	button.text = text
	button.pressed.connect(callback)
	parent.add_child(button)
	return button


func _build_pixels() -> void:
	var row := HFlowContainer.new()
	_content.add_child(row)
	var texture := ImageTexture.create_from_image(Image.load_from_file(Fixtures.PIXEL_PATH))
	for nearest: bool in [true, false]:
		var box := VBoxContainer.new()
		# 256 + default separation 4 aligns both samples at all four tested scales.
		box.custom_minimum_size.x = 256
		row.add_child(box)
		var text := Label.new()
		text.text = "nearest / 별도 문자 0128 한글" if nearest else "linear / 별도 문자 0128 한글"
		box.add_child(text)
		var picture := TextureRect.new()
		picture.texture = texture
		picture.texture_filter = (
			CanvasItem.TEXTURE_FILTER_NEAREST if nearest else CanvasItem.TEXTURE_FILTER_LINEAR
		)
		picture.custom_minimum_size = Vector2(128, 64)
		picture.stretch_mode = TextureRect.STRETCH_KEEP
		picture.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		box.add_child(picture)
		_pixel_nodes.append(picture)


func configure(value: RefCounted, row: Dictionary) -> void:
	session = value
	case_id = row.get("state", "pa")
	layout_id = row.get("layout", "A")
	display_sample = row.get("source", "MODEL") == "SAMPLE"
	long_text = row.get("profile", "baseline") == "long"
	overlap = row.get("overlap", false)
	sample_payload = Fixtures.sample(case_id)
	set_font(row.get("font", "default"))
	_reflow()
	refresh()


func set_font(choice: String) -> void:
	var value := Theme.new()
	value.default_font_size = 18
	if choice == "system":
		var font := SystemFont.new()
		font.font_names = PackedStringArray(["Malgun Gothic"])
		value.default_font = font
	theme = value


func _reflow() -> void:
	if _work == null:
		return
	_work.vertical = layout_id == "B" or size.x < 880


func refresh() -> void:
	if session == null:
		return
	var state: Dictionary = session.snapshot()
	var displayed := state.duplicate(true)
	if display_sample:
		displayed.plan.station_ids = sample_payload.stops.duplicate()
		displayed.plan.allowed_actions.edit = sample_payload.edit
	if overlap:
		for station: Dictionary in displayed.stations:
			station.x_km = 1
			station.y_km = 1
	map_view.present(displayed, selected_id)
	if long_text:
		map_view.markers.S12.text = Fixtures.samples().strings[0].text
		map_view.markers.S12.clip_text = true
	_plan_ids = displayed.plan.station_ids.duplicate()
	var plan_key := Fixtures.digest(_plan_ids)
	if _rendered != plan_key:
		plan_list.clear()
		for index: int in _plan_ids.size():
			plan_list.add_item("%d · %s" % [index + 1, _plan_ids[index]])
		_rendered = plan_key
	for id: String in candidates:
		candidates[id].disabled = not displayed.plan.allowed_actions.edit and id not in _plan_ids
		candidates[id].button_pressed = selected_id == id
	var locked: bool = not state.plan.allowed_actions.edit or display_sample
	for action: String in ["up", "down", "remove", "undo", "predict"]:
		actions[action].disabled = locked
	actions.predict.disabled = locked or not state.allowed_actions.predict
	actions.undo.disabled = locked or not state.plan.allowed_actions.undo
	sections.source.text = (
		("DESIGN_DISPLAY_FIXTURE / 모델 값 아님" if display_sample else "MODEL_SETUP / 실제 Session API")
		+ " · "
		+ case_id
	)
	if display_sample:
		_present_sample()
	else:
		_present_model(state)
	sections.stress.text = "표시 부하 · 게임 값 아님\n" + Fixtures.corpus() if long_text else ""
	_update_selected()


func _present_sample() -> void:
	var keys := {
		"clock": "clock",
		"validation": "validation",
		"funds": "funds",
		"activity": "activity",
		"prediction": "pred",
		"previous": "previous",
		"report": "report",
		"history": "history",
		"message": "message"
	}
	for key: String in keys:
		sections[key].text = key + ": " + str(sample_payload.get(keys[key], ""))
	sections.validation.text += " · " + sample_payload.count
	sections.previous.text += " · " + sample_payload.version
	sections.message.text += "\n오류행: " + str(sample_payload.errors)
	sections.message.text += " / 단절: " + str(sample_payload.broken)


func _present_model(state: Dictionary) -> void:
	sections.clock.text = "실제 게임분 %s / 정지 %s" % [state.clock.simulation_minute, state.clock.paused]
	sections.validation.text = "계획: " + str(state.plan.validation)
	sections.funds.text = "현재 자금 C/R/F/K/A/B: " + JSON.stringify(state.current.funds)
	sections.activity.text = "발생/지급: " + JSON.stringify(state.daily_activity)
	sections.prediction.text = (
		"현재 예측: %s / %s\n%s"
		% [
			state.prediction.prediction_status,
			state.prediction.reason,
			_prediction_summary(state.prediction.current)
		]
	)
	sections.previous.text = (
		"표시 revision: %s / 계획 revision: %s" % [state.view_revision, state.plan.plan_revision]
	)
	sections.previous.text += "\n이전 예측: " + _prediction_summary(state.prediction.previous)
	sections.report.text = (
		"확정 보고: %s / 일 %s / 사유 %s / 키 %s"
		% [state.report.status, state.report.day_id, state.report.reason, state.report.display_key]
	)
	sections.history.text = "당시 명령 결과: " + JSON.stringify(state.command_result)
	sections.message.text = "포함역은 정보 선택 / 후보 추가·편집은 실제 Session 명령"


func _prediction_summary(row: Dictionary) -> String:
	if row.is_empty():
		return "자료 없음"
	var value: Dictionary = row.value
	return (
		"입력 %s / 생성 %s / 기간 [%s, %s) 끝 제외 / %s"
		% [
			row.input_revision,
			row.generated_minute,
			value.get("period_start", "UNKNOWN"),
			value.get("period_end", "UNKNOWN"),
			JSON.stringify(value.get("totals", {}))
		]
	)


func _update_selected() -> void:
	sections.selected.text = "정보 선택: " + selected_id
	if long_text and selected_id == "S12":
		sections.selected.text += "\n" + Fixtures.samples().strings[0].text
	var index := _plan_ids.find(selected_id)
	if index >= 0:
		plan_list.select(index)


func choose_info(id: String) -> void:
	var before := Fixtures.digest(Fixtures.authority(session))
	selected_id = id
	refresh()
	observed.emit(
		"information",
		{"id": id, "before": before, "after": Fixtures.digest(Fixtures.authority(session))}
	)


func activate_station(id: String) -> void:
	if display_sample or id in session.plan.snapshot().station_ids:
		choose_info(id)
		return
	selected_id = id
	_dispatch("select", {"station_id": id})


func command(action: String) -> void:
	if action == "refresh":
		choose_info(selected_id)
		return
	var args := {}
	var operation := action
	if action in ["up", "down"]:
		operation = "reorder"
		var index: int = session.plan.snapshot().station_ids.find(selected_id)
		args = {"from": index, "to": index + (-1 if action == "up" else 1)}
	if action == "remove":
		args = {"station_id": selected_id}
	_dispatch(operation, args)


func _dispatch(action: String, payload: Dictionary) -> void:
	if display_sample:
		observed.emit("blocked_display_fixture", {"action": action})
		return
	_sequence += 1
	var request := {
		"command_id": "dev025-live-%d" % _sequence,
		"action": action,
		"expected_plan_revision": session.plan.snapshot().plan_revision
	}
	request.merge(payload)
	var before := Fixtures.authority(session)
	var result: Dictionary = session.dispatch(request)
	model_commands += 1
	refresh()
	observed.emit(
		"command",
		{
			"request": request,
			"result": result,
			"before": before,
			"after": Fixtures.authority(session)
		}
	)


func observation() -> Dictionary:
	var texts := {}
	for id: String in sections:
		texts[id] = sections[id].text
	var focus := get_viewport().gui_get_focus_owner()
	var pixels: Array = []
	for node: TextureRect in _pixel_nodes:
		pixels.append(
			{
				"filter": node.texture_filter,
				"rect": str(node.get_global_rect()),
				"transform": str(node.get_global_transform_with_canvas())
			}
		)
	return {
		"case": case_id,
		"layout": layout_id,
		"vertical": _work.vertical,
		"source": "SAMPLE" if display_sample else "MODEL",
		"selected_id": selected_id,
		"focus": str(focus.name) if focus else "NONE",
		"texts": texts,
		"content_sha256": Fixtures.digest(texts),
		"plan_ids": _plan_ids,
		"authority_sha256": Fixtures.digest(Fixtures.authority(session)),
		"model_commands": model_commands,
		"scroll_y": _scroll.scroll_vertical,
		"viewport": str(get_viewport_rect()),
		"pixels": pixels,
		"map_rect": str(map_view.get_global_rect()),
		"overlap": overlap
	}


func scroll_bottom() -> void:
	_scroll.scroll_vertical = 100000


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		observed.emit("input_key", {"key": event.keycode, "text": event.as_text()})
	if event is InputEventMouseButton and event.pressed:
		observed.emit(
			"input_mouse", {"button": event.button_index, "position": str(event.position)}
		)
