# DEV-023 — UI 실행·검증 계획

- AGT-DEV-0004 / 2026-11-15 / **P3_IMPLEMENTED_REVIEW_REQUESTED / DESIGN_L2_ACCEPTED / INDEPENDENT_GUI_PENDING**.
- 현재 P3 기준 main: `3e2982ac71be28344c3be5360652f4071c678ce3`. 이전 P1 기준은 각 실행 이력에 보존.
- [착수 범위·권한](../tasks/DEV-023_W06_OPERATIONS_UI.md), [소비 계약·RFC](DEV-023_UI_SUPPLY_AND_EXECUTION_PLAN.md).
- U01~U20은 전체 수용 계획과 기대값이다. P1 실제 실행·잔여는 §6과 검증 JSON으로 구분하며 DEV-022의 과거 PASS를 이번 실행 결과로 복사하지 않는다.

## 1. 증거 종류와 공통 조건

| 분류 | 의미·한계 |
| --- | --- |
| MODEL_CHAIN_SETUP | 기존 W04A/W05 정상 명령으로 실제 W06 공급을 만든 자동 초기화. 유효 개통·첫 실적 보고의 원본이지만 전체 실제 마우스/키보드 완주 증거는 아님 |
| MODEL_FIXTURE | B/자금·자정/cohort 등 통제 입력으로 모델 경계 검사. 제품에서 자연 발생했다고 표시하지 않음 |
| CONSUMER_FIXTURE | 실제 봉투 사본의 누락/타입/0/오류·역행·긴 문자열을 새 View에 전달. 표시 검증이며 원본 모델 생성 PASS 아님 |
| AUTO_UI | Session/View 신호·공급/표시·무효과 자동검사. 실제 사람의 키보드·가독성/GUI 수용을 대신하지 않음 |
| REAL_GUI | 실제 마우스/키보드 입력→현재 화면/모델 결과/로그 관측. 제품 초기화와 fixture 초기화를 명시적으로 구분 |
| INDEPENDENT_REVIEW | DEV 자체 실행과 구별되는 실행 주체의 증거를 Design이 심사. Owner/HQ Stage DONE과 별도 |

모든 실행은 실제 full SHA 또는 base+dirty diff/파일 해시, 엔진·실행 환경, 초기 시각/자금/사업·공사 ID, 입력, 기대/실제, 종료코드, 로그/캡처 해시를 기록한다. 공개 기록에는 불필요한 개인 경로/화면/대화를 넣지 않는다. 최종 코드가 바뀌면 영향받은 검사를 재실행하고 이전 실행의 소스 해시는 보존한다.

## 2. 수용 조건 — U01~U20

AUTO는 신규 runner와 필요한 모델 회귀, GUI는 해당 실제 입력/관측을 뜻한다. '영향 GUI'는 새 화면/Host 변경의 해당 조건만 확인하며 모든 키×배속×크기의 조합 시험을 새로 요구하지 않는다.

| ID | 입력·경계 | 기대 결과 | 수행/근거 |
| --- | --- | --- | --- |
| U01 | 정상 제품 main 부팅·개통 전, W06 활성화 실패 반례 | 같은 Session에 W06 1회 연결. SERVICE_NOT_READY와 오류 구분, 승객/운임 생성 없음. 실패를 정상0으로 숨기지 않음; 기존 DATA 실패 경계 유지 | AUTO + 제품 초기 REAL_GUI |
| U02 | 같은 Session enable 재호출, 기존 W07 합성 운임 fixture | carry/cohort/보고 재생성 없음. 명시적 비활성 fixture 경로 보존, 활성 W06와 합성 운임 혼용 거부 유지 | AUTO; 기존 W07/입찰·공사 UI |
| U03 | 정상 명령으로 표준 개통→실제 영업→Day4 마감 | 공급 기준 사례 T4805→5760, 요청/탑승4296·완료4291·운임429100·운영비95500·만족도50→55. 화면과 해당 원본 수치 일치 | MODEL_CHAIN_SETUP + AUTO + 해당 GUI. 모델 실행을 전체 GUI로 표시하지 않음 |
| U04 | 당일/현재 이동 중/고정 보고·서로 다른 OD 도착 | 기간 누계와 재고/예정·완료 분리. 같은 날짜의 opening_in_transit+boarded=completed+closing_in_transit. 전일 마감 이동중5와 T5760 후 현재1의 차이를 오류로 보정하지 않음 | AUTO + P06/P07 GUI |
| U05 | 유효 개통·정상 수요0, 미개통/자료 없음 대조 | 실적0은 0으로, 자료 없음은 별도. 허용 서비스 1구간당 비용100은 수요0에도 표시. 미개통 일반운임0 | MODEL_FIXTURE/CONSUMER_FIXTURE + AUTO + GUI |
| U06 | B>0/다음 비용 부족, 같은 T 도착 운임·B정산, 영업/비영업 | 신규 탑승 제한과 기존 이동/도착 구별. B0만으로 재개 표시 금지. 모델 boarding 판정·사유를 그대로 소비; 정산을 발생비로 재인식 안 함 | MODEL_FIXTURE + AUTO + GUI |
| U07 | CLOSE-01 통제: 23:59 탑승8·10분 이동, 도착 전 B500 | 익일00:09 완료8/운임800, B0/자유현금 순증300, 잔여 도착 추가비0, 비영업 신규 탑승 불가, 전일 보고 불변 | MODEL_FIXTURE + AUTO + 경계 GUI. 기존 W06 자연 OD 자정 결과와 구분 |
| U08 | 현재 C/R/F/K/A/B, 사업별 R/K 및 당일 비용/지급/정부금/기성 | 원장/보고 원값 일치. payment·debt_payment·construction_payment 분리, K 중복 차감/R 해제 없음. 모델 예 C50/K48·비용3→C48/B1·운임11→C58/B0/A10 재사용 | AUTO + 재무 GUI; W02/W06 |
| U09 | 첫 마감 전·과거일 선택·자정·재조회·없는 일자/잘못된 타입 | 현재/마감금액 분리, 선택일/보고 value.day_id/display_key 일치. 고정 사본 불변. 잘못된 날짜는 거부/없음이며 현재값 대입 없음. 기존 root.report 전일 계약 보존 | AUTO + 날짜/현재·과거 GUI |
| U10 | 확정0/미수신/FAILED, 만족도 분수/미마감 after=[]/연산한계 | 0·없음·실패 구별. 유리수 원값/가용성 유지, 미마감과 오류 구분. 긴/알 수 없는 reason은 중립 안내·진단 | CONSUMER_FIXTURE + AUTO + GUI; L2-A |
| U11 | 같은 Session의 늦은 view판/모델판, 불일치 minute/day/phase, 동일판 remainder 변화 | 낡은 관측이 최신 표시·행동·선택 덮지 않음. 불일치 새 소비 영역은 확인 불가, 동일판 정상 재조회 허용. View판과 모델판 숫자를 같은 종류로 비교하지 않음 | AUTO + 변화 상태 GUI |
| U12 | 보고 선택/재조회·P06/P07/P01 왕복·동일 입력 반복/실패 | clock minute·원장 entries/funds·W04A/W05 상태·실적/cohort·고정보고·명령 큐에 효과0. UI 선택/관측판 변경은 별도 허용 | 일시정지 AUTO 전후 비교 + GUI 로그 |
| U13 | 보고 없음/서비스0/완료0, 첫 유효 보고 이후, query=true/available=false | 유효 보고 전 다음 조회 성공 없음. 유효 후 source first_valid_report와 연결. 공급 실패는 실패·재확인 가능으로 표시, stale 목록 정상표시 금지. 조회 성공≠새 수주 | AUTO + 보고→조회 GUI |
| U14 | 유효 보고→기존 공고 목록/상세→복귀, 이미 CLOSED/BUSY | 원본 목록/자격/마감 유지. 새 회차/정부 지급/계약·접수 없음. 재조회 시 의미가 달라진 대상 재확인; 무관한 판 증가만으로 일괄 거부하지 않음 | AUTO + 실제 마우스/키보드; S2-09 |
| U15 | 실제/예측의 계획·기간·자료 생성 시각 차이, 과거 명령 거부와 현재 허용 | 예상이 현재 실적을 덮지 않음. 당시에 거부된 결과와 지금의 허용 구별, 없는 시각/ID 창작 없음 | AUTO + P06 예상·실적 GUI; 기존 W03/W07 |
| U16 | 운영 표식 이동/정차·승하차, 정지/재개·1/2/4배속, 스냅샷 간격/그림 호출 수 변경 | 동일 입력/같은 게임분 원장·실적 동일. paused 연출 정지, 잔여 도착 유지. 표식≠열차/시민 수 약속, 조회/연출로 사건 생성·수요/돈 변경 없음 | AUTO + 각 속도 실제 GUI 관측; L2-C |
| U17 | S01↔P06/P07, 보고→P01→복귀, 기존 P01/P02↔P05 | 선택·보고일·포커스/스크롤의 합의된 복귀, 숨은 화면 키/중복 signal 없음. 조회만으로 계획 추가/입찰/착공하지 않음 | AUTO + 마우스/Tab/Enter/Space·읽기 키 영향 GUI |
| U18 | 긴 한국어 사유·큰 금액/분수·부족한 창 폭/높이, 스크롤 끝 | 필수 현재/과거·상태/금액·단위·불가 사유가 읽힘. 포커스 가림/갇힘·가로 넘침으로 행동 소실 없음. 실제 측정 크기/DPI 기록, 최종 F-08 규격으로 승격 안 함 | CONSUMER_FIXTURE + AUTO 구조 보조 + 실제 GUI |
| U19 | 새 소비 영역 누락/잘못된 타입→정상 복귀, 반복 화면 전환/종료 | 오류 영역에서 옛 현재값·허용상태 재사용 없음. 정상 복귀 시 올바른 데이터/선택. 새 연결의 입력·signal 누수/중복 없음. DEV-026 전역 세션 교체 시험으로 확대 안 함 | AUTO + 영향 GUI |
| U20 | runner 정상/의도적 실패, TEST_ONLY 실행과 제품 분리 | 정상 exit0, 의도적 실패는 exit1. fixture 라벨/초기화 경로 명시, 제품에 테스트 버튼/강제 성공/주입 로드 없음. 캐시/로그/증거 분류·해시 확인 | AUTO + 정적 검사 |

U03의 수치는 기존 DEV-022 사례를 **재현할 기대값**이다. 기존 [fixture JSON](DEV-022_W06_FIXTURES.json)의 model_chain_open/first_report_next_query/zero_demand/restricted/recovery/close01/invalid_source_consumer와 원본 [검증 JSON](DEV-022_W06_VALIDATION.json)을 연결한다. 새 Session 초기화·실제 입력 시각이 달라진 GUI는 해당 실행의 실제 원장값으로 검산하며 T4805/5760을 강제로 맞추지 않는다.

## 3. 예정 자동검사·프로젝트 로드

실행 승인 후 전용 .venv와 저장소 고정 gdtoolkit 4.5.0을 준비하고 Godot 4.7.2의 실제 실행 파일/버전을 기록한다. 사용자 프로필 충돌을 피하려면 APPDATA/LOCALAPPDATA/TEMP/TMP를 해당 worktree의 .local 아래로 분리하되 safe-save를 끄거나 검사 정책을 우회하지 않는다.

예정 명령(`$Godot`은 해당 PC에서 확인한 엔진 실행 파일, 새 runner 플래그는 구현 후 실제 계약으로 확정):

```powershell
.venv/Scripts/python.exe tools/policy.py doctor
.venv/Scripts/python.exe tools/policy.py check
& $Godot --headless --path . --script tests/game/run_operations_ui_tests.gd -- --evidence
& $Godot --headless --path . --script tests/game/run_operations_ui_tests.gd -- --verify-failure-exit
& $Godot --headless --editor --path . --quit
```

관련 기존 runner는 같은 `--headless --path . --script tests/game/<runner>` 형식으로 각각 실행한다. 자동 로그/엔진 종료코드와 실제 GUI를 구분한다.

| 기존 runner | 이번 관련성 |
| --- | --- |
| run_w01_tests.gd | 제품 main의 초기화/실패 경계 및 DATA 보존. 코드 검사만으로 실제 부팅 완료로 표시하지 않음 |
| run_w02_tests.gd | 제품에서 활성화되는 비용·도착·정산·자정 원장 |
| run_w03_tests.gd | 같은 Network/parameters 및 예측 소비·노선 소속 |
| run_w04a_tests.gd / run_w05_tests.gd | 유효 사업/개통·공통 분 순서와 조회 무효과 |
| run_w06_tests.gd | 실제 모델 전체 계약, fixture 혼용·자정·첫 보고 |
| run_w07_tests.gd | Session/Host/Map·현재/과거·정지/배속·기존 fixture |
| run_tender_ui_tests.gd / run_construction_ui_tests.gd | Host 동선·신호·포커스, 기존 자식 공급 |

기존 runner는 수정하지 않는다. 새 활성화/소비에서 회귀가 나면 새 변경을 먼저 고치고, 기존 기대 의미 수정이 정말 필요하면 근거와 추가 경로 승인을 검토한다. 정책/모델 파일을 임의로 확장하지 않는다.

## 4. 실제 GUI와 Design 인수 패킷

1. 제품 main을 정상 실행하여 초기화·P06/P07 진입·개통 전 상태·시간 조작·기존 입찰/공사 왕복을 직접 관측한다.
2. 실제 W04A/W05 명령으로 생성한 W06 상태를 정상 제품 View에 연결한 검증 전용 초기화에서 운영/재무/보고→조회 입력을 직접 수행할 수 있다. **MODEL_CHAIN_SETUP + REAL_GUI**로 기록하고 최초 시작부터의 자연 제품 완주로 주장하지 않는다.
3. 일반 제품 정상 경로로 이미 확보한 운영 세션/완주 증거가 있다면 같은 SHA·입력·원장/환경 근거를 확인하여 관측된 조건만 재사용한다. 독립 초기 상태부터 전체 B01→보고→다음 사업 UI 완주는 DEV-024 책임으로 유지한다.
4. 자연 정상 경로에 없는 제한/실패/자료 없음/0/자정 수치는 별도 MODEL_FIXTURE 또는 CONSUMER_FIXTURE로 명시해 필요한 GUI 행만 관측한다. 테스트 전용 UI와 제품 경로를 분리한다.
5. 독립 실행자는 시험본·주체·환경을 기록하고 Design이 실제 원본 입력→화면→로그를 심사한다. DEV 자동 signal 호출·정적 캡처만으로 독립 REAL_GUI 인수 처리하지 않는다.

하나의 패킷에 U-ID별 초기화 종류·입력·기대/실제·PASS/FAIL/NOT_RUN·full SHA/소스 해시·원본 위치·로그/캡처 해시·종료코드·환경·미해결을 묶는다. 독립 검수는 한 대표 회신에 영향 행을 모으고 이슈별 중복 완주를 요구하지 않는다. 패킷 전달/Issue 회신은 이번 준비 권한 밖이므로 초안만 작성한다.

## 5. 종료·후속 판단

- 로컬 구현 검토: 승인 경로·L2 수용 범위, 자동/로드/DEV GUI 결과, 알려진 결함/NOT_RUN과 독립 검수 준비를 제출. 미실행 GUI를 자동검사 PASS로 대체하지 않는다.
- 화면 인수: Design의 해당 범위 독립 수용을 별도로 연결. 실패/미확인은 조건과 차단 대상만 표시한다.
- Commit·Push·PR/필수 CI·main 병합은 개별 승인 후. 이번에는 preflight/원격 CI도 NOT_RUN이다.
- VS-01 전체/Windows build/export/FPS·물리 DPI 최종 인수/외부 사용성·Stage DONE은 이번 완료 조건으로 추가하지 않으며 잔여 상태를 보존한다.
- Q03~05·W05·OBS-01·Q12 한정 수용 및 Q12 상위 PARTIAL 유지. 관련 Host 변화는 직접 영향만 확인한다.
- DEV-026 구현·제품 검증은 **보류**. 새 W06 자식의 필수 오류 검증을 실시해도 DEV-026 공통 20사례 완료로 표시하지 않는다.

## 6. Owner 승인 후 P1 실행 범위 — 후속 기록

Owner의 현재 로컬 구현·검증 승인과 L2 선행 조건은 [범위 §1.1](../tasks/DEV-023_W06_OPERATIONS_UI.md#11-owner-로컬-구현검증-승인--2026-11-15)에 기록했다. 위 계획의 실행 승인 대기/예정 문구는 준비 시점 이력이다. 실제 P1 결과는 [결과서 §6](../tasks/DEV-023_RESULT.md#6-owner-승인-후-p1-공급-구현검증--로컬-결과)와 [검증 JSON](DEV-023_UI_VALIDATION.json)을 따른다.

run_operations_ui_tests.gd의 현재 범위는 **P1_SUPPLY_ONLY**다. P1-01~11은 활성화/실패, 정상 명령 개통·첫 보고, 조회 무효과, 보고 선택, 재무 경계, 신규 운행 공급 오류, 다음 조회 실패, 통제 모델 공급, 시간/조회, 사본 격리를 검사한다. P1-12는 별도 의도적 실패 종료코드 검사다. View/씬 렌더링이나 키보드 GUI runner가 구현된 것처럼 표시하지 않는다.

| 기존 수용 행 | 현재 P1 증거 범위 | 남은 범위 |
| --- | --- | --- |
| U01~U06, U08~U10, U12~U14, U19 | 신규 Session 공급·무효과·실패/회복 자동검사와 관련 모델/기존 UI 회귀 | 제품 main 연결, 새 패널 표시/행동 및 실제 GUI |
| U07 | W06 CLOSE-01 모델 회귀 및 신규 실제 OD 자정 공급 사본 | CLOSE-01 새 패널 소비/표시 및 실제 GUI |
| U11 | 새 봉투 내부 minute/day/model판·revision 불일치 거부 | View에서 늦은 응답/동일판 보간 처리 |
| U15 | 기존 예측·Session 계약 회귀 보존 | P06 예상/실적의 소속·기간 표시 |
| U16 | 정지 조회 무효과, 같은 게임분의 1/2/4배속 모델 동일 | 운영 중 대표 표식·보간/그림 호출 변화 및 실제 GUI |
| U17~U18 | 기존 Host/입찰·공사 자동 회귀만 | 새 화면 왕복·포커스·긴 내용/작은 창의 입력·가독성 |
| U20 | 현재 P1 runner exit0/의도적 exit1, TEST_ONLY 격리·해시·출처 | 후속 화면/GUI runner가 추가되면 해당 범위 검사 |

따라서 **U01~U20 전체 PASS가 아니다**. P1-01~11 자동 결과와 U-ID 전체 수용을 별개로 기록한다. Design L2/독립 GUI, 실제 플레이, build/export/FPS, 원격 CI/preflight는 NOT_RUN/PENDING이며 DEV-026 보류도 유지한다.

## 7. Design 회신 후 입력 보완 검사

DEV023-L2-INPUT-1은 [실행계획 §8](DEV-023_UI_SUPPLY_AND_EXECUTION_PLAN.md#8-design-l2-0104-후속-패킷--dev023-l2-input-1)을 정본으로 사용한다. 기존 정상 P1 3,041단언 기록은 그대로 보존한다. 이번에는 제품/모델/Session/기존 fixture 변경 없이 신규 runner의 TEST_ONLY 분기만 추가했으므로 전체 모델·GUI 회귀를 반복하지 않았다.

`Godot --headless --path . --script tests/game/run_operations_ui_tests.gd -- --l2-supply`: **55단언·실패0·exit0**. L2-02-R은 T362 세 제한/RK보호27단언, L2-02-C는 통제된 연속 회복16단언, L2-03-S는 누락/원본 실패·회복/관측 불일치·응답 입력12단언이다. `-- --verify-failure-exit`는 의도적1실패/exit1 감지를 확인했다. 엔진/스크립트 오류0이며 실제 결과·원본 로그/소스 해시는 검증 JSON의 l2_followup에 있다.

L2-02-C의 기본 수요 초기 입력은 원하는 잔여 도착/완전 회복을 충분히 만들지 못했다. 실패한 두 탐색 실행을 보존하고, 실제 7분 OD의 TEST_ONLY 수요를 D08=1350/나머지0으로 명시하여 T365~368의 입력 목적을 재현했다. 제품 수요/서비스/원장 규칙은 수정하지 않았다. 현재 P1 시험 함수/기대값과 기본 실행 경로를 보존했다.

L2-03-S의 역순 응답은 실제 공급 사본의 전달순서 입력을 마련한 것이며 새 View 동작을 검증한 결과가 아니다. 미구현 GUI 제출을 통합 전 조건으로 요구하지 않는 Design 지침을 따른다. 프로젝트 editor 로드·실GUI/플레이·빌드·Design 최종 수용·원격 CI/preflight 및 DEV-026 구현·제품 검증은 이번 후속에서 NOT_RUN이다. 기존 P1 로드/회귀 결과는 당시 파일 해시의 이력이다.

## 8. 원격 제출 검사와 기존 실행의 구분

Owner의 원격 PR 생성 승인에 따라 최신 main 30cc2ea 기준으로 제출한다. e379e58 이후 제품/테스트/규칙 차이는 없고 검토받은 제품·테스트·fixture/validation JSON 바이트도 그대로다. 이미 통과한 게임 검사를 문서/출처 갱신만으로 반복하지 않는다. 현재 제출에서 doctor/check·승인12개 경로/기존 해시·manifest, 정상 commit/push 훅·커밋 후 preflight와 실제 head의 필수 CI를 확인한다.

P1 3,041단언과 L2 55단언은 서로 다른 실행 단계의 기록이다. 기존 source_sha256 및 current_source_sha256과 실행별 raw hash를 보존하고 새 head의 신규 전체 실행으로 합산하지 않는다. 실제 제출 head·CI 링크는 PR 본문/Checks가 정본이며 미실행 UI/GUI/build 및 Design 수용·main 병합·DEV-026의 경계는 유지한다.

## 9. P3 실행 결과 행별 인계

현재 결과는 validation JSON.p3_integration에 원본/입력 종류·실행별 소스·로그/캡처 해시와 연결한다. 아래 GUI는 DEV 관측 범위이며 Design 독립 수용은 전체 PENDING이다. 기존 공급 L2는 ACCEPTED로 유지한다.

| ID | 자동/공급 | DEV 실제 GUI | 관측 한계/후속 |
| --- | --- | --- | --- |
| U01 | PASS | G04 | 제품 초기화/미개통. 활성화 실패는 기존 P1 공급 반례 재사용 |
| U02 | PASS | NOT_RUN | 명시 opt-in/기존 W07 fixture 보존. 별도 GUI 필요 없음 |
| U03 | PASS | G01/G05 | 정상 명령 초기화 후 실제 화면. DEV-024 자연 완주 아님 |
| U04 | PASS | G01 | 현재 이동중1와 Day4 마감5/완료4291 분리 |
| U05 | PASS | G04; 정상수요0 GUI NOT_RUN | 정상0 소비 자동과 미개통 실제0 구분 |
| U06 | PASS | G02; 회복 연속 GUI NOT_RUN | B100 제한 GUI와 B0 부족→재개 자동 입력 |
| U07 | REUSED_P1_MODEL_AND_AUTO | NOT_RUN | CLOSE-01 00:09 전용 GUI 후속. 자정 후 실제 공급 소비는 G01 |
| U08 | PASS | G01/G02/G03/G04 | 현재/당일/기성/운영비 지급 합계, R 보호/큰 값 |
| U09 | PASS | G01 | 일자 선택/첫 보고/복귀. 잘못된 타입은 기존 P1 재사용 |
| U10 | PASS | G03/G06; 일부 예외 GUI NOT_RUN | 정확한 큰 분수/산술 오류/미마감. 확정0·원본실패/복구 자동 |
| U11 | PASS | 역순 응답 직접 GUI NOT_RUN | 낡은 모델/게임분/View판 거부와 동일판 remainder 수용 |
| U12 | PASS | G01 | 읽기/왕복 게임효과0. 실제 입력과 현재/고정 보고 로그 |
| U13 | PASS | G01/G02/G04 | 유효 보고 전/후 및 query 공급 실패 구별 |
| U14 | PASS | G01 | 기존 CLOSED 목록 진입 후 P07 복귀. 새 수주 없음 |
| U15 | P1_PREDICTION_REUSED / DISPLAY_REVIEW | 미계산 G01/G05; 계산 완료 GUI NOT_RUN | 예측 현재값의 계획/기간/생성 시각 별도 코드. 독립 해당 행 후속 |
| U16 | PASS | G05 | 동일시각 동일 표식/그림 호출 효과0/정지/1·2·4배속. 정확한 열차 event 재생 아님 |
| U17 | PASS | G01/G03/G04 | P05 왕복 자동·기존 공사 회귀, 보고 왕복/포커스/Tab/Space 실제. 새 전체 조합 없음 |
| U18 | PASS_STRUCTURE_AND_KEYS | G03 | 800x600 / viewport1152x864. 물리 DPI·F-08 최종 규격 확정 아님 |
| U19 | PASS | G02/G06 및 종료0 | 잘못된 타입/누락·복구 자동. 전역 Session 재생성 제외 |
| U20 | PASS | GUI 종료0 | 정상202/의도적 exit1·제품 TEST_ONLY 로드 없음 |

공급 문서 §10의 구현과 Owner §1.4의 Git 권한으로 PR/필수 CI를 진행한다. 실제 PR head와 CI는 PR/Checks가 정본이며 새 head의 미실행 게임 검사를 PASS로 소급하지 않는다.
