extends SceneTree
## Design용 검증 실행기. 사례 전환/지연 응답은 제품 UI에서 제공하지 않는다.

const Fixtures = preload("res://tests/game/w07_ui_fixtures.gd")
const Stage1 = preload("res://scenes/stage1.tscn")

var _view: Control
var _picker: OptionButton


func _initialize() -> void:
	call_deferred("_build")


func _build() -> void:
	root.title = "MetroManager · 검증 전용"
	var shell := VBoxContainer.new()
	shell.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(shell)
	var tools := HBoxContainer.new()
	shell.add_child(tools)
	var banner := Label.new()
	banner.text = "DEV-015 검증 전용 · 제품 데이터 아님"
	tools.add_child(banner)
	_picker = OptionButton.new()
	for id: String in Fixtures.CASES:
		_picker.add_item(id)
	_picker.item_selected.connect(_choose)
	tools.add_child(_picker)
	var next := Button.new()
	next.text = "다음 검증 사례"
	next.pressed.connect(
		func() -> void:
			var index: int = (_picker.selected + 1) % Fixtures.CASES.size()
			_picker.select(index)
			_choose(index)
	)
	tools.add_child(next)
	var delayed := Button.new()
	delayed.text = "낡은 예측 응답 검증"
	delayed.pressed.connect(_late_response)
	tools.add_child(delayed)
	_view = Stage1.instantiate()
	_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_view.session = Fixtures.create(Fixtures.CASES[0])
	shell.add_child(_view)
	print("W07_CASE_READY ", Fixtures.CASES[0])


func _choose(index: int) -> void:
	_view.session = Fixtures.create(Fixtures.CASES[index])
	_view.reset_observation()
	print("W07_CASE_READY ", Fixtures.CASES[index])


func _late_response() -> void:
	var state: Dictionary = _view.session.prediction.snapshot()
	var accepted: bool = _view.session.prediction.complete(
		state.prediction_input_revision - 1, {"ok": true}, _view.session.pipeline.clock.minute
	)
	print("W07_LATE_RESPONSE accepted=", accepted)
	_view.present(_view.session.snapshot())
