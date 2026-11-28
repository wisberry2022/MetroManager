class_name BusinessSources
extends RefCounted
## 실제 계약/거래를 대조하는 읽기 전용 경계. W04A/W04B 출처를 명시적으로 연결한다.

const Ledger = preload("res://scripts/model/company_ledger.gd")
const Profile = preload("res://scripts/simulation/proposal_demand_profile.gd")
const REVISION := "DEV027-BUSINESS-1"


static func collect(
	tenders: Dictionary,
	proposals: Dictionary,
	ledger: Ledger,
	minute: int,
	verified: Dictionary = {}
) -> Dictionary:
	var result := {"available": true, "sources": [], "reason_codes": []}
	var seen: Dictionary = {}
	for spec: Dictionary in [
		{"envelope": tenders, "rows": "tenders", "kind": "PUBLIC_TENDER"},
		{"envelope": proposals, "rows": "proposals", "kind": "COMPANY_PROPOSAL"},
	]:
		var envelope: Dictionary = spec.envelope
		if envelope.is_empty():
			continue
		if not is_same(envelope.get("available"), true) or not envelope.get(spec.rows) is Array:
			return _error("INVALID_SOURCE_ENVELOPE")
		for row: Variant in envelope[spec.rows]:
			if not row is Dictionary or not row.get("business_contract") is Dictionary:
				return _error("INVALID_SOURCE_ROW")
			var contract: Dictionary = row.business_contract
			if contract.is_empty() or is_same(contract.get("status"), "REJECTED"):
				continue
			if not _valid_contract(contract, ledger, minute, verified):
				return _error("CONTRACT_PAYMENT_MISMATCH")
			var source := _source(row, contract, spec.kind)
			if source.is_empty():
				return _error("INVALID_PERMISSION_SOURCE")
			if seen.has(contract.project_id) or seen.has(contract.business_contract_id):
				return _error("DUPLICATE_BUSINESS_SOURCE")
			seen[contract.project_id] = true
			seen[contract.business_contract_id] = true
			result.sources.append(source)
	return result


static func _valid_contract(
	contract: Dictionary, ledger: Ledger, minute: int, verified: Dictionary
) -> bool:
	for key: String in ["business_contract_id", "project_id"]:
		if not contract.get(key) is String or contract[key].is_empty():
			return false
	if not is_same(contract.get("status"), "EFFECTIVE") or not contract.get("effective_at") is int:
		return false
	var payment: Variant = contract.get("government_payment")
	if not payment is Dictionary or not is_same(payment.get("available"), true):
		return false
	for key: String in ["amount", "effective_at", "ledger_entry_index"]:
		if not payment.get(key) is int or payment[key] < 0:
			return false
	if not payment.get("transaction_id") is String or payment.transaction_id.is_empty():
		return false
	if not is_same(payment.get("restricted_project_id"), contract.project_id):
		return false
	if payment.effective_at != contract.effective_at or payment.effective_at > minute:
		return false
	var funds := ledger.snapshot()
	if (
		not funds.restricted_by_project.has(contract.project_id)
		or not funds.reserved_by_project.has(contract.project_id)
	):
		return false
	# 공개 원장 항목은 추가만 된다. 캐시는 소비자 소유이며 다른 원장/변경 지급에는 재사용하지 않는다.
	var key: String = str(ledger.get_instance_id()) + ":" + payment.transaction_id
	if verified.get(key) == contract:
		return true
	var entries := ledger.entries()
	if payment.ledger_entry_index >= entries.size():
		return false
	var entry: Dictionary = entries[payment.ledger_entry_index]
	var valid: bool = (
		entry.get("kind") == "government"
		and entry.get("amount") == payment.amount
		and entry.get("effective_at") == payment.effective_at
		and funds.restricted_by_project.has(contract.project_id)
		and funds.reserved_by_project.has(contract.project_id)
	)
	if valid:
		verified[key] = contract.duplicate(true)
	return valid


static func _source(row: Dictionary, contract: Dictionary, kind: String) -> Dictionary:
	var stops: Array = []
	var source_id: String = ""
	var permission := {}
	var profile := {}
	if kind == "PUBLIC_TENDER":
		var terms: Variant = row.get("terms")
		if not terms is Dictionary or not terms.get("station_ids") is Array:
			return {}
		if (
			not terms.get("tender_id") is String
			or not is_same(terms.get("project_id"), contract.project_id)
			or not is_same(terms.get("fare"), 100)
			or not is_same(
				contract.government_payment.transaction_id,
				str(terms.get("round_id", "")) + "-GOVERNMENT"
			)
		):
			return {}
		stops = terms.station_ids
		source_id = terms.tender_id
	else:
		permission = _proposal_permission(row, contract)
		if permission.is_empty():
			return {}
		var permitted: Variant = contract.get("permitted_plan")
		if not permitted is Dictionary or not permitted.get("plan") is Dictionary:
			return {}
		if not permitted.plan.get("station_ids") is Array:
			return {}
		var identity: Variant = permitted.get("identity")
		if (
			not identity is Dictionary
			or not is_same(identity.get("business_identity_id"), contract.project_id)
			or not row.get("identity") is Dictionary
			or row.identity != identity
		):
			return {}
		if (
			not is_same(contract.get("source_kind"), kind)
			or not contract.get("source_id") is String
		):
			return {}
		if not is_same(identity.get("proposal_id"), contract.source_id):
			return {}
		source_id = contract.source_id
		stops = permitted.plan.station_ids
		var supplied: Variant = permitted.get("demand_profile", {})
		if not supplied is Dictionary or not Profile.valid(supplied):
			return {}
		if (
			not supplied.is_empty()
			and (
				supplied.business_identity_id != contract.project_id
				or supplied.effective_at > permission.admitted_at
			)
		):
			return {}
		profile = supplied
	if source_id.is_empty() or stops.size() < 6 or stops.size() > 8:
		return {}
	var seen: Dictionary = {}
	for station: Variant in stops:
		if not station is String or station.is_empty() or seen.has(station):
			return {}
		seen[station] = true
	var result := {
		"source_kind": kind,
		"source_id": source_id,
		"project_id": contract.project_id,
		"business_contract_id": contract.business_contract_id,
		"station_ids": stops.duplicate(),
		"business_contract": contract.duplicate(true),
		"terms": row.terms.duplicate(true) if kind == "PUBLIC_TENDER" else {},
		"permission": permission,
		"fare": 100,
	}
	if not profile.is_empty():
		result["demand_profile"] = profile.duplicate(true)
	return result


static func _error(reason: String) -> Dictionary:
	return {"available": false, "sources": [], "reason_codes": [reason]}


static func _proposal_permission(row: Dictionary, contract: Dictionary) -> Dictionary:
	if not row.get("decisions") is Array or not contract.get("permitted_plan") is Dictionary:
		return {}
	for decision: Variant in row.decisions:
		if (
			not decision is Dictionary
			or not is_same(decision.get("decision_id"), contract.get("decision_id"))
		):
			continue
		if (
			not is_same(decision.get("outcome"), "APPROVED")
			or decision.get("kind") not in ["GOVERNMENT", "PERSUASION"]
			or not is_same(
				decision.get("authorized_government"), contract.government_payment.amount
			)
			or not is_same(decision.get("business_identity_id"), contract.project_id)
			or not decision.get("submission") is Dictionary
			or decision.submission != contract.permitted_plan
			or not is_same(contract.business_contract_id, str(decision.decision_id) + ":business")
			or not is_same(
				contract.government_payment.transaction_id,
				contract.business_contract_id + ":government"
			)
		):
			return {}
		return decision.duplicate(true)
	return {}


## 설치 실패는 source_status에 남긴다. 독립 유효 출처는 계속 사용할 수 있다.
static func packet(
	tenders: Dictionary,
	proposals: Dictionary,
	ledger: Ledger,
	minute: int,
	revision: int,
	verified: Dictionary = {}
) -> Dictionary:
	var result := {
		"available": false,
		"source_contract_revision": REVISION,
		"data_version": "1.3",
		"simulation_minute": minute,
		"snapshot_revision": revision,
		"sources": [],
		"source_status": {},
		"reason_codes": []
	}
	var seen := {}
	for kind: String in ["PUBLIC_TENDER", "COMPANY_PROPOSAL"]:
		var input := tenders if kind == "PUBLIC_TENDER" else proposals
		if input.is_empty():
			result.source_status[kind] = {"status": "NOT_INSTALLED", "available": false}
			continue
		var checked := collect(
			input if kind == "PUBLIC_TENDER" else {},
			input if kind == "COMPANY_PROPOSAL" else {},
			ledger,
			minute,
			verified
		)
		if not input.get("simulation_minute") is int or input.simulation_minute != minute:
			checked = _error("STALE_BUSINESS_SOURCE")
		result.source_status[kind] = {
			"status": "READY" if checked.available else "INVALID",
			"available": checked.available,
			"reason_codes": checked.reason_codes
		}
		if not checked.available:
			continue
		result.available = true
		for row: Dictionary in checked.sources:
			if seen.has(row.project_id) or seen.has(row.business_contract_id):
				result.available = false
				result.sources = []
				result.reason_codes = ["DUPLICATE_BUSINESS_SOURCE"]
				return result
			seen[row.project_id] = true
			seen[row.business_contract_id] = true
			result.sources.append(row)
	if not result.available:
		result.reason_codes = ["BUSINESS_SOURCE_UNAVAILABLE"]
	return result


## 소비자가 받은 정상화 사본도 계약/원장과 다시 대조한다.
static func rows(
	value: Dictionary, ledger: Ledger, minute: int, verified: Dictionary = {}
) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if (
		not is_same(value.get("source_contract_revision"), REVISION)
		or not is_same(value.get("available"), true)
		or not is_same(value.get("simulation_minute"), minute)
		or not value.get("sources") is Array
	):
		return result
	var seen := {}
	for raw: Variant in value.sources:
		if not raw is Dictionary or not raw.get("business_contract") is Dictionary:
			return []
		var contract: Dictionary = raw.business_contract
		if not _valid_contract(contract, ledger, minute, verified):
			return []
		var kind: Variant = raw.get("source_kind")
		if not kind is String or kind not in ["PUBLIC_TENDER", "COMPANY_PROPOSAL"]:
			return []
		var original := {"terms": raw.get("terms"), "business_contract": contract}
		if kind == "COMPANY_PROPOSAL":
			var permitted: Variant = contract.get("permitted_plan")
			if not permitted is Dictionary:
				return []
			original.identity = permitted.get("identity")
			original.decisions = [raw.get("permission")]
		var expected := _source(original, contract, kind)
		if expected.is_empty() or raw != expected or seen.has(raw.project_id):
			return []
		seen[raw.project_id] = true
		result.append(raw.duplicate(true))
	return result
