class_name CommandQueue
extends RefCounted
## 닫힌 분 이후의 명령만 접수한다. 동일 ID는 접수/최종 결과를 재사용한다.

var _commands: Dictionary = {}
var _results: Dictionary = {}


func submit(command: Dictionary, completed_minute: int) -> Dictionary:
	var id: Variant = command.get("command_id")
	if not id is String or id.is_empty():
		return {"accepted": false, "reason": "INVALID_COMMAND"}
	if _results.has(id):
		return _results[id].duplicate(true)
	if _commands.has(id):
		return {"pending": true, "command_id": id, "effective_at": _commands[id].effective_at}
	var error := _payload_error(command, completed_minute)
	if not error.is_empty():
		return {"accepted": false, "reason": error}
	var effective: int = command.effective_at
	var copy := command.duplicate(true)
	var day_minute: int = effective % 1440
	if day_minute < 360:
		copy.effective_at += 360 - day_minute
	_commands[id] = copy
	return {"pending": true, "command_id": id, "effective_at": copy.effective_at}


func due(minute: int) -> Array[Dictionary]:
	var ids: Array = _commands.keys()
	ids.sort()
	var found: Array[Dictionary] = []
	for id: String in ids:
		if _commands[id].effective_at == minute:
			found.append(_commands[id].duplicate(true))
	return found


func finish(id: String, result: Dictionary) -> void:
	if _commands.has(id) and not _results.has(id):
		_results[id] = result.duplicate(true)
		_commands.erase(id)


func result(id: String) -> Dictionary:
	return _results.get(id, {}).duplicate(true)


func _payload_error(command: Dictionary, completed_minute: int) -> String:
	var requested: Variant = command.get("requested_at")
	var effective: Variant = command.get("effective_at")
	if not requested is int or not effective is int:
		return "INVALID_TIME"
	if requested > effective or effective <= completed_minute:
		return "CLOSED_EFFECTIVE_TIME"
	if not command.get("target_id") is String or command.target_id.is_empty():
		return "INVALID_TARGET"
	for key: String in ["government", "total_cost", "target_revision"]:
		if not command.get(key) is int or command[key] < 0:
			return "INVALID_PAYLOAD"
	return ""
