extends SceneTree
## P3-A 실제 Session 자동 연결. 자연 GUI VS-02/독립 심사와 구분한다.

const FX = preload("res://tests/game/w04b_fixtures.gd")
const Sources = preload("res://scripts/simulation/business_sources.gd")
const Guard = preload("res://scripts/ui/s01_observation_contract.gd")
const TenderFX = preload("res://tests/game/w019_ui_fixtures.gd")
const Construction = preload("res://scripts/simulation/construction_service.gd")
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
		_test_initialization()
		_test_chain()
		_test_source_isolation()
		_test_phase_order()
	var output := "res://.local/validation/DEV-027/session-pipeline/vs02-auto.json"
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
				"scope": "AUTO_CHAIN_NOT_NATURAL_GUI"
			}
		),
		true
	)
	print("VS02_AUTO_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _test_initialization() -> void:
	var data: Dictionary = FX.Data.load_data().data
	var value := FX.Session.new(data, data.initial_company)
	_expect("not_implicitly_enabled", value.snapshot().proposal_ui.available, false)
	var before := value.pipeline.ledger.snapshot()
	var bad := value.pipeline.enable_proposals(
		value.network, FX.Predictor.load_parameters(), value.observation_scope(), 2, {"bad": true}
	)
	_expect("invalid_data", bad.accepted, false)
	_expect("invalid_envelope", value.pipeline.proposal_snapshot().available, false)
	_expect("invalid_no_money_effect", value.pipeline.ledger.snapshot(), before)
	_expect("valid_after_failure", value.enable_proposals(2).accepted, true)
	_expect("proposal_only_construction", value.enable_construction_ui().accepted, true)
	_expect("not_fake_tender", value.pipeline.snapshot().has("tenders"), false)
	_expect("proposal_only_operations", value.enable_operations_ui().accepted, true)
	_expect("next_requires_report", value.query_next_business({}).accepted, false)
	_samples.initialization = FX.sample(value)
	value.refresh_tenders()
	_expect(
		"explicit_public_refresh_after_proposal", value.pipeline.snapshot().has("tenders"), true
	)


func _permit(value: FX.Session) -> void:
	FX.session_prepare(value)
	value.request_proposal(FX.session_command(value, "city", "submit_city_review"))
	FX.advance(value, 391)
	value.request_proposal(FX.session_command(value, "government", "submit_government_review"))
	FX.advance(value, 452)
	_expect("direct_permission", FX.session_row(value).decisions.back().outcome, "APPROVED")


func _project(value: FX.Session) -> Dictionary:
	var rows: Array = value.snapshot().construction_ui.snapshot.projects
	return {} if rows.is_empty() else rows[0]


func _construction(value: FX.Session, action: String) -> void:
	var state: Dictionary = value.snapshot().construction_ui.snapshot
	var row: Dictionary = state.contract_candidates[0] if action == "contract" else _project(value)
	var confirmed := {
		"project_id": row.project_id,
		"business_contract_id": row.business_contract.business_contract_id,
		"target_revision": 0 if action == "contract" else row.condition_revision,
		"snapshot_revision": state.snapshot_revision,
		"mode": "STANDARD"
	}
	var id := "construction-" + action
	_expect(
		action + "_pending", value.request_construction(id, action, confirmed).get("pending"), true
	)
	FX.advance(value, value.pipeline.clock.minute + 1)
	_expect(action + "_accepted", value.pipeline.construction_result(id).accepted, true)


func _test_chain() -> void:
	var value := FX.session()
	value.enable_construction_ui()
	value.enable_operations_ui()
	_permit(value)
	_expect(
		"permission_not_candidate",
		value.snapshot().construction_ui.snapshot.contract_candidates,
		[]
	)
	value.request_proposal(FX.session_command(value, "sign", "sign_proposal_contract"))
	FX.advance(value, 453)
	var business: Dictionary = FX.session_row(value).business_contract
	_expect("contract_shared_ledger", value.pipeline.ledger.snapshot().cash, 1800000)
	_expect(
		"payment_actual",
		value.pipeline.ledger.entries()[business.government_payment.ledger_entry_index].amount,
		800000
	)
	_expect(
		"actual_candidate", value.snapshot().construction_ui.snapshot.contract_candidates.size(), 1
	)
	_test_source_tamper(value)
	_construction(value, "contract")
	_expect("source_kind", _project(value).source_kind, "COMPANY_PROPOSAL")
	_expect("source_id", _project(value).source_id, business.source_id)
	_expect("plan_chain", _project(value).station_ids, business.permitted_plan.plan.station_ids)
	_expect("contract_separate", _project(value).started_at, null)
	_construction(value, "start")
	var started: int = _project(value).started_at
	FX.advance(value, started + 2879)
	_expect("not_early_complete", _project(value).status, "BUILDING")
	FX.advance(value, started + 2880)
	_expect("standard_duration", _project(value).status, "COMPLETED")
	_expect("paid600k", _project(value).paid, 600000)
	_samples.L09_construction = FX.sample(value)
	_construction(value, "trial")
	var at: int = value.pipeline.clock.minute
	FX.advance(value, at + 59)
	_expect("trial59", _project(value).trial_status, "RUNNING")
	FX.advance(value, at + 60)
	_expect("trial60", _project(value).trial_status, "PASSED")
	_construction(value, "safety")
	at = value.pipeline.clock.minute
	FX.advance(value, at + 59)
	_expect("safety59", _project(value).safety_status, "RUNNING")
	FX.advance(value, at + 60)
	_expect("safety60", _project(value).safety_status, "PASSED")
	_construction(value, "open")
	_expect("real_service_ready", value.pipeline.operations_snapshot().service_ready, true)
	_expect("no_report_yet", value.pipeline.operations_snapshot().first_valid_report, {})
	FX.advance(value, 4320)
	var ops := value.pipeline.operations_snapshot()
	_expect("first_report", ops.first_valid_report.day_id, 3)
	_expect("actual_completed", ops.first_valid_report.completed > 0, true)
	_expect("actual_fare", ops.first_valid_report.fare, ops.first_valid_report.completed * 100)
	var report := value.pipeline.reports.report(3)
	_expect("report_source", report.fare, ops.first_valid_report.fare)
	var before := value.pipeline.snapshot()
	var ledger := value.pipeline.ledger.entries()
	var confirmed: Dictionary = value.snapshot().next_business_ui
	var query := value.query_next_business(confirmed)
	_expect("next_accepted", query.accepted, true)
	_expect("next_proposals", query.proposals.proposals.size(), 2)
	_expect("next_no_fake_tender", query.tenders, {})
	value.query_next_business(confirmed)
	_expect("next_no_effect", value.pipeline.snapshot(), before)
	_expect("next_no_payment", value.pipeline.ledger.entries(), ledger)
	_expect(
		"guard_after_chain",
		Guard.proposal_region(value.snapshot(), value.observation_scope()).available,
		true
	)
	_samples.L09_report_and_next = {"session": FX.sample(value), "query": query}


func _test_source_tamper(value: FX.Session) -> void:
	var ledger := value.pipeline.ledger
	var packet := Sources.packet({}, value.pipeline.proposal_snapshot(), ledger, 453, 1)
	_expect("normalized_source", Sources.rows(packet, ledger, 453).size(), 1)
	var verified := {}
	_expect("cached_first", Sources.rows(packet, ledger, 453, verified).size(), 1)
	_expect("cached_same", Sources.rows(packet, ledger, 453, verified).size(), 1)
	_expect("cached_other_ledger", Sources.rows(packet, FX.Ledger.new(), 453, verified), [])
	for key: String in ["station_ids", "source_id", "business_contract_id", "fare"]:
		var bad := packet.duplicate(true)
		bad.sources[0][key] = [] if key == "station_ids" else "tampered"
		_expect("tamper:" + key, Sources.rows(bad, ledger, 453), [])
	var bad := packet.duplicate(true)
	bad.sources[0].business_contract.government_payment.amount += 1
	_expect("tamper_payment", Sources.rows(bad, ledger, 453), [])
	_expect("cache_does_not_mask_tamper", Sources.rows(bad, ledger, 453, verified), [])
	bad = packet.duplicate(true)
	bad.sources[0].business_contract.permitted_plan.plan.station_ids = FX.ROUTE_B
	_expect("tamper_permission", Sources.rows(bad, ledger, 453), [])
	_expect("other_ledger", Sources.rows(packet, FX.Ledger.new(), 453), [])
	_expect("other_minute", Sources.rows(packet, ledger, 454), [])
	bad = packet.duplicate(true)
	bad.sources.append(bad.sources[0].duplicate(true))
	_expect("duplicate_source", Sources.rows(bad, ledger, 453), [])


func _test_source_isolation() -> void:
	var value := TenderFX.create()
	value.request_bid("public", "B01", TenderFX.confirmed(value))
	TenderFX.advance_to(value, 1800)
	var public: Dictionary = value.pipeline.snapshot().tenders
	var bad := {"available": false, "simulation_minute": 1800}
	var packet := Sources.packet(public, bad, value.pipeline.ledger, 1800, 1)
	_expect("public_survives", packet.available, true)
	_expect("bad_proposal_explicit", packet.source_status.COMPANY_PROPOSAL.status, "INVALID")
	_expect(
		"public_source",
		Sources.rows(packet, value.pipeline.ledger, 1800)[0].source_kind,
		"PUBLIC_TENDER"
	)
	var service := Construction.new(value.pipeline.ledger)
	_expect(
		"public_candidate_survives", service.snapshot(1800, 1, packet).contract_candidates.size(), 1
	)
	_samples.L08_source_isolation = {
		"kind": "INVALID_PROVIDER_FIXTURE_WITH_REAL_PUBLIC_CONTRACT", "packet": packet
	}
	value.enable_construction_ui()
	value.dispatch({"command_id": "public-resume", "action": "resume"})
	_construction(value, "contract")
	_expect("legacy_public_no_source_field", _project(value).has("source_kind"), false)
	value.enable_operations_ui()
	value.enable_proposals(2)
	FX.advance(value, 1802)
	_expect("late_proposal_keeps_public", value.pipeline.operations_snapshot().available, true)


func _test_phase_order() -> void:
	var value := FX.session()
	_permit(value)
	# 같은 CONTRACT 단계의 일반 계약이 먼저 같은 사업 ID를 사용한 충돌 반례.
	var project: String = FX.session_row(value).identity.business_identity_id
	var command := {
		"command_id": "generic",
		"target_id": project,
		"target_revision": 0,
		"government": 0,
		"total_cost": 0,
		"requested_at": 452,
		"effective_at": 453
	}
	value.pipeline.commands.submit(command, 452)
	value.request_proposal(FX.session_command(value, "sign", "sign_proposal_contract"))
	FX.advance(value, 453)
	_expect("generic_before_proposal", value.proposal_result("sign").reason, "PROJECT_IN_PROGRESS")
	_expect("failed_payment_atomic", value.pipeline.ledger.snapshot().cash, 1000000)
	_expect("failed_no_contract", FX.session_row(value).business_contract, {})
	_samples.phase_order = FX.sample(value)


func _expect(id: String, actual: Variant, expected: Variant) -> void:
	_checks += 1
	var passed: bool = typeof(actual) == typeof(expected) and actual == expected
	_assertions.append({"id": id, "passed": passed, "actual": actual, "expected": expected})
	if not passed:
		_failures += 1
		push_error("FAIL " + id + " actual=" + str(actual) + " expected=" + str(expected))
