extends SceneTree

const FX = preload("res://tests/game/w019_ui_fixtures.gd")
const TenderPanel = preload("res://scenes/tender_panel.tscn")
const View = preload("res://scripts/ui/tender_view.gd")
const Stage1 = preload("res://scenes/stage1.tscn")

var _checks: int = 0
var _failures: int = 0
var _assertions: Array[Dictionary] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_expect("intentional_failure", false, true)
	else:
		_test_decimal()
		await _test_public_criteria()
		await _test_current_reasons()
		await _test_normal()
		await _test_boundaries()
		await _test_states()
		await _test_stale()
		await _test_host()
		_write_evidence()
	print("DEV019_UI_TEST_RESULT checks=", _checks, " failures=", _failures)
	quit(0 if _failures == 0 else 1)


func _test_decimal() -> void:
	for pair: Array in [
		[8600000, 100000, "86"],
		[8000000, 100000, "80"],
		[7999997, 100000, "79.99997"],
		[800001, 10000, "80.0001"],
		[0, 10000, "0"],
		[1000000, 10000, "100"],
		[1, 3, "자료 없음"],
		[1, 0, "자료 없음"]
	]:
		_expect(
			"exact_decimal",
			View.exact_decimal({"numerator": pair[0], "denominator": pair[1]}),
			pair[2]
		)


func _panel(session: FX.Session) -> View:
	var panel: View = TenderPanel.instantiate()
	root.add_child(panel)
	panel.bid_requested.connect(
		func(id: String, tender: String, seen: Dictionary) -> void:
			session.request_bid(id, tender, seen)
			panel.present(session.snapshot().tender_ui)
	)
	panel.refresh_requested.connect(
		func() -> void:
			session.refresh_tenders()
			panel.present(session.snapshot().tender_ui)
	)
	panel.present(session.snapshot().tender_ui)
	return panel


func _choose(panel: View, index: int = 0) -> void:
	(
		panel
		. get_children()
		. filter(func(node: Node) -> bool: return node is ItemList)[0]
		. item_selected
		. emit(index)
	)
	panel.controls.detail.pressed.emit()


func _test_public_criteria() -> void:
	for index: int in [0, 1]:
		var session := FX.create()
		var before := session.pipeline.snapshot()
		var panel := _panel(session)
		_choose(panel, index)
		var text: String = panel.labels.criteria.text
		_expect("QA001_before_visible", panel.labels.criteria.visible, true)
		for required: String in [
			"공고의 공개 평가 기준",
			"입찰 결과는 아직 확정되지 않았습니다.",
			"공고 마감 시점의 자격·자금 상태",
			"사업별 제한자금 R의 합계",
			"F ÷ 10,000을 0~100점 범위로 제한",
			"(7 × 이행능력 점수 + 3 × 재무점수) ÷ 10",
			"경쟁자 공개점수 80점 (이행능력 80점 / 재무점수 80점)",
			"동점 시 우선순위: 경쟁자 → 플레이어"
		]:
			_expect("QA001_prebid_content", required in text, true)
		_expect("QA001_no_predicted86", "86" in text, false)
		_expect(
			"QA001_after_terms",
			panel.labels.summary.get_index() < panel.labels.criteria.get_index(),
			true
		)
		_expect(
			"QA001_before_eligibility",
			panel.labels.criteria.get_index() < panel.labels.eligibility.get_index(),
			true
		)
		_expect(
			"QA001_before_submit",
			panel.labels.criteria.get_index() < panel.controls.submit.get_parent().get_index(),
			true
		)
		_expect("QA001_no_side_effect", session.pipeline.snapshot(), before)
		panel.controls.submit.pressed.emit()
		FX.advance_to(session, 1800)
		panel.present(session.snapshot().tender_ui)
		_expect("QA001_fixed_after_decision", "경쟁자 공개점수 80점" in panel.labels.criteria.text, true)
		_expect("QA001_remove_unconfirmed", "아직 확정되지" in panel.labels.criteria.text, false)
		_expect("QA001_separate_actual", "공개점수 86 : 80점" in panel.labels.decision.text, true)
		panel.queue_free()
		await process_frame
	var supplied := FX.create("FRACTION")
	var envelope: Dictionary = supplied.snapshot().tender_ui.snapshot
	envelope.tenders[0].terms.competitor_capability = 60
	envelope.tenders[0].terms.competitor_financial_score = 20
	var custom := supplied._evaluation_criteria(envelope)
	_expect(
		"QA001_authority_model_score", View.exact_decimal(custom.B01.competitor_display_score), "48"
	)
	envelope.tenders[0].terms.competitor_financial_score = -1
	_expect(
		"QA001_invalid_input_omitted", supplied._evaluation_criteria(envelope).has("B01"), false
	)
	envelope.tenders[0].terms.competitor_financial_score = 80.0
	_expect("QA001_noninteger_omitted", supplied._evaluation_criteria(envelope).has("B01"), false)
	var session := FX.create()
	var panel := _panel(session)
	_choose(panel)
	FX.advance_to(session, 1800)
	panel.present(session.snapshot().tender_ui)
	_expect("QA001_not_submitted_confirmed", "아직 확정되지" in panel.labels.criteria.text, false)
	var packet: Dictionary = session.snapshot().tender_ui
	packet.snapshot.tenders[0].terms.tie_priority.reverse()
	panel.present(packet)
	_expect("QA001_priority_from_terms", "플레이어 → 경쟁자" in panel.labels.criteria.text, true)
	packet.evaluation_criteria = {}
	panel.present(packet)
	_expect("QA001_missing_not80", "경쟁자 평가 자료 없음" in panel.labels.criteria.text, true)
	panel.queue_free()
	await process_frame


func _test_current_reasons() -> void:
	for pair: Array in [
		["BUSY", "다른 사업 진행 중"], ["DURATION", "공기 이행 불가"], ["BEFORE_START", "접수기간 시작 전"]
	]:
		var session := FX.create(pair[0])
		var panel := _panel(session)
		panel.present(FX.packet(session, pair[0]))
		_choose(panel)
		_expect("QA002_known_korean", pair[1] in panel.labels.eligibility.text, true)
		_expect("QA002_authority_disabled", panel.controls.submit.disabled, true)
		panel.queue_free()
		await process_frame
	var session := FX.create()
	var panel := _panel(session)
	_choose(panel)
	var packet: Dictionary = session.snapshot().tender_ui
	packet.snapshot.tenders[0].reason_codes = [
		"ROUND_CLOSED", "UNKNOWN_TEST_ONLY", "PROJECT_IN_PROGRESS"
	]
	packet.snapshot.tenders[0].allowed_actions.submit_bid = false
	panel.present(packet)
	_expect(
		"QA002_ordered_lines",
		(
			"접수기간 종료\n행동 제한 사유를 확인할 수 없습니다 (코드: UNKNOWN_TEST_ONLY)\n다른 사업 진행 중"
			in panel.labels.eligibility.text
		),
		true
	)
	_expect(
		"QA002_raw_preserved",
		panel.shown.snapshot.tenders[0].reason_codes,
		packet.snapshot.tenders[0].reason_codes
	)
	_expect("QA002_no_history_mix", "UNKNOWN_TEST_ONLY" in panel.labels.request.text, false)
	_expect("QA002_button_authority", panel.controls.submit.disabled, true)
	panel.queue_free()
	await process_frame


func _test_normal() -> void:
	for id: String in ["B01", "B02"]:
		var session := FX.create()
		var panel := _panel(session)
		var before := session.pipeline.ledger.snapshot()
		_choose(panel, 0 if id == "B01" else 1)
		_expect("Q01_selected", panel.selected_id, id)
		_expect("Q01_selection_no_command", session.snapshot().tender_ui.requests.size(), 0)
		_expect("Q02_fixed_terms", "정부금 800000" in panel.labels.summary.text, true)
		_expect("Q02_fixed_plan", "읽기 전용" in panel.labels.summary.text, true)
		_expect("Q02_no_edits", panel.find_children("*", "LineEdit").size(), 0)
		_expect("Q12_before_disabled", panel.controls.handoff.disabled, true)
		panel.controls.submit.pressed.emit()
		var request: Dictionary = session.snapshot().tender_ui.requests[0]
		_expect("Q05_pending", request.result.pending, true)
		_expect("Q05_pending_no_receipt", "접수 미확정" in panel.labels.request.text, true)
		_expect("Q09_pending_disabled", panel.controls.submit.disabled, true)
		panel.controls.submit.pressed.emit()
		_expect("Q09_no_second_command", session.snapshot().tender_ui.requests.size(), 1)
		var again := session.request_bid(request.command.command_id, id, FX.confirmed(session, id))
		_expect("Q09_idempotent", again.pending, true)
		_expect("pause_no_effect", session.pipeline.ledger.snapshot(), before)
		FX.advance_to(session, 361)
		panel.present(session.snapshot().tender_ui)
		_expect("Q05_received", "유효 접수 완료" in panel.labels.request.text, true)
		FX.advance_to(session, 1800)
		panel.present(session.snapshot().tender_ui)
		_expect("Q07_score86", "공개점수 86 : 80점" in panel.labels.decision.text, true)
		_expect("Q07_awarded", "낙찰" in panel.labels.decision.text, true)
		_expect("Q11_contract", "EFFECTIVE" in panel.labels.contract.text, true)
		_expect("Q11_payment", "금액 800000" in panel.labels.payment.text, true)
		_expect("Q11_funds", session.pipeline.ledger.snapshot().cash, 1800000)
		_expect("Q12_allowed", panel.controls.handoff.disabled, false)
		var funds := session.pipeline.ledger.snapshot()
		panel.controls.handoff.pressed.emit()
		_expect("Q12_partial_page", panel.page, "P05")
		_expect("Q12_not_constructed", "NOT_CREATED" in panel.labels.handoff.text, true)
		_expect("Q12_navigation_no_effect", session.pipeline.ledger.snapshot(), funds)
		panel.controls.back.pressed.emit()
		_expect("Q12_back", panel.page, "P02")
		panel.controls.back.pressed.emit()
		_expect("Q01_list_back_selection", panel.selected_id, id)
		panel.controls.refresh.pressed.emit()
		_expect("Q11_refresh_no_effect", session.pipeline.ledger.snapshot(), funds)
		panel.queue_free()
		await process_frame


func _test_boundaries() -> void:
	for effective: int in [359, 360, 1439, 1440, 1799, 1800, 1801]:
		for speed: int in [1, 2, 4]:
			var session := FX.create("NORMAL", effective - 1)
			session.pipeline.clock.set_speed(speed)
			var panel := _panel(session)
			_choose(panel)
			var expected := (
				"NOT_OPEN" if effective < 360 else ("ROUND_CLOSED" if effective >= 1800 else "")
			)
			# 비활성 버튼의 직접 요청 경계는 Session API로 검사한다.
			var result := session.request_bid("boundary", "B01", FX.confirmed(session))
			_expect("Q04_06_pending", result.pending, true)
			var paused := session.snapshot()
			session.advance_usec(5000000)
			_expect("Q04_pause", session.snapshot(), paused)
			panel.present(session.snapshot().tender_ui)
			if effective == 1800:
				_expect("deadline_model_open", panel.shown.snapshot.tenders[0].state, "OPEN")
				_expect(
					"deadline_pending_not_closed",
					"ROUND_CLOSED" in panel.labels.eligibility.text,
					false
				)
				_expect("deadline_timing", "처리 예정 T=1800" in panel.labels.timing.text, true)
			FX.advance_to(session, effective)
			panel.present(session.snapshot().tender_ui)
			var record: Dictionary = session.snapshot().tender_ui.requests[0]
			_expect("Q04_06_reason", record.result.reason, expected)
			_expect("Q04_06_effective", record.result.effective_at, effective)
			if expected == "ROUND_CLOSED":
				_expect("Q06_text", "응찰 접수 거부: 접수기간 종료" in panel.labels.request.text, true)
				_expect("Q06_disabled", panel.controls.submit.disabled, true)
			panel.queue_free()
			await process_frame


func _test_states() -> void:
	for case_id: String in [
		"EMPTY", "ERROR", "UNAVAILABLE", "BUSY", "DURATION", "TIE", "FRACTION", "PAYMENT_MISSING"
	]:
		var session := FX.create(case_id)
		var panel := _panel(session)
		if case_id not in ["EMPTY", "ERROR", "UNAVAILABLE"]:
			_choose(panel)
		if case_id in ["TIE", "FRACTION"]:
			if case_id == "FRACTION":
				panel.controls.submit.pressed.emit()
			FX.advance_to(session, 1800)
		panel.present(FX.packet(session, case_id))
		match case_id:
			"EMPTY":
				_expect("Q01_empty", "공고가 없습니다" in panel.labels.status.text, true)
			"ERROR":
				_expect("Q01_error", "조회 실패" in panel.labels.status.text, true)
			"UNAVAILABLE":
				_expect("Q10_unavailable", "자료 없음" in panel.labels.status.text, true)
			"BUSY", "DURATION":
				_expect("Q03_disabled", panel.controls.submit.disabled, true)
			"TIE":
				_expect("Q08_tie", "공개점수 80 : 80점" in panel.labels.decision.text, true)
				_expect("Q08_priority", "경쟁자 우선" in panel.labels.decision.text, true)
				_expect("Q08_no_contract", panel.controls.handoff.disabled, true)
			"FRACTION":
				_expect("Q08_fraction", "79.99997" in panel.labels.decision.text, true)
			"PAYMENT_MISSING":
				_expect("Q11_missing_payment", "자료 없음" in panel.labels.payment.text, true)
		if case_id in ["EMPTY", "ERROR", "UNAVAILABLE"]:
			session.refresh_tenders()
			panel.present(session.snapshot().tender_ui)
			_expect("Q01_recover", panel.shown.snapshot.tenders.size(), 2)
		panel.queue_free()
		await process_frame


func _test_stale() -> void:
	var session := FX.create()
	var panel := _panel(session)
	_choose(panel)
	var old: Dictionary = session.snapshot().tender_ui
	panel.controls.submit.pressed.emit()
	FX.advance_to(session, 361)
	panel.present(session.snapshot().tender_ui)
	var current := panel.shown.duplicate(true)
	var disabled: bool = panel.controls.submit.disabled
	_expect("Q10_stale_rejected", panel.present(old), false)
	_expect("Q10_current_preserved", panel.shown, current)
	_expect("Q10_button_preserved", panel.controls.submit.disabled, disabled)
	var record: Dictionary = session.snapshot().tender_ui.requests[0]
	var pending := record.duplicate(true)
	pending.result = {"pending": true, "command_id": record.command.command_id}
	_expect("Q10_late_pending_rejected", panel.accept_result(pending), false)
	_expect("Q10_late_does_not_change_current", panel.shown, current)
	var changed := FX.confirmed(session)
	changed.round_id = "B01-R2"
	session.request_bid("wrong-round", "B01", changed)
	FX.advance_to(session, 362)
	_expect(
		"Q10_changed_reason", session.pipeline.bid_result("wrong-round").reason, "STATE_CHANGED"
	)
	panel.queue_free()
	await process_frame


func _test_host() -> void:
	var session := FX.create()
	var host := Stage1.instantiate()
	host.session = session
	root.add_child(host)
	await process_frame
	host.controls.open_tenders.pressed.emit()
	_expect("host_opens", host.tender_view.visible, true)
	host.tender_view.controls.exit.pressed.emit()
	_expect("host_returns", host.tender_view.visible, false)
	_expect("host_preserves_plan", session.plan.snapshot().station_ids, [])
	host.queue_free()
	await process_frame


func _expect(label: String, actual: Variant, expected: Variant) -> void:
	_checks += 1
	_assertions.append(
		{
			"label": label,
			"passed": actual == expected,
			"actual":
			(
				JSON.stringify(actual).sha256_text()
				if actual is Dictionary or actual is Array
				else actual
			),
			"expected":
			(
				JSON.stringify(expected).sha256_text()
				if expected is Dictionary or expected is Array
				else expected
			)
		}
	)
	if actual != expected:
		_failures += 1
		printerr("FAIL ", label, " actual=", actual, " expected=", expected)


func _write_evidence() -> void:
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--evidence="):
			var file := FileAccess.open(arg.trim_prefix("--evidence="), FileAccess.WRITE)
			if file == null:
				_expect("evidence_write", false, true)
				return
			file.store_string(
				(
					JSON.stringify(
						{
							"checks": _checks,
							"failures": _failures,
							"exit_code": 0 if _failures == 0 else 1,
							"assertions": _assertions
						},
						"  "
					)
					+ "\n"
				)
			)
