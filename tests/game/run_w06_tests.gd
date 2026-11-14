extends SceneTree
## 실제 정상 명령 연결과 통제 반례를 별도 식별해 W06 승인 의미를 검증한다.

const FX = preload("res://tests/game/w06_fixtures.gd")
const FX5 = preload("res://tests/game/w05_fixtures.gd")
const BidFX = preload("res://tests/game/w04a_fixtures.gd")
const Pipeline = preload("res://scripts/simulation/minute_pipeline.gd")
const Line = preload("res://scripts/model/operating_line.gd")
const Service = preload("res://scripts/simulation/operations_service.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")
const Reports = preload("res://scripts/model/daily_ledger_report.gd")

var _checks: int = 0
var _failures: int = 0
var _case: String = ""
var _assertions: Array[Dictionary] = []
var _evidence: Dictionary = {}
var _chain: Pipeline


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_case = "W06-18"
		_expect("intentional_failure", true, false)
	else:
		for method: String in [
			"_prerequisites",
			"_normal_chain",
			"_identity",
			"_od",
			"_capacity",
			"_oracle",
			"_service_intervals",
			"_funds",
			"_recovery",
			"_same_minute",
			"_midnight",
			"_satisfaction",
			"_reports",
			"_time",
			"_next_query",
			"_fixture_conflict",
			"_consumer",
			"_runner"
		]:
			print("W06_SECTION ", method)
			call(method)
		if "--evidence" in OS.get_cmdline_user_args():
			_write_evidence()
	print("W06_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _prerequisites() -> void:
	_case = "W06-01"
	var pipe := Pipeline.new()
	_expect("requires_w05", pipe.enable_operations().accepted, false)
	_expect(
		"disabled_snapshot", pipe.operations_snapshot().reason_codes, ["OPERATIONS_NOT_ENABLED"]
	)
	pipe.enable_tenders()
	pipe.enable_construction()
	var bad := Predictor.load_parameters()
	bad.fare = 101
	_expect("invalid_parameters", pipe.enable_operations(FX.network(), bad).accepted, false)
	bad = Predictor.load_parameters()
	bad.data_version = "9.9"
	_expect("invalid_data_version", pipe.enable_operations(FX.network(), bad).accepted, false)
	bad = Predictor.load_parameters()
	bad.fare = 100.0
	_expect("typed_fare_required", pipe.enable_operations(FX.network(), bad).accepted, false)
	_expect("valid_enable", pipe.enable_operations().accepted, true)
	_expect("duplicate_enable", pipe.enable_operations().accepted, false)
	BidFX.advance_to(pipe, 380)
	_expect("preopen_zero", pipe.operations_snapshot().daily.boarded, 0)
	_expect("preopen_cost", FX.sum_entries(pipe.ledger, "operating_cost"), 0)
	_expect("preopen_fare", FX.sum_entries(pipe.ledger, "fare"), 0)
	var fixture := FX.controlled()
	var wrong: Dictionary = fixture.construction.duplicate(true)
	wrong.projects[0].business_contract.government_payment.ledger_entry_index = 999
	_expect(
		"payment_source_rejected",
		fixture.service.bind_sources(fixture.tenders, wrong, 359).accepted,
		false
	)
	_expect("rejection_no_money", FX.sum_entries(fixture.ledger, "fare"), 0)
	for key: String in ["trial_status", "safety_status"]:
		var not_ready := FX.controlled()
		not_ready.project.state[key] = "FAILED"
		FX.step(not_ready, 360)
		_expect(key + "_no_passengers", not_ready.service.daily(1).boarded, 0)
		_expect(key + "_no_fare", FX.sum_entries(not_ready.ledger, "fare"), 0)
	var wrong_route := FX.controlled()
	wrong_route.project.state.station_ids = ["S01"]
	FX.step(wrong_route, 360)
	_expect("route_source_rejected", wrong_route.service.service_ready(), false)
	_evidence["preopen"] = pipe.operations_snapshot()


func _normal_chain() -> void:
	_case = "W06-02"
	_chain = FX.opened()
	_expect("real_open_result", _chain.construction_result("open").accepted, true)
	var state := _chain.snapshot()
	_expect("opened_at", state.construction.projects[0].opened_at, 4805)
	_expect(
		"authority_project",
		state.operations.source.project_id,
		state.construction.projects[0].project_id
	)
	_expect(
		"authority_contract",
		state.operations.source.construction_contract_id,
		state.construction.projects[0].construction_contract_id
	)
	_expect("open_first_service", state.operations.daily.service_minutes, 1)
	_expect("no_retroactive_cost", FX.sum_entries(_chain.ledger, "operating_cost"), 0)
	_expect("first_boarding_no_fare", FX.sum_entries(_chain.ledger, "fare"), 0)
	BidFX.advance_to(_chain, 4815)
	_expect("actual_completed", _chain.operations_snapshot().daily.completed > 0, true)
	_expect("actual_cost", FX.sum_entries(_chain.ledger, "operating_cost"), 1000)
	_expect(
		"actual_fare",
		FX.sum_entries(_chain.ledger, "fare"),
		_chain.operations_snapshot().daily.completed * 100
	)
	_evidence["model_chain_open"] = {
		"kind": "MODEL_CHAIN",
		"open_result": _chain.construction_result("open"),
		"operations": _chain.operations_snapshot(),
		"funds": _chain.ledger.snapshot()
	}


func _identity() -> void:
	_case = "W06-03"
	var value := FX.controlled()
	FX.until(value, 365)
	var before: Dictionary = value.service.snapshot(365, 6)
	var entries: Array = value.ledger.entries()
	_expect(
		"repeat_source",
		value.service.bind_sources(value.tenders, value.construction, 365).accepted,
		true
	)
	_expect("repeat_preserves", value.service.snapshot(365, 6), before)
	_expect("repeat_no_money", value.ledger.entries(), entries)
	var stale: Dictionary = value.construction.duplicate(true)
	stale.snapshot_revision = 0
	var stale_tenders: Dictionary = value.tenders.duplicate(true)
	stale_tenders.snapshot_revision = 0
	_expect(
		"stale_source",
		value.service.bind_sources(stale_tenders, stale, 365).reason,
		"STALE_OPERATIONS_SOURCE"
	)
	_expect("stale_no_state_change", value.service.snapshot(365, 6), before)
	var old_open: Dictionary = value.project.state.duplicate(true)
	value.project.invalidate_conditions()
	FX.until(value, 380)
	_expect("invalidated_stops_boarding", value.service.daily(1).boarded, before.daily.boarded)
	_expect("residual_completes", value.service.snapshot(380, 21).in_transit, 0)
	_expect("original_cost_preserved", FX.sum_entries(value.ledger, "operating_cost"), 600)
	value.project.state = old_open
	FX.step(value, 381)
	_expect("older_condition_not_reopened", value.service.service_ready(), false)
	var wrong := FX.controlled()
	wrong.project.state.construction_contract_id = "OTHER"
	FX.step(wrong, 360)
	_expect("wrong_contract_no_boarding", wrong.service.daily(1).boarded, 0)
	var temporal := _line([_pair("A", 1080, 1)])
	temporal.board(360, true, 10)
	_expect("arrival_before_boarding_time_rejected", temporal.arrive(359).accepted, false)
	temporal.arrive(362)
	_expect("boarding_time_reversal_rejected", temporal.board(361, true, 10).accepted, false)
	temporal.close_day(1)
	_expect("closed_day_boarding_rejected", temporal.board(363, true, 10).accepted, false)
	_expect("closed_day_arrival_rejected", temporal.arrive(363).accepted, false)


func _od() -> void:
	_case = "W06-04"
	var value := FX.controlled()
	var snapshot: Dictionary = value.service.snapshot(359, 0)
	var pairs: Array = snapshot.od_pairs
	_expect("accessible_od_count", pairs.size(), 4)
	_expect("shortest_D08", [pairs[3].origin, pairs[3].minutes], ["S08", 7])
	for boundary: Array in [[5, 10], [6, 8], [10, 8], [11, 5]]:
		_expect("q_" + str(boundary[0]), Predictor.selection_tenths(boundary[0]), boundary[1])
	var stops: Array[String] = []
	stops.assign(snapshot.source.station_ids)
	stops.reverse()
	var reversed := Predictor.od_pairs(FX.network(), stops, value.parameters.daily_demand)
	_expect("reversed_od", reversed, pairs)
	var tied_stops: Array[String] = ["S01", "S03", "S02", "S05", "S07", "S08"]
	var tied := Predictor.od_pairs(FX.network(), tied_stops, value.parameters.daily_demand)
	_expect("tie_lexicographic_station", tied[0].origin, "S01")
	_expect("unserved_district_absent", snapshot.carry.has("D05:D06"), false)


func _capacity() -> void:
	_case = "W06-05"
	var parameters := Predictor.load_parameters()
	for id: String in parameters.daily_demand:
		parameters.daily_demand[id] = 0
	parameters.daily_demand.D01 = 1296
	parameters.capacity_per_minute = 1
	var value := FX.controlled(359, {}, parameters)
	FX.until(value, 369)
	var day: Dictionary = value.service.daily(1)
	_expect(
		"capacity_requests",
		[day.requested, day.boarded, day.unboarded, day.completed],
		[12, 10, 2, 9]
	)
	_expect("no_integer_queue", value.service.snapshot(369, 10).in_transit, 1)
	var multi := _line([_pair("B", 10800, 1), _pair("A", 10800, 1)])
	multi.board(360, true, 10)
	var state := multi.snapshot()
	_expect("line_shared_capacity", multi.daily(1).boarded, 10)
	_expect("sorted_allocation", state.cohorts[0].od_id, "A")
	_expect("capacity_unboarded", multi.daily(1).unboarded, 10)
	var carry := _line([_pair("A", 1, 1)])
	carry.board(1439, true, 10)
	carry.close_day(1)
	carry.arrive(1440)
	_expect("fraction_midnight_preserved", carry.snapshot().carry.A, 10)
	carry.board(1800, false, 10)
	_expect("fraction_blocked_preserved", carry.snapshot().carry.A, 20)


func _oracle() -> void:
	_case = "W06-06"
	var value := FX.controlled()
	FX.until(value, 1440)
	var report: Dictionary = value.reports.report(1)
	_expect(
		"full_day_counts",
		[report.operations.requested, report.operations.boarded, report.operations.completed],
		[4860, 4860, 4852]
	)
	_expect("full_day_finance", [report.fare, report.operating_cost], [485200, 108000])
	_expect("full_day_carry_stock", report.operations.closing_in_transit, 8)
	_expect("full_day_satisfaction", report.operations.satisfaction_after, [55, 1])
	FX.until(value, 1450)
	_expect("all_cohorts_arrived", value.service.snapshot(1450, 1091).in_transit, 0)
	_expect("all_fare", FX.sum_entries(value.ledger, "fare"), 486000)
	_expect("no_residual_cost", FX.sum_entries(value.ledger, "operating_cost"), 108000)
	_expect("closed_report_unchanged", value.reports.report(1), report)
	_evidence["full_day_controlled"] = {
		"kind": "MODEL_FIXTURE", "report": report, "after": FX.consumer(value)
	}
	var stops: Array[String] = ["S01", "S05", "S09", "S10", "S11", "S12"]
	var prediction := Predictor.predict(FX.network(), stops, Predictor.load_parameters(), 360, 1800)
	_expect("route_B_fixture_valid", prediction.ok, true)
	var line := _line(
		Predictor.od_pairs(FX.network(), stops, Predictor.load_parameters().daily_demand)
	)
	for minute: int in range(360, 1800):
		line.arrive(minute)
		if minute < 1440:
			line.board(minute, true, 10)
	_expect(
		"route_B_actual_vs_prediction",
		line.daily(1).boarded + line.daily(2).boarded,
		prediction.totals.boarded
	)
	_expect("route_B_completed", line.daily(1).completed + line.daily(2).completed, 1460)


func _service_intervals() -> void:
	_case = "W06-07"
	var data := Predictor.load_parameters()
	for id: String in data.daily_demand:
		data.daily_demand[id] = 0
	var zero := FX.controlled(358, {}, data)
	FX.step(zero, 359)
	_expect("before06_no_service", zero.service.daily(1).service_minutes, 0)
	FX.step(zero, 360)
	_expect("06_service_starts", zero.service.daily(1).service_minutes, 1)
	_expect("06_no_retro_cost", FX.sum_entries(zero.ledger, "operating_cost"), 0)
	FX.step(zero, 361)
	_expect("zero_demand_cost100", FX.sum_entries(zero.ledger, "operating_cost"), 100)
	_expect("zero_demand_no_fare", FX.sum_entries(zero.ledger, "fare"), 0)
	var end := FX.controlled(1438, {}, data)
	FX.until(end, 1441)
	_expect("last_interval_cost100", end.reports.report(1).operating_cost, 100)
	_expect("next_day_cost0", end.reports.current(2).operating_cost, 0)
	_evidence["zero_demand"] = FX.consumer(zero)


func _funds() -> void:
	_case = "W06-08"
	for entry: Array in [
		[{"cash": 0}, "SERVICE_FUNDS_INSUFFICIENT"],
		[{"cash": 1000, "unpaid": 1100}, "UNPAID_BALANCE"],
		[{"cash": 1000, "reserved_by_project": {"OTHER": 1000}}, "SERVICE_FUNDS_INSUFFICIENT"]
	]:
		var value := FX.controlled(359, entry[0])
		var protected: Dictionary = value.ledger.snapshot()
		FX.until(value, 362)
		_expect(entry[1] + "_no_boarding", value.service.daily(1).boarded, 0)
		_expect(entry[1] + "_requests_recorded", value.service.daily(1).unboarded > 0, true)
		_expect(
			entry[1] + "_R_protected",
			value.ledger.snapshot().restricted_by_project,
			protected.restricted_by_project
		)
		_expect(
			entry[1] + "_K_protected",
			value.ledger.snapshot().reserved_by_project,
			protected.reserved_by_project
		)
		_expect(
			entry[1] + "_reason", value.service.snapshot(362, 3).boarding.reason_codes, [entry[1]]
		)
	_evidence["restricted"] = FX.consumer(FX.controlled(359, {"cash": 0}))
	var ledger := Ledger.new({"cash": 50, "reserved_by_project": {"OTHER": 48}})
	ledger.operating_cost(3, 360)
	_expect("partial_payment", FX.money(ledger), [48, 0, 48, 48, 0, 1])
	ledger.fare(11, 361)
	_expect(
		"settlement_no_cost_repeat",
		[FX.money(ledger), FX.sum_entries(ledger, "operating_cost")],
		[[58, 0, 58, 48, 10, 0], 3]
	)


func _recovery() -> void:
	_case = "W06-09"
	for cash: int in [99, 100]:
		var value := FX.controlled(359, {"cash": cash})
		FX.step(value, 360)
		_expect(
			"next_cost_boundary_" + str(cash),
			value.service.snapshot(360, 1).boarding.boarding_allowed,
			cash == 100
		)
	var value := FX.controlled()
	FX.until(value, 365)
	# TEST_ONLY: 새 비용 의무로 가용액을 소진, 기존 이동 cohort를 유지한다.
	var available: int = value.ledger.snapshot().available_cash
	value.ledger.operating_cost(available + 150, 365)
	var before_boarded: int = value.service.daily(1).boarded
	FX.step(value, 366)
	_expect("arrival_pays_B_before_boarding", value.ledger.snapshot().unpaid, 0)
	_expect("recovery_has_funds", value.ledger.snapshot().available_cash >= 100, true)
	_expect("recovery_new_boarding", value.service.daily(1).boarded > before_boarded, true)
	_evidence["recovery"] = FX.consumer(value)


func _same_minute() -> void:
	_case = "W06-10"
	var minute := _chain.clock.minute + 1
	var available: int = _chain.ledger.snapshot().available_cash
	var own := available - 99
	var cmd := {
		"command_id": "same-t-contract",
		"target_id": "OTHER",
		"requested_at": minute - 1,
		"effective_at": minute,
		"target_revision": 0,
		"government": 0,
		"total_cost": own
	}
	_chain.commands.submit(cmd, minute - 1)
	BidFX.advance_to(_chain, minute)
	var result := _chain.commands.result(cmd.command_id)
	_expect("contract_cannot_use_later_fare", result.reason, "OWN_FUNDS_INSUFFICIENT")
	_expect("contract_decision_funds", result.decision_funds.available_cash, available - 100)
	_expect("later_arrival_would_cover", _chain.ledger.snapshot().available_cash >= own, true)
	var phases: Array = []
	for item: Dictionary in _chain.snapshot().trace:
		if item.effective_at == minute:
			phases.append(item.phase)
	_expect(
		"sem_order",
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
	_evidence["sem_contract"] = {"kind": "MODEL_CHAIN", "command": cmd, "result": result}


func _midnight() -> void:
	_case = "W06-11"
	var value := FX.controlled(1438)
	FX.until(value, 1440)
	var old: Dictionary = value.reports.report(1)
	FX.until(value, 1450)
	_expect("real_od_residual", value.reports.current(2).fare > 0, true)
	_expect("real_od_cost0", value.reports.current(2).operating_cost, 0)
	_expect("real_od_previous_unchanged", value.reports.report(1), old)
	var service: Service = FX.controlled(1438).service
	# TEST_ONLY CLOSE-01 cohort: 실제 P-A OD의 10분 통행이라고 표시하지 않는다.
	service._line = _line([_pair("CLOSE01", 10800, 10)])
	service.board(1439, {"boarding_allowed": true, "reason_codes": []})
	_expect("close01_board8", service.daily(1).boarded, 8)
	_expect("close01_original_interval100", service.previous_interval_cost(1440), 100)
	var previous := service.close_day(1, 0)
	service.arrivals(1440)
	var ledger := Ledger.new({"cash": 0, "unpaid": 500})
	var done := service.arrivals(1449)
	ledger.fare(done.completed * 100, 1449)
	_expect("close01_arrival8", done.completed, 8)
	_expect("close01_B0_F300", [ledger.snapshot().unpaid, ledger.snapshot().free_cash], [0, 300])
	_expect("close01_cost_not_recreated", FX.sum_entries(ledger, "operating_cost"), 0)
	_expect("close01_residual_cost0", service.previous_interval_cost(1449), 0)
	_expect("close01_previous_report_frozen", service.close_day(1, 0), previous)
	_expect("close01_duplicate_arrival0", service.arrivals(1449).completed, 0)
	_evidence["close01"] = {
		"kind": "MODEL_FIXTURE",
		"previous": previous,
		"day2": service.daily(2),
		"funds": ledger.snapshot()
	}


func _satisfaction() -> void:
	_case = "W06-12"
	var late := _line([_pair("A", 1080, 1)])
	late.board(360, true, 10)
	late.arrive(362)
	_expect("late_completed_exact", late.close_day(1).satisfaction_after, [53, 1])
	_expect("zero_request_keeps_previous", late.close_day(2).satisfaction_after, [53, 1])
	var no_complete := _line([_pair("A", 1080, 1)])
	no_complete.board(360, true, 10)
	_expect("zero_completed_delay0", no_complete.close_day(1).satisfaction_after, [55, 1])
	for allowed: bool in [false, true]:
		var line := _line([_pair("A", 1080, 1)])
		for day: int in range(1, 12):
			var minute := (day - 1) * 1440 + 360
			line.arrive(minute)
			line.board(minute, allowed, 10)
			line.arrive(minute + 1)
			line.close_day(day)
		_expect(
			"satisfaction_clamp_" + str(allowed),
			line.snapshot().satisfaction,
			[100 if allowed else 0, 1]
		)
	_expect("fraction_exact", Line.add_fraction([1, 3], [1, 6]), [1, 2])
	_expect("overflow_explicit_failure", Line.add_fraction([Line.MAX_INT, 1], [1, 1]), [])
	_expect("min_int_failure", Line.add_fraction([-Line.MAX_INT - 1, 1], [1, 1]), [])
	_expect("invalid_fraction_type", Line.add_fraction([1.0, 2], [1, 2]), [])
	var unavailable := _line([_pair("A", 1080, 1)])
	unavailable._satisfaction = [Line.MAX_INT, 1]
	unavailable.board(360, true, 10)
	var failed := unavailable.close_day(1)
	_expect("overflow_report_missing_not_zero", failed.satisfaction_after, [])
	_expect("overflow_report_reason", failed.reason_codes, ["SATISFACTION_ARITHMETIC_LIMIT"])
	_expect(
		"overflow_current_reason",
		unavailable.daily(2).reason_codes,
		["SATISFACTION_ARITHMETIC_LIMIT"]
	)
	var report: Dictionary = _evidence.full_day_controlled.report.operations
	_expect(
		"stock_identity",
		report.opening_in_transit + report.boarded - report.completed,
		report.closing_in_transit
	)


func _reports() -> void:
	_case = "W06-13"
	var reports := Reports.new()
	_expect("not_closed_missing", reports.report(1), {})
	var line := _line([])
	reports.sync_operations(1, line.daily(1))
	reports.sync([{"kind": "fare", "amount": 100, "effective_at": 360}])
	_expect("financial_sync_keeps_operations", reports.current(1).operations.requested, 0)
	reports.close(1, Ledger.new().snapshot())
	var copy := reports.report(1)
	copy.operations.requested = 999
	copy.closing_funds.cash = -1
	_expect("external_copy_cannot_change_closed", reports.report(1).operations.requested, 0)
	_expect("external_funds_copy", reports.report(1).closing_funds.cash, 1000000)
	_expect("late_operations_rejected", reports.sync_operations(1, copy.operations), false)
	_expect("wrong_day_rejected", reports.sync_operations(2, line.daily(1)), false)
	reports.sync([{"kind": "fare", "amount": 100, "effective_at": 360}])
	_expect("repeated_sync_not_double", reports.report(1).fare, 100)


func _time() -> void:
	_case = "W06-14"
	var baseline: Dictionary = {}
	var entries: Array = []
	for speed: int in [1, 2, 4]:
		print("W06_TIME speed=", speed)
		var pipe := FX.opened()
		pipe.clock.set_speed(speed)
		pipe.clock.paused = true
		var paused := _time_state(pipe)
		var clock := pipe.clock.snapshot()
		pipe.advance_usec(10000000)
		_expect("pause_" + str(speed), [_time_state(pipe), pipe.clock.snapshot()], [paused, clock])
		pipe.clock.paused = false
		var duration: int = 10000000 / speed
		if speed == 1:
			pipe.advance_usec(duration)
			baseline = _time_state(pipe)
			entries = pipe.ledger.entries()
		else:
			pipe.advance_usec(17)
			pipe.advance_usec(duration / 3)
			pipe.advance_usec(duration - 17 - duration / 3)
			_expect("split_speed_snapshot_" + str(speed), _time_state(pipe), baseline)
			_expect(
				"split_speed_ledger_" + str(speed),
				JSON.stringify(pipe.ledger.entries()).sha256_text(),
				JSON.stringify(entries).sha256_text()
			)
	_evidence["time_equivalence"] = {
		"kind": "MODEL_CHAIN", "speeds": [1, 2, 4], "minute": baseline.simulation_minute
	}


func _next_query() -> void:
	_case = "W06-15"
	_expect("before_report_query_blocked", _chain.next_business_query().available, false)
	BidFX.advance_to(_chain, 5760)
	var report := _chain.reports.report(4)
	var stations: Array[String] = []
	stations.assign(_chain.operations_snapshot().source.station_ids)
	var expected := Predictor.predict(
		FX.network(), stations, Predictor.load_parameters(), 4805, 5760
	)
	_expect("partial_day_requests", report.operations.requested, expected.totals.requested)
	_expect("partial_day_completions", report.operations.completed, expected.totals.completed)
	_expect("partial_day_fare", report.fare, expected.totals.predicted_fare)
	_expect("partial_day_cost", report.operating_cost, 95500)
	_expect("partial_day_cash", report.closing_funds.cash, 1200000 + report.fare - 95500)
	var query := _chain.next_business_query()
	_expect("first_actual_report", query.first_valid_report.day_id, 4)
	_expect("first_report_actual_completion", report.operations.completed > 0, true)
	_expect("first_report_actual_fare", report.fare, report.operations.completed * 100)
	_expect("query_available", query.available, true)
	var before := _chain.ledger.entries()
	_expect("query_snapshot_copy", _chain.next_business_query(), query)
	_expect("query_money_no_effect", _chain.ledger.entries(), before)
	_expect("existing_catalog_preserved", query.tenders, _chain.snapshot().tenders)
	_evidence["first_report_next_query"] = {
		"kind": "MODEL_CHAIN",
		"report": report,
		"query": query,
		"operations": _chain.operations_snapshot(),
		"funds": _chain.ledger.snapshot()
	}
	var empty := FX.controlled()
	empty.service.close_day(1, 0)
	_expect(
		"zero_report_not_success", empty.service.next_business_query(empty.tenders).available, false
	)


func _fixture_conflict() -> void:
	_case = "W06-16"
	for key: String in ["operating_cost", "arrival_fare", "eligible", "next_cost"]:
		var pipe := BidFX.pipeline()
		pipe.enable_construction()
		var input := {key: true if key == "eligible" else 100}
		_expect("fixture_before_" + key, pipe.set_fixture(361, input), true)
		var before := pipe.snapshot()
		_expect(
			"conflicting_enable_" + key,
			pipe.enable_operations().reason,
			"OPERATIONS_FIXTURE_CONFLICT"
		)
		_expect("enable_no_partial_state_" + key, pipe.snapshot(), before)
		var active := BidFX.pipeline()
		active.enable_construction()
		active.enable_operations()
		_expect("fixture_after_" + key, active.set_fixture(361, input), false)
	var legacy := Pipeline.new()
	legacy.set_fixture(361, {"arrival_fare": 300, "operating_cost": 100, "eligible": true})
	BidFX.advance_to(legacy, 361)
	_expect("disabled_legacy_money", legacy.ledger.snapshot().cash, 1000200)
	_expect("disabled_no_new_field", legacy.snapshot().has("operations"), false)


func _consumer() -> void:
	_case = "W06-17"
	var value := FX.controlled()
	FX.until(value, 362)
	var source := FX.consumer(value)
	_expect("consumer_revision", source.operations.snapshot_revision, 3)
	_expect("consumer_phase", source.operations.observation_phase, "T_COMPLETE")
	_expect("consumer_missing_vs_zero", source.previous_report, {})
	_expect("consumer_current_zero_or_value", source.current_report.has("fare"), true)
	source.operations.source.station_ids.clear()
	_expect("consumer_source_copy", value.service.snapshot(362, 3).source.station_ids.size(), 6)
	value.project.state.construction_contract_id = "WRONG"
	FX.step(value, 363)
	_expect("consumer_failure_not_zero", value.service.snapshot(363, 4).available, false)
	_expect(
		"consumer_failure_reason",
		value.service.snapshot(363, 4).reason_codes,
		["INVALID_OPERATIONS_SOURCE"]
	)
	_evidence["invalid_source_consumer"] = FX.consumer(value)


func _runner() -> void:
	_case = "W06-18"
	var covered: Dictionary = {}
	for item: Dictionary in _assertions:
		covered[item.case_id] = true
	_expect("planned_cases_1_to_17_present", covered.size(), 17)


func _line(pairs: Array[Dictionary]) -> Line:
	return Line.new(
		{
			"project_id": "TEST_ONLY",
			"business_contract_id": "TEST_ONLY-B",
			"construction_contract_id": "TEST_ONLY-C",
			"condition_revision": 0,
			"opened_at": 0,
			"station_ids": []
		},
		pairs
	)


func _time_state(pipe: Pipeline) -> Dictionary:
	var value := pipe.snapshot()
	value.trace = {"sha256": JSON.stringify(value.trace).sha256_text()}
	return value


func _pair(id: String, demand: int, minutes: int) -> Dictionary:
	return {"id": id, "daily_demand": demand, "minutes": minutes}


func _expect(label: String, actual: Variant, expected: Variant) -> void:
	_checks += 1
	var passed: bool = actual == expected
	if not passed:
		_failures += 1
		print("FAIL ", _case, " ", label, " actual=", actual, " expected=", expected)
	_assertions.append(
		{"case_id": _case, "label": label, "passed": passed, "actual": actual, "expected": expected}
	)


func _write_evidence() -> void:
	var file := FileAccess.open("res://.local/validation/w06-model-results.json", FileAccess.WRITE)
	if file == null:
		_expect("evidence_write", false, true)
		return
	file.store_string(
		(
			JSON.stringify(
				{
					"task_id": "DEV-022",
					"agent_id": "AGT-DEV-0004",
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
