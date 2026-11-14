extends RefCounted
## TEST_ONLY: 정상 명령 준비와 소비 사본 주입을 분리한다. 제품은 이 파일을 로드하지 않는다.

const Session = preload("res://scripts/ui/stage1_session.gd")
const Loader = preload("res://scripts/data/gate2_data_loader.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")
const FX5 = preload("res://tests/game/w05_fixtures.gd")
const FX6 = preload("res://tests/game/w06_fixtures.gd")
const Reports = preload("res://scripts/model/daily_ledger_report.gd")


class ConsumerPipeline:
	extends "res://scripts/simulation/minute_pipeline.gd"
	## 소비 경계 전용 사본. 실제 입찰/개통 생성의 증거가 아니다.
	var supplied: Dictionary = {}
	var query: Dictionary = {}

	func snapshot() -> Dictionary:
		return supplied.duplicate(true)

	func next_business_query() -> Dictionary:
		return query.duplicate(true)


static func session(initial: Dictionary = {}, parameters: Dictionary = {}) -> Session:
	var value := Session.new(Loader.load_data().data, initial, parameters)
	value.fixture_label = "DEV023-TEST_ONLY"
	return value


static func advance_to(value: Session, minute: int) -> void:
	var units: int = (minute - value.pipeline.clock.minute) * 5000000
	units -= value.pipeline.clock.remainder
	var divisor: int = 12 * value.pipeline.clock.speed
	if units > 0:
		var elapsed: int = units / divisor
		if units % divisor > 0:
			elapsed += 1
		value.advance_usec(elapsed)


static func opened() -> Dictionary:
	var value := session()
	var steps: Array[Dictionary] = []
	steps.append({"stage": "enable", "result": value.enable_operations_ui()})
	var before := value.snapshot()
	var row: Dictionary = before.tender_ui.snapshot.tenders[0]
	steps.append(
		{
			"stage": "bid",
			"result":
			value.request_bid(
				"dev023-bid",
				row.terms.tender_id,
				{
					"round_id": row.terms.round_id,
					"target_revision": row.target_revision,
					"plan_revision": 0,
					"snapshot_revision": before.current.snapshot_revision
				}
			)
		}
	)
	advance_to(value, 1800)
	for action: String in ["contract", "start", "trial", "safety", "open"]:
		if action == "trial":
			advance_to(value, 4682)
		elif action == "safety":
			advance_to(value, 4743)
		elif action == "open":
			advance_to(value, 4804)
		var command := FX5.command(value.pipeline, action, "dev023-" + action)
		command["snapshot_revision"] = command.expected_snapshot_revision
		value.request_construction(command.command_id, action, command)
		advance_to(value, command.effective_at)
		steps.append(
			{"stage": action, "result": value.pipeline.construction_result(command.command_id)}
		)
	return {"session": value, "steps": steps, "kind": "MODEL_CHAIN_SETUP"}


static func consumer(
	current: Dictionary, query: Dictionary = {}, reports: Reports = null
) -> Session:
	var value := session()
	value.enable_operations_ui()
	var pipe := ConsumerPipeline.new()
	pipe.supplied = current.duplicate(true)
	pipe.query = query.duplicate(true)
	pipe.clock.minute = current.simulation_minute
	if reports != null:
		pipe.reports = reports
	value.pipeline = pipe
	value.fixture_label = "DEV023-CONSUMER_FIXTURE"
	return value


static func controlled_current(value: Dictionary) -> Dictionary:
	var operations: Dictionary = value.service.snapshot(
		value.minute, value.construction.snapshot_revision
	)
	return {
		"data_version": "1.3",
		"simulation_minute": value.minute,
		"day_id": value.minute / 1440 + 1,
		"snapshot_revision": value.construction.snapshot_revision,
		"observation_phase": "T_COMPLETE",
		"funds": value.ledger.snapshot(),
		"boarding": operations.boarding.duplicate(true),
		"operations": operations,
		"trace": []
	}


static func effects(value: Session) -> String:
	return (
		JSON
		. stringify(
			{
				"clock": value.pipeline.clock.snapshot(),
				"model": value.pipeline.snapshot(),
				"entries": value.pipeline.ledger.entries(),
				"commands": value.pipeline.commands._commands,
				"results": value.pipeline.commands._results,
				"reports": value.pipeline.reports._closed,
				"daily": value.pipeline.reports._days,
				"plan": value.plan.snapshot(),
				"prediction": value.prediction.snapshot()
			}
		)
		. sha256_text()
	)


static func packet(value: Session, kind: String) -> Dictionary:
	var state := value.snapshot()
	return {
		"kind": kind,
		"operations_ui": state.operations_ui,
		"finance_ui": state.finance_ui,
		"next_business_ui": state.next_business_ui
	}
