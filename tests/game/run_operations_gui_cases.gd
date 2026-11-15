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

	func snapshot() -> Dictionary:
		return super.snapshot() if display.is_empty() else display.duplicate(true)


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
		_session = DisplaySession.new(FX.Loader.load_data().data, {})
		_session.enable_operations_ui()
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
		var supplied := _state(packet, _session.snapshot())
		supplied.fixture_label = "DEV023-CONSUMER_FIXTURE " + _case_id
		_session.display = supplied
		_session.fixture_label = supplied.fixture_label
	_session.pipeline.clock.paused = true
	_host = Host.instantiate()
	_host.session = _session
	root.add_child(_host)
	if _kind == "CONSUMER_FIXTURE":
		_host.set_process(false)
	await process_frame
	_host.controls.open_operations.pressed.emit()
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
	var scroll_before: int = _host._scroll.scroll_vertical
	_host.finance_view.controls.query.pressed.emit()
	_expect("U14_query_P01", _host.tender_view.visible, true)
	_expect("U14_hidden_finance", _host.finance_view.visible, false)
	_host.tender_view.exit_requested.emit()
	for index: int in 4:
		await process_frame
	_expect("U17_return_report", _host.finance_view.visible, true)
	_expect("U17_report_preserved", _host.finance_view.labels.report.text, report_before)
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
	_host.controls.open_tenders.pressed.emit()
	_host.tender_view.construction_requested.emit("P-A")
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
	await _consumer_cases()
	_map_cases()
	_host.queue_free()
	await process_frame


func _consumer_cases() -> void:
	var op := Operations.new()
	var finance := Finance.new()
	root.add_child(op)
	root.add_child(finance)
	var base := FX.session().snapshot()
	for id: String in _fixture.scenarios:
		var state := _state(_fixture.scenarios[id], base)
		op.shown = {}
		finance.shown = {}
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
	var recovery: Dictionary = _fixture.l2_supplement.scenarios.l2_restriction_recovery
	for id: String in ["before", "restricted", "B0_still_insufficient", "resumed"]:
		var state := _state(recovery[id], base)
		op.shown = {}
		finance.shown = {}
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
	var state := _state(_fixture.scenarios.actual_open, base)
	op.shown = {}
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
	await process_frame


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
		if event.keycode == KEY_F12:
			_capture("F12")
	if event is InputEventMouseButton and event.pressed:
		print("DEV023_REAL_INPUT ", event.as_text())


func _capture(label: String) -> void:
	await process_frame
	_capture_index += 1
	var path := (
		"res://.local/validation/DEV023_GUI_%s_%s_%02d.png"
		% [_case_id, _capture_run, _capture_index]
	)
	root.get_texture().get_image().save_png(path)
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
				"operations_text": _host.operations_view.labels.status.text,
				"report_text": _host.finance_view.labels.report.text
			}
		)
	)


func _exit_gui() -> void:
	await _capture("EXIT")
	quit(0)
