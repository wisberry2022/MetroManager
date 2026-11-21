extends Control
## DATA 좌표의 추상 지도. 버튼과 목록은 동일 안정 ID를 요청한다.

signal station_requested(station_id: String)

const Operations = preload("res://scripts/ui/operations_view.gd")

var markers: Dictionary = {}
var flow_markers: Array[Dictionary] = []
var operating_stops: Array = []
var station_flow: Dictionary = {}
var _stations: Array = []
var _edges: Array = []
var _stops: Array = []
var _enabled: bool = true


func clear_observation() -> void:
	_enabled = false
	_stations = []
	_edges = []
	_stops = []
	flow_markers.clear()
	operating_stops = []
	station_flow.clear()
	for button: Button in markers.values():
		button.disabled = true
		remove_child(button)
		button.queue_free()
	markers.clear()
	queue_redraw()


func _ready() -> void:
	custom_minimum_size = Vector2(390, 230)
	resized.connect(_layout_markers)


func present(state: Dictionary, focused_id: String = "") -> void:
	_stations = state.stations
	_edges = state.edges
	_stops = state.plan.station_ids
	_enabled = state.plan.allowed_actions.edit
	var ids: Array = _stations.map(func(row: Dictionary) -> String: return row.id)
	for id: String in markers.keys():
		if id not in ids:
			markers[id].queue_free()
			markers.erase(id)
	for station: Dictionary in _stations:
		var id: String = station.id
		if not markers.has(id):
			var button := Button.new()
			button.name = "Map_" + id
			button.toggle_mode = true
			button.pressed.connect(func() -> void: station_requested.emit(id))
			add_child(button)
			markers[id] = button
		var number: int = _stops.find(id)
		markers[id].text = "%d. %s" % [number + 1, id] if number >= 0 else id
		markers[id].tooltip_text = "%s / %s · 목록에서도 선택 가능" % [id, station.neighborhood_id]
		markers[id].disabled = not _enabled and id not in _stops
		markers[id].button_pressed = id == focused_id
	_present_flow(state)
	_layout_markers()
	queue_redraw()


func _point(id: String) -> Vector2:
	for station: Dictionary in _stations:
		if station.id == id:
			return Vector2(
				55 + station.x_km * (size.x - 110) / 3, 42 + station.y_km * (size.y - 84) / 2
			)
	return Vector2.ZERO


func _layout_markers() -> void:
	for id: String in markers:
		markers[id].position = _point(id) - Vector2(36, 18)
		markers[id].size = Vector2(72, 36)
	queue_redraw()


func _draw() -> void:
	for edge: Array in _edges:
		draw_line(_point(edge[0]), _point(edge[1]), Color(0.45, 0.48, 0.52), 1.0)
	for index: int in range(1, operating_stops.size()):
		draw_line(
			_point(operating_stops[index - 1]),
			_point(operating_stops[index]),
			Color(0.95, 0.65, 0.2),
			9.0
		)
	for index: int in range(1, _stops.size()):
		var a: String = _stops[index - 1]
		var b: String = _stops[index]
		var connected: bool = [a, b] in _edges or [b, a] in _edges
		var color := Color(0.2, 0.8, 0.9) if connected else Color(1.0, 0.4, 0.3)
		draw_line(_point(a), _point(b), color, 4.0)

	for marker: Dictionary in flow_markers:
		draw_circle(
			_flow_point(marker.path, marker.progress) + Vector2(0, 23), 5.0, Color(1.0, 0.8, 0.25)
		)
	for id: String in station_flow:
		draw_arc(_point(id), 42, 0, TAU, 24, Color(0.95, 0.65, 0.2), 2.0)


func _present_flow(state: Dictionary) -> void:
	flow_markers.clear()
	operating_stops = []
	station_flow.clear()
	var value := Operations.operation(state)
	if value.is_empty() or not value.service_ready:
		return
	var stops: Variant = value.source.get("station_ids")
	if not stops is Array:
		return
	for id: Variant in stops:
		if not id is String or not markers.has(id):
			return
	operating_stops = stops.duplicate()
	var clock: Dictionary = state.clock
	if not clock.get("remainder") is int:
		return
	var observed := float(clock.simulation_minute) + float(clock.remainder) / 5000000.0
	for row: Variant in value.cohorts:
		if (
			not row is Dictionary
			or not Operations.numbers(row, ["count", "boarded_at", "expected_at"])
		):
			continue
		for pair: Variant in value.od_pairs:
			if not pair is Dictionary or pair.get("id") != row.get("od_id"):
				continue
			var start: int = stops.find(pair.get("origin"))
			var finish: int = stops.find(pair.get("destination"))
			if start < 0 or finish < 0 or start == finish or row.expected_at <= row.boarded_at:
				continue
			var path: Array = []
			var direction := 1 if finish > start else -1
			for index: int in range(start, finish + direction, direction):
				path.append(stops[index])
			flow_markers.append(
				{
					"path": path,
					"count": row.count,
					"progress":
					clampf((observed - row.boarded_at) / (row.expected_at - row.boarded_at), 0, 1)
				}
			)
			station_flow[path[0]] = station_flow.get(path[0], 0) + row.count
	for id: String in station_flow:
		markers[id].tooltip_text += " · 이 역 출발 이동 중 %d통행 (현재 cohort 집계)" % station_flow[id]


func _flow_point(path: Array, progress: float) -> Vector2:
	var lengths: Array[float] = []
	var total := 0.0
	for index: int in range(1, path.size()):
		var length := _point(path[index - 1]).distance_to(_point(path[index]))
		lengths.append(length)
		total += length
	var remaining := progress * total
	for index: int in lengths.size():
		if remaining <= lengths[index]:
			return _point(path[index]).lerp(
				_point(path[index + 1]), remaining / maxf(1.0, lengths[index])
			)
		remaining -= lengths[index]
	return _point(path.back())
