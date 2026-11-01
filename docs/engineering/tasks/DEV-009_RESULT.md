# DEV-009 — GitHub merge 오류 재발 예방 검수 보고

- 담당: Convention Team / LAPTOP / 2026-11-01 / 상태: REVIEW, 공식 승인·DONE 아님.
- 근거: [티켓](DEV-009_GITHUB_MERGE_PREVENTION.md), ERR-20261101-001 및 Owner의 재발 방지·PR 생성 직접 요청.
- 기준 main: `ac04302f2bdab75aab49f0950bce92f115ec8047`.
- 브랜치: `codex/DEV-009-github-merge-prevention`. 실제 제출 head SHA·PR·최종 CI는 제출 후 PR 본문과 채팅에 기록.

## 확인과 변경 효과

오류 보고서는 원래 Draft #37의 병합이 아니라 대체 PR #40으로 main에 들어갔다. 기획 본문 복구 #36, 공용 보고 정책 #39도 main 반영을 확인했다. 원래 보고서의 PENDING은 당시 기록으로 보존하고 Convention 후속 사실을 덧붙였다. Issue #38은 OPEN이며 임의 종료하지 않는다.

직접 원인은 작업 이력의 부모 2개 merge commit이다. 실제 UI 클릭/주체와 디자인 브랜치 삭제의 인과는 미확인이다. 기존 사후 CI 거부는 유지하고 로컬 생성/제출 단계에 예방을 추가했다.

- pre-merge-commit은 자동 merge commit 생성을 거부한다. pre-commit과 commit-msg는 MERGE_HEAD가 남은 수동 커밋도 거부한다. 파일·진행 중 merge는 자동 폐기하지 않는다.
- `policy.py preflight`는 커밋된 현재 작업 브랜치가 fetch된 origin/main을 포함하는지와 기존 커밋·티켓·부서·경로를 읽기만 하여 검사한다. pre-push에도 같은 제출 검사를 연결했다. 뒤처진 공유 브랜치는 새 브랜치·대체 PR로 복구한다.
- 플러그인/API는 로컬 훅 미실행이므로 별도의 원격 main/head/expected SHA·단일 부모·티켓/경로 대조와 두 CI 확인 절차를 문서·AGENTS·PR 템플릿에 연결했다.

## 변경 파일

| 파일 | 변경 |
| --- | --- |
| tools/policy.py | merge 상태·제출 사전 검사, preflight 명령, pre-push 연결, doctor 새 훅 점검 |
| tools/install_hooks.py | 기존 커스텀 pre-merge-commit 충돌도 보존하며 설치 중단 |
| .githooks/pre-merge-commit | 자동 로컬 merge commit 거부 |
| tests/tooling/test_git_prevention.py | 실제 훅·수동 커밋·5부서 정상/읽기 전용·뒤처진 main·기존 이력 검사·커스텀 훅 보존 7개 |
| AGENTS.md | 전 부서 API/UI merge 금지·제출 사전 확인 진입점 |
| .github/pull_request_template.md | base/head SHA·로컬/API 사전 확인·대체 관계 항목 |
| docs/engineering/DEPARTMENT_WORKFLOW.md | API 갱신 전 원격 대조 |
| docs/engineering/GIT_WORKFLOW.md | 새 훅·preflight·pre-push 절차 |
| docs/engineering/ENFORCEMENT.md | 설치·차단 범위·한계 |
| docs/engineering/README.md | 제출 안내 링크 |
| docs/engineering/GITHUB_SUBMISSION.md | Git/API/UI 제출·재제출 절차·공식 문서 근거 |
| docs/engineering/tasks/DEV-009_GITHUB_MERGE_PREVENTION.md | 직접 요청·제출 승인 범위·수용 기준 |
| docs/engineering/tasks/DEV-009_RESULT.md | 본 결과 |
| docs/co-work/err-report/ERR-20261101-001_PR35_BRANCH_UPDATE.md | 최초 증거 보존, Convention 후속 사실/예방 검수 상태 추가 |
| docs/co-work/err-report/README.md | 경로·보고서 반영 사실과 예방 후속 구분 |

두 CI 워크플로·department_policy.py·원격 보호 설정·예외 목록·다른 부서 전용 산출물·게임 소스/Godot 설정은 수정하지 않았다. 공유 DEV-006와 이전 DEV-008 worktree를 보존했다.

## 검증 명령과 증거

- `git fetch origin`, `git status --short --branch`, `git worktree list`: 시작 root clean DEV-006, 원격 main 기준 확인 후 별도 DEV-009 worktree 생성. 중복 DEV-009 문서/브랜치 없음, 미공유 예약 UNKNOWN.
- worktree `.venv` 생성 및 `-m pip install -r tools/requirements-dev.txt`: PASS, 고정 도구 설치. 의존성 버전 규정 변경 없음.
- `.venv/Scripts/python.exe tools/install_hooks.py`, `tools/policy.py doctor`: PASS. 기존 core.hooksPath=.githooks 유지. 새 훅은 Git 실행 비트도 함께 제출한다.
- `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v`: PASS, 37 tests / 42.271s. 기존 30개 + 신규 7개. Windows의 실제 shell 훅 실행을 위해 허용된 실행 환경에서 격리 임시 Git 저장소를 사용. 현재 프로젝트의 merge/강제 push를 시험하지 않았다.
- 실제 임시 `git merge --no-edit main`과 후속 `git commit`: 예상 거부, HEAD 불변·MERGE_HEAD 유지. 저장소 내용 자동 폐기 없음. 5개 부서 preflight 정상·전후 ref/status 동일, 오래된 base의 preflight/pre-push·merge 부모2·타 티켓·main branch 거부, 기존 커스텀 merge 훅 보존 확인.
- `.venv/Scripts/python.exe tools/policy.py check`: PASS. `git diff --check`: PASS.
- 현재 origin/main 검사기로 DEV-009 경로·브랜치·티켓·제안 메시지 대조 및 변경 파일 UTF-8/LF/개행·새 상대 링크: PASS.
- 실제 제출의 정상 커밋 훅·커밋 후 preflight·일반 push·head SHA·원격 CI는 PR 본문/채팅에 후속 기록한다. 결과를 얻기 전 PASS로 간주하지 않는다.
- GitHub 저장소 API: allow_update_branch=false, squash=true, merge/rebase merge/auto-merge=false 확인. 설정을 바꾸지 않았다. main 보호와 두 필수 검사는 제출 시 branch API로 재확인한다. 상세 보호 전체 설정의 재실측은 NOT_RUN.
- [공식 Git 훅](https://git-scm.com/docs/githooks) 및 [GitHub 갱신 제안 설정](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-suggestions-to-update-pull-request-branches) 직접 확인. 실제 UI 클릭 재현/실패 시험 PR: NOT_RUN.
- 자동 게임 테스트 / Godot 프로젝트 로드 / 게임 플레이 / Windows 빌드 / 성능·사용성·VP: 각각 NOT_RUN. 게임 소스·설정 변경 없음.

## 한계·미해결·명세 영향

로컬 preflight는 fetch된 ref와 커밋만 확인하고 네트워크 fetch·미커밋 파일 검사·CI·Owner 승인 판정을 하지 않는다. 검사 뒤 main 진전 경합은 기존 strict 검사/검수로 다시 확인한다. 새 훅은 각 clone/worktree에서 install_hooks.py를 다시 실행해야 적용된다.

API/UI는 로컬 훅을 호출하지 않으며 같은 관리자 계정의 작업 브랜치 merge 생성 자체를 이 변경이 서버에서 차단하지 않는다. allow_update_branch=false만으로 버튼이 항상 제거된다고 보고하지 않는다. 보호를 완화하지 않고 사전 대조·운영 절차와 기존 main 필수 CI/Owner 검수를 유지한다. 최종 기술적 신원·권한 분리의 기존 한계는 남는다.

게임 기획/디자인 명세 변경 필요 없음. 공통 제출 절차/훅은 Owner 검수 대상이며 main 병합·릴리스는 이번 승인 범위 밖이다. Issue #38 종료나 다른 채팅 통지는 하지 않는다. 구현과 PR 제출은 재발 방지 검수 요청이며 공식 DONE이 아니다.
