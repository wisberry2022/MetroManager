"""Trusted, data-only commit/path gate. Never imports or executes PR code."""

import datetime
import json
import os
from pathlib import Path, PurePosixPath
import re
import subprocess
import sys
import tempfile

DEPARTMENTS = {
    "DEV": ("DEV", "docs/engineering/"),
    "PM": ("HQ", "docs/hq/"),
    "PLN": ("기획", "docs/planning/"),
    "DSG": ("디자인", "docs/design/"),
    "INF": ("INF", "docs/infra/"),
}
TASK = r"(?:DEV|PM|PLN|DSG|INF)-[0-9]{3,}"
BRANCH = re.compile(rf"codex/({TASK})-[a-z0-9]+(?:-[a-z0-9]+)*")
SUBJECT = re.compile(
    rf"\[(HQ|기획|디자인|DEV|INF)\]\[(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)\] "
    rf"({TASK}) (\S[^\r\n]*)"
)
EXCEPTIONS = "docs/governance/path_exceptions.json"
# Only direct Markdown reports and their index are shared across departments.
SHARED_REPORT = re.compile(
    r"docs/co-work/err-report/(?:README\.md|ERR-[0-9]{8}-[0-9]{3,}_[^/\\]+\.md)"
)
DEV_ROOTS = ("scripts/", "scenes/", "assets/", "tests/", "tools/", ".github/", ".githooks/",
             "docs/engineering/", "docs/governance/", "docs/templates/")
DEV_FILES = {"AGENTS.md", "README.md", ".editorconfig", ".gitattributes", ".gitignore",
             "project.godot", "export_presets.cfg", "icon.svg", "icon.svg.import",
             # Shared instruction entry points maintained by Convention Team (DEV-003).
             "docs/hq/README.md", "docs/planning/README.md", "docs/design/README.md"}


def git(*args):
    return subprocess.check_output(["git", *args])


def branch_task(branch):
    match = BRANCH.fullmatch(branch)
    if not match:
        raise ValueError(f"Invalid work branch: {branch}")
    return match.group(1)


def department(task):
    if not re.fullmatch(TASK, task):
        raise ValueError("Invalid task ID")
    return DEPARTMENTS[task.split("-")[0]]


def message_check(message, task, title_only=False):
    lines = message.strip().splitlines()
    match = SUBJECT.fullmatch(lines[0]) if lines else None
    if not match or match[1] != department(task)[0] or match[3] != task or len(lines[0]) > 100:
        raise ValueError("Expected [부서][type] TASK-ID 설명, matching branch department/task (<=100 chars)")
    if not title_only and (len(lines) < 3 or lines[1] or not any(x.strip() for x in lines[2:])):
        raise ValueError("Commit body required after blank line: explain effect and validation")


def ticket_check(task, names):
    _, root = department(task)
    prefixes = [root + "tasks/"]
    if task.startswith("DEV-"):
        prefixes.append("tasks/")  # Preserve existing development tickets.
    if not any(any(p.startswith(prefix + task + "_") for prefix in prefixes)
               and p.endswith(".md") and not p.endswith("_RESULT.md") for p in names):
        raise ValueError(f"Missing task document in department directory for {task}")


def load_exceptions(base):
    exists = subprocess.run(["git", "cat-file", "-e", f"{base}:{EXCEPTIONS}"], capture_output=True)
    if exists.returncode:
        return {}
    return json.loads(git("show", f"{base}:{EXCEPTIONS}").decode("utf-8"))


def path_check(task, names, exceptions=None, today=None):
    _, root = department(task)
    today = today or datetime.datetime.now(datetime.timezone.utc).date()
    grant = (exceptions or {}).get(task, {})
    extra = set()
    if grant:
        if not grant.get("decision") or not grant.get("reason"):
            raise ValueError("Exception requires a decision reference and reason")
        if datetime.date.fromisoformat(grant["expires"]) >= today:
            extra = set(grant["paths"])
    for name in names:
        path = PurePosixPath(name)
        if path.is_absolute() or ".." in path.parts or "\\" in name:
            raise ValueError(f"Unsafe path: {name}")
        allowed = name.startswith(root)
        if task.startswith("DEV-"):
            allowed = (name.startswith(DEV_ROOTS) or name in DEV_FILES
                       or bool(re.fullmatch(r"tasks/DEV-[0-9]{3,}_[^/]+\.md", name)))
        allowed = allowed or SHARED_REPORT.fullmatch(name) is not None
        if not allowed and name not in extra:
            raise ValueError(f"{department(task)[0]} cannot modify {name}; use own directory or approved base exception")


def names_at(ref):
    return [x.decode("utf-8") for x in git("ls-tree", "-r", "--name-only", "-z", ref).split(b"\0") if x]


def changed_paths(*args):
    # --no-renames exposes both the deleted source and added destination.
    return [x.decode("utf-8") for x in git("diff", "--name-only", "--no-renames", "-z", *args).split(b"\0") if x]


def modes_check(ref, names):
    if not names:
        return
    raw = git("ls-tree", "-r", "-z", ref)
    changed = set(names)
    for entry in raw.split(b"\0"):
        if not entry:
            continue
        metadata, name = entry.split(b"\t", 1)
        if name.decode("utf-8") in changed and metadata.split()[0] not in {b"100644", b"100755"}:
            raise ValueError("Changed symlinks/submodules are not allowed; request a reviewed policy change")


def is_ancestor(older, newer):
    result = subprocess.run(
        ["git", "merge-base", "--is-ancestor", older, newer], capture_output=True,
    )
    if result.returncode == 1:
        return False
    result.check_returncode()
    return True


def clean_merge_tree(first, second):
    """Recompute in an isolated object-only repo; no checkout, refs or PR code execution.

    Global/system/source-local merge drivers are deliberately not imported. Git's
    built-in clean merge result is required; conflicts and unsupported Git fail closed.
    """
    for sha in (first, second):
        if not re.fullmatch(r"[0-9a-f]{40}", sha):
            raise ValueError("Invalid merge parent SHA")
    objects = Path(git("rev-parse", "--git-path", "objects").decode().strip()).resolve()
    alternate = objects.as_posix()
    if "\n" in alternate or "\r" in alternate:
        raise ValueError("Unsupported object directory")
    env = {key: value for key, value in os.environ.items() if not key.startswith("GIT_")}
    env.update(GIT_CONFIG_NOSYSTEM="1", GIT_CONFIG_GLOBAL=os.devnull,
               GIT_ATTR_NOSYSTEM="1", GIT_NO_REPLACE_OBJECTS="1")
    with tempfile.TemporaryDirectory(prefix="metro-verified-sync-") as folder:
        try:
            subprocess.run(["git", "init", "--bare", "--quiet", folder], env=env,
                           check=True, capture_output=True, timeout=30)
            (Path(folder) / "objects/info/alternates").write_text(
                alternate + "\n", encoding="utf-8", newline="\n",
            )
            result = subprocess.run(
                ["git", "-C", folder, "merge-tree", "--write-tree", first, second],
                env=env, capture_output=True, timeout=30,
            )
        except (OSError, subprocess.SubprocessError):
            raise ValueError("Unable to verify base-sync tree; Git merge-tree --write-tree required") from None
        if result.returncode != 0:
            raise ValueError("Base-sync is conflicting or cannot be verified; preserve work and use a replacement PR")
        tree = result.stdout.splitlines()[0].decode("ascii") if result.stdout else ""
        if not re.fullmatch(r"[0-9a-f]{40}", tree):
            raise ValueError("Invalid verified merge tree")
        return tree


def verified_base_sync(base, sha, parents):
    if len(parents) != 2:
        raise ValueError(f"Expected single-parent work commit or verified base-sync merge: {sha}; use a replacement PR")
    first, second = parents
    if (not is_ancestor(second, base) or is_ancestor(first, second)
            or is_ancestor(second, first)):
        raise ValueError(f"Expected single-parent work commit: {sha}; merge parent is not a new trusted base; use a replacement PR")
    expected = clean_merge_tree(first, second)
    actual = git("rev-parse", f"{sha}^{{tree}}").decode().strip()
    if actual != expected:
        raise ValueError(f"Base-sync tree differs from the clean merge: {sha}; use a replacement PR")


def range_check(base, head, task):
    grants = load_exceptions(base)
    ticket_check(task, names_at(head))
    commits = git("rev-list", f"{base}..{head}").decode().splitlines()
    if not commits:
        raise ValueError("No task commits to validate")
    work_count, sync_count = 0, 0
    for sha in commits:
        parents = git("rev-list", "--parents", "-n", "1", sha).decode().split()
        if len(parents) != 2:
            verified_base_sync(base, sha, parents[1:])
            sync_count += 1
            continue
        message_check(git("show", "-s", "--format=%B", sha).decode("utf-8"), task)
        changed = changed_paths(parents[1], sha)
        path_check(task, changed, grants)
        modes_check(sha, changed)
        work_count += 1
    if not work_count or (sync_count and not changed_paths(base, head)):
        raise ValueError("Expected single-parent work commit or effective verified base-sync; "
                         "no task changes; use a replacement PR")
    print(f"PASS: department={department(task)[0]}, commits={len(commits)}, task={task}, "
          f"work={work_count}, verified_base_sync={sync_count}")


def staged_check(task):
    base = git("rev-parse", "origin/main").decode().strip()
    path_check(task, changed_paths("--cached"), load_exceptions(base))
    for row in git("ls-files", "--stage", "-z").split(b"\0"):
        if row and row.split()[0] not in {b"100644", b"100755"}:
            raise ValueError("Symlinks/submodules are not supported by the local gate")


def main():
    from pathlib import Path
    event = json.loads(Path(os.environ["GITHUB_EVENT_PATH"]).read_text(encoding="utf-8"))
    pr = event["pull_request"]
    base, head = pr["base"]["sha"], pr["head"]["sha"]
    for sha in (base, head):
        if not re.fullmatch(r"[0-9a-f]{40}", sha):
            raise ValueError("Invalid event SHA")
    task = branch_task(pr["head"]["ref"])
    message_check(pr["title"], task, title_only=True)
    range_check(base, head, task)


if __name__ == "__main__":
    try:
        main()
    except (ValueError, KeyError, OSError, subprocess.CalledProcessError) as error:
        print(f"FAIL: {error}", file=sys.stderr)
        sys.exit(1)
