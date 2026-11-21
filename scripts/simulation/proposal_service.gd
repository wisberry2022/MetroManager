class_name ProposalService
extends RefCounted
## P1 단독 모델 실행 경계. 제품 Pipeline/Session, E01 수요 효과와 화면은 아직 연결하지 않는다.

const Loader = preload("res://scripts/data/proposal_data_loader.gd")
const Network = preload("res://scripts/model/administrative_network.gd")
const Proposal = preload("res://scripts/model/company_proposal.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const ACTIONS := {
	"submit_city_review": "CITY",
	"submit_government_review": "GOVERNMENT",
	"submit_persuasion": "PERSUASION",
	"sign_proposal_contract": "CONTRACT",
}

var _models: Dictionary = {}
var _terms: Dictionary = {}
var _scope: String = ""
var _minute: int = 360
var _revision: int = 0
var _seed: int = 0
var _rng := RandomNumberGenerator.new()
var _ledger: Ledger
var _pending: Array[Dictionary] = []
var _commands: Dictionary = {}
var _reviews: Array[Dictionary] = []
var _draws: Array[Dictionary] = []
var _links: Dictionary = {}
var _errors: Array[String] = []


## context의 parameters/ledger는 모델 조립 입력이며 UI 명령으로 바꿀 수 없다.
func _init(network: Network, data: Dictionary, context: Dictionary) -> void:
	var checked := Loader.validate_data(data)
	if not checked.ok or not network.valid() or not _valid_context(context):
		_errors = ["INVALID_PROPOSAL_CONTEXT"]
		return
	_terms = checked.data
	_scope = context.run_scope
	_minute = context.completed_minute
	_seed = context.seed
	_rng.seed = _seed
	_ledger = context.get("ledger", Ledger.new())
	var parameters: Dictionary = context.get("parameters", Predictor.load_parameters())
	for slot: String in _terms.slot_ids:
		_models[slot] = (
			Proposal
			. new(
				network,
				{
					"slot_id": slot,
					"proposal_id": _scope + ":proposal:" + slot,
					"business_identity_id": _scope + ":business:" + slot,
				},
				parameters
			)
		)
		_links[slot] = []


func edit(slot: String, stops: Array[String], name: String = "") -> Dictionary:
	if not _models.has(slot):
		return {"accepted": false, "reason": "INVALID_SLOT"}
	var changed: Dictionary = _models[slot].edit(stops, name, _minute)
	if changed.accepted:
		_revision += 1
	return changed


func predict(slot: String) -> Dictionary:
	if not _models.has(slot):
		return {"accepted": false, "reason": "INVALID_SLOT"}
	var result: Dictionary = _models[slot].predict(_minute)
	_revision += 1
	return result


## command_id는 실행 소속 안에서 멱등이다. 당시 제출 사본은 이후 초안과 별도 보관한다.
func submit(command: Dictionary) -> Dictionary:
	var id: Variant = command.get("command_id")
	if (
		not id is String
		or id.is_empty()
		or not command.get("run_scope") is String
		or command.run_scope != _scope
	):
		return {"accepted": false, "pending": false, "reason": "INVALID_COMMAND_SCOPE"}
	if _commands.has(id):
		return _commands[id].duplicate(true)
	var reason := _command_error(command)
	var record := {
		"command_id": id,
		"command": command.duplicate(true),
		"requested_at": _minute,
		"registered_at": null,
		"admitted_at": null,
		"effective_at": null,
		"effective_not_before": next_office_minute(_minute),
		"pending": reason.is_empty(),
		"accepted": false,
		"reason": reason,
		"reason_codes": [] if reason.is_empty() else [reason],
	}
	if reason.is_empty():
		record.registered_at = _minute
		record.submission = _models[command.slot_id].submission()
		_pending.append(record.duplicate(true))
	_commands[id] = record
	_revision += 1
	return record.duplicate(true)


func result(id: String) -> Dictionary:
	return _commands.get(id, {}).duplicate(true)


## 호출자가 완료 게임분을 단조롭게 공급한다. 같은 분은 무효과이며 후퇴는 거부한다.
func advance_to(completed_minute: int) -> Dictionary:
	if not _errors.is_empty() or completed_minute < _minute:
		return {"accepted": false, "reason": "INVALID_TIME_OR_CONTEXT"}
	for minute: int in range(_minute + 1, completed_minute + 1):
		_minute = minute
		_complete_due()
		_admit_due()
	return {"accepted": true, "completed_minute": _minute}


func snapshot() -> Dictionary:
	var rows: Array[Dictionary] = []
	for slot: String in _models:
		var row: Dictionary = _models[slot].snapshot()
		var actions: Dictionary = {}
		for action: String in ACTIONS:
			var reason := _action_error(slot, ACTIONS[action])
			actions[action] = {"allowed": reason.is_empty(), "reason_codes": [reason]}
			if reason.is_empty():
				actions[action].reason_codes = []
		row.action_states = actions
		row.business_alias_slots = _related_slots(slot)
		row.di03_status = "DEPENDENT_SCOPE_PENDING"
		rows.append(row)
	return {
		"available": _errors.is_empty(),
		"errors": _errors.duplicate(),
		"schema_version": Loader.SCHEMA,
		"data_version": "1.4",
		"rules_version": Loader.RULES,
		"run_scope": _scope,
		"snapshot_revision": _revision,
		"simulation_minute": _minute,
		"proposals": rows,
		"commands": _commands.values().duplicate(true),
		"rng":
		{
			"seed": str(_seed),
			"state": str(_rng.state),
			"draw_count": _draws.size(),
			"draws": _draws.duplicate(true),
			"engine": Engine.get_version_info().string,
		},
		"fact_supply": {"available": false, "status": "DI03_PENDING", "facts": []},
	}


static func next_office_minute(completed: int) -> int:
	var candidate := completed + 1
	return candidate + maxi(0, 360 - candidate % 1440)


func _valid_context(context: Dictionary) -> bool:
	return (
		context.get("run_scope") is String
		and not context.run_scope.is_empty()
		and context.get("seed") is int
		and context.get("completed_minute") is int
		and context.completed_minute >= 0
		and (not context.has("ledger") or context.ledger is Ledger)
		and (not context.has("parameters") or context.parameters is Dictionary)
	)


func _command_error(command: Dictionary) -> String:
	if not _errors.is_empty():
		return "INVALID_PROPOSAL_CONTEXT"
	if not command.get("slot_id") is String or not _models.has(command.slot_id):
		return "INVALID_SLOT"
	if not command.get("action") is String or not ACTIONS.has(command.action):
		return "INVALID_ACTION"
	for key: Variant in command:
		if (
			key
			not in [
				"command_id",
				"run_scope",
				"slot_id",
				"action",
				"binding",
				"decision_id",
				"expected_snapshot_revision"
			]
		):
			return "UNSUPPORTED_COMMAND_FIELD"
	return _binding_error(command)


func _binding_error(command: Dictionary) -> String:
	var kind: String = ACTIONS[command.action]
	var model: Proposal = _models[command.slot_id]
	if kind in ["CITY", "GOVERNMENT"]:
		if not command.get("binding") is Dictionary or command.binding != model.binding():
			return "STALE_PLAN_OR_PREDICTION"
	if kind != "CITY":
		var decision := _target_decision(model, kind)
		if (
			not command.get("decision_id") is String
			or decision.is_empty()
			or command.decision_id != decision.get("decision_id", "")
		):
			return "STALE_DECISION"
	return _action_error(command.slot_id, kind)


func _action_error(slot: String, kind: String) -> String:
	var model: Proposal = _models[slot]
	var row := model.snapshot()
	var related := _related_slots(slot)
	var identity_error := _identity_error(row, related)
	if not identity_error.is_empty():
		return identity_error
	if kind == "CITY":
		return model.preparation_error()
	if kind in ["GOVERNMENT", "PERSUASION"]:
		return _review_eligibility(model, kind, related)
	var permit := _target_decision(model, "CONTRACT")
	if permit.get("outcome") != "APPROVED":
		return "PERMISSION_REQUIRED"
	var funds := _ledger.snapshot()
	if not funds.restricted_by_project.is_empty() or not funds.reserved_by_project.is_empty():
		return "PROJECT_IN_PROGRESS"
	return ""


func _identity_error(row: Dictionary, related: Array[String]) -> String:
	if not row.review.is_empty():
		return "REVIEW_IN_PROGRESS"
	if not row.business_contract.is_empty():
		return "BUSINESS_ALREADY_CONTRACTED"
	for other: String in related:
		var other_row: Dictionary = _models[other].snapshot()
		if not other_row.review.is_empty():
			return "BUSINESS_REVIEW_IN_PROGRESS"
		if not other_row.business_contract.is_empty():
			return "BUSINESS_ALREADY_CONTRACTED"
	return ""


func _review_eligibility(model: Proposal, kind: String, related: Array[String]) -> String:
	if kind == "GOVERNMENT":
		var prep := model.preparation_error()
		if not prep.is_empty():
			return prep
		var city := model.latest_decision("CITY")
		if city.get("outcome") != "APPROVED" or city.submission.binding != model.binding():
			return "CURRENT_CITY_APPROVAL_REQUIRED"
		return _government_error(related)
	if kind == "PERSUASION":
		var held := model.latest_decision("GOVERNMENT")
		if held.get("outcome") != "HELD":
			return "HELD_DECISION_REQUIRED"
		if held.decision_id in model.snapshot().persuasion_used_for:
			return "PERSUASION_ALREADY_USED"
	return ""


func _government_error(related: Array[String]) -> String:
	var latest: Dictionary = {}
	for slot: String in related:
		var row: Dictionary = _models[slot].snapshot()
		for decision: Dictionary in row.decisions:
			if decision.kind == "CITY":
				continue
			if latest.is_empty() or decision.decision_order > latest.decision_order:
				latest = decision
	if latest.is_empty():
		return ""
	if latest.outcome == "APPROVED":
		return "BUSINESS_ALREADY_AUTHORIZED"
	if latest.outcome == "HELD":
		return "PERSUASION_REQUIRED"
	return "NEW_FACT_REQUIRED_DI03_PENDING"


func _target_decision(model: Proposal, kind: String) -> Dictionary:
	if kind == "GOVERNMENT":
		return model.latest_decision("CITY")
	if kind == "PERSUASION":
		return model.latest_decision("GOVERNMENT")
	var row := model.snapshot()
	for index: int in range(row.decisions.size() - 1, -1, -1):
		var decision: Dictionary = row.decisions[index]
		if decision.kind in ["GOVERNMENT", "PERSUASION"]:
			return decision
	return {}


func _related_slots(slot: String) -> Array[String]:
	var related: Array[String] = [slot]
	var keys: Array = _links[slot].duplicate()
	var current: Dictionary = _models[slot].submission()
	keys.append(Proposal.station_key(current.plan.station_ids))
	# 과거 접수 계획의 무순서 집합을 연결하여 슬롯 계보를 잃지 않고 추적한다.
	var changed := true
	while changed:
		changed = false
		for other: String in _links:
			if other in related:
				continue
			for key: String in _links[other]:
				if key in keys:
					related.append(other)
					keys.append_array(_links[other])
					changed = true
					break
	related.sort()
	return related


func _admit_due() -> void:
	var remaining: Array[Dictionary] = []
	for record: Dictionary in _pending:
		if record.effective_not_before > _minute:
			remaining.append(record)
			continue
		var command: Dictionary = record.command
		var reason := _command_error(command)
		record.pending = false
		record.effective_at = _minute
		if reason.is_empty():
			if ACTIONS[command.action] == "CONTRACT":
				reason = _sign_contract(command)
			else:
				_start_review(command, record)
		record.accepted = reason.is_empty()
		record.reason = reason
		record.reason_codes = [] if reason.is_empty() else [reason]
		record.admitted_at = _minute if reason.is_empty() else null
		record.requires_new_request = not reason.is_empty()
		_commands[command.command_id] = record.duplicate(true)
		_revision += 1
	_pending = remaining


func _start_review(command: Dictionary, record: Dictionary) -> void:
	var model: Proposal = _models[command.slot_id]
	var kind: String = ACTIONS[command.action]
	var submitted: Dictionary = record.submission
	var target := _target_decision(model, kind)
	if kind == "PERSUASION":
		submitted = target.submission.duplicate(true)
	var review := {
		"review_id": _scope + ":review:%06d" % (_reviews.size() + 1),
		"review_order": _reviews.size(),
		"kind": kind,
		"slot_id": command.slot_id,
		"command_id": command.command_id,
		"submission": submitted,
		"requested_at": record.requested_at,
		"registered_at": record.registered_at,
		"admitted_at": _minute,
		"completes_at": _minute + int(_terms[kind.to_lower() + "_minutes"]),
		"target_decision_id": target.get("decision_id", ""),
		"completed": false,
	}
	record.review_id = review.review_id
	_reviews.append(review)
	var key := Proposal.station_key(submitted.plan.station_ids)
	if key not in _links[command.slot_id]:
		_links[command.slot_id].append(key)
	model.admit(review)


func _complete_due() -> void:
	for review: Dictionary in _reviews:
		if review.completed or review.completes_at != _minute:
			continue
		var decision := review.duplicate(true)
		decision.decision_id = review.review_id + ":decision"
		decision.decision_order = _revision
		decision.completed_at = _minute
		decision.business_identity_id = review.submission.identity.business_identity_id
		decision.outcome = _outcome(review, decision.decision_id)
		decision.authorized_government = 0
		if review.kind != "CITY" and decision.outcome == "APPROVED":
			decision.authorized_government = (
				_terms.government if review.kind == "GOVERNMENT" else _terms.persuasion_government
			)
		if review.kind != "CITY" and decision.outcome == "REJECTED":
			decision.fact_pending = {
				"status": "DI03_PENDING",
				"earliest_at": _minute + _terms.fact_delay_minutes,
				"decision_id": decision.decision_id,
				"fact_created": false,
			}
		review.completed = true
		decision.completed = true
		_models[review.slot_id].complete(decision)
		_revision += 1


func _outcome(review: Dictionary, decision_id: String) -> String:
	if review.kind == "CITY":
		var totals: Dictionary = review.submission.prediction.current.value.totals
		return Proposal.city_outcome(int(totals.predicted_fare) - int(totals.operating_cost))
	var before := _rng.state
	var sample := _rng.randi_range(0, 99)
	var outcome := (
		Proposal.government_outcome(sample)
		if review.kind == "GOVERNMENT"
		else Proposal.persuasion_outcome(sample)
	)
	(
		_draws
		. append(
			{
				"draw_index": _draws.size() + 1,
				"seed": str(_seed),
				"state_before": str(before),
				"state_after": str(_rng.state),
				"sample": sample,
				"domain": [0, 99],
				"outcome": outcome,
				"kind": review.kind,
				"review_id": review.review_id,
				"decision_id": decision_id,
				"command_id": review.command_id,
				"minute": _minute,
				"phase": "REVIEW_COMPLETE",
			}
		)
	)
	return outcome


func _sign_contract(command: Dictionary) -> String:
	var model: Proposal = _models[command.slot_id]
	var permit := _target_decision(model, "CONTRACT")
	var project: String = permit.business_identity_id
	var effect := _ledger.contract(
		project, permit.authorized_government, _terms.standard_cost, _minute
	)
	if not effect.accepted:
		return effect.reason
	var contract_id: String = permit.decision_id + ":business"
	(
		model
		. record_contract(
			{
				"status": "EFFECTIVE",
				"business_contract_id": contract_id,
				"source_kind": "COMPANY_PROPOSAL",
				"source_id": permit.submission.identity.proposal_id,
				"project_id": project,
				"slot_id": command.slot_id,
				"effective_at": _minute,
				"decision_id": permit.decision_id,
				"command_id": command.command_id,
				"permitted_plan": permit.submission.duplicate(true),
				"standard_cost": _terms.standard_cost,
				"duration_minutes": _terms.duration_minutes,
				"fare": _terms.fare,
				"result": effect,
				"government_payment":
				{
					"available": true,
					"amount": permit.authorized_government,
					"effective_at": _minute,
					"ledger_entry_index": _ledger.entries().size() - 1,
					"transaction_id": contract_id + ":government",
					"restricted_project_id": project,
				},
			}
		)
	)
	return ""
