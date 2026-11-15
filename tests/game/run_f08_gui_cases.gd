extends SceneTree
## Real rendering/sampling driver. Scripted sweeps/profiles are not manual GUI acceptance.

const Fixtures = preload("res://tests/game/f08_fixtures.gd")
const ExperimentPanel = preload("res://tests/game/f08_experiment_panel.gd")
const Stage1 = preload("res://scenes/stage1.tscn")
const CASES_PATH := "res://docs/engineering/evidence/DEV-025_F08_CASES.json"

var _panel: ExperimentPanel
var _product: Control
var _session: RefCounted
var _banner: Label
var _output := ""
var _event_file: FileAccess
var _captures := 0
var _current := {
	"state": "pa",
	"source": "MODEL",
	"layout": "A",
	"font": "default",
	"profile": "baseline",
	"width": 1280,
	"height": 720,
	"scale": 1.0
}
var _busy := false
var _case_index := 0
var _sample_timer := 0.0
var _manual := false
var _profiling := false


func _initialize() -> void:
	call_deferred("_build")


func _build() -> void:
	_output = _argument(
		"--output=", "res://.local/f08/manual-" + str(Time.get_unix_time_from_system())
	)
	_output = ProjectSettings.globalize_path(_output)
	if DirAccess.dir_exists_absolute(_output):
		push_error("Output exists; refusing overwrite: " + _output)
		quit(2)
		return
	DirAccess.make_dir_recursive_absolute(_output)
	_event_file = FileAccess.open(_output.path_join("events.jsonl"), FileAccess.WRITE)
	root.title = "MetroManager DEV-025 · 격리 기술 실험"
	root.size = Vector2i(1280, 720)
	var shell := VBoxContainer.new()
	shell.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(shell)
	_banner = Label.new()
	_banner.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	shell.add_child(_banner)
	_panel = ExperimentPanel.new()
	shell.add_child(_panel)
	_panel.observed.connect(_event)
	_session = Fixtures.create_model("pa")
	_product = Stage1.instantiate()
	_product.session = _session
	_product.size_flags_vertical = Control.SIZE_EXPAND_FILL
	shell.add_child(_product)
	_product.set_process(false)
	_product.hide()
	_apply(_current, true)
	root.close_requested.connect(_finish)
	if "--sweep" in OS.get_cmdline_user_args():
		await _sweep()
	elif "--profile" in OS.get_cmdline_user_args():
		await _profile()
	else:
		_manual = true
		_event("manual_ready", {"instruction": "Real OS input; F5 capture; Escape exit"})
		await _capture("READY")


func _argument(prefix: String, fallback: String) -> String:
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with(prefix):
			return arg.trim_prefix(prefix)
	return fallback


func _apply(row: Dictionary, reset: bool) -> void:
	_current = row.duplicate(true)
	root.size = Vector2i(row.get("width", 1280), row.get("height", 720))
	root.content_scale_size = root.size
	root.content_scale_factor = row.get("scale", 1.0)
	if reset:
		_session = Fixtures.create_model(row.state)
		_product.session = _session
		_product.reset_observation()
	_panel.configure(_session, row)
	_panel.visible = row.source != "PRODUCT"
	_product.visible = row.source == "PRODUCT"
	_product.set_process(false)
	_product.present(_session.snapshot())
	_banner.text = (
		(
			"DEV-025 격리 실험 | %s %s / %s / %s / %.2fx\n"
			+ "F1 A/B · F2 font · F3 scale · F4 case · F5 capture · F6 source · "
			+ "F7 window · F9 long · F10 overlap · Esc exit"
		)
		% [row.source, row.layout, row.state, row.font, row.scale]
	)


func _event(kind: String, detail: Dictionary) -> void:
	if _event_file == null:
		return
	if _profiling and kind == "information":
		return
	_event_file.store_line(
		JSON.stringify(
			{
				"kind": kind,
				"ticks_usec": Time.get_ticks_usec(),
				"frame": Engine.get_process_frames(),
				"detail": detail,
				"condition": _current,
				"plan": _session.plan.snapshot() if _session else {},
				"authority_sha256":
				Fixtures.digest(Fixtures.authority(_session)) if _session else ""
			}
		)
	)
	_event_file.flush()
	if kind == "input_key" and _manual and not _busy:
		call_deferred("_key", detail.key)


func _key(key: int) -> void:
	var row := _current.duplicate(true)
	var reset := false
	match key:
		KEY_ESCAPE:
			_finish()
			return
		KEY_F5:
			await _capture("MANUAL")
			return
		KEY_F1:
			row.layout = "B" if row.layout == "A" else "A"
		KEY_F2:
			row.font = "system" if row.font == "default" else "default"
		KEY_F3:
			var scales := [1.0, 1.25, 1.5, 2.0]
			row.scale = scales[(scales.find(row.scale) + 1) % scales.size()]
		KEY_F4:
			_case_index = (_case_index + 1) % Fixtures.CASE_IDS.size()
			row.state = Fixtures.CASE_IDS[_case_index]
			reset = true
		KEY_F6:
			var modes := ["MODEL", "SAMPLE", "PRODUCT"]
			row.source = modes[(modes.find(row.source) + 1) % modes.size()]
		KEY_F7:
			row.width = 1600 if row.width == 1280 else (1920 if row.width == 1600 else 1280)
			row.height = 900 if row.width == 1600 else (1080 if row.width == 1920 else 720)
		KEY_F9:
			row.profile = "long" if row.profile == "baseline" else "baseline"
		KEY_F10:
			row.overlap = not row.get("overlap", false)
		_:
			return
	var before := Fixtures.digest(Fixtures.authority(_session))
	_apply(row, reset)
	_event(
		"fixture_or_presentation_control",
		{
			"reset_model": reset,
			"before": before,
			"after": Fixtures.digest(Fixtures.authority(_session))
		}
	)


func _process(delta: float) -> bool:
	if _manual and _session != null:
		_sample_timer += delta
		if _sample_timer > 0.2:
			_sample_timer = 0
			_event(
				"manual_state",
				{
					"observation": _panel.observation(),
					"last_result": _session.snapshot().command_result
				}
			)
	return false


func _capture(label: String) -> void:
	_busy = true
	await process_frame
	await RenderingServer.frame_post_draw
	_captures += 1
	var stem := "%03d-%s" % [_captures, label]
	var file := _output.path_join(stem + ".png")
	var result := root.get_texture().get_image().save_png(file)
	var value := {
		"condition": _current,
		"environment": Fixtures.environment(root),
		"observation": _panel.observation(),
		"authority": Fixtures.authority(_session),
		"png": stem + ".png",
		"png_sha256": FileAccess.get_sha256(file),
		"save_error": result,
		"font": Fixtures.font_probe(_panel.sections.source.get_theme_font("font"))
	}
	FileAccess.open(_output.path_join(stem + ".json"), FileAccess.WRITE).store_string(
		JSON.stringify(value, "\t") + "\n"
	)
	_event("capture", {"stem": stem, "sha256": value.png_sha256, "save_error": result})
	print("F08_CAPTURE ", stem)
	_busy = false


func _sweep() -> void:
	var cases: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(CASES_PATH))
	for row: Dictionary in cases.render_cases:
		_apply(row, true)
		await create_timer(0.4).timeout
		if row.get("bottom", false):
			_panel.scroll_bottom()
			await create_timer(0.15).timeout
		await _capture(row.id)
	_event("sweep_complete", {"kind": "SCRIPTED_RENDER_NOT_MANUAL_INPUT", "count": _captures})
	_finish()


func _profile() -> void:
	_profiling = true
	var matrix: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(CASES_PATH))
	var file := FileAccess.open(_output.path_join("profile.csv"), FileAccess.WRITE)
	file.store_csv_line(
		PackedStringArray(
			[
				"case_id",
				"source",
				"layout",
				"state",
				"speed",
				"sample",
				"elapsed_usec",
				"frame_interval_usec",
				"adapter_update_usec",
				"engine_process_sec",
				"static_memory_bytes",
				"objects",
				"nodes",
				"draw_calls",
				"game_minute",
				"gpu_frame_usec",
				"input_kind"
			]
		)
	)
	for row: Dictionary in matrix.profile_cases:
		_apply(row, true)
		_session.pipeline.clock.paused = row.speed == 0
		_session.pipeline.clock.set_speed(maxi(1, row.speed))
		await create_timer(1.0).timeout
		var start := Time.get_ticks_usec()
		var previous := start
		var sample_index := 0
		while Time.get_ticks_usec() - start < 2000000:
			await process_frame
			var now := Time.get_ticks_usec()
			var interval := now - previous
			previous = now
			var update_start := Time.get_ticks_usec()
			_session.advance_usec(interval)
			if sample_index % 30 == 0:
				var id := "S01" if (sample_index / 30) % 2 == 0 else "S12"
				if row.source != "PRODUCT":
					_panel.choose_info(id)
				else:
					_product.map_view.station_requested.emit(id)
			if row.source == "PRODUCT":
				_product.present(_session.snapshot())
			else:
				_panel.refresh()
			var update_usec := Time.get_ticks_usec() - update_start
			file.store_csv_line(
				PackedStringArray(
					[
						row.id,
						row.source,
						row.layout,
						row.state,
						str(row.speed),
						str(sample_index),
						str(now - start),
						str(interval),
						str(update_usec),
						str(Performance.get_monitor(Performance.TIME_PROCESS)),
						str(Performance.get_monitor(Performance.MEMORY_STATIC)),
						str(Performance.get_monitor(Performance.OBJECT_COUNT)),
						str(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)),
						str(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)),
						str(_session.pipeline.clock.minute),
						"NOT_AVAILABLE",
						"SCRIPTED_PROFILE"
					]
				)
			)
			sample_index += 1
		file.flush()
		_event(
			"profile_case",
			{
				"samples": sample_index,
				"warmup_sec": 1,
				"sample_sec": 2,
				"environment": Fixtures.environment(root)
			}
		)
		print("F08_PROFILE ", row.id, " samples=", sample_index)
	file.close()
	_finish()


func _finish() -> void:
	if _event_file:
		_event("requested_exit", {"code": 0, "captures": _captures})
		_event_file.close()
	quit(0)
