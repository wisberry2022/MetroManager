extends ScrollContainer
## 세로 바깥 스크롤이 실제로 움직인 휠 입력을 읽기 이력에 포함한다.

var reading_generation: int = 0
var _wheel_at_outer_control: bool = false


func _ready() -> void:
	var bar := get_v_scroll_bar()
	gui_input.connect(_observe_wheel)
	bar.gui_input.connect(_observe_wheel)
	bar.scrolling.connect(_on_vertical_scroll)


func _input(_event: InputEvent) -> void:
	_wheel_at_outer_control = false


static func is_wheel(event: InputEvent) -> bool:
	return (
		event is InputEventMouseButton
		and event.button_index >= MOUSE_BUTTON_WHEEL_UP
		and event.button_index <= MOUSE_BUTTON_WHEEL_RIGHT
	)


func _observe_wheel(event: InputEvent) -> void:
	if is_wheel(event) and event.pressed:
		# GUI 입력 직후 엔진이 이동을 처리한다. 경계에서 멈춘 입력도 같은 프레임에 해제한다.
		_wheel_at_outer_control = true
		set_deferred("_wheel_at_outer_control", false)


func _on_vertical_scroll() -> void:
	if _wheel_at_outer_control:
		_wheel_at_outer_control = false
		reading_generation += 1
		follow_focus = false
