# PLN-003 — 협업 오류 보고·공용 경로 최초 등록

- Planning / 2026-11-01 / REVIEW / 수신 Convention Team.
- 기준 main: `80d44a983ce57e4d3d067b15eac7f9cdeadbd3c4`; 브랜치: `codex/PLN-003-collaboration-error-report`.
- Owner 직접 요청: “해당 PR을 재생성해주고 … Convention Team에 보고하기 위한 증상 보고서도 생성해주세요 … 별도 산출물 … docs/co-work/err-report 경로를 신설 … 일괄 관리 … 확정”.
- 허용: 이번 증상 분석·보고서/README·본 티켓 작성·전용 브랜치 commit/공유·별도 보고 PR 및 Convention Issue 보고. 새 공용 경로는 이번 Owner 직접 지정에 따른 작성 범위다.
- 제외: 검사기/거버넌스/타 부서 파일 수정, DEV 사칭, 검사 우회, main merge·강제 push·게임 규칙 변경.
- 산출물: [보고서](../../co-work/err-report/ERR-20261101-001_PR35_BRANCH_UPDATE.md), [공용 관리 안내](../../co-work/err-report/README.md).
- 완료 조건: 증상/실패 로그·SHA·근거·미확인 분리·복구/재발 방지/담당/NOT_RUN 기록, 별도 PR·Convention 추적점 연결.
- **통합 차단:** 기존 main 검사기는 공용 경로 미등록. 본 승인 자체로 검사 코드가 바뀌지 않는다. Convention Team이 소관 DEV 변경을 base에 반영하기 전 보고 PR 통합 BLOCKED. 원래 기획 복구 PR과 분리하며 검사 면제 요청 아님.
