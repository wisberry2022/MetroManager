extends RefCounted
## TEST_ONLY: 모델 준비와 소비 사본 변조를 구별한다. 제품은 로드하지 않는다.

const W07 = preload("res://tests/game/w07_ui_fixtures.gd")
const Ops = preload("res://tests/game/operations_ui_fixtures.gd")
const Session = preload("res://scripts/ui/stage1_session.gd")
const Host = preload("res://scenes/stage1.tscn")
const Contract = preload("res://scripts/ui/s01_observation_contract.gd")


static func session(case_id: String = "QA-M02") -> Session:
	var value := W07.create(case_id)
	value.pipeline.clock.paused = true
	value.fixture_label = "DEV026-" + case_id
	return value


static func effects(value: Session) -> String:
	return Ops.effects(value)


static func sample(value: Session, case_id: String) -> Variant:
	var state := value.snapshot()
	match case_id:
		"EX-01":
			return null
		"EX-02":
			state.erase("stations")
		"EX-05":
			state.prediction.prediction_status = "CALCULATING"
			state.prediction.available = false
			state.prediction.current = {}
		"EX-09":
			state.current.erase("funds")
		"EX-10":
			state.daily_activity.erase("operating_cost")
		"EX-13":
			state.command_result = {
				"command_id": "consumer-only",
				"action": "undo",
				"reason": "UNKNOWN_FIXTURE",
				"accepted": false,
				"effective_at": 360,
				"result_revision": state.view_revision,
				"plan_revision": state.plan.plan_revision
			}
		"EX-14":
			state.view_revision = 0
		"EX-17":
			state.allowed_actions.erase("resume")
			state.plan.allowed_actions.erase("edit")
		"EX-19":
			state.report.display_key = "foreign/day-1"
			state.report.status = "READY"
			state.report.available = true
			state.report.day_id = 1
		"EX-20":
			state.daily_activity.snapshot_revision += 1
	return state


static func tree_state(view: Control) -> Dictionary:
	return {
		"scope": view.session.observation_scope(),
		"view_revision": view._displayed_revision,
		"regions": view._observation.regions,
		"selection": view._selected_id,
		"markers": view.map_view.markers.keys(),
		"labels":
		{
			"clock": view._labels.clock.text,
			"plan": view._labels.validation.text,
			"funds": view._labels.funds.text,
			"daily": view._labels.activity.text,
			"report": view._labels.report.text,
			"prediction": view._labels.prediction.text,
			"feedback": view._labels.feedback.text
		},
		"actions":
		{
			"resume": not view.controls.resume.disabled,
			"predict": not view.controls.predict.disabled,
			"undo": not view.controls.undo.disabled
		},
		"screen": view._reading_context().screen,
		"scroll": view._scroll.scroll_vertical,
		"focus": str(view.get_viewport().gui_get_focus_owner()),
		"effects": effects(view.session)
	}
