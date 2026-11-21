extends RefCounted
## 순수 모델 검사용 조립 입력. GUI 명령/제품 초기화에 강제 결과 통로를 추가하지 않는다.

const Loader = preload("res://scripts/data/proposal_data_loader.gd")
const Data = preload("res://scripts/data/gate2_data_loader.gd")
const Network = preload("res://scripts/model/administrative_network.gd")
const Service = preload("res://scripts/simulation/proposal_service.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const ROUTE_A: Array[String] = ["S01", "S02", "S03", "S04", "S08", "S12"]
const ROUTE_B: Array[String] = ["S01", "S05", "S09", "S10", "S11", "S12"]
const ROUTE_8: Array[String] = ["S01", "S02", "S06", "S05", "S09", "S10", "S11", "S12"]


static func bundle(
	seed_value: int = 0, minute: int = 360, parameters: Dictionary = {}
) -> Dictionary:
	var ledger := Ledger.new()
	var params := parameters if not parameters.is_empty() else Predictor.load_parameters()
	return {
		"ledger": ledger,
		"service":
		(
			Service
			. new(
				Network.new(Data.load_data().data),
				Loader.load_data().data,
				{
					"run_scope": "P1-MODEL",
					"seed": seed_value,
					"completed_minute": minute,
					"ledger": ledger,
					"parameters": params,
				}
			)
		),
	}


static func prepare(service: Service, slot: String = "P-A", stops: Array[String] = ROUTE_A) -> void:
	service.edit(slot, stops, "proposal " + slot)
	service.predict(slot)


static func row(service: Service, slot: String = "P-A") -> Dictionary:
	for value: Dictionary in service.snapshot().proposals:
		if value.identity.slot_id == slot:
			return value
	return {}


static func command(
	service: Service, id: String, action: String = "submit_city_review", slot: String = "P-A"
) -> Dictionary:
	var item := row(service, slot)
	var value := {
		"command_id": id,
		"run_scope": service.snapshot().run_scope,
		"slot_id": slot,
		"action": action,
		"binding": item.binding,
		"expected_snapshot_revision": 0,
	}
	if action != "submit_city_review":
		var kind := "CITY" if action == "submit_government_review" else "GOVERNMENT"
		for index: int in range(item.decisions.size() - 1, -1, -1):
			var decision: Dictionary = item.decisions[index]
			var contract: bool = action == "sign_proposal_contract" and decision.kind != "CITY"
			if contract or decision.kind == kind:
				value.decision_id = decision.decision_id
				break
		if not value.has("decision_id"):
			value.decision_id = ""
	return value


static func city(service: Service, slot: String = "P-A", id: String = "city") -> Dictionary:
	var submitted := service.submit(command(service, id, "submit_city_review", slot))
	service.advance_to(int(service.snapshot().simulation_minute) + 31)
	return submitted


static func government(service: Service, slot: String = "P-A") -> void:
	service.submit(command(service, "government-" + slot, "submit_government_review", slot))
	service.advance_to(int(service.snapshot().simulation_minute) + 61)


static func last(service: Service, slot: String = "P-A") -> Dictionary:
	var decisions: Array = row(service, slot).decisions
	return {} if decisions.is_empty() else decisions.back()


## 고정 엔진의 정상 RNG로 분기 seed를 찾는다. 판정값을 Service에 주입하지 않는다.
static func seeds() -> Dictionary:
	var found: Dictionary = {}
	for candidate: int in range(10000):
		var rng := RandomNumberGenerator.new()
		rng.seed = candidate
		var first := rng.randi_range(0, 99)
		var second := rng.randi_range(0, 99)
		var key := "DIRECT" if first < 70 else ("REJECT" if first >= 90 else "HELD_FAIL")
		if first >= 70 and first < 90 and second < 60:
			key = "HELD_SUCCESS"
		if not found.has(key):
			found[key] = {"seed": candidate, "samples": [first, second]}
		if found.size() == 4:
			break
	return found


static func negative_parameters() -> Dictionary:
	var params := Predictor.load_parameters()
	for key: String in params.daily_demand:
		params.daily_demand[key] = 0
	return params
