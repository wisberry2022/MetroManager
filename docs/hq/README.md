# HQ 산출물

HQ의 신규 계획·일정·공유 보고서는 이 디렉터리에 둡니다. 기존 docs/governance 문서는 공통 규정 원본으로 유지합니다.

- 티켓/결과: `docs/hq/tasks/PM-NNN_TITLE.md`, `PM-NNN_RESULT.md`
- 브랜치: `codex/PM-NNN-description`
- 커밋 예: `[HQ][docs] PM-002 프로젝트 현황을 공유합니다` + 빈 줄 + 본문
- 필수: main의 AGENTS.md와 [부서별 작업 규칙](../engineering/DEPARTMENT_WORKFLOW.md)을 명시적으로 읽고, 플러그인 쓰기 시 branch를 반드시 지정합니다.
- 다른 부서·개발 소스·CI 수정은 기본 금지입니다. main에 직접 쓰지 않습니다.

## 부서 공통 검수 안내

- [GUI 검수·증거 재사용 지침](GUI_REVIEW_PROTOCOL.md) — 관련 작업 시작 시 승인/병합 상태와 자기 부서 역할을 확인합니다. 수용 증거 재사용, 영향 범위 재검수, 독립 실행·심사, Stage 2 잔여 조건을 안내합니다.
- [PM-015 제출 범위](tasks/PM-015_GUI_REVIEW_PROTOCOL.md) / [검증 결과](tasks/PM-015_RESULT.md). 기존 PM-008·PM-014 수용 기준과 개별 실행/Git 권한을 유지합니다.
- Owner가 부서별로 전달할 공통 진입점입니다. PR 게시만으로 세션 간 자동 전달이나 숙지 완료를 가정하지 않습니다.

## Stage 2 통합 현황

- [S2 통합 인수표·DEV-023 완료·DEV-024 잔여 업무](STAGE2_ACCEPTANCE_MATRIX.md) — DEV-023 24조건 수용·GUI 단계 종료와 Owner DONE/#79 종료를 반영합니다. 다음 필수 경로는 DEV-024 실제 VS-01·영향 회귀, HQ 통합·Owner Stage 인수입니다. Q12 원래 P05 대조 완료와 상위 PARTIAL을 구별하며 기존 수용을 유지합니다.
- 최신 갱신: [PM-018 Owner 결정·작업 범위](tasks/PM-018_DEV023_CLOSEOUT.md) / [검증 결과](tasks/PM-018_RESULT.md). DEV-023 완료와 이 문서 PR의 검토/main 반영 상태를 구별합니다.
- 이전 이력: [PM-017 범위](tasks/PM-017_Q12_W06_ACCEPTANCE_UPDATE.md) / [결과](tasks/PM-017_RESULT.md), [PM-016 범위](tasks/PM-016_STAGE2_ACCEPTANCE_UPDATE.md) / [결과](tasks/PM-016_RESULT.md). 승인 기준은 PM-014이며 실제 수용 범위는 연결된 Issue/PR을 따릅니다.
