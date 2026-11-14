# DEV-022 — W05→W06 공급 계약·실행·L3 영향 검토안

- 담당: AGT-DEV-0004 / 2026-11-14 / **APPROVED_PLAN / IMPLEMENTED_LOCAL_REVIEW**.
- 분석 기준: main `3db401fc19b03e8719e4cccd741a8e1afe3df119`.
- [권한·정확한 경로](../tasks/DEV-022_W06_OPERATIONS_MODEL.md), [검증 계획](DEV-022_W06_VALIDATION_PLAN.md).
- 아래 신규 타입·함수·필드는 최초 계획 당시 제안이다. Owner 후속 승인에 따른 실제 구현 계약과 함수 차이는 [공급·검증 인계](DEV-022_W06_SUPPLY_AND_VALIDATION.md)를 따른다. Design L2 수용은 아직 아니다.

## 1. 현재 공급과 부족한 부분

| 현재 소스·확인 함수 | 사실·W06 연결 방식 |
| --- | --- |
| [MinutePipeline](../../../scripts/simulation/minute_pipeline.gd): enable_construction, _tick, snapshot | 실제 W04A/W05는 연결됐지만 운영비·도착 운임·승차 eligible은 set_fixture의 시험 입력이다. 이를 실제 승객 공급 증거로 쓰지 않는다. |
| [ConstructionService](../../../scripts/simulation/construction_service.gd): snapshot, service_ready, _source | 프로젝트별 OPEN/service_ready·opened_at·condition_revision이 존재한다. service_ready()의 “어느 프로젝트든 OPEN” 결과만으로 특정 노선의 운행을 허가하지 않는다. |
| [ConstructionProject](../../../scripts/model/construction_project.gd): snapshot, apply, invalidate_conditions | 유효 사업/공사 계약·station_ids를 보존한다. 개통 조건 무효화 시 OPEN을 해제한다. |
| [TenderService](../../../scripts/simulation/tender_service.gd): snapshot, _close, _eligibility | 실제 business_contract/정부 지급 결과와 terms를 제공한다. 역 목록·운임은 terms에서 읽는다. 첫 영업 보고 시 기존 공고가 CLOSED이거나 BUSY일 수 있다. |
| [DemandPredictor](../../../scripts/simulation/demand_predictor.gd): load_parameters, od_pairs, selection_tenths | 순수 OD/선택률 계산을 재사용한다. predict 전체 결과는 재무 제한 없는 예측이므로 실제 매출로 복사하지 않는다. |
| [CompanyLedger](../../../scripts/model/company_ledger.gd): operating_cost, fare, settle, boarding | 비용/B·R/K 보호·운임 도착 시 자동 정산·승차 자금 검사를 이미 제공한다. 별도 경제 원장을 만들지 않는다. |
| [DailyLedgerReport](../../../scripts/model/daily_ledger_report.gd): sync, close, current, report | 재무 원장의 effective_at별 집계와 1회 고정 마감을 보존하고 운행 집계만 추가한다. |

승인 근거는 [DATA v1.4](../../planning/PLN-001_GATE2_DATA_v1_DRAFT.md) §4~6 및 [최종 승인 SEM/CLOSE](../../planning/PLN-001_GATE2_FINAL_APPROVAL.md)다. DRAFT라는 파일명만으로 승인 상태를 판단하지 않는다.

## 2. 제안 책임과 함수

| 소유자 | 제안 함수/책임 |
| --- | --- |
| OperatingLine | `_init(source, pairs)`, `reconcile_source(source)`, `board(minute, allowed, capacity)`, `arrive(minute)`, `close_day(day)`, `snapshot()`: 단일 유효 노선의 carry·cohort·요청/탑승/미탑승/완료·일별 상태. 원장·UI·명령 큐를 직접 수정하지 않음 |
| OperationsService | `bind_sources(tenders, construction, minute)`, `previous_interval_cost(minute)`, `arrivals(minute)`, `board(minute, ledger_gate)`, `close_day(day)`, `snapshot(minute, revision)`, `next_business_query(tenders)`: 권위 원본 검증/노선 수명·집계. 원장 반영은 Pipeline 한 곳 |
| MinutePipeline | `enable_operations(network, parameters)`: 명시적 opt-in; 유효 W04A/W05 서비스 존재와 파라미터 검증 후 활성화. 미개통 상태 활성화는 가능하되 승객·운임·비용 0. `operations_snapshot/next_business_query`는 읽기 전용 wrapper. `_tick`이 각 효과를 정확히 한 번 반영 |
| DailyLedgerReport | `sync_operations(day, summary)`: 내부 서비스의 누적 일별 집계를 deep copy로 갱신하고 이미 마감한 day는 변경 거부. 기존 sync는 operations 집계를 덮어쓰지 않으며 close는 재무와 운행을 함께 고정 |

기존 제품 Session에서 enable_operations를 호출하는 변경은 DEV-023이다. DEV-022는 테스트에서 실제 Pipeline과 W04A/W05 명령을 연결한다. “모델 통합 PASS”와 “제품 GUI 사용 가능”을 분리한다.

실제 공급은 같은 Pipeline의 Tender/Construction 스냅샷을 통해 `project_id + business_contract_id + construction_contract_id`를 대조한다. 계약 EFFECTIVE·정부 지급의 원장 참조·프로젝트 일치·유효 OPEN/service_ready·opened_at≤T·condition_revision을 확인한다. 역 목록은 프로젝트와 사업 terms가 일치해야 하며 승인 도시의 유효 6~8역과 운임100을 확인한다. 외부 화면 플래그나 fixture가 OPEN의 권위가 되지 않는다.

동일 원본의 반복 조회/연결은 carry·만족도·cohort·누적 비용을 초기화하지 않는다. ID 충돌·오래된 조건·부적합 원본은 효과 없이 거부한다. 유효 조건이 해제되면 신규 승차를 막되 기존 cohort 도착과 이미 제공한 구간 비용은 유지한다. 두 번째 실제 수주·복수 노선의 새 배분 정책은 이번 대상이 아니다.

## 3. 분 T 처리와 비용·운임

GameClock은 큰 elapsed 입력에서 먼저 최종 minute까지 이동한다. 따라서 처리 중에는 **각 _tick의 minute 인수 T**를 사용하고 clock.minute의 최종값을 모든 하위 단계에 쓰지 않는다. 기존 다음 순서를 바꾸지 않는다.

| 순서 | W06 삽입·보존 조건 |
| --- | --- |
| PREVIOUS_INTERVAL | 직전 [T−1,T)에 신규 승차를 허용한 서비스 구간이면 운영비100을 T−1 날짜로 1회 발생/지급. 해당 분 수요0도 비용 발생. W05 기성 발생·지급 순서는 보존 |
| 자정 경계 | 전일 운행 집계·만족도를 완료하고 재무 sync + sync_operations 후 close. 이후 새 날짜 집계를 시작. T의 계약/도착은 전일 보고에 들어가지 않음 |
| CONTRACT | 기존 대기 계약·정부 지급·자격/R/K 검사. 같은 T의 후순위 도착 운임을 미리 사용하지 않음 |
| PROGRESS / VALIDATION | 기존 완공·시험/안전·개통. 이 단계 뒤 실제 원본을 대조하므로 T 개통은 T의 새 서비스 구간부터 가능 |
| ARRIVAL | T 도착 cohort만 완료 처리, 실제 완료 수×100을 ledger.fare에 1회 반영. fare 내부 B 자동 정산 보존 |
| SETTLEMENT | 기존 ledger.settle. 앞선 fare 정산과 중복 비용/지급이 없어야 함 |
| BOARDING | 06:00≤일중 시각<24:00, 유효 개통, B=0, 다음 구간100 충당 등 ledger.boarding 결과로 신규 승차 결정. 허용한 구간만 다음 tick 비용 대상으로 기록 |
| T_COMPLETE | 보고의 당일 집계와 관측 snapshot 갱신. 관측은 승객 생성·원장·명령 효과 없음 |

개통 전/일시정지/영업시간 밖에는 신규 요청·승차와 서비스 구간 비용이 없다. 영업시간 내 유효 개통 노선의 재무 제한 중에는 OD 요청을 계산하되 탑승0·정수 미탑승을 기록하고 소수 carry를 유지한다. 잔여 승객만 도착하는 시간의 **추가 운영비는0**이며 원래 허용한 구간 비용을 면제하지 않는다. 운임은 탑승 때 받지 않으며 도착일의 자유현금/매출이다.

실제 operations 활성화와 기존 set_fixture의 운영비/운임/eligible/next_cost 입력 혼용을 거부한다. 활성화 전에 충돌 입력이 예약돼 있어도 활성화를 실패시키고 상태를 그대로 둔다. 운영 모드에서의 set_fixture도 충돌 시 효과0이다. operations 비활성 W02/W05 기존 시험은 그대로 유지한다. 통제 cohort·자금 반례는 테스트 내부 서비스/모델 fixture로 격리하며 실제 개통 시나리오로 표시하지 않는다.

## 4. OD·cohort·보고 공급

- 승인 수요·역 접근성과 OD 최단 경로/동률 처리는 기존 od_pairs를 재사용한다. q는 5분 이하1.0, 10분 이하0.8, 초과0.5, 영업시간 균등 분배다. 고정 분 경계마다 carry 분자에 D×q_tenths를 더해 분모10800으로 정수 요청/나머지를 나눈다.
- OD ID 순으로 **노선 전체 U10/분**을 공유하고 남은 용량은 다음 분으로 넘기지 않는다. 소수 carry만 다음 분/날짜로 유지하며 정수 미탑승은 대기열로 남기지 않는다.
- cohort는 OD·탑승 시각·예정 도착·인원으로 집계한다. 현재 이동 중과 도착 완료를 구분하고 도착 중복·음수/역행·반복 처리로 운임을 늘리지 않는다. 현재 모델에 임의 지연/RNG를 넣지 않으며 지연률 반례는 TEST_ONLY다.
- 만족도 초기50, 일일 변화 `5×탑승/요청−5×미탑승/요청−2×지연완료/완료`, 0~100 clamp. 요청0이면 전일 유지, 완료0이면 지연률0. 내부는 약분한 유리수로 유지하고 화면 소수1자리 반올림은 DEV-023 소비 책임이다. 정수 연산 경계도 검사하며 임의 float 근사로 계약을 바꾸지 않는다.

다음은 신규 공급 필드의 제안이다. 실제 이름·정상/오류 fixture와 Design L2 결과를 이후 공급 증거에 고정한다.

| 공급 묶음 | 최소 내용·판별 기준 |
| --- | --- |
| pipeline.operations 현재 | 활성/가용 여부와 reason_codes, 시각/day_id/T_COMPLETE/snapshot_revision, 권위 계약 ID·condition_revision·opened_at, boarding_allowed, in_transit, OD carry, 당일 누적 |
| 당일/고정 report.operations | requested/boarded/unboarded/completed/late_completed, service_minutes, opening_in_transit/closing_in_transit, 만족도 전후 유리수. 기존 재무 operating_cost/fare/payment/debt_payment/closing_funds는 원장 소유 |
| 고정 보고 식별 | 기존 day_id와 close의 불변 복사본. 새로 조회해도 전일 수치가 현재 값으로 바뀌지 않음. DEV-026의 run_scope/복귀 guard·Session 재생성은 여기서 구현하지 않음 |
| first_valid_report | 마감 보고에 실제 서비스 구간>0·실제 완료>0·그 완료에 대응하는 실제 운임 근거가 있을 때만 해당 day 참조. 영업0/완료0 보고는 유효 표시 자료지만 최초 영업 성공 증거가 아님 |
| next_business_query | 위 보고 참조, 현재 원본 공고/후보와 실제 CLOSED/BUSY 등 조회 결과, reason/기존 allowed_actions. 조회 자체가 재계약·R/K 해제·새 공고 생성/라운드 재개를 하지 않음 |

재고 검산은 `opening_in_transit + boarded − completed = closing_in_transit`이다. 요청/탑승/미탑승은 발생일, 완료/운임은 도착일에 귀속한다. 마감 없음, 정상0, 일부 공급 실패, 자금 제한, 현재와 고정 과거를 서로 다른 공급 상태로 전달하며 누락을0으로 위장하지 않는다. 기존 reason을 재사용하고 새 사유가 필요하면 명시적 공급 계약으로 Design에 제시한다. 새 운행 조작 명령이나 사용자 정책 enum을 임의 확정하지 않는다.

**다음 사업 조회의 현행 제약:** 현재 B01/B02 접수는 최초 영업 보고 전에 종료될 수 있고 원장의 기존 사업 키 때문에 BUSY가 유지될 수 있다. 조회 공급은 이 사실을 그대로 반환한다. 다음 “조회”를 “반드시 새 접수 가능 공고 생성/두 번째 수주”로 확대하지 않는다. HQ/Design이 새로운 모집 회차를 요구하면 그 차이만 별도 명세 검토 대상으로 올리며 모델 준비 전체를 막지 않는다.

## 5. L3 영향 검토와 후속 인계

| 영향 경계 | 위험·검증/종료 조건 |
| --- | --- |
| 공통 시각/분 순서 | T−1 비용, T 개통/도착/승차, clock 최종값 혼용. 경계 로그와 일괄/분할/배속 동등성 |
| 원장·R/K/B | 선사용·정산 중복·정부/공사 자금 전용. 원장 API만 호출하고 전후 현금/원장 항목별 검산 |
| W05 상태 연계 | 다른 사업 OPEN 또는 오래된 revision 소비. 실제 정상 명령 연결과 ID/조건 반례, 기존 시험열차 일반 운임0 |
| 보고·만족도 | 자정 도착의 전일 혼입·과거 보고 변경·예측의 실적 혼입. 고정 사본·날짜/재고/비용/현금 대조 |
| 기존 소비자 | operations 비활성 root/reports의 의미 유지, 활성 payload는 additive. W07·입찰/공사 UI 자동 회귀; 실제 제품 연결은 DEV-023 |
| 증거·범위 | MODEL_CHAIN과 TEST_ONLY를 구분, 기존 수용을 새 head의 실행으로 표시하지 않음. DEV-026 예외 계약·F-08 제작은 유입시키지 않음 |

S2-06/07 모델·자동, S2-09 공급, S2-01 회귀, S2-11 기록이 DEV-022의 직접 인수 범위다. S2-08 GUI와 S2-10 완주, S2-09 실제 사용자 조회는 DEV-023/024에 남는다. 현재 L3 검토는 영향 식별 단계이며 실제 안전성 검증 PASS가 아니다.

DEV-023 인계물은 실제 필드 표·정상/0/자료 없음/제한/실패/current-vs-closed fixture와 원장/보고 대응 증거다. 화면 연결 전에 Design L2를 진행한다. 이미 수용한 Q03~05/W05/Q12를 자동으로 다시 열지 않으며 변경 영향이 드러난 조건만 회귀한다. 실제 승인 의미/부서 경계 차이는 [RFC 양식](../../templates/RFC_AND_DECISION.md)을 따른다.
