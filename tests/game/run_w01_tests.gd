extends SceneTree
## 실패는 항상 종료1. --verify-failure-exit는 같은 검사기의 의도적 실패 경로다.

const DataLoader = preload("res://scripts/data/gate2_data_loader.gd")
const CompanyState = preload("res://scripts/model/initial_company_state.gd")

var _checks: int = 0
var _failures: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure_probe", true, false)
		_finish()
		return
	var loaded := DataLoader.load_data()
	_expect("approved_file_load", loaded.ok, true)
	if not loaded.ok:
		printerr(JSON.stringify(loaded.errors))
		_finish()
		return
	var data: Dictionary = loaded.data
	_test_approved_values(data)
	_test_invalid_inputs(data)
	_expect(
		"missing_file", DataLoader.load_data("res://missing-w01.json").errors, ["FILE_OPEN_FAILED"]
	)
	_expect(
		"invalid_json", DataLoader.load_data("res://project.godot").errors, ["JSON_PARSE_FAILED"]
	)
	_expect("input_unchanged", DataLoader.load_data().data, data)
	_finish()


func _test_approved_values(data: Dictionary) -> void:
	_expect("data_version", data.data_version, "1.3")
	var expected_parents := {
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
	var actual_parents: Dictionary = {}
	for row: Dictionary in data.administration:
		actual_parents[row.id] = row.parent_id
	_expect("approved_administration", actual_parents, expected_parents)
	var expected_stations := [
		["S01", "D01", 0, 0],
		["S02", "D02", 1, 0],
		["S03", "D03", 2, 0],
		["S04", "D04", 3, 0],
		["S05", "D05", 0, 1],
		["S06", "D06", 1, 1],
		["S07", "D07", 2, 1],
		["S08", "D08", 3, 1],
		["S09", "D05", 0, 2],
		["S10", "D06", 1, 2],
		["S11", "D07", 2, 2],
		["S12", "D08", 3, 2],
	]
	var actual_stations: Array = []
	for row: Dictionary in data.stations:
		actual_stations.append([row.id, row.neighborhood_id, int(row.x_km), int(row.y_km)])
	_expect("approved_station_coordinates_affiliations", actual_stations, expected_stations)
	var edges: Array[String] = []
	for pair: Array in data.edges:
		edges.append(pair[0] + ":" + pair[1])
	edges.sort()
	var expected_edges: Array[String] = [
		"S01:S02",
		"S01:S05",
		"S02:S03",
		"S02:S06",
		"S03:S04",
		"S03:S07",
		"S04:S08",
		"S05:S06",
		"S05:S09",
		"S06:S07",
		"S06:S10",
		"S07:S08",
		"S07:S11",
		"S08:S12",
		"S09:S10",
		"S10:S11",
		"S11:S12",
	]
	_expect("approved_17_bidirectional_edges", edges, expected_edges)
	var initialized := CompanyState.from_data(data)
	_expect("initialization_ok", initialized.ok, true)
	var expected_state := {
		"data_version": "1.3",
		"city_id": "C01",
		"cash": 1000000,
		"restricted_by_project": {},
		"reserved_by_project": {},
		"unpaid": 0,
		"free_cash": 1000000,
		"available_cash": 1000000,
		"capability": 80,
		"financial_score": 100,
		"day_id": 1,
		"simulation_minute": 360,
	}
	_expect("initial_state_approved_values", initialized.state, expected_state)
	_expect("repeat_initialization", CompanyState.from_data(data).state, expected_state)
	for key: String in ["cash", "unpaid", "free_cash", "available_cash", "simulation_minute"]:
		_expect("integer_state:" + key, typeof(initialized.state[key]), TYPE_INT)
	initialized.state.restricted_by_project["TEST"] = 99
	_expect("initial_state_isolation", CompanyState.from_data(data).state, expected_state)
	var reversed := data.duplicate(true)
	for pair: Array in reversed.edges:
		pair.reverse()
	_expect("bidirectional_edge_representation", DataLoader.validate_data(reversed).ok, true)
	_expect("loading_isolation", DataLoader.load_data().data, data)


func _test_invalid_inputs(data: Dictionary) -> void:
	for value: Variant in [null, [], 12, "bad", true]:
		_expect("root_type", DataLoader.validate_data(value).errors, ["ROOT_NOT_OBJECT"])
	var cases := [
		["schema", "SCHEMA_VERSION_MISMATCH"],
		["schema_type", "SCHEMA_VERSION_MISMATCH"],
		["affiliation_type", "STATION_AFFILIATION_MISMATCH:S01"],
		["source_path_type", "SOURCE_INVALID"],
		["city_type", "INITIAL_CITY_INVALID"],
		["version", "DATA_VERSION_MISMATCH"],
		["source", "SOURCE_INVALID"],
		["source_type", "SOURCE_INVALID"],
		["admin_type", "ADMIN_NOT_ARRAY"],
		["admin_row", "ADMIN_ROW_INVALID"],
		["admin_duplicate", "ADMIN_DUPLICATE_ID:P01"],
		["admin_missing", "ADMIN_MISSING_ID:D08"],
		["orphan", "ADMIN_ORPHAN:C01"],
		["cycle", "ADMIN_CYCLE:P01"],
		["parent_type", "ADMIN_ORPHAN:C01"],
		["parent_changed", "ADMIN_PARENT_MISMATCH:D01"],
		["station_type", "STATION_NOT_ARRAY"],
		["station_row", "STATION_ROW_INVALID"],
		["station_duplicate", "STATION_DUPLICATE_ID:S01"],
		["station_missing", "STATION_MISSING_ID:S12"],
		["affiliation", "STATION_AFFILIATION_MISMATCH:S01"],
		["coordinate", "STATION_COORDINATE_MISMATCH:S01"],
		["coordinate_type", "STATION_COORDINATE_INVALID:S01"],
		["edges_type", "EDGES_NOT_ARRAY"],
		["edge_shape", "EDGE_INVALID"],
		["edge_type", "EDGE_INVALID"],
		["edge_reference", "EDGE_REFERENCE_INVALID"],
		["edge_self", "EDGE_REFERENCE_INVALID"],
		["edge_missing", "EDGE_SET_MISMATCH"],
		["edge_diagonal", "EDGE_SET_MISMATCH"],
		["edge_reverse_duplicate", "EDGE_DUPLICATE:S01:S02"],
		["initial_type", "INITIAL_NOT_OBJECT"],
		["city", "INITIAL_CITY_INVALID"],
		["cash", "INITIAL_VALUE_INVALID:cash"],
		["fraction", "INITIAL_VALUE_INVALID:cash"],
		["bool_number", "INITIAL_VALUE_INVALID:cash"],
		["missing_initial", "INITIAL_VALUE_INVALID:day_id"],
		["restricted", "INITIAL_BALANCES_INVALID:restricted_by_project"],
		["reserved_type", "INITIAL_BALANCES_INVALID:reserved_by_project"],
	]
	for test_case: Array in cases:
		var changed := _mutate(data, test_case[0])
		var rejected := DataLoader.validate_data(changed)
		_expect(test_case[0] + ":rejected", rejected.ok, false)
		_expect(test_case[0] + ":reason", test_case[1] in rejected.errors, true)
		_expect(test_case[0] + ":no_partial_data", rejected.data, {})
		var initial := CompanyState.from_data(changed)
		_expect(test_case[0] + ":no_partial_state", initial.state, {})
		_expect(test_case[0] + ":no_mutation", DataLoader.load_data().data, data)


func _mutate(data: Dictionary, name: String) -> Dictionary:
	var changed := data.duplicate(true)
	match name:
		"schema_type":
			changed.schema_version = []
		"affiliation_type":
			changed.stations[0].neighborhood_id = {}
		"source_path_type":
			changed.source.path = []
		"city_type":
			changed.initial_company.city_id = []
		"schema":
			changed.schema_version = "unknown"
		"version":
			changed.data_version = "1.2"
		"source":
			changed.source.commit = "unknown"
		"source_type":
			changed.source = []
		"admin_type":
			changed.administration = {}
		"admin_row":
			changed.administration[0] = null
		"admin_duplicate":
			changed.administration.append(changed.administration[0].duplicate())
		"admin_missing":
			changed.administration.pop_back()
		"orphan":
			changed.administration[1].parent_id = "MISSING"
		"cycle":
			changed.administration[0].parent_id = "C01"
		"parent_type":
			changed.administration[1].parent_id = []
		"parent_changed":
			changed.administration[6].parent_id = "G02"
		"station_type":
			changed.stations = {}
		"station_row":
			changed.stations[0] = {"id": 1}
		"station_duplicate":
			changed.stations.append(changed.stations[0].duplicate())
		"station_missing":
			changed.stations.pop_back()
		"affiliation":
			changed.stations[0].neighborhood_id = "MISSING"
		"coordinate":
			changed.stations[0].x_km = 1
		"coordinate_type":
			changed.stations[0].x_km = "0"
		"edges_type":
			changed.edges = {}
		"edge_shape":
			changed.edges[0] = ["S01"]
		"edge_type":
			changed.edges[0] = [1, "S02"]
		"edge_reference":
			changed.edges[0] = ["S01", "MISSING"]
		"edge_self":
			changed.edges[0] = ["S01", "S01"]
		"edge_missing":
			changed.edges.pop_back()
		"edge_diagonal":
			changed.edges[0] = ["S01", "S06"]
		"edge_reverse_duplicate":
			changed.edges.append(["S02", "S01"])
		"initial_type":
			changed.initial_company = []
		"city":
			changed.initial_company.city_id = "MISSING"
		"cash":
			changed.initial_company.cash = -1
		"fraction":
			changed.initial_company.cash = 1000000.5
		"bool_number":
			changed.initial_company.cash = true
		"missing_initial":
			changed.initial_company.erase("day_id")
		"restricted":
			changed.initial_company.restricted_by_project = {"TEST": 1}
		"reserved_type":
			changed.initial_company.reserved_by_project = []
	return changed


## Variant 비교는 null/오류 데이터 및 수치/컬렉션의 기대·실제 로그에 필요하다.
func _expect(name: String, actual: Variant, expected: Variant) -> void:
	_checks += 1
	if actual != expected:
		_failures += 1
		printerr(
			"FAIL ",
			name,
			" expected=",
			JSON.stringify(expected),
			" actual=",
			JSON.stringify(actual)
		)


func _finish() -> void:
	print("W01_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)
