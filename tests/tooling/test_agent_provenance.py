"""Synthetic, unissued identities in temporary repositories; no real registry writes."""

from contextlib import contextmanager
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "tools"))
import agent_provenance as provenance
import department_policy as gate

MODULE = Path(provenance.__file__).resolve()
REGISTRY = "docs/infra/agents/registry.json"


def row(prefix="DEV", number="0001", status="ACTIVE"):
    return {"agent_id": f"AGT-{prefix}-{number}", "department": prefix, "generation": 1,
            "status": status, "owner_approval_ref": "SYNTHETIC-TEST-NOT-AN-APPROVAL"}


def run(*args):
    return subprocess.check_output(["git", *args], stderr=subprocess.DEVNULL)


def write(path, data):
    target = Path(path)
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(data if isinstance(data, bytes) else data.encode())
    subprocess.run(["git", "add", "--", path], check=True)


def commit(parent, message):
    tree = run("write-tree").decode().strip()
    args = ["git", "commit-tree", tree]
    if parent:
        args += ["-p", parent]
    return subprocess.check_output(args, input=message.encode()).decode().strip()


class Fixture:
    def __init__(self, prefix="DEV", rows=None):
        self.prefix = prefix
        self.task = prefix + "-901"
        self.primary = "AGT-" + prefix + "-0001"
        self.root = gate.DEPARTMENTS[prefix][1]
        self.manifest = f"{self.root}tasks/{self.task}_PROVENANCE.json"
        self.title = f"[{gate.department(self.task)[0]}][docs] {self.task} Fixture"
        self.footer = f"Agent-ID: {self.primary}\nTask-ID: {self.task}"
        self.body = "Synthetic metadata\n\n" + self.footer
        write(REGISTRY, json.dumps({"schema_version": 1, "agents": rows if rows is not None else [row(prefix)]}))
        self.base = commit(None, "Historical test base")
        write(f"{self.root}tasks/{self.task}_PLAN.md", "Fixture ticket\n")
        self.head = None

    def manifest_data(self):
        tree = run("write-tree").decode().strip()
        artifacts = []
        for path, (kind, old, new) in provenance.changes(self.base, tree).items():
            if path == self.manifest:
                continue
            item = {"path": path, "change_type": {"A": "add", "M": "modify", "D": "delete"}[kind],
                    "agent_id": self.primary, "contributors": [], "source_refs": [self.task],
                    "blob_sha": None if kind == "D" else new}
            if kind != "A":
                item["old_blob_sha"] = old
            artifacts.append(item)
        return {"schema_version": 1, "task_id": self.task, "primary_agent_id": self.primary,
                "base_sha": self.base, "artifacts": artifacts}

    def finish(self, mutate=None, footer=None, parent=None):
        data = self.manifest_data()
        if mutate:
            mutate(data)
        write(self.manifest, json.dumps(data, ensure_ascii=False) + "\n")
        self.head = commit(parent or self.base, self.title + "\n\nFixture.\n\n"
                           + (self.footer if footer is None else footer))
        return self.head

    def audit(self, **overrides):
        args = dict(base=self.base, head=self.head, task=self.task,
                    branch=f"codex/{self.task}-fixture", title=self.title, body=self.body,
                    registry_path=REGISTRY, manifest_path=self.manifest)
        args.update(overrides)
        return provenance.audit(**args)


@contextmanager
def repository(prefix="DEV", rows=None):
    previous = Path.cwd()
    with tempfile.TemporaryDirectory(prefix="metro-provenance-") as folder:
        try:
            os.chdir(folder)
            subprocess.run(["git", "init", "-q"], check=True)
            for key, value in (("core.autocrlf", "false"), ("user.name", "Fixture"),
                               ("user.email", "fixture@example.invalid")):
                subprocess.run(["git", "config", key, value], check=True)
            yield Fixture(prefix, rows)
        finally:
            os.chdir(previous)


class ProvenanceTests(unittest.TestCase):
    def test_all_departments_and_read_only_validation(self):
        for prefix in gate.DEPARTMENTS:
            with self.subTest(prefix=prefix), repository(prefix) as fixture:
                fixture.finish()
                before = run("status", "--porcelain"), run("for-each-ref")
                self.assertEqual(fixture.audit(), [])
                self.assertEqual(before, (run("status", "--porcelain"), run("for-each-ref")))

    def test_missing_duplicate_and_mismatching_trailers(self):
        with repository() as f:
            for footer in ("No trailers", f.footer + "\nAgent-ID: " + f.primary,
                           f.footer.replace(f.task, "DEV-902")):
                with self.subTest(footer=footer):
                    f.finish(footer=footer)
                    self.assertTrue(f.audit())
            f.finish()
            self.assertEqual(f.audit(body=f.body + "\nAgent-ID: " + f.primary), ["PRIMARY_COUNT"])

    def test_unregistered_inactive_and_wrong_department(self):
        for status in ("PENDING", "RETIRED", "SUSPENDED"):
            with self.subTest(status=status), repository(rows=[row(status=status)]) as f:
                f.finish()
                self.assertEqual(f.audit(), ["AGENT_INACTIVE"])
        with repository(rows=[row("INF")]) as f:
            f.finish()
            self.assertEqual(f.audit(), ["AGENT_UNREGISTERED"])
            self.assertEqual(f.audit(body=f.body.replace(f.primary, "AGT-INF-0001")), ["AGENT_DEPARTMENT"])

    def test_head_registry_cannot_self_register(self):
        with repository("INF", rows=[]) as f:
            write(REGISTRY, json.dumps({"schema_version": 1, "agents": [row("INF")]}))
            f.finish()
            self.assertEqual(f.audit(), ["AGENT_UNREGISTERED"])

    def test_unconfigured_registry_is_reported_without_bootstrapping(self):
        with repository() as f:
            f.finish()
            self.assertEqual(f.audit(registry_path="docs/infra/not-issued.json"), ["REGISTRY_NOT_CONFIGURED"])

    def test_manifest_coverage_duplicate_and_stale_hash(self):
        mutations = [lambda d: d["artifacts"].clear(),
                     lambda d: d["artifacts"].append(dict(d["artifacts"][0])),
                     lambda d: d["artifacts"][0].update(blob_sha="0" * 40),
                     lambda d: d.update(base_sha="0" * 40),
                     lambda d: d["artifacts"][0].update(source_refs=[])]
        with repository() as f:
            for mutation in mutations:
                f.finish(mutation)
                self.assertTrue(f.audit())

    def test_binary_modify_delete_and_explicit_rename(self):
        with repository() as f:
            write("assets/old.png", b"\x89PNG\x00old")
            write("assets/delete.png", b"\x00delete")
            write("scenes/change.tscn", "[gd_scene]\n")
            f.base = commit(None, "Historical fixture with binary assets")
            # The ticket must still be changed in the request range.
            write(f"{f.root}tasks/{f.task}_PLAN.md", "Updated fixture ticket\n")
            subprocess.run(["git", "rm", "--cached", "assets/old.png", "assets/delete.png"],
                           check=True, capture_output=True)
            write("assets/new.png", b"\x89PNG\x00new")
            write("scenes/change.tscn", "[gd_scene load_steps=2]\n")

            def rename(data):
                old = next(item for item in data["artifacts"] if item["path"] == "assets/old.png")
                data["artifacts"].remove(old)
                new = next(item for item in data["artifacts"] if item["path"] == "assets/new.png")
                new.update(change_type="rename", old_path="assets/old.png", old_blob_sha=old["old_blob_sha"])

            f.finish(rename)
            self.assertEqual(f.audit(), [])
            f.finish(lambda d: (rename(d), next(x for x in d["artifacts"] if x["path"] == "assets/new.png")
                               .update(old_blob_sha="0" * 40)))
            self.assertEqual(f.audit(), ["OLD_BLOB_MISMATCH"])

    def test_contributor_declarations_do_not_grant_paths(self):
        with repository(rows=[row(), row("DSG")]) as f:
            f.footer += "\nContributor-Agent-ID: AGT-DSG-0001"
            f.body += "\nContributor-Agent-ID: AGT-DSG-0001"
            f.finish(lambda d: d["artifacts"][0].update(contributors=["AGT-DSG-0001"]))
            self.assertEqual(f.audit(), [])
            self.assertEqual(f.audit(body=f.body.rsplit("\n", 1)[0]), ["PR_CONTRIBUTORS_MISSING"])
            write("docs/design/forbidden.md", "No permission\n")
            f.finish()
            self.assertEqual(f.audit(), ["INPUT_OR_EXISTING_POLICY_INVALID"])

    def test_intermediate_bad_manifest_is_not_hidden_by_final_repair(self):
        with repository() as f:
            bad = f.finish(lambda d: d["artifacts"][0].update(blob_sha="0" * 40))
            f.finish(parent=bad)
            self.assertEqual(f.audit(), ["BLOB_MISMATCH"])

    def test_invalid_registry_and_json_resource_guards(self):
        examples = [b'{"schema_version":1,"schema_version":1}',
                    b'{"schema_version":1,"x":NaN}', b"not-json", b"\xff",
                    json.dumps({"schema_version": 1, "agents": [row(), row()]}).encode(),
                    b" " * (provenance.LIMIT + 1)]
        for raw in examples:
            with self.subTest(size=len(raw)), self.assertRaises(provenance.Invalid):
                provenance.registry(raw)
        nested = b'{"schema_version":1,"x":' + b"[" * 40 + b"0" + b"]" * 40 + b"}"
        with self.assertRaises(provenance.Invalid):
            provenance.json_data(nested)
        for number in ("001", "00001"):
            with self.assertRaises(provenance.Invalid):
                provenance.registry(json.dumps({"schema_version": 1, "agents": [row(number=number)]}).encode())

    def test_report_only_cli_never_prints_metadata_values(self):
        with repository() as f:
            f.finish()
            Path("pr-body.txt").write_text("PRIVATE-FIXTURE-DO-NOT-LOG", encoding="utf-8")
            result = subprocess.run([sys.executable, str(MODULE), "--base", f.base, "--head", f.head,
                                     "--task", f.task, "--branch", f"codex/{f.task}-fixture",
                                     "--title", f.title, "--pr-body-file", "pr-body.txt",
                                     "--registry", REGISTRY, "--manifest", f.manifest],
                                    capture_output=True, text=True, check=True)
            self.assertNotIn("PRIVATE-FIXTURE", result.stdout + result.stderr)
            output = json.loads(result.stdout)
            self.assertEqual(output["mode"], "REPORT_ONLY")
            self.assertFalse(output["identity_authenticated"])
            self.assertEqual(output["result"], "DIAGNOSTICS")

    def test_legacy_branch_and_manifest_location_cannot_bypass_policy(self):
        with repository() as f:
            f.finish()
            self.assertTrue(f.audit(branch="main"))
            self.assertEqual(f.audit(manifest_path="docs/infra/DEV-901_PROVENANCE.json"), ["MANIFEST_LOCATION"])
            for path in ("../registry.json", "/tmp/registry.json", "docs/infra/../registry.json",
                         "docs/infra\\registry.json"):
                self.assertTrue(f.audit(registry_path=path))


if __name__ == "__main__":
    unittest.main()
