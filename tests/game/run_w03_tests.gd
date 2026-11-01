extends SceneTree

const Loader = preload("res://scripts/data/gate2_data_loader.gd")
const Network = preload("res://scripts/model/administrative_network.gd")
const Plan = preload("res://scripts/model/route_plan.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")
const Prediction = preload("res://scripts/model/prediction_state.gd")
const ROUTE_A: Array[String] = ["S01", "S02", "S03", "S04", "S08", "S12"]
const ROUTE_B: Array[String] = ["S01", "S05", "S09", "S10", "S11", "S12"]
const ROUTE_8: Array[String] = ["S01", "S02", "S06", "S05", "S09", "S10", "S11", "S12"]

var _checks: int = 0
var _failures: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure", true, false)
	else:
		var loaded := Loader.load_data()
		_expect("W01_data", loaded.ok, true)
		if loaded.ok:
			_test_network(loaded.data)
			var network := Network.new(loaded.data)
			_test_plan(network)
			_test_prediction(network)
			_test_revisions()
	print("W03_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _test_network(data: Dictionary) -> void:
	_expect("empty_network", Network.new({}).valid(), false)
	var network := Network.new(data)
	_expect("valid_network", network.valid(), true)
	_expect("parents14", network.parents().size(), 14)
	_expect("known_station", network.station("S12").neighborhood_id, "D08")
	_expect("known_city", network.in_city("S12", "C01"), true)
	_expect("unknown_city", network.in_city("S12", "MISSING"), false)
	_expect("bidirectional", network.connected("S02", "S01"), true)
	_expect("nonedge", network.connected("S01", "S06"), false)
	for kind: String in [
		"duplicate", "orphan", "cycle", "parent_type", "affiliation", "edge", "edge_type"
	]:
		var bad := data.duplicate(true)
		match kind:
			"duplicate":
				bad.stations.append(bad.stations[0].duplicate())
			"orphan":
				bad.administration[1].parent_id = "MISSING"
			"cycle":
				bad.administration[0].parent_id = "C01"
			"parent_type":
				bad.administration[0].parent_id = []
			"affiliation":
				bad.stations[0].neighborhood_id = "MISSING"
			"edge_type":
				bad.edges = 1
			"edge":
				bad.edges.append(["S01", "MISSING"])
		var rejected := Network.new(bad)
		_expect(kind + ":rejected", rejected.valid(), false)
		_expect(kind + ":fail_closed", rejected.in_city("S01", "C01"), false)
	var alternate := data.duplicate(true)
	alternate.administration.append({"id": "SPECIAL", "parent_id": ""})
	alternate.administration.append({"id": "SPECIAL-D", "parent_id": "SPECIAL"})
	alternate.stations.append({"id": "EXTERNAL", "neighborhood_id": "SPECIAL-D"})
	var external := Network.new(alternate)
	_expect("test_only_special_city", external.in_city("EXTERNAL", "SPECIAL"), true)
	_expect("external_not_local", external.in_city("EXTERNAL", "C01"), false)
	var plan := Plan.new(external)
	var bad_route := ROUTE_A.duplicate()
	bad_route[5] = "EXTERNAL"
	_expect(
		"outside_jurisdiction",
		"OUTSIDE_JURISDICTION" in plan.validate(bad_route).reason_codes,
		true
	)
	_expect("source_unmodified", Loader.load_data().data, data)


func _test_plan(network: Network) -> void:
	var plan := Plan.new(network)
	for route: Array[String] in [ROUTE_A, ROUTE_B, ROUTE_8]:
		_expect("approved_route", plan.validate(route).valid, true)
	var short: Array[String] = ["S01", "S02", "S03", "S04", "S08"]
	var long: Array[String] = ["S01", "S02", "S03", "S04", "S08", "S07", "S06", "S05", "S09"]
	_expect("5_stations", plan.validate(short).valid, false)
	_expect("9_stations", plan.validate(long).valid, false)
	var duplicate := ROUTE_A.duplicate()
	duplicate[5] = "S01"
	_expect("duplicate_revisit", "DUPLICATE_STATION" in plan.validate(duplicate).reason_codes, true)
	var disconnected := ROUTE_A.duplicate()
	disconnected.reverse()
	disconnected[2] = "S06"
	_expect("disconnected", "DISCONNECTED" in plan.validate(disconnected).reason_codes, true)
	plan.replace(ROUTE_A)
	var prior := plan.snapshot()
	_expect("duplicate_select_rejected", plan.select("S01").accepted, false)
	_expect("unknown_select_rejected", plan.select("UNKNOWN").accepted, false)
	_expect("rejected_no_state_change", plan.snapshot(), prior)
	plan.replace(ROUTE_A)
	_expect("same_plan_no_revision_change", plan.snapshot(), prior)
	plan.remove("S12")
	_expect("remove", plan.snapshot().station_ids, short)
	_expect("undo", plan.undo(), true)
	_expect("undo_restores_order", plan.snapshot().station_ids, ROUTE_A)
	_expect("monotonic_revision", plan.snapshot().plan_revision > prior.plan_revision, true)
	plan.reorder(0, 1)
	_expect("reorder", plan.snapshot().station_ids[0], "S02")
	_expect("reorder_errors_visible", plan.snapshot().validation.valid, false)
	plan.undo()
	plan.lock(true)
	var locked := plan.snapshot()
	_expect("locked_edit", plan.remove("S12").accepted, false)
	_expect("locked_undo", plan.undo(), false)
	_expect("locked_no_changes", plan.snapshot(), locked)
	_expect("locked_submit", plan.validate(ROUTE_A).allowed_actions.submit, false)


func _test_prediction(network: Network) -> void:
	var parameters := Predictor.load_parameters()
	_expect("parameter_load", parameters.is_empty(), false)
	var result := Predictor.predict(network, ROUTE_A, parameters)
	_expect("prediction_ok", result.ok, true)
	_expect("daily_requests", result.totals.requested, 4860)
	_expect("daily_boarded", result.totals.boarded, 4860)
	_expect("daily_unboarded", result.totals.unboarded, 0)
	_expect("completions_in_half_open_period", result.totals.completed, 4852)
	_expect("fare_in_period", result.totals.predicted_fare, 485200)
	_expect("cost_in_period", result.totals.operating_cost, 108000)
	_expect("route_distance", result.distance_km, 5)
	_expect("route_end_to_end_minutes", result.end_to_end_minutes, 9)
	_expect("period", [result.period_start, result.period_end], [360, 1440])
	var full_service_cycle := Predictor.predict(network, ROUTE_A, parameters, 360, 1800)
	_expect("full_service_cycle_completed", full_service_cycle.totals.completed, 4860)
	_expect("full_service_cycle_fare", full_service_cycle.totals.predicted_fare, 486000)
	_expect("full_service_cycle_cost", full_service_cycle.totals.operating_cost, 108000)
	var second_route := Predictor.predict(network, ROUTE_B, parameters, 360, 1800)
	_expect("route_B_completed", second_route.totals.completed, 1460)
	var pairs: Array = result.od_pairs
	_expect("no_duplicate_access_demand", pairs.size(), 4)
	_expect("D08_uses_closest_station", [pairs[3].origin, pairs[3].minutes], ["S08", 7])
	var reversed := ROUTE_A.duplicate()
	reversed.reverse()
	var reverse_result := Predictor.predict(network, reversed, parameters)
	_expect("reverse_symmetric", reverse_result.totals, result.totals)
	for boundary: Array in [[5, 10], [6, 8], [10, 8], [11, 5]]:
		_expect("q_boundary", Predictor.selection_tenths(boundary[0]), boundary[1])
	var first := Predictor.predict(network, ROUTE_A, parameters, 360, 700)
	var second := Predictor.predict(network, ROUTE_A, parameters, 700, 1440, first.carry)
	for key: String in result.totals:
		_expect("split:" + key, first.totals[key] + second.totals[key], result.totals[key])
	_expect("split_remainders_and_arrivals", second.carry, result.carry)
	var next_day := Predictor.predict(network, ROUTE_A, parameters, 1440, 1450, result.carry)
	_expect("residual_completions", next_day.totals.completed, 8)
	_expect("residual_cost0", next_day.totals.operating_cost, 0)
	var low := parameters.duplicate(true)
	for id: String in low.daily_demand:
		low.daily_demand[id] = 0
	low.daily_demand.D01 = 1296
	low.capacity_per_minute = 1
	var boundary := Predictor.predict(network, ROUTE_A, low, 360, 370)
	_expect(
		"capacity_fixture",
		[
			boundary.totals.requested,
			boundary.totals.boarded,
			boundary.totals.unboarded,
			boundary.totals.completed
		],
		[12, 10, 2, 9]
	)
	low.daily_demand.D01 = 0
	_expect("zero_demand", Predictor.predict(network, ROUTE_A, low).totals.requested, 0)
	_expect("invalid_period", Predictor.predict(network, ROUTE_A, parameters, 500, 400).ok, false)
	_expect(
		"stale_carry_time",
		Predictor.predict(network, ROUTE_A, parameters, 701, 1440, first.carry).ok,
		false
	)
	_expect(
		"stale_carry_route",
		Predictor.predict(network, ROUTE_B, parameters, 700, 1440, first.carry).ok,
		false
	)
	_expect(
		"stale_carry_inputs",
		Predictor.predict(network, ROUTE_A, low, 700, 1440, first.carry).ok,
		false
	)
	var bad_carry: Dictionary = first.carry.duplicate(true)
	bad_carry.pending_arrivals = [null]
	_expect(
		"malformed_carry",
		Predictor.predict(network, ROUTE_A, parameters, 700, 1440, bad_carry).ok,
		false
	)
	var no_demand := parameters.duplicate(true)
	no_demand.daily_demand = {}
	_expect("missing_demand", Predictor.predict(network, ROUTE_A, no_demand).ok, false)
	var invalid := parameters.duplicate(true)
	invalid.capacity_per_minute = -1
	_expect("invalid_capacity", Predictor.predict(network, ROUTE_A, invalid).ok, false)
	_expect("deterministic_repeat", Predictor.predict(network, ROUTE_A, parameters), result)


func _test_revisions() -> void:
	var state := Prediction.new()
	_expect("not_calculated", state.snapshot().available, false)
	state.change_input(7, 7, 360)
	state.complete(7, {"requested": 0}, 361)
	_expect("valid_zero", state.snapshot().current.value.requested, 0)
	_expect("zero_available", state.snapshot().available, true)
	state.change_input(8, 8, 362)
	state.begin()
	_expect("calculating", state.snapshot().prediction_status, "CALCULATING")
	_expect("previous_not_current", state.snapshot().available, false)
	_expect("previous_preserved", state.snapshot().previous.value.requested, 0)
	_expect("late_response", state.complete(7, {"requested": 10}, 363), false)
	state.fail(8, "CALCULATION_FAILED")
	_expect("failed", state.snapshot().prediction_status, "FAILED")
	_expect("failed_unavailable", state.snapshot().available, false)
	state.complete(8, {"requested": 20}, 364)
	var before := state.snapshot()
	_expect("same_input_no_invalidation", state.change_input(8, 8, 370), false)
	_expect("query_unchanged", state.snapshot(), before)
	var edited := state.snapshot()
	edited.current.value.requested = 999
	_expect("isolated_snapshot", state.snapshot(), before)


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
