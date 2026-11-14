class_name OperationsService
extends RefCounted
## W05 권위 원본을 실제 운행에 연결한다. 원장 효과는 반환하고 Pipeline이 적용한다.

const Line = preload("res://scripts/model/operating_line.gd")
const Network = preload("res://scripts/model/administrative_network.gd")
const Plan = preload("res://scripts/model/route_plan.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const UI_REVISION := "DEV022-W06-UI-1"

var _network: Network
var _parameters: Dictionary
var _ledger: Ledger
var _line: Line = Line.new({}, [])
var _bound: bool = false
var _ready: bool = false
var _reason: String = "SERVICE_NOT_READY"
var _source_minute: int = -1
var _source_revision: int = -1
var _last_board: int = -1
var _last_cost: int = -1
var _cost_due_at: int = -1
var _boarding: Dictionary = {"boarding_allowed": false, "reason_codes": ["SERVICE_NOT_READY"]}
var _first_report: Dictionary = {}
var _verified_business: Dictionary = {}


func _init(network: Network, parameters: Dictionary, ledger: Ledger) -> void:
	_network = network
	_parameters = parameters.duplicate(true)
	_ledger = ledger


func valid() -> bool:
	if _network == null or not _network.valid():
		return false
	if (
		_parameters.get("data_version") != "1.3"
		or not _parameters.get("daily_demand") is Dictionary
	):
		return false
	for key: String in ["fare", "operating_cost_per_minute"]:
		if not _parameters.get(key) is int or _parameters[key] != 100:
			return false
	var capacity: Variant = _parameters.get("capacity_per_minute")
	if not capacity is int or capacity < 1 or capacity > 10:
		return false
	for index: int in range(1, 9):
		var demand: Variant = _parameters.daily_demand.get("D%02d" % index)
		if not demand is int or demand < 0 or demand > Line.MAX_INT / 864000:
			return false
	return true


## 같은 Pipeline의 스냅샷만 공급한다. 오래된 호출은 현재 정상 상태를 덮어쓰지 않는다.
func bind_sources(tenders: Dictionary, construction: Dictionary, minute: int) -> Dictionary:
	if not valid() or not _valid_envelope(tenders, construction, minute):
		return _unavailable("INVALID_OPERATIONS_SOURCE")
	var revision: int = construction.snapshot_revision
	if minute < _source_minute or revision < _source_revision:
		return {"accepted": false, "reason": "STALE_OPERATIONS_SOURCE"}
	_source_minute = minute
	_source_revision = revision
	var sources: Array[Dictionary] = []
	var invalid := false
	for item: Variant in construction.projects:
		if not item is Dictionary:
			invalid = true
			continue
		var source := _source(item, tenders, minute)
		if source.is_empty():
			invalid = true
		else:
			sources.append(source)
	if invalid or sources.size() != 1:
		return _unavailable(
			(
				"SERVICE_NOT_READY"
				if not invalid and sources.is_empty()
				else "INVALID_OPERATIONS_SOURCE"
			)
		)
	var source: Dictionary = sources[0]
	if _bound:
		if not _line.reconcile_source(source):
			return _unavailable("OPERATIONS_SOURCE_CHANGED")
	elif source.opened_at != null:
		var stops: Array[String] = []
		stops.assign(source.station_ids)
		_line = Line.new(source, Predictor.od_pairs(_network, stops, _parameters.daily_demand))
		_bound = true
	if source.opened_at == null:
		return _unavailable("SERVICE_NOT_READY")
	_ready = true
	_reason = ""
	return {"accepted": true}


## 직전에 허용한 구간 비용만 한 번 반환한다. 이후 조건 실효로 과거 비용을 취소하지 않는다.
func previous_interval_cost(minute: int) -> int:
	if minute <= _last_cost:
		return 0
	_last_cost = minute
	if minute != _cost_due_at:
		return 0
	_cost_due_at = -1
	return int(_parameters.operating_cost_per_minute)


func arrivals(minute: int) -> Dictionary:
	return _line.arrive(minute)


func board(minute: int, ledger_gate: Dictionary) -> Dictionary:
	if minute <= _last_board:
		return {"accepted": false, "reason": "CLOSED_OPERATIONS_TIME"}
	_last_board = minute
	_boarding = ledger_gate.duplicate(true)
	if not _ready:
		_boarding = {"boarding_allowed": false, "reason_codes": [_reason]}
	if minute % 1440 < 360:
		_boarding = {"boarding_allowed": false, "reason_codes": ["OUTSIDE_SERVICE_HOURS"]}
	if not _ready or minute % 1440 < 360:
		return {"accepted": true, "counts": {"requested": 0, "boarded": 0, "unboarded": 0}}
	var allowed: bool = _boarding.get("boarding_allowed", false)
	var result := _line.board(minute, allowed, int(_parameters.capacity_per_minute))
	if result.accepted and allowed:
		_cost_due_at = minute + 1
	return result


func service_ready() -> bool:
	return _ready


func daily(day: int) -> Dictionary:
	return _line.daily(day)


func close_day(day: int, actual_fare: int) -> Dictionary:
	var value := _line.close_day(day)
	if (
		_first_report.is_empty()
		and value.service_minutes > 0
		and value.completed > 0
		and actual_fare == value.completed * 100
	):
		_first_report = {
			"day_id": day,
			"service_minutes": value.service_minutes,
			"completed": value.completed,
			"fare": actual_fare
		}
	return value


func snapshot(minute: int, revision: int) -> Dictionary:
	var value := _line.snapshot()
	value.merge(
		{
			"available": _reason in ["", "SERVICE_NOT_READY"],
			"service_ready": _ready,
			"reason_codes": [] if _reason.is_empty() else [_reason],
			"data_version": "1.3",
			"ui_contract_revision": UI_REVISION,
			"simulation_minute": minute,
			"day_id": minute / 1440 + 1,
			"snapshot_revision": revision,
			"observation_phase": "T_COMPLETE",
			"boarding": _boarding.duplicate(true),
			"daily": daily(minute / 1440 + 1),
			"first_valid_report": _first_report.duplicate(true)
		}
	)
	return value


func next_business_query(tenders: Dictionary) -> Dictionary:
	var ready := not _first_report.is_empty()
	return {
		"available": ready and tenders.get("available", false),
		"reason_codes":
		(
			["FIRST_VALID_OPERATIONS_REPORT_REQUIRED"]
			if not ready
			else ([] if tenders.get("available", false) else ["TENDER_SUPPLY_UNAVAILABLE"])
		),
		"first_valid_report": _first_report.duplicate(true),
		"tenders": tenders.duplicate(true) if ready else {},
		"allowed_actions": {"query": ready}
	}


func _unavailable(reason: String) -> Dictionary:
	_ready = false
	_reason = reason
	return {"accepted": reason == "SERVICE_NOT_READY", "reason": reason}


func _valid_envelope(tenders: Dictionary, construction: Dictionary, minute: int) -> bool:
	for data: Dictionary in [tenders, construction]:
		if (
			data.get("available") != true
			or data.get("data_version") != "1.3"
			or data.get("simulation_minute") != minute
			or not data.get("snapshot_revision") is int
		):
			return false
	return (
		tenders.get("tenders") is Array
		and construction.get("projects") is Array
		and tenders.snapshot_revision == construction.snapshot_revision
	)


func _source(project: Dictionary, tenders: Dictionary, minute: int) -> Dictionary:
	var business: Variant = project.get("business_contract")
	if not business is Dictionary or not business.get("government_payment") is Dictionary:
		return {}
	var payment: Dictionary = business.government_payment
	if not _payment_linked(business, payment, minute):
		return {}
	if (
		project.get("project_id") != business.project_id
		or (
			project.get("construction_contract_id")
			!= business.business_contract_id + "-CONSTRUCTION"
		)
		or project.get("construction_contract_status") != "EFFECTIVE"
		or not project.get("condition_revision") is int
		or project.condition_revision < 0
		or not project.get("contract_effective_at") is int
		or project.contract_effective_at > minute
		or not project.get("station_ids") is Array
	):
		return {}
	for row: Variant in tenders.tenders:
		if not row is Dictionary or row.get("business_contract") != business:
			continue
		var terms: Variant = row.get("terms")
		if not terms is Dictionary or terms.get("station_ids") != project.station_ids:
			continue
		if terms.get("fare") != 100 or terms.get("project_id") != business.project_id:
			continue
		var stops: Array[String] = []
		for stop: Variant in project.station_ids:
			if stop is String:
				stops.append(stop)
		if (
			stops.size() != project.station_ids.size()
			or not Plan.new(_network).validate(stops).valid
			or (project.get("status") == "OPEN" and not _valid_open(project, minute))
		):
			return {}
		return {
			"project_id": business.project_id,
			"business_contract_id": business.business_contract_id,
			"construction_contract_id": project.construction_contract_id,
			"condition_revision": project.condition_revision,
			"opened_at": project.get("opened_at") if project.get("status") == "OPEN" else null,
			"station_ids": stops
		}
	return {}


func _valid_open(project: Dictionary, minute: int) -> bool:
	return (
		project.get("service_ready") == true
		and project.get("opened_at") is int
		and project.opened_at <= minute
		and project.opened_at >= project.contract_effective_at
		and project.get("trial_status") == "PASSED"
		and project.get("safety_status") == "PASSED"
		and project.get("defects") == 0
		and project.get("construction_payable") == 0
		and project.get("completed_at") is int
		and project.completed_at <= project.opened_at
	)


func _payment_linked(business: Dictionary, payment: Dictionary, minute: int) -> bool:
	for key: String in ["project_id", "business_contract_id"]:
		if not business.get(key) is String or business[key].is_empty():
			return false
	for key: String in ["amount", "effective_at", "ledger_entry_index"]:
		if not payment.get(key) is int:
			return false
	if (
		business.get("status") != "EFFECTIVE"
		or not business.get("effective_at") is int
		or business.effective_at > minute
		or payment.get("available") != true
		or payment.get("restricted_project_id") != business.project_id
		or not payment.get("transaction_id") is String
		or payment.transaction_id.is_empty()
	):
		return false
	var funds := _ledger.snapshot()
	var protected: bool = (
		funds.restricted_by_project.has(business.project_id)
		and funds.reserved_by_project.has(business.project_id)
	)
	# 원장 공개 API의 항목은 추가만 된다. 검증한 동일 지급 참조를 매 분 전체 복사하지 않는다.
	if business == _verified_business:
		return protected
	var entries := _ledger.entries()
	var index: int = payment.ledger_entry_index
	if index < 0 or index >= entries.size():
		return false
	var item: Dictionary = entries[index]
	var linked: bool = (
		item.kind == "government"
		and item.amount == payment.amount
		and item.effective_at == payment.effective_at
		and item.effective_at <= minute
		and protected
	)
	if linked:
		_verified_business = business.duplicate(true)
	return linked
