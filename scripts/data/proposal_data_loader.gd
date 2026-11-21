class_name ProposalDataLoader
extends RefCounted
## P1 승인 수치만 공급한다. 슬롯 예시를 고정 경로나 E01 영향 지역으로 만들지 않는다.

const DATA_PATH := "res://assets/data/stage3_proposals_v1_4.json"
const SCHEMA := "DEV-027-W04B-P1-1"
const RULES := "C0.7-D0.9-DATA1.4"
const SOURCE := "1a941196cc6d963db93a9fba6a0386b16710aa46"
const NUMBERS := {
	"city_minutes": 30,
	"government_minutes": 60,
	"persuasion_minutes": 30,
	"government_approved_below": 70,
	"government_held_below": 90,
	"persuasion_success_below": 60,
	"government": 800000,
	"persuasion_government": 640000,
	"standard_cost": 600000,
	"duration_minutes": 2880,
	"fare": 100,
	"office_opens_at": 360,
	"day_minutes": 1440,
	"fact_delay_minutes": 1440,
}


static func load_data(path: String = DATA_PATH) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return _result({}, "FILE_OPEN_FAILED")
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return _result({}, "JSON_PARSE_FAILED")
	return validate_data(parser.data)


## Variant는 손상된 JSON 입력을 부분 수용하지 않기 위해 경계에서만 사용한다.
static func validate_data(value: Variant) -> Dictionary:
	if not value is Dictionary:
		return _result({}, "INVALID_PROPOSAL_DATA")
	var expected := {
		"schema_version": SCHEMA,
		"data_version": "1.4",
		"rules_version": RULES,
		"source": {"commit": SOURCE, "path": "docs/planning/PLN-001_GATE2_DATA_v1_DRAFT.md"},
		"city_id": "C01",
		"slot_ids": ["P-A", "P-B"],
		"di03_status": "DEPENDENT_SCOPE_PENDING",
	}
	if value.size() != expected.size() + NUMBERS.size():
		return _result({}, "INVALID_PROPOSAL_FIELDS")
	for key: String in expected:
		if typeof(value.get(key)) != typeof(expected[key]) or value[key] != expected[key]:
			return _result({}, "INVALID_PROPOSAL_METADATA")
	var copy: Dictionary = value.duplicate(true)
	for key: String in NUMBERS:
		var number: Variant = value.get(key)
		if not (number is int or number is float) or number != NUMBERS[key]:
			return _result({}, "INVALID_PROPOSAL_VALUE")
		copy[key] = int(number)
	return _result(copy, "")


static func _result(data: Dictionary, reason: String) -> Dictionary:
	return {
		"ok": reason.is_empty(),
		"data": data.duplicate(true),
		"errors": [] if reason.is_empty() else [reason]
	}
