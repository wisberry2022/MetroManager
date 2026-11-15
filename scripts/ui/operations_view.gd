extends VBoxContainer
## P06 읽기 전용 소비. 바깥 봉투 실패 시 내부 허용값을 현재 상태로 사용하지 않는다.

signal finance_requested
signal exit_requested
signal focus_region_requested(region: Control)

var controls: Dictionary = {}
var labels: Dictionary = {}
var shown: Dictionary = {}


func _ready() -> void:
	add_text(self, labels, "title", "운영 현황 · P06")
	add_text(self, labels, "status", "")
	add_text(self, labels, "source", "")
	add_text(self, labels, "totals", "")
	add_text(self, labels, "satisfaction", "")
	add_text(self, labels, "prediction", "")
	add_text(self, labels, "notice", "운행 흐름은 대표 표시이며 실제 열차·시민 수와 같지 않습니다.")
	add_action(self, controls, "finance", "재무 상세", func() -> void: finance_requested.emit())
	add_action(self, controls, "back", "뒤로", func() -> void: exit_requested.emit())
	for button: Button in controls.values():
		button.focus_entered.connect(func() -> void: focus_region_requested.emit(button))
	for id: String in labels:
		labels[id].name = "P06_" + id
	for id: String in controls:
		controls[id].name = "P06_" + id


func present(state: Dictionary) -> bool:
	if is_older(state, shown):
		return false
	shown = state.duplicate(true)
	var value := operation(state)
	labels.status.text = summary(state)
	labels.source.text = ""
	labels.totals.text = ""
	labels.satisfaction.text = ""
	if not value.is_empty():
		var source: Dictionary = value.source
		labels.source.text = (
			"현재 관측 · 게임일 %d / 게임분 %d\n사업 %s · 공사 %s · 개통 %s"
			% [
				value.day_id,
				value.simulation_minute,
				source.get("project_id", "없음"),
				source.get("construction_contract_id", "없음"),
				str(source.get("opened_at", "없음"))
			]
		)
		labels.totals.text = daily_text(value.daily) + "\n현재 이동 중 %d통행" % value.in_transit
		var finance := packet(state, "finance_ui")
		var activity := dictionary(finance.get("current_activity"))
		if finance.get("available") == true and numbers(activity, ["fare", "operating_cost"]):
			labels.totals.text += (
				"\n당일 도착 운임 %d / 운영비 발생 %d (게임 통화 단위)" % [activity.fare, activity.operating_cost]
			)
		labels.satisfaction.text = (
			"현재 만족도 %s\n당일 마감 만족도 %s"
			% [
				fraction(value.satisfaction, value.daily.satisfaction_available).trim_prefix(
					"만족도 "
				),
				(
					fraction(value.daily.satisfaction_after, value.daily.satisfaction_available)
					. trim_prefix("만족도 ")
				)
			]
		)
	labels.prediction.text = prediction_text(state.get("prediction", {}))
	return true


static func add_text(parent: Node, into: Dictionary, id: String, text: String) -> void:
	var label := Label.new()
	label.name = id
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(label)
	into[id] = label


static func add_action(
	parent: Node, into: Dictionary, id: String, text: String, callback: Callable
) -> void:
	var button := Button.new()
	button.name = id
	button.text = text
	button.pressed.connect(callback)
	parent.add_child(button)
	into[id] = button


static func dictionary(value: Variant) -> Dictionary:
	return value if value is Dictionary else {}


static func is_older(state: Dictionary, previous: Dictionary) -> bool:
	if previous.is_empty():
		return false
	if state.get("view_revision", -1) < previous.get("view_revision", -1):
		return true
	var current := dictionary(state.get("current"))
	var old := dictionary(previous.get("current"))
	for key: String in ["simulation_minute", "snapshot_revision"]:
		if current.get(key) is int and old.get(key) is int and current[key] < old[key]:
			return true
	return false


static func packet(state: Dictionary, key: String) -> Dictionary:
	var value := dictionary(state.get(key))
	var observation := dictionary(value.get("observation"))
	var current := dictionary(state.get("current"))
	var clock := dictionary(state.get("clock"))
	if value.get("ui_contract_revision") != "DEV023-UI-1":
		return {}
	if value.get("view_revision") != state.get("view_revision"):
		return {}
	for field: String in ["simulation_minute", "day_id", "snapshot_revision"]:
		if not observation.get(field) is int or observation[field] != current.get(field):
			return {}
	if (
		observation.get("data_version") != "1.3"
		or observation.get("observation_phase") != "T_COMPLETE"
		or clock.get("simulation_minute") != observation.get("simulation_minute")
	):
		return {}
	return value


static func numbers(value: Dictionary, keys: Array) -> bool:
	for key: String in keys:
		if not value.get(key) is int or value[key] < 0:
			return false
	return true


static func operation(state: Dictionary) -> Dictionary:
	var outer := packet(state, "operations_ui")
	if outer.get("status") != "READY" or outer.get("available") != true:
		return {}
	var value := dictionary(outer.get("snapshot"))
	var daily := dictionary(value.get("daily"))
	var boarding := dictionary(value.get("boarding"))
	if (
		value.get("available") != true
		or not value.get("service_ready") is bool
		or not boarding.get("boarding_allowed") is bool
		or not value.get("source") is Dictionary
		or not value.get("cohorts") is Array
		or not value.get("od_pairs") is Array
		or not value.get("satisfaction") is Array
		or not numbers(value, ["in_transit", "simulation_minute", "day_id", "snapshot_revision"])
		or not numbers(
			daily,
			[
				"requested",
				"boarded",
				"unboarded",
				"completed",
				"late_completed",
				"service_minutes",
				"opening_in_transit",
				"closing_in_transit"
			]
		)
		or not daily.get("satisfaction_after") is Array
		or not daily.get("satisfaction_available") is bool
	):
		return {}
	for field: String in ["simulation_minute", "day_id", "snapshot_revision"]:
		if value[field] != outer.observation[field]:
			return {}
	return value


static func summary(state: Dictionary) -> String:
	var outer := packet(state, "operations_ui")
	var value := operation(state)
	if value.is_empty():
		if outer.get("status") == "UNAVAILABLE":
			return "운행 자료 없음"
		if outer.get("reason_codes", []) == ["INVALID_OPERATIONS_INPUT"]:
			return "운행 자료를 불러오지 못했습니다"
		return failure("운행", outer)
	var result := "개통 완료" if value.service_ready else "개통 전"
	result += (
		" · 신규 탑승 가능"
		if value.boarding.boarding_allowed
		else " · " + reasons(value.boarding.get("reason_codes", []), "운행")
	)
	return result + "\n이동 중 %d / 당일 완료 %d통행" % [value.in_transit, value.daily.completed]


static func reasons(codes: Variant, target: String) -> String:
	var messages := {
		"SERVICE_NOT_READY": "영업 조건 미충족 — 신규 탑승 불가",
		"OUTSIDE_SERVICE_HOURS": "영업시간 외 — 신규 탑승 불가",
		"UNPAID_BALANCE": "미지급금으로 신규 탑승 제한",
		"SERVICE_FUNDS_INSUFFICIENT": "다음 구간 운영비 부족 — 신규 탑승 제한",
		"REPORT_UNAVAILABLE": "마감 보고서 없음",
		"FIRST_VALID_OPERATIONS_REPORT_REQUIRED": "실제 영업 실적이 있는 첫 마감 보고서가 필요합니다",
		"STATE_CHANGED": "정보가 변경되었습니다. 확인 후 다시 조회해 주세요",
		"OPERATIONS_NOT_ENABLED": "운행 자료 없음",
		"SATISFACTION_ARITHMETIC_LIMIT": "만족도 산출 오류"
	}
	var result: Array[String] = []
	if codes is Array:
		for code: Variant in codes:
			if code is String:
				result.append(messages.get(code, target + " 자료를 확인할 수 없습니다") + " [" + code + "]")
	return " / ".join(result) if not result.is_empty() else target + " 자료를 확인할 수 없습니다"


static func failure(target: String, outer: Dictionary) -> String:
	return target + " 자료를 확인할 수 없습니다\n" + reasons(outer.get("reason_codes", []), target)


static func fraction(value: Variant, available: bool = true) -> String:
	if not available:
		return "만족도 산출 오류"
	if value is Array and value.is_empty():
		return "마감 후 산출"
	if (
		not value is Array
		or value.size() != 2
		or not value[0] is int
		or not value[1] is int
		or value[0] < 0
		or value[1] <= 0
	):
		return "만족도 산출 오류"
	if value[0] % value[1] == 0:
		return "%d점" % (value[0] / value[1])
	return "%d/%d점" % [value[0], value[1]]


static func daily_text(value: Dictionary, closed: bool = false) -> String:
	if not numbers(
		value,
		[
			"requested",
			"boarded",
			"unboarded",
			"completed",
			"late_completed",
			"service_minutes",
			"opening_in_transit",
			"closing_in_transit"
		]
	):
		return "실적 자료를 확인할 수 없습니다"
	return (
		("요청 %d / 탑승 %d / 미탑승 %d / 완료 %d / 늦은 완료 %d통행\n" + "서비스 %d분 · 기초 이동 중 %d / %s 이동 중 %d통행")
		% [
			value.requested,
			value.boarded,
			value.unboarded,
			value.completed,
			value.late_completed,
			value.service_minutes,
			value.opening_in_transit,
			"마감 시점" if closed else "현재",
			value.closing_in_transit
		]
	)


static func prediction_text(value: Dictionary) -> String:
	var current := dictionary(value.get("current"))
	var totals := dictionary(dictionary(current.get("value")).get("totals"))
	if value.get("available") != true or totals.is_empty():
		return "예측 · 자료 없음 / 계획 화면에서 예측 계산 (현재 실적과 별도)"
	var data: Dictionary = current.value
	return (
		"예측 · 계획판 %s / 입력판 %s\n기간 [%s, %s) 게임분 · 생성 %s\n예상 완료 %s통행 / 운임 %s (실적 아님)"
		% [
			str(value.get("plan_revision")),
			str(current.get("input_revision")),
			str(data.get("period_start")),
			str(data.get("period_end")),
			str(current.get("generated_minute")),
			str(totals.get("completed")),
			str(totals.get("predicted_fare"))
		]
	)
