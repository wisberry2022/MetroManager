# DEV-027 W04B P1 모델 공급 계약

- 작성: Development / AGT-DEV-0004 / 2026-11-22 KST.
- 상태: **P1_LOCAL_REVIEW / PRODUCT_INTEGRATION_PENDING / L2_FINAL_PENDING**.
- 기준 main: `1a941196cc6d963db93a9fba6a0386b16710aa46`. 미커밋 시험본은 [증거 색인](../evidence/DEV-027_W04B_VS02_RESULTS.json)의 소스 SHA-256으로 식별한다.
- 승인 범위: [티켓 §7](../tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md#7-p1-비의존-모델-로컬-구현검증-승인--2026-11-22). 실행·검증 결과는 [결과서 §7](../tasks/DEV-027_RESULT.md#7-p1-비의존-모델-로컬-결과--2026-11-22).
- 본 계약은 **단독 모델 API의 실제 로컬 공급**이다. Session/root UI 계약, 지역 의존표, 화면/명령 연결, W05/W06 제품 소비, Design L2 또는 VS-02 수용을 선언하지 않는다.

## 1. 구현 경계

| 파일·역할 | 실제 공급 | 보류 |
| --- | --- | --- |
| `stage3_proposals_v1_4.json`·`ProposalDataLoader` | C0.7/D0.9/DATA1.4의 P-A/P-B·기간·확률 구간·금액·업무시간. 타입/고정값 오류는 부분 데이터 없이 거부 | 예시 노선의 강제 지리 제한, E01 대상 OD/동·반복 수요 효과 없음 |
| `CompanyProposal` | 기존 RoutePlan·PredictionState·DemandPredictor 재사용, 초안/당시 제출 사본·잠금·심사/설득 사용 이력 | 기존 예측/실운행 수요 경로 수정0 |
| `ProposalService` | 명령 멱등·효력 재검사·시청/정부/설득·정상 RNG·동일성 계보·허가 계획에 의한 별도 사업계약 | 실제 Session/Pipeline 초기화·분 단계 연결 없음 |
| `BusinessSources.collect` | 실제 공공입찰/회사 제안 계약의 출처·원장 지급·허가 계획 사본을 검증하는 읽기 전용 변환 | 가짜 tender 생성, 이중 원장, 공사/운영 소비자 변경 없음 |

P1의 계약 검사는 독립 CompanyLedger 객체에서 실제 `contract` API를 호출한다. 정상 게임에서 계약할 수 있게 되었다는 뜻이 아니다. 원장·시계·공사·운영·UI 원본 파일은 수정하지 않았다. DI-03 수요 프로필 파일도 만들지 않았다.

## 2. 모델 API·식별과 관측

`ProposalService.new(network, data, context)`의 context에는 `run_scope:String`, `seed:int`, `completed_minute:int`를 명시한다. 선택적인 `ledger`와 `parameters`는 모델 조립/격리 검사 입력이며 사용자 명령으로 주입할 수 없다. 제품의 정상 예측은 기존 승인 W03 자료를 재사용한다. 음수/0 예측용 검사 파라미터는 fixture로 구분한다.

- `edit(slot, stations, name)`: 기존 유효성·편집 규칙. 실제 역 변경은 plan/input revision을 올리고 예측을 과거 값으로 분리한다. 이름만 바꾸어도 사업 실패 계보는 유지한다. 심사 중 편집/재예측은 거부한다.
- `predict(slot)`: 같은 하루 360~1440 구간의 W03 예측. 원장·시간·RNG 효과0.
- `submit(command)`, `result(command_id)`: 요청/대기/효력 결과를 구분. 아래 계약으로만 유효 명령을 받는다.
- `advance_to(completed_minute)`: 단독 모델 검사에서 완료 게임분을 공급하는 경계. 같은 분 재호출은 효과0, 후퇴는 거부. 제품의 시간 권위는 계속 GameClock이며 P3에서 실제 Pipeline 단계 연결이 필요하다.
- `snapshot()`: detached deep copy. `available/errors`, scope/관측판/게임분, `proposals`, `commands`, 정상 `rng` 계보, 명시적 `fact_supply.available=false/status=DI03_PENDING`을 공급한다. 조회 자체는 계산/추출/지급을 하지 않는다.

slot은 P-A/P-B, proposal은 `scope:proposal:slot`, 사업 원장은 `scope:business:slot`로 기존 W04A의 P-A/P-B 지급 키와 분리한다. 접수한 역 집합의 연결은 `business_alias_slots`로 보존한다. **슬롯별 ID가 다르다는 이유로 다른 사업 자격을 부여하지 않는다.** 같은 슬롯·같은 무순서 역 집합·그 과거 연결에 속한 정부 판정을 함께 검사하며 현재 계획 해시만 비교하지 않는다. 이 ID는 실행 내 식별이며 세이브/영구 ID 규격이 아니다.

## 3. 명령·효력·고정 사본

공통 필드: `command_id`, `run_scope`, `slot_id`, `action`. `expected_snapshot_revision`은 선택적 진단 정보이며 시간/조회판 진전 자체로 명령을 거부하지 않는다. 명령으로 sample·예측값·사업비·임의 효력 시각을 공급할 수 없다.

| action | 필수 의미 참조 | 성공 효력 / 원자성 |
| --- | --- | --- |
| submit_city_review | 현재 `binding` = proposal_id/plan_revision/prediction_input_revision | 유효 예측/계획 재검사, 당시 사본·review_id·시청 횟수·잠금 동시 확정. 30분 뒤 하루 운임−운행비 ≥0 승인 |
| submit_government_review | 현재 binding + 해당 시청 decision_id | 현재 계획의 시청 승인·사업 계보 제한 재검사. 60분 뒤 정상 RNG로 판정 |
| submit_persuasion | 보류 government decision_id | 보류 당시 사본을 유지하고 해당 판정의 1회 사용을 접수 때 소비. 현재 별도 초안으로 대체하지 않음. 30분 뒤 정상 RNG |
| sign_proposal_contract | 허가받은 government/persuasion decision_id | 현재 초안과 별개인 허가 사본으로 기존 CompanyLedger.contract 호출. 실제 지급 거래·제한 사업·사업계약 ID 연결 |

완료된 게임분 T의 요청은 최소 T+1에 효력이 생긴다. 업무시간은 06:00 이상~24:00 미만이며 T60→360, T360→361, T1439→1800, T1440→1800이다. 기간은 요청·등록이 아니라 `admitted_at`부터 기산하며 시작한 심사를 밤에 멈추지 않는다.

접수 전 편집은 가능하지만 의미 revision이 바뀌면 예약은 실패한다. `submission`은 당시 요청 사본이며 현재 `draft`로 바꾸지 않는다. 실패 시 `requires_new_request=true`·구체 사유를 남기고 횟수/추출/사실 소비/지급을 추가하지 않는다. 같은 command_id는 변경 payload를 보내도 최초 기록을 재사용한다. 다른 run_scope는 거부한다.

같은 분에는 완료 심사를 먼저 확정하고 예약을 안정된 등록 순서로 재검사한다. 이 P1 단독 모델은 기존 원장의 계약 연산을 호출하지만 **SEM-03 전체 Pipeline 통합 검증은 수행하지 않았다**. P3에서 기존 CONTRACT·공정·도착·B 정산·탑승 순서를 보존하여 연결한다.

정부 적합800000/설득 성공640000은 허가액이다. 별도 계약 효력 전 현금0효과, 계약 때 같은 사업 R에 1회 지급/매출을 기록한다. 당시 허가 노선으로 인계하며 편집 초안으로 덮지 않는다. 이미 유효한 R/K 사업이 있으면 계약 효력 때 PROJECT_IN_PROGRESS로 재검사한다. B 자체를 새로운 제재로 추가하지 않는다.

## 4. DI-02 정상 RNG·재현

전용 Godot RandomNumberGenerator를 생성 시 한 번 seed로 초기화한다. 정부/설득의 **유효 접수 뒤 첫 완료 처리에만** `randi_range(0,99)`를 1회 호출한다.

| 심사 | 적용 구간 |
| --- | --- |
| 정부 | 0~69 적합 / 70~89 보류 / 90~99 부적합 |
| 설득 | 0~59 성공 / 60~99 실패 |
| 시청 | RNG0 |

동시 완료는 실제 접수 순서, review_id로 추적한다. 로그는 seed/draw_index/호출 전후 state/샘플/범위/결과/review·decision·command/게임분을 보존한다. 큰 state 정수는 JSON 정밀도 손실을 막기 위해 10진 문자열로 내보낸다. 엔진 버전이 다를 때 같은 난수열을 보장하지 않는다.

고정 엔진 `4.7.2.stable.official.ed1daf0bf`의 정상 검색·독립 모델 재현:

| seed | 실제 연속 샘플 | P1 확인 |
| --- | --- | --- |
| 2 | 정부50 | 직접 적합·800000 허가 및 단독 계약 |
| 0 | 정부83→설득83 | 보류·설득 실패 |
| 8 | 정부84→설득13 | 보류·설득 성공·640000 허가 및 단독 계약 |
| 1 | 정부97 | 부적합 |

순수 분기 함수의 0~99 구간 검사는 별도 fixture다. 위 seed는 실제 RNG에서 찾았으며 service에 판정값을 주입하지 않았다. **정상 VS-02 GUI 완주용 후보 seed를 확보한 것**이며 전체 제품 완주를 확인한 것은 아니다.

## 5. DI-03·Design·후속 잔여

- 정부 실패의 `fact_pending.earliest_at = completed_at+1440`은 승인된 발생 기준 시각만 표시한다. 실제 fact 생성/수요 적용/소비는 하지 않고 DI03_PENDING으로 남긴다.
- `CompanyProposal.fact_error`는 관련 business/decision·판정 후·발생 후·미사용의 순수 판별이다. 격리 입력 검사만 수행했으며 실제 E01 공급/재접수 성공 증거가 아니다.
- E01 대상 OD/동, 추가 발생/중첩, 유리수5/4·carry·예측 revision/실운행 및 원자적 소비는 **DI-03 종속 보류**다. 판정 후 시간이 지나도 현재 모델은 정부 제한을 임의 해제하지 않는다.
- 실제 Session/Pipeline 공급·공사/운영 연결은 P3 잔여. `BusinessSources`의 W04A 읽기 호환 검사로 기존 소비자 확장 완료를 주장하지 않는다.
- #146의 실제 공급 L2·지역 의존표·표시/행동 경계 대조 전 화면 통합 대기. 현재 모델 snapshot을 완성된 UI payload로 간주하지 않는다.
- DEV-026 한정 수용/PARTIAL·미관측, S3-12/HQ·Owner 최종 인수 대기 유지. 새 제품 GUI·독립 실행·Design 수용·VS-02·빌드/export는 NOT_RUN.
- 새 게임 명세 변경 필요는 확인되지 않았다. 기존 RFC-DEV-027-01만 OPEN이며 새 정책을 만들지 않았다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
