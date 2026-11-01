# DEV-014 — Update branch 반복 오류 수정 결과

- Convention Team / 2026-11-01 / REVIEW. Owner 정책·제출 승인 수신, main 병합·운영 검증 대기. DONE 아님.
- 기준 main: `87342cd5c29a3047695c11bfd7f2b76415cdf4d8`.
- 브랜치: `codex/DEV-014-verified-base-sync`, 격리 worktree `.local/worktrees/DEV-014-verified-base-sync`.
- [작업 범위·승인 근거](DEV-014_VERIFIED_BASE_SYNC.md), [정책 조건·RFC-DEV-014-01](../VERIFIED_BASE_SYNC.md).

## 원인과 수정

ERR-20261101-002의 PR #52/#53 실패 로그와 실제 부모를 확인했다. GitHub Update branch가 만든 부모 2개 커밋을 기존 공통 검사기가 일괄 거부했다. DEV-009의 로컬 merge 금지 훅·안내는 원격 UI 동작과 strict 최신성 요구의 충돌을 해소하지 못했다.

`department_policy.range_check`에 검증된 무충돌 base-sync 예외를 구현했다. 첫 부모는 기존 작업, 둘째 부모는 신뢰된 base의 조상이어야 하며, 격리한 Git 내장 merge 결과와 실제 tree가 정확히 같아야 한다. 일반 작업 커밋의 기존 부서·티켓·메시지·경로·모드 검사는 모두 유지한다. 임의 추가 수정·수동 충돌 해결·외부 부모·과거 위반 은닉은 거부한다. 반복 갱신에서도 같은 브랜치·기존 커밋을 보존한다.

두 필수 CI는 기존 공통 검사기를 계속 호출하며 workflow 파일은 변경하지 않았다. 로컬 merge 생성 금지 훅·force push 금지·main squash·strict·Owner 최종 병합 승인도 유지한다. 공통 WORK_STATUS의 과거 기록은 보존하고 병렬 작업의 상태는 개별 티켓/결과·Issue/PR에 기록하도록 안내했다. 실제 내용 충돌은 여전히 검수·대체 PR이 필요하다.

## 변경 파일

| 구분 | 파일 |
| --- | --- |
| 구현·회귀 | `tools/department_policy.py`, `tools/policy.py`, `tests/tooling/test_verified_base_sync.py` |
| 규정·제출 안내 | `AGENTS.md`, `.github/pull_request_template.md`, `docs/engineering/GIT_WORKFLOW.md`, `DEPARTMENT_WORKFLOW.md`, `ENFORCEMENT.md`, `GITHUB_SUBMISSION.md`, `README.md`, `VERIFIED_BASE_SYNC.md` (이하 경로는 docs/engineering 기준) |
| 협업·현황 | `docs/engineering/collaboration/README.md`, `WORK_STATUS.md` (같은 디렉터리) |
| 오류 접수 후속 | `docs/co-work/err-report/ERR-20261101-002_UPDATE_BRANCH_AND_PARALLEL_PR.md`, 같은 디렉터리 `README.md` |
| 티켓·결과 | `docs/engineering/tasks/DEV-014_VERIFIED_BASE_SYNC.md`, `DEV-014_RESULT.md` (같은 디렉터리) |

## 검증 명령·증거

검증은 격리 worktree의 `.venv/Scripts/python.exe`로 실행했다. Windows sandbox 기본 Temp 접근 실패가 있어 승인된 재실행은 TEMP/TMP를 worktree의 `.local/validation-tmp`로 지정했다. 실패를 통과로 간주하거나 검사기를 우회하지 않았다.

| 구분 | 명령·대상 | 결과 |
| --- | --- | --- |
| 자동 테스트 | `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v` | PASS, 기존 49 + 신규 8 = 57 tests |
| 실제 오류 재생 | 당시 base `88496d0c3bcef8d59e76c9977ee6ff07d01339fe`, PR #52 head `42a82c2340a52b0ca8baa863796a46b214c21c1e`, PR #53 head `e4bfed3fb597a32d9f03cc5b9186addc25528f00`를 기존 main 코드와 후보 `range_check`에 입력 | 기존은 각각 Expected single-parent 거부, 후보는 각각 work=1, verified_base_sync=1 PASS |
| 로컬 환경 | `.venv/Scripts/python.exe tools/policy.py doctor` | PASS; 원격 보호 검증을 의미하지 않음 |
| 제출 전 파일 검사 | `.venv/Scripts/python.exe tools/policy.py check` | PASS, worktree files=208, GDScript=15; formatting 15 unchanged, lint success |
| 공백 오류 | `git diff --check` | PASS |
| 원격 보호 확인 | main branch API | protected=true, policy/department-policy 존재 확인. 상세 protection API는 403으로 전체 설정 재확인 불가. 설정 변경 없음 |
| 원격 CI·실제 Update branch | 제출 PR CI는 PR에 기록, 실제 Update branch는 정책 main 반영 후 승인된 시험 PR 필요 | 제출 CI PENDING / 실제 Update branch NOT_RUN. 과거 실패 run을 성공으로 변경한 것이 아님 |
| Godot 프로젝트 로드 | 게임 구현 변경 없음 | NOT_RUN |
| 게임 플레이 | 게임 구현 변경 없음 | NOT_RUN |
| 빌드 | 게임 구현 변경 없음 | NOT_RUN |

신규 회귀는 5개 부서의 두 CI 진입점·preflight·pre-push, 반복 갱신의 이력 보존, 부모/추가 수정/충돌/과거 위반/메시지/심볼릭 링크 거부, 외부 merge driver 미실행 및 원본 refs/status 불변을 검증한다. merge-tree 지원 부족·실패는 허용하지 않는다.

## 미해결·승인 필요

- RFC-DEV-014-01의 제한 동기화 예외와 상태 정본/집계 절차는 Owner가 승인했다. [DEC-DEV-014-01](../VERIFIED_BASE_SYNC.md)의 원문·범위를 따른다. 게임 명세 변경은 불필요하며 Git 운영 규정 변경은 main 반영 대기다.
- Owner 후속 메시지로 DEV-014 commit/push/PR을 승인받아 제출한다. 실제 제출 SHA·PR·CI 결과는 PR과 채팅에 기록한다. main 병합은 미승인이며 진행하지 않는다.
- base-only 검사기의 신뢰 경계상 후보가 main에 반영되기 전에는 기존 PR에서 이 예외를 사용할 수 없다. 제출 PR 자체는 기존 단일 부모 규칙을 준수해야 한다.
- 정책 반영 후 실제 GitHub Update branch·두 CI·기존 PR 번호/head 보존 검증이 남았다. ERR-002는 OPEN 유지하며 RFC-DEV-014-01은 ANSWERED로 기록한다.
- 향후 provenance ENFORCE 도입 전 sync metadata/Manifest 기준 정합화를 협의해야 한다. 현재 독립 REPORT_ONLY 기능은 변경하지 않았다.
- 기본 checkout과 Project Leader의 작업물은 변경하지 않았다. 승인된 작업 브랜치 제출만 수행하며 main·보호 설정 변경·공유 이력 재작성은 하지 않는다.
