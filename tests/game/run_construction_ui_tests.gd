extends SceneTree
## 실제 Control 신호와 UI 중개를 검증한다. 직접 GUI 검수와 구분한다.

const FX = preload("res://tests/game/construction_ui_fixtures.gd")
const ConstructionPanel = preload("res://scenes/construction_panel.tscn")
const View = preload("res://scripts/ui/construction_view.gd")
const Stage = preload("res://scenes/stage1.tscn")

var _checks: int = 0
var _failures: int = 0
var _assertions: Array[Dictionary] = []
var _cases: Array[Dictionary] = []
var _focus_cases: Array[Dictionary] = []
var _focus_assertion_start: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if "--obs01-only" in args or "--obs01-baseline" in args:
		await _test_focus_visibility("--obs01-baseline" in args)
		_write_focus_evidence()
		print("DEV021_OBS01_TEST_RESULT checks=", _checks, " failures=", _failures)
		quit(0 if _failures == 0 else 1)
		return
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure", false, true)
	else:
		_test_complete("STANDARD")
		_test_complete("FAST")
		_test_funds()
		_test_observations()
		_test_command_boundaries()
		_test_speeds()
		_test_host()
		_expect("all_required_cases_completed", _cases.size(), 10)
		_expect("assertions_executed", _checks > 100, true)
		_write_evidence()
		await _test_focus_visibility(false)
		_write_focus_evidence()
	print("DEV021_UI_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _panel(session: FX.BidFX.Session) -> View:
	var panel: View = ConstructionPanel.instantiate()
	root.add_child(panel)
	panel.command_requested.connect(
		func(id: String, action: String, seen: Dictionary) -> void:
			session.request_construction(id, action, seen)
			panel.present(session.snapshot().construction_ui)
	)
	panel.select_project("P-A")
	panel.present(session.snapshot().construction_ui)
	return panel


func _step(session: FX.BidFX.Session, panel: View, action: String) -> void:
	_expect(action + "_enabled", panel.controls[action].disabled, false)
	panel.controls[action].pressed.emit()
	_expect(action + "_pending_lock", panel.controls[action].disabled, true)
	FX.BidFX.advance_to(session, session.pipeline.clock.minute + 1)
	panel.present(session.snapshot().construction_ui)


func _test_complete(mode: String) -> void:
	var session := FX.create()
	var initial := session.snapshot()
	var panel := _panel(session)
	_expect("contract_before", "NOT_CREATED" in panel.labels.status.text, true)
	_expect("start_before_contract", panel.controls.start.disabled, true)
	_expect("open_before_contract", panel.controls.open.disabled, true)
	panel.controls.mode.select(0 if mode == "STANDARD" else 1)
	_step(session, panel, "contract")
	_expect("contract_no_auto_start", FX.row(session).started_at, null)
	_expect("contract_id", FX.row(session).construction_contract_id, "B01-R1-BUSINESS-CONSTRUCTION")
	_step(session, panel, "start")
	var start: int = FX.row(session).started_at
	var duration: int = FX.row(session).duration_minutes
	_expect("work_starts_at_effect", start, 1802)
	_expect("initial_progress_zero", FX.row(session).elapsed_minutes, 0)
	FX.BidFX.advance_to(session, start + duration - 1)
	panel.present(session.snapshot().construction_ui)
	_expect("last_minute_not_complete", FX.row(session).status, "BUILDING")
	_expect("no_early_trial", panel.controls.trial.disabled, true)
	FX.BidFX.advance_to(session, start + duration)
	panel.present(session.snapshot().construction_ui)
	var row := FX.row(session)
	_expect("completed", row.status, "COMPLETED")
	_expect("complete_elapsed", row.elapsed_minutes, duration)
	_expect("complete_accrual", row.accrued, row.total_cost)
	_expect("complete_paid", row.paid, row.total_cost)
	_expect("complete_due_zero", row.construction_payable, 0)
	var funds: Dictionary = session.pipeline.snapshot().funds
	_expect("cash_complete", funds.cash, 1200000 if mode == "STANDARD" else 1080000)
	_expect("restricted_complete", funds.restricted, 200000 if mode == "STANDARD" else 80000)
	_expect("free_cash_complete", funds.free_cash, 1000000)
	_expect("reserved_complete", funds.reserved, 0)
	_expect("B_complete", funds.unpaid, 0)
	_expect("UI_accrued_paid_due", "발생 기성" in panel.labels.progress.text, true)
	_expect("UI_B_separate", "운영비 B" in panel.labels.funds.text, true)
	_expect("UI_actual_start_copy", "실제 착공 효력부터" in panel.labels.mode.text, true)
	_expect("no_early_open", panel.controls.open.disabled, true)
	_step(session, panel, "trial")
	var trial_at: int = session.pipeline.clock.minute
	FX.BidFX.advance_to(session, trial_at + 59)
	panel.present(session.snapshot().construction_ui)
	_expect("trial_59", FX.row(session).trial_status, "RUNNING")
	_expect("safety_before_trial_end", panel.controls.safety.disabled, true)
	FX.BidFX.advance_to(session, trial_at + 60)
	panel.present(session.snapshot().construction_ui)
	_step(session, panel, "safety")
	var safety_at: int = session.pipeline.clock.minute
	FX.BidFX.advance_to(session, safety_at + 59)
	_expect("safety_59", FX.row(session).safety_status, "RUNNING")
	FX.BidFX.advance_to(session, safety_at + 60)
	panel.present(session.snapshot().construction_ui)
	if mode == "FAST":
		_expect("fast_first_defect", FX.row(session).defects, 1)
		_expect("fast_safety_failed", FX.row(session).safety_status, "FAILED")
		_expect("defect_prevents_open", panel.controls.open.disabled, true)
		_step(session, panel, "repair")
		var repair_at: int = session.pipeline.clock.minute
		_expect("repair_upfront", FX.row(session).repair_paid, 20000)
		_expect("repair_cash", session.pipeline.snapshot().funds.cash, 1060000)
		_expect("repair_R", session.pipeline.snapshot().funds.restricted, 60000)
		_expect("repair_not_accrual", FX.row(session).accrued, 720000)
		FX.BidFX.advance_to(session, repair_at + 29)
		_expect("repair_29", FX.row(session).defects, 1)
		FX.BidFX.advance_to(session, repair_at + 30)
		panel.present(session.snapshot().construction_ui)
		_expect("repair_30", FX.row(session).defects, 0)
		_expect("repair_needs_retest", panel.controls.open.disabled, true)
		_step(session, panel, "safety")
		FX.BidFX.advance_to(session, session.pipeline.clock.minute + 60)
		panel.present(session.snapshot().construction_ui)
	_expect("safety_passed", FX.row(session).safety_status, "PASSED")
	_step(session, panel, "open")
	_expect("open_effective", FX.row(session).service_ready, true)
	_expect("open_not_operations", "W06 후속" in panel.labels.status.text, true)
	_expect("open_duplicate_disabled", panel.controls.open.disabled, true)
	_record(mode + "_CONTROL_E2E", initial, session)
	panel.free()


func _test_funds() -> void:
	for id: String in ["PAYMENT_DUE", "FINAL_DUE", "RESUME", "REPAIR_SHORT"]:
		var session := FX.create(id)
		var initial := session.snapshot()
		var panel := _panel(session)
		if id == "REPAIR_SHORT":
			_expect("repair_short_disabled", panel.controls.repair.disabled, true)
			_expect("repair_short_reason", "20,000" in panel.labels.repair_reason.text, true)
			var before := session.pipeline.snapshot()
			panel.controls.repair.pressed.emit()
			_expect("disabled_no_partial_or_request", session.pipeline.snapshot(), before)
			_expect("repair_not_started", FX.row(session).repair_paid, 0)
		elif id == "RESUME":
			_step(session, panel, "resume")
			_expect("resume_paid_existing", FX.row(session).paid, 625)
			_expect("resume_no_reaccrual", FX.row(session).accrued, 625)
			_expect("resume_due_zero", FX.row(session).construction_payable, 0)
			_expect("resume_elapsed_preserved", FX.row(session).elapsed_minutes, 3)
		else:
			_expect("suspended", FX.row(session).status, "SUSPENDED")
			_expect("due_209", FX.row(session).construction_payable, 209)
			_expect("due_not_B", session.pipeline.snapshot().funds.unpaid, 0)
			_expect("no_trial_unpaid", panel.controls.trial.disabled, true)
			_expect("no_resume_funds", panel.controls.resume.disabled, true)
			_expect("due_visible", "공사 미지급 209" in panel.labels.progress.text, true)
			var elapsed: int = FX.row(session).elapsed_minutes
			FX.BidFX.advance_to(session, session.pipeline.clock.minute + 10)
			_expect("suspension_preserves_work", FX.row(session).elapsed_minutes, elapsed)
			if id == "PAYMENT_DUE":
				_expect("performed3", elapsed, 3)
				_expect("accrual625", FX.row(session).accrued, 625)
				_expect("paid416", FX.row(session).paid, 416)
			else:
				_expect("full_work_unpaid", elapsed, 2880)
				_expect("full_not_complete_time", FX.row(session).completed_at, null)
		_record(id, initial, session)
		panel.free()


func _test_observations() -> void:
	var session := FX.create("PROGRESS")
	var panel := _panel(session)
	var before := session.pipeline.snapshot()
	for index: int in 3:
		session.refresh_construction()
		panel.present(session.snapshot().construction_ui)
	_expect("queries_no_effect", session.pipeline.snapshot(), before)
	var old: Dictionary = session.snapshot().construction_ui
	FX.BidFX.advance_to(session, session.pipeline.clock.minute + 1)
	panel.present(session.snapshot().construction_ui)
	var current := panel.shown.duplicate(true)
	var button_state: bool = panel.controls.open.disabled
	old.status = "FAILED"
	old.reason = "LATE_QUERY_FAILURE"
	_expect("old_failure_rejected", panel.present(old), false)
	_expect("current_not_overwritten", panel.shown, current)
	_expect("buttons_not_overwritten", panel.controls.open.disabled, button_state)
	var changed := current.duplicate(true)
	changed.snapshot.ui_contract_revision = "UNKNOWN"
	_expect("unknown_contract_rejected", panel.present(changed), false)
	for id: String in ["ERROR", "UNAVAILABLE", "EMPTY"]:
		session.refresh_construction()
		_expect("fixture_accepted_" + id, panel.present(FX.packet(session, id)), true)
		_expect("missing_disables_contract_" + id, panel.controls.contract.disabled, true)
		_expect("missing_disables_open_" + id, panel.controls.open.disabled, true)
		_expect("missing_is_not_zero_" + id, panel.labels.progress.text, "")
		session.refresh_construction()
		panel.present(session.snapshot().construction_ui)
		_expect("recovery_restores_progress", "수행 공정" in panel.labels.progress.text, true)
	var record := {
		"command":
		{"command_id": "old-failure", "project_id": "P-A", "action": "open", "requested_at": 1},
		"result":
		{
			"command_id": "old-failure",
			"pending": false,
			"accepted": false,
			"reason_codes": ["STATE_CHANGED"],
			"result_revision": 1
		}
	}
	current = panel.shown.duplicate(true)
	_expect("old_result_history_only", panel.accept_result(record), true)
	_expect("history_does_not_override_snapshot", panel.shown, current)
	record.result.pending = true
	_expect("late_pending_not_regress", panel.accept_result(record), false)
	panel.free()


func _test_command_boundaries() -> void:
	var session := FX.create()
	var seen := FX.confirmed(session)
	var pending := session.request_construction("same-id", "contract", seen)
	var before := session.pipeline.snapshot()
	_expect("contract_pending", pending.pending, true)
	session.advance_usec(10000000)
	_expect("pause_keeps_snapshot", session.pipeline.snapshot(), before)
	_expect("same_id_pending", session.request_construction("same-id", "open", {}), pending)
	FX.BidFX.advance_to(session, 1801)
	var result := session.pipeline.construction_result("same-id")
	_expect("same_id_complete", session.request_construction("same-id", "repair", {}), result)
	_expect("only_one_contract", session.snapshot().construction_ui.snapshot.projects.size(), 1)
	before = session.pipeline.snapshot()
	session.request_construction(
		"stale-condition",
		"start",
		{
			"project_id": "P-A",
			"business_contract_id": "B01-R1-BUSINESS",
			"snapshot_revision": 0,
			"target_revision": 999
		}
	)
	FX.BidFX.advance_to(session, 1802)
	_expect(
		"condition_revision_guard",
		session.pipeline.construction_result("stale-condition").reason,
		"STATE_CHANGED"
	)
	_expect("rejection_no_money", session.pipeline.snapshot().funds, before.funds)
	_expect("rejection_no_start", FX.row(session).started_at, null)
	# 시각만 경과한 snapshot 판은 대상 조건 변경과 다르다.
	session.request_construction("old-observation-valid-target", "start", seen)
	FX.BidFX.advance_to(session, 1803)
	_expect("old_snapshot_valid_target", FX.row(session).started_at, 1803)
	var night := FX.create()
	FX.BidFX.advance_to(night, 2880)
	var request := night.request_construction("night-contract", "contract", FX.confirmed(night))
	_expect("night_contract_deferred", request.effective_at, 3240)
	FX.BidFX.advance_to(night, 3239)
	_expect("night_no_early_contract", FX.row(night), {})
	FX.BidFX.advance_to(night, 3240)
	_expect("night_effective_contract", FX.row(night).contract_effective_at, 3240)
	_record("COMMAND_BOUNDARIES", before, session)


func _test_speeds() -> void:
	var baseline: Dictionary = {}
	for speed: int in [1, 2, 4]:
		var session := FX.create()
		session.pipeline.clock.set_speed(speed)
		FX.execute(session, "contract", "speed-contract")
		FX.execute(session, "start", "speed-start")
		for minute: int in [1803, 1804, 1805, 4682]:
			FX.BidFX.advance_to(session, minute)
		var value := {"row": FX.row(session), "funds": session.pipeline.snapshot().funds}
		if baseline.is_empty():
			baseline = value
		_expect("speed_equal_%d" % speed, value, baseline)
		_record("SPEED_%d" % speed, {}, session)


func _test_host() -> void:
	var session := FX.create()
	var host = Stage.instantiate()
	host.session = session
	root.add_child(host)
	host.set_process(false)
	host.controls.open_tenders.pressed.emit()
	var tender = host.tender_view
	(
		tender
		. get_children()
		. filter(func(n: Node) -> bool: return n is ItemList)[0]
		. item_selected
		. emit(0)
	)
	tender.controls.detail.pressed.emit()
	_expect("R01_actual_start_copy", "실제 착공 효력부터" in tender.labels.summary.text, true)
	tender.controls.handoff.pressed.emit()
	tender.controls.construction.pressed.emit()
	_expect("host_construction_visible", host.construction_view.visible, true)
	_expect("host_tender_hidden", tender.visible, false)
	host.construction_view.controls.contract.pressed.emit()
	FX.BidFX.advance_to(session, 1801)
	host.present(session.snapshot())
	_expect("host_contract_one", session.snapshot().construction_ui.snapshot.projects.size(), 1)
	host.construction_view.controls.back.pressed.emit()
	_expect("return_tender", tender.visible, true)
	_expect("return_selection", tender.selected_id, "B01")
	_expect("return_page", tender.page, "P05")
	_expect("no_static_NOT_CREATED_override", "NOT_CREATED" in tender.labels.handoff.text, false)
	_expect("return_focus", tender.controls.construction.has_focus(), true)
	tender.controls.exit.pressed.emit()
	_expect("return_S01", host.controls.open_tenders.visible, true)
	host.free()


func _expect(id: String, actual: Variant, expected: Variant) -> void:
	_checks += 1
	var ok: bool = actual == expected
	if not ok:
		_failures += 1
		printerr("FAIL ", id, " expected=", expected, " actual=", actual)
	_assertions.append(
		{
			"id": id,
			"ok": ok,
			"expected": _evidence_value(expected),
			"actual": _evidence_value(actual)
		}
	)


func _record(id: String, initial: Dictionary, session: FX.BidFX.Session) -> void:
	_cases.append(
		{
			"id": id,
			"execution": "EXECUTED_AUTOMATED_CONTROL_TEST",
			"fixture_kind": "TEST_ONLY",
			"initial_snapshot": _compact(initial),
			"actual_snapshot": session.snapshot().construction_ui,
			"ledger":
			session.pipeline.ledger.entries().filter(
				func(entry: Dictionary) -> bool: return entry.amount != 0
			)
		}
	)


func _write_evidence() -> void:
	if "--evidence" not in OS.get_cmdline_user_args():
		return
	var output := FileAccess.open(
		"res://docs/engineering/evidence/DEV-021_W05_UI_CASES.json", FileAccess.WRITE
	)
	output.store_string(
		(
			JSON.stringify({"task_id": "DEV-021", "cases": _cases, "assertions": _assertions}, "  ")
			+ "\n"
		)
	)


func _compact(value: Dictionary) -> Dictionary:
	var result := value.duplicate(true)
	if result.has("current"):
		result.current.erase("trace")
	result.erase("trace")
	return result


func _evidence_value(value: Variant) -> Variant:
	if value is Dictionary:
		var result: Dictionary = {}
		for key: String in value:
			if key != "trace":
				result[key] = _evidence_value(value[key])
		return result
	if value is Array:
		return value.map(_evidence_value)
	return value


func _test_focus_visibility(baseline: bool) -> void:
	_focus_assertion_start = _assertions.size()
	var clipped := 0
	for case_id: String in ["PROGRESS", "FOCUS_POST_REPAIR", "FOCUS_OPEN_READY"]:
		var session := FX.create(case_id)
		var model_before: Dictionary = session.snapshot().construction_ui.snapshot
		for size_value: Vector2i in [Vector2i(1104, 900), Vector2i(1280, 720), Vector2i(1280, 960)]:
			root.size = size_value
			var host = Stage.instantiate()
			host.session = session
			root.add_child(host)
			host.set_process(false)
			host.controls.open_tenders.pressed.emit()
			host.tender_view.selected_id = "B01"
			host.tender_view.page = "P05"
			host.present(session.snapshot())
			host.tender_view.controls.construction.pressed.emit()
			await _layout_frames()
			var panel: View = host.construction_view
			var scroll: ScrollContainer = host.get_children()[0]
			var observations: Array[Dictionary] = []
			for action: String in [
				"back",
				"refresh",
				"contract",
				"start",
				"resume",
				"trial",
				"safety",
				"repair",
				"open"
			]:
				var button: Button = panel.controls[action]
				button.grab_focus()
				await _layout_frames()
				var region: Control = button.get_parent() if action in View.ACTIONS else button
				var visible := _inside_scroll(scroll, region)
				clipped += int(not visible)
				observations.append(_focus_observation(scroll, button, region, action))
				_expect(case_id + "_focus_" + action, root.gui_get_focus_owner() == button, true)
				if not baseline:
					_expect(case_id + "_visible_" + action, visible, true)
			for reverse: bool in [false, true]:
				for index: int in 14:
					await _tab_key(reverse)
					var focus := root.gui_get_focus_owner()
					_expect("keyboard_has_focus", focus != null, true)
					if not baseline and focus != null:
						_expect("keyboard_focus_visible", _inside_scroll(scroll, focus), true)
			var before: Dictionary = session.snapshot().construction_ui
			panel.controls.refresh.pressed.emit()
			host.present(session.snapshot())
			await _layout_frames()
			_expect(
				"refresh_no_model_mutation",
				session.snapshot().construction_ui.snapshot == before.snapshot,
				true
			)
			_expect(
				"navigation_no_new_request",
				session.snapshot().construction_ui.requests,
				before.requests
			)
			panel.controls.back.pressed.emit()
			await _layout_frames()
			_expect("return_selected_B01", host.tender_view.selected_id, "B01")
			if not baseline:
				_expect(
					"return_focus_visible",
					_inside_scroll(scroll, host.tender_view.controls.construction),
					true
				)
			host.tender_view.controls.construction.pressed.emit()
			await _layout_frames()
			_expect("reentry_focus", root.gui_get_focus_owner() == panel.controls.back, true)
			if not baseline:
				_expect("reentry_visible", _inside_scroll(scroll, panel.controls.back), true)
			_focus_cases.append(
				{
					"case": case_id,
					"kind": "AUTOMATED_TEST_ONLY_PRODUCT_HOST",
					"phase": "BASELINE" if baseline else "FIXED",
					"window_raw": [size_value.x, size_value.y],
					"observed_window_raw": [root.size.x, root.size.y],
					"observed_viewport": str(root.get_visible_rect()),
					"initial": model_before,
					"observations": observations,
					"after": session.snapshot().construction_ui.snapshot
				}
			)
			host.free()
		_expect(
			"paused_navigation_preserves_model",
			session.snapshot().construction_ui.snapshot == model_before,
			true
		)
	_expect("focus_required_cases", _focus_cases.size(), 9)
	if baseline:
		_expect("baseline_clipped_focus_reproduced", clipped > 0, true)
	else:
		_expect("fixed_all_action_rows_visible", clipped, 0)
	print("DEV021_OBS01_FOCUS phase=", "BASELINE" if baseline else "FIXED", " clipped=", clipped)


func _layout_frames() -> void:
	for frame: int in 4:
		await process_frame


func _tab_key(reverse: bool) -> void:
	var event := InputEventKey.new()
	event.keycode = KEY_TAB
	event.shift_pressed = reverse
	event.pressed = true
	Input.parse_input_event(event)
	var release := event.duplicate() as InputEventKey
	release.pressed = false
	Input.parse_input_event(release)
	await _layout_frames()


func _inside_scroll(scroll: ScrollContainer, control: Control) -> bool:
	var clip := scroll.get_global_rect()
	if scroll.get_v_scroll_bar().visible:
		clip.size.x -= scroll.get_v_scroll_bar().size.x
	if scroll.get_h_scroll_bar().visible:
		clip.size.y -= scroll.get_h_scroll_bar().size.y
	return clip.grow(1.0).encloses(control.get_global_rect())


func _focus_observation(
	scroll: ScrollContainer, button: Button, region: Control, action: String
) -> Dictionary:
	return {
		"action": action,
		"disabled": button.disabled,
		"focus_path":
		str(button.get_path()) if root.gui_get_focus_owner() == button else "OTHER_OR_NONE",
		"button_rect": str(button.get_global_rect()),
		"region_rect": str(region.get_global_rect()),
		"scroll_rect": str(scroll.get_global_rect()),
		"scroll": scroll.scroll_vertical,
		"region_visible": _inside_scroll(scroll, region)
	}


func _write_focus_evidence() -> void:
	if "--obs01-evidence" not in OS.get_cmdline_user_args():
		return
	var path := "res://docs/engineering/evidence/DEV-021_OBS01_CASES.json"
	var evidence: Dictionary = {}
	if FileAccess.file_exists(path):
		var previous: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
		if previous is Dictionary:
			evidence = previous
	var phase := "baseline" if "--obs01-baseline" in OS.get_cmdline_user_args() else "fixed"
	evidence[phase] = {
		"cases": _focus_cases, "assertions": _assertions.slice(_focus_assertion_start)
	}
	evidence.task_id = "DEV-021"
	evidence.observation = "OBS-01"
	var output := FileAccess.open(path, FileAccess.WRITE)
	output.store_string(JSON.stringify(evidence, "  ") + "\n")
