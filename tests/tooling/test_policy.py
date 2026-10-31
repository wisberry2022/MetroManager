"""Policy regressions, including staged/unstaged isolation; no project commits."""
import contextlib
import io
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "tools"))
import policy


class PolicyTests(unittest.TestCase):
    def test_branch(self):
        self.assertEqual(policy.branch_task("codex/DEV-002-repository-policy"), "DEV-002")
        for bad in ("main", "develop", "codex/no-ticket", "codex/DEV-002-UPPER", ""):
            with self.subTest(bad=bad), self.assertRaises(ValueError):
                policy.branch_task(bad)

    def test_message(self):
        policy.message_check("[DEV][fix] DEV-003 문제 수정\n\n영향과 검증입니다.", "DEV-003")
        for bad in ("free text", "[DEV][fix] DEV-003 제목만", "[DEV][fix] DEV-004 다른 티켓\n\n본문"):
            with self.subTest(bad=bad), self.assertRaises(ValueError):
                policy.message_check(bad, "DEV-003")

    def test_pr_title(self):
        policy.message_check("[DEV][ci] DEV-002 검사 추가", "DEV-002", title_only=True)

    def test_ticket(self):
        policy.ticket_check("DEV-002", ["tasks/DEV-002_REPOSITORY_POLICY.md"])
        with self.assertRaises(ValueError):
            policy.ticket_check("DEV-002", ["tasks/DEV-002_RESULT.md"])

    def test_text(self):
        for name, data in (("scripts/BadName.gd", b"extends Node\n"),
                           ("tools/a.py", b"x = 1 \n"),
                           ("tools/a.py", b"x = 1"),
                           (".githooks/pre-commit", b"#!/bin/sh\r\n")):
            with self.subTest(name=name, data=data), self.assertRaises(ValueError):
                policy.file_check(name, data)

    def test_push_rejects_protected_refs_and_deletion(self):
        for local, ref in (("a" * 40, "refs/heads/main"), ("a" * 40, "refs/tags/v1"),
                           ("0" * 40, "refs/heads/codex/DEV-002-policy")):
            with self.subTest(ref=ref), self.assertRaises(ValueError):
                policy.push_target(local, ref, "0" * 40)

    def test_push_checks_fast_forward(self):
        with patch.object(policy.subprocess, "run", side_effect=subprocess.CalledProcessError(1, "git")):
            with self.assertRaises(subprocess.CalledProcessError):
                policy.push_target("a" * 40, "refs/heads/codex/DEV-002-policy", "b" * 40)

    def test_new_work_branch(self):
        self.assertEqual(policy.push_target("a" * 40, "refs/heads/codex/DEV-002-policy", "0" * 40), "DEV-002")

    def test_staged_snapshot_cannot_hide_bad_gdscript(self):
        previous = Path.cwd()
        with tempfile.TemporaryDirectory() as directory:
            try:
                os.chdir(directory)
                subprocess.run(["git", "init", "-q"], check=True)
                Path("bad_script.gd").write_text("this is invalid gdscript\n", encoding="utf-8")
                subprocess.run(["git", "add", "bad_script.gd"], check=True)
                Path("bad_script.gd").write_text("extends Node\n", encoding="utf-8")
                with contextlib.redirect_stdout(io.StringIO()):
                    policy.check("worktree")
                with self.assertRaises(subprocess.CalledProcessError):
                    policy.check("staged")
            finally:
                os.chdir(previous)


if __name__ == "__main__":
    unittest.main()
