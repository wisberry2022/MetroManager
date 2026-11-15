# DEV-024 — VS-01 실행·Design 입력 패킷 검토안

- AGT-DEV-0004 / 2026-11-15 / **DEV_SELF_GUI_VALIDATED / INDEPENDENT_REVIEW_PENDING**.
- 기준 main: `0a76a2e924ec0b661e3cdbd858ed6bfd665f3dc9`.
- [티켓·권한/8경로](../tasks/DEV-024_VS01_INTEGRATION_EVIDENCE.md) / [검증 계획](DEV-024_VS01_VALIDATION_PLAN.md).
- DEV-026 구현·제품 검증 **HOLD** 유지. §1~5는 준비 이력이며 실제 실행·인계 현황은 §6에 기록한다.
- 요청 정본: [Design #80](https://github.com/wisberry2022/MetroManager/issues/80#issuecomment-6888452975). [#81](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6888459436)은 연결용이며 동일 검수를 반복하지 않는다.

## 1. Design 입력6묶음: 준비 완료와 실행 시 채울 값

| 입력 | 현재 연결한 내용 | 실제 실행 전/후 남은 값 |
| --- | --- | --- |
| 입력-1 담당·범위·권한 | AGT-DEV-0004, 티켓 §1 Owner 준비 지시·승계 근거, §3~5 실행 제안 | 로컬 구현/검증 승인 원문 및 독립 실행 주체·유효 권한. Git 승인은 제출 단계에서 별도 |
| 입력-2 고정 시험본·영향 | 위 full SHA. 기존 GUI 시험 SHA `bf99dd11f3d8cd4d6dc07e38de164cd0b27f8dba` 대비 후속 PR #129~132 문서13개만 변경 | 새 관측기·원본 기록 도구의 실행 전 고정 사본/해시. 실제 실행본 목록·제품 소스 동일성 재확인 |
| 입력-3 정상 초기/환경 | 정상 main 부팅·기본 데이터·빈 프로필/실행 폴더, 아래 명령·환경 규격 | 실제 Godot 실행 파일/버전/해시, OS/renderer·창/viewport·프로필 경로·로그 |
| 입력-4 조작·기대 | §3 단일 연속 경로·대기·ID/효력시각·유효 보고/조회 성공 조건 | 실제 입력 시각·생성 ID·관측값. 예정 시각을 실제 결과로 적지 않음 |
| 입력-5 자체 검증/한계 | 기존 DEV-022/023 증거와 재사용 경계, 검증 계획의 최종 회귀 목록 | DEV-024 자체검사/회귀/로드/GUI 실행별 결과·해시·미실행·해당 제출 CI |
| 입력-6 관측/출처 | §4 기존 로그와 부족한 원장/입력 연속 기록의 최소 보완 계약 | 실행 전 helper 해시, 실제 개입 목록·run ID·시작/종료/exit/오류·파일 색인 |

현재 패킷은 **준비안**이며 실제 독립 GUI 시작 조건이 모두 충족됐다고 선언하지 않는다. P1~P2 로컬 실행 승인과 구현/검증 후 미공급 항목만 채운다. 신규 PR 생성은 로컬 실행 선행조건이 아니다. 미커밋 관측기는 기준 SHA에 포함됐다고 표시하지 않고 별도 파일 manifest로 고정한다.

## 2. 정상 초기 상태·환경·실행본 고정

### 2.1 제품 출처와 기존 수용 영향

`git diff --name-status bf99dd11f3d8cd4d6dc07e38de164cd0b27f8dba 0a76a2e924ec0b661e3cdbd858ed6bfd665f3dc9` 결과는 Planning3·Design2·HQ5·DEV 후속 기록3개다. 제품 소스·씬·데이터·설정·게임 테스트·정책 변경은 없다. 후속 문서가 새 제품 계약을 승인한 것으로 해석하지 않는다. DEV-023의 기존24조건 수용은 유지한다. 실제 DEV-024 실행 환경 동일성은 아직 NOT_VERIFIED이며 실행 시 비교한다.

실행 전 `git rev-parse HEAD`·`git status --porcelain=v1`·제품 경로 diff를 기록하고, `scripts/`, `scenes/`, `assets/data/`, `project.godot`, 사용 테스트/관측기·수집 스크립트의 실행 사본을 고정한다. full SHA와 SHA-256 목록을 함께 남긴다. 시험 중 수정하지 않고, 수정이 필요하면 run을 종료·보존한 뒤 새 source/run ID로 시작한다. 문서만 변경되면 이를 실제 게임 재실행 이유로 삼지 않는다.

### 2.2 정상 부팅과 프로필

[제품 main](../../../scripts/main.gd)은 Gate 2 데이터를 읽고 InitialCompanyState를 통해 새 Session을 생성하며 운행 UI를 활성화한다. 기존 진행 상태를 불러오는 세이브 로더는 현재 `scripts/` 검색에서 확인되지 않았다. 시작 로그 `W01_INIT_OK`와 초기 snapshot을 직접 대조해야 하며, 검색 결과만으로 실제 초기화 PASS를 선언하지 않는다.

예정 초기값: Day1 06:00 / T360, C1,000,000·R0·F1,000,000·K0·B0, 유효 사업/공사/운영선/마감 실적 없음. 제품 데이터는 `assets/data/gate2_w01_v1_3.json`, `stage2_tenders_v1_3.json`, `gate2_w03_demand_v1_3.json`의 고정본이다. 값·계약·상태를 fixture로 덮어쓰지 않는다.

기존 사용자 AppData를 삭제하지 않는다. 실행별 빈 디렉터리 아래 APPDATA/LOCALAPPDATA/TEMP/TMP를 프로세스 범위로 분리하고 종료 후 원래 환경을 복원한다. 과거 경로 길이/캐시 문제를 피하도록 저장소 루트 `.local/g24/<run-id>/` 같은 짧은 경로를 사용한다. 로컬 절대 경로는 제한 manifest에, 공개 색인은 상대 경로로 기록한다. safe-save·훅·검사를 끄지 않는다.

### 2.3 실행 명령·화면

예정 엔진은 기존 검증의 Godot `4.7.2.stable.official.ed1daf0bf`와 대조한다. 실제 버전은 승인 후 확인하며 이번 새 엔진 실행은 NOT_RUN이다. `project.godot`의 4.7 / Forward Plus / Windows d3d12 / canvas_items·expand 설정을 유지한다.

아래 PowerShell의 `$GodotExe`, `$RunRoot`, `$ProjectRoot`는 실행 직전 확인한 엔진·빈 실행 폴더·시험 worktree 절대 경로다. UI 게임 창은 실제 조작 대상이며 수집용 보조 프로세스 창은 숨김으로 실행한다.

~~~powershell
# 제품 자체 실행 기준: 승인 후에만 실행
& $GodotExe --path $ProjectRoot --resolution 1100x900 --log-file "$RunRoot/product.log"
# 최소 관측 보조를 구현/자체검증한 경우의 제안 인터페이스
& $GodotExe --path $ProjectRoot --resolution 1100x900 --log-file "$RunRoot/product.log" --script tests/game/run_vs01_tests.gd -- --observe --run-id=<id> --evidence-dir=<absolute-run-directory>
~~~

두 명령을 각각 전체 완주할 의무는 없다. 관측 보조는 동일 `scenes/main.tscn` 정상 초기화를 호스트하고 제품 코드/데이터를 그대로 사용한다. 새 옵션은 **구현 예정 계약**으로, 아직 실행 가능한 도구가 아니다. 실제 시작/종료·프로세스 exit·stdout/stderr는 실행 launcher가 기록한다.

1100×900 창은 반복 가능한 관측 목표이며 새 화면 수용 명세가 아니다. 실제 client/viewport 크기, OS 배율·renderer·엔진 로그를 함께 기록한다. 작은 창·물리 DPI 전체 조합 재검수는 제외한다.

## 3. 실제 마우스/키보드 완주 절차

아래 V01~V05는 **한 프로세스·한 초기 상태의 관측 구간5개**다. 별도5회 실행·DEV-023 개별 행 재인수 요구가 아니다. 모든 상태 명령은 실제 제품 버튼으로 발행하고 정상 `정지`·`재개`·`1×/2×/4×`만 사용한다. 버튼 직접 signal emit, Session.dispatch/request 직접 호출, advance_to/시각 대입은 자연 완주에서 금지한다.

| 구간 | 실제 조작·대기 | 기록과 판별 |
| --- | --- | --- |
| V01 초기→B01 사업 확보 | 정상 실행 → 필요 시 `정지` → `공공입찰 목록 열기` → B01 선택 → `선택 공고 상세 확인` → `응찰 요청`. 요청/접수 확인 후 재개·배속으로 Day2 06:00(T1800) 마감 처리까지 대기 | B01/B01-R1/P-A, command ID·requested_at·effective_at·판정 revision, player86/competitor80, 유효 사업 계약·정부 지급1회. C1,800,000/R800,000/F1,000,000/K0/B0 확인 |
| V02 동일 사업→표준 완공 | B01의 `P05 인계 정보 확인`·`공사·검증·개통 화면 열기` → `표준 공사` 선택 → `공사 계약 요청` → 실제 효력 확인 → `착공 요청` → 정상 시간 진행으로2880분 공정·최종 지급 완료 대기 | 동일 project/business contract와 새 construction contract ID, 착공/기성/완공 시각. 누적 기성 floor(600000×경과/2880) 및 원장 차액. 완공≠개통. 영업 전 C1,200,000/R200,000/F1,000,000/K0/B0 |
| V03 검증→개통 | 완공 후 `시범운행 요청` →60분 완료/PASSED → `안전검증 / 재시험 요청` →60분 완료/PASSED → `개통 요청` → 다음 효력분 확인 | 요청·효력시각, 동일 사업/공사·운영선 source ID, trial/safety PASSED·opened_at·service_ready. 표준 정상 경로에서 수리 조작은 예정하지 않음 |
| V04 실제 영업→유효 마감 | `운영 현황`(P06)에서 실제 운영선/완료/이동 중/비용을 관측. 정상 시간으로 첫 실적 있는 날짜 마감까지 진행. `재무 상세` 또는 `재무·보고`(P07) → `첫 실적 보고 보기` | 실제 service_minutes>0 AND completed>0 AND fare=completed×100인 첫 마감 보고. 현재 집계와 고정 보고의 날짜 구분, report display_key·day_id·closing_funds·원장/도착 비교 |
| V05 확인한 보고→다음 조회 | 위 첫 보고를 실제 표시한 상태에서 `공고 조회` → 권위 QUERY accepted 확인 → P01 공고/후보 화면 도달. 필요한 화면 캡처 후 제품 정지·정상 창 종료 | 화면이 표시한 report_key와 QUERY first_valid_report 일치, 조회 observed_at·tenders version, P01 진입. 조회 가능≠응찰 자격/다음 수주. 두 번째 응찰은 필요 없음 |

B01은 데이터의 고정 노선 조건을 소비하므로 S01에서 임의 노선을 추가로 만들 필요가 없다. 최초 응찰은 마감 전 효력으로 접수됐는지 확인한다. 정지 중 요청은 pending일 수 있으며 재개 후 다음 게임분의 결과를 기다린다. 오래된 화면/상태 변경 거부가 나오면 원본을 남기고 실제 `재조회` 후 같은 정상 경로에서 재시도할 수 있다. 사업을 놓치거나 원장/ID 연속성이 깨지면 성공으로 덮지 않고 해당 run을 실패/부분으로 보존한다.

매 구간의 ID는 실행 결과에서 읽으며 생성값을 미리 주입하지 않는다. 사업→사업 계약→공사 계약→운영선 source→보고 day/display_key→QUERY를 한 표로 연결한다. 동일한 논리 ID가 다른 실행에 재사용될 수 있으므로 run ID·프로세스·초기 snapshot을 항상 함께 키로 사용한다.

시간 추정: clock은 실시간1초당2.4게임분(1×), 4×는9.6분이다. T360→T5760(예상 첫 실적일 마감)의 순수 진행은 4× 기준 약562.5초다. 정상 사용자 조작·정지·관측 시간은 별도이며 개통일/첫 유효 보고일은 실제 효력시각으로 결정한다. 과거 fixture의 T4805·완료4291·고정 일일 수익을 합격 기대값으로 강제하지 않는다. 긴 대기는 짧게 나누어 관측하고 도중 중단/지연을 기록한다.

## 4. 관측 수단: 기존 로그 재사용과 최소 보완

이미 있는 제품 로그:

| 로그/조회 | 기존 제공 | 보완 필요 |
| --- | --- | --- |
| W01_INIT_OK·DEV023_ACTIVATION·W07_INIT_OK | 정상 초기화·활성화 | 실행 source/profile·run ID와 연결 |
| W07_COMMAND·DEV019_BID_REQUEST·DEV021_COMMAND | 정지/배속·입찰/공사 요청·효력 예약 | 실제 OS 입력·후속 판정·원장 연결 |
| DEV019/DEV021 표시 로그 | 입찰·공사 화면의 변경 관측 | 화면에 노출되지 않은 전체 원장·장기간 영업 연속성 |
| DEV023_UI REPORT/QUERY | 표시 보고·현재 자금·query 결과 | 실제 입력→화면·서비스/도착 누적과 run 종료 |
| pipeline.snapshot(), ledger.entries(), reports.report/current | 읽기용 권위 사본·trace·원장·고정 보고 | 제품 stdout에서 매번 모두 내보내지 않음 |

기존 `run_operations_gui_cases.gd`는 `FX.opened()`·`advance_to(5760)` 또는 소비 fixture를 사용한다. 해당 runner로 얻은 실제 화면/조작 수용은 유효하지만 **정상 초기 전체 경로 준비 없이 자연 VS-01을 증명하지는 못한다**.

정적 조사상 전체 입력/원장 연속 기록이 기존 stdout만으로는 부족하므로, 다음 승인 범위에 작은 TEST_ONLY 관측 호스트를 제안한다. 별도 검수 프레임워크나 새 모델 fixture는 만들지 않는다.

- 정상 main 장면을 그대로 생성하고 실제 window input·주요 상태 전환·주기 관측·선택 캡처를 연결한다. Session/시계/모델·화면 supply를 바꾸거나 제품 process를 멈추지 않는다. 게임 정지/배속은 실제 제품 버튼으로만 변경한다.
- 입력 sequence·실시각/monotonic tick·장면/화면·포인터/키, 명령 ID/요청/효력, snapshot의 게임분/revision/source ID를 기록한다. 입력 수신 직전/직후와 프레임 처리 후의 차이를 구분한다. 단순 시간 근접만으로 인과 성공을 선언하지 않는다.
- `ledger.entries()`의 새 행, 보고/운영 누적 변화, source ID, trace 범위를 별도 색인으로 저장한다. 도착은 effective_at별 운임 행/100과 실제 completed 변화·cohort 정보로 대조한다. 프레임 사이 여러 게임분이 지나면 도착 개별 사건을 관측했다고 과장하지 않고 누적/원장 시각 증거로 표시한다.
- `snapshot()`/보고/원장 getter는 정적 조사상 사본을 반환한다. 구현 후 읽기 전후 의미 상태 불변·제품 정상 초기화·오류/출력 실패 처리·exit1 감지를 자체검증한다. 관측 비용으로 프레임 지연이 생기면 측정/기록하고 수집 빈도를 줄이며 시계를 직접 보정하지 않는다.
- 캡처가 필요하면 관측용 키/외부 캡처를 명시하고 게임 행동을 대신 발행하지 않는다. 매 프레임 스크린샷이나 모든 cohort 원본 반복 저장은 필요 없다. 시작·V01~V05 경계·필수 불일치·종료를 충분히 연결한다.
- 테스트 전 파일 사본/해시를 고정한다. 실행 후 원본 로그/입력/상태/화면·exit manifest와 파일 SHA-256 색인을 만든다. 늦게 만든 helper 해시를 실행 전 원본으로 소급하지 않는다.

## 5. 시작·종료·Design 인계

실제 독립 실행 전 입력-1~4가 확인되고 입력-5 적용 가능한 자체검증·알려진 결함과 입력-6 관측법을 대조할 수 있어야 한다. 독립 실행자는 DEV 구현/자체검증과 구별해 기록한다. 현재 독립 실행자 지정/실행 결과는 NOT_VERIFIED/NOT_RUN이며 다른 대화의 권한을 추정하지 않는다. DEV 자체 캡처만으로 독립 수용을 선언하지 않는다.

완주를 막는 확인된 제품 결함, 초기/ID/보고 연속성을 증명할 수 없는 필수 누락만 해당 실행의 차단 사유로 특정한다. 기존 물리 DPI·과거 도구 바이트·기록 정정 잔여를 자동으로 이번 전체 실행 차단으로 올리지 않는다.

종료 패킷은 run/source/environment/helper manifest, 입력·원장/보고·주요 화면, V01~V05 기대/실제, 시작/종료/exit/오류, 검증·기존 수용/S2 색인으로 구성한다. 필수 경로와 증거가 연결되고 차단 결함/필수 누락이 없으며 Design이 관측 범위를 명시해 수용하면 해당 GUI 단계를 종료한다. 충분한 별도 독립 증거가 있으면 Design은 심사로 수용하며 같은 GUI 재실행을 새로 요구하지 않는다. DEV-024 DONE·Issue 종료·HQ/Owner Stage 인수는 별개다.

#80에 회신할 때는 이6묶음과 원본 접근 방법·해시를 한 번에 연결하고 #81에는 요약/링크만 둔다. 현재는 **로컬 인계안만 작성**했으며 게시 권한/도구 실행 권한으로 해석하지 않는다. 보완은 기능 결함·증거 누락·기록 정정을 묶어 영향 행만 처리한다. 전체 경로 무효가 확인된 경우에만 전체 재실행 여부를 판단한다.

## 6. 승인 후 실제 실행·독립 인계 현황

### 6.1 실행본과 관측 계약

정본 자체 실행은 **DEV024-GUI-20261115T035321 / DEV_SELF_GUI / AGT-DEV-0004**다. 기준 main은 위 SHA, 미커밋 관측기와 UID는 [검증 JSON](DEV-024_VS01_VALIDATION.json)의 별도 SHA-256으로 식별한다. run 시작 전 제품/사용 테스트·데이터 사본, source-manifest와 launcher를 고정했고 성공 실행 중 소스 변경은0이다. `.local/g24/`는 공용 저장소 루트 기준이며 이 worktree에서는 `../../g24/`다. 원본 접근은 같은 로컬 저장소/Owner 제한 보관이며 외부 전송은 하지 않았다.

실행 후 최종 정적 감사에서 관측기 CRLF를 규약의 LF로 정리했다. 시험 원본 `be5d52f6d5196deed95c50e1b5e0123490c577f6599dec8cf3f00244ee1cf7be`와 제출 후보 `fa20d87f05d3726e9ca583a92e113977b9060932438bb27aec6b5eda0ecefd81`는 개행 정규화 후 바이트가 완전히 같다. 원본 사본/실행 해시는 유지하며 최종 LF 바이트로 게임을 다시 실행한 것은 NOT_RUN이다. 코드 내용·제품·환경 변경이 없어 기존 실행을 재사용한다.

Godot `4.7.2.stable.official.ed1daf0bf`, 엔진 SHA-256 `c8f0a6bc45a19b33541501e57f6f7cd972ab18453743266339d495cbbe846643`, Windows / D3D12 12_0 / Forward+ / Intel Iris Xe를 기록했다. 요청 창1100×900, 실제 viewport·PNG1152×942다. 물리 DPI 전체 검증은 NOT_VERIFIED다. run별 빈 APPDATA/LOCALAPPDATA/TEMP/TMP에서 정상 T360/C1,000,000으로 시작했다.

실제 GUI 명령은 `Godot_v4.7.2-stable_win64_console.exe --path . --resolution 1100x900 --script tests/game/run_vs01_tests.gd -- --observe --run-id=DEV024-GUI-20261115T035321 --evidence-dir=<빈 절대 실행 폴더>/evidence`이며 작업 디렉터리는 본 worktree다. launcher가 stdout/stderr를 `console.log`로 수집하므로 이 실행에는 `--log-file`을 사용하지 않았다. 재현 시 새 run ID/빈 폴더와 실행별 환경을 사용한다. 원본 `run_checks.py`·`launch.json`에서 실제 명령/프로필을 확인할 수 있다.

관측기는 정상 `scenes/main.tscn`을 호스트하며 입력 수신, 1초 간격/입력 후 상태 사본, 원장/trace 증분과 F12·이정표 캡처를 기록한다. 실제 조작은 Computer Use `@oai/sky`의 마우스·키보드 및 제품 정지/재개·1×/4×만 사용했다. fixture, 명령 직접 호출, 상태/시각 주입은 없다. 관측 도구의 `DEV_SELF_GUI` 표기는 이번 DEV 실행 분류이며 후속 실행자의 신원/권한 인증이 아니다. 독립 실행은 해당 주체·권한·별도 run/source/입력 원본을 추가로 기록해야 한다.

### 6.2 같은 실행에서 관측한 V01~V05

| 구간 | 실제 결과 |
| --- | --- |
| V01 | B01/B01-R1/P-A, 응찰 요청T398/효력399, T1800 player86/competitor80·사업 계약·정부800000 단회 지급 |
| V02 | 사업 `B01-R1-BUSINESS` → 공사 `B01-R1-BUSINESS-CONSTRUCTION`; 표준 계약 효력2016·착공2042·완공4922, 2880분/600000. 영업 전 C1200000/R200000/F1000000/K0/B0 |
| V03 | 시범5095→5155, 안전5196→5256, 개통5321. 같은 사업/공사 source로 실제 영업 |
| V04 | 첫 유효 Day4 마감 경계5760(첫 관측5764), 서비스439분·완료1969·운임196900·운영비/지급43900. 마감 C1353000/R200000/F1153000/K0/B0. 실제 첫 보고 선택/화면 확인 |
| V05 | 표시 `run--9223371984979622399/day-4`에 대한 QUERY T6400 accepted. 기존 P05 인계 문맥 → 실제 `공고 상세로` → `목록으로` → P01 목록 도달·캡처, T6701 정지 후 Alt+F4 정상 종료 |

QUERY는 공고 데이터를 정상 조회했으나 `stage1_view._open_tenders`가 기존 `TenderView.page`를 보존해 즉시 P01로 초기화하지 않았다. 추가 정상 탐색2단계를 수행한 사실을 숨기지 않으며 **조회 단일 클릭으로 P01에 직행했다고 하지 않는다**. 제품 수정은 없고 이 경로의 Design 판단은 PENDING이다. 반환 B01은 AWARDED, B02는 CLOSED이며 둘 다 응찰 불가다. 다음 조회 성공을 새 회차 공급/두 번째 수주로 확대하지 않는다.

### 6.3 입력6묶음 공급 상태와 남은 심사

| 입력 | 이번 로컬 공급 | 남은 항목 |
| --- | --- | --- |
| 입력-1 | 티켓 §1.1 Owner 승인·AGT-DEV-0004·8경로·DEV 자체 실행 분류 | 별도 독립 실행 주체/유효 권한·결과 |
| 입력-2 | 기준 SHA·제품 동일성·run 시작 전 source/launcher 사본·해시, 미커밋 파일 별도 식별 | 후속 독립 run의 실행본 고정 |
| 입력-3 | 정상 초기값·분리 프로필·엔진/renderer·창/viewport·정상 종료/오류0 | 독립 실행 환경 기록; 물리 DPI는 별도 잔여 |
| 입력-4 | §6.2 실제 시각·ID·완주·P05→P01 추가 탐색·화면24개 | 해당 실제 경로의 독립 관측/Design 심사 |
| 입력-5 | 자동3291·관측 오류 감지·로드·자체 GUI·실패 이력·미실행 분류 | 독립 실행/Design 수용, 승인 후 제출 CI |
| 입력-6 | 입력70·조작 기록36·상태971·원장14142·trace44387·원본 해시와 증거 감사 | 실제 원본 전달/수신 및 독립 실행·심사 기록 |

원본 `events.jsonl`, `operator-actions.json`, `operator-concordance.json`, `gui-audit*.json`, `console.log`, `launch.json`, `result.json`, `source-manifest.json`, `source/`, 캡처는 `.local/g24/DEV024-GUI-20261115T035321/`에 있다. 입력·조작 시각 대응은70개 모두 확인했지만 물리 입력 주체를 인증하는 장치는 아니다. GUI 원본 감사23245개/실패0은 자동 게임 단언3291개와 별도다.

관측기 초기 실패와 입력 주체 미확인 환경 probe는 [결과서 §8](../tasks/DEV-024_RESULT.md)에 분리했다. 이번 공급은 **DEV 자체 검증·로컬 독립 인계 자료**이며 독립 실행/Design 새 심사 NOT_RUN, #80/#81 게시 NOT_RUN이다. 충분한 별도 독립 증거가 공급되면 Design이 한 번 심사하고 기존24조건은 실제 영향이 없는 한 재개방하지 않는다.
