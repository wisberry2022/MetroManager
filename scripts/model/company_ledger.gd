class_name CompanyLedger
extends RefCounted
## 승인 SEM/CLOSE의 경제 효과만 구현한다. 제품 거래 UI는 없다.

var _cash: int = 1000000
var _restricted: Dictionary = {}
var _reserved: Dictionary = {}
var _unpaid: int = 0
var _entries: Array[Dictionary] = []
var _latest_minute: int = -1


func _init(initial: Dictionary = {}) -> void:
	_cash = initial.get("cash", 1000000)
	_restricted = initial.get("restricted_by_project", {}).duplicate(true)
	_reserved = initial.get("reserved_by_project", {}).duplicate(true)
	_unpaid = initial.get("unpaid", 0)


func snapshot() -> Dictionary:
	var restricted: int = _sum(_restricted)
	var reserved: int = _sum(_reserved)
	return {
		"cash": _cash,
		"restricted_by_project": _restricted.duplicate(true),
		"reserved_by_project": _reserved.duplicate(true),
		"restricted": restricted,
		"reserved": reserved,
		"free_cash": _cash - restricted,
		"available_cash": maxi(0, _cash - restricted - reserved),
		"unpaid": _unpaid
	}


func entries() -> Array[Dictionary]:
	return _entries.duplicate(true)


func settle(minute: int) -> int:
	if minute < 0 or minute < _latest_minute:
		return 0
	var paid := mini(_unpaid, int(snapshot().available_cash))
	_cash -= paid
	_unpaid -= paid
	if paid > 0:
		_record("debt_payment", paid, minute)
	return paid


func operating_cost(amount: int, minute: int) -> bool:
	if amount < 0 or minute < 0 or minute < _latest_minute:
		return false
	_unpaid += amount
	if amount > 0:
		_record("operating_cost", amount, minute)
	var paid := mini(_unpaid, int(snapshot().available_cash))
	_cash -= paid
	_unpaid -= paid
	if paid > 0:
		_record("payment", paid, minute)
	return true


func fare(amount: int, minute: int) -> bool:
	if amount < 0 or minute < 0 or minute < _latest_minute:
		return false
	_cash += amount
	_record("fare", amount, minute)
	settle(minute)
	return true


func contract(project: String, government: int, total_cost: int, minute: int) -> Dictionary:
	var before := snapshot()
	if (
		project.is_empty()
		or government < 0
		or total_cost < 0
		or minute < 0
		or minute < _latest_minute
	):
		return {"accepted": false, "reason": "INVALID_CONTRACT", "decision_funds": before}
	if _restricted.has(project) or _reserved.has(project):
		return {"accepted": false, "reason": "DUPLICATE_PROJECT", "decision_funds": before}
	var own := maxi(0, total_cost - government)
	# 미지급 우선 의무는 검사하되 A 정의는 변경하지 않는다.
	if maxi(0, int(before.available_cash) - _unpaid) < own:
		return {"accepted": false, "reason": "OWN_FUNDS_INSUFFICIENT", "decision_funds": before}
	settle(minute)
	_cash += government
	_restricted[project] = government
	_reserved[project] = own
	_record("government", government, minute)
	return {"accepted": true, "reason": "", "decision_funds": before}


func construction_payment(project: String, amount: int, minute: int) -> bool:
	if (
		amount < 0
		or minute < 0
		or minute < _latest_minute
		or not _restricted.has(project)
		or not _reserved.has(project)
	):
		return false
	var restricted: int = _restricted[project]
	var own := maxi(0, amount - restricted)
	if own > int(_reserved[project]) or amount > _cash:
		return false
	_restricted[project] = maxi(0, restricted - amount)
	_reserved[project] -= own
	_cash -= amount
	_record("construction_cost", amount, minute)
	_record("construction_payment", amount, minute)
	return true


func boarding(minute: int, next_cost: int, eligible: bool = true) -> Dictionary:
	var reason := ""
	if minute % 1440 < 360:
		reason = "OUTSIDE_SERVICE_HOURS"
	elif not eligible:
		reason = "SERVICE_NOT_READY"
	elif _unpaid > 0:
		reason = "UNPAID_BALANCE"
	elif next_cost < 0 or int(snapshot().available_cash) < next_cost:
		reason = "SERVICE_FUNDS_INSUFFICIENT"
	return {"boarding_allowed": reason.is_empty(), "reason_codes": [reason] if reason else []}


func _record(kind: String, amount: int, minute: int) -> void:
	_latest_minute = minute
	_entries.append({"kind": kind, "amount": amount, "effective_at": minute})


func _sum(values: Dictionary) -> int:
	var total: int = 0
	for value: int in values.values():
		total += value
	return total
