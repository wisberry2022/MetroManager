"""Automated PR creation against a fake API only; no real IDs or network writes."""

from copy import deepcopy
from contextlib import redirect_stdout
import io
import json
import os
from pathlib import Path
import subprocess
import sys
import unittest
from unittest.mock import patch
from urllib.error import HTTPError

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "tools"))
import agent_registration_pr as writer
import agent_registry as registry
import agent_provenance as protocol
from test_agent_registry_reporting import full_row
from test_agent_provenance import repository, run, write, commit


class FakeGitHub:
    def __init__(self, base, main_reads=None, pending=False, fail_ref=False, fail_pr=False):
        self.base = base
        self.main_reads = list(main_reads or [base, base, base])
        self.calls = []
        self.pending, self.fail_ref, self.fail_pr = pending, fail_ref, fail_pr

    def request(self, method, path, data=None):
        self.calls.append((method, path, data))
        if path == "git/ref/heads/main":
            return {"object": {"sha": self.main_reads.pop(0)}}
        if path.startswith("pulls?state=open"):
            return [{"number": 1}] if self.pending else []
        if path.startswith("pulls/1/files"):
            return [{"filename": registry.REGISTRY}]
        if path == f"git/commits/{self.base}" and method == "GET":
            return {"tree": {"sha": "c" * 40}}
        if path == "git/trees":
            return {"sha": "a" * 40}
        if path == "git/commits":
            return {"sha": "b" * 40}
        if path == "git/refs":
            if self.fail_ref:
                raise writer.SubmissionError("API_REQUEST_FAILED")
            return {"ref": data["ref"], "object": {"sha": data["sha"]}}
        if path == "pulls":
            if self.fail_pr:
                raise writer.SubmissionError("API_REQUEST_FAILED")
            return {"number": 71}
        raise AssertionError((method, path))


def workflow():
    return patch.dict(os.environ, {"GITHUB_ACTIONS": "true", "GITHUB_WORKFLOW_REF": writer.WORKFLOW,
                                  "GITHUB_REF": "refs/heads/main"})


def prepare(f):
    run("update-ref", "refs/remotes/origin/main", f.base)
    run("update-ref", "HEAD", f.base)
    return writer.prepare(f.base, "INF-902", "INF", "Successor fixture", "NEW-SCOPE",
                          "AGT-INF-0001", "SYNTHETIC-CANDIDATE", "TEST-HANDOFF",
                          "SYNTHETIC-GIT-APPROVAL", "AGT-INF-0001")


class RegistrationPRTests(unittest.TestCase):
    def test_cli_default_prepare_and_submit_context_guard_do_not_open_network(self):
        with repository("INF", rows=[full_row("INF")]) as f:
            prepare(f)
            arguments = ["agent_registration_pr.py", "--base", f.base, "--task", "INF-902",
                         "--department", "INF", "--role", "Fixture", "--scope", "NEW",
                         "--predecessor", "AGT-INF-0001", "--candidate-ref", "TEST-CANDIDATE",
                         "--handoff-ref", "TEST-HANDOFF", "--git-approval-ref", "TEST-GIT"]
            with patch.object(sys, "argv", arguments), patch.object(writer, "GitHub") as client:
                output = io.StringIO()
                with redirect_stdout(output):
                    self.assertEqual(writer.main(), 0)
                client.assert_not_called()
                self.assertEqual(json.loads(output.getvalue())["mode"], "PREPARED_PR")
            with patch.object(sys, "argv", arguments + ["--submit"]), patch.object(writer, "GitHub") as client:
                with patch.dict(os.environ, {"GITHUB_ACTIONS": "false"}), redirect_stdout(io.StringIO()):
                    self.assertEqual(writer.main(), 1)
                client.assert_not_called()

    def test_prepare_is_read_only_and_outputs_pending_pipeline(self):
        with repository("INF", rows=[full_row("INF")]) as f:
            run("update-ref", "refs/remotes/origin/main", f.base)
            run("update-ref", "HEAD", f.base)
            before = run("status", "--porcelain"), run("for-each-ref"), run("write-tree")
            plan = prepare(f)
            self.assertEqual(before, (run("status", "--porcelain"), run("for-each-ref"), run("write-tree")))
            self.assertEqual(plan["review_sequence"], writer.STEPS)
            self.assertFalse(plan["remote_write_performed"])
            item = json.loads(plan["files"][registry.REGISTRY])["agents"][-1]
            self.assertEqual((item["status"], item["activated_at"]), ("PENDING", None))
            writer.validate_plan(plan)

    def test_automated_pr_api_only_creates_branch_draft_and_valid_single_parent(self):
        with repository("INF", rows=[full_row("INF")]) as f, workflow():
            plan = prepare(f)
            api = FakeGitHub(f.base)
            result = writer.publish(api, plan)
            self.assertEqual(result["result"], "PENDING_PR_CREATED")
            self.assertFalse(result["reserved"])
            self.assertFalse(result["enforcement_enabled"])
            writes = [(path, data) for method, path, data in api.calls if method != "GET"]
            self.assertEqual([path for path, _ in writes], ["git/trees", "git/commits", "git/refs", "pulls"])
            tree = writes[0][1]
            self.assertEqual(tree["base_tree"], "c" * 40)
            self.assertEqual(set(item["path"] for item in tree["tree"]), set(plan["files"]))
            self.assertEqual(writes[1][1]["parents"], [f.base])
            self.assertEqual(writes[2][1]["ref"], "refs/heads/codex/INF-902-agent-registration")
            self.assertTrue(writes[3][1]["draft"])
            self.assertEqual(writes[3][1]["base"], "main")
            run("read-tree", f.base)
            for item in tree["tree"]:
                write(item["path"], item["content"])
            head = commit(f.base, writes[1][1]["message"])
            protocol.gate.range_check(f.base, head, "INF-902")

    def test_unauthorized_context_and_wrong_checkout_make_zero_api_calls(self):
        with repository("INF", rows=[full_row("INF")]) as f:
            plan = prepare(f)
            api = FakeGitHub(f.base)
            with patch.dict(os.environ, {"GITHUB_ACTIONS": "false"}):
                with self.assertRaisesRegex(protocol.Invalid, "AUTHORIZED_MAIN_WORKFLOW_REQUIRED"):
                    writer.publish(api, plan)
            self.assertEqual(api.calls, [])
            write("docs/infra/changed.md", "Fixture\n")
            head = commit(f.base, "Synthetic checkout advance")
            run("update-ref", "HEAD", head)
            with workflow(), self.assertRaisesRegex(protocol.Invalid, "TRUSTED_BASE_CHECKOUT_REQUIRED"):
                writer.publish(api, plan)
            self.assertEqual(api.calls, [])

    def test_stale_main_and_open_registration_stop_before_live_ref_or_pr(self):
        with repository("INF", rows=[full_row("INF")]) as f, workflow():
            plan = prepare(f)
            cases = [(FakeGitHub(f.base, ["d" * 40]), "PROPOSAL_STALE_BASE"),
                     (FakeGitHub(f.base, [f.base, "d" * 40]), "PROPOSAL_STALE_BASE"),
                     (FakeGitHub(f.base, pending=True), "REGISTRATION_PR_IN_PROGRESS")]
            for api, code in cases:
                with self.subTest(code=code), self.assertRaisesRegex(ValueError, code):
                    writer.publish(api, plan)
                self.assertFalse(any(method != "GET" and path in {"git/refs", "pulls"}
                                     for method, path, _ in api.calls))

    def test_partial_failure_never_force_updates_deletes_or_merges(self):
        with repository("INF", rows=[full_row("INF")]) as f, workflow():
            plan = prepare(f)
            cases = [FakeGitHub(f.base, fail_ref=True), FakeGitHub(f.base, fail_pr=True),
                     FakeGitHub(f.base, [f.base, f.base, "d" * 40])]
            for api in cases:
                with self.subTest(api=api), self.assertRaises(ValueError):
                    writer.publish(api, plan)
                self.assertFalse(any(method in {"PATCH", "PUT", "DELETE"} for method, _, _ in api.calls))
                self.assertFalse(any("merge" in path or (data and data.get("force"))
                                     for _, path, data in api.calls))

    def test_plan_tampering_cannot_write_other_paths_or_activate(self):
        with repository("INF", rows=[full_row("INF")]) as f, workflow():
            original = prepare(f)
            extra = deepcopy(original)
            extra["files"]["scripts/main.gd"] = "No permission\n"
            active = deepcopy(original)
            data = json.loads(active["files"][registry.REGISTRY])
            data["agents"][-1].update(status="ACTIVE", activated_at="2026-11-02T12:00:00+09:00")
            active["files"][registry.REGISTRY] = json.dumps(data)
            for plan in (extra, active):
                api = FakeGitHub(f.base)
                with self.assertRaises(protocol.Invalid):
                    writer.publish(api, plan)
                self.assertEqual(api.calls, [])

    def test_paginated_scan_and_scan_limits_fail_closed(self):
        class Paged:
            def request(self, method, path, data=None):
                if path.startswith("pulls?state=open"):
                    return [{"number": 1}]
                if path.endswith("&page=1"):
                    return [{"filename": f"docs/infra/{i}.md"} for i in range(100)]
                return [{"filename": registry.REGISTRY}]
        with self.assertRaisesRegex(writer.SubmissionError, "REGISTRATION_PR_IN_PROGRESS"):
            writer.no_pending_registration(Paged())
        class Endless:
            def request(self, method, path, data=None):
                return [{}] * 100
        with self.assertRaisesRegex(writer.SubmissionError, "REGISTRATION_SCAN_LIMIT"):
            list(writer.pages(Endless(), "pulls?state=open", 1))

    def test_api_errors_and_redirects_never_leak_tokens_or_raw_responses(self):
        client = writer.GitHub("PRIVATE-FAKE-TOKEN")
        with patch.object(client.opener, "open", side_effect=HTTPError("PRIVATE-URL", 403, "PRIVATE-BODY", {}, None)):
            with self.assertRaisesRegex(writer.SubmissionError, "^API_REQUEST_FAILED$"):
                client.request("GET", "git/ref/heads/main")
        with self.assertRaisesRegex(writer.SubmissionError, "API_REDIRECT_REFUSED"):
            writer.NoRedirect().redirect_request(None, None, 302, "", {}, "https://example.invalid")

    def test_workflow_is_manual_main_only_serialized_and_uses_dedicated_token(self):
        import yaml
        root = Path(__file__).resolve().parents[2]
        value = yaml.safe_load((root / ".github/workflows/agent-registration-proposal.yml").read_text())
        triggers = value.get("on", value.get(True))
        self.assertEqual(set(triggers), {"workflow_dispatch"})
        self.assertEqual(value["concurrency"], {"group": "agent-registration-single-writer", "cancel-in-progress": False})
        self.assertEqual(value["permissions"], {"contents": "read"})
        job = value["jobs"]["propose"]
        self.assertEqual(job["if"], "github.ref == 'refs/heads/main'")
        self.assertFalse(job["steps"][0]["with"]["persist-credentials"])
        step = job["steps"][-1]
        self.assertEqual(step["env"]["AGENT_REGISTRATION_TOKEN"], "${{ secrets.AGENT_REGISTRATION_TOKEN }}")
        self.assertNotIn("${{", step["run"])
        self.assertNotIn("GITHUB_TOKEN", json.dumps(value))


if __name__ == "__main__":
    unittest.main()
