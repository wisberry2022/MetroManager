# MetroManager 전체 부서 에이전트 지침

- Owner의 승인 기록, 최신 승인 명세, 승인된 작업 티켓 순으로 근거를 확인한다. DRAFT 문서나 최신 커밋을 승인으로 간주하지 않는다.
- 변경 전에 Git 상태, 기존 파일, Godot 설정과 적용 지침을 조사하고 기존 작업물을 보존한다.
- 작업 티켓의 포함·제외 범위를 준수한다. 기획 규칙과 디자인 의도를 임의로 결정하거나 변경하지 않는다.
- 모호하거나 구현 불가능한 명세, 부서 경계·범위 변경은 `docs/templates/RFC_AND_DECISION.md`에 따라 RFC로 보고한다.
- 작업 결과에는 작업 ID, 변경 파일, 검증 명령과 증거, 미해결 사항, 명세 변경 필요 여부를 기록한다. 자동 테스트, 프로젝트 로드, 게임 플레이, 빌드를 구분하고 미실행은 NOT_RUN으로 표시한다.
- Owner의 명시적 추가 승인 없이 커밋, 원격 푸시, 브랜치 병합, 릴리스 또는 배포를 수행하지 않는다. 완료 보고는 검수 요청이며 공식 승인이나 DONE 처리가 아니다.

운영 규정: `docs/governance/HQ_OPERATING_RULES.md` (문서의 승인 상태를 함께 확인).

## 전 부서·GitHub 플러그인 공통 (DEV-003)

- HQ/기획/디자인/DEV/INF 모두 `docs/engineering/DEPARTMENT_WORKFLOW.md`와 자기 부서 README를 읽는다. ChatGPT 플러그인은 자동 지침 주입/로컬 훅 실행을 보장하지 않으므로 도구로 직접 읽는다.
- 커밋/PR 제목은 `[부서][type] TASK-ID 작업 내용`. 부서는 HQ/기획/디자인/DEV/INF, 티켓은 각각 PM/PLN/DSG/DEV/INF. 빈 줄 뒤 변경 효과·검증 본문을 작성한다.
- 모든 부서는 `codex/<TASK-ID>-<description>` 작업 브랜치에 공유하고 플러그인 쓰기 도구의 branch를 생략하지 않는다. main 직접 수정 금지. DEV-002의 초기 예외는 재사용하지 않는다.
- HQ는 docs/hq/, 기획은 docs/planning/, 디자인은 docs/design/, INF는 docs/infra/ 안에서 작업한다. 타 부서 산출물·개발 소스·CI·도구의 수정/삭제 금지. 개발은 docs/engineering/과 승인된 개발 범위를 담당한다.
- 예외는 Owner 결정에 따른 base 브랜치의 path_exceptions.json 기록으로 제한한다. 본인 브랜치의 예외 추가는 효력이 없다. 실제 부서 사칭은 같은 계정만으로 기술적으로 식별할 수 없음을 인정한다.
- main 병합에는 policy와 department-policy 검사를 확인한다. 원격 보호 설정의 적용 여부와 권한 위임 여부는 별도로 확인한다.

## INF 등록 (DEV-007 검수안)

- INF는 컨텍스트 건전성·세션 연속성·후임 인계 정책과 검증을 담당한다. 게임 규칙·디자인·개발 코드·HQ 일정/Stage 결정은 소관이 아니다.
- INF 티켓은 `docs/infra/tasks/INF-NNN_*.md`, 브랜치는 `codex/INF-NNN-description`, 제목은 `[INF][type] INF-NNN 작업 내용`이다. 개별 Owner 승인 범위에서만 Commit/Push/PR을 수행한다.
- 공개 Git에는 최소화된 진단 상태·근거만 기록한다. 내부 대화 원문·상세 세션 평가는 Owner 제한 보관한다.
- 등록의 원격 적용은 DEV-007의 Owner 검수·main 병합 후다. 초기 README 게시와 실제 INF PR 검증은 `docs/engineering/INF_ONBOARDING.md`를 따른다. 이 문서는 포괄 Git 권한을 부여하지 않는다.

## 코드·Git 운영 (DEV-002)

- 매 작업 시작 시 `docs/engineering/CODE_CONVENTIONS.md`, `docs/engineering/GIT_WORKFLOW.md`와 `docs/engineering/ENFORCEMENT.md`를 직접 읽는다. 실행 중인 채팅도 기억에 의존하지 않고 다시 확인한다.
- Project Leader 및 모든 개발 에이전트에 동일하게 적용한다. 규칙 관리 담당은 Convention Team이며, 게임 아키텍처 판단은 Project Leader의 책임이다.
- 신규 작업은 `codex/<TASK-ID>-<lower-kebab-description>` 브랜치에서 한다. 공유 작업 디렉터리의 브랜치를 다른 채팅 작업 중에 바꾸지 않는다. 필요하면 별도 worktree를 사용한다.
- 작업 전 `python tools/policy.py doctor`, 제출 전 `python tools/policy.py check` 및 관련 테스트를 실행한다. gdtoolkit은 `.venv`의 Python으로 실행한다.
- 커밋·푸시·병합 권한은 각각 Owner의 명시적 승인 범위를 확인한다. 위임이 있다면 대상 저장소·작업·브랜치·허용 동작·기간·금지 사항과 원문 근거를 기록한다. DEV-001의 일회성 승인은 재사용하지 않는다.
- 실패한 검사, 누락된 훅, 미적용 원격 보호를 무시하고 진행하지 않는다. `--no-verify`, 훅 해제, CI 삭제, 강제 푸시로 통과시키지 않는다. 예외는 RFC/Owner 결정으로 관리한다.
- 검사 통과는 승인 또는 DONE이 아니다. 로컬 훅과 AGENTS.md는 보안 경계가 아니며, 원격 강제 적용 상태는 ENFORCEMENT 문서와 실제 원격 설정을 함께 확인한다.
