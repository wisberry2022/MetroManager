class_name DemandPredictor
extends RefCounted
## 실운행을 변경하지 않는 예측기. 잔여/집계를 반환하고 분할에도 정수 산술을 유지한다.

const Network = preload("res://scripts/model/administrative_network.gd")
const Plan = preload("res://scripts/model/route_plan.gd")
const DENOMINATOR: int = 10800


static func load_parameters() -> Dictionary:
	var file := FileAccess.open("res://assets/data/gate2_w03_demand_v1_3.json", FileAccess.READ)
	if file == null:
		return {}
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK or not json.data is Dictionary:
		return {}
	var value: Dictionary = json.data
	if not value.get("data_version") is String or value.data_version != "1.3":
		return {}
	if not value.get("source") is Dictionary or not value.get("daily_demand") is Dictionary:
		return {}
	if not value.source.get("path") is String or not value.source.get("commit") is String:
		return {}
	if value.source.path != "docs/planning/PLN-001_GATE2_DATA_v1_DRAFT.md":
		return {}
	if value.source.commit != "604751d79bba86cad179ca6434a5ec5b42640d71":
		return {}
	for key: String in ["capacity_per_minute", "fare", "operating_cost_per_minute"]:
		if not _integer_number(value.get(key)):
			return {}
		value[key] = int(value[key])
	for index: int in range(1, 9):
		var id := "D%02d" % index
		if not _integer_number(value.daily_demand.get(id)):
			return {}
		value.daily_demand[id] = int(value.daily_demand[id])
	return value if _valid_parameters(value) else {}


static func _integer_number(value: Variant) -> bool:
	return value is int or (value is float and is_finite(value) and value == floor(value))


static func selection_tenths(minutes: int) -> int:
	return 10 if minutes <= 5 else (8 if minutes <= 10 else 5)


static func od_pairs(
	network: Network, stops: Array[String], demand: Dictionary
) -> Array[Dictionary]:
	var pairs: Array[Dictionary] = []
	for index: int in range(1, 9):
		var origin := "D%02d" % index
		var destination := "D%02d" % (index % 8 + 1)
		var best: Dictionary = {}
		for a: int in stops.size():
			for b: int in stops.size():
				if network.station(stops[a]).get("neighborhood_id") != origin:
					continue
				if network.station(stops[b]).get("neighborhood_id") != destination:
					continue
				var minutes := 2 * absi(a - b) - 1
				var tie := stops[a] + ":" + stops[b]
				if (
					best.is_empty()
					or minutes < best.minutes
					or (minutes == best.minutes and tie < best.tie)
				):
					best = {
						"id": origin + ":" + destination,
						"origin": stops[a],
						"destination": stops[b],
						"minutes": minutes,
						"tie": tie,
						"daily_demand": int(demand[origin])
					}
		if not best.is_empty():
			pairs.append(best)
	return pairs


static func predict(
	network: Network,
	stops: Array[String],
	parameters: Dictionary,
	start: int = 360,
	end: int = 1440,
	carry: Dictionary = {}
) -> Dictionary:
	var plan := Plan.new(network)
	var validation := plan.validate(stops)
	if not validation.valid:
		return {"ok": false, "reason": "INVALID_PLAN", "details": validation.reason_codes}
	if not _valid_parameters(parameters) or start < 0 or end < start:
		return {"ok": false, "reason": "INVALID_INPUT"}
	var pairs := od_pairs(network, stops, parameters.daily_demand)
	var state: Dictionary = {"remainders": {}, "pending_arrivals": [], "as_of": start}
	if not carry.is_empty():
		if not _valid_carry(carry, stops, parameters, start):
			return {"ok": false, "reason": "CARRY_MISMATCH"}
		state = carry.duplicate(true)
	state.route = stops.duplicate()
	state.parameters = parameters.duplicate(true)
	var totals := {
		"requested": 0,
		"boarded": 0,
		"unboarded": 0,
		"completed": 0,
		"predicted_fare": 0,
		"operating_cost": 0
	}
	for minute: int in range(start, end):
		var capacity: int = parameters.capacity_per_minute
		if minute % 1440 >= 360:
			totals.operating_cost += int(parameters.operating_cost_per_minute)
			for pair: Dictionary in pairs:
				var numerator: int = state.remainders.get(pair.id, 0)
				numerator += pair.daily_demand * selection_tenths(pair.minutes)
				var requested: int = numerator / DENOMINATOR
				state.remainders[pair.id] = numerator % DENOMINATOR
				var boarded := mini(requested, capacity)
				capacity -= boarded
				totals.requested += requested
				totals.boarded += boarded
				totals.unboarded += requested - boarded
				if boarded > 0:
					state.pending_arrivals.append(
						{"minute": minute + pair.minutes, "count": boarded}
					)
		var pending: Array = []
		for arrival: Dictionary in state.pending_arrivals:
			if arrival.minute == minute:
				totals.completed += arrival.count
			else:
				pending.append(arrival)
		state.pending_arrivals = pending
	totals.predicted_fare = totals.completed * int(parameters.fare)
	state.as_of = end
	return {
		"ok": true,
		"data_version": parameters.get("data_version", "1.3"),
		"period_start": start,
		"period_end": end,
		"totals": totals,
		"carry": state,
		"od_pairs": pairs,
		"distance_km": stops.size() - 1,
		"end_to_end_minutes": 2 * (stops.size() - 1) - 1
	}


static func _valid_parameters(parameters: Dictionary) -> bool:
	for key: String in ["capacity_per_minute", "fare", "operating_cost_per_minute"]:
		if not parameters.get(key) is int or parameters[key] < 0:
			return false
	if not parameters.get("daily_demand") is Dictionary:
		return false
	for index: int in range(1, 9):
		var amount: Variant = parameters.daily_demand.get("D%02d" % index)
		if not amount is int or amount < 0:
			return false
	return true


static func _valid_carry(
	carry: Dictionary, stops: Array[String], parameters: Dictionary, start: int
) -> bool:
	if not carry.get("as_of") is int or carry.as_of != start:
		return false
	if not carry.get("route") is Array or carry.route != stops:
		return false
	if not carry.get("parameters") is Dictionary or carry.parameters != parameters:
		return false
	if not carry.get("remainders") is Dictionary or not carry.get("pending_arrivals") is Array:
		return false
	for amount: Variant in carry.remainders.values():
		if not amount is int or amount < 0 or amount >= DENOMINATOR:
			return false
	for arrival: Variant in carry.pending_arrivals:
		if not arrival is Dictionary or not arrival.get("minute") is int:
			return false
		if arrival.minute < start or not arrival.get("count") is int or arrival.count < 0:
			return false
	return true
