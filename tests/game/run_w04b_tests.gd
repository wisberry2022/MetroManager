extends SceneTree

const Loader = preload("res://scripts/data/proposal_data_loader.gd")
const Proposal = preload("res://scripts/model/company_proposal.gd")
const Service = preload("res://scripts/simulation/proposal_service.gd")
const Sources = preload("res://scripts/simulation/business_sources.gd")
const Clock = preload("res://scripts/simulation/game_clock.gd")
const FX = preload("res://tests/game/w04b_fixtures.gd")
const TenderFX = preload("res://tests/game/w04a_fixtures.gd")

var _checks: int = 0
var _failures: int = 0
var _assertions: Array[Dictionary] = []
var _records: Dictionary = {}
var _seeds: Dictionary = {}


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure", true, false)
	else:
		_seeds = FX.seeds()
		_test_data_and_routes()
		_test_city_and_schedule()
		_test_pending_and_locks()
		_test_rng_branches()
		_test_identity_history()
		_test_contracts_and_sources()
		_test_time_and_observation()
		_test_fact_boundaries()
		_test_malformed_boundaries()
		_test_pipeline_phases()
		_write_evidence()
	print("W04B_P1_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _test_data_and_routes() -> void:
	var loaded := Loader.load_data()
	_expect("W4B-01/data", loaded.ok, true)
	_expect("W4B-01/typed_minutes", loaded.data.city_minutes is int, true)
	_expect("missing_data", Loader.load_data("res://MISSING.json").ok, false)
	for invalid: Variant in [null, [], 1, "x", true]:
		_expect("invalid_root", Loader.validate_data(invalid).ok, false)
	for key: String in loaded.data:
		var bad: Dictionary = loaded.data.duplicate(true)
		bad[key] = true
		_expect("invalid_field:" + key, Loader.validate_data(bad).ok, false)
	var service: Service = FX.bundle().service
	_expect("unknown_slot", service.edit("P-X", FX.ROUTE_A).accepted, false)
	var routes := [
		[FX.ROUTE_A.slice(0, 5), false],
		[FX.ROUTE_A, true],
		[FX.ROUTE_8, true],
		[["S01", "S02", "S03", "S04", "S08", "S07", "S06", "S05", "S09"], false],
		[["S01", "S02", "S04", "S08", "S12", "S11"], false],
	]
	for index: int in routes.size():
		var stops: Array[String] = []
		stops.assign(routes[index][0])
		FX.prepare(service, "P-A", stops)
		var receipt := service.submit(FX.command(service, "route-" + str(index)))
		_expect("W4B-01/count_connect:" + str(index), receipt.pending, routes[index][1])
	var before: Dictionary = FX.row(service).draft
	_expect("W4B-02/unknown_station", service.edit("P-A", ["NO_STATION"]).accepted, false)
	_expect("W4B-02/duplicate_station", service.edit("P-A", ["S01", "S01"]).accepted, false)
	_expect("W4B-02/invalid_edit_preserves", FX.row(service).draft, before)
	var broken := Service.new(
		FX.Network.new(FX.Data.load_data().data), {}, {"run_scope": "invalid"}
	)
	_expect("invalid_service_unavailable", broken.snapshot().available, false)
	_expect("invalid_no_partial_rows", broken.snapshot().proposals, [])


func _test_city_and_schedule() -> void:
	for profit: int in [-1, 0, 1]:
		_expect(
			"W4B-06/pure_profit:" + str(profit),
			Proposal.city_outcome(profit),
			"REJECTED" if profit < 0 else "APPROVED"
		)
	for start: int in [60, 359, 360, 1438, 1439, 1440, 1799]:
		var bundle := FX.bundle(0, start)
		var service: Service = bundle.service
		FX.prepare(service)
		var expected: int = {
			60: 360, 359: 360, 360: 361, 1438: 1439, 1439: 1800, 1440: 1800, 1799: 1800
		}[start]
		var cmd := FX.command(service, "office")
		var pending := service.submit(cmd)
		_expect("W4B-08/next:" + str(start), pending.effective_not_before, expected)
		_expect("registration_not_admission", pending.admitted_at, null)
		service.advance_to(expected - 1)
		_expect("not_started_before", FX.row(service).review, {})
		service.advance_to(expected)
		_expect("W4B-09/admitted", FX.row(service).review.admitted_at, expected)
		service.advance_to(expected + 29)
		_expect("W4B-09/not_early", FX.row(service).decisions.size(), 0)
		service.advance_to(expected + 30)
		_expect("W4B-09/exact_end", FX.last(service).completed_at, expected + 30)
		_expect("city_rng_zero", service.snapshot().rng.draw_count, 0)
		_expect("W4B-05/no_prediction_cash", bundle.ledger.snapshot().cash, 1000000)
	var negative: Service = FX.bundle(0, 360, FX.negative_parameters()).service
	FX.prepare(negative)
	for attempt: int in range(3):
		FX.city(negative, "P-A", "negative-" + str(attempt))
		_expect("W4B-07/city_retry", FX.last(negative).outcome, "REJECTED")
	_expect("W4B-07/attempts", FX.row(negative).attempts.city, 3)
	_expect("W4B-07/no_E01_for_city", FX.last(negative).has("fact_pending"), false)
	var zero_parameters := FX.negative_parameters()
	zero_parameters.operating_cost_per_minute = 0
	var zero: Service = FX.bundle(0, 360, zero_parameters).service
	FX.prepare(zero)
	FX.city(zero)
	_expect("W4B-06/actual_zero_model", FX.last(zero).outcome, "APPROVED")
	_records.city_fixture_negative = negative.snapshot()
	_records.city_fixture_zero = zero.snapshot()


func _test_pending_and_locks() -> void:
	var service: Service = FX.bundle().service
	FX.prepare(service)
	var cmd := FX.command(service, "edit-pending")
	var pending := service.submit(cmd)
	_expect("pending_duplicate_same", service.submit(cmd), pending)
	FX.prepare(service, "P-A", FX.ROUTE_B)
	_expect("pending_copy_unchanged", pending.submission.plan.station_ids, FX.ROUTE_A)
	service.advance_to(361)
	_expect(
		"W4B-04/stale_recheck", service.result(cmd.command_id).reason, "STALE_PLAN_OR_PREDICTION"
	)
	_expect("W4B-17/failed_admission_attempts", FX.row(service).attempts.city, 0)
	_expect("W4B-17/failed_admission_draws", service.snapshot().rng.draw_count, 0)
	_expect("explicit_new_request", service.result(cmd.command_id).requires_new_request, true)
	var new_cmd := FX.command(service, "fresh")
	service.submit(new_cmd)
	service.advance_to(362)
	_expect("new_receipt_admitted", service.result("fresh").accepted, true)
	_expect("W4B-04/locked_edit", service.edit("P-A", FX.ROUTE_A).reason, "PLAN_LOCKED")
	_expect("locked_predict", service.predict("P-A").accepted, false)
	_expect(
		"review_repeat", service.submit(FX.command(service, "other")).reason, "REVIEW_IN_PROGRESS"
	)
	service.advance_to(392)
	_expect("unlocked_after_city", service.edit("P-A", FX.ROUTE_A).accepted, true)
	service.predict("P-A")
	var government := service.submit(FX.command(service, "stale-city", "submit_government_review"))
	_expect("prior_city_not_new_plan", government.reason, "CURRENT_CITY_APPROVAL_REQUIRED")
	var forbidden := FX.command(service, "forged")
	forbidden.sample = 0
	_expect(
		"no_forced_sample_command", service.submit(forbidden).reason, "UNSUPPORTED_COMMAND_FIELD"
	)
	var old_scope := FX.command(service, "wrong-scope")
	old_scope.run_scope = "old-run"
	_expect("old_scope_rejected", service.submit(old_scope).reason, "INVALID_COMMAND_SCOPE")
	var duplicate := new_cmd.duplicate(true)
	duplicate.action = "sign_proposal_contract"
	_expect("same_id_reuses_first_result", service.submit(duplicate), service.result("fresh"))
	_records.pending_edit = service.snapshot()


func _test_rng_branches() -> void:
	_expect("normal_seed_search_complete", _seeds.size(), 4)
	var counts := {"APPROVED": 0, "HELD": 0, "REJECTED": 0}
	var success := 0
	for sample: int in range(100):
		counts[Proposal.government_outcome(sample)] += 1
		success += int(Proposal.persuasion_outcome(sample) == "APPROVED")
	_expect("W4B-10/domain_70_20_10", counts, {"APPROVED": 70, "HELD": 20, "REJECTED": 10})
	_expect("W4B-11/domain_60_40", success, 60)
	for invalid: int in [-1, 100]:
		_expect("invalid_sample", Proposal.government_outcome(invalid), "INVALID_SAMPLE")
	for branch: String in _seeds:
		var service: Service = FX.bundle(_seeds[branch].seed).service
		FX.prepare(service)
		FX.city(service)
		var command := FX.command(service, "rng-government", "submit_government_review")
		service.submit(command)
		service.advance_to(392)
		service.advance_to(451)
		_expect("W4B-09/government_not_early", service.snapshot().rng.draw_count, 0)
		service.advance_to(452)
		var expected := (
			"APPROVED" if branch == "DIRECT" else ("REJECTED" if branch == "REJECT" else "HELD")
		)
		_expect("W4B-10/normal_engine:" + branch, FX.last(service).outcome, expected)
		_expect(
			"W4B-18/sample_identity:" + branch,
			service.snapshot().rng.draws[0].sample,
			_seeds[branch].samples[0]
		)
		_expect("W4B-18/exactly_one", service.snapshot().rng.draw_count, 1)
		service.submit(command)
		service.advance_to(452)
		_expect("W4B-19/completed_duplicate", service.snapshot().rng.draw_count, 1)
		if branch.begins_with("HELD"):
			_persuade_branch(service, branch)
		elif branch == "REJECT":
			var retry := FX.command(service, "retry", "submit_government_review")
			_expect(
				"W4B-14/failure_restriction",
				service.submit(retry).reason,
				"NEW_FACT_REQUIRED_DI03_PENDING"
			)
		_records[branch] = service.snapshot()


func _persuade_branch(service: Service, branch: String) -> void:
	var held := FX.last(service)
	FX.prepare(service, "P-A", FX.ROUTE_B)
	var command := FX.command(service, "persuade", "submit_persuasion")
	_expect("W4B-11/pending", service.submit(command).pending, true)
	service.advance_to(453)
	_expect("W4B-11/consumed_on_admission", FX.row(service).attempts.persuasion, 1)
	_expect("held_plan_not_current_draft", FX.row(service).review.submission, held.submission)
	service.advance_to(482)
	_expect("persuasion_not_early", service.snapshot().rng.draw_count, 1)
	service.advance_to(483)
	var expected := "APPROVED" if branch == "HELD_SUCCESS" else "REJECTED"
	_expect("W4B-11/result:" + branch, FX.last(service).outcome, expected)
	_expect(
		"W4B-13/reduction",
		FX.last(service).authorized_government,
		640000 if branch == "HELD_SUCCESS" else 0
	)
	_expect(
		"persuasion_once",
		service.submit(FX.command(service, "again", "submit_persuasion")).reason,
		"PERSUASION_ALREADY_USED"
	)
	service.submit(command)
	_expect("persuasion_duplicate_no_draw", service.snapshot().rng.draw_count, 2)


func _test_identity_history() -> void:
	var service: Service = FX.bundle(_seeds.REJECT.seed).service
	FX.prepare(service)
	FX.city(service)
	FX.government(service)
	var failed := FX.last(service)
	service.edit("P-A", FX.ROUTE_A, "renamed")
	_expect(
		"W4B-03/name_keeps_failure",
		service.submit(FX.command(service, "renamed", "submit_government_review")).reason,
		"NEW_FACT_REQUIRED_DI03_PENDING"
	)
	var reverse := FX.ROUTE_A.duplicate()
	reverse.reverse()
	FX.prepare(service, "P-B", reverse)
	FX.city(service, "P-B", "cross-slot-city")
	_expect(
		"W4B-03/cross_slot_unordered_set",
		service.submit(FX.command(service, "cross-slot", "submit_government_review", "P-B")).reason,
		"NEW_FACT_REQUIRED_DI03_PENDING"
	)
	# 두 슬롯이 연결된 이후 둘 다 역을 바꾸어도 과거 계보를 잃지 않는다.
	FX.prepare(service, "P-A", FX.ROUTE_B)
	FX.city(service, "P-A", "edited-city")
	FX.prepare(service, "P-B", FX.ROUTE_8)
	FX.city(service, "P-B", "edited-alias-city")
	_expect(
		"W4B-03/history_not_current_hash_only",
		(
			service
			. submit(FX.command(service, "alias-edited", "submit_government_review", "P-B"))
			. reason
		),
		"NEW_FACT_REQUIRED_DI03_PENDING"
	)
	service.advance_to(int(failed.completed_at) + 1441)
	_expect("W4B-14/time_no_reset", service.snapshot().rng.draw_count, 1)
	_expect("DI03/no_generated_fact", service.snapshot().fact_supply.facts, [])
	_expect("DI03/preserved_pending", service.snapshot().fact_supply.status, "DI03_PENDING")
	_expect(
		"W4B-03/same_slot_replacement",
		service.submit(FX.command(service, "same-slot-edited", "submit_government_review")).reason,
		"NEW_FACT_REQUIRED_DI03_PENDING"
	)
	var distinct: Service = FX.bundle(_seeds.REJECT.seed).service
	FX.prepare(distinct)
	FX.city(distinct)
	FX.government(distinct)
	FX.prepare(distinct, "P-B", FX.ROUTE_B)
	FX.city(distinct, "P-B", "distinct-city")
	_expect(
		"W4B-03/truly_other_slot",
		(
			distinct
			. submit(FX.command(distinct, "distinct-government", "submit_government_review", "P-B"))
			. pending
		),
		true
	)
	_records.identity_history = service.snapshot()


func _test_contracts_and_sources() -> void:
	for branch: String in ["DIRECT", "HELD_SUCCESS"]:
		var bundle := FX.bundle(_seeds[branch].seed)
		var service: Service = bundle.service
		FX.prepare(service)
		FX.city(service)
		FX.government(service)
		if branch == "HELD_SUCCESS":
			service.submit(FX.command(service, "persuade", "submit_persuasion"))
			service.advance_to(483)
		var permit := FX.last(service)
		FX.prepare(service, "P-A", FX.ROUTE_B)
		_expect("W4B-12/permission_not_payment", bundle.ledger.snapshot().cash, 1000000)
		var cmd := FX.command(service, "sign", "sign_proposal_contract")
		_expect("W4B-21/contract_pending", service.submit(cmd).pending, true)
		var at: int = service.snapshot().simulation_minute + 1
		service.advance_to(at)
		var contract: Dictionary = FX.row(service).business_contract
		var amount := 800000 if branch == "DIRECT" else 640000
		_expect("W4B-12/actual_payment", bundle.ledger.snapshot().cash, 1000000 + amount)
		_expect("W4B-22/restricted", bundle.ledger.snapshot().restricted, amount)
		_expect("W4B-22/free_cash", bundle.ledger.snapshot().free_cash, 1000000)
		_expect("W4B-21/authorized_plan_copy", contract.permitted_plan, permit.submission)
		_expect("W4B-21/distinct_W04A_project", contract.project_id == "P-A", false)
		var before: Dictionary = bundle.ledger.snapshot()
		service.submit(cmd)
		service.submit(FX.command(service, "sign-again", "sign_proposal_contract"))
		service.advance_to(at + 1)
		_expect("W4B-19/no_duplicate_payment", bundle.ledger.snapshot(), before)
		var sources := Sources.collect({}, service.snapshot(), bundle.ledger, at)
		_expect("source_valid_proposal", sources.available, true)
		_expect("source_kind", sources.sources[0].source_kind, "COMPANY_PROPOSAL")
		_expect("source_plan_not_new_draft", sources.sources[0].station_ids, FX.ROUTE_A)
		var forged := service.snapshot()
		forged.proposals[0].business_contract.government_payment.amount += 1
		_expect(
			"source_wrong_amount", Sources.collect({}, forged, bundle.ledger, at).available, false
		)
		_expect(
			"source_future_payment",
			Sources.collect({}, service.snapshot(), bundle.ledger, at - 1).available,
			false
		)
		_records[branch + "_contract"] = {
			"snapshot": service.snapshot(),
			"ledger": bundle.ledger.snapshot(),
			"entries": bundle.ledger.entries(),
			"sources": sources,
		}
	var pipe := TenderFX.pipeline()
	pipe.submit_bid(TenderFX.command())
	TenderFX.advance_to(pipe, 1800)
	var old := Sources.collect(pipe.snapshot().tenders, {}, pipe.ledger, 1800)
	_expect("W04A_read_compatibility", old.available, true)
	_expect("W04A_source_kind", old.sources[0].source_kind, "PUBLIC_TENDER")
	_expect("W04A_id_unchanged", old.sources[0].project_id, "P-A")
	_expect(
		"unavailable_not_empty_success",
		Sources.collect({"available": false, "tenders": []}, {}, pipe.ledger, 1800).available,
		false
	)
	_test_contract_conflict()


func _test_contract_conflict() -> void:
	var bundle := FX.bundle(_seeds.DIRECT.seed)
	var service: Service = bundle.service
	FX.prepare(service)
	FX.city(service)
	FX.government(service)
	service.submit(FX.command(service, "sign", "sign_proposal_contract"))
	bundle.ledger.contract("P-A", 800000, 600000, 452)
	service.advance_to(453)
	_expect("competing_contract_recheck", service.result("sign").reason, "PROJECT_IN_PROGRESS")
	_expect("competing_payment_once", bundle.ledger.entries().size(), 1)
	_expect("competing_failure_no_contract", FX.row(service).business_contract, {})


func _test_time_and_observation() -> void:
	var reference: Dictionary = {}
	for speed: int in [1, 2, 4]:
		for chunked: bool in [false, true]:
			var service: Service = FX.bundle(_seeds.DIRECT.seed).service
			FX.prepare(service)
			var clock := Clock.new(360)
			clock.set_speed(speed)
			service.submit(FX.command(service, "city"))
			_drive(service, clock, 391, chunked)
			service.submit(FX.command(service, "gov", "submit_government_review"))
			_drive(service, clock, 452, chunked)
			clock.paused = true
			var paused := service.snapshot()
			clock.advance_usec(5000000)
			service.advance_to(clock.minute)
			_expect("W4B-30/pause_no_effect", service.snapshot(), paused)
			service.snapshot()
			service.result("gov")
			_expect("W4B-19/observation_pure", service.snapshot(), paused)
			var modified := service.snapshot()
			modified.proposals[0].decisions.clear()
			modified.rng.draws.clear()
			_expect("snapshot_detached", service.snapshot(), paused)
			_expect("time_rewind_rejected", service.advance_to(451).accepted, false)
			if reference.is_empty():
				reference = paused
			else:
				_expect("W4B-30/speed_split_replay", paused, reference)
	_records.normal_replay = reference
	_test_simultaneous_order()


func _drive(service: Service, clock: Clock, target: int, chunked: bool) -> void:
	while clock.minute < target:
		var remaining := (target - clock.minute) * 5000000 - clock.remainder
		var elapsed := ceili(float(remaining) / (12 * clock.speed))
		clock.advance_usec(mini(elapsed, 17000) if chunked else elapsed)
		service.advance_to(clock.minute)


func _test_simultaneous_order() -> void:
	var service: Service = FX.bundle(_seeds.DIRECT.seed).service
	FX.prepare(service)
	FX.prepare(service, "P-B", FX.ROUTE_B)
	service.submit(FX.command(service, "z-city", "submit_city_review", "P-B"))
	service.submit(FX.command(service, "a-city"))
	service.advance_to(391)
	service.submit(FX.command(service, "z-government", "submit_government_review", "P-B"))
	service.submit(FX.command(service, "a-government", "submit_government_review"))
	service.advance_to(452)
	var draws: Array = service.snapshot().rng.draws
	_expect("same_minute_two_draws", draws.size(), 2)
	_expect("registration_order_before_lexical", draws[0].command_id, "z-government")
	_expect("second_registered_draw", draws[1].command_id, "a-government")
	_records.simultaneous = service.snapshot()


func _test_fact_boundaries() -> void:
	var failure := {
		"business_identity_id": "business-A", "decision_id": "failed", "completed_at": 600
	}
	var fact := {
		"fact_id": "E01",
		"business_identity_id": "business-A",
		"decision_id": "failed",
		"occurred_at": 2040,
		"used": false
	}
	_expect("W4B-16/static_valid_fact", Proposal.fact_error(fact, failure, 2040), "")
	_expect("W4B-16/unoccurred", Proposal.fact_error(fact, failure, 2039), "FACT_NOT_OCCURRED")
	for at: int in [599, 600]:
		var copy := fact.duplicate()
		copy.occurred_at = at
		_expect(
			"W4B-16/not_after", Proposal.fact_error(copy, failure, 2040), "FACT_NOT_AFTER_DECISION"
		)
	for key: String in ["business_identity_id", "decision_id"]:
		var copy := fact.duplicate()
		copy[key] = "other"
		_expect("W4B-16/unrelated", Proposal.fact_error(copy, failure, 2040), "UNRELATED_FACT")
	var used := fact.duplicate()
	used.used = true
	_expect("W4B-16/used", Proposal.fact_error(used, failure, 2040), "FACT_ALREADY_USED")
	_expect("W4B-16/malformed", Proposal.fact_error({}, failure, 2040), "INVALID_FACT")


func _test_malformed_boundaries() -> void:
	var data: Dictionary = Loader.load_data().data
	for key: String in data:
		for invalid: Variant in [null, [], {}, "wrong", true]:
			var copy := data.duplicate(true)
			copy[key] = invalid
			_expect("data_type:" + key, Loader.validate_data(copy).ok, false)
	for key: String in data.source:
		var copy := data.duplicate(true)
		copy.source[key] = false
		_expect("source_type:" + key, Loader.validate_data(copy).ok, false)
	var service: Service = FX.bundle(_seeds.DIRECT.seed).service
	FX.prepare(service)
	for key: String in ["command_id", "run_scope", "slot_id", "action", "binding"]:
		for invalid: Variant in [null, [], {}, true, 1, "wrong"]:
			var cmd := FX.command(service, "bad-" + key + str(_checks))
			cmd[key] = invalid
			if key == "command_id" and is_same(invalid, "wrong"):
				cmd[key] = ""
			var response := service.submit(cmd)
			_expect("command_type:" + key, response.get("pending", false), false)
	FX.city(service)
	for invalid: Variant in [null, [], {}, true, 1, "wrong"]:
		var cmd := FX.command(service, "bad-decision-" + str(_checks), "submit_government_review")
		cmd.decision_id = invalid
		_expect("decision_type", service.submit(cmd).pending, false)
	_expect("invalid_command_no_rng", service.snapshot().rng.draw_count, 0)
	var bundle := FX.bundle(_seeds.DIRECT.seed)
	var paid: Service = bundle.service
	FX.prepare(paid)
	FX.city(paid)
	FX.government(paid)
	paid.submit(FX.command(paid, "sign", "sign_proposal_contract"))
	paid.advance_to(453)
	var envelope := paid.snapshot()
	for key: String in [
		"status",
		"business_contract_id",
		"project_id",
		"effective_at",
		"government_payment",
		"permitted_plan",
		"source_kind",
		"source_id"
	]:
		for invalid: Variant in [null, [], true, 1]:
			var copy := envelope.duplicate(true)
			copy.proposals[0].business_contract[key] = invalid
			_expect(
				"business_type:" + key,
				Sources.collect({}, copy, bundle.ledger, 453).available,
				false
			)
	for key: String in envelope.proposals[0].business_contract.government_payment:
		var copy := envelope.duplicate(true)
		copy.proposals[0].business_contract.government_payment[key] = false
		_expect(
			"payment_type:" + key, Sources.collect({}, copy, bundle.ledger, 453).available, false
		)


func _test_pipeline_phases() -> void:
	var bundle := FX.bundle(2)
	var service: Service = bundle.service
	FX.prepare(service)
	FX.city(service)
	FX.government(service)
	service.submit(FX.command(service, "phase-sign", "sign_proposal_contract"))
	_expect("phase_contract_before_review", service.process_contract_phase(453).accepted, false)
	_expect("phase_review", service.process_review_phase(453).accepted, true)
	_expect("phase_no_early_payment", bundle.ledger.snapshot().cash, 1000000)
	_expect(
		"phase_incomplete", service.process_review_phase(454).reason, "INCOMPLETE_PROPOSAL_PHASE"
	)
	_expect("phase_review_duplicate", service.process_review_phase(453).changes, 0)
	_expect("phase_contract", service.process_contract_phase(453).accepted, true)
	_expect("phase_payment", bundle.ledger.snapshot().cash, 1800000)
	var before := service.snapshot()
	_expect("phase_contract_duplicate", service.process_contract_phase(453).changes, 0)
	_expect("phase_snapshot_stable", service.snapshot(), before)
	_expect("phase_backwards", service.process_review_phase(452).accepted, false)
	_expect("phase_skip", service.process_review_phase(455).accepted, false)
	service.advance_to(454)
	_expect("phase_compatibility", service.snapshot().simulation_minute, 454)


func _expect(id: String, actual: Variant, expected: Variant) -> void:
	_checks += 1
	var passed: bool = typeof(actual) == typeof(expected) and actual == expected
	if not passed:
		_failures += 1
		push_error("FAIL " + id + " actual=" + str(actual) + " expected=" + str(expected))
	_assertions.append({"id": id, "passed": passed, "actual": actual, "expected": expected})


func _write_evidence() -> void:
	var output := "res://.local/validation/DEV-027/p1/model-evidence.json"
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("--output="):
			output = argument.trim_prefix("--output=")
	DirAccess.make_dir_recursive_absolute(output.get_base_dir())
	var file := FileAccess.open(output, FileAccess.WRITE)
	if file == null:
		_expect("evidence_write", false, true)
		return
	(
		file
		. store_string(
			(
				(
					JSON
					. stringify(
						{
							"task_id": "DEV-027",
							"scope": "P1_ISOLATED_MODEL",
							"engine": Engine.get_version_info(),
							"checks": _checks,
							"failures": _failures,
							"assertions": _assertions,
							"normal_rng_seeds": _seeds,
							"records": _records,
							"di03": "DEPENDENT_SCOPE_PENDING",
							"product_integration": "NOT_RUN",
							"gui_design_vs02": "NOT_RUN",
						},
						"\t"
					)
				)
				+ "\n"
			)
		)
	)
