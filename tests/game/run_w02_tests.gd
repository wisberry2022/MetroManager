extends SceneTree

const Clock = preload("res://scripts/simulation/game_clock.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const Pipeline = preload("res://scripts/simulation/minute_pipeline.gd")
const Queue = preload("res://scripts/simulation/command_queue.gd")

var _checks: int = 0
var _failures: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure", true, false)
	else:
		_test_clock()
		_test_ledger()
		_test_contract_order()
		_test_midnight_and_replay()
		_test_commands()
	print("W02_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _test_clock() -> void:
	for speed: int in [1, 2, 4]:
		var clock := Clock.new()
		clock.set_speed(speed)
		_expect("speed_minutes", clock.advance_usec(5000000), 12 * speed)
		_expect("absolute_minutes", clock.minute, 360 + 12 * speed)
	var day := Clock.new()
	day.advance_usec(600000000)
	_expect("one_day", day.minute, 1800)
	_expect("day_id", day.snapshot().day_id, 2)
	var whole := Clock.new()
	var split := Clock.new()
	whole.advance_usec(10345678)
	for elapsed: int in [1, 234567, 1000000, 8000000, 1111110]:
		split.advance_usec(elapsed)
	_expect("fractional_replay", split.snapshot(), whole.snapshot())
	var before := whole.snapshot()
	_expect("negative_time", whole.advance_usec(-1), 0)
	_expect("negative_no_mutation", whole.snapshot(), before)
	_expect("invalid_speed", whole.set_speed(3), false)
	whole.paused = true
	var paused := whole.snapshot()
	whole.advance_usec(600000000)
	_expect("paused_freezes", whole.snapshot(), paused)
	whole.paused = false
	whole.advance_usec(5000000)
	_expect("resume", whole.minute, int(before.simulation_minute) + 12)


func _test_ledger() -> void:
	var ledger := Ledger.new({"cash": 100})
	_expect("reserve_contract", ledger.contract("P", 80, 110, 360).accepted, true)
	_funds(ledger, [180, 80, 100, 30, 70, 0])
	_expect("construction90", ledger.construction_payment("P", 90, 361), true)
	_funds(ledger, [90, 0, 90, 20, 70, 0])
	_expect("construction20", ledger.construction_payment("P", 20, 362), true)
	_funds(ledger, [70, 0, 70, 0, 70, 0])
	var isolated := Ledger.new(
		{
			"cash": 200,
			"restricted_by_project": {"P1": 80, "P2": 40},
			"reserved_by_project": {"P1": 30, "P2": 10}
		}
	)
	isolated.construction_payment("P1", 90, 360)
	_funds(isolated, [110, 40, 70, 30, 40, 0])
	_expect("other_restricted", isolated.snapshot().restricted_by_project.P2, 40)
	_expect("other_reserved", isolated.snapshot().reserved_by_project.P2, 10)
	var reserved := Ledger.new({"cash": 50, "reserved_by_project": {"P": 48}})
	reserved.operating_cost(3, 360)
	_funds(reserved, [48, 0, 48, 48, 0, 1])
	reserved.fare(11, 361)
	_funds(reserved, [58, 0, 58, 48, 10, 0])
	var cost: int = 0
	for entry: Dictionary in reserved.entries():
		if entry.kind == "operating_cost":
			cost += entry.amount
	_expect("no_cost_reentry", cost, 3)
	var restricted := Ledger.new({"cash": 20, "restricted_by_project": {"P": 20}})
	restricted.operating_cost(3, 360)
	_funds(restricted, [20, 20, 0, 0, 0, 3])
	var before := restricted.snapshot()
	_expect("negative_cost", restricted.operating_cost(-1, 361), false)
	_expect("negative_fare", restricted.fare(-1, 361), false)
	_expect("unknown_project", restricted.construction_payment("NONE", 1, 361), false)
	_expect("no_failure_mutation", restricted.snapshot(), before)
	var insolvent := Ledger.new({"cash": -5})
	_expect("negative_cash_no_bailout", insolvent.snapshot().available_cash, 0)
	_expect("unpaid_not_contract_ban", restricted.contract("NEW", 80, 80, 362).accepted, true)


func _test_contract_order() -> void:
	var pipeline := Pipeline.new({"cash": 79000}, 719)
	pipeline.commands.submit(_contract("C1", "P1", 720, 640000, 720000), 719)
	pipeline.set_fixture(720, {"arrival_fare": 1000})
	pipeline.advance_usec(416667)
	var rejected := pipeline.commands.result("C1")
	_expect("earlier_contract_rejected", rejected.accepted, false)
	_expect("reason", rejected.reason, "OWN_FUNDS_INSUFFICIENT")
	_expect("decision_cash", rejected.decision_funds.cash, 79000)
	_expect("effective_at", rejected.effective_at, 720)
	_funds(pipeline.ledger, [80000, 0, 80000, 0, 80000, 0])
	_expect("no_retroactive_result", pipeline.commands.result("C1"), rejected)
	var phases: Array = []
	for item: Dictionary in pipeline.snapshot().trace:
		phases.append(item.phase)
	_expect(
		"phase_order",
		phases,
		[
			"PREVIOUS_INTERVAL",
			"CONTRACT",
			"PROGRESS",
			"VALIDATION",
			"ARRIVAL",
			"SETTLEMENT",
			"BOARDING"
		]
	)
	var same_time := Pipeline.new(
		{"cash": 20, "restricted_by_project": {"P": 20}, "unpaid": 500}, 719
	)
	same_time.set_fixture(720, {"arrival_fare": 800, "eligible": true, "next_cost": 100})
	same_time.advance_usec(416667)
	_funds(same_time.ledger, [320, 20, 300, 0, 300, 0])
	_expect("same_T_boarding", same_time.snapshot().boarding.boarding_allowed, true)
	_expect(
		"closed_hours", same_time.ledger.boarding(1449, 100).reason_codes, ["OUTSIDE_SERVICE_HOURS"]
	)
	_expect("B0_not_enough", same_time.ledger.boarding(720, 301).boarding_allowed, false)
	_expect("not_open", same_time.ledger.boarding(720, 100, false).boarding_allowed, false)


func _test_midnight_and_replay() -> void:
	var whole := _midnight_fixture()
	var split := _midnight_fixture()
	whole.advance_usec(5000000)
	for index: int in 50:
		split.advance_usec(100000)
	_expect("pipeline_replay", split.snapshot(), whole.snapshot())
	_expect("ledger_replay", split.ledger.entries(), whole.ledger.entries())
	var prior := whole.reports.report(1)
	_expect("prior_fare", prior.fare, 0)
	_expect("day2_fare", whole.reports.current(2).fare, 800)
	_expect("day2_debt_payment", whole.reports.current(2).debt_payment, 500)
	_expect("residual_no_cost", whole.reports.current(2).operating_cost, 0)
	_funds(whole.ledger, [320, 20, 300, 0, 300, 0])
	prior.closing_funds.cash = 9999
	_expect("report_copy", whole.reports.report(1).closing_funds.cash, 20)
	whole.advance_usec(5000000)
	_expect("prior_report_frozen", whole.reports.report(1).fare, 0)
	var same_midnight := Pipeline.new({"cash": 100}, 1439)
	same_midnight.commands.submit(_contract("M", "P", 1800, 80, 80), 1439)
	# 실제 업무시간 제약과 자정 장부 fixture는 별도로 검증한다.
	_expect("midnight_effect_deferred", same_midnight.commands.due(1440).size(), 0)
	_expect("next_business_start", same_midnight.commands.due(1800).size(), 1)


func _test_commands() -> void:
	for speed: int in [2, 4]:
		var normal := _midnight_fixture()
		var fast := _midnight_fixture()
		fast.clock.set_speed(speed)
		normal.advance_usec(5000000)
		fast.advance_usec(5000000 / speed)
		_expect("pipeline_speed_replay", fast.snapshot(), normal.snapshot())
	var guarded := Ledger.new({"cash": 100})
	guarded.contract("P", 80, 110, 400)
	var original := guarded.snapshot()
	var entries := guarded.entries()
	_expect("reject_excess_progress", guarded.construction_payment("P", 111, 401), false)
	_expect("reject_duplicate_project", guarded.contract("P", 80, 110, 401).accepted, false)
	_expect("reject_backdated_cost", guarded.operating_cost(10, 399), false)
	_expect("reject_backdated_fare", guarded.fare(10, 399), false)
	_expect("reject_backdated_contract", guarded.contract("P2", 80, 80, 399).accepted, false)
	_expect("reject_backdated_progress", guarded.construction_payment("P", 10, 399), false)
	_expect("rejections_atomic_funds", guarded.snapshot(), original)
	_expect("rejections_atomic_entries", guarded.entries(), entries)
	var debt := Ledger.new({"cash": 50, "unpaid": 40})
	_expect("B_priority_insufficient", debt.contract("P", 80, 100, 360).accepted, false)
	_expect("B_priority_failure_no_pay", debt.snapshot().unpaid, 40)
	_expect("B_priority_covered", debt.contract("P", 80, 90, 360).accepted, true)
	_funds(debt, [90, 80, 10, 10, 0, 0])

	var pipeline := Pipeline.new({"cash": 100})
	var command := _contract("C", "P", 361, 80, 110)
	command.expected_snapshot_revision = 999
	var pending := pipeline.commands.submit(command, 360)
	_expect("duplicate_pending", pipeline.commands.submit(command, 360), pending)
	pipeline.clock.paused = true
	pipeline.advance_usec(5000000)
	_expect("paused_no_effect", pipeline.commands.result("C"), {})
	pipeline.clock.paused = false
	pipeline.advance_usec(416667)
	var result := pipeline.commands.result("C")
	_expect("envelope_revision_not_blanket_rejection", result.accepted, true)
	var funds := pipeline.ledger.snapshot()
	_expect("duplicate_result", pipeline.commands.submit(command, 361), result)
	_expect("duplicate_no_economy", pipeline.ledger.snapshot(), funds)
	var stale := _contract("STALE", "P2", 362, 80, 80)
	stale.target_revision = 1
	pipeline.target_revisions.P2 = 2
	pipeline.commands.submit(stale, 361)
	pipeline.advance_usec(416667)
	_expect("changed_meaning", pipeline.commands.result("STALE").reason, "STATE_CHANGED")
	_expect("changed_no_economy", pipeline.ledger.snapshot(), funds)
	var queue := Queue.new()
	_expect("closed_phase", queue.submit(command, 361).reason, "CLOSED_EFFECTIVE_TIME")
	_expect("malformed_id", queue.submit({}, 360).reason, "INVALID_COMMAND")
	var bad := _contract("BAD", "P3", 362, 80, 80)
	bad.government = -1
	_expect("invalid_payload", queue.submit(bad, 360).reason, "INVALID_PAYLOAD")
	_expect("invalid_fixture", pipeline.set_fixture(363, {"arrival_fare": -1}), false)


func _midnight_fixture() -> Pipeline:
	var pipeline := Pipeline.new(
		{"cash": 20, "restricted_by_project": {"P": 20}, "unpaid": 500}, 1439
	)
	pipeline.set_fixture(1449, {"arrival_fare": 800, "eligible": true})
	return pipeline


func _contract(id: String, target: String, minute: int, grant: int, cost: int) -> Dictionary:
	return {
		"command_id": id,
		"target_id": target,
		"target_revision": 0,
		"requested_at": minute - 1,
		"effective_at": minute,
		"government": grant,
		"total_cost": cost
	}


func _funds(ledger: Ledger, expected: Array) -> void:
	var state := ledger.snapshot()
	_expect(
		"C/R/F/K/A/B",
		[
			state.cash,
			state.restricted,
			state.free_cash,
			state.reserved,
			state.available_cash,
			state.unpaid
		],
		expected
	)


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
