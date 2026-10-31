"""Repository gates. No commit, push, merge, or approval is performed here."""

import argparse
import importlib.metadata
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile

TASK = r"(?:DEV|PLN|DSG|PM)-[0-9]{3,}"
BRANCH = re.compile(rf"codex/({TASK})-[a-z0-9]+(?:-[a-z0-9]+)*")
SUBJECT = re.compile(
    rf"(?:feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)"
    rf"\([a-z][a-z0-9-]*\)!?: ({TASK}) \S[^\r\n]*"
)
TEXT_SUFFIXES = {".gd", ".py", ".yml", ".yaml", ".json", ".toml", ".cfg"}


def git(*args):
    return subprocess.check_output(["git", *args])


def branch_task(branch):
    match = BRANCH.fullmatch(branch)
    if not match:
        raise ValueError(f"Invalid work branch: {branch}; use codex/DEV-002-description")
    return match.group(1)


def message_check(message, task, title_only=False):
    lines = message.strip().splitlines()
    match = SUBJECT.fullmatch(lines[0]) if lines else None
    if not match or match.group(1) != task or len(lines[0]) > 100:
        raise ValueError("Subject must be type(scope): TASK-ID description (<=100 characters)")
    if not title_only:
        if len(lines) < 3 or lines[1] or not any(line.strip() for line in lines[2:]):
            raise ValueError("Add a blank line and a body explaining effect and validation")


def ticket_check(task, names):
    if not any(re.fullmatch(rf"tasks/{re.escape(task)}_(?!RESULT\.md$).+\.md", p) for p in names):
        raise ValueError(f"Missing task document for {task}")


def paths(mode):
    if mode == "staged":
        raw = git("ls-files", "-z")
    else:
        raw = git("ls-files", "-z", "--cached", "--others", "--exclude-standard")
    return sorted(set(p.decode("utf-8") for p in raw.split(b"\0") if p))


def file_check(name, data):
    path = Path(name)
    if path.suffix not in TEXT_SUFFIXES and not name.startswith(".githooks/"):
        return
    text = data.decode("utf-8")
    if text.startswith("\ufeff"):
        raise ValueError(f"{name}: UTF-8 BOM is forbidden")
    if data and not data.endswith(b"\n"):
        raise ValueError(f"{name}: missing final newline")
    for number, line in enumerate(text.splitlines(), 1):
        if line != line.rstrip():
            raise ValueError(f"{name}:{number}: trailing whitespace")
    if path.suffix == ".gd":
        if not re.fullmatch(r"[a-z][a-z0-9_]*", path.stem):
            raise ValueError(f"{name}: GDScript filenames must be snake_case")
    if name.startswith(".githooks/") and b"\r" in data:
        raise ValueError(f"{name}: hooks require LF")


def check(mode="worktree"):
    names = paths(mode)
    with tempfile.TemporaryDirectory(prefix="metro-policy-") as directory:
        snapshot = Path(directory)
        scripts = []
        for name in names:
            path = Path(name)
            if mode == "worktree" and not path.is_file():
                continue
            data = git("show", f":{name}") if mode == "staged" else path.read_bytes()
            file_check(name, data)
            if path.suffix == ".gd":
                target = snapshot / path
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(data)
                scripts.append(name)
        if scripts:
            if importlib.metadata.version("gdtoolkit") != "4.5.0":
                raise ValueError("Install pinned tools/requirements-dev.txt")
            # Isolated snapshot: staged code cannot be hidden by unstaged fixes.
            for module, flags in [("formatter", ["--check"]), ("linter", [])]:
                subprocess.run(
                    [sys.executable, "-m", f"gdtoolkit.{module}", *flags, *scripts],
                    cwd=snapshot, check=True,
                )
        print(f"PASS: {mode} files={len(names)}, GDScript={len(scripts)}")


def commits_check(base, head, task):
    commits = git("rev-list", f"{base}..{head}").decode().splitlines()
    for sha in commits:
        parents = git("rev-list", "--parents", "-n", "1", sha).decode().split()
        if len(parents) > 2:
            raise ValueError(f"Merge commit forbidden on work branch: {sha}")
        message_check(git("show", "-s", "--format=%B", sha).decode("utf-8"), task)


def push_target(local_sha, remote_ref, remote_sha):
    if set(local_sha) == {"0"}:
        raise ValueError("Deletion requires separate Owner-controlled maintenance")
    if not remote_ref.startswith("refs/heads/"):
        raise ValueError("Tags and non-branch refs require separate release approval")
    task = branch_task(remote_ref.removeprefix("refs/heads/"))
    if set(remote_sha) != {"0"}:
        subprocess.run(["git", "merge-base", "--is-ancestor", remote_sha, local_sha], check=True)
    return task


def pre_push():
    for line in sys.stdin:
        _, local_sha, remote_ref, remote_sha = line.split()
        task = push_target(local_sha, remote_ref, remote_sha)
        # All branch commits, including previously pushed ones, must pass.
        base = git("rev-parse", "--verify", "origin/main").decode().strip()
        commits_check(base, local_sha, task)
        names = git("ls-tree", "-r", "--name-only", local_sha).decode("utf-8").splitlines()
        ticket_check(task, names)
    print("PASS: push ref/commit checks; Owner authorization must be verified separately")


def doctor():
    result = subprocess.run(["git", "config", "--get", "core.hooksPath"], capture_output=True, text=True)
    if result.stdout.strip() != ".githooks":
        raise ValueError("Hooks inactive: run python tools/install_hooks.py")
    for name in ("pre-commit", "commit-msg", "pre-push"):
        file_check(f".githooks/{name}", Path(f".githooks/{name}").read_bytes())
    if importlib.metadata.version("gdtoolkit") != "4.5.0":
        raise ValueError("gdtoolkit 4.5.0 required")
    print("PASS: local hooks/tooling; remote protection is NOT verified by doctor")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=["check", "pre-commit", "commit-msg", "pre-push", "doctor", "ci"])
    parser.add_argument("message_file", nargs="?")
    args = parser.parse_args()
    if args.command == "check":
        check()
    elif args.command == "doctor":
        doctor()
    elif args.command == "pre-push":
        pre_push()
    elif args.command in {"pre-commit", "commit-msg"}:
        task = branch_task(git("branch", "--show-current").decode().strip())
        ticket_check(task, paths("staged"))
        if args.command == "pre-commit":
            check("staged")
        else:
            message_check(Path(args.message_file).read_text(encoding="utf-8"), task)
    else:
        event = json.loads(Path(os.environ["GITHUB_EVENT_PATH"]).read_text(encoding="utf-8"))
        pr = event["pull_request"]
        task = branch_task(pr["head"]["ref"])
        message_check(pr["title"], task, title_only=True)
        ticket_check(task, paths("worktree"))
        commits_check(pr["base"]["sha"], pr["head"]["sha"], task)
        check()


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, subprocess.CalledProcessError, importlib.metadata.PackageNotFoundError) as error:
        print(f"FAIL: {error}", file=sys.stderr)
        sys.exit(1)
