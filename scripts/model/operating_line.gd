class_name OperatingLine
extends RefCounted
## 실제 OD/carry/cohort와 일별 운행 실적만 소유한다. 현금은 Pipeline의 원장이 소유한다.

const Predictor = preload("res://scripts/simulation/demand_predictor.gd")
const MAX_INT: int = 9223372036854775807

var _source: Dictionary
var _pairs: Array[Dictionary]
var _carry: Dictionary = {}
var _cohorts: Array[Dictionary] = []
var _days: Dictionary = {}
var _closed: Dictionary = {}
var _satisfaction: Array = [50, 1]
var _last_board: int = -1
var _last_arrival: int = -1


func _init(source: Dictionary, pairs: Array[Dictionary]) -> void:
	_source = source.duplicate(true)
	_pairs = pairs.duplicate(true)
	_pairs.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a.id < b.id)
	for pair: Dictionary in _pairs:
		_carry[pair.id] = 0


## 권위 ID/역은 고정하고 조건 revision과 개통 시각만 전진시킨다.
func reconcile_source(source: Dictionary) -> bool:
	for key: String in [
		"project_id", "business_contract_id", "construction_contract_id", "station_ids"
	]:
		if source.get(key) != _source.get(key):
			return false
	if source.get("condition_revision", -1) < _source.condition_revision:
		return false
	if (
		source.condition_revision == _source.condition_revision
		and source.get("opened_at") != null
		and _source.get("opened_at") != null
		and source.get("opened_at") != _source.get("opened_at")
	):
		return false
	_source = source.duplicate(true)
	return true


func board(minute: int, allowed: bool, capacity: int) -> Dictionary:
	if (
		minute <= _last_board
		or minute < _last_arrival
		or minute < 0
		or capacity < 0
		or _closed.has(minute / 1440 + 1)
	):
		return {"accepted": false, "reason": "CLOSED_OPERATIONS_TIME"}
	_last_board = minute
	var day := minute / 1440 + 1
	_ensure_day(day)
	var counts := {"requested": 0, "boarded": 0, "unboarded": 0}
	var remaining := capacity if allowed else 0
	for pair: Dictionary in _pairs:
		var numerator: int = (
			_carry[pair.id] + pair.daily_demand * Predictor.selection_tenths(pair.minutes)
		)
		var requested: int = numerator / Predictor.DENOMINATOR
		_carry[pair.id] = numerator % Predictor.DENOMINATOR
		var boarded := mini(requested, remaining)
		remaining -= boarded
		counts.requested += requested
		counts.boarded += boarded
		counts.unboarded += requested - boarded
		if boarded > 0:
			_cohorts.append(
				{
					"od_id": pair.id,
					"boarded_at": minute,
					"expected_at": minute + pair.minutes,
					"count": boarded
				}
			)
	for key: String in counts:
		_days[day][key] += counts[key]
	if allowed:
		_days[day].service_minutes += 1
	return {"accepted": true, "counts": counts}


## 예정 시각을 넘긴 cohort도 한 번만 완료한다. 정상 경로는 모든 분을 처리하므로 지연0이다.
func arrive(minute: int) -> Dictionary:
	if (
		minute <= _last_arrival
		or minute <= _last_board
		or minute < 0
		or _closed.has(minute / 1440 + 1)
	):
		return {"accepted": false, "completed": 0, "late_completed": 0}
	_last_arrival = minute
	var day := minute / 1440 + 1
	_ensure_day(day)
	var completed := 0
	var late := 0
	var pending: Array[Dictionary] = []
	for cohort: Dictionary in _cohorts:
		if cohort.expected_at <= minute:
			completed += int(cohort.count)
			if cohort.expected_at < minute:
				late += int(cohort.count)
		else:
			pending.append(cohort)
	_cohorts = pending
	_days[day].completed += completed
	_days[day].late_completed += late
	return {"accepted": true, "completed": completed, "late_completed": late}


func daily(day: int) -> Dictionary:
	if _closed.has(day):
		return _closed[day].duplicate(true)
	var value: Dictionary = _days.get(day, _blank(day)).duplicate(true)
	value.closing_in_transit = _in_transit()
	return value


func close_day(day: int) -> Dictionary:
	if _closed.has(day):
		return daily(day)
	_ensure_day(day)
	var value := daily(day)
	var next := _satisfaction.duplicate()
	if value.requested > 0 and not next.is_empty():
		next = add_fraction(next, [5 * (value.boarded - value.unboarded), value.requested])
		if value.completed > 0 and not next.is_empty():
			next = add_fraction(next, [-2 * value.late_completed, value.completed])
		if not next.is_empty():
			if next[0] < 0:
				next = [0, 1]
			elif next[0] / next[1] >= 100:
				next = [100, 1]
	value.satisfaction_after = next.duplicate()
	value.satisfaction_available = not next.is_empty()
	value.reason_codes = [] if not next.is_empty() else ["SATISFACTION_ARITHMETIC_LIMIT"]
	_satisfaction = next
	_closed[day] = value.duplicate(true)
	return value


func snapshot() -> Dictionary:
	return {
		"source": _source.duplicate(true),
		"od_pairs": _pairs.duplicate(true),
		"carry": _carry.duplicate(true),
		"in_transit": _in_transit(),
		"cohorts": _cohorts.duplicate(true),
		"satisfaction": _satisfaction.duplicate()
	}


## 약분 후에도 int64에 담을 수 없으면 자료 실패를 반환하며 근사값을 만들지 않는다.
static func add_fraction(a: Array, b: Array) -> Array:
	if a.size() != 2 or b.size() != 2:
		return []
	for value: Variant in a + b:
		if not value is int or value < -MAX_INT:
			return []
	if a[1] <= 0 or b[1] <= 0:
		return []
	var divisor := _gcd(a[1], b[1])
	var x: int = b[1] / divisor
	var y: int = a[1] / divisor
	if absi(a[0]) > MAX_INT / x or absi(b[0]) > MAX_INT / y or a[1] > MAX_INT / x:
		return []
	var left: int = a[0] * x
	var right: int = b[0] * y
	if (right > 0 and left > MAX_INT - right) or (right < 0 and left < -MAX_INT - right):
		return []
	var numerator: int = left + right
	var denominator: int = a[1] * x
	var reduced := _gcd(absi(numerator), denominator)
	return [numerator / reduced, denominator / reduced]


static func _gcd(a: int, b: int) -> int:
	while b != 0:
		var remainder := a % b
		a = b
		b = remainder
	return maxi(a, 1)


func _in_transit() -> int:
	var count := 0
	for cohort: Dictionary in _cohorts:
		count += int(cohort.count)
	return count


func _ensure_day(day: int) -> void:
	if not _days.has(day):
		_days[day] = _blank(day)


func _blank(day: int) -> Dictionary:
	return {
		"day_id": day,
		"requested": 0,
		"boarded": 0,
		"unboarded": 0,
		"completed": 0,
		"late_completed": 0,
		"service_minutes": 0,
		"opening_in_transit": _in_transit(),
		"closing_in_transit": _in_transit(),
		"satisfaction_before": _satisfaction.duplicate(),
		"satisfaction_after": [],
		"satisfaction_available": not _satisfaction.is_empty(),
		"reason_codes": [] if not _satisfaction.is_empty() else ["SATISFACTION_ARITHMETIC_LIMIT"]
	}
