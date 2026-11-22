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
	var operations: Dictionary = view.session.enable_operations_ui()
	print("DEV023_ACTIVATION ", JSON.stringify(operations))
	var seed_choice := proposal_seed(OS.get_cmdline_user_args())
	if seed_choice.accepted:
		var proposals: Dictionary = view.session.enable_proposals(seed_choice.seed)
		print(
			"DEV027_ACTIVATION ",
			JSON.stringify({"seed": str(seed_choice.seed), "result": proposals})
		)
	else:
		push_warning("W04B 초기 seed 인수가 유효하지 않아 회사 제안 진입을 활성화하지 않았습니다")
	$Margin.hide()
	add_child(view)
	print("W01_INIT_OK ", JSON.stringify(state))
	print("W07_INIT_OK S01_MINIMUM_UI")


## 명시 재현은 기존 네 seed만 받는다. 기본 플레이는 정상 난수 초기화를 사용한다.
static func proposal_seed(arguments: PackedStringArray) -> Dictionary:
	var selected: Variant = null
	for argument: String in arguments:
		if not argument.begins_with("--w04b-seed"):
			continue
		if selected != null or not argument.begins_with("--w04b-seed="):
			return {"accepted": false}
		var value := argument.trim_prefix("--w04b-seed=")
		if value not in ["0", "1", "2", "8"]:
			return {"accepted": false}
		selected = int(value)
	if selected == null:
		var random := RandomNumberGenerator.new()
		random.randomize()
		selected = random.randi()
	return {"accepted": true, "seed": selected}


func _fail(errors: Array) -> void:
	_status.text = "MetroManager — W01 초기화 실패\n" + ", ".join(errors)
	printerr("W01_INIT_FAILED ", JSON.stringify(errors))
	# 화면 실패 표시는 한 프레임 그린 후 종료한다. headless에서도 종료1을 보존한다.
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().quit(1)
