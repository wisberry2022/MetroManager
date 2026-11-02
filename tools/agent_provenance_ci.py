"""Trusted-base, data-only report adapter. No writes, credentials, or enforcement."""

from contextlib import redirect_stdout
import io
import json
import os
from pathlib import Path
import subprocess
import sys

# With python -I, only this explicitly trusted checkout's tools are imported.
sys.path.insert(0, str(Path(__file__).resolve().parent))
import agent_provenance as protocol
import agent_registry as registry


def report(event):
    base = head = None
    diagnostics = []
    try:
        pr = event["pull_request"]
        base_value, head_value = pr["base"]["sha"], pr["head"]["sha"]
        protocol.require(isinstance(base_value, str) and protocol.SHA.fullmatch(base_value) is not None
                         and isinstance(head_value, str) and protocol.SHA.fullmatch(head_value) is not None,
                         "COMMIT_SHA")
        base, head = base_value, head_value
        # Never accidentally test a PR-supplied executable from the head checkout.
        checkout = protocol.git("rev-parse", "HEAD").decode().strip()
        protocol.require(checkout == base, "TRUSTED_BASE_CHECKOUT_REQUIRED")
        task = protocol.gate.branch_task(pr["head"]["ref"])
        _, _, legacy = registry.trusted(base)
        # Validate each registry delta, not merely the final repaired snapshot.
        commits = protocol.git("rev-list", "--reverse", "--topo-order", f"{base}..{head}").decode().splitlines()
        for sha in commits:
            parents = protocol.git("rev-list", "--parents", "-n", "1", sha).decode().split()[1:]
            if len(parents) != 1:
                continue  # Existing gate separately proves/rejects every merge.
            if registry.REGISTRY in protocol.gate.changed_paths(parents[0], sha):
                protocol.require(task.startswith("INF-"), "REGISTRY_INF_TASK_REQUIRED")
                registry.compare(protocol.blob(parents[0], registry.REGISTRY),
                                 protocol.blob(sha, registry.REGISTRY), legacy)
        manifest = f"{protocol.gate.department(task)[1]}tasks/{task}_PROVENANCE.json"
        if task.startswith("DEV-"):
            candidates = [manifest, f"tasks/{task}_PROVENANCE.json"]
            names = set(protocol.gate.names_at(head))
            present = [name for name in candidates if name in names]
            protocol.require(len(present) <= 1, "MANIFEST_AMBIGUOUS")
            if present:
                manifest = present[0]
        body = pr.get("body") or ""
        with redirect_stdout(io.StringIO()):
            diagnostics = protocol.audit(base, head, task, pr["head"]["ref"],
                                         pr["title"], body, registry.REGISTRY, manifest)
    except protocol.Invalid as error:
        diagnostics = [str(error)]
    except (OSError, ValueError, TypeError, KeyError, subprocess.CalledProcessError):
        diagnostics = ["PROVENANCE_INPUT_INVALID"]
    return {"mode": "REPORT_ONLY", "protocol": "draft-v1", "base_sha": base, "head_sha": head,
            "result": "DIAGNOSTICS" if diagnostics else "DECLARATION_CONSISTENT",
            "diagnostics": diagnostics, "identity_authenticated": False,
            "approval_authenticated": False, "enforcement_enabled": False}


def main():
    try:
        path = Path(os.environ["GITHUB_EVENT_PATH"])
        protocol.require(path.stat().st_size <= protocol.LIMIT, "EVENT_TOO_LARGE")
        event = json.loads(path.read_text(encoding="utf-8"))
        result = report(event)
    except (KeyError, OSError, ValueError, protocol.Invalid):
        result = {"mode": "REPORT_ONLY", "result": "DIAGNOSTICS",
                  "diagnostics": ["EVENT_UNREADABLE"], "identity_authenticated": False,
                  "approval_authenticated": False, "enforcement_enabled": False}
    print(json.dumps(result, ensure_ascii=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
