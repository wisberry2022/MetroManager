# Agent Registry — 전환 기록 양식

- ID: INF-REG-TEMPLATE / v1.1 / 2026-11-14 / TEMPLATE_ONLY / 개정 INF-009
- 소유: INF / 최초 임명·효력·권한 이전: Owner / 담당·의존성 갱신: HQ
- [전환 규정](agents/REGISTRY_TRANSITION_RULES.md)이 정본이다. 이 빈 양식은 실제 ID 발급·schema 변경·시험 합격을 뜻하지 않는다.
- 실제 내용은 Owner 제한 보관이 기본이며 공개 Git에는 필요한 운영 사실만 남긴다.

## 전환 결정과 후임 확인

| 필드 | 기록 |
|---|---|
| 결정 ID·Owner 최초 지시 근거·인계 ID | |
| 역할·실제 담당 범위 | |
| 기존 ID·세대 / 신규 ID·세대·predecessor | |
| ID 중복 확인 main SHA·열린 PR·미반영 배정 참조 | |
| 기존 종료 / 후임 시작 효력 시각 | 각각 오프셋 포함 ISO 8601 |
| 승계 업무·허용 동작·범위·기간·종료 조건 | |
| 후임 인수 확인 시각 / 실제 업무 개시 시각 | |
| 업무상 기존/후임 상태 | RETIRED / ACTIVE 등 실제 결정 |
| 별도 건강 진단 | NOT_ASSESSED 또는 실제 근거 |
| 선택적 수용시험 | NOT_RUN(정책상 생략) 또는 실제 요청·결과 |
| 후속 등록 책임자·티켓/추적 참조 | |

## 후속 등록과 감사 기록

| 기록 상태 | 기준 main·registry blob / 제출 head | 기록 시각·작성자 | PR·실제 merge SHA·main 확인 시각 |
|---|---|---|---|
| REGISTRY_RECORD_PENDING / REGISTRY_RECORDED | | | |

- 통상 전환은 최초 Owner 지시와 후임 확인으로 진행한다. INF 판정·PM 확인·Owner 재승인은 별도 필수 단계가 아니다.
- 업무상 ACTIVE와 main 등록 반영 여부를 구분한다. 건강 상태 NORMAL/WATCH 등은 lifecycle ACTIVE/PENDING/RETIRED와 별도다. 위 기록 상태를 registry.json enum으로 추가하지 않는다.
- ID는 재사용하지 않고 과거 작성 이력을 보존한다. 번호·generation·계보를 분리한다.
- activated_at/retired_at은 결정된 효력 시각이고 recorded_at에 해당하는 기록 시각·PR 병합 시각과 다르다. 기존 레거시 null을 추정값으로 채우지 않는다.
- 새 행 record_version=1, 기존 행 변경 +1. 실제 인사 변경은 해당 결정에 한하며 형식 정리를 이유로 다른 행·root를 고치지 않는다.
- 생략한 시험을 ACCEPTANCE_VERIFIED로 기록하지 않는다. INF·PM 필드의 과거 필수 확인을 대체한 근거로 INF-009 정책과 해당 Owner 전환 지시를 연결한다.
- 정정은 이전/새 값·사유·근거를 새 티켓·PR로 남긴다. 일반 append-only event schema는 별도 미결이다.

## 정정·복구 이력

| 기록 시각 | 대상 결정/ID | 이전 값 → 새 값·사유 | Owner 근거·티켓·PR·SHA |
|---|---|---|---|
| | | | |
