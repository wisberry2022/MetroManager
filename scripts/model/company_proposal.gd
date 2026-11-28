class_name CompanyProposal
extends RefCounted
## 슬롯의 현재 초안과 심사 당시 사본을 분리한다. 순수 모델이며 Session/UI에 연결하지 않는다.

const Network = preload("res://scripts/model/administrative_network.gd")
const Plan = preload("res://scripts/model/route_plan.gd")
const Prediction = preload("res://scripts/model/prediction_state.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")

var _plan: Plan
var _network: Network
var _prediction := Prediction.new()
var _parameters: Dictionary
var _identity: Dictionary
var _demand_profile: Dictionary = {}
var _name: String = ""
var _input_revision: int = 0
var _review: Dictionary = {}
var _decisions: Array[Dictionary] = []
var _contract: Dictionary = {}
var _city_attempts: int = 0
var _government_attempts: int = 0
var _persuasion_attempts: int = 0
var _persuasion_used_for: Array[String] = []


func _init(network: Network, identity: Dictionary, parameters: Dictionary) -> void:
	_network = network
	_plan = Plan.new(network)
	_identity = identity.duplicate(true)
	_parameters = parameters.duplicate(true)


func edit(stops: Array[String], name: String, minute: int) -> Dictionary:
	var before: int = _plan.snapshot().plan_revision
	var result := _plan.replace(stops)
	if not result.accepted:
		return result
	_name = name
	var after: int = _plan.snapshot().plan_revision
	if after != before:
		_input_revision += 1
		_prediction.change_input(after, _input_revision, minute)
	return result


func predict(minute: int) -> Dictionary:
	if not _review.is_empty():
		return {"accepted": false, "reason": "PLAN_LOCKED"}
	var stops: Array[String] = []
	stops.assign(_plan.snapshot().station_ids)
	_prediction.begin()
	# 승인된 W03의 같은 하루 기간을 재사용한다. 회사 원장에는 접근하지 않는다.
	var value := Predictor.predict(_network, stops, _parameters, 360, 1440, {}, _demand_profile)
	if value.ok:
		_prediction.complete(_input_revision, value, minute)
	else:
		_prediction.fail(_input_revision, value.reason)
	return {"accepted": value.ok, "prediction": _prediction.snapshot()}


func update_demand_profile(profile: Dictionary, minute: int) -> bool:
	if profile == _demand_profile:
		return false
	_demand_profile = profile.duplicate(true)
	_input_revision += 1
	_prediction.change_input(_plan.snapshot().plan_revision, _input_revision, minute)
	return true


func binding() -> Dictionary:
	return {
		"proposal_id": _identity.proposal_id,
		"plan_revision": _plan.snapshot().plan_revision,
		"prediction_input_revision": _input_revision,
	}


func submission() -> Dictionary:
	return {
		"identity": _identity.duplicate(true),
		"name": _name,
		"binding": binding(),
		"plan": _plan.snapshot(),
		"prediction": _prediction.snapshot(),
		"demand_profile": _demand_profile.duplicate(true),
	}


func preparation_error() -> String:
	var plan := _plan.snapshot()
	if not plan.validation.valid:
		return "INVALID_PLAN"
	var prediction := _prediction.snapshot()
	if not prediction.available or not prediction.current.get("value", {}).get("ok", false):
		return "PREDICTION_NOT_CURRENT"
	return ""


func latest_decision(kind: String = "") -> Dictionary:
	for index: int in range(_decisions.size() - 1, -1, -1):
		if kind.is_empty() or _decisions[index].kind == kind:
			return _decisions[index].duplicate(true)
	return {}


func latest_authority_decision() -> Dictionary:
	for index: int in range(_decisions.size() - 1, -1, -1):
		if _decisions[index].kind != "CITY":
			return _decisions[index].duplicate(true)
	return {}


func admit(review: Dictionary) -> void:
	_review = review.duplicate(true)
	_plan.lock(true)
	match review.kind:
		"CITY":
			_city_attempts += 1
		"GOVERNMENT":
			_government_attempts += 1
		"PERSUASION":
			_persuasion_attempts += 1
			_persuasion_used_for.append(review.target_decision_id)


func complete(decision: Dictionary) -> void:
	_decisions.append(decision.duplicate(true))
	_review = {}
	_plan.lock(false)


func record_contract(contract: Dictionary) -> void:
	_contract = contract.duplicate(true)


func snapshot() -> Dictionary:
	return {
		"identity": _identity.duplicate(true),
		"name": _name,
		"binding": binding(),
		"draft": submission(),
		"review": _review.duplicate(true),
		"decisions": _decisions.duplicate(true),
		"business_contract": _contract.duplicate(true),
		"persuasion_used_for": _persuasion_used_for.duplicate(),
		"attempts":
		{
			"city": _city_attempts,
			"government": _government_attempts,
			"persuasion": _persuasion_attempts,
		},
	}


static func station_key(stops: Array) -> String:
	var ordered := stops.duplicate()
	ordered.sort()
	return JSON.stringify(ordered)


static func city_outcome(profit: int) -> String:
	return "APPROVED" if profit >= 0 else "REJECTED"


static func government_outcome(sample: int) -> String:
	if sample < 0 or sample > 99:
		return "INVALID_SAMPLE"
	return "APPROVED" if sample < 70 else ("HELD" if sample < 90 else "REJECTED")


static func persuasion_outcome(sample: int) -> String:
	if sample < 0 or sample > 99:
		return "INVALID_SAMPLE"
	return "APPROVED" if sample < 60 else "REJECTED"


## 접수 자격은 발생한 관련 사실과 해당 실패 당시 근거로 확인한다.
static func fact_error(fact: Dictionary, failure: Dictionary, minute: int) -> String:
	for key: String in ["fact_id", "business_identity_id", "decision_id"]:
		if not fact.get(key) is String or fact[key].is_empty():
			return "INVALID_FACT"
	if not fact.get("occurred_at") is int or not fact.get("used") is bool:
		return "INVALID_FACT"
	if (
		not failure.get("completed_at") is int
		or not failure.get("business_identity_id") is String
		or not failure.get("decision_id") is String
	):
		return "INVALID_FAILURE"
	if fact.business_identity_id != failure.get("business_identity_id"):
		return "UNRELATED_FACT"
	if fact.decision_id != failure.get("decision_id"):
		return "UNRELATED_FACT"
	if fact.occurred_at <= failure.completed_at:
		return "FACT_NOT_AFTER_DECISION"
	if fact.occurred_at > minute:
		return "FACT_NOT_OCCURRED"
	return "FACT_ALREADY_USED" if fact.used else ""
