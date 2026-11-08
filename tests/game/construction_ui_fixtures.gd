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
	"ERROR",
	"UNAVAILABLE",
	"EMPTY"
]


static func create(id: String = "CONTRACT") -> BidFX.Session:
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
