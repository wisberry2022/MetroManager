class_name InitialCompanyState
extends RefCounted
## W01의 초기 읽기 상태만 만든다. 진행/거래/동적 snapshot 서비스는 W02 범위다.

const DataLoader = preload("res://scripts/data/gate2_data_loader.gd")


static func from_data(data: Dictionary) -> Dictionary:
	var checked := DataLoader.validate_data(data)
	if not checked.ok:
		return {"ok": false, "state": {}, "errors": checked.errors}
	var initial: Dictionary = checked.data.initial_company
	var state := {
		"data_version": checked.data.data_version,
		"city_id": initial.city_id,
		"cash": int(initial.cash),
		"restricted_by_project": initial.restricted_by_project.duplicate(true),
		"reserved_by_project": initial.reserved_by_project.duplicate(true),
		"unpaid": int(initial.unpaid),
		"free_cash": int(initial.cash),
		"available_cash": int(initial.cash),
		"capability": int(initial.capability),
		"financial_score": int(initial.financial_score),
		"day_id": int(initial.day_id),
		"simulation_minute": int(initial.simulation_minute),
	}
	return {"ok": true, "state": state, "errors": []}
