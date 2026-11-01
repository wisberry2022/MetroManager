# PM-011 — Gate 3-2 승인 계획·착수 요청 제출 결과

- **PM-011** / 2026-11-01 / 담당 HQ(PM) / 상태: REVIEW — PR·Owner main Merge 승인 대기
- **기준 main:** `3add70d3c787091e17d4cd37af0657e88e869767`; **브랜치:** `codex/PM-011-gate3-2-stage1-kickoff-repair`.
- **요청 근거:** Gate 3-1 종합 보고서에 대한 Owner 명시 승인 및 Gate 3-2 부서별 착수 요청서 PR 지시.

## 제출 범위

| 파일 | 처리 |
| --- | --- |
| [Gate 3-2 승인 계획](../PM-011_GATE3_2_APPROVED_PLAN.md) | OWNER 승인 계획의 공식 HQ 요약·Stage 1 범위/의존성/부분 검증 |
| [실행 협업 절차](../PM-011_GATE3_2_EXECUTION_PROTOCOL.md) | 기존 PM-008 추가 운영 지침, 테스트/권한/PR 갱신 안전선 |
| [Planning](../requests/PM-011_PLANNING_KICKOFF.md) | 승인 의미/반례 지원, 새 규칙 충돌 시만 L3 |
| [Design](../requests/PM-011_DESIGN_KICKOFF.md) | 저충실도 UI·상태/지도/목록, DEV 공급 조건과 검증 |
| [Development](../requests/PM-011_DEVELOPMENT_KICKOFF.md) | W01 시작, W02/W03 분할·회귀, 최소 UI 실제 공급 |
| [PM 티켓](PM-011_GATE3_2_KICKOFF.md) | 승인 원문·허용 행위·비범위 |

## 검증 수준

- 문서 단위: 기준 SHA, 내부 상대 링크, Gate 2/3-1/Owner 기록·부서 소관·Git 권한 경계의 **정적 대조**.
- 변경 파일: 모두 `docs/hq/` 아래 Markdown, LF/UTF-8/마지막 개행 및 PM-011 ID 사용.
- `policy`, `department-policy`: **실제 PR 생성 후 최신 head의 원격 CI를 직접 재조회**. 생성 전에 PASS로 작성하지 않음.
- 로컬 훅/doctor/check, Godot headless/게임 자동테스트/GUI·실플레이/Windows 빌드·FPS·외부 사용성·두 VP E2E: **NOT_RUN**, HQ 문서 전용 제출.
- 승인 Stage 1 실행 티켓, 타 부서 Git Commit/Push/PR, main Merge, 구현·디자인 제작: 이번 PR로 수행/승인하지 않음.

## 동일 PR 보완 — Owner 전달 INF 권고

- [기획 후임 전환 공개 기록](../PM-011_PLANNING_SUCCESSION_RECORD.md) 추가: Gate 3-1 담당 후임 명시, 현직 신규 업무 종료/참조 유지, 구 권한 비승계. INF 제한 공유용 시험 원문 미게시.
- PM-010 공통/부서별 체크리스트 및 PM-011 수신·숙지를 Gate 3-2 신규 실행 전 **기존 Issue의 최소 확인 댓글**로 남기도록 계획·절차·세 착수 요청서에 반영. 이미 분석된 내용의 전면 재심사 불요.
- 변경 후 PR head의 두 필수 CI를 다시 조회하며, 실제 Godot·게임 UI/빌드·개별 Git 권한·main Merge는 NOT_RUN.

## 후속

Owner가 본 PR을 검수하고 별도 `main` Merge 승인 후 각 부서 세션에 자신의 요청서 URL과 **실제 병합 `main` SHA**를 직접 전달한다. 각 부서는 최신 원격 확인→실행 티켓 제안 및 승인 범위 확인→허용된 작업만 개시한다. HQ는 첫 Stage의 의존성·차단·실제 검증 증거를 추적한다.

- **대체 제출:** 기존 PR #41은 DEV-009 main 병합으로 최신 main에서 뒤처짐. 새 `codex/PM-011-gate3-2-stage1-kickoff-repair`를 `3add70d3c787091e17d4cd37af0657e88e869767`에서 만들고 승인된 HQ 문서만 재제출한다. 기존 공유 브랜치에 main merge/force push하지 않으며 두 CI를 신규 head에서 재실행한다.
