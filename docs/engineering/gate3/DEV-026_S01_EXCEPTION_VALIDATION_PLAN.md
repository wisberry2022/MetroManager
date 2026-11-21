# DEV-026 — 적용 사례·검증 계획

> **현재 로컬 후속 — 2026-11-21:** 경로 재지정 승인 적용·기존35개 실패 해소·자동 GUI266/266 PASS. LOCAL_REVIEW / PRODUCT_L2_PENDING. 후속8개 파일은 미커밋이며 Commit·Push·main 병합은 별도 승인이다. 아래 이전 본문의 PARTIAL·승인 대기·NOT_RUN은 당시 기록이고 최신 근거는 마지막 후속 절과 증거 JSON gui_followup을 따른다.

<!-- 아래 이전 본문은 당시 상태로 보존한다. -->

> **현재 상태 — 2026-11-21:** PR_REVIEW_PARTIAL / TEST_PATH_REASSIGNMENT_PENDING / PRODUCT_L2_PENDING. Owner가 기존23개 파일의 Commit·Push·Draft PR 공유를 요청했다([티켓 §9](../tasks/DEV-026_S01_EXCEPTION_SCOPE.md)). 기존 GUI35개 실패·검사기 재지정 승인 대기·Design 수용 대기는 유지한다. 앞선 HOLD/NOT_RUN·로컬 검토 기록은 당시 이력이며 main 병합은 별도 승인이다.

- 기준: `9e6154e926d44cdbbb2fb117fb7d3fc56d152eac` / AGT-DEV-0004 / 2026-11-14.
- 상태: **DOCUMENT_REVIEW / PLANNED_NOT_RUN / OWNER_IMPLEMENTATION_DEFERRED**.
- [계약안](DEV-026_S01_EXCEPTION_CONTRACT.md), [실행·승인 범위](../tasks/DEV-026_S01_EXCEPTION_SCOPE.md).
- 기준 Design: [작업표](../../design/tasks/DSG-008_CONTRACT_REVIEW_WORKSHEET.md), [v0.2 카탈로그](../../design/assets/source/dsg_008/copy_exceptions/s01_copy_catalog.json), [20사례 확인표](../../design/assets/source/dsg_008/copy_exceptions/s01_acceptance_checklist.json).
- 아래 표는 DEV 적용 제안이다. 모든 실제 결과/새 증거는 **NOT_RUN / 없음**, Design 제품 수용은 **PENDING**이다. 원본 Design JSON은 수정하지 않는다.

Owner 후속 결정으로 이번에는 문서 PR만 공유한다. 아래 제품 검증은 DEV-022~025 선행 업무 이후 최신 공급·UI·실험 결과와 적용/제외 행을 다시 대조한 뒤 착수한다. 문서 제출 검사·필수 CI는 제품 검증과 구분하며 실행 계획의 PASS로 전용하지 않는다.

## 1. 20사례 적용 대조

| case_id · copy_ids | 입력·관측 조건 | 적용 구분 | 기대 행동/종료 조건 | 검증 묶음 |
| --- | --- | --- | --- | --- |
| EX-01 · CP-S01/CP-S15 | 전체 null/{}·root 버전/타입 누락; 초기 DATA 실패 별도 | 신규 guard | 현재 없음·관련 모델 입력0·시간 자동정지 없음, 유효 공급 복귀 | X-01 |
| EX-02 · CP-S02 | stations/administration/edges 일부 누락·잘못된 ID/부모순환 | 신규 guard | 지도/후보 제한·독립 시계/자금 유지, 정상 복귀 | X-01/X-06 |
| EX-03 · CP-S03/CP-R01 | 정상 plan.station_ids=[]와 plan 누락 구분 | 제품 정상+표현 보완 | 빈계획 안내·공급이 허용한 추가만, 자동 후보 추가0 | X-06 |
| EX-04 · CP-S04 | 정상 미계산·predict 허용 true/false/누락 | 표현·guard | 미계산/자료없음, 허용 확인 후 기존 계산만 제안 | X-02 |
| EX-05 · CP-S05 | PredictionState.begin 소비 표본 | 소비 fixture 한정 | CALCULATING 안내 분기; 동기 제품 중간 프레임은 EXCLUDED_FROM_PATH | X-02 |
| EX-06 · CP-S06 | 실제0 예측 READY 및 current 입력판 변조 | 제품+반례 | 유효0 표시, 잘못된 현재 입력/계획 소속은 보류 | X-02 |
| EX-07 · CP-S07/CP-R11 | 실제 잘못된 예측 입력 결과/격리 fail·회복 | 제품/fixture 구분 | 실패0치환 없음·이전값 분리·허용된 명시 재계산 후 복귀 | X-02 |
| EX-08 · CP-R18/CP-S08/CP-S04 | 예측→편집→이전 결과→낡은 complete/fail | 기존+추가 guard | 현재/이전 입력·기간 분리, 늦은 결과의 덮어쓰기0 | X-02 |
| EX-09 · CP-S09 | coherent=false·clock/current 불일치·funds 누락/타입 | 기존+추가 guard | 자금 지역 미확인, 독립 시계/계획/보고 유지 | X-03 |
| EX-10 · CP-S10 | daily 4금액 각각 누락/문자열/bool/음수 | 기존+소비 보강 | 자료 없음/오류, 0보완·UI 재계산 없음 | X-03 |
| EX-11 · CP-S11 | day0 조회 생략·day>0 실제 보고 없음 | 문구 보완 | 중립 없음, 확인된 첫날만 부연, READY0과 구분 | X-04 |
| EX-12 · CP-S12 | 기존 보고 생성 후 report_error; display_key 잔존 | 기존+소비 보강 | FAILED 유지·보고값 숨김·독립 자금 유지·정상 공급 복귀 | X-04 |
| EX-13 · CP-S14 | 미등록 reason 및 누락 결과 필드 | 문구·guard | CP-S14, 코드 진단 보존·임의 성공/복구 버튼 없음 | X-05 |
| EX-14 · CP-S20 | 동일scope 역행·새scope 낮은판·이전scope 높은판 | 기존+생명주기 | stale 무시·새 View는 새판 수용·이전 응답/명령 이력 배제 | X-05/X-07 |
| EX-15 · CP-S16/CP-R08 | 과거 STATE_CHANGED/거부 뒤 현재 edit 허용 | 제품/fixture 구분 | 당시 ID/효력과 현재 허용 분리, 새 요청만 현재판 검사 | X-05 |
| EX-16 · CP-S13 | 일반 dispatch 및 W04A/W05 실제 pending 경로 소스 대조 | 일반 S01 적용 제외 | CP-S13 인위 대기 없음. 다른 화면 문구 이식 제외; 정상 전달 회귀만 | X-07 |
| EX-17 · CP-S15 | root pause/resume/speed/predict·plan edit/undo 개별 누락 | 신규 guard | 누락 행동군만 제한·이전 허용값 재사용0·정보 선택 별도 | X-01/X-06 |
| EX-18 · CP-R04 | 기존 격리 EXTERNAL 입력·기본12후보 보존 | 검증 fixture 한정 | 실제 모델 관할 거부와 표시 연결; 제품 데이터/후보 추가0 | X-06 |
| EX-19 · CP-S19 | READY key 없음/다른run/day/value.day 불일치 | 신규 식별 guard | 해당 보고만 미확인, 정상 동일 대상 복귀·영구ID 추가0 | X-04/X-05 |
| EX-20 · CP-S18 | daily day/minute/snapshot_revision 각각 불일치 | 기존+소비 보강 | CP-S18·동일 관측만 표시·0치환/정산 재실행0 | X-03 |

EX-05는 소비 분기 자동검사 대상으로 남기되 실제 동기 제품의 대기 시간을 만들지 않는다. EX-16은 일반 S01에서 제외되며 W04A/W05의 실제 pending을 이번 S01 인수 PASS로 전용하지 않는다. EX-18의 외부역은 별도 검증 데이터이고 기본12후보를 바꾸지 않는다.

## 2. 영향별 실행·증거 계획

X 번호는 검증 묶음이며 새 필수 GUI 실행 횟수나 모든 문맥×키 행렬이 아니다. 한 실행이 실제로 입증한 행은 공동 연결한다. 자동검사의 경계 조합과 독립 GUI의 실제 조작 증거를 구분한다.

| 묶음 | 자동·직접 관측할 핵심 | 확보할 증거 |
| --- | --- | --- |
| X-01 구조·지역 행동 | 각 최상위/필수 하위 타입 검사, root 무효와 지역 무효 구분, 권한 개별 누락, malformed 관측 뒤 정상 복귀. 상태 부족 중 callback 직접 호출도 모델 명령0 | 검사 결과 영역·표시/버튼·before/after Session·원장·실제 입력. 초기 DATA 실패 exit1은 기존 경계로 별도 확인 |
| X-02 예측 | READY 유효0·미계산·FAILED·previous, 입력/계획판 불일치, 늦은 complete/fail, 기간/생성분 타입. 동기 dispatch 완료 및 fixture CALCULATING 구분 | 실제 계산 요청·편집·허용/비허용, 현재/과거 라벨·기간·단언. 자동 지연0·명령/시각 부작용 대조 |
| X-03 재무·당일 | coherent 및 day/minute/revision, 4개 금액 누락/잘못된 타입, current 자체 누락. 정상값을 각 지역에만 복구 | 공급값/표시값·지역 경고·독립 시계/편집 유지. 표시 중 경과 시간은 통제하고 guard 자체 원장 변경0 |
| X-04 보고 | 첫날/중립없음/실패+key잔존/READY0/잘못된run·day·value.day/정상복귀 | 실제 Report.close/Session.report_error 표본과 수신 변조 fixture 구분. 현재 자금과 과거 보고를 별도 캡처 |
| X-05 귀속·명령 | 같은 Session 역행·동일판 remainder 변화 수용, 새 View 낮은판, old scope 높은판·과거 callback 차단, result 불완전/미상 사유, 당시 거부 후 현재 허용 | old/new Session·View·자식 인스턴스 및 scope, 각 판 종류, 결과 ID/효력, 옛 이력 없음·최신 버튼 유지 |
| X-06 계획·복귀 | 실제 빈 계획, 정보 선택/편집 구분, 같은ID 복귀·대상 소멸·자료 누락, 소속/간선 오류, 지도/목록 공통 입력, 기본12후보 | 키보드·마우스 실제 조작, 포커스 소유자·선택ID·스크롤·입력 전후. 첫 후보 자동 추가0·부적절한 포커스 회수0 |
| X-07 자식 호스트·기존 경로 | S01→P01/P02→공사→복귀, root/current 자료 이상과 독립 자식 자료, 자식 봉투 미수신 시 전달/명령 보류, 새 View의 자식 이력 초기화 | 기존 요청/결과 전달 및 복귀/선택, 정상 CP-S13 미변경. 깊은 자식 봉투 손상은 이번 인수 밖으로 명시 |

수신 변조는 신규 검증 fixture에서만 수행하고 제품 DATA/명령결과/원장을 강제 성공값으로 덮지 않는다. 정상→이상→정상 전이는 같은 Session에서 확인하며 snapshot의 표본 관측판은 전용 fixture가 명시 관리한다. fixture 전환으로 새 실행을 만드는 것과 같은 실행의 실제 복구를 구분한다. 이 장치는 현재 미구현이다.

### 실행 명령 후보 — 승인 후에만 실행

Godot4.7.2 / Windows D3D12 Forward+·현재 project 설정을 유지한다. 실행 전 실제 엔진 경로·버전·창/viewport·검증 전용 짧은 APPDATA·raw log 위치를 고정한다. DPI/배율은 확인되지 않으면 NOT_VERIFIED이며 최종 합격 수치를 창작하지 않는다.

- 신규 자동: `godot --headless --path . --script tests/game/run_s01_exception_tests.gd`, 실패 감지 `-- --verify-failure-exit`(의도 실패 exit1). 파일은 구현 승인 후 생성한다.
- 필수 영향 회귀: 기존 `run_w07_tests.gd`, `run_w03_tests.gd`, `run_tender_ui_tests.gd`, `run_construction_ui_tests.gd`. Session/호스트 공유 경계를 확인하고 기존 단언을 무단 삭제하지 않는다.
- 경제/시각 모델 소스는 변경하지 않는다. X-01/03/05에서 guard·표시·정보선택의 원장/시각 무효과를 정지 조건에서 확인한다. 모델/공통시간 코드 변경 필요 또는 관련 회귀 실패가 생기면 범위 변경 검토 후 W02/W04A/W05 해당 자동회귀를 확대한다.
- 프로젝트 로드: `godot --headless --editor --path . --quit`, 제품 초기화 `godot --headless --path . --quit-after 3`; 초기실패는 격리 fixture로 기존 exit1도 확인한다.
- 직접 GUI: 제안 `run_s01_exception_gui_cases.gd`에서 조건·입력·관측 로그와 원본 viewport 캡처. 기존 W07 runner는 새 View 전환 회귀에 사용한다. 실제 제품 정상 경로와 소비 반례를 구분한다.
- 문서·정책: `.venv/Scripts/python.exe tools/policy.py doctor`, `check`, `git diff --check`. Commit 승인 후 정상 훅·fetch/preflight, Push/PR 별도 승인 후 `policy`·`department-policy` 확인.

각 실제 실행은 run_id/case_id·full SHA·fixture/source 해시·입력/기대/실제·종료코드·엔진/스크립트 오류·로그/화면을 남긴다. PARTIAL/NOT_CAPTURED/FAIL을 PASS로 승격하지 않는다. 제품 자동 단언·GUI 횟수·사후 파일 대조 수를 합산하지 않는다.

## 3. 기존 증거 재사용과 종료 조건

- 기존 [DEV-015 결과](../tasks/DEV-015_RESULT.md) 및 [W07 tests](../../../tests/game/run_w07_tests.gd)의 시각/보고/예측·정보 선택은 정상 회귀 기준이다. 새 부분 누락·실행 귀속 guard의 PASS 증거로 대신하지 않는다.
- Q03~Q05의 [Design 수용](https://github.com/wisberry2022/MetroManager/issues/75#issuecomment-6876401724), Q12의 [28조건 한정 수용](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6873744971)은 보존한다. 호스트 변경의 직접 영향은 X-07로 확인하되 같은12조합·28조건 전체를 기본 반복 의무로 만들지 않는다. 실제 영향/결함이면 해당 행을 재개방한다.
- Design의 기존652 브라우저 검사는 정적 문구/열람기 증거다. 새 Godot guard·실제 복귀·현재 공급 계약 인수로 사용하지 않는다.
- DEV 종료: 적용 행의 자동·직접 GUI 증거, 제외 사유, 알려진 실패/미실행을 한 패킷으로 공급하고 사용 가능한 SHA를 고정한다. 검수용 관찰 도구의 성공을 제품 성공으로 혼동하지 않는다.
- Design 종료: 새 계약의 의미/직접 영향 행을 L2 대조하고 필요한 독립 실행 증거를 심사해 수용/보완 범위를 기록한다. 부족한 행만 묶어서 보완한다. 이 계획은 독립 GUI 수행 권한이나 실행 증거가 아니다.
- 해당 표시/guard의 제품 적용·인수 전이 차단 시점이다. Track A 전체·독립 W06 준비·Stage 전부의 착수 차단으로 확대하지 않는다.

이번 계획에서 게임 자동검사·프로젝트 로드·GUI/플레이·부분 자료/새 Session/복구 실험·빌드/export·성능은 모두 NOT_RUN. F-08·상위 통합·전체 가독성/접근성 인수와 A01-Q12 상위 PARTIAL은 별도 유지한다.

## 4. RP/EX 공동 검증 보완 — 2026-11-21 / PLANNED_NOT_RUN

기준 main `de0f03f9d2fcc301940a4176f1359b2788a51950`. [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053570152)·[Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053550740)의 사전 의미 의견을 [계약 §7](DEV-026_S01_EXCEPTION_CONTRACT.md)에 반영했다. §1의 기존20사례·copy_ids와 EX-05/16/18 구분은 그대로다. 아래 행은 기존 X/RP/EX의 최신 문맥을 연결하며 추가 필수 GUI 횟수나 모든 화면×키 조합을 만들지 않는다.

| 기존 연결 | 실제 공급 후 최소 입력/기대 | 증거·구분 |
| --- | --- | --- |
| X-01/03/07 · RP-01·02·08 | root 무효 vs 단일 P06/P07/W04B 봉투 오류, 부분 자금/당일/운영·보고 오류 → 해당 지역만 제한·독립 유효값 유지. 이전 marker/클릭/허용 상태를 현재 것으로 사용0 | 표시/행동 의존표와 경계 callback·명령 효과. 깊은 자식 전면 손상 행렬은 제외 |
| X-05/07 · RP-03·04 | 새 scope 낮은판 / old scope 높은판 / 같은판 remainder, 새 View의 자식·선택일·확인 사본·feedback·이력 초기화. 프레임 대기 중 Session/화면/사용자 포커스 변경 → 옛 callback 복원/명령0 | 정상 제품 새 Session 경로와 주입 반례를 분리. 같은 Session reset의 수신 하한 불변 |
| X-04/05 · RP-05·06 | P07 FIXED_DAY가 자정 뒤 유지, S01 직전일과 독립. 다른 run/day·낡은 확인 사본·key/value 불일치 → 조회0, 정상 사본은 실제 조회 결과 대조 | 표시한 보고·선택 문맥·사본/명령·허용/성공·계약 가능 구분. 조회 성공을 신규 계약 완료로 합산하지 않음 |
| X-06/07 · RP-07 | 계약 §7.3의 화면별 유효 fallback, 선택 소멸→선택 없음, 숨은/제거된 Control 복원0, 사용자 이동 존중, 실제 포커스 도달/가시성·스크롤·읽기 순서 | 원래 수용 복귀와 직접 영향만. 포커스만 이동할 때 자동 선택/모델 명령0 |
| X-05/07 · W04B UI-02·04·06·09~11·13 | 대기 제출 사본/현재 초안, 보류 근거/설득 이력, 허가 계획/계약 분리. 실제 실패 결과와 미수신/오류·당시/현재 구분 | 모델 전이 검증은 DEV-027, 소비·예외 의미는 DEV-026/Track B, 기능 L2는 Track A. 실제 공급 전 전체 제품 PASS 불가 |
| X-06/07 · RD-03·07 | 실제 채택/변경한 복귀·가시성·겹친 마커 동일 ID 목록 접근 | B 배치 채택·마커 재배치·최소창 규격/F08 전체 재실험을 추가하지 않음 |

### 4.1 실행 후보·표본 공급

기존 X-01~07 명령과 실제 영향 회귀를 재사용한다. 최신 P06/P07 영향은 `run_operations_ui_tests.gd`와 `run_operations_gui_cases.gd -- --auto`의 해당 행을 연결한다. F08 runner 수정은 새 Session→새 View 전환 호환 행만 대조하며 기존 실험 전부를 다시 실행하지 않는다. 새 fixture/runner는 아직 만들지 않았다.

실제 공급 때 한 패킷의 각 행에 **코드/명령 위치, full SHA(미커밋이면 base+변경 파일 해시), RP/EX 및 W04B 영향 행, 입력/기대/실제 관측, 실제 제품/소비 fixture, 원본 로그/화면·해시 위치**를 연결한다. 오류/낡은 관측의 무효과는 정지 조건 또는 동일 유효 시간 진행으로 비교해 자연 경과와 추가 부작용을 혼동하지 않는다.

Track B는 예외·실행 소속·수명·복귀, Track A는 기능 흐름/신규 W04B 영향 행을 주관한다. 같은 GUI를 중복 요구하지 않는다. 독립 실행 주체·범위·권한은 실행 전에 합의하고, DEV 자체 자동/GUI·독립 실행·Design 증거 심사를 별도로 기록한다.

### 4.2 상태·차단과 재사용

사전 의견은 수신됐지만 실제 공급/제품 L2 및 검증 수용은 PENDING이다. 새 전체 Design 차단은 없고 실제 미공급·필수 차이 행만 해당 통합/수용 시점까지 보류한다. DI-03 미결과 F08 전체 규격은 DEV-026 비의존 준비의 선행조건이 아니다. 이미 유효한 실행 승인은 원문/대상/경로/동작을 연결해 재사용하되, 이번 문서 PR이나 Design 댓글 자체를 새 제품 실행 권한으로 사용하지 않는다.

Stage 2 DONE·DEV-023 24조건·DEV-024 1115A/1115B·DEV-025 공급 종료와 원래 SHA/수용 한계를 유지한다. Track B RD별 새 심사/F08 선택·적용은 #92 별도다. RFC-DEV-026-01은 실제 계약 반영/제품 수용까지 구분해 OPEN으로 남긴다.

현재 새 자동 게임 검사·Godot 로드·실제 GUI/플레이·독립 실행·부분 자료/Session/복귀 실험·빌드/export·성능은 **모두 NOT_RUN**이다. 위 표의 기대값은 관측된 PASS가 아니다.

## 5. 로컬 실행 전환 — 2026-11-21

Owner의 DEV-026 우선 진행 원문과 로컬 실행 권한은 [티켓 §8](../tasks/DEV-026_S01_EXCEPTION_SCOPE.md)이다. 앞의 PLANNED_NOT_RUN·미구현은 작성 당시 기록이며 현재 실행 여부는 [실행 색인](../evidence/DEV-026_S01_EXCEPTION_EVIDENCE.md)과 [기계 판독 결과](../evidence/DEV-026_S01_EXCEPTION_RESULTS.json)를 따른다. 기존20사례/copy_ids·EX-05/16/18 제외/한정 의미는 변경하지 않았다.

신규 `w026_ui_fixtures.gd`는 실제 Session 생성/모델 준비와 소비 사본 변조를 구분한다. `run_s01_exception_tests.gd`는 조건별 단언과 실패 exit 검사를 제공한다. `run_s01_exception_gui_cases.gd`는 TEST_ONLY 표식을 유지하며 실제 OS 입력·화면·선택/포커스·Session 효과 해시를 기록한다. 소비 fixture를 실제 제품 자연 완주로 세지 않는다.

원본 로그는 전용 worktree의 `.local/validation/DEV-026/`에 보존한다. 미커밋 시험본은 full base SHA+변경 파일 SHA-256 및 실행별 source-hashes.json으로 고정하며 앞선 실패/보완/최종 판정을 분리한다. 자동 검사 개수와 실제 GUI 조작 수, 프로젝트 로드/빌드/Design 심사를 합산하지 않는다. 데이터 초기화 실패는 격리 프로젝트 사본에서 실제 main의 종료1을 확인하고 제품 DATA는 그대로 둔다.

P06/P07 기존 GUI 소비 전환기의 경로 재지정 검토는 [티켓 §8.1](../tasks/DEV-026_S01_EXCEPTION_SCOPE.md)에 있다. 검사의 기대값을 새 구현에 맞춰 낮추지 않고 실제 Session 소속과 선택일 문맥을 맞추는 범위다. 승인 전에는 해당 파일을 수정하지 않는다. 관련 잔여는 실제 검증 결과서에 명시한다.

DEV 자체 자동·GUI는 본 패킷, 독립 실행 주체/권한·Track B 실제 공급 L2·Design 검증 수용은 PENDING이다. Track A W04B 신규 실제 공급은 DEV-027에서 연결한다. 현재 패킷을 Stage DONE·최신 main 전체 자연 완주·RD/F08 최종 심사로 표시하지 않는다.

## 6. 승인된 검사 보완 실행 — 2026-11-21

[티켓 §10](../tasks/DEV-026_S01_EXCEPTION_SCOPE.md)에 따라 최대24개를 유지하며 run_operations_ui_tests.gd 수정 후보를 run_operations_gui_cases.gd로 재지정했다. 앞 절의 승인 대기는 당시 기록이다.

수정 전245/35실패 보존 → Session/표본 수명·선택일 준비 정렬 → 기존 호출식86곳/단언245개 보존 대조 → 수정 후266PASS → 신규 경계334·공급158·W07 322PASS → 의도적 실패exit1·프로젝트 로드exit0 → 정책/경로/해시 감사를 수행했다. 종료코드와 SCRIPT ERROR/ERROR를 함께 대조했다. 명령·실행 ID·원본 해시는 증거 JSON gui_followup을 따른다.

실제 GUI OS 입력·자연 완주·독립 실행·빌드는 NOT_RUN이다. 제품 소스 불변으로 기존 독립 수용과21캡처를 재사용하되 새 실행으로 합산하지 않는다. 실제 공급 L2/Design 수용은 PENDING이다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-026
