extends RefCounted
## 검증 전용. 제품 main은 이 파일을 참조하지 않는다.

const Loader = preload("res://scripts/data/gate2_data_loader.gd")
const Initial = preload("res://scripts/model/initial_company_state.gd")
const Session = preload("res://scripts/ui/stage1_session.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")
const ROUTE: Array[String] = ["S01", "S02", "S03", "S04", "S08", "S12"]
const ROUTE_8: Array[String] = ["S01", "S02", "S06", "S05", "S09", "S10", "S11", "S12"]
const CASES: Array[String] = [
	"QA-T01",
	"QA-T02",
	"QA-T03",
	"QA-F01",
	"QA-F02",
	"QA-F02-K",
	"QA-F03",
	"QA-F04",
	"QA-F04-ZERO",
	"QA-M01",
	"QA-M02",
	"QA-M02-8",
	"QA-M02-EXTERNAL",
	"QA-M02-DISCONNECTED",
	"QA-M03",
	"QA-M04",
	"QA-P01",
	"QA-P01-FAIL",
	"QA-P02",
	"QA-X01"
]


static func create(case_id: String) -> Session:
	var data: Dictionary = Loader.load_data().data
	var initial: Dictionary = Initial.from_data(data).state
	var parameters := Predictor.load_parameters()
	if case_id == "QA-M02-EXTERNAL":
		data.administration.append({"id": "OTHER", "parent_id": ""})
		data.administration.append({"id": "OTHER-D", "parent_id": "OTHER"})
		data.stations.append({"id": "EXTERNAL", "neighborhood_id": "OTHER-D", "x_km": 1, "y_km": 1})
	if case_id == "QA-M04":
		for station: Dictionary in data.stations:
			station.x_km = 1
			station.y_km = 1
	if case_id == "QA-F02":
		initial.merge({"cash": 20, "restricted_by_project": {"P": 20}, "unpaid": 3}, true)
	if case_id == "QA-F02-K":
		initial.merge({"cash": 50, "reserved_by_project": {"P": 48}}, true)
	if case_id == "QA-F03":
		initial.merge(
			{
				"simulation_minute": 1439,
				"cash": 20,
				"restricted_by_project": {"P": 20},
				"unpaid": 500
			},
			true
		)
	if case_id == "QA-F04-ZERO":
		initial.simulation_minute = 1440
	if case_id.begins_with("QA-P"):
		for id: String in parameters.daily_demand:
			parameters.daily_demand[id] = 0
	var session := Session.new(data, initial, parameters)
	session.fixture_label = case_id
	session.pipeline.clock.paused = true
	if case_id == "QA-F02-K":
		session.pipeline.ledger.operating_cost(3, 360)
		# 직접 원장 주입은 fixture 준비에서만 기존 보고 집계에 반영한다.
		session.pipeline.reports.sync(session.pipeline.ledger.entries())
	if case_id == "QA-F03":
		session.pipeline.set_fixture(1449, {"arrival_fare": 800, "eligible": true})
		session.pipeline.clock.paused = false
		session.advance_usec(5000000)
		session.pipeline.clock.paused = true
	if case_id == "QA-F04":
		session.report_error = "REPORT_READ_FAILED"
	if case_id == "QA-F04-ZERO":
		session.pipeline.reports.close(1, session.pipeline.ledger.snapshot())
	if case_id.begins_with("QA-P") or case_id in ["QA-M02", "QA-M03"]:
		fill(session, ROUTE)
	if case_id == "QA-M02-8":
		fill(session, ROUTE_8)
	if case_id == "QA-M02-DISCONNECTED":
		fill(session, ["S01", "S03", "S04", "S08", "S12", "S11"])
	if case_id == "QA-M03":
		session.plan.lock(true)
	if case_id.begins_with("QA-P"):
		session.dispatch({"command_id": "fixture-predict", "action": "predict"})
	if case_id in ["QA-P01-FAIL", "QA-P02"]:
		session.dispatch({"command_id": "fixture-edit", "action": "remove", "station_id": "S12"})
		var input_revision: int = session.prediction.snapshot().prediction_input_revision
		if case_id == "QA-P01-FAIL":
			session.prediction.fail(input_revision, "CALCULATION_FAILED")
		else:
			session.prediction.begin()
	return session


static func fill(session: Session, stops: Array[String]) -> void:
	for id: String in stops:
		session.dispatch({"command_id": "fixture-add-" + id, "action": "select", "station_id": id})
