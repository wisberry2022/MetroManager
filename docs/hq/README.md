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

## Stage 2 완료와 Stage 3 실행

- [S2 최종 인수표](STAGE2_ACCEPTANCE_MATRIX.md) — Owner 최종 인수로 **Stage 2 DONE**. [#141 최종 결정](https://github.com/wisberry2022/MetroManager/issues/141#issuecomment-6892772104) 및 PR #144 merge `96c51ae6c3352195b9a8e8b89f92dd51c13be81c`를 따른다. 전체 MVP DONE은 아니다.
- [PM-020 Stage 3 계획안](PM-020_STAGE3_EXECUTION_PLAN.md) — W04B·VS-02와 **DEV-026 구현·제품 검증을 공식 개발 범위**로 연결하고 DEV-025 심사 완료·F-08 O-01~07 방향 승인 후속을 연결한다. 진입·S3-01~12 기준안·담당별 요청을 제공한다. DEV-026 편입과 현재 공급의 한정 수용은 승인 완료이며 W04B 미래 공급·분담 수용 연결·S3-12 최종 인수는 별도다. 문서 반영과 Stage 최종 인수를 구별한다.
- 부서 요청: [개발](requests/PM-020_DEVELOPMENT_STAGE3.md), [기획](requests/PM-020_PLANNING_STAGE3.md), [Design A](requests/PM-020_DESIGN_A_STAGE3.md), [Design B](requests/PM-020_DESIGN_B_STAGE3.md), [INF](requests/PM-020_INFRA_STAGE3.md), [Convention](requests/PM-020_CONVENTION_STAGE3.md). Owner 전달용이며 자동 전달·숙지 완료를 가정하지 않는다.
- 최신 작업: [PM-021 승인·범위](tasks/PM-021_STAGE3_F08_DIRECTIONS.md) / [결과](tasks/PM-021_RESULT.md). [계획 내 S3 인수표](PM-020_STAGE3_EXECUTION_PLAN.md#6-stage-3-종료-기준안)와 S3-10 하위 행에서 **방향 승인 완료 / 최종 규격·제품 적용 잔여**를 분리한다. #92 OPEN, DEV-026 현재 공급 한정 수용·S3-12 최종 인수 별도. 이전 [PM-020](tasks/PM-020_STAGE3_ENTRY_PLAN.md) / [결과](tasks/PM-020_RESULT.md)는 작성 당시 이력이다.
- 기존 집계: [PM-019](tasks/PM-019_STAGE2_FINAL_ACCEPTANCE.md) / [결과](tasks/PM-019_RESULT.md), [PM-018](tasks/PM-018_DEV023_CLOSEOUT.md) / [결과](tasks/PM-018_RESULT.md), [PM-017](tasks/PM-017_Q12_W06_ACCEPTANCE_UPDATE.md) / [PM-016](tasks/PM-016_STAGE2_ACCEPTANCE_UPDATE.md). 과거 승인 대기 표현은 해당 작성 시점 이력이다.

## PM-022 현재 진입점 — 2026-11-28

- [S3-12 인수 범위·결정](STAGE3_S3_12_ACCEPTANCE_SCOPE.md): OD-S312-01·02 승인, DEV-027 비의존 한정 종료, 관측 한계 원상태 보존/현재 GUI 비차단. 기존 문서의 당시 HOLD·미공급 표현을 최신 결정으로 구별한다.
- [DI-03 부서별 착수 요청](requests/PM-022_DI03_DEPARTMENT_REQUESTS.md): Stage 3 필수 유지, 범위 내 로컬 구현·검증 착수 가능. 실제 공급 L2 → UI 통합 → 신규 영향 검수 순서와 미래 Git/독립 GUI 권한을 구분한다.
- [DI-03 #185](https://github.com/wisberry2022/MetroManager/issues/185) / [HQ 최종 인수 #186](https://github.com/wisberry2022/MetroManager/issues/186). #146 원 기록은 비의존 협의/검수 종료로 보존하고 후속은 분리한다. #104 RP/EX와 #92 F-08은 별도 유지. DEV-027 전체 DONE·S3-12/Stage 최종 인수 아님.
- [PM-022 승인·범위](tasks/PM-022_S3_12_DI03_TRANSITION.md) / [결과](tasks/PM-022_RESULT.md). 게시와 각 채팅의 자동 전달/숙지 완료는 다르다.
