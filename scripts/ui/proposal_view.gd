extends VBoxContainer
## W04B 실제 소비자. 채택본과 읽기 선택은 이 Session의 View 수명에만 속한다.

signal command_requested(command: Dictionary)
signal construction_requested(project_id: String)
signal exit_requested
signal refresh_requested
signal focus_region_requested(region: Control)

const Contract = preload("res://scripts/ui/s01_observation_contract.gd")
const Text = preload("res://scripts/ui/proposal_presentation.gd")
const Operations = preload("res://scripts/ui/operations_view.gd")
const MapView = preload("res://scripts/ui/stage1_map.gd")

var controls: Dictionary = {}
var labels: Dictionary = {}
var station_buttons: Dictionary = {}
var map_view: MapView
var plan_list: ItemList
var name_input: LineEdit
var selected_slot: String = ""
var selected_station: String = ""
var previous_packet: Dictionary = {}
var shown: Dictionary = {}
var row: Dictionary = {}
var available: bool = false
var _binding: RefCounted
var _scope: String = ""
var _root: Dictionary = {}
var _map_valid: bool = false
var _sequence: int = 0
var _station_box: HFlowContainer
var _listed: Array = []
var _name_dirty: bool = false
var _applying_name: bool = false


func bind_session(value: RefCounted) -> void:
	if _binding == null:
		_binding = value
		_scope = value.observation_scope()


func _ready() -> void:
	for id: String in ["title", "status", "identity"]:
		Operations.add_text(self, labels, id, "")
	labels.title.text = "회사 자체 제안"
	labels.title.focus_mode = Control.FOCUS_ALL
	var slots := HFlowContainer.new()
	add_child(slots)
	for slot: String in ["P-A", "P-B"]:
		_button(slots, slot, "제안 슬롯 " + slot, _select_slot.bind(slot))
	Operations.add_text(self, labels, "names", "역 ID / 소속 동 표시 · 실제 역명 자료 미공급")
	map_view = MapView.new()
	map_view.station_requested.connect(_select_station)
	add_child(map_view)
	_station_box = HFlowContainer.new()
	add_child(_station_box)
	Operations.add_text(self, labels, "selection", "읽을 역을 선택하세요 (노선 변경 없음)")
	plan_list = ItemList.new()
	plan_list.name = "ProposalPlan"
	plan_list.custom_minimum_size = Vector2(0, 130)
	plan_list.item_selected.connect(_plan_selected)
	add_child(plan_list)
	var editor := HFlowContainer.new()
	add_child(editor)
	name_input = LineEdit.new()
	name_input.name = "ProposalName"
	name_input.placeholder_text = "제안 이름 · 적용 버튼으로 변경"
	name_input.text_changed.connect(func(_text: String) -> void: _name_dirty = true)
	name_input.custom_minimum_size.x = 280
	editor.add_child(name_input)
	for entry: Array in [
		["add", "역 추가"], ["remove", "역 제거"], ["up", "위로"], ["down", "아래로"], ["name", "이름 적용"]
	]:
		_button(editor, entry[0], entry[1], _edit.bind(entry[0]))
	_button(editor, "predict", "예측 계산", _request.bind("predict_proposal"))
	for id: String in ["validation", "prediction", "review", "requests", "decisions", "contract"]:
		Operations.add_text(self, labels, id, "")
	for action: String in Text.ACTIONS:
		_button(self, action, Text.ACTIONS[action], _request.bind(action))
		Operations.add_text(self, labels, action, "")
	Operations.add_text(self, labels, "facts", "추가 사실 자료 미공급 · 재접수 제한")
	Operations.add_text(self, labels, "feedback", "")
	_button(self, "construction", "같은 사업 공사·검증 (P05)", _construction)
	_button(self, "refresh", "현재 상태 다시 확인", _refresh)
	_button(self, "back", "뒤로", func() -> void: exit_requested.emit())
	for id: String in labels:
		labels[id].name = "Proposal_" + id


func _button(parent: Node, id: String, text: String, callback: Callable) -> void:
	Operations.add_action(parent, controls, id, text, callback)
	controls[id].name = "Proposal_" + id
	controls[id].focus_entered.connect(func() -> void: focus_region_requested.emit(controls[id]))


func present(state: Variant) -> bool:
	var check := Contract.inspect(state, _scope, int(previous_packet.get("view_revision", -1)))
	if (
		check.discard_observation
		or (check.global_current_valid and Operations.is_older(state, _root))
	):
		return false
	var guard := Contract.proposal_region(state, _scope, previous_packet)
	available = _binding != null and guard.available and _consumer_fields_valid(state.proposal_ui)
	_root = state.duplicate(true) if check.global_current_valid else {}
	_map_valid = available and check.regions.map
	shown = {}
	row = {}
	if available:
		previous_packet = state.proposal_ui.duplicate(true)
		shown = previous_packet.duplicate(true)
		row = _selected_row()
		if row.is_empty():
			selected_slot = ""
			selected_station = ""
	else:
		print("DEV027_PROPOSAL_REJECT ", guard.reason)
		name_input.text = ""
		_name_dirty = false
	_render()
	return available


func _consumer_fields_valid(packet: Dictionary) -> bool:
	for item: Dictionary in packet.snapshot.proposals:
		if not item.get("name") is String or not Contract.strings(item.get("persuasion_used_for")):
			return false
	for record: Variant in packet.snapshot.commands:
		if not record is Dictionary or not record.get("command") is Dictionary:
			return false
		if not record.get("command_id") is String or not record.get("pending") is bool:
			return false
		if not record.get("accepted") is bool or not record.get("reason") is String:
			return false
		if record.command.get("slot_id") not in ["P-A", "P-B"]:
			return false
	return true


func _selected_row() -> Dictionary:
	for item: Dictionary in shown.get("snapshot", {}).get("proposals", []):
		if item.identity.slot_id == selected_slot:
			return item.duplicate(true)
	return {}


func _select_slot(slot: String) -> void:
	if not available or not is_visible_in_tree() or slot not in ["P-A", "P-B"]:
		return
	selected_slot = slot
	selected_station = ""
	row = _selected_row()
	name_input.text = row.get("name", "")
	_name_dirty = false
	labels.feedback.text = "슬롯 선택 · 명령 효과 없음"
	_render()


func _select_station(id: String) -> void:
	if not _map_valid or row.is_empty() or not station_buttons.has(id):
		return
	selected_station = id
	_render()


func _plan_selected(index: int) -> void:
	if index >= 0 and index < _listed.size():
		_select_station(_listed[index])


func _render() -> void:
	labels.status.text = "현재 제안 상태 확인 불가" if not available else "제안 슬롯을 선택하세요"
	labels.identity.text = ""
	for id: String in ["validation", "prediction", "review", "requests", "decisions", "contract"]:
		labels[id].text = ""
	for slot: String in ["P-A", "P-B"]:
		controls[slot].disabled = not available
	for id: String in ["add", "remove", "up", "down", "name", "predict", "construction"]:
		controls[id].disabled = true
	name_input.editable = false
	for action: String in Text.ACTIONS:
		controls[action].disabled = true
		labels[action].text = "상태를 확인할 수 없습니다" if not available else "슬롯 선택 필요"
	if not row.is_empty():
		labels.status.text = "현재 초안 · " + ("심사 중 편집 잠금" if row.draft.plan.locked else "편집 가능 여부 확인")
		labels.identity.text = "선택 슬롯 %s · %s" % [selected_slot, row.name]
		labels.validation.text = (
			"노선 조건 충족"
			if row.draft.plan.validation.valid
			else Text.reasons(row.draft.plan.validation.reason_codes)
		)
		labels.prediction.text = Text.prediction(row.draft.prediction)
		labels.review.text = Text.review_text(row)
		labels.requests.text = Text.request_text(shown.snapshot.commands, selected_slot)
		labels.decisions.text = Text.decisions_text(row)
		labels.contract.text = Text.contract_text(row)
	_render_map()
	if not row.is_empty():
		_render_actions()


func _render_actions() -> void:
	var stops: Array = row.draft.plan.station_ids
	var edit: bool = row.edit_state.allowed
	var index: int = stops.find(selected_station)
	name_input.editable = edit
	if not _name_dirty and not name_input.has_focus():
		name_input.text = row.name
	controls.name.disabled = not edit
	controls.add.disabled = not edit or not _map_valid or selected_station.is_empty() or index >= 0
	controls.remove.disabled = not edit or not _map_valid or index < 0
	controls.up.disabled = not edit or not _map_valid or index <= 0
	controls.down.disabled = not edit or not _map_valid or index < 0 or index >= stops.size() - 1
	controls.predict.disabled = not row.predict_state.allowed
	controls.predict.tooltip_text = Text.reasons(row.predict_state.reason_codes)
	for action: String in Text.ACTIONS:
		var allowed: Dictionary = row.action_states[action]
		controls[action].disabled = not allowed.allowed
		labels[action].text = "현재 요청 가능" if allowed.allowed else Text.reasons(allowed.reason_codes)
	controls.construction.disabled = row.business_contract.is_empty()


func _render_map() -> void:
	var stops: Array = row.get("draft", {}).get("plan", {}).get("station_ids", [])
	if stops != _listed:
		_listed = stops.duplicate()
		plan_list.clear()
		for id: String in stops:
			plan_list.add_item(id)
	var ids: Array = (
		_root.stations.map(func(value: Dictionary) -> String: return value.id)
		if _map_valid and not row.is_empty()
		else []
	)
	if selected_station not in ids:
		selected_station = ""
	for id: String in station_buttons.keys():
		if id not in ids:
			var button: Button = station_buttons[id]
			_station_box.remove_child(button)
			button.queue_free()
			station_buttons.erase(id)
	labels.selection.text = "읽을 역을 선택하세요 (노선 변경 없음)"
	for id: String in ids:
		var station: Dictionary = _root.stations[ids.find(id)]
		if not station_buttons.has(id):
			var button := Button.new()
			button.name = "ProposalStation_" + id
			button.toggle_mode = true
			button.pressed.connect(_select_station.bind(id))
			_station_box.add_child(button)
			station_buttons[id] = button
		station_buttons[id].text = "%s / %s" % [id, station.neighborhood_id]
		station_buttons[id].button_pressed = id == selected_station
		if id == selected_station:
			labels.selection.text = "정보 선택 %s / %s · 노선 변경 없음" % [id, station.neighborhood_id]
	if not ids.is_empty():
		var render := _root.duplicate(true)
		render.plan = row.draft.plan.duplicate(true)
		render.plan.allowed_actions = {"edit": row.edit_state.allowed}
		map_view.present(render, selected_station)
	else:
		map_view.clear_observation()
	if selected_station in stops:
		var index: int = stops.find(selected_station)
		# Keep the keyboard's pending ensure-visible request for an unchanged selection.
		if not plan_list.is_selected(index):
			plan_list.select(index)
	else:
		plan_list.deselect_all()


func _edit(operation: String) -> void:
	if not _can_request("edit_proposal") or controls[operation].disabled:
		return
	var stops: Array = row.draft.plan.station_ids.duplicate()
	var index: int = stops.find(selected_station)
	match operation:
		"add":
			stops.append(selected_station)
		"remove":
			stops.remove_at(index)
		"up", "down":
			stops.remove_at(index)
			stops.insert(index + (-1 if operation == "up" else 1), selected_station)
	_applying_name = operation == "name"
	_emit_command(
		"edit_proposal",
		{"station_ids": stops, "name": name_input.text if _applying_name else row.name}
	)


func _can_request(action: String) -> bool:
	if not available or row.is_empty() or not is_visible_in_tree():
		return false
	if action == "edit_proposal":
		return row.edit_state.allowed
	if action == "predict_proposal":
		return row.predict_state.allowed
	return row.action_states.get(action, {}).get("allowed", false)


func _request(action: String) -> void:
	if _can_request(action):
		_emit_command(action)


func _emit_command(action: String, payload: Dictionary = {}) -> void:
	var command := payload.duplicate(true)
	command.merge(
		{
			"run_scope": _scope,
			"slot_id": selected_slot,
			"action": action,
			"binding": row.binding.duplicate(true)
		}
	)
	if action in ["submit_government_review", "submit_persuasion", "sign_proposal_contract"]:
		for index: int in range(row.decisions.size() - 1, -1, -1):
			var decision: Dictionary = row.decisions[index]
			var kind := "CITY" if action == "submit_government_review" else "GOVERNMENT"
			if (
				decision.kind == kind
				or (action == "sign_proposal_contract" and decision.kind != "CITY")
			):
				command.decision_id = decision.decision_id
				break
	_sequence += 1
	command.command_id = "proposal-ui-%d-%d" % [get_instance_id(), _sequence]
	for record: Dictionary in shown.snapshot.commands:
		var prior: Dictionary = record.command.duplicate(true)
		prior.erase("command_id")
		var current := command.duplicate(true)
		current.erase("command_id")
		if record.pending and prior == current:
			command.command_id = record.command_id
			break
	command_requested.emit(command)


func show_result(result: Dictionary) -> void:
	if _applying_name and result.get("accepted", false):
		_name_dirty = false
		name_input.text = row.get("name", "")
	_applying_name = false
	labels.feedback.text = (
		"당시 요청: "
		+ (
			"접수 대기 (성공 보장 아님)"
			if result.get("pending", false)
			else ("처리됨" if result.get("accepted", false) else Text.reason(result.get("reason", "")))
		)
	)


func _construction() -> void:
	if (
		available
		and is_visible_in_tree()
		and not row.is_empty()
		and not row.business_contract.is_empty()
	):
		construction_requested.emit(row.business_contract.project_id)


func _refresh() -> void:
	if is_visible_in_tree():
		refresh_requested.emit()


func reading_context() -> Dictionary:
	return {"slot": selected_slot, "station": selected_station}


func restore_context(context: Dictionary) -> void:
	selected_slot = context.get("slot", "")
	selected_station = context.get("station", "")
	row = _selected_row() if available else {}
	if row.is_empty() and available:
		selected_slot = ""
	_render()
