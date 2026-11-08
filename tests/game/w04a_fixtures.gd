extends RefCounted
## 자동 검증용 명령/관측만 생성한다. 제품 성공 상태를 강제로 주입하지 않는다.

const Pipeline = preload("res://scripts/simulation/minute_pipeline.gd")


static func pipeline(initial: Dictionary = {}, minute: int = 360) -> Pipeline:
	var value := Pipeline.new(initial, minute)
	value.enable_tenders()
	return value


static func command(
	id: String = "bid-1", tender: String = "B01", requested: int = 360, effective: int = 361
) -> Dictionary:
	return {
		"command_id": id,
		"tender_id": tender,
		"round_id": tender + "-R1",
		"requested_at": requested,
		"effective_at": effective,
		"expected_snapshot_revision": 0,
		"target_revision": 0,
		"plan_revision": 0
	}


static func advance_to(value: Pipeline, minute: int) -> void:
	# 게임 시각 권위는 Clock뿐이다. 최소 usec를 올림해 목표 정수분에 도달한다.
	var units: int = (minute - value.clock.minute) * 5000000 - value.clock.remainder
	if units > 0:
		value.advance_usec(ceili(float(units) / (12 * value.clock.speed)))


static func row(value: Pipeline, id: String = "B01") -> Dictionary:
	for item: Dictionary in value.snapshot().tenders.tenders:
		if item.terms.tender_id == id:
			return item
	return {}
