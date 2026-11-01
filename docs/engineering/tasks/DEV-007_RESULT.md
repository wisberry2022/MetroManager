# DEV-007 — INF 부서 등록 검수 보고

- 담당: Convention Team / LAPTOP / 2026-11-01 / 상태: REVIEW. 공식 승인·DONE 아님.
- 기준 main: `06d6a28071c037d6b4ef9a745032ba650e985c57`.
- 작업 브랜치: `codex/DEV-007-infra-department-registration` / Git 제출 SHA: PENDING.
- 승인 근거·범위: [티켓](DEV-007_INF_DEPARTMENT_REGISTRATION.md). 첨부 문서는 요청/제안으로 읽었으며 INF의 권한 설명을 이번 DEV의 commit/push/merge 승인으로 사용하지 않았다.

## 변경 효과와 파일

INF를 `INF-NNN` / `[INF][type]` / `codex/INF-NNN-description` / `docs/infra/`에 매핑했다. 기존 부서와 동일한 본문·티켓·경로·이력 검사를 재사용한다. 승인 진위·Git 인증은 검사기에서 만들어내지 않는다.

| 파일 | 변경 |
| --- | --- |
| tools/department_policy.py | 부서 매핑, TASK·SUBJECT의 INF 인식. BRANCH·ticket/path 검사는 기존 공통 로직 재사용 |
| tests/tooling/test_department_policy.py | INF 정상/부정 메시지·티켓·경로, 격리 Git 객체의 양쪽 CI 진입점, main ref 거부, DEV의 INF 경로 쓰기 거부 |
| tests/tooling/test_policy.py | INF 정상 작업 브랜치 push, main/tag/삭제/비 fast-forward 거부 |
| AGENTS.md | INF 소관·티켓·공개 정보 최소화·적용 경계 |
| README.md | INF 공통 규정 진입 안내 |
| docs/engineering/DEPARTMENT_WORKFLOW.md | INF 매핑·경로·업무·권한 경계 |
| docs/engineering/GIT_WORKFLOW.md | INF 티켓·메시지·기존 Git 절차 연결 |
| docs/engineering/ENFORCEMENT.md | base 검사기를 보존하는 2단계 등록 절차 |
| docs/engineering/README.md | INF 등록 안내 링크 |
| .github/CODEOWNERS | INF 경로의 기존 Owner 검토 담당 명시, 쓰기 ACL이 아님 |
| docs/engineering/INF_ONBOARDING.md | 초기 INF README 게시 원본, 별도 INF 티켓/PR/검증 절차, RFC-DEV-007-01 |
| docs/engineering/tasks/DEV-007_INF_DEPARTMENT_REGISTRATION.md | 요청 원문·승인 경계·포함/제외·수용 기준 |
| docs/engineering/tasks/DEV-007_RESULT.md | 본 검수 결과 |

`tools/policy.py`, 두 CI 워크플로, 로컬 훅, path_exceptions, 게임 소스·Godot 설정·타 부서 산출물은 변경하지 않았다. DEV의 INF 디렉터리 쓰기를 새로 허용하지 않는다.

## 검증 명령과 실제 증거

- `git status --short --branch`, `git worktree list`: 시작 clean main, worktree 1개. 종료 시 DEV-007 작업 브랜치에 이번 변경만 존재.
- `git fetch origin`: 최초 sandbox의 .git/FETCH_HEAD 쓰기 거부 후 해당 read/sync 작업 권한으로 재실행 PASS. fetch 후 main=origin/main, 기준 SHA 동일. 추가 sandbox ls-remote는 네트워크 오류로 실패하여 새 증거로 사용하지 않음.
- `python tools/policy.py doctor`: 시스템 Python에 gdtoolkit 메타데이터가 없어 FAIL. 규정대로 `.venv/Scripts/python.exe tools/policy.py doctor` 재실행 PASS.
- `.venv/Scripts/python.exe tools/policy.py check`: PASS, 최종 files=105 / GDScript=0.
- `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v`: PASS, 23 tests. 기존 19개에 INF 회귀 4개를 추가. 최초 신규 fixture event.json의 마지막 개행 누락으로 1개 오류가 발생했고 fixture 개행 수정 후 전체 PASS. 부정 GDScript의 파서 오류 출력은 기존 거부 테스트의 예상 결과.
- 격리 Git 객체 기반 INF PR: 승인된 코드의 `department_policy.main()`·`policy.main(ci)` 모두 정상 통과; main ref와 타 부서 파일은 거부. 실제 GitHub PR 성공으로 표현하지 않는다.
- origin/main 검사기 자체로 DEV-007 변경 경로·작업 브랜치·티켓·제안 메시지 검증: PASS. 스테이징이나 프로젝트 커밋 없이 로컬 diff/파일 목록과 기존 main 코드를 대조.
- `git diff --check`: PASS.
- GitHub 연결 `get_repo`: PASS, 공개 저장소·연결 주체 push/admin 권한, squash=true, merge/rebase/auto-merge=false 확인. 실제 권한 보유는 정책상 실행 승인과 다르며 인증 주체 추가나 설정 변경은 하지 않음.
- 서버 main 보호 상세·필수 검사 설정 재실측: NOT_RUN. doctor/get_repo로 확인되지 않는 항목이며 실제 PR 제출 때 확인 필요.
- 실제 DEV PR/원격 CI·정상 INF PR/원격 CI: NOT_RUN, DEV 제출 승인 및 등록 main 반영 후 순서대로 검증 필요.
- 자동 게임 테스트 / Godot 프로젝트 로드 / 게임 플레이 / Windows 빌드: NOT_RUN. 게임 코드·설정 변경 없음.

검사 시 프로세스 TMP/TEMP를 쓰기 허용된 세션 시각화 디렉터리로 지정했다. 테스트 임시 Git 저장소는 해당 경로에서만 만들며 현재 프로젝트의 commit/push를 수행하지 않는다.

## 미해결·후속·명세 영향

1. Owner가 현재 채팅에서 "PR 생성해주세요"로 이번 commit·일반 push·PR 제출을 승인했다. 승인 원문·범위는 티켓의 후속 Git 제출 승인에 기록했다. 실제 PR/head SHA·필수 CI 결과는 제출 후 PR 본문과 채팅에 남긴다. main 병합은 별도 Owner 승인 대상이며 INF가 main의 등록 정책을 사용할 수 있는 상태는 아직 아니다.
2. `department-policy`는 base 코드만 실행하므로 등록이 main에 반영된 뒤 INF의 별도 승인 티켓에서 정상 INF PR을 검증한다. 초기 `docs/infra/README.md` 원본은 INF_ONBOARDING에 준비했으며, INF가 자기 티켓과 함께 게시한다. 현 base가 DEV의 INF 경로 쓰기를 거부하므로 같은 DEV PR에 직접 넣지 않았다.
3. 기존 HQ 초기 ZIP과의 중복 정리는 원본 위치·버전·승인 상태 미확보. RFC-DEV-007-01 OPEN으로 HQ/INF에 대조를 인계하며 타 부서 문서 이동·삭제는 하지 않는다.
4. 공통 정책 문서 변경은 Owner 검수 필요. 게임 기획/디자인 명세 변경 필요 없음. 동일 계정의 실제 부서 식별·독립 리뷰 한계는 유지된다.

제안 제출 제목: `[DEV][chore] DEV-007 INF 부서 Git 정책을 등록합니다`.

제안 커밋/PR 본문: INF의 티켓·메시지·작업 경로를 공통 Git 정책에 등록하고 기존 부서 경계와 보호 ref 제한을 유지합니다. 정책 검사 및 23개 테스트를 통과했으며 실제 원격 INF PR 검증은 등록 main 반영 후 수행합니다. Owner의 이번 제출 승인 원문·허용 범위는 티켓의 후속 Git 제출 승인에 기록했습니다.

## PR 제출 시 재확인

- fetch 후 HEAD=origin/main=`06d6a28071c037d6b4ef9a745032ba650e985c57`, 작업 경로 13개 유지.
- `.venv/Scripts/python.exe tools/policy.py doctor`: PASS.
- GitHub 플러그인의 main 보호 상세 API 읽기: 403 Resource not accessible by integration. 보호가 없는 것으로 해석하지 않으며 설정을 변경하지 않았다. branch 조회와 실제 PR 필수 검사 결과를 별도로 확인한다.
- main branch API 읽기: PASS, protected=true, 필수 policy/department-policy, 각각 GitHub Actions App 15368 바인딩 확인. 상세 보호 전체 설정의 재검증은 아님.
