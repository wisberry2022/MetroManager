extends VBoxContainer
## W05 권위 상태의 표시와 요청만 담당한다. 경제/시간/허용 조건은 모델이 판정한다.

signal command_requested(id: String, action: String, confirmed: Dictionary)
signal refresh_requested
signal exit_requested
signal focus_region_requested(region: Control)

const ACTIONS := {
	"contract": "공사 계약 요청",
	"start": "착공 요청",
	"resume": "공정 재개 요청",
	"trial": "시범운행 요청",
	"safety": "안전검증 / 재시험 요청",
	"repair": "수리비 지급·수리 요청",
	"open": "개통 요청"
}
const STATES := {
	"CONTRACTED": "공사 계약 유효 · 착공 전",
	"BUILDING": "공사 진행 중",
	"SUSPENDED": "미지급 기성으로 공정 중단",
	"COMPLETED": "공사 완공 · 검증/개통과 별도",
	"OPEN": "개통 유효 · 실제 영업 기능은 W06 후속",
	"NOT_STARTED": "미시작",
	"RUNNING": "진행 중",
	"PASSED": "통과",
	"FAILED": "실패",
	"trial": "시범운행",
	"safety": "안전검증 / 재시험",
	"repair": "수리"
}
const REASONS := {
	"PREREQUISITE_NOT_MET": "선행 상태 미충족",
	"CONSTRUCTION_PAYMENT_DUE": "공사 미지급 기성 · 자금 확보 후 재개 필요",
	"REPAIR_FUNDS_INSUFFICIENT": "수리비 20,000 전액 부족 · 부분 지급/착수 없음",
	"BUSINESS_PAYMENT_NOT_EFFECTIVE": "사업 계약·정부 지급 효력 확인 필요",
	"CONSTRUCTION_CONTRACT_EXISTS": "이미 체결된 공사 계약",
	"STATE_CHANGED": "확인한 대상 조건 변경 · 재조회 필요",
	"BUSINESS_CONTRACT_MISMATCH": "사업 계약 식별자 불일치",
	"UNKNOWN_CONSTRUCTION_PROJECT": "공사 사업 자료 없음",
	"MODE_RESERVATION_POLICY_REQUIRED": "해당 모드의 별도 약정 정책 필요",
	"CLOSED_EFFECTIVE_TIME": "이미 완료된 게임분 · 소급 실행 불가",
	"INVALID_COMMAND": "명령 형식 확인 필요",
	"INVALID_MODE": "공사 모드 확인 필요",
	"INVALID_ACTION": "지원하지 않는 명령",
	"FIXED_TERMS": "고정 조건 변경 불가",
	"CONSTRUCTION_NOT_ENABLED": "공사 공급 미활성"
}

var controls: Dictionary = {}
var labels: Dictionary = {}
var shown: Dictionary = {}
var selected_id: String = ""
var _modes: OptionButton
var _history: Dictionary = {}
var _view_revision: int = -1
var _snapshot_revision: int = -1
var _sequence: int = 0
var _ready_data: bool = false
var _last_observation: String = ""
var _focus_regions: Dictionary = {}
var _focus_signature: String = ""


func _ready() -> void:
	_label("title")
	var navigation := HBoxContainer.new()
	add_child(navigation)
	_button(navigation, "back", "사업 인계로 복귀", func() -> void: exit_requested.emit())
	_button(navigation, "refresh", "재조회", func() -> void: refresh_requested.emit())
	for id: String in ["source", "status", "contract", "mode", "progress", "funds", "procedure"]:
		_label(id)
	_modes = OptionButton.new()
	_modes.name = "ConstructionMode"
	_modes.add_item("표준 공사", 0)
	_modes.add_item("빠른 공사", 1)
	_modes.item_selected.connect(func(_index: int) -> void: _render())
	add_child(_modes)
	controls["mode"] = _modes
	_focus_regions["mode"] = _modes
	_modes.focus_entered.connect(_request_focus_visibility)
	for action: String in ACTIONS:
		var row := VBoxContainer.new()
		add_child(row)
		_button(row, action, ACTIONS[action], _request.bind(action))
		_label(action + "_reason", row)
	_label("history")
	_render()


func _label(id: String, parent: Node = null) -> void:
	var label := Label.new()
	label.name = "Construction_" + id
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	(self if parent == null else parent).add_child(label)
	labels[id] = label


func _button(parent: Node, id: String, text: String, callback: Callable) -> void:
	var button := Button.new()
	button.name = "Construction_" + id
	button.text = text
	button.pressed.connect(callback)
	parent.add_child(button)
	controls[id] = button
	_focus_regions[id] = parent if id in ACTIONS else button
	button.focus_entered.connect(_request_focus_visibility)


func select_project(id: String) -> void:
	selected_id = id
	_render()


## 이전 관측·늦은 실패는 현재 상태와 행동을 덮지 않는다.
func present(packet: Dictionary) -> bool:
	var envelope: Dictionary = packet.get("snapshot", {})
	var view_rev: int = packet.get("view_revision", -1)
	var snap_rev: int = envelope.get("snapshot_revision", -1)
	if view_rev < _view_revision or (snap_rev >= 0 and snap_rev < _snapshot_revision):
		return false
	if packet.get("status") == "READY" and not _valid_envelope(envelope):
		return false
	_view_revision = view_rev
	_snapshot_revision = maxi(_snapshot_revision, snap_rev)
	shown = packet.duplicate(true)
	_ready_data = packet.get("status") == "READY" and envelope.get("available", false)
	for record: Dictionary in packet.get("requests", []):
		accept_result(record)
	_render()
	return true


## 원명령 이력만 갱신한다. 최신 권위 snapshot/버튼은 건드리지 않는다.
func accept_result(record: Dictionary) -> bool:
	var command: Dictionary = record.get("command", {})
	var result: Dictionary = record.get("result", {})
	var id: String = command.get("command_id", "")
	if id.is_empty() or result.get("command_id") != id:
		return false
	if _history.has(id):
		var old: Dictionary = _history[id].result
		if not old.get("pending", false) and result.get("pending", false):
			return false
		if _result_rank(result) < _result_rank(old):
			return false
	_history[id] = record.duplicate(true)
	return true


func _result_rank(result: Dictionary) -> int:
	var value: Variant = result.get("result_revision")
	return value if value is int else -1


func _valid_envelope(value: Dictionary) -> bool:
	return (
		value.get("ui_contract_revision") == "DEV020-W05-UI-1"
		and value.get("rules_version") == "RFC-DEV-020-01-OWNER-20261108"
		and value.get("data_version") == "1.3"
		and value.get("observation_phase") == "T_COMPLETE"
		and value.get("snapshot_revision") is int
		and value.get("simulation_minute") is int
		and value.get("projects") is Array
		and value.get("contract_candidates") is Array
		and value.get("funds") is Dictionary
	)


func _selected(key: String) -> Dictionary:
	if _ready_data:
		for row: Dictionary in shown.snapshot.get(key, []):
			if row.project_id == selected_id:
				return row
	return {}


func _pending() -> bool:
	for record: Dictionary in _history.values():
		if record.command.project_id == selected_id and record.result.get("pending", false):
			return true
	return false


func _request(action: String) -> void:
	if controls[action].disabled or not _ready_data:
		return
	var row := _selected("projects")
	if action == "contract":
		row = _selected("contract_candidates")
	if row.is_empty():
		return
	_sequence += 1
	var confirmed := {
		"project_id": selected_id,
		"business_contract_id": row.business_contract.business_contract_id,
		"snapshot_revision": shown.snapshot.snapshot_revision,
		"target_revision": row.get("condition_revision", row.get("target_revision", -1)),
		"mode": "STANDARD" if _modes.selected == 0 else "FAST"
	}
	command_requested.emit(
		"construction-ui-%d-%d" % [get_instance_id(), _sequence], action, confirmed
	)


func _render() -> void:
	if labels.is_empty():
		return
	labels.title.text = "P05 · 공사/검증/개통 · " + selected_id
	if not shown.get("fixture_label", "").is_empty():
		labels.title.text += " · TEST_ONLY " + shown.fixture_label
	for label: Label in labels.values():
		if label != labels.title:
			label.text = ""
	for action: String in ACTIONS:
		controls[action].disabled = true
		labels[action + "_reason"].text = "권위 자료 없음"
	_modes.disabled = true
	if not _ready_data:
		labels.status.text = (
			"공사 조회 실패: " + str(shown.get("reason", "자료 없음"))
			if shown.get("status") == "FAILED"
			else "공사 자료 없음 · 미활성/미수신을 정상 0으로 처리하지 않습니다."
		)
	else:
		_render_state()
	_render_history()
	for label: Label in labels.values():
		label.visible = not label.text.is_empty()
	_refresh_focus_visibility()


## 행동과 사유 행을 호스트에 전달하며 명령/허용값/시각은 변경하지 않는다.
func focus_region() -> Control:
	if not is_inside_tree():
		return null
	var owner := get_viewport().gui_get_focus_owner()
	for id: String in controls:
		if controls[id] == owner:
			return _focus_regions[id]
	return null


func _request_focus_visibility() -> void:
	var region := focus_region()
	if region != null and region.is_visible_in_tree():
		focus_region_requested.emit(region)


func _refresh_focus_visibility() -> void:
	var region := focus_region()
	if region == null:
		_focus_signature = ""
		return
	var owner := get_viewport().gui_get_focus_owner()
	var reason := ""
	for id: String in controls:
		if controls[id] == owner and labels.has(id + "_reason"):
			reason = labels[id + "_reason"].text
	var signature := "%s/%s/%s" % [owner.get_instance_id(), owner.get("disabled"), reason]
	if signature != _focus_signature:
		_focus_signature = signature
		_request_focus_visibility()


func _render_state() -> void:
	var envelope: Dictionary = shown.snapshot
	labels.source.text = (
		"완료 관측 T=%d / revision %d / %s · 다음 처리 대상 T=%d (공사 계약은 야간 이연 가능)"
		% [
			envelope.simulation_minute,
			envelope.snapshot_revision,
			envelope.observation_phase,
			shown.next_effective_at
		]
	)
	var project := _selected("projects")
	var candidate := _selected("contract_candidates")
	if project.is_empty() and candidate.is_empty():
		labels.status.text = "이 사업의 공사 계약/유효 인계 자료 없음"
		return
	var row: Dictionary = candidate if project.is_empty() else project
	var business: Dictionary = row.business_contract
	var payment: Dictionary = business.get("government_payment", {})
	labels.contract.text = (
		"사업 계약 %s / %s · 효력분 %s\n정부 지급 %s / 금액 %s · 효력분 %s"
		% [
			business.business_contract_id,
			business.status,
			str(business.effective_at),
			str(payment.get("transaction_id", "자료 없음")),
			str(payment.get("amount", "자료 없음")),
			str(payment.get("effective_at", "자료 없음"))
		]
	)
	if project.is_empty():
		labels.status.text = "공사 계약 NOT_CREATED · 착공/진행 없음"
		var mode: String = "STANDARD" if _modes.selected == 0 else "FAST"
		var terms: Array = candidate.modes[mode]
		labels.mode.text = (
			"%s · 공사비 %d / 공기 %d게임분 (실제 착공 효력부터)"
			% [_modes.get_item_text(_modes.selected), terms[0], terms[1]]
		)
		_modes.disabled = _pending()
	else:
		_render_project(project)
	_render_funds(envelope.funds)
	_render_actions(project, candidate)
	_log_observation(project)


func _log_observation(project: Dictionary) -> void:
	var key := JSON.stringify(
		{
			"project_id": selected_id,
			"status": project.get("status"),
			"procedure": project.get("procedure"),
			"trial": project.get("trial_status"),
			"safety": project.get("safety_status"),
			"defects": project.get("defects"),
			"requests": shown.get("requests", [])
		}
	)
	if key != _last_observation:
		_last_observation = key
		print(
			"DEV021_OBSERVATION ",
			JSON.stringify(
				{
					"project_id": selected_id,
					"actual": shown.snapshot,
					"requests": shown.get("requests", []),
					"fixture_label": shown.get("fixture_label", "")
				}
			)
		)


func _render_project(project: Dictionary) -> void:
	labels.status.text = STATES.get(project.status, project.status)
	labels.contract.text += (
		"\n공사 계약 %s / %s · 효력분 %s\n실제 착공 %s / 완공 %s / 개통 %s"
		% [
			project.construction_contract_id,
			project.construction_contract_status,
			str(project.contract_effective_at),
			_time(project.started_at),
			_time(project.completed_at),
			_time(project.opened_at)
		]
	)
	labels.mode.text = (
		"%s · 공사비 %d / 공기 %d게임분 (실제 착공 효력부터)"
		% [
			"표준 공사" if project.mode == "STANDARD" else "빠른 공사",
			project.total_cost,
			project.duration_minutes
		]
	)
	labels.progress.text = (
		"수행 공정 %d / %d게임분\n발생 기성 %d / 실제 지급 %d / 공사 미지급 %d (운영비 B와 별도)"
		% [
			project.elapsed_minutes,
			project.duration_minutes,
			project.accrued,
			project.paid,
			project.construction_payable
		]
	)
	labels.procedure.text = (
		"시범 %s / 안전 %s / 결함 %d개\n현재 절차 %s · 시작 %s / 완료 예정 %s\n수리 지급 총액 %d · 해당 사업 제한자금 우선, 부족분 가용자금"
		% [
			STATES.get(project.trial_status, project.trial_status),
			STATES.get(project.safety_status, project.safety_status),
			project.defects,
			STATES.get(project.procedure, "없음"),
			_time(project.procedure_started_at),
			_time(project.procedure_completes_at),
			project.repair_paid
		]
	)
	if project.procedure.is_empty():
		labels.procedure.text = labels.procedure.text.replace("현재 절차 없음", "현재 절차 없음 (시각은 최근 절차 기록)")


func _render_funds(funds: Dictionary) -> void:
	labels.funds.text = (
		"현재 자금 C %d / R %d / F %d / K %d / A %d / 운영비 B %d\n해당 사업 R %d / K %d"
		% [
			funds.cash,
			funds.restricted,
			funds.free_cash,
			funds.reserved,
			funds.available_cash,
			funds.unpaid,
			funds.restricted_by_project.get(selected_id, 0),
			funds.reserved_by_project.get(selected_id, 0)
		]
	)


func _render_actions(project: Dictionary, candidate: Dictionary) -> void:
	for action: String in ACTIONS:
		var row: Dictionary = candidate if action == "contract" else project
		var allowed: bool = row.get("allowed_actions", {}).get(action, false)
		controls[action].disabled = not allowed or _pending()
		var codes: Array = (
			row.get("reason_codes", [])
			if action == "contract"
			else row.get("action_reason_codes", {}).get(action, [])
		)
		labels[action + "_reason"].text = (
			"선행 요청 최종 결과 대기 · 성공 미확정"
			if _pending()
			else ("요청 가능 · 실제 효력에서 최종 판정" if allowed else _reasons(codes))
		)
		if action == "contract" and allowed:
			labels[action + "_reason"].text += " · 계약만 06:00~24:00, 야간 요청은 다음 06:00 효력"


func _render_history() -> void:
	var lines: Array[String] = []
	for record: Dictionary in _history.values():
		if record.command.project_id != selected_id:
			continue
		var result: Dictionary = record.result
		lines.append(
			(
				"%s · %s · 요청 T=%s / 효력%s %s · %s / %s / 판 %s"
				% [
					record.command.command_id,
					ACTIONS.get(record.command.action, record.command.action),
					str(record.command.requested_at),
					"예정" if result.get("pending", false) else "",
					_time(result.get("effective_at")),
					(
						"처리 대기 · 성공 미확정"
						if result.get("pending", false)
						else (
							"처리 수용"
							if result.get("accepted", false)
							else _reasons(result.get("reason_codes", []))
						)
					),
					str(result.get("decision_phase", "대기")),
					_time(result.get("result_revision"))
				]
			)
		)
	labels.history.text = "명령 이력\n" + "\n".join(lines) if not lines.is_empty() else "명령 이력 없음"


func _reasons(codes: Array) -> String:
	var lines: Array[String] = []
	for code: String in codes:
		lines.append(REASONS.get(code, "행동 제한 사유 확인 필요 (코드: %s)" % code))
	return " / ".join(lines) if not lines.is_empty() else "해당 단계의 권위 허용 없음"


func _time(value: Variant) -> String:
	return "자료 없음/미시작" if value == null else str(value)
