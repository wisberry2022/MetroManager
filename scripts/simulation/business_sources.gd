class_name BusinessSources
extends RefCounted
## 실제 계약/거래를 대조하는 읽기 전용 경계. P1에서는 W05/W06 소비자를 변경하지 않는다.

const Ledger = preload("res://scripts/model/company_ledger.gd")


static func collect(
	tenders: Dictionary, proposals: Dictionary, ledger: Ledger, minute: int
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
			if not _valid_contract(contract, ledger, minute):
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


static func _valid_contract(contract: Dictionary, ledger: Ledger, minute: int) -> bool:
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
	var entries := ledger.entries()
	if payment.ledger_entry_index >= entries.size():
		return false
	var entry: Dictionary = entries[payment.ledger_entry_index]
	var funds := ledger.snapshot()
	return (
		entry.get("kind") == "government"
		and entry.get("amount") == payment.amount
		and entry.get("effective_at") == payment.effective_at
		and funds.restricted_by_project.has(contract.project_id)
		and funds.reserved_by_project.has(contract.project_id)
	)


static func _source(row: Dictionary, contract: Dictionary, kind: String) -> Dictionary:
	var stops: Array = []
	var source_id: String = ""
	if kind == "PUBLIC_TENDER":
		var terms: Variant = row.get("terms")
		if not terms is Dictionary or not terms.get("station_ids") is Array:
			return {}
		if (
			not terms.get("tender_id") is String
			or not is_same(terms.get("project_id"), contract.project_id)
		):
			return {}
		stops = terms.station_ids
		source_id = terms.tender_id
	else:
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
	if source_id.is_empty() or stops.size() < 6 or stops.size() > 8:
		return {}
	var seen: Dictionary = {}
	for station: Variant in stops:
		if not station is String or station.is_empty() or seen.has(station):
			return {}
		seen[station] = true
	return {
		"source_kind": kind,
		"source_id": source_id,
		"project_id": contract.project_id,
		"business_contract_id": contract.business_contract_id,
		"station_ids": stops.duplicate(),
		"business_contract": contract.duplicate(true),
	}


static func _error(reason: String) -> Dictionary:
	return {"available": false, "sources": [], "reason_codes": [reason]}
