"""DEV-013 draft protocol spike. Read-only, REPORT_ONLY, never an approval gate.

Reads candidate registry data from a pinned base and manifests from Git objects.
No real IDs are issued here; policy/schema adoption requires INF/Owner decisions.
"""

import argparse
from contextlib import redirect_stdout
import io
import json
from pathlib import Path, PurePosixPath
import re
import subprocess

import department_policy as gate

ID = re.compile(r"AGT-(PM|PLN|DSG|DEV|INF)-[0-9]{4}")
SHA = re.compile(r"[0-9a-f]{40}")
LIMIT = 1024 * 1024  # Draft resource bounds, not adopted policy.


class Invalid(ValueError):
    pass


def require(condition, code):
    if not condition:
        raise Invalid(code)


def safe_path(value):
    require(isinstance(value, str) and bool(value), "PATH_INVALID")
    path = PurePosixPath(value)
    require(not path.is_absolute() and ".." not in path.parts and "\\" not in value,
            "PATH_INVALID")
    require(str(path) == value and not any(ord(c) < 32 for c in value), "PATH_INVALID")
    return value


def git(*args):
    return subprocess.check_output(["git", *args], stderr=subprocess.DEVNULL)


def blob(ref, path):
    safe_path(path)
    spec = f"{ref}:{path}"
    size = int(git("cat-file", "-s", spec))
    require(size <= LIMIT, "JSON_TOO_LARGE")
    require(git("cat-file", "-t", spec).strip() == b"blob", "JSON_NOT_BLOB")
    return git("cat-file", "blob", spec)


def json_data(raw):
    require(len(raw) <= LIMIT, "JSON_TOO_LARGE")

    def unique(pairs):
        result = {}
        for key, value in pairs:
            require(key not in result, "JSON_DUPLICATE_KEY")
            result[key] = value
        return result

    def constant(_):
        raise Invalid("JSON_NONFINITE")

    try:
        result = json.loads(raw.decode("utf-8"), object_pairs_hook=unique, parse_constant=constant)
    except (UnicodeError, json.JSONDecodeError, RecursionError):
        raise Invalid("JSON_INVALID") from None

    def depth(value, level=0):
        require(level <= 32, "JSON_TOO_DEEP")
        if isinstance(value, dict):
            for item in value.values():
                depth(item, level + 1)
        elif isinstance(value, list):
            for item in value:
                depth(item, level + 1)

    depth(result)
    require(isinstance(result, dict) and type(result.get("schema_version")) is int
            and result["schema_version"] == 1, "SCHEMA_VERSION")
    return result


def registry(raw):
    data = json_data(raw)
    rows = data.get("agents")
    require(isinstance(rows, list) and len(rows) <= 1000, "REGISTRY_ROWS")
    agents = {}
    for row in rows:
        require(isinstance(row, dict), "REGISTRY_ROW")
        agent = row.get("agent_id")
        require(isinstance(agent, str) and ID.fullmatch(agent) is not None, "AGENT_FORMAT")
        require(agent not in agents, "AGENT_DUPLICATE")
        require(row.get("department") == ID.fullmatch(agent)[1], "AGENT_DEPARTMENT")
        require(type(row.get("generation")) is int and row["generation"] > 0, "AGENT_GENERATION")
        require(isinstance(row.get("status"), str)
                and row["status"] in {"PENDING", "ACTIVE", "RETIRED", "SUSPENDED"}, "AGENT_STATUS")
        require(isinstance(row.get("owner_approval_ref"), str)
                and bool(row["owner_approval_ref"].strip()), "AGENT_APPROVAL_REFERENCE")
        agents[agent] = row
    return agents


def agent_check(agent, agents, department=None):
    require(isinstance(agent, str) and ID.fullmatch(agent) is not None, "AGENT_FORMAT")
    require(agent in agents, "AGENT_UNREGISTERED")
    require(agents[agent]["status"] == "ACTIVE", "AGENT_INACTIVE")
    if department is not None:
        require(agents[agent]["department"] == department, "AGENT_DEPARTMENT")


def declaration(text, task, agents):
    require(isinstance(text, str) and len(text.encode("utf-8")) <= LIMIT, "METADATA_SIZE")
    footer = text.rstrip().split("\n\n")[-1].splitlines()
    fields = {}
    for line in footer:
        match = re.fullmatch(r"([A-Za-z][A-Za-z0-9-]*): ([^\r\n]+)", line)
        require(match is not None, "TRAILER_BLOCK")
        fields.setdefault(match[1], []).append(match[2])
    require(len(fields.get("Agent-ID", [])) == 1, "PRIMARY_COUNT")
    require(fields.get("Task-ID") == [task], "TASK_TRAILER")
    primary = fields["Agent-ID"][0]
    agent_check(primary, agents, task.split("-")[0])
    contributors = fields.get("Contributor-Agent-ID", [])
    require(len(contributors) == len(set(contributors)) and primary not in contributors,
            "CONTRIBUTOR_DUPLICATE")
    for agent in contributors:
        agent_check(agent, agents)
    return primary, set(contributors)


def changes(base, head):
    raw = git("diff", "--raw", "--no-abbrev", "--no-renames", "-z", base, head).split(b"\0")
    result = {}
    for index in range(0, len(raw) - 1, 2):
        metadata = raw[index].decode("ascii").split()
        path = safe_path(raw[index + 1].decode("utf-8"))
        require(len(metadata) == 5 and metadata[4] in {"A", "M", "D"}, "CHANGE_KIND")
        result[path] = (metadata[4], metadata[2], metadata[3])
    return result


def manifest_check(raw, manifest_path, base, head, task, primary, declared, contributors, agents):
    data = json_data(raw)
    require(data.get("task_id") == task and data.get("primary_agent_id") == primary, "MANIFEST_OWNER")
    require(data.get("base_sha") == base, "MANIFEST_BASE")
    entries = data.get("artifacts")
    require(isinstance(entries, list) and len(entries) <= 5000, "MANIFEST_ROWS")
    actual = changes(base, head)
    # The manifest's own blob is the only self-reference exemption.
    require(manifest_path in actual and actual[manifest_path][0] != "D", "MANIFEST_UNCHANGED")
    del actual[manifest_path]
    covered = set()
    for entry in entries:
        require(isinstance(entry, dict), "MANIFEST_ROW")
        path = safe_path(entry.get("path"))
        require(path in actual and path not in covered, "MANIFEST_COVERAGE")
        kind, old_sha, new_sha = actual[path]
        actor = entry.get("agent_id")
        agent_check(actor, agents, task.split("-")[0])
        require(actor in declared, "ARTIFACT_AUTHOR_UNDECLARED")
        people = entry.get("contributors")
        require(isinstance(people, list) and all(isinstance(p, str) for p in people), "ARTIFACT_CONTRIBUTORS")
        require(len(people) == len(set(people)) and actor not in people, "CONTRIBUTOR_DUPLICATE")
        for person in people:
            agent_check(person, agents)
            require(person in contributors or person in declared, "ARTIFACT_CONTRIBUTOR_UNDECLARED")
        refs = entry.get("source_refs")
        require(isinstance(refs, list) and bool(refs)
                and all(isinstance(r, str) and r.strip() for r in refs), "SOURCE_REFERENCES")
        expected = {"A": "add", "M": "modify", "D": "delete"}[kind]
        if entry.get("change_type") == "rename":
            old_path = safe_path(entry.get("old_path"))
            require(kind == "A" and old_path in actual and actual[old_path][0] == "D"
                    and old_path not in covered, "RENAME_PAIR")
            require(entry.get("old_blob_sha") == actual[old_path][1], "OLD_BLOB_MISMATCH")
            covered.add(old_path)
        else:
            require(entry.get("change_type") == expected, "ARTIFACT_CHANGE_KIND")
            if kind != "A":
                require(entry.get("old_blob_sha") == old_sha, "OLD_BLOB_MISMATCH")
        require(entry.get("blob_sha") == (None if kind == "D" else new_sha), "BLOB_MISMATCH")
        covered.add(path)
    require(covered == set(actual), "MANIFEST_COVERAGE")


def audit(base, head, task, branch, title, body, registry_path, manifest_path):
    """Returns diagnostic codes, never user-provided values or file contents."""
    try:
        require(SHA.fullmatch(base) is not None and SHA.fullmatch(head) is not None, "COMMIT_SHA")
        require(gate.branch_task(branch) == task, "BRANCH_TASK")
        gate.message_check(title, task, title_only=True)
        with redirect_stdout(io.StringIO()):
            gate.range_check(base, head, task)
        safe_path(registry_path)
        require(registry_path.startswith("docs/infra/"), "REGISTRY_LOCATION")
        try:
            trusted = blob(base, registry_path)
        except subprocess.CalledProcessError:
            return ["REGISTRY_NOT_CONFIGURED"]
        agents = registry(trusted)
        primary, pr_contributors = declaration(body, task, agents)
        allowed = [f"{gate.department(task)[1]}tasks/{task}_PROVENANCE.json"]
        if task.startswith("DEV-"):
            allowed.append(f"tasks/{task}_PROVENANCE.json")
        require(manifest_path in allowed, "MANIFEST_LOCATION")
        authors, all_contributors = set(), set()
        commits = git("rev-list", "--reverse", f"{base}..{head}").decode().splitlines()
        last = None
        for sha in commits:
            last, people = declaration(git("show", "-s", "--format=%B", sha).decode("utf-8"), task, agents)
            authors.add(last)
            all_contributors.update(people)
            manifest_check(blob(sha, manifest_path), manifest_path, base, sha, task,
                           last, authors, pr_contributors | all_contributors, agents)
        require(primary == last, "PR_PRIMARY_MISMATCH")
        require(all_contributors <= pr_contributors, "PR_CONTRIBUTORS_MISSING")
        return []
    except Invalid as error:
        return [str(error)]
    except (ValueError, OSError, subprocess.CalledProcessError, UnicodeError, RecursionError):
        return ["INPUT_OR_EXISTING_POLICY_INVALID"]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base", "head", "task", "branch", "title", "pr-body-file", "registry", "manifest"):
        parser.add_argument("--" + name, required=True)
    args = parser.parse_args()
    try:
        require(Path(args.pr_body_file).stat().st_size <= LIMIT, "METADATA_SIZE")
        body = Path(args.pr_body_file).read_text(encoding="utf-8")
        diagnostics = audit(args.base, args.head, args.task, args.branch, args.title,
                            body, args.registry, args.manifest)
    except (OSError, UnicodeError, Invalid):
        diagnostics = ["PR_METADATA_UNREADABLE"]
    print(json.dumps({"mode": "REPORT_ONLY", "protocol": "draft-v1",
                      "result": "DIAGNOSTICS" if diagnostics else "DECLARATION_CONSISTENT",
                      "diagnostics": diagnostics, "identity_authenticated": False}))
    # Always report-only; not wired into hooks, CI, or branch protection.
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
