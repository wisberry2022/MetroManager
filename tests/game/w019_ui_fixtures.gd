extends RefCounted
## 검증 전용 입력. 제품 main과 Session은 이 파일을 참조하지 않는다.

const Loader = preload("res://scripts/data/gate2_data_loader.gd")
const Initial = preload("res://scripts/model/initial_company_state.gd")
const Session = preload("res://scripts/ui/stage1_session.gd")
const Tender = preload("res://scripts/model/public_tender.gd")
const CASES: Array[String] = [
	"NORMAL",
	"DEADLINE",
	"NIGHT",
	"TIE",
	"FRACTION",
	"EMPTY",
	"ERROR",
	"UNAVAILABLE",
	"STALE",
	"PAYMENT_MISSING",
	"BUSY",
	"DURATION",
	"BEFORE_START",
	"REASON_FALLBACK",
	"B_ZERO",
	"B_ONLY",
	"OUTSIDE_REASON"
]


static func create(case_id: String = "NORMAL", minute: int = -1) -> Session:
	var data: Dictionary = Loader.load_data().data
	var initial: Dictionary = Initial.from_data(data).state
	if case_id == "DEADLINE":
		initial.simulation_minute = 1799
	if case_id == "NIGHT":
		initial.simulation_minute = 1439
	if case_id == "BEFORE_START":
		initial.simulation_minute = 358
	if case_id == "FRACTION":
		initial.cash = 799999
	if case_id == "BUSY":
		initial.restricted_by_project = {"OTHER": 1}
	if case_id == "B_ONLY":
		initial.unpaid = 100
	if minute >= 0:
		initial.simulation_minute = minute
	var session := Session.new(data, initial)
	session.fixture_label = "DEV019-" + case_id
	session.enable_tender_ui()
	session.pipeline.clock.paused = true
	if case_id == "TIE":
		session.request_bid("fixture-tie", "B01", confirmed(session))
		advance_to(session, 361)
		session.pipeline.ledger.operating_cost(200000, 361)
	if case_id == "PAYMENT_MISSING":
		session.request_bid("fixture-payment", "B01", confirmed(session))
		advance_to(session, 1800)
	return session


static func confirmed(session: Session, id: String = "B01") -> Dictionary:
	var packet: Dictionary = session.snapshot().tender_ui
	for row: Dictionary in packet.snapshot.tenders:
		if row.terms.tender_id == id:
			return {
				"round_id": row.terms.round_id,
				"plan_revision": row.plan_revision,
				"target_revision": row.target_revision,
				"snapshot_revision": packet.snapshot.snapshot_revision
			}
	return {}


## 미노출 대상의 빈 confirmed를 재사용하지 않는 검증 전용 직접 요청.
static func direct_request(session: Session, command_id: String, target: String) -> Dictionary:
	var seen := confirmed(session, target)
	if target == "B-X":
		seen = {
			"round_id": "B-X-R1",
			"plan_revision": 0,
			"target_revision": 0,
			"snapshot_revision": session.snapshot().tender_ui.snapshot.snapshot_revision
		}
	return session.request_bid(command_id, target, seen)


## 실제 경과 입력만 소비하고 종료분 이후 잉여 벽시간은 버린다. 분·결과를 덮어쓰지 않는다.
static func advance_observed(session: Session, elapsed: int, stop_minute: int = -1) -> Dictionary:
	var clock := session.pipeline.clock
	var before := clock.minute
	var used := maxi(0, elapsed)
	if clock.paused:
		used = 0
	elif stop_minute >= 0:
		var units := (stop_minute - clock.minute) * 5000000 - clock.remainder
		var rate := 12 * clock.speed
		@warning_ignore("integer_division")
		var remaining_usec: int = (maxi(0, units) + rate - 1) / rate
		used = mini(used, remaining_usec)
	session.advance_usec(used)
	var reached := stop_minute >= 0 and clock.minute >= stop_minute
	if reached:
		clock.paused = true
	return {
		"before": before,
		"after": clock.minute,
		"elapsed_usec": elapsed,
		"consumed_usec": used,
		"reached_stop": reached
	}


## 원장·명령·완료 단계·보고를 조회만 한다. 소비 반례는 packet()에서 별도로 공급한다.
static func observation(session: Session) -> Dictionary:
	return {
		"pipeline": session.pipeline.snapshot(),
		"clock": session.pipeline.clock.snapshot(),
		"packet": session.snapshot().tender_ui,
		"ledger": session.pipeline.ledger.entries(),
		"closed_day1": session.pipeline.reports.report(1),
		"current_day2": session.pipeline.reports.current(2)
	}


static func advance_to(session: Session, minute: int) -> void:
	var clock := session.pipeline.clock
	var paused := clock.paused
	clock.paused = false
	var units: int = (minute - clock.minute) * 5000000 - clock.remainder
	if units > 0:
		session.advance_usec(ceili(float(units) / (12 * clock.speed)))
	clock.paused = paused


## 경제 상태를 바꾸지 않는 소비 반례. 직접 GUI에 검증 전용임을 표시한다.
static func packet(session: Session, case_id: String) -> Dictionary:
	var value: Dictionary = session.snapshot().tender_ui
	match case_id:
		"EMPTY":
			value.snapshot.tenders = []
		"ERROR":
			value.status = "FAILED"
			value.reason = "QUERY_FAILED_TEST_ONLY"
		"UNAVAILABLE":
			value.snapshot.available = false
		"PAYMENT_MISSING":
			value.snapshot.tenders[0].business_contract.government_payment = {}
		"REASON_FALLBACK":
			value.snapshot.tenders[0].reason_codes = [
				"ROUND_CLOSED",
				"UNKNOWN_TEST_ONLY_LONG_DIAGNOSTIC_REASON_CODE",
				"PROJECT_IN_PROGRESS"
			]
			value.snapshot.tenders[0].allowed_actions.submit_bid = false

		"DURATION":
			var row: Dictionary = value.snapshot.tenders[0]
			row.eligibility = Tender.new(row.terms).eligibility("C01", false, 2881)
			row.reason_codes = row.eligibility.reason_codes
			row.allowed_actions.submit_bid = false
		"OUTSIDE_REASON":
			var row: Dictionary = value.snapshot.tenders[0]
			row.eligibility = Tender.new(row.terms).eligibility("C02", false, 2880)
			row.reason_codes = row.eligibility.reason_codes
			row.allowed_actions.submit_bid = false
	return value
