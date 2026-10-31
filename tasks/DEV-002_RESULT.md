# DEV-002 결과 및 검수 요청

- 일자: 2026-10-31 / 담당: Convention Team / 상태: REVIEW (DONE 아님)
- 착수 근거: 본 채팅 Owner의 코드 컨벤션 결정·운영 및 Git 전략/강제 프로세스 구축 지시.
- 기준 HEAD: `0705d144b75142859d22b4322150d756f797d6de`
- 사전: clean main, origin `https://github.com/wisberry2022/MetroManager.git`, 게임 소스/메인 씬 없음.
- 사후: `codex/DEV-002-repository-policy`, HEAD 동일, 인덱스 변경 없음. commit/push/merge/release 미수행.

## 구현 결과

- Godot 공식 스타일 및 gdtoolkit 4.5.0 기반 코드 규칙, EditorConfig, 검사 환경.
- GitHub Flow 기반 main + 작업 브랜치 + squash PR, 정형 메시지, 승인/위임 구분, 충돌·롤백·예외 처리 규칙.
- AGENTS.md에서 모든 개발 채팅의 필수 읽기/검사 절차 연결. 별도 스킬 설치 없이 공통 진입점 사용.
- pre-commit/commit-msg/pre-push 훅 작성 및 이 저장소 `core.hooksPath=.githooks` 활성화.
- GitHub CI·PR 템플릿·CODEOWNERS 준비. 원격 적용 사양과 RFC 작성.

## 변경 파일

| 파일 | 변경 |
|---|---|
| `.editorconfig` | GDScript/Python/YAML 등 편집 규칙 |
| `.gitignore` | .venv/Python 캐시 제외 |
| `AGENTS.md`, `README.md` | 개발 규칙 진입점 |
| `.githooks/pre-commit`, `commit-msg`, `pre-push` | 로컬 검사 연결 |
| `.github/workflows/policy.yml` | PR policy 검사 |
| `.github/pull_request_template.md`, `.github/CODEOWNERS` | 승인·검증·Owner 리뷰 |
| `tools/policy.py`, `tools/install_hooks.py`, `tools/requirements-dev.txt` | 검사/설치/고정 의존성 |
| `tests/tooling/test_policy.py` | 정상 및 거부/스테이징 분리 회귀 테스트 |
| `docs/engineering/CODE_CONVENTIONS.md` | 코드 규칙 |
| `docs/engineering/GIT_WORKFLOW.md` | Git 규칙·조사 근거 |
| `docs/engineering/ENFORCEMENT.md` | 설치·원격 적용·한계·인수인계 |
| `docs/governance/RFC-0001_REMOTE_ENFORCEMENT.md` | 원격 접근/권한 분리 미해결 사항 |
| `tasks/DEV-002_REPOSITORY_POLICY.md`, `tasks/DEV-002_RESULT.md` | 작업과 결과 |

로컬 전용 변경: `.venv/` 설치, `.git/config` 훅 경로, 작업 브랜치 생성. Git에는 .venv/캐시를 포함하지 않는다. 기존 project.godot, icon 파일, HQ 운영 규정 원문, DEV-001 문서는 보존했다.

## 검증 명령과 증거

| 구분 / 명령 | 결과 |
|---|---|
| `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v` | PASS: 9 tests, 2.939s. 잘못된 브랜치/메시지/티켓, main/tag/삭제/비-fast-forward 거부. 작업 폴더의 정상 코드로 스테이징된 잘못된 코드를 숨길 수 없음 확인 |
| `.venv/Scripts/python.exe tools/policy.py doctor` | PASS: 훅 경로와 gdtoolkit 확인 |
| `.venv/Scripts/python.exe tools/policy.py check` | PASS: 현재 저장소 검사. 실제 게임 GDScript 0개; 테스트에서 정상/비정상 GDScript를 별도로 검증 |
| `.venv/Scripts/python.exe -m pip check` | PASS: No broken requirements found |
| `bash -n .githooks/<hook>` (3개) | PASS: shell 문법 검사 |
| main에서 `policy.py pre-commit` | 예상대로 exit 1: Invalid work branch: main |
| 작업 브랜치에서 `bash .githooks/pre-commit` | 예상대로 exit 1: Missing task document for DEV-002. 새 티켓이 아직 스테이징되지 않았으므로 정확한 거부; 실제 커밋 없음 |
| `git diff --check` | PASS |
| `git diff --exit-code -- project.godot icon.svg icon.svg.import docs/governance/HQ_OPERATING_RULES.md` | PASS: 기존 엔진/아이콘/운영 문서 보존 |
| `git diff --cached --exit-code`, `git rev-parse HEAD` | PASS: 인덱스와 기존 HEAD 보존 |
| 자동 게임 테스트 | NOT_RUN: 게임 코드 없음 |
| Godot 프로젝트 로드 | NOT_RUN: 이번 변경은 개발 도구/문서이며 엔진 파일 변경 없음. DEV-001의 이전 성공을 이번 실행으로 계산하지 않음 |
| 게임 플레이 / Windows 빌드 | NOT_RUN: 기능·씬·빌드 변경 없음 |
| GitHub Actions 실제 실행 / 원격 보호 인수검증 | NOT_RUN: 미커밋·미푸시, 원격 관리 설정 미확인 |

초기 PyPI 접근·훅 설치·임시 Git 테스트·Git Bash는 샌드박스 제한으로 실패했고, 승인된 권한 확장 후 재실행하여 위 결과를 확보했다. 테스트에서 출력된 invalid GDScript 오류는 의도한 거부 사례다.

## 수용 기준 및 미해결

- AC-01~03, AC-05: 로컬 구현·검증 완료, 검수 요청.
- AC-04: 원격 파일/사양 준비 완료. 서버 활성화·실효 검증은 미완료.
- 본 작업의 커밋·작업 브랜치 push 승인이 필요하다. 승인 후 첫 PR CI 결과를 확보하고 ENFORCEMENT 사양으로 main 보호를 적용·검증한다.
- 저장소 플랜·접근 권한·Project Leader의 별도 인증 주체를 확인해야 한다. Owner 계정과 동일한 관리자 권한을 공유하면 완전한 우회 방지는 보장할 수 없다.
- Project Leader 채팅으로 자동 메시지를 보내지 않았다. 다음 작업 시작 시 변경된 AGENTS.md와 문서를 직접 읽도록 연결했다.
- 게임 명세 변경 필요: 없음. 원격 운영/위임은 RFC-0001 결정 필요. HQ DRAFT를 APPROVED로 바꾸거나 포괄 위임을 생성하지 않았다.

## 후속 main 반영 승인 및 검증

위 미커밋/미푸시 기록은 최초 검수 제출 시점이다. 2026-10-31 Owner가 초기 설정이므로 원격 main에 바로 merge하도록 지시했다. DEC-0001에 승인 원문과 일회성 PR/pre-push 예외 범위를 기록했다. 이 결정 파일도 이번 변경에 포함한다.

- 승인 범위: DEV-002를 작업 브랜치에서 단일 커밋한 뒤 main으로 fast-forward 통합하고 origin/main으로 일반 push. 강제 push·릴리스·배포 없음.
- 반영 전 재검증: doctor/check/diff 검사 PASS, 자동 테스트 9개 PASS (2.087s). origin fetch 후 기존 main과 작업 기준 일치 확인.
- 커밋 시 pre-commit/commit-msg 훅 정상 실행. main push에만 DEC-0001의 일회성 `--no-verify` 적용 예정이며 core.hooksPath는 유지한다.
- GitHub Actions는 PR 트리거이므로 이번 main 직접 반영의 원격 실행은 NOT_RUN. 원격 보호 활성화는 미완료 상태를 유지한다.
- 실행 후 최종 SHA와 origin/main 일치 여부는 채팅에 보고한다. 본 승인을 티켓 DONE 또는 향후 포괄 위임으로 확대하지 않는다.
