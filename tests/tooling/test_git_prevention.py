"""Real isolated merge hooks and committed-head submission checks; no project writes."""

from contextlib import contextmanager
import io
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "tools"))
import department_policy as gate
import policy

PROJECT = Path(__file__).resolve().parents[2]


@contextmanager
def repository():
    previous = Path.cwd()
    with tempfile.TemporaryDirectory(prefix="metro-prevention-") as folder:
        try:
            os.chdir(folder)
            subprocess.run(["git", "init", "-q"], check=True)
            subprocess.run(["git", "config", "core.autocrlf", "false"], check=True)
            subprocess.run(["git", "config", "user.name", "Policy Test"], check=True)
            subprocess.run(["git", "config", "user.email", "test@example.invalid"], check=True)
            yield
        finally:
            os.chdir(previous)


def write(name, text="Test\n"):
    path = Path(name)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8", newline="\n")
    subprocess.run(["git", "add", "--", name], check=True)


def commit(message, *parents):
    tree = gate.git("write-tree").decode().strip()
    args = ["git", "commit-tree", tree]
    for parent in parents:
        args += ["-p", parent]
    return subprocess.check_output(args, input=message.encode()).decode().strip()


def ref(name, sha):
    subprocess.run(["git", "update-ref", name, sha], check=True)


def submission(prefix="PLN"):
    name, root = gate.DEPARTMENTS[prefix]
    task = prefix + "-101"
    write("seed.md")
    base = commit("Historical base")
    ref("refs/remotes/origin/main", base)
    write(f"{root}tasks/{task}_PLAN.md")
    head = commit(f"[{name}][docs] {task} Report\n\nValidation.", base)
    branch = f"refs/heads/codex/{task}-report"
    ref(branch, head)
    subprocess.run(["git", "symbolic-ref", "HEAD", branch], check=True)
    return base, head, task


class GitPreventionTests(unittest.TestCase):
    def test_preflight_all_departments_is_read_only(self):
        for prefix in gate.DEPARTMENTS:
            with self.subTest(prefix=prefix), repository():
                submission(prefix)
                before = (gate.git("show-ref"), gate.git("status", "--porcelain"))
                policy.preflight()
                self.assertEqual(before, (gate.git("show-ref"), gate.git("status", "--porcelain")))

    def test_stale_base_rejected_before_push_without_modifying_history(self):
        with repository():
            base, head, task = submission()
            other = commit("New main", base)
            ref("refs/remotes/origin/main", other)
            before = gate.git("show-ref")
            with self.assertRaisesRegex(ValueError, "fetched origin/main"):
                policy.preflight()
            line = f"refs/heads/codex/{task}-report {head} refs/heads/codex/{task}-report {'0' * 40}\n"
            with patch.object(sys, "stdin", io.StringIO(line)):
                with self.assertRaisesRegex(ValueError, "replacement PR"):
                    policy.pre_push()
            self.assertEqual(before, gate.git("show-ref"))

    def test_current_merge_head_still_rejected_by_submission_history(self):
        with repository():
            base, head, task = submission()
            other = commit("Main change", base)
            merged = commit("[기획][docs] PLN-101 Merge\n\nInvalid merge.", head, other)
            ref("refs/remotes/origin/main", other)
            with self.assertRaisesRegex(ValueError, "Expected single-parent work commit"):
                policy.submission_check(other, merged, task)

    def test_pending_merge_rejected_at_both_manual_commit_gates(self):
        with repository():
            _, head, _ = submission()
            Path(".git/MERGE_HEAD").write_text(head + "\n", encoding="utf-8")
            for command in ("pre-commit", "commit-msg", "preflight", "pre-merge-commit"):
                with self.subTest(command=command), patch.object(sys, "argv", ["policy.py", command]):
                    with self.assertRaisesRegex(ValueError, "Merge commits are forbidden"):
                        policy.main()

    def test_preflight_keeps_branch_ticket_and_department_gates(self):
        with repository():
            base, head, task = submission()
            with self.assertRaises(ValueError):
                policy.submission_check(base, head, "INF-101")
            subprocess.run(["git", "symbolic-ref", "HEAD", "refs/heads/main"], check=True)
            ref("refs/heads/main", head)
            with self.assertRaisesRegex(ValueError, "Invalid work branch"):
                policy.preflight()

    def test_real_merge_and_manual_commit_do_not_create_merge_commit(self):
        with repository():
            base, head, _ = submission()
            # Build a separate main tree so the real merge is non-fast-forward and conflict-free.
            subprocess.run(["git", "read-tree", base], check=True)
            write("main_only.md")
            main = commit("Main advancement", base)
            ref("refs/heads/main", main)
            subprocess.run(["git", "read-tree", head], check=True)
            Path("main_only.md").unlink()
            Path("tools").mkdir()
            for name in ("policy.py", "department_policy.py"):
                shutil.copyfile(PROJECT / "tools" / name, Path("tools") / name)
            Path(".githooks").mkdir()
            for name in ("pre-merge-commit", "pre-commit"):
                target = Path(".githooks") / name
                shutil.copyfile(PROJECT / ".githooks" / name, target)
                target.chmod(target.stat().st_mode | 0o111)
            subprocess.run([sys.executable, "-m", "venv", "--without-pip", ".venv"], check=True)
            subprocess.run(["git", "config", "core.hooksPath", ".githooks"], check=True)
            result = subprocess.run(["git", "merge", "--no-edit", "main"], capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("Merge commits are forbidden", result.stdout + result.stderr)
            self.assertEqual(gate.git("rev-parse", "HEAD").decode().strip(), head)
            self.assertTrue(Path(".git/MERGE_HEAD").is_file())
            result = subprocess.run(["git", "commit", "-m", "Manual merge"], capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("Merge commits are forbidden", result.stdout + result.stderr)
            self.assertEqual(gate.git("rev-parse", "HEAD").decode().strip(), head)

    def test_installer_preserves_existing_custom_merge_hook(self):
        with repository():
            Path("tools").mkdir()
            shutil.copyfile(PROJECT / "tools/install_hooks.py", "tools/install_hooks.py")
            hook = Path(".git/hooks/pre-merge-commit")
            hook.write_text("Custom hook\n", encoding="utf-8")
            result = subprocess.run([sys.executable, "tools/install_hooks.py"], capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("preserve", result.stdout + result.stderr)
            self.assertEqual(hook.read_text(encoding="utf-8"), "Custom hook\n")


if __name__ == "__main__":
    unittest.main()
