class_name Gate2DataLoader
extends RefCounted
## W01 승인 입력을 검증한 뒤에만 호출자에게 전달한다. 캐시/게임 상태는 변경하지 않는다.

const DATA_PATH := "res://assets/data/gate2_w01_v1_3.json"
const SCHEMA_VERSION := "DEV-010-W01-1"
const SOURCE_PATH := "docs/planning/PLN-001_GATE2_DATA_v1_DRAFT.md"
const SOURCE_COMMIT := "1356c4b2ec824ca51e807bd9754a891aaa57e13d"
const ADMIN_PARENTS := {
	"P01": "",
	"C01": "P01",
	"G01": "C01",
	"G02": "C01",
	"G03": "C01",
	"G04": "C01",
	"D01": "G01",
	"D02": "G01",
	"D03": "G02",
	"D04": "G02",
	"D05": "G03",
	"D06": "G03",
	"D07": "G04",
	"D08": "G04",
}
const INITIAL_VALUES := {
	"cash": 1000000,
	"unpaid": 0,
	"capability": 80,
	"financial_score": 100,
	"day_id": 1,
	"simulation_minute": 360,
}


## 파일/JSON/의미 오류 모두 동일한 실패 결과를 반환하며 부분 데이터를 노출하지 않는다.
static func load_data(path: String = DATA_PATH) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return _result({}, ["FILE_OPEN_FAILED"])
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return _result({}, ["JSON_PARSE_FAILED"])
	return validate_data(parser.data)


## Variant는 JSON 루트가 배열/null/스칼라인 부정 입력도 안전하게 검사하기 위해 사용한다.
static func validate_data(value: Variant) -> Dictionary:
	if not value is Dictionary:
		return _result({}, ["ROOT_NOT_OBJECT"])
	var errors: Array[String] = []
	if not _matches_text(value.get("schema_version"), SCHEMA_VERSION):
		errors.append("SCHEMA_VERSION_MISMATCH")
	if not _matches_text(value.get("data_version"), "1.3"):
		errors.append("DATA_VERSION_MISMATCH")
	var source: Variant = value.get("source")
	if not source is Dictionary:
		errors.append("SOURCE_INVALID")
	elif (
		not _matches_text(source.get("path"), SOURCE_PATH)
		or not _matches_text(source.get("commit"), SOURCE_COMMIT)
	):
		errors.append("SOURCE_INVALID")
	var admins := _index_rows(value.get("administration"), "ADMIN", errors)
	_validate_admins(admins, errors)
	var stations := _index_rows(value.get("stations"), "STATION", errors)
	_validate_stations(stations, errors)
	_validate_edges(value.get("edges"), stations, errors)
	_validate_initial(value.get("initial_company"), errors)
	return _result(value, errors)


static func _result(data: Dictionary, errors: Array[String]) -> Dictionary:
	return {
		"ok": errors.is_empty(),
		"data": data.duplicate(true) if errors.is_empty() else {},
		"errors": errors
	}


static func _index_rows(value: Variant, label: String, errors: Array[String]) -> Dictionary:
	var indexed: Dictionary = {}
	if not value is Array:
		errors.append(label + "_NOT_ARRAY")
	else:
		for row: Variant in value:
			if not row is Dictionary or not row.get("id") is String or row.get("id") == "":
				errors.append(label + "_ROW_INVALID")
			elif indexed.has(row.id):
				errors.append(label + "_DUPLICATE_ID:" + row.id)
			else:
				indexed[row.id] = row
	return indexed


static func _validate_admins(admins: Dictionary, errors: Array[String]) -> void:
	if admins.size() != ADMIN_PARENTS.size():
		errors.append("ADMIN_COUNT_MISMATCH")
	for id: String in admins:
		var parent: Variant = admins[id].get("parent_id")
		if not parent is String or (parent != "" and not admins.has(parent)):
			errors.append("ADMIN_ORPHAN:" + id)
			continue
		if not ADMIN_PARENTS.has(id) or parent != ADMIN_PARENTS.get(id):
			errors.append("ADMIN_PARENT_MISMATCH:" + id)
		var seen: Dictionary = {}
		var cursor: Variant = id
		while cursor is String and cursor != "" and admins.has(cursor):
			if seen.has(cursor):
				errors.append("ADMIN_CYCLE:" + id)
				break
			seen[cursor] = true
			cursor = admins[cursor].get("parent_id")
	for id: String in ADMIN_PARENTS:
		if not admins.has(id):
			errors.append("ADMIN_MISSING_ID:" + id)


static func _validate_stations(stations: Dictionary, errors: Array[String]) -> void:
	if stations.size() != 12:
		errors.append("STATION_COUNT_MISMATCH")
	for number: int in range(1, 13):
		var id := "S%02d" % number
		if not stations.has(id):
			errors.append("STATION_MISSING_ID:" + id)
			continue
		var row: Dictionary = stations[id]
		var district := "D%02d" % (number if number <= 8 else number - 4)
		if not _matches_text(row.get("neighborhood_id"), district):
			errors.append("STATION_AFFILIATION_MISMATCH:" + id)
		var x: Variant = row.get("x_km")
		var y: Variant = row.get("y_km")
		if not _is_integer(x) or not _is_integer(y):
			errors.append("STATION_COORDINATE_INVALID:" + id)
		elif int(x) != (number - 1) % 4 or int(y) != floori((number - 1) / 4.0):
			errors.append("STATION_COORDINATE_MISMATCH:" + id)


static func _validate_edges(value: Variant, stations: Dictionary, errors: Array[String]) -> void:
	if not value is Array:
		errors.append("EDGES_NOT_ARRAY")
		return
	var actual: Dictionary = {}
	for edge: Variant in value:
		if not edge is Array or edge.size() != 2:
			errors.append("EDGE_INVALID")
			continue
		if not edge[0] is String or not edge[1] is String:
			errors.append("EDGE_INVALID")
			continue
		var a: String = edge[0]
		var b: String = edge[1]
		if a == b or not stations.has(a) or not stations.has(b):
			errors.append("EDGE_REFERENCE_INVALID")
		var key := _edge_key(a, b)
		if actual.has(key):
			errors.append("EDGE_DUPLICATE:" + key)
		actual[key] = true
	var expected: Dictionary = {}
	# DATA §2: 4열×3행의 양방향 맨해튼 거리1 간선을 한 번씩 기록한다.
	for number: int in range(1, 13):
		if number % 4 != 0:
			expected[_edge_key("S%02d" % number, "S%02d" % (number + 1))] = true
		if number <= 8:
			expected[_edge_key("S%02d" % number, "S%02d" % (number + 4))] = true
	if actual != expected:
		errors.append("EDGE_SET_MISMATCH")


static func _edge_key(a: String, b: String) -> String:
	return a + ":" + b if a < b else b + ":" + a


static func _validate_initial(value: Variant, errors: Array[String]) -> void:
	if not value is Dictionary:
		errors.append("INITIAL_NOT_OBJECT")
		return
	if not _matches_text(value.get("city_id"), "C01"):
		errors.append("INITIAL_CITY_INVALID")
	for key: String in INITIAL_VALUES:
		var number: Variant = value.get(key)
		if not _is_integer(number) or number != INITIAL_VALUES[key]:
			errors.append("INITIAL_VALUE_INVALID:" + key)
	for key: String in ["restricted_by_project", "reserved_by_project"]:
		var balances: Variant = value.get(key)
		if not balances is Dictionary or not balances.is_empty():
			errors.append("INITIAL_BALANCES_INVALID:" + key)


static func _is_integer(value: Variant) -> bool:
	return value is int or (value is float and is_finite(value) and value == floor(value))


static func _matches_text(value: Variant, expected: String) -> bool:
	return value is String and value == expected
