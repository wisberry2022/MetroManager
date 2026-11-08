"""Prepare a PENDING registration PR; submission requires an authorized main workflow.

No automatic activation, merge, force update, enforcement or authority authentication.
"""

import argparse
import json
import os
import subprocess
from urllib.error import HTTPError, URLError
from urllib.request import build_opener, HTTPRedirectHandler, Request

import agent_registry as registry
import agent_provenance as protocol

REPOSITORY = "wisberry2022/MetroManager"
WORKFLOW = REPOSITORY + "/.github/workflows/agent-registration-proposal.yml@refs/heads/main"
STEPS = registry.REGISTRATION_STEPS


class SubmissionError(ValueError):
    def __init__(self, code, recovery_context=None):
        super().__init__(code)
        self.recovery_context = recovery_context


class NoRedirect(HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        raise SubmissionError("API_REDIRECT_REFUSED")


class GitHub:
    def __init__(self, token):
        if not token:
            raise SubmissionError("WRITER_TOKEN_MISSING")
        self.token = token
        self.opener = build_opener(NoRedirect())

    def request(self, method, path, data=None):
        payload = None if data is None else json.dumps(data, ensure_ascii=False).encode("utf-8")
        request = Request("https://api.github.com/repos/" + REPOSITORY + "/" + path,
                          data=payload, method=method,
                          headers={"Authorization": "Bearer " + self.token,
                                   "Accept": "application/vnd.github+json",
                                   "Content-Type": "application/json", "User-Agent": "MetroManager-registration"})
        try:
            with self.opener.open(request, timeout=30) as response:
                raw = response.read(4 * protocol.LIMIT + 1)
            if len(raw) > 4 * protocol.LIMIT:
                raise SubmissionError("API_RESPONSE_TOO_LARGE")
            return json.loads(raw.decode("utf-8"))
        except HTTPError as error:
            code = f"API_HTTP_{error.code}" if type(error.code) is int and 100 <= error.code <= 599 else "API_REQUEST_FAILED"
            raise SubmissionError(code) from None
        except (URLError, OSError, ValueError) as error:
            if isinstance(error, SubmissionError):
                raise
            raise SubmissionError("API_REQUEST_FAILED") from None


def prepare(base, task, department, role, scope, predecessor, candidate_ref, handoff, git_ref, actor):
    registry.text(git_ref, "GIT_APPROVAL_REFERENCE_REQUIRED")
    expected = protocol.git("rev-parse", "refs/remotes/origin/main").decode().strip()
    proposed = registry.proposal(base, expected, task, department, role, scope, predecessor,
                                 candidate_ref, handoff)
    _, agents, _ = registry.trusted(base)
    protocol.agent_check(actor, agents, "INF")
    path = f"docs/infra/tasks/{task}_AGENT_REGISTRATION.md"
    protocol.require(path not in protocol.gate.names_at(base), "REGISTRATION_TICKET_EXISTS")
    title = f"[INF][feat] {task} 후임 Agent-ID PENDING 등록을 제안합니다"
    body = ("PENDING 후보만 제안하며 실제 ID 예약·활성화·병합은 수행하지 않습니다.\n"
            "INF 수용 검증 → PM 전환 확인 → Owner 활성화 승인 및 병합 순서로 검토합니다.\n"
            "활성화 시각은 실행/PR/병합 시각으로 추정하지 않고 Owner가 승인한 실제 효력 시각을 기록합니다.\n"
            f"후보 지정 참조: {candidate_ref}\nGit 실행 승인 참조: {git_ref}\n"
            "등록부 관리: INF / 도구 구현: Convention Team. REPORT_ONLY 유지; ENFORCE는 별도 Owner 승인.\n"
            f"\nAgent-ID: {actor}\nTask-ID: {task}")
    ticket = (f"# {task} — PENDING 후임 등록 검토\n\n"
              f"- 기준 main: `{base}` / 후보: `{proposed['agent_id']}` / 상태: REVIEW, DONE 아님.\n"
              f"- 후보 지정 참조: {candidate_ref}\n- Git 실행 승인 참조: {git_ref}\n"
              "- 위 참조는 호출자가 제공한 공개 근거이며 도구가 실제 승인자를 인증한 것이 아니다.\n"
              "- 순서: PENDING PR 생성 → INF 수용 검증 → PM 전환 확인 → Owner 활성화 승인 및 병합.\n"
              "- 생성 시 PENDING/activated_at=null. 실제 승인된 효력 시각을 INF가 기록한다.\n"
              "- 검증: 생성기의 형식/구조 사전 검사만 수행. 원격 CI·INF 수용·PM 전환·Owner 활성화 승인: NOT_RUN.\n"
              "- 게임 테스트/프로젝트 로드/플레이/빌드: NOT_RUN (등록 제안). ENFORCE 전환은 별도 승인 대상.\n")
    return {"mode": "PREPARED_PR", "base": base, "task": task, "actor": actor,
            "branch": proposed["branch"], "title": title, "body": body,
            "agent_id": proposed["agent_id"], "review_sequence": STEPS,
            "expected_registry_blob_sha": proposed["expected_registry_blob_sha"],
            "git_approval_ref": git_ref, "reserved": False, "remote_write_performed": False,
            "files": {registry.REGISTRY: json.dumps(proposed["registry"], ensure_ascii=False, indent=2) + "\n",
                      path: ticket}}


def ensure_workflow(base):
    protocol.require(os.environ.get("GITHUB_ACTIONS") == "true"
                     and os.environ.get("GITHUB_WORKFLOW_REF") == WORKFLOW
                     and os.environ.get("GITHUB_REF") == "refs/heads/main",
                     "AUTHORIZED_MAIN_WORKFLOW_REQUIRED")
    protocol.require(protocol.git("rev-parse", "HEAD").decode().strip() == base,
                     "TRUSTED_BASE_CHECKOUT_REQUIRED")


def sha(value):
    protocol.require(isinstance(value, str) and protocol.SHA.fullmatch(value) is not None, "API_SHA_INVALID")
    return value


def pages(client, path, max_pages):
    separator = "&" if "?" in path else "?"
    for page in range(1, max_pages + 1):
        result = client.request("GET", f"{path}{separator}per_page=100&page={page}")
        protocol.require(isinstance(result, list), "API_LIST_INVALID")
        yield from result
        if len(result) < 100:
            return
    raise SubmissionError("REGISTRATION_SCAN_LIMIT")


def no_pending_registration(client):
    # Main-only numbering must not allocate over an outstanding registration proposal.
    for pr in pages(client, "pulls?state=open", 10):
        number = pr.get("number")
        protocol.require(type(number) is int and number > 0, "API_PR_INVALID")
        for item in pages(client, f"pulls/{number}/files", 30):
            if item.get("filename") == registry.REGISTRY or item.get("previous_filename") == registry.REGISTRY:
                raise SubmissionError("REGISTRATION_PR_IN_PROGRESS")


def validate_plan(plan):
    task, base = plan["task"], plan["base"]
    protocol.require(protocol.gate.branch_task(plan["branch"]) == task and task.startswith("INF-"),
                     "PROPOSAL_INF_TASK_REQUIRED")
    ticket = f"docs/infra/tasks/{task}_AGENT_REGISTRATION.md"
    protocol.require(set(plan["files"]) == {registry.REGISTRY, ticket}, "REGISTRATION_PATHS")
    protocol.require(ticket not in protocol.gate.names_at(base), "REGISTRATION_TICKET_EXISTS")
    protocol.gate.message_check(plan["title"] + "\n\n" + plan["body"], task)
    protocol.gate.path_check(task, plan["files"], protocol.gate.load_exceptions(base))
    _, before, legacy = registry.trusted(base)
    protocol.agent_check(plan["actor"], before, "INF")
    after = registry.compare(protocol.blob(base, registry.REGISTRY),
                             plan["files"][registry.REGISTRY].encode("utf-8"), legacy)
    protocol.require(all(after[key] == old for key, old in before.items()), "REGISTRATION_EXISTING_RECORD_CHANGED")
    protocol.require(set(after) - set(before) == {plan["agent_id"]}, "REGISTRATION_SINGLE_CANDIDATE")
    protocol.require(plan["expected_registry_blob_sha"] == protocol.git(
        "rev-parse", f"{base}:{registry.REGISTRY}").decode().strip(), "REGISTRY_BLOB_CHANGED")
    registry.text(plan["git_approval_ref"], "GIT_APPROVAL_REFERENCE_REQUIRED")
    for content in plan["files"].values():
        protocol.require(isinstance(content, str) and len(content.encode("utf-8")) <= protocol.LIMIT,
                         "REGISTRATION_CONTENT_SIZE")


def publish(client, plan):
    ensure_workflow(plan["base"])
    validate_plan(plan)
    progress = {"stage": "remote_base", "branch": plan["branch"],
                "branch_creation_attempted": False, "pr_creation_attempted": False}
    try:
        return _publish_prepared(client, plan, progress)
    except (protocol.Invalid, SubmissionError, OSError, ValueError, TypeError, KeyError) as error:
        code = str(error) if isinstance(error, (protocol.Invalid, SubmissionError)) else "REGISTRATION_INPUT_INVALID"
        raise SubmissionError(code, progress) from None


def _publish_prepared(client, plan, progress):
    base = plan["base"]

    def current_main():
        return sha(client.request("GET", "git/ref/heads/main")["object"]["sha"])

    protocol.require(current_main() == base, "PROPOSAL_STALE_BASE")
    progress["stage"] = "open_registration_scan"
    no_pending_registration(client)
    progress["stage"] = "tree_creation"
    commit = client.request("GET", f"git/commits/{base}")
    tree = sha(client.request("POST", "git/trees", {
        "base_tree": sha(commit["tree"]["sha"]),
        "tree": [{"path": path, "mode": "100644", "type": "blob", "content": content}
                 for path, content in plan["files"].items()]})["sha"])
    progress["stage"] = "commit_creation"
    head = sha(client.request("POST", "git/commits", {
        "message": plan["title"] + "\n\n" + plan["body"] + "\n", "tree": tree, "parents": [base]})["sha"])
    progress.update(stage="base_recheck", proposed_head_sha=head)
    protocol.require(current_main() == base, "PROPOSAL_STALE_BASE")
    # Create only. Existing branches are never updated/deleted and force is never used.
    progress.update(stage="branch_creation", branch_creation_attempted=True)
    created = client.request("POST", "git/refs", {"ref": "refs/heads/" + plan["branch"], "sha": head})
    protocol.require(created.get("ref") == "refs/heads/" + plan["branch"]
                     and created.get("object", {}).get("sha") == head, "API_REF_INVALID")
    progress["stage"] = "post_branch_base_recheck"
    protocol.require(current_main() == base, "BASE_CHANGED_BRANCH_RETAINED")
    progress.update(stage="pr_creation", pr_creation_attempted=True)
    pr = client.request("POST", "pulls", {"base": "main", "head": plan["branch"],
                       "title": plan["title"], "body": plan["body"], "draft": True,
                       "maintainer_can_modify": False})
    number = pr.get("number")
    protocol.require(type(number) is int and number > 0, "API_PR_INVALID")
    return {"result": "PENDING_PR_CREATED", "pr_number": number,
            "url": f"https://github.com/{REPOSITORY}/pull/{number}", "head_sha": head,
            "branch": plan["branch"], "reserved": False, "remote_write_performed": True,
            "review_sequence": STEPS, "identity_authenticated": False, "approval_authenticated": False,
            "enforcement_enabled": False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base", "task", "department", "role", "scope", "predecessor", "candidate-ref",
                 "handoff-ref", "git-approval-ref"):
        parser.add_argument("--" + name, required=name not in {"predecessor", "handoff-ref"})
    parser.add_argument("--actor", default="AGT-INF-0001")
    parser.add_argument("--submit", action="store_true")
    args = parser.parse_args()
    try:
        plan = prepare(args.base, args.task, args.department, args.role, args.scope, args.predecessor or None,
                       args.candidate_ref, args.handoff_ref or None, args.git_approval_ref, args.actor)
        if args.submit:
            ensure_workflow(args.base)  # Reject before reading credentials or opening a connection.
            result = publish(GitHub(os.environ.get("AGENT_REGISTRATION_TOKEN")), plan)
        else:
            result = plan
        print(json.dumps(result, ensure_ascii=False))
        return 0
    except (protocol.Invalid, SubmissionError, OSError, ValueError, TypeError, KeyError,
            subprocess.CalledProcessError) as error:
        code = str(error) if isinstance(error, (protocol.Invalid, SubmissionError)) else "REGISTRATION_INPUT_INVALID"
        result = {"result": "DIAGNOSTICS", "diagnostics": [code],
                  "remote_state_requires_review": bool(args.submit)}
        if isinstance(error, SubmissionError) and error.recovery_context is not None:
            result["recovery_context"] = error.recovery_context
        print(json.dumps(result))
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
