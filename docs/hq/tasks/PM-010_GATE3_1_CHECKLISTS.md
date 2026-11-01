# PM-010 — Gate 3-1 계획 확정용 부서별 체크리스트 작성·PR 제출

- **작업 ID:** PM-010 / HQ(PM) / 2026-11-01 / 상태: REVIEW
- **기준 `main`:** `5a24ddb375b5859a033055566353e932754a525e`.
- **Owner 명시 지시:** 2026-11-01 HQ 채팅에서 “현재까지 확보된 부서별 분석을 바탕으로 3-1 계획 확정 단계를 위해 각 부서에게 요청할 내용들을 ... 체크리스트 수준 ... 작업하여 PR 생성해주세요.”
- **허용 동작:** 본 PM-010의 **HQ 문서 작성·작업 브랜치 Commit/Push·PR 생성 및 필수 CI 확인**. 저장소 `wisberry2022/MetroManager`, 브랜치 `codex/PM-010-gate3-1-department-checklists`, 허용 경로 `docs/hq/`만. 유효 범위는 이번 PM-010 문서 제출/검수 요청까지.
- **금지:** main 직접 쓰기·Merge, 다른 부서 문서/게임 코드·에셋 수정, 새 기획 정책 확정, 부서별 별도 실행 티켓 권한 자동 부여, 릴리스.
- **기존 PM-009 관계:** `codex/PM-009-gate3-stage1-plan`의 미PR·미병합 Stage 초안은 이번 커밋에 포함하지 않음. 이후 부서 회신을 입력으로 HQ가 대조할 계획.

## 작업 범위

- [요청 개요](../PM-010_GATE3_1_REQUESTS.md)
- [Planning](../requests/PM-010_PLANNING_CHECKLIST.md)
- [Design](../requests/PM-010_DESIGN_CHECKLIST.md)
- [Development](../requests/PM-010_DEVELOPMENT_CHECKLIST.md)
- [INF](../requests/PM-010_INF_CHECKLIST.md)
- [결과 기록](PM-010_RESULT.md)

## 완료 조건

- 4부서에 같은 Gate 2 승인·Gate 3-0 분석 기준/최신 `main`을 인계할 수 있음.
- 각 요청은 담당 R&R을 벗어나지 않으며 체크리스트와 최소 회신 양식에 한정.
- Stage의 미승인 구현·제품 목표·Git 권한을 승인으로 간주하지 않음.
- 동일 검토 내용 반복을 피하고 현재 Issue/PR을 증거로 재사용.
- HQ 소관 경로만 변경한 PR 제출, `policy`와 `department-policy` 확인, main Merge는 Owner 별도 승인.
