class_name PublicTender
extends RefCounted
## 공고별 접수/판정/사업 계약의 사본. 공사 계약은 W05에서 별도로 생성한다.

var _terms: Dictionary
var _revision: int = 0
var _receipt: Dictionary = {}
var _decision: Dictionary = {}
var _contract: Dictionary = {}
var _closed: bool = false


func _init(terms: Dictionary) -> void:
	_terms = terms.duplicate(true)


func terms() -> Dictionary:
	return _terms.duplicate(true)


func revision() -> int:
	return _revision


func received() -> bool:
	return not _receipt.is_empty()


func closed() -> bool:
	return _closed


func receive(receipt: Dictionary) -> void:
	if not received() and not _closed:
		_receipt = receipt.duplicate(true)
		_revision += 1


func decide(decision: Dictionary) -> void:
	if not _closed:
		_closed = true
		_decision = decision.duplicate(true)
		_revision += 1


func record_contract(contract: Dictionary) -> void:
	if _decision.get("awarded", false) and _contract.is_empty():
		_contract = contract.duplicate(true)
		_revision += 1


## 자격의 숫자 문턱이나 접수 후 자동 박탈 제재를 추가하지 않는다.
func eligibility(city: String, active: bool, duration: int) -> Dictionary:
	var checks := {
		"jurisdiction": city == _terms.city_id,
		"no_active_project": not active,
		"duration_feasible": duration <= int(_terms.duration_minutes) and duration > 0
	}
	var reasons: Array[String] = []
	if not checks.jurisdiction:
		reasons.append("OUTSIDE_JURISDICTION")
	if not checks.no_active_project:
		reasons.append("PROJECT_IN_PROGRESS")
	if not checks.duration_feasible:
		reasons.append("DURATION_NOT_FEASIBLE")
	return {"eligible": reasons.is_empty(), "checks": checks, "reason_codes": reasons}


func snapshot(minute: int, eligibility_now: Dictionary) -> Dictionary:
	var state := "OPEN" if minute >= int(_terms.opens_at) else "NOT_OPEN"
	if received():
		state = "RECEIVED"
	if _closed:
		state = "AWARDED" if _decision.get("awarded", false) else "CLOSED"
	var reasons: Array = eligibility_now.reason_codes.duplicate()
	if _closed or minute >= int(_terms.closes_at):
		reasons.append("ROUND_CLOSED")
	elif received():
		reasons.append("DUPLICATE_BID")
	elif minute < int(_terms.opens_at):
		reasons.append("NOT_OPEN")
	var valid: bool = _contract.get("status") == "EFFECTIVE"
	return {
		"terms": terms(),
		"target_revision": _revision,
		"plan_revision": 0,
		"plan_locked": true,
		"state": state,
		"eligibility": eligibility_now.duplicate(true),
		"reason_codes": reasons,
		"allowed_actions": {"submit_bid": reasons.is_empty(), "enter_p05": valid},
		"receipt": _receipt.duplicate(true),
		"decision": _decision.duplicate(true),
		"business_contract": _contract.duplicate(true),
		"construction_contract": {"available": false, "status": "NOT_CREATED"},
		"p05_reason_codes": [] if valid else ["BUSINESS_CONTRACT_NOT_EFFECTIVE"]
	}


## 정확한 유리수: 표시 점수=비교분자/100000. float 반올림을 판정에 쓰지 않는다.
static func score(free_cash: int, capability: int) -> Dictionary:
	var financial_numerator := clampi(free_cash, 0, 1000000)
	var comparison_numerator := 7 * capability * 10000 + 3 * financial_numerator
	return {
		"free_cash": free_cash,
		"capability": capability,
		"financial_score": {"numerator": financial_numerator, "denominator": 10000},
		"comparison_score": {"numerator": comparison_numerator, "denominator": 10000},
		"display_score": {"numerator": comparison_numerator, "denominator": 100000}
	}
