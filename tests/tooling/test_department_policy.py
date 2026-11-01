"""Boundary regressions, including API-style Git object commits (no hooks)."""

import datetime
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "tools"))
import department_policy as gate
import policy


class DepartmentTests(unittest.TestCase):
    def test_all_department_headers(self):
        for prefix, (name, _) in gate.DEPARTMENTS.items():
            task = prefix + "-101"
            gate.message_check(f"[{name}][docs] {task} 보고서\n\n검토 결과를 기록했습니다.", task)
            with self.assertRaises(ValueError):
                gate.message_check(f"[OTHER][docs] {task} 보고서\n\n본문", task)

    def test_department_cannot_impersonate_other_task(self):
        with self.assertRaises(ValueError):
            gate.message_check("[DEV][docs] PLN-101 설명\n\n본문", "PLN-101")

    def test_own_paths_and_tickets(self):
        for prefix, (_, root) in gate.DEPARTMENTS.items():
            task = prefix + "-101"
            gate.path_check(task, [root + "brief.md", root + "tasks/" + task + "_BRIEF.md"])
            gate.ticket_check(task, [root + "tasks/" + task + "_BRIEF.md"])

    def test_non_dev_denied_source_policy_and_other_department(self):
        for task in ("PM-101", "PLN-101", "DSG-101", "INF-101"):
            for name in ("project.godot", "scripts/game.gd", "tools/policy.py", "AGENTS.md",
                         ".github/workflows/policy.yml", "docs/governance/path_exceptions.json",
                         "docs/engineering/notes.md", "tasks/DEV-001_RESULT.md"):
                with self.subTest(task=task, name=name), self.assertRaises(ValueError):
                    gate.path_check(task, [name])

    def test_dev_cannot_edit_other_department_artifact(self):
        for name in ("docs/planning/economy.md", "docs/infra/README.md",
                     "docs/infra/continuity.md"):
            with self.subTest(name=name), self.assertRaises(ValueError):
                gate.path_check("DEV-003", [name])

    def test_inf_ticket_and_signature_boundaries(self):
        self.assertEqual(gate.branch_task("codex/INF-101-session-handoff"), "INF-101")
        gate.message_check("[INF][docs] INF-101 인계 규칙", "INF-101", title_only=True)
        for names in ([], ["docs/infra/tasks/INF-101_RESULT.md"],
                      ["docs/infra/tasks/INF-102_POLICY.md"],
                      ["docs/engineering/tasks/INF-101_POLICY.md"]):
            with self.subTest(names=names), self.assertRaises(ValueError):
                gate.ticket_check("INF-101", names)
        for message in ("[DEV][docs] INF-101 인계\n\n본문",
                        "[INF][docs] DEV-101 인계\n\n본문",
                        "[INF][docs] INF-102 인계\n\n본문",
                        "[INF][docs] INF-101 인계"):
            with self.subTest(message=message), self.assertRaises(ValueError):
                gate.message_check(message, "INF-101")

    def test_inf_denied_other_departments_and_path_escape(self):
        for name in ("docs/hq/brief.md", "docs/planning/brief.md", "docs/design/brief.md",
                     "docs/infra/../hq/brief.md", "docs/infrastructure/brief.md",
                     "/docs/infra/brief.md", "docs/infra\\brief.md",
                     ".github/CODEOWNERS"):
            with self.subTest(name=name), self.assertRaises(ValueError):
                gate.path_check("INF-101", [name])

    def test_rename_checks_old_and_new_path(self):
        with self.assertRaises(ValueError):
            gate.path_check("PM-101", ["scripts/game.gd", "docs/hq/game.gd"])

    def test_path_escape(self):
        for name in ("docs/hq/../../scripts/a.gd", "/docs/hq/file.md", "docs/hq\\file.md"):
            with self.assertRaises(ValueError):
                gate.path_check("PM-101", [name])

    def test_scoped_exception_expiry(self):
        grants = {"PM-101": {"decision": "DEC-TEST", "reason": "Approved migration",
                             "expires": "2026-11-01", "paths": ["README.md"]}}
        gate.path_check("PM-101", ["README.md"], grants, datetime.date(2026, 10, 31))
        with self.assertRaises(ValueError):
            gate.path_check("PM-101", ["README.md"], grants, datetime.date(2026, 11, 2))
        with self.assertRaises(ValueError):
            gate.path_check("PM-101", ["project.godot"], grants, datetime.date(2026, 10, 31))

    def test_symlink_rejected(self):
        with patch.object(gate, "git", return_value=b"120000 blob abc\tdocs/hq/link\0"):
            with self.assertRaises(ValueError):
                gate.modes_check("HEAD", ["docs/hq/link"])

    def test_inf_pr_runs_both_ci_entry_points(self):
        previous = Path.cwd()
        with tempfile.TemporaryDirectory() as folder:
            try:
                os.chdir(folder)
                subprocess.run(["git", "init", "-q"], check=True)

                def commit(parent, message):
                    tree = gate.git("write-tree").decode().strip()
                    args = ["git", "-c", "user.name=Policy Test",
                            "-c", "user.email=test@example.invalid", "commit-tree", tree]
                    if parent:
                        args += ["-p", parent]
                    return subprocess.check_output(args, input=message.encode()).decode().strip()

                Path("seed.md").write_text("base\n", encoding="utf-8")
                subprocess.run(["git", "add", "seed.md"], check=True)
                base = commit(None, "Historical seed")
                Path("docs/infra/tasks").mkdir(parents=True)
                Path("docs/infra/tasks/INF-101_HANDOFF.md").write_text("Ticket\n", encoding="utf-8")
                Path("docs/infra/README.md").write_text("Infra\n", encoding="utf-8")
                subprocess.run(["git", "add", "docs"], check=True)
                title = "[INF][docs] INF-101 인계 규칙"
                head = commit(base, title + "\n\n인계 범위와 검증을 기록합니다.")
                event = {"pull_request": {"title": title, "base": {"sha": base},
                         "head": {"sha": head, "ref": "codex/INF-101-handoff"}}}
                Path("event.json").write_text(json.dumps(event) + "\n", encoding="utf-8")
                with patch.dict(os.environ, {"GITHUB_EVENT_PATH": str(Path("event.json").resolve())}):
                    gate.main()
                    with patch.object(sys, "argv", ["policy.py", "ci"]):
                        policy.main()
                    event["pull_request"]["head"]["ref"] = "main"
                    Path("event.json").write_text(json.dumps(event) + "\n", encoding="utf-8")
                    with self.assertRaises(ValueError):
                        gate.main()
                    with patch.object(sys, "argv", ["policy.py", "ci"]):
                        with self.assertRaises(ValueError):
                            policy.main()
                Path("docs/hq").mkdir()
                Path("docs/hq/brief.md").write_text("Forbidden\n", encoding="utf-8")
                subprocess.run(["git", "add", "docs"], check=True)
                bad = commit(head, title + "\n\n타 부서 변경 거부 검증")
                with self.assertRaises(ValueError):
                    gate.range_check(base, bad, "INF-101")
            finally:
                os.chdir(previous)

    def test_api_commits_and_self_granted_exception(self):
        previous = Path.cwd()
        with tempfile.TemporaryDirectory() as folder:
            try:
                os.chdir(folder)
                subprocess.run(["git", "init", "-q"], check=True)
                # Commit-tree models GitHub Git Data API; no client hooks run.
                def commit(parent, message):
                    tree = gate.git("write-tree").decode().strip()
                    args = ["git", "-c", "user.name=Policy Test", "-c", "user.email=test@example.invalid",
                            "commit-tree", tree]
                    if parent:
                        args += ["-p", parent]
                    return subprocess.check_output(args, input=message.encode()).decode().strip()

                Path("seed.txt").write_text("base\n")
                subprocess.run(["git", "add", "seed.txt"], check=True)
                base = commit(None, "Historical seed")
                Path("docs/hq/tasks").mkdir(parents=True)
                Path("docs/hq/tasks/PM-101_REPORT.md").write_text("Ticket\n")
                subprocess.run(["git", "add", "docs"], check=True)
                good = commit(base, "[HQ][docs] PM-101 보고서\n\n검증했습니다.")
                gate.range_check(base, good, "PM-101")
                Path("project.godot").write_text("unauthorized\n")
                Path("docs/governance").mkdir()
                Path("docs/governance/path_exceptions.json").write_text(
                    '{"PM-101":{"decision":"fake","reason":"self","expires":"2099-01-01",'
                    '"paths":["project.godot","docs/governance/path_exceptions.json"]}}')
                subprocess.run(["git", "add", "."], check=True)
                bad = commit(good, "[HQ][docs] PM-101 임의 소스 변경\n\n본문")
                with self.assertRaises(ValueError):
                    gate.range_check(base, bad, "PM-101")
                # Even restoring the source in a later commit does not erase the violation.
                subprocess.run(["git", "rm", "--cached", "project.godot",
                                "docs/governance/path_exceptions.json"], check=True, capture_output=True)
                restored = commit(bad, "[HQ][revert] PM-101 복구\n\n본문")
                with self.assertRaises(ValueError):
                    gate.range_check(base, restored, "PM-101")
            finally:
                os.chdir(previous)


if __name__ == "__main__":
    unittest.main()
