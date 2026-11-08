class_name ConstructionService
extends RefCounted
## W05 명령과 단계 어댑터. W04A 지급 증거를 소비하며 정부금을 다시 지급하지 않는다.

const Project = preload("res://scripts/model/construction_project.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const COMMAND_KEYS := [
	"command_id",
	"project_id",
	"business_contract_id",
	"action",
	"mode",
	"requested_at",
	"effective_at",
	"expected_snapshot_revision",
	"target_revision"
]

var _ledger: Ledger
var _projects: Dictionary = {}
var _pending: Dictionary = {}
var _results: Dictionary = {}


func _init(ledger: Ledger) -> void:
	_ledger = ledger


func submit(command: Dictionary, completed: int) -> Dictionary:
	var id: Variant = command.get("command_id")
	if not id is String or id.is_empty():
		return {"accepted": false, "reason": "INVALID_COMMAND"}
	if _results.has(id):
		return result(id)
	if _pending.has(id):
		return {"pending": true, "command_id": id, "effective_at": _pending[id].effective_at}
	var error := _format_error(command, completed)
	if not error.is_empty():
		_results[id] = _outcome(command, error, -1, -1, "ADMISSION")
		return result(id)
	var value := command.duplicate(true)
	if value.action == "contract" and int(value.effective_at) % 1440 < 360:
		value.effective_at = int(value.effective_at) / 1440 * 1440 + 360
	_pending[id] = value
	return {"pending": true, "command_id": id, "effective_at": value.effective_at}


func result(id: String) -> Dictionary:
	return _results.get(id, {}).duplicate(true)


## PREVIOUS_INTERVAL: 발생 비용은 끝난 구간에 귀속, 지급은 뒤 PROGRESS에 귀속한다.
func accrue(minute: int) -> void:
	for project: Project in _projects.values():
		_ledger.construction_accrual(project.accrue(minute), minute - 1)


func process_phase(phase: String, minute: int, revision: int, tenders: Dictionary) -> int:
	var changes := 0
	if phase == "PROGRESS":
		for project: Project in _projects.values():
			if project.state.status == "BUILDING" and project.state.construction_payable > 0:
				_pay(project, minute)
	if phase == "VALIDATION":
		for project: Project in _projects.values():
			project.validate_at(minute)
	var ids: Array = _pending.keys()
	ids.sort()
	for id: String in ids:
		var command: Dictionary = _pending[id]
		var expected_phase := "CONTRACT" if command.action == "contract" else "VALIDATION"
		if command.action in ["start", "resume"]:
			expected_phase = "PROGRESS"
		if expected_phase != phase or command.effective_at != minute:
			continue
		var error := _execute(command, minute, tenders)
		_results[id] = _outcome(command, error, minute, revision + changes, phase)
		_pending.erase(id)
		changes += 1
	return changes


func snapshot(minute: int, revision: int, tenders: Dictionary = {}) -> Dictionary:
	var projects: Array[Dictionary] = []
	for project: Project in _projects.values():
		var row := project.snapshot()
		if (
			row.allowed_actions.resume
			and not _ledger.can_pay_construction(row.project_id, row.construction_payable)
		):
			row.allowed_actions.resume = false
			row.action_reason_codes.resume = ["CONSTRUCTION_PAYMENT_DUE"]
		if row.allowed_actions.repair:
			var funds := _ledger.snapshot()
			var own_r: int = funds.restricted_by_project.get(row.project_id, 0)
			if own_r + int(funds.available_cash) < 20000:
				row.allowed_actions.repair = false
				row.action_reason_codes.repair = ["REPAIR_FUNDS_INSUFFICIENT"]
		projects.append(row)
	return {
		"available": true,
		"rules_version": "RFC-DEV-020-01-OWNER-20261108",
		"data_version": "1.3",
		"ui_contract_revision": "DEV020-W05-UI-1",
		"simulation_minute": minute,
		"day_id": minute / 1440 + 1,
		"snapshot_revision": revision,
		"observation_phase": "T_COMPLETE",
		"funds": _ledger.snapshot(),
		"projects": projects,
		"contract_candidates": _candidates(tenders, minute)
	}


func _candidates(tenders: Dictionary, minute: int) -> Array[Dictionary]:
	var values: Array[Dictionary] = []
	for row: Dictionary in tenders.get("tenders", []):
		var business: Dictionary = row.get("business_contract", {})
		if business.is_empty():
			continue
		var command := {
			"project_id": business.project_id, "business_contract_id": business.business_contract_id
		}
		var reason := ""
		if _projects.has(business.project_id):
			reason = "CONSTRUCTION_CONTRACT_EXISTS"
		elif _source(command, tenders, minute).is_empty():
			reason = "BUSINESS_PAYMENT_NOT_EFFECTIVE"
		values.append(
			{
				"project_id": business.project_id,
				"business_contract": business.duplicate(true),
				"target_revision": 0,
				"allowed_actions": {"contract": reason.is_empty()},
				"reason_codes": [] if reason.is_empty() else [reason],
				"modes": Project.MODES.duplicate(true)
			}
		)
	return values


func service_ready() -> bool:
	for project: Project in _projects.values():
		if project.state.status == "OPEN":
			return true
	return false


func _execute(command: Dictionary, minute: int, tenders: Dictionary) -> String:
	var id: String = command.project_id
	if command.action == "contract":
		return _contract(command, minute, tenders)
	if not _projects.has(id):
		return "UNKNOWN_CONSTRUCTION_PROJECT"
	var project: Project = _projects[id]
	var reason := _project_error(project, command)
	if not reason.is_empty():
		return reason
	if command.action == "resume" and not _pay(project, minute):
		return "CONSTRUCTION_PAYMENT_DUE"
	if command.action == "repair" and not _ledger.repair_payment(id, 20000, minute):
		return "REPAIR_FUNDS_INSUFFICIENT"
	project.apply(command.action, minute)
	return ""


func _project_error(project: Project, command: Dictionary) -> String:
	if project.state.business_contract.business_contract_id != command.business_contract_id:
		return "BUSINESS_CONTRACT_MISMATCH"
	if command.target_revision != project.state.condition_revision:
		return "STATE_CHANGED"
	return project.action_error(command.action)


func _contract(command: Dictionary, minute: int, tenders: Dictionary) -> String:
	if _projects.has(command.project_id):
		return "CONSTRUCTION_CONTRACT_EXISTS"
	var source := _source(command, tenders, minute)
	if source.is_empty():
		return "BUSINESS_PAYMENT_NOT_EFFECTIVE"
	if command.target_revision != 0:
		return "STATE_CHANGED"
	var total: int = Project.MODES[command.mode][0]
	if total > int(source.business_contract.government_payment.amount):
		return "MODE_RESERVATION_POLICY_REQUIRED"
	_projects[command.project_id] = Project.new(source, command.mode, minute)
	return ""


func _pay(project: Project, minute: int) -> bool:
	var due: int = project.state.construction_payable
	if due == 0:
		return true
	var paid := _ledger.construction_payment(project.state.project_id, due, minute, false)
	project.payment(paid, minute)
	return paid


func _source(command: Dictionary, tenders: Dictionary, minute: int) -> Dictionary:
	for row: Dictionary in tenders.get("tenders", []):
		var business: Dictionary = row.get("business_contract", {})
		var payment: Dictionary = business.get("government_payment", {})
		if not _valid_source_types(business, payment):
			continue
		if (
			business.get("status") != "EFFECTIVE"
			or business.get("project_id") != command.project_id
		):
			continue
		if business.get("business_contract_id") != command.business_contract_id:
			continue
		if (
			not payment.get("available", false)
			or payment.get("restricted_project_id") != command.project_id
		):
			continue
		var index: int = payment.get("ledger_entry_index", -1)
		var entries := _ledger.entries()
		if index < 0 or index >= entries.size():
			continue
		var entry: Dictionary = entries[index]
		var linked: bool = entry.kind == "government" and entry.amount == payment.get("amount")
		linked = linked and entry.effective_at == payment.get("effective_at")
		linked = (
			linked and int(entry.effective_at) <= minute and int(business.effective_at) <= minute
		)
		var funds := _ledger.snapshot()
		if (
			linked
			and funds.restricted_by_project.has(command.project_id)
			and funds.reserved_by_project.has(command.project_id)
		):
			return row.duplicate(true)
	return {}


func _valid_source_types(business: Dictionary, payment: Dictionary) -> bool:
	for key: String in ["project_id", "business_contract_id", "status"]:
		if not business.get(key) is String:
			return false
	for key: String in ["amount", "effective_at", "ledger_entry_index"]:
		if not payment.get(key) is int:
			return false
	return (
		business.get("effective_at") is int
		and payment.get("available") is bool
		and payment.get("restricted_project_id") is String
		and payment.get("transaction_id") is String
		and not payment.transaction_id.is_empty()
	)


func _outcome(
	command: Dictionary, reason: String, minute: int, revision: int, phase: String
) -> Dictionary:
	return {
		"accepted": reason.is_empty(),
		"pending": false,
		"command": command.duplicate(true),
		"command_id": command.command_id,
		"requested_at": command.get("requested_at"),
		"effective_at": null if minute < 0 else minute,
		"phase_revision": null if revision < 0 else revision,
		"result_revision": null if revision < 0 else revision + 1,
		"decision_phase": phase,
		"reason": reason,
		"reason_codes": [] if reason.is_empty() else [reason]
	}


func _format_error(command: Dictionary, completed: int) -> String:
	for key: String in command:
		if key not in COMMAND_KEYS:
			return "FIXED_TERMS"
	for key: String in ["project_id", "business_contract_id", "action"]:
		if not command.get(key) is String or command[key].is_empty():
			return "INVALID_COMMAND"
	for key: String in [
		"requested_at", "effective_at", "target_revision", "expected_snapshot_revision"
	]:
		if not command.get(key) is int or command[key] < 0:
			return "INVALID_COMMAND"
	if command.requested_at > completed or command.effective_at <= completed:
		return "CLOSED_EFFECTIVE_TIME"
	return _action_format_error(command)


func _action_format_error(command: Dictionary) -> String:
	if command.action == "contract":
		if not command.get("mode") is String or not Project.MODES.has(command.mode):
			return "INVALID_MODE"
	elif command.action not in Project.ACTIONS:
		return "INVALID_ACTION"
	return ""
