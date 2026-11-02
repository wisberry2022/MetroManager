# DEV-015 — W07 Stage 1 최소 S01 UI 통합 실행 티켓

- 담당: Development Project Leader / LAPTOP / 2026-11-02 (Asia/Seoul).
- 상태: **REVIEW / IMPLEMENTED / AUTOMATED_VERIFIED / DEV_GUI_CHECKED / DESIGN_ACCEPTANCE_PENDING**.
- 최초 기준 main: `293b5f956316f2be877e547fbfc223b9446f82bd` (PR #62 반영). 제출 기준: `682a4f10f2cfe14bed6984e87bff75c05f37d8b5` (INF-002 문서4개 추가, 게임/정책 코드 동일).
- 실행 승인 요청: [Issue #63](https://github.com/wisberry2022/MetroManager/issues/63).
- 브랜치: `codex/DEV-015-stage1-ui-integration` / 독립 worktree. DEV-015는 main·기존 Issue·로컬/원격 작업 브랜치에서 중복 없음 확인 후 배정.
- Owner 현재 요청: “현재 DEV-011, 012 도 구현이 종료되어 main에 반영되었으니 이후 작업을 진행해야 합니다. 이후 작업 범위를 확인하고 작업 착수에 들어가주세요”. 이는 최초 준비 지시의 이력이다. 아래 §8의 이번 개별 승인으로 구현/Git 제출을 진행하며 DEV-011/012 권한을 승계하지 않는다.
- 근거: [PM-011 승인 Stage 1](../../hq/PM-011_GATE3_2_APPROVED_PLAN.md) §2~4/6, [개발 요청](../../hq/requests/PM-011_DEVELOPMENT_KICKOFF.md), [실행 절차](../../hq/PM-011_GATE3_2_EXECUTION_PROTOCOL.md), [PM-010 개발 체크리스트](../../hq/requests/PM-010_DEVELOPMENT_CHECKLIST.md), [UI 계약 v0.2.1](../gate3/DEV-006_UI_DATA_CONTRACT.md).
- Design 입력: [DSG-003 S01](../../design/tasks/DSG-003_STAGE1_S01_IA.md), [DSG-004 지도/예측](../../design/tasks/DSG-004_STAGE1_MAP_ROUTE_PREDICTION.md), [DSG-005 v0.3 14개 검수 사례](../../design/tasks/DSG-005_STAGE1_UI_ACCEPTANCE_PLAN.md), [Design #59](https://github.com/wisberry2022/MetroManager/issues/59).
- 고정 L2 합의: [DEV 회신](https://github.com/wisberry2022/MetroManager/issues/25#issuecomment-6557565493), [Design 정적 수용](https://github.com/wisberry2022/MetroManager/issues/59#issuecomment-6557641509). 실제 UI 수용은 아직 아니다.

## 1. 현재 단계와 다음 작업의 선택

W01 진입/초기 상태, W02 시각·원장, W03 행정/노선·예측이 main에 있다. W02 자정 복합 경계의 추가 회귀도 PR #62로 반영됐다. DSG-005 검수 계획/에셋 인계는 PR #61로 main에 반영됐다. 현재 `scripts/main.gd`는 여전히 W01 정적 Label만 표시한다.

승인된 Stage 1의 다음 순서는 **W02/W03를 소비하는 W07 최소 UI 연결 → DEV 자동/GUI 증거 → Design 실제 검수 → HQ/Owner Stage 부분 인수**다. 일반 W01~09 작업 카드의 번호만 따라 W04 사업 확보를 먼저 구현하지 않는다. W04~06은 Stage 1 명시적 제외이며 다음 Slice에서 별도 티켓으로 진행한다.

## 2. 포함·제외 및 내부 작업 순서

| 순서 | 포함할 결과 | Stage / 검수 |
| --- | --- | --- |
| A. 공급 중개 | 단일 Pipeline·RoutePlan·PredictionState 소유, 완료 관측 묶음, 명령 ID/당시 결과/최신 허용 행동·사유, 표시용 보고 식별 | S1-07/08/09, QA-T01/03·X01 |
| B. 시간·장부 | 실제 정지/재개/1·2·4배속, 현재 C/R/F/K/A/B 읽기 전용, 과거 마감 보고·없음/0/오류·현재/과거 분리 | S1-05/06 표현, S1-07/08, QA-T01~03·F01~04 |
| C. 지도·목록 | DATA 좌표/안정 ID의 추상 12역 지도·동일 목록, 추가/선택/제거/순서 변경/undo, 유효성/거부 사유·키보드/목록 대체 조작 | S1-03/08, QA-M01~04 |
| D. 예측 | 실제 편집→입력 revision 무효화·계산, 지정 기간/단위/출처, READY0/미계산/실패/이전 결과·낡은 응답 거부 | S1-04/08, QA-P01/02 |
| E. 검증·인계 | 중개 자동/모델 회귀·Godot 로드·실제 GUI 조작·14개 사례의 증거/결함·Design 실행 방법 | S1-01/09 및 위 실제 입력 |

제외: W04 공공입찰/회사제안/심사·계약, W05 시공·안전·개통, W06 실제 영업/승객/운임/만족·다음사업, 플레이어 취소·원장 편집·임의 정부지급/도착/정산 토글, 범용 비동기/전역 Autoload·저장 체계, 고충실도/PNG·열차/승객 연출, 제품 PC/해상도/폰트/FPS 확정, 외부 연구·Windows export/배포, 전체 VP/AC 인수, 정책/CI·타 부서 산출물 수정.

Stage 1 별도 필수 이미지0개 수용안을 유지한다. 기존 Control·텍스트·기본 도형으로 표현하되 상태 문구/정보 위계/색 외 식별은 DSG-003~005를 따른다. 1280×720·40px·16px 타일 가설을 승인 제품 규격으로 승격하지 않는다. project.godot의 main 경로/렌더러/스트레치 설정을 이번 범위에서 변경하지 않는다.

## 3. 기존 의미를 보존하는 실제 연결 기준

1. **동일 관측:** 한 Pipeline만 시간 진행을 소유한다. 틱 완료 뒤 clock·T_COMPLETE/funds·선택 보고 사본을 중간 await/추가 tick 없이 읽어 하나의 화면 상태로 전달하고 현재 게임분 일치를 확인한다. 화면 갱신/조회는 시간·원장·난수 진행의 별도 입력이 아니다.
2. **시간 명령:** 기존 clock.paused/set_speed만으로는 없는 명령 식별·허용 행동·사유·효력 당시 결과·화면 관측 revision을 최소 중개 계층에서 제공한다. 정지 중 재개가 다음 틱을 기다리지 않으며 동기 완료를 지연 연출하지 않는다. 동일 command_id는 당시 결과만 재사용하고 늦은 응답은 최신 버튼/모델을 덮지 않는다. 계약용 CommandQueue의 업무시간/의미는 변경하지 않는다.
3. **표시 revision:** Pipeline의 revision은 시간제어/계획 편집만으로 갱신되지 않을 수 있다. 화면 묶음의 revision과 원본 pipeline/plan/input revision을 구분하여 입력 변화와 최신성을 추적하고, UI용 식별을 기존 모델의 새 필드라고 주장하지 않는다.
4. **보고:** 독립 report_id가 없음을 유지한다. 현재 실행의 보고 저장소 범위+마감 day_id를 표시용 식별로 제공한다. T1440의 현재 day2와 마감 day1을 구분한다. report(day)=={}는 없음, 존재하는 값0은 0, 조회 오류는 별도 상태다. 현재 자금은 원본 funds 값만 표시하고 마감 보고를 다시 계산하지 않는다.
5. **편집:** 지도·목록은 같은 RoutePlan에 명령1회, 같은 결과/후속 snapshot을 반영한다. 5/9역·단절의 편집 수락과 유효성 실패를 분리한다. 잠금·중복·관할외 입력 거부 시 원본 상태를 보존한다. undo false는 실행 직전 locked/allowed_actions.undo를 근거로 잠금/이력 없음 또는 예기치 않은 실패로 구분하며 validation 오류를 undo 사유로 재활용하지 않는다.
6. **예측:** 실제 계획/예측 입력 변경을 change_input에 연결한다. 성공 결과 전체를 current.value로 보관하고 현재 READY만 유효하게 소비한다. 이전 결과는 자기 revision/기간/생성 게임분과 함께 비교용으로 표시한다. complete/fail의 낡은 입력 revision 거부를 연결 테스트한다. 반열린 게임분·km·게임분·통행수·게임 통화 정수 단위를 명시하고 실제 실적/운임 수입으로 오인시키지 않는다.
7. **검증 전용 상태:** 외부관할·지연/오류·보호자금/B·미구현 계약/도착 등은 테스트 전용 실행 경로/fixture로 공급한다. 제품 main에서 테스트 입력/디버그 사건 버튼을 노출하지 않는다. 테스트 화면은 검증 데이터임을 표시한다.

## 4. 구현·Git 개별 승인 요청 경로

| 경로 | 용도 |
| --- | --- |
| `scripts/main.gd`, `scenes/main.tscn` | 기존 W01 진입을 유지하며 S01 실제 화면/입력으로 연결, 초기 실패 처리 보존 |
| `scripts/ui/stage1_session.gd` | W01 초기 상태를 받아 단일 W02/W03 소유·명령/공급 중개 |
| `scripts/ui/stage1_view.gd` | 시간·재무·보고·역 목록·예측/결과 상태 표현 및 입력 연결 |
| `scripts/ui/stage1_map.gd` | 추상 지도 기본 도형·12역/간선·포커스/선택·같은 입력 경로 |
| `scenes/stage1.tscn` | 최소 S01 UI 구성 |
| `tests/game/run_w07_tests.gd` | 중개/상태·명령·UI 신호/읽기 결과 자동/실패 종료 검증 |
| `tests/game/w07_ui_fixtures.gd`, `tests/game/run_w07_gui_cases.gd` | 정상/오류·지연·경계 입력과 검증용 UI 실행 경로, 제품과 분리 |
| 신규 `.gd` 각각의 실제 `.gd.uid` | 엔진 생성 식별자 추적 |
| 본 티켓·`docs/engineering/tasks/DEV-015_RESULT.md` | 승인·공급 매핑·초기/기대/실제·명령/증거·미해결 기록 |
| `docs/engineering/evidence/DEV-015_*.png` | 필요한 최소 GUI 입력/전후 화면 증거, 불필요한 개인 화면 제외 |

W01 데이터/로더/초기 회사 상태, W02/03 모델·자동검사, project.godot, assets, 기획/디자인/HQ/INF 산출물, tools/CI는 읽기 전용으로 유지한다. 코드 경로 추가·모델 의미 변경 필요 시 먼저 범위/영향/RFC를 보고한다. 공통 WORK_STATUS.md에 병렬 현황 행을 추가하지 않고 티켓/결과·Issue/PR을 상태 정본으로 사용한다.

Owner 승인 요청: `wisberry2022/MetroManager` / DEV-015 / 위 브랜치·경로에서 **W07 최소 S01 구현·검증, Commit, 해당 작업 브랜치 일반 Push 또는 규정 API 공유, base=main PR 생성/필수 CI 확인·동일 범위 검수 수정**. 기간은 명시 승인 시점부터 이번 티켓 검수 대응까지다. main Merge·직접 쓰기·공유 이력 재작성/force push·릴리스/배포·정책/CI/기획 수치 변경은 제외한다. DEV-011/012의 개별 권한은 재사용하지 않는다.

## 5. 실제 검증 및 인수 기준

| 구분 | 실행/기대 | 품질 증거 |
| --- | --- | --- |
| 기존 모델 회귀 | W01 219/W02 309/W03 101 기존 검사를 실제 엔진에서 재실행 | 원본 테스트·기대값 유지, 실패0/종료0·스크립트 오류 없음 |
| W07 자동 | 같은 상태의 조회/중복/지연·정지/배속·편집/undo·기간/단위·예측0/없음/실패·보고 구분 | 독립 기대값/초기·실제 snapshot/원장·단언 수·코드 SHA |
| 실패 감지 | 새 러너 `-- --verify-failure-exit` | 예상 종료1, 정상0과 엔진 오류 로그를 함께 검사 |
| 프로젝트 로드 | Godot4.7.2 `--headless --editor --path . --quit` | 로드 결과를 GUI 조작 PASS와 구분 |
| 실제 GUI | `--path .`의 제품 화면, 별도 검증 GUI 실행기 | 정지→재개/1·2·4, 지도↔목록 편집/오류 복구·가독성, 전후 캡처/입력 로그 |
| Design QA 14건 | QA-T01~03/F01~04/M01~04/P01~02/X01을 DSG-005와 1:1 연결 | 각 케이스의 초기/기대/실제·사유/허용행동·revision·게임분·GUI 증거·결함/NOT_RUN |
| 도구/제출 | doctor/check·최신 정책57테스트(제출 시 재확인)·커밋 후 fetch/preflight·두 필수 CI | 실행 명령·head/base/tree·필수 CI 링크, 검사 PASS≠Owner 승인 |

자동/GUI 증거는 코드/데이터 버전, command_id·효력 게임분·pipeline/plan/input/화면 revision, 원본 기대값/실측값에 대응시킨다. 실제 GUI가 미실행이면 NOT_RUN이며 자동 UI 신호 테스트나 정적 캡처만으로 실제 조작 합격을 선언하지 않는다.

검증 순서: A 중개/실제 fixture 제공 및 자동검사 → B~D UI 연결 → DEV 실제 조작/캡처·결함 수정 → Design #59 실제 표현/조작 수용 → 필요한 경우 Planning 의미 확인 → HQ 통합 → Owner Stage 부분 인수. 테스트 사건으로 영업/계약이 구현됐다고 표시하지 않는다.

## 6. 의존성·차단·미해결

- **선행 준비됨:** W01/W02/W03·자정 회귀 main 반영, DSG-003/004/005 설계·QA 기준 및 기존 L2 정적 의미 수용. 별도 PNG·새 행정 폴리곤·고충실도 제품 규격을 선행으로 요구하지 않는다.
- **미해결:** Design 독립 실제 인수와 Owner Stage 부분 인수. DEV 구현/검증의 실제 범위와 GUI 미실행 세부 항목은 결과 문서에 기록한다. Planning #48의 자정 보완 증거에 대한 추가 수용 회신은 현재 확인되지 않아 PENDING으로 보존하며 UI 준비 자체를 막지 않는다.
- **영향:** L2 공급·실제 화면 소비. W02 공통 시각/원장은 높은 회귀 영향이 있으므로 기존 의미/소스를 변경하지 않는다. 실제 규칙·중대한 순서/부서 경계 변경이 필요하면 해당 변경만 중단하고 RFC→HQ/Owner 절차를 따른다.
- **현재 수행:** 승인된 공급 중개·S01 화면·테스트 전용 실행기/fixture·자동 회귀 및 실제 D3D12 GUI 입력/상태 관찰을 수행했다. [DEV-015 결과](DEV-015_RESULT.md)에 명령·기대/실제·GUI 증거와 잔여를 기록한다. Commit/Push/PR·필수 CI/preflight의 실제 SHA와 결과는 제출 PR에 연결한다. 빌드/성능/외부 사용성·전체 VP는 NOT_RUN이다.
- **공식 완료 아님:** DEV 구현·검증/PR과 Design ACCEPTED·Owner DONE/Stage 종료는 별도다. 신규 명세 변경 필요 없음.

## 7. 착수 준비 검증 (승인 전 이력)

- 14개 고유 검수 ID: QA-T01, QA-T02, QA-T03, QA-F01, QA-F02, QA-F03, QA-F04, QA-M01, QA-M02, QA-M03, QA-M04, QA-P01, QA-P02, QA-X01.
- 준비용 doctor/check PASS(files213/GDScript16), UTF-8/LF·상대 링크·ID 목록 검토. 기존 root .venv를 읽기 전용 도구 환경으로 사용했으며 이 worktree의 전용 .venv 설치는 NOT_RUN이다. 테스트 파일·게임 코드·씬·설정은 변경하지 않았다.

## 8. 이번 개별 실행·Git 승인 및 범위 유지

- Owner 현재 채팅 원문: “개발 에이전트. Issue #63의 DEV-015 W07 최소 S01 UI 통합 구현 및 Commit·Push·PR 생성을 승인합니다. 티켓 범위에 한해서 작업하고 검증 후 PR 생성해주세요. main 병합은 별도 승인하겠습니다.”
- 승인자 Owner / 저장소 wisberry2022/MetroManager / DEV-015 / 위 브랜치·§2~5의 경로·구현/검증·Commit/작업 브랜치 공유/PR/동일 범위 검수 대응에 한정한다. 기간/금지는 §4 그대로이며 main Merge는 수행하지 않는다.
- 작업 중 INF-002/PR #64가 main에 반영돼 미공유 브랜치만 fast-forward했다. 자기 미커밋 작업을 보존했으며 merge commit·공유 이력 재작성·타 부서 수정은 없다. 게임/기존 모델·정책 도구는 두 기준 사이 동일하다.
- GUI 검증 중 Windows 잠금은 Owner가 해제했고, 다른 입력을 잠시 멈춰도 된다는 Owner 회신 뒤 실제 클릭/키보드 검증을 진행했다. 자동 신호 검증·실제 입력·Design 독립 검수를 구분한다. 상세 결과는 DEV-015_RESULT.md가 정본이다.

## 9. PR #65 병합 후 동일 범위 검수 대응

- Owner 후속 지시: “개발 에이전트. 디자이너 에이전트가 당신의 결과물을 테스트하여 검수한 결과를 이슈사항에 등록하였습니다. 원격 저장소의 이슈59, 이슈63을 확인하여 조치해주세요”. §4/8의 이번 티켓 검수 대응 기간·동일 범위 수정/Git 권한을 적용하며 main 병합은 별도 승인이다.
- 최신 기준 `2ae5161a8d61a77b69b71dac09c9cfc1c3fa0df5`, 새 독립 브랜치 `codex/DEV-015-ui-review-fixes`. 병합된 이전 브랜치/공유 이력을 재작성하지 않는다.
- 대상: DSG-QA-01 기존 역 정보 포커스, DSG-QA-02 MAP-07 오류 구간의 목록 텍스트. 기존 UI2개·W07 검사/fixture·본 티켓/결과·동일 DEV-015 증거 경로만 수정한다. 증거 형식 불일치 보정도 동일 경로에서 수행한다.
- 기존 모델/게임 규칙·기획/디자인/INF/정책/CI는 수정하지 않는다. Design 재검수 PENDING, 추가 게임 명세 결정 필요 없음. 결과의 최신 검수 대응 기록은 DEV-015_RESULT.md §6에 있다.
