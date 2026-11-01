# DSG-005 — Gate 3-2 Stage 1 최소 UI 표현·실조작 수용 계획

- 문서 ID: `DSG-005-STAGE1-UI-QA` / 버전: `v0.3 / REVIEW` / 작성: 2026-11-01
- 담당: Design / Art Director & UI/UX Designer / 영향: 디자인 검수 L1, DEV 공급 계약과 실제 UI 대조 L2
- 기준 `main`: `87342cd5c29a3047695c11bfd7f2b76415cdf4d8`
- Owner 승인: “DEV-11,12 구현이 완료되어 main에 머지되었습니다. 해당 내용 원격 저장소에서 확인하여 다음 작업 착수해주세요.”(검수 준비 착수), 후속 “DSG-005의 두 Markdown 산출물에 대한 PR 제출 권한을 승인합니다. ... 이전에 디자이너 에이전트가 결정한 추후 진행하게 될 디자인 산출물의 디렉토리 관리 방안도 포함해주세요”(이번 두 문서 Commit·작업 브랜치 Push·PR 제출 및 CI 확인). `main` 병합·게임 UI/에셋 제작은 별도 승인.
- 근거: [PM-011 Stage 1](https://github.com/wisberry2022/MetroManager/blob/87342cd5c29a3047695c11bfd7f2b76415cdf4d8/docs/hq/PM-011_GATE3_2_APPROVED_PLAN.md), [DSG-003 S01 IA](https://github.com/wisberry2022/MetroManager/blob/87342cd5c29a3047695c11bfd7f2b76415cdf4d8/docs/design/tasks/DSG-003_STAGE1_S01_IA.md), [DSG-004 지도·노선·예측](https://github.com/wisberry2022/MetroManager/blob/87342cd5c29a3047695c11bfd7f2b76415cdf4d8/docs/design/tasks/DSG-004_STAGE1_MAP_ROUTE_PREDICTION.md), [DEV UI 계약 v0.2.1](https://github.com/wisberry2022/MetroManager/blob/87342cd5c29a3047695c11bfd7f2b76415cdf4d8/docs/engineering/gate3/DEV-006_UI_DATA_CONTRACT.md)
- 상태: `DEV_L2_STATIC_MAPPING_ACCEPTED / CHECKLIST_V03_SUBMITTED_FOR_REVIEW / W07_GUI_NOT_IMPLEMENTED / GAME_GUI_NOT_TESTED`.
- 개발팀 회신 반영: [Issue #25 DEV→Design L2 공급 답변](https://github.com/wisberry2022/MetroManager/issues/25#issuecomment-6557565493) — 요청 1~4 수용, W07 실제 UI 통합 시 보완할 항목 및 검증 시점 확정. **해당 코멘트는 실제 기능 공급·W07 구현 완료 증거가 아니다.**

## 1. 범위와 정확한 완료 정의

**디자인팀의 작업:** 실제 UI의 정보 위계·문구·상태표·이력·지도↔목록 동일 조작·예측 출처·가독성 및 오류 복구를 검수한다. W02/W03 **모델 값 자체의 계산·판정·Godot API 설계는 Development의 소관**이다.

Stage 1 디자인 검수와 연결된 공식 부분 인수 ID: `S1-07`(시간 조작), `S1-08`(동일 지도/목록 조작·예측·현재/과거 자금), `S1-09`(증거/결함 추적), `S1-03·04·05·06`의 **화면 표현과 공급 의미에 해당하는 부분**. 실제 UI가 없다면 위 어느 항목도 화면/실조작 PASS로 판정하지 않는다.

**비범위:** 신규 경제/행정 규칙, 미구현 계약·시공·운행 기능의 플레이어 UI, P01~07 완성 UI, 고충실도 PNG·열차/시민 연출, 제품 최소 PC·뷰포트/폰트/FPS 수치 결정, Godot 코드·씬·테스트 실행(DEV 책임), 실제 외부 사용자 연구.

## 2. 현재 코드 상태 — 원격 정적 점검

| 근거 파일 | 현재 실제 구현에서 확인된 공급 의미 | 디자인 검수 전 남은 연결 지점 |
|---|---|---|
| `scripts/main.gd` | W01 데이터 초기화·회사 숫자를 **정적 Label**에 표시. W02/W03 모델 연결 UI 없음 | W07 최소 UI 실제 화면/입력 구현 및 별도 티켓 승인 필요 |
| `scripts/simulation/game_clock.gd` | `snapshot(): simulation_minute/day_id/remainder/paused/speed`, `set_speed()`는 bool, `paused`는 속성 | **현재 시간 제어용 `allowed_actions/reason_codes`·command_id/pending/결과 통합은 없음.** W07 중개 계층이 최신 허용/거부·즉시 효력·화면 관측 revision을 공급해야 함. pause 해제는 다음 시간 tick 대기로 막지 않음 |
| `scripts/simulation/minute_pipeline.gd` | `snapshot(): data_version/simulation_minute/day_id/snapshot_revision/observation_phase="T_COMPLETE"/funds/boarding/trace` | **개발팀 수용 방침:** 한 Pipeline 인스턴스를 시간 진행의 원본으로 사용. 완료된 안정 관측 시점에 clock/pipeline/보고 사본을 중간 `await`·추가 tick 없이 함께 묶고 두 현재 게임시각 일치 대조. `set_fixture()`는 **테스트 전용**, 제품 UI 노출 금지 |
| `scripts/model/company_ledger.gd` | `snapshot(): cash/restricted/reserved/free_cash/available_cash/unpaid` 및 사업별 집계 | C/R/F/K/A/B를 정확히 표시, 직접 수정·추정/재계산 금지 |
| `scripts/model/daily_ledger_report.gd` | `report(day)`로 확정 보고 복사, `current(day)`로 당일 별도. **독립 `report_id`는 없음** | 실행별 보고 저장소 범위와 **마감 대상 `day_id`**를 조합한 표시용 식별 기준을 W07에서 명시. 예: T=1440에서 **마감 day_id=1, 현재 day_id=2**. `report(day)=={}`는 미마감/없음, 존재하는 보고의 숫자0은 실제0, 조회 오류는 별도 |
| `scripts/model/route_plan.gd` | `snapshot(): station_ids/plan_revision/validation/locked/allowed_actions(edit,undo)`; `select/remove/reorder`는 수락/사유, **`undo()`는 bool** | 편집 수락과 **6~8역 유효성 통과는 별개**. 같은 Plan 인스턴스에 한 번만 명령하고 후속 snapshot을 지도·목록 양쪽에 반영. Undo 실패는 실행 직전 `locked`/`allowed_actions.undo`로 잠금·이력 없음 구별, 그 외 false는 **재조회/일반 실패**. `validation.reason_codes`를 Undo 실패 원인으로 오용 금지 |
| `scripts/model/prediction_state.gd` | `snapshot(): prediction_input_revision/plan_revision/input_minute/prediction_status/reason/available/current/previous` | DemandPredictor 성공 결과 전체가 **`current.value`**에 들어간다는 W07 연결 방침. `period_start/end`, `totals`, `distance_km`, `end_to_end_minutes`와 생성 게임분을 출처별 소비. **범용 `units` 필드는 없음**; 기간은 반열린 게임분, 거리 km·시간 게임분·인원 통행수·금액 정수. 실제 편집→`change_input` 호출은 W07 검증 항목 |
| `scripts/model/administrative_network.gd`·`demand_predictor.gd` | 역 안정 ID/부모·간선과 기간별 예측 데이터/수요 | 지도 표시 경계가 관할 판정을 바꾸지 않음. 정상/부정 테스트 fixture는 UI 통합 전 DEV와 연결 |

위 상태는 **원격 소스 정적 읽기 + 개발팀 Issue #25 회신의 통합 계획 수용**에 한정. 현재 API에 없는 항목을 구현 완료로 표기하지 않는다. 실제 S01 화면·Godot GUI의 동작 결과는 확인하지 않았다.

## 3. 디자인 실제 조작 검수 매트릭스 (실행 대기)

| ID / Stage | 사용자 동작 / 초기 상태 | 화면 기대 및 비교할 실제 증거 | 담당·상태 |
|---|---|---|---|
| `QA-T01` / S1-07 | 초기 게임일 06:00의 W02 최신 스냅샷 조회 | **하나의 Pipeline**에서 clock+T_COMPLETE/funds를 동일 완료 시점에 확보, 시각 불일치·중간 갱신 없음; `paused/speed`를 동일 관측으로 표시 | DEV 공급→DSG 확인 / NOT_RUN |
| `QA-T02` / S1-07 | 정지→기다림→재개→1/2/4배속 | 실제 클릭 후 게임분·버튼 선택상태 변화, 정지 중 진행 0; 화면만 바뀌고 모델 시각이 불변이면 FAIL | DEV W07 GUI+로그 / NOT_RUN |
| `QA-T03` / S1-07·09 | 속도 변경 허용/거부 및 동기 완료·필요 시 pending/지연 결과 | W07 중개 계층에서 최신 허용/사유·명령 결과/화면 revision을 제공하는지; **동기 처리라면 인위적 pending 연출 금지**. 늦은 거부는 당시 명령 기록만 갱신, 정지 해제는 다음 tick 대기 금지 | DEV W07 중개/fixture→DSG / NOT_RUN |
| `QA-F01` / S1-08 | 초기 C=1,000,000 / R=K=B=0 | C/F/A=1,000,000, R/K/B=`0`; 숫자·게임 통화 단위·현재 시점 표시 | 실제 화면/동일 snapshot / NOT_RUN |
| `QA-F02` / S1-05·08 | C20/R20/F0/K0/A0/B3 및 C50/K48→비용3/지급2/B1 | 제한/자유/예약/미지급 각각 표현, 발생비/현금지급 구별, K 중복차감·B 자체 계약금지 문구 금지 | DEV fixture→DSG / NOT_RUN |
| `QA-F03` / S1-06·08 | 23:59→익일00:09, 이전 보고/당일 자금 변화 | T=1440의 **보고 day_id=1 / 현재 day_id=2**를 분리; 표시용 보고 식별은 **실행 저장소 범위+마감 day_id** (전역 `report_id` 허구 표시 금지). 이전 보고 불변. 미구현 영업 이벤트는 **테스트 fixture** 명시 | DEV fixture→DSG / NOT_RUN |
| `QA-F04` / S1-08 | 확정 보고의 숫자0·`report(day)=={}`·조회 오류 및 예측 READY0·미수신·실패 | **보고는 빈 Dictionary=미마감/없음**, 정상 보고의 0은 실제0, 조회 오류는 별도. 예측은 available·status를 함께 사용. 서로를 `0`으로 대체하지 않음 | DEV fixture→DSG / NOT_RUN |
| `QA-M01` / S1-03·08 | 지도에서 S01 선택→목록에서 S02 추가→순서 변경 | 두 영역 모두 동일 stable ID/고유 역수/순서/revision. 지도만 새로운 로컬 노선 계산 불가 | DEV W07 GUI/로그 / NOT_RUN |
| `QA-M02` / S1-03·08 | 공식 P-A/P-B 6역 및 8역, 5·9역·중복·단절·타관할 부정 입력 | **5·9역/단절은 편집 자체 수락 가능하나 validation 제출 불가**, 중복 등은 편집 단계에서 거부·기존 revision 보존 가능. 편집 결과와 검증 사유·제출 가능성·대상 ID를 지도/목록에 일치 표시 | DEV W03 fixture+GUI / NOT_RUN |
| `QA-M03` / S1-08 | 제거·위/아래 이동·되돌리기·잠금 시도 | 같은 Plan 인스턴스·한 번의 명령/후속 snapshot. `undo()==false`는 이전 `locked=true`면 잠금, 미잠금+`allowed_actions.undo=false`면 이력 없음, 그 외 **일반 실패+재조회**. validation 오류를 undo 사유로 쓰거나 거부 결과를 성공 표시 금지 | DEV W07 GUI/로그 / NOT_RUN |
| `QA-M04` / S1-08 | 후보 12역이 밀집/겹칠 때 목록 대체 조작 | 지도 마커 클릭 실패 상황에도 목록에서 같은 ID·동작 수행. 포커스/순서/텍스트로 색 외 식별 가능 | 실제 GUI·가독성 관찰 / NOT_RUN |
| `QA-P01` / S1-04·08 | rev7 READY/유효0→편집으로 입력rev8 `change_input`→미계산/계산중/실패→READY | 유효0/미계산/실패/갱신중 분리; **`current.value`의 중첩 totals·반열린 기간(게임분)·거리km/시간게임분·통행수/통화정수/생성시각** 표시. 범용 units 필드 전제 금지; 실제 실적/운임 인식으로 오인 금지 | DEV fixture→DSG / NOT_RUN |
| `QA-P02` / S1-04·08 | 현재 rev8 후 늦은 rev7 READY 응답 | `complete/fail`의 **입력revision 불일치 거부**와 W07 연결을 확인; 이전 결과는 자기 입력revision·기간·생성분과 함께 비교용만 표시하고 현재 rev8 결과·허용행동을 덮지 않음 | 실제 인수 시험 / NOT_RUN |
| `QA-X01` / S1-08·09 | UI 조회/동일 ID 중복 입력·일시정지 반복 | 조회만으로 원장/게임 시간·난수·계획이 재실행되지 않음; 경제 효과 판단은 DEV 로그에 의존 | DEV 자동+GUI 동시 비교 / NOT_RUN |

**증거 최소 단위:** `코드 SHA + data/rules_version + 시뮬레이션 게임분/day_id + snapshot/plan/prediction revision + command_id/효력시각(해당 시) + 재현 조작 순서 + 실제/기대 차이 + GUI 캡처 또는 영상 + 담당 판정`을 동일 검수 케이스에 기록한다. 실행 증거 없는 항목은 `NOT_RUN`이며 PASS/FAIL로 추정하지 않는다.

## 4. 타 부서 필요한 L2 공급/확인 (실제 UI 통합 전)

1. **DEV W07 최소 GUI 통합 티켓**: 현재 `scripts/main.gd`는 W01 초기화 Label만 표시한다. DEV는 [Issue #25 회신](https://github.com/wisberry2022/MetroManager/issues/25#issuecomment-6557565493)에서 이 요청 1~4를 **W07 티켓의 공급·검증 항목으로 수용**했다. 실제 구현·GUI·Commit/Push/PR 승인은 아직 없고 개발 소관의 별도 Owner 승인 티켓이 필요하다. DSG가 개발 소스/씬을 직접 수정하지 않는다.
2. **W02 UI 소비 — 개발팀 연결 방침 확인, 구현 전**: 하나의 Pipeline 인스턴스에서 완료된 동일 관측 시점의 GameClock/Pipeline/보고 사본을 묶고 시각 일치를 확인한다. 자금 `funds.cash/restricted/free_cash/reserved/available_cash/unpaid`를 C/R/F/K/A/B에 매핑한다. **독립 `report_id` 없음**: 보고 저장소 범위+마감 대상 `day_id`는 표시 식별이며 전역 고유값이 아님. `report(day)=={}` / 실제0 / 조회 오류 구별. 시간제어 `set_speed` bool·paused 속성은 존재하나 `allowed_actions/reason_codes`·명령 pending/효력 결과 통합은 **W07 최소 중개 계층의 잔여 작업**. 정지→재개를 다음 tick에 묶지 않고 동기 완료 시 임의 pending 만들지 않는다.
3. **W03 UI 소비 — 개발팀 연결 방침 확인, 구현 전**: 지도와 목록은 동일 Plan에 **한 번만 명령**하고 반환 결과 및 새 스냅샷으로 동기화한다. 편집 수락과 `validation.valid`를 분리하고 잠금/undo 가능 여부를 최신 `locked/allowed_actions.undo`에서 판단한다. bool false의 예기치 않은 결과는 일반 실패/재조회. 예측은 성공 DemandPredictor의 전체 결과를 `PredictionState.current.value`로 전달하고, `change_input` 호출·지난 입력 응답 거부를 W07에서 검증한다. **독립 범용 units 필드는 현존하지 않음**.
4. **오류·비정상 재현 및 증거 — 개발팀 W07 티켓 공급 예정**: 정상 6/8·부정 5/9/중복/단절/잠금/undo·지도↔목록 대체 조작, READY0/미계산/실패/이전·늦은 결과, 현재자금/마감, 정지·재개·1/2/4배속. 케이스마다 코드·데이터 SHA/초기·기대·실제/명령식별자·게임분·전후 revision/캡처+로그를 분리 기록하며 실제 입력 없는 정적 스크린샷은 PASS가 아님. 외부 관할/미구현 경제 사건/지연은 **별도 테스트 환경에만** 두고 제품용 디버그 버튼 금지.
5. **DSG 자체 독립 소관**: 범례·라벨/정보 밀도·지도↔목록 UX·오류 메시지/회복과 가독성. PC/뷰포트/폰트/FPS는 아직 Owner 승인 규격 아님. 이번 Stage에 별도 PNG 필수 0개라는 개발팀 제안 수용; 본격 픽셀 PNG·하드웨어 실측 별도.

**정확한 차단:** Issue #25의 개발 회신은 **정적 공급/소비 합의 및 W07 계획 수용**이다. 1~4의 구현·실제 fixture가 미제공이어도 DSG-005 문서/정적 매핑 준비는 가능. **실제 `S1-07/08` GUI 인수는 W07 화면·정상/부정 fixture·명령/스냅샷 결과가 마련될 때까지 PENDING.** W02/W03 독립 모델 검증을 재중단하지 않는다. 기존 의미와 차이가 있으면 해당 UI-DC·화면·상태·명령ID만 L2로 협의하며 승인 게임 규칙 변경은 HQ/Owner L3로 상정.

## 5. 검수 기록 템플릿

| 항목 | 기록 |
|---|---|
| 케이스 | `QA-...` / Stage ID / 실제 검수 GUI 화면 |
| 소스 기준 | main SHA, DEV 통합 PR head, data_version, DEV UI 의미 계약 revision, **UI 모델 공급/소비 기준 시점** |
| 테스트 입력·행동 | 초기값·command_id(실제 명령이 있는 경우)·게임시각·행동 순서·필요한 fixture; 보고는 **저장소 범위+마감 day_id**, 예측은 input_revision+기간 |
| 기대 / 실제 | 정식 모델 결과·디자인 문구/상태 기대 vs 실행 화면·명령 로그; **편집 수락≠유효 노선, pending은 실제 제공할 때만** |
| 판정 | `PASS / FAIL / BLOCKED / NOT_RUN` (실제 수행 증거 필수) |
| 담당·해결 조건 | Design/DEV 소관, 영향 ID, 재검수 방법, Owner/HQ 상정 여부 |
| 증거 | 화면 캡처·조작 로그/영상·시각·revision·PR/커밋 링크 |

## 6. 후속 디자인 산출물 디렉터리 관리·DEV 인계 기준 (부서 공통 참조)

**효력 구분:** 아래 경로는 [Design과 DEV의 에셋 경로/형식 협의 수용 기록](https://github.com/wisberry2022/MetroManager/issues/51#issuecomment-6557396587)을 **후속 작업 인계용 제안 기준**으로 정리한 것이다. DSG-005에서 파일·에셋을 생성하거나 경로 규정을 수정하는 결정이 아니다. 실제 하위 디렉터리는 이번 PR에서 **만들지 않으며**, 신규 아트·PNG 제작은 별도 Owner 개별 티켓/Commit·Push·PR 승인이 필요하다.

| 산출물/수명주기 | 제안 경로 | 작성·반영 책임 / 적용 조건 |
|---|---|---|
| 디자인 작업 명세·검수·인계 | `docs/design/tasks/DSG-NNN_*.md` | **Design**. 요구/상태·검수 시나리오·의존성과 실제 파일 목록/결정·NOT_RUN 기록 |
| 편집 가능한 시각 **원본** | `docs/design/assets/source/` | **Design**. Pixelorama 등의 편집 가능한 원본 및 버전 관리. 실제 필요 파일/폴더만 생성 |
| 렌더링·내보내기 **인계본** | `docs/design/assets/exports/` | **Design**. 원본 해상도·투명 배경 픽셀 PNG, 벡터 아이콘은 SVG 또는 PNG. 원본과 대응 추적 |
| 게임 UI 패널·버튼 | `assets/ui/panels/` | **DEV**가 승인된 개발 티켓으로 가져와 Godot `res://assets/ui/panels/`에 적용 |
| 게임 공용 아이콘 | `assets/ui/icons/` | **DEV**가 승인된 개발 티켓으로 Godot에 적용 |
| 지도·역·도시 픽셀 아트 | `assets/art/world/` | **DEV**가 승인된 개발 티켓으로 Godot에 적용 |
| 후속 차량·인물·효과 | `assets/art/vehicles/`, `assets/art/characters/`, `assets/art/effects/` | **후속 Stage**의 DEV 적용 위치 후보. 첫 Stage 필수 아트로 확정하지 않음 |

**작업 흐름:** `Design 편집 원본` → `Design exports와 에셋 인계 명세` → `DEV의 승인된 독립 티켓` → `DEV가 assets/ 임포트·씬 연결` → `Design의 게임 화면 표현·가독성 검수`. 디자인팀은 `assets/`, `scripts/`, `scenes/`, `project.godot`를 직접 수정하지 않는다. `docs/design/` 내부의 비-MD 이미지·원본도 경로 자체와 별개로 **개별 Owner 제작·Git 권한**이 필요하다. 현행 `docs/governance/path_exceptions.json`에 새로운 경로 예외는 요구하지 않는다.

**이름·인계 필수 항목:** 파일명 **영문 `snake_case`**, 용도·사용 화면/상태, 원본 크기(px)·투명 여부, 상태별 변형·애니메이션 프레임, 피벗/기준점, 원본↔exports↔게임 적용 경로의 대응, 라이선스/출처와 버전/해시를 명시한다. 실제 제작 전 대상이 없는 폴더를 일괄 생성하지 않는다. 도형·텍스트로 구현 가능한 Stage 1 S01은 **별도 필수 PNG 0개**이며, W07 최소 UI의 조작/검수 의무는 유지한다.

**DEV 기술 책임:** Godot 임포트 옵션·씬 연결·표시 배율·필터·클릭 영역은 Development가 결정한다. 픽셀아트 nearest 필터·정수 배율은 **우선 검증할 가설**이며 UI 글꼴에 일률 적용하거나 대상 PC·화면 크기·폰트·타일 원본 크기·최종 배율·FPS를 본 문서로 확정하지 않는다. UI-DC-08은 DEV+Design→HQ→Owner의 후속 제품 규격 판단이다.

**검수 시점:** 실제 게임 적용 PNG/SVG가 생기면 각 에셋의 인계 명세와 Godot 수입 상태를 대조하고 사용처에서 크기·투명/선명도·상태/프레임/가독성·표시 일관성을 별도 검증한다. 현재 원본/exports/게임 적용 및 PNG 검수 모두 `NOT_CREATED / NOT_RUN`이다.

## 7. 권한·제출 경계

- Owner는 DSG-005 **검수 준비 착수**와 후속 **두 Markdown 문서 PR 제출**을 각각 승인했다. 이번 승인으로 아래 두 파일의 단일 부모 Commit·작업 브랜치 Push·PR 생성·두 필수 CI 확인 및 동일 범위 검토 대응만 수행한다. `main` 병합·릴리스나 신규 PNG/게임 코드 제작의 권한은 없다.
- 이번 **승인된 제출 브랜치**: `codex/DSG-005-stage1-ui-acceptance-plan`. **허용 파일 2개**: `docs/design/tasks/DSG-005_STAGE1_UI_ACCEPTANCE_PLAN.md`, `docs/design/tasks/DSG-005_RESULT.md`. 이 두 파일의 PR 및 해당 범위의 검토 대응 완료 시 제출 권한 종료. 미래 이미지 제작·새 디렉터리 생성, 실제 검수 증거/추가 PR의 범위 확대는 별도 Owner 승인 확인.
- 기존 `DSG-003`·`DSG-004`의 일회성 Git 권한 재사용 금지. DEV 코드·씬·`assets/` 변경, 대량 PNG 제작, 임의 경제/행정 규칙·최종 PC 목표 변경 금지.
- 상태: **`DSG005_V03_REVIEW / DEV_L2_STATIC_MAPPING_ACCEPTED / W07_IMPLEMENTATION_PENDING / GUI_ACCEPTANCE_NOT_RUN`**.

### 7.1 이번 개발 회신에서 확정된 것과 확정되지 않은 것

- **확정된 합의:** Issue #25 회신의 W07 공급·검증 계획, 보고 식별의 실제 미구현 상태, undo 실패 이유의 기존 상태 기반 판별, 예측 nested result/기간·단위, GUI 입력 검증 증거 요구사항.
- **미구현:** W07 공통 관측 중개·시간제어 허용/결과·보고 표시 키 연결·계획 편집/예측 상태 연결·GUI 및 테스트 fixture. 기존 W02·W03 모델 검증 PASS를 W07 인수 PASS로 전환하지 않는다.
- **승인 경계:** DSG-005 **이 두 Markdown 문서**의 작업 브랜치 Commit·Push·PR 제출은 Owner 승인됨. **W07 개발 코드/씬 구현**, 실제 UI 수용/검수 합격, 이미지 에셋 본제작, `main` 병합·릴리스는 이번 Design 승인 대상이 아님.
