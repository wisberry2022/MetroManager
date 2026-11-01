class_name PredictionState
extends RefCounted
## 현재 입력/이전 결과와 생성 게임시각을 분리한다. 조회는 계산/시간/난수를 진행하지 않는다.

var _input_revision: int = 0
var _plan_revision: int = 0
var _input_minute: int = 0
var _status: String = "NOT_CALCULATED"
var _reason: String = ""
var _current: Dictionary = {}
var _previous: Dictionary = {}


func change_input(plan_revision: int, input_revision: int, minute: int) -> bool:
	if input_revision <= _input_revision:
		return false
	_previous = _current.duplicate(true) if not _current.is_empty() else _previous
	_current = {}
	_plan_revision = plan_revision
	_input_revision = input_revision
	_input_minute = minute
	_status = "NOT_CALCULATED"
	_reason = "INPUT_CHANGED"
	return true


func begin() -> void:
	_status = "CALCULATING"
	_reason = ""


func complete(input_revision: int, result: Dictionary, generated_minute: int) -> bool:
	if input_revision != _input_revision:
		return false
	_current = {
		"value": result.duplicate(true),
		"input_revision": input_revision,
		"generated_minute": generated_minute
	}
	_status = "READY"
	_reason = ""
	return true


func fail(input_revision: int, reason: String) -> bool:
	if input_revision != _input_revision:
		return false
	_status = "FAILED"
	_reason = reason
	_current = {}
	return true


func snapshot() -> Dictionary:
	return {
		"prediction_input_revision": _input_revision,
		"plan_revision": _plan_revision,
		"input_minute": _input_minute,
		"prediction_status": _status,
		"reason": _reason,
		"available": _status == "READY",
		"current": _current.duplicate(true),
		"previous": _previous.duplicate(true)
	}
