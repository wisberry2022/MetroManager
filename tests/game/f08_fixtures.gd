extends RefCounted
## DEV-025 only. Display samples never become production state or rules.

const W07 = preload("res://tests/game/w07_ui_fixtures.gd")
const Session = preload("res://scripts/ui/stage1_session.gd")
const SAMPLE_PATH := "res://docs/design/assets/source/dsg_008/dev025/common_samples.json"
const PIXEL_PATH := "res://docs/design/assets/exports/dsg_008/dev025/pixel_probe_128x64.png"
const CASE_IDS := [
	"pa",
	"eight",
	"initial",
	"five",
	"nine",
	"duplicate",
	"gap",
	"locked",
	"failure",
	"zero",
	"stale",
	"restricted",
	"reserved",
	"report",
	"report-failure"
]

static var _samples: Dictionary = {}


static func samples() -> Dictionary:
	if _samples.is_empty():
		_samples = JSON.parse_string(FileAccess.get_file_as_string(SAMPLE_PATH))
	return _samples


static func sample(case_id: String) -> Dictionary:
	for row: Dictionary in samples().states:
		if row.id == case_id:
			return row.duplicate(true)
	return {}


static func create_model(case_id: String) -> Session:
	var mapping := {
		"pa": "QA-M02",
		"eight": "QA-M02-8",
		"gap": "QA-M02-DISCONNECTED",
		"locked": "QA-M03",
		"failure": "QA-P01-FAIL",
		"zero": "QA-P01",
		"stale": "QA-P02",
		"restricted": "QA-F02",
		"reserved": "QA-F02-K",
		"report": "QA-F04-ZERO",
		"report-failure": "QA-F04"
	}
	var session := W07.create(mapping.get(case_id, "QA-T01"))
	if case_id in ["five", "nine", "duplicate"]:
		var stops: Array[String] = []
		stops.assign(sample(case_id).stops)
		# Duplicate is a rejected real command; its invalid display is tested in SAMPLE mode.
		for index: int in stops.size():
			session.dispatch(
				{
					"command_id": "f08-setup-%d" % index,
					"action": "select",
					"station_id": stops[index]
				}
			)
	# Enable exactly the same read-only navigation supplies as the product S01 host.
	session.enable_tender_ui()
	session.enable_construction_ui()
	session.fixture_label = "DEV025_MODEL_SETUP:" + case_id
	return session


static func authority(session: Session) -> Dictionary:
	return {
		"plan": session.plan.snapshot(),
		"clock": session.pipeline.clock.snapshot(),
		"current": session.pipeline.snapshot(),
		"ledger": session.pipeline.ledger.entries(),
		"prediction": session.prediction.snapshot()
	}


static func digest(value: Variant) -> String:
	return JSON.stringify(value).sha256_text()


static func corpus() -> String:
	var parts: PackedStringArray = []
	for row: Dictionary in samples().strings:
		parts.append(row.text)
	return "\n".join(parts)


static func font_probe(font: Font) -> Dictionary:
	var server := TextServerManager.get_primary_interface()
	var shaped := server.create_shaped_text()
	var added := server.shaped_text_add_string(shaped, corpus(), font.get_rids(), 18)
	server.shaped_text_shape(shaped)
	var families: Dictionary = {}
	var missing: Array = []
	var glyphs: Array = []
	for row: Dictionary in server.shaped_text_get_glyphs(shaped):
		var rid: RID = row.font_rid
		var family := server.font_get_name(rid) if rid.is_valid() else "NO_FONT_RID"
		families[family] = families.get(family, 0) + 1
		var item := {
			"start": row.start,
			"end": row.end,
			"index": row.index,
			"flags": row.flags,
			"family": family
		}
		glyphs.append(item)
		if not rid.is_valid() or row.index == 0:
			missing.append(item)
	server.free_rid(shaped)
	return {
		"text_sha256": corpus().sha256_text(),
		"added": added,
		"families": families,
		"missing_or_virtual_glyphs": missing,
		"glyphs": glyphs,
		"note": "Glyph RID names are runtime observations, not font distribution rights."
	}


static func environment(window: Window) -> Dictionary:
	return {
		"engine": Engine.get_version_info(),
		"os": OS.get_name(),
		"os_version": OS.get_version(),
		"display_server": DisplayServer.get_name(),
		"adapter": RenderingServer.get_video_adapter_name(),
		"vendor": RenderingServer.get_video_adapter_vendor(),
		"renderer": RenderingServer.get_current_rendering_method(),
		"driver": RenderingServer.get_current_rendering_driver_name(),
		"screen_size": str(DisplayServer.screen_get_size()),
		"screen_dpi_api": DisplayServer.screen_get_dpi(),
		"screen_scale_api": DisplayServer.screen_get_scale(),
		"screen_refresh_hz": DisplayServer.screen_get_refresh_rate(),
		"window_size": str(DisplayServer.window_get_size()),
		"window_size_with_decorations": str(DisplayServer.window_get_size_with_decorations()),
		"viewport_rect": str(window.get_visible_rect()),
		"content_scale_factor": window.content_scale_factor,
		"final_transform": str(window.get_final_transform()),
		"font_path": OS.get_system_font_path("Malgun Gothic"),
		"note": "API values; physical monitor DPI and unobserved PCs are NOT_VERIFIED."
	}
