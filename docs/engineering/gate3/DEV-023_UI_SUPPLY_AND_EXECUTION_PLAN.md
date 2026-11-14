# DEV-023 — UI 공급 계약·실행 계획

- AGT-DEV-0004 / 2026-11-15 / **L2_SUPPLEMENT_LOCAL_REVIEW / DESIGN_ACCEPTANCE_PENDING**.
- 기준 main: `e379e584e6a9fefa0c581f27903c16e4fc0f5136`.
- [권한·23개 경로](../tasks/DEV-023_W06_OPERATIONS_UI.md), [검증 계획](DEV-023_UI_VALIDATION_PLAN.md).
- 소비 입력은 합병된 [DEV022-W06-UI-1](DEV-022_W06_SUPPLY_AND_VALIDATION.md). 준비 당시 어댑터 제안명은 DEV023-UI-v0.1이었다. 현재 P1의 실제 계약은 **DEV023-UI-1**이며 §7에 필드·실행 패킷을 고정했다. Design 수용이나 새 규칙 승인은 아니다.

## 1. 준비 시점 소스와 변경 이유 — P1 실제 변경은 §7

| 현재 확인 | 필요한 연결 |
| --- | --- |
| main._ready가 Session을 만들고 Stage1View를 붙임. View._ready는 tender/construction만 활성화 | main에서 같은 Session의 enable_operations_ui를 명시적으로 호출. 모델 초기화 실패가 정상0으로 표시되지 않게 공급 |
| Session.snapshot은 current·전일 report·daily_activity·tender_ui/construction_ui를 공급 | 기존 필드를 보존하고 operations_ui/finance_ui/next_business_ui를 같은 관측에서 추가 |
| daily_activity는 운영비 발생/즉시지급/후정산·합계만, report는 바로 전일만 | 상세 P07용 당일 전체 보고와 선택 마감일을 별도 공급. 기존 전일 요약의 의미를 몰래 변경하지 않음 |
| View는 S01·P01/P02·P05만 있고 Map은 편집 계획선을 그림 | 새 P06/P07 Control과 내비게이션, 권위 source.station_ids 운영선/집계 기반 경량 표현 |
| Pipeline.next_business_query는 기존 Tender 전체 봉투를 반환 | 최초 유효 보고의 근거·조회 가능/실패·기존 공고 상태를 읽기 소비해 기존 P01로 이동 |
| 기존 W07 fixture는 합성 운임/비용 사용, 활성 operations는 혼용 거부 | 제품 부팅과 격리 시험을 명시적으로 구분. Session 생성/공통 View._ready의 무조건 활성화는 피함 |

제품 초기화는 enable_tender_ui→enable_construction_ui→enable_operations_ui 순서로 중복 안전하게 구성한다. 새 adapter의 반복 호출은 이미 연결된 모델/통행/cohort/보고를 재생성하지 않는다. 개통 전 SERVICE_NOT_READY는 정상 비영업 상태이고 자료 오류와 다르다. 실패를 숨겨 W06 비활성으로 정상 실행했다고 표시하지 않는다. 기존 W01 DATA 로드 실패와 종료코드 경계는 유지한다.

## 2. 공급·소비 매핑

한 번의 동기 Session.snapshot 안에서 current = pipeline.snapshot, clock, current day 보고, 선택 과거 보고 및 next query를 읽는다. 중간 await/시간 진행 없이 봉투를 구성한다. 루트 view_revision은 UI 관측판, snapshot_revision은 모델 완료판이며 서로 다른 수를 같다고 강제하지 않는다. 현재 수치끼리는 data_version/minute/day/snapshot_revision/T_COMPLETE가 일치해야 한다. 과거 보고는 현재 관측 봉투와 별도의 대상일·고정 내용을 갖는다.

| 소비 구역 | 실제 입력과 제안 출력 | 계약·실패 처리 |
| --- | --- | --- |
| operations_ui | current.operations의 source, available/service_ready/reason_codes/boarding/daily/in_transit/cohorts/od_pairs/satisfaction | 새 봉투에 view_revision·status·snapshot·fixture_label. 알 수 없는 사유는 중립 안내+진단. available=true/개통 전과 available=false 오류 구분 |
| P06 실적 | daily.requested/boarded/unboarded/completed/late_completed/service_minutes, 현재 in_transit | 당일 누계(통행)와 현재 이동 중 재고를 구분. 관측분/기간 표시. 미공급→0 변환 금지 |
| 만족도 | 정수 [분자,분모], 마감 satisfaction_before/after/available/reason_codes | 원값 보존. 빈 after는 미마감이며 0점 아님. 표시 정밀도는 L2-A 대상; 표시를 모델에 다시 쓰지 않음 |
| P06 예상 | 기존 prediction 상태/소속 계획판/입력판/대상기간/생성시각 | 예상은 현재 운영선 실적과 소속이 다를 수 있음. 임의로 같은 노선 비교라고 표시하지 않고 소속/기간 일치 여부 표시 |
| finance_ui 현재 | current.funds의 cash/restricted/free_cash/reserved/available_cash/unpaid·restricted_by_project/reserved_by_project | C/R/F/K/A/B와 사업별 R/K 그대로. R을 자유현금에 합치거나 K를 지출로 재차감하지 않음 |
| finance_ui 당일 | reports.current(day)의 operating_cost/payment/debt_payment/fare/government/construction_cost/construction_payment/operations | 운영 발생·즉시 지급·후정산, 공사 발생·기성 지급을 별도 행. cash_payment=payment+debt_payment는 운영 관련 합계이며 회사 전체 지출로 오표시하지 않음 |
| finance_ui 고정 보고 | reports.report(selected_day)의 값/closing_funds/operations + 기존 _report_scope 기반 display_key | 선택 가능 범위 1..현재일−1. 없음/조회실패/확정0 구분. 보고 선택은 UI 상태이며 원장·마감 재실행 없음. 기존 root.report의 전일 계약 유지 |
| next_business_ui | next_business_query의 available/reason_codes/first_valid_report/tenders/allowed_actions.query | tenders는 배열이 아니라 권위 봉투. 하위 data/minute/revision 대조 후 기존 P01 공급과 연결 |

**다음 조회의 두 상태를 분리한다.** 모델의 allowed_actions.query는 첫 유효 보고 유무를, available은 실제 Tender 공급까지 반영한다. query=true/available=false이면 자료 실패와 재확인 가능 상태이며 정상 목록으로 이동했다고 기록하지 않는다. query=false를 B/현재 현금만으로 true로 바꾸지 않는다.

select_finance_report(day)와 query_next_business(confirmed)는 읽기/표시 어댑터다. 보고일 타입·현재 범위, 처음 표시한 유효 보고의 대상과 현재 공급을 재확인한다. 의미가 변한 대상을 사용하지 않고 무관한 view_revision 증가만으로 일괄 거부하지 않는다. 실패/반복 입력에도 tick·원장·명령 큐·공고 회차·계약은 불변이다. 실제 사업 요청은 기존 P01의 권위 검사를 사용하며 DEV-023이 신규 수주 성공을 만들지 않는다.

## 3. 화면 동선·경량 표현 제안

- S01의 기존 시간 조작·편집·입찰 동선을 보존하고 운영 현황(P06)·재무/보고(P07) 진입을 추가한다. 개통 전에도 현황을 열어 사유를 읽을 수 있고, 진입이 영업 개시 명령이 되지 않는다.
- P06→P07에서 실제 운영비/운임·정산 상세를 확인하고, P07의 유효 보고 근거→다음 공고 조회로 P01을 연다. 조회만으로 공사/계약/응찰을 생성하지 않는다.
- 보고는 현재/선택한 고정 과거를 구별한다. 날짜 전환과 자정 도중에 현재 자금으로 과거 보고를 덮지 않는다.
- 각 새 화면은 복귀 대상을 보관한다. 보고→다음 공고→복귀는 원래 보고 선택을 유지하는 안이다. 기존 직접 S01→P01→S01, P01/P02→P05→복귀 동선을 바꾸지 않는다. 구체 레이블/정보 계층/탭 순서와 복귀 대상은 L2-B 대상이다.
- 변경되는 Host의 새 내비게이션 Control만 수명/입력 연결·포커스·스크롤을 관리한다. 기존 OBS-01 읽기 키 처리를 새 패널로 연결할 때 해당 패널이 보일 때만 동작하게 한다. 가려진 옛 화면 입력·중복 signal, 사용자 포커스 강탈을 검증한다.

운행 연출은 기존 추상 DATA 좌표와 실제 source.station_ids/od_pairs(origin,destination,minutes)/cohorts(boarded_at,expected_at,count)를 읽는 **대표 표식**으로 제안한다. 계획선과 실제 운영선을 구별하고 이동/정차·승하차 피드백에 텍스트 실집계를 병기한다. 정확한 열차 운용/개별 시민 객체가 공급된 것처럼 표현하지 않는다.

권위 game minute와 clock.remainder를 이용한 표시 보간은 화면 전용이다. paused이면 정지, 역행 관측이면 이전 표시 유지, 자정/재무 제한 뒤에도 실제 잔여 cohort의 도착 표현은 계속된다. 읽기 간 건너뛴 사건을 모두 관측한 것처럼 재생하지 않으며, 개별 도착 event ID/정차 시간이 공급되지 않은 부분은 L2-C에서 집계 피드백 방식으로 확정한다. 새 도착 판정·승차량·돈·정차 지연을 연출에서 만들지 않는다. 표시 프레임/창크기/표식 수 차이에 원장이 불변이어야 한다.

새 PNG/스프라이트·폰트/애니메이션 에셋, 최종 상한/FPS·해상도는 범위 밖이다. 기본 도형/컨트롤의 최소 표현을 사용하되 Design의 실제 공급 L2 수용 뒤 적용한다.

## 4. 실행과 영향 회귀

1. **승인 후 공급 작성:** 새 Session 어댑터와 W06 명령 기반 fixture를 먼저 구성. 기존 필드 계약과 inactive fixture 경로 보존. 신규 자동검사로 현재/보고/조회·금전 무효과 입증.
2. **L2 패킷:** 본 매핑을 실제 필드로 갱신하고 정상/미개통/0/없음/실패/재무 제한·자정·보고/다음 조회 사례를 고정 소스 해시와 함께 제공한다. 아래 RFC의 미정 표현만 합의한다.
3. **해당 수용 후 화면 연결:** main 부팅 opt-in, P06/P07, Host 동선과 S01 경량 표현. 제품 경로에 TEST_ONLY fixture/강제 시간 이동을 연결하지 않는다.
4. **로컬 검증:** 신규 UI 자동→기존 영향 회귀→프로젝트 로드→변경 행 실제 GUI. 실패는 해당 소유 파일/승인 범위에서 수정하고 영향 검사만 다시 수행한다.
5. **결과 제출:** 실제 필드·fixture/검증 JSON·로컬 원본 해시·NOT_RUN·한정 Design 인수 요청 패킷을 작성. Owner 검토 전 Git 제출 없음.

분류는 화면 소비 L2다. 활성화로 실제 비용/운임이 제품에서 시작되는 **L3 영향 확인**은 필요하지만 경제·시각 모델의 변경 권한은 포함하지 않는다. W06/W02/W05/W04A와 공통 Session/View를 사용하는 W07/입찰·공사 UI, W01/W03을 검증한다. 소스/명세 차이가 없는 기존 Design PASS를 자동 재개방하지 않으며 Host의 직접 영향(왕복·포커스·현재 재무·새 활성화)만 GUI 재검수한다.

## 5. RFC-DEV-023-01 — 실제 W06 UI 공급·표현 L2 검토 초안

[공식 RFC 양식](../../templates/RFC_AND_DECISION.md)에 따른 **LOCAL_DRAFT / NOT_SENT / ANSWER_PENDING**이다. 외부 메시지를 전송하거나 Design 의견을 대신 작성하지 않았다.

- 요청/응답: Development → Design Track A, S01 표현 경계는 해당 Design 담당과 협의.
- 관련: DEV-023 / UI-DC-02·05·06·07 / S2-06·07·08·09·11.
- 근거: 위 main의 DEV022-W06-UI-1, DSG-002 v0.2, PM-014/016. 기존 정적 의미 전체의 재승인 요청은 아니다.
- 현황: 실제 W06 공급은 main에 있지만 P06/P07과 운영 피드백 화면은 없다. DEV-022 fixture는 DEV_SUPPLIED_DESIGN_L2_PENDING이다.
- **L2-A 데이터 표현:** 정상0·미개통·원본 오류·비영업/B/비용 부족, 동일 T 정산과 탑승 상태, 만족도 유리수/미마감·자료실패, 당일 발생/즉시지급/후정산과 고정보고의 제안 행 구성이 기존 의미와 일치하는지 확인 요청. 정확한 한국어 신규 사유 문구와 표시 정밀도 합의.
- **L2-B 동선/행동:** S01/P06/P07→유효 보고→P01 조회/복귀의 제안 동선, 읽기 전용 이동/재조회와 실제 사업 요청의 구분, 키보드·포커스/스크롤 검수 행을 확인 요청. P01 조기 탐색 자체를 새로 막지 않으며 S2-09 완료는 실제 보고 이후 해당 경로에서 입증.
- **L2-C 경량 표현:** 실제 열차/정차 event 부재를 전제로 대표 표식+이동/정차·승하차 집계 피드백의 충분성과 오해 방지 문구 확인 요청. 정확한 사건 공급이 반드시 필요하다는 의견이면 누락 필드·상태·판정만 명시하여 DEV 모델 소유 범위 영향/RFC로 재검토. 고충실도 아트나 F-08 전체 확정을 선행조건으로 추가하지 않음.
- 영향: L2-A는 해당 P06/P07 표현, B는 동선/Host 통합, C는 S01 운영 연출에 적용. Owner 승인 후 독립 공급/자동검사 준비는 진행 가능. 디자인 미회신을 새 정책 승인으로 해석하지 않는다.
- 답변/결론: Design PENDING / HQ 추가 조정 없음 / Owner 로컬 구현·검증 APPROVED(범위 문서 §1.1), 화면 통합은 해당 L2 수용 후. 게임 명세 변경 필요 현재 NONE; 차이 확인 시 해당 건만 상정.
- 종료 증거: 같은 패킷 revision·fixture/source SHA, 영향 행별 수용/보완 의견, 적용 범위·제외와 실제 GUI 인수 방법. 실제 GUI 완료와 정적 L2는 별도다.

## 6. DEV-026 보류와 후속 인계

이번에는 새 W06 소비 봉투의 필수 타입/판/가용성 검사를 수행한다. S01 root null/전역 버전·run_scope 귀속, 세션 전체 재생성, 기존 EX/CP 20사례의 공통 fallback·카탈로그 적용은 DEV-026에 남긴다. 새 View는 정상 Session 생명주기 안에서 생성하며 테스트 fixture 전환을 DEV-026 세션 교체 구현으로 확대하지 않는다.

향후 DEV-026 재개용으로 변경된 Session.snapshot 필드·신규 자식 View/신호·보고 선택/복귀·운영 마커 상태와 검증 범위를 결과에 인계한다. DSG-008의 L2-A/B/C 사전 의견은 이때 실제 소스에 재대조한다. DEV-026 문서·코드·제품 검증을 이번에 갱신/실행하지 않는다.

## 7. P1 실제 공급 패킷 — DEV023-UI-1 / LOCAL_REVIEW

Owner의 로컬 구현·검증 승인에 따라 Session 공급과 독립 자동검사를 구현했다. 실제 [fixture](DEV-023_UI_FIXTURES.json), [검증 색인](DEV-023_UI_VALIDATION.json), [변경 출처](../tasks/DEV-023_PROVENANCE.json)를 연결한다. 기준 main은 헤더와 같고 소스는 미커밋 상태의 파일 해시로 고정한다. 문서의 화면/동선 제안은 아직 적용하지 않았다.

| 봉투/함수 | 실제 계약 |
| --- | --- |
| 공통 봉투 | ui_contract_revision=DEV023-UI-1, view_revision, status(READY/UNAVAILABLE/FAILED), available, reason_codes, fixture_label, observation(data_version=1.3, simulation_minute, day_id, snapshot_revision, observation_phase=T_COMPLETE) |
| operations_ui | snapshot은 DEV022-W06-UI-1의 사본. source/carry/OD/cohort/boarding/daily/만족도 원값 보존. 활성화 전 UNAVAILABLE, 활성화 실패 FAILED, 정상 개통 전 READY + SERVICE_NOT_READY. 당일 집계·cohort 시각/수·분수 등 신규 소비의 타입/관측 일치를 검사하며 실패하면 빈 snapshot |
| finance_ui | current_funds, current_activity, report_day_range(first=1,last=현재일−1), report_selection(LATEST_CLOSED/FIXED_DAY), report. cash_payment는 payment+debt_payment이고 int64 합계 넘침은 실패. 보고 실패와 현재 재무 가용성은 독립 |
| finance_ui.report | status/available/reason_codes/day_id/display_key/value. 마감 전 보고 없음은 UNAVAILABLE/REPORT_UNAVAILABLE, 조회 오류는 FAILED/원인. READY만 고정 보고 사본을 제공. root.report는 계속 전일 요약 |
| next_business_ui | report_key/first_valid_report/tenders/allowed_actions.query. 실제 Reports의 해당 마감일·서비스분·완료·운임을 대조. Tender 전체 봉투의 시각/판/가용성을 대조. 첫 보고 없음과 query=true이지만 공급 FAILED를 구별 |
| enable_operations_ui() | 기존 tender→construction→operations 연결. 반복 성공 호출은 모델/관측판 재생성 없음. 기존 합성 운임 fixture와 혼용 거부 유지. 제품 main에서는 아직 호출하지 않음 |
| select_finance_report(day) | 정수 1..현재일−1만 수용, 실제 보고가 없는 경우 봉투에서 UNAVAILABLE. 선택만 변경하며 같은 선택 반복은 관측판도 유지. 선택일은 자정 뒤에도 고정; 초기 상태는 최신 마감일 자동 추적 |
| query_next_business(confirmed) | confirmed.report_key와 first_valid_report가 현재 권위 보고와 일치해야 수용. 결과는 accepted/reason/observed_at/report_key/first_valid_report/tenders. 현재 query 공급 재검사, 실패 시 tenders={}. 무관한 View판 증가만으로 거부하지 않음. 시계/원장/명령 큐/계약 변화0 |

운행 비활성은 OPERATIONS_NOT_ENABLED, 새 공급 불일치는 INVALID_OPERATIONS_SUPPLY/INVALID_FINANCE_SUPPLY/INVALID_REPORT_SUPPLY/INVALID_NEXT_BUSINESS_SUPPLY로 기록한다. 날짜 입력 거부는 INVALID_REPORT_DAY, 확인 보고 불일치는 STATE_CHANGED다. 원본이 주는 가용성·미개통·탑승 제한/알 수 없는 사유는 보존한다. 이 식별자들은 공급 진단 계약이며 사용자용 한국어 문구는 L2-A에서 확정한다.

새 검사는 Session이 정상 생성한 관측과 신규 자식 봉투의 경계에 한정한다. S01 root 전체 타입/재생성·전역 run_scope/EX·CP 20사례를 검증했다는 뜻이 아니다. source/OD의 게임 규칙은 DEV-022 권위 모델에 맡기고 어댑터에서 재계산하지 않는다.

### 실제 fixture의 분류와 읽는 방법

- MODEL_CHAIN_SETUP: 실제 Session 명령으로 개통 T4805→Day4 마감 T5760. actual_open/actual_first_report는 제품 수치의 실제 자동 공급이다. preopen과 zero_fixed_report는 정상 Session 초기/마감 상태다. 실제 마우스/키보드 플레이 증거는 아니다.
- MODEL_FIXTURE: activation_failed/fixture_conflict는 통제한 입력 실패, partial_payment/settlement는 직접 원장 입력의 재무 경계다. 제품 자연 발생 증거와 구별한다.
- MODEL_FIXTURE_TO_CONSUMER: 기존 W06 통제 모델로 만든 zero_demand/UNPAID_BALANCE/SERVICE_FUNDS_INSUFFICIENT/same_T_recovery/midnight_residual을 Session 소비 사본에 연결했다. 정상 입찰부터 생성된 사례로 간주하지 않는다.
- CONSUMER_FIXTURE: report_failure/unknown_source_failure/next_supply_unavailable/satisfaction_unavailable은 공급 사본이나 오류 상태 주입이다. 실제 모델이 그런 오류를 자연 생성했다는 증거가 아니다.

midnight_residual은 기존 실제 OD의 자정 잔여 통행 사례이며 U07의 CLOSE-01 통행8/운임800 전용 반례를 대체하지 않는다. 해당 전용 모델 반례는 W06 회귀에 있고 신규 P06/P07 화면 검증은 미실행이다. 모든 패킷의 observation 및 보고 대상일을 함께 읽고, fixture별로 다른 run 기반 report_key를 다른 세션으로 복사해 재사용하지 않는다.

### Owner 전달용 Design L2 검토 요청안 — NOT_SENT

> DEV-023의 Owner 승인 범위 중 P1 Session 공급·자동검사 결과를 로컬 검토안으로 준비했습니다. 계약 DEV023-UI-1과 위 fixture/검증 JSON을 기준으로 RFC-DEV-023-01의 L2-A(실적/재무·오류·만족도 표현), L2-B(보고→기존 공고 조회와 복귀/입력), L2-C(대표 운행 표식과 집계 피드백)를 확인해 주십시오. 정상 명령 기반 자동 공급과 통제/소비 fixture를 구별해 기록했습니다. P06/P07/Host/Map 제품 통합은 아직 실행하지 않았고, 수용 후 진행합니다. 행별 수용 또는 보완할 필드·상태·문구·동선을 같은 패킷 revision과 함께 남겨주시면 반영하겠습니다. 이 요청은 전체 실제 GUI 인수·Stage DONE·DEV-026 재개 요청이 아닙니다.

현재 RFC는 계속 **LOCAL_DRAFT / NOT_SENT / DESIGN_ANSWER_PENDING**이다. 원격 게시·전달은 수행하지 않았다. L2 수용 후 §4의 화면 연결과 U01~U20 중 남은 자동/실제 GUI 검증으로 이어간다.

## 8. Design L2-01~04 후속 패킷 — DEV023-L2-INPUT-1

**DEV_RESPONSE_READY / LOCAL_REVIEW / DESIGN_ACCEPTANCE_PENDING / NOT_SENT.** [#79 정본 회신](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6885914882)과 [#81 연결 회신](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6885920998)에 대한 한 패킷이다. 기존 §5·7의 A/B/C 초안과 아직 미전달 상태는 이력으로 보존하며, 현재 Design 검토 자체가 미실시인 것은 아니다. 정적 표현 기준 회신은 수신했고 최종 화면 통합 수용만 남아 있다.

### L2-01 — 고정 출처·공급→화면 매핑

| 식별 | 고정 값·의미 |
| --- | --- |
| 검토 원격 main | 30cc2ea5f6e7c03aebff1315b6fd00530871ebec. [최신 HQ 인수표](https://github.com/wisberry2022/MetroManager/blob/30cc2ea5f6e7c03aebff1315b6fd00530871ebec/docs/hq/STAGE2_ACCEPTANCE_MATRIX.md)와 Design 회신의 기준 |
| 실제 로컬 코드 base | e379e584e6a9fefa0c581f27903c16e4fc0f5136 + 미커밋 DEV-023 파일. 원격 추가8개는 HQ/POST-MVP 문서이며 제품/테스트 차이 없음 |
| 계약/패킷 revision | 모델 DEV022-W06-UI-1 / 어댑터 DEV023-UI-1 / 이번 인계 DEV023-L2-INPUT-1. 새 게임 의미 revision 아님 |
| 실제 Session 공급 소스 | Git blob b1889ce0355cf299cc05bb5b6edda9fbb1e9da13 / SHA-256 d59f86e3a5c4d256b3742fd384e17e4605abbda181d5b60ed14a2c99e26c7c4a. 이전 P1과 동일 |
| 파일/증거 고정 | [manifest](../tasks/DEV-023_PROVENANCE.json), [fixture](DEV-023_UI_FIXTURES.json)의 l2_supplement, [검증 JSON](DEV-023_UI_VALIDATION.json)의 current_source_sha256/l2_followup. 기존 P1 원본 JSON과 실행 해시 보존 |

새 구현을 포함한 원격 commit SHA는 아직 없다. 위 blob은 commit SHA가 아니며 base+미커밋 파일 해시가 실제 시험본 식별이다. 별도 Git 권한 없이 고정 공개 커밋이 있다고 표시하지 않는다. 동일 패킷을 Owner가 로컬 검토/전달할 수 있게 준비했고 원격 게시 전에는 검토자가 해당 파일을 직접 확인할 수 있어야 한다.

아래 화면 문구·정밀도·동선은 #79 기준을 적용한 **구현 전 소비안**이다. 화면 제작/Design 최종 수용 결과가 아니다. 현재 값은 같은 Session.snapshot 호출의 관측을 사용하고 과거 보고를 현재 게임분으로 바꿔 표시하지 않는다.

| API/필드 | 화면 항목·단위/기간 | 가용성·사유·행동 |
| --- | --- | --- |
| enable_operations_ui() | 제품 main의 Session 생성 후, View 부착 전 W04A→W05→W06 연결 제안 | 실패는 FAILED. 공통 Session 생성/View._ready에서는 자동 활성화하지 않아 격리 W07 fixture 보존. 현재 제품 호출은 NOT_RUN |
| operations_ui.observation + view_revision | P06/S01 관측 게임분·Day·완료판/T_COMPLETE | 모델판과 View판의 수치 동일성을 요구하지 않음. 같은 자식/관측의 값·사유만 결합. 누락/불일치면 해당 현재값 확인 불가 |
| snapshot.source.project_id/business_contract_id/construction_contract_id/condition_revision/station_ids/opened_at | P05 인계 사업·공사와 P06 운영선·개통시각 | 같은 사업/공사 ID를 표시. 없는 ID/개통시각은 생성하지 않음. 계획선과 실제 운영선 별도 |
| service_ready + boarding.boarding_allowed/reason_codes | 개통 유효 상태 / 신규 탑승 허용·제한 | 미개통 SERVICE_NOT_READY, 비영업 OUTSIDE_SERVICE_HOURS, 미지급 UNPAID_BALANCE, 비용 부족 SERVICE_FUNDS_INSUFFICIENT 구분. 읽기 화면 열기는 영업/응찰/공사 명령이 아님 |
| daily.requested/boarded/unboarded/completed/late_completed/service_minutes | P06 당일 요청·탑승·미탑승·완료 통행수 / 서비스분 | 현재 Day 누계. 실제0은 0, 필드 누락은 확인 불가. 통행 수를 고유 시민/열차 수로 부르지 않음 |
| in_transit/cohorts | P06/S01 현재 이동 중 통행수·예정 도착 | 현재 재고이며 과거 보고의 closing_in_transit와 별도. 제한 뒤에도 잔여 통행 도착 유지. 연출은 원장/요청을 만들지 않음 |
| satisfaction / daily.satisfaction_before/after/available/reason_codes | P06 현재 만족도·P07 마감 전후 만족도(점) | 정수 분자/분모 원값을 유지하는 표시안. after=[]는 미마감·미산출, available=false+SATISFACTION_ARITHMETIC_LIMIT는 산술 자료 오류. 0점으로 대입하지 않음. 소수 반올림안은 미확정 |
| finance_ui.current_funds | P07 현재 C/R/F/K/A/B 및 사업별 R/K(금액) | observation의 현재 잔액. K를 지출로 재차감/R을 A로 재분류하지 않음. B만으로 새 계약 차단을 만들지 않음 |
| current_activity.operating_cost/payment/debt_payment/cash_payment | P07 당일 운영비 발생 / 즉시 지급 / B 후정산 / 운영 현금지급 합계(금액) | 합계는 payment+debt_payment이며 회사 전체 지출이 아님. 후정산을 새 발생비로 합산하지 않음 |
| current_activity.fare/government/construction_cost/construction_payment | P07 당일 도착 운임·정부금·공사비 발생·기성 지급(금액) | 운영 지출과 공사 지출을 분리. 원장 원값 소비이며 조회로 정산/지급 재실행 없음 |
| finance_ui.report.day_id/display_key/value/closing_funds/operations | P07 선택 마감일의 고정 재무·실적 | report_day_range 1..현재일−1. UNAVAILABLE=보고 없음, FAILED=조회/공급 오류, READY0=확정0. root.report 전일 의미 유지 |
| root.prediction의 소속 계획/기간/생성시각/상태 | P06 예상과 실제 실적 별도 구역 | 기간/소속이 다르면 직접 동일 기준 비교로 표시하지 않음. 현재 실적으로 옛 예측을 덮지 않음 |
| next_business_ui.first_valid_report/report_key/allowed_actions.query/available/tenders | P07 첫 실제 실적 보고 근거 → P01 기존 공고 조회 | 첫 보고 미충족은 query=false. query=true라도 available=false는 공급 실패·재조회이며 이동 성공 아님. Tender는 data/minute/day/model판/T_COMPLETE를 가진 전체 봉투 |

보고→조회 연결에서는 P07이 실제로 표시한 report.display_key/day_id/value를 next_business_ui.report_key/first_valid_report와 대조한다. 다른 날짜를 보고 있다면 먼저 `첫 실적 보고 보기`로 해당 일자를 선택하는 안이다. 표시한 실제 보고가 일치하고 query/available이 모두 참일 때 그 확인 사본으로 query_next_business를 호출한 뒤 P01로 이동한다. 이 표시 조건은 기존 P01의 조기 탐색을 차단하는 새 사업 정책이 아니다. API만 호출한 자동검사를 실제 사용자의 보고 열람 증거로 주장하지 않는다.

### L2-02 — T362 재무 제한·R/K 보호·회복 연결

Design 지적을 확인했다. 공개 DEV-022 restricted는 T359/revision0·SERVICE_NOT_READY를 추출했으며 W06-08의 T362 재무 제한 결과와 다른 객체다. 모델 결함으로 단정하지 않고 **소비 증거 추출/연결 보완**으로 처리했다. 승인 범위 밖의 DEV-022 파일은 수정하지 않고 DEV-023의 실제 입력을 연결한다.

기존 P1 scenarios.SERVICE_FUNDS_INSUFFICIENT와 UNPAID_BALANCE는 이미 T362 실제 제한이다. 이번 l2_supplement.scenarios의 세 입력은 같은 기존 W06 통제 생성법을 재사용하고 R/K 전후 값을 같이 고정한다.

| JSON 키 | 실제 관측·판정 | 구분 |
| --- | --- | --- |
| l2_restricted_funds.packet | T362/revision3, A0/B0·R200000, SERVICE_FUNDS_INSUFFICIENT, 신규 탑승0·미탑승 누계>0 | 실제 W06 통제 모델 → 소비 사본 |
| l2_restricted_unpaid.packet | T362/revision3, A0/B100·R200000, UNPAID_BALANCE, 신규 탑승0 | 동일 분류. 초기 B1100 중 실제 정산 결과를 표시 |
| l2_restricted_reserved.packet | T362/revision3, K(OTHER)=1000 보호·A0, SERVICE_FUNDS_INSUFFICIENT | R/K 양쪽 전후 동일 단언·원값 동봉 |
| l2_restriction_recovery.before/restricted/B0_still_insufficient/resumed | T365 허용·이동중6 → T366 B50/A0·미지급 제한·이동중6 → T367 B0/A50·비용 부족·완료1 → T368 B0/A150·재개·완료2·누적 탑승7 | **TEST_ONLY** D08=1350/기타 수요0 + T365 비용 의무999450 주입. 자연 제품 실행이 아님 |

마지막 연속 입력은 같은 W06 통제 모델의 실제 cost→arrival→settlement→boarding 순서를 사용했다. T366~368 사이 운영비가 재발생하지 않고 R200000/K0은 유지된다. 현재 공급을 보여주기 위한 각 Session 소비 사본의 report_key는 세션별이며 이 비교를 전역 run_scope 구현으로 확대하지 않는다. 기존 P1 same_T_recovery와 midnight_residual, W06 CLOSE-01 증거는 그대로 재사용한다. 전용 CLOSE-01 8통행 반례와 실제 OD 자정 입력은 별개다.

### L2-03 — 필수 상태 입력 색인

아래 `P1:`은 fixture JSON의 scenarios, `L2:`는 l2_supplement.scenarios 경로다. 의미/입력 대조용이며 기대 화면의 실제 렌더링은 NOT_RUN이다. 해당 입력을 재생성하려면 신규 보완은 `Godot --headless --path . --script tests/game/run_operations_ui_tests.gd -- --l2-supply`, 기존 P1은 같은 runner의 `-- --evidence`를 사용한다. 이번에는 P1 전체를 재실행하지 않았다.

| 상태 | 실제 입력 위치/분류 | 기대 화면·이유·가능 행동 |
| --- | --- | --- |
| 정상 개통/첫 실적 | P1:actual_open, actual_first_report / MODEL_CHAIN_SETUP | 정상 실적·첫 보고; 조회 가능과 응찰 가능은 별개. Day4 마감 이동중5와 T5760 Day5 현재1 분리 |
| 개통 전 | P1:preopen / 정상 Session | SERVICE_NOT_READY·승객/운임0. 현황 읽기 가능, 영업 명령 없음 |
| 정상 수요0 | P1:zero_demand / MODEL_FIXTURE_TO_CONSUMER | 요청0·서비스 비용100·미마감 만족도. 자료 없음으로 표시하지 않음 |
| 보고 없음/운행 비활성 | P1:preopen.finance_ui.report, zero_fixed_report.operations_ui | UNAVAILABLE의 대상 영역/사유 표시. 과거 보고 현재값 대입 금지 |
| 필수 운행 공급 누락 | L2:l2_missing_operations.input/packet / CONSUMER_FIXTURE | 활성 공급에서 누락됐으므로 FAILED/INVALID_OPERATIONS_SUPPLY·빈 현재 snapshot. 정상0과 구별 |
| 실제 원본 오류·회복 | L2:l2_source_error_recovery / MODEL_FIXTURE_TO_CONSUMER | 실제 bind_sources가 거부한 INVALID_OPERATIONS_SOURCE→정상 회복. 현재 운영값 확인 불가/복구, 원장 변화0 |
| 알 수 없는 원본 사유 | P1:unknown_source_failure / CONSUMER_FIXTURE | 오류 상태·중립 설명과 진단 사유 보존. 정상값으로 보정하지 않음 |
| 현재/마감·확정0·조회 실패 | P1:actual_first_report, zero_fixed_report, report_failure | 현재/선택일/고정 값/키 구별. 보고 오류여도 정상 현재 자금은 별도 영역에서 표시 |
| 만족도 미산출 | P1:zero_demand.operations_ui.snapshot.daily | after=[]는 미마감, before=[50,1] 유지. 0점 아님 |
| 만족도 산술 한계 | P1:satisfaction_unavailable / CONSUMER_FIXTURE | satisfaction=[]/daily.satisfaction_available=false/사유 SATISFACTION_ARITHMETIC_LIMIT. 통행 누계와 만족도 오류 영역을 구별 |
| 첫 유효 보고 전/후 | P1:preopen.next_business_ui, actual_first_report.next_business_ui | 전에는 근거 필요, 후에는 표시한 실제 보고 확인 후 조회. 새 수주 성공 아님 |
| query 허용·자료 실패 | P1:next_supply_unavailable / CONSUMER_FIXTURE | query=true/available=false. 실패·재확인, 공고 이동 성공으로 표시하지 않음 |
| 재무 제한/회복·잔여도착 | L2:l2_restricted_* 및 l2_restriction_recovery, P1:midnight_residual | 위 L2-02 판정/시각 그대로. B0만으로 허용하지 않음·비영업 도착 추가비0 |
| 봉투 내부 오래된 판 혼합 | L2:l2_mixed_revision.input/packet / CONSUMER_FIXTURE | operations판이 current보다1 낮으면 해당 신규 공급 거부. 어댑터 자동검사 PASS |
| 정상 새 응답→정상 옛 응답 역순 도착 | L2:l2_delayed_response_inputs.newer/older / CONSUMER_FIXTURE | 전달순서 T365→T364, 기대는 새 화면 유지. **View의 실제 거부 동작은 L2 수용 후 구현·검증**. 이 입력 검사로 GUI PASS 주장하지 않음 |

### L2-04 — 연결·연출·조작/영향 검증 계획

| 연결 | 구현 전 계획·검증 대응 |
| --- | --- |
| P05→P06/P07 | Host 공통 내비게이션에 운영/재무 읽기 진입을 두고 현재 P05의 사업/공사 ID·선택·스크롤·포커스 복귀 대상을 보관한다. 승인 밖 construction_view/기존 scene 수정 대신 승인된 stage1_view의 연결로 구성. 개통 전에도 사유를 읽을 수 있음. U01/17/19 |
| P06→P07 | 동일 Session 관측으로 현재 실적→재무 상세. 뒤로가기는 원래 패널/선택으로. 조회로 계획 편집/입찰/착공 없음. U08/12/17 |
| P07 보고→공고 | 첫 실제 보고를 선택·표시한 뒤 위 L2-01 확인 사본과 최신 조회 공급을 대조. 기존 P01/P02의 CLOSED/BUSY·자격을 그대로 표시. 공고 복귀는 보고일/진입 버튼 포커스 보존. P01→P05의 기존 왕복과 반환 대상이 충돌하지 않게 Host가 문맥별로 관리. U09/13/14/17 |
| S01 운영 표식 | source.station_ids의 실제 운영선과 od_pairs의 origin/destination/minutes, cohort의 boarded_at/expected_at/count로 대표 이동 표식. 실제 열차/정차 event ID·정차 시간이 없음을 명시하고 개별 시민·열차 수를 창작하지 않음. 정차·승하차는 공급된 출발/도착 집계 변화의 최소 피드백으로 제안. 관측을 건너뛴 사건 전부를 재현했다고 하지 않음. 세부 표현 수용 대기 |
| 정지/배속·역행 | 권위 게임분+remainder의 화면 보간, paused 정지. 최신 관측 후 늦은 봉투는 값/사유/행동/선택을 덮지 않음. 동일판의 정상 remainder 변화는 허용. 원장/수요/도착을 연출에서 생성하지 않음. U11/16 |
| 새 GUI 검증 | 제품 main 초기/미개통 → 정상 명령 준비+실제 조작 운영/재무/보고→공고 → 필요한 통제 예외. 마우스와 Tab/Enter/Space, 읽기 키·포커스/스크롤·긴 문구/작은 창·복구를 U01~20의 해당 행에 연결. 실제 측정 창/DPI와 초기화 종류를 기록. TEST_ONLY 준비를 최초부터 자연 제품 완주로 표시하지 않음 |
| 영향 회귀 | UI 연결 후 신규 화면 자동·기존 W07/입찰·공사 UI 및 main 초기화 W01부터 실제 변경 영향 검사. 모델/공통시간·원장 변경이 생기면 해당 W02~06/SEM/CLOSE 회귀. 이미 수용된 P05/Q03~05는 영향 확인 행만 재개방. DEV-024 표준 실제 완주 증거는 관측 범위 안에서 공동 사용 |

고충실도 아트·최종 F-08·두 번째 수주·빠른 공사 전체 E2E·DEV-026 공통 root/세션 교체를 새 선행조건으로 추가하지 않는다. 새 화면 수용은 이 계획의 L2 판정 후 실제 구현/DEV 검증/Design 독립 수용으로 구별한다.

### 한 번에 전달할 회신안 — 로컬 초안 / NOT_SENT

> DEV-023 / AGT-DEV-0004입니다. #79의 정적 검토 및 #81 연결 회신을 확인했습니다. 기존 Owner 로컬 구현·검증 승인 원문은 범위 문서 §1.1, 이번 후속 지시는 §1.2에 연결했습니다. Git 제출·main 병합은 별도 승인 상태입니다.
>
> DEV023-L2-INPUT-1로 L2-01 공급→화면/단위/상태/행동 매핑과 실제 소스 해시, L2-02 T362 제한/R·K 보호 및 T365~368 회복 연속 입력, L2-03 필수 상태 색인, L2-04 연결·연출·조작/영향 검증 계획을 한 패킷으로 준비했습니다. 기존 P1 17개 입력을 보존하고 누락된 입력8개를 추가했으며 보완 자동55단언·실패0/exit0, 의도적 실패 exit1을 확인했습니다. 통제 모델/소비 입력을 제품 자연 도달이나 실제 GUI 증거로 확대하지 않았습니다.
>
> 공개 DEV-022 restricted의 T359 초기 객체는 재무 제한 증거로 쓰지 않으며, 이번 실제 제한 입력을 대체 연결 대상으로 제시합니다. 새 화면/모델 변경 없이 증거를 보완했습니다. 원격 새 commit은 아직 없고 base+미커밋 파일 blob/SHA-256으로 고정했으므로 첨부/공유된 동일 로컬 패킷을 검토 대상으로 삼아 주십시오.
>
> 각 L2-01~04의 해당 화면 통합 수용 또는 남은 구체 보완을 회신해 주시면 그 범위로 통합하겠습니다. 실제 GUI 수용은 구현 후 별도입니다. 기존 Q03~05·P05 인계·W05·OBS-01/Q12 한정 수용과 상위 PARTIAL·기록/환경 잔여, DEV-026 보류를 유지합니다.

## 9. 원격 검토용 제출 — Owner 승인 후속

Owner의 PR 생성 지시에 따라 동일한 DEV023-L2-INPUT-1 패킷을 Commit·Push·PR로 공유한다. 권한은 [범위 §1.3](../tasks/DEV-023_W06_OPERATIONS_UI.md#13-owner-원격-pr-제출-승인--2026-11-15)에 연결했다. 제품/시험/fixture 값·파일 해시는 로컬 검토본과 동일하다. §7~8의 미커밋·NOT_SENT와 Owner 전달문은 작성 당시 기록이며, 게시 이후의 고정 출처는 제출 PR의 실제 head SHA와 해당 파일 링크를 사용한다. 별도 Issue 댓글은 보내지 않는다.

PR parent/base는 30cc2ea5f6e7c03aebff1315b6fd00530871ebec이며 기존 e379e58 실행 증거를 보존한다. Design이 검토할 정본은 §8의 L2-01~04와 fixture.l2_supplement/validation.l2_followup이다. Git 게시가 Design 최종 수용을 대신하지 않는다. 제품 화면 통합·독립 GUI·DEV-024/HQ 인수·DEV-026 보류 경계는 동일하다.
