# DEV-015 — W07 최소 S01 UI 구현·검증 결과

§1~5는 PR #65 최초 제출 시점 기록이다. 병합 후 발견된 두 결함·증거 형식 오류와 최신 수정 검증은 §6을 우선 확인한다. 최초 제출의 무결함/프로젝트 로드 진술을 현재 판정으로 재사용하지 않는다.

- 담당: Development Project Leader / LAPTOP, 2026-11-02. 상태: REVIEW / DEV 검증 완료 / Design 실제 인수 PENDING.
- 승인: [실행 티켓](DEV-015_STAGE1_UI_INTEGRATION.md) §8의 Owner 개별 구현·Commit·Push·PR 승인. [Issue #63](https://github.com/wisberry2022/MetroManager/issues/63). main 병합은 별도 승인이다.
- 제출 기준 main: `682a4f10f2cfe14bed6984e87bff75c05f37d8b5`. 최초 기준 `293b5f956316f2be877e547fbfc223b9446f82bd` 이후 INF 문서4개만 fast-forward 수용했다. 기존 게임 모델·정책 코드 변경 없음. 실제 제출 head/tree·필수 CI는 PR에서 확인한다.

## 1. 변경 파일과 공급 계약

| 경로 | 결과 |
| --- | --- |
| scripts/main.gd | W01 초기 로드/실패 처리를 보존하고 최소 S01 화면에 연결 |
| scripts/ui/stage1_session.gd 및 .gd.uid | 기존 Pipeline/Network/RoutePlan/PredictionState를 소유하는 공급 중개, 완료 시각의 조회·명령 결과·허용 행동 |
| scripts/ui/stage1_view.gd 및 .gd.uid | 시간 제어, 현재 재무/과거 보고, 역 목록·노선 편집/undo·예측/피드백 |
| scripts/ui/stage1_map.gd 및 .gd.uid | DATA 좌표의 기본 도형 지도·역 ID·순서/연결 표시, 목록과 동일 명령 경로 |
| scenes/stage1.tscn | S01 화면 진입 구성 |
| tests/game/run_w07_tests.gd 및 .gd.uid | 203개 단언의 공급·상태·명령·UI 회귀 및 의도적 실패 종료 검사 |
| tests/game/w07_ui_fixtures.gd, run_w07_gui_cases.gd 및 각각 .gd.uid | 제품에서 참조하지 않는 19개 검증 변형과 실제 GUI 실행기 |
| 본 결과·실행 티켓, docs/engineering/evidence/DEV-015_*.png 7개 | 승인·범위·기대/실제 및 게임 창으로 한정한 증거 |

총23개 파일. W01~03 원본 모델·기존 검사, project.godot, assets, 기획/디자인/HQ/INF·정책·CI·공유 집계표는 변경하지 않았다.

- 단일 세션의 완료 관측에서 시각·재무·보고·노선·예측을 묶고 화면 revision으로 낡은 조회를 거부한다. 조회 자체는 게임 시간을 진행시키지 않는다.
- 정지/재개는 tick 대기 없이 처리하고 1/2/4배속만 수용한다. command_id 중복은 최초 결과를 재사용하며 stale plan revision은 거부한다. 영업/계약 명령은 제공하지 않는다.
- 과거 마감 보고는 현재 재무와 분리한다. `run-인스턴스/day-N`은 세션 안의 표시용 키이며 영구 report_id로 주장하지 않는다. 없음·실제0·오류를 구분한다.
- 노선 입력 변경 시 예측 input_revision을 증가시키고 현재 결과를 무효화한다. 이전 결과는 비교용으로만 표시한다. 예측은 기존 Predictor로 계산하며 장부를 변경하지 않는다. 같은 입력/기간의 결과는 재사용한다.
- 첫 예측 기간은 당일06:00부터 다음날06:00까지 `[시작, 끝)`의 1440분이다. 인원/운임/비용 단위를 표시한다. 별도 제품 PNG·신규 기획 규칙은 추가하지 않았다.

## 2. 자동검사·프로젝트 로드

작업 브랜치 전용 `.venv`와 상위 Godot 폴더의 Godot 4.7.2 실행 파일을 사용했다. 다음 명령은 worktree 루트에서 실행한다. `$godotExe`에는 해당 실행 파일의 절대 경로를 지정한다.

```powershell
.venv/Scripts/python.exe tools/policy.py doctor
.venv/Scripts/python.exe -m gdtoolkit.formatter --check scripts/main.gd scripts/ui tests/game/run_w07_tests.gd tests/game/w07_ui_fixtures.gd tests/game/run_w07_gui_cases.gd
.venv/Scripts/python.exe -m gdtoolkit.linter scripts/main.gd scripts/ui tests/game/run_w07_tests.gd tests/game/w07_ui_fixtures.gd tests/game/run_w07_gui_cases.gd
& $godotExe --headless --path . --script tests/game/run_w01_tests.gd
& $godotExe --headless --path . --script tests/game/run_w02_tests.gd
& $godotExe --headless --path . --script tests/game/run_w03_tests.gd
& $godotExe --headless --path . --script tests/game/run_w07_tests.gd
& $godotExe --headless --path . --script tests/game/run_w07_tests.gd -- --verify-failure-exit
& $godotExe --headless --editor --path . --quit
& $godotExe --headless --path . --quit-after 3
.venv/Scripts/python.exe tools/policy.py check
.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v
```

| 구분 | 실제 결과 |
| --- | --- |
| W01 / W02 / W03 기존 회귀 | 각각219 / 309 / 101 단언, 실패0·종료0 |
| W07 신규 회귀 | 203 단언, 실패0·종료0 |
| W07 의도적 실패 | 예상 종료1, 정상 검사와 실패 감지 경로 구분 |
| Godot 편집기 프로젝트 로드 | headless 종료0, SCRIPT ERROR/ERROR 없음 |
| 제품 main 진입 | headless 종료0, W01_INIT_OK·W07_INIT_OK 확인 |
| doctor·gdformat·gdlint | PASS |
| 정책 check | PASS: worktree files=238, GDScript=22 |
| 전체 정책 도구 회귀 | 57개 PASS / 301.130초 / 종료0 |

W07은 시각/조회 불변성·중복/오류 명령·stale 입력·deep copy·노선6/8/9역·외부 관할·잠금·undo·예측0/4860/미계산/실패·낡은 응답·현재/과거 보고·장부 불변성과 실제 Control 신호를 검증한다. 정상 PA6 예측 기대/실제는 요청4860명·완료4860명·운임486000·비용108000, 기간360..1800이다. F03은 현재1451분/C320/B0과 과거1일/C20/운임0을 구분한다.

첫 정책57개 실행은 임시 저장소 `git add` 프로세스 생성 시 WinError5 환경 오류1건(게임 단언 실패 아님)이 있었다. 같은 모듈7개 재실행과 최종 전체57개 재실행은 모두 PASS했다. sandbox 안의 check도 임시 디렉터리 정리 접근 오류가 있어 정상 권한으로 재실행해 PASS했다. 우회·정책 변경은 없다. 원시 로그는 로컬 `.local/verification/`에 보존하며 개인 화면/대화는 제출하지 않는다.

## 3. 실제 GUI 검증과 14개 검수 ID 대응

Windows / Intel Iris Xe / D3D12의 실제 Godot 창에서 실행했다. 검증용 `--resolution 1180x840`은 제품 해상도 승인 의미가 아니다. Owner 잠금 해제·입력 중지 회신 후 클릭과 키보드를 사용했다. 그림은 게임 창만 포함한다. 검증 fixture는 화면 상단에 표시하며 제품 실행 경로에서 선택할 수 없다.

```powershell
& $godotExe --path .
& $godotExe --path . --resolution 1180x840 --script tests/game/run_w07_gui_cases.gd
```

| 검수 ID | 실제 관찰/조작·자동 증거 | 제한 |
| --- | --- | --- |
| QA-T01 | 초기 정지06:00·동일 관측 시각·재무 표시, 자동 조회 불변성 | DEV 검증 |
| QA-T02 | 실제 재개→2배→4배→1배→정지. command_id 2~6, 효력분360/377/403/454/466, 최종07:46 정지 | [시간 증거](../evidence/DEV-015_TIME_CONTROLS.png) |
| QA-T03 | 실제 제어 상태 관찰, 잘못된 배속·중복/낡은 명령은 자동 거부 검증 | 잘못된 배속의 GUI 결함 주입 NOT_RUN |
| QA-F01 | T01 공통 초기 상태에서 C/R/F/K/A/B 확인, 자동 초기값 검증 | F01 별도 독립 캡처 없음 |
| QA-F02 | R 차감/C20/R20/B3과 K 하한/C48/K48/B1 두 변형 관찰, 자동 기대값 일치 | DEV 검증 |
| QA-F03 | 2일00:11 현재C320/B0과 1일마감C20/운임0 분리 관찰 | [현재/과거 증거](../evidence/DEV-015_CURRENT_AND_CLOSED_REPORT.png) |
| QA-F04 | 없음·보고 오류·실제0 변형 관찰, 자동 상태/문구 검증 | DEV 검증 |
| QA-M01 | 지도S01→목록S02, 위로 이동→undo→제거를 실제 입력, plan revision1~5 | [지도/목록 증거](../evidence/DEV-015_MAP_LIST_UNDO.png) |
| QA-M02 | PA6 실제 예측4860명, 8역 표시, 외부 관할 클릭 거부/OTHER 경로 표시; 5/8/9역 자동 판정 | [정상 예측](../evidence/DEV-015_VALID_ROUTE_PREDICTION.png), 5/9역 수동 GUI NOT_RUN |
| QA-M03 | 잠금 fixture의 비활성 버튼/사유 관찰, 자동 명령 거부 | 잠금 해제 제품 기능은 범위 외 |
| QA-M04 | 겹친 지도에서 목록S01을 실제 선택해 편집 성공 | [목록 대체](../evidence/DEV-015_OVERLAP_LIST_FALLBACK.png) |
| QA-P01 | READY0/input7 확인 후 S05 추가→input8 미계산/이전7 비교용, 실패8 변형 관찰 | [READY0](../evidence/DEV-015_READY_ZERO.png) |
| QA-P02 | 계산중8에서 낡은7 응답 버튼 실제 입력→accepted=false, 최신 상태 보존 | [낡은 응답 거부](../evidence/DEV-015_STALE_RESPONSE_REJECTED.png) |
| QA-X01 | 정지/조회 화면 관찰, 중복 명령과 장부 불변성은 자동 단언 | GUI 중복 결함 주입 NOT_RUN |

실제 입력 로그는 `W07_COMMAND`로 command_id·명령·효력분·revision을, 낡은 예측은 `W07_LATE_RESPONSE accepted=false`를 출력한다. 전후 상태·명령은 같은 검증 세션에서 확인했다. 자동 신호 검사를 실제 마우스 입력으로 계산하지 않는다. 이 표는 DEV 증거이며 Design의 14개 독립 수용 판정이 아니다.

## 4. 인계·미해결·명세 영향

- Design [#59](https://github.com/wisberry2022/MetroManager/issues/59): 위 실행기로 19개 변형을 선택해 실제 표현/조작 수용 필요. 수치/시간 의미는 기존 L2를 유지했다. 테스트 전용 시간외 사건은 제품 영업/계약 구현을 의미하지 않는다.
- NOT_RUN: Windows export/빌드·배포, FPS/성능 목표, 외부 사용성 연구, 전체 VP/AC 인수, 다양한 화면 크기/폰트/DPI의 완전 검수, 키보드만으로 전체 노선 편집 완주. 프로젝트 로드·자동검사·부분 GUI 조작과 구분한다.
- 코드 범위의 미해결 결함은 현재 확인되지 않았다. 위 수동 미실행과 Design 독립 인수·HQ/Owner Stage 부분 인수는 남아 있다. Planning #48의 별도 수용 회신 상태를 임의 확정하지 않는다.
- 신규 기획/디자인 명세 변경 필요 없음. 공식 DONE/ACCEPTED·Stage 종료 및 main 병합을 수행하지 않았다.

## 5. 제출 검증 기록

커밋 전 최종 check/전체 정책 회귀와 커밋 후 fetch/preflight, 원격 head·부모·tree·경로 및 policy/department-policy 결과를 PR·Issue #63에 연결한다. API 공유는 로컬 훅을 실행하지 않으므로 로컬 정상 커밋의 검사와 원격 필수 CI를 각각 확인한다.

## 6. 2026-11-02 Design 검수 두 결함 후속

담당 AGT-DEV-0001 / LAPTOP. 기준 main `2ae5161a8d61a77b69b71dac09c9cfc1c3fa0df5`, 브랜치 `codex/DEV-015-ui-review-fixes`. Owner의 이번 조치 지시와 티켓 §4/8의 동일 범위 검수 대응 승인에 따른다. [Design 증거 판정 #59](https://github.com/wisberry2022/MetroManager/issues/59#issuecomment-6577275089), [구체 요청 #63](https://github.com/wisberry2022/MetroManager/issues/63#issuecomment-6577283763)을 읽었다. Owner QA ZIP 원문은 이번에 직접 열람하지 않았으며 그 묶음의 검증 판정은 Design 회신을 출처로 한다.

### 수정과 범위

- **DSG-QA-01:** 이미 포함된 역의 지도/후보 목록 재클릭은 로컬 정보 포커스로 처리한다. 새 역 클릭만 기존 추가 명령을 보낸다. 안내 문구로 두 의도를 구분하며 지도·후보 버튼·노선 행의 선택을 일치시키고 선택 행으로 스크롤한다. 포커스는 모델 조회 외 명령을 보내지 않아 계획/예측/장부/command_result 및 revision을 바꾸지 않는다. 잠금 중에는 포함된 역 정보 선택을 허용하되 새 역 추가·제거/정렬/undo는 비활성을 유지한다.
- **DSG-QA-02:** 지도와 동일 DATA 간선을 이용해 연결 오류의 양 끝 ID·순서·간선 없음 사유를 목록 바로 아래 텍스트에 제공한다. 실제 허용 행동에 맞춰 순서 조정/제거/추가 또는 현재 잠금 안내를 표시한다. 색만 의존하지 않는다. 원본 Plan 유효성/단절 편집 수락 의미는 유지한다.
- **증거 형식 정정:** 최초7장과 이번5장 모두 Computer Use 응답의 실제 바이트가 JPEG였으나 PNG 확장자로 저장됐음을 발견했다. 최초 editor 재임포트는 종료0이어도 `Not a PNG file`/ERR_FILE_CORRUPT를 출력했다. 이를 로드 정상으로 간주하지 않는다. Godot의 JPEG decoder→PNG writer로 기존 디코딩 픽셀/크기를 보존해 변환했으며 화면 내용/수치·발생 시점을 편집하지 않았다. 변환 뒤12장의 실제 PNG signature·CRC와 엔진 재임포트를 확인했다. 기존7장은 최초 사건의 증거이며 새 코드 증거로 소급하지 않는다.
- 변경 파일: `scripts/ui/stage1_map.gd`, `stage1_view.gd`; `tests/game/run_w07_tests.gd`, `w07_ui_fixtures.gd`; 본 결과·실행 티켓; 기존7개 증거와 아래 신규5개 증거. 총18개 파일. `.png.import` 등 로컬 생성 캐시는 제출하지 않는다.

### 자동·로드·실제 GUI 구분

기존 §2 명령을 최신 코드에 실행했다. W01 **219**, W02 **309**, W03 **101**, W07 **273** 단언 실패0·종료0(합계902). 신규70개는 포커스의 전체 세션 snapshot 불변·양쪽 선택·잠금 경계·정상/단절 위치·복구/undo 등을 검증한다. 의도적 실패 종료1(예상), 제품 main headless 종료0. 최종 editor headless 재임포트 종료0·ERROR/WARNING 없음. format/lint·doctor PASS, 정책 전체 **80개 PASS / 315.675초 / 종료0**. DEV-016 main 반영으로 기존57개 대비23개가 추가됐으며 도구/검사는 수정하지 않았다. 최종 check/커밋·원격 head/preflight/CI는 제출 PR에 연결한다.

실제 Windows Godot4.7.2 / D3D12 / Intel Iris Xe / 검증 실행기 `--resolution 1180x840`에서 다음을 직접 클릭했다. 해상도는 제품 사양 승격이 아니다. 검증용 fixture는20개(기존19+정확한 MAP-07 변형1), QA ID는14개 그대로다. 이번 실행기의 마지막 정상 종료코드는0이다. 최초 QA 환경의 shader cache 진단 원인을 규명하거나 전체 성능 정상으로 판정한 것은 아니다.

| 실제 입력·초기 → 기대/실제 | 증거 |
| --- | --- |
| 빈 계획/T01 공통 초기에서 지도 S01 추가→마커 재클릭→후보 재클릭→제거: 추가 명령1회/plan1, 포커스2회1→1·명령 없음, 제거 plan2. 이 부분은 자동 스크롤 최종 한 줄 보완 전 실행 로그로만 보존 | 로컬 gui-review-first.log, 최종6역 포커스는 아래 재검증 |
| QA-M02 정상6역에서 S12 마커→후보 S12 재클릭: 두 번 모두6→6, 명령 없음, 선택 행6 자동 스크롤, 오류 없음 | [포커스](../evidence/DEV-015_REVIEW_FOCUS.png) |
| 선택 S12 위로→단절 구간4.S04→5.S12 설명→undo: plan7→8, 정상6역 복구·오류 설명 제거 | [정상 복구](../evidence/DEV-015_REVIEW_NORMAL_RESTORED.png) |
| QA-M02-DISCONNECTED 정확한 MAP-07 `S01→S03→S04→S08→S12→S11`/plan6 → S01 정보 선택: plan6 유지, 지도 단절선과 `1. S01 → 2. S03: 연결 간선 없음`·수정 안내 일치 | [MAP-07](../evidence/DEV-015_REVIEW_MAP07_GAP.png) |
| 위 상태 S01 제거: plan7, 특정 단절 설명 사라짐. 5역 최소 조건 실패는 그대로 유지(유효로 오표시하지 않음) | [복구 경계](../evidence/DEV-015_REVIEW_MAP07_REPAIR.png) |
| QA-M03 잠금6역에서 S01 클릭: plan6→6/명령 없음, 정보 선택·행/버튼 상태 표시, 편집 비활성 | [잠금 포커스](../evidence/DEV-015_REVIEW_LOCKED_FOCUS.png) |

최종 실행기 로그 발췌(게임분360):

```text
W07_FOCUS station_id=S12 plan_revision_before=6 plan_revision_after=6 command_dispatched=false (지도/후보 각1회)
W07_COMMAND ui-42664461879-1 reorder accepted=true plan_revision=7 reason_codes=[DISCONNECTED]
W07_COMMAND ui-42664461879-2 undo accepted=true plan_revision=8
W07_FOCUS station_id=S01 plan_revision_before=6 plan_revision_after=6 command_dispatched=false (MAP-07)
W07_COMMAND ui-42664461879-3 remove accepted=true plan_revision=7 reason_codes=[STATION_COUNT]
W07_FOCUS station_id=S01 plan_revision_before=6 plan_revision_after=6 command_dispatched=false (잠금)
```

재현: §3의 GUI 실행기에서 QA-M02 / QA-M02-DISCONNECTED / QA-M03 선택. 첫 사례의 S12를 지도·후보에서 재클릭하고 위로/undo, 둘째 사례의 S01을 선택/제거한다. 신규 `W07_FOCUS`는 정보 선택 관찰 로그이며 command_id/모델 명령으로 꾸미지 않는다. `W07_COMMAND`와 분리해 포커스/모델 변경을 추적한다. 원시 로그는 `.local/verification/`에 보존한다.

**남은 사항:** 두 건은 DEV 수정/회귀·실제 GUI 확인 완료이며 Design 독립 재수용은 PENDING이다. 이번 검증을 14개 QA 전체 ACCEPTED로 승격하지 않는다. 9역 다양한 경계·지연 시간 명령/동일 command_id GUI·키보드 전 과정·다양한 DPI·자정 전체 시퀀스·별도 제품 main 수동 검증·빌드/export·성능/외부 사용성/전체 VP는 이번 NOT_RUN으로 유지한다. 수정 후5역 결과 관찰은 전체5역 시나리오 인수가 아니다. 기획/모델·신규 디자인 명세 변경 필요 없음. main 병합·Stage 종료·Issue 자동 종료 없음.
