# DEV-018 — W04A 실제 공급 계약 및 검증 인계

- 담당 AGT-DEV-0001 / LAPTOP / 2026-11-08 / REVIEW.
- 기준 main b48dd82a9b93d062d1a3bcfdf8750cb260c83e3e; C0.6/D0.9/DATA1.3, Planning [RFC 회신](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6716236853).
- UI 계약 revision `DEV018-W04A-UI-1`. DEV006-UI-v0.2-decision-1의 UI-DC-03/05/07 W04A 부분 구현. W04B·공사/운행 모델·실제 UI/조회 오류 표시·역순 수신 적용은 후속 티켓이며 NOT_RUN.

## 1. 진입 및 명령

제품 연결용 API는 MinutePipeline.enable_tenders(), submit_bid(command), bid_result(command_id), snapshot()이다. enable_tenders는 승인 로더와 실제 RoutePlan 검증 후 단1회 서비스 설치, 잘못된 데이터는 부분 설치 없이 거부한다. 기존 Stage1 제품 진입은 자동으로 입찰을 활성화하지 않으며 DEV-019가 이 API를 연결해야 한다. W04A 모델 검증은 set_fixture 없이 이 진입점과 실제 공고 입력으로 사업을 확보한다. set_fixture는 같은T 후순위 운임/기성의 순서 반례에만 사용한다.

명령 Dictionary의 허용 키/타입은 다음과 같으며 운임/정부금/공기/역 payload를 보내면 FIXED_TERMS다.

| 키 | 타입·단위·의미 |
| --- | --- |
| command_id | 비어 있지 않은 String. 접수·거부·최종 결과를 같은 ID로 재사용 |
| tender_id / round_id | String, B01 / B01-R1 등 안정 ID |
| requested_at | int 게임분, 현재 완료분 이하의 요청 기록 |
| effective_at | int 게임분, 현재 완료분보다 이후인 실제 접수 처리분 |
| expected_snapshot_revision | 0이상 int, 화면 관측 출처. 이 값만 오래됐다고 일괄 거부하지 않음 |
| target_revision / plan_revision | 0이상 int. 공고 대상 및 고정 계획의 확인 버전. 초기 각각0 |

예: completed=360에서 bid-1/B01/B01-R1/requested_at360/effective_at361/expected_snapshot_revision0/target_revision0/plan_revision0을 접수하면 pending,361 CONTRACT에서 최종 접수 결과가 확정된다. 일시정지 중 요청은 pending이며 시간 의존 효과는 재개 전 생기지 않는다. 이미 완료된 분으로 소급 접수하지 않는다. completed1798→effective1799는 유효하지만 completed1799→effective1800은 마감 거부다. requested_at만1799라고1800 실제 접수를 소급 허용하지 않는다. DEV-019는 요청 시각과 실제 접수 시각을 구분해야 한다.

기존 CommandQueue의 계약 시간외 이연을 응찰에 재사용하지 않는다. 응찰의 유효 effective_at가 [360,1800)이면 야간/자정에도 처리한다. 판정·정부 지급은1800 CONTRACT로 연결한다.

## 2. SUP-01~08 실제 대응

`snapshot().tenders`는 Dictionary 봉투, 그 안의 `tenders`는 Array[Dictionary] 공고 목록이다. 목록/자격/허용행동은 동일 완료 관측을 소비하며 이전 결과로 현재 버튼 상태를 덮지 않는 UI 처리 자체는 DEV-019 검증 대상이다. 반환값·입력은 깊은 복사로 보호한다.

| 공급 | 실제 경로·타입·단위 | 명령/fixture·책임·차단 |
| --- | --- | --- |
| SUP-01 | rules_version/data_version/ui_contract_revision:String, snapshot_revision/simulation_minute/day_id:int, observation_phase:String=T_COMPLETE | Pipeline 외부 revision/분과 동일. DEV018 자동,019 통합 전 |
| SUP-02 | rows[].terms의 tender_id/round_id/project_id/issuer_id/city_id:String, station_ids:Array, opens_at/closes_at/fare/government/duration_minutes/standard_cost:int, state:String | B01시청/B02정부·BX비노출. JSON의 수치도 공급 시 int로 정규화 |
| SUP-03 | target_revision/plan_revision:int, plan_locked:bool=true, eligibility:{eligible:bool,checks:Dictionary,reason_codes:Array}, reason_codes:Array, allowed_actions:{submit_bid:bool,enter_p05:bool} | 고정 공고 계획 편집 없음. 현재 자격과 receipt/decision 당시 사본 분리 |
| SUP-04 | submit_bid 결과 pending:bool,command_id:String,effective_at:int. 명령 키는 §1 | 명령ID로 결과 조회. 단순 시간 경과 snapshot 변경은 별도 대상 변경과 구분 |
| SUP-05 | bid_result의 accepted/pending:bool, reason:String,reason_codes:Array, requested_at/effective_at/phase_revision/result_revision:int, 대상/회차/계획/기대revision | 사전 형식 거부는 효과가 없어 effective_at/result_revision을 꾸며내지 않음. receipt는 admission_snapshot 보존 |
| SUP-06 | decision:{awarded:bool,reason:String,effective_at/phase_revision/result_revision:int,funds:Dictionary,score:Dictionary,eligibility:Dictionary,terms:Dictionary,competitor_comparison:Dictionary,tie_priority:Array} | 마감 당시 사본 고정. 초기/마감 F변동·동점·소수 정밀도 반례 |
| SUP-07 | business_contract:{business_contract_id/project_id/status:String,attempted_at:int,effective_at:int 또는 null,phase_revision/result_revision:int,result:Dictionary,government_payment:Dictionary} | 지급 식별자·원장 index·사업R 연결. 낙찰과 계약 거부도 별도 상태 |
| SUP-08 | allowed_actions.enter_p05:bool, p05_reason_codes:Array, construction_contract:{available:false,status:NOT_CREATED} | 유효 사업 계약·지급 이후 P05 진입 근거. 실제 공사 계약 식별자/상태는020, 화면은019/후속UI |

정부 지급에는 available:bool,transaction_id:String,amount:int,effective_at:int/null,ledger_entry_index:int/null,restricted_project_id:String이 있다. transaction_id는 round_id-GOVERNMENT이며 ledger_entry_index는 기존 ledger.entries()의 해당 government 항목 인덱스다. 기존 원장에 거래 ID 필드를 추가하지 않았다. 사업 계약 ID는 round_id-BUSINESS이며 공사 계약으로 재사용하지 않는다.

공고 상태는 NOT_OPEN/OPEN/RECEIVED/AWARDED/CLOSED, 계약 상태는 EFFECTIVE/REJECTED다. 미응찰 종료는 decision.reason=NOT_SUBMITTED, 미체결은 빈 business_contract이며 판정 실패/자료 없음/값0은 구분한다. invalid loader/service의 available=false/errors와 정상 빈 목록 available=true/tenders=[]도 모델에서 분리 검증했다. 실제 조회 실패 UI 제작은019다.

사유: INVALID_COMMAND/INVALID_TARGET/CLOSED_EFFECTIVE_TIME/FIXED_TERMS/UNKNOWN_TENDER/STATE_CHANGED/NOT_OPEN/ROUND_CLOSED/DUPLICATE_BID/OUTSIDE_JURISDICTION/PROJECT_IN_PROGRESS/DURATION_NOT_FEASIBLE/TIE_PRIORITY/LOWER_SCORE. 조건이 같을 때 현재 봉투 revision만 오래된 명령은 허용하고, 회차/대상/계획 변경은 거부한다. 같은 command_id의 다른 payload도 최초 pending/결과를 재사용한다.

## 3. 점수·시각·W05 경계

F는 원장 free_cash=C−ΣR이다. 정수 통화의 정밀도를 손실하지 않도록 재무점수를 numerator=clamp(F,0,1000000),denominator=10000으로 저장한다. 이행능력 c에 대해 비교점수 numerator=7×c×10000+3×재무분자,denominator=10000이다. 사용자 점수는 동일 분자/100000이다. 경쟁자80/80은8000000/10000, 표시80이다. 양변 공통 분모의 정수 분자 비교로 임의 반올림 없이 동일 공식의 대소/동점을 판정한다.

- F1000000,c80: 비교8600000/10000=860, 표시86.
- F800000,c80: 비교8000000/10000=800, 표시80. 경쟁자와 동점→TIE_PRIORITY 탈락.
- F799999,c80: 비교7999997/10000으로800 미만. 재무점수 소수를 정수로 절사하지 않으며 표시 자릿수/한국어 문구는 Design 협의 대상이다. 표시값으로 판정을 재계산하지 않는다.

1800의 마감·점수 판정→조건을 충족한 사업 계약/정부 지급은 기존 CONTRACT 내부에서 실행한다. 기존 이전구간 비용/자정 마감→CONTRACT→PROGRESS→VALIDATION→ARRIVAL→SETTLEMENT→BOARDING 순서를 보존한다. 기존 계약 Queue 처리가 같은 단계에서 먼저 실행되며 새로운 업무 간 우선순위 게임 규칙을 추가하지 않는다. 입찰 명령은 command_id 순서, 공고는 승인 데이터 순서로 결정적으로 처리한다.

각 명령·판정·계약 사건은 phase_revision/result_revision을 기록하고 변화 수를 Pipeline revision에 반영한다. UI 봉투는 최종 T_COMPLETE revision이다. 따라서 동일 게임분이어도 당시 decision.funds는 후순위 운임/기성이 반영된 최종 funds와 다를 수 있다. 실제 revision 값은 fixture JSON을 참조한다.

B01 정상 직후 C1800000/R800000/F1000000/K0/B0 및 정부 지급1회. 유효 사업 계약·project_id·지급 거래/R 연결·고정 조건을 W05가 소비해야 한다. W05는 표준 공사 계약을 별도 생성하고 기성/개통을 수행한다. 본 티켓은 착공·공사 계약·시범/안전/영업을 생성하지 않는다.

현재 서비스의 진행 사업 검사는 기존 R/K 사업 키 존재를 사용한다. 사업 종료/해제 생명주기와 후속 실제 시공 상태의 소비는 DEV-020 연결 때 구체화해야 하며 이 티켓은 두 번째 사업 수주를 구현하지 않는다. 모델의 공기 자격 함수는 승인 시공 기간과 공고 기간을 비교하고 새 능력 최저점은 사용하지 않는다. 미래 비영K 모드 약정은 별도 HQ/Owner 결정 대상이다.

## 4. 실제 검증과 후속

[실행 fixture JSON](DEV-018_W04A_FIXTURES.json)은 Godot 러너의 --evidence 옵션으로 생성했다. 경계9건·독립 B01/B02 정상·접수 후 F변동 동점의 초기/명령/기대/실제 snapshot·원장 비영 항목을 포함한다. 모든 자동 단언은 라벨·기대/실제·성공 여부를 기록하며 복합 값은 JSON SHA256 비교로 최소화한다. 전체 값 비교는 테스트에서 수행한 뒤 요약한다. 원장0금액 fare 반복 항목만 증거에서 생략하고 실제 검사는 원본 전체 entries를 비교한다.

- run_w04a_tests.gd: 데이터/타입/고정조건, 목록/정상빈목록/오류, 경계359/360/1079/1080/1439/1440/1799/1800/1801, 점수/동점/소수, 중복/변경명령/종료회차/stale, 자격/공기/RK, 계약/지급, 일괄/분할·정지/1/2/4, 후순위 운임·기성 순서, 조회/복사/동일 단계 재호출.
- W01/02/03/W07 러너: 기존951단언 회귀. W02의 원장·시간 외 계약 이연·자정·후순위 운임 선사용 금지의 기존 검증 보존.
- --verify-failure-exit: 의도 실패1건/exit1을 별도 확인. fixture의 자동 결과를 실제 GUI 완주로 취급하지 않는다.
- RNG: 새3개 제품 스크립트와 Pipeline 연결은 RNG 호출·생성·시드 설정이 없다. 화면 조회도 입력을 다시 실행하지 않는다. 이는 RNG 비사용 범위 확인이며 미래 F01 seed/state·시퀀스 실행 검증 완료가 아니다.
- DEV-019 최초 통합 전 실제 필드/revision/reason/fixture를 Design L2에서 소비 확인. 역순 수신·0/없음/오류·실제 조작 검수는 해당 UI 구현 후. A01 저충실도 설계는 병행 가능.
- 실제 W04A GUI·S2-02/03 전체·S2-08·VS01 완주·W05/W06·Windows export/성능·최종 MVP: NOT_RUN.

검증 명령·종료·최종 제출 SHA/CI는 [결과](../tasks/DEV-018_RESULT.md)와 PR에 기록한다. 의미 변경 필요 없음. 검수 제출이며 DONE/main 병합은 Owner 별도다.
