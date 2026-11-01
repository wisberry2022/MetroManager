# DEV-005 — 현황 분석·개발 협업 공간 검수 요청

- 담당: LAPTOP Project Leader / 2026-11-01 (Asia/Seoul) / 상태: REVIEW
- 티켓: [DEV-005](DEV-005_ENVIRONMENT_COLLABORATION.md)
- 기준 SHA: `dc06e48b1dbc7745dcb0a29e424cd0416767ab38`
- 로컬 브랜치: `codex/DEV-005-environment-collaboration`
- 이 문서는 제출 전 기록이다. Owner의 후속 지시로 DEV-005 commit/push/PR 생성 승인. 실제 공유 head SHA·PR URL·최종 CI는 PR 본문과 최종 채팅에 기록한다. main 병합·릴리스·배포는 제외.

## 결과

Gate 1은 승인됐고 Gate 2는 Owner가 전달한 최신 DEV/Design 재검토와 PM-006 HQ 조건부 승인까지 확인됐다. 기획 CLOSE-01~03 보완·APP-01·Owner 최종 결정 대기다. 게임 스크립트·메인 씬·게임 자동 테스트·내보내기 설정은 없다. 상세 근거와 잔여는 [현황 분석](../collaboration/DEV-005_PROJECT_STATUS.md)에 기록했다.

개발 전용 협업 공간에 환경별 기록, 작업 현황, 인계 양식과 실제 최초 인계를 만들었다. DESKTOP 미확인/수신 PENDING, LAPTOP 실측, LOCAL_ONLY/SHARED/ACKNOWLEDGED를 구분하여 다른 PC에서 문서를 확보하기 전부터 인수 완료로 보이지 않게 했다.

## 변경 파일

모든 경로는 `docs/engineering/` 기준이다.

| 파일 | 변경·목적 |
| --- | --- |
| README.md | 협업·현황·티켓/결과 진입 링크 추가 |
| tasks/DEV-005_ENVIRONMENT_COLLABORATION.md | 이번 Owner 지시·범위·수용 기준 기록 |
| tasks/DEV-005_RESULT.md | 결과·검증·미해결 기록 |
| collaboration/README.md | 두 환경의 작업 시작·중복 방지·공유·인수 절차 |
| collaboration/DEV-005_PROJECT_STATUS.md | 승인·구현·Gate 잔여 분석, 원본 인계 RFC |
| collaboration/WORK_STATUS.md | DEV-005 현황 및 DESKTOP 미확인 표시 |
| collaboration/environments/DESKTOP.md | 수신 환경 직접 확인용 기록 |
| collaboration/environments/LAPTOP.md | 랩탑 환경·기준 SHA·검증 현황 |
| collaboration/templates/HANDOFF.md | 재사용 인계·수신 확인 양식 |
| collaboration/handoffs/DEV-005_2026-11-01_LAPTOP_TO_DESKTOP.md | 현재 작업의 최초 인계 준비 |

로컬 준비: `.venv` 생성·고정 requirements 설치, install_hooks.py로 저장소의 core.hooksPath=.githooks 설정. 이는 추적 파일 변경이 아니며 기존 훅/CI/정책 코드·Godot 설정·타 부서 문서를 수정하지 않았다.

## 검증 명령·증거

| 구분 | 명령 / 방법 | 결과 |
| --- | --- | --- |
| Git 기준·기존 작업 | git status --short --branch, git worktree list, git fetch origin, git rev-parse HEAD origin/main | PASS. 시작 main clean/worktree1개, fetch 후 두 SHA=dc06e48b1dbc7745dcb0a29e424cd0416767ab38 |
| 로컬 설치 | python -m venv .venv; .venv/Scripts/python.exe -m pip install -r tools/requirements-dev.txt; python tools/install_hooks.py | PASS. 최초 sandbox ensurepip 실패 후 허용된 권한으로 재실행·설치. 최초 훅 비활성도 설치 후 해소 |
| doctor | .venv/Scripts/python.exe tools/policy.py doctor | PASS. gdtoolkit4.5.0/로컬 훅 확인, 원격 보호는 검사하지 않음 |
| 정책 검사 | .venv/Scripts/python.exe tools/policy.py check | PASS. 최초 sandbox 실행은 파일 검사 출력 후 임시 디렉터리 정리 WinError5로 실패. 허용된 권한의 동일 검사로 재실행 통과. 게임 GDScript0개 |
| 정책 도구 자동 테스트 | .venv/Scripts/python.exe -m unittest discover -s tests/tooling -v | PASS, 19/19. 임시 Git 저장소를 쓰므로 허용된 권한으로 실행. bad_script.gd 파싱 오류는 부정 입력 거부 검증의 예상 출력 |
| 문서 구조·경로 | Python으로 새/수정 문서10개 UTF-8/BOM 없음·LF·마지막 개행·후행 공백, 상대 링크 목적지, 부서 경로·브랜치/티켓 형식 대조 | PASS. 최종 보고 전 실제 검사하여 확인 |
| 기존 원문·공백 | git diff --exit-code dc06e48b1dbc7745dcb0a29e424cd0416767ab38 -- docs/planning docs/design docs/hq project.godot tools tests .github .githooks AGENTS.md; git diff --check | PASS. 보호 대상 추적 파일 변경 없음 |
| 게임 자동 테스트 | 게임 테스트 코드 없음 | NOT_RUN |
| Godot 프로젝트 로드 | 문서 작업, 실행 엔진 경로/버전 미확인 | NOT_RUN |
| 게임 플레이 / Windows 빌드 / 성능 측정 | 각각 실행하지 않음 | NOT_RUN |
| 원격 CI / 현재 보호 설정 | 제출 후 CI 결과는 PR 본문 기록 / branches/main API 확인 | protected=true, 필수 policy/department-policy(App 15368) 확인. 상세 보호 설정 전체 재검증 아님. 제출 전 CI는 PENDING |

문서·정책 검사 성공은 Gate 2 승인, 구현 검증 또는 게임 E2E PASS가 아니다. 테스트 코드는 새로 만들거나 변경하지 않았다.

## 미해결·명세 변경·다음 단계

- RFC-DEV-005-01 ANSWERED: Owner 전달 최신 dc06e48 기준 DEV/Design/PM-006 원문을 확보하고 파일명·해시·판정을 현황 분석에 기록했다. 과거 c0c5f547 기준 3차 원본 자체를 확보한 것은 아니며 구분해 보존한다.
- DESKTOP의 실제 현재 작업·사용 중 DEV ID·도구·엔진 환경과 인수 확인은 미확인이다. DEV-005 번호는 확인 가능한 저장소 범위에서 신규 부여했다.
- 최초 작성은 LOCAL_ONLY였다. 후속 Owner 원문에 따라 이번 작업 브랜치 commit/push/PR로 공유한다. 실제 공유 증거는 PR 본문을 확인하며 DESKTOP 인수 확인은 PENDING이다.
- 이번 변경에 게임 기획·디자인 명세 수정 필요 없음. Gate 2 잔여 세칙/데이터 계약/PC·성능·검수 계획·견적은 기존 후속 항목으로 유지한다.
- 다음 순서: 승인된 DEV-005 커밋·작업 브랜치 push·PR 및 CI 확인 → Owner 검수 → DESKTOP 직접 인수 확인. 기획 보완과 게임 개발은 해당 담당·승인 티켓 범위에서 진행한다.

이번 보고는 검수 요청이며 DEV-005 DONE·공식 운영 규정 승인·Gate 2 최종 승인 처리 요청을 대신하지 않는다.
