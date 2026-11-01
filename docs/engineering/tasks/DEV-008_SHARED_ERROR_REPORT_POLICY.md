# DEV-008 — 공용 오류 보고 경로 정책과 PR #37 선행 조치

- 담당: Convention Team / LAPTOP / 2026-11-01 / 상태: REVIEW, DONE 아님.
- 승인자·착수 근거: Owner의 현재 채팅 직접 요청. PR #37/Issue #38은 요청·관찰 자료로 사용.

> 컨벤션 팀. PR #37에 기획 에이전트의 Github 사용 중 발생한 오류에 대한 경로와 증상에 대한 보고서 등록을 위한 PR 막힘 현상이 발생했습니다 컨벤션 팀에서 선조치하여야 PR 승인이 가능하니 확인하여 조치바랍니다

## 목적·기준·선행조건

- 목적: Owner 지정 공용 오류 보고 경로와 기존 검사기의 불일치를 고치고 기존 부서/티켓/CI 경계를 유지한다.
- 원격 main: `5933f7885fc0b975b74fd81c137982d2a9adff0b`, fetch·branch API 확인. main protected=true, 필수 policy/department-policy, Actions App 15368 바인딩 확인.
- PR #37: PLN-003 / Draft / head `a9bfb82f814de8830bdb7db4269e17c0a5d88fed`; 최초 base `80d44a983ce57e4d3d067b15eac7f9cdeadbd3c4`.
- 지침: AGENTS.md, 개발 README, CODE_CONVENTIONS v1.0, GIT_WORKFLOW v1.1, ENFORCEMENT v1.1, DEPARTMENT_WORKFLOW v1.1, GOV-001 DRAFT의 승인 운영 원칙 및 RFC/DEC 양식 직접 확인. 최신 main에서도 해당 파일의 차이가 없음을 확인.
- DEV-008은 fetch 후 문서·브랜치에서 사용되지 않음을 확인. 미공유 예약은 UNKNOWN.
- 브랜치: `codex/DEV-008-shared-error-report-policy`. 공유 루트의 DEV-006 브랜치/파일은 변경하지 않고 별도 `.local/worktrees/DEV-008-shared-error-report-policy`에서 진행한다.
- 영향: L2, 전 부서 공용 보고 인터페이스/정책 변경. 게임 명세 영향 없음.

## 포함·제외·산출물

포함: 원인/실패 로그 직접 확인, 공용 직속 Markdown 보고서·README 허용, 기존 티켓/부서 경계 회귀 검증, 단일 부모 오류의 복구 안내, 안전한 재제출 문서, 티켓·결과.

제외: 기획의 PR #37 파일 직접 수정·대신 재제출, 기존 PR 종료/Draft 해제, 정책 우회·자기 예외, 서버 보호 변경, main 병합, commit/push/PR의 포괄 위임, 타 부서·게임 소스·Godot 설정 수정. DEV-007의 과거 제출 승인을 재사용하지 않는다.

## 수용 기준

1. 기존 PR #37을 기존 검사기로 거부 재현하고 후보 검사기에서는 실제 head/범위 검증을 통과한다.
2. 5개 부서의 공용 보고서+기존 자기 부서 티켓 조합은 양쪽 CI 진입점에서 통과한다.
3. 다른 공유 경로·비 Markdown·잘못된 이름·하위 경로·상위 탐색·타 부서 소스/정책·티켓 누락/불일치·symlink/submodule·merge commit은 거부한다. main/tag/강제 갱신 제한도 기존 테스트로 유지한다.
4. 기존 워크플로와 base 코드 신뢰 경계를 유지하고 Owner 검수/main 반영 후 기획 대체 PR의 두 CI를 확인하는 후속 절차를 명시한다.
5. 작업 ID·변경 파일·명령·검증 증거·NOT_RUN·미해결·명세 영향은 [결과](DEV-008_RESULT.md)에 기록한다. 실제 원격 반영 전 해결/DONE으로 표시하지 않는다.

현재 요청은 조사·수정 근거다. 이번 변경의 Git 제출과 main 병합은 각각의 명시적 Owner 승인 범위를 확인한다.

## 후속 Git 제출 승인 (2026-11-01)

- 승인자: Owner / 원문 위치: 현재 Convention Team 채팅의 DEV-008 검수 보고 직후.

> PR 생성해주세요

- 직전 검수 요청의 DEV-008 커밋·push·선행 PR 생성 범위를 승인한 응답이다.
- 대상: `wisberry2022/MetroManager`, `codex/DEV-008-shared-error-report-policy`, 이번 변경 파일 11개.
- 허용: 해당 변경의 commit·작업 브랜치 일반 push·base=main PR 생성/수정·필수 CI 확인.
- 기간·종료: 이번 DEV-008 제출·검사 확인까지. Owner 후속 철회 지시 시 중단.
- 금지: main 직접 쓰기·병합·force push·릴리스·기획 PR 재제출/변경. 미래 포괄 위임 아님.
