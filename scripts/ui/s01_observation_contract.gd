extends RefCounted
## DEV-026 소비 경계. 값을 계산/보정하지 않고 영역별로 확인한다.

const REVISION := "DEV026-S01-EX-v0.1"
const FUNDS := ["cash", "restricted", "free_cash", "reserved", "available_cash", "unpaid"]
const DAILY := ["operating_cost", "payment", "debt_payment", "cash_payment"]


static func dictionary(value: Variant) -> Dictionary:
	return value if value is Dictionary else {}


static func integers(value: Dictionary, keys: Array, minimum: int = 0) -> bool:
	for key: String in keys:
		if not value.get(key) is int or value[key] < minimum:
			return false
	return true


static func strings(value: Variant) -> bool:
	if not value is Array:
		return false
	for item: Variant in value:
		if not item is String:
			return false
	return true


static func root_valid(state: Variant) -> bool:
	return (
		state is Dictionary
		and text_equal(state.get("ui_contract_revision"), REVISION)
		and text_equal(state.get("data_version"), "1.3")
		and state.get("run_scope") is String
		and not state.run_scope.is_empty()
		and integers(state, ["view_revision"])
	)


static func inspect(state: Variant, scope: String, floor_revision: int) -> Dictionary:
	var value := dictionary(state)
	var discard: bool = (
		(value.get("run_scope") is String and value.run_scope != scope)
		or (integers(value, ["view_revision"]) and value.view_revision < floor_revision)
	)
	var valid: bool = root_valid(state) and value.run_scope == scope and not scope.is_empty()
	var regions := {}
	var names := [
		"clock",
		"plan",
		"map",
		"funds",
		"daily",
		"prediction",
		"previous",
		"report",
		"command",
		"tender_ui",
		"construction_ui",
		"operations_ui",
		"finance_ui",
		"next_business_ui"
	]
	for name: String in names:
		regions[name] = false
	if valid:
		var clock := dictionary(value.get("clock"))
		var plan := dictionary(value.get("plan"))
		var current := dictionary(value.get("current"))
		var prediction := dictionary(value.get("prediction"))
		regions.clock = clock_valid(clock)
		regions.plan = _plan_valid(plan)
		regions.map = _map_valid(value)
		regions.funds = _current_valid(current, clock) and enabled(value.get("coherent"))
		regions.funds = regions.funds and integers(dictionary(current.get("funds")), FUNDS)
		regions.daily = _daily_valid(value, current, clock)
		regions.prediction = _prediction_valid(prediction, plan)
		regions.previous = _prediction_result(dictionary(prediction.get("previous")))
		regions.report = (
			regions.clock
			and report_valid(dictionary(value.get("report")), scope, clock.get("day_id", 0) - 1)
		)
		regions.command = _command_valid(value.get("command_result"))
		for key: String in ["tender_ui", "construction_ui"]:
			regions[key] = value.get(key) is Dictionary and not value[key].is_empty()
		for key: String in ["operations_ui", "finance_ui", "next_business_ui"]:
			regions[key] = not envelope(value, key).is_empty()
	return {
		"discard_observation": discard,
		"global_current_valid": valid,
		"regions": regions,
		"diagnostic": "STALE_OR_FOREIGN" if discard else ("READY" if valid else "ROOT_UNCONFIRMED")
	}


static func clock_valid(value: Dictionary) -> bool:
	return (
		integers(value, ["simulation_minute", "day_id", "remainder"])
		and value.day_id == value.simulation_minute / 1440 + 1
		and value.get("paused") is bool
		and value.get("speed") is int
		and value.speed in [1, 2, 4]
	)


static func _plan_valid(plan: Dictionary) -> bool:
	var validation := dictionary(plan.get("validation"))
	return (
		strings(plan.get("station_ids"))
		and integers(plan, ["plan_revision"])
		and plan.get("locked") is bool
		and validation.get("valid") is bool
		and strings(validation.get("reason_codes"))
	)


static func _map_valid(state: Dictionary) -> bool:
	var stations: Variant = state.get("stations")
	var parents: Variant = state.get("administration")
	var edges: Variant = state.get("edges")
	if not stations is Array or not parents is Dictionary or not edges is Array:
		return false
	var ids := {}
	for row: Variant in stations:
		if not row is Dictionary or not row.get("id") is String:
			return false
		if row.id.is_empty() or ids.has(row.id) or not row.get("neighborhood_id") is String:
			return false
		for axis: String in ["x_km", "y_km"]:
			if not (row.get(axis) is int or row.get(axis) is float):
				return false
			if not is_finite(float(row[axis])):
				return false
		ids[row.id] = true
		if not parents.has(row.neighborhood_id):
			return false
	for key: Variant in parents:
		if not key is String or key.is_empty():
			return false
		var cursor: String = key
		var visited := {}
		while not cursor.is_empty():
			if visited.has(cursor) or not parents.get(cursor) is Dictionary:
				return false
			visited[cursor] = true
			var parent: Variant = parents[cursor].get("parent_id")
			if not parent is String:
				return false
			cursor = parent
	for edge: Variant in edges:
		if not edge is Array or edge.size() != 2:
			return false
		if not edge[0] is String or not edge[1] is String:
			return false
		if not ids.has(edge[0]) or not ids.has(edge[1]):
			return false
	var stops: Variant = dictionary(state.get("plan")).get("station_ids", [])
	if strings(stops):
		for id: String in stops:
			if not ids.has(id):
				return false
	return true


static func _current_valid(value: Dictionary, clock: Dictionary) -> bool:
	return (
		clock_valid(clock)
		and integers(value, ["day_id", "simulation_minute", "snapshot_revision"])
		and text_equal(value.get("data_version"), "1.3")
		and text_equal(value.get("observation_phase"), "T_COMPLETE")
		and value.day_id == clock.day_id
		and value.simulation_minute == clock.simulation_minute
	)


static func _daily_valid(state: Dictionary, current: Dictionary, clock: Dictionary) -> bool:
	var daily := dictionary(state.get("daily_activity"))
	if not _current_valid(current, clock) or not enabled(state.get("coherent")):
		return false
	if not integers(daily, DAILY + ["day_id", "simulation_minute", "snapshot_revision"]):
		return false
	for key: String in ["day_id", "simulation_minute", "snapshot_revision"]:
		if daily[key] != current[key]:
			return false
	return true


static func _prediction_valid(prediction: Dictionary, plan: Dictionary) -> bool:
	if not integers(prediction, ["plan_revision", "prediction_input_revision", "input_minute"]):
		return false
	var status: Variant = prediction.get("prediction_status")
	if not status is String or status not in ["NOT_CALCULATED", "CALCULATING", "READY", "FAILED"]:
		return false
	if not prediction.get("available") is bool or not prediction.get("reason") is String:
		return false
	if prediction.available != (status == "READY"):
		return false
	if status != "READY":
		return true
	var current := dictionary(prediction.get("current"))
	return (
		_plan_valid(plan)
		and prediction.plan_revision == plan.plan_revision
		and _prediction_result(current)
		and current.input_revision == prediction.prediction_input_revision
	)


static func _prediction_result(result: Dictionary) -> bool:
	var value := dictionary(result.get("value"))
	return (
		integers(result, ["input_revision", "generated_minute"])
		and integers(value, ["period_start", "period_end", "distance_km", "end_to_end_minutes"])
		and value.period_end > value.period_start
		and integers(
			dictionary(value.get("totals")),
			["requested", "boarded", "completed", "predicted_fare", "operating_cost"]
		)
	)


static func report_valid(report: Dictionary, scope: String, day: int) -> bool:
	if day < 0 or not integers(report, ["day_id"]) or report.day_id != day:
		return false
	var status: Variant = report.get("status")
	if not status is String or status not in ["UNAVAILABLE", "FAILED", "READY"]:
		return false
	if not report.get("available") is bool or report.available != (status == "READY"):
		return false
	if not report.get("display_key") is String or not report.get("value") is Dictionary:
		return false
	if status != "READY":
		return report.value.is_empty()
	var value: Dictionary = report.value
	return (
		day > 0
		and report.display_key == "%s/day-%d" % [scope, day]
		and integers(value, ["day_id", "operating_cost", "payment", "fare"])
		and value.day_id == day
		and integers(dictionary(value.get("closing_funds")), ["cash"])
	)


static func _command_valid(result: Variant) -> bool:
	if not result is Dictionary:
		return false
	if result.is_empty():
		return true
	return (
		result.get("command_id") is String
		and result.get("action") is String
		and result.get("reason", "") is String
		and result.get("accepted") is bool
		and integers(result, ["effective_at", "result_revision", "plan_revision"])
	)


## 자식 봉투는 자신의 관측과 유효 시계로 검사한다. current 자금의 누락에 종속시키지 않는다.
static func envelope(state: Dictionary, key: String) -> Dictionary:
	if not root_valid(state):
		return {}
	var value := dictionary(state.get(key))
	var observation := dictionary(value.get("observation"))
	var clock := dictionary(state.get("clock"))
	if not clock_valid(clock) or not _current_valid(observation, clock):
		return {}
	if not text_equal(value.get("ui_contract_revision"), "DEV023-UI-1"):
		return {}
	if not value.get("view_revision") is int or value.view_revision != state.view_revision:
		return {}
	if (
		not value.get("available") is bool
		or not value.get("status") is String
		or value.get("status") not in ["READY", "FAILED", "UNAVAILABLE"]
	):
		return {}
	return value


static func finance_report(state: Dictionary, scope: String, expected_day: int) -> Dictionary:
	var outer := envelope(state, "finance_ui")
	var report := dictionary(outer.get("report"))
	var days := dictionary(outer.get("report_day_range"))
	if not integers(days, ["first", "last"]) or days.first != 1:
		return {}
	if days.last != dictionary(state.get("clock")).get("day_id", 0) - 1:
		return {}
	if expected_day < 0 or expected_day > days.last:
		return {}
	if (
		not outer.get("report_selection") is String
		or outer.report_selection not in ["LATEST_CLOSED", "FIXED_DAY"]
	):
		return {}
	if outer.report_selection == "LATEST_CLOSED" and expected_day != days.last:
		return {}
	if enabled(report.get("available")):
		var value := dictionary(report.get("value"))
		if not integers(
			value,
			[
				"operating_cost",
				"payment",
				"debt_payment",
				"fare",
				"government",
				"construction_cost",
				"construction_payment"
			]
		):
			return {}
		if not integers(dictionary(value.get("closing_funds")), FUNDS):
			return {}
		var operations: Variant = value.get("operations", {})
		if not operations is Dictionary:
			return {}
		if not operations.is_empty() and not operations.get("satisfaction_available") is bool:
			return {}
	return report if report_valid(report, scope, expected_day) else {}


static func action_allowed(state: Dictionary, regions: Dictionary, action: String) -> bool:
	var actions := dictionary(state.get("allowed_actions"))
	var plan := dictionary(state.get("plan"))
	var edit := dictionary(plan.get("allowed_actions"))
	match action:
		"pause", "resume":
			return regions.get("clock", false) and enabled(actions.get(action))
		"speed":
			return regions.get("clock", false) and _speeds_valid(actions.get("speed"))
		"select", "remove", "reorder":
			return (
				regions.get("plan", false)
				and regions.get("map", false)
				and enabled(edit.get("edit"))
			)
		"undo":
			return regions.get("plan", false) and enabled(edit.get("undo"))
		"predict":
			return (
				regions.get("plan", false)
				and regions.get("prediction", false)
				and enabled(actions.get("predict"))
			)
	return false


static func focus_valid(target: Variant) -> bool:
	return (
		is_instance_valid(target)
		and target is Control
		and target.is_visible_in_tree()
		and target.focus_mode != Control.FOCUS_NONE
		and (not target is ItemList or target.item_count > 0)
		and (not target is BaseButton or not target.disabled)
	)


static func text_equal(value: Variant, expected: String) -> bool:
	return value is String and value == expected


static func enabled(value: Variant) -> bool:
	return value is bool and value


static func _speeds_valid(value: Variant) -> bool:
	if not value is Array:
		return false
	for item: Variant in value:
		if not item is int or item not in [1, 2, 4]:
			return false
	return true


static func focus_fallback(panel: Node, candidates: Array) -> Control:
	for target: Variant in candidates:
		if focus_valid(target) and (panel == target or panel.is_ancestor_of(target)):
			return target
	return null
