"""Registry lifecycle proposals and trusted-base reports; fixtures are never issued IDs."""

import json
import os
from pathlib import Path
import subprocess
import sys
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "tools"))
import agent_provenance as protocol
import agent_registry as registry
import agent_provenance_ci as ci
from test_agent_provenance import repository, row, write, run, commit


def full_row(prefix="DEV", number="0001", **kwargs):
    value = row(prefix, number)
    value.update(record_version=1, predecessor_agent_id=None, role="Fixture",
                 session_scope=f"FIXTURE-{prefix}-{number}", session_kind="TEST",
                 activated_at="2026-11-02T10:00:00+09:00", retired_at=None, handoff_ref=None)
    value.update(kwargs)
    return value


def raw(rows):
    return json.dumps({"schema_version": 1, "agents": rows}).encode()


def event(f):
    return {"pull_request": {"base": {"sha": f.base},
                             "head": {"sha": f.head, "ref": f"codex/{f.task}-fixture"},
                             "title": f.title, "body": f.body}}


class RegistryReportingTests(unittest.TestCase):
    def test_real_merged_registry_legacy_and_separate_development_roles(self):
        previous = Path.cwd()
        try:
            os.chdir(Path(__file__).resolve().parents[2])
            data, agents, legacy = registry.trusted(registry.BOOTSTRAP)
            self.assertEqual(len(agents), 8)
            self.assertEqual(sum(r["status"] == "ACTIVE" for r in agents.values()), 7)
            self.assertEqual(len(legacy), 8)
            self.assertEqual(agents["AGT-DEV-0002"]["session_scope"], "DEVELOPMENT-CONVENTION-TEAM")
            self.assertIsNone(agents["AGT-DEV-0001"]["activated_at"])
            self.assertNotEqual(agents["AGT-DEV-0001"]["session_scope"],
                                agents["AGT-DEV-0003"]["session_scope"])
        finally:
            os.chdir(previous)

    def test_time_predecessor_generation_and_scope_validation(self):
        examples = [full_row(activated_at=None), full_row(activated_at="2026-11-02T10:00:00"),
                    full_row(predecessor_agent_id="AGT-DEV-9999", generation=2),
                    full_row(generation=2), full_row(record_version=0),
                    full_row(status="PENDING"), full_row(retired_at="2026-11-02T11:00:00+09:00")]
        for item in examples:
            with self.subTest(item=item), self.assertRaises(protocol.Invalid):
                registry.validate(raw([item]))
        with self.assertRaises(protocol.Invalid):
            registry.validate(raw([full_row(), full_row(number="0002", session_scope="FIXTURE-DEV-0001")]))
        self.assertEqual(len(registry.validate(raw([full_row(activated_at=None)]), {"AGT-DEV-0001"})[1]), 1)

    def test_immutable_records_deletion_versions_and_transition_review(self):
        original = full_row()
        for changes in ({"role": "Reassigned", "record_version": 2}, {"notes": "No version bump"},
                        {"status": "SUSPENDED", "record_version": 2},
                        {"owner_approval_ref": "FORGED", "record_version": 2},
                        {"record_version": 3}):
            modified = dict(original, **changes)
            with self.subTest(changes=changes), self.assertRaises(protocol.Invalid):
                registry.compare(raw([original]), raw([modified]))
        with self.assertRaises(protocol.Invalid):
            registry.compare(raw([original]), raw([]))
        self.assertEqual(len(registry.compare(raw([original]), raw([dict(original, notes="Reviewed", record_version=2)]))), 1)

    def test_new_pending_sequence_and_no_automatic_active(self):
        original = full_row(status="RETIRED", retired_at="2026-11-02T11:00:00+09:00")
        pending = full_row(number="0002", status="PENDING", activated_at=None)
        registry.compare(raw([original]), raw([original, pending]))
        for addition in (full_row(number="0002"), dict(pending, agent_id="AGT-DEV-0003")):
            with self.assertRaises(protocol.Invalid):
                registry.compare(raw([original]), raw([original, addition]))

    def test_root_claims_and_fake_legacy_null_do_not_grant_activation(self):
        old = {"schema_version": 1, "agents": [full_row()]}
        new = dict(old, registry_state="OWNER_APPROVED")
        with self.assertRaisesRegex(protocol.Invalid, "REGISTRY_ROOT_REVIEW_REQUIRED"):
            registry.compare(json.dumps(old).encode(), json.dumps(new).encode())
        forged = full_row(number="0002", activated_at=None,
                          owner_approval_ref="OWNER_DIRECT_INF_2026-11-02_INITIAL_REGISTRY_APPROVAL")
        with self.assertRaisesRegex(protocol.Invalid, "REGISTRY_ACTIVATION_TIME"):
            registry.compare(raw([full_row()]), raw([full_row(), forged]), {"AGT-DEV-0001"})

    def test_head_pending_registration_cannot_authorize_its_own_submission(self):
        with repository("INF", rows=[full_row("INF")]) as f:
            pending = full_row("INF", "0002", status="PENDING", activated_at=None)
            write(registry.REGISTRY, raw([full_row("INF"), pending]))
            f.primary = "AGT-INF-0002"
            f.footer = f"Agent-ID: {f.primary}\nTask-ID: {f.task}"
            f.body = "Synthetic.\n\n" + f.footer
            f.finish()
            subprocess.run(["git", "update-ref", "HEAD", f.base], check=True)
            self.assertEqual(ci.report(event(f))["diagnostics"], ["AGENT_UNREGISTERED"])

    def test_offline_proposal_preserves_registry_refs_index_and_checks_stale_base(self):
        with repository("INF", rows=[full_row("INF")]) as f:
            before = run("status", "--porcelain"), run("for-each-ref"), run("write-tree"), Path(registry.REGISTRY).read_bytes()
            proposed = registry.proposal(f.base, f.base, "INF-902", "INF", "Successor", "NEW-SCOPE",
                                         "AGT-INF-0001", "SYNTHETIC-CANDIDATE-APPROVAL", "TEST-HANDOFF")
            self.assertEqual(proposed["agent_id"], "AGT-INF-0002")
            self.assertFalse(proposed["reserved"])
            self.assertFalse(proposed["remote_write_performed"])
            new = proposed["registry"]["agents"][-1]
            self.assertEqual((new["generation"], new["status"], new["activated_at"]), (2, "PENDING", None))
            self.assertEqual(before, (run("status", "--porcelain"), run("for-each-ref"), run("write-tree"), Path(registry.REGISTRY).read_bytes()))
            with self.assertRaisesRegex(protocol.Invalid, "PROPOSAL_STALE_BASE"):
                registry.proposal(f.base, "0" * 40, "INF-902", "INF", "R", "S", None, "REF", None)
            with self.assertRaisesRegex(protocol.Invalid, "PROPOSAL_INF_TASK_REQUIRED"):
                registry.proposal(f.base, f.base, "DEV-902", "INF", "R", "S", None, "REF", None)

    def test_proposal_collision_requires_new_base_not_an_id_reservation(self):
        with repository("INF", rows=[full_row("INF")]) as f:
            def propose(base, scope):
                return registry.proposal(base, base, "INF-902", "INF", "R", scope, None, "TEST", None)
            first = propose(f.base, "S1")
            second = propose(f.base, "S2")
            self.assertEqual(first["agent_id"], second["agent_id"])
            # A serialized writer merged the first proposal; recalculate on the new base.
            write(registry.REGISTRY, json.dumps(first["registry"]))
            new_base = commit(f.base, "Synthetic merged registry proposal")
            third = propose(new_base, "S2")
            self.assertEqual(third["agent_id"], "AGT-INF-0003")

    def test_report_adapter_reads_base_only_and_never_logs_private_body(self):
        with repository(rows=[full_row()]) as f:
            f.finish()
            subprocess.run(["git", "update-ref", "HEAD", f.base], check=True)
            report = ci.report(event(f))
            self.assertEqual(report["result"], "DECLARATION_CONSISTENT")
            self.assertFalse(report["enforcement_enabled"])
            self.assertFalse(report["identity_authenticated"])
            private = event(f)
            private["pull_request"]["body"] = "PRIVATE-DO-NOT-LOG"
            self.assertNotIn("PRIVATE-DO-NOT-LOG", json.dumps(ci.report(private)))
            invalid = event(f)
            invalid["pull_request"]["head"]["sha"] = "PRIVATE-INVALID-SHA"
            self.assertNotIn("PRIVATE-INVALID-SHA", json.dumps(ci.report(invalid)))
            subprocess.run(["git", "update-ref", "HEAD", f.head], check=True)
            self.assertEqual(ci.report(event(f))["diagnostics"], ["TRUSTED_BASE_CHECKOUT_REQUIRED"])

    def test_registry_head_self_registration_and_bad_intermediate_change_are_reported(self):
        with repository("INF", rows=[full_row("INF")]) as f:
            changed = full_row("INF", status="SUSPENDED", record_version=2)
            write(registry.REGISTRY, raw([changed]))
            bad = f.finish()
            write(registry.REGISTRY, raw([full_row("INF")]))
            f.finish(parent=bad)
            subprocess.run(["git", "update-ref", "HEAD", f.base], check=True)
            self.assertEqual(ci.report(event(f))["diagnostics"], ["REGISTRY_TRANSITION_REVIEW_REQUIRED"])

    def test_existing_development_manifest_location_and_ambiguous_pair(self):
        with repository(rows=[full_row()]) as f:
            canonical = f.manifest
            f.manifest = f"tasks/{f.task}_PROVENANCE.json"
            # Existing path policy only grants legacy *.md by default. JSON requires
            # an explicit trusted-base exception; the adapter must not expand it.
            write("docs/governance/path_exceptions.json", json.dumps({f.task: {
                "paths": [f.manifest], "decision": "SYNTHETIC-NOT-AN-APPROVAL",
                "reason": "Fixture-only legacy JSON path grant", "expires": "2099-01-01"}}))
            f.base = commit(f.base, "Synthetic trusted exception base")
            f.finish()
            subprocess.run(["git", "update-ref", "HEAD", f.base], check=True)
            self.assertEqual(ci.report(event(f))["diagnostics"], [])
            write(canonical, "{}\n")
            f.finish()
            self.assertEqual(ci.report(event(f))["diagnostics"], ["MANIFEST_AMBIGUOUS"])

    def test_clean_base_sync_preserves_old_snapshot_and_followup_uses_new_base(self):
        with repository(rows=[full_row()]) as f:
            old_base = f.base
            work = f.finish()
            run("read-tree", old_base)
            write("docs/design/trusted.md", "Trusted main update\n")
            main = commit(old_base, "Synthetic trusted main")
            tree = run("merge-tree", "--write-tree", work, main).decode().splitlines()[0]
            synced = subprocess.check_output(["git", "commit-tree", tree, "-p", work, "-p", main],
                                            input=b"Merge branch main\n").decode().strip()
            f.base, f.head = main, synced
            self.assertEqual(f.audit(), [])
            run("read-tree", synced)
            write(f.root + "followup.md", "New work after sync\n")
            f.finish(parent=synced)
            self.assertEqual(f.audit(), [])
            subprocess.run(["git", "update-ref", "HEAD", main], check=True)
            self.assertEqual(ci.report(event(f))["diagnostics"], [])

    def test_report_cli_exit_zero_and_workflow_trust_contract(self):
        module = Path(ci.__file__).resolve()
        with repository(rows=[full_row()]) as f:
            f.finish()
            subprocess.run(["git", "update-ref", "HEAD", f.base], check=True)
            Path("event.json").write_text(json.dumps(event(f)), encoding="utf-8")
            with patch.dict(os.environ, GITHUB_EVENT_PATH=str(Path("event.json").resolve())):
                output = subprocess.check_output([sys.executable, "-I", str(module)])
                bad = event(f)
                bad["pull_request"]["body"] = "PRIVATE-INVALID-DECLARATION"
                Path("event.json").write_text(json.dumps(bad), encoding="utf-8")
                diagnosed = subprocess.check_output([sys.executable, "-I", str(module)])
            self.assertEqual(json.loads(output)["result"], "DECLARATION_CONSISTENT")
            self.assertEqual(json.loads(diagnosed)["result"], "DIAGNOSTICS")
            self.assertNotIn(b"PRIVATE-INVALID", diagnosed)
        import yaml
        root = Path(__file__).resolve().parents[2]
        workflow = yaml.safe_load((root / ".github/workflows/agent-provenance-report.yml").read_text())
        self.assertEqual(workflow["permissions"], {"contents": "read"})
        job = workflow["jobs"]["agent-provenance-report"]
        checkout = job["steps"][0]["with"]
        self.assertEqual(checkout["ref"], "${{ github.event.pull_request.base.sha }}")
        self.assertFalse(checkout["persist-credentials"])
        self.assertNotIn("continue-on-error", job)
        self.assertIn("python -I", job["steps"][-1]["run"])


if __name__ == "__main__":
    unittest.main()
