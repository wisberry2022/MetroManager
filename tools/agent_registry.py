"""INF-owned registry validation and offline PENDING proposal; never issues live IDs."""

import argparse
from copy import deepcopy
from datetime import datetime
import json
import subprocess

import agent_provenance as protocol

REGISTRY = "docs/infra/agents/registry.json"
BOOTSTRAP = "682a4f10f2cfe14bed6984e87bff75c05f37d8b5"  # Reviewed INF-002 bootstrap.
IMMUTABLE = ("agent_id", "department", "generation", "predecessor_agent_id",
             "role", "session_scope", "session_kind")
REGISTRATION_STEPS = ["PENDING_PR", "INF_ACCEPTANCE", "PM_SWITCH_CONFIRMATION",
                      "OWNER_ACTIVATION_APPROVAL_AND_MERGE"]


def text(value, code):
    protocol.require(isinstance(value, str) and bool(value.strip())
                     and not any(ord(c) < 32 for c in value), code)


def timestamp(value):
    try:
        protocol.require(isinstance(value, str) and "T" in value, "REGISTRY_TIMESTAMP")
        parsed = datetime.fromisoformat(value.replace("Z", "+00:00"))
        protocol.require(parsed.utcoffset() is not None, "REGISTRY_TIMESTAMP")
        return parsed
    except (TypeError, ValueError):
        raise protocol.Invalid("REGISTRY_TIMESTAMP") from None


def validate(raw, legacy_ids=()):
    data = protocol.json_data(raw)
    agents = protocol.registry(raw)
    for agent, row in agents.items():
        protocol.require(set(IMMUTABLE) | {"activated_at", "retired_at", "record_version"}
                         <= set(row), "REGISTRY_FIELDS")
        protocol.require(type(row.get("record_version")) is int
                         and row["record_version"] > 0, "REGISTRY_RECORD_VERSION")
        for key in ("role", "session_scope", "session_kind"):
            text(row.get(key), "REGISTRY_ROLE")
        text(row.get("owner_approval_ref"), "AGENT_APPROVAL_REFERENCE")
        predecessor = row.get("predecessor_agent_id")
        if predecessor is not None:
            protocol.require(predecessor in agents and predecessor != agent,
                             "REGISTRY_PREDECESSOR")
            previous = agents[predecessor]
            protocol.require(previous["department"] == row["department"]
                             and previous["generation"] + 1 == row["generation"],
                             "REGISTRY_PREDECESSOR")
            text(row.get("handoff_ref"), "REGISTRY_HANDOFF")
        else:
            protocol.require(row["generation"] == 1, "REGISTRY_GENERATION")
        active, retired = row.get("activated_at"), row.get("retired_at")
        for value in (active, retired):
            if value is not None:
                timestamp(value)
        if row["status"] in {"ACTIVE", "RETIRED"}:
            protocol.require(active is not None or agent in legacy_ids, "REGISTRY_ACTIVATION_TIME")
        if row["status"] == "RETIRED":
            protocol.require(retired is not None or agent in legacy_ids, "REGISTRY_RETIREMENT_TIME")
        else:
            protocol.require(retired is None, "REGISTRY_RETIREMENT_STATE")
        if row["status"] == "PENDING":
            protocol.require(active is None, "REGISTRY_PENDING_TIME")
        if active is not None and retired is not None:
            protocol.require(timestamp(active) <= timestamp(retired), "REGISTRY_TIME_ORDER")
        seen, cursor = set(), agent
        while cursor is not None:
            protocol.require(cursor in agents and cursor not in seen, "REGISTRY_CYCLE")
            seen.add(cursor)
            cursor = agents[cursor].get("predecessor_agent_id")
    active_scopes = [r["session_scope"] for r in agents.values() if r["status"] == "ACTIVE"]
    protocol.require(len(set(active_scopes)) == len(active_scopes), "REGISTRY_DUPLICATE_SCOPE")
    return data, agents


def bootstrap_legacy(base):
    """Only the pinned, already merged INF bootstrap may grant historical null times."""
    try:
        sha = protocol.git("rev-parse", BOOTSTRAP + "^{commit}").decode().strip()
        ancestor = subprocess.run(["git", "merge-base", "--is-ancestor", sha, base],
                                  capture_output=True)
        if ancestor.returncode != 0:
            return set()
        initial = protocol.registry(protocol.blob(sha, REGISTRY))
        return {key for key, row in initial.items() if row.get("activated_at") is None}
    except (OSError, ValueError, subprocess.CalledProcessError):
        return set()


def trusted(base):
    protocol.require(protocol.SHA.fullmatch(base) is not None, "COMMIT_SHA")
    legacy = bootstrap_legacy(base)
    data, agents = validate(protocol.blob(base, REGISTRY), legacy)
    return data, agents, legacy


def compare(old_raw, new_raw, legacy_ids=()):
    """Structural consistency only. Approval reference strings do not authenticate approval."""
    old_data, before = validate(old_raw, legacy_ids)
    new_data, after = validate(new_raw, legacy_ids)
    protocol.require({k: v for k, v in old_data.items() if k != "agents"}
                     == {k: v for k, v in new_data.items() if k != "agents"},
                     "REGISTRY_ROOT_REVIEW_REQUIRED")
    protocol.require(set(before) <= set(after), "REGISTRY_ID_DELETED")
    for agent, old in before.items():
        new = after[agent]
        protocol.require(all(old.get(k) == new.get(k) for k in IMMUTABLE), "REGISTRY_ID_REASSIGNED")
        if old == new:
            continue
        protocol.require(new["record_version"] == old["record_version"] + 1,
                         "REGISTRY_VERSION_STEP")
        # New transition/event policy is unresolved. Diagnose rather than invent authority.
        protocol.require(old["status"] == new["status"], "REGISTRY_TRANSITION_REVIEW_REQUIRED")
        for key in ("activated_at", "retired_at", "owner_approval_ref",
                    "agent_id_activation_approval_ref", "handoff_ref"):
            protocol.require(old.get(key) == new.get(key), "REGISTRY_HISTORY_CHANGED")
    for department in protocol.gate.DEPARTMENTS:
        prefix = f"AGT-{department}-"
        maximum = max((int(k[-4:]) for k in before if k.startswith(prefix)), default=0)
        additions = sorted(int(k[-4:]) for k in after.keys() - before.keys() if k.startswith(prefix))
        protocol.require(additions == list(range(maximum + 1, maximum + 1 + len(additions))),
                         "REGISTRY_SEQUENCE_REUSE")
    for agent in after.keys() - before.keys():
        row = after[agent]
        protocol.require(row["status"] == "PENDING" and row["record_version"] == 1,
                         "REGISTRY_NEW_PENDING_ONLY")
        text(row.get("owner_approval_ref"), "AGENT_APPROVAL_REFERENCE")
    return after


def proposal(base, expected_base, task, department, role, scope, predecessor, approval, handoff):
    protocol.require(base == expected_base, "PROPOSAL_STALE_BASE")
    protocol.gate.department(task)
    protocol.require(task.startswith("INF-"), "PROPOSAL_INF_TASK_REQUIRED")
    data, agents, legacy = trusted(base)
    protocol.require(department in protocol.gate.DEPARTMENTS, "AGENT_DEPARTMENT")
    for value in (role, scope, approval):
        text(value, "PROPOSAL_REFERENCE")
    protocol.require(scope not in {r["session_scope"] for r in agents.values()
                                  if r["status"] in {"PENDING", "ACTIVE"}}, "REGISTRY_DUPLICATE_SCOPE")
    generation = 1
    if predecessor:
        protocol.require(predecessor in agents and agents[predecessor]["department"] == department,
                         "REGISTRY_PREDECESSOR")
        text(handoff, "REGISTRY_HANDOFF")
        generation = agents[predecessor]["generation"] + 1
    maximum = max((int(k[-4:]) for k in agents if k.startswith(f"AGT-{department}-")), default=0)
    protocol.require(maximum < 9999, "REGISTRY_SEQUENCE_EXHAUSTED")
    agent = f"AGT-{department}-{maximum + 1:04d}"
    result = deepcopy(data)
    result["agents"].append({
        "agent_id": agent, "department": department, "generation": generation,
        "status": "PENDING", "role": role, "session_scope": scope, "session_kind": "UNCONFIRMED",
        "predecessor_agent_id": predecessor, "activated_at": None, "retired_at": None,
        "owner_approval_ref": approval, "handoff_ref": handoff, "record_version": 1,
    })
    raw = json.dumps(result, ensure_ascii=False).encode()
    compare(protocol.blob(base, REGISTRY), raw, legacy)
    return {"mode": "OFFLINE_PROPOSAL", "agent_id": agent, "reserved": False,
            "expected_main_sha": base,
            "expected_registry_blob_sha": protocol.git("rev-parse", f"{base}:{REGISTRY}").decode().strip(),
            "branch": f"codex/{task}-agent-registration", "path": REGISTRY,
            "registry": result, "remote_write_performed": False,
            "review_sequence": REGISTRATION_STEPS,
            "requires": ["INF_ACCEPTANCE", "PM_SWITCH_CONFIRMATION", "OWNER_ACTIVATION_APPROVAL",
                         "SINGLE_WRITER_CAS", "MANUAL_MAIN_MERGE"]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["check", "propose"])
    parser.add_argument("--base", required=True)
    parser.add_argument("--head")
    parser.add_argument("--task")
    parser.add_argument("--department", choices=list(protocol.gate.DEPARTMENTS))
    parser.add_argument("--role")
    parser.add_argument("--scope")
    parser.add_argument("--predecessor")
    parser.add_argument("--approval-ref")
    parser.add_argument("--handoff-ref")
    args = parser.parse_args()
    try:
        if args.command == "check":
            _, agents, legacy = trusted(args.base)
            if args.head:
                protocol.require(protocol.SHA.fullmatch(args.head) is not None, "COMMIT_SHA")
                agents = compare(protocol.blob(args.base, REGISTRY), protocol.blob(args.head, REGISTRY), legacy)
            result = {"result": "STRUCTURALLY_CONSISTENT", "agents": len(agents),
                      "identity_authenticated": False, "approval_authenticated": False}
        else:
            expected = protocol.git("rev-parse", "refs/remotes/origin/main").decode().strip()
            result = proposal(args.base, expected, args.task, args.department, args.role, args.scope,
                              args.predecessor, args.approval_ref, args.handoff_ref)
        print(json.dumps(result, ensure_ascii=False))
        return 0
    except (protocol.Invalid, OSError, ValueError, TypeError, subprocess.CalledProcessError) as error:
        code = str(error) if isinstance(error, protocol.Invalid) else "REGISTRY_INPUT_INVALID"
        print(json.dumps({"result": "DIAGNOSTICS", "diagnostics": [code]}))
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
