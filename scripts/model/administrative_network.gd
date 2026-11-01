class_name AdministrativeNetwork
extends RefCounted
## 안정 ID/부모/역 소속/간선이 판정 원본이다. 표시 도형을 소비하지 않는다.

var _admins: Dictionary = {}
var _stations: Dictionary = {}
var _edges: Dictionary = {}
var _errors: Array[String] = []


func _init(data: Dictionary) -> void:
	_index(data.get("administration", []), _admins)
	_index(data.get("stations", []), _stations)
	if _admins.is_empty() or _stations.is_empty():
		_errors.append("EMPTY_NETWORK")
	for id: String in _admins:
		var seen: Dictionary = {}
		var cursor: Variant = id
		while cursor is String and cursor != "":
			if seen.has(cursor):
				_errors.append("ADMIN_CYCLE")
				break
			if not _admins.has(cursor):
				_errors.append("ADMIN_ORPHAN")
				break
			seen[cursor] = true
			cursor = _admins[cursor].get("parent_id")
		if not cursor is String:
			_errors.append("ADMIN_PARENT_INVALID")
	for row: Dictionary in _stations.values():
		if not row.get("neighborhood_id") is String:
			_errors.append("STATION_AFFILIATION_INVALID")
		elif not _admins.has(row.neighborhood_id):
			_errors.append("STATION_AFFILIATION_INVALID")
	var edges: Variant = data.get("edges", [])
	if not edges is Array:
		_errors.append("EDGES_INVALID")
		edges = []
	for edge: Variant in edges:
		if not edge is Array or edge.size() != 2:
			_errors.append("EDGE_INVALID")
		elif not edge[0] is String or not edge[1] is String:
			_errors.append("EDGE_INVALID")
		elif edge[0] == edge[1] or not _stations.has(edge[0]) or not _stations.has(edge[1]):
			_errors.append("EDGE_INVALID")
		elif _edges.has(_key(edge[0], edge[1])):
			_errors.append("EDGE_DUPLICATE")
		else:
			_edges[_key(edge[0], edge[1])] = true


func valid() -> bool:
	return _errors.is_empty()


func station(id: String) -> Dictionary:
	return _stations.get(id, {}).duplicate(true)


func parents() -> Dictionary:
	return _admins.duplicate(true)


func in_city(station_id: String, city: String) -> bool:
	if not valid() or not _stations.has(station_id) or not _admins.has(city):
		return false
	var cursor: String = _stations[station_id].neighborhood_id
	while cursor != "":
		if cursor == city:
			return true
		cursor = _admins[cursor].parent_id
	return false


func connected(a: String, b: String) -> bool:
	return valid() and _edges.has(_key(a, b))


func _index(rows: Variant, target: Dictionary) -> void:
	if not rows is Array:
		_errors.append("ROWS_INVALID")
		return
	for row: Variant in rows:
		if not row is Dictionary or not row.get("id") is String or row.id.is_empty():
			_errors.append("ID_INVALID")
		elif target.has(row.id):
			_errors.append("ID_DUPLICATE")
		else:
			target[row.id] = row.duplicate(true)


func _key(a: String, b: String) -> String:
	return a + ":" + b if a < b else b + ":" + a


func validation_errors() -> Array[String]:
	return _errors.duplicate()
