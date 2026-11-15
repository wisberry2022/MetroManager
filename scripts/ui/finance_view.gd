extends VBoxContainer
## P07 현재 재무/고정 보고를 분리하며 조회는 확인 사본만 전달한다.

signal report_requested(day: int)
signal query_requested(confirmed: Dictionary)
signal refresh_requested
signal exit_requested
signal focus_region_requested(region: Control)

const Format = preload("res://scripts/ui/operations_view.gd")
const FUND_NAMES = {
	"cash": "총현금",
	"restricted": "제한현금",
	"free_cash": "자유현금",
	"reserved": "예약금",
	"available_cash": "신규약정 가용금",
	"unpaid": "미지급금"
}
const FLOW_NAMES = {
	"operating_cost": "운영비 발생",
	"payment": "운영비 즉시 지급",
	"debt_payment": "미지급 운영비 후정산",
	"fare": "도착 운임",
	"government": "정부금",
	"construction_cost": "공사비 발생",
	"construction_payment": "공사 기성 지급"
}

var controls: Dictionary = {}
var labels: Dictionary = {}
var shown: Dictionary = {}
var _days: OptionButton
var _range_last: int = -1
var _confirmed: Dictionary = {}
var _first_day: int = -1


func _ready() -> void:
	Format.add_text(self, labels, "title", "재무·보고 · P07")
	Format.add_text(self, labels, "current", "")
	Format.add_text(self, labels, "activity", "")
	Format.add_text(self, labels, "selection", "마감 보고일 선택")
	_days = OptionButton.new()
	_days.name = "ReportDay"
	_days.item_selected.connect(
		func(index: int) -> void: report_requested.emit(_days.get_item_id(index))
	)
	add_child(_days)
	controls["day"] = _days
	Format.add_action(self, controls, "first", "첫 실적 보고 보기", _select_first)
	Format.add_text(self, labels, "report", "")
	Format.add_text(self, labels, "query", "")
	Format.add_text(self, labels, "feedback", "")
	Format.add_action(self, controls, "query", "공고 조회", _query)
	Format.add_action(
		self, controls, "refresh", "자료 다시 확인", func() -> void: refresh_requested.emit()
	)
	Format.add_action(self, controls, "back", "뒤로", func() -> void: exit_requested.emit())
	for button: Control in controls.values():
		button.focus_entered.connect(func() -> void: focus_region_requested.emit(button))
	for id: String in labels:
		labels[id].name = "P07_" + id
	for id: String in controls:
		controls[id].name = "P07_" + id


func present(state: Dictionary) -> bool:
	if Format.is_older(state, shown):
		return false
	shown = state.duplicate(true)
	var outer := Format.packet(state, "finance_ui")
	var report := Format.dictionary(outer.get("report"))
	labels.current.text = Format.failure("재무", outer)
	labels.activity.text = ""
	if outer.get("status") == "READY" and outer.get("available") == true:
		labels.current.text = (
			"현재 재무 · 게임일 %d / 게임분 %d\n%s"
			% [
				outer.observation.day_id,
				outer.observation.simulation_minute,
				funds_text(Format.dictionary(outer.get("current_funds")))
			]
		)
		labels.activity.text = (
			"당일 누계 · 미마감\n" + activity_text(Format.dictionary(outer.get("current_activity")))
		)
	labels.report.text = report_text(report)
	_update_days(outer, report)
	_update_query(Format.packet(state, "next_business_ui"), report)
	return true


func show_result(result: Dictionary) -> void:
	labels.feedback.text = (
		""
		if result.get("accepted") == true
		else Format.reasons([result.get("reason", "UNKNOWN")], "공고")
	)


func _update_days(outer: Dictionary, report: Dictionary) -> void:
	var last: Variant = Format.dictionary(outer.get("report_day_range")).get("last", 0)
	if not last is int or last < 0:
		last = 0
	if last != _range_last:
		_range_last = last
		_days.clear()
		for day: int in range(1, last + 1):
			_days.add_item("마감일 %d" % day, day)
	_days.disabled = last == 0
	for index: int in _days.item_count:
		if _days.get_item_id(index) == report.get("day_id"):
			_days.select(index)


func _update_query(outer: Dictionary, report: Dictionary) -> void:
	_confirmed = {}
	_first_day = -1
	var first := Format.dictionary(outer.get("first_valid_report"))
	var allowed := Format.dictionary(outer.get("allowed_actions"))
	if allowed.get("query") == true and first.get("day_id") is int:
		_first_day = first.day_id
	controls.first.disabled = _first_day < 1
	controls.query.disabled = true
	labels.query.text = Format.reasons(outer.get("reason_codes", []), "공고")
	if outer.get("available") != true or outer.get("status") != "READY":
		return
	labels.query.text = "첫 실적 보고(마감일 %d)를 먼저 표시해 주세요" % _first_day
	var value := Format.dictionary(report.get("value"))
	var operations := Format.dictionary(value.get("operations"))
	if (
		report.get("available") != true
		or report.get("status") != "READY"
		or report.get("display_key", "") != outer.get("report_key")
		or report.get("day_id") != _first_day
		or value.get("day_id") != _first_day
		or operations.get("completed") != first.get("completed")
		or operations.get("service_minutes") != first.get("service_minutes")
		or value.get("fare") != first.get("fare")
		or allowed.get("query") != true
	):
		return
	_confirmed = {"report_key": outer.report_key, "first_valid_report": first.duplicate(true)}
	controls.query.disabled = false
	labels.query.text = "표시한 첫 실적 보고를 근거로 공고 조회 가능 · 실제 응찰 조건은 공고에서 확인"


func _select_first() -> void:
	if _first_day > 0 and is_visible_in_tree():
		report_requested.emit(_first_day)


func _query() -> void:
	if not _confirmed.is_empty() and not controls.query.disabled and is_visible_in_tree():
		query_requested.emit(_confirmed.duplicate(true))


static func funds_text(value: Dictionary) -> String:
	if not Format.numbers(value, FUND_NAMES.keys()):
		return "재무 자료를 확인할 수 없습니다"
	var rows: Array[String] = []
	for key: String in FUND_NAMES:
		rows.append("%s %d" % [FUND_NAMES[key], value[key]])
	for key: String in ["restricted_by_project", "reserved_by_project"]:
		var buckets := Format.dictionary(value.get(key))
		for id: String in buckets:
			rows.append(
				(
					"%s · %s %s"
					% [
						"사업별 제한현금" if key == "restricted_by_project" else "사업별 예약금",
						id,
						str(buckets[id])
					]
				)
			)
	return "게임 통화 단위\n" + "\n".join(rows)


static func activity_text(value: Dictionary) -> String:
	if not Format.numbers(value, FLOW_NAMES.keys()):
		return "재무 자료를 확인할 수 없습니다"
	var rows: Array[String] = []
	for key: String in FLOW_NAMES:
		rows.append("%s %d" % [FLOW_NAMES[key], value[key]])
	if value.payment <= 9223372036854775807 - value.debt_payment:
		rows.append("운영비 지급 합계 %d" % (value.payment + value.debt_payment))
	return "게임 통화 단위\n" + "\n".join(rows)


static func report_text(report: Dictionary) -> String:
	if report.get("status") == "UNAVAILABLE":
		return "마감 보고서 없음"
	if report.get("status") != "READY" or report.get("available") != true:
		return Format.failure("보고", report)
	var value := Format.dictionary(report.get("value"))
	var operations := Format.dictionary(value.get("operations"))
	var text := (
		"고정 과거 보고 · 마감일 %s\n보고 식별 %s\n%s\n마감 자금\n%s"
		% [
			str(report.get("day_id")),
			str(report.get("display_key")),
			activity_text(value),
			funds_text(Format.dictionary(value.get("closing_funds")))
		]
	)
	if not operations.is_empty():
		text += "\n" + Format.daily_text(operations, true)
		text += (
			"\n만족도 전 %s → 마감 %s"
			% [
				Format.fraction(operations.get("satisfaction_before")),
				Format.fraction(
					operations.get("satisfaction_after"),
					operations.get("satisfaction_available", false)
				)
			]
		)
	return text
