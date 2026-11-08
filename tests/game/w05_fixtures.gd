extends RefCounted
## 승인된 B01 실제 입찰 경로와 내부 원장 반례 입력. 제품 자금 지원 기능은 없다.

const BidFX = preload("res://tests/game/w04a_fixtures.gd")
const Pipeline = preload("res://scripts/simulation/minute_pipeline.gd")


static func awarded() -> Pipeline:
	var pipe := BidFX.pipeline()
	pipe.enable_construction()
	pipe.submit_bid(BidFX.command())
	BidFX.advance_to(pipe, 1800)
	return pipe


static func command(
	pipe: Pipeline, action: String, id: String, mode: String = "STANDARD"
) -> Dictionary:
	var row := BidFX.row(pipe)
	return {
		"command_id": id,
		"project_id": row.terms.project_id,
		"business_contract_id": "B01-R1-BUSINESS",
		"action": action,
		"mode": mode,
		"requested_at": pipe.clock.minute,
		"effective_at": pipe.clock.minute + 1,
		"expected_snapshot_revision": pipe.snapshot().snapshot_revision,
		"target_revision": 0
	}


static func execute(
	pipe: Pipeline, action: String, id: String, mode: String = "STANDARD"
) -> Dictionary:
	var cmd := command(pipe, action, id, mode)
	pipe.submit_construction(cmd)
	BidFX.advance_to(pipe, cmd.effective_at)
	return pipe.construction_result(id)


static func row(pipe: Pipeline) -> Dictionary:
	var rows: Array = pipe.snapshot().construction.projects
	return {} if rows.is_empty() else rows[0]


static func started(mode: String = "STANDARD", start: int = 1802) -> Pipeline:
	var pipe := awarded()
	execute(pipe, "contract", "contract", mode)
	BidFX.advance_to(pipe, start - 1)
	execute(pipe, "start", "start", mode)
	return pipe


static func nonzero_entries(pipe: Pipeline) -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	for entry: Dictionary in pipe.ledger.entries():
		if entry.amount != 0:
			entries.append(entry)
	return entries
