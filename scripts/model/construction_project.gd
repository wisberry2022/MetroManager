class_name ConstructionProject
extends RefCounted
## 공정/검증 상태만 소유한다. 현금/R/K/B의 권위는 CompanyLedger다.

const MODES := {"STANDARD": [600000, 2880], "FAST": [720000, 1440]}
const ACTIONS := ["start", "resume", "trial", "safety", "repair", "open"]

var state: Dictionary


func _init(source: Dictionary, mode: String, minute: int) -> void:
	var business: Dictionary = source.business_contract
	state = {
		"project_id": business.project_id,
		"business_contract": business.duplicate(true),
		"station_ids": source.terms.station_ids.duplicate(),
		"construction_contract_id": business.business_contract_id + "-CONSTRUCTION",
		"construction_contract_status": "EFFECTIVE",
		"contract_effective_at": minute,
		"mode": mode,
		"total_cost": MODES[mode][0],
		"duration_minutes": MODES[mode][1],
		"condition_revision": 0,
		"status": "CONTRACTED",
		"started_at": null,
		"completed_at": null,
		"elapsed_minutes": 0,
		"last_progress_at": null,
		"accrued": 0,
		"paid": 0,
		"construction_payable": 0,
		"trial_status": "NOT_STARTED",
		"safety_status": "NOT_STARTED",
		"procedure": "",
		"procedure_started_at": null,
		"procedure_completes_at": null,
		"procedure_revision": null,
		"defects": 0,
		"first_defect_issued": false,
		"repair_paid": 0,
		"opened_at": null
	}


func snapshot() -> Dictionary:
	var value := state.duplicate(true)
	value["allowed_actions"] = {}
	value["action_reason_codes"] = {}
	for action: String in ACTIONS:
		var reason := action_error(action)
		value.allowed_actions[action] = reason.is_empty()
		value.action_reason_codes[action] = [] if reason.is_empty() else [reason]
	value["reason_codes"] = ["CONSTRUCTION_PAYMENT_DUE"] if state.construction_payable > 0 else []
	value["service_ready"] = state.status == "OPEN"
	return value


func action_error(action: String) -> String:
	var ready: bool = state.status == "COMPLETED" and state.procedure.is_empty()
	var valid := {
		"start": state.status == "CONTRACTED",
		"resume": state.status == "SUSPENDED",
		"trial": ready and state.trial_status != "PASSED" and state.defects == 0,
		"safety":
		(
			ready
			and state.trial_status == "PASSED"
			and state.safety_status != "PASSED"
			and state.defects == 0
		),
		"repair": ready and state.defects > 0,
		"open":
		(
			ready
			and state.trial_status == "PASSED"
			and state.safety_status == "PASSED"
			and state.defects == 0
		)
	}
	return "" if valid.get(action, false) else "PREREQUISITE_NOT_MET"


func apply(action: String, minute: int) -> void:
	match action:
		"start":
			state.started_at = minute
			state.status = "BUILDING"
		"resume":
			state.status = (
				"COMPLETED" if state.elapsed_minutes == state.duration_minutes else "BUILDING"
			)
			if state.status == "COMPLETED":
				state.completed_at = minute
		"open":
			state.status = "OPEN"
			state.opened_at = minute
		_:
			state.procedure = action
			state.procedure_started_at = minute
			state.procedure_completes_at = minute + (30 if action == "repair" else 60)
			state.procedure_revision = state.condition_revision
			if action == "repair":
				state.repair_paid += 20000
			else:
				state[action + "_status"] = "RUNNING"


## 이전 구간의 수행 공정을 먼저 확정한다. 지급 실패로 수행 이력을 삭제하지 않는다.
func accrue(minute: int) -> int:
	if state.status != "BUILDING" or minute <= int(state.started_at):
		return 0
	if state.last_progress_at != null and minute <= int(state.last_progress_at):
		return 0
	state.last_progress_at = minute
	state.elapsed_minutes += 1
	var cumulative: int = (
		int(state.total_cost) * int(state.elapsed_minutes) / int(state.duration_minutes)
	)
	var amount: int = cumulative - int(state.accrued)
	state.accrued = cumulative
	state.construction_payable += amount
	return amount


func payment(paid: bool, minute: int) -> void:
	if state.construction_payable == 0:
		return
	if not paid:
		state.status = "SUSPENDED"
		return
	state.paid += state.construction_payable
	state.construction_payable = 0
	if state.elapsed_minutes == state.duration_minutes:
		state.status = "COMPLETED"
		state.completed_at = minute


func validate_at(minute: int) -> void:
	if state.procedure.is_empty() or minute < int(state.procedure_completes_at):
		return
	var action: String = state.procedure
	state.procedure = ""
	if state.procedure_revision != state.condition_revision:
		return
	match action:
		"trial":
			state.trial_status = "PASSED"
		"safety":
			if state.mode == "FAST" and not state.first_defect_issued:
				state.first_defect_issued = true
				state.defects = 1
				state.safety_status = "FAILED"
			else:
				state.safety_status = "PASSED"
		"repair":
			state.defects = 0
			state.safety_status = "NOT_STARTED"


## 후속 조건 변경 어댑터용. 플레이어 조건 편집 기능은 이 티켓에 없다.
func invalidate_conditions() -> void:
	state.condition_revision += 1
	state.trial_status = "NOT_STARTED"
	state.safety_status = "NOT_STARTED"
	if state.procedure != "repair":
		state.procedure = ""
	if state.status == "OPEN":
		state.status = "COMPLETED"
		state.opened_at = null
