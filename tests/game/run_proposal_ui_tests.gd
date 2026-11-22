extends SceneTree
## Session/소비 계약 자동 검사. Control·OS 입력·Design 심사가 아니다.

const FX = preload("res://tests/game/w04b_fixtures.gd")
const Guard = preload("res://scripts/ui/s01_observation_contract.gd")
const Proposal = preload("res://scripts/model/company_proposal.gd")
var _checks: int = 0
var _failures: int = 0
var _assertions: Array[Dictionary] = []
var _samples: Dictionary = {}


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure", false, true)
	else:
		_test_commands()
		_test_office()
		_test_branches()
		_test_guard()
		_test_prediction()
		for id: String in _samples:
			var sample: Dictionary = _samples[id]
			if sample.kind == "ACTUAL_SESSION_API":
				_expect(
					"actual_sample_guard:" + id,
					Guard.proposal_region(sample.state, sample.state.run_scope).available,
					true
				)
	var output := "res://.local/validation/DEV-027/session-pipeline/proposal-ui.json"
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--output="):
			output = arg.trim_prefix("--output=")
	_expect(
		"write_evidence",
		FX.save(
			output,
			{
				"checks": _checks,
				"failures": _failures,
				"assertions": _assertions,
				"samples": _samples,
				"scope": "SESSION_SUPPLY_NO_SCREEN"
			}
		),
		true
	)
	print("PROPOSAL_UI_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _test_commands() -> void:
	var value := FX.session()
	_expect("duplicate_enable", value.enable_proposals(0).accepted, false)
	var cmd := FX.session_command(value, "edit", "edit_proposal")
	var result := value.request_proposal(cmd)
	_expect("edit", result.accepted, true)
	var before := value.snapshot()
	_expect("edit_idempotent", value.request_proposal(cmd), result)
	_expect("edit_duplicate_no_revision", value.snapshot(), before)
	cmd.run_scope = "old"
	_expect("scope_before_dedup", value.request_proposal(cmd).reason, "INVALID_COMMAND_SCOPE")
	cmd = FX.session_command(value, "bad-field", "predict_proposal")
	cmd.seed = 8
	_expect("no_seed_command", value.request_proposal(cmd).reason, "UNSUPPORTED_COMMAND_FIELD")
	value.request_proposal(FX.session_command(value, "predict", "predict_proposal"))
	cmd = FX.session_command(value, "city", "submit_city_review")
	_expect("registered_not_admitted", value.request_proposal(cmd).admitted_at, null)
	_samples.L01_registered = FX.sample(value)
	FX.advance(value, 361)
	_expect("actual_admission", value.proposal_result("city").admitted_at, 361)
	_expect("locked", FX.session_row(value).edit_state.allowed, false)
	_expect("locked_predict", FX.session_row(value).predict_state.reason_codes, ["PLAN_LOCKED"])
	_expect(
		"locked_edit_rejected",
		value.request_proposal(FX.session_command(value, "lock", "edit_proposal")).accepted,
		false
	)
	_samples.L04_locked = FX.sample(value)
	FX.advance(value, 391)
	_expect("city_exact30", FX.session_row(value).decisions.back().completed_at, 391)
	var decision: Dictionary = FX.session_row(value).decisions.back().duplicate(true)
	cmd = FX.session_command(value, "change", "edit_proposal")
	cmd.station_ids = FX.ROUTE_B
	value.request_proposal(cmd)
	_expect("city_copy_preserved", FX.session_row(value).decisions.back(), decision)
	_expect(
		"changed_not_government",
		FX.session_row(value).action_states.submit_government_review.allowed,
		false
	)
	_samples.L04_changed = FX.sample(value)
	var queued := FX.session(2, 60)
	FX.session_prepare(queued)
	cmd = FX.session_command(queued, "queued", "submit_city_review")
	queued.request_proposal(cmd)
	var edit := FX.session_command(queued, "change", "edit_proposal")
	edit.station_ids = FX.ROUTE_B
	queued.request_proposal(edit)
	FX.advance(queued, 360)
	_expect("queued_stale", queued.proposal_result("queued").reason, "STALE_PLAN_OR_PREDICTION")
	_expect("queued_no_admission", queued.proposal_result("queued").admitted_at, null)
	_expect("queued_retry_same", queued.request_proposal(cmd), queued.proposal_result("queued"))
	_samples.L03_stale = FX.sample(queued)
	queued.request_proposal(FX.session_command(queued, "new-predict", "predict_proposal"))
	_expect(
		"new_id_required",
		(
			queued
			. request_proposal(FX.session_command(queued, "new-city", "submit_city_review"))
			. pending
		),
		true
	)
	FX.advance(queued, 361)
	_expect("new_id_admitted", queued.proposal_result("new-city").admitted_at, 361)


func _test_office() -> void:
	for start: int in [60, 360, 1439, 1440]:
		var value := FX.session(2, start)
		FX.session_prepare(value)
		var expected: int = {60: 360, 360: 361, 1439: 1800, 1440: 1800}[start]
		var receipt := value.request_proposal(
			FX.session_command(value, "city", "submit_city_review")
		)
		_expect("office:" + str(start), receipt.effective_not_before, expected)
		value.dispatch({"command_id": "pause", "action": "pause"})
		value.advance_usec(5000000)
		_expect("pause:" + str(start), value.pipeline.clock.minute, start)
		_samples["L02_pause_" + str(start)] = FX.sample(value)
		value.dispatch({"command_id": "resume", "action": "resume"})
		FX.advance(value, expected + 30)
		_expect(
			"period:" + str(start),
			FX.session_row(value).decisions.back().completed_at,
			expected + 30
		)
		_expect(
			"pipeline_clock:" + str(start),
			value.pipeline.proposal_snapshot().simulation_minute,
			expected + 30
		)
	for speed: int in [1, 2, 4]:
		var value := FX.session()
		value.dispatch({"command_id": "speed", "action": "speed", "value": speed})
		FX.session_prepare(value)
		value.request_proposal(FX.session_command(value, "city", "submit_city_review"))
		for index: int in 40:
			value.advance_usec(500000 / speed)
		_expect("chunk_speed:" + str(speed), value.pipeline.clock.minute, 408)
		_expect(
			"chunk_city:" + str(speed), FX.session_row(value).decisions.back().completed_at, 391
		)


func _test_branches() -> void:
	for seed_value: int in [2, 0, 8, 1]:
		var value := FX.session(seed_value)
		FX.session_prepare(value)
		value.request_proposal(FX.session_command(value, "city", "submit_city_review"))
		FX.advance(value, 391)
		value.request_proposal(FX.session_command(value, "government", "submit_government_review"))
		FX.advance(value, 452)
		var item := FX.session_row(value)
		var outcome: String = {2: "APPROVED", 0: "HELD", 8: "HELD", 1: "REJECTED"}[seed_value]
		_expect("government:" + str(seed_value), item.decisions.back().outcome, outcome)
		_expect("draw1", value.pipeline.proposal_snapshot().rng.draw_count, 1)
		_samples["L01_government_" + str(seed_value)] = FX.sample(value)
		if seed_value in [0, 8]:
			var held: Dictionary = item.decisions.back().duplicate(true)
			var edit := FX.session_command(value, "held-edit", "edit_proposal")
			edit.station_ids = FX.ROUTE_B
			value.request_proposal(edit)
			value.request_proposal(FX.session_command(value, "persuade", "submit_persuasion"))
			_expect("persuasion_not_used_queued", FX.session_row(value).persuasion_used_for, [])
			FX.advance(value, 453)
			_expect(
				"persuasion_held_plan",
				FX.session_row(value).review.submission.plan.station_ids,
				held.submission.plan.station_ids
			)
			_expect(
				"persuasion_current_separate",
				FX.session_row(value).draft.plan.station_ids,
				FX.ROUTE_B
			)
			_expect(
				"used_at_admission", FX.session_row(value).persuasion_used_for, [held.decision_id]
			)
			_samples["L05_admitted_" + str(seed_value)] = FX.sample(value)
			FX.advance(value, 482)
			_expect("persuasion29", FX.session_row(value).decisions.size(), 2)
			FX.advance(value, 483)
			_expect("persuasion30", FX.session_row(value).decisions.back().completed_at, 483)
			_expect(
				"persuasion_result",
				FX.session_row(value).decisions.back().outcome,
				"APPROVED" if seed_value == 8 else "REJECTED"
			)
			_expect("draw2", value.pipeline.proposal_snapshot().rng.draw_count, 2)
			_expect("held_preserved", FX.session_row(value).decisions[1], held)
		if seed_value in [2, 8]:
			_expect("permission_no_payment", value.pipeline.ledger.snapshot().cash, 1000000)
			_samples["L06_permission_" + str(seed_value)] = FX.sample(value)
			var cmd := FX.session_command(value, "sign", "sign_proposal_contract")
			value.request_proposal(cmd)
			FX.advance(value, value.pipeline.clock.minute + 1)
			var expected := 800000 if seed_value == 2 else 640000
			_expect(
				"shared_ledger_payment", value.pipeline.ledger.snapshot().cash, 1000000 + expected
			)
			_expect(
				"payment_amount",
				FX.session_row(value).business_contract.government_payment.amount,
				expected
			)
			var ledger := value.pipeline.ledger.entries()
			value.request_proposal(cmd)
			value.snapshot()
			_expect("payment_once", value.pipeline.ledger.entries(), ledger)
			_samples["L06_contract_" + str(seed_value)] = FX.sample(value)
		else:
			FX.advance(value, value.pipeline.clock.minute + 1440)
			_expect(
				"DI03_unavailable", value.pipeline.proposal_snapshot().fact_supply.available, false
			)
			_expect("DI03_no_facts", value.pipeline.proposal_snapshot().fact_supply.facts, [])
			_expect(
				"DI03_no_retry",
				FX.session_row(value).action_states.submit_government_review.allowed,
				false
			)
			_samples["L07_pending_" + str(seed_value)] = FX.sample(value)


func _test_guard() -> void:
	var value := FX.session()
	FX.session_prepare(value)
	var state := value.snapshot()
	var scope := value.observation_scope()
	_expect("valid_region", Guard.proposal_region(state, scope).available, true)
	_expect("same_packet", Guard.proposal_region(state, scope, state.proposal_ui).available, true)
	_expect("old_scope", Guard.proposal_region(state, "old").available, false)
	var bad := state.duplicate(true)
	bad.proposal_ui.snapshot.proposals[0].name = "conflict"
	_expect(
		"same_view_conflict",
		Guard.proposal_region(bad, scope, state.proposal_ui).reason,
		"CONFLICTING_PROPOSAL_OBSERVATION"
	)
	_samples.L08_conflict = {
		"kind": "MALFORMED_COPY_FIXTURE", "state": bad, "previous": state.proposal_ui
	}
	for key: String in [
		"snapshot", "observation", "requests", "status", "run_scope", "view_revision"
	]:
		for invalid: Variant in [null, false, [], 1]:
			if key == "requests" and invalid is Array:
				continue
			bad = state.duplicate(true)
			bad.proposal_ui[key] = invalid
			_expect("regional_type:" + key, Guard.proposal_region(bad, scope).available, false)
			_expect("funds_independent:" + key, Guard.inspect(bad, scope, 0).regions.funds, true)
	bad = state.duplicate(true)
	bad.ui_contract_revision = "unknown"
	_expect("invalid_root", Guard.proposal_region(bad, scope).available, false)
	_samples.L08_root = {"kind": "MALFORMED_COPY_FIXTURE", "state": bad}
	FX.advance(value, 361)
	_expect(
		"stale",
		Guard.proposal_region(state, scope, value.snapshot().proposal_ui).reason,
		"STALE_PROPOSAL_OBSERVATION"
	)
	var other := FX.session()
	_expect("new_session_scope", other.observation_scope() != scope, true)
	_expect(
		"new_session_no_import",
		Guard.proposal_region(state, other.observation_scope()).available,
		false
	)
	_expect("new_session_blank", FX.session_row(other).draft.plan.station_ids, [])
	bad = state.duplicate(true)
	bad.proposal_ui.snapshot.proposals[0] = FX.session_row(other)
	_expect("foreign_row_in_current_root", Guard.proposal_region(bad, scope).available, false)


func _test_prediction() -> void:
	var value := FX.session(2, 360, FX.negative_parameters())
	FX.session_prepare(value)
	var prediction: Dictionary = FX.session_row(value).draft.prediction
	_expect("negative_available", prediction.available, true)
	_expect(
		"negative_value",
		(
			(
				prediction.current.value.totals.predicted_fare
				- prediction.current.value.totals.operating_cost
			)
			< 0
		),
		true
	)
	_expect(
		"negative_guard",
		Guard.proposal_region(value.snapshot(), value.observation_scope()).available,
		true
	)
	_samples.L10_negative = FX.sample(value)
	var zero := value.snapshot()
	var totals: Dictionary = (
		zero.proposal_ui.snapshot.proposals[0].draft.prediction.current.value.totals
	)
	totals.predicted_fare = totals.operating_cost
	_expect(
		"zero_display_is_available",
		Guard.proposal_region(zero, value.observation_scope()).available,
		true
	)
	_samples.L10_zero_display = {"kind": "DISPLAY_VALUE_FIXTURE", "state": zero, "profit": 0}
	var failed := value.snapshot()
	var failed_prediction: Dictionary = failed.proposal_ui.snapshot.proposals[0].draft.prediction
	failed_prediction.prediction_status = "FAILED"
	failed_prediction.available = false
	failed_prediction.reason = "FIXTURE_PREDICTION_FAILURE"
	failed_prediction.current = {}
	_expect(
		"failure_distinct_from_zero",
		Guard.proposal_region(failed, value.observation_scope()).available,
		true
	)
	_samples.L10_failure = {"kind": "DISPLAY_ERROR_FIXTURE", "state": failed}
	_expect("zero_city_boundary_pure", Proposal.city_outcome(0), "APPROVED")
	_samples.L10_zero = {
		"kind": "PURE_RULE_FIXTURE", "input_profit": 0, "actual": Proposal.city_outcome(0)
	}


func _expect(id: String, actual: Variant, expected: Variant) -> void:
	_checks += 1
	var passed: bool = typeof(actual) == typeof(expected) and actual == expected
	_assertions.append({"id": id, "passed": passed, "actual": actual, "expected": expected})
	if not passed:
		_failures += 1
		push_error("FAIL " + id + " actual=" + str(actual) + " expected=" + str(expected))
