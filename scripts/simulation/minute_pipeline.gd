class_name MinutePipeline
extends RefCounted
## W02 고정 분 처리. 미구현 사업/운행은 테스트 입력으로만 경계를 검증한다.

const Clock = preload("res://scripts/simulation/game_clock.gd")
const Queue = preload("res://scripts/simulation/command_queue.gd")
const Ledger = preload("res://scripts/model/company_ledger.gd")
const Reports = preload("res://scripts/model/daily_ledger_report.gd")

var clock: Clock
var commands: Queue = Queue.new()
var ledger: Ledger
var reports: Reports = Reports.new()
var target_revisions: Dictionary = {}
var _events: Dictionary = {}
var _revision: int = 0
var _trace: Array[Dictionary] = []
var _boarding: Dictionary = {}


func _init(initial: Dictionary = {}, start_minute: int = 360) -> void:
	clock = Clock.new(start_minute)
	ledger = Ledger.new(initial)


## 테스트 전용 주입점이며 제품 UI에 연결하지 않는다.
func set_fixture(minute: int, input: Dictionary) -> bool:
	if minute <= clock.minute or _events.has(minute):
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
	return {
		"data_version": "1.3",
		"simulation_minute": clock.minute,
		"day_id": clock.minute / 1440 + 1,
		"snapshot_revision": _revision,
		"observation_phase": "T_COMPLETE",
		"funds": ledger.snapshot(),
		"boarding": _boarding.duplicate(true),
		"trace": _trace.duplicate(true)
	}


func _tick(minute: int) -> void:
	var input: Dictionary = _events.get(minute, {})
	_stage(minute, "PREVIOUS_INTERVAL")
	ledger.operating_cost(input.get("operating_cost", 0), minute - 1)
	reports.sync(ledger.entries())
	if minute % 1440 == 0:
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
	_stage(minute, "PROGRESS")
	for payment: Dictionary in input.get("construction", []):
		ledger.construction_payment(payment.project, payment.amount, minute)
	_stage(minute, "VALIDATION")
	_stage(minute, "ARRIVAL")
	ledger.fare(input.get("arrival_fare", 0), minute)
	_stage(minute, "SETTLEMENT")
	ledger.settle(minute)
	_stage(minute, "BOARDING")
	_boarding = ledger.boarding(minute, input.get("next_cost", 100), input.get("eligible", false))
	reports.sync(ledger.entries())
	_events.erase(minute)
	_revision += 1


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
