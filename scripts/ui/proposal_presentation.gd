extends RefCounted
## 공급된 사본·시각·행동만 표현한다. 심사 판정이나 효력 시각을 생성하지 않는다.

const Operations = preload("res://scripts/ui/operations_view.gd")
const ACTIONS := {
	"submit_city_review": "시청 심사 요청",
	"submit_government_review": "정부 심사 요청",
	"submit_persuasion": "설득 요청",
	"sign_proposal_contract": "사업계약 요청",
}
const KINDS := {"CITY": "시청", "GOVERNMENT": "정부", "PERSUASION": "설득"}
const OUTCOMES := {"APPROVED": "승인", "HELD": "보류", "REJECTED": "거부"}
const REASONS := {
	"PLAN_LOCKED": "심사 중 · 편집 잠금",
	"REVIEW_IN_PROGRESS": "심사가 진행 중입니다",
	"BUSINESS_REVIEW_IN_PROGRESS": "같은 사업의 심사가 진행 중입니다",
	"BUSINESS_ALREADY_CONTRACTED": "이미 계약한 사업입니다",
	"BUSINESS_ALREADY_AUTHORIZED": "이미 허가한 사업입니다",
	"CURRENT_CITY_APPROVAL_REQUIRED": "현재 계획의 시청 승인이 필요합니다",
	"HELD_DECISION_REQUIRED": "정부 보류 판정이 필요합니다",
	"PERSUASION_ALREADY_USED": "이번 보류의 설득 기회를 사용했습니다",
	"PERSUASION_REQUIRED": "보류된 사업은 설득 결과를 확인하세요",
	"NEW_FACT_REQUIRED_DI03_PENDING": "추가 사실 자료 미공급 · 재접수 제한",
	"PERMISSION_REQUIRED": "정부 허가가 필요합니다",
	"PROJECT_IN_PROGRESS": "진행 중인 사업을 먼저 완료하세요",
	"STALE_PLAN_OR_PREDICTION": "요청 후 계획 또는 예측이 변경됐습니다",
	"STALE_DECISION": "심사 결과가 변경됐습니다",
	"PREDICTION_NOT_CURRENT": "현재 계획의 예측이 필요합니다",
	"INVALID_PLAN": "노선 조건을 확인하세요",
	"STATION_COUNT": "서로 다른 역 6~8개가 필요합니다",
	"DUPLICATE_STATION": "중복된 역이 있습니다",
	"DISCONNECTED": "연결되지 않은 역 구간이 있습니다",
	"OUTSIDE_JURISDICTION": "관할에 없는 역입니다",
	"INSUFFICIENT_AVAILABLE_CASH": "사용 가능한 자금이 부족합니다",
	"INSUFFICIENT_FREE_CASH": "자유 자금이 부족합니다",
}


static func reason(code: String) -> String:
	return REASONS.get(code, "상태를 확인할 수 없습니다")


static func reasons(codes: Array) -> String:
	var messages: PackedStringArray = []
	for code: String in codes:
		messages.append(reason(code))
	return " / ".join(messages)


static func time_text(value: Variant) -> String:
	if not value is int or value < 0:
		return "미확인"
	return "게임일 %d %02d:%02d" % [value / 1440 + 1, (value / 60) % 24, value % 60]


static func prediction(value: Dictionary) -> String:
	var status: String = value.get("prediction_status", "")
	var label: String = (
		{"NOT_CALCULATED": "예측 전", "CALCULATING": "예측 계산 중", "FAILED": "예측 실패", "READY": "현재 예측"}
		. get(status, "예측 상태 미확인")
	)
	if value.get("available", false):
		label += "\n" + _prediction_value(value.current)
	var old: Dictionary = value.get("previous", {})
	if not old.is_empty():
		label += "\n이전 예측 (비교용 · 현재 제출 근거 아님)\n" + _prediction_value(old)
	return label


static func _prediction_value(value: Dictionary) -> String:
	var totals: Dictionary = value.get("value", {}).get("totals", {})
	if not totals.has("predicted_fare") or not totals.has("operating_cost"):
		return "예측 자료 미확인"
	return (
		Operations.prediction_value(value)
		+ (
			"\n시청 사업성: 예상 하루 운임 %s − 운영비 %s (게임 통화 단위 · 공사비와 별도)"
			% [str(totals.predicted_fare), str(totals.operating_cost)]
		)
	)


static func request_text(records: Array, slot: String) -> String:
	var lines: PackedStringArray = []
	for record: Dictionary in records:
		var command: Dictionary = record.get("command", {})
		if command.get("slot_id") != slot:
			continue
		lines.append(
			(
				"%s · 요청 %s / 등록 %s"
				% [
					ACTIONS.get(command.get("action"), "요청"),
					time_text(record.get("requested_at")),
					time_text(record.get("registered_at"))
				]
			)
		)
		if record.get("pending", false):
			lines.append(
				(
					"접수 대기 · 접수 가능 최저 시각 %s (성공 보장 아님 · 효력 단계 재검사)"
					% time_text(record.get("effective_not_before"))
				)
			)
		elif record.get("accepted", false):
			lines.append(
				(
					"실제 접수 %s / 효력 처리 %s"
					% [time_text(record.get("admitted_at")), time_text(record.get("effective_at"))]
				)
			)
		else:
			lines.append("당시 요청 처리 실패: " + reason(record.get("reason", "")))
			if record.get("requires_new_request", false):
				lines.append("새 요청 필요 · 현재 행동 가능 여부는 아래 버튼 사유 확인")
	return "요청 이력 없음" if lines.is_empty() else "\n".join(lines)


static func review_text(row: Dictionary) -> String:
	var review: Dictionary = row.review
	if review.is_empty():
		return "진행 중인 심사 없음"
	return (
		"%s 심사 중 · 편집 잠금\n실제 접수 %s → 완료 예정 %s\n심사 당시 계획: %s"
		% [
			KINDS.get(review.kind, "심사"),
			time_text(review.admitted_at),
			time_text(review.completes_at),
			plan_text(review.submission)
		]
	)


static func plan_text(copy: Dictionary) -> String:
	return (
		"%s · %s"
		% [copy.get("name", "이름 없음"), " → ".join(copy.get("plan", {}).get("station_ids", []))]
	)


static func decisions_text(row: Dictionary) -> String:
	var lines: PackedStringArray = []
	for decision: Dictionary in row.decisions:
		lines.append(
			(
				"당시 %s 판정: %s · 완료 %s\n당시 계획: %s"
				% [
					KINDS.get(decision.kind, "심사"),
					OUTCOMES.get(decision.outcome, "미확인"),
					time_text(decision.completed_at),
					plan_text(decision.submission)
				]
			)
		)
		if decision.kind == "CITY":
			lines.append(prediction(decision.submission.prediction))
		elif decision.outcome == "APPROVED":
			lines.append("허가 금액 %d (게임 통화 단위 · 실제 지급과 별도)" % decision.authorized_government)
		elif decision.outcome == "HELD":
			lines.append(
				(
					"보류 당시 계획 유지 · 설득 기회: "
					+ ("접수·사용 완료" if decision.decision_id in row.persuasion_used_for else "미사용 1회")
				)
			)
	return "당시 심사 결과 없음" if lines.is_empty() else "\n".join(lines)


static func contract_text(row: Dictionary) -> String:
	var contract: Dictionary = row.business_contract
	if contract.is_empty():
		return "사업계약 미효력 · 정부 지급 미확인 (허가만으로 지급·착공하지 않음)"
	var payment: Dictionary = contract.government_payment
	return (
		"사업계약 효력 %s\n허가 계획: %s\n실제 정부 지급 %s · %s\n공사계약·착공은 P05에서 별도"
		% [
			time_text(contract.effective_at),
			plan_text(contract.permitted_plan),
			str(payment.get("amount", "미확인")),
			time_text(payment.get("effective_at"))
		]
	)
