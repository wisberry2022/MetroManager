# DEV-026 — DSG-008 S01 예외 공급·소비 계약 검토안

- 작성: Development / AGT-DEV-0004 / 2026-11-14 / v0.1.
- 상태: **DOCUMENT_REVIEW / CONTRACT_PROPOSED / OWNER_IMPLEMENTATION_DEFERRED**.
- 기준 main: `9e6154e926d44cdbbb2fb117fb7d3fc56d152eac`. 제안 식별자: `DEV026-S01-EX-v0.1`; 현재 제품에 존재하는 API/승인 계약이 아니다.
- 관련: RFC-DSG-008-EX-01 / [#104 최신 Design 인계](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6874170205) / [기존 DEV 회신](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6873960483).
- [작업·승인 범위](../tasks/DEV-026_S01_EXCEPTION_SCOPE.md), [20사례·검증 계획](DEV-026_S01_EXCEPTION_VALIDATION_PLAN.md), [이번 정적 검토 결과](../tasks/DEV-026_RESULT.md).

Owner 후속 결정에 따라 이 계약은 Design 사전 열람용 문서 PR로 공유한다. DEV-026 구현·제품 검증은 DEV-022~025 선행 업무 뒤로 보류한다. 제출 base는 `2baed0518e5443007c159962bfba46a8eeae5fdb`이며 위 분석 SHA 이후 제품/Design 원본 변경은 없다. 재개 시 최신 공급·UI·실험 결과와 영향 행을 다시 대조한다.

## 1. 현재 사실과 제안의 구분

[UI-DC v0.2.1](DEV-006_UI_DATA_CONTRACT.md)의 정적 의미 수용은 유지한다. 아래 근거는 기준 SHA 소스 관찰이며 이번 제품 실행/재현 결과가 아니다. Design 카탈로그 schema2·검수표 schema1은 디자인 문서 형식으로 게임 payload에 직접 주입하지 않는다.

| 현재 코드 사실 | 실제 경계·부족한 부분 |
| --- | --- |
| [main._ready/_fail](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/main.gd#L12) | DATA/초기회사 검증 성공 후 새 Session과 Stage1 View 생성. 실패 화면 후 exit1. 초기 실패의 부분 복구 기능 없음 |
| [Session.snapshot](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/ui/stage1_session.gd#L51) | 동기 전체 Dictionary. view_revision/data_version/clock/current/plan/prediction/report/daily_activity/allowed_actions 및 입찰·공사 하위 공급. root ui_contract_revision/run_scope는 없음 |
| [View.present](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/ui/stage1_view.gd#L202), [_render_plan](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/ui/stage1_view.gd#L246), [Map.present](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/ui/stage1_map.gd#L18) | view_revision 역행만 먼저 거부하고 필수 자료 직접 접근. 후보 생성·입력 callback도 session.snapshot을 직접 사용하므로 present 한 곳의 검사만으로 충분하지 않음 |
| [재무·당일 렌더](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/ui/stage1_view.gd#L318) | coherent=false 안내 및 daily 정수/비음수·day/minute/snapshot_revision 검사는 존재. funds/report는 먼저 직접 읽어 전체 누락 guard가 아님 |
| [Session._predict](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/ui/stage1_session.gd#L181), [PredictionState](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/model/prediction_state.gd#L14) | begin→predict→complete/fail 동기 종료. 모델은 입력판 불일치 완료/실패를 거부. View는 available=true만으로 current를 표시하고 계획/입력 소속을 직접 교차 검증하지 않음 |
| [보고 공급](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/ui/stage1_session.gd#L51), [DailyLedgerReport](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/model/daily_ledger_report.gd#L31) | day=current.day_id−1; day>0만 report 조회. report_error이면 FAILED, 존재하면 READY, 그 외 UNAVAILABLE. FAILED에도 원래 보고가 있으면 display_key가 남고 value는 빈 Dictionary |
| [reset_observation](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/ui/stage1_view.gd#L452), [GUI _choose](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/tests/game/run_w07_gui_cases.gd#L50) | 기존 View에 Session을 교체하고 일부 로컬 상태만 초기화. 자식 패널 revision/이력·이전 Session callback 소속 초기화 보장 없음 |
| [dispatch](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/ui/stage1_session.gd#L106) / [request_bid](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/ui/stage1_session.gd#L224) / [request_construction](https://github.com/wisberry2022/MetroManager/blob/9e6154e926d44cdbbb2fb117fb7d3fc56d152eac/scripts/ui/stage1_session.gd#L307) | 일반 dispatch는 동기. 실제 pending은 응찰/공사 requests[].command/result 경로에 존재. 현재 허용 행동과 당시 결과는 별도 |

런타임 data_version은 실제 loader/Pipeline의 `1.3`이다. 최근 기획 C/DATA 문서 개정이나 PLN-008 병합을 근거로 이 값을 올리거나 금융·서비스 화면을 이번 범위에 넣지 않는다.

## 2. 권고 구조와 책임 — 모두 신규 적용 제안

흐름은 **권위 모델 → Stage1Session.snapshot → S01ObservationContract 검사 → Stage1View 지역 렌더/입력 → 기존 Session 명령**이다. 별도 비동기 서비스·전역 상태·새 게임 enum은 추가하지 않는다.

- Session: 기존 모델 값을 복사하고 실행 소속·계약 버전만 추가 공급한다. 비용/자격/예측을 재계산하거나 원장을 동기화하는 새 조회 부작용을 넣지 않는다.
- 신규 `scripts/ui/s01_observation_contract.gd`: 순수 구조/출처 검사. 제안 진입점 `inspect(state: Variant, expected_run_scope: String, displayed_revision: int) -> Dictionary`. Dictionary 접근/형 변환 전에 타입 검사. 결과는 소비기 내부의 `discard_observation`, `global_current_valid`, `regions`(영역별 valid/diagnostic)이며 게임 payload·모델 사유 enum이 아니다.
- View: 검사된 영역만 소비하고 현재 표시와 마지막 확인 자료를 분리한다. 현재 입력 허용과 선택/포커스를 담당한다. Map에는 검증된 자료만 전달하고 무효 시 이전 marker의 클릭·그리기 자료도 제거한다.
- 모델: 기존 경제/시간/계획/효력 판정의 최종 권위. UI guard의 미확인은 모델 거부 결과로 위조하지 않는다.

View의 제안 수신 서명은 `present(state: Variant) -> bool`이다. 현재 Dictionary 인자에 null을 전달해 타입 오류를 낸 뒤 복구하는 방식이 아니라, helper 검사 후에만 Dictionary로 접근한다. 반환 false는 수용하지 않은 관측을 뜻하며 원인은 진단에 분리한다. stale/다른 scope의 응답은 화면 불변, 현재 공급 자체의 미확인은 지역 안내/입력 제한으로 처리한다. root가 유효한 부분 자료 관측은 true로 수용하고 영역별 유효성을 별도로 기록한다.

### 2.1 최소 추가 공급

| 제안 필드/API | 공급·소비 규칙 |
| --- | --- |
| root `ui_contract_revision: String` | `DEV026-S01-EX-v0.1` 정확한 일치. 기존 UI-DC 문서 revision 및 W04A/W05 계약 문자열과 별개 |
| root `run_scope: String` | Session의 기존 `_report_scope = run-<instance id>`를 재사용해 공급. 프로세스 내 Session 생존 기간의 관측 소속이며 영구ID·세이브/신원 인증이 아님 |
| `Session.observation_scope() -> String` | 같은 값을 읽기만 하는 제안 getter. View가 _ready에서 실제 Session 객체와 기대 scope를 고정할 때 사용. 수신 payload가 기대값을 스스로 교체하지 못함 |
| 기존 root `data_version/view_revision` | 문자열 `1.3` / 비음수 정수. 누락·타입/지원 버전 불일치면 현재 모델 요청을 제안하지 않음. 생략을 호환 기본값으로 채우지 않음 |

기존 필드·단위·W04A/W05 봉투는 변경하지 않는다. `rules_version`을 S01에 임의 추가하여 기획 버전과 제품 구현 완료를 동일시하지 않는다.

### 2.2 수신·실행 생명주기

1. View는 한 Session에 귀속한다. 같은 scope에서 낮은 view_revision은 **현재 화면·버튼·포커스를 그대로 유지한 채 무시**하고 CP-S20은 진단 로그로만 남긴다. 높은 번호의 다른 Session 응답도 버린다.
2. 같은 view_revision의 재조회는 허용한다. GameClock.remainder는 분 진행 전에도 달라지므로 전체 Dictionary 바이트 동일을 요구하지 않는다. 같은 판 종류만 비교하고 root view_revision과 Pipeline/계획/예측 입력판을 교차 비교하지 않는다.
3. 현재 공급 자체가 없음/null/잘못된 타입·버전이면 현재 표시를 미확인으로 바꾸고 해당 입력을 막는다. 마지막 확인본을 남길 경우 당시 scope/시각을 붙인 읽기 전용 자료로만 유지한다. 미수신을 stale 응답 무시와 혼동하지 않는다.
4. 새 Session은 **새 Stage1 View와 Map/Tender/Construction 자식 전체 생성**을 권고한다. 옛 View는 process·입력·signal을 해제한 뒤 제거하며 기존 callback은 캡처한 Session 객체가 현재 binding과 같은지 검사한다. 이전 요청/관측 이력을 새 scope로 옮기지 않는다.
5. 제품 main의 현행 새 Session+View 생성은 유지한다. 기존 QA 전환기는 이 경로를 따라 View를 재생성하도록 수정한다. `reset_observation()`은 같은 Session의 로컬 표시 초기화만 허용하고 수신 하한을 되감지 않는다. 다른 Session 직접 대입은 지원 재바인딩으로 간주하지 않고 입력/렌더를 보류해 새 View 경로를 요구한다.
6. 현재 제품에는 실제 지연 응답 전송 계층이 없다. old-scope 주입은 검증 fixture로 구분한다. 실행 사이의 영구 식별·역직렬화·네트워크 재연결은 제외한다.

## 3. 영역별 필수 자료와 행동 의존성

root 소속/버전/관측판 확인 뒤 영역을 각각 평가한다. 일부가 무효여도 다른 유효 영역을 같은 새 snapshot에서 갱신한다. 이전 허용값/금액을 새 snapshot의 누락에 섞지 않는다.

| 영역 | 소비 전 확인할 실제 필드 | 제한·독립 유지 |
| --- | --- | --- |
| 시계 | clock의 simulation_minute/day_id 정수, paused bool, speed가1/2/4. remainder는 표시 판정에 사용하지 않음 | pause/resume 각 bool·speed 배열은 root allowed_actions에서 별도 검사. 누락된 행동만 비활성. 자료 누락으로 clock.paused를 바꾸지 않음 |
| 계획 자료 | plan.station_ids 문자열 배열, plan_revision 정수, locked bool, validation.valid bool/reason_codes 문자열 배열 | 빈 배열은 실제 빈 계획, 누락과 구별. validation의 게임상 불합격은 구조 오류로 숨기지 않음. edit/undo 허용값은 별도 검사 |
| 지도·후보·소속 | stations 배열(id/neighborhood_id 문자열, 유한 좌표), administration Dictionary의 parent_id·연결/순환 안전성, edges의2개 안정ID·참조, 계획 ID 연결 | 지도/후보가 공유하는 자료 누락 시 둘 다 입력 제한. 목록을 무조건 대체 경로로 보장하지 않음. 유효 계획 텍스트는 자료 있음으로 구별하되 미확인 ID를 조작하지 않음 |
| 현재 자금 | current의 day_id/simulation_minute/snapshot_revision 정수·T_COMPLETE, funds의 cash/restricted/free_cash/reserved/available_cash/unpaid 정수, coherent bool 및 clock 시각 일치 | 확인 실패 시 해당 금액 표시 보류. UI에서 F/A/B 등을 계산·0치환하지 않음. 시계/계획/보고의 독립 유효값은 유지 |
| 당일 관측 | 기존4개 금액 운영비/지급/부채지급/현금지급은 정수·비음수, day/minute/snapshot_revision이 current와 같음 | 누락·타입 오류 CP-S10, 관측 불일치 CP-S18. 공급 cash_payment를 그대로 표시. 현재 자금 확인과 원장 재계산을 대체하지 않음 |
| 예측 | 상태/available, plan_revision·prediction_input_revision·input_minute, current/previous 및 값의 기간·생성분·표시 금액/통행/거리·시간 타입 | §4에 따른 현재 소속 확인. 예측 오류가 시간/편집을 전역 잠그지 않음 |
| 보고 | status/available/reason/day_id/display_key/value 및 READY value.day_id·표시 금액·closing_funds.cash | §4에 따라 보고만 제한. 자금 누락이어도 clock의 대상 day·scope가 유효하면 보고는 독립 소비 가능 |
| 과거 명령 | command_result 빈 Dictionary 또는 command_id/action 문자열·accepted bool·effective_at/result_revision/plan_revision 정수 | 누락 결과를 성공/0시각으로 만들지 않음. 과거 결과는 현재 allowed_actions를 수정하지 않음 |
| 호스트의 자식 전달 | root scope 유효, 해당 tender_ui/construction_ui가 Dictionary이고 현재 Session에서 공급됨 | 정상 봉투는 변경 없이 자식에 전달. missing/잘못된 타입은 전달·그 자식 진입/명령만 보류. 자식 내부 깊은 필드 guard·문구/계약 개편은 별도 범위 |

계획 추가/제거/정렬은 유효 plan·관련 ID 자료와 `plan.allowed_actions.edit`, undo는 유효 plan과 `plan.allowed_actions.undo`, predict는 유효 plan/현재 예측 입력 식별과 `allowed_actions.predict`에 의존한다. predict의 기존 FAILED/미계산 자체는 재계산 금지 사유가 아니다. 숫자0·빈계획은 명시적으로 받은 유효값으로만 표시한다.

입력 callback은 렌더 시점의 허용 여부와 현재 binding을 먼저 확인한다. 모델을 바꾸는 계획 명령은 표시한 plan_revision을 기존 `expected_plan_revision`에 넣어 Session의 현재판 검사에 맡긴다. 새 snapshot의 판으로 몰래 대체 실행하지 않는다. 시간 제어는 계획 오류에 종속시키지 않는다. 정보 선택은 유효 ID/소속만 확인되면 별도로 허용하며 모델 명령을 발생시키지 않는다.

호스트 전체 미확인/자식 자료 미확인 시 이전 자식 화면의 현재 입력이 남지 않게 해당 영역을 비활성/숨김 처리한다. 복구 때 원래 화면·유효 선택을 복원한다. W04A/W05 내부 정상 UI나 실제 pending 표현 변경을 포함하지 않으며 이 호스트 경계의 영향은 검증 계획의 X-07에서 따로 확인한다.

## 4. 상태별 구체 소비

### 예측 — EX-04~08

- READY: available=true, current.input_revision == prediction_input_revision, prediction.plan_revision == plan.plan_revision일 때만 현재 결과. 기간/생성분과 기존 표시 값의 타입도 확인한다. 유효한0은 그대로 숫자0이다.
- NOT_CALCULATED/FAILED: 현재값 없음. FAILED는 확인한 사유와 CP-S07, 미계산은 CP-S04. 이전값으로 채우거나 실패를0으로 바꾸지 않는다.
- CALCULATING: 모델 상태를 받은 소비 fixture에서 CP-S05만 확인한다. 현행 _predict는 동기이므로 제품 중간 프레임/실제 대기 검수는 EXCLUDED_FROM_PATH. 자동 지연·취소·진행률을 만들지 않는다.
- previous는 자기 input_revision·generated_minute·period를 표시한 비교용이다. 그 필드가 없으면 이전 자료도 미확인으로 둔다. previous에는 plan_revision이 없으므로 과거 계획판을 창작하지 않는다.
- 시간 경과만으로 현재 입력판이 자동 갱신되지는 않는다. _predict가 계산 요청 시 기간을 바꾸면 입력판을 올린다. UI는 과거 기간을 오늘 기간으로 재라벨링하거나 날짜 변화만으로 자동 계산하지 않는다.

### 보고 — EX-11/12/19

| 공급 조합 | 표시·판정 |
| --- | --- |
| UNAVAILABLE + available=false | CP-S11 “확정 보고 자료 없음”. 유효 clock.day_id=1·report.day_id=0·현재 scope 및 조회 생략 경로가 확인된 경우에만 첫 마감 전 부연 |
| UNAVAILABLE, day>0인데 보고 없음 | 같은 중립 문구. 미마감·조회 실패·유효0 어느 것으로도 단정하지 않음 |
| FAILED + available=false | CP-S12와 확인한 사유. display_key가 남아도 value를 보여주거나 READY로 승격하지 않음 |
| READY + available=true | report.day_id == clock.day_id−1 >0, value.day_id 동일, display_key == “<기대 run_scope>/day-<day_id>” 및 표시 값 구조를 확인한 후 확정 과거 보고 표시 |
| READY의 key/day/scope 불일치, 필드 누락 또는 모순된 status/available | CP-S19/지역 미확인. 다른 실행·날짜의 값과 병합하지 않음. 진단 이유는 로그에 구분 |

display_key는 기존 표시 식별자이며 단독 신뢰 근거가 아니다. 기대 scope는 binding에서, 기대 마감일은 같은 관측의 유효 clock에서 얻는다. clock도 미확인이라면 보고 대상 확인이 필요하므로 보고를 현재 정상값으로 승격하지 않는다. 보고0은 READY/식별 확인 후 유효0이다. 정상 공급의 복귀만 소비하며 디스크/네트워크 재조회·복구 버튼은 추가하지 않는다.

### 결과·사유·pending — EX-13~16

일반 dispatch의 INVALID_COMMAND처럼 실제로 ID/효력분이 없는 반환은 해당 필드를 창작하지 않는다. 정상 저장된 command_result만 당시 요청 ID·효력분과 연결한다. unknown reason은 CP-S14의 중립 문구로 표시하고 원시 코드는 진단 로그에 보존한다. 알려진 사유와 accepted 결과의 당시 안내는 CP-S16/17 의미를 따른다. 옛 거부가 최신 edit/undo/predict를 잠그지 않는다.

CP-S13은 일반 S01 계획·시간·예측에서 **적용 제외**다. W04A/W05는 실제 requests[].command/result·pending·effective_at이 있지만 이번 티켓에서 문구를 이식하거나 재설계하지 않는다. 현재 명령과 이후 계약·지급/공정 완료를 합치지 않는 기존 계약을 유지한다.

## 5. 복귀·선택·포커스 제안

동일 Session에서 같은 안정 ID가 유효하면 정보 선택을 보존한다. 부분 미수신 중에는 선택 ID를 잠재 보관할 수 있으나 현재 유효하다고 표시하거나 모델 요청에 쓰지 않는다. 정상 복귀 때 ID가 없어졌으면 선택을 비우며 첫 후보를 자동 추가하지 않는다.

사용자가 포커스를 이동하지 않았을 때만 이전의 살아 있는 유효 Control로 복원한다. 대상이 없어졌거나 해당 행동이 제한되면 기존 계획 목록 → 유효 후보 Control → 기존 제목 Label 순으로 안전한 포커스 목적지를 선택한다. 마지막 제목은 focus_mode만 허용하는 제안이며 새 버튼·화면 이동은 없다. 후보에 포커스를 주는 것과 계획에 추가하는 것을 구분한다. 새 Session에는 이전 선택/포커스를 이관하지 않는다. 정확한 영향 행은 아래 L2 검토 대상으로 남긴다.

## 6. RFC-DEV-026-01 — 필요한 L2 대조 초안

- 상태: **OPEN / PROPOSED / OWNER_IMPLEMENTATION_DEFERRED**. 상위 RFC: RFC-DSG-008-EX-01.
- 요청: DEV / 응답 책임: Design Track B. 연관 DEV-026 / DSG-008.
- 현황: 기존20사례의 의미는 유지하되 지역 제한·새 View 경계·복귀 목적지가 구체화되지 않았다.
- 제안/대조: (L2-A) EX-01/02/17의 실제 의존 자료별 제한 및 호스트 자식 전달 제한, (L2-B) EX-14/19의 새 Session→전체 View 재생성과 보고 대상 확인, (L2-C) EX-03/13/15 및 복귀 공통의 사유 문구·포커스 목적지. 20사례 전체 재승인이 아닌 해당 의미/직접 영향 행을 한 번에 대조한다.
- 권고: 위 최소 추가 메타데이터·순수 검사·View 재생성 적용. 기존 View/자식 상태 전부를 개별 reset하는 대안은 잔존 이력 위험과 수정 경로가 커 이번 권고에서 제외한다.
- 영향: S01 소비/UI-DC-01·02·05·07의 기술 표현과 해당 자동/GUI 검증. 경제·시간·세이브 정책 변경 없음. 일정은 Owner 범위/Design 영향 대조 후 산정하며 현재 NOT_ESTIMATED.
- DEV 의견: 본 검토안. Design 의견·HQ 조정: 미수신/PENDING. Owner 결정: 사전 검토 문서 PR 제출 승인, DEV-022~025 선행 후 DEV-026 착수. 현재 구현/제품 검증은 보류하며 미래 변경 범위는 재개 시 재대조한다.
- 반영 후보: 본 계약·검증 계획·DEV 티켓. Design 작업표/카탈로그의 변경 여부는 Design 소관이다. 현재 게임 명세 변경 필요 NONE, 기술 계약은 PROPOSED.

F08-01~04·최종 글꼴/창/DPI/배율/필터/FPS/상한은 별도 OPEN/미확정이다. 수용된 Q03~Q05·Q12 28조건·QA-001/002·OBS-01·A02-11을 자동 재개방하지 않으며 A01-Q12 상위 PARTIAL도 유지한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-026
