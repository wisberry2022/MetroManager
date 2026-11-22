# DEV-027 W04B P1 모델 공급 계약

> **2026-11-22 P3-A 수용·P3-B 계획 후속:** Track A 공급 L2 한정 수용·Track B 정적 이견 없음을 마지막 후속 절에 연결한다. [화면 계획](DEV-027_SCREEN_INTEGRATION_PLAN.md)은 이번 문서7개와 미래 실행19개를 구분한다. 실제 화면 통합은 계획에 포함하되 구현·게임 검증·Git/GUI·DI03 보류는 유지한다. 앞선 상태/증거는 당시 이력이다.


> **2026-11-22 P3-A 구현 후속:** 승인된 Session·Pipeline 연결과 L2 공급 준비의 로컬 검토 결과는 문서 마지막의 P3-A 후속 절을 따른다. 앞선 미실행/미승인 문구는 당시 기록이다. DI03·L2 전 화면 통합·Git/최종 인수 대기는 유지한다.

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

## 8. P3-A 실제 Session·Pipeline 공급 계약 — 2026-11-22

상위 P1 원문은 당시 격리 모델 계약으로 보존한다. 현재 실행 식별과 실제/fixture 표본은 [P3-A 증거 색인](../evidence/DEV-027_SESSION_PIPELINE_L2_EVIDENCE.md) 및 [JSON](../evidence/DEV-027_SESSION_PIPELINE_L2_RESULTS.json)을 따른다. **공급 준비 완료 ≠ Design L2 수용 ≠ 화면 통합**.

### 명시적 API와 상태 권위

`Stage1Session.enable_proposals(seed:int)`가 기존 network/parameters/run_scope/clock/ledger로 Pipeline의 서비스를 한 번 설치한다. 재활성화는 거부하며 main/View에서 호출하지 않는다. `request_proposal(command)`·`proposal_result(id)`로 편집/예측/네 심사·계약을 요청/조회한다. scope는 Session에서 먼저 검사하며 동일 ID는 payload를 바꿔도 최초 결과를 재사용한다. service 명령은 효력 후 최신 결과로 조회된다.

편집 필드는 command_id/run_scope/slot_id/action=`edit_proposal`/현재 binding/station_ids/name, 예측은 action=`predict_proposal`이며 station_ids/name은 받지 않는다. 두 명령의 current binding은 proposal_id/plan_revision/prediction_input_revision이다. 네 기존 심사/계약 명령·decision 참조는 §3을 재사용한다. seed/원장/판정값은 명령에 넣지 않는다.

`snapshot().proposal_ui`는 `ui_contract_revision=DEV027-W04B-UI-1`, run_scope/view_revision/status/available/reason_codes/observation/snapshot/requests를 공급한다. observation은 기존 Pipeline의1.3/T_COMPLETE/게임분·일·snapshot_revision이며 내부 모델 snapshot은1.4/별도 snapshot_revision이다. root의 DEV026-S01-EX-v0.1/1.3 판을 변경하지 않는다. `requests[].command/result/requested_at`, 모델의 `commands`, `review`, `decisions`, `business_contract`는 각각 실제 기록이다.

각 행 `edit_state`는 계획 잠금, `predict_state`는 잠금/유효 계획, `action_states`는 네 심사/계약의 현재 허용·사유다. 요청 당시 거절 reason과 현재 행동 reason을 대체하지 않는다. 현재 draft·예약 submission·심사/보류 decision.submission·contract.permitted_plan을 분리한다. 미계산/실패/유효0/음수도 분리한다.

`S01ObservationContract.proposal_region(root, expected_scope, previous_packet={})`는 root/지역 타입·소속·관측·행동과 심사 사본을 확인한다. expected_scope는 Session이 정하고 previous_packet은 소비자가 마지막 채택본을 보관해 전달한다. 이전 view는 STALE_PROPOSAL_OBSERVATION, 같은 view의 다른 내용은 CONFLICTING_PROPOSAL_OBSERVATION이다. 동일 재수신은 읽기만 허용한다. `inspect`는 proposal_ui를 별도 지역으로 공급하며 자금/보고 등의 기존 지역은 각자의 의존으로 판정한다. 이번에 실제 Control의 이전봉투 저장·focus·화면 복귀는 연결하지 않는다.

### 공유 단계와 실제 사업 출처

Pipeline: 이전 구간 비용/발생 → 자정 마감 → process_review_phase → CONTRACT(일반→W04A→W04B process_contract_phase→W05) → PROGRESS → VALIDATION → ARRIVAL → SETTLEMENT → BOARDING/보고. 일괄 advance의 마지막 clock.minute를 중간 tick에 전달하지 않는다. 제안 심사/계약 단계 API의 중복은 무효과이고 역행/건너뜀은 거부한다. 독립 advance_to는 같은 두 단계를 순차 호출한다.

`BusinessSources.packet`은 `DEV027-BUSINESS-1`, 1.3/관측분·판, sources, source_status를 공급한다. 각 source는 PUBLIC_TENDER/COMPANY_PROPOSAL의 source_id·project_id·business_contract_id·station_ids·business_contract·fare와 원 출처 terms/permission을 보유한다. 제안 terms는 빈 사본이며 가짜 tender를 만들지 않는다. 허가 decision/submission과 지급 transaction/index/amount/분·사업 보호금 존재를 대조한다. 없는 공급은 NOT_INSTALLED, 실패는 INVALID, 유효는 READY로 분리한다. 실패한 제안 공급이 유효 공고 후보를 제거하지 않는다. 소비 `rows`는 변조/중복/다른 원장·분을 다시 확인한다. 같은 원장의 추가 전용 항목 캐시는 소비자별이며 모델/조회/RNG/원장 효과를 만들지 않는다.

ConstructionProject가 실제 station_ids/출처를 보존하고 기존 공사 규칙을 적용한다. Operations는 원 계약/지급/출처·계획/개통 상태를 대조하며 기존 단일 운행·동시 제한을 넓히지 않는다. W04B를 나중에 켜도 기존 PUBLIC_TENDER 공사는 원 계약/역 대조로 유지한다. `query_next_business(confirmed)`는 기존 report_key/first_valid_report 확인을 유지하고 tenders와 선택적 proposals를 구분해 반환한다. 조회로 지급/심사/난수를 실행하지 않는다. 화면의 새 이동/복귀는 P3-B다.

DI03 fact_supply는 available=false/status=DI03_PENDING/facts=[]다. 적격 사실이 정상 공급된0건과 같지 않다. +1440 이후 실제 사건·수요·소비·재접수는 여전히 NOT_RUN이다. 이름/환경/폰트/아트의 기존 공급·미공급·담당/차단 시점은 상세 계획 §5를 그대로 보존한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 9. P3-A 공급 수용·P3-B 소비 계약 준비 — 2026-11-22

[PR #171](https://github.com/wisberry2022/MetroManager/pull/171)은 main `cc8814097634013be8df8b27f166bdee09c7bac6`에 병합됐다. 제출 head `a9111742a74c7369ab7c52f5e24ef5ca51d2c217`와 병합 tree가 동일하며 기존 모델/연결677·영향 회귀3204·로드/의도 실패 및 필수 CI는 원 실행 식별로 재사용한다. 이번 새 게임 실행이나 최신 main 자연 VS02 결과가 아니다.

- [Track A / AGT-DSG-0004](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7073746341): **TRACK_A_P3A_L2_LIMITED_ACCEPTANCE**. 비의존 기능 공급·백엔드 연결 한정 수용, 기능 의미의 추가 필수 수정 없음. UI11은 제한/미공급 의미만, UI12 실제 DI03은 보류.
- [Track B / AGT-DSG-0003](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7073690611): **P3A_SUPPLY_REVIEWED / TRACK_B_STATIC_NO_OBJECTION / SCREEN_ACCEPTANCE_PENDING / GUI_NOT_REQUESTED_NOW**. 공급 의미 이견 없음이며 실제 화면/표현·읽기·수명·복귀 수용은 별도다.
- 과거 P1의 Session/Pipeline 미공급, 승인 전 Git/실행 대기는 당시 이력이다. 원문·기존 검증·raw·실제/fixture 구분과 DEV026 한정 수용/PARTIAL·미관측·P07 구분을 보존한다. DI03 실제 종속 구현·검증 및 S3-10-C·S3-12/HQ·Owner 최종 인수 대기도 유지한다.

[P3-B 계획](DEV-027_SCREEN_INTEGRATION_PLAN.md) §4~5가 실제 Control의 채택본/행동·문구·읽기·화면별 복귀에 대한 **제안/확인 대기**다. §8의 실제 API·게임 의미는 변경하지 않았다. 이미 수용된 공급을 재작성하지 않으며, 남은 소비 계약의 필수 차이만 해당 행 통합 전에 해결한다. 실제 main/View 연결은 다음 P3-B 구현 후보에 포함되지만 이번에는 문서만 작성한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 10. P3-B 실제 화면 소비 연결 — 2026-11-22

- 기준: `1a24e3346d0ec46ca692fe54d5de5656913c3450` + [실행 JSON](../evidence/DEV-027_SCREEN_INTEGRATION_RESULTS.json)의 최종 파일 해시. 신규 commit 없음.
- [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074162935) / [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074161321) B01~06 방향 확인과 Owner 최대19경로 승인에 따라 구현했다. 현재 **LOCAL_REVIEW_PENDING / P4_GUI_INDEPENDENT_NOT_RUN / REMOTE_NOT_SENT**.
- 새 실제 View 자동 **225 PASS**, 영향 회귀 **3120 PASS**(그중 P3-A 모델/공급/VS02 재실행677), 정상 실패0·SCRIPT ERROR0. 새 runner 의도 실패 exit1을 별도로 확인했다. Godot4.7.2 최종 로드 exit0·오류0.
- 제품 코드는 main/Host와 새 proposal View/표시 매핑/씬에 한정한다. 모델·Session·Pipeline·원장·시계·기존 씬·자산/데이터·CI 변경0. 기존 UI 입력 공통 처리와 표시 helper를 재사용해 Host를1000행 이내로 유지했다.
- B02는 `effective_not_before`→접수 가능 최저 시각(성공 보장 아님), `admitted_at`→실제 접수, `completes_at`→실제 접수부터의 완료 예정으로 소비한다. 기존 게임 규칙·심사/난수/지급 계산 추가0.
- 자동 검사에는 실제 Control 신호/합성 키보드와 게임 시간 환산이 있다. 실제 OS GUI·독립 실행·자연 VS02·최종 가독성/물리 DPI·빌드/export·성능은 각각 NOT_RUN. 표시0/실패 등 사본 fixture는 실제 자연 발생과 분리했다.
- P1/P3-A 결과·실패/원본과 Markdown 원문을 보존했다. 비변경 추적774개·공유 데이터2개·별도 F08 문서9개 해시 일치. 검사 당시 CRLF 바이트는 로컬 보관하고 LF 정규화 외 변경0을 검증했다. 최종 로드는 LF 파일로 실행했다.
- DI03 종속 범위 보류, DEV026 한정 수용/PARTIAL·미관측·P07 구분, #92 실제 이름/환경/폰트/아트·최종 규격, S3-10-C·S3-12/HQ·Owner 최종 인수 대기 유지. 새 명세 변경/RFC 필요 없음.
- 로컬 제출 검사: `.venv/Scripts/python.exe tools/policy.py doctor` 및 `check` PASS(793파일/68 GDScript), `git diff --check` PASS. 정확한19경로·18개 provenance blob·UTF-8/LF·원문 보존을 재확인했다. 원격 필수 CI는 PR 미생성으로 NOT_RUN이다.

`main.gd`가 기존 운영 활성화 후 동일 Session에 제안을1회 설치한다. `stage1_view.gd`가 `proposal_panel.tscn`/`proposal_view.gd`를 만들고 명령을 Session에 전달한다. View는 실제 Session scope와 마지막 채택 봉투를 `proposal_region`에 전달하며 동일판 상충/거부를 previous에 저장하지 않는다. 사용 이력에 필요한 추가 타입 확인은 소비자 안에서 수행한다. 표시는 `proposal_presentation.gd`가 담당하고 내부 오류 원 코드를 일반 라벨로 내보내지 않는다.

정보 선택은 명령0, 실제 편집·예측·시청/정부/설득/계약은 각각 공급 권위를 사용한다. 동일 pending 명령의 재입력은 같은 command_id를 재사용하고 실패 후 명시적 새 입력은 새 ID다. 같은 사업 P05 출발 문맥, P06/P07 보고/읽기, 후보 이동과 복귀를 Host가 보관하며 새 Session은 전체 자식을 교체한다. root/map 무효 읽기를 임의 fallback으로 우회하지 않는다. 이 변경은 DI03 공급/생성/소비를 추가하지 않는다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
