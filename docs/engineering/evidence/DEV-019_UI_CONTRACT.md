# DEV-019 — A01 실제 UI 공급·소비·검수 인계

- 담당 AGT-DEV-0001 / LAPTOP / 2026-11-08 / REVIEW. base main3aad051c46230fae04314e082dcf5b39a1a1004f.
- Planning RFC-DEV-018-01, [Design 마감 매핑 수용](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6716760279)을 반영했다. 실제 Design 독립 GUI 수용·S2 인수는 별도다.
- UI-DC03/05/07·DEV018-W04A-UI-1을 소비한다. 모델/원장/Clock/Queue/Pipeline·기획/디자인 원본/기존 테스트·main.gd·기존 scene·project 설정은 수정하지 않는다.

## 제품 진입·책임

S01의 “공공입찰 목록 열기”→P01→B01/B02 선택/상세→P02 “응찰 요청”→실제 게임시각 진행→접수·마감 판정·사업 계약/정부 지급→허용된 “P05 인계 정보 확인”→복귀. 고정 공고 조건은 읽기 전용이며 선택·조회·화면 이동은 새 응찰/지급/착공을 실행하지 않는다.

기존 Stage1View의 HUD와 단일 Session.advance_usec가 시각을 진행한다. 입찰 패널은 별도 시뮬레이션/타이머를 소유하지 않는다. 기존 S01 계획/지도/예측/재무/보고는 복귀 후 동일 상태를 유지한다.

Session.enable_tender_ui는 명시적으로 DEV018 Pipeline.enable_tenders를 호출한다. Session.request_bid는 일반 Stage1 dispatch와 분리해 실제 효력분/result revision을 현재분으로 덮지 않는다. Session.refresh_tenders는 읽기 전용 재조회이며 정상 동기 공급에 가짜 로딩을 만들지 않는다.

## 실제 공급/소비 경로

| 경로·타입 | 역할/소비 규칙 |
| --- | --- |
| Session.snapshot().tender_ui:Dictionary | view_revision:int, status:String,reason:String, snapshot:Dictionary,funds:Dictionary,requests:Array,next_effective_at:int,fixture_label:String |
| tender_ui.snapshot | 원 Pipeline current.tenders의 동일 완료 봉투·권위 공고/자격/허용행동/receipt/decision/business_contract. rules/data/UI revision 및 T_COMPLETE 검사 |
| tender_ui.funds | 같은 Pipeline 관측의 현재 C/R/F/K/A/B. 당시 판정 자금은 decision.funds/score로 분리 |
| tender_ui.requests[].command/result | 원명령ID·대상·회차·확인revision·요청분 및 실제 pending/accepted/사유/효력/result_revision. 명령별 이력이며 현재 행동의 권위가 아님 |
| next_effective_at | Session이 지금 생성할 명령의 후보 current minute+1. 접수 성공 보장이 아님. 실제 pending/효력/거부는 Pipeline 결과가 권위 |
| TenderView.present(packet):bool | 오래된 view/snapshot revision 거부. 지원 계약의 현재 봉투만 적용. UI가 F→점수/자격/마감 판정을 재계산하지 않음 |
| TenderView.accept_result(record):bool | 결과를 원명령 이력에만 귀속. 완료 후 낡은 pending·낮은 result revision으로 퇴행하지 않음. 최신 버튼/선택/snapshot 변경 없음 |

### 마감 직전과 확정 상태

completed1798→후보1799, completed1799→후보1800을 표시한다. 현재 공급이 OPEN/submit_bid=true여도 버튼은 “응찰 요청”이며 접수 보장을 뜻하지 않는다. “마감 T=1800 / 지금 요청의 처리 예정 T=1800 / 최종 접수 여부는 실제 효력 단계에서 결정”을 안내한다. 현재 OPEN을 사전에 CLOSED나 가짜 ROUND_CLOSED로 바꾸지 않는다. pending이면 원명령/요청1799/예정1800·접수 미확정, 실제1800 ROUND_CLOSED 결과 후 요청1799/효력1800·접수 거부를 표시한다. 정지 중에는 새 효과가 없다.

actual effective1799의 기존 receipt는1800 신규 요청 거부와 분리한다. completed359에서효력360의 접수는 자동 경계 입력으로 검증한다. 종료후 CLOSED+NOT_SUBMITTED는 미응찰 종료, TIE_PRIORITY/LOWER_SCORE는탈락, AWARDED+사업계약REJECTED는낙찰과계약거부를 분리한다. 현재 자격 미충족이 이전 낙찰을 지우지 않는다.

### 점수 표시

공급 분자/분모를 int 나눗셈·나머지로 유한소수 문자열화하며 float/반올림·점수공식을 사용하지 않는다. 분모10000/100000에 따른 정확한 표시와 후행0 제거·점 단위를 사용한다. 공급 비교값→공개표시의 단위 변환만 수행한다. 정상 공개86:80·비교860:800, 동점80:80, F799999의 재무79.9999/공개79.99997을 검증한다. 미수신/분모오류는 자료 없음이며 실제0은0이다.

### P05·오류·키보드

P05는 유효 사업계약·정부지급을 확인한 뒤 ID/효력/R·현재자금·공사계약미체결/복귀만 제공한다. 지급자료 없음이면 진입을 막으며 해당 정보를 지급완료로 치환하지 않는다. 공사체결/착공/공정/검증 명령은 없다. **A01-Q12 PARTIAL**, 실제 W05 P05 조작 인수는020/021이다.

조회 오류(status FAILED), 정상빈목록(READY/available true/0rows), 자료없음(available false), 실제값0을 구분한다. 이전 자료를 현재 행동의 근거로 사용하지 않는다. 목록 선택은조회/포커스일뿐. 목록복귀는 같은ID를 보존하고 데이터가 사라지면 선택 해제/사유를 표시한다. 재조회가 포커스를 빼앗지 않도록 ItemList를 실제 내용 변경시에만 재구성한다. Tab/Enter/Space·방향키는 기본 Control/ItemList 의미로 동작한다.

## 실행·재현

- 제품: godot --path . (기존 main). 정상 독립 초기에서 실제 입력으로 확인.
- 자동: godot --headless --path . --script tests/game/run_tender_ui_tests.gd -- --evidence=res://docs/engineering/evidence/DEV-019_UI_ASSERTIONS.json
- 실패감지: 같은러너 -- --verify-failure-exit →의도실패1/exit1.
- 검증전용GUI: godot --path . --script tests/game/run_tender_gui_cases.gd -- --case=DEADLINE. NORMAL/DEADLINE/NIGHT/TIE/FRACTION/EMPTY/ERROR/UNAVAILABLE/STALE/PAYMENT_MISSING/BUSY/DURATION/BEFORE_START 선택. 제품 main은 이 러너·fixture를 참조하지 않는다.
- 검증창의 +1분/마감까지는 테스트 전용 기존Clock 진행이다. 정상제품에는 시간건너뛰기·자금주입·성공고정 기능이 없다. DURATION/오류/자료 없음 등 소비반례는 명시적 테스트 packet이며 실제 경제 사건으로 취급하지 않는다.

## Design 독립 인계

| 검수 묶음 | DEV 증거/남은 인수 |
| --- | --- |
| Q01~03 | B01/B02·BX비노출·조건읽기전용/현재자격·빈/없음/오류 자동, 제품목록·실제오류복구 GUI. Design 독립 인수 대기 |
| Q04~06 | 요청분/효력·정지/1·2·4배속 자동,1799→1800 실제pending/거부 GUI. Design 고정head 재확인 |
| Q07~08 | 정상86:80·동점80:80·소수자동, 제품정상·검증소수 GUI. 동점의 독립 Design GUI 대기 |
| Q09~10 | 중복/역순/조건변경·현재상태/버튼 불변 자동. 전체입력·포커스/복귀의 Design 독립 GUI 대기 |
| Q11~12 | 계약/지급1회·현재/당시·미지급자료·P05부작용0 자동, 제품계약/지급/P05읽기전용 GUI. Q12는PARTIAL |

개발자의 GUI 관찰은 디자인 독립 검수를 대체하지 않는다. 전체A01-Q01~12/S2-02·03·08/Stage2 DONE을 자기선언하지 않는다. W04B·실제W05/W06·VS01완주·Windows export/성능·전체MVP는 NOT_RUN. 최종명령·소스해시·로그·PNG·head/CI는 결과와 PR에 기록한다.

## QA-001·QA-002 후속 보완 / RFC-DEV-019-02

Design [문구·배치 회신](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6717520859)에 따라 P02 고정조건 다음·현재 자격/행동 및 응찰 버튼 이전에 읽기 전용 공개 평가기준을 표시한다. 미응찰에서도 경쟁자 고정점수/구성과 terms.tie_priority를 읽을 수 있다. 제목은 고정이며 decision이 비었을 때만 미확정 안내를 표시한다. 실제 마감 판정 사본·현재자금·접수이력은 기존처럼 분리한다.

Session tender_ui에 evaluation_criteria: Dictionary[tender_id, Dictionary]를 추가한다. competitor_display_score는 {numerator:int, denominator:int}, competitor_capability/competitor_financial_score는 점 단위 int, tie_priority는 고정 역할 배열이다. 공고 terms에서 검증된 경쟁자 능력/재무점수(정수0~100)를 읽으며 미유효 입력은 해당 행을 생략한다. 기존 PublicTender.score의 입력 단위에 맞춰 고정 경쟁자 재무점수×10000을 전달한다. 이는 회사 현금이 아니며 회사 원장/자격/시각/낙찰을 변경하거나 플레이어 점수를 미리 계산하지 않는다. View는 유리수 문자열만 표시하고 누락은 “경쟁자 평가 자료 없음”으로 구분한다. 기존 DEV018 snapshot 봉투와 terms/schema/UI revision은 보존한다.

현재 reason_codes는 기존 한국어 매핑으로 공급 순서대로 한 줄씩 표시한다. 미등록은 “행동 제한 사유를 확인할 수 없습니다 (코드: …)”로 표시한다. 원 snapshot의 코드와 allowed_actions는 변경하지 않는다. 과거 요청 사유와 현재 사유를 혼합하지 않는다.

검증 전용 CASES에 REASON_FALLBACK을 추가했다. 종료/미등록 긴 코드/사업 진행 중의 다중 사유 packet과 비활성 행동만 공급하며 모델 경제 상태는 바꾸지 않는다. 제품 main에서 해당 fixture를 참조하지 않는다. [보완 결과](../tasks/DEV-019_QA_FIX_RESULT.md) 및 [증거](DEV-019_QA_FIX_VALIDATION.json). P05는 기존 읽기 전용 인계 / Q12 PARTIAL이며 공사 기능은 추가하지 않는다.
