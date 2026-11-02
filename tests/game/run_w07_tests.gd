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
		await _test_views()
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
