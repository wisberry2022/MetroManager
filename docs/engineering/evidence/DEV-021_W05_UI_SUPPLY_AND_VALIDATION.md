# DEV-021 W05 UI 공급·소비 및 검증 인계

- 작업/담당: DEV-021 / AGT-DEV-0001
- 기준 main: 7735ccff22952dabdf1371c2b29d81b620f4a9c0
- 결과 상태와 실제 수치: [결과](../tasks/DEV-021_RESULT.md), [실행 JSON](DEV-021_W05_UI_VALIDATION.json), [자동 사례](DEV-021_W05_UI_CASES.json)
- 승인 패킷: https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6720044883
- 정책/Design 근거: [티켓](../tasks/DEV-021_W05_CONSTRUCTION_UI.md)
- 본 산출물은 개발 검수 요청이며 Design 독립 GUI/Owner 인수 완료가 아니다.

## 공급과 권위

Stage1Session은 기존 Pipeline.enable_construction()을 한 번 활성화하며 같은 시각·원장·서비스를 사용한다. snapshot().construction_ui의 snapshot은 기존 snapshot().construction의 깊은 사본이다. UI 공급은 view_revision/status/reason/snapshot/requests/next_effective_at/fixture_label이다. 조회·재조회·화면 왕복은 명령·시각 진행·원장 효과를 만들지 않는다.

| 항목 | 원본 필드·형식 | 소비 |
| --- | --- | --- |
| 버전/관측 | rules_version=RFC-DEV-020-01-OWNER-20261108, data_version=1.3, ui_contract_revision=DEV020-W05-UI-1; T_COMPLETE, snapshot_revision/simulation_minute/day_id:int | 미지원 계약 및 이전 revision은 현재 화면 반영 거부. 미활성/available=false/실패/빈 목록은 정상0과 구분 |
| 인계 | contract_candidates:Array[Dictionary], business_contract ID/status/effective_at 및 government_payment | 사업/정부 지급을 다시 집행하지 않고 공사계약 후보로 표시 |
| 공사계약 | construction_contract_id/status/contract_effective_at, mode, total_cost/duration_minutes:int | 사업계약·공사계약·실제 착공을 별도 표시. 표준/빠른 후보 값 그대로 사용 |
| 공정 | status, started_at/completed_at/opened_at:null 또는 int; elapsed_minutes/duration_minutes:int | 원값의 게임분 표시. 자금중단 시 확정 전체 완료 예정시각·미공급 비율/잔여분을 창작하지 않음 |
| 기성/자금 | accrued/paid/construction_payable/repair_paid:int, funds의 C/R/F/K/A/B 및 사업별 R/K | 발생·실지급·공사 미지급·수리 지급·운영비 B를 별도 표시. UI 경제 공식 재계산 없음 |
| 절차 | trial_status/safety_status/procedure, procedure_started_at/procedure_completes_at:null 또는 int, defects:int | 현 절차의 시작/완료 예정, 비진행 중 남은 시각은 최근 절차 기록임을 표시. 전체 과거 시험/결함 종류 미공급 |
| 행동 | allowed_actions:Dictionary[bool], action_reason_codes/reason_codes:Array[String], condition_revision:int | 허용/거부와 한국어 사유+알 수 없는 코드 fallback. 임의 착공 최소자금 조건 없음 |
| 요청 | command_id/project_id/business_contract_id/action:String; contract만 mode:String; requested_at/effective_at/expected_snapshot_revision/target_revision:int | 모델에 전달. completed+1 이후만 요청. 계약의 야간 이연은 모델 반환 effective_at 사용 |
| 결과 | pending/accepted:bool, reason_codes, effective_at/decision_phase/result_revision | 요청과 처리 대기·수용·거부 구분. 현재 행동과 과거 결과를 분리하며 같은 command_id는 원요청/결과 재사용 |

기본 다음 처리분 안내는 계약 야간 이연 가능성을 함께 명시한다. expected_snapshot_revision은 관측 근거이고 target_revision이 대상 조건 검사다. 시각만 경과한 관측을 조건 변경으로 거부하는 규칙을 추가하지 않는다.

선행 명령 pending 중 같은 사업의 후속 버튼/모드 변경을 잠그며 결과 반영 후 새 권위 행동으로 갱신한다. 결과만 늦게 도착하면 원명령 이력에만 반영한다. 이전 조회 실패·낡은 snapshot은 현재 상태·버튼을 덮지 않는다. 로그 DEV021_COMMAND/OBSERVATION은 명령과 의미 상태 전환을 기록하며 원장/모델을 변경하지 않는다.

## 최소 화면과 디자인 정합화

P05 사업 인계 → 공사·검증·개통 화면 → 사업 인계 복귀 → S01의 기존 경로다. 기존 인계의 정적 NOT_CREATED가 실제 생성된 공사를 덮지 않는다. 복귀 시 B01 선택/P05 페이지와 진입 버튼 포커스를 유지하며 Return/Tab 조작을 지원한다. 기존 ScrollContainer에서 좁은 창의 세로 스크롤을 유지한다.

공기 안내는 Design 수용 의미인 “공기 2,880게임분 (실제 착공 효력부터)”로 정합화했다. 권위 숫자를 사용하고 표준2880/빠른1440을 구분한다. 공사 중단·게임 일시정지·안전 실패는 각자 상태다.

수리비는 지급 총액과 “해당 사업 제한자금 우선, 부족분 가용자금” 정책 안내만 표시한다. 현재 잔액으로 과거 거래별 R/A 분담을 추정하지 않는다. 개통 후에도 실제 영업은 W06 후속임을 명시한다. 모델/계약 필드 확대와 새 정책은 없다.

## 자동 재현

프로젝트 루트는 해당 PR worktree다. GODOT은 랩탑 상위 godot 폴더의 4.7.2 콘솔 실행 파일, PYTHON은 해당 worktree의 .venv/Scripts/python.exe다.

```text
GODOT --headless --path . --editor --quit
GODOT --headless --path . --script res://tests/game/run_construction_ui_tests.gd -- --evidence
GODOT --headless --path . --script res://tests/game/run_construction_ui_tests.gd -- --verify-failure-exit
PYTHON -m unittest discover -s tests/tooling -v
PYTHON tools/policy.py doctor
PYTHON tools/policy.py check
PYTHON tools/policy.py preflight
```

기존 회귀는 같은 Godot로 tests/game/run_w01_tests.gd, run_w02_tests.gd, run_w03_tests.gd, run_w04a_tests.gd, run_w05_tests.gd, run_w07_tests.gd, run_tender_ui_tests.gd를 실행한다. 기존 증거 파일 재작성을 피하도록 기존 runner에 --evidence를 주지 않는다.

신규 자동검사는 실제 Control의 pressed 신호→Session→Pipeline 연결, 표준/빠른 완주, 기성 경계, 부족/재개/최종 미지급, 수리 전액 부족, 멱등/조건 revision/효력분/계약 야간 이연, 역순 실패·자료 없음·재조회, 1/2/4배속 및 host 화면 왕복을 검증한다. 필수 10개 사례 완료/100개 이상 단언 실행을 함께 확인하여 스크립트 중도 오류·0건 실행을 PASS로 취급하지 않는다. 외부 실행기에서도 종료코드와 SCRIPT ERROR/ERROR/FAIL을 확인한다.

모든 신규 사례는 TEST_ONLY 자동 Control 검사이며 수동 실제품 GUI 인수와 다르다. RESUME은 DEV-020에서 승인된 비영 K/기존 미지급 회복 내부 반례를 재현하는 테스트 전용 원장/프로젝트 초기화다. 제품 자금 지원/원장 교체 기능은 없다. REPAIR_SHORT는 현재 원장 게임분으로 자금 소모를 구성한다. 과거 분에 자금 소모를 요청해 모델이 거부한 초기 fixture 실패는 입력 정합화 후 재검증했다.

CASES.json은 입력/초기·기대/실제·명령·revision·종료 관측을 보존한다. 비교에는 전체 snapshot을 사용하며 공개 기록에서는 대량의 분 처리 trace를 생략하고 비영 거래를 기록한다. 전체 원본 로그는 추적 제외 .local/validation에 두고 VALIDATION.json에 경로·해시·종료코드를 남긴다.

## 실제 GUI와 보조 GUI

제품은 정상 main 씬에서 새 게임으로 시작해 B01 응찰·마감·사업계약/정부금부터 공사·시험·개통까지 직접 클릭했다. 시간 순간이동·완료 상태 주입은 사용하지 않았다.

| 제품 경계 | 실제 관측 |
| --- | --- |
| 응찰 | 요청479 → 실제 접수480 |
| 마감/사업계약/정부금 | T1800, 공개점수86:80, 사업계약/정부 지급 유효 |
| 공사계약 | 요청2238 → 효력2239, 착공 전 공정0 |
| 실제 착공/완공 | 착공2325 → 5205 완공, 경과2880 |
| 일시정지 | T2423, 공정98/2880, 발생=지급20416, 공사 미지급0 불변. 재개 후 진행 |
| 완공 원장 | C1200000 / R200000 / F1000000 / K0 / B0, 발생=지급600000 |
| 시범/안전 | 시범5352→5412, 안전5712→5772 각각 독립60분 |
| 개통 | 요청5897 → 효력5898. 사업 인계 복귀 시 OPEN 유지 |
| 접근/복귀 | 진입 버튼 포커스 복원 후 Return 재진입, 창 폭 축소 및 Tab 포커스 이동 확인 |

테스트 전용 GUI는 다음과 같이 별도로 실행한다.

```text
GODOT --path . --script res://tests/game/run_construction_gui_cases.gd -- --case=PAYMENT_DUE
GODOT --path . --script res://tests/game/run_construction_gui_cases.gd -- --case=FAST_REPAIR --run
```

--run은 보조 fixture의 초기 시각 진행을 4배속으로 설정한다. 보조 도구의 시간 이동/fixture 교체는 제품에 노출하지 않는다. PAYMENT_DUE에서 수행3/발생625/지급416/공사 미지급209·B0·재개 차단 사유를 직접 확인했다. FAST_REPAIR에서는 실제 화면 수리3499요청→3500효력/3530완료, 수리비20000 및 C1060000/R60000/F1000000/K0/B0, 재시험3671→3731, 개통3823을 확인했다. 정상 빠른 공사의 전체 수동 E2E 반복을 주장하지 않는다.

초기 사용자 조작이 섞인 제품 실행 dev021-product.log는 수용 증거에서 제외한다. 별도 초기 보조 창의 도구 입력은 효과가 확인되지 않아 성공 처리하지 않았다. 실제품은 dev021-product-clean.log, 빠른 수리 조작은 dev021-fast-running-gui.log의 명령·관측 및 아래 캡처로 구분한다. Windows UI 도구의 좌표/포커스 불명확성에서 재관측·재선택 후 실제 결과로만 판단했다.

증거 PNG: DEV-021_PRODUCT_P05_CONTRACT.png / PROGRESS.png / OPEN.png, DEV-021_FIXTURE_PAYMENT_DUE.png / FAST_REPAIR.png, DEV-021_GUI_NARROW_KEYBOARD.png. 대표 캡처는 전체 자동 사례·로그를 대체하지 않는다.

## 후속 검수·이월

- Design: 제출 head에서 문구·정보 순서·상태 구분·허용 행동·오류/역순·축소/키보드/복귀 및 A-02/A01-Q12 독립 GUI 검수.
- A01-Q12는 위 구현·개발 증거 공급 후에도 Design 독립 인수 전 PARTIAL/GUI_ACCEPTANCE_PENDING.
- W04A Q03/04/05는 #75에서 별도 추적한다. 본 UI 완주로 그 잔여 QA를 PASS로 바꾸지 않는다.
- W06 실제 승객/운임/다음 사업, 전체 VS-01, F-08/Windows export/성능은 후속 티켓이며 본 완료로 승격하지 않는다.
- 기획·디자인 공식 문서 정합화는 해당 부서 소관. 기존 Owner 결정/Design L2 의미 변경은 필요하지 않다.
