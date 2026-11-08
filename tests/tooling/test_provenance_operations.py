"""Operational diagnostics on temporary objects, including the real approved base registry."""

import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "tools"))
import agent_provenance as protocol
import agent_provenance_ci as ci
import agent_registry as registry
from test_agent_provenance import repository, row, write, run
from test_agent_registry_reporting import full_row, event

APPROVED_BASE = "fba3fd575c83e1eae234dc77aa9207898e0849b3"


def detailed(f, **overrides):
    args = dict(base=f.base, head=f.head, task=f.task, branch=f"codex/{f.task}-fixture",
                title=f.title, body=f.body, registry_path=registry.REGISTRY, manifest_path=f.manifest)
    args.update(overrides)
    return protocol.audit_detailed(**args)


class OperationalDiagnosticsTests(unittest.TestCase):
    def test_missing_manifest_is_not_misreported_as_existing_policy_failure(self):
        with repository() as f:
            f.finish()
            # Construct a valid ordinary task commit without a manifest, as PR #67/#69 did.
            run("read-tree", f.head)
            run("update-index", "--force-remove", f.manifest)
            tree = run("write-tree").decode().strip()
            f.head = subprocess.check_output(["git", "commit-tree", tree, "-p", f.base],
                                            input=(f.title + "\n\nFixture.\n\n" + f.footer).encode()).decode().strip()
            result = detailed(f)
            self.assertEqual(result["diagnostics"], ["MANIFEST_NOT_FOUND"])
            self.assertEqual(result["diagnostic_details"], [{"code": "MANIFEST_NOT_FOUND",
                              "stage": "commit_manifest", "commit_sha": f.head, "path": f.manifest}])

    def test_pr_and_commit_trailer_errors_have_distinct_stages(self):
        with repository() as f:
            f.finish()
            result = detailed(f, body="PRIVATE-INVALID-PR")
            self.assertEqual(result["diagnostics"], ["TRAILER_BLOCK"])
            self.assertEqual(result["diagnostic_details"][0]["stage"], "pr_declaration")
            self.assertNotIn("PRIVATE-INVALID", json.dumps(result))
            f.finish(footer="PRIVATE-INVALID-COMMIT")
            result = detailed(f)
            self.assertEqual(result["diagnostic_details"][0]["stage"], "commit_declaration")
            self.assertEqual(result["diagnostic_details"][0]["commit_sha"], f.head)
            self.assertNotIn("PRIVATE-INVALID", json.dumps(result))

    def test_existing_policy_rejection_does_not_dump_path_or_error_text(self):
        with repository() as f:
            write("docs/design/PRIVATE-FORBIDDEN.md", "Fixture\n")
            f.finish()
            result = detailed(f)
            self.assertEqual(result["diagnostics"], ["INPUT_OR_EXISTING_POLICY_INVALID"])
            self.assertEqual(result["diagnostic_details"][0]["stage"], "existing_policy")
            self.assertNotIn("PRIVATE-FORBIDDEN", json.dumps(result))

    def test_crlf_metadata_uses_same_strict_footer_and_missing_still_fails(self):
        with repository() as f:
            f.finish(footer=f.footer.replace("\n", "\r\n"))
            self.assertEqual(detailed(f, body=f.body.replace("\n", "\r\n"))["diagnostics"], [])
            for body in ("No footer", f.body + "\nAgent-ID: " + f.primary):
                self.assertTrue(detailed(f, body=body)["diagnostics"])

    def test_negative_id_and_blob_codes_remain_enforced_as_diagnostics(self):
        for status in ("PENDING", "SUSPENDED", "RETIRED"):
            with self.subTest(status=status), repository(rows=[row(status=status)]) as f:
                f.finish()
                result = detailed(f)
                self.assertEqual(result["diagnostics"], ["AGENT_INACTIVE"])
                self.assertEqual(result["diagnostic_details"][0]["stage"], "pr_declaration")
        with repository() as f:
            f.finish()
            self.assertEqual(detailed(f, body=f.body.replace(f.primary, "AGT-DEV-9999"))["diagnostics"],
                             ["AGENT_UNREGISTERED"])
            f.finish(lambda data: data["artifacts"][0].update(blob_sha="0" * 40))
            result = detailed(f)
            self.assertEqual(result["diagnostics"], ["BLOB_MISMATCH"])
            self.assertEqual(result["diagnostic_details"][0]["stage"], "commit_manifest")

    def test_ci_self_registration_details_point_to_the_original_trusted_registry(self):
        with repository("INF", rows=[full_row("INF")]) as f:
            pending = full_row("INF", "0002", status="PENDING", activated_at=None)
            write(registry.REGISTRY, json.dumps({"schema_version": 1, "agents": [full_row("INF"), pending]}))
            f.primary = "AGT-INF-0002"
            f.footer = f"Agent-ID: {f.primary}\nTask-ID: {f.task}"
            f.body = "Fixture\n\n" + f.footer
            f.finish()
            run("update-ref", "HEAD", f.base)
            result = ci.report(event(f))
            self.assertEqual(result["diagnostics"], ["AGENT_UNREGISTERED"])
            self.assertEqual(result["diagnostic_details"][0]["stage"], "pr_declaration")
            self.assertFalse(result["enforcement_enabled"])

    def test_git_read_error_is_distinct_and_never_displays_raw_stderr(self):
        with repository() as f:
            f.finish()
            with patch.object(protocol, "required_blob", side_effect=subprocess.CalledProcessError(
                    1, ["PRIVATE-COMMAND"], stderr=b"PRIVATE-ERROR")):
                result = detailed(f)
            self.assertEqual(result["diagnostics"], ["GIT_READ_FAILED"])
            self.assertEqual(result["diagnostic_details"][0]["stage"], "registry")
            self.assertNotIn("PRIVATE-", json.dumps(result))

    def test_approved_real_registry_normal_case_in_temporary_repo_only(self):
        # Read source objects via alternates; write fixture commits only to a temp .git.
        previous = Path.cwd()
        source = Path(__file__).resolve().parents[2]
        source_objects = subprocess.check_output(["git", "-C", str(source), "rev-parse", "--git-path", "objects"]).decode().strip()
        source_objects = (source / source_objects).resolve().as_posix()
        with tempfile.TemporaryDirectory(prefix="metro-real-registry-audit-") as folder:
            try:
                os.chdir(folder)
                subprocess.run(["git", "init", "-q"], check=True)
                Path(".git/objects/info/alternates").write_text(source_objects + "\n", encoding="utf-8", newline="\n")
                for key, value in (("user.name", "Fixture"), ("user.email", "fixture@example.invalid"),
                                   ("core.autocrlf", "false")):
                    subprocess.run(["git", "config", key, value], check=True)
                run("read-tree", APPROVED_BASE)
                task, actor = "DEV-901", "AGT-DEV-0002"
                manifest = f"docs/engineering/tasks/{task}_PROVENANCE.json"
                title = f"[DEV][test] {task} Temporary approved-registry audit"
                write(f"docs/engineering/tasks/{task}_PLAN.md", "Synthetic task, no remote submission\n")
                write("docs/engineering/provenance/fixture.md", "Synthetic artifact\n")
                tree = run("write-tree").decode().strip()
                entries = [{"path": name, "change_type": "add", "agent_id": actor,
                            "contributors": [], "source_refs": ["LOCAL-SYNTHETIC-AUDIT"], "blob_sha": new}
                           for name, (_, _, new) in protocol.changes(APPROVED_BASE, tree).items()]
                write(manifest, json.dumps({"schema_version": 1, "task_id": task,
                      "primary_agent_id": actor, "base_sha": APPROVED_BASE, "artifacts": entries}))
                footer = f"Agent-ID: {actor}\nTask-ID: {task}"
                head = subprocess.check_output(["git", "commit-tree", run("write-tree").decode().strip(),
                       "-p", APPROVED_BASE], input=(title + "\n\nFixture.\n\n" + footer).encode()).decode().strip()
                run("update-ref", "HEAD", APPROVED_BASE)
                result = ci.report({"pull_request": {"base": {"sha": APPROVED_BASE},
                      "head": {"sha": head, "ref": "codex/DEV-901-fixture"}, "title": title,
                      "body": "Local fixture\n\n" + footer}})
                self.assertEqual(result["result"], "DECLARATION_CONSISTENT")
                self.assertEqual(result["diagnostic_details"], [])
                for key in ("identity_authenticated", "approval_authenticated", "enforcement_enabled"):
                    self.assertFalse(result[key])
            finally:
                os.chdir(previous)


if __name__ == "__main__":
    unittest.main()
