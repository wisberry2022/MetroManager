# 협업 오류 보고서

Owner는 2026-11-01 현 Planning Codex 대화에서 “docs/co-work/err-report 경로를 신설하여 … 협업 도중 발생하는 에러사항은 해당 디렉토리에서 일괄 관리”하도록 확정했다. 협업 과정의 PR·Git·검사·부서 전달 오류 보고서는 이 경로에 모은다.

- 파일명: `ERR-YYYYMMDD-NNN_요약.md`. 작성 시 기존 ID 중복 확인.
- 보고서에 신고 부서/작업 ID, 증상·재현 조건, 기준 main/PR/head/부모 SHA, 로그 링크, 확인 원인과 추정/미확인, 영향, 복구/예방·담당·검증/NOT_RUN·종료조건을 기록한다.
- 원문 비밀정보·불필요한 개인 화면/대화는 공개 Git에 복제하지 않는다.
- 보고서 등록은 정책 수정·main merge·게임 규칙 변경 권한을 만들지 않는다.
- **도입 상태:** Owner의 공용 경로 결정은 수령. 현재 base 검사기의 허용 경로 등록은 Convention Team 반영 PENDING. 기존 부서/티켓·필수 CI·Owner merge 규칙을 유지한다.

| ID | 내용 | 상태 |
| --- | --- | --- |
| [ERR-20261101-001](ERR-20261101-001_PR35_BRANCH_UPDATE.md) | PR #35 main 동기화 merge commit 후 필수 CI 실패 | 원인 확인 / 기획 PR 복구·Convention 후속 추적 |
