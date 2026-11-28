extends RefCounted
## 실패 계획에 고정된 출발 동과 사업별 수요판의 공통 형식.

const Network = preload("res://scripts/model/administrative_network.gd")
const BASE_UNITS: int = 4
const BOOST_UNITS: int = 5


static func destination_district(origin: String) -> String:
	return "D%02d" % (int(origin.substr(1)) % 8 + 1)


static func od_ids(targets: Array[String]) -> Array[String]:
	var result: Array[String] = []
	for origin: String in targets:
		result.append(origin + ":" + destination_district(origin))
	return result


static func target_districts(network: Network, stops: Array) -> Array[String]:
	var result: Array[String] = []
	for stop: String in stops:
		var district: String = network.station(stop).neighborhood_id
		if district not in result:
			result.append(district)
	result.sort()
	return result


static func valid_targets(targets: Variant) -> bool:
	if not targets is Array or targets.is_empty() or targets.size() > 8:
		return false
	var previous := ""
	for id: Variant in targets:
		if not id is String or id not in ["D01", "D02", "D03", "D04", "D05", "D06", "D07", "D08"]:
			return false
		if id <= previous:
			return false
		previous = id
	return true


static func valid(profile: Dictionary) -> bool:
	return (
		profile.is_empty()
		or (
			profile.get("business_identity_id") is String
			and not profile.business_identity_id.is_empty()
			and profile.get("fact_id") is String
			and not profile.fact_id.is_empty()
			and profile.get("effective_at") is int
			and profile.effective_at >= 0
			and is_same(profile.get("revision"), 1)
			and valid_targets(profile.get("origin_districts"))
			and profile.get("multiplier") == [BOOST_UNITS, BASE_UNITS]
		)
	)
