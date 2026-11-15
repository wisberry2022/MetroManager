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

## Stage 2 완료와 Stage 3 준비

- [S2 최종 인수표](STAGE2_ACCEPTANCE_MATRIX.md) — Owner 최종 인수로 **Stage 2 DONE**. [#141 최종 결정](https://github.com/wisberry2022/MetroManager/issues/141#issuecomment-6892772104) 및 PR #144 merge `96c51ae6c3352195b9a8e8b89f92dd51c13be81c`를 따른다. 전체 MVP DONE은 아니다.
- [PM-020 Stage 3 계획안](PM-020_STAGE3_EXECUTION_PLAN.md) — W04B·VS-02와 **DEV-026 구현·제품 검증을 공식 개발 범위**로 연결하고 DEV-025 Design 심사/F-08을 병행한다. 진입·S3-01~12 기준안·담당별 요청을 제공한다. DEV-026 편입은 Owner 후속 요청에 따른 결정이며 정확한 계약/실행/Git 준비는 별도 확인한다. 전체 세부 계획은 **PLAN_REVIEW**다.
- 부서 요청: [개발](requests/PM-020_DEVELOPMENT_STAGE3.md), [기획](requests/PM-020_PLANNING_STAGE3.md), [Design A](requests/PM-020_DESIGN_A_STAGE3.md), [Design B](requests/PM-020_DESIGN_B_STAGE3.md), [INF](requests/PM-020_INFRA_STAGE3.md), [Convention](requests/PM-020_CONVENTION_STAGE3.md). Owner 전달용이며 자동 전달·숙지 완료를 가정하지 않는다.
- 최신 작업: [PM-020 승인·범위](tasks/PM-020_STAGE3_ENTRY_PLAN.md) / [결과](tasks/PM-020_RESULT.md).
- 기존 집계: [PM-019](tasks/PM-019_STAGE2_FINAL_ACCEPTANCE.md) / [결과](tasks/PM-019_RESULT.md), [PM-018](tasks/PM-018_DEV023_CLOSEOUT.md) / [결과](tasks/PM-018_RESULT.md), [PM-017](tasks/PM-017_Q12_W06_ACCEPTANCE_UPDATE.md) / [PM-016](tasks/PM-016_STAGE2_ACCEPTANCE_UPDATE.md). 과거 승인 대기 표현은 해당 작성 시점 이력이다.
