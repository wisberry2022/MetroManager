extends Control
## DATA 좌표의 추상 지도. 버튼과 목록은 동일 안정 ID를 요청한다.

signal station_requested(station_id: String)

var markers: Dictionary = {}
var _stations: Array = []
var _edges: Array = []
var _stops: Array = []
var _enabled: bool = true


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
	for index: int in range(1, _stops.size()):
		var a: String = _stops[index - 1]
		var b: String = _stops[index]
		var connected: bool = [a, b] in _edges or [b, a] in _edges
		var color := Color(0.2, 0.8, 0.9) if connected else Color(1.0, 0.4, 0.3)
		draw_line(_point(a), _point(b), color, 4.0)
