# INF-001 — 컨텍스트 건전성 및 세대교체 운영 문서 등록

- 담당: INF / 2026-11-01 / 상태: REVIEW
- Owner 승인: INF를 PM·Planning·Design·Development와 동등한 부서 에이전트로 인정하고 원격 Commit/Push/PR 권한 부여; 이후 **'여태까지 합의된 컨텍스트 관리 방안 및 평가서, 후임 인수인계서 템플릿을 정리하여 PR 생성'** 직접 지시.
- 저장소: `wisberry2022/MetroManager`
- 기준 `main`: `0303a929b682efb8c75b20eed2994b3a36ecafae` (DEV-007 등록 반영)
- 작업 브랜치: `codex/INF-001-context-governance`
- 허용: INF 소관 `docs/infra/**` 신규 문서의 Commit/Push/PR (이번 작업 완료/Owner 철회까지)
- 금지: `main` 직접 변경/병합, 릴리스, 타 부서 문서/게임 소스/CI/정책 코드 변경, 위임의 포괄 확대.
- 연관 종료 이력: Issue #19(초기 운영 제안), Issue #20(INF 등록 요청)는 Owner가 CLOSED. **재개설·승인 티켓 대용 사용하지 않음**.

## 목표
Phase 1·2에서 합의한 수동 진단, ACHC 독립 평가, Git 기반 업무 스냅샷, 후임 수용 시험, Owner/PM/INF 책임 경계를 정식 INF 경로에 정리한다.

## 포함
- `README.md`
- `AGENT_HEALTH_POLICY.md`
- `AGENT_HEALTH_REPORT_TEMPLATE.md` 및 `AGENT_ASSESSMENT_TEMPLATE.md` (빈 양식)
- `AGENT_HANDOFF_TEMPLATE.md` 및 `AGENT_REGISTRY_TEMPLATE.md` (빈 양식)
- `PLANNING_SUCCESSION_RUNBOOK.md` (예방적 인계 방법)
- 본 티켓과 `INF-001_RESULT.md`
- 승인 범위에서 작업 브랜치 Commit/Push 및 base `main` PR 생성

## 제외
네 개 에이전트 **실제 건강 진단 결과 원문/점수/개별 오류**, 비공개 세션 URL·개인정보·비밀값, 후임 실제 생성/이관, 자동화, 기타 부서 수정, 게임 명세 변경, Owner의 main Merge.

## 완료 기준
1. INF 전용 경로·티켓·커밋 형식을 만족하고 기존 승인·권한을 변경하지 않는다.
2. 평가/자기보고/후임 수용 양식을 혼동하지 않고 계측 불가·미실행을 표시한다.
3. Owner 교체 승인 → 현직 인계 → 후임 독립 수용 → PM 전환 → Owner 권한 재부여가 구분된다.
4. 상세 개인 진단 결과 없이 공개해도 되는 문서로 구성한다.
5. 새 HEAD의 `policy` 및 `department-policy` 확인 후 Owner Merge 승인 대기.
