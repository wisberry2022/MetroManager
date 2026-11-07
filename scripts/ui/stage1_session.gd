extends RefCounted
## Stage 1 공급 중개. 경제/관할/예측 판정은 기존 모델만 수행한다.

const Pipeline = preload("res://scripts/simulation/minute_pipeline.gd")
const Network = preload("res://scripts/model/administrative_network.gd")
const Plan = preload("res://scripts/model/route_plan.gd")
const Prediction = preload("res://scripts/model/prediction_state.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")

var pipeline: Pipeline
var network: Network
var plan: Plan
var prediction: Prediction = Prediction.new()
var revision: int = 1
var report_error: String = ""
var fixture_label: String = ""
var _data: Dictionary
var _parameters: Dictionary
var _input_revision: int = 1
var _last_command: String = ""
var _results: Dictionary = {}
var _report_scope: String


func _init(data: Dictionary, initial: Dictionary, parameters: Dictionary = {}) -> void:
	_data = data.duplicate(true)
	_parameters = (
		Predictor.load_parameters() if parameters.is_empty() else parameters.duplicate(true)
	)
	pipeline = Pipeline.new(initial, int(initial.get("simulation_minute", 360)))
	network = Network.new(data)
	plan = Plan.new(network, initial.get("city_id", "C01"))
	_report_scope = "run-%s" % get_instance_id()
	prediction.change_input(0, _input_revision, pipeline.clock.minute)


func advance_usec(elapsed: int) -> void:
	var previous := pipeline.clock.minute
	pipeline.advance_usec(elapsed)
	if previous != pipeline.clock.minute:
		revision += 1


func snapshot() -> Dictionary:
	var clock := pipeline.clock.snapshot()
	var current := pipeline.snapshot()
	var daily := pipeline.reports.current(current.day_id)
	var day: int = current.day_id - 1
	var report := pipeline.reports.report(day) if day > 0 else {}
	var report_state := (
		"FAILED"
		if not report_error.is_empty()
		else ("READY" if not report.is_empty() else "UNAVAILABLE")
	)
	return {
		"view_revision": revision,
		"data_version": current.data_version,
		"clock": clock,
		"current": current,
		"daily_activity":
		{
			"day_id": daily.day_id,
			"simulation_minute": current.simulation_minute,
			"snapshot_revision": current.snapshot_revision,
			"operating_cost": daily.operating_cost,
			"payment": daily.payment,
			"debt_payment": daily.debt_payment,
			"cash_payment": daily.payment + daily.debt_payment
		},
		"coherent": clock.simulation_minute == current.simulation_minute,
		"report":
		{
			"status": report_state,
			"reason": report_error,
			"available": report_state == "READY",
			"day_id": day,
			"display_key": "%s/day-%d" % [_report_scope, day] if not report.is_empty() else "",
			"value": report if report_state == "READY" else {}
		},
		"plan": plan.snapshot(),
		"prediction": prediction.snapshot(),
		"stations": _data.stations.duplicate(true),
		"administration": network.parents(),
		"edges": _data.edges.duplicate(true),
		"allowed_actions":
		{
			"pause": not clock.paused,
			"resume": clock.paused,
			"speed": [1, 2, 4],
			"predict": plan.snapshot().validation.valid
		},
		"command_result": _results.get(_last_command, {}).duplicate(true),
		"fixture_label": fixture_label
	}


func dispatch(command: Dictionary) -> Dictionary:
	var id: Variant = command.get("command_id")
	if not id is String or id.is_empty():
		return {"accepted": false, "reason": "INVALID_COMMAND"}
	if _results.has(id):
		return _results[id].duplicate(true)
	var previous: int = plan.snapshot().plan_revision
	var action: String = command.get("action", "")
	var result: Dictionary
	if command.has("expected_plan_revision") and command.expected_plan_revision != previous:
		result = {"accepted": false, "reason": "STATE_CHANGED"}
	else:
		result = _apply(action, command)
	var next: int = plan.snapshot().plan_revision
	if next != previous:
		_input_revision += 1
		prediction.change_input(next, _input_revision, pipeline.clock.minute)
	revision += 1
	result.merge(
		{
			"command_id": id,
			"action": action,
			"effective_at": pipeline.clock.minute,
			"result_revision": revision,
			"plan_revision": next
		}
	)
	_results[id] = result.duplicate(true)
	_last_command = id
	return result.duplicate(true)


func _apply(action: String, command: Dictionary) -> Dictionary:
	var result := {"accepted": true, "reason": ""}
	match action:
		"pause", "resume":
			pipeline.clock.paused = action == "pause"
		"speed":
			var speed: Variant = command.get("value")
			if not speed is int or not pipeline.clock.set_speed(speed):
				result = {"accepted": false, "reason": "INVALID_SPEED"}
		"select", "remove":
			var id: Variant = command.get("station_id")
			if not id is String:
				result = {"accepted": false, "reason": "INVALID_STATION"}
			else:
				result = plan.select(id) if action == "select" else plan.remove(id)
		"reorder":
			var from: Variant = command.get("from")
			var to: Variant = command.get("to")
			if not from is int or not to is int:
				result = {"accepted": false, "reason": "INVALID_INDEX"}
			else:
				result = plan.reorder(from, to)
		"undo":
			result = _undo()
		"predict":
			result = _predict()
		_:
			result = {"accepted": false, "reason": "UNKNOWN_ACTION"}
	return result


func _undo() -> Dictionary:
	var before := plan.snapshot()
	var reason := ""
	if before.locked:
		reason = "PLAN_LOCKED"
	elif not before.allowed_actions.undo:
		reason = "NO_UNDO_HISTORY"
	elif not plan.undo():
		reason = "UNDO_FAILED"
	return {"accepted": reason.is_empty(), "reason": reason}


func _predict() -> Dictionary:
	var stops: Array[String] = plan.snapshot().station_ids
	# 선택일의 온전한 서비스+잔여 도착 기간. 실적/현재 운임이 아닌 고정 기간 예측이다.
	var day: int = pipeline.clock.minute / 1440
	var start: int = day * 1440 + 360
	var end: int = start + 1440
	# 기간이 달라지면 같은 계획이라도 입력 revision을 갱신한다.
	var before := prediction.snapshot()
	if before.available and before.current.value.period_start == start:
		return {"accepted": true, "reason": ""}
	if before.available and before.current.value.period_start != start:
		_input_revision += 1
		prediction.change_input(
			plan.snapshot().plan_revision, _input_revision, pipeline.clock.minute
		)
	prediction.begin()
	var value := Predictor.predict(network, stops, _parameters, start, end)
	if value.ok:
		prediction.complete(_input_revision, value, pipeline.clock.minute)
	else:
		prediction.fail(_input_revision, value.reason)
	return {"accepted": value.ok, "reason": value.get("reason", "")}
