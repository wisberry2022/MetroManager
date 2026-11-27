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
var _access_cases: Array[Dictionary] = []
var _input_observation: Dictionary = {}


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure", false, true)
	elif "--f04-only" in OS.get_cmdline_user_args():
		await _focus_ordering()
		await _restore_edges()
	else:
		await _main_entry()
		await _keyboard_and_reading()
		await _editing_and_office()
		await _branches()
		await _guard_and_lifetime()
		await _display_boundaries()
		await _business_flow()
		_prediction_boundaries()
		print("KEYBOARD_FOCUS_STAGE inventory")
		await _keyboard_inventory()
		print("KEYBOARD_FOCUS_STAGE actions")
		await _keyboard_actions()
		print("KEYBOARD_FOCUS_STAGE ordering")
		await _focus_ordering()
		await _restore_edges()
	var output := "res://.local/validation/DEV-027/screen-integration/view.json"
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("--output="):
			output = argument.trim_prefix("--output=")
	var evidence := {
		"checks": _checks,
		"failures": _failures,
		"assertions": _assertions,
		"samples": _samples,
		"keyboard_focus": _access_cases,
		"scope": "HEADLESS_CONTROL_SYNTHETIC_INPUT_NOT_OS_GUI"
	}
	_expect("write_evidence", FX.save(output, evidence), true)
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
		var parsed: Dictionary = MainScript.proposal_seed(["--w04b-seed=" + seed_value])
		_expect("seed:" + seed_value, parsed.seed, int(seed_value))
	for arguments: PackedStringArray in [
		["--w04b-seed"], ["--w04b-seed=3"], ["--w04b-seed=-1"], ["--w04b-seed=2", "--w04b-seed=2"]
	]:
		var accepted: bool = MainScript.proposal_seed(arguments).accepted
		_expect("invalid_seed:" + str(arguments), accepted, false)
	_expect("default_random_seed", MainScript.proposal_seed([]).accepted, true)
	var main := Main.instantiate()
	root.add_child(main)
	await process_frame
	var product: Control = main.get_child(main.get_child_count() - 1)
	product.set_process(false)
	var before: Dictionary = product.session.snapshot()
	_expect("actual_main_installs_proposals", before.proposal_ui.available, true)
	_expect("main_operations_preserved", before.operations_ui.available, true)
	_host = product
	_view = product.proposal_view
	_session = product.session
	await _activate(product.controls.open_proposals, "K01:main_initial")
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
	var pending: int = _session.snapshot().proposal_ui.snapshot.commands.size()
	_expect("pending_same_request_id", pending, count)
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
		var expected: String = {2: "APPROVED", 0: "HELD", 8: "HELD", 1: "REJECTED"}[seed_value]
		_expect("normal_rng:" + str(seed_value), decision.outcome, expected)
		if decision.outcome == "HELD":
			_view.name_input.text = "현재 초안"
			_click("name")
			_click("submit_persuasion")
			_expect("persuasion_not_used_on_request", _view.row.persuasion_used_for.size(), 0)
			_at(453)
			_expect("persuasion_used_on_admission", _view.row.persuasion_used_for.size(), 1)
			_expect("held_copy", _view.row.review.submission, decision.submission)
			_at(483)
			expected = "APPROVED" if seed_value == 8 else "REJECTED"
			_expect(
				"persuasion_branch:" + str(seed_value), _view.row.decisions.back().outcome, expected
			)
		_expect("DI03_visible", _view.labels.facts.text.contains("미공급"), true)
		if seed_value in [1, 0]:
			_expect("failure_reentry_block", _view.controls.submit_government_review.disabled, true)
			var facts: String = _view.labels.submit_government_review.text
			_expect("failure_not_zero_facts", facts.contains("미공급"), true)
		else:
			_expect("permit_no_contract", _view.row.business_contract.is_empty(), true)
			_expect("permit_no_p05", _view.controls.construction.disabled, true)
			_click("sign_proposal_contract")
			_at(_session.pipeline.clock.minute + 1)
			var amount: int = _view.row.business_contract.government_payment.amount
			_expect(
				"actual_payment:" + str(seed_value), amount, 800000 if seed_value == 2 else 640000
			)
			var disabled: bool = _view.controls.sign_proposal_contract.disabled
			_expect("contract_repeat_disabled", disabled, true)
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
		await _frames(2)
		for key: String in ["prediction", "requests", "facts", "contract"]:
			var fits: bool = _view.labels[key].size.x <= _view.size.x + 1
			_expect("headless_layout_width:" + str(dimensions) + key, fits, true)
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
	await _frames(3)
	_expect("read_return_slot", _view.selected_slot, "P-B")
	_expect("read_return_scroll", _host._scroll.scroll_vertical, saved_scroll)
	_host.controls.open_finance.pressed.emit()
	_host.finance_view.controls.back.pressed.emit()
	_view.controls.back.grab_focus()
	await _frames(3)
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
	await _frames(2)
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
	await _frames(3)
	_expect("candidate_return_report", _host.finance_view.visible, true)
	_expect("candidate_return_report_day", _session.snapshot().finance_ui.report.day_id, 3)
	_record("B05_control_chain_report_candidate")
	before = _session.snapshot()
	_host.finance_view.controls.back.pressed.emit()
	await _frames(2)
	_host.operations_view.controls.back.pressed.emit()
	await _frames(2)
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
	var expected := {"NOT_CALCULATED": "예측 전", "FAILED": "예측 실패", "READY": "현재 예측"}
	for status: String in expected:
		var output := Text.prediction({"prediction_status": status, "available": false})
		_expect("prediction_state:" + status, output.contains(expected[status]), true)


func _input_key(code: int, reverse: bool = false, character: int = 0) -> void:
	for pressed: bool in [true, false]:
		var event := InputEventKey.new()
		event.keycode = code
		event.unicode = character
		event.shift_pressed = reverse
		event.pressed = pressed
		root.push_input(event)
		if pressed:
			_input_observation = {"handled": root.is_input_handled(), "kind": "key"}


func _frames(count: int = 4) -> void:
	for index: int in range(count):
		await process_frame


func _focus_state() -> Dictionary:
	return FX.focus_state(_host, _session, root)


func _tab_to(target: Control, id: String, reverse: bool = false) -> bool:
	var trace: Array = []
	for step: int in range(100):
		var owner := root.gui_get_focus_owner()
		if owner == target:
			break
		_input_key(KEY_TAB, reverse)
		await _frames(2)
		owner = root.gui_get_focus_owner()
		trace.append(str(owner.get_path()) if owner != null else "")
	var reached: bool = root.gui_get_focus_owner() == target
	_expect(id + ":tab_reached", reached, true)
	_expect(
		id + ":focus_intersects_scroll",
		reached and _host._scroll.get_global_rect().intersects(target.get_global_rect()),
		true
	)
	_access_cases.append(
		{
			"id": id,
			"kind": "SYNTHETIC_TAB_NOT_OS",
			"reverse": reverse,
			"target": str(target.get_path()),
			"reached": reached,
			"trace": trace,
			"state": _focus_state(),
			"os_status": "NOT_RUN"
		}
	)
	return reached


func _activate(target: Control, id: String, code: int = KEY_ENTER) -> void:
	if not await _tab_to(target, id):
		return
	_input_key(code)
	await _frames()


func _command_key(id: String, case_id: String, code: int = KEY_ENTER) -> void:
	var commands: Array[Dictionary] = []
	var capture := func(command: Dictionary) -> void: commands.append(command.duplicate(true))
	_view.command_requested.connect(capture)
	await _activate(_view.controls[id], case_id, code)
	_view.command_requested.disconnect(capture)
	_expect(case_id + ":one_command", commands.size(), 1)
	if commands.size() != 1:
		return
	var command: Dictionary = commands[0]
	var action: String = id if id in Text.ACTIONS else "edit_proposal"
	if id == "predict":
		action = "predict_proposal"
	_expect(case_id + ":action", command.action, action)
	_expect(case_id + ":slot", command.slot_id, _view.selected_slot)
	_access_cases.append(
		{"id": case_id + ":activation", "kind": "SYNTHETIC_ACTIVATION", "command": command}
	)


func _tab_cycle(id: String) -> void:
	var before := _session.snapshot()
	var initial := root.gui_get_focus_owner()
	var visited: Array = []
	var outside_controls: Array = []
	for step: int in range(100):
		_input_key(KEY_TAB)
		await _frames(2)
		var owner := root.gui_get_focus_owner()
		var valid: bool = owner != null and Guard.focus_valid(owner)
		if owner == null or _view.is_ancestor_of(owner):
			_expect(id + ":valid:" + str(step), valid, true)
		else:
			outside_controls.append({"path": str(owner.get_path()), "focus_valid": valid})
		if owner == null:
			break
		visited.append(str(owner.get_path()))
		if owner == initial:
			break
	_expect(id + ":cycle_returns", root.gui_get_focus_owner(), initial)
	_expect(id + ":no_model_effect", _session.snapshot(), before)
	_access_cases.append(
		{
			"id": id,
			"kind": "SYNTHETIC_TAB_CYCLE",
			"visited": visited,
			"outside_proposal_scope": outside_controls
		}
	)


func _keyboard_inventory() -> void:
	root.size = Vector2i(1100, 900)
	await _setup()
	await _frames()
	# Only this starting anchor is assigned; every target below is reached with Tab.
	_view.labels.title.grab_focus()
	var before := _session.snapshot()
	await _activate(_view.controls["P-B"], "K02:P-B", KEY_SPACE)
	_expect("K02:explicit_P-B", _view.selected_slot, "P-B")
	await _tab_to(_view.controls["P-A"], "K02:P-A:reverse", true)
	_expect("K02:focus_is_not_selection", _view.selected_slot, "P-B")
	_input_key(KEY_ENTER)
	await _frames()
	_expect("K02:explicit_P-A", _view.selected_slot, "P-A")
	_expect("K02:read_effect0", _session.snapshot(), before)
	_route()  # State preparation with existing fixture; not keyboard route construction.
	await _frames()
	await _step_to(_view.name_input, _view.controls.remove, "K01-12:disabled_add")
	before = _session.snapshot()
	for id: String in _view.station_buttons:
		for group: String in ["list", "map"]:
			var target: Control = (
				_view.station_buttons[id] if group == "list" else _view.map_view.markers[id]
			)
			await _activate(target, "K03:" + group + ":" + id)
			_expect("K03:selected:" + group + ":" + id, _view.selected_station, id)
	_expect("K03:all_reads_effect0", _session.snapshot(), before)
	await _step_to(_view.name_input, _view.plan_list, "K01-04:reverse", true)
	await _tab_to(_view.plan_list, "K04:list")
	_input_key(KEY_UP)
	await _frames()
	_expect("K04:selection", _view.selected_station, FX.ROUTE_A[-2])
	_expect("K04:read_effect0", _session.snapshot(), before)
	_input_key(KEY_DOWN)
	await _frames()
	_expect("K01-04:last_selected", _view.selected_station, "S12")
	var list: ItemList = _view.plan_list
	var rect := list.get_item_rect(list.item_count - 1)
	rect.position.y -= list.get_v_scroll_bar().value
	var global_rect := Rect2(list.global_position + rect.position, rect.size)
	_expect("K01-04:last_row_inside_list", Rect2(Vector2.ZERO, list.size).encloses(rect), true)
	_expect(
		"K01-04:last_row_inside_outer", _host._scroll.get_global_rect().encloses(global_rect), true
	)
	_expect("K01-04:read_effect0", _session.snapshot(), before)
	_access_cases.append(
		{
			"id": "K01-04",
			"kind": "SELECTED_ROW_GEOMETRY_NOT_OS",
			"row_rect": str(rect),
			"list_rect": str(list.get_global_rect()),
			"outer_rect": str(_host._scroll.get_global_rect()),
			"list_scroll": list.get_v_scroll_bar().value,
			"state": _focus_state()
		}
	)
	await _tab_to(_view.map_view.markers.S12, "K04:exit_reverse", true)
	await _tab_to(_view.name_input, "K05:name")
	var scroll: int = _host._scroll.scroll_vertical
	_input_key(KEY_END)
	_input_key(KEY_A, false, 97)
	await _frames()
	_expect("K05:buffer_only", _session.snapshot(), before)
	_expect("K05:typed_character", _view.name_input.text.ends_with("a"), true)
	_input_key(KEY_LEFT)
	_input_key(KEY_RIGHT)
	_input_key(KEY_LEFT, true)
	_expect("K05:select_character", _view.name_input.get_selected_text(), "a")
	_input_key(KEY_BACKSPACE)
	_expect("K05:delete_selection", _view.name_input.text, _view.row.name)
	_input_key(KEY_A, false, 97)
	_input_key(KEY_HOME)
	await _frames()
	_expect("K05:caret_home", _view.name_input.caret_column, 0)
	_expect("K05:no_outer_scroll", _host._scroll.scroll_vertical, scroll)
	_expect("K05:editing_still_buffer_only", _session.snapshot(), before)
	await _command_key("name", "K05:apply", KEY_SPACE)
	_expect("K05:applied_name", _view.row.name.ends_with("a"), true)
	await _command_key("predict", "K07:predict")
	await _activate(_view.station_buttons.S02, "K06:select")
	for action: String in ["up", "down", "remove", "add"]:
		var stops: Array = _view.row.draft.plan.station_ids.duplicate()
		var index: int = stops.find("S02")
		if action == "add":
			stops.append("S02")
		else:
			stops.remove_at(index)
			if action in ["up", "down"]:
				stops.insert(index + (-1 if action == "up" else 1), "S02")
		await _command_key(action, "K06:" + action)
		_expect("K06:payload:" + action, _view.row.draft.plan.station_ids, stops)
	before = _session.snapshot()
	await _activate(_view.controls.refresh, "K11:refresh")
	_expect("K11:refresh_effect0", _session.snapshot(), before)
	await _tab_cycle("K12:enabled_cycle")
	await _activate(_view.controls.back, "K11:back")
	_expect("K11:back_to_plan", _view.visible, false)
	await _activate(_host.controls.open_proposals, "K01:host_entry")
	_expect("K01:real_view", _view.visible, true)
	_expect("K11:reentry_keeps_explicit_slot", _view.selected_slot, "P-A")
	await _tab_to(_view.labels.title, "K12:title")
	before = _session.snapshot()
	_input_key(KEY_ENTER)
	await _frames()
	_expect("K12:title_has_no_command", _session.snapshot(), before)
	await _dispose()


func _keyboard_actions() -> void:
	for seed_value: int in [2, 8]:
		await _setup(seed_value, 360)
		_route()
		await _frames()
		_view.labels.title.grab_focus()
		await _tab_to(_view.controls.submit_city_review, "K08:reverse:" + str(seed_value), true)
		await _command_key("submit_city_review", "K08:city:" + str(seed_value))
		_at(361)
		await _frames()
		_expect("K12:locked_owner_valid", Guard.focus_valid(root.gui_get_focus_owner()), true)
		var before := _session.snapshot()
		await _activate(_view.station_buttons.S05, "K03:locked_list:" + str(seed_value))
		_expect("K03:locked_read_effect0", _session.snapshot(), before)
		await _tab_cycle("K12:locked:" + str(seed_value))
		_at(391)
		await _frames()
		await _command_key("submit_government_review", "K09:government:" + str(seed_value))
		await _step_to(
			_view.controls.submit_government_review,
			_view.controls.refresh,
			"K01-12:request_pending:" + str(seed_value)
		)
		_at(392)
		await _step_to(
			_view.name_input, _view.controls.refresh, "K01-12:review_pending:" + str(seed_value)
		)
		_at(452)
		await _frames()
		if seed_value == 8:
			await _step_to(
				_view.controls.refresh, _view.controls.submit_persuasion, "K01-14:reverse", true
			)
			await _step_to(
				_view.controls.predict, _view.controls.submit_city_review, "K01-14:forward_city"
			)
			await _step_to(
				_view.controls.submit_city_review,
				_view.controls.submit_persuasion,
				"K01-14:forward_persuasion"
			)
			await _command_key("submit_persuasion", "K09:persuasion", KEY_SPACE)
			_at(483)
			await _frames()
		await _step_to(
			_view.controls.refresh,
			_view.controls.sign_proposal_contract,
			"K01-13:reverse:" + str(seed_value),
			true
		)
		await _command_key("sign_proposal_contract", "K09:contract:" + str(seed_value))
		_at(_session.pipeline.clock.minute + 1)
		await _frames()
		await _activate(_view.controls.construction, "K10:P05:" + str(seed_value))
		_expect(
			"K10:same_project",
			_host.construction_view.selected_id,
			_view.row.business_contract.project_id
		)
		await _activate(_host.construction_view.controls.back, "K10:return:" + str(seed_value))
		_expect("K10:return_slot", _view.selected_slot, "P-A")
		before = _session.snapshot()
		await _activate(_host.controls.open_finance, "K11:finance:" + str(seed_value))
		await _activate(_host.finance_view.controls.back, "K11:saved_return:" + str(seed_value))
		_expect("K11:finance_return_effect0", _session.snapshot(), before)
		await _dispose()


func _focus_probe(mode: String, input: String, delay: int) -> void:
	await _setup(2, 360)
	if mode == "return_p05":
		_route()
		_click("submit_city_review")
		_at(391)
		_click("submit_government_review")
		_at(452)
		_click("sign_proposal_contract")
		_at(453)
	await _frames()
	_view.controls["P-A"].grab_focus()
	await _frames()
	var limit: int = _focus_state().limit
	_host._scroll.scroll_vertical = limit / 2
	var context: Dictionary = _host._reading_context()
	if mode == "return_p05" and input == "none":
		_view.controls.construction.grab_focus()
		await _frames()
		context = _host._reading_context()
		_expect("F01:P05_saved_focus_visible", _focus_state().owner_intersects_scroll, true)
	var trace: Array = [_focus_state()]
	var before := _session.snapshot()
	if mode == "ensure":
		_host._ensure_focus_region(_view.controls["P-A"])
	elif mode == "return_p07":
		_host.controls.open_finance.pressed.emit()
		await _frames()
		trace[0] = _focus_state()
		_host.finance_view.controls.back.pressed.emit()
	elif mode == "return_p05":
		_view.controls.construction.pressed.emit()
		await _frames()
		trace[0] = _focus_state()
		_host.construction_view.controls.back.pressed.emit()
	else:
		# Component ordering test: retain a visible owner; not an OS P05/P07 return.
		_host._restore_reading(context)
	await _frames(delay)
	trace.append(_focus_state())
	_input_observation = {}
	var wheel := input.begins_with("wheel")
	if wheel:
		var code := MOUSE_BUTTON_WHEEL_UP if input == "wheel_up" else MOUSE_BUTTON_WHEEL_DOWN
		var target: Control = _host._scroll.get_v_scroll_bar() if input == "wheel_bar" else null
		_input_observation = FX.wheel(root, _host._scroll, code, target)
	elif input == "navigate":
		_host.controls.open_finance.pressed.emit()
	elif input != "none":
		var keys := {
			"home": KEY_HOME,
			"end": KEY_END,
			"page_up": KEY_PAGEUP,
			"page_down": KEY_PAGEDOWN,
			"tab": KEY_TAB
		}
		_input_key(keys[input])
	var after_input := _focus_state()
	trace.append(after_input)
	for frame: int in range(5):
		await process_frame
		trace.append(_focus_state())
	var last: Dictionary = trace.back()
	var moved: bool = after_input.scroll != trace[1].scroll
	var same_owner: bool = after_input.owner_valid and after_input.owner == trace[1].owner
	var group := ("F03" if input.begins_with("wheel") else "F02") if mode == "ensure" else "F04"
	var row_id := group + ":" + input + ":" + str(delay)
	if input == "none":
		row_id = "F01:" + mode
	elif input in ["tab", "navigate"]:
		row_id = "F05:" + mode + ":" + input
	_expect(row_id + ":read_effect0", _session.snapshot(), before)
	var applicable: bool = moved and same_owner
	if wheel:
		var start: Dictionary = trace[1]
		applicable = moved and _input_observation.handled and start.screen == after_input.screen
		applicable = (
			applicable and start.scope == last.scope and start.generation == last.generation
		)
		_expect(row_id + ":wheel_input:" + mode, applicable, true)
		_expect(row_id + ":wheel_preserved:" + mode, last.scroll, after_input.scroll)
	var status := "OBSERVED_REVIEW_REQUIRED"
	if input not in ["none", "tab", "navigate"] and not applicable:
		status = "INCONCLUSIVE"
	if mode == "restore" and input in ["home", "end", "page_up", "page_down"]:
		_expect(row_id + ":valid_input", moved and same_owner, true)
		_expect(row_id + ":preserves_reading", last.scroll, after_input.scroll)
	_access_cases.append(
		{
			"id": row_id + ":" + mode,
			"kind": "SYNTHETIC_INPUT_COMPONENT_ORDERING",
			"mode": mode,
			"input": input,
			"delay_frames": delay,
			"trace": trace,
			"input_moved_scroll": moved,
			"input_observation": _input_observation.duplicate(),
			"saved_scroll": context.scroll,
			"same_owner_at_input": same_owner,
			"proposed_user_scroll_preserved": last.scroll == after_input.scroll,
			"priority_expectation_applicable":
			input not in ["none", "tab", "navigate"] and applicable,
			"status": status,
			"design_status": "PENDING",
			"os_status": "NOT_RUN"
		}
	)
	if input == "none" and mode != "ensure":
		_expect("F01:restore_without_input", last.scroll, context.scroll)
		if mode == "return_p05":
			_expect("F01:P05_no_input_owner", last.owner, str(context.focus.get_path()))
			_expect("F01:P05_no_input_visible", last.owner_intersects_scroll, true)
	if input in ["tab", "navigate"]:
		_expect("F05:late_callback_keeps_new_owner", last.owner, after_input.owner)
		_expect("F05:late_callback_keeps_screen", last.screen, after_input.screen)
	_input_key(KEY_TAB)
	await _frames()
	_expect("F06:follow_reenabled", _host._scroll.follow_focus, true)
	_expect("F06:focus_valid", Guard.focus_valid(root.gui_get_focus_owner()), true)
	_expect("F06:focus_visible", _focus_state().owner_intersects_scroll, true)
	await _dispose()


func _focus_ordering() -> void:
	root.size = Vector2i(800, 600)
	root.notify_mouse_entered()
	for mode: String in ["ensure", "restore"]:
		for input: String in [
			"none", "home", "end", "page_up", "page_down", "wheel_up", "wheel_down", "tab"
		]:
			await _focus_probe(mode, input, 0)
	for input: String in ["end", "wheel_down"]:
		for delay: int in [1, 3]:
			await _focus_probe("restore", input, delay)
	for mode: String in ["ensure", "restore"]:
		await _focus_probe(mode, "navigate", 0)
	await _focus_probe("restore", "wheel_bar", 0)
	for mode: String in ["return_p05", "return_p07"]:
		for input: String in ["none", "end", "wheel_down"]:
			await _focus_probe(mode, input, 1)
	root.notify_mouse_exited()


func _step_to(start: Control, target: Control, id: String, reverse: bool = false) -> void:
	if root.gui_get_focus_owner() != start:
		await _tab_to(start, id + ":start")
	_expect(id + ":starting_owner", root.gui_get_focus_owner(), start)
	var before := _session.snapshot()
	var trace: Array = [_focus_state()]
	_input_key(KEY_TAB, reverse)
	trace.append(_focus_state())
	_expect(id + ":immediate_owner", root.gui_get_focus_owner(), target)
	# Exercise the real invalid-focus fallback after the input, like periodic present.
	_host.present(_session.snapshot())
	await _frames()
	trace.append(_focus_state())
	_expect(id + ":settled_owner", root.gui_get_focus_owner(), target)
	_expect(id + ":settled_visible", _focus_state().owner_intersects_scroll, true)
	_expect(id + ":read_effect0", _session.snapshot(), before)
	_expect(id + ":valid", Guard.focus_valid(root.gui_get_focus_owner()), true)
	_access_cases.append(
		{
			"id": id,
			"kind": "SINGLE_TAB_CHAIN_NOT_OS",
			"reverse": reverse,
			"target": str(target.get_path()),
			"trace": trace
		}
	)


func _restore_edges() -> void:
	root.notify_mouse_entered()
	for action: String in [
		"clamp", "inner", "roundtrip", "old_scope", "replace", "clamp_wheel", "inner_wheel"
	]:
		await _setup(2, 360)
		if action == "inner_wheel":
			for id: String in FX.ROUTE_8:
				_view.station_buttons[id].pressed.emit()
				_click("add")
		_view.controls["P-A"].grab_focus()
		await _frames()
		_host._scroll.scroll_vertical = _focus_state().limit / 2
		var context: Dictionary = _host._reading_context()
		_host._scroll.scroll_vertical = 0
		if action == "inner":
			_view.name_input.grab_focus()
		if action == "old_scope":
			context.scope = "old scope"
		var before := _session.snapshot()
		_host._restore_reading(context)
		if action == "inner_wheel":
			_host._scroll.ensure_control_visible(_view.plan_list)
			await process_frame
		var trace: Array = [_focus_state()]
		if action == "roundtrip":
			_input_key(KEY_END)
			trace.append(_focus_state())
			_input_key(KEY_HOME)
		elif action == "replace":
			var next := FX.session(2)
			next.enable_operations_ui()
			_host = HostScript.replace_session(_host, next)
			_host.set_process(false)
			_session = next
			before = next.snapshot()
		elif action in ["clamp_wheel", "inner_wheel"]:
			var list_bar: VScrollBar = _view.plan_list.get_v_scroll_bar()
			var inner_before := list_bar.value
			var target: Control = _view.plan_list if action == "inner_wheel" else null
			var code := MOUSE_BUTTON_WHEEL_DOWN if target != null else MOUSE_BUTTON_WHEEL_UP
			_input_observation = FX.wheel(root, _host._scroll, code, target)
			_expect(
				"F04:edge:inner_wheel_moved:" + action,
				list_bar.value > inner_before,
				target != null
			)
			_expect("F04:edge:no_outer_move:" + action, _focus_state().scroll, trace[0].scroll)
		else:
			_input_key(KEY_END if action == "inner" else KEY_HOME)
		trace.append(_focus_state())
		for frame: int in range(5):
			await process_frame
			trace.append(_focus_state())
		var restores := action.begins_with("clamp") or action.begins_with("inner")
		var expected: int = context.scroll if restores else 0
		_expect("F04:edge:" + action, trace.back().scroll, expected)
		_expect("F04:edge_effect0:" + action, _session.snapshot(), before)
		_access_cases.append(
			{"id": "F04:edge:" + action, "trace": trace, "kind": "COMPONENT_NOT_OS"}
		)
		await _dispose()
	root.notify_mouse_exited()
