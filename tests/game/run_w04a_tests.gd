extends SceneTree

const Loader = preload("res://scripts/data/tender_data_loader.gd")
const Tender = preload("res://scripts/model/public_tender.gd")
const Service = preload("res://scripts/simulation/tender_service.gd")
const Pipeline = preload("res://scripts/simulation/minute_pipeline.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const FX = preload("res://tests/game/w04a_fixtures.gd")

var _checks: int = 0
var _failures: int = 0
var _evidence: Array[Dictionary] = []
var _assertions: Array[Dictionary] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure", true, false)
	else:
		_test_data()
		_test_boundaries()
		_test_score_and_contract()
		_test_commands()
		_test_eligibility()
		_test_time_and_order()
		_test_observations()
		_write_evidence()
	print("W04A_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _test_data() -> void:
	var loaded := Loader.load_data()
	_expect("load", loaded.ok, true)
	_expect("typed_game_minutes", loaded.data.tenders[0].closes_at is int, true)
	_expect("missing_file", Loader.load_data("res://MISSING.json").ok, false)
	for invalid: Variant in [null, [], 1, "x", true]:
		_expect("root_rejected", Loader.validate_data(invalid).ok, false)
	for key: String in ["schema_version", "data_version", "rules_version", "source", "tenders"]:
		var bad: Dictionary = loaded.data.duplicate(true)
		bad[key] = null
		_expect("invalid:" + key, Loader.validate_data(bad).ok, false)
	for key: String in loaded.data.tenders[0]:
		var bad: Dictionary = loaded.data.duplicate(true)
		bad.tenders[0][key] = true
		_expect("term_type:" + key, Loader.validate_data(bad).ok, false)
	var duplicate: Dictionary = loaded.data.duplicate(true)
	duplicate.tenders[2] = duplicate.tenders[0].duplicate(true)
	_expect("duplicate_data", Loader.validate_data(duplicate).ok, false)
	var wrong_route: Dictionary = loaded.data.duplicate(true)
	wrong_route.tenders[0].station_ids.reverse()
	_expect("fixed_route", Loader.validate_data(wrong_route).ok, false)
	var pipe := FX.pipeline()
	var rows: Array = pipe.snapshot().tenders.tenders
	_expect("only_two_local", rows.size(), 2)
	_expect("B01_city", rows[0].terms.issuer_id, "CITY_HALL")
	_expect("B02_government", rows[1].terms.issuer_id, "NATIONAL_GOVERNMENT")
	_expect("BX_hidden", FX.row(pipe, "B-X"), {})
	_expect("enable_once", pipe.enable_tenders().reason, "TENDERS_ALREADY_ENABLED")
	var disabled := Pipeline.new()
	_expect("disabled_command", disabled.submit_bid(FX.command()).reason, "TENDERS_NOT_ENABLED")
	_expect("invalid_enable", disabled.enable_tenders({"x": 1}).accepted, false)
	_expect("invalid_no_partial", disabled.snapshot().has("tenders"), false)
	var empty := Service.new(Ledger.new(), {"city_id": "NO_LOCAL_TENDERS"}, loaded.data)
	_expect("empty_available", empty.snapshot(360, 0).available, true)
	_expect("empty_not_error", empty.snapshot(360, 0).tenders, [])
	var error := Service.new(Ledger.new(), {"city_id": "C01"}, {})
	_expect("error_not_empty_success", error.snapshot(360, 0).available, false)


func _test_boundaries() -> void:
	for minute: int in [359, 360, 1079, 1080, 1439, 1440, 1799, 1800, 1801]:
		var pipe := FX.pipeline({}, minute - 1)
		var cmd := FX.command("at-" + str(minute), "B01", minute - 1, minute)
		var initial := pipe.snapshot()
		_expect("boundary_pending", pipe.submit_bid(cmd).pending, true)
		FX.advance_to(pipe, minute)
		var expected := "NOT_OPEN" if minute < 360 else ("ROUND_CLOSED" if minute >= 1800 else "")
		_expect("boundary:" + str(minute), pipe.bid_result(cmd.command_id).reason, expected)
		_expect("boundary_time", pipe.bid_result(cmd.command_id).effective_at, minute)
		_expect("boundary_receipt", not FX.row(pipe).receipt.is_empty(), expected.is_empty())
		_record(
			"boundary_" + str(minute),
			cmd,
			initial,
			pipe,
			{"reason": expected, "accepted": expected.is_empty()}
		)
	# GUI 요청분이 마감 전이어도 실제 접수 효력이 마감이면 거부한다.
	var late := FX.pipeline({}, 1799)
	late.submit_bid(FX.command("late", "B01", 1799, 1800))
	FX.advance_to(late, 1800)
	_expect("no_backdate", late.bid_result("late").reason, "ROUND_CLOSED")


func _test_score_and_contract() -> void:
	for id: String in ["B01", "B02"]:
		var pipe := FX.pipeline()
		var cmd := FX.command("normal-" + id, id)
		var initial := pipe.snapshot()
		pipe.submit_bid(cmd)
		FX.advance_to(pipe, 361)
		_expect("receipt_before_award", FX.row(pipe, id).state, "RECEIVED")
		_expect("receipt_no_money", pipe.ledger.snapshot().cash, 1000000)
		FX.advance_to(pipe, 1800)
		var row := FX.row(pipe, id)
		_expect("normal_award", row.decision.awarded, true)
		_expect("normal_exact_score", row.decision.score.comparison_score.numerator, 8600000)
		_expect("comparison_denominator", row.decision.score.comparison_score.denominator, 10000)
		_expect("display_86", row.decision.score.display_score.denominator, 100000)
		_expect("competitor80", row.decision.competitor_comparison.numerator, 8000000)
		_expect("contract_status", row.business_contract.status, "EFFECTIVE")
		_expect("effect1800", row.business_contract.effective_at, 1800)
		_expect("payment800000", row.business_contract.government_payment.amount, 800000)
		_expect("p05_authorized", row.allowed_actions.enter_p05, true)
		_expect("no_construction_contract", row.construction_contract.available, false)
		_expect("C1800000", pipe.ledger.snapshot().cash, 1800000)
		_expect("R800000", pipe.ledger.snapshot().restricted, 800000)
		_expect("F1000000", pipe.ledger.snapshot().free_cash, 1000000)
		_expect("K0", pipe.ledger.snapshot().reserved, 0)
		_expect("B0", pipe.ledger.snapshot().unpaid, 0)
		var govt: int = 0
		for entry: Dictionary in pipe.ledger.entries():
			if entry.kind == "government":
				govt += 1
		_expect("government_once", govt, 1)
		var after := pipe.ledger.snapshot()
		pipe.submit_bid(cmd)
		FX.advance_to(pipe, 1810)
		_expect("repeat_no_money", pipe.ledger.snapshot(), after)
		_expect("decision_frozen", FX.row(pipe, id).decision, row.decision)
		_record(
			"normal_" + id,
			cmd,
			initial,
			pipe,
			{"awarded": true, "cash": 1800000, "government_transactions": 1}
		)
	var tie := FX.pipeline()
	var tie_initial := tie.snapshot()
	tie.submit_bid(FX.command())
	FX.advance_to(tie, 361)
	tie.ledger.operating_cost(200000, 361)
	FX.advance_to(tie, 1800)
	var row := FX.row(tie)
	_expect(
		"admission_score860",
		row.receipt.admission_snapshot.score.comparison_score.numerator,
		8600000
	)
	_expect("deadline_F800000", row.decision.score.free_cash, 800000)
	_expect("deadline_score800", row.decision.score.comparison_score.numerator, 8000000)
	_expect("tie_lost", row.decision.reason, "TIE_PRIORITY")
	_expect("no_tie_contract", row.business_contract, {})
	_expect("no_tie_p05", row.allowed_actions.enter_p05, false)
	_record(
		"funds_changed_tie",
		FX.command(),
		tie_initial,
		tie,
		{"reason": "TIE_PRIORITY", "score": 8000000}
	)
	var low := FX.pipeline({"cash": 799999})
	low.submit_bid(FX.command())
	FX.advance_to(low, 1800)
	_expect("lower_not_rounded_to_tie", FX.row(low).decision.reason, "LOWER_SCORE")
	_expect("fraction_preserved", FX.row(low).decision.score.comparison_score.numerator, 7999997)
	_expect("negative_clamp", Tender.score(-1, 80).financial_score.numerator, 0)
	_expect("upper_clamp", Tender.score(1000001, 80).financial_score.numerator, 1000000)


func _test_commands() -> void:
	var pipe := FX.pipeline()
	var cmd := FX.command()
	_expect("pending", pipe.submit_bid(cmd).pending, true)
	var changed := cmd.duplicate(true)
	changed.tender_id = "B02"
	_expect("same_id_original", pipe.submit_bid(changed).effective_at, 361)
	cmd.tender_id = "B-X"
	FX.advance_to(pipe, 361)
	_expect("defensive_command_copy", pipe.bid_result("bid-1").accepted, true)
	var result_value := pipe.bid_result("bid-1")
	result_value.accepted = false
	_expect("defensive_result_copy", pipe.bid_result("bid-1").accepted, true)
	pipe.submit_bid(FX.command("duplicate", "B01", 361, 362))
	FX.advance_to(pipe, 362)
	_expect("different_id_duplicate", pipe.bid_result("duplicate").reason, "DUPLICATE_BID")
	FX.advance_to(pipe, 1800)
	pipe.submit_bid(FX.command("closed", "B01", 1800, 1801))
	FX.advance_to(pipe, 1801)
	_expect("terminal_round", pipe.bid_result("closed").reason, "ROUND_CLOSED")
	for kind: String in ["round", "plan", "target", "unknown", "outside"]:
		var fresh := FX.pipeline()
		var bad := FX.command(kind)
		match kind:
			"round":
				bad.round_id = "B01-R2"
			"plan":
				bad.plan_revision = 1
			"target":
				bad.target_revision = 1
			"unknown":
				bad.tender_id = "MISSING"
			"outside":
				bad.tender_id = "B-X"
		fresh.submit_bid(bad)
		FX.advance_to(fresh, 361)
		var expected := "UNKNOWN_TENDER" if kind in ["unknown", "outside"] else "STATE_CHANGED"
		_expect("stale:" + kind, fresh.bid_result(kind).reason, expected)
		_expect("reject_no_money", fresh.ledger.snapshot().cash, 1000000)
	for key: String in ["fare", "government", "duration_minutes", "station_ids"]:
		var fresh := FX.pipeline()
		var bad := FX.command(key)
		bad[key] = 1
		_expect("fixed:" + key, fresh.submit_bid(bad).reason, "FIXED_TERMS")
	for key: String in [
		"command_id",
		"requested_at",
		"effective_at",
		"expected_snapshot_revision",
		"plan_revision",
		"target_revision",
		"round_id",
		"tender_id"
	]:
		var fresh := FX.pipeline()
		var bad := FX.command(key)
		bad[key] = null
		_expect("bad_command:" + key, fresh.submit_bid(bad).accepted, false)
	var time := FX.pipeline()
	_expect(
		"closed_time",
		time.submit_bid(FX.command("closed-time", "B01", 360, 360)).reason,
		"CLOSED_EFFECTIVE_TIME"
	)
	_expect(
		"future_requested",
		time.submit_bid(FX.command("future", "B01", 361, 362)).reason,
		"CLOSED_EFFECTIVE_TIME"
	)
	var old_envelope := FX.pipeline()
	FX.advance_to(old_envelope, 500)
	old_envelope.submit_bid(FX.command("old-envelope", "B01", 500, 501))
	FX.advance_to(old_envelope, 501)
	_expect("envelope_alone_not_stale", old_envelope.bid_result("old-envelope").accepted, true)


func _test_eligibility() -> void:
	var tender := Tender.new(Loader.load_data().data.tenders[0])
	_expect(
		"jurisdiction_reason",
		tender.eligibility("OTHER", false, 2880).reason_codes,
		["OUTSIDE_JURISDICTION"]
	)
	_expect(
		"duration_reason",
		tender.eligibility("C01", false, 2881).reason_codes,
		["DURATION_NOT_FEASIBLE"]
	)
	_expect("fast_within_period", tender.eligibility("C01", false, 1440).eligible, true)
	var busy := FX.pipeline({"restricted_by_project": {"OTHER": 1}})
	busy.submit_bid(FX.command())
	FX.advance_to(busy, 361)
	_expect("busy_rejected", busy.bid_result("bid-1").reason, "PROJECT_IN_PROGRESS")
	var reserved := FX.pipeline({"reserved_by_project": {"OTHER": 1}})
	reserved.submit_bid(FX.command())
	FX.advance_to(reserved, 361)
	_expect("reserved_project_busy", reserved.bid_result("bid-1").reason, "PROJECT_IN_PROGRESS")
	var after_receipt := FX.pipeline()
	after_receipt.submit_bid(FX.command())
	FX.advance_to(after_receipt, 361)
	after_receipt.ledger.contract("OTHER", 1, 1, 361)
	FX.advance_to(after_receipt, 1800)
	var row := FX.row(after_receipt)
	_expect("no_invented_disqualification", row.decision.awarded, true)
	_expect("contract_rechecks_active", row.business_contract.result.reason, "PROJECT_IN_PROGRESS")
	_expect("contract_rejected_not_effective", row.allowed_actions.enter_p05, false)
	# B>0 자체는 새 계약 제재가 아니며 기존 B 우선 상환·R/K 보호는 유지한다.
	var debt := FX.pipeline({"unpaid": 100})
	debt.submit_bid(FX.command())
	FX.advance_to(debt, 1800)
	_expect("B_not_sanction", FX.row(debt).business_contract.status, "EFFECTIVE")
	_expect("B_paid_once", debt.ledger.snapshot().cash, 1799900)
	var protected := FX.pipeline({"cash": 50, "reserved_by_project": {"OTHER": 48}, "unpaid": 3})
	protected.submit_bid(FX.command())
	FX.advance_to(protected, 1800)
	_expect("K_preserved", protected.ledger.snapshot().reserved_by_project.OTHER, 48)
	_expect("B_unpaid_protected", protected.ledger.snapshot().unpaid, 1)


func _test_time_and_order() -> void:
	var baseline: Dictionary = {}
	for speed: int in [1, 2, 4]:
		for split: bool in [false, true]:
			var pipe := FX.pipeline()
			pipe.submit_bid(FX.command())
			pipe.clock.set_speed(speed)
			pipe.clock.paused = true
			var paused := pipe.snapshot()
			pipe.advance_usec(1000000)
			_expect("pause_no_effect", pipe.snapshot(), paused)
			pipe.clock.paused = false
			var elapsed: int = 600000000 / speed
			if split:
				for index: int in 120:
					pipe.advance_usec(elapsed / 120)
			else:
				pipe.advance_usec(elapsed)
			var observation := {
				"tenders": pipe.snapshot().tenders,
				"funds": pipe.ledger.snapshot(),
				"entries": pipe.ledger.entries(),
				"command_result": pipe.bid_result("bid-1")
			}
			if baseline.is_empty():
				baseline = observation
			_expect("split_speed_replay", observation, baseline)
	var order := FX.pipeline()
	order.submit_bid(FX.command())
	order.set_fixture(
		1800, {"arrival_fare": 1000, "construction": [{"project": "P-A", "amount": 100}]}
	)
	FX.advance_to(order, 1800)
	var row := FX.row(order)
	_expect("contract_before_arrival", row.decision.score.free_cash, 1000000)
	_expect("contract_before_progress", row.business_contract.result.decision_funds.cash, 1000000)
	_expect("current_after_progress_arrival", order.ledger.snapshot().cash, 1800900)
	_expect("restricted_after_progress", order.ledger.snapshot().restricted, 799900)
	var tie := FX.pipeline({"cash": 800000})
	tie.submit_bid(FX.command())
	tie.set_fixture(1800, {"arrival_fare": 200000})
	FX.advance_to(tie, 1800)
	_expect("late_fare_cannot_change_award", FX.row(tie).decision.reason, "TIE_PRIORITY")
	_expect("current_F_changed", tie.ledger.snapshot().free_cash, 1000000)
	var midnight := FX.pipeline()
	midnight.submit_bid(FX.command("night", "B01", 360, 1440))
	FX.advance_to(midnight, 1440)
	_expect("midnight_receipt", midnight.bid_result("night").accepted, true)
	_expect("midnight_no_contract", midnight.ledger.snapshot().cash, 1000000)


func _test_observations() -> void:
	var pipe := FX.pipeline()
	var initial := pipe.snapshot()
	for index: int in 5:
		_expect("query_invariant", pipe.snapshot(), initial)
	var modified := pipe.snapshot()
	modified.tenders.tenders[0].terms.fare = 0
	_expect("snapshot_copy", FX.row(pipe).terms.fare, 100)
	pipe.submit_bid(FX.command())
	FX.advance_to(pipe, 1800)
	var snapshot := pipe.snapshot()
	_expect(
		"shared_observation_revision",
		snapshot.tenders.snapshot_revision,
		snapshot.snapshot_revision
	)
	_expect("shared_observation_minute", snapshot.tenders.simulation_minute, 1800)
	_expect("day2", snapshot.tenders.day_id, 2)
	_expect("complete_phase", snapshot.tenders.observation_phase, "T_COMPLETE")
	_expect(
		"phase_before_complete",
		FX.row(pipe).decision.phase_revision < snapshot.snapshot_revision,
		true
	)
	var service := Service.new(
		Ledger.new(), {"city_id": "C01", "capability": 80}, Loader.load_data().data
	)
	service.submit(FX.command(), 360)
	service.process_contract_phase(361, 1)
	service.process_contract_phase(1800, 2)
	var after := service.snapshot(1800, 10)
	service.process_contract_phase(1800, 2)
	_expect("same_phase_replayed_once", service.snapshot(1800, 10), after)
	_expect("stale_snapshot_unchanged", initial.tenders.tenders[0].state, "OPEN")


func _record(
	id: String, command: Dictionary, initial: Dictionary, pipe: Pipeline, expected: Dictionary
) -> void:
	_evidence.append(
		{
			"fixture_id": id,
			"command": command,
			"initial_snapshot": initial,
			"expected": expected,
			"actual_snapshot":
			{"funds": pipe.ledger.snapshot(), "tenders": pipe.snapshot().tenders},
			"actual_command_result": pipe.bid_result(command.command_id),
			"ledger_entries":
			pipe.ledger.entries().filter(func(entry: Dictionary) -> bool: return entry.amount != 0),
			"execution": "GODOT_AUTOMATED",
			"rules_version": Loader.RULES,
			"data_version": "1.3"
		}
	)


func _write_evidence() -> void:
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--evidence="):
			var file := FileAccess.open(arg.trim_prefix("--evidence="), FileAccess.WRITE)
			if file == null:
				_expect("evidence_write", false, true)
				return
			file.store_string(
				(
					JSON.stringify(
						{
							"checks": _checks,
							"failures": _failures,
							"exit_code": 0 if _failures == 0 else 1,
							"cases": _evidence,
							"assertions": _assertions
						},
						"  "
					)
					+ "\n"
				)
			)


func _expect(label: String, actual: Variant, expected: Variant) -> void:
	_checks += 1
	_assertions.append(
		{
			"label": label,
			"expected": _evidence_value(expected),
			"actual": _evidence_value(actual),
			"passed": actual == expected
		}
	)
	if actual != expected:
		_failures += 1
		printerr("FAIL ", label, " actual=", actual, " expected=", expected)


func _evidence_value(value: Variant) -> Variant:
	if value is Dictionary or value is Array:
		return {"type": type_string(typeof(value)), "sha256": JSON.stringify(value).sha256_text()}
	return value
