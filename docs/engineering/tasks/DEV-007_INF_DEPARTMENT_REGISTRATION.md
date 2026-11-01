# DEV-007 — INF 부서 Git 정책 등록

- 담당: Convention Team / LAPTOP / 2026-11-01
- 상태: REVIEW — 이번 직접 요청에 따른 구현·검수 제출, DONE 아님.
- 착수 승인자·근거: Owner의 현재 채팅 직접 요청. 첨부 문서는 요청/제안이며 독립 승인 원문으로 취급하지 않는다.

> 컨벤션 팀. 첫번째 임무입니다. 해당 md 파일을 읽고 인프라 에이전트가 추후 원격 저장소에 접근하여 현재 프로젝트의 Git 푸쉬 룰을 준수하여 원격 저장소에 쓸 수 있도록 작업해주세요

## 기준·범위·권한

- 기준 main: `06d6a28071c037d6b4ef9a745032ba650e985c57`. 작업 전 fetch 성공, HEAD=origin/main, clean. 공유 worktree 1개. DEV-006은 PM-008-DEV 제안 ID이므로 피하고 fetch 후 추적 브랜치·문서에서 DEV-007 미사용 확인. 미공유 예약은 UNKNOWN.
- 브랜치: `codex/DEV-007-infra-department-registration`.
- 입력: Owner 제공 `INF_DEPARTMENT_REGISTRATION_REQUEST.md`; 개인 경로·문서 전체는 공개 저장소에 복사하지 않는다.
- 규정: AGENTS.md, CODE_CONVENTIONS, GIT_WORKFLOW v1.1, ENFORCEMENT v1.1, DEPARTMENT_WORKFLOW v1.0, 개발 README, GOV-001 DRAFT의 승인 운영 원칙, DEC-0002, PM-008 A안, RFC/DEC 양식 직접 확인.
- 포함: INF 티켓/부서/경로/브랜치/메시지 인식, 기존 부서 경계 보존, 회귀 테스트, 공통 문서·CODEOWNERS·INF README 게시 원본과 2단계 적용 절차.
- 제외: 게임 코드·기획·디자인·HQ 산출물 수정, 실제 INF 진단 정책 작성, HQ ZIP 이동/삭제, 인증 주체·서버 보호 변경, main 직접 쓰기·병합·릴리스·배포.
- 이번 요청은 구현 근거다. 저장소 규정에 따라 실제 commit/push/PR 제출 승인은 검수 결과와 함께 별도 확인한다. 첨부의 INF 권한 설명을 Convention Team의 Git 권한으로 전용하지 않는다.
- 영향: L2, INF 인터페이스·공통 검사 변경. 게임 명세 영향 없음.

## 수용 기준

1. `codex/INF-NNN-description`, `[INF][type] INF-NNN 요약`, 본문·티켓 필수 규칙을 인식한다.
2. INF는 `docs/infra/`만 수정하고 기존 부서의 경로·메시지·main/tag/삭제/비선형 이력 제한을 유지한다. DEV의 INF 경로 쓰기도 허용하지 않는다.
3. 정상 INF PR의 양쪽 CI 진입점과 부정 사례를 로컬 격리 Git 객체로 검증한다.
4. DEV 등록 PR→Owner main 병합→별도 승인 INF 티켓/초기 README PR 순서를 명시한다. 실제 PR 검증 전에는 원격 사용 가능 완료로 보고하지 않는다.
5. INF 장기 정책의 소유 경로와 공개 정보 최소화 원칙을 설명하고 미확보 HQ ZIP 중복 검토는 RFC로 인계한다.

결과·변경 파일·검증·미해결 사항은 [DEV-007_RESULT.md](DEV-007_RESULT.md)에 기록한다.

## 후속 Git 제출 승인 (2026-11-01)

- 승인자: Owner / 원문 위치: 현재 Convention Team 채팅, 로컬 검수 보고 직후.

> PR 생성해주세요

- 직전 확인 대상: 이번 DEV-007 변경의 커밋·작업 브랜치 push·PR 생성. 위 응답으로 해당 제출 범위 승인.
- 저장소·브랜치: `wisberry2022/MetroManager`, `codex/DEV-007-infra-department-registration`.
- 허용: 이번 13개 변경 파일 커밋, 해당 브랜치 일반 push, base=main PR 생성·수정 및 필수 CI 확인.
- 기간·종료: 이번 DEV-007 PR 제출·검사 확인까지. Owner의 후속 철회 지시가 있으면 중단.
- 제외: main 직접 쓰기·병합·강제 push·릴리스·배포, INF의 별도 후속 티켓 실행. 미래 포괄 위임 아님.
