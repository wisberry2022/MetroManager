extends "res://scripts/simulation/minute_pipeline.gd"
## 테스트 전용 확정 지급 사건. 플레이어 명령 큐나 제품 실행 경로를 변경하지 않는다.


class TrackedReports:
	extends "res://scripts/model/daily_ledger_report.gd"

	var close_calls: Dictionary = {}

	func close(day: int, funds: Dictionary) -> void:
		close_calls[day] = close_calls.get(day, 0) + 1
		super.close(day, funds)


var payment_result: Dictionary = {}
var before_payment: Dictionary = {}
var closed_before_payment: Dictionary = {}
var payment_dispatches: int = 0


func _init() -> void:
	super({"cash": 100}, 1439)
	reports = TrackedReports.new()


func close_calls() -> Dictionary:
	return (reports as TrackedReports).close_calls.duplicate()


func _stage(minute: int, phase: String) -> void:
	super._stage(minute, phase)
	if minute == 1440 and phase == "CONTRACT":
		# 승인된 내부 확정 사건만 이 단계에 공급한다. 플레이어 신규 계약이 아니다.
		closed_before_payment = reports.report(1)
		before_payment = ledger.snapshot()
		payment_dispatches += 1
		payment_result = ledger.contract("MIDNIGHT", 80, 80, minute)
