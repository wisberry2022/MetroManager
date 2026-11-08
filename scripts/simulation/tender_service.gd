class_name TenderService
extends RefCounted
## 입찰 전용 명령을 CONTRACT 단계에서 실행한다. 기존 계약 Queue의 업무시간 이연과 분리한다.

const Loader = preload("res://scripts/data/tender_data_loader.gd")
const CompanyLoader = preload("res://scripts/data/gate2_data_loader.gd")
const Network = preload("res://scripts/model/administrative_network.gd")
const Plan = preload("res://scripts/model/route_plan.gd")
const Tender = preload("res://scripts/model/public_tender.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const UI_REVISION := "DEV018-W04A-UI-1"

var _ledger: Ledger
var _city: String
var _capability: int
var _tenders: Dictionary = {}
var _pending: Dictionary = {}
var _results: Dictionary = {}
var _errors: Array = []


func _init(ledger: Ledger, company: Dictionary, data: Dictionary) -> void:
	_ledger = ledger
	_city = company.get("city_id", "")
	_capability = company.get("capability", 80)
	var validated := Loader.validate_data(data)
	var company_data := CompanyLoader.load_data()
	if not validated.ok or not company_data.ok or _capability < 0 or _capability > 100:
		_errors = ["INVALID_TENDER_INPUT"]
		return
	var plan := Plan.new(Network.new(company_data.data), _city)
	for terms: Dictionary in validated.data.tenders:
		if terms.city_id != _city:
			continue
		var stops: Array[String] = []
		stops.assign(terms.station_ids)
		if not plan.validate(stops).valid:
			_errors = ["INVALID_TENDER_ROUTE"]
			_tenders.clear()
			return
		_tenders[terms.tender_id] = Tender.new(terms)


func valid() -> bool:
	return _errors.is_empty()


## 요청의 snapshot revision은 진단용. 대상/회차/고정 계획 revision이 같으면 시간 경과만으로 거부하지 않는다.
func submit(command: Dictionary, completed_minute: int) -> Dictionary:
	var id: Variant = command.get("command_id")
	if not id is String or id.is_empty():
		return {"accepted": false, "reason": "INVALID_COMMAND"}
	if _results.has(id):
		return _results[id].duplicate(true)
	if _pending.has(id):
		return {"pending": true, "command_id": id, "effective_at": _pending[id].effective_at}
	var reason := _command_error(command, completed_minute)
	if not reason.is_empty():
		var rejected := {
			"accepted": false,
			"pending": false,
			"command_id": id,
			"reason": reason,
			"reason_codes": [reason],
			"requested_at": command.get("requested_at")
		}
		_results[id] = rejected
		return rejected.duplicate(true)
	_pending[id] = command.duplicate(true)
	return {"pending": true, "command_id": id, "effective_at": command.effective_at}


func result(id: String) -> Dictionary:
	return _results.get(id, {}).duplicate(true)


## 단일 Pipeline만 호출한다. 같은 분 재호출은 상태/원장 효과를 반복하지 않는다.
func process_contract_phase(minute: int, phase_revision: int) -> int:
	var changes := 0
	var ids: Array = _pending.keys()
	ids.sort()
	for id: String in ids:
		var command: Dictionary = _pending[id]
		if command.effective_at != minute:
			continue
		var reason := _admission_error(command, minute)
		var result_value := {
			"accepted": reason.is_empty(),
			"pending": false,
			"command_id": id,
			"tender_id": command.tender_id,
			"round_id": command.round_id,
			"plan_revision": command.plan_revision,
			"expected_snapshot_revision": command.expected_snapshot_revision,
			"requested_at": command.requested_at,
			"effective_at": minute,
			"reason": reason,
			"reason_codes": [] if reason.is_empty() else [reason],
			"decision_phase": "CONTRACT",
			"phase_revision": phase_revision + changes,
			"result_revision": phase_revision + changes + 1
		}
		if reason.is_empty():
			var tender: Tender = _tenders[command.tender_id]
			result_value["admission_snapshot"] = {
				"funds": _ledger.snapshot(),
				"score": Tender.score(int(_ledger.snapshot().free_cash), _capability),
				"eligibility": _eligibility(tender),
				"command": command.duplicate(true)
			}
			result_value["target_revision"] = tender.revision() + 1
			tender.receive(result_value)
		_results[id] = result_value
		_pending.erase(id)
		changes += 1
	for tender: Tender in _tenders.values():
		if not tender.closed() and minute >= int(tender.terms().closes_at):
			changes += _close(tender, minute, phase_revision + changes)
	return changes


func snapshot(minute: int, snapshot_revision: int) -> Dictionary:
	var rows: Array[Dictionary] = []
	for tender: Tender in _tenders.values():
		rows.append(tender.snapshot(minute, _eligibility(tender)))
	return {
		"rules_version": Loader.RULES,
		"data_version": "1.3",
		"ui_contract_revision": UI_REVISION,
		"snapshot_revision": snapshot_revision,
		"simulation_minute": minute,
		"day_id": minute / 1440 + 1,
		"observation_phase": "T_COMPLETE",
		"available": valid(),
		"errors": _errors.duplicate(),
		"tenders": rows
	}


func _eligibility(tender: Tender) -> Dictionary:
	# W04A 표준 경로만 연결한다. 비영 K의 미래 모드/약정 정책은 여기서 결정하지 않는다.
	var funds := _ledger.snapshot()
	var active: bool = (
		not funds.restricted_by_project.is_empty() or not funds.reserved_by_project.is_empty()
	)
	return tender.eligibility(_city, active, 2880)


func _command_error(command: Dictionary, completed: int) -> String:
	if not valid():
		return "INVALID_TENDER_INPUT"
	for key: String in [
		"requested_at",
		"effective_at",
		"expected_snapshot_revision",
		"target_revision",
		"plan_revision"
	]:
		if not command.get(key) is int or command[key] < 0:
			return "INVALID_COMMAND"
	if command.requested_at > completed or command.effective_at <= completed:
		return "CLOSED_EFFECTIVE_TIME"
	for key: String in ["tender_id", "round_id"]:
		if not command.get(key) is String:
			return "INVALID_TARGET"
	# 사용자가 운임/금액/공기/노선을 payload로 교체하는 통로를 만들지 않는다.
	var keys := [
		"command_id",
		"tender_id",
		"round_id",
		"requested_at",
		"effective_at",
		"expected_snapshot_revision",
		"target_revision",
		"plan_revision"
	]
	for key: Variant in command:
		if key not in keys:
			return "FIXED_TERMS"
	return ""


func _admission_error(command: Dictionary, minute: int) -> String:
	if not _tenders.has(command.tender_id):
		return "UNKNOWN_TENDER"
	var tender: Tender = _tenders[command.tender_id]
	var terms := tender.terms()
	var reason := ""
	if command.round_id != terms.round_id or command.plan_revision != 0:
		reason = "STATE_CHANGED"
	elif minute >= int(terms.closes_at) or tender.closed():
		reason = "ROUND_CLOSED"
	elif minute < int(terms.opens_at):
		reason = "NOT_OPEN"
	elif tender.received():
		reason = "DUPLICATE_BID"
	elif command.target_revision != tender.revision():
		reason = "STATE_CHANGED"
	else:
		var eligibility_now := _eligibility(tender)
		if not eligibility_now.eligible:
			reason = str(eligibility_now.reason_codes[0])
	return reason


func _close(tender: Tender, minute: int, phase_revision: int) -> int:
	var terms := tender.terms()
	var funds := _ledger.snapshot()
	var score := Tender.score(int(funds.free_cash), _capability)
	var competitor: int = (
		(7 * int(terms.competitor_capability) + 3 * int(terms.competitor_financial_score)) * 10000
	)
	var awarded: bool = tender.received() and score.comparison_score.numerator > competitor
	var reason := (
		"NOT_SUBMITTED"
		if not tender.received()
		else (
			""
			if awarded
			else (
				"TIE_PRIORITY" if score.comparison_score.numerator == competitor else "LOWER_SCORE"
			)
		)
	)
	tender.decide(
		{
			"awarded": awarded,
			"reason": reason,
			"effective_at": minute,
			"phase_revision": phase_revision,
			"result_revision": phase_revision + 1,
			"decision_phase": "CONTRACT",
			"funds": funds,
			"score": score,
			"eligibility": _eligibility(tender),
			"competitor_comparison": {"numerator": competitor, "denominator": 10000},
			"tie_priority": terms.tie_priority.duplicate(),
			"terms": terms
		}
	)
	if not awarded:
		return 1
	var eligibility_now := _eligibility(tender)
	var effect: Dictionary
	if not eligibility_now.eligible:
		effect = {"accepted": false, "reason": eligibility_now.reason_codes[0]}
	else:
		effect = _ledger.contract(
			terms.project_id, int(terms.government), int(terms.standard_cost), minute
		)
	var accepted: bool = effect.accepted
	tender.record_contract(
		{
			"business_contract_id": terms.round_id + "-BUSINESS",
			"project_id": terms.project_id,
			"status": "EFFECTIVE" if accepted else "REJECTED",
			"attempted_at": minute,
			"effective_at": minute if accepted else null,
			"phase_revision": phase_revision + 1,
			"result_revision": phase_revision + 2,
			"result": effect,
			"government_payment":
			{
				"available": accepted,
				"effective_at": minute if accepted else null,
				"ledger_entry_index": _ledger.entries().size() - 1 if accepted else null,
				"transaction_id": terms.round_id + "-GOVERNMENT" if accepted else "",
				"amount": int(terms.government) if accepted else 0,
				"restricted_project_id": terms.project_id
			},
			"standard_cost": int(terms.standard_cost),
			"construction_contract_available": false
		}
	)
	return 2
