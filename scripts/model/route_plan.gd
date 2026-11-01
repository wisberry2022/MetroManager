class_name RoutePlan
extends RefCounted

const Network = preload("res://scripts/model/administrative_network.gd")

var _network: Network
var _city: String
var _stops: Array[String] = []
var _history: Array = []
var _revision: int = 0
var _locked: bool = false


func _init(network: Network, city: String = "C01") -> void:
	_network = network
	_city = city


func snapshot() -> Dictionary:
	return {
		"station_ids": _stops.duplicate(),
		"plan_revision": _revision,
		"validation": validate(_stops),
		"locked": _locked,
		"allowed_actions": {"edit": not _locked, "undo": not _locked and not _history.is_empty()}
	}


func lock(value: bool) -> void:
	_locked = value


## 임시5/9역·단절은 편집 중 표시할 수 있다. 제출 가능 여부는 validate가 공급한다.
func replace(stops: Array[String]) -> Dictionary:
	if _locked:
		return {"accepted": false, "reason": "PLAN_LOCKED"}
	for id: String in stops:
		if not _network.in_city(id, _city):
			return {"accepted": false, "reason": "OUTSIDE_JURISDICTION"}
		if stops.count(id) > 1:
			return {"accepted": false, "reason": "DUPLICATE_STATION"}
	if stops == _stops:
		return {"accepted": true, "validation": validate(_stops)}
	_history.append(_stops.duplicate())
	_stops = stops.duplicate()
	_revision += 1
	return {"accepted": true, "validation": validate(_stops)}


func select(id: String) -> Dictionary:
	var stops := _stops.duplicate()
	stops.append(id)
	return replace(stops)


func remove(id: String) -> Dictionary:
	if id not in _stops:
		return {"accepted": false, "reason": "STATION_NOT_SELECTED"}
	var stops := _stops.duplicate()
	stops.erase(id)
	return replace(stops)


func reorder(from: int, to: int) -> Dictionary:
	if from < 0 or to < 0 or from >= _stops.size() or to >= _stops.size():
		return {"accepted": false, "reason": "INVALID_INDEX"}
	var stops := _stops.duplicate()
	var id: String = stops.pop_at(from)
	stops.insert(to, id)
	return replace(stops)


func undo() -> bool:
	if _locked or _history.is_empty():
		return false
	_stops = _history.pop_back()
	_revision += 1
	return true


func validate(stops: Array[String]) -> Dictionary:
	var reasons: Array[String] = []
	if not _network.valid():
		reasons.append("INVALID_NETWORK")
	if stops.size() < 6 or stops.size() > 8:
		reasons.append("STATION_COUNT")
	var seen: Dictionary = {}
	for index: int in stops.size():
		var id: String = stops[index]
		if seen.has(id):
			reasons.append("DUPLICATE_STATION")
		seen[id] = true
		if not _network.in_city(id, _city):
			reasons.append("OUTSIDE_JURISDICTION")
		if index > 0 and not _network.connected(stops[index - 1], id):
			reasons.append("DISCONNECTED")
	return {
		"valid": reasons.is_empty(),
		"reason_codes": reasons,
		"allowed_actions": {"submit": reasons.is_empty() and not _locked}
	}
