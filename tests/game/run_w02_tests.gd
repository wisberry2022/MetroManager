extends SceneTree

const Clock = preload("res://scripts/simulation/game_clock.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const Pipeline = preload("res://scripts/simulation/minute_pipeline.gd")
const Queue = preload("res://scripts/simulation/command_queue.gd")
const MidnightFixture = preload("res://tests/game/w02_midnight_fixture.gd")

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
		_test_midnight_composite()
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


func _test_midnight_composite() -> void:
	var reference: Dictionary = {}
	for speed: int in [1, 2, 4]:
		for split: bool in [false, true]:
			var pipeline := MidnightFixture.new()
			pipeline.clock.set_speed(speed)
			var event := {
				"operating_cost": 3, "construction": [{"project": "MIDNIGHT", "amount": 60}]
			}
			_expect("composite_fixture", pipeline.set_fixture(1440, event), true)
			_expect("composite_duplicate_fixture", pipeline.set_fixture(1440, event), false)
			var command := _contract("PLAYER", "OTHER", 1440, 80, 80)
			var pending := pipeline.commands.submit(command, 1439)
			_expect("composite_player_deferred", pending.effective_at, 1800)
			_expect("composite_duplicate_command", pipeline.commands.submit(command, 1439), pending)
			pipeline.clock.paused = true
			pipeline.advance_usec(1000000)
			_expect("composite_paused_clock", pipeline.clock.minute, 1439)
			_expect("composite_paused_funds", pipeline.ledger.snapshot().cash, 100)
			_expect("composite_paused_no_payment", pipeline.payment_dispatches, 0)
			pipeline.clock.paused = false
			var chunks: Array[int] = [1000000]
			if split:
				chunks.assign([4, 996, 50000, 199000, 750000])
			for elapsed: int in chunks:
				pipeline.advance_usec(elapsed / speed)
			_assert_midnight_composite(pipeline, pending)
			var actual := _composite_state(pipeline)
			if reference.is_empty():
				reference = actual
				print("W02_MIDNIGHT_EVIDENCE ", JSON.stringify(actual))
			_expect("composite_split_speed_equivalence", actual, reference)
			_assert_midnight_idempotence(pipeline, pending)


func _assert_midnight_composite(pipeline: MidnightFixture, pending: Dictionary) -> void:
	_expect("composite_minute", pipeline.clock.minute, 1441)
	_expect("composite_phase", pipeline.snapshot().observation_phase, "T_COMPLETE")
	_expect("composite_internal_payment", pipeline.payment_result.accepted, true)
	_expect("composite_internal_dispatch_once", pipeline.payment_dispatches, 1)
	_expect("composite_closed_before_payment", pipeline.closed_before_payment.day_id, 1)
	_expect("composite_closing_cash", pipeline.closed_before_payment.closing_funds.cash, 97)
	_expect("composite_pre_payment_cash", pipeline.before_payment.cash, 97)
	_funds(pipeline.ledger, [117, 20, 97, 0, 97, 0])
	var day1 := pipeline.reports.report(1)
	var expected_day1 := {
		"day_id": 1,
		"operating_cost": 3,
		"construction_cost": 0,
		"fare": 0,
		"government": 0,
		"payment": 3,
		"debt_payment": 0,
		"construction_payment": 0,
		"closing_funds":
		{
			"cash": 97,
			"restricted_by_project": {},
			"reserved_by_project": {},
			"restricted": 0,
			"reserved": 0,
			"free_cash": 97,
			"available_cash": 97,
			"unpaid": 0
		}
	}
	_expect("composite_day1_exact", day1, expected_day1)
	_expect(
		"composite_day2_exact",
		pipeline.reports.current(2),
		{
			"day_id": 2,
			"operating_cost": 0,
			"construction_cost": 60,
			"fare": 0,
			"government": 80,
			"payment": 0,
			"debt_payment": 0,
			"construction_payment": 60
		}
	)
	_expect("composite_day2_not_closed", pipeline.reports.report(2), {})
	_expect(
		"composite_positive_entries",
		_positive_entries(pipeline),
		[
			{"kind": "operating_cost", "amount": 3, "effective_at": 1439},
			{"kind": "payment", "amount": 3, "effective_at": 1439},
			{"kind": "government", "amount": 80, "effective_at": 1440},
			{"kind": "construction_cost", "amount": 60, "effective_at": 1440},
			{"kind": "construction_payment", "amount": 60, "effective_at": 1440}
		]
	)
	_expect("composite_close_once", pipeline.close_calls(), {1: 1})
	_expect("composite_player_still_pending", pipeline.commands.result("PLAYER"), {})
	_expect("composite_no_midnight_player", pipeline.commands.due(1440), [])
	_expect("composite_player_pending_unchanged", pending.effective_at, 1800)
	var phases: Array[String] = []
	for item: Dictionary in pipeline.snapshot().trace:
		if item.effective_at == 1440:
			phases.append(item.phase)
	_expect(
		"composite_stage_order",
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


func _assert_midnight_idempotence(pipeline: MidnightFixture, pending: Dictionary) -> void:
	var before := _composite_state(pipeline)
	var report := pipeline.reports.report(1)
	report.closing_funds.cash = -1
	_expect("composite_report_copy", pipeline.reports.report(1), before.closed_report)
	_expect("composite_requery", _composite_state(pipeline), before)
	_expect("composite_closed_fixture", pipeline.set_fixture(1440, {"operating_cost": 3}), false)
	_expect(
		"composite_duplicate_payment",
		pipeline.ledger.contract("MIDNIGHT", 80, 80, 1441).reason,
		"DUPLICATE_PROJECT"
	)
	var duplicate := _contract("PLAYER", "OTHER", 1440, 80, 80)
	_expect("composite_pending_requery", pipeline.commands.submit(duplicate, 1441), pending)
	_expect("composite_duplicate_no_effect", _composite_state(pipeline), before)
	pipeline.advance_usec(0)
	_expect("composite_zero_advance", _composite_state(pipeline), before)
	pipeline.advance_usec(5000000)
	_expect("composite_later_report_frozen", pipeline.reports.report(1), before.closed_report)
	_expect("composite_later_funds", pipeline.ledger.snapshot(), before.pipeline.funds)
	_expect(
		"composite_later_no_positive_duplicate",
		_positive_entries(pipeline),
		before.positive_entries
	)
	_expect("composite_later_close_once", pipeline.close_calls(), {1: 1})
	_expect("composite_later_payment_once", pipeline.payment_dispatches, 1)
	_expect("composite_later_day2", pipeline.reports.current(2), before.current_report)


func _positive_entries(pipeline: MidnightFixture) -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	for entry: Dictionary in pipeline.ledger.entries():
		if entry.amount > 0:
			entries.append(entry)
	return entries


func _composite_state(pipeline: MidnightFixture) -> Dictionary:
	var clock := pipeline.clock.snapshot()
	clock.erase("speed")
	return {
		"clock_without_speed": clock,
		"pipeline": pipeline.snapshot(),
		"closed_report": pipeline.reports.report(1),
		"current_report": pipeline.reports.current(2),
		"entries": pipeline.ledger.entries(),
		"positive_entries": _positive_entries(pipeline),
		"close_calls": pipeline.close_calls(),
		"payment_dispatches": pipeline.payment_dispatches
	}


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
