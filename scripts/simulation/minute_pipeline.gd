class_name MinutePipeline
extends RefCounted
## 고정 분의 W02/W04A/W05/W06 처리. 실제 운행은 명시적으로 활성화한다.

const Clock = preload("res://scripts/simulation/game_clock.gd")
const Queue = preload("res://scripts/simulation/command_queue.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const Tenders = preload("res://scripts/simulation/tender_service.gd")
const TenderLoader = preload("res://scripts/data/tender_data_loader.gd")
const CompanyLoader = preload("res://scripts/data/gate2_data_loader.gd")
const Reports = preload("res://scripts/model/daily_ledger_report.gd")
const Construction = preload("res://scripts/simulation/construction_service.gd")
const Operations = preload("res://scripts/simulation/operations_service.gd")
const Network = preload("res://scripts/model/administrative_network.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")

var clock: Clock
var commands: Queue = Queue.new()
var ledger: Ledger
var reports: Reports = Reports.new()
var target_revisions: Dictionary = {}
var _tenders: Tenders
var _construction: Construction
var _operations: Operations
var _events: Dictionary = {}
var _revision: int = 0
var _trace: Array[Dictionary] = []
var _boarding: Dictionary = {}


func _init(initial: Dictionary = {}, start_minute: int = 360) -> void:
	clock = Clock.new(start_minute)
	ledger = Ledger.new(initial)


## W04A 제품 공급의 명시적 진입점. 실패한 데이터로 부분 사업 상태를 설치하지 않는다.
func enable_tenders(data: Dictionary = {}) -> Dictionary:
	if _tenders != null:
		return {"accepted": false, "reason": "TENDERS_ALREADY_ENABLED"}
	var loaded := TenderLoader.load_data() if data.is_empty() else TenderLoader.validate_data(data)
	var company := CompanyLoader.load_data()
	if not loaded.ok or not company.ok:
		return {"accepted": false, "reason": "INVALID_TENDER_INPUT"}
	var service := Tenders.new(ledger, company.data.initial_company, loaded.data)
	if not service.valid():
		return {"accepted": false, "reason": "INVALID_TENDER_INPUT"}
	_tenders = service
	return {"accepted": true}


func submit_bid(command: Dictionary) -> Dictionary:
	if _tenders == null:
		return {"accepted": false, "reason": "TENDERS_NOT_ENABLED"}
	return _tenders.submit(command, clock.minute)


func bid_result(command_id: String) -> Dictionary:
	return {} if _tenders == null else _tenders.result(command_id)


## 모델 공급만 활성화한다. 실제 P05 화면 연결은 DEV-021 소관이다.
func enable_construction() -> Dictionary:
	if _tenders == null or _construction != null:
		return {"accepted": false, "reason": "CONSTRUCTION_ENABLE_PREREQUISITE"}
	_construction = Construction.new(ledger)
	return {"accepted": true}


func submit_construction(command: Dictionary) -> Dictionary:
	if _construction == null:
		return {"accepted": false, "reason": "CONSTRUCTION_NOT_ENABLED"}
	return _construction.submit(command, clock.minute)


func construction_result(command_id: String) -> Dictionary:
	return {} if _construction == null else _construction.result(command_id)


## DEV-022 모델 opt-in. 제품 Session/화면 활성화는 DEV-023의 명시적 연결을 따른다.
func enable_operations(network: Network = null, parameters: Dictionary = {}) -> Dictionary:
	if _construction == null or _operations != null:
		return {"accepted": false, "reason": "OPERATIONS_ENABLE_PREREQUISITE"}
	for input: Dictionary in _events.values():
		if _operations_fixture(input):
			return {"accepted": false, "reason": "OPERATIONS_FIXTURE_CONFLICT"}
	if network == null:
		var data := CompanyLoader.load_data()
		if not data.ok:
			return {"accepted": false, "reason": "INVALID_OPERATIONS_INPUT"}
		network = Network.new(data.data)
	var values := Predictor.load_parameters() if parameters.is_empty() else parameters
	var service := Operations.new(network, values, ledger)
	if not service.valid():
		return {"accepted": false, "reason": "INVALID_OPERATIONS_INPUT"}
	var tenders := _tenders.snapshot(clock.minute, _revision)
	var result := service.bind_sources(
		tenders, _construction.snapshot(clock.minute, _revision, tenders), clock.minute
	)
	if not result.accepted:
		return result
	_operations = service
	return {"accepted": true}


func operations_snapshot() -> Dictionary:
	if _operations == null:
		return {"available": false, "reason_codes": ["OPERATIONS_NOT_ENABLED"]}
	return _operations.snapshot(clock.minute, _revision)


func next_business_query() -> Dictionary:
	if _operations == null:
		return {"available": false, "reason_codes": ["OPERATIONS_NOT_ENABLED"]}
	return _operations.next_business_query(_tenders.snapshot(clock.minute, _revision))


## 테스트 전용 주입점이며 제품 UI에 연결하지 않는다.
func set_fixture(minute: int, input: Dictionary) -> bool:
	if (
		minute <= clock.minute
		or _events.has(minute)
		or (_operations != null and _operations_fixture(input))
	):
		return false
	if not _valid_fixture(input):
		return false
	_events[minute] = input.duplicate(true)
	return true


func advance_usec(elapsed: int) -> void:
	var previous := clock.minute
	var steps := clock.advance_usec(elapsed)
	for minute: int in range(previous + 1, previous + steps + 1):
		_tick(minute)


func snapshot() -> Dictionary:
	var value := {
		"data_version": "1.3",
		"simulation_minute": clock.minute,
		"day_id": clock.minute / 1440 + 1,
		"snapshot_revision": _revision,
		"observation_phase": "T_COMPLETE",
		"funds": ledger.snapshot(),
		"boarding": _boarding.duplicate(true),
		"trace": _trace.duplicate(true)
	}
	if _tenders != null:
		value["tenders"] = _tenders.snapshot(clock.minute, _revision)
	if _construction != null:
		value["construction"] = _construction.snapshot(
			clock.minute, _revision, _tenders.snapshot(clock.minute, _revision)
		)
	if _operations != null:
		value["operations"] = operations_snapshot()
	return value


func _tick(minute: int) -> void:
	var input: Dictionary = _events.get(minute, {})
	_stage(minute, "PREVIOUS_INTERVAL")
	var cost: int = input.get("operating_cost", 0)
	if _operations != null:
		cost = _operations.previous_interval_cost(minute)
	ledger.operating_cost(cost, minute - 1)
	if _construction != null:
		_construction.accrue(minute)
	reports.sync(ledger.entries())
	if minute % 1440 == 0:
		if _operations != null:
			var day := minute / 1440
			reports.sync_operations(day, _operations.close_day(day, reports.current(day).fare))
		reports.close(minute / 1440, ledger.snapshot())
	_stage(minute, "CONTRACT")
	for command: Dictionary in commands.due(minute):
		var result: Dictionary
		if (
			command.get("target_revision", 0)
			!= target_revisions.get(command.get("target_id", ""), 0)
		):
			result = {"accepted": false, "reason": "STATE_CHANGED"}
		else:
			result = ledger.contract(
				command.get("target_id", ""),
				command.get("government", -1),
				command.get("total_cost", -1),
				minute
			)
		result.merge(
			{
				"command_id": command.command_id,
				"effective_at": minute,
				"decision_phase": "CONTRACT",
				"decision_snapshot_revision": _revision,
				"result_revision": _revision + 1
			}
		)
		_revision += 1
		commands.finish(command.command_id, result)
	if _tenders != null:
		_revision += _tenders.process_contract_phase(minute, _revision)
	_construction_phase("CONTRACT", minute)
	_stage(minute, "PROGRESS")
	for payment: Dictionary in input.get("construction", []):
		ledger.construction_payment(payment.project, payment.amount, minute)
	_construction_phase("PROGRESS", minute)
	_stage(minute, "VALIDATION")
	_construction_phase("VALIDATION", minute)
	if _operations != null:
		var tenders := _tenders.snapshot(minute, _revision)
		_operations.bind_sources(
			tenders, _construction.snapshot(minute, _revision, tenders), minute
		)
	_stage(minute, "ARRIVAL")
	var fare: int = input.get("arrival_fare", 0)
	if _operations != null:
		fare = _operations.arrivals(minute).completed * 100
	ledger.fare(fare, minute)
	_stage(minute, "SETTLEMENT")
	ledger.settle(minute)
	_stage(minute, "BOARDING")
	var eligible: bool = input.get("eligible", false)
	if _construction != null:
		eligible = eligible and _construction.service_ready()
	if _operations != null:
		eligible = _operations.service_ready()
	_boarding = ledger.boarding(minute, input.get("next_cost", 100), eligible)
	if _operations != null:
		_operations.board(minute, _boarding)
		_boarding = _operations.snapshot(minute, _revision).boarding
		reports.sync_operations(minute / 1440 + 1, _operations.daily(minute / 1440 + 1))
	reports.sync(ledger.entries())
	_events.erase(minute)
	_revision += 1


func _construction_phase(phase: String, minute: int) -> void:
	if _construction != null:
		_revision += _construction.process_phase(
			phase, minute, _revision, _tenders.snapshot(minute, _revision)
		)


func _stage(minute: int, phase: String) -> void:
	_revision += 1
	_trace.append({"effective_at": minute, "phase": phase, "snapshot_revision": _revision})


func _valid_fixture(input: Dictionary) -> bool:
	for key: String in ["operating_cost", "arrival_fare", "next_cost"]:
		if input.has(key) and (not input[key] is int or input[key] < 0):
			return false
	if input.has("eligible") and not input.eligible is bool:
		return false
	if not input.get("construction", []) is Array:
		return false
	for item: Variant in input.get("construction", []):
		if not item is Dictionary or not item.get("project") is String:
			return false
		if not item.get("amount") is int or item.amount < 0:
			return false
	return true


func _operations_fixture(input: Dictionary) -> bool:
	for key: String in ["operating_cost", "arrival_fare", "eligible", "next_cost"]:
		if input.has(key):
			return true
	return false
