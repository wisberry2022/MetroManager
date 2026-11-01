"""Shared error reports keep department tickets, paths, and linear history gates."""

from contextlib import contextmanager
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

REPORT = "docs/co-work/err-report/ERR-20261101-001_PR35_BRANCH_UPDATE.md"
INDEX = "docs/co-work/err-report/README.md"


@contextmanager
def repository():
    previous = Path.cwd()
    with tempfile.TemporaryDirectory() as folder:
        try:
            os.chdir(folder)
            subprocess.run(["git", "init", "-q"], check=True)
            subprocess.run(["git", "config", "core.autocrlf", "false"], check=True)
            yield
        finally:
            os.chdir(previous)


def write(name, content="Report\n"):
    path = Path(name)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8", newline="\n")
    subprocess.run(["git", "add", "--", name], check=True)


def commit(message, *parents):
    tree = gate.git("write-tree").decode().strip()
    args = ["git", "-c", "user.name=Policy Test", "-c", "user.email=test@example.invalid",
            "commit-tree", tree]
    for parent in parents:
        args += ["-p", parent]
    return subprocess.check_output(args, input=message.encode()).decode().strip()


class SharedReportTests(unittest.TestCase):
    def test_all_departments_only_share_report_markdown_and_index(self):
        for prefix in gate.DEPARTMENTS:
            task = prefix + "-101"
            with self.subTest(task=task):
                gate.path_check(task, [REPORT, INDEX,
                                      "docs/co-work/err-report/ERR-20261101-002_한글_증상.md"])
            for name in ("docs/co-work/README.md", "docs/co-work/err-reporting/README.md",
                         "docs/co-work/err-report/sub/README.md",
                         "docs/co-work/err-report/tool.py", "docs/co-work/err-report/notes.md",
                         "docs/co-work/err-report/ERR-20261101-001_.md",
                         "docs/co-work/err-report/ERR-20261101-001_bad.md.py",
                         "docs/co-work/err-report/../planning/brief.md",
                         "/docs/co-work/err-report/README.md",
                         "docs/co-work/err-report\\README.md"):
                with self.subTest(task=task, name=name), self.assertRaises(ValueError):
                    gate.path_check(task, [name])

    def test_shared_reports_do_not_replace_own_department_ticket(self):
        for prefix, (_, root) in gate.DEPARTMENTS.items():
            task = prefix + "-101"
            for names in ([REPORT, INDEX], [f"docs/co-work/err-report/tasks/{task}_REPORT.md"],
                          [f"{root}tasks/{task}_RESULT.md"],
                          [f"{root}tasks/{prefix}-102_REPORT.md"]):
                with self.subTest(task=task, names=names), self.assertRaises(ValueError):
                    gate.ticket_check(task, names)
            gate.ticket_check(task, [REPORT, f"{root}tasks/{task}_REPORT.md"])

    def test_existing_cross_department_and_policy_boundaries_remain(self):
        for prefix, (_, root) in gate.DEPARTMENTS.items():
            task = prefix + "-101"
            forbidden = [other_root + "private.md" for _, other_root in gate.DEPARTMENTS.values()
                         if other_root != root]
            if prefix != "DEV":
                forbidden += ["tools/department_policy.py", "AGENTS.md", "project.godot",
                              ".github/workflows/department-policy.yml",
                              "docs/governance/path_exceptions.json"]
            for name in forbidden:
                with self.subTest(task=task, name=name), self.assertRaises(ValueError):
                    gate.path_check(task, [REPORT, name])

    def test_shared_symlinks_and_submodules_still_rejected(self):
        for mode in ("120000", "160000"):
            with patch.object(gate, "git", return_value=f"{mode} blob abc\t{REPORT}\0".encode()):
                with self.subTest(mode=mode), self.assertRaises(ValueError):
                    gate.modes_check("HEAD", [REPORT])

    def test_all_department_report_prs_pass_both_ci_entry_points(self):
        for prefix, (department, root) in gate.DEPARTMENTS.items():
            with self.subTest(department=department), repository():
                write("seed.md")
                base = commit("Historical seed")
                task = prefix + "-101"
                write(f"{root}tasks/{task}_REPORT.md")
                write(REPORT)
                write(INDEX)
                title = f"[{department}][docs] {task} 오류 보고"
                head = commit(title + "\n\n공용 오류 보고와 검증을 기록합니다.", base)
                event = {"pull_request": {"title": title, "base": {"sha": base},
                         "head": {"sha": head, "ref": f"codex/{task}-error-report"}}}
                Path("event.json").write_text(json.dumps(event) + "\n", encoding="utf-8")
                with patch.dict(os.environ, {"GITHUB_EVENT_PATH": str(Path("event.json").resolve())}):
                    gate.main()
                    with patch.object(sys, "argv", ["policy.py", "ci"]):
                        policy.main()
                write("docs/co-work/err-report/escape.py")
                bad = commit(title + "\n\n비문서 파일 거부 검증", head)
                with self.assertRaises(ValueError):
                    gate.range_check(base, bad, task)
                subprocess.run(["git", "rm", "--cached", "docs/co-work/err-report/escape.py"],
                               check=True, capture_output=True)
                restored = commit(title + "\n\n복구 후에도 중간 위반 거부", bad)
                with self.assertRaises(ValueError):
                    gate.range_check(base, restored, task)

    def test_report_changes_keep_staged_path_gate(self):
        with repository():
            write("seed.md")
            base = commit("Historical seed")
            subprocess.run(["git", "update-ref", "HEAD", base], check=True)
            subprocess.run(["git", "update-ref", "refs/remotes/origin/main", base], check=True)
            write("docs/planning/tasks/PLN-101_REPORT.md")
            write(REPORT)
            gate.staged_check("PLN-101")
            write("docs/infra/other.md")
            with self.assertRaises(ValueError):
                gate.staged_check("PLN-101")

    def test_merge_commit_keeps_rejection_and_provides_recovery_guidance(self):
        with repository():
            write("seed.md")
            base = commit("Historical seed")
            write("docs/planning/tasks/PLN-101_REPORT.md")
            write(REPORT)
            title = "[기획][docs] PLN-101 오류 보고"
            head = commit(title + "\n\n정상 제출", base)
            other = commit("Other base change", base)
            merged = commit(title + "\n\n잘못된 merge", head, other)
            with self.assertRaisesRegex(ValueError, "Expected single-parent work commit.*replacement PR"):
                gate.range_check(base, merged, "PLN-101")


if __name__ == "__main__":
    unittest.main()
