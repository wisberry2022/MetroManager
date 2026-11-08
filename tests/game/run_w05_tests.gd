extends SceneTree

const FX = preload("res://tests/game/w05_fixtures.gd")
const BidFX = preload("res://tests/game/w04a_fixtures.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const Service = preload("res://scripts/simulation/construction_service.gd")
const Project = preload("res://scripts/model/construction_project.gd")
const Pipeline = preload("res://scripts/simulation/minute_pipeline.gd")

var _checks: int = 0
var _failures: int = 0
var _assertions: Array[Dictionary] = []
var _cases: Array[Dictionary] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure", true, false)
	else:
		print("W05_SECTION standard")
		_test_standard()
		print("W05_SECTION commands")
		_test_commands()
		print("W05_SECTION funds")
		_test_funds()
		print("W05_SECTION suspension")
		_test_suspension()
		print("W05_SECTION validation")
		_test_fast_and_validation()
		print("W05_SECTION time")
		_test_time()
		_test_procedure_boundaries()
		_write_evidence()
	print("W05_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _test_standard() -> void:
	var pipe := FX.started()
	var initial := pipe.snapshot()
	var start: int = FX.row(pipe).started_at
	_expect("standard_start", start, 1802)
	_expect("start_no_work", FX.row(pipe).elapsed_minutes, 0)
	pipe.set_fixture(start + 1, {"eligible": true, "next_cost": 0})
	_expect(
		"separate_contract_id",
		FX.row(pipe).construction_contract_id,
		"B01-R1-BUSINESS-CONSTRUCTION"
	)
	for item: Array in [[1, 208], [2, 416], [3, 625], [2879, 599791], [2880, 600000]]:
		BidFX.advance_to(pipe, start + int(item[0]))
		var row := FX.row(pipe)
		if item[0] == 1:
			_expect(
				"preopen_boarding_blocked",
				pipe.snapshot().boarding.reason_codes,
				["SERVICE_NOT_READY"]
			)
		_expect("standard_elapsed_" + str(item[0]), row.elapsed_minutes, item[0])
		_expect("standard_floor_" + str(item[0]), row.accrued, item[1])
		_expect("standard_paid_" + str(item[0]), row.paid, item[1])
		_expect("standard_due_" + str(item[0]), row.construction_payable, 0)
	_expect("standard_completed", FX.row(pipe).status, "COMPLETED")
	_expect("standard_completion_time", FX.row(pipe).completed_at, start + 2880)
	_expect("standard_funds", _money(pipe.ledger), [1200000, 200000, 1000000, 0, 0])
	_expect("government_once", _count(pipe.ledger, "government"), 1)
	_expect("construction_accrual_total", _sum(pipe.ledger, "construction_cost"), 600000)
	_expect("construction_payment_total", _sum(pipe.ledger, "construction_payment"), 600000)
	_expect("not_automatically_open", FX.row(pipe).service_ready, false)
	_expect("no_fare", _sum(pipe.ledger, "fare"), 0)
	_record("B01_STANDARD", initial, pipe, {"funds": [1200000, 200000, 1000000, 0, 0]})
	var delayed := FX.started("STANDARD", 2000)
	BidFX.advance_to(delayed, 4879)
	_expect("delayed_no_backdate", FX.row(delayed).status, "BUILDING")
	BidFX.advance_to(delayed, 4880)
	_expect("delayed_complete", FX.row(delayed).completed_at, 4880)
	var same := FX.awarded()
	var contract := FX.command(same, "contract", "a-contract")
	var begin := FX.command(same, "start", "b-start")
	same.submit_construction(contract)
	same.submit_construction(begin)
	BidFX.advance_to(same, 1801)
	_expect("same_minute_contract_start", same.construction_result("b-start").accepted, true)
	BidFX.advance_to(same, 4681)
	_expect("owner_example_4681", FX.row(same).completed_at, 4681)


func _test_commands() -> void:
	var disabled := Pipeline.new()
	_expect("disabled_enable", disabled.enable_construction().accepted, false)
	_expect("disabled_submit", disabled.submit_construction({}).reason, "CONSTRUCTION_NOT_ENABLED")
	var pipe := FX.awarded()
	var before := pipe.ledger.entries()
	_expect("enable_once", pipe.enable_construction().accepted, false)
	var cmd := FX.command(pipe, "contract", "once")
	var pending := pipe.submit_construction(cmd)
	var changed := cmd.duplicate(true)
	changed.mode = "FAST"
	_expect("pending_idempotent", pipe.submit_construction(changed), pending)
	BidFX.advance_to(pipe, 1801)
	var result := pipe.construction_result("once")
	_expect("contract_accepted", result.accepted, true)
	_expect(
		"contract_no_government_repay",
		pipe.ledger.entries().filter(
			func(entry: Dictionary) -> bool: return entry.kind == "government"
		),
		before.filter(func(entry: Dictionary) -> bool: return entry.kind == "government")
	)
	_expect("final_idempotent", pipe.submit_construction(changed), result)
	_expect(
		"new_id_duplicate_contract",
		FX.execute(pipe, "contract", "duplicate").reason,
		"CONSTRUCTION_CONTRACT_EXISTS"
	)
	_expect("premature_safety", FX.execute(pipe, "safety", "premature").accepted, false)
	var stale := FX.command(pipe, "start", "stale")
	stale.target_revision = 1
	pipe.submit_construction(stale)
	BidFX.advance_to(pipe, stale.effective_at)
	_expect("stale_revision", pipe.construction_result("stale").reason, "STATE_CHANGED")
	_expect("stale_no_progress", FX.row(pipe).elapsed_minutes, 0)
	var valid := FX.command(pipe, "start", "valid")
	valid.expected_snapshot_revision = 0
	pipe.submit_construction(valid)
	BidFX.advance_to(pipe, valid.effective_at)
	_expect("time_only_revision", pipe.construction_result("valid").accepted, true)
	var frozen := pipe.snapshot()
	var entries := pipe.ledger.entries()
	for index: int in range(10):
		var copy := pipe.snapshot()
		copy.construction.projects[0].station_ids.clear()
		copy.construction.projects[0].status = "OPEN"
		copy.construction.funds.cash = 0
		var response := pipe.construction_result("valid")
		response.accepted = false
	_expect("read_no_effect", pipe.snapshot(), frozen)
	_expect("read_ledger_no_effect", pipe.ledger.entries(), entries)
	for key: String in [
		"project_id",
		"business_contract_id",
		"action",
		"requested_at",
		"effective_at",
		"target_revision",
		"expected_snapshot_revision"
	]:
		var bad := FX.command(pipe, "open", "bad-" + key)
		bad[key] = null
		_expect("invalid_type_" + key, pipe.submit_construction(bad).accepted, false)
	var extra := FX.command(pipe, "open", "extra")
	extra.government = 999
	_expect("fixed_terms", pipe.submit_construction(extra).reason, "FIXED_TERMS")
	var past := FX.command(pipe, "open", "past")
	past.effective_at = pipe.clock.minute
	_expect("no_backdating", pipe.submit_construction(past).reason, "CLOSED_EFFECTIVE_TIME")
	var unknown := FX.command(pipe, "open", "unknown")
	unknown.project_id = "OTHER"
	pipe.submit_construction(unknown)
	BidFX.advance_to(pipe, unknown.effective_at)
	_expect(
		"unknown_project",
		pipe.construction_result("unknown").reason,
		"UNKNOWN_CONSTRUCTION_PROJECT"
	)
	var empty := BidFX.pipeline()
	empty.enable_construction()
	_expect("no_business_source", FX.execute(empty, "contract", "no-source").accepted, false)
	_expect("no_business_no_partial", empty.snapshot().construction.projects, [])
	# 지급 없음/다른 원장/잘못된 연결을 source consumer 자체에서 검증한다.
	var source: Dictionary = BidFX.row(FX.awarded())
	for field: String in ["available", "ledger_entry_index", "restricted_project_id", "amount"]:
		var bad_source := source.duplicate(true)
		bad_source.business_contract.government_payment[field] = (
			false if field == "available" else -1
		)
		var service := Service.new(FX.awarded().ledger)
		var input := cmd.duplicate(true)
		service.submit(input, 1800)
		service.process_phase("CONTRACT", 1801, 0, {"tenders": [bad_source]})
		_expect("invalid_payment_link_" + field, service.result("once").accepted, false)


func _test_funds() -> void:
	var ledger := Ledger.new({"cash": 100})
	_expect("nonzero_k_contract", ledger.contract("P", 80, 110, 360).accepted, true)
	_expect("nonzero_k_before", _money(ledger), [180, 80, 100, 30, 0])
	_expect("nonzero_k_first", ledger.construction_payment("P", 90, 361), true)
	_expect("nonzero_k_decrease", _money(ledger), [90, 0, 90, 20, 0])
	_expect("nonzero_k_final", ledger.construction_payment("P", 20, 362), true)
	_expect("nonzero_k_zero", _money(ledger), [70, 0, 70, 0, 0])
	var isolated := Ledger.new(
		{
			"cash": 200,
			"restricted_by_project": {"P1": 80, "P2": 40},
			"reserved_by_project": {"P1": 30, "P2": 10}
		}
	)
	_expect("two_project_payment", isolated.construction_payment("P1", 90, 360), true)
	_expect("two_project_funds", _money(isolated), [110, 40, 70, 30, 0])
	_expect("other_restricted_unchanged", isolated.snapshot().restricted_by_project.P2, 40)
	_expect("other_reserved_unchanged", isolated.snapshot().reserved_by_project.P2, 10)
	var guard := Ledger.new(
		{
			"cash": 100,
			"restricted_by_project": {"P1": 0, "P2": 80},
			"reserved_by_project": {"P1": 30, "P2": 0}
		}
	)
	var before := guard.snapshot()
	_expect("cannot_spend_other_R", guard.construction_payment("P1", 30, 360), false)
	_expect("protected_no_effect", guard.snapshot(), before)
	for available: int in [9999, 10000]:
		var repair := Ledger.new(
			{
				"cash": 50000 + available,
				"restricted_by_project": {"P1": 10000, "P2": 30000},
				"reserved_by_project": {"P1": 5000, "P2": 5000},
				"unpaid": 7
			}
		)
		var initial := repair.snapshot()
		var prior := repair.entries()
		_expect(
			"repair_atomic_" + str(available),
			repair.repair_payment("P1", 20000, 360),
			available == 10000
		)
		if available == 9999:
			_expect("repair_failure_unchanged", repair.snapshot(), initial)
			_expect("repair_failure_no_entries", repair.entries(), prior)
		else:
			_expect("repair_R_first", repair.snapshot().restricted_by_project.P1, 0)
			_expect("repair_other_R", repair.snapshot().restricted_by_project.P2, 30000)
			_expect(
				"repair_K_unchanged",
				repair.snapshot().reserved_by_project,
				initial.reserved_by_project
			)
			_expect("repair_B_unchanged", repair.snapshot().unpaid, 7)


func _test_suspension() -> void:
	var pipe := FX.started()
	var id: String = FX.row(pipe).project_id
	var start: int = FX.row(pipe).started_at
	BidFX.advance_to(pipe, start + 2)
	_expect("first_two_paid", FX.row(pipe).paid, 416)
	# 内部資金不足 fixture: 残余 R を別の承認済み支払APIで消費。ゲーム機能ではない。
	var remainder: int = pipe.ledger.snapshot().restricted_by_project[id]
	pipe.ledger.construction_payment(id, remainder, pipe.clock.minute, false)
	var initial := pipe.snapshot()
	BidFX.advance_to(pipe, start + 3)
	_expect("failed_progress_preserved", FX.row(pipe).elapsed_minutes, 3)
	_expect("failed_accrual_preserved", FX.row(pipe).accrued, 625)
	_expect("failed_paid", FX.row(pipe).paid, 416)
	_expect("failed_due", FX.row(pipe).construction_payable, 209)
	_expect("failed_suspended", FX.row(pipe).status, "SUSPENDED")
	_expect("failed_not_B", pipe.ledger.snapshot().unpaid, 0)
	BidFX.advance_to(pipe, start + 10)
	_expect("stopped_progress", FX.row(pipe).elapsed_minutes, 3)
	_expect(
		"resume_still_insufficient",
		FX.execute(pipe, "resume", "no-funds").reason,
		"CONSTRUCTION_PAYMENT_DUE"
	)
	_record("SUSPENDED_209", initial, pipe, {"elapsed_minutes": 3, "payable": 209, "B": 0})
	# 同じサービスと原帳状態で不足を再現し、外部テスト入金後に既存債務だけ再試行。
	var source: Dictionary = BidFX.row(FX.awarded())
	var ledger := Ledger.new(
		{"cash": 0, "restricted_by_project": {id: 0}, "reserved_by_project": {id: 209}}
	)
	var project := Project.new(source, "STANDARD", 1800)
	project.apply("start", 1801)
	for minute: int in range(1802, 1805):
		project.accrue(minute)
	project.state.paid = 416
	project.state.construction_payable = 209
	project.payment(false, 1804)
	ledger.fare(209, 1805)
	_expect("recovery_existing_payment", ledger.construction_payment(id, 209, 1805, false), true)
	project.payment(true, 1805)
	project.apply("resume", 1805)
	_expect("recovery_no_reaccrual", project.state.accrued, 625)
	_expect("recovery_paid_once", project.state.paid, 625)
	_expect("recovery_due_zero", project.state.construction_payable, 0)
	_expect("recovery_cost_zero", _sum(ledger, "construction_cost"), 0)
	var final := FX.started()
	var final_start: int = FX.row(final).started_at
	BidFX.advance_to(final, final_start + 2879)
	var final_id: String = FX.row(final).project_id
	var left: int = final.ledger.snapshot().restricted_by_project[final_id]
	final.ledger.construction_payment(final_id, left, final.clock.minute, false)
	BidFX.advance_to(final, final_start + 2880)
	_expect("100pct_not_completed", FX.row(final).status, "SUSPENDED")
	_expect("100pct_preserved", FX.row(final).elapsed_minutes, 2880)
	_expect("100pct_final_due", FX.row(final).construction_payable, 209)
	_expect("100pct_no_completed_time", FX.row(final).completed_at, null)


func _test_fast_and_validation() -> void:
	for mode: String in ["STANDARD", "FAST"]:
		var pipe := FX.started(mode)
		var initial := pipe.snapshot()
		var start: int = FX.row(pipe).started_at
		var duration := 1440 if mode == "FAST" else 2880
		BidFX.advance_to(pipe, start + duration)
		_expect(mode + "_complete", FX.row(pipe).status, "COMPLETED")
		_expect(mode + "_before_open", FX.row(pipe).service_ready, false)
		_expect(mode + "_open_rejected", FX.execute(pipe, "open", "too-early").accepted, false)
		_expect(mode + "_trial_start", FX.execute(pipe, "trial", "trial").accepted, true)
		var trial: int = pipe.clock.minute
		_expect(mode + "_overlap_rejected", FX.execute(pipe, "safety", "overlap").accepted, false)
		BidFX.advance_to(pipe, trial + 59)
		_expect(mode + "_trial_59", FX.row(pipe).trial_status, "RUNNING")
		BidFX.advance_to(pipe, trial + 60)
		_expect(mode + "_trial_60", FX.row(pipe).trial_status, "PASSED")
		_expect(mode + "_safety_start", FX.execute(pipe, "safety", "safety").accepted, true)
		var safety: int = pipe.clock.minute
		BidFX.advance_to(pipe, safety + 59)
		_expect(mode + "_safety_59", FX.row(pipe).safety_status, "RUNNING")
		BidFX.advance_to(pipe, safety + 60)
		if mode == "FAST":
			_expect("fast_first_failure", FX.row(pipe).safety_status, "FAILED")
			_expect("fast_one_defect", FX.row(pipe).defects, 1)
			_expect("fast_initial_funds", _money(pipe.ledger), [1080000, 80000, 1000000, 0, 0])
			_expect("fast_repair_start", FX.execute(pipe, "repair", "repair").accepted, true)
			var repair: int = pipe.clock.minute
			_expect("fast_repair_funds", _money(pipe.ledger), [1060000, 60000, 1000000, 0, 0])
			BidFX.advance_to(pipe, repair + 29)
			_expect("repair_29", FX.row(pipe).defects, 1)
			BidFX.advance_to(pipe, repair + 30)
			_expect("repair_30", FX.row(pipe).defects, 0)
			_expect("retest_required", FX.row(pipe).safety_status, "NOT_STARTED")
			_expect("retest_start", FX.execute(pipe, "safety", "retest").accepted, true)
			BidFX.advance_to(pipe, pipe.clock.minute + 60)
			_expect("no_repeated_defect", FX.row(pipe).defects, 0)
		_expect(mode + "_safety_pass", FX.row(pipe).safety_status, "PASSED")
		_expect(mode + "_open", FX.execute(pipe, "open", "open").accepted, true)
		_expect(mode + "_service_ready", FX.row(pipe).service_ready, true)
		_expect(
			mode + "_open_duplicate_new_id", FX.execute(pipe, "open", "open-again").accepted, false
		)
		_expect(mode + "_no_product_fare", _sum(pipe.ledger, "fare"), 0)
		_record(mode + "_OPEN", initial, pipe, {"service_ready": true})
	var source: Dictionary = BidFX.row(FX.awarded())
	var project := Project.new(source, "STANDARD", 1800)
	var repeated := Project.new(source, "STANDARD", 1800)
	repeated.apply("start", 1801)
	_expect("progress_first_accrual", repeated.accrue(1802), 208)
	_expect("progress_same_minute_no_repeat", repeated.accrue(1802), 0)
	_expect("progress_no_backdate", repeated.accrue(1801), 0)
	_expect("progress_once_elapsed", repeated.state.elapsed_minutes, 1)
	project.state.status = "COMPLETED"
	project.apply("trial", 5000)
	project.validate_at(5059)
	_expect("direct_trial59", project.state.trial_status, "RUNNING")
	project.validate_at(5060)
	project.apply("safety", 5060)
	project.invalidate_conditions()
	project.validate_at(5120)
	_expect("invalidated_trial", project.state.trial_status, "NOT_STARTED")
	_expect("late_old_validation_ignored", project.state.safety_status, "NOT_STARTED")
	_expect("invalidated_cannot_open", project.action_error("open"), "PREREQUISITE_NOT_MET")


func _test_time() -> void:
	var expected: Dictionary = {}
	for speed: int in [1, 2, 4]:
		for split: bool in [false, true]:
			var pipe := FX.started()
			pipe.clock.set_speed(speed)
			pipe.clock.paused = true
			var paused := pipe.snapshot()
			pipe.advance_usec(10000000)
			_expect("pause_no_effect", pipe.snapshot(), paused)
			pipe.clock.paused = false
			if split:
				for minute: int in range(1803, 4683):
					BidFX.advance_to(pipe, minute)
			else:
				pipe.advance_usec(1)
				_expect("partial_minute_no_work", FX.row(pipe).elapsed_minutes, 0)
				BidFX.advance_to(pipe, 4682)
			var result := {
				"construction": pipe.snapshot().construction,
				"entries": pipe.ledger.entries(),
				"report": pipe.reports.report(3)
			}
			if expected.is_empty():
				expected = result
			_expect("speed_split_" + str(speed) + "_" + str(split), result, expected)
	var midnight := FX.started("STANDARD", 2000)
	BidFX.advance_to(midnight, 2879)
	var accrued_before: int = FX.row(midnight).accrued
	BidFX.advance_to(midnight, 2880)
	var delta: int = FX.row(midnight).accrued - accrued_before
	_expect(
		"midnight_previous_accrual",
		midnight.reports.report(2).construction_cost,
		FX.row(midnight).accrued
	)
	_expect("midnight_newday_payment", midnight.reports.current(3).construction_payment, delta)
	var closed := midnight.reports.report(2)
	BidFX.advance_to(midnight, 2900)
	_expect("closed_report_immutable", midnight.reports.report(2), closed)
	var contract_pipe := FX.awarded()
	BidFX.advance_to(contract_pipe, 2939)
	var deferred := FX.command(contract_pipe, "contract", "night-contract")
	deferred.effective_at = 2940
	_expect(
		"contract_night_deferred", contract_pipe.submit_construction(deferred).effective_at, 3240
	)
	BidFX.advance_to(contract_pipe, 2940)
	_expect("night_contract_pending", contract_pipe.construction_result("night-contract"), {})
	BidFX.advance_to(contract_pipe, 3240)
	_expect(
		"deferred_actual_time",
		contract_pipe.construction_result("night-contract").effective_at,
		3240
	)
	var night := FX.awarded()
	FX.execute(night, "contract", "contract")
	BidFX.advance_to(night, 2939)
	_expect("night_start_allowed", FX.execute(night, "start", "night-start").effective_at, 2940)
	_expect("night_start_no_backdate", FX.row(night).elapsed_minutes, 0)
	var trace: Array = midnight.snapshot().trace.filter(
		func(item: Dictionary) -> bool: return item.effective_at == 2880
	)
	_expect(
		"fixed_phase_order",
		trace.map(func(item: Dictionary) -> String: return item.phase),
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


func _test_procedure_boundaries() -> void:
	var pipe := FX.awarded()
	var source := BidFX.row(pipe)
	var project := Project.new(source, "STANDARD", 1800)
	project.state.status = "COMPLETED"
	project.apply("trial", 5000)
	project.validate_at(5060)
	project.apply("safety", 5060)
	project.validate_at(5119)
	_expect("independent_safety59", project.state.safety_status, "RUNNING")
	project.validate_at(5120)
	_expect("independent_safety60", project.state.safety_status, "PASSED")
	var fast := Project.new(source, "FAST", 1800)
	fast.state.status = "COMPLETED"
	fast.state.trial_status = "PASSED"
	fast.state.first_defect_issued = true
	fast.state.defects = 1
	fast.apply("repair", 6000)
	fast.validate_at(6030)
	fast.apply("safety", 6030)
	fast.validate_at(6089)
	_expect("retest59", fast.state.safety_status, "RUNNING")
	fast.validate_at(6090)
	_expect("retest60", fast.state.safety_status, "PASSED")
	# 전용 내부 fixture: 실제 서비스의 원자적 수리 거부와 후순위 운임을 분리한다.
	var ledger := Ledger.new(
		{"cash": 19999, "restricted_by_project": {"P-A": 10000}, "reserved_by_project": {"P-A": 0}}
	)
	var service := Service.new(ledger)
	var repair_project := Project.new(source, "FAST", 1800)
	repair_project.state.status = "COMPLETED"
	repair_project.state.defects = 1
	service._projects["P-A"] = repair_project
	var cmd := FX.command(pipe, "repair", "repair-insufficient", "FAST")
	cmd.requested_at = 2939
	cmd.effective_at = 2940
	var before := ledger.snapshot()
	service.submit(cmd, 2939)
	service.process_phase("VALIDATION", 2940, 100, {})
	_expect(
		"repair_no_later_fare_prespend",
		service.result(cmd.command_id).reason,
		"REPAIR_FUNDS_INSUFFICIENT"
	)
	_expect("repair_no_partial_cash", ledger.snapshot(), before)
	_expect("repair_not_started", repair_project.state.procedure, "")
	_expect("repair_unpaid_zero", repair_project.state.repair_paid, 0)
	ledger.fare(1, 2940)
	cmd.command_id = "repair-night-valid"
	cmd.requested_at = 2940
	cmd.effective_at = 2941
	service.submit(cmd, 2940)
	service.process_phase("VALIDATION", 2941, 101, {})
	_expect("repair24h_allowed", service.result(cmd.command_id).effective_at, 2941)
	_expect("repair_valid_started", repair_project.state.procedure, "repair")
	_expect("repair_funded_full", repair_project.state.repair_paid, 20000)
	service.process_phase("VALIDATION", 2941, 102, {})
	_expect("same_phase_duplicate_no_payment", _sum(ledger, "construction_payment"), 20000)
	# 미지급 기성의 실제 서비스 재개. 승인된 비영 K/부족 회복 내부 원장 반례.
	var recovery_ledger := Ledger.new(
		{"cash": 0, "restricted_by_project": {"P-A": 0}, "reserved_by_project": {"P-A": 209}}
	)
	var recovery := Service.new(recovery_ledger)
	var suspended := Project.new(source, "STANDARD", 1800)
	suspended.state.status = "SUSPENDED"
	suspended.state.started_at = 1801
	suspended.state.elapsed_minutes = 3
	suspended.state.accrued = 625
	suspended.state.paid = 416
	suspended.state.construction_payable = 209
	recovery._projects["P-A"] = suspended
	cmd = FX.command(pipe, "resume", "resume-after-recovery")
	cmd.requested_at = 2940
	cmd.effective_at = 2941
	recovery_ledger.fare(209, 2940)
	recovery.submit(cmd, 2940)
	recovery.process_phase("PROGRESS", 2941, 200, {})
	_expect("resume24h_valid", recovery.result(cmd.command_id).accepted, true)
	_expect("resume_existing_due_paid", suspended.state.paid, 625)
	_expect("resume_no_new_accrual_same_T", suspended.state.elapsed_minutes, 3)
	_expect("resume_cost_not_repeated", _sum(recovery_ledger, "construction_cost"), 0)
	recovery.accrue(2942)
	_expect("resume_next_interval_progress", suspended.state.elapsed_minutes, 4)
	_cases.append(
		{
			"id": "REPAIR_AND_RESUME_BOUNDARIES",
			"status": "EXECUTED",
			"fixture_kind": "INTERNAL_APPROVED_PROTECTION_COUNTEREXAMPLE",
			"initial_repair_funds": before,
			"expected":
			{"repair_effective": 2941, "resume_effective": 2941, "partial_payment": false},
			"actual_repair": repair_project.snapshot(),
			"repair_result": service.result("repair-night-valid"),
			"repair_ledger": ledger.entries(),
			"actual_recovery": suspended.snapshot(),
			"resume_result": recovery.result("resume-after-recovery"),
			"resume_ledger": recovery_ledger.entries()
		}
	)


func _money(ledger: Ledger) -> Array:
	var funds := ledger.snapshot()
	return [funds.cash, funds.restricted, funds.free_cash, funds.reserved, funds.unpaid]


func _sum(ledger: Ledger, kind: String) -> int:
	var total := 0
	for entry: Dictionary in ledger.entries():
		if entry.kind == kind:
			total += entry.amount
	return total


func _count(ledger: Ledger, kind: String) -> int:
	return (
		ledger.entries().filter(func(entry: Dictionary) -> bool: return entry.kind == kind).size()
	)


func _expect(label: String, actual: Variant, expected: Variant) -> void:
	_checks += 1
	var passed: bool = actual == expected
	if not passed:
		_failures += 1
		push_error(label + ": actual=" + str(actual) + " expected=" + str(expected))
	_assertions.append(
		{
			"label": label,
			"passed": passed,
			"actual": _summary(actual),
			"expected": _summary(expected)
		}
	)


func _summary(value: Variant) -> Variant:
	if value is Dictionary or value is Array:
		return {"json_sha256": JSON.stringify(value).sha256_text()}
	return value


func _record(id: String, initial: Dictionary, pipe: Pipeline, expected: Dictionary) -> void:
	var before := initial.duplicate(true)
	before.erase("trace")
	var after := pipe.snapshot()
	after.erase("trace")
	var commands: Array[Dictionary] = []
	for command_id: String in [
		"contract", "start", "no-funds", "trial", "safety", "repair", "retest", "open"
	]:
		var result := pipe.construction_result(command_id)
		if not result.is_empty():
			commands.append(result)
	_cases.append(
		{
			"id": id,
			"status": "EXECUTED",
			"initial": before,
			"expected": expected,
			"actual": after,
			"ledger": FX.nonzero_entries(pipe),
			"command_results": commands
		}
	)


func _write_evidence() -> void:
	if "--evidence" not in OS.get_cmdline_user_args():
		return
	var base := "res://docs/engineering/evidence/DEV-020_W05_"
	var fixtures := FileAccess.open(base + "FIXTURES.json", FileAccess.WRITE)
	fixtures.store_string(JSON.stringify({"task_id": "DEV-020", "cases": _cases}, "  ") + "\n")
	var validation := FileAccess.open(base + "VALIDATION.json", FileAccess.WRITE)
	validation.store_string(
		(
			JSON.stringify(
				{
					"task_id": "DEV-020",
					"engine": Engine.get_version_info(),
					"rules": "RFC-DEV-020-01-OWNER-20261108",
					"checks": _checks,
					"failures": _failures,
					"exit_code": 0 if _failures == 0 else 1,
					"assertions": _assertions,
					"W05_GUI": "NOT_RUN",
					"VS01": "NOT_RUN",
					"Windows_export": "NOT_RUN"
				},
				"  "
			)
			+ "\n"
		)
	)
