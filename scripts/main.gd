extends Control
## 승인 데이터의 초기화 결과만 관찰하는 W01 메인 진입점.

const DataLoader = preload("res://scripts/data/gate2_data_loader.gd")
const CompanyState = preload("res://scripts/model/initial_company_state.gd")

@onready var _status: Label = $Margin/Status


func _ready() -> void:
	var loaded := DataLoader.load_data()
	if not loaded.ok:
		_fail(loaded.errors)
		return
	var initialized := CompanyState.from_data(loaded.data)
	if not initialized.ok:
		_fail(initialized.errors)
		return
	var state: Dictionary = initialized.state
	_status.text = (
		(
			"MetroManager — W01\n초기화 완료 / DATA %s\n"
			+ "도시 %s / 1도 · 1시 · 4구 · 8동 · 후보역 12\n"
			+ "시작일 %d / 06:00 (초기값)\n"
			+ "C %d / R 0 / F %d / K 0 / A %d / B %d\n"
			+ "이행능력 %d / 재무점수 %d\n\nW01 초기 상태 확인 — 시간 진행·거래·노선 조작 미구현"
		)
		% [
			state.data_version,
			state.city_id,
			state.day_id,
			state.cash,
			state.free_cash,
			state.available_cash,
			state.unpaid,
			state.capability,
			state.financial_score,
		]
	)
	print("W01_INIT_OK ", JSON.stringify(state))


func _fail(errors: Array) -> void:
	_status.text = "MetroManager — W01 초기화 실패\n" + ", ".join(errors)
	printerr("W01_INIT_FAILED ", JSON.stringify(errors))
	# 화면 실패 표시는 한 프레임 그린 후 종료한다. headless에서도 종료1을 보존한다.
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().quit(1)
