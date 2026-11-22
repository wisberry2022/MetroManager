extends SceneTree
## P3-B 실제 Control/Host 자동 검사. 합성 입력·시간 환산은 OS GUI/자연 VS02 증거가 아니다.

const FX = preload("res://tests/game/w04b_fixtures.gd")
const Host = preload("res://scenes/stage1.tscn")
const Main = preload("res://scenes/main.tscn")
const MainScript = preload("res://scripts/main.gd")
const HostScript = preload("res://scripts/ui/stage1_view.gd")
const Text = preload("res://scripts/ui/proposal_presentation.gd")
const Guard = preload("res://scripts/ui/s01_observation_contract.gd")
var _host: Control
var _view: Control
var _session: FX.Session
var _checks: int = 0
var _failures: int = 0
var _assertions: Array[Dictionary] = []
var _samples: Dictionary = {}


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure", false, true)
	else:
		await _main_entry()
		await _keyboard_and_reading()
		await _editing_and_office()
		await _branches()
		await _guard_and_lifetime()
		await _display_boundaries()
		await _business_flow()
		_prediction_boundaries()
	var output := "res://.local/validation/DEV-027/screen-integration/view.json"
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("--output="):
			output = argument.trim_prefix("--output=")
	_expect(
		"write_evidence",
		FX.save(
			output,
			{
				"checks": _checks,
				"failures": _failures,
				"assertions": _assertions,
				"samples": _samples,
				"scope": "HEADLESS_CONTROL_SYNTHETIC_INPUT_NOT_OS_GUI"
			}
		),
		true
	)
	print("PROPOSAL_VIEW_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _expect(id: String, actual: Variant, expected: Variant) -> void:
	_checks += 1
	var passed: bool = actual == expected
	if not passed:
		_failures += 1
		print("FAIL ", id, " actual=", actual, " expected=", expected)
	_assertions.append(
		{
			"id": id,
			"pass": passed,
			"actual": str(actual) if actual is Object else actual,
			"expected": str(expected) if expected is Object else expected
		}
	)


func _main_entry() -> void:
	for seed_value: String in ["0", "1", "2", "8"]:
		_expect(
			"seed:" + seed_value,
			MainScript.proposal_seed(["--w04b-seed=" + seed_value]).seed,
			int(seed_value)
		)
	for arguments: PackedStringArray in [
		["--w04b-seed"], ["--w04b-seed=3"], ["--w04b-seed=-1"], ["--w04b-seed=2", "--w04b-seed=2"]
	]:
		_expect(
			"invalid_seed:" + str(arguments), MainScript.proposal_seed(arguments).accepted, false
		)
	_expect("default_random_seed", MainScript.proposal_seed([]).accepted, true)
	var main := Main.instantiate()
	root.add_child(main)
	await process_frame
	var product: Control = main.get_child(main.get_child_count() - 1)
	product.set_process(false)
	_expect(
		"actual_main_installs_proposals", product.session.snapshot().proposal_ui.available, true
	)
	_expect("main_operations_preserved", product.session.snapshot().operations_ui.available, true)
	var before: Dictionary = product.session.snapshot()
	product.controls.open_proposals.pressed.emit()
	_expect("main_real_view", product.proposal_view.visible, true)
	_expect("first_no_selection", product.proposal_view.selected_slot, "")
	_expect("entry_no_effect", product.session.snapshot(), before)
	_expect("main_enable_once", product.session.enable_proposals(2).accepted, false)
	main.queue_free()
	await process_frame


func _setup(seed_value: int = 2, minute: int = 60, params: Dictionary = {}) -> void:
	_session = FX.session(seed_value, minute, params)
	_session.enable_operations_ui()
	_host = Host.instantiate()
	_host.session = _session
	root.add_child(_host)
	_host.set_process(false)
	_view = _host.proposal_view
	_host.controls.open_proposals.pressed.emit()
	_click("P-A")
	await process_frame


func _dispose() -> void:
	_host.queue_free()
	await process_frame


func _click(id: String) -> void:
	_expect("button_enabled:" + id, _view.controls[id].disabled, false)
	_view.controls[id].pressed.emit()


func _route() -> void:
	for id: String in FX.ROUTE_A:
		_view.station_buttons[id].pressed.emit()
		_click("add")
	_click("predict")


func _at(minute: int) -> void:
	FX.advance(_session, minute)
	_host.present(_session.snapshot())


func _record(name: String) -> void:
	var labels := {}
	for key: String in _view.labels:
		labels[key] = _view.labels[key].text
	_samples[name] = {
		"kind": "ACTUAL_CONTROL_WITH_AUTOMATIC_TIME_INPUT",
		"labels": labels,
		"packet": _session.snapshot().proposal_ui,
		"selection": _view.reading_context()
	}


func _editing_and_office() -> void:
	await _setup()
	var before := _session.snapshot()
	_view.station_buttons.S01.pressed.emit()
	_view.map_view.station_requested.emit("S02")
	_expect("map_list_read_effect0", _session.snapshot(), before)
	_expect("map_list_same_id", _view.selected_station, "S02")
	_route()
	_expect("six_stops", _view.row.draft.plan.station_ids, FX.ROUTE_A)
	_expect("prediction_ready", _view.labels.prediction.text.contains("현재 예측"), true)
	_view.name_input.text = "사업 가"
	_view.name_input.text_changed.emit("사업 가")
	_host.present(_session.snapshot())
	_expect("name_buffer_survives_refresh", _view.name_input.text, "사업 가")
	_click("name")
	_expect("explicit_name", _view.row.name, "사업 가")
	_click("submit_city_review")
	_expect("B02_not_guaranteed", _view.labels.requests.text.contains("성공 보장 아님"), true)
	_expect("B02_minimum", _view.labels.requests.text.contains("접수 가능 최저 시각"), true)
	_expect("B02_no_early_review", _view.row.review.is_empty(), true)
	var count: int = _session.snapshot().proposal_ui.snapshot.commands.size()
	_click("submit_city_review")
	_expect(
		"pending_same_request_id", _session.snapshot().proposal_ui.snapshot.commands.size(), count
	)
	_view.station_buttons.S12.pressed.emit()
	_click("remove")
	_at(360)
	_expect("recheck_failed_no_admission", _view.row.review.is_empty(), true)
	_expect("failure_current_separate", _view.labels.requests.text.contains("새 요청 필요"), true)
	_expect("invalid_current_action", _view.controls.submit_city_review.disabled, true)
	_record("B02_recheck_failed")
	_click("add")
	_click("predict")
	_click("submit_city_review")
	_at(361)
	_expect("B02_actual_admission", _view.row.review.admitted_at, 361)
	_expect("B02_actual_period", _view.row.review.completes_at, 391)
	_expect("locked_edit", _view.controls.add.disabled, true)
	before = _session.snapshot()
	_view.station_buttons.S05.pressed.emit()
	_expect("locked_information_read", _view.selected_station, "S05")
	_expect("locked_read_effect0", _session.snapshot(), before)
	_expect("locked_name", _view.name_input.editable, false)
	_record("B02_admitted_locked")
	_at(391)
	_expect("city_completion", _view.row.decisions.back().outcome, "APPROVED")
	await _dispose()


func _branches() -> void:
	for seed_value: int in [2, 0, 8, 1]:
		await _setup(seed_value, 360)
		_route()
		_click("submit_city_review")
		_at(391)
		_click("submit_government_review")
		_at(452)
		var decision: Dictionary = _view.row.decisions.back().duplicate(true)
		_expect(
			"normal_rng:" + str(seed_value),
			decision.outcome,
			{2: "APPROVED", 0: "HELD", 8: "HELD", 1: "REJECTED"}[seed_value]
		)
		if decision.outcome == "HELD":
			_view.name_input.text = "현재 초안"
			_click("name")
			_click("submit_persuasion")
			_expect("persuasion_not_used_on_request", _view.row.persuasion_used_for.size(), 0)
			_at(453)
			_expect("persuasion_used_on_admission", _view.row.persuasion_used_for.size(), 1)
			_expect("held_copy", _view.row.review.submission, decision.submission)
			_at(483)
			_expect(
				"persuasion_branch:" + str(seed_value),
				_view.row.decisions.back().outcome,
				"APPROVED" if seed_value == 8 else "REJECTED"
			)
		_expect("DI03_visible", _view.labels.facts.text.contains("미공급"), true)
		if seed_value in [1, 0]:
			_expect("failure_reentry_block", _view.controls.submit_government_review.disabled, true)
			_expect(
				"failure_not_zero_facts",
				_view.labels.submit_government_review.text.contains("미공급"),
				true
			)
		else:
			_expect("permit_no_contract", _view.row.business_contract.is_empty(), true)
			_expect("permit_no_p05", _view.controls.construction.disabled, true)
			_click("sign_proposal_contract")
			_at(_session.pipeline.clock.minute + 1)
			_expect(
				"actual_payment:" + str(seed_value),
				_view.row.business_contract.government_payment.amount,
				800000 if seed_value == 2 else 640000
			)
			_expect(
				"contract_repeat_disabled", _view.controls.sign_proposal_contract.disabled, true
			)
		_record("B03_branch_" + str(seed_value))
		await _dispose()


func _guard_and_lifetime() -> void:
	await _setup()
	_route()
	var original := _session.snapshot()
	var adopted: Dictionary = _view.previous_packet.duplicate(true)
	_expect("same_packet_read", _view.present(original), true)
	_expect("same_packet_effect0", _session.snapshot(), original)
	var wrong := original.duplicate(true)
	wrong.proposal_ui.snapshot.proposals[0].name = "동일판 상충"
	_host.present(wrong)
	_expect("conflicting_packet_rejected", _view.available, false)
	_expect("previous_not_replaced", _view.previous_packet, adopted)
	_expect("invalid_action_disabled", _view.controls.predict.disabled, true)
	_expect("independent_funds", _host._observation.regions.funds, true)
	_view.controls.predict.pressed.emit()
	_expect("invalid_click_effect0", _session.snapshot(), original)
	_host.present(original)
	_expect("recovered", _view.available, true)
	wrong = original.duplicate(true)
	wrong.run_scope = "old scope"
	_expect("old_scope_discard", _view.present(wrong), false)
	_expect("old_scope_keeps_current", _view.available, true)
	wrong = original.duplicate(true)
	wrong.erase("ui_contract_revision")
	_host.present(wrong)
	_expect("root_invalid_funds", _host._observation.regions.funds, false)
	_expect("root_invalid_proposal", _view.available, false)
	_host.present(original)
	wrong = original.duplicate(true)
	wrong.erase("proposal_ui")
	_host.present(wrong)
	_expect("missing_region", _view.available, false)
	_host.present(original)
	wrong = original.duplicate(true)
	wrong.proposal_ui.snapshot.commands.append(null)
	_host.present(wrong)
	_expect("malformed_consumer_history", _view.available, false)
	_expect("malformed_preserves_previous", _view.previous_packet, adopted)
	_host.present(original)
	_view.station_buttons.S12.pressed.emit()
	wrong = original.duplicate(true)
	wrong.stations = []
	_host.present(wrong)
	_expect("invalid_map_no_read_fallback", _view.station_buttons.is_empty(), true)
	_expect("invalid_map_remove_disabled", _view.controls.remove.disabled, true)
	_view.controls.remove.pressed.emit()
	_expect("invalid_map_no_stale_selection_edit", _session.snapshot(), original)
	_host.present(original)
	var old := _view
	var next := FX.session(2)
	next.enable_operations_ui()
	_host = HostScript.replace_session(_host, next)
	_host.set_process(false)
	_expect("new_session_no_selected_slot", _host.proposal_view.selected_slot, "")
	var next_before := next.snapshot()
	old.command_requested.emit(FX.session_command(_session, "retired", "predict_proposal"))
	_expect("retired_callback_no_effect", next.snapshot(), next_before)
	await process_frame
	await _dispose()


func _display_boundaries() -> void:
	await _setup(2, 360, FX.negative_parameters())
	_route()
	_expect("negative_forecast_available", _view.row.draft.prediction.available, true)
	var original := _session.snapshot()
	var zero := original.duplicate(true)
	zero.view_revision += 1
	zero.proposal_ui.view_revision = zero.view_revision
	var totals: Dictionary = (
		zero.proposal_ui.snapshot.proposals[0].draft.prediction.current.value.totals
	)
	totals.predicted_fare = 0
	totals.operating_cost = 0
	_host.present(zero)
	_expect("zero_fixture_valid", _view.available, true)
	_expect("zero_is_number", _view.labels.prediction.text.contains("예상 운임 0 / 운영비 0"), true)
	var failed := zero.duplicate(true)
	failed.view_revision += 1
	failed.proposal_ui.view_revision = failed.view_revision
	var prediction: Dictionary = failed.proposal_ui.snapshot.proposals[0].draft.prediction
	prediction.previous = prediction.current.duplicate(true)
	prediction.current = {}
	prediction.available = false
	prediction.prediction_status = "FAILED"
	prediction.reason = "DISPLAY_FIXTURE_FAILURE"
	_host.present(failed)
	_expect("failed_fixture_valid", _view.available, true)
	_expect("failed_is_not_zero", _view.labels.prediction.text.begins_with("예측 실패"), true)
	_expect("previous_is_comparison", _view.labels.prediction.text.contains("비교용"), true)
	_expect("stale_view_discard", _view.present(original), false)
	_expect("stale_keeps_latest", _view.shown.view_revision, failed.view_revision)
	for dimensions: Vector2i in [Vector2i(800, 600), Vector2i(1100, 900)]:
		root.size = dimensions
		await process_frame
		await process_frame
		for key: String in ["prediction", "requests", "facts", "contract"]:
			_expect(
				"headless_layout_width:" + str(dimensions) + key,
				_view.labels[key].size.x <= _view.size.x + 1,
				true
			)
	_samples.B06_display_fixtures = {
		"kind": "DISPLAY_VALUE_FIXTURE_NOT_NATURAL_GAME",
		"zero": zero.proposal_ui,
		"failed": failed.proposal_ui
	}
	await _dispose()


func _keyboard_and_reading() -> void:
	await _setup()
	var before := _session.snapshot()
	_view.controls["P-B"].grab_focus()
	await process_frame
	var key := InputEventKey.new()
	key.keycode = KEY_ENTER
	key.pressed = true
	Input.parse_input_event(key)
	await process_frame
	key.pressed = false
	Input.parse_input_event(key)
	await process_frame
	_expect("synthetic_keyboard_slot", _view.selected_slot, "P-B")
	_expect("keyboard_read_effect0", _session.snapshot(), before)
	_view.controls["P-A"].grab_focus()
	key = InputEventKey.new()
	key.keycode = KEY_END
	key.pressed = true
	_expect(
		"reading_end_handled", HostScript.read_construction_key(_host._scroll, _view, key), true
	)
	_expect("reading_no_focus_jump", root.gui_get_focus_owner(), _view.controls["P-A"])
	_expect("reading_follow_disabled", _host._scroll.follow_focus, false)
	var saved_scroll: int = _host._scroll.scroll_vertical
	_host.controls.open_finance.pressed.emit()
	_host.finance_view.controls.back.pressed.emit()
	await process_frame
	await process_frame
	await process_frame
	_expect("read_return_slot", _view.selected_slot, "P-B")
	_expect("read_return_scroll", _host._scroll.scroll_vertical, saved_scroll)
	_host.controls.open_finance.pressed.emit()
	_host.finance_view.controls.back.pressed.emit()
	_view.controls.back.grab_focus()
	await process_frame
	await process_frame
	await process_frame
	_expect("return_respects_user_focus", root.gui_get_focus_owner(), _view.controls.back)
	await _dispose()


func _business_flow() -> void:
	await _setup(2, 360)
	_route()
	_click("submit_city_review")
	_at(391)
	_click("submit_government_review")
	_at(452)
	_click("sign_proposal_contract")
	_at(453)
	var project: String = _view.row.business_contract.project_id
	_click("construction")
	_expect("P05_visible", _host.construction_view.visible, true)
	_expect("P05_same_project", _host.construction_view.selected_id, project)
	for action: String in ["contract", "start"]:
		_p05(action)
	var started: int = _session.snapshot().construction_ui.snapshot.projects[0].started_at
	_at(started + 2880)
	_p05("trial")
	_at(_session.pipeline.clock.minute + 60)
	_p05("safety")
	_at(_session.pipeline.clock.minute + 60)
	_p05("open")
	_expect(
		"actual_operating_source",
		_session.pipeline.operations_snapshot().source.project_id,
		project
	)
	_at(4320)
	_expect(
		"actual_report_ready", _session.pipeline.operations_snapshot().first_valid_report.day_id, 3
	)
	_host.construction_view.controls.back.pressed.emit()
	await process_frame
	await process_frame
	_expect("P05_return_proposal", _view.visible, true)
	_expect("P05_return_same_slot", _view.selected_slot, "P-A")
	var before := _session.snapshot()
	_host.controls.open_operations.pressed.emit()
	_host.operations_view.controls.finance.pressed.emit()
	_host.finance_view.controls.first.pressed.emit()
	_expect("P07_selected_report_day", _session.snapshot().finance_ui.report.day_id, 3)
	var ledger := _session.pipeline.ledger.entries()
	var draws: int = _session.snapshot().proposal_ui.snapshot.rng.draw_count
	_host.finance_view.controls.query.pressed.emit()
	_expect("next_query_tenders", _host.tender_view.visible, true)
	_expect("next_proposal_choice_visible", _host.controls.open_proposals.visible, true)
	_host.controls.open_proposals.pressed.emit()
	_expect("next_proposal_explicit_move", _view.visible, true)
	_expect("candidate_query_no_payment", _session.pipeline.ledger.entries(), ledger)
	_expect(
		"candidate_query_no_rng", _session.snapshot().proposal_ui.snapshot.rng.draw_count, draws
	)
	_view.controls.back.pressed.emit()
	await process_frame
	await process_frame
	await process_frame
	_expect("candidate_return_report", _host.finance_view.visible, true)
	_expect("candidate_return_report_day", _session.snapshot().finance_ui.report.day_id, 3)
	_record("B05_control_chain_report_candidate")
	before = _session.snapshot()
	_host.finance_view.controls.back.pressed.emit()
	await process_frame
	await process_frame
	_host.operations_view.controls.back.pressed.emit()
	await process_frame
	await process_frame
	_expect("P06_P07_return_proposal", _view.visible, true)
	_expect("reading_roundtrip_effect0", _session.snapshot(), before)
	await _dispose()


func _p05(action: String) -> void:
	var control: Button = _host.construction_view.controls[action]
	_expect("p05_enabled:" + action, control.disabled, false)
	control.pressed.emit()
	_at(_session.pipeline.clock.minute + 1)


func _prediction_boundaries() -> void:
	_expect("unknown_reason_neutral", Text.reason("UNKNOWN_INTERNAL_CODE"), "상태를 확인할 수 없습니다")
	_expect("unreceived_time", Text.time_text(null), "미확인")
	_expect("midnight_time", Text.time_text(1440), "게임일 2 00:00")
	for status: String in ["NOT_CALCULATED", "FAILED", "READY"]:
		var output := Text.prediction({"prediction_status": status, "available": false})
		_expect(
			"prediction_state:" + status,
			output.contains(
				{"NOT_CALCULATED": "예측 전", "FAILED": "예측 실패", "READY": "현재 예측"}[status]
			),
			true
		)
