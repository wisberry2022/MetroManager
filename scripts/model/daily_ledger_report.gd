class_name DailyLedgerReport
extends RefCounted
## 발생/현금 일자를 effective_at으로 집계하고 마감 보고는 변경하지 않는다.

var _seen: int = 0
var _days: Dictionary = {}
var _closed: Dictionary = {}


func sync(entries: Array[Dictionary]) -> void:
	for index: int in range(_seen, entries.size()):
		var item: Dictionary = entries[index]
		var day: int = item.effective_at / 1440 + 1
		if _closed.has(day):
			continue
		if not _days.has(day):
			_days[day] = {
				"day_id": day,
				"operating_cost": 0,
				"construction_cost": 0,
				"fare": 0,
				"government": 0,
				"payment": 0,
				"debt_payment": 0,
				"construction_payment": 0
			}
		_days[day][item.kind] += item.amount
	_seen = entries.size()


func close(day: int, funds: Dictionary) -> void:
	if not _closed.has(day):
		var report: Dictionary = _days.get(day, _blank(day)).duplicate(true)
		report.closing_funds = funds.duplicate(true)
		_closed[day] = report


func report(day: int) -> Dictionary:
	return _closed.get(day, {}).duplicate(true)


func current(day: int) -> Dictionary:
	return _days.get(day, _blank(day)).duplicate(true)


func _blank(day: int) -> Dictionary:
	return {
		"day_id": day,
		"operating_cost": 0,
		"construction_cost": 0,
		"fare": 0,
		"government": 0,
		"payment": 0,
		"debt_payment": 0,
		"construction_payment": 0
	}
