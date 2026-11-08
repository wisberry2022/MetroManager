extends VBoxContainer
## A01 권위 공급 소비만 담당한다. 요청 전송 허용과 실제 유효 접수는 별개다.

signal bid_requested(id: String, tender_id: String, confirmed: Dictionary)
signal refresh_requested
signal exit_requested

const STATES := {
	"NOT_OPEN": "접수 시작 전",
	"OPEN": "공고 접수 중 (접수 미확정)",
	"RECEIVED": "유효 접수 완료 · 마감 판정 대기",
	"AWARDED": "낙찰",
	"CLOSED": "접수 종료"
}
const REASONS := {
	"ROUND_CLOSED": "접수기간 종료",
	"NOT_OPEN": "접수기간 시작 전",
	"DUPLICATE_BID": "이미 접수된 회차",
	"STATE_CHANGED": "확인한 조건 변경 · 재확인 필요",
	"PROJECT_IN_PROGRESS": "다른 사업 진행 중",
	"DURATION_NOT_FEASIBLE": "공기 이행 불가",
	"OUTSIDE_JURISDICTION": "관할 불일치",
	"TIE_PRIORITY": "동점 · 공개 우선순위에 따라 경쟁자 우선",
	"LOWER_SCORE": "경쟁자보다 낮은 점수",
	"NOT_SUBMITTED": "미응찰 종료"
}

var controls: Dictionary = {}
var labels: Dictionary = {}
var shown: Dictionary = {}
var selected_id: String = ""
var page: String = "P01"
var _list: ItemList
var _list_rows: Array[String] = []
var _view_revision: int = -1
var _snapshot_revision: int = -1
var _sequence: int = 0
var _rows: Array = []
var _ready_data: bool = false
var _history: Dictionary = {}
var _log_signatures: Dictionary = {}


func _ready() -> void:
	_label("title", "공공입찰 · P01")
	var navigation := HBoxContainer.new()
	add_child(navigation)
	_button(navigation, "back", "목록으로", _back)
	_button(navigation, "refresh", "재조회", func() -> void: refresh_requested.emit())
	_button(navigation, "exit", "S01 노선 계획으로", func() -> void: exit_requested.emit())
	_label("source", "")
	_label("status", "")
	_list = ItemList.new()
	_list.custom_minimum_size = Vector2(0, 100)
	_list.item_selected.connect(_select_index)
	_list.item_activated.connect(
		func(index: int) -> void:
			_select_index(index)
			_open_detail()
	)
	add_child(_list)
	_button(self, "detail", "선택 공고 상세 확인", _open_detail)
	_label("summary", "공고를 선택하세요.")
	_label("criteria", "")
	_label("timing", "")
	_label("eligibility", "")
	var actions := HBoxContainer.new()
	add_child(actions)
	_button(actions, "submit", "응찰 요청", _request)
	_button(actions, "handoff", "P05 인계 정보 확인", _handoff)
	_label("request", "")
	_label("decision", "")
	_label("contract", "")
	_label("payment", "")
	_label("funds", "")
	_label("handoff", "")
	_render()


func _label(id: String, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(label)
	labels[id] = label


func _button(parent: Node, id: String, text: String, action: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.name = "Tender_" + id
	button.pressed.connect(action)
	parent.add_child(button)
	controls[id] = button


## 새 관측만 현재 화면에 적용한다. 늦은 결과는 원명령 이력에만 귀속한다.
func present(packet: Dictionary) -> bool:
	var view_rev: int = packet.get("view_revision", -1)
	var envelope: Dictionary = packet.get("snapshot", {})
	var snap_rev: int = envelope.get("snapshot_revision", -1)
	if view_rev < _view_revision or (snap_rev >= 0 and snap_rev < _snapshot_revision):
		return false
	if packet.get("status") == "READY" and not _valid_envelope(envelope):
		return false
	_view_revision = view_rev
	_snapshot_revision = maxi(_snapshot_revision, snap_rev)
	shown = packet.duplicate(true)
	for record: Dictionary in packet.get("requests", []):
		accept_result(record)
	_ready_data = packet.get("status") == "READY" and envelope.get("available", false)
	_rows = envelope.get("tenders", []).duplicate(true) if _ready_data else []
	_render()
	return true


## 이력 수신은 현재 snapshot/선택/행동을 변경하지 않는다.
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
		if int(result.get("result_revision", -1)) < int(old.get("result_revision", -1)):
			return false
	_history[id] = record.duplicate(true)
	return true


func _valid_envelope(value: Dictionary) -> bool:
	return (
		value.get("ui_contract_revision") == "DEV018-W04A-UI-1"
		and value.get("rules_version") == "C0.6-D0.9-DATA1.3"
		and value.get("data_version") == "1.3"
		and value.get("observation_phase") == "T_COMPLETE"
		and value.get("snapshot_revision") is int
		and value.get("simulation_minute") is int
		and value.get("tenders") is Array
	)


func _select_index(index: int) -> void:
	if index >= 0 and index < _rows.size():
		selected_id = _rows[index].terms.tender_id
		_render()


func _open_detail() -> void:
	if _ready_data and not _selected().is_empty():
		page = "P02"
		_render()
		if not controls.submit.disabled:
			controls.submit.grab_focus()
		else:
			controls.back.grab_focus()


func _back() -> void:
	page = "P01" if page == "P02" else "P02"
	_render()
	if page == "P01":
		_list.grab_focus()
	else:
		controls.back.grab_focus()


func _handoff() -> void:
	if not _ready_data or controls.handoff.disabled:
		return
	page = "P05"
	_render()
	controls.back.grab_focus()


func _request() -> void:
	var row := _selected()
	if not _ready_data or row.is_empty() or controls.submit.disabled:
		return
	_sequence += 1
	var confirmed := {
		"round_id": row.terms.round_id,
		"plan_revision": row.plan_revision,
		"target_revision": row.target_revision,
		"snapshot_revision": shown.snapshot.snapshot_revision
	}
	bid_requested.emit("bid-ui-%d-%d" % [get_instance_id(), _sequence], selected_id, confirmed)


func _selected() -> Dictionary:
	for row: Dictionary in _rows:
		if row.terms.tender_id == selected_id:
			return row
	return {}


func _render() -> void:
	if labels.is_empty():
		return
	var envelope: Dictionary = shown.get("snapshot", {})
	labels.title.text = "공공입찰 · " + page
	if not shown.get("fixture_label", "").is_empty():
		labels.title.text += " · 검증 전용: " + shown.fixture_label
	for label: Label in labels.values():
		label.visible = true
	labels.source.text = ""
	if envelope.has("simulation_minute"):
		labels.source.text = (
			"현재 완료 관측 · 게임분 %d / snapshot %d / %s"
			% [envelope.simulation_minute, envelope.snapshot_revision, envelope.observation_phase]
		)
	labels.status.text = ""
	if not _ready_data:
		labels.status.text = (
			"공고 조회 실패: " + str(shown.get("reason", "자료 없음"))
			if shown.get("status") == "FAILED"
			else "자료 없음: 공고 정보를 사용할 수 없습니다."
		)
	elif _rows.is_empty():
		labels.status.text = "현재 관할의 공고가 없습니다."
	var texts: Array[String] = []
	for row: Dictionary in _rows:
		texts.append(
			(
				"%s · %s · %s · 마감 게임분 %d"
				% [
					row.terms.tender_id,
					_issuer(row.terms.issuer_id),
					STATES.get(row.state, row.state),
					row.terms.closes_at
				]
			)
		)
	if texts != _list_rows:
		_list_rows = texts
		_list.clear()
		for text: String in texts:
			_list.add_item(text)
	var row := _selected()
	if row.is_empty() and not selected_id.is_empty() and _ready_data:
		selected_id = ""
		page = "P01"
		labels.status.text = "선택한 공고가 없어졌습니다. 다른 공고를 확인하세요."
	for index: int in _rows.size():
		if _rows[index].terms.tender_id == selected_id:
			_list.select(index)
	_list.visible = page == "P01"
	controls.detail.visible = page == "P01"
	controls.detail.disabled = row.is_empty() or not _ready_data
	controls.back.visible = page != "P01"
	controls.back.text = "목록으로" if page == "P02" else "공고 상세로"
	for key: String in [
		"summary",
		"criteria",
		"timing",
		"eligibility",
		"request",
		"decision",
		"contract",
		"payment",
		"funds",
		"handoff"
	]:
		labels[key].text = ""
	controls.submit.visible = page == "P02"
	controls.handoff.visible = page == "P02"
	controls.submit.disabled = true
	controls.handoff.disabled = true
	if row.is_empty() or not _ready_data:
		labels.summary.text = "공고를 선택하세요." if _ready_data else "현재 공고 자료 없음"
		_hide_empty_labels()
		return
	_render_row(row)
	_hide_empty_labels()


func _render_row(row: Dictionary) -> void:
	var terms: Dictionary = row.terms
	labels.summary.text = (
		"%s / %s / %s · %s · 고정 조건 (읽기 전용)\n운임 %d / 정부금 %d / 공기 %d게임분 (계약 효력부터)\n노선: %s · 접수 [%d, %d)게임분"
		% [
			terms.tender_id,
			terms.round_id,
			terms.project_id,
			_issuer(terms.issuer_id),
			terms.fare,
			terms.government,
			terms.duration_minutes,
			" → ".join(terms.station_ids),
			terms.opens_at,
			terms.closes_at
		]
	)
	if page == "P01":
		return
	_render_criteria(row)
	var pending := false
	var request_lines: Array[String] = []
	for record: Dictionary in _history.values():
		if record.command.tender_id != selected_id or record.command.round_id != terms.round_id:
			continue
		var result: Dictionary = record.result
		pending = pending or result.get("pending", false)
		var state := (
			"요청 처리 대기 · 접수 미확정"
			if result.get("pending", false)
			else (
				"유효 접수 완료"
				if result.get("accepted", false)
				else "응찰 접수 거부: " + _reason(result.get("reason", ""))
			)
		)
		request_lines.append(
			(
				"%s · 요청분 %d / 처리%s %s · %s"
				% [
					record.command.command_id,
					record.command.requested_at,
					"예정" if result.get("pending", false) else "효력분",
					str(result.get("effective_at", "없음")),
					state
				]
			)
		)
	labels.request.text = (
		"요청 이력\n" + "\n".join(request_lines) if not request_lines.is_empty() else "요청 이력 없음"
	)
	controls.submit.disabled = not row.allowed_actions.submit_bid or pending
	controls.handoff.disabled = (
		not row.allowed_actions.enter_p05
		or not row.business_contract.get("government_payment", {}).get("available", false)
	)
	labels.timing.text = (
		"마감 T=%d / 지금 요청의 처리 예정 T=%d\n최종 접수 여부는 실제 효력 단계에서 결정됩니다. 요청 전송은 접수 성공 보장이 아닙니다."
		% [terms.closes_at, shown.next_effective_at]
	)
	labels.eligibility.text = (
		"현재 상태: %s · 자격: %s · 계획: 고정/읽기 전용\n현재 행동 사유\n%s"
		% [
			STATES.get(row.state, row.state),
			"충족" if row.eligibility.eligible else "미충족",
			_current_reasons(row.reason_codes)
		]
	)
	if not row.receipt.is_empty():
		labels.request.text += (
			"\n접수 당시 사본 · 실제 접수분 %d / 당시 F %d / 결과판 %d"
			% [
				row.receipt.effective_at,
				row.receipt.admission_snapshot.funds.free_cash,
				row.receipt.result_revision
			]
		)
	_render_decision(row.decision)
	_render_contract(row)
	var funds: Dictionary = shown.funds
	labels.funds.text = (
		"현재 자금 (마감 당시 판정과 별도) · C %d / R %d / F %d / K %d / A %d / B %d"
		% [
			funds.cash,
			funds.restricted,
			funds.free_cash,
			funds.reserved,
			funds.available_cash,
			funds.unpaid
		]
	)
	if page == "P05":
		for id: String in ["criteria", "timing", "eligibility", "request", "decision"]:
			labels[id].text = ""
		labels.handoff.text = (
			(
				"P05 읽기 전용 인계\n사업 %s / 공사 계약: NOT_CREATED (미체결)"
				+ "\n착공·공정·검증 기능은 후속 단계에서 제공됩니다. 이 화면 이동은 계약/지급/착공을 실행하지 않습니다."
			)
			% terms.project_id
		)
	var signature := JSON.stringify(
		{
			"state": row.state,
			"decision": row.decision,
			"contract": row.business_contract,
			"requests": request_lines
		}
	)
	if _log_signatures.get(selected_id) != signature:
		_log_signatures[selected_id] = signature
		print(
			"DEV019_OBSERVATION ",
			JSON.stringify(
				{
					"tender_id": selected_id,
					"snapshot_revision": shown.snapshot.snapshot_revision,
					"simulation_minute": shown.snapshot.simulation_minute,
					"row": row,
					"funds": funds
				}
			)
		)


func _render_criteria(row: Dictionary) -> void:
	var value: Dictionary = shown.get("evaluation_criteria", {}).get(row.terms.tender_id, {})
	var lines: Array[String] = ["공고의 공개 평가 기준"]
	if row.decision.is_empty():
		lines.append("입찰 결과는 아직 확정되지 않았습니다.")
	lines.append("평가 시점: 공고 마감 시점의 자격·자금 상태")
	lines.append("자유현금 F = 현재 현금 C − 사업별 제한자금 R의 합계 (F의 실제 평가값은 마감 시점 기준)")
	lines.append("재무점수 = F ÷ 10,000을 0~100점 범위로 제한")
	lines.append("공개점수 = (7 × 이행능력 점수 + 3 × 재무점수) ÷ 10")
	if value.is_empty():
		lines.append("경쟁자 평가 자료 없음")
	else:
		lines.append(
			(
				"경쟁자 공개점수 %s점 (이행능력 %d점 / 재무점수 %d점)"
				% [
					exact_decimal(value.competitor_display_score),
					value.competitor_capability,
					value.competitor_financial_score
				]
			)
		)
	var priority: Array[String] = []
	for role: String in row.terms.tie_priority:
		priority.append({"COMPETITOR": "경쟁자", "PLAYER": "플레이어"}.get(role, role))
	lines.append("동점 시 우선순위: " + " → ".join(priority))
	lines.append("실제 낙찰 여부는 마감 시점 판정으로 결정됩니다. 이 기준은 현재 플레이어의 확정 결과가 아닙니다.")
	labels.criteria.text = "\n".join(lines)


func _current_reasons(codes: Array) -> String:
	var lines: Array[String] = []
	for code: String in codes:
		lines.append(_reason(code))
	return "\n".join(lines) if not lines.is_empty() else "현재 거부 사유 없음"


func _render_decision(decision: Dictionary) -> void:
	labels.decision.text = "마감 판정: 자료 없음 (미판정)"
	if decision.is_empty():
		return
	var score: Dictionary = decision.score
	labels.decision.text = (
		(
			"마감 판정 당시 · 게임분 %d / 결과판 %d · %s\nF %d / 이행능력 %d / 재무점수 %s점"
			+ "\n공개점수 %s : %s점 / 내부 비교 %s : %s\n동점 우선순위: 경쟁자 → 플레이어 · %s"
		)
		% [
			decision.effective_at,
			decision.result_revision,
			"낙찰" if decision.awarded else _reason(decision.reason),
			score.free_cash,
			score.capability,
			exact_decimal(score.financial_score),
			exact_decimal(score.display_score),
			exact_decimal(
				{
					"numerator": decision.competitor_comparison.numerator,
					"denominator": decision.competitor_comparison.denominator * 10
				}
			),
			exact_decimal(score.comparison_score),
			exact_decimal(decision.competitor_comparison),
			_reason(decision.reason)
		]
	)


func _render_contract(row: Dictionary) -> void:
	var contract: Dictionary = row.business_contract
	labels.contract.text = "사업 계약: 자료 없음 (미체결)"
	labels.payment.text = "정부 지급: 자료 없음 (미지급)"
	if contract.is_empty():
		return
	labels.contract.text = (
		"사업 계약 %s · %s · 실제 효력분 %s"
		% [contract.business_contract_id, contract.status, str(contract.effective_at)]
	)
	var payment: Dictionary = contract.get("government_payment", {})
	if payment.get("available", false):
		labels.payment.text = (
			"정부 지급 %s · 금액 %d · 효력분 %s / 제한금 사업 %s"
			% [
				payment.transaction_id,
				payment.amount,
				str(payment.effective_at),
				payment.restricted_project_id
			]
		)
	else:
		labels.payment.text = "정부 지급 자료 없음 (완료로 간주하지 않음)"


## 공급된 유한소수 비율만 문자열로 바꾼다. 경제 공식/반올림/float 사용 없음.
static func exact_decimal(value: Dictionary) -> String:
	var numerator: int = value.get("numerator", 0)
	var denominator: int = value.get("denominator", 0)
	if denominator <= 0 or numerator < 0:
		return "자료 없음"
	var integer: int = numerator / denominator
	var remainder: int = numerator % denominator
	var fraction := ""
	for digit: int in 8:
		if remainder == 0:
			break
		remainder *= 10
		fraction += str(remainder / denominator)
		remainder %= denominator
	return (
		str(integer) + ("." + fraction if not fraction.is_empty() else "")
		if remainder == 0
		else "자료 없음"
	)


func _issuer(id: String) -> String:
	return {"CITY_HALL": "C01 시청", "NATIONAL_GOVERNMENT": "C01 소재 정부"}.get(id, id)


func _reason(id: String) -> String:
	return REASONS.get(id, "행동 제한 사유를 확인할 수 없습니다 (코드: %s)" % id if not id.is_empty() else "")


func _hide_empty_labels() -> void:
	for label: Label in labels.values():
		label.visible = not label.text.is_empty()
