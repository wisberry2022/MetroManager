extends RefCounted
## Stage 1 공급 중개. 경제/관할/예측 판정은 기존 모델만 수행한다.

const Pipeline = preload("res://scripts/simulation/minute_pipeline.gd")
const Network = preload("res://scripts/model/administrative_network.gd")
const Plan = preload("res://scripts/model/route_plan.gd")
const Prediction = preload("res://scripts/model/prediction_state.gd")
const Tender = preload("res://scripts/model/public_tender.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")
const OPERATIONS_UI_REVISION := "DEV023-UI-1"
const OBSERVATION_REVISION := "DEV026-S01-EX-v0.1"

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
var _tender_enabled: bool = false
var _tender_error: String = ""
var _bid_requests: Dictionary = {}
var _construction_enabled: bool = false
var _construction_error: String = ""
var _construction_requests: Dictionary = {}
var _operations_enabled: bool = false
var _operations_error: String = ""
var _finance_day: int = -1


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
		"ui_contract_revision": OBSERVATION_REVISION,
		"run_scope": _report_scope,
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
		"fixture_label": fixture_label,
		"tender_ui": _tender_snapshot(current),
		"construction_ui": _construction_snapshot(current),
		"operations_ui": _operations_snapshot(current),
		"finance_ui": _finance_snapshot(current, daily),
		"next_business_ui": _next_business_snapshot(current)
	}


## 기대 실행 소속은 수신 자료가 아닌 실제 Session에서 고정한다.
func observation_scope() -> String:
	return _report_scope


## 선택 보고일의 권위 문맥. 조회는 시간/원장을 변경하지 않는다.
func finance_report_day() -> int:
	return pipeline.clock.minute / 1440 if _finance_day < 0 else _finance_day


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


## 명시적 제품 UI 진입. 입찰 모델의 경제·시각 규칙은 재구현하지 않는다.
func enable_tender_ui() -> Dictionary:
	if _tender_enabled:
		return {"accepted": true}
	var result := pipeline.enable_tenders()
	_tender_enabled = result.get("accepted", false)
	_tender_error = result.get("reason", "")
	revision += 1
	return result


## 조회/재조회는 게임 시각·명령·원장 효과를 발생시키지 않는다.
func refresh_tenders() -> void:
	if not _tender_enabled:
		enable_tender_ui()
	revision += 1


## 확인한 대상/회차/계획 판을 그대로 명령에 묶는다. 실제 효력은 현재 완료분 이후다.
func request_bid(id: String, tender_id: String, confirmed: Dictionary) -> Dictionary:
	if _bid_requests.has(id):
		var previous: Dictionary = pipeline.bid_result(id)
		return previous if not previous.is_empty() else _bid_requests[id].result.duplicate(true)
	var command := {
		"command_id": id,
		"tender_id": tender_id,
		"round_id": confirmed.get("round_id", ""),
		"target_revision": confirmed.get("target_revision", -1),
		"plan_revision": confirmed.get("plan_revision", -1),
		"expected_snapshot_revision": confirmed.get("snapshot_revision", -1),
		"requested_at": pipeline.clock.minute,
		"effective_at": pipeline.clock.minute + 1
	}
	var result := pipeline.submit_bid(command)
	_bid_requests[id] = {"command": command.duplicate(true), "result": result.duplicate(true)}
	revision += 1
	print("DEV019_BID_REQUEST ", JSON.stringify({"command": command, "result": result}))
	return result.duplicate(true)


func _tender_snapshot(current: Dictionary) -> Dictionary:
	var requests: Array[Dictionary] = []
	for entry: Dictionary in _bid_requests.values():
		var record := entry.duplicate(true)
		var result := pipeline.bid_result(record.command.command_id)
		if not result.is_empty():
			record.result = result
		requests.append(record)
	return {
		"view_revision": revision,
		"status": "READY" if _tender_enabled else "FAILED",
		"reason": _tender_error,
		"snapshot": current.get("tenders", {}).duplicate(true),
		"funds": current.funds.duplicate(true),
		"evaluation_criteria": _evaluation_criteria(current.get("tenders", {})),
		"construction_projects":
		current.get("construction", {}).get("projects", []).duplicate(true),
		"requests": requests,
		"next_effective_at": current.simulation_minute + 1,
		"fixture_label": fixture_label
	}


## 명시적 소비 연결. 제품 화면 호출은 Design L2 수용 후 별도로 연결한다.
func enable_operations_ui() -> Dictionary:
	if _operations_enabled:
		return {"accepted": true}
	var result := enable_construction_ui()
	if result.get("accepted", false):
		result = pipeline.enable_operations(network, _parameters)
	_operations_enabled = result.get("accepted", false)
	_operations_error = result.get("reason", "")
	revision += 1
	return result.duplicate(true)


## 과거 보고 선택만 변경한다. 시각·원장·보고 생성을 실행하지 않는다.
func select_finance_report(day: Variant) -> Dictionary:
	var current_day: int = pipeline.clock.minute / 1440 + 1
	if not day is int or day < 1 or day >= current_day:
		return {"accepted": false, "reason": "INVALID_REPORT_DAY"}
	if _finance_day != day:
		_finance_day = day
		revision += 1
	return {"accepted": true, "reason": "", "day_id": day}


## 확인한 실제 보고를 기준으로 기존 공고를 읽는다. 사업 명령을 발행하지 않는다.
func query_next_business(confirmed: Dictionary) -> Dictionary:
	var current := pipeline.snapshot()
	var packet := _next_business_snapshot(current)
	var reason := ""
	if not packet.available:
		reason = packet.reason_codes[0]
	elif (
		confirmed.get("report_key") != packet.report_key
		or confirmed.get("first_valid_report") != packet.first_valid_report
	):
		reason = "STATE_CHANGED"
	return {
		"accepted": reason.is_empty(),
		"reason": reason,
		"observed_at": current.simulation_minute,
		"report_key": packet.get("report_key", ""),
		"first_valid_report": packet.get("first_valid_report", {}).duplicate(true),
		"tenders": packet.get("tenders", {}).duplicate(true) if reason.is_empty() else {}
	}


func _operations_snapshot(current: Dictionary) -> Dictionary:
	var packet := _ui_packet(current)
	packet["snapshot"] = {}
	if not _operations_enabled:
		return _inactive_operations(packet)
	var value: Variant = current.get("operations")
	if not _valid_operations(value, current):
		return _ui_failure(packet, "INVALID_OPERATIONS_SUPPLY")
	packet.snapshot = value.duplicate(true)
	packet.available = value.available
	packet.status = "READY" if value.available else "FAILED"
	packet.reason_codes = value.reason_codes.duplicate()
	if not packet.available and packet.reason_codes.is_empty():
		return _ui_failure(packet, "INVALID_OPERATIONS_SUPPLY")
	return packet


func _finance_snapshot(current: Dictionary, daily: Dictionary) -> Dictionary:
	var packet := _ui_packet(current)
	var day: int = current.day_id - 1 if _finance_day < 0 else _finance_day
	packet.merge(
		{
			"current_funds": {},
			"current_activity": {},
			"report_day_range": {"first": 1, "last": current.day_id - 1},
			"report_selection": "LATEST_CLOSED" if _finance_day < 0 else "FIXED_DAY",
			"report": _finance_report(day)
		}
	)
	var valid_observation := _same_observation(current, current)
	var valid_funds := valid_observation and _valid_funds(current.get("funds"))
	var valid_activity: bool = (
		valid_observation
		and _valid_report_totals(daily, current.day_id)
		and daily.payment <= 9223372036854775807 - daily.debt_payment
	)
	if valid_funds:
		packet.current_funds = current.funds.duplicate(true)
	if valid_activity:
		packet.current_activity = daily.duplicate(true)
		packet.current_activity["cash_payment"] = daily.payment + daily.debt_payment
	if not valid_funds or not valid_activity:
		return _ui_failure(packet, "INVALID_FINANCE_SUPPLY")
	return packet


func _finance_report(day: int) -> Dictionary:
	var value := pipeline.reports.report(day) if day > 0 else {}
	var packet := {
		"status": "UNAVAILABLE",
		"available": false,
		"reason_codes": [],
		"day_id": day,
		"display_key": "",
		"value": {}
	}
	if not report_error.is_empty():
		return _ui_failure(packet, report_error)
	if value.is_empty():
		packet.reason_codes = ["REPORT_UNAVAILABLE"]
		return packet
	if not _valid_report_totals(value, day) or not _valid_funds(value.get("closing_funds")):
		return _ui_failure(packet, "INVALID_REPORT_SUPPLY")
	packet.status = "READY"
	packet.available = true
	packet.display_key = "%s/day-%d" % [_report_scope, day]
	packet.value = value.duplicate(true)
	return packet


func _next_business_snapshot(current: Dictionary) -> Dictionary:
	var packet := _ui_packet(current)
	packet.merge(
		{
			"report_key": "",
			"first_valid_report": {},
			"tenders": {},
			"allowed_actions": {"query": false}
		}
	)
	if not _operations_enabled:
		return _inactive_operations(packet)
	var value := pipeline.next_business_query()
	if (
		not value.get("available") is bool
		or not _string_codes(value.get("reason_codes"))
		or not value.get("allowed_actions") is Dictionary
		or not value.allowed_actions.get("query") is bool
		or not value.get("first_valid_report") is Dictionary
		or not value.get("tenders") is Dictionary
		or not _same_observation(current, current)
	):
		return _ui_failure(packet, "INVALID_NEXT_BUSINESS_SUPPLY")
	if not value.allowed_actions.query:
		if value.available or not value.first_valid_report.is_empty():
			return _ui_failure(packet, "INVALID_NEXT_BUSINESS_SUPPLY")
		packet.status = "UNAVAILABLE"
		packet.available = false
		packet.reason_codes = ["FIRST_VALID_OPERATIONS_REPORT_REQUIRED"]
		return packet
	return _ready_business_query(packet, value, current)


func _ready_business_query(
	packet: Dictionary, value: Dictionary, current: Dictionary
) -> Dictionary:
	if not _valid_first_report(value.first_valid_report, current.day_id):
		return _ui_failure(packet, "INVALID_NEXT_BUSINESS_SUPPLY")
	packet.allowed_actions = value.allowed_actions.duplicate(true)
	packet.first_valid_report = value.first_valid_report.duplicate(true)
	packet.report_key = "%s/day-%d" % [_report_scope, value.first_valid_report.day_id]
	if not value.available:
		var reason: String = (
			"TENDER_SUPPLY_UNAVAILABLE" if value.reason_codes.is_empty() else value.reason_codes[0]
		)
		return _ui_failure(packet, reason)
	if (
		not _same_observation(value.tenders, current)
		or value.tenders.get("available") != true
		or not value.tenders.get("tenders") is Array
	):
		return _ui_failure(packet, "INVALID_NEXT_BUSINESS_SUPPLY")
	packet.tenders = value.tenders.duplicate(true)
	return packet


func _ui_packet(current: Dictionary) -> Dictionary:
	return {
		"ui_contract_revision": OPERATIONS_UI_REVISION,
		"view_revision": revision,
		"status": "READY",
		"available": true,
		"reason_codes": [],
		"fixture_label": fixture_label,
		"observation":
		{
			"data_version": current.get("data_version"),
			"simulation_minute": current.get("simulation_minute"),
			"day_id": current.get("day_id"),
			"snapshot_revision": current.get("snapshot_revision"),
			"observation_phase": current.get("observation_phase")
		}
	}


func _inactive_operations(packet: Dictionary) -> Dictionary:
	packet.available = false
	packet.status = "UNAVAILABLE" if _operations_error.is_empty() else "FAILED"
	packet.reason_codes = [
		"OPERATIONS_NOT_ENABLED" if _operations_error.is_empty() else _operations_error
	]
	return packet


func _ui_failure(packet: Dictionary, reason: String) -> Dictionary:
	packet.status = "FAILED"
	packet.available = false
	packet.reason_codes = [reason]
	return packet


func _same_observation(value: Dictionary, current: Dictionary) -> bool:
	if value.get("data_version") != "1.3" or current.get("data_version") != "1.3":
		return false
	for key: String in ["simulation_minute", "day_id", "snapshot_revision"]:
		if not value.get(key) is int or value[key] < 0 or value[key] != current.get(key):
			return false
	return (
		value.day_id == value.simulation_minute / 1440 + 1
		and current.get("observation_phase") == "T_COMPLETE"
		and value.get("observation_phase") == "T_COMPLETE"
	)


func _valid_operations(value: Variant, current: Dictionary) -> bool:
	if not value is Dictionary:
		return false
	if (
		not _same_observation(value, current)
		or value.get("ui_contract_revision") != "DEV022-W06-UI-1"
		or not value.get("available") is bool
		or not value.get("service_ready") is bool
		or not _string_codes(value.get("reason_codes"))
		or not value.get("in_transit") is int
		or value.in_transit < 0
	):
		return false
	for key: String in ["source", "carry", "boarding", "daily", "first_valid_report"]:
		if not value.get(key) is Dictionary:
			return false
	for key: String in ["od_pairs", "cohorts", "satisfaction"]:
		if not value.get(key) is Array:
			return false
	return (
		_valid_operation_summary(value.daily, current.day_id)
		and _valid_fraction(value.satisfaction)
		and _valid_cohorts(value.cohorts)
		and value.boarding.get("boarding_allowed") is bool
		and _string_codes(value.boarding.get("reason_codes"))
	)


func _valid_operation_summary(value: Variant, day: int) -> bool:
	if not value is Dictionary or value.get("day_id") != day:
		return false
	for key: String in [
		"requested",
		"boarded",
		"unboarded",
		"completed",
		"late_completed",
		"service_minutes",
		"opening_in_transit",
		"closing_in_transit"
	]:
		if not value.get(key) is int or value[key] < 0:
			return false
	return (
		value.get("satisfaction_available") is bool
		and _valid_fraction(value.get("satisfaction_before"))
		and _valid_fraction(value.get("satisfaction_after"))
		and _string_codes(value.get("reason_codes"))
	)


func _valid_fraction(value: Variant) -> bool:
	if not value is Array:
		return false
	return (
		value.is_empty()
		or (
			value.size() == 2
			and value[0] is int
			and value[1] is int
			and value[0] >= 0
			and value[1] > 0
		)
	)


func _valid_cohorts(rows: Array) -> bool:
	for row: Variant in rows:
		if not row is Dictionary or not row.get("od_id") is String or row.od_id.is_empty():
			return false
		for key: String in ["boarded_at", "expected_at", "count"]:
			if not row.get(key) is int or row[key] < 0:
				return false
		if row.count == 0 or row.expected_at <= row.boarded_at:
			return false
	return true


func _valid_report_totals(value: Dictionary, day: int) -> bool:
	if value.get("day_id") != day:
		return false
	for key: String in [
		"operating_cost",
		"payment",
		"debt_payment",
		"fare",
		"government",
		"construction_cost",
		"construction_payment"
	]:
		if not value.get(key) is int or value[key] < 0:
			return false
	return not value.has("operations") or _valid_operation_summary(value.operations, day)


func _valid_funds(value: Variant) -> bool:
	if not value is Dictionary:
		return false
	for key: String in ["cash", "restricted", "free_cash", "reserved", "available_cash", "unpaid"]:
		if not value.get(key) is int or value[key] < 0:
			return false
	for key: String in ["restricted_by_project", "reserved_by_project"]:
		if not value.get(key) is Dictionary:
			return false
		for id: Variant in value[key]:
			if not id is String or not value[key][id] is int or value[key][id] < 0:
				return false
	return true


func _valid_first_report(value: Dictionary, current_day: int) -> bool:
	for key: String in ["day_id", "service_minutes", "completed", "fare"]:
		if not value.get(key) is int or value[key] < 1:
			return false
	if value.day_id >= current_day:
		return false
	var report := pipeline.reports.report(value.day_id)
	var operations: Variant = report.get("operations")
	return (
		operations is Dictionary
		and report.get("day_id") == value.day_id
		and report.get("fare") == value.fare
		and operations.get("day_id") == value.day_id
		and operations.get("service_minutes") == value.service_minutes
		and operations.get("completed") == value.completed
		and value.fare % 100 == 0
		and value.fare / 100 == value.completed
	)


func _string_codes(value: Variant) -> bool:
	if not value is Array:
		return false
	for code: Variant in value:
		if not code is String or code.is_empty():
			return false
	return true


## 고정 경쟁자 재무점수의 단위를 기존 점수 API 입력에 맞춘다. 회사 현금/원장은 사용하지 않는다.
func _evaluation_criteria(envelope: Dictionary) -> Dictionary:
	var criteria: Dictionary = {}
	for row: Dictionary in envelope.get("tenders", []):
		var terms: Dictionary = row.terms
		var capability: Variant = terms.get("competitor_capability")
		var financial: Variant = terms.get("competitor_financial_score")
		if not capability is int or not financial is int:
			continue
		if capability < 0 or capability > 100 or financial < 0 or financial > 100:
			continue
		var score := Tender.score(financial * 10000, capability)
		criteria[terms.tender_id] = {
			"competitor_display_score": score.display_score,
			"competitor_capability": capability,
			"competitor_financial_score": financial,
			"tie_priority": terms.tie_priority.duplicate()
		}
	return criteria


## 기존 Pipeline에 공사 공급을 한 번만 연결한다. 조회 자체는 활성화하지 않는다.
func enable_construction_ui() -> Dictionary:
	if _construction_enabled:
		return {"accepted": true}
	if not _tender_enabled:
		enable_tender_ui()
	var result := pipeline.enable_construction()
	_construction_enabled = result.get("accepted", false)
	_construction_error = result.get("reason", "")
	revision += 1
	return result


func refresh_construction() -> void:
	revision += 1


## 확인된 대상 판을 전달하며 이미 완료된 게임분에 소급하지 않는다.
func request_construction(id: String, action: String, confirmed: Dictionary) -> Dictionary:
	if _construction_requests.has(id):
		var previous := pipeline.construction_result(id)
		return (
			previous
			if not previous.is_empty()
			else _construction_requests[id].result.duplicate(true)
		)
	var command := {
		"command_id": id,
		"project_id": confirmed.get("project_id", ""),
		"business_contract_id": confirmed.get("business_contract_id", ""),
		"action": action,
		"requested_at": pipeline.clock.minute,
		"effective_at": pipeline.clock.minute + 1,
		"expected_snapshot_revision": confirmed.get("snapshot_revision", -1),
		"target_revision": confirmed.get("target_revision", -1)
	}
	if action == "contract":
		command.mode = confirmed.get("mode", "")
	var result := pipeline.submit_construction(command)
	_construction_requests[id] = {
		"command": command.duplicate(true), "result": result.duplicate(true)
	}
	revision += 1
	print("DEV021_COMMAND ", JSON.stringify({"command": command, "result": result}))
	return result.duplicate(true)


func _construction_snapshot(current: Dictionary) -> Dictionary:
	var requests: Array[Dictionary] = []
	for entry: Dictionary in _construction_requests.values():
		var record := entry.duplicate(true)
		var result := pipeline.construction_result(record.command.command_id)
		if not result.is_empty():
			record.result = result
		requests.append(record)
	return {
		"view_revision": revision,
		"status": "READY" if _construction_enabled else "UNAVAILABLE",
		"reason": _construction_error,
		"snapshot": current.get("construction", {}).duplicate(true),
		"requests": requests,
		"next_effective_at": current.simulation_minute + 1,
		"fixture_label": fixture_label
	}
