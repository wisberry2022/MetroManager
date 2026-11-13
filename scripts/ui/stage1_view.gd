extends MarginContainer
## 기본 도형/컨트롤의 최소 S01. 화면은 공급값만 소비한다.

const Session = preload("res://scripts/ui/stage1_session.gd")
const TenderPanel = preload("res://scenes/tender_panel.tscn")
const ConstructionPanel = preload("res://scenes/construction_panel.tscn")
const MapView = preload("res://scripts/ui/stage1_map.gd")

var session: Session
var map_view: MapView
var controls: Dictionary = {}
var candidate_buttons: Dictionary = {}
var plan_list: ItemList
var shown: Dictionary = {}
var tender_view: VBoxContainer
var construction_view: VBoxContainer
var _labels: Dictionary = {}
var _sequence: int = 0
var _displayed_revision: int = -1
var _last_usec: int = 0
var _refresh_usec: int = 0
var _selected_id: String = ""
var _candidates: GridContainer
var _list_stops: Array = []
var _focus_feedback: String = ""
var _planning_sections: Array[Node] = []
var _scroll: ScrollContainer
var _focus_sequence: int = 0


func _ready() -> void:
	for side: String in ["left", "right", "top", "bottom"]:
		add_theme_constant_override("margin_" + side, 12)
	_scroll = ScrollContainer.new()
	add_child(_scroll)
	_scroll.resized.connect(_focus_resized)
	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll.add_child(root)
	_label(root, "title", "MetroManager · S01 노선 계획")
	var hud := HBoxContainer.new()
	root.add_child(hud)
	for action: String in ["pause", "resume"]:
		_button(hud, action, "정지" if action == "pause" else "재개", action)
	for speed: int in [1, 2, 4]:
		_button(hud, "speed%d" % speed, "%d×" % speed, "speed", {"value": speed})
	_label(hud, "clock", "게임 시간 확인 중")
	var navigation := Button.new()
	navigation.name = "OpenTenders"
	navigation.text = "공공입찰 목록 열기"
	navigation.pressed.connect(_open_tenders)
	root.add_child(navigation)
	controls["open_tenders"] = navigation
	tender_view = TenderPanel.instantiate()
	tender_view.visible = false
	tender_view.bid_requested.connect(_bid_requested)
	tender_view.refresh_requested.connect(_refresh_tenders)
	tender_view.exit_requested.connect(_close_tenders)
	tender_view.construction_requested.connect(_open_construction)
	root.add_child(tender_view)
	construction_view = ConstructionPanel.instantiate()
	construction_view.hide()
	construction_view.command_requested.connect(_construction_requested)
	construction_view.refresh_requested.connect(_refresh_construction)
	construction_view.exit_requested.connect(_close_construction)
	construction_view.focus_region_requested.connect(_ensure_focus_region)
	root.add_child(construction_view)
	var work := HBoxContainer.new()
	root.add_child(work)
	var left := VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	work.add_child(left)
	_label(left, "map_hint", "후보역 / 번호: 선택 순서 / 굵은 선: 계획 / 오류는 목록 사유 확인")
	map_view = MapView.new()
	map_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_view.station_requested.connect(_select_station)
	left.add_child(map_view)
	_label(left, "legend", "관할: P01 > C01 · DATA 소속 기준 / 도형은 추상 배치")
	var right := VBoxContainer.new()
	right.custom_minimum_size.x = 360
	work.add_child(right)
	_label(right, "candidates_title", "후보역 · 미포함 역: 추가 / 포함 역: 정보 선택")
	_candidates = GridContainer.new()
	_candidates.columns = 4
	right.add_child(_candidates)
	_build_candidates()
	_label(right, "selection", "선택한 역 없음")
	plan_list = ItemList.new()
	plan_list.name = "PlanList"
	plan_list.custom_minimum_size = Vector2(350, 125)
	plan_list.item_selected.connect(_plan_selected)
	right.add_child(plan_list)
	var edit := HBoxContainer.new()
	right.add_child(edit)
	_button(edit, "up", "위로", "reorder", {"direction": -1})
	_button(edit, "down", "아래로", "reorder", {"direction": 1})
	_button(edit, "remove", "제거", "remove")
	_button(edit, "undo", "되돌리기", "undo")
	_button(edit, "predict", "예측 계산", "predict")
	_label(right, "validation", "계획 확인 중")
	_label(right, "connections", "")
	_label(root, "prediction", "예측: 미계산")
	_label(root, "previous", "")
	_label(root, "funds", "현재 자금 확인 중")
	_label(root, "activity", "당일 운영비 확인 중")
	_label(root, "report", "확정 보고 없음")
	_label(root, "feedback", "후보역을 선택해 노선을 편집하세요.")
	_label(root, "scope", "노선 계획/예측 · 공공입찰 → 사업 인계 → 공사·검증·개통 · 실제 영업은 W06 후속")
	var after_panel := false
	for section: Node in root.get_children():
		if after_panel and section != construction_view:
			_planning_sections.append(section)
		if section == tender_view:
			after_panel = true
	session.enable_tender_ui()
	session.enable_construction_ui()
	_last_usec = Time.get_ticks_usec()
	present(session.snapshot())


func _process(_delta: float) -> void:
	if session == null:
		return
	var now := Time.get_ticks_usec()
	session.advance_usec(maxi(0, now - _last_usec))
	_refresh_usec += now - _last_usec
	_last_usec = now
	if _refresh_usec >= 200000:
		_refresh_usec = 0
		present(session.snapshot())


func _button(
	parent: Node, id: String, text: String, action: String, payload: Dictionary = {}
) -> void:
	var button := Button.new()
	button.name = id
	button.text = text
	button.pressed.connect(_act.bind(action, payload))
	parent.add_child(button)
	controls[id] = button


func _label(parent: Node, id: String, text: String) -> void:
	var label := Label.new()
	label.name = id
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(label)
	_labels[id] = label


func _select_station(id: String) -> void:
	_selected_id = id
	if id in session.snapshot().plan.station_ids:
		_focus_station(id)
		return
	_act("select", {"station_id": id})


func _plan_selected(index: int) -> void:
	_focus_station(shown.plan.station_ids[index])


func _focus_station(id: String) -> void:
	_selected_id = id
	var before: Dictionary = session.snapshot()
	_focus_feedback = "정보 선택: %s · 노선 변경 없음 · 계획판 %d" % [id, before.plan.plan_revision]
	present(session.snapshot())
	plan_list.ensure_current_is_visible()
	print(
		"W07_FOCUS ",
		JSON.stringify(
			{
				"station_id": id,
				"plan_revision_before": before.plan.plan_revision,
				"plan_revision_after": session.snapshot().plan.plan_revision,
				"command_dispatched": false
			}
		)
	)


func _act(action: String, payload: Dictionary = {}) -> void:
	_focus_feedback = ""
	_sequence += 1
	var command := payload.duplicate(true)
	command.merge({"command_id": "ui-%d-%d" % [get_instance_id(), _sequence], "action": action})
	var current := session.snapshot()
	if action in ["remove", "reorder"]:
		command.station_id = _selected_id
		command.expected_plan_revision = current.plan.plan_revision
	if action == "reorder":
		command.from = current.plan.station_ids.find(_selected_id)
		command.to = command.from + command.direction
	var result := session.dispatch(command)
	print("W07_COMMAND ", JSON.stringify(result))
	present(session.snapshot())


func present(state: Dictionary) -> bool:
	if state.view_revision < _displayed_revision:
		return false
	_displayed_revision = state.view_revision
	shown = state.duplicate(true)
	var clock: Dictionary = state.clock
	_labels.title.text = (
		"MetroManager · S01 노선 계획"
		+ (" · 검증 전용: " + state.fixture_label if not state.fixture_label.is_empty() else "")
	)
	_labels.clock.text = (
		"게임일 %d %02d:%02d · %s · %d×"
		% [
			clock.day_id,
			(clock.simulation_minute / 60) % 24,
			clock.simulation_minute % 60,
			"일시정지" if clock.paused else "진행 중",
			clock.speed
		]
	)
	controls.pause.disabled = not state.allowed_actions.pause
	controls.resume.disabled = not state.allowed_actions.resume
	for speed: int in [1, 2, 4]:
		controls["speed%d" % speed].text = ("[%d×]" if speed == clock.speed else "%d×") % speed
	tender_view.present(state.tender_ui)
	construction_view.present(state.construction_ui)
	_render_plan(state)
	_render_finance(state)
	_render_prediction(state.prediction)
	var result: Dictionary = state.command_result
	if not result.is_empty():
		_labels.feedback.text = (
			"마지막 요청: %s · %s · 당시 게임분 %d"
			% [
				"처리됨" if result.accepted else "거부됨",
				reason_text(result.get("reason", "")),
				result.effective_at
			]
		)
	if not _focus_feedback.is_empty():
		_labels.feedback.text = _focus_feedback
	return true


func _render_plan(state: Dictionary) -> void:
	var route: Dictionary = state.plan
	map_view.present(state, _selected_id)
	if _list_stops != route.station_ids:
		_list_stops = route.station_ids.duplicate()
		plan_list.clear()
		for index: int in route.station_ids.size():
			var id: String = route.station_ids[index]
			plan_list.add_item("%d. %s" % [index + 1, id])
	for index: int in route.station_ids.size():
		if route.station_ids[index] == _selected_id:
			plan_list.select(index)
	var selected: int = route.station_ids.find(_selected_id)
	controls.up.disabled = not route.allowed_actions.edit or selected <= 0
	controls.down.disabled = (
		not route.allowed_actions.edit or selected < 0 or selected >= route.station_ids.size() - 1
	)
	controls.remove.disabled = not route.allowed_actions.edit or selected < 0
	controls.undo.disabled = not route.allowed_actions.undo
	controls.predict.disabled = not state.allowed_actions.predict
	for id: String in candidate_buttons:
		candidate_buttons[id].disabled = (
			not route.allowed_actions.edit and id not in route.station_ids
		)
		candidate_buttons[id].button_pressed = id == _selected_id
		var number: int = route.station_ids.find(id)
		candidate_buttons[id].text = "%d.%s" % [number + 1, id] if number >= 0 else id
	var reasons: Array[String] = []
	for code: String in route.validation.reason_codes:
		reasons.append(reason_text(code))
	_labels.validation.text = (
		"%d역 · 계획판 %d · %s\n%s"
		% [
			route.station_ids.size(),
			route.plan_revision,
			"유효" if route.validation.valid else "계획 조건 미충족",
			" / ".join(reasons)
		]
	)
	_labels.selection.text = "선택: " + (_selected_id if not _selected_id.is_empty() else "없음")
	for station: Dictionary in state.stations:
		if station.id == _selected_id:
			var path: Array[String] = [station.id]
			var cursor: String = station.neighborhood_id
			while not cursor.is_empty():
				path.push_front(cursor)
				cursor = state.administration[cursor].parent_id
			_labels.selection.text += " / " + " > ".join(path)
	if route.locked:
		_labels.validation.text += " · 편집 잠금"
	_render_connections(state)


func _render_connections(state: Dictionary) -> void:
	# 기존 지도와 같은 DATA 간선으로 오류 위치만 설명한다. 유효성은 원본 Plan 판정이다.
	var stops: Array = state.plan.station_ids
	var gaps: Array[String] = []
	for index: int in range(1, stops.size()):
		var a: String = stops[index - 1]
		var b: String = stops[index]
		if [a, b] not in state.edges and [b, a] not in state.edges:
			gaps.append("%d. %s → %d. %s: 연결 간선 없음" % [index, a, index + 1, b])
	_labels.connections.text = ""
	if not gaps.is_empty():
		_labels.connections.text = "연결 오류 · " + " / ".join(gaps)
		_labels.connections.text += (
			"\n수정: 역을 선택해 위로/아래로 순서 조정 또는 제거 후 연결된 역 추가"
			if state.plan.allowed_actions.edit
			else "\n현재 편집 잠금 · 역 정보 선택 가능"
		)


func _render_finance(state: Dictionary) -> void:
	var funds: Dictionary = state.current.funds
	_labels.funds.text = (
		"현재 자금 · 게임분 %d · 게임 통화 단위\nC 총현금 %d / R 제한 %d / F 자유 %d / K 예약 %d / A 신규약정 가용 %d / B 미지급 %d"
		% [
			state.current.simulation_minute,
			funds.cash,
			funds.restricted,
			funds.free_cash,
			funds.reserved,
			funds.available_cash,
			funds.unpaid
		]
	)
	var report: Dictionary = state.report
	if report.available:
		var value: Dictionary = report.value
		_labels.report.text = (
			"확정 과거 보고 · 마감일 %d · %s\n운영비 %d / 지급 %d / 운임 %d / 마감 현금 %d"
			% [
				report.day_id,
				report.display_key,
				value.operating_cost,
				value.payment,
				value.fare,
				value.closing_funds.cash
			]
		)
	else:
		_labels.report.text = (
			"확정 보고 없음 (미마감)"
			if report.status == "UNAVAILABLE"
			else ("보고 조회 실패: " + reason_text(report.reason))
		)
	if not state.coherent:
		_labels.funds.text = "현재 상태 확인 중: 게임 시각 불일치"
	_render_activity(state)


func _render_activity(state: Dictionary) -> void:
	var daily: Dictionary = state.get("daily_activity", {})
	for key: String in ["operating_cost", "payment", "debt_payment", "cash_payment"]:
		if not daily.get(key) is int or daily[key] < 0:
			_labels.activity.text = "당일 운영비 확인 실패: 자료 없음/오류"
			return
	if (
		not state.coherent
		or daily.get("day_id") != state.current.day_id
		or daily.get("simulation_minute") != state.current.simulation_minute
		or daily.get("snapshot_revision") != state.current.snapshot_revision
	):
		_labels.activity.text = "당일 운영비 확인 중: 관측 시점 불일치"
		return
	_labels.activity.text = (
		"당일 운영비(미마감) · 게임일 %d / 게임분 %d · 게임 통화 정수 단위\n발생 누계 %d / 현금 지급 누계 %d"
		% [daily.day_id, daily.simulation_minute, daily.operating_cost, daily.cash_payment]
	)


func _render_prediction(prediction: Dictionary) -> void:
	_labels.prediction.text = (
		"예측: %s · 입력판 %d / 계획판 %d"
		% [
			(
				{
					"NOT_CALCULATED": "미계산",
					"CALCULATING": "계산 중",
					"READY": "계산 완료",
					"FAILED": "계산 실패"
				}
				. get(prediction.prediction_status, prediction.prediction_status)
			),
			prediction.prediction_input_revision,
			prediction.plan_revision
		]
	)
	if prediction.available:
		_labels.prediction.text += "\n" + _prediction_value(prediction.current)
	elif prediction.prediction_status == "FAILED":
		_labels.prediction.text += " · 자료 없음: " + reason_text(prediction.reason)
	else:
		_labels.prediction.text += " · 자료 없음 / 예측 계산을 선택하세요"
	_labels.previous.text = ""
	if not prediction.previous.is_empty():
		_labels.previous.text = (
			"이전 입력판 %d (비교용): %s"
			% [prediction.previous.input_revision, _prediction_value(prediction.previous)]
		)


func _prediction_value(result: Dictionary) -> String:
	var value: Dictionary = result.value
	return (
		(
			"예측 기간 [%d, %d) 게임분 · %d km / 종단 %d 게임분\n"
			+ "요청 %d / 탑승 %d / 완료 %d 통행 · 예상 운임 %d / 운영비 %d (실적 아님) · 생성 게임분 %d"
		)
		% [
			value.period_start,
			value.period_end,
			value.distance_km,
			value.end_to_end_minutes,
			value.totals.requested,
			value.totals.boarded,
			value.totals.completed,
			value.totals.predicted_fare,
			value.totals.operating_cost,
			result.generated_minute
		]
	)


func reason_text(code: String) -> String:
	return (
		{
			"": "현재 상태를 확인하세요",
			"STATION_COUNT": "서로 다른 역 6~8개가 필요합니다",
			"DUPLICATE_STATION": "이미 선택한 역입니다",
			"DISCONNECTED": "이어지지 않은 역 구간이 있습니다",
			"OUTSIDE_JURISDICTION": "관할에 없는 역입니다",
			"PLAN_LOCKED": "계획이 잠겨 있습니다",
			"NO_UNDO_HISTORY": "되돌릴 이력이 없습니다",
			"UNDO_FAILED": "되돌리기 실패: 상태를 다시 확인하세요",
			"STATE_CHANGED": "계획이 변경됐습니다. 다시 확인하세요",
			"INVALID_SPEED": "배속은 1·2·4만 가능합니다",
			"INVALID_PLAN": "계획 조건을 먼저 확인하세요",
			"INVALID_INPUT": "예측 입력을 확인하세요",
			"STATION_NOT_SELECTED": "선택된 노선 역이 아닙니다",
			"INVALID_INDEX": "이동할 순서를 확인하세요"
		}
		. get(code, "정보를 확인하지 못했습니다: " + code)
	)


func reset_observation() -> void:
	_displayed_revision = -1
	_selected_id = ""
	_focus_feedback = ""
	_list_stops = []
	plan_list.clear()
	_labels.feedback.text = "후보역을 선택해 노선을 편집하세요."
	_last_usec = Time.get_ticks_usec()
	_build_candidates()
	present(session.snapshot())


func _build_candidates() -> void:
	for child: Node in _candidates.get_children():
		_candidates.remove_child(child)
		child.queue_free()
	candidate_buttons.clear()
	for station: Dictionary in session.snapshot().stations:
		var id: String = station.id
		var button := Button.new()
		button.text = id
		button.name = "List_" + id
		button.toggle_mode = true
		button.pressed.connect(_select_station.bind(id))
		_candidates.add_child(button)
		candidate_buttons[id] = button


func _open_tenders() -> void:
	for section: Control in _planning_sections:
		section.hide()
	tender_view.show()
	controls.open_tenders.hide()
	present(session.snapshot())
	tender_view.controls.refresh.grab_focus()


func _close_tenders() -> void:
	tender_view.hide()
	for section: Control in _planning_sections:
		section.show()
	controls.open_tenders.show()
	controls.open_tenders.grab_focus()
	_ensure_focus_region(controls.open_tenders)


func _bid_requested(id: String, tender_id: String, confirmed: Dictionary) -> void:
	session.request_bid(id, tender_id, confirmed)
	present(session.snapshot())


func _refresh_tenders() -> void:
	session.refresh_tenders()
	present(session.snapshot())


func _open_construction(project_id: String) -> void:
	_scroll.follow_focus = true
	tender_view.hide()
	construction_view.select_project(project_id)
	construction_view.show()
	present(session.snapshot())
	construction_view.controls.back.grab_focus()


func _close_construction() -> void:
	_scroll.follow_focus = false
	construction_view.hide()
	tender_view.show()
	present(session.snapshot())
	tender_view.controls.construction.grab_focus()
	_ensure_focus_region(tender_view.controls.construction)


func _construction_requested(id: String, action: String, confirmed: Dictionary) -> void:
	session.request_construction(id, action, confirmed)
	present(session.snapshot())


func _refresh_construction() -> void:
	session.refresh_construction()
	present(session.snapshot())


func _focus_resized() -> void:
	if construction_view != null and construction_view.visible:
		var region: Control = construction_view.focus_region()
		if region != null:
			_ensure_focus_region(region)


func _ensure_focus_region(region: Control) -> void:
	# 레이아웃 반영 후에도 같은 대상에 포커스가 있을 때만 스크롤한다.
	await get_tree().process_frame
	if not is_instance_valid(region) or not region.is_visible_in_tree():
		return
	var owner := get_viewport().gui_get_focus_owner()
	if owner != null and (owner == region or region.is_ancestor_of(owner)):
		_scroll.ensure_control_visible(region)
		await get_tree().process_frame
		if not is_instance_valid(region) or get_viewport().gui_get_focus_owner() != owner:
			return
		_focus_sequence += 1
		print(
			"DEV021_OBS01_PRODUCT_FOCUS ",
			JSON.stringify(
				{
					"sequence": _focus_sequence,
					"fixture_label": session.fixture_label,
					"minute": session.pipeline.clock.minute,
					"view_revision": session.revision,
					"owner_path": str(owner.get_path()),
					"owner_rect": str(owner.get_global_rect()),
					"region_path": str(region.get_path()),
					"region_rect": str(region.get_global_rect()),
					"scroll_rect": str(_scroll.get_global_rect()),
					"scroll": _scroll.scroll_vertical,
					"window_raw": [get_window().size.x, get_window().size.y],
					"viewport_rect": str(get_viewport().get_visible_rect())
				}
			)
		)
