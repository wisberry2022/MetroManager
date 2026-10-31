# Development Agent 지침

- Owner의 승인 기록, 최신 승인 명세, 승인된 작업 티켓 순으로 근거를 확인한다. DRAFT 문서나 최신 커밋을 승인으로 간주하지 않는다.
- 변경 전에 Git 상태, 기존 파일, Godot 설정과 적용 지침을 조사하고 기존 작업물을 보존한다.
- 작업 티켓의 포함·제외 범위를 준수한다. 기획 규칙과 디자인 의도를 임의로 결정하거나 변경하지 않는다.
- 모호하거나 구현 불가능한 명세, 부서 경계·범위 변경은 `docs/templates/RFC_AND_DECISION.md`에 따라 RFC로 보고한다.
- 작업 결과에는 작업 ID, 변경 파일, 검증 명령과 증거, 미해결 사항, 명세 변경 필요 여부를 기록한다. 자동 테스트, 프로젝트 로드, 게임 플레이, 빌드를 구분하고 미실행은 NOT_RUN으로 표시한다.
- Owner의 명시적 추가 승인 없이 커밋, 원격 푸시, 브랜치 병합, 릴리스 또는 배포를 수행하지 않는다. 완료 보고는 검수 요청이며 공식 승인이나 DONE 처리가 아니다.

운영 규정: `docs/governance/HQ_OPERATING_RULES.md` (문서의 승인 상태를 함께 확인).

## 코드·Git 운영 (DEV-002)

- 매 작업 시작 시 `docs/engineering/CODE_CONVENTIONS.md`, `docs/engineering/GIT_WORKFLOW.md`와 `docs/engineering/ENFORCEMENT.md`를 직접 읽는다. 실행 중인 채팅도 기억에 의존하지 않고 다시 확인한다.
- Project Leader 및 모든 개발 에이전트에 동일하게 적용한다. 규칙 관리 담당은 Convention Team이며, 게임 아키텍처 판단은 Project Leader의 책임이다.
- 신규 작업은 `codex/<TASK-ID>-<lower-kebab-description>` 브랜치에서 한다. 공유 작업 디렉터리의 브랜치를 다른 채팅 작업 중에 바꾸지 않는다. 필요하면 별도 worktree를 사용한다.
- 작업 전 `python tools/policy.py doctor`, 제출 전 `python tools/policy.py check` 및 관련 테스트를 실행한다. gdtoolkit은 `.venv`의 Python으로 실행한다.
- 커밋·푸시·병합 권한은 각각 Owner의 명시적 승인 범위를 확인한다. 위임이 있다면 대상 저장소·작업·브랜치·허용 동작·기간·금지 사항과 원문 근거를 기록한다. DEV-001의 일회성 승인은 재사용하지 않는다.
- 실패한 검사, 누락된 훅, 미적용 원격 보호를 무시하고 진행하지 않는다. `--no-verify`, 훅 해제, CI 삭제, 강제 푸시로 통과시키지 않는다. 예외는 RFC/Owner 결정으로 관리한다.
- 검사 통과는 승인 또는 DONE이 아니다. 로컬 훅과 AGENTS.md는 보안 경계가 아니며, 원격 강제 적용 상태는 ENFORCEMENT 문서와 실제 원격 설정을 함께 확인한다.
