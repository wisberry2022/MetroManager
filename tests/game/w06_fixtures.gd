extends RefCounted
## MODEL_CHAIN은 정상 명령, controlled는 명시적 TEST_ONLY 합성 개통/자금 입력이다.

const Pipeline = preload("res://scripts/simulation/minute_pipeline.gd")
const FX5 = preload("res://tests/game/w05_fixtures.gd")
const BidFX = preload("res://tests/game/w04a_fixtures.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const Project = preload("res://scripts/model/construction_project.gd")
const Network = preload("res://scripts/model/administrative_network.gd")
const Loader = preload("res://scripts/data/gate2_data_loader.gd")
const TenderLoader = preload("res://scripts/data/tender_data_loader.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")
const Operations = preload("res://scripts/simulation/operations_service.gd")
const Reports = preload("res://scripts/model/daily_ledger_report.gd")


static func network() -> Network:
	return Network.new(Loader.load_data().data)


static func opened() -> Pipeline:
	var pipe := BidFX.pipeline()
	pipe.enable_construction()
	pipe.enable_operations()
	pipe.submit_bid(BidFX.command())
	BidFX.advance_to(pipe, 1800)
	FX5.execute(pipe, "contract", "construction")
	FX5.execute(pipe, "start", "start")
	BidFX.advance_to(pipe, 4682)
	FX5.execute(pipe, "trial", "trial")
	BidFX.advance_to(pipe, 4743)
	FX5.execute(pipe, "safety", "safety")
	BidFX.advance_to(pipe, 4804)
	FX5.execute(pipe, "open", "open")
	return pipe


static func controlled(
	minute: int = 359, initial: Dictionary = {}, parameters: Dictionary = {}
) -> Dictionary:
	var ledger := Ledger.new(initial)
	var terms: Dictionary = TenderLoader.load_data().data.tenders[0].duplicate(true)
	ledger.contract(terms.project_id, 800000, 600000, 0)
	var government_index := -1
	var entries := ledger.entries()
	for index: int in entries.size():
		if entries[index].kind == "government":
			government_index = index
	ledger.construction_payment(terms.project_id, 600000, 0)
	var business := {
		"project_id": terms.project_id,
		"business_contract_id": "B01-R1-BUSINESS",
		"status": "EFFECTIVE",
		"effective_at": 0,
		"government_payment":
		{
			"available": true,
			"effective_at": 0,
			"ledger_entry_index": government_index,
			"transaction_id": "B01-R1-GOVERNMENT",
			"amount": 800000,
			"restricted_project_id": terms.project_id
		}
	}
	var project := Project.new({"business_contract": business, "terms": terms}, "STANDARD", 0)
	project.state.merge(
		{
			"status": "OPEN",
			"opened_at": 0,
			"started_at": 0,
			"completed_at": 0,
			"elapsed_minutes": 2880,
			"accrued": 600000,
			"paid": 600000,
			"trial_status": "PASSED",
			"safety_status": "PASSED"
		},
		true
	)
	var data := Predictor.load_parameters() if parameters.is_empty() else parameters.duplicate(true)
	var service := Operations.new(network(), data, ledger)
	var tenders := {
		"available": true,
		"data_version": "1.3",
		"simulation_minute": minute,
		"snapshot_revision": 0,
		"tenders": [{"terms": terms, "business_contract": business}]
	}
	var construction := {
		"available": true,
		"data_version": "1.3",
		"simulation_minute": minute,
		"snapshot_revision": 0,
		"projects": [project.snapshot()]
	}
	service.bind_sources(tenders, construction, minute)
	return {
		"kind": "MODEL_FIXTURE",
		"service": service,
		"ledger": ledger,
		"parameters": data,
		"tenders": tenders,
		"construction": construction,
		"project": project,
		"reports": Reports.new(),
		"minute": minute
	}


## 테스트 전용 어댑터. 실제 Pipeline과 별도로 공개 서비스/원장 API를 순서대로 검산한다.
static func step(value: Dictionary, minute: int) -> void:
	var service: Operations = value.service
	var ledger: Ledger = value.ledger
	var reports: Reports = value.reports
	ledger.operating_cost(service.previous_interval_cost(minute), minute - 1)
	reports.sync(ledger.entries())
	if minute % 1440 == 0:
		var day := minute / 1440
		reports.sync_operations(day, service.close_day(day, reports.current(day).fare))
		reports.close(day, ledger.snapshot())
	for data: Dictionary in [value.tenders, value.construction]:
		data.simulation_minute = minute
		data.snapshot_revision += 1
	value.construction.projects = [value.project.snapshot()]
	service.bind_sources(value.tenders, value.construction, minute)
	ledger.fare(service.arrivals(minute).completed * 100, minute)
	ledger.settle(minute)
	service.board(minute, ledger.boarding(minute, 100, service.service_ready()))
	reports.sync(ledger.entries())
	reports.sync_operations(minute / 1440 + 1, service.daily(minute / 1440 + 1))
	value.minute = minute


static func until(value: Dictionary, end: int) -> void:
	for minute: int in range(value.minute + 1, end + 1):
		step(value, minute)


static func sum_entries(ledger: Ledger, kind: String) -> int:
	var total := 0
	for item: Dictionary in ledger.entries():
		if item.kind == kind:
			total += int(item.amount)
	return total


static func money(ledger: Ledger) -> Array:
	var s := ledger.snapshot()
	return [s.cash, s.restricted, s.free_cash, s.reserved, s.available_cash, s.unpaid]


static func consumer(value: Dictionary) -> Dictionary:
	return {
		"operations": value.service.snapshot(value.minute, value.construction.snapshot_revision),
		"funds": value.ledger.snapshot(),
		"current_report": value.reports.current(value.minute / 1440 + 1),
		"previous_report": value.reports.report(value.minute / 1440),
		"kind": value.kind
	}
