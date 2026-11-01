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

## 후속 환경 정보 정정 — 2026-11-01 / REVIEW

- 근거: 이번 채팅에서 Owner가 프로젝트 상위 Godot 실행 폴더 및 디자인 작업용 Pixelorama clone을 안내하고 LAPTOP.md 정정을 요청함.
- 작업 기준: DEV-005 / HEAD=37e660f5788b1c29a48ae8720c3d14396cc897a6, fetch 후 원격 DEV-005 head 일치.
- 변경 파일: collaboration/environments/LAPTOP.md, collaboration/DEV-005_PROJECT_STATUS.md, 본 보고서. Godot 경로·실제 버전·Pixelorama 소스 위치와 버전 확인 범위를 기록하고 최초 PATH 기반 미확인 표현을 정정.
- 증거: `../godot/Godot_v4.7.2-stable_win64_console.exe --headless --version` → `4.7.2.stable.official.ed1daf0bf` (PASS). GUI/콘솔 실행 파일 모두 존재.
- Pixelorama: `git -C ../Pixelorama status --short --branch` → master...origin/master, clean. HEAD=`fae9327992f1506f340b920e0fa6515a88298079`, origin=`https://github.com/Orama-Interactive/Pixelorama.git`, describe=`v1.2.3-64-gfae93279`. project.godot에는 v1.2.4-rc2/4.7 표기. 버전 태그와 소스 설정값을 구분.
- 최초 sandbox의 상위 Pixelorama Git 접근은 Permission denied. 허용된 권한으로 동일 읽기 검사를 재실행해 위 결과 확인. 도구·별도 저장소 수정 없음.
- doctor / `.venv/Scripts/python.exe tools/policy.py check` / `git diff --check` PASS. 변경 문서 3개 UTF-8·LF·개행·상대 링크 검사 PASS. 게임/도구 자동 테스트 재실행은 NOT_RUN(환경 기록 정정만 수행).
- MetroManager 및 Pixelorama 프로젝트 로드·플레이·빌드·디자인 에셋 제작: 각각 NOT_RUN. 버전 명령 실행과 구분.
- 미해결: 실제 프로젝트 로드·Pixelorama 사용 검증은 미실행. 명세 변경 필요 없음.
- 최초 정정은 미커밋 상태였으며, 후속 Owner 지시로 이번 정정의 commit/작업 브랜치 공유/PR 제출이 승인됐다. PR #13 병합 완료를 확인해 별도 후속 PR로 제출한다. main 병합·릴리스 승인 없음.

### 환경 정정 후속 PR 제출 승인·검증

- Owner 원문(이번 채팅, 2026-11-01): “개발 에이전트. 수정본을 PR 생성해주세요 현재 소스트리 확인 시 아직 미커밋 파일이 3개가 남아있습니다”
- 허용: DEV-005 환경 정정 3개 파일의 commit/작업 브랜치 공유/PR 생성·CI 확인. 대상 wisberry2022/MetroManager, 브랜치 codex/DEV-005-laptop-environment-correction. 이번 제출까지 유효하며 main 병합·강제 push·릴리스 제외.
- 제출 기준: 최신 main e5b61f2457b1930a5e0f0e2e1d3f705dd42ed93d. 기존 PR #13은 병합 완료, 미커밋 변경을 보존한 채 최신 main에서 후속 브랜치 생성.
- 제출 방식: 앞선 Git HTTPS 인증 실패가 확인되어 연결된 GitHub API의 base tree 보존·단일 부모 commit·새 작업 브랜치 방식 사용. 로컬 커밋의 검사 통과 및 API 제출 트리 동일성을 확인하고 제출 뒤 원격 head로 로컬을 맞춘다. 정확한 SHA·PR URL·CI는 후속 PR 본문에 기록한다.
- 검사: doctor / policy check / 문서 3개 UTF-8·LF·개행·공백·상대 링크 및 diff 검사 PASS. 문서 전용 변경으로 게임/도구 자동 테스트 재실행 NOT_RUN. 원격 policy/department-policy 결과는 제출 후 실제 확인한다.
- Godot 버전 명령 PASS는 이전 정정 시 직접 확인한 증거이며 이번 제출에서 다시 프로젝트를 열거나 Pixelorama를 실행하지 않음. Godot 로드·게임 플레이·빌드·성능·디자인 도구 사용은 각각 NOT_RUN.
- 문서의 최초 현황 분석은 dc06e48 시점 스냅샷이다. 이번 main에는 Gate 2 최종 승인(PLN-001_GATE2_FINAL_APPROVAL.md)과 Gate 3 운영 문서가 추가됐음을 확인했다. 이번 PR은 환경 정보 정정에 한정하며 Gate 3 분석·구현을 착수하지 않는다.
