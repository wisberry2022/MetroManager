# DEV-009 — GitHub 작업 브랜치 merge 오류 재발 예방

- 담당: Convention Team / LAPTOP / 2026-11-01 / 상태: REVIEW, DONE 아님.
- 착수·제출 승인자: Owner, 현재 Convention Team 채팅의 아래 직접 요청.

> 컨벤션팀. 기획 에이전트의 오류 리포트 PR이 승인되어 main에 머지되었습니다. 해당 오류 리포트 확인하여 추후 GitHub 사용 시 동일 문제로 에러가 발생하지 않도록 조치 진행하여 PR까지 생성해주세요

## 기준·범위·권한

- 기준 main: `ac04302f2bdab75aab49f0950bce92f115ec8047`, fetch 후 원격과 대조. DEV-009의 문서·브랜치 중복 없음 확인, 미공유 예약은 UNKNOWN.
- 근거: ERR-20261101-001, 기획 대체 보고 PR #40 통합, DEV-008/PR #39 통합. 원래 PR #37은 미병합 종료, Issue #38은 OPEN. 보고서의 최초 PENDING과 최신 원격 상태를 구분.
- 규정: 매 작업 필수 개발 규정·AGENTS·개발 README, GOV-001 DRAFT의 승인 원칙, RFC/DEC 양식, Godot 설정 직접 확인. 최신 main의 DEV-008 지침 변경도 diff로 확인.
- 브랜치: `codex/DEV-009-github-merge-prevention`. 별도 `.local/worktrees/DEV-009-github-merge-prevention`에서 작업, 공유 DEV-006 및 기존 DEV-008 worktree 변경 없음.
- 포함: 로컬 자동/수동 merge 커밋 예방, 커밋된 제출의 main 포함/이력 사전 검사·pre-push 연결, 정상/부정/실제 훅 테스트, API/UI 운영 안내와 PR 양식, 공용 오류 보고서의 Convention 후속 사실 기록.
- 제외: 게임 규칙·구현·Godot 설정, main 직접 쓰기·병합·release·배포, force push·기존 이력 재작성, 다른 부서 실제 산출물 변경, 서버 보호 완화/신규 유료 기능 도입, Issue #38 종료.
- Git 승인: 이번 요청의 "PR까지 생성"에 필요한 DEV-009 변경의 commit·작업 브랜치 일반 push·base=main PR 생성/수정·필수 CI 확인까지. 저장소 `wisberry2022/MetroManager`, 위 작업 브랜치, 이번 제출 종료까지 유효. Owner 후속 철회 시 중단. 미래 포괄 위임·main 병합 승인이 아님.
- 영향 L2: 전 부서 제출 인터페이스·정책/훅 변경. 게임 기획/디자인 명세 영향 없음.

## 수용 기준

1. 실제 임시 Git 저장소의 자동 merge 및 후속 수동 commit이 거부되고 HEAD에 merge commit이 생성되지 않는다.
2. 5개 부서의 정상 제출 preflight는 읽기만 수행한다. fetch된 main보다 뒤처진 head·merge 이력·잘못된 부서/티켓·부적합 브랜치는 거부한다.
3. 기존 커스텀 merge 훅은 설치기가 덮어쓰지 않으며 기존 검사·단일 부모·부서 경계와 main 보호를 유지한다.
4. API/UI의 로컬 훅 미실행과 allow_update_branch=false의 한계를 명시하고 최신 main/expected SHA/부모/경로 대조·대체 PR 절차를 제공한다.
5. 이번 작업의 정상 훅·preflight·일반 push·두 원격 CI 결과와 실행/NOT_RUN·미해결을 [결과](DEV-009_RESULT.md) 및 PR 본문에 남긴다. 완료 보고는 검수 요청이다.
