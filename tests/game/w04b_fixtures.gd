extends RefCounted
## 순수 모델 검사용 조립 입력. GUI 명령/제품 초기화에 강제 결과 통로를 추가하지 않는다.

const Loader = preload("res://scripts/data/proposal_data_loader.gd")
const Data = preload("res://scripts/data/gate2_data_loader.gd")
const Network = preload("res://scripts/model/administrative_network.gd")
const Service = preload("res://scripts/simulation/proposal_service.gd")
const Predictor = preload("res://scripts/simulation/demand_predictor.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const Session = preload("res://scripts/ui/stage1_session.gd")
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


## P1에서 확보한 네 seed만 재사용한다. 새 탐색이나 Service 판정 주입은 하지 않는다.
static func seeds() -> Dictionary:
	var found: Dictionary = {}
	for candidate: int in [2, 0, 8, 1]:
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


static func session(seed_value: int = 2, minute: int = 360, params: Dictionary = {}) -> Session:
	var data: Dictionary = Data.load_data().data
	var initial: Dictionary = data.initial_company.duplicate(true)
	initial.simulation_minute = minute
	var value := Session.new(data, initial, params)
	value.enable_proposals(seed_value)
	return value


static func session_row(value: Session, slot: String = "P-A") -> Dictionary:
	for item: Dictionary in value.snapshot().proposal_ui.snapshot.proposals:
		if item.identity.slot_id == slot:
			return item
	return {}


static func session_command(
	value: Session, id: String, action: String, slot: String = "P-A"
) -> Dictionary:
	var item := session_row(value, slot)
	var cmd := {
		"command_id": id,
		"run_scope": value.observation_scope(),
		"slot_id": slot,
		"action": action,
		"binding": item.binding
	}
	if action in ["edit_proposal", "predict_proposal"]:
		if action == "edit_proposal":
			cmd.station_ids = ROUTE_A.duplicate()
			cmd.name = "P3-A " + slot
		return cmd
	cmd.expected_snapshot_revision = value.snapshot().proposal_ui.snapshot.snapshot_revision
	if action != "submit_city_review":
		var kind := "CITY" if action == "submit_government_review" else "GOVERNMENT"
		cmd.decision_id = ""
		for index: int in range(item.decisions.size() - 1, -1, -1):
			var decision: Dictionary = item.decisions[index]
			if (
				decision.kind == kind
				or (action == "sign_proposal_contract" and decision.kind != "CITY")
			):
				cmd.decision_id = decision.decision_id
				break
	return cmd


static func session_prepare(value: Session, prefix: String = "prepare") -> void:
	value.request_proposal(session_command(value, prefix + "-edit", "edit_proposal"))
	value.request_proposal(session_command(value, prefix + "-predict", "predict_proposal"))


## 실제 GameClock 입력을 환산한다. 시계/모델 상태를 직접 대입하지 않는다.
static func advance(value: Session, target: int) -> void:
	var clock := value.pipeline.clock
	var delta := target - clock.minute
	if delta > 0:
		value.advance_usec(
			(delta * 5000000 - clock.remainder + 12 * clock.speed - 1) / (12 * clock.speed)
		)


static func sample(value: Session) -> Dictionary:
	var state := value.snapshot()
	state.current.erase("trace")
	return {"kind": "ACTUAL_SESSION_API", "state": state, "ledger": value.pipeline.ledger.entries()}


static func save(output: String, record: Dictionary) -> bool:
	DirAccess.make_dir_recursive_absolute(output.get_base_dir())
	var file := FileAccess.open(output, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(record, "\t") + "\n")
	return true
