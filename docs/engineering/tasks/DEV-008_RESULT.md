# DEV-008 — PR #37 선행 정책 조치 검수 보고

- Convention Team / LAPTOP / 2026-11-01 / REVIEW. 공식 승인·DONE 아님.
- 작업: [DEV-008 티켓](DEV-008_SHARED_ERROR_REPORT_POLICY.md), 관련 [PR #37](https://github.com/wisberry2022/MetroManager/pull/37) / [Issue #38](https://github.com/wisberry2022/MetroManager/issues/38).
- 기준 main: `5933f7885fc0b975b74fd81c137982d2a9adff0b`.
- 브랜치: `codex/DEV-008-shared-error-report-policy`, 최초 LOCAL_ONLY → 승인된 Git 제출 진행. 실제 commit/PR SHA·CI 결과는 PR 본문과 채팅에 기록.

## 원인과 수정 결과

PR #37의 기획 티켓·단일 부모는 유효하지만 기존 검사기에 공용 `docs/co-work/err-report/` 허용 규칙이 없어 두 CI가 실패했다. 원격 job `124808050665` 원문과 실제 head `a9bfb82f814de8830bdb7db4269e17c0a5d88fed`의 로컬 검사에서 같은 경로 거부를 확인했다. 이는 PR #35의 merge commit 부모 2개 오류와 별개다.

모든 기존 부서에 공용 직속 Markdown 보고서 `ERR-YYYYMMDD-NNN_요약.md`와 `README.md`만 허용했다. 자기 부서 티켓·제목·브랜치·승인 범위는 유지한다. 다른 공용 경로·코드/설정·하위 디렉터리·타 부서 산출물 권한을 추가하지 않는다. 단일 부모 오류에는 최신 main의 새 작업 브랜치·대체 PR·강제 push 금지 복구 안내를 추가했고 거부 조건은 유지했다.

## 변경 파일

| 경로 | 변경 |
| --- | --- |
| tools/department_policy.py | 한정된 공용 보고 파일 인식, 단일 부모 오류 복구 안내 |
| tests/tooling/test_shared_reports.py | 5개 부서의 양쪽 CI/스테이징 정상 경로, 티켓·부서·공유 범위·중간 위반·symlink/submodule·merge 거부 회귀 7개 |
| AGENTS.md | 공용 오류 보고 진입 지침 |
| docs/engineering/DEPARTMENT_WORKFLOW.md | 기존 부서 티켓을 유지하는 공용 경로 범위 |
| docs/engineering/GIT_WORKFLOW.md | merge 방식 Update branch 금지 및 대체 PR 복구 절차 |
| docs/engineering/ENFORCEMENT.md | base 정책 선행 반영 및 PR #37 재제출 조건 |
| docs/engineering/README.md | 공용 오류 보고 안내 링크 |
| docs/engineering/SHARED_ERROR_REPORTS.md | 근거·보고 항목·Owner 검수/병합 후 기획 대체 PR 순서 |
| .github/CODEOWNERS | 공용 보고 경로의 기존 Owner 검토 담당 명시 |
| docs/engineering/tasks/DEV-008_SHARED_ERROR_REPORT_POLICY.md | Owner 직접 요청·범위·수용 기준 |
| docs/engineering/tasks/DEV-008_RESULT.md | 본 결과 |

기획 PR #37의 3개 파일, 두 CI 워크플로, policy.py, 로컬 훅, path_exceptions, 게임 소스/Godot 설정/타 부서 산출물은 수정하지 않았다. 기존 DEV-006 작업 루트도 변경하지 않았다.

## 검증 명령과 증거

실행 위치는 전용 worktree이며 검사 Python은 기존 checkout의 `.venv` 고정 도구를 직접 사용했다. 아래 `../../../.venv/Scripts/python.exe`는 해당 원본 interpreter다. worktree의 자체 `.venv`/커밋 훅 실행은 아직 준비·실행하지 않았으며 Git 제출 시 별도 확인한다. 프로세스 TMP/TEMP만 쓰기 허용된 세션 시각화 경로로 지정했다.

- `git status --short --branch`, `git worktree list`: 원래 공유 루트는 clean DEV-006, HEAD `ea9d107`; 브랜치 변경 없이 전용 DEV-008 worktree 생성. fetch 후 origin/main은 위 기준 SHA.
- `../../../.venv/Scripts/python.exe tools/policy.py doctor`: PASS, 공유 config의 hooksPath=.githooks와 핀 도구 확인. 원격 보호 검증이나 새 worktree 훅의 전체 실행 증거는 아님.
- `../../../.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v`: PASS, 30 tests / 19.343s. 기존 23개와 신규 7개. 최초 신규 fixture에서 commit-tree가 HEAD를 갱신하지 않은 상태의 rm/스테이징 오류가 있어 fixture만 수정 후 전체 PASS. 기존 부정 GDScript 파서 오류 출력은 예상 거부 결과.
- 실제 PR #37: 기존 main 검사기의 `range_check(current_main, actual_head, PLN-003)`로 거부 재현. 후보 검사기의 같은 호출은 PASS, 단일 기획 커밋 1개.
- PR #37 실제 tree/head를 임시 독립 Git 저장소에 펼치고 후보 코드의 `department_policy.main()` 및 `policy.main(ci)` 진입점을 실행: 모두 PASS, worktree files=134 / GDScript=0. 원본 tree 변경이나 PR 코드 실행 없이 후보 검사기로 데이터 검증. 첫 로컬 clone은 Windows sandbox/MSYS 실행 오류, 대체 objects 참조는 최초 CRLF 경로 오류가 있었고 LF로 수정 후 검증 PASS.
- 실제 PR #35 merge SHA에 후보 `range_check` 실행: Expected single-parent work commit 거부 유지 및 복구 안내 확인.
- `../../../.venv/Scripts/python.exe tools/policy.py check`, `git diff --check`: PASS.
- 현재 origin/main 코드로 DEV-008 작업 브랜치·티켓·제안 커밋 형식·변경 경로 대조: PASS. 이 DEV 변경의 파일 경로는 기존 base 규칙에서도 허용되며 자기 예외를 추가하지 않았다.
- 변경 파일 UTF-8(BOM 없음)·LF·마지막 개행 및 새 문서 상대 링크: PASS.
- GitHub main branch API: protected=true, policy/department-policy 필수, Actions App 15368 바인딩. 상세 보호 전체 설정 재검증은 NOT_RUN, 서버 설정 변경 없음.
- 신규 DEV 원격 PR·CI / 정책 반영 후 기획 대체 PR 원격 CI: NOT_RUN. 현재 로컬 통과를 원격 해결로 표시하지 않는다.
- 자동 게임 테스트 / Godot 프로젝트 로드 / 게임 플레이 / Windows 빌드 / UI 클릭 재현: 각각 NOT_RUN. 게임 코드·설정 변경 없음.

## 미해결·제출·인수

1. Owner의 조사·수정 요청으로 로컬 선조치를 완료했고, 이어 현재 채팅의 "PR 생성해주세요"로 이번 DEV-008 commit·일반 push·선행 PR 제출·CI 확인이 승인됐다. 범위와 종료 조건은 티켓의 후속 Git 제출 승인에 기록했다. main 병합 승인은 별도이며 DEV-007의 과거 승인을 재사용하지 않았다.
2. DEV-008을 승인된 작업 브랜치 PR로 제출해 양쪽 CI 확인→Owner 검수·별도 main 병합 승인→기획이 당시 최신 main의 새 PLN-003 브랜치로 원본 보고 파일 3개 재제출→두 원격 CI 확인 순서다. 정책의 base 반영 전 PR #37은 계속 차단된다.
3. 기획 PR의 Draft 해제·내용 변경·기존 PR 종료·Issue #38 종료·타 채팅 메시지 전송은 하지 않았다. 단순 재실행이 최신 base를 쓰거나 단일 부모 규칙을 해소한다고 가정하지 않는다.
4. 공유 경로의 내용 승인·타 부서 보고서 수정·ID 중복은 티켓/리뷰로 확인한다. 검사기는 실제 부서 신원이나 승인 진위를 보장하지 않는다.
5. 게임 기획/디자인 명세 변경 필요 없음. 공통 경로 정책 및 GitHub UI 복구 안내 변경은 Owner 검수 대상이며 로컬 구현을 공식 승인/DONE으로 표시하지 않는다.

제안 제목: `[DEV][fix] DEV-008 공용 오류 보고 경로의 부서 검사를 정합화합니다`.

## 승인된 PR 제출 준비

- fetch 재확인: 작업 기준 HEAD=origin/main=`5933f7885fc0b975b74fd81c137982d2a9adff0b`.
- worktree 자체 `.venv` 생성·고정 requirements 설치: PASS. 해당 `.venv/Scripts/python.exe`로 doctor/check PASS, unittest 30 tests PASS(29.532s). hooksPath=.githooks는 기존 공유 설정을 보존했으며 검사/훅 우회 없이 커밋한다. 앞선 로컬 검증에서 원본 `.venv`를 쓴 사실은 그대로 유지한다.
- 제출 전 main branch API 재확인: 기준 SHA 동일, protected=true, 필수 policy/department-policy와 Actions App 15368 바인딩 유지.
- 실제 제출 head SHA·PR 링크·최종 CI는 제출 후 PR 본문과 채팅에 기록한다. main 반영 또는 기획 후속 PR 완료를 주장하지 않는다.
