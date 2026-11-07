extends SceneTree

const Fixtures = preload("res://tests/game/w07_ui_fixtures.gd")
const Stage1 = preload("res://scenes/stage1.tscn")

var _checks: int = 0
var _failures: int = 0
var _sequence: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure", false, true)
	else:
		_test_time_and_commands()
		_test_plan_and_prediction()
		_test_reports()
		_test_daily_activity()
		_test_late_failure()
		await _test_views()
		await _test_review_fixes()
		await _test_residual_views()
	print("W07_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _test_time_and_commands() -> void:
	for speed: int in [1, 2, 4]:
		var session := Fixtures.create("QA-T02")
		var stable := session.snapshot()
		session.advance_usec(5000000)
		_expect("paused_minute", session.snapshot().clock.simulation_minute, 360)
		_expect("query_no_effect", session.snapshot(), stable)
		_do(session, "speed", {"value": speed})
		var resumed := _do(session, "resume")
		_expect("resume_no_tick_wait", resumed.accepted, true)
		_expect("resume_effective_minute", resumed.effective_at, 360)
		_expect(
			"pause_resume_revision", session.snapshot().view_revision > stable.view_revision, true
		)
		session.advance_usec(5000000)
		_expect("speed_model_minute", session.snapshot().clock.simulation_minute, 360 + 12 * speed)
		_expect("same_observation", session.snapshot().coherent, true)
		_do(session, "pause")
		var stopped := session.snapshot()
		session.advance_usec(5000000)
		_expect("stopped", session.snapshot(), stopped)
	var session := Fixtures.create("QA-T03")
	var before := session.pipeline.snapshot()
	_expect("invalid_speed", _do(session, "speed", {"value": 3}).reason, "INVALID_SPEED")
	_expect("invalid_speed_atomic", session.pipeline.snapshot(), before)
	_expect("invalid_command", session.dispatch({}).reason, "INVALID_COMMAND")
	_expect("unknown_action", _do(session, "contract").reason, "UNKNOWN_ACTION")
	var command := {"command_id": "ONCE", "action": "select", "station_id": "S01"}
	var first := session.dispatch(command)
	var state := session.snapshot()
	_expect("duplicate_result", session.dispatch(command), first)
	_expect("duplicate_state", session.snapshot(), state)
	var copy := session.snapshot()
	copy.plan.station_ids.clear()
	_expect("isolated_snapshot", session.snapshot(), state)
	_expect(
		"stale_meaning",
		_do(session, "remove", {"station_id": "S01", "expected_plan_revision": 0}).reason,
		"STATE_CHANGED"
	)
	_expect("stale_keeps_plan", session.plan.snapshot(), state.plan)


func _test_plan_and_prediction() -> void:
	var session := Fixtures.create("QA-M01")
	_expect("undo_empty", _do(session, "undo").reason, "NO_UNDO_HISTORY")
	Fixtures.fill(session, Fixtures.ROUTE)
	_expect("six_valid", session.snapshot().plan.validation.valid, true)
	var funds := session.pipeline.ledger.snapshot()
	_expect("prediction_success", _do(session, "predict").accepted, true)
	var predicted: Dictionary = session.snapshot().prediction
	_expect("routeA_requested", predicted.current.value.totals.requested, 4860)
	_expect("routeA_completed", predicted.current.value.totals.completed, 4860)
	_expect("routeA_fare", predicted.current.value.totals.predicted_fare, 486000)
	_expect(
		"prediction_period",
		[predicted.current.value.period_start, predicted.current.value.period_end],
		[360, 1800]
	)
	_expect("prediction_no_money", session.pipeline.ledger.snapshot(), funds)
	var plan := session.plan.snapshot()
	_expect(
		"duplicate_rejected",
		_do(session, "select", {"station_id": "S01"}).reason,
		"DUPLICATE_STATION"
	)
	_expect("rejection_keeps_revision", session.plan.snapshot(), plan)
	_do(session, "remove", {"station_id": "S12"})
	_expect("five_editable", session.snapshot().plan.station_ids.size(), 5)
	_expect("five_invalid", session.snapshot().plan.validation.valid, false)
	_expect("edit_invalidates", session.snapshot().prediction.available, false)
	_expect("previous_retained", session.snapshot().prediction.previous, predicted.current)
	_expect(
		"old_response_rejected",
		session.prediction.complete(
			predicted.prediction_input_revision, predicted.current.value, 400
		),
		false
	)
	_expect("invalid_predict", _do(session, "predict").reason, "INVALID_PLAN")
	_expect("failed_not_zero", session.snapshot().prediction.prediction_status, "FAILED")
	_do(session, "undo")
	_expect("undo_restores_order", session.plan.snapshot().station_ids, Fixtures.ROUTE)
	_expect(
		"undo_revision_forward", session.plan.snapshot().plan_revision > plan.plan_revision, true
	)
	_do(session, "reorder", {"from": 0, "to": 4})
	_expect(
		"reorder_disconnected",
		"DISCONNECTED" in session.plan.snapshot().validation.reason_codes,
		true
	)
	var locked := Fixtures.create("QA-M03")
	_expect("locked_undo", _do(locked, "undo").reason, "PLAN_LOCKED")
	_expect("locked_select", _do(locked, "select", {"station_id": "S05"}).accepted, false)
	var outside := Fixtures.create("QA-M02-EXTERNAL")
	_expect(
		"external_rejected",
		_do(outside, "select", {"station_id": "EXTERNAL"}).reason,
		"OUTSIDE_JURISDICTION"
	)
	var zero := Fixtures.create("QA-P01")
	_expect("ready_zero_available", zero.snapshot().prediction.available, true)
	_expect("ready_zero", zero.snapshot().prediction.current.value.totals.requested, 0)
	_expect("revision_seven", zero.snapshot().prediction.prediction_input_revision, 7)
	_do(zero, "remove", {"station_id": "S12"})
	_expect("revision_eight", zero.snapshot().prediction.prediction_input_revision, 8)
	_expect("zero_to_absent", zero.snapshot().prediction.available, false)
	var route8 := Fixtures.create("QA-M02-8")
	_expect("eight_valid", route8.snapshot().plan.validation.valid, true)
	_do(route8, "select", {"station_id": "S08"})
	_expect("nine_editable", route8.snapshot().plan.station_ids.size(), 9)
	_expect("nine_invalid", route8.snapshot().plan.validation.valid, false)


func _test_reports() -> void:
	var report := Fixtures.create("QA-F03").snapshot()
	_expect("current_day", report.current.day_id, 2)
	_expect("past_day", report.report.day_id, 1)
	_expect("report_present", report.report.available, true)
	_expect("report_scope_key", report.report.display_key.ends_with("/day-1"), true)
	_expect("past_fare_frozen", report.report.value.fare, 0)
	_expect("current_cash", report.current.funds.cash, 320)
	_expect("current_B_settled", report.current.funds.unpaid, 0)
	var no_report := Fixtures.create("QA-F01").snapshot()
	_expect("report_absent", no_report.report.status, "UNAVAILABLE")
	var zero := Fixtures.create("QA-F04-ZERO").snapshot()
	_expect("report_zero_available", zero.report.available, true)
	_expect("report_zero", zero.report.value.operating_cost, 0)
	_expect("report_error", Fixtures.create("QA-F04").snapshot().report.status, "FAILED")
	var reserved: Dictionary = Fixtures.create("QA-F02-K").snapshot().current.funds
	_expect("reserved_current", [reserved.cash, reserved.reserved, reserved.unpaid], [48, 48, 1])


func _test_daily_activity() -> void:
	var session := Fixtures.create("QA-F02-K")
	var state := session.snapshot()
	_expect(
		"R01_accrued_paid_unpaid",
		[
			state.daily_activity.operating_cost,
			state.daily_activity.cash_payment,
			state.current.funds.unpaid
		],
		[3, 2, 1]
	)
	_expect(
		"R01_reserved_preserved",
		[
			state.current.funds.cash,
			state.current.funds.reserved,
			state.current.funds.available_cash
		],
		[48, 48, 0]
	)
	_expect(
		"R01_same_minute", state.daily_activity.simulation_minute, state.clock.simulation_minute
	)
	_expect(
		"R01_same_revision", state.daily_activity.snapshot_revision, state.current.snapshot_revision
	)
	var entries := session.pipeline.ledger.entries()
	var current := session.pipeline.reports.current(1)
	session.pipeline.reports.sync(entries)
	session.pipeline.reports.sync(entries)
	_expect("R01_sync_not_double_counted", session.pipeline.reports.current(1), current)
	_expect("R01_query_repeat", session.snapshot(), state)
	_expect("R01_query_keeps_entries", session.pipeline.ledger.entries(), entries)
	var copy := session.snapshot()
	copy.daily_activity.operating_cost = 999
	_expect("R01_isolated_daily_copy", session.snapshot(), state)
	var unsynced := Fixtures.create("QA-T01")
	unsynced.pipeline.ledger.operating_cost(1, 360)
	unsynced.snapshot()
	_expect("R01_query_does_not_sync", unsynced.pipeline.reports.current(1).operating_cost, 0)
	var settled := Fixtures.create("QA-F03").snapshot()
	_expect(
		"R01_old_debt_payment",
		[
			settled.daily_activity.operating_cost,
			settled.daily_activity.payment,
			settled.daily_activity.debt_payment,
			settled.daily_activity.cash_payment,
			settled.current.funds.unpaid
		],
		[0, 0, 500, 500, 0]
	)
	# 공급 집계의 종류 분리만 검증하는 보고 입력. 신규 경제 사건 구현이 아니다.
	var projection := Fixtures.create("QA-T01")
	var records: Array[Dictionary] = []
	for pair: Array in [
		["operating_cost", 3],
		["payment", 2],
		["debt_payment", 5],
		["construction_payment", 40],
		["fare", 60],
		["government", 70]
	]:
		records.append({"kind": pair[0], "amount": pair[1], "effective_at": 360})
	projection.pipeline.reports.sync(records)
	_expect("R01_payment_kinds_only", projection.snapshot().daily_activity.cash_payment, 7)
	session.pipeline.clock.minute = 1439
	session.pipeline.clock.paused = false
	session.advance_usec(500000)
	session.pipeline.clock.paused = true
	state = session.snapshot()
	_expect(
		"R01_midnight_day",
		[state.current.day_id, state.daily_activity.day_id, state.report.day_id],
		[2, 2, 1]
	)
	_expect(
		"R01_new_day_zero",
		[state.daily_activity.operating_cost, state.daily_activity.cash_payment],
		[0, 0]
	)
	_expect(
		"R01_closed_prior_cost",
		[state.report.value.operating_cost, state.report.value.payment],
		[3, 2]
	)
	var closed: Dictionary = state.report.duplicate(true)
	session.pipeline.ledger.operating_cost(2, 1440)
	session.pipeline.reports.sync(session.pipeline.ledger.entries())
	_expect("R01_new_day_cost", session.snapshot().daily_activity.operating_cost, 2)
	_expect("R01_closed_report_immutable", session.snapshot().report, closed)
	print("W07_R01_RESULT accrued=3 paid=2 unpaid=1 midnight_day2=0 prior_day1=3/2")


func _test_late_failure() -> void:
	var session := Fixtures.create("QA-M02")
	_expect("R02_valid_six_stations", session.plan.snapshot().validation.valid, true)
	_do(session, "predict")
	var value: Dictionary = session.prediction.snapshot().current.value.duplicate(true)
	_expect("R02_input_seven", session.prediction.snapshot().prediction_input_revision, 7)
	session.prediction.change_input(session.plan.snapshot().plan_revision, 8, 361)
	session.prediction.begin()
	var before := session.prediction.snapshot()
	_expect("R02_calculating", before.prediction_status, "CALCULATING")
	var accepted := session.prediction.fail(7, "STALE_FAILURE")
	_expect("R02_late_fail_calculating_rejected", accepted, false)
	_expect("R02_late_fail_calculating_unchanged", session.prediction.snapshot(), before)
	_log_late_failure("CALCULATING", accepted, before, session.prediction.snapshot())
	_expect("R02_complete_valid_eight", session.prediction.complete(8, value, 362), true)
	before = session.prediction.snapshot()
	_expect(
		"R02_ready_eight", [before.prediction_status, before.current.input_revision], ["READY", 8]
	)
	accepted = session.prediction.fail(7, "STALE_FAILURE")
	_expect("R02_late_fail_ready_rejected", accepted, false)
	_expect("R02_late_fail_ready_unchanged", session.prediction.snapshot(), before)
	_log_late_failure("READY", accepted, before, session.prediction.snapshot())
	_expect("R02_current_failure_accepted", session.prediction.fail(8, "CURRENT_FAILURE"), true)
	var failed := session.prediction.snapshot()
	_expect(
		"R02_current_failure_state",
		[failed.prediction_status, failed.reason, failed.available, failed.current],
		["FAILED", "CURRENT_FAILURE", false, {}]
	)
	_expect("R02_current_failure_keeps_previous", failed.previous, before.previous)


func _log_late_failure(
	status: String, accepted: bool, before: Dictionary, after: Dictionary
) -> void:
	print(
		"W07_R02_LATE_FAIL ",
		JSON.stringify(
			{
				"status": status,
				"accepted": accepted,
				"input_before": before.prediction_input_revision,
				"input_after": after.prediction_input_revision,
				"before_sha256": JSON.stringify(before).sha256_text(),
				"after_sha256": JSON.stringify(after).sha256_text(),
				"snapshot_equal": before == after
			}
		)
	)


func _test_residual_views() -> void:
	for case_id: String in ["QA-F02-K", "QA-F03", "QA-F01"]:
		var view := Stage1.instantiate()
		view.session = Fixtures.create(case_id)
		root.add_child(view)
		view.set_process(false)
		await process_frame
		var state: Dictionary = view.session.snapshot()
		var label: Label = view.find_child("activity", true, false)
		var expected := {
			"QA-F02-K": "발생 누계 3 / 현금 지급 누계 2",
			"QA-F03": "발생 누계 0 / 현금 지급 누계 500",
			"QA-F01": "발생 누계 0 / 현금 지급 누계 0"
		}
		_expect("R01_ui_" + case_id, label.text.contains(expected[case_id]), true)
		_expect("R01_ui_unclosed_" + case_id, label.text.contains("미마감"), true)
		var invalid := state.duplicate(true)
		invalid.daily_activity = {}
		view.present(invalid)
		_expect("R01_no_data_not_zero", label.text, "당일 운영비 확인 실패: 자료 없음/오류")
		invalid = state.duplicate(true)
		invalid.daily_activity.simulation_minute += 1
		view.present(invalid)
		_expect("R01_wrong_minute_not_displayed", label.text, "당일 운영비 확인 중: 관측 시점 불일치")
		invalid = state.duplicate(true)
		invalid.daily_activity.snapshot_revision += 1
		view.present(invalid)
		_expect("R01_wrong_revision_not_displayed", label.text, "당일 운영비 확인 중: 관측 시점 불일치")
		view.present(state)
		_expect("R01_view_recovery", label.text.contains(expected[case_id]), true)
		_expect("R01_ui_read_only", view.session.snapshot(), state)
		view.queue_free()
		await process_frame


func _test_views() -> void:
	for case_id: String in Fixtures.CASES:
		var view := Stage1.instantiate()
		view.session = Fixtures.create(case_id)
		root.add_child(view)
		view.set_process(false)
		await process_frame
		_expect(case_id + ":coherent", view.shown.coherent, true)
		_expect(case_id + ":same_route", view.map_view._stops, view.shown.plan.station_ids)
		_expect(case_id + ":candidates", view.candidate_buttons.size(), view.shown.stations.size())
		_expect(case_id + ":markers", view.map_view.markers.size(), view.shown.stations.size())
		_expect(
			case_id + ":funds_label",
			view.find_child("funds", true, false).text.contains("현재 자금"),
			true
		)
		_expect(
			case_id + ":fixture_label",
			view.find_child("title", true, false).text.contains(case_id),
			true
		)
		if case_id == "QA-M01":
			var old: Dictionary = view.shown.duplicate(true)
			view.map_view.markers.S01.pressed.emit()
			view.candidate_buttons.S02.pressed.emit()
			_expect("map_then_list_once", view.shown.plan.station_ids, ["S01", "S02"])
			_expect("map_list_same_order", view.plan_list.get_item_text(1), "2. S02")
			_expect("stale_view_rejected", view.present(old), false)
			_expect("stale_keeps_buttons", view.shown.plan.station_ids, ["S01", "S02"])
			view.controls.undo.pressed.emit()
			_expect("ui_undo", view.shown.plan.station_ids, ["S01"])
		if case_id == "QA-M02-EXTERNAL":
			view.candidate_buttons.EXTERNAL.pressed.emit()
			_expect(
				"external_affiliation_display",
				view.find_child("selection", true, false).text.contains(
					"OTHER > OTHER-D > EXTERNAL"
				),
				true
			)
		if case_id == "QA-X01":
			view.session = Fixtures.create("QA-M02")
			view.reset_observation()
			_expect("case_switch_full", view.plan_list.item_count, 6)
			view.session = Fixtures.create("QA-M01")
			view.reset_observation()
			_expect("case_switch_clears", view.plan_list.item_count, 0)
		if case_id == "QA-M03":
			_expect("ui_locked_disabled", view.controls.undo.disabled, true)
		if case_id == "QA-M04":
			_expect(
				"overlap_fixture",
				view.map_view.markers.S01.position,
				view.map_view.markers.S12.position
			)
			view.candidate_buttons.S12.pressed.emit()
			_expect("list_bypasses_overlap", view.shown.plan.station_ids, ["S12"])
		if case_id == "QA-P01":
			_expect(
				"render_real_zero",
				view.find_child("prediction", true, false).text.contains("요청 0"),
				true
			)
		if case_id == "QA-F04":
			_expect(
				"render_error", view.find_child("report", true, false).text.contains("조회 실패"), true
			)
		view.queue_free()
		await process_frame


func _test_review_fixes() -> void:
	for case_id: String in ["QA-M01", "QA-M02", "QA-M03", "QA-M02-DISCONNECTED"]:
		var view := Stage1.instantiate()
		view.session = Fixtures.create(case_id)
		root.add_child(view)
		view.set_process(false)
		await process_frame
		if case_id == "QA-M01":
			view.map_view.markers.S01.pressed.emit()
		var before: Dictionary = view.session.snapshot()
		for source: Button in [view.map_view.markers.S01, view.candidate_buttons.S01]:
			_expect("included_focus_enabled_" + case_id, source.disabled, false)
			source.pressed.emit()
			_expect("focus_no_model_command_" + case_id, view.session.snapshot(), before)
			_expect("focus_selects_row_" + case_id, view.plan_list.is_selected(0), true)
			_expect("focus_map_marked_" + case_id, view.map_view.markers.S01.button_pressed, true)
			_expect("focus_list_marked_" + case_id, view.candidate_buttons.S01.button_pressed, true)
			_expect(
				"focus_feedback_" + case_id,
				view.find_child("feedback", true, false).text.begins_with("정보 선택: S01"),
				true
			)
		view.present(view.session.snapshot())
		_expect(
			"focus_feedback_survives_refresh",
			view.find_child("feedback", true, false).text.begins_with("정보 선택: S01"),
			true
		)
		var connections: Label = view.find_child("connections", true, false)
		if case_id == "QA-M03":
			_expect("locked_focus_keeps_remove_disabled", view.controls.remove.disabled, true)
			_expect("locked_new_station_disabled", view.candidate_buttons.S05.disabled, true)
		elif case_id == "QA-M02-DISCONNECTED":
			_expect(
				"map07_still_invalid", view.shown.plan.validation.reason_codes, ["DISCONNECTED"]
			)
			_expect("map07_pair", connections.text.contains("1. S01 → 2. S03: 연결 간선 없음"), true)
			_expect("map07_action", connections.text.contains("순서 조정 또는 제거"), true)
			view.controls.remove.pressed.emit()
			_expect("map07_repair_removes_error", connections.text, "")
			_expect("map07_repair_keeps_count_failure", view.shown.plan.validation.valid, false)
			view.controls.undo.pressed.emit()
			_expect("map07_undo_restores_pair", connections.text.contains("1. S01 → 2. S03"), true)
		else:
			_expect("normal_no_connection_error", connections.text, "")
			view.controls.remove.pressed.emit()
			_expect("focused_remove_works", "S01" in view.shown.plan.station_ids, false)
		view.queue_free()
		await process_frame


func _do(session: RefCounted, action: String, payload: Dictionary = {}) -> Dictionary:
	_sequence += 1
	var command := payload.duplicate(true)
	command.merge({"command_id": "test-%d" % _sequence, "action": action})
	return session.dispatch(command)


func _expect(name: String, actual: Variant, expected: Variant) -> void:
	_checks += 1
	if actual != expected:
		_failures += 1
		printerr(
			"FAIL ",
			name,
			" expected=",
			JSON.stringify(expected),
			" actual=",
			JSON.stringify(actual)
		)
