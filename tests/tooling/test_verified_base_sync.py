"""Verify base-only merge trees without granting merge commits general permission."""

from contextlib import contextmanager
import io
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


def write(path, content="fixture\n"):
    target = Path(path)
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(content, encoding="utf-8", newline="\n")
    subprocess.run(["git", "add", "--", path], check=True)


def commit(message, *parents):
    tree = gate.git("write-tree").decode().strip()
    args = ["git", "commit-tree", tree]
    for parent in parents:
        args += ["-p", parent]
    return subprocess.check_output(args, input=message.encode()).decode().strip()


def index(ref):
    subprocess.run(["git", "read-tree", ref], check=True)


class Fixture:
    def __init__(self, prefix, conflict=False, driver=False):
        self.task = prefix + "-901"
        self.root = gate.department(self.task)[1]
        self.branch = f"codex/{self.task}-fixture"
        self.title = f"[{gate.department(self.task)[0]}][docs] {self.task} Fixture"
        self.message = self.title + "\n\nValidation."
        self.shared = self.root + "shared.md"
        write(self.shared, "first\nkeep\nlast\n")
        if driver:
            write(".gitattributes", "*.md merge=probe\n")
        self.base = commit("Historical base")
        write(self.root + f"tasks/{self.task}_PLAN.md")
        if conflict or driver:
            write(self.shared, "work\nkeep\nlast\n")
        self.work = commit(self.message, self.base)
        index(self.base)
        write("docs/design/main-only.md", "Trusted main content\n")
        if conflict or driver:
            write(self.shared, "main\nkeep\nlast\n" if conflict else "first\nkeep\nmain\n")
        self.main = commit("Trusted main advancement", self.base)
        index(self.work)
        write("docs/design/main-only.md", "Trusted main content\n")
        if conflict:
            write(self.shared, "Manual resolution\n")
        elif driver:
            write(self.shared, "work\nkeep\nmain\n")
        self.synced = commit("Merge branch 'main' into fixture", self.work, self.main)
        subprocess.run(["git", "update-ref", "refs/remotes/origin/main", self.main], check=True)
        subprocess.run(["git", "symbolic-ref", "HEAD", "refs/heads/" + self.branch], check=True)
        subprocess.run(["git", "update-ref", "HEAD", self.synced], check=True)


@contextmanager
def repository(prefix="PLN", **kwargs):
    previous = Path.cwd()
    with tempfile.TemporaryDirectory(prefix="metro-sync-test-") as folder:
        try:
            os.chdir(folder)
            subprocess.run(["git", "init", "-q"], check=True)
            for key, value in (("core.autocrlf", "false"), ("user.name", "Fixture"),
                               ("user.email", "fixture@example.invalid")):
                subprocess.run(["git", "config", key, value], check=True)
            yield Fixture(prefix, **kwargs)
        finally:
            os.chdir(previous)


class VerifiedBaseSyncTests(unittest.TestCase):
    def test_all_departments_clean_update_passes_both_ci_and_preflight(self):
        for prefix in gate.DEPARTMENTS:
            with self.subTest(prefix=prefix), repository(prefix) as f:
                before = gate.git("for-each-ref"), gate.git("status", "--porcelain")
                event = {"pull_request": {"title": f.title, "base": {"sha": f.main},
                         "head": {"sha": f.synced, "ref": f.branch}}}
                # Event data is outside the checkout snapshot.
                with tempfile.TemporaryDirectory() as folder:
                    event_file = Path(folder) / "event.json"
                    event_file.write_text(json.dumps(event) + "\n", encoding="utf-8")
                    with patch.dict(os.environ, {"GITHUB_EVENT_PATH": str(event_file)}):
                        gate.main()
                        with patch.object(sys, "argv", ["policy.py", "ci"]):
                            policy.main()
                policy.preflight()
                line = f"refs/heads/{f.branch} {f.synced} refs/heads/{f.branch} {f.work}\n"
                with patch.object(sys, "stdin", io.StringIO(line)):
                    policy.pre_push()
                self.assertEqual(before, (gate.git("for-each-ref"), gate.git("status", "--porcelain")))

    def test_untrusted_parent_reversed_parents_and_octopus_fail(self):
        with repository() as f:
            with self.assertRaises(ValueError):
                gate.range_check(f.base, f.synced, f.task)
            reversed_merge = commit("Reverse merge", f.main, f.work)
            with self.assertRaises(ValueError):
                gate.range_check(f.main, reversed_merge, f.task)
            third = commit("Untrusted side", f.base)
            octopus = commit("Octopus", f.work, f.main, third)
            with self.assertRaises(ValueError):
                gate.range_check(f.main, octopus, f.task)

    def test_extra_own_or_other_department_edits_in_merge_fail(self):
        with repository() as f:
            for path in (f.root + "extra.md", "docs/infra/extra.md"):
                index(f.synced)
                write(path, "Hidden edit in merge\n")
                forged = commit("Merge with hidden edit", f.work, f.main)
                with self.subTest(path=path), self.assertRaisesRegex(ValueError, "tree differs"):
                    gate.range_check(f.main, forged, f.task)

    def test_conflict_resolution_is_not_a_clean_sync(self):
        with repository(conflict=True) as f:
            with self.assertRaisesRegex(ValueError, "conflicting"):
                gate.range_check(f.main, f.synced, f.task)

    def test_clean_sync_does_not_hide_old_violation_or_later_wrong_path(self):
        with repository() as f:
            index(f.work)
            write("docs/infra/forbidden.md")
            bad = commit(f.message, f.work)
            index(f.work)
            fixed = commit(f.message, bad)
            index(f.synced)
            synced = commit("Merge clean after restoring bad work", fixed, f.main)
            with self.assertRaises(ValueError):
                gate.range_check(f.main, synced, f.task)
            write("docs/infra/forbidden.md", "Later violation\n")
            later = commit(f.message, f.synced)
            with self.assertRaises(ValueError):
                gate.range_check(f.main, later, f.task)

    def test_wrong_work_message_and_symlink_are_still_rejected(self):
        with repository() as f:
            index(f.work)
            wrong = commit("[DEV][docs] DEV-901 Wrong department\n\nBody.", f.base)
            index(f.synced)
            merged = commit("Merge", wrong, f.main)
            with self.assertRaises(ValueError):
                gate.range_check(f.main, merged, f.task)
            index(f.work)
            link_blob = subprocess.check_output(["git", "hash-object", "-w", "--stdin"], input=b"target")
            subprocess.run(["git", "update-index", "--add", "--cacheinfo", "120000",
                            link_blob.decode().strip(), f.root + "link"], check=True)
            linked = commit(f.message, f.work)
            with self.assertRaises(ValueError):
                gate.range_check(f.main, linked, f.task)

    def test_repeated_base_updates_preserve_the_same_branch_and_old_head(self):
        with repository() as f:
            index(f.main)
            write("docs/design/main-second.md")
            main_next = commit("Another trusted main change", f.main)
            index(f.synced)
            write("docs/design/main-second.md")
            updated = commit("Merge latest main", f.synced, main_next)
            subprocess.run(["git", "update-ref", "refs/heads/" + f.branch, updated, f.synced], check=True)
            gate.range_check(main_next, updated, f.task)
            self.assertTrue(gate.is_ancestor(f.synced, updated))
            self.assertEqual(gate.git("branch", "--show-current").decode().strip(), f.branch)

    def test_local_and_global_external_merge_drivers_are_not_executed(self):
        with repository("DEV", driver=True) as f:
            sentinel = Path("driver-executed").resolve()
            command = f'echo executed > "{sentinel.as_posix()}"'
            subprocess.run(["git", "config", "merge.probe.driver", command], check=True)
            with tempfile.TemporaryDirectory() as folder:
                config = Path(folder) / "global.config"
                subprocess.run(["git", "config", "--file", str(config), "merge.probe.driver", command], check=True)
                with patch.dict(os.environ, {"GIT_CONFIG_GLOBAL": str(config)}):
                    gate.range_check(f.main, f.synced, f.task)
            self.assertFalse(sentinel.exists())


if __name__ == "__main__":
    unittest.main()
