# DEV-022 — W06 실제 공급·검증 인계

- 담당: AGT-DEV-0004 / Development / 2026-11-14.
- 상태: **IMPLEMENTED / AUTO_VALIDATED / LOCAL_REVIEW_ONLY**.
- 실행 기준 main: `2507cda419ed27e96c5d64ced7666ed7a2e58227`; 미커밋 로컬 구현.
- [Owner 승인·18개 경로](../tasks/DEV-022_W06_OPERATIONS_MODEL.md#11-owner-로컬-구현검증-승인--2026-11-14), [결과서](../tasks/DEV-022_RESULT.md), [승인 검증 계획](DEV-022_W06_VALIDATION_PLAN.md).
- 실제 UI/Design L2·GUI 인수는 NOT_RUN이며 DEV-023/024에 남긴다. DEV-026 구현·검증 보류를 유지한다.

## 1. 구현 경계

`MinutePipeline.enable_operations(network=null, parameters={})`로 명시적으로 활성화한다. W04A와 W05 서비스가 없거나 이미 활성화했거나 충돌하는 경제 fixture가 예약돼 있으면 효과 없이 실패한다. 기본 네트워크/파라미터는 기존 DATA 1.3 로더를 재사용한다. 실제 제품 Stage1Session/View는 변경하지 않았으므로 DEV-023에서 opt-in과 화면 소비를 연결해야 한다.

`OperatingLine`이 OD별 소수 carry·이동 cohort·일별 실적/유리수 만족도를 소유하고 `OperationsService`가 W04A/W05 권위 결합과 서비스 구간·도착·조회 공급을 담당한다. CompanyLedger/DemandPredictor/Clock/기존 W04A·W05·UI 소스는 읽기 재사용했다. 기획 C0.7/D0.9/DATA1.4의 승인 의미와 런타임 data_version 1.3을 구분한다.

## 2. W05 공급 결합

입력은 같은 Pipeline의 T 시각·동일 snapshot_revision을 가진 Tender/Construction 스냅샷이다. `available=true`, DATA 1.3, 원본 배열 구조를 확인한다.

- 사업 EFFECTIVE, project/business ID, 정부 지급 available/transaction ID/원장 인덱스·금액·효력 시각, R/K의 해당 사업 키를 대조한다.
- 공사 계약 ID는 해당 사업계약의 `-CONSTRUCTION`, EFFECTIVE, contract_effective_at≤T여야 한다. 프로젝트와 원본 사업 terms의 역 목록/사업 ID·운임100을 대조하고 기존 RoutePlan으로 유효6~8역을 검사한다.
- OPEN은 service_ready, 유효 opened_at, 시험/안전 PASSED, 결함0·공사 미지급0·완공 시각과 함께 소비한다.
- 단일 사업 모델이다. 여러 공사 원본을 임의로 하나 고르거나 복수 노선의 새 수요/용량 정책을 만들지 않는다.
- 반복 공급은 재초기화하지 않는다. 감소한 원본 시각/revision은 거부하며 동일 노선 조건 revision의 후퇴·계약/역/개통 시각 충돌은 소비하지 않는다. 조건 실효 후에는 신규 승차를 멈추고 이미 발생한 서비스 구간 비용과 이동 cohort를 유지한다.

정부 지급 원장 항목은 CompanyLedger 공개 API에서 추가 후 불변이다. 검증한 동일 사업 지급 참조는 서비스 안에 캐시하고 R/K 키는 계속 확인한다. 새 지급 참조는 다시 검증한다. 이는 금전 처리·공사 완료를 생략하는 캐시가 아니다.

## 3. 분 처리와 회계

기존 PREVIOUS_INTERVAL → 자정 마감 → CONTRACT → PROGRESS → VALIDATION → ARRIVAL → SETTLEMENT → BOARDING을 유지한다. Clock이 먼저 최종 분까지 이동해도 각 처리의 T는 _tick 인수를 사용한다.

| 시점 | 실제 처리 |
| --- | --- |
| T 이전 구간 | T−1에 승차를 허용한 [T−1,T)의 비용100을 T−1 날짜로 인식. 수요0에도 발생 |
| 자정 | 전일 운행·만족도 집계 → 원장/운행 보고 복사 → 1회 고정 마감. T의 도착은 다음 날짜 |
| 계약/공정/검증 | 기존 W04A/W05 명령을 먼저 처리하고 권위 개통을 연결. 같은 T 도착 운임의 계약 선사용 금지 |
| 도착/정산 | 실제 완료 인원×100을 ledger.fare로 반영. 기존 B 자동 정산·R/K 보호 보존 |
| 신규 승차 | 06:00~24:00·유효 개통·B=0·다음 구간100 충당을 검사. 실제 허용 구간만 다음 비용 대상으로 기록 |

재무 제한 중에도 영업시간 내 유효 개통 노선의 요청/정수 미탑승을 기록한다. 소수 carry는 날짜를 넘어 유지하고 정수 미탑승·남은 분 용량은 이월하지 않는다. OD ID 순으로 노선 공용 U10을 배분한다. 기존 승객의 영업시간 외/제한 후 잔여 도착에는 추가 운영비0이다. 자동 회복은 B 정산 뒤 같은 T의 승차 조건으로 결정하며 새 수동 정산/운행 조작을 추가하지 않았다.

활성 operations와 set_fixture의 operating_cost/arrival_fare/eligible/next_cost 혼용은 활성화 전후 모두 거부한다. operations 비활성 기존 W02/W05 시험 경로는 유지한다.

## 4. DEV-023 소비 계약 — DEV022-W06-UI-1

실제 공급은 아래와 같다. 이 계약명은 개발 공급 버전이며 Design 수용을 뜻하지 않는다.

| 위치/API | 필드·의미 |
| --- | --- |
| `pipeline.operations_snapshot()` / `snapshot().operations` | 활성 시 아래 현재 공급, 비활성 helper는 available=false/OPERATIONS_NOT_ENABLED. 비활성 root에는 operations 필드가 추가되지 않음 |
| 현재 관측 | data_version, ui_contract_revision, simulation_minute, day_id, snapshot_revision, observation_phase=T_COMPLETE |
| 원본/가용 상태 | available, service_ready, reason_codes, source의 project_id/business_contract_id/construction_contract_id/condition_revision/opened_at/station_ids |
| 실적/이동 | od_pairs, carry(분모10800의 OD별 분자), cohorts(od_id/boarded_at/expected_at/count), in_transit, daily, satisfaction |
| 승차 상태 | boarding.boarding_allowed/reason_codes. source available=true라도 영업시간·B·다음 비용 조건으로 신규 승차는 제한될 수 있음 |
| `reports.current(day).operations` | 당일 requested/boarded/unboarded/completed/late_completed/service_minutes/opening_in_transit/closing_in_transit |
| `reports.report(day).operations` | 위 필드의 마감 사본과 satisfaction_before/satisfaction_after/satisfaction_available/reason_codes |
| 재무 | 기존 보고의 fare/operating_cost/payment/debt_payment/closing_funds를 그대로 사용. 운행 집계가 별도 현금 원장이 되지 않음 |
| 최초 유효 보고 | first_valid_report: 실제 서비스 구간>0·완료>0·도착 운임 일치인 첫 마감의 day_id/service_minutes/completed/fare |
| `pipeline.next_business_query()` | available/reason_codes/first_valid_report/tenders/allowed_actions.query. 기존 공고의 CLOSED·BUSY 등 원본 판정을 보존하는 읽기 전용 공급 |

만족도는 정수 배열 `[분자, 분모]`다. 마감 전 satisfaction_after의 빈 배열은 아직 산출되지 않았음을 뜻하며 0점이 아니다. 요청0이면 전일 값을 유지하고 완료0이면 지연률0이다. 유리수 연산을 int64로 정확하게 표현할 수 없는 경우 빈 배열·satisfaction_available=false·SATISFACTION_ARITHMETIC_LIMIT로 자료 실패를 표시하고 근사값을 만들지 않는다.

주요 공급 사유는 OPERATIONS_NOT_ENABLED, OPERATIONS_ENABLE_PREREQUISITE, INVALID_OPERATIONS_INPUT, OPERATIONS_FIXTURE_CONFLICT, SERVICE_NOT_READY, INVALID_OPERATIONS_SOURCE, STALE_OPERATIONS_SOURCE, OPERATIONS_SOURCE_CHANGED, FIRST_VALID_OPERATIONS_REPORT_REQUIRED, TENDER_SUPPLY_UNAVAILABLE이다. 승차의 OUTSIDE_SERVICE_HOURS/UNPAID_BALANCE/SERVICE_FUNDS_INSUFFICIENT는 기존 원장 의미다. 구체적인 한국어 문구·표현은 Design L2 대상이며 이번에 임의 UI 문구를 추가하지 않았다.

모든 관측은 복사본이다. reports.sync_operations는 누적 실적을 교체하며 이미 마감한 날짜의 갱신을 거부한다. 자료 없음 `{}`, 정상0, 개통 전, 자금 제한, 원본 실패, 현재/과거 보고를 구분해야 한다. DEV-026의 root run_scope·복귀 guard·Session 재생성은 포함하지 않는다.

## 5. 검증 증거와 L3

실제 명령·종료코드·소스 해시·사례 판정은 [검증 JSON](DEV-022_W06_VALIDATION.json), 소비 가능한 사례 사본은 [fixture JSON](DEV-022_W06_FIXTURES.json)에 기록한다. 최종 W06 179개와 기존 회귀2485개, 정상 총2664개가 PASS했다. 의도적 실패1건의 exit1도 확인했다. Godot 프로젝트 로드는 exit0·ERROR/SCRIPT ERROR0이다.

실제 MODEL_CHAIN은 T4805 표준 개통 후 T5760에 Day4 보고를 마감했다. 요청/탑승4296·미탑승0·완료4291·운임429100·서비스955분/운영비95500·만족도50→55, 마감 C1533600/R200000/F1333600/K0/B0다. 전일 마감 이동 중5와 T5760 도착 후 현재 이동 중1은 서로 다른 관측 시점이다. 이 보고를 참조한 다음 공고 조회 공급은 available=true이며 새 공고/두 번째 수주를 생성하지 않았다.

기존 회귀 실행 이후 W06 전용 입력 버전/자료형·시간 역행·유리수 오류 처리를 보완하고 최종 W06를 재실행했다. 공통 Pipeline/Report의 동작과 기존 테스트 내용은 동일하며 LF 정규화만 구분한다. 각 실행의 실제 소스 해시를 보존하고 과거 회귀를 새 실행으로 표시하지 않는다.

| L3 영향 | 구현/검증 경계 |
| --- | --- |
| 시각·비용 | 고정 T와 직전 서비스 구간, 일괄/분할/배속·일시정지, 개통 첫 분·자정 회귀 |
| R/K/B·운임 | 기존 원장 API 재사용, 제한/예약 보호, B 우선 정산·A99/100, 같은 T 계약 선사용 거부 |
| W05 결합 | 정상 명령의 실제 표준 개통과 TEST_ONLY 부적합/실효 원본을 구분 |
| 보고·만족도 | 날짜/재고/운임·비용 검산, 요청0/완료0·지연·clamp·유리수, 고정 보고 복사본 불변 |
| 기존 소비자 | operations 비활성 계약 보존, W02/W03/W04A/W05/W07/입찰·공사 UI 자동 회귀 |
| 품질 범위 | 모델/자동과 프로젝트 로드는 실제 GUI/플레이·Design 독립 검수·FPS/export 인수가 아님 |

통제 CLOSE-01의 23:59 탑승8·10분 이동·도착 직전 B500은 MODEL_FIXTURE다. 기존 P-A 실제 OD의 자연 발생이라고 표시하지 않으며 별도의 실제 OD 자정 잔여 도착도 검사한다. 실제 명령 기반 첫 영업 보고→다음 조회는 MODEL_CHAIN이고, 이를 실제 제품 조작/VS-01 GUI 완료로 표시하지 않는다.

DEV-023 화면 통합 전에 정상/0/자료 없음/원본 실패/재무 제한·현재/고정 보고 공급을 Design L2에 인계한다. DEV-024 전체 GUI·HQ 통합/Owner DONE은 잔여다. Q03~05 수용·Q12 한정 수용/상위 PARTIAL을 유지하며 새 영향이 없는 GUI를 다시 요청하지 않는다.
