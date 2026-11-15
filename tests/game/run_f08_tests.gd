extends SceneTree
## Checks adapter authority boundaries and equal sample consumption, not visual acceptance.

const Fixtures = preload("res://tests/game/f08_fixtures.gd")
const ExperimentPanel = preload("res://tests/game/f08_experiment_panel.gd")

var _checks := 0
var _failures: Array = []
var _rows: Array = []


func _initialize() -> void:
	call_deferred("_run")


func _check(label: String, value: bool) -> void:
	_checks += 1
	_rows.append({"label": label, "passed": value})
	if not value:
		_failures.append(label)
		print("F08_FAIL ", label)


func _run() -> void:
	var samples := Fixtures.samples()
	_check("sample_kind", samples.kind == "DESIGN_DISPLAY_FIXTURE_NOT_GAME_SNAPSHOT")
	_check("sample_counts", samples.states.size() == 15 and samples.comparisons.size() == 12)
	_check("pixel_hash", FileAccess.get_sha256(Fixtures.PIXEL_PATH) == samples.pixel_probe.sha256)
	root.size = Vector2i(1280, 720)
	var panel := ExperimentPanel.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(panel)
	for row: Dictionary in samples.states:
		var session := Fixtures.create_model(row.id)
		_check(row.id + ":stations", session.snapshot().stations.size() == 12)
		var before := Fixtures.digest(Fixtures.authority(session))
		var reference := ""
		for layout: String in ["A", "B"]:
			panel.configure(
				session,
				{
					"state": row.id,
					"source": "SAMPLE",
					"layout": layout,
					"profile": "long",
					"font": "default"
				}
			)
			await process_frame
			var value := panel.observation()
			_check(row.id + layout + ":sample_stops", value.plan_ids == row.stops)
			_check(
				row.id + layout + ":corpus_preserved",
				value.texts.stress.ends_with(Fixtures.corpus())
			)
			_check(row.id + layout + ":no_model_effect", value.authority_sha256 == before)
			if layout == "A":
				reference = value.content_sha256
			else:
				_check(row.id + ":AB_content_equal", reference == value.content_sha256)
		panel.activate_station("S12")
		panel.command("remove")
		_check(
			row.id + ":sample_no_command", before == Fixtures.digest(Fixtures.authority(session))
		)
	for case_id: String in ["pa", "eight", "five", "nine", "gap", "locked"]:
		var session := Fixtures.create_model(case_id)
		panel.configure(session, {"state": case_id, "source": "MODEL", "layout": "A"})
		await process_frame
		var state: Dictionary = session.snapshot()
		_check(case_id + ":model_plan_ids", panel.observation().plan_ids == state.plan.station_ids)
		var before := Fixtures.digest(Fixtures.authority(session))
		panel.choose_info("S01")
		panel.command("refresh")
		panel.layout_id = "B"
		panel.refresh()
		_check(
			case_id + ":info_refresh_layout_no_effect",
			before == Fixtures.digest(Fixtures.authority(session))
		)
		_check(case_id + ":map_ids", panel.map_view.markers.size() == 12)
		if case_id in ["five", "nine", "gap"]:
			_check(case_id + ":invalid", not state.plan.validation.valid)
		if case_id in ["pa", "eight"]:
			_check(case_id + ":valid", state.plan.validation.valid)
		if case_id == "locked":
			_check("locked:included_enabled", not panel.candidates.S01.disabled)
			_check("locked:candidate_disabled", panel.candidates.S05.disabled)
			panel.activate_station("S05")
			_check("locked:guard_no_effect", before == Fixtures.digest(Fixtures.authority(session)))
			_check("locked:reason", session.snapshot().command_result.reason == "PLAN_LOCKED")
	var session := Fixtures.create_model("pa")
	panel.configure(session, {"state": "pa", "source": "MODEL", "layout": "A"})
	var initial: Array = session.plan.snapshot().station_ids
	panel.choose_info("S12")
	panel.command("remove")
	_check("edit:remove", session.plan.snapshot().station_ids.size() == 5)
	panel.command("undo")
	_check("edit:undo", session.plan.snapshot().station_ids == initial)
	panel.activate_station("S05")
	_check("edit:candidate_same_id", session.plan.snapshot().station_ids.back() == "S05")
	panel.command("up")
	_check("edit:move_same_id", session.plan.snapshot().station_ids[5] == "S05")
	var before := Fixtures.digest(Fixtures.authority(session))
	var duplicate: Dictionary = session.dispatch(
		{"command_id": "duplicate", "action": "select", "station_id": "S05"}
	)
	_check("duplicate:reason", duplicate.reason == "DUPLICATE_STATION")
	_check("duplicate:no_effect", before == Fixtures.digest(Fixtures.authority(session)))
	panel.overlap = true
	panel.long_text = true
	panel.refresh()
	await process_frame
	_check("display:coordinates_unchanged", session.snapshot().stations[0].x_km == 0)
	_check(
		"display:map_overlaps",
		panel.map_view.markers.S01.position == panel.map_view.markers.S12.position
	)
	panel.choose_info("S12")
	_check(
		"display:full_name_path",
		panel.observation().texts.selected.ends_with(samples.strings[0].text)
	)
	_check("display:authority_unchanged", before == Fixtures.digest(Fixtures.authority(session)))
	if "--verify-failure-exit" in OS.get_cmdline_user_args():
		_check("intentional_failure", false)
	var out := "res://.local/f08/auto.json"
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--output="):
			out = arg.trim_prefix("--output=")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out.get_base_dir()))
	FileAccess.open(out, FileAccess.WRITE).store_string(
		(
			JSON.stringify(
				{
					"checks": _checks,
					"failures": _failures,
					"cases": _rows,
					"kind": "AUTOMATED_ADAPTER_CHECKS_NOT_GUI_ACCEPTANCE"
				},
				"\t"
			)
			+ "\n"
		)
	)
	panel.free()
	print("F08_TEST_RESULT checks=%d failures=%d" % [_checks, _failures.size()])
	quit(0 if _failures.is_empty() else 1)
