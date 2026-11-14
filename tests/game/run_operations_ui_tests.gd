extends SceneTree
## DEV-023 P1 공급 자동검사. View/씬·실제 GUI·Design L2 수용을 대신하지 않는다.

const FX = preload("res://tests/game/operations_ui_fixtures.gd")
const FX6 = preload("res://tests/game/w06_fixtures.gd")

var _checks: int = 0
var _failures: int = 0
var _case: String = ""
var _assertions: Array[Dictionary] = []
var _evidence: Dictionary = {}
var _chain: FX.Session


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_case = "P1-12"
		_expect("intentional_failure", true, false)
	elif "--l2-supply" in OS.get_cmdline_user_args():
		_l2_restrictions()
		_l2_recovery()
		_l2_states()
		_write_evidence("res://.local/validation/dev023-l2-results.json", "L2_INPUT_SUPPLEMENT")
	else:
		for method: String in [
			"_enable",
			"_invalid_enable",
			"_normal_chain",
			"_read_only",
			"_reports",
			"_finance_boundaries",
			"_operations_errors",
			"_next_query_errors",
			"_controlled_states",
			"_time",
			"_copies"
		]:
			print("DEV023_SECTION ", method)
			call(method)
		if "--evidence" in OS.get_cmdline_user_args():
			_write_evidence()
	print("DEV023_SUPPLY_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _enable() -> void:
	_case = "P1-01"
	var value := FX.session()
	var initial := value.snapshot()
	_expect("default_inactive", initial.operations_ui.status, "UNAVAILABLE")
	_expect("no_implicit_model", initial.current.has("operations"), false)
	_expect("no_query_initial", initial.next_business_ui.allowed_actions.query, false)
	_expect("current_finance_ready", initial.finance_ui.available, true)
	_expect("no_past_report", initial.finance_ui.report.status, "UNAVAILABLE")
	_expect("explicit_enable", value.enable_operations_ui().accepted, true)
	var before := FX.effects(value)
	var revision: int = value.revision
	_expect("repeated_enable", value.enable_operations_ui().accepted, true)
	_expect("repeated_enable_effects", FX.effects(value), before)
	_expect("repeated_enable_revision", value.revision, revision)
	var state := value.snapshot()
	_expect("preopen_normal", state.operations_ui.status, "READY")
	_expect("preopen_not_ready", state.operations_ui.snapshot.service_ready, false)
	_expect("preopen_reason", state.operations_ui.reason_codes, ["SERVICE_NOT_READY"])
	_expect("current_same_source", state.operations_ui.snapshot, state.current.operations)
	_expect(
		"first_report_required",
		value.query_next_business({}).reason,
		"FIRST_VALID_OPERATIONS_REPORT_REQUIRED"
	)
	_evidence["preopen"] = FX.packet(value, "MODEL_CHAIN_SETUP")


func _invalid_enable() -> void:
	_case = "P1-02"
	var parameters := FX.Predictor.load_parameters()
	parameters.fare = 101
	var invalid := FX.session({}, parameters)
	_expect("invalid_parameters", invalid.enable_operations_ui().accepted, false)
	_expect("failed_activation_not_zero", invalid.snapshot().operations_ui.status, "FAILED")
	_expect(
		"invalid_reason",
		invalid.snapshot().operations_ui.reason_codes,
		["INVALID_OPERATIONS_INPUT"]
	)
	var conflict := FX.session()
	_expect(
		"legacy_fixture_installed",
		conflict.pipeline.set_fixture(361, {"arrival_fare": 800, "eligible": true}),
		true
	)
	_expect(
		"fixture_conflict_rejected",
		conflict.enable_operations_ui().reason,
		"OPERATIONS_FIXTURE_CONFLICT"
	)
	FX.advance_to(conflict, 361)
	_expect("legacy_fare_preserved", conflict.pipeline.reports.current(1).fare, 800)
	var active := FX.session()
	active.enable_operations_ui()
	_expect(
		"active_rejects_injection", active.pipeline.set_fixture(361, {"arrival_fare": 800}), false
	)
	_evidence["activation_failed"] = FX.packet(invalid, "MODEL_FIXTURE")
	_evidence["fixture_conflict"] = FX.packet(conflict, "MODEL_FIXTURE")


func _normal_chain() -> void:
	_case = "P1-03"
	var opened := FX.opened()
	_chain = opened.session
	for step: Dictionary in opened.steps:
		var key: String = "pending" if step.stage == "bid" else "accepted"
		_expect("actual_" + step.stage, step.result.get(key, false), true)
	_expect("actual_open_minute", _chain.pipeline.clock.minute, 4805)
	var initial := _chain.snapshot()
	_expect("valid_source_ready", initial.operations_ui.snapshot.service_ready, true)
	_expect(
		"actual_business_id",
		initial.operations_ui.snapshot.source.business_contract_id,
		"B01-R1-BUSINESS"
	)
	_evidence["actual_open"] = FX.packet(_chain, "MODEL_CHAIN_SETUP")
	FX.advance_to(_chain, 5760)
	var state := _chain.snapshot()
	var closed: Dictionary = state.finance_ui.report.value
	_expect("actual_report_ready", state.finance_ui.report.status, "READY")
	_expect("actual_closed_day", closed.day_id, 4)
	_expect("actual_operating_cost", closed.operating_cost, 95500)
	_expect("actual_fare", closed.fare, 429100)
	_expect("actual_requested", closed.operations.requested, 4296)
	_expect("actual_boarded", closed.operations.boarded, 4296)
	_expect("actual_completed", closed.operations.completed, 4291)
	_expect("actual_satisfaction", closed.operations.satisfaction_after, [55, 1])
	_expect("closed_stock", closed.operations.closing_in_transit, 5)
	_expect("current_stock", state.operations_ui.snapshot.in_transit, 1)
	_expect("closed_cash", closed.closing_funds.cash, 1533600)
	_expect("restricted_preserved", closed.closing_funds.restricted, 200000)
	_expect("next_query_available", state.next_business_ui.available, true)
	_expect(
		"query_matches_actual_catalog", state.next_business_ui.tenders, state.tender_ui.snapshot
	)
	_evidence["actual_first_report"] = FX.packet(_chain, "MODEL_CHAIN_SETUP")


func _read_only() -> void:
	_case = "P1-04"
	var confirmation: Dictionary = _chain.snapshot().next_business_ui
	var before := FX.effects(_chain)
	var revision: int = _chain.revision
	for repeat: int in range(3):
		var result := _chain.query_next_business(confirmation)
		_expect("query_success_" + str(repeat), result.accepted, true)
		_expect("catalog_same_" + str(repeat), result.tenders, confirmation.tenders)
		_chain.snapshot()
	_expect("reads_effects0", FX.effects(_chain), before)
	_expect("reads_revision_stable", _chain.revision, revision)
	var changed := confirmation.duplicate(true)
	changed.first_valid_report.fare += 100
	_expect("changed_report_rejected", _chain.query_next_business(changed).reason, "STATE_CHANGED")
	changed = confirmation.duplicate(true)
	changed.report_key = "another-run/day-4"
	_expect(
		"wrong_display_key_rejected", _chain.query_next_business(changed).reason, "STATE_CHANGED"
	)
	_expect("no_confirmation_rejected", _chain.query_next_business({}).reason, "STATE_CHANGED")
	_expect("rejections_effects0", FX.effects(_chain), before)
	_chain.refresh_tenders()
	_expect("unrelated_revision_allowed", _chain.query_next_business(confirmation).accepted, true)
	var queued := _chain.pipeline.commands.submit(
		{
			"command_id": "future-check",
			"target_id": "UNKNOWN-TEST",
			"requested_at": 5760,
			"effective_at": 6000,
			"target_revision": 0,
			"government": 0,
			"total_cost": 0
		},
		5760
	)
	_expect("pending_control", queued.pending, true)
	before = FX.effects(_chain)
	_chain.query_next_business(confirmation)
	_chain.select_finance_report(4)
	_chain.snapshot()
	_expect("pending_queue_unchanged", FX.effects(_chain), before)


func _reports() -> void:
	_case = "P1-05"
	var value := FX.session()
	FX.advance_to(value, 2880)
	var latest := value.snapshot()
	_expect("latest_day", latest.finance_ui.report.day_id, 2)
	_expect("actual_zero_report", latest.finance_ui.report.value.fare, 0)
	_expect("zero_report_not_operations_proof", latest.next_business_ui.available, false)
	var before := FX.effects(value)
	for invalid: Variant in [-1, 0, 3, 4, 1.0, true, "1", null]:
		_expect("invalid_day_" + str(invalid), value.select_finance_report(invalid).accepted, false)
	_expect("invalid_selection_effects0", FX.effects(value), before)
	_expect("select_day1", value.select_finance_report(1).accepted, true)
	var selected := value.snapshot()
	_expect("selected_day", selected.finance_ui.report.day_id, 1)
	_expect("legacy_report_still_previous", selected.report.day_id, 2)
	var revision: int = value.revision
	value.select_finance_report(1)
	_expect("repeat_selection_revision", value.revision, revision)
	_expect("selection_effects0", FX.effects(value), before)
	var frozen: Dictionary = selected.finance_ui.report.duplicate(true)
	FX.advance_to(value, 4320)
	_expect("fixed_selection_across_midnight", value.snapshot().finance_ui.report, frozen)
	_expect("root_previous_advances", value.snapshot().report.day_id, 3)
	_evidence["zero_fixed_report"] = FX.packet(value, "MODEL_CHAIN_SETUP")
	value.report_error = "TEST_REPORT_FAILURE"
	_expect("failed_report", value.snapshot().finance_ui.report.status, "FAILED")
	_expect("failed_has_no_value", value.snapshot().finance_ui.report.value, {})
	_expect("current_independent_of_report", value.snapshot().finance_ui.available, true)
	_evidence["report_failure"] = FX.packet(value, "CONSUMER_FIXTURE")
	value.report_error = ""
	_expect("report_recovered", value.snapshot().finance_ui.report, frozen)


func _finance_boundaries() -> void:
	_case = "P1-06"
	var value := FX.session({"cash": 50, "reserved_by_project": {"OTHER": 48}})
	value.pipeline.ledger.operating_cost(3, 360)
	value.pipeline.reports.sync(value.pipeline.ledger.entries())
	var first: Dictionary = value.snapshot().finance_ui
	_expect("partial_payment_cash", first.current_funds.cash, 48)
	_expect("partial_payment_debt", first.current_funds.unpaid, 1)
	_expect("partial_payment_incurred", first.current_activity.operating_cost, 3)
	_expect("partial_payment_immediate", first.current_activity.payment, 2)
	_evidence["partial_payment"] = FX.packet(value, "MODEL_FIXTURE")
	FX.advance_to(value, 361)
	value.pipeline.ledger.fare(11, 361)
	value.pipeline.reports.sync(value.pipeline.ledger.entries())
	var second: Dictionary = value.snapshot().finance_ui
	_expect("settled_cash", second.current_funds.cash, 58)
	_expect("settled_available", second.current_funds.available_cash, 10)
	_expect("settled_debt", second.current_funds.unpaid, 0)
	_expect("no_double_expense", second.current_activity.operating_cost, 3)
	_expect("debt_payment_separate", second.current_activity.debt_payment, 1)
	_expect("operating_cash_sum", second.current_activity.cash_payment, 3)
	_evidence["settlement"] = FX.packet(value, "MODEL_FIXTURE")
	var current := value.pipeline.snapshot()
	var daily := value.pipeline.reports.current(1)
	for key: String in ["operating_cost", "payment", "debt_payment", "fare"]:
		var invalid := daily.duplicate(true)
		invalid.erase(key)
		_expect("missing_" + key, value._finance_snapshot(current, invalid).available, false)
	var wrong := current.duplicate(true)
	wrong.funds.cash = 58.0
	_expect("wrong_funds_type", value._finance_snapshot(wrong, daily).available, false)
	var overflow := daily.duplicate(true)
	overflow.payment = 9223372036854775807
	overflow.debt_payment = 1
	_expect("cash_sum_overflow", value._finance_snapshot(current, overflow).available, false)
	_expect("valid_finance_recovery", value._finance_snapshot(current, daily).available, true)


func _operations_errors() -> void:
	_case = "P1-07"
	var current := _chain.pipeline.snapshot()
	for key: String in ["requested", "completed", "satisfaction_after"]:
		var missing_count := current.duplicate(true)
		missing_count.operations.daily.erase(key)
		_expect(
			"missing_daily_" + key,
			FX.consumer(missing_count).snapshot().operations_ui.available,
			false
		)
	for fraction: Variant in [[1, 0], [1.0, 2], "unknown"]:
		var invalid_fraction := current.duplicate(true)
		invalid_fraction.operations.satisfaction = fraction
		_expect(
			"invalid_fraction_" + str(fraction),
			FX.consumer(invalid_fraction).snapshot().operations_ui.available,
			false
		)
	var invalid_cohort := current.duplicate(true)
	invalid_cohort.operations.cohorts = [{"od_id": "S01:S02", "count": 1}]
	_expect(
		"missing_cohort_time", FX.consumer(invalid_cohort).snapshot().operations_ui.available, false
	)
	for key: String in ["available", "boarding", "daily", "cohorts", "satisfaction", "source"]:
		var missing := current.duplicate(true)
		missing.operations.erase(key)
		var value := FX.consumer(missing)
		var packet: Dictionary = value.snapshot().operations_ui
		_expect("missing_" + key, packet.status, "FAILED")
		_expect("missing_has_no_snapshot_" + key, packet.snapshot, {})
	for key: String in ["simulation_minute", "snapshot_revision", "day_id"]:
		var mismatch := current.duplicate(true)
		mismatch.operations[key] -= 1
		_expect(
			"mismatched_" + key, FX.consumer(mismatch).snapshot().operations_ui.available, false
		)
	var bad := current.duplicate(true)
	bad.operations.ui_contract_revision = "unknown-version"
	_expect("unknown_contract", FX.consumer(bad).snapshot().operations_ui.available, false)
	bad = current.duplicate(true)
	bad.operations.in_transit = 1.0
	_expect("wrong_count_type", FX.consumer(bad).snapshot().operations_ui.available, false)
	bad = current.duplicate(true)
	bad.operations.available = false
	bad.operations.service_ready = false
	bad.operations.reason_codes = ["TEST_UNKNOWN_SOURCE_REASON"]
	var unknown := FX.consumer(bad)
	_expect(
		"unknown_reason_preserved",
		unknown.snapshot().operations_ui.reason_codes,
		["TEST_UNKNOWN_SOURCE_REASON"]
	)
	_evidence["unknown_source_failure"] = FX.packet(unknown, "CONSUMER_FIXTURE")
	var recovered := FX.consumer(current)
	_expect("valid_supply_recovered", recovered.snapshot().operations_ui.available, true)


func _next_query_errors() -> void:
	_case = "P1-08"
	var current := _chain.pipeline.snapshot()
	var raw := _chain.pipeline.next_business_query()
	var unavailable := raw.duplicate(true)
	unavailable.available = false
	unavailable.reason_codes = ["TENDER_SUPPLY_UNAVAILABLE"]
	unavailable.tenders = {}
	var value := FX.consumer(current, unavailable, _chain.pipeline.reports)
	var packet: Dictionary = value.snapshot().next_business_ui
	_expect("query_permission_separate", packet.allowed_actions.query, true)
	_expect("supply_failure_not_ready", packet.available, false)
	_expect(
		"supply_failure_reason",
		value.query_next_business(packet).reason,
		"TENDER_SUPPLY_UNAVAILABLE"
	)
	_evidence["next_supply_unavailable"] = FX.packet(value, "CONSUMER_FIXTURE")
	for field: String in ["completed", "service_minutes", "fare"]:
		var wrong := raw.duplicate(true)
		wrong.first_valid_report[field] = 0
		_expect(
			"invalid_report_" + field,
			(
				FX
				. consumer(current, wrong, _chain.pipeline.reports)
				. snapshot()
				. next_business_ui
				. available
			),
			false
		)
	var stale := raw.duplicate(true)
	stale.tenders.snapshot_revision -= 1
	_expect(
		"stale_catalog",
		FX.consumer(current, stale, _chain.pipeline.reports).snapshot().next_business_ui.available,
		false
	)
	var valid := FX.consumer(current, raw, _chain.pipeline.reports)
	_expect("current_catalog_recovers", valid.snapshot().next_business_ui.available, true)


func _controlled_states() -> void:
	_case = "P1-09"
	var parameters := FX.Predictor.load_parameters()
	for id: String in parameters.daily_demand:
		parameters.daily_demand[id] = 0
	var zero := FX6.controlled(359, {}, parameters)
	FX6.until(zero, 361)
	var value := FX.consumer(FX.controlled_current(zero), {}, zero.reports)
	var state := value.snapshot()
	_expect("zero_demand_valid", state.operations_ui.available, true)
	_expect("zero_demand_requested", state.operations_ui.snapshot.daily.requested, 0)
	_expect("zero_demand_service_cost", state.finance_ui.current_activity.operating_cost, 100)
	_expect("not_closed_satisfaction", state.operations_ui.snapshot.daily.satisfaction_after, [])
	_evidence["zero_demand"] = FX.packet(value, "MODEL_FIXTURE_TO_CONSUMER")
	for entry: Array in [
		[{"cash": 0}, "SERVICE_FUNDS_INSUFFICIENT"],
		[{"cash": 1000, "unpaid": 1100}, "UNPAID_BALANCE"]
	]:
		var limited := FX6.controlled(359, entry[0])
		FX6.until(limited, 362)
		var limited_session := FX.consumer(FX.controlled_current(limited), {}, limited.reports)
		var observed := limited_session.snapshot()
		_expect(entry[1] + "_source_valid", observed.operations_ui.available, true)
		_expect(
			entry[1] + "_boarding_limited",
			observed.operations_ui.snapshot.boarding.boarding_allowed,
			false
		)
		_expect(
			entry[1] + "_reason", observed.operations_ui.snapshot.boarding.reason_codes, [entry[1]]
		)
		_evidence[entry[1]] = FX.packet(limited_session, "MODEL_FIXTURE_TO_CONSUMER")
	var missing := FX.controlled_current(zero)
	missing.operations.satisfaction = []
	missing.operations.daily.satisfaction_available = false
	missing.operations.daily.reason_codes = ["SATISFACTION_ARITHMETIC_LIMIT"]
	var satisfaction := FX.consumer(missing, {}, zero.reports)
	_expect(
		"satisfaction_absent_not_zero",
		satisfaction.snapshot().operations_ui.snapshot.satisfaction,
		[]
	)
	_evidence["satisfaction_unavailable"] = FX.packet(satisfaction, "CONSUMER_FIXTURE")
	var recovered := FX6.controlled()
	FX6.until(recovered, 365)
	var available: int = recovered.ledger.snapshot().available_cash
	recovered.ledger.operating_cost(available + 150, 365)
	FX6.step(recovered, 366)
	var recovery := FX.consumer(FX.controlled_current(recovered), {}, recovered.reports)
	_expect("same_T_settlement_B0", recovery.snapshot().finance_ui.current_funds.unpaid, 0)
	_expect(
		"same_T_boarding_allowed",
		recovery.snapshot().operations_ui.snapshot.boarding.boarding_allowed,
		true
	)
	_evidence["same_T_recovery"] = FX.packet(recovery, "MODEL_FIXTURE_TO_CONSUMER")
	var midnight := FX6.controlled(1438)
	FX6.until(midnight, 1440)
	var closed: Dictionary = midnight.reports.report(1)
	FX6.until(midnight, 1450)
	var residual := FX.consumer(FX.controlled_current(midnight), {}, midnight.reports)
	var finance: Dictionary = residual.snapshot().finance_ui
	_expect("residual_day2_fare", finance.current_activity.fare > 0, true)
	_expect("residual_no_cost", finance.current_activity.operating_cost, 0)
	_expect("previous_report_frozen", finance.report.value, closed)
	_expect(
		"outside_service_no_boarding",
		residual.snapshot().operations_ui.snapshot.boarding.boarding_allowed,
		false
	)
	_evidence["midnight_residual"] = FX.packet(residual, "MODEL_FIXTURE_TO_CONSUMER")


func _time() -> void:
	_case = "P1-10"
	var expected: Dictionary = {}
	for speed: int in [1, 2, 4]:
		var value := FX.session()
		value.enable_operations_ui()
		value.pipeline.clock.set_speed(speed)
		FX.advance_to(value, 367)
		var current := value.pipeline.snapshot()
		if speed == 1:
			expected = current
		else:
			_expect("speed_" + str(speed) + "_same_model", current, expected)
		value.pipeline.clock.paused = true
		var before := FX.effects(value)
		value.advance_usec(10000000)
		for repeat: int in range(3):
			value.snapshot()
		_expect("paused_queries_" + str(speed), FX.effects(value), before)


func _copies() -> void:
	_case = "P1-11"
	var before := FX.effects(_chain)
	var state := _chain.snapshot()
	state.operations_ui.snapshot.source.station_ids.clear()
	state.finance_ui.current_funds.cash = 0
	state.finance_ui.report.value.closing_funds.cash = 0
	state.next_business_ui.tenders.tenders.clear()
	_expect("packet_mutation_no_model_effect", FX.effects(_chain), before)
	var confirmation: Dictionary = _chain.snapshot().next_business_ui
	var result := _chain.query_next_business(confirmation)
	result.tenders.tenders.clear()
	_expect("query_result_is_copy", FX.effects(_chain), before)


func _expect(label: String, actual: Variant, expected: Variant) -> void:
	_checks += 1
	var passed: bool = actual == expected
	if not passed:
		_failures += 1
		print("FAIL ", _case, " ", label, " actual=", actual, " expected=", expected)
	_assertions.append(
		{"case_id": _case, "label": label, "passed": passed, "actual": actual, "expected": expected}
	)


func _write_evidence(
	path: String = "res://.local/validation/dev023-supply-results.json",
	stage: String = "P1_SUPPLY_ONLY"
) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		_expect("evidence_write", false, true)
		return
	file.store_string(
		(
			JSON.stringify(
				{
					"task_id": "DEV-023",
					"agent_id": "AGT-DEV-0004",
					"stage": stage,
					"design_l2": "PENDING",
					"engine": Engine.get_version_info().string,
					"checks": _checks,
					"failures": _failures,
					"assertions": _assertions,
					"scenarios": _evidence
				},
				"\t"
			)
			+ "\n"
		)
	)


## Design L2-02: 초기 T359 대신 실제 제한 T362와 보호 자금을 추출한다.
func _l2_restrictions() -> void:
	_case = "L2-02-R"
	for entry: Array in [
		["funds", {"cash": 0}, "SERVICE_FUNDS_INSUFFICIENT"],
		["unpaid", {"cash": 1000, "unpaid": 1100}, "UNPAID_BALANCE"],
		[
			"reserved",
			{"cash": 1000, "reserved_by_project": {"OTHER": 1000}},
			"SERVICE_FUNDS_INSUFFICIENT"
		]
	]:
		var model := FX6.controlled(359, entry[1])
		var protected: Dictionary = model.ledger.snapshot()
		FX6.until(model, 362)
		var packet := _l2_packet(model)
		var observed: Dictionary = packet.operations_ui.snapshot
		var funds: Dictionary = packet.finance_ui.current_funds
		_expect(entry[0] + "_minute", packet.operations_ui.observation.simulation_minute, 362)
		_expect(entry[0] + "_revision", packet.operations_ui.observation.snapshot_revision, 3)
		_expect(entry[0] + "_valid", packet.operations_ui.available, true)
		_expect(entry[0] + "_blocked", observed.boarding.boarding_allowed, false)
		_expect(entry[0] + "_reason", observed.boarding.reason_codes, [entry[2]])
		_expect(entry[0] + "_no_boarding", observed.daily.boarded, 0)
		_expect(entry[0] + "_unboarded", observed.daily.unboarded > 0, true)
		_expect(entry[0] + "_R", funds.restricted_by_project, protected.restricted_by_project)
		_expect(entry[0] + "_K", funds.reserved_by_project, protected.reserved_by_project)
		_evidence["l2_restricted_" + entry[0]] = {
			"kind": "MODEL_FIXTURE_TO_CONSUMER",
			"input": {"initial_minute": 359, "initial": entry[1], "advance_to": 362},
			"protected_before": protected,
			"packet": packet
		}


## 동일 통제 모델의 제한·잔여 도착·B0 이후 비용 부족·재개를 각각 보존한다.
func _l2_recovery() -> void:
	_case = "L2-02-C"
	var parameters := FX.Predictor.load_parameters()
	for id: String in parameters.daily_demand:
		parameters.daily_demand[id] = 0
	# TEST_ONLY: 실제 운영선의 7분 OD에 분당 1명 입력. 제품 수요값은 변경하지 않는다.
	for pair: Dictionary in FX.controlled_current(FX6.controlled()).operations.od_pairs:
		if pair.minutes == 7:
			parameters.daily_demand[pair.id.get_slice(":", 0)] = 1350
	var model := FX6.controlled(359, {}, parameters)
	FX6.until(model, 365)
	var prepared_at: int = model.minute
	var before := _l2_packet(model)
	var due := 0
	for cohort: Dictionary in before.operations_ui.snapshot.cohorts:
		if cohort.expected_at == prepared_at + 1:
			due += cohort.count * 100
	var available: int = model.ledger.snapshot().available_cash
	# TEST_ONLY 의무 주입. 다음 T의 비용100·실제 도착 운임 후 B50이 남도록 통제한다.
	var imposed: int = available + due - 100 + 50
	_expect("duty_injected", model.ledger.operating_cost(imposed, prepared_at), true)
	FX6.step(model, prepared_at + 1)
	var restricted := _l2_packet(model)
	var observed: Dictionary = restricted.operations_ui.snapshot
	_expect("restricted_B50", restricted.finance_ui.current_funds.unpaid, 50)
	_expect("restricted_boarding", observed.boarding.boarding_allowed, false)
	_expect("restricted_reason", observed.boarding.reason_codes, ["UNPAID_BALANCE"])
	_expect("residual_in_transit", observed.in_transit > 0, true)
	var resumed: Dictionary = {}
	var settled_insufficient: Dictionary = {}
	for minute: int in range(prepared_at + 2, prepared_at + 16):
		FX6.step(model, minute)
		var packet := _l2_packet(model)
		var funds: Dictionary = packet.finance_ui.current_funds
		var gate: Dictionary = packet.operations_ui.snapshot.boarding
		if funds.unpaid == 0 and not gate.boarding_allowed and settled_insufficient.is_empty():
			settled_insufficient = packet
		if gate.boarding_allowed:
			resumed = packet
			break
	_expect("B0_not_enough_sample", not settled_insufficient.is_empty(), true)
	_expect("resumed_sample", not resumed.is_empty(), true)
	if resumed.is_empty() or settled_insufficient.is_empty():
		return
	_expect(
		"B0_reason",
		settled_insufficient.operations_ui.snapshot.boarding.reason_codes,
		["SERVICE_FUNDS_INSUFFICIENT"]
	)
	_expect("resumed_B0", resumed.finance_ui.current_funds.unpaid, 0)
	_expect("resumed_A100", resumed.finance_ui.current_funds.available_cash >= 100, true)
	_expect(
		"arrival_progress",
		resumed.operations_ui.snapshot.daily.completed > observed.daily.completed,
		true
	)
	_expect(
		"new_boarding_resumed",
		resumed.operations_ui.snapshot.daily.boarded > observed.daily.boarded,
		true
	)
	_expect(
		"R_protected",
		resumed.finance_ui.current_funds.restricted_by_project,
		before.finance_ui.current_funds.restricted_by_project
	)
	_expect(
		"K_protected",
		resumed.finance_ui.current_funds.reserved_by_project,
		before.finance_ui.current_funds.reserved_by_project
	)
	_expect(
		"no_extra_service_cost_while_blocked",
		resumed.finance_ui.current_activity.operating_cost,
		restricted.finance_ui.current_activity.operating_cost
	)
	_expect(
		"debt_payment_progress",
		(
			resumed.finance_ui.current_activity.debt_payment
			> restricted.finance_ui.current_activity.debt_payment
		),
		true
	)
	_evidence["l2_restriction_recovery"] = {
		"kind": "MODEL_FIXTURE_TO_CONSUMER",
		"input":
		{
			"initial_minute": 359,
			"TEST_ONLY_daily_demand": parameters.daily_demand,
			"advance_to": prepared_at,
			"test_only_cost": imposed,
			"cost_at": prepared_at
		},
		"before": before,
		"restricted": restricted,
		"B0_still_insufficient": settled_insufficient,
		"resumed": resumed
	}


## L2-03: 미공급/실제 원본 오류·복구/관측 불일치와 지연 응답 입력을 보강한다.
func _l2_states() -> void:
	_case = "L2-03-S"
	var model := FX6.controlled()
	FX6.until(model, 364)
	var session := FX.consumer(FX.controlled_current(model), {}, model.reports)
	var older := FX.packet(session, "CONSUMER_FIXTURE")
	FX6.step(model, 365)
	var current := FX.controlled_current(model)
	session.pipeline.supplied = current.duplicate(true)
	session.pipeline.clock.minute = 365
	session.revision += 1
	var newer := FX.packet(session, "CONSUMER_FIXTURE")
	_expect("newer_model_observation", newer.operations_ui.observation.simulation_minute, 365)
	_expect("older_model_observation", older.operations_ui.observation.simulation_minute, 364)
	_expect(
		"newer_view_revision",
		newer.operations_ui.view_revision > older.operations_ui.view_revision,
		true
	)
	_evidence["l2_delayed_response_inputs"] = {
		"kind": "CONSUMER_FIXTURE",
		"delivery_order": ["newer", "older"],
		"newer": newer,
		"older": older,
		"expected_ui": "KEEP_NEWER; VIEW_IMPLEMENTATION_NOT_RUN"
	}
	var missing := current.duplicate(true)
	missing.erase("operations")
	var unavailable := FX.packet(FX.consumer(missing, {}, model.reports), "CONSUMER_FIXTURE")
	_expect("missing_operations_failed", unavailable.operations_ui.status, "FAILED")
	_expect("missing_not_zero", unavailable.operations_ui.snapshot, {})
	_evidence["l2_missing_operations"] = {
		"kind": "CONSUMER_FIXTURE", "input": missing, "packet": unavailable
	}
	var stale := current.duplicate(true)
	stale.operations.snapshot_revision -= 1
	var rejected := FX.packet(FX.consumer(stale, {}, model.reports), "CONSUMER_FIXTURE")
	_expect(
		"mixed_revision_rejected",
		rejected.operations_ui.reason_codes,
		["INVALID_OPERATIONS_SUPPLY"]
	)
	_evidence["l2_mixed_revision"] = {
		"kind": "CONSUMER_FIXTURE", "input": stale, "packet": rejected
	}
	var original_entries: Array = model.ledger.entries()
	var invalid: Dictionary = model.construction.duplicate(true)
	invalid.available = false
	_expect(
		"actual_source_rejected",
		model.service.bind_sources(model.tenders, invalid, 365).accepted,
		false
	)
	var failed := _l2_packet(model)
	_expect("actual_source_failure", failed.operations_ui.status, "FAILED")
	_expect(
		"source_failure_reason", failed.operations_ui.reason_codes, ["INVALID_OPERATIONS_SOURCE"]
	)
	_expect(
		"actual_source_recovers",
		model.service.bind_sources(model.tenders, model.construction, 365).accepted,
		true
	)
	var recovered := _l2_packet(model)
	_expect("recovered_ready", recovered.operations_ui.available, true)
	_expect("source_reads_no_ledger_effect", model.ledger.entries(), original_entries)
	_evidence["l2_source_error_recovery"] = {
		"kind": "MODEL_FIXTURE_TO_CONSUMER",
		"input":
		{"minute": 365, "invalid_construction": invalid, "restore": "original_construction"},
		"failed": failed,
		"recovered": recovered
	}


func _l2_packet(model: Dictionary) -> Dictionary:
	return FX.packet(
		FX.consumer(FX.controlled_current(model), {}, model.reports), "MODEL_FIXTURE_TO_CONSUMER"
	)
