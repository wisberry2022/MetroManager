extends Control
## W01 초기화 실패 경계를 보존하며 W07 최소 S01을 연결한다.

const DataLoader = preload("res://scripts/data/gate2_data_loader.gd")
const CompanyState = preload("res://scripts/model/initial_company_state.gd")
const Session = preload("res://scripts/ui/stage1_session.gd")
const Stage1 = preload("res://scenes/stage1.tscn")

@onready var _status: Label = $Margin/Status


func _ready() -> void:
	get_window().title = "MetroManager · S01"
	var loaded := DataLoader.load_data()
	if not loaded.ok:
		_fail(loaded.errors)
		return
	var initialized := CompanyState.from_data(loaded.data)
	if not initialized.ok:
		_fail(initialized.errors)
		return
	var state: Dictionary = initialized.state
	var view := Stage1.instantiate()
	view.session = Session.new(loaded.data, state)
	$Margin.hide()
	add_child(view)
	print("W01_INIT_OK ", JSON.stringify(state))
	print("W07_INIT_OK S01_MINIMUM_UI")


func _fail(errors: Array) -> void:
	_status.text = "MetroManager — W01 초기화 실패\n" + ", ".join(errors)
	printerr("W01_INIT_FAILED ", JSON.stringify(errors))
	# 화면 실패 표시는 한 프레임 그린 후 종료한다. headless에서도 종료1을 보존한다.
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().quit(1)
