"""Install repository-local hooks without replacing an existing custom hook setup."""
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
current = subprocess.run(
    ["git", "config", "--get", "core.hooksPath"], cwd=root, capture_output=True, text=True
)
if current.stdout.strip() not in {"", ".githooks"}:
    sys.exit("Existing core.hooksPath found; preserve it and request integration review")
hooks_dir = subprocess.check_output(["git", "rev-parse", "--git-path", "hooks"], cwd=root).decode().strip()
for name in ("pre-commit", "pre-merge-commit", "commit-msg", "pre-push"):
    if (root / hooks_dir / name).exists() and current.stdout.strip() != ".githooks":
        sys.exit(f"Existing {name} found; preserve it and request integration review")
for hook in (root / ".githooks").iterdir():
    hook.chmod(hook.stat().st_mode | 0o111)
subprocess.run(["git", "config", "--local", "core.hooksPath", ".githooks"], cwd=root, check=True)
print("Installed core.hooksPath=.githooks for this repository")
