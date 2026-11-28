# DEV-027 DI-03 모델·실제 공급 및 L2 검토 패킷

Development / AGT-DEV-0004 · 2026-11-28 KST · #185 후속.
작업 기준은 PR #187 병합 main `a1e2534232e4cc71425a47c530240625784c0ae9`다. 로컬 브랜치는 `codex/DEV-027-di03-supply`이며 실행 소스의 SHA256과 실제 payload는 [결과 JSON](DEV-027_DI03_RESULTS.json)에 함께 기록한다. [착수 범위](../tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md#23-pm-022-di-03-모델과-공급-착수--2026-11-28) · [PM-022 요청](../../hq/requests/PM-022_DI03_DEPARTMENT_REQUESTS.md) · [A1+B1 정본](../../planning/tasks/PLN-016_E01_OWNER_DECISION.md)

## 1. 실제 소비 계약

Session의 `proposal_ui.snapshot`과 기존 Pipeline `proposal_snapshot()` 경로를 사용한다. 기준 시점은 봉투의 `run_scope`, `simulation_minute`, `snapshot_revision` 및 상위 관측의 `T_COMPLETE`로 연결한다. 제안의 현재 상태, 과거 심사 사본, 요청의 당시 결과는 각자 보존한다.

| 범위 | 실제 필드·입력 | 소비 의미 |
| --- | --- | --- |
| UI11 실패 근거 | `proposals[].decisions[].submission`, `decision_id`, `target_decision_id`, `fact_pending` | 정부 부적합은 해당 심사 계획, 설득 실패는 연결된 보류 계획. `fact_pending`은 실패 당시 예정 기록이다. |
| UI12 현재 사건 | `fact_supply.available/status/scheduled/facts` | `READY`의 빈 배열은 정상 0건이다. `scheduled`는 발생 전, `facts`는 발생 후다. `failed_at/scheduled_at/occurred_at/effect_at`와 고정 `basis_*`·`origin_districts/target_od_ids`를 보존한다. |
| UI12 사용 이력 | 사건의 `used/consumed_at/consumed_by`, 요청의 `registered_at/admitted_at/effective_at/fact_consumed_at/consumed_fact_id` | 현재 효과판과 사실 사용 이력은 독립적이다. 등록 상태·접수 결과·완료 판정을 각 시점 값으로 표시한다. |
| UI11/12 재접수 | `proposals[].government_retry_state`의 `applicable/allowed/reason_codes/failure_decision_id/fact_id` | L2용 실제 자격 결과다. `submit_government_review`에 현재 `binding`과 시청 승인 `decision_id`, 표시된 `fact_id`를 공급한다. 정부 실패 근거는 별도 `failure_decision_id`로 연결한다. 최초 제출에는 `fact_id`를 보내지 않는다. |
| 예측·운행 | `draft.demand_profile`, `draft.prediction.current.value.od_pairs`, `business_contract.permitted_plan.demand_profile`, 운영 `source.demand_profile/od_pairs/carry_denominator` | 사건 ID·사업 ID·효력시각·출발 동·배율·수요판을 사용한다. OD의 기존 `daily_demand`는 원값이다. 대상의 실제 수요는 `effective_daily_demand`의 정수 분자/분모다. 기존 출발/도착 역 배분과 접근성은 유지한다. |

요청은 기존 Session `request_proposal`로 전달한다. 동일 `command_id`로 조회·재전송 시 이미 기록한 결과를 사용한다. 효력 시점에도 현재 계획·예측·시청 승인·최신 관련 실패와 발생/미사용 사실을 검사하고, 성공 접수에서만 한 번 소비한다. 공급에서 관측한 제한 사유는 `FACT_NOT_OCCURRED`, `PREDICTION_NOT_CURRENT`, `CURRENT_CITY_APPROVAL_REQUIRED`, `STALE_PLAN_OR_PREDICTION`, `NEW_FACT_REQUIRED` 등이다. 기수용 UI-1 일반 액션에는 기존 표시 사유를 유지하고 사실 지정 액션은 해당 L2 이후 연결한다.

Pipeline 내부에서는 마감 뒤 기존 제안 심사 완료 단계에 E01 효력을 적용한 후 해당 분의 접수를 검사한다. 완료된 분을 보고 새로 넣은 입력은 기존 T+1을 따른다. 증가량은 출발 동을 중복 제거한 후 정확한 ×5/4로 계산한다. carry가 있는 예측 구간을 연결할 때 분모가 10800에서 43200으로 바뀌므로 기존 분자를 4배로 환산한다. 운영은 허가 계획의 효력 수요판을 고정해 사용하며 원본 도시 수요·목적지 접근·용량·코호트/운임 처리 순서는 유지한다. 이미 관련된 슬롯은 하나의 사실만 새로 예약하고, 복수의 관련 공급 후보가 있으면 최초 실패의 활성 수요판을 한 개 선택한다.

## 2. D01 경계와 증거 위치

| 행 | 검증 경로 | 관측과 인수 범위 |
| --- | --- | --- |
| D01-01 | W04B 모델 정상 RNG의 정부 부적합과 설득 실패 | P-A 출발 동 D01/D02/D03/D04/D08. D08 역 2개를 하나로 합친다. 설득 당시 편집 초안이 바뀌어도 보류 사본을 사용한다. |
| D01-02 | 이름·역순·역 교체·교차 슬롯 및 별개 사업 경계 | 관련 슬롯은 같은 사건 ID를 사용한다. 별개 슬롯은 겹치는 출발 동에서도 자기 사건의 효력만 소비한다. |
| D01-03 | 실제 Session/Clock 입력, seed 4 | 정부 부적합 T600, 정지 중 T2039 유지, T2040 발생·효과 각각 1회, T2041 동일 상태. 효과 시점에 해당 예측은 무효화되고 별개 P-B 예측은 유지된다. |
| D01-04 | 실제 Session, 승인 예시 외 소수 격리 검사, seed 1 직접 운영 연결 | D08 200→250, D04→D05 미접근 유지. 격리 입력 101→505/4, 기존 carry·다음 분 도착 보존. 허가 뒤 처음 열린 운행에서 예측 OD와 운영 OD, 수요판이 일치한다. |
| D01-05 | 실제 Session, 성공·실패 재접수 | T2099 등록 미소비, T2100 접수 성공 소비, T2160 재실패 뒤 T3600에도 새 사건과 환급 0. 별도 실행의 계획 변경은 T2072 효력 재검사에서 실패하고 사실·추첨을 변경하지 않는다. |
| D01-06 | 실제 봉투와 원본 snapshot, 소속 guard | 상태/명령/사유와 원천판을 공급한다. 대상 화면은 A/B L2 확인 대기다. |
| D01-07 | 원장·마감 불변 검사와 직접 영향 자동 회귀 | 발생/소비 경로의 금전 효과 0, 기존 확정 일일보고 유지. 원래 읽기·복귀/전수 GUI의 수용 근거를 재사용한다. |

## 3. 검토 요청과 잔여

- **Planning**은 실제 대상·획득/소비/재실패·carry가 A1+B1에 부합하는지 대조한다. 현재 DEV의 명세 변경 요청은 없다.
- **Track A**는 UI11/12에서 예정·발생·사용·접수 실패 및 현재 가능한 행동의 연결, 재접수의 P-A/P-B 및 근거 계획을 대조한다.
- **Track B**는 같은 패킷의 RP-01/02/08 및 영향 EX에서 정상 0건, 공급 오류·옛 소속, 현재 액션과 과거 결과, 수요판 및 문구 경계를 대조한다. 영향 화면의 재심사 필요성은 해당 변경으로 판단한다.
- DEV 자체 OS GUI, 독립 GUI/Design 수용, 자연 VS-02 재완주, 빌드/export, 원격 CI 및 Git 제출은 이번 로컬 D1/D2 결과에서 NOT_RUN이다. 화면 통합과 제품 수용은 대기다. 기존 비의존 한정 종료, F-08/최종 규격, 기존 PARTIAL 및 S3-12/HQ·Owner 최종 인수 경계를 유지한다.

## 4. 실행 식별과 보존

Godot 4.7.2 headless에서 W04B, Session API, VS-02 자동 공급·운행, 제안 화면 자동, W03, W06을 실행했다. VS-02 자동의 DI-03 경로는 seed 1로 정부 부적합 후 사실을 사용한 다음 허가·표준 공사·개통·첫 운행의 영향을 확인했다. 이 경로의 D08 carry는 개통 분 8000/43200에서 다음 분 16000/43200으로 이어졌다. 별도 seed 4의 실패 경계는 정상 엔진 추첨 97·99를 유지했다. 격리 predictor 101·0 입력은 제품 원본에 반입하지 않았다.

`--headless --editor --quit` 로드는 exit 0이고 엔진 로그에 오류가 없었다. 자동 검사별 명령·결과·원본 해시, 변경 소스 SHA256, 시점별 원장과 실제 봉투 표본을 [JSON](DEV-027_DI03_RESULTS.json)에 둔다. 임시 import 메타데이터는 격리 사본에서 생긴 미추적 파일만 정리했다. 도시·제안 데이터는 기준 Git blob과 일치하며 공유 작업 트리의 기존 데이터 변경 2개를 보존했다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
