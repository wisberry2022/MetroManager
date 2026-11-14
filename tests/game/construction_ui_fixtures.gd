extends RefCounted
## 명시적 TEST_ONLY 입력. 제품 코드에서는 이 파일을 참조하지 않는다.

const BidFX = preload("res://tests/game/w019_ui_fixtures.gd")
const W05 = preload("res://tests/game/w05_fixtures.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const Project = preload("res://scripts/model/construction_project.gd")
const CASES: Array[String] = [
	"CONTRACT",
	"PROGRESS",
	"PAYMENT_DUE",
	"FINAL_DUE",
	"RESUME",
	"FAST_REPAIR",
	"REPAIR_SHORT",
	"FOCUS_POST_REPAIR",
	"FOCUS_OPEN_READY",
	"ERROR",
	"UNAVAILABLE",
	"EMPTY"
]


static func create(id: String = "CONTRACT") -> BidFX.Session:
	if id in ["FOCUS_POST_REPAIR", "FOCUS_OPEN_READY"]:
		var focus_session := create("FAST_REPAIR")
		execute(focus_session, "repair", "focus-fixture-repair")
		BidFX.advance_to(focus_session, 3432)
		if id == "FOCUS_OPEN_READY":
			execute(focus_session, "safety", "focus-fixture-retest")
			BidFX.advance_to(focus_session, 3493)
		focus_session.fixture_label = "DEV021-" + id
		return focus_session
	var session := BidFX.create()
	session.enable_construction_ui()
	session.fixture_label = "DEV021-" + id
	session.request_bid("fixture-bid", "B01", BidFX.confirmed(session))
	BidFX.advance_to(session, 1800)
	if id in ["PROGRESS", "PAYMENT_DUE", "FINAL_DUE", "RESUME", "FAST_REPAIR", "REPAIR_SHORT"]:
		var mode := "FAST" if id in ["FAST_REPAIR", "REPAIR_SHORT"] else "STANDARD"
		execute(session, "contract", "fixture-contract", mode)
		execute(session, "start", "fixture-start")
	if id == "PROGRESS":
		BidFX.advance_to(session, 2000)
	if id in ["PAYMENT_DUE", "FINAL_DUE"]:
		var start: int = row(session).started_at
		BidFX.advance_to(session, start + (2879 if id == "FINAL_DUE" else 2))
		var project: String = row(session).project_id
		var funds := session.pipeline.ledger.snapshot()
		session.pipeline.ledger.construction_payment(
			project, funds.restricted_by_project[project], session.pipeline.clock.minute, false
		)
		BidFX.advance_to(session, session.pipeline.clock.minute + 1)
	if id == "RESUME":
		# DEV-020 승인 비영 K/미지급 회복 반례. 제품 정상 사업 경로가 아니다.
		var project: String = row(session).project_id
		var model: Project = session.pipeline.get("_construction")._projects[project]
		var ledger = session.pipeline.ledger
		ledger.construction_payment(
			project, ledger.snapshot().restricted_by_project[project], 1802, false
		)
		# K는 승인된 내부 반례의 초기 상태로만 구성한다.
		var replacement := Ledger.new(
			{
				"cash": 209,
				"restricted_by_project": {project: 0},
				"reserved_by_project": {project: 209}
			}
		)
		session.pipeline.ledger = replacement
		session.pipeline.get("_construction").set("_ledger", replacement)
		model.state.status = "SUSPENDED"
		model.state.elapsed_minutes = 3
		model.state.accrued = 625
		model.state.paid = 416
		model.state.construction_payable = 209
	if id in ["FAST_REPAIR", "REPAIR_SHORT"]:
		BidFX.advance_to(session, int(row(session).started_at) + 1440)
		execute(session, "trial", "fixture-trial")
		BidFX.advance_to(session, session.pipeline.clock.minute + 60)
		execute(session, "safety", "fixture-safety")
		BidFX.advance_to(session, session.pipeline.clock.minute + 60)
		if id == "REPAIR_SHORT":
			var project: String = row(session).project_id
			var ledger = session.pipeline.ledger
			ledger.construction_payment(
				project,
				ledger.snapshot().restricted_by_project[project],
				session.pipeline.clock.minute,
				false
			)
			ledger.operating_cost(980001, session.pipeline.clock.minute)
			ledger.settle(session.pipeline.clock.minute)
	return session


static func row(session: BidFX.Session) -> Dictionary:
	var values: Array = session.snapshot().construction_ui.snapshot.projects
	return {} if values.is_empty() else values[0]


static func confirmed(session: BidFX.Session, mode: String = "STANDARD") -> Dictionary:
	var envelope: Dictionary = session.snapshot().construction_ui.snapshot
	var project := row(session)
	var candidate: Dictionary = envelope.contract_candidates[0]
	return {
		"project_id": candidate.project_id,
		"business_contract_id": candidate.business_contract.business_contract_id,
		"target_revision": project.get("condition_revision", candidate.target_revision),
		"snapshot_revision": envelope.snapshot_revision,
		"mode": mode
	}


static func execute(
	session: BidFX.Session, action: String, id: String, mode: String = "STANDARD"
) -> Dictionary:
	var result := session.request_construction(id, action, confirmed(session, mode))
	BidFX.advance_to(session, int(result.get("effective_at", session.pipeline.clock.minute + 1)))
	return session.pipeline.construction_result(id)


static func packet(session: BidFX.Session, id: String) -> Dictionary:
	var value: Dictionary = session.snapshot().construction_ui
	if id == "ERROR":
		value.status = "FAILED"
		value.reason = "TEST_ONLY_QUERY_ERROR"
	if id == "UNAVAILABLE":
		value.snapshot.available = false
	if id == "EMPTY":
		value.snapshot.projects = []
		value.snapshot.contract_candidates = []
	return value


## Q12 표시 사본. 정상 모델과 합성 표시/이력을 분리하며 제품에서 참조하지 않는다.
static func q12_text(kind: String, size: int, suffix: String = "_END_A") -> String:
	var prefix := "TEST_ONLY_LONG_" if kind == "code" else "TEST_ID_"
	if kind in ["id", "code"]:
		return (
			prefix
			+ "AB09_-".repeat(size).substr(0, size - prefix.length() - suffix.length())
			+ suffix
		)
	var seed: String = {
		"ko": "한글 표시 확인 ",
		"mixed": "한글 Metro 0123 / ()[]:_- ",
		"tight": "한글METRO0123456789",
		"lf": "한글 Metro 0123 / ()[]:_- "
	}[kind]
	var text := seed.repeat(size).substr(0, size)
	if kind == "lf":
		text = text.substr(0, 255) + "\n" + text.substr(256, 511) + "\n" + text.substr(768)
	return text


static func q12_specs() -> Array[String]:
	var ids: Array[String] = []
	for field: String in ["project", "business", "construction", "payment", "command"]:
		for size: int in [64, 256]:
			ids.append("ID-%s-%d" % [field, size])
	for kind: String in ["ko", "mixed", "lf", "tight"]:
		ids.append("FAILED-" + kind)
	for location: String in ["candidate", "action", "history"]:
		for size: int in [64, 256, 128]:
			ids.append("REASON-%s-%d" % [location, size])
	return ids


static func q12_display(session: BidFX.Session, case_id: String) -> Dictionary:
	var value: Dictionary = session.snapshot().construction_ui
	var texts: Array[Dictionary] = []
	var envelope: Dictionary = value.snapshot
	var selected := "P-A"
	var id_fields: Array[String] = []
	if case_id.begins_with("ID-"):
		id_fields.append(case_id.split("-")[1])
	if case_id in ["LTXT-G01", "LTXT-G07"]:
		id_fields.assign(["project", "business", "construction", "payment", "command"])
	var size := int(case_id.get_slice("-", 2)) if case_id.begins_with("ID-") else 256
	for field: String in id_fields:
		var text := q12_text("id", size)
		texts.append(_q12_text_record(field, text))
		if field == "project":
			selected = text
			for map: String in ["restricted_by_project", "reserved_by_project"]:
				var amount: int = envelope.funds[map].get("P-A", 0)
				envelope.funds[map].erase("P-A")
				envelope.funds[map][text] = amount
		for group: String in ["projects", "contract_candidates"]:
			for item: Dictionary in envelope[group]:
				match field:
					"project":
						item.project_id = text
						item.business_contract.project_id = text
						item.business_contract.government_payment.restricted_project_id = text
					"business":
						item.business_contract.business_contract_id = text
					"construction":
						if item.has("construction_contract_id"):
							item.construction_contract_id = text
					"payment":
						item.business_contract.government_payment.transaction_id = text
	var failed: String = (
		{"LTXT-G02": "ko", "LTXT-G03": "mixed", "LTXT-G03-LF": "lf", "LTXT-G04": "tight"}
		. get(case_id, case_id.trim_prefix("FAILED-") if case_id.begins_with("FAILED-") else "")
	)
	if not failed.is_empty():
		value.status = "FAILED"
		value.reason = q12_text(failed, 256 if failed == "ko" else 1024)
		texts.append(_q12_text_record("packet.reason", value.reason))
	var location := ""
	var reason_size := 256
	if case_id.begins_with("REASON-"):
		location = case_id.get_slice("-", 1)
		reason_size = int(case_id.get_slice("-", 2))
	if case_id == "LTXT-G05":
		location = "action"
	if case_id in ["LTXT-G06", "LTXT-G07"]:
		location = "both"
		reason_size = 128
	var codes: Array[String] = ["PREREQUISITE_NOT_MET"]
	if not location.is_empty():
		if reason_size == 128:
			codes.clear()
		for index: int in 8 if reason_size == 128 else 1:
			var code := q12_text("code", reason_size, "_%02d" % (index + 1))
			codes.append(code)
			texts.append(_q12_text_record(location + ".reason", code))
		if location == "candidate":
			envelope.contract_candidates[0].reason_codes = codes
		if location in ["action", "both"]:
			envelope.projects[0].action_reason_codes.open = codes
	# Preserve ID references inside the cloned command history only.
	for record: Dictionary in value.requests:
		record.command.project_id = selected
		if "business" in id_fields:
			record.command.business_contract_id = q12_text("id", size)
	if "command" in id_fields or location in ["history", "both"]:
		for index: int in 2:
			var id := q12_text("id", size, "_END_A" if index == 0 else "_END_B")
			texts.append(_q12_text_record("requests.command_id", id))
			value.requests.append(
				{
					"command":
					{"command_id": id, "project_id": selected, "action": "open", "requested_at": 1},
					"result":
					{
						"command_id": id,
						"pending": false,
						"accepted": false,
						"reason_codes": codes if index == 0 else ["STATE_CHANGED"],
						"effective_at": 2,
						"result_revision": 2,
						"decision_phase": "VALIDATION"
					}
				}
			)
	return {"packet": value, "selected_id": selected, "inputs": texts, "case_id": case_id}


static func _q12_text_record(field: String, text: String) -> Dictionary:
	return {
		"field": field,
		"text": text,
		"codepoints": text.length(),
		"utf8_bytes": text.to_utf8_buffer().size(),
		"sha256": text.sha256_text()
	}


static func q12_session(id: String) -> BidFX.Session:
	if id.begins_with("Q12-CMD"):
		return create("CONTRACT")
	if id.begins_with("Q12-REV"):
		var session := create("CONTRACT")
		execute(session, "contract", "q12-setup-contract")
		return session
	if id.begins_with("Q12-HIS"):
		var session := create("CONTRACT")
		execute(session, "contract", "q12-setup-contract", "FAST")
		execute(session, "start", "q12-setup-start")
		BidFX.advance_to(session, int(row(session).started_at) + 1440)
		return session
	if id.begins_with("Q12-FIN"):
		var session := create("FAST_REPAIR")
		if id != "Q12-FIN-01":
			var shortage := id == "Q12-FIN-03"
			var ledger := Ledger.new(
				{
					"cash": 29999 if shortage else 30000,
					"restricted_by_project": {"P-A": 10000, "P-B": 5000},
					"reserved_by_project": {"P-A": 0, "P-B": 5001 if id == "Q12-FIN-04" else 5000}
				}
			)
			session.pipeline.ledger = ledger
			session.pipeline.get("_construction").set("_ledger", ledger)
		return session
	return create("FOCUS_POST_REPAIR")
