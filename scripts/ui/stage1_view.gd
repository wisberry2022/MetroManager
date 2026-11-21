extends MarginContainer
## 기본 도형/컨트롤의 최소 S01. 화면은 공급값만 소비한다.

const Contract = preload("res://scripts/ui/s01_observation_contract.gd")
const Session = preload("res://scripts/ui/stage1_session.gd")
const TenderPanel = preload("res://scenes/tender_panel.tscn")
const ConstructionPanel = preload("res://scenes/construction_panel.tscn")
const OperationsPanel = preload("res://scenes/operations_panel.tscn")
const FinancePanel = preload("res://scenes/finance_panel.tscn")
const Operations = preload("res://scripts/ui/operations_view.gd")
const MapView = preload("res://scripts/ui/stage1_map.gd")

var session: Session
var map_view: MapView
var controls: Dictionary = {}
var candidate_buttons: Dictionary = {}
var plan_list: ItemList
var shown: Dictionary = {}
var tender_view: VBoxContainer
var construction_view: VBoxContainer
var operations_view: VBoxContainer
var finance_view: VBoxContainer
var _screen_history: Array[Dictionary] = []
var _report_return: Dictionary = {}
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
var _bound_session: Session
var _scope: String = ""
var _retired: bool = false
var _navigation_generation: int = 0
var _suspended_child: String = ""
var _observation: Dictionary = {}


func _ready() -> void:
	_bound_session = session
	_scope = session.observation_scope()
	_observation = Contract.inspect(null, _scope, -1)
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
	var reading := HFlowContainer.new()
	root.add_child(reading)
	for screen: String in ["operations", "finance"]:
		Operations.add_action(
			reading,
			controls,
			"open_" + screen,
			"운영 현황" if screen == "operations" else "재무·보고",
			_open_reading.bind(screen)
		)
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
	operations_view = OperationsPanel.instantiate()
	finance_view = FinancePanel.instantiate()
	for panel: VBoxContainer in [operations_view, finance_view]:
		root.add_child(panel)
		panel.hide()
		panel.exit_requested.connect(_return_reading)
		panel.focus_region_requested.connect(_ensure_focus_region)
	operations_view.finance_requested.connect(_open_reading.bind("finance"))
	finance_view.report_requested.connect(_select_report)
	finance_view.query_requested.connect(_query_business)
	finance_view.refresh_requested.connect(_refresh_finance)
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
	_label(
		left,
		"legend",
		"관할: P01 > C01 · DATA 소속 기준 / 도형은 추상 배치\n운행 흐름(대표 표시) · 주황선: 실제 운영선 / 점: 이동 중 통행 묶음"
	)
	var right := VBoxContainer.new()
	right.custom_minimum_size.x = 360
	work.add_child(right)
	_label(right, "candidates_title", "후보역 · 미포함 역: 추가 / 포함 역: 정보 선택")
	_candidates = GridContainer.new()
	_candidates.columns = 4
	right.add_child(_candidates)
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
	_label(root, "operations_summary", "")
	operations_view.bind_session(session)
	finance_view.bind_session(session)
	_labels.title.focus_mode = Control.FOCUS_ALL
	_label(root, "scope", "노선 계획/예측 · 공공입찰 → 사업 인계 → 공사·검증·개통 · 운영 현황 · 재무·보고")
	var after_panel := false
	for section: Node in root.get_children():
		if after_panel and section not in [construction_view, operations_view, finance_view]:
			_planning_sections.append(section)
		if section == tender_view:
			after_panel = true
	session.enable_tender_ui()
	session.enable_construction_ui()
	_last_usec = Time.get_ticks_usec()
	present(session.snapshot())


func _process(_delta: float) -> void:
	if not _binding_valid():
		present(null)
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
	if not _binding_valid() or not _observation.regions.map or not _observation.regions.plan:
		return
	if not candidate_buttons.has(id):
		return
	_selected_id = id
	if id in shown.plan.station_ids:
		_focus_station(id)
		return
	_act("select", {"station_id": id})


func _plan_selected(index: int) -> void:
	if not _binding_valid() or not _observation.regions.map or not _observation.regions.plan:
		return
	if index >= 0 and index < shown.plan.station_ids.size():
		_focus_station(shown.plan.station_ids[index])


func _focus_station(id: String) -> void:
	if not _binding_valid() or not _observation.regions.map:
		return
	_selected_id = id
	_focus_feedback = "정보 선택: %s · 노선 변경 없음 · 계획판 %d" % [id, shown.plan.plan_revision]
	# 렌더한 관측을 유지한다. 부분 자료를 명령 callback의 재조회로 우회하지 않는다.
	present(shown)
	plan_list.ensure_current_is_visible()
	print("W07_FOCUS ", JSON.stringify({"station_id": id, "command_dispatched": false}))


func _act(action: String, payload: Dictionary = {}) -> void:
	if not _binding_valid() or not Contract.action_allowed(shown, _observation.regions, action):
		return
	if action == "speed" and payload.get("value") not in shown.allowed_actions.speed:
		return
	_focus_feedback = ""
	_sequence += 1
	var command := payload.duplicate(true)
	command.merge({"command_id": "ui-%d-%d" % [get_instance_id(), _sequence], "action": action})
	if action in ["select", "remove", "reorder", "undo", "predict"]:
		command.expected_plan_revision = shown.plan.plan_revision
	if action in ["remove", "reorder"]:
		if _selected_id not in shown.plan.station_ids:
			return
		command.station_id = _selected_id
	if action == "reorder":
		command.from = shown.plan.station_ids.find(_selected_id)
		command.to = command.from + command.direction
	var result := session.dispatch(command)
	print("W07_COMMAND ", JSON.stringify(result))
	present(session.snapshot())


func present(state: Variant) -> bool:
	var check := Contract.inspect(state, _scope, _displayed_revision)
	if not _binding_valid():
		check = Contract.inspect(null, _scope, _displayed_revision)
	if (
		check.discard_observation
		or (check.global_current_valid and Operations.is_older(state, shown))
	):
		print("DEV026_DISCARD ", check.diagnostic)
		return false
	_observation = check
	shown = state.duplicate(true) if check.global_current_valid else {}
	if check.global_current_valid:
		_displayed_revision = maxi(_displayed_revision, state.view_revision)
	var region: Dictionary = check.regions
	var owner := get_viewport().gui_get_focus_owner()
	var owned_focus := owner != null and is_ancestor_of(owner)
	_render_clock(region.clock)
	_render_children(region)
	if region.plan:
		_render_plan(shown)
	else:
		map_view.clear_observation()
		_list_stops = []
		plan_list.clear()
		_labels.validation.text = "계획 자료를 확인하지 못했습니다"
		_labels.selection.text = "선택 정보 확인 중"
		_labels.connections.text = ""
		_disable_plan()
	_render_finance(shown)
	if region.prediction:
		_render_prediction(shown.prediction)
	else:
		_labels.prediction.text = "예측을 확인하지 못했습니다 · 자료 없음"
		_labels.previous.text = ""
	if region.previous:
		var previous: Dictionary = shown.prediction.previous
		_labels.previous.text = (
			"이전 입력판 %d (비교용): %s" % [previous.input_revision, _prediction_value(previous)]
		)
	_render_result(region.command)
	if owned_focus and not Contract.focus_valid(owner):
		var fallback := _fallback(_reading_context().screen)
		if fallback != null:
			fallback.grab_focus()
	return check.global_current_valid


func _render_plan(state: Dictionary) -> void:
	var route: Dictionary = state.plan.duplicate(true)
	route.allowed_actions = {
		"edit": Contract.action_allowed(state, _observation.regions, "select"),
		"undo": Contract.action_allowed(state, _observation.regions, "undo")
	}
	_build_candidates()
	if _observation.regions.map:
		if not _selected_id.is_empty() and not candidate_buttons.has(_selected_id):
			_selected_id = ""
		var map_state := state.duplicate(true)
		map_state.plan = route
		map_view.present(map_state, _selected_id)
	else:
		map_view.clear_observation()
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
	controls.predict.disabled = not Contract.action_allowed(state, _observation.regions, "predict")
	for id: String in candidate_buttons:
		candidate_buttons[id].disabled = (
			not _observation.regions.map
			or (not route.allowed_actions.edit and id not in route.station_ids)
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
	if not _observation.regions.map:
		_labels.selection.text = "선택 정보 확인 중 · 지도·후보 자료 없음"
	var stations: Array = state.stations if _observation.regions.map else []
	for station: Dictionary in stations:
		if station.id == _selected_id:
			var path: Array[String] = [station.id]
			var cursor: String = station.neighborhood_id
			while not cursor.is_empty():
				path.push_front(cursor)
				cursor = state.administration[cursor].parent_id
			_labels.selection.text += " / " + " > ".join(path)
	if route.locked:
		_labels.validation.text += " · 편집 잠금"
	_labels.connections.text = "지도·후보 자료를 확인 중입니다"
	if _observation.regions.map:
		var connected := state.duplicate(true)
		connected.plan = route
		_render_connections(connected)


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
	var region: Dictionary = _observation.regions
	_labels.funds.text = "현재 자금의 기준 시각을 확인 중입니다 · 자료 없음"
	if region.funds:
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
	_labels.report.text = "보고의 조회 대상을 확인 중입니다 · 자료 없음"
	if region.report:
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
		elif report.status == "FAILED":
			_labels.report.text = ("과거 보고 조회 실패 · " + reason_text(str(report.get("reason", ""))))
		else:
			_labels.report.text = "확정 보고 자료 없음"
			if state.clock.day_id == 1 and report.day_id == 0:
				_labels.report.text += " (첫 마감 전)"
	_render_activity(state)


func _render_activity(state: Dictionary) -> void:
	var daily := Contract.dictionary(state.get("daily_activity"))
	if not Contract.integers(daily, Contract.DAILY):
		_labels.activity.text = "당일 운영비 확인 실패: 자료 없음/오류"
		return
	if not _observation.regions.daily:
		_labels.activity.text = "당일 운영비 확인 중: 관측 시점 불일치"
		return
	_labels.activity.text = (
		"당일 운영비(미마감) · 게임일 %d / 게임분 %d · 게임 통화 정수 단위\n발생 누계 %d / 현금 지급 누계 %d"
		% [daily.day_id, daily.simulation_minute, daily.operating_cost, daily.cash_payment]
	)


func _render_prediction(prediction: Dictionary) -> void:
	var text := Operations.prediction_messages(prediction, _observation.regions.previous)
	_labels.prediction.text = text.current
	_labels.previous.text = text.previous


func _prediction_value(result: Dictionary) -> String:
	return Operations.prediction_value(result)


func reason_text(code: String) -> String:
	return Operations.reason_text(code)


func reset_observation() -> void:
	# 같은 Session의 표시만 갱신한다. 관측 하한/자식 이력을 되감지 않는다.
	_focus_feedback = ""
	_last_usec = Time.get_ticks_usec()
	present(session.snapshot() if _binding_valid() else null)


func _build_candidates() -> void:
	if not _observation.regions.map:
		for button: Button in candidate_buttons.values():
			button.disabled = true
		return
	var ids: Array = shown.stations.map(func(row: Dictionary) -> String: return row.id)
	for id: String in candidate_buttons.keys():
		if id not in ids:
			var old: Button = candidate_buttons[id]
			old.disabled = true
			_candidates.remove_child(old)
			old.queue_free()
			candidate_buttons.erase(id)
	for id: String in ids:
		if candidate_buttons.has(id):
			continue
		var button := Button.new()
		button.text = id
		button.name = "List_" + id
		button.toggle_mode = true
		button.pressed.connect(_select_station.bind(id))
		_candidates.add_child(button)
		candidate_buttons[id] = button


func _open_tenders() -> void:
	if not _binding_valid() or not _observation.regions.tender_ui:
		return
	tender_view.controls.exit.text = (
		"재무·보고로 돌아가기" if not _report_return.is_empty() else "S01 노선 계획으로"
	)
	operations_view.hide()
	finance_view.hide()
	for section: Control in _planning_sections:
		section.hide()
	tender_view.show()
	controls.open_tenders.hide()
	present(session.snapshot())
	tender_view.controls.refresh.grab_focus()


func _close_tenders() -> void:
	if not _binding_valid():
		return
	if not _report_return.is_empty():
		var previous := _report_return
		_report_return = {}
		_restore_reading(previous)
		return
	tender_view.hide()
	for section: Control in _planning_sections:
		section.show()
	controls.open_tenders.show()
	controls.open_tenders.grab_focus()
	_ensure_focus_region(controls.open_tenders)


func _bid_requested(id: String, tender_id: String, confirmed: Dictionary) -> void:
	if not _binding_valid() or not tender_view.visible or not _observation.regions.tender_ui:
		return
	session.request_bid(id, tender_id, confirmed)
	present(session.snapshot())


func _refresh_tenders() -> void:
	if not _binding_valid() or not tender_view.visible or not _observation.regions.tender_ui:
		return
	session.refresh_tenders()
	present(session.snapshot())


func _open_construction(project_id: String) -> void:
	if not _binding_valid() or not _observation.regions.construction_ui:
		return
	_scroll.follow_focus = true
	tender_view.hide()
	construction_view.select_project(project_id)
	construction_view.show()
	present(session.snapshot())
	construction_view.controls.back.grab_focus()


func _close_construction() -> void:
	if not _binding_valid():
		return
	_scroll.follow_focus = false
	construction_view.hide()
	tender_view.show()
	present(session.snapshot())
	tender_view.controls.construction.grab_focus()
	_ensure_focus_region(tender_view.controls.construction)


func _construction_requested(id: String, action: String, confirmed: Dictionary) -> void:
	if (
		not _binding_valid()
		or not construction_view.visible
		or not _observation.regions.construction_ui
	):
		return
	session.request_construction(id, action, confirmed)
	present(session.snapshot())


func _refresh_construction() -> void:
	if (
		not _binding_valid()
		or not construction_view.visible
		or not _observation.regions.construction_ui
	):
		return
	_scroll.follow_focus = true
	session.refresh_construction()
	present(session.snapshot())
	var region: Control = construction_view.focus_region()
	if region != null:
		_ensure_focus_region(region)


func _focus_resized() -> void:
	if not _binding_valid():
		return
	if construction_view != null and construction_view.visible:
		_scroll.follow_focus = true
		var region: Control = construction_view.focus_region()
		if region != null:
			_ensure_focus_region(region)


func _ensure_focus_region(region: Control) -> void:
	# 레이아웃 반영 후에도 같은 대상에 포커스가 있을 때만 스크롤한다.
	if not _binding_valid():
		return
	var generation := _navigation_generation
	await get_tree().process_frame
	if not _binding_valid() or generation != _navigation_generation:
		return
	if not is_instance_valid(region) or not region.is_visible_in_tree():
		return
	if construction_view.is_ancestor_of(region) and not _scroll.follow_focus:
		return
	var owner := get_viewport().gui_get_focus_owner()
	if owner != null and (owner == region or region.is_ancestor_of(owner)):
		_scroll.ensure_control_visible(region)
		await get_tree().process_frame
		if not _binding_valid() or generation != _navigation_generation:
			return
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


## W05 읽기 키만 소비한다. 보조 검수 호스트도 이 제어를 그대로 재사용한다.
static func read_construction_key(
	scroll: ScrollContainer, panel: Control, event: InputEvent
) -> bool:
	if event is InputEventMouseButton and panel.is_visible_in_tree():
		scroll.follow_focus = true
		return false
	if not event is InputEventKey or not event.pressed or not panel.is_visible_in_tree():
		return false
	if event.alt_pressed or event.meta_pressed or event.shift_pressed:
		if event.keycode == KEY_TAB:
			scroll.follow_focus = true
		return false
	if event.keycode == KEY_TAB:
		scroll.follow_focus = true
		return false
	if event.keycode not in [KEY_PAGEUP, KEY_PAGEDOWN, KEY_HOME, KEY_END]:
		return false
	if event.ctrl_pressed and event.keycode not in [KEY_HOME, KEY_END]:
		return false
	var owner := panel.get_viewport().gui_get_focus_owner()
	if owner == null or not panel.is_ancestor_of(owner):
		return false
	if owner is OptionButton or owner is LineEdit or owner is TextEdit:
		return false
	# 읽기 중 화면 밖의 기존 포커스로 자동 복귀하지 않게 한다.
	scroll.follow_focus = false
	var bar := scroll.get_v_scroll_bar()
	var limit := maxi(0, int(bar.max_value - bar.page))
	var step := maxi(1, int(scroll.size.y * 0.8))
	match event.keycode:
		KEY_HOME:
			scroll.scroll_vertical = 0
		KEY_END:
			scroll.scroll_vertical = limit
		KEY_PAGEUP:
			scroll.scroll_vertical = maxi(0, scroll.scroll_vertical - step)
		KEY_PAGEDOWN:
			scroll.scroll_vertical = mini(limit, scroll.scroll_vertical + step)
	return true


func _unhandled_key_input(event: InputEvent) -> void:
	if not _binding_valid():
		return
	for panel: Control in [construction_view, operations_view, finance_view]:
		if read_construction_key(_scroll, panel, event):
			get_viewport().set_input_as_handled()
			return


func _input(event: InputEvent) -> void:
	if not _binding_valid():
		return
	# 새 읽기 패널은 ScrollContainer가 Home/End를 먼저 소비하기 전에 처리한다.
	for panel: Control in [operations_view, finance_view]:
		if read_construction_key(_scroll, panel, event):
			get_viewport().set_input_as_handled()
			return
	# Tab은 GUI가 소비하기 전에 기존 포커스 추적만 복구한다.
	if event is InputEventMouseButton or (event is InputEventKey and event.keycode == KEY_TAB):
		for panel: Control in [construction_view, operations_view, finance_view]:
			read_construction_key(_scroll, panel, event)


func _reading_context() -> Dictionary:
	var screen := _suspended_child.trim_suffix("_ui") if not _suspended_child.is_empty() else "plan"
	if screen == "tender":
		screen = "tenders"
	for entry: Array in [
		["tenders", tender_view],
		["construction", construction_view],
		["operations", operations_view],
		["finance", finance_view]
	]:
		if entry[1].visible:
			screen = entry[0]
	return {
		"scope": _scope,
		"screen": screen,
		"focus": get_viewport().gui_get_focus_owner(),
		"scroll": _scroll.scroll_vertical
	}


func _show_reading(screen: String) -> void:
	if not _binding_valid():
		return
	_navigation_generation += 1
	_suspended_child = ""
	for section: Control in _planning_sections:
		section.visible = screen == "plan"
	tender_view.visible = screen == "tenders"
	construction_view.visible = screen == "construction"
	operations_view.visible = screen == "operations"
	finance_view.visible = screen == "finance"
	controls.open_tenders.visible = screen == "plan"
	_scroll.follow_focus = true
	present(session.snapshot())


func _open_reading(screen: String) -> void:
	if not _binding_valid() or not _observation.regions.get(screen + "_ui", false):
		return
	if _reading_context().screen == screen:
		return
	_screen_history.append(_reading_context())
	_show_reading(screen)
	var target: Control = (
		operations_view.controls.finance if screen == "operations" else finance_view.controls.first
	)
	if not Contract.focus_valid(target):
		target = _fallback(screen)
	if target == null:
		return
	target.grab_focus()
	_ensure_focus_region(target)


func _return_reading() -> void:
	if not _binding_valid():
		return
	if _screen_history.is_empty():
		_show_reading("plan")
		return
	_restore_reading(_screen_history.pop_back())


func _restore_reading(context: Dictionary) -> void:
	if not _binding_valid() or context.get("scope") != _scope:
		return
	_show_reading(context.screen)
	var owner := get_viewport().gui_get_focus_owner()
	var generation := _navigation_generation
	await get_tree().process_frame
	await get_tree().process_frame
	if not _binding_valid() or generation != _navigation_generation:
		return
	if _reading_context().screen != context.screen or get_viewport().gui_get_focus_owner() != owner:
		return
	var target: Variant = context.focus
	if not Contract.focus_valid(target):
		target = _fallback(context.screen)
	if target != null and is_ancestor_of(target):
		target.grab_focus()
	_scroll.follow_focus = false
	_scroll.scroll_vertical = context.scroll


func _select_report(day: int) -> void:
	if not finance_view.day_allowed(day):
		return
	if not _binding_valid() or not finance_view.visible or not _observation.regions.finance_ui:
		return
	var result := session.select_finance_report(day)
	present(session.snapshot())
	finance_view.show_result(result)
	_log_reading("REPORT", result)


func _refresh_finance() -> void:
	if not _binding_valid() or not finance_view.visible or not _observation.regions.finance_ui:
		return
	present(session.snapshot())
	finance_view.show_result({"accepted": true})
	_log_reading("REFRESH", {})


func _query_business(confirmed: Dictionary) -> void:
	if not _binding_valid() or not finance_view.visible:
		return
	if not finance_view.confirmation_current(confirmed):
		finance_view.labels.feedback.text = "표시한 보고와 현재 허용 행동을 다시 확인해 주세요"
		return
	var result := session.query_next_business(confirmed)
	present(session.snapshot())
	finance_view.show_result(result)
	_log_reading("QUERY", result)
	if result.get("accepted", false):
		_report_return = _reading_context()
		tender_view.page = "P01"
		_open_tenders()


func _log_reading(action: String, result: Dictionary) -> void:
	print(
		"DEV023_UI ",
		JSON.stringify(
			{
				"action": action,
				"result": result,
				"fixture": session.fixture_label,
				"minute": session.pipeline.clock.minute,
				"view_revision": session.revision,
				"report": shown.finance_ui.report,
				"funds": shown.finance_ui.current_funds
			}
		)
	)


## 새 Session에는 호스트와 전체 자식을 새로 만든다. 기존 인스턴스를 재바인딩하지 않는다.
static func replace_session(previous: Control, next: Session) -> Control:
	var parent := previous.get_parent()
	var index := previous.get_index()
	var vertical := previous.size_flags_vertical
	previous.retire()
	parent.remove_child(previous)
	previous.queue_free()
	var replacement: Control = load("res://scenes/stage1.tscn").instantiate()
	replacement.session = next
	replacement.size_flags_vertical = vertical
	parent.add_child(replacement)
	parent.move_child(replacement, index)
	return replacement


func retire() -> void:
	_retired = true
	_navigation_generation += 1
	set_process(false)
	set_process_input(false)
	set_process_unhandled_key_input(false)
	hide()
	for panel: Node in [map_view, tender_view, construction_view, operations_view, finance_view]:
		for entry: Dictionary in panel.get_signal_list():
			for connection: Dictionary in panel.get_signal_connection_list(entry.name):
				if connection.callable.get_object() == self:
					panel.disconnect(entry.name, connection.callable)


func _binding_valid() -> bool:
	return (
		not _retired
		and is_inside_tree()
		and not is_queued_for_deletion()
		and _bound_session != null
		and session == _bound_session
	)


func _render_clock(valid: bool) -> void:
	var fixture: Variant = shown.get("fixture_label", "")
	_labels.title.text = "MetroManager · S01 노선 계획"
	if fixture is String and not fixture.is_empty():
		_labels.title.text += " · 검증 전용: " + fixture
	_labels.clock.text = "게임 시간 확인 중 · 자료 없음"
	if valid:
		var clock: Dictionary = shown.clock
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
	for action: String in ["pause", "resume"]:
		controls[action].disabled = not Contract.action_allowed(shown, _observation.regions, action)
	for speed: int in [1, 2, 4]:
		var enabled := Contract.action_allowed(shown, _observation.regions, "speed")
		controls["speed%d" % speed].disabled = (
			not enabled or speed not in shown.allowed_actions.speed
		)
		controls["speed%d" % speed].text = (
			("[%d×]" if valid and shown.clock.speed == speed else "%d×") % speed
		)


func _render_children(region: Dictionary) -> void:
	for entry: Array in [["tender_ui", tender_view], ["construction_ui", construction_view]]:
		var panel: Control = entry[1]
		if region[entry[0]]:
			panel.process_mode = Node.PROCESS_MODE_INHERIT
			panel.mouse_filter = Control.MOUSE_FILTER_STOP
			panel.present(shown[entry[0]])
			if _suspended_child == entry[0]:
				panel.show()
				_suspended_child = ""
		else:
			# 이전 자식의 입력·표시는 정상 공급 복귀까지 숨긴다.
			if panel.visible:
				_suspended_child = entry[0]
			panel.hide()
			panel.process_mode = Node.PROCESS_MODE_DISABLED
			panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	controls.open_tenders.disabled = not region.tender_ui
	controls.open_operations.disabled = not region.operations_ui
	controls.open_finance.disabled = not region.finance_ui
	operations_view.present(shown)
	finance_view.present(shown)
	_labels.operations_summary.text = "운행 흐름(대표 표시)\n" + Operations.summary(shown)


func _disable_plan() -> void:
	for id: String in ["up", "down", "remove", "undo", "predict"]:
		controls[id].disabled = true
	for button: Button in candidate_buttons.values():
		button.disabled = true


func _render_result(valid: bool) -> void:
	_labels.feedback.text = "현재 상태와 허용된 행동을 확인하세요"
	if valid:
		var result: Dictionary = shown.command_result
		if not result.is_empty():
			_labels.feedback.text = (
				"당시 요청 %s: %s · %s · 게임분 %d"
				% [
					result.command_id,
					"처리됨" if result.accepted else "처리되지 않음",
					reason_text(result.get("reason", "")),
					result.effective_at
				]
			)
	if not _focus_feedback.is_empty() and _observation.regions.plan and _observation.regions.map:
		_labels.feedback.text = _focus_feedback


func _fallback(screen: String) -> Control:
	var options: Array
	match screen:
		"operations":
			options = [operations_view.controls.back, operations_view.labels.title]
		"finance":
			options = [
				finance_view.controls.day, finance_view.controls.refresh, finance_view.labels.title
			]
		"tenders":
			options = [tender_view.controls.refresh, _labels.title]
		"construction":
			options = [construction_view.controls.back, _labels.title]
		_:
			options = [plan_list] if _observation.regions.plan and plan_list.item_count > 0 else []
			options.append_array(candidate_buttons.values())
			options.append(_labels.title)
	return Contract.focus_fallback(self, options)
