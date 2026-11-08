class_name TenderDataLoader
extends RefCounted
## 승인된 고정 공고를 검증하며 잘못된 입력의 부분 데이터를 공개하지 않는다.

const DATA_PATH := "res://assets/data/stage2_tenders_v1_3.json"
const SCHEMA := "DEV-018-W04A-1"
const RULES := "C0.6-D0.9-DATA1.3"
const SOURCE := "b48dd82a9b93d062d1a3bcfdf8750cb260c83e3e"
const ROUTES := {
	"B01": ["S01", "S02", "S03", "S04", "S08", "S12"],
	"B02": ["S01", "S05", "S09", "S10", "S11", "S12"],
	"B-X": []
}


static func load_data(path: String = DATA_PATH) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return _result({}, "FILE_OPEN_FAILED")
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return _result({}, "JSON_PARSE_FAILED")
	return validate_data(parser.data)


## Variant는 잘못된 JSON 루트/필드의 타입을 안전하게 거부하기 위한 입력이다.
static func validate_data(value: Variant) -> Dictionary:
	if not value is Dictionary:
		return _result({}, "INVALID_TENDER_DATA")
	if value.get("schema_version") != SCHEMA or value.get("data_version") != "1.3":
		return _result({}, "INVALID_TENDER_VERSION")
	if value.get("rules_version") != RULES:
		return _result({}, "INVALID_RULES_VERSION")
	var source: Variant = value.get("source")
	if not source is Dictionary or source.get("commit") != SOURCE:
		return _result({}, "INVALID_SOURCE")
	if source.get("path") != "docs/planning/PLN-001_GATE2_DATA_v1_DRAFT.md":
		return _result({}, "INVALID_SOURCE")
	if source.get("semantics_comment") != 6716236853:
		return _result({}, "INVALID_SOURCE")
	var rows: Variant = value.get("tenders")
	if not rows is Array or rows.size() != 3:
		return _result({}, "INVALID_TENDER_ROWS")
	var seen: Dictionary = {}
	for row: Variant in rows:
		if not row is Dictionary or not _valid_row(row) or seen.has(row.tender_id):
			return _result({}, "INVALID_TENDER_ROW")
		seen[row.tender_id] = true
	return _result(value, "")


static func _valid_row(row: Dictionary) -> bool:
	var id: Variant = row.get("tender_id")
	if not id is String or not ROUTES.has(id):
		return false
	var expected := {
		"round_id": id + "-R1",
		"project_id": "P-A" if id == "B01" else ("P-B" if id == "B02" else "EXTERNAL"),
		"city_id": "EXTERNAL_CITY" if id == "B-X" else "C01",
		"issuer_id":
		(
			"EXTERNAL_TEST_ONLY"
			if id == "B-X"
			else ("CITY_HALL" if id == "B01" else "NATIONAL_GOVERNMENT")
		),
		"station_ids": ROUTES[id],
		"opens_at": 360,
		"closes_at": 1800,
		"fare": 100,
		"government": 800000,
		"duration_minutes": 2880,
		"standard_cost": 600000,
		"competitor_capability": 80,
		"competitor_financial_score": 80,
		"tie_priority": ["COMPETITOR", "PLAYER"]
	}
	for key: String in expected:
		# JSON 정수는 float로 파싱되므로 수치 동등성은 허용하되 bool은 허용하지 않는다.
		if row.get(key) is bool or row.get(key) != expected[key]:
			return false
	return row.size() == expected.size() + 1


static func _result(data: Dictionary, reason: String) -> Dictionary:
	var copy := data.duplicate(true) if reason.is_empty() else {}
	if reason.is_empty():
		# JSON 수치 표현을 UI 계약의 정수 통화/게임분으로 명시 변환한다.
		for row: Dictionary in copy.tenders:
			for key: String in [
				"opens_at",
				"closes_at",
				"fare",
				"government",
				"duration_minutes",
				"standard_cost",
				"competitor_capability",
				"competitor_financial_score"
			]:
				row[key] = int(row[key])
	return {"ok": reason.is_empty(), "data": copy, "errors": [] if reason.is_empty() else [reason]}
