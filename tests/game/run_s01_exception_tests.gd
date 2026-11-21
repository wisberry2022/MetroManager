extends SceneTree
## DEV-026 자동 경계/소비 검사. 실제 OS 입력·독립 Design 수용과 구분한다.

const FX = preload("res://tests/game/w026_ui_fixtures.gd")
const Contract = preload("res://scripts/ui/s01_observation_contract.gd")

var _checks: Array[Dictionary] = []
var _failures: int = 0
var _view: Control


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 900)
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("HARNESS_INTENTIONAL_FAILURE", true, false)
	else:
		await _root_and_regions()
		await _typed_fields()
		await _actions_and_prediction()
		await _reports_and_children()
		await _lifecycle_and_focus()
		await _selection_and_fallback()
		await _query()
	var output := "res://.local/validation/DEV-026/auto-%d.json" % Time.get_ticks_usec()
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--output="):
			output = arg.trim_prefix("--output=")
	if FileAccess.file_exists(output):
		push_error("Evidence output exists: " + output)
		quit(2)
		return
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output.get_base_dir()))
	var file := FileAccess.open(output, FileAccess.WRITE)
	file.store_string(
		(
			JSON.stringify(
				{
					"kind": "DEV_AUTOMATIC_MODEL_AND_CONSUMER_FIXTURE",
					"checks": _checks,
					"failures": _failures,
					"engine": Engine.get_version_info()
				},
				"\t"
			)
			+ "\n"
		)
	)
	print("DEV026_TEST_RESULT checks=", _checks.size(), " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _mount(value: FX.Session) -> void:
	if is_instance_valid(_view):
		_view.retire()
		_view.free()
	_view = FX.Host.instantiate()
	_view.session = value
	root.add_child(_view)
	_view.set_process(false)
	await process_frame


func _root_and_regions() -> void:
	var value := FX.session()
	await _mount(value)
	var state := value.snapshot()
	var before := FX.effects(value)
	_expect("root_contract", state.ui_contract_revision, Contract.REVISION)
	_expect("scope_from_binding", state.run_scope, value.observation_scope())
	for invalid: Variant in [null, [], "bad", {}, {"view_revision": "1"}]:
		_expect("root_rejected_" + str(invalid), _view.present(invalid), false)
		_expect("root_markers_cleared", _view.map_view.markers.size(), 0)
		_view._act("resume")
		_view._act("remove")
		_view._bid_requested("invalid", "B01", {})
		_expect("root_no_command", FX.effects(value), before)
		_expect("root_recovery", _view.present(state), true)
	for key: String in ["ui_contract_revision", "run_scope", "view_revision", "data_version"]:
		var invalid := state.duplicate(true)
		invalid.erase(key)
		_expect("root_missing_" + key, _view.present(invalid), false)
		_expect("root_missing_resume_" + key, _view.controls.resume.disabled, true)
		_view.present(state)
	for key: String in [
		"clock",
		"current",
		"plan",
		"prediction",
		"daily_activity",
		"report",
		"stations",
		"administration",
		"edges",
		"tender_ui",
		"construction_ui",
		"operations_ui",
		"finance_ui",
		"next_business_ui",
		"command_result"
	]:
		for bad: Variant in [null, "wrong", true, []]:
			var invalid := state.duplicate(true)
			invalid[key] = bad
			_expect("regional_accept_" + key + "_" + str(bad), _view.present(invalid), true)
			_expect("regional_no_effect_" + key, FX.effects(value), before)
			_view.present(state)
	var no_funds := state.duplicate(true)
	no_funds.current.erase("funds")
	_view.present(no_funds)
	_expect("funds_missing_not_zero", _view._observation.regions.funds, false)
	_expect("funds_missing_plan_kept", _view.plan_list.item_count, 6)
	_expect("funds_missing_clock_kept", _view._observation.regions.clock, true)
	var cycle := state.duplicate(true)
	var parent: String = cycle.stations[0].neighborhood_id
	cycle.administration[parent].parent_id = parent
	_view.present(cycle)
	_expect("map_cycle_rejected", _view.map_view.markers.is_empty(), true)
	_expect("map_cycle_funds_kept", _view._observation.regions.funds, true)
	_view._select_station("S01")
	_expect("map_cycle_callback_no_effect", FX.effects(value), before)
	for key: String in Contract.DAILY:
		for bad: Variant in [null, "0", true, -1]:
			var invalid := state.duplicate(true)
			invalid.daily_activity[key] = bad
			_view.present(invalid)
			_expect("daily_bad_" + key + str(bad), _view._observation.regions.daily, false)
			_expect("daily_funds_independent", _view._observation.regions.funds, true)
	_view.present(state)
	_expect("regional_full_recovery", _view.map_view.markers.size(), 12)
	for field: String in ["day_id", "simulation_minute", "snapshot_revision"]:
		var mismatch := state.duplicate(true)
		mismatch.daily_activity[field] += 1
		_view.present(mismatch)
		_expect("daily_observation_mismatch_" + field, _view._observation.regions.daily, false)
		_expect("daily_mismatch_funds_kept_" + field, _view._observation.regions.funds, true)
	for bad: Variant in [null, "true", 1, 0, false]:
		var mismatch := state.duplicate(true)
		mismatch.coherent = bad
		_view.present(mismatch)
		_expect("coherence_requires_bool_" + str(bad), _view._observation.regions.funds, false)


func _typed_fields() -> void:
	var value := FX.session()
	await _mount(value)
	var state := value.snapshot()
	var before := FX.effects(value)
	for key: String in ["ui_contract_revision", "data_version", "run_scope", "view_revision"]:
		for bad: Variant in [true, 0, [], {}]:
			var invalid := state.duplicate(true)
			invalid[key] = bad
			_expect("root_type_" + key + str(bad), _view.present(invalid), false)
			_view.present(state)
	for row: Array in [
		["current", "data_version", "funds"],
		["current", "observation_phase", "funds"],
		["prediction", "prediction_status", "prediction"],
		["report", "status", "report"],
		["finance_ui", "ui_contract_revision", "finance_ui"],
		["operations_ui", "status", "operations_ui"]
	]:
		for bad: Variant in [true, 0, [], {}]:
			var invalid := state.duplicate(true)
			invalid[row[0]][row[1]] = bad
			_view.present(invalid)
			_expect(
				"regional_type_" + str(row) + str(bad), _view._observation.regions[row[2]], false
			)
			_view.present(state)
	for bad: Variant in ["wrong", 0, [], {}]:
		var invalid := state.duplicate(true)
		invalid.next_business_ui.allowed_actions.query = bad
		invalid.operations_ui.snapshot.available = bad
		invalid.finance_ui.report.available = bad
		invalid.finance_ui.report_day_range.first = bad
		invalid.finance_ui.current_activity.day_id = bad
		_view.present(invalid)
		_expect(
			"malformed_child_query_blocked_" + str(bad),
			_view.finance_view.controls.query.disabled,
			true
		)
		_expect(
			"malformed_child_independent_plan_" + str(bad), _view._observation.regions.plan, true
		)
		_view.present(state)
	_expect("typed_consumer_no_effect", FX.effects(value), before)


func _actions_and_prediction() -> void:
	var value := FX.session()
	await _mount(value)
	var state := value.snapshot()
	for key: String in ["pause", "resume", "speed", "predict"]:
		var invalid := state.duplicate(true)
		invalid.allowed_actions.erase(key)
		_view.present(invalid)
		var before := FX.effects(value)
		_view._act(key, {"value": 2})
		_expect("missing_action_no_effect_" + key, FX.effects(value), before)
	for key: String in ["edit", "undo"]:
		var invalid := state.duplicate(true)
		invalid.plan.allowed_actions.erase(key)
		_view.present(invalid)
		var before := FX.effects(value)
		_view._act("select" if key == "edit" else "undo", {"station_id": "S03"})
		_expect("missing_plan_action_" + key, FX.effects(value), before)
	_view.present(state)
	var displayed: int = state.plan.plan_revision
	value.dispatch({"command_id": "external-edit", "action": "remove", "station_id": "S12"})
	var plan := value.plan.snapshot()
	_view._act("select", {"station_id": "S03"})
	_expect("displayed_revision_not_replaced", value.plan.snapshot(), plan)
	_expect(
		"stale_display_request_rejected", value.snapshot().command_result.reason, "STATE_CHANGED"
	)
	_expect("displayed_revision_was_old", displayed < plan.plan_revision, true)
	value = FX.session("QA-P01")
	await _mount(value)
	state = value.snapshot()
	_expect("real_zero_current_prediction", _view._labels.prediction.text.contains("요청 0"), true)
	var wrong := state.duplicate(true)
	wrong.prediction.current.input_revision += 1
	_view.present(wrong)
	_expect("prediction_identity_mismatch", _view._observation.regions.prediction, false)
	wrong = state.duplicate(true)
	wrong.prediction.current.value.period_end = "wrong"
	_view.present(wrong)
	_expect("prediction_bad_period", _view._labels.prediction.text.contains("자료 없음"), true)
	_view.present(FX.sample(value, "EX-05"))
	_expect("calculating_fixture_only", _view._labels.prediction.text.contains("계산 중"), true)
	_view.present(FX.sample(value, "EX-13"))
	_expect("unknown_reason_neutral", _view._labels.feedback.text.contains("안내 내용을"), true)
	_expect(
		"unknown_reason_not_raw_ui", _view._labels.feedback.text.contains("UNKNOWN_FIXTURE"), false
	)
	var pending := value.snapshot()
	_expect("general_sync_no_pending", pending.command_result.get("pending", false), false)


func _reports_and_children() -> void:
	var value := FX.session("QA-M01")
	value.pipeline.clock.paused = false
	FX.Ops.advance_to(value, 2880)
	value.pipeline.clock.paused = true
	value.select_finance_report(1)
	await _mount(value)
	var state := value.snapshot()
	var unavailable := state.duplicate(true)
	unavailable.report.status = "UNAVAILABLE"
	unavailable.report.available = false
	unavailable.report.value = {}
	_view.present(unavailable)
	_expect("later_missing_report_neutral", _view._labels.report.text, "확정 보고 자료 없음")
	for field: String in ["display_key", "day_id", "value"]:
		var invalid := state.duplicate(true)
		if field == "display_key":
			invalid.report.display_key = "foreign/day-2"
		elif field == "day_id":
			invalid.report.day_id = 1
		else:
			invalid.report.value.day_id = 1
		_view.present(invalid)
		_expect("root_report_identity_" + field, _view._observation.regions.report, false)
		_expect("root_report_funds_kept_" + field, _view._observation.regions.funds, true)
	var current: Dictionary = state.current.duplicate(true)
	current.erase("funds")
	var partial_supply: Dictionary = value._finance_snapshot(
		current, state.finance_ui.current_activity
	)
	_expect("supply_funds_missing_activity_kept", partial_supply.current_activity.is_empty(), false)
	_expect("supply_funds_missing_report_kept", partial_supply.report, state.finance_ui.report)
	var daily: Dictionary = state.finance_ui.current_activity.duplicate(true)
	daily.erase("payment")
	partial_supply = value._finance_snapshot(state.current, daily)
	_expect("supply_activity_missing_funds_kept", partial_supply.current_funds, state.current.funds)
	_expect("supply_activity_missing_not_zero", partial_supply.current_activity.is_empty(), true)
	_view._open_reading("finance")
	_expect("fixed_day_is_not_root_previous", state.report.day_id, 2)
	_expect("fixed_day_report", _view.finance_view.labels.report.text.contains("마감일 1"), true)
	var report_text: String = _view.finance_view.labels.report.text
	var before := FX.effects(value)
	for field: String in ["display_key", "day_id", "value"]:
		var invalid := state.duplicate(true)
		invalid.finance_ui.report[field] = "foreign" if field != "day_id" else 2
		_view.present(invalid)
		_expect("wrong_report_" + field, _view.finance_view.controls.query.disabled, true)
		_expect(
			"wrong_report_hidden_" + field,
			_view.finance_view.labels.report.text.contains("고정 과거 보고"),
			false
		)
	var partial := state.duplicate(true)
	partial.erase("current")
	_view.present(partial)
	_expect("independent_p07_report", _view.finance_view.labels.report.text, report_text)
	partial = state.duplicate(true)
	partial.finance_ui.erase("current_funds")
	_view.present(partial)
	_expect("partial_p07_report_kept", _view.finance_view.labels.report.text, report_text)
	_expect(
		"partial_funds_no_zero", _view.finance_view.labels.current.text.contains("총현금 0"), false
	)
	_view.present(state)
	_expect("report_reads_no_effect", FX.effects(value), before)
	value.pipeline.clock.paused = false
	FX.Ops.advance_to(value, 4320)
	value.pipeline.clock.paused = true
	_view.present(value.snapshot())
	_expect("fixed_day_after_midnight", _view.finance_view.labels.report.text, report_text)
	value.report_error = "FIXTURE_FAILURE"
	_view.present(value.snapshot())
	_expect("real_failed_report_hidden", _view._labels.report.text.contains("조회 실패"), true)
	_expect("failed_p07_hidden", _view.finance_view.labels.report.text.contains("고정 과거 보고"), false)
	value.report_error = ""
	_view.present(value.snapshot())
	_expect("failed_report_recovery", _view.finance_view.labels.report.text, report_text)
	state = value.snapshot()
	for key: String in ["tender_ui", "construction_ui"]:
		_view._show_reading("tenders" if key == "tender_ui" else "construction")
		var panel: Control = _view.tender_view if key == "tender_ui" else _view.construction_view
		var back_disabled: bool = panel.controls.back.disabled
		var invalid := state.duplicate(true)
		invalid[key] = null
		_view.present(invalid)
		_expect("missing_child_hidden_" + key, panel.visible, false)
		before = FX.effects(value)
		_view._bid_requested("blocked", "B01", {})
		_view._construction_requested("blocked", "contract", {})
		_expect("child_boundary_no_command_" + key, FX.effects(value), before)
		_view.present(state)
		_expect("child_screen_restored_" + key, panel.visible, true)
		_expect("child_back_recovered_" + key, panel.controls.back.disabled, back_disabled)


func _selection_and_fallback() -> void:
	var value := FX.session()
	await _mount(value)
	var before := FX.effects(value)
	_view._focus_station("S02")
	_view.map_view.markers.S02.grab_focus()
	_view.present(FX.sample(value, "EX-02"))
	_expect("missing_map_keeps_latent_id", _view._selected_id, "S02")
	_expect("removed_marker_fallback", root.gui_get_focus_owner(), _view.plan_list)
	_view.present(value.snapshot())
	_expect("same_id_recovered", _view._selected_id, "S02")
	var gone := value.snapshot()
	gone.stations = gone.stations.filter(func(row: Dictionary) -> bool: return row.id != "S02")
	gone.edges = gone.edges.filter(func(edge: Array) -> bool: return "S02" not in edge)
	gone.plan.station_ids.erase("S02")
	_view.candidate_buttons.S02.grab_focus()
	_view.present(gone)
	_expect("gone_id_clear", _view._selected_id, "")
	_expect("gone_candidate_removed", _view.candidate_buttons.has("S02"), false)
	_expect("gone_id_fallback", root.gui_get_focus_owner(), _view.plan_list)
	_expect("selection_and_fallback_no_effect", FX.effects(value), before)
	_view.present(null)
	_expect("no_data_focus_title", root.gui_get_focus_owner(), _view._labels.title)


func _lifecycle_and_focus() -> void:
	var value := FX.session()
	await _mount(value)
	var state := value.snapshot()
	var older := state.duplicate(true)
	older.view_revision -= 1
	_expect("stale_same_scope", _view.present(older), false)
	_expect("stale_keeps_current", _view.shown, state)
	var same := state.duplicate(true)
	same.clock.remainder += 1
	_expect("same_revision_remainder", _view.present(same), true)
	var foreign := state.duplicate(true)
	foreign.run_scope = "foreign-run"
	foreign.view_revision += 1000
	_expect("foreign_high_revision", _view.present(foreign), false)
	var floor_before: int = _view._displayed_revision
	_view.reset_observation()
	_expect("reset_preserves_floor", _view._displayed_revision, floor_before)
	_view._open_reading("finance")
	_view.finance_view.controls.refresh.grab_focus()
	var context: Dictionary = _view._reading_context()
	_view._open_reading("operations")
	_view._restore_reading(context)
	_view.controls.resume.grab_focus()
	await process_frame
	await process_frame
	await process_frame
	_expect("deferred_restore_respects_user", root.gui_get_focus_owner(), _view.controls.resume)
	var original := _view
	var old_child: Control = original.finance_view
	var old_model := FX.effects(value)
	var next := FX.session("QA-M01")
	var next_scope := next.observation_scope()
	_view = original.replace_session(original, next)
	_view.set_process(false)
	original._act("resume")
	old_child.query_requested.emit({})
	_expect("retired_callback_no_old_effect", FX.effects(value), old_model)
	_expect("new_host", _view != original, true)
	_expect("new_child", _view.finance_view != old_child, true)
	_expect("new_scope_low_revision", _view.shown.run_scope, next_scope)
	_expect("new_scope_no_selection", _view._selected_id, "")
	_expect("new_scope_no_history", _view._screen_history.is_empty(), true)
	_expect("new_scope_no_confirmation", _view.finance_view._confirmed.is_empty(), true)
	_expect("old_scope_after_replacement", _view.present(state), false)
	await process_frame
	var bound: FX.Session = _view.session
	var bound_before := FX.effects(bound)
	var other := FX.session()
	var other_before := FX.effects(other)
	_view.session = other
	_view.reset_observation()
	_view._process(0.1)
	_view._act("resume")
	_expect("unsupported_rebinding_old_no_effect", FX.effects(bound), bound_before)
	_expect("unsupported_rebinding_new_no_effect", FX.effects(other), other_before)
	_expect("unsupported_rebinding_input_block", _view.controls.resume.disabled, true)


func _query() -> void:
	var value: FX.Session = FX.Ops.opened().session
	FX.Ops.advance_to(value, 5760)
	value.pipeline.clock.paused = true
	await _mount(value)
	_view._open_reading("finance")
	var confirmed: Dictionary = _view.finance_view._confirmed.duplicate(true)
	_expect("actual_first_report_confirmed", not confirmed.is_empty(), true)
	var before := FX.effects(value)
	_view._select_report(1)
	_view._query_business(confirmed)
	_expect("old_confirmation_no_navigation", _view.finance_view.visible, true)
	_expect("old_confirmation_no_effect", FX.effects(value), before)
	_view._select_report(4)
	var correct: Dictionary = _view.finance_view._confirmed.duplicate(true)
	_view._query_business(correct)
	_expect("valid_query_catalog", _view.tender_view.visible, true)
	_expect("valid_query_no_ledger_time_effect", FX.effects(value), before)
	_view._close_tenders()
	await process_frame
	await process_frame
	await process_frame
	_expect("same_run_report_return", _view.finance_view.visible, true)
	_expect("same_run_fixed_day_return", _view.finance_view.shown.finance_ui.report.day_id, 4)
	var invalid := value.snapshot()
	invalid.erase("next_business_ui")
	_view.present(invalid)
	_expect("missing_query_clears_confirmation", _view.finance_view._confirmed.is_empty(), true)
	_view._query_business(correct)
	_expect("missing_query_callback_no_effect", FX.effects(value), before)
	_view.retire()
	_view.free()


func _expect(name: String, actual: Variant, expected: Variant) -> void:
	var passed: bool = actual == expected
	if actual is Object:
		actual = str(actual)
	if expected is Object:
		expected = str(expected)
	_checks.append({"name": name, "passed": passed, "actual": actual, "expected": expected})
	if not passed:
		_failures += 1
		printerr("FAIL ", name, " actual=", actual, " expected=", expected)
