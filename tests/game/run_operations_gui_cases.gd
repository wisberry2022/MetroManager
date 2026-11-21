extends SceneTree
## TEST_ONLY: 제품 Host의 자동 소비 검사 또는 실제 GUI 관측용 초기화. 자동 PASS와 실GUI를 구분한다.

const FX = preload("res://tests/game/operations_ui_fixtures.gd")
const Host = preload("res://scenes/stage1.tscn")
const Operations = preload("res://scripts/ui/operations_view.gd")
const Finance = preload("res://scripts/ui/finance_view.gd")
const Main = preload("res://scenes/main.tscn")


class DisplaySession:
	extends "res://scripts/ui/stage1_session.gd"
	var display: Dictionary = {}
	var expected_report_day: int = -1

	func snapshot() -> Dictionary:
		return super.snapshot() if display.is_empty() else display.duplicate(true)

	func finance_report_day() -> int:
		return super.finance_report_day() if expected_report_day < 0 else expected_report_day


var _host: Control
var _session: FX.Session
var _checks: Array[Dictionary] = []
var _failures: int = 0
var _fixture: Dictionary = {}
var _kind: String = "MODEL_CHAIN_SETUP"
var _case_id: String = "first_report"
var _capture_index: int = 0
var _capture_run: String = str(Time.get_unix_time_from_system()).replace(".", "-")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_fixture = _integers(
		JSON.parse_string(
			FileAccess.get_file_as_string("res://docs/engineering/gate3/DEV-023_UI_FIXTURES.json")
		)
	)
	root.size = (
		Vector2i(800, 600) if "--small" in OS.get_cmdline_user_args() else Vector2i(1100, 900)
	)
	root.title = "MetroManager · DEV023 TEST_ONLY"
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--case="):
			_case_id = arg.trim_prefix("--case=")
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure", false, true)
		_finish()
		return
	if "--auto" in OS.get_cmdline_user_args():
		await _automatic()
		_finish()
		return
	if _case_id in ["first_report", "open"]:
		_session = FX.opened().session
		if _case_id == "first_report":
			FX.advance_to(_session, 5760)
	else:
		_kind = "CONSUMER_FIXTURE"
		var packet: Dictionary = (
			_fixture
			. scenarios
			. get("actual_open" if _case_id == "long" else _case_id, {})
			. duplicate(true)
		)
		if _case_id == "long":
			packet.operations_ui.snapshot.satisfaction = [9223372036854775807, 3]
			packet.finance_ui.current_funds.cash = 9223372036854775807
			packet.operations_ui.snapshot.source.construction_contract_id = "긴 공사 식별 정보 ".repeat(20)
		if _case_id.begins_with("l2_"):
			packet = _fixture.l2_supplement.scenarios[_case_id].get("packet", {})
		_session = _display_session(packet, _case_id)
	_session.pipeline.clock.paused = true
	_host = Host.instantiate()
	_host.session = _session
	root.add_child(_host)
	if _kind == "CONSUMER_FIXTURE":
		_host.set_process(false)
	await process_frame
	_host.controls.open_operations.pressed.emit()
	_host.finance_view.controls.query.pressed.connect(_capture.bind("QUERY_RESULT"))
	_host.tender_view.controls.exit.pressed.connect(_capture.bind("TENDER_EXIT"))
	root.window_input.connect(_input_log)
	root.close_requested.connect(_exit_gui)
	_capture("READY")


func _automatic() -> void:
	var main := Main.instantiate()
	root.add_child(main)
	await process_frame
	var product: Control = main.get_child(main.get_child_count() - 1)
	product.set_process(false)
	_expect("U01_product_opt_in", product.session.snapshot().operations_ui.status, "READY")
	_expect("U01_preopen", product.operations_view.labels.status.text.contains("개통 전"), true)
	main.queue_free()
	await process_frame
	_session = FX.opened().session
	FX.advance_to(_session, 5760)
	_session.pipeline.clock.paused = true
	_host = Host.instantiate()
	_host.session = _session
	root.add_child(_host)
	_host.set_process(false)
	await process_frame
	var effects := FX.effects(_session)
	_enter_p05()
	var tender_id: String = _host.tender_view.selected_id
	var history: Dictionary = _host.tender_view._history.duplicate(true)
	_host.tender_view.controls.construction.pressed.emit()
	_expect("U03_actual_completed", _host.shown.operations_ui.snapshot.daily.completed, 4)
	_expect("U04_fixed_completed", _host.finance_view.labels.report.text.contains("완료 4291"), true)
	_expect(
		"U04_current_transit",
		_host.operations_view.labels.totals.text.contains("현재 이동 중 1통행"),
		true
	)
	_expect(
		"U04_fixed_transit", _host.finance_view.labels.report.text.contains("마감 시점 이동 중 5통행"), true
	)
	_host.controls.open_operations.grab_focus()
	_host.controls.open_operations.pressed.emit()
	_expect("U17_open_P06", _host.operations_view.visible, true)
	_host.operations_view.controls.finance.pressed.emit()
	_expect("U17_open_P07", _host.finance_view.visible, true)
	_expect("U17_hidden_P06", _host.operations_view.visible, false)
	_host.finance_view.report_requested.emit(1)
	_expect("U09_selected", _session.snapshot().finance_ui.report.day_id, 1)
	_expect("U13_other_report_blocks_query", _host.finance_view.controls.query.disabled, true)
	_host.finance_view.controls.first.pressed.emit()
	_expect("U13_first_report", _session.snapshot().finance_ui.report.day_id, 4)
	_expect("U13_display_confirmed", _host.finance_view.controls.query.disabled, false)
	_host.finance_view.controls.query.grab_focus()
	await process_frame
	var reading := InputEventKey.new()
	reading.pressed = true
	reading.keycode = KEY_END
	_host._input(reading)
	_expect("U18_End_reads", _host._scroll.scroll_vertical > 0, true)
	reading.keycode = KEY_HOME
	_host._input(reading)
	_expect("U18_Home_reads", _host._scroll.scroll_vertical, 0)
	reading.keycode = KEY_END
	_host._input(reading)
	var report_before: String = _host.finance_view.labels.report.text
	var report_packet: Dictionary = _host.shown.finance_ui.report.duplicate(true)
	var confirmed: Dictionary = _host.finance_view._confirmed.duplicate(true)
	var scroll_before: int = _host._scroll.scroll_vertical
	_rejected_queries(confirmed, effects)
	_host.finance_view.controls.query.pressed.emit()
	_expect("U14_query_P01", _host.tender_view.visible, true)
	_expect("V05_immediate_page", _host.tender_view.page, "P01")
	_expect("V05_list_visible", _host.tender_view._list.is_visible_in_tree(), true)
	_expect("V05_detail_visible", _host.tender_view.controls.detail.is_visible_in_tree(), true)
	for key: String in ["back", "submit", "handoff", "construction"]:
		_expect("V05_hidden_" + key, _host.tender_view.controls[key].is_visible_in_tree(), false)
	_expect("V05_query_focus", root.gui_get_focus_owner(), _host.tender_view.controls.refresh)
	_expect("V05_focus_visible", root.gui_get_focus_owner().is_visible_in_tree(), true)
	_expect("V05_selected_tender_kept", _host.tender_view.selected_id, tender_id)
	_expect("V05_history_kept", _host.tender_view._history, history)
	_expect("V05_query_no_effect", FX.effects(_session), effects)
	_expect("U14_hidden_finance", _host.finance_view.visible, false)
	_host.finance_view.query_requested.emit(confirmed)
	_expect("V05_hidden_report_no_effect", FX.effects(_session), effects)
	_host.tender_view.exit_requested.emit()
	for index: int in 4:
		await process_frame
	_expect("U17_return_report", _host.finance_view.visible, true)
	_expect("U17_report_preserved", _host.finance_view.labels.report.text, report_before)
	_expect("V05_report_packet_preserved", _host.shown.finance_ui.report, report_packet)
	_expect("V05_confirmed_preserved", _host.finance_view._confirmed, confirmed)
	_expect("V05_return_consumed", _host._report_return.is_empty(), true)
	_expect("U17_focus_restored", root.gui_get_focus_owner(), _host.finance_view.controls.query)
	_expect("U17_scroll_restored", _host._scroll.scroll_vertical, scroll_before)
	for index: int in 3:
		_host.finance_view.controls.refresh.pressed.emit()
	_expect("U12_read_only", FX.effects(_session), effects)
	var current: Dictionary = _host.shown.duplicate(true)
	var older: Dictionary = current.duplicate(true)
	older.current.snapshot_revision -= 1
	older.view_revision += 1
	_expect("U11_old_model_rejected", _host.present(older), false)
	_expect("U11_selected_retained", _host.shown.finance_ui.report.day_id, 4)
	older = current.duplicate(true)
	older.view_revision -= 1
	_expect("U11_old_view_rejected", _host.present(older), false)
	current.clock.remainder = 4999999
	_expect("U11_equal_revision_remainder", _host.present(current), true)
	_expect("U12_display_only", FX.effects(_session), effects)
	_host.finance_view.controls.back.pressed.emit()
	await process_frame
	await process_frame
	_expect("U17_finance_back_P06", _host.operations_view.visible, true)
	_host.operations_view.controls.back.pressed.emit()
	await process_frame
	await process_frame
	_enter_p05()
	_host.tender_view.controls.exit.pressed.emit()
	_host.controls.open_tenders.pressed.emit()
	_expect("V05_ordinary_open_keeps_P05", _host.tender_view.page, "P05")
	_host.tender_view.controls.construction.pressed.emit()
	_expect("U17_P05_entry", _host.construction_view.visible, true)
	var project_before: Dictionary = _host.construction_view.shown.duplicate(true)
	_host.controls.open_operations.grab_focus()
	_host.controls.open_operations.pressed.emit()
	_host.operations_view.controls.back.pressed.emit()
	for index: int in 4:
		await process_frame
	_expect("U17_P05_return", _host.construction_view.visible, true)
	_expect("U17_P05_preserved", _host.construction_view.shown, project_before)
	_expect("U17_P05_focus", root.gui_get_focus_owner(), _host.controls.open_operations)
	_expect("U12_P05_no_effect", FX.effects(_session), effects)
	_host.construction_view.controls.back.pressed.emit()
	_expect("V05_construction_back_keeps_P05", _host.tender_view.page, "P05")
	_expect("V05_construction_back_visible", _host.tender_view.visible, true)
	await _consumer_cases()
	_map_cases()
	_host.queue_free()
	await process_frame


func _enter_p05() -> void:
	_host.controls.open_tenders.pressed.emit()
	_host.tender_view._list.item_selected.emit(0)
	_host.tender_view.controls.detail.pressed.emit()
	_expect("V05_detail_precondition", _host.tender_view.page, "P02")
	_host.tender_view.controls.handoff.pressed.emit()
	_expect("V05_P05_precondition", _host.tender_view.page, "P05")
	_expect("V05_P05_visible", _host.tender_view.controls.construction.is_visible_in_tree(), true)


func _rejected_queries(confirmed: Dictionary, effects: String) -> void:
	var wrong_key := confirmed.duplicate(true)
	wrong_key.report_key = "invalid-report-key"
	var wrong_report := confirmed.duplicate(true)
	wrong_report.first_valid_report = {}
	for invalid: Dictionary in [wrong_key, wrong_report, {}]:
		_host.finance_view.query_requested.emit(invalid)
		_expect("V05_rejected_stays_report", _host.finance_view.visible, true)
		_expect("V05_rejected_no_tenders", _host.tender_view.visible, false)
		_expect("V05_rejected_keeps_P05", _host.tender_view.page, "P05")
		_expect("V05_rejected_feedback", _host.finance_view.labels.feedback.text.is_empty(), false)
		_expect("V05_rejected_no_return", _host._report_return.is_empty(), true)
		_expect("V05_rejected_no_effect", FX.effects(_session), effects)


func _consumer_cases() -> void:
	for id: String in _fixture.scenarios:
		var pair := _consumer_pair(_fixture.scenarios[id], id)
		var op: Control = pair.operations
		var finance: Control = pair.finance
		var state: Dictionary = pair.session.snapshot()
		_expect("U19_render_" + id, op.present(state) and finance.present(state), true)
		if id == "preopen":
			_expect("U05_preopen_reason", op.labels.status.text.contains("개통 전"), true)
		if id == "zero_demand":
			_expect("U05_real_zero", op.labels.totals.text.contains("요청 0"), true)
			_expect("U10_unclosed", op.labels.satisfaction.text.contains("마감 후 산출"), true)
		if id == "satisfaction_unavailable":
			_expect("U10_arithmetic", op.labels.satisfaction.text.begins_with("현재 만족도 산출 오류"), true)
		if id == "unknown_source_failure":
			_expect("U19_outer_failure", op.labels.status.text.contains("신규 탑승 가능"), false)
		if id == "next_supply_unavailable":
			_expect("U13_query_failure", finance.controls.query.disabled, true)
		if id == "report_failure":
			_expect("U09_report_error", finance.labels.report.text.contains("확인할 수 없습니다"), true)
			_expect("U09_current_kept", finance.labels.current.text.contains("총현금"), true)
		if id == "zero_fixed_report":
			_expect("U10_zero_report", finance.labels.report.text.contains("운영비 발생 0"), true)
		for key: String in finance.labels:
			_expect(
				"U18_wrap_" + id + "_" + key,
				finance.labels[key].autowrap_mode,
				TextServer.AUTOWRAP_WORD_SMART
			)
		op.queue_free()
		finance.queue_free()
	_restriction_cases()
	var pair := _consumer_pair(_fixture.scenarios.actual_open, "invalid_recovery")
	var op: Control = pair.operations
	var finance: Control = pair.finance
	var state: Dictionary = pair.session.snapshot()
	op.present(state)
	var invalid: Dictionary = state.duplicate(true)
	invalid.operations_ui.snapshot = "wrong"
	op.present(invalid)
	_expect("U19_bad_type_clears", op.labels.totals.text, "")
	_expect("U19_bad_type_failure", op.labels.status.text.contains("확인할 수 없습니다"), true)
	invalid.erase("operations_ui")
	op.present(invalid)
	_expect("U19_missing_clears", op.labels.totals.text, "")
	op.present(state)
	_expect("U19_recovery", op.labels.status.text.contains("신규 탑승 가능"), true)
	var failure := state.duplicate(true)
	failure.operations_ui.status = "FAILED"
	failure.operations_ui.available = false
	op.present(failure)
	_expect("U19_no_stale_allow", op.labels.status.text.contains("신규 탑승 가능"), false)
	_expect("U10_fraction_integer", Operations.fraction([55, 1]), "55점")
	_expect(
		"U10_fraction_exact",
		Operations.fraction([9223372036854775807, 3]),
		"9223372036854775807/3점"
	)
	_expect("U10_no_rounding", Operations.fraction([151, 3]), "151/3점")
	op.queue_free()
	finance.queue_free()
	_consumer_boundaries()
	await process_frame


func _restriction_cases() -> void:
	var recovery: Dictionary = _fixture.l2_supplement.scenarios.l2_restriction_recovery
	var pair := _consumer_pair(recovery.before, "restriction_recovery")
	var op: Control = pair.operations
	var finance: Control = pair.finance
	for id: String in ["before", "restricted", "B0_still_insufficient", "resumed"]:
		var state := _state(recovery[id], pair.session.snapshot())
		op.present(state)
		finance.present(state)
		var expected: String = {
			"before": "신규 탑승 가능",
			"restricted": "미지급금으로",
			"B0_still_insufficient": "다음 구간 운영비 부족",
			"resumed": "신규 탑승 가능"
		}[id]
		_expect("U06_" + id, op.labels.status.text.contains(expected), true)
		_expect("U08_payment_label_" + id, finance.labels.activity.text.contains("운영비 지급 합계"), true)
	op.queue_free()
	finance.queue_free()


func _consumer_pair(packet: Dictionary, label: String) -> Dictionary:
	var value := _display_session(packet, label)
	var op := Operations.new()
	var finance := Finance.new()
	op.bind_session(value)
	finance.bind_session(value)
	root.add_child(op)
	root.add_child(finance)
	return {"session": value, "operations": op, "finance": finance}


func _display_session(packet: Dictionary, label: String) -> DisplaySession:
	var value := DisplaySession.new(FX.Loader.load_data().data, {})
	value.enable_operations_ui()
	value.fixture_label = "DEV023-CONSUMER_FIXTURE " + label
	# 과거 소비 표본의 선택 문맥을 고정하고 후속 이상 관측에서 기대일을 다시 읽지 않는다.
	value.expected_report_day = (
		packet.finance_ui.report.day_id
		if packet.finance_ui.report_selection == "FIXED_DAY"
		else packet.operations_ui.observation.day_id - 1
	)
	value.display = _state(packet, value.snapshot())
	value.display.fixture_label = value.fixture_label
	value.pipeline.clock.paused = true
	return value


func _consumer_boundaries() -> void:
	var original: Dictionary = _fixture.scenarios.actual_first_report.duplicate(true)
	var pair := _consumer_pair(original, "binding_boundaries")
	var op: Control = pair.operations
	var finance: Control = pair.finance
	var state: Dictionary = pair.session.snapshot()
	var effects := FX.effects(pair.session)
	op.present(state)
	finance.present(state)
	_expect("D26_fixture_unchanged", original, _fixture.scenarios.actual_first_report)
	_expect("D26_valid_report_query", finance.controls.query.disabled, false)
	_expect("D26_report_copy_current", finance.confirmation_current(finance._confirmed), true)
	for kind: String in ["foreign", "stale"]:
		var invalid := state.duplicate(true)
		if kind == "foreign":
			invalid.run_scope = "foreign-run"
			invalid.view_revision += 1000
		else:
			invalid.view_revision -= 1
		_expect("D26_reject_operations_" + kind, op.present(invalid), false)
		_expect("D26_reject_finance_" + kind, finance.present(invalid), false)
		_expect("D26_keep_operations_" + kind, op.shown, state)
		_expect("D26_keep_finance_" + kind, finance.shown, state)
	for kind: String in ["scope", "day", "value"]:
		var invalid := state.duplicate(true)
		match kind:
			"scope":
				invalid.finance_ui.report.display_key = "foreign/day-4"
			"day":
				invalid.finance_ui.report.day_id = 3
			"value":
				invalid.finance_ui.report.value.day_id = 3
		finance.present(invalid)
		_expect(
			"D26_bad_report_hidden_" + kind, finance.labels.report.text.contains("고정 과거"), false
		)
		_expect("D26_bad_report_query_" + kind, finance.controls.query.disabled, true)
		finance.present(state)
		_expect("D26_report_recovery_" + kind, finance.controls.query.disabled, false)
	_expect("D26_consumer_no_model_effect", FX.effects(pair.session), effects)
	op.queue_free()
	finance.queue_free()


func _map_cases() -> void:
	var state := _state(_fixture.scenarios.actual_open, FX.session().snapshot())
	var map: Control = _host.map_view
	map.present(state)
	_expect("U16_actual_route", map.operating_stops.size(), 6)
	_expect("U16_cohort_markers", map.flow_markers.size(), 3)
	var before: Array = map.flow_markers.duplicate(true)
	for index: int in 5:
		map.queue_redraw()
		map.present(state)
	_expect("U16_draw_no_advance", map.flow_markers, before)
	state.clock.remainder = 2500000
	map.present(state)
	_expect("U16_authoritative_interpolation", map.flow_markers[0].progress, 0.5)
	for speed: int in [1, 2, 4]:
		state.clock.speed = speed
		map.present(state)
		_expect("U16_same_time_speed_" + str(speed), map.flow_markers[0].progress, 0.5)
	state.operations_ui.available = false
	state.operations_ui.status = "FAILED"
	map.present(state)
	_expect("U19_failed_map_clears", map.flow_markers.size(), 0)


func _state(packet: Dictionary, base: Dictionary) -> Dictionary:
	var state := base.duplicate(true)
	for key: String in ["operations_ui", "finance_ui", "next_business_ui"]:
		state[key] = packet.get(key, {}).duplicate(true)
	var observation: Dictionary = packet.operations_ui.observation
	state.view_revision = packet.operations_ui.view_revision
	for key: String in observation:
		state.current[key] = observation[key]
	state.clock.simulation_minute = observation.simulation_minute
	state.clock.day_id = observation.day_id
	state.clock.paused = true
	state.clock.remainder = 0
	# 보관 표본은 불변이다. 복제본의 일치하는 보고/조회 키만 시험 Session에 귀속한다.
	var report: Dictionary = state.finance_ui.report
	var suffix := "/day-%d" % report.day_id
	if report.display_key.begins_with("run-") and report.display_key.ends_with(suffix):
		var recorded_scope: String = report.display_key.trim_suffix(suffix)
		report.display_key = state.run_scope + suffix
		var next: Dictionary = state.next_business_ui
		var next_day: int = next.get("first_valid_report", {}).get("day_id", -1)
		if next.get("report_key") == "%s/day-%d" % [recorded_scope, next_day]:
			next.report_key = "%s/day-%d" % [state.run_scope, next_day]
	return state


func _integers(value: Variant) -> Variant:
	if value is float and value == floor(value):
		return int(value)
	if value is Array:
		return value.map(_integers)
	if value is Dictionary:
		for key: Variant in value:
			value[key] = _integers(value[key])
	return value


func _expect(label: String, actual: Variant, expected: Variant) -> void:
	var passed: bool = actual == expected
	_checks.append(
		{"label": label, "passed": passed, "actual": str(actual), "expected": str(expected)}
	)
	if not passed:
		_failures += 1
		print("FAIL ", label, " actual=", actual, " expected=", expected)


func _finish() -> void:
	var path := "res://.local/validation/dev023-ui-integration.json"
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		path = "res://.local/validation/dev023-ui-integration-failure.json"
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(
		(
			JSON.stringify(
				{
					"kind": "AUTO_UI",
					"checks": _checks,
					"failures": _failures,
					"real_gui": "NOT_INFERRED_FROM_AUTO"
				},
				"\t"
			)
			+ "\n"
		)
	)
	print("DEV023_UI_TEST_RESULT checks=", _checks.size(), " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _input_log(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		print("DEV023_REAL_INPUT ", event.as_text())
		_capture("F12" if event.keycode == KEY_F12 else "KEY")
	if event is InputEventMouseButton and event.pressed:
		print("DEV023_REAL_INPUT ", event.as_text())
		_capture("MOUSE")


func _capture(label: String) -> void:
	for index: int in 3:
		await process_frame
	_capture_index += 1
	var path := (
		"res://.local/validation/DEV023_GUI_%s_%s_%02d.png"
		% [_case_id, _capture_run, _capture_index]
	)
	root.get_texture().get_image().save_png(path)
	var focus := root.gui_get_focus_owner()
	print(
		"DEV023_GUI_CAPTURE ",
		JSON.stringify(
			{
				"case": _case_id,
				"kind": _kind,
				"label": label,
				"file": path,
				"screen": _host._reading_context().screen,
				"window": str(root.size),
				"viewport": str(root.get_visible_rect()),
				"minute": _host.shown.current.simulation_minute,
				"backing_pipeline_minute": _session.pipeline.clock.minute,
				"effects": FX.effects(_session),
				"tender_page": _host.tender_view.page,
				"tender_visible": _host.tender_view.visible,
				"tender_list_visible": _host.tender_view._list.is_visible_in_tree(),
				"selected_tender": _host.tender_view.selected_id,
				"focus": str(focus.get_path()) if focus != null else "",
				"focus_visible": focus.is_visible_in_tree() if focus != null else false,
				"scroll": _host._scroll.scroll_vertical,
				"selected_report": _host.shown.finance_ui.report,
				"confirmed_query": _host.finance_view._confirmed,
				"operations_text": _host.operations_view.labels.status.text,
				"report_text": _host.finance_view.labels.report.text
			}
		)
	)


func _exit_gui() -> void:
	await _capture("EXIT")
	quit(0)
