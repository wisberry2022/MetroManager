class_name GameClock
extends RefCounted
## 현실 마이크로초를 12/5000000 게임분으로 누적한다. 정지 중 입력은 소비하지 않는다.

var minute: int = 360
var paused: bool = false
var speed: int = 1
var remainder: int = 0


func _init(start_minute: int = 360) -> void:
	minute = start_minute


func set_speed(value: int) -> bool:
	if value not in [1, 2, 4]:
		return false
	speed = value
	return true


func advance_usec(elapsed: int) -> int:
	if elapsed < 0 or paused:
		return 0
	remainder += elapsed * 12 * speed
	var steps: int = remainder / 5000000
	remainder %= 5000000
	minute += steps
	return steps


func snapshot() -> Dictionary:
	return {
		"simulation_minute": minute,
		"day_id": minute / 1440 + 1,
		"remainder": remainder,
		"paused": paused,
		"speed": speed
	}
