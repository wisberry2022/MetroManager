# DEV-011 — W02 시간·명령·원장·마감 구현 결과

- Development / LAPTOP / 2026-11-01 / **REVIEW · IMPLEMENTED / MODEL_VERIFIED**.
- [실행/Git 승인 티켓](DEV-011_W02_CLOCK_LEDGER.md), [Issue #48](https://github.com/wisberry2022/MetroManager/issues/48), 기준 main `604751d79bba86cad179ca6434a5ec5b42640d71`.
- 브랜치 `codex/DEV-011-w02-clock-ledger`, 현재 Owner가 개별 구현·Commit/Push/PR을 승인. main 병합·GUI/후속 기능·타 부서/정책 변경은 제외. 실제 제출 SHA/원격 CI는 PR 본문/댓글을 따른다.

## 구현과 변경 파일

- `scripts/simulation/game_clock.gd`: 현실 마이크로초×12/5000000의 정수 누적, 정지·1/2/4배속·부분분 보존.
- `scripts/simulation/command_queue.gd`: 접수/효력·06~24 업무시간·중복 pending/최종결과·닫힌 분/부정 payload 거부. 봉투 revision만으로 무조건 거부하지 않음.
- `scripts/simulation/minute_pipeline.gd`: 승인 분 단계·자정 마감·대상 의미 revision 재검사·현재 snapshot/당시 결과 분리. 미구현 사업/운행은 **테스트 전용 fixture**로만 공급.
- `scripts/model/company_ledger.gd`: C/R/F/K/A/B, 사업별 정부 제한/자기 예약·기성 지출, 발생비/지급·B 우선상환, 부정/과거 거래 거부. 실패 계약/지출은 자금·원장 불변.
- `scripts/model/daily_ledger_report.gd`: 발생/현금 귀속 일자와 마감 보고의 복사/불변.
- `tests/game/run_w02_tests.gd` 및 신규6개 `.gd`의 실제 생성 `.gd.uid`.
- 본 결과·DEV-011 티켓·`collaboration/WORK_STATUS.md`의 자기 행. 총15파일, W01/DEV-012/프로젝트 설정·씬·기획/디자인/CI·도구는 변경하지 않음.

## 실제 검증과 증거

엔진은 기존 Godot `4.7.2.stable.official.ed1daf0bf`, worktree에서 프로젝트 루트 상위 Godot 콘솔 실행 파일의 절대/상대 경로로 실행했다.

| 종류 | 실제 결과 |
| --- | --- |
| 신규 규칙/회귀 | `--headless --path . --script res://tests/game/run_w02_tests.gd` → **W02_TEST_RESULT checks=81 failures=0**, 종료0 |
| 실패 검출 | 같은 러너 뒤 `-- --verify-failure-exit` → intentional_failure, checks1/failures1·종료1(예상) |
| 기존 게임 회귀 | `run_w01_tests.gd` → **219단언 PASS**, 종료0 |
| 엔진 로드 | `--headless --editor --path . --quit` → 클래스/리소스 초기화·종료0 |
| 기존 메인 headless 진입 | `--headless --path . --quit-after 3` → W01_INIT_OK/승인 초기값, 종료0 |
| 도구/정책 | 독립 `.venv`에 requirements-dev 고정 설치 후 doctor·gdformat/gdlint·policy check PASS. 검사기/설정 변경 없음 |
| 정책 도구 회귀 | `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v` → **37테스트 OK**. bad_script.gd 거부는 예상 부정 입력 출력 |

81단언은 600초/하루·부분분/일괄/분할·배속·정지/재개, 승인 자금 기대값/두 사업 격리/부분지급/B·예약 보호, FX-R01-A/FX-R02-A/B, 00:09 귀속/전일보고 불변, 중복/낡은 의미/봉투revision·업무시간·부정/과거 거래의 원자성을 검증한다. 첫 스타일 검사에서 과다 return을 입력 검증 함수로 분리했고 이후 스타일/엔진 검사를 통과했다. 테스트 입력은 실제 제품 계약/승객/시공 기능이 아니다.

정상 예: C79000 계약 당시 자기약정80000은 부족1000으로 거부, 후순위 운임1000 뒤 현재80000이 되어도 과거 거부 불변. C20/R20/B500·도착운임800은 C320/R20/F300/B0, 영업·비용 조건이면 같은 T 탑승 판정, 00:09는 제한. 자정 이전 보고는 이후 도착/조회로 변하지 않는다.

## 공급·잔여·인수 경계

- 공급: GameClock의 게임분/일자/부분분·속도/정지, CommandQueue의 접수/효력/최종 결과, MinutePipeline의 DATA1.3·simulation_minute/day_id·snapshot_revision/T_COMPLETE·자금/탑승사유·사건순서, 독립 마감 보고. 반환값은 내부 상태의 복사다.
- 실제 최소 UI에 연결하기 전 Design과 영향 상태/fixture를 대조해야 한다. 현재 GUI 시간 조작·P07·지도/목록 연결은 **NOT_RUN**. 기존 W01 화면은 정적 초기값이며 이번 모듈을 구동하는 UI로 변경하지 않았다.
- W03/실제 계약·시공·운행·전체 Stage/AC·독립 VP E2E·Windows export/성능·사용성은 각각 **NOT_RUN / 범위 제외**. L3 공통 시간/원장 영향은 유지하며 후속 소비자가 생길 때 양 경로/보고 회귀를 확장한다.
- 검증 범위의 잔여 결함·신규 명세 변경/RFC 없음. Owner 결과 수용/DONE·main Merge는 별도다. PR 제출 전 경로/문서/원문 보존·단일 부모/preflight, 실제 원격 두 CI를 확인하고 그 증거를 PR에 연결한다.

- 제출 기준 갱신: 구현 중 Design PR #50의 문서2개만 main 5c91d56c78c2de5bd94bea7ee66b5c86181f4cb8에 추가됐다. 미공유 작업을 최신 main 위로 재배치하고 승인된 자기 변경만 제출한다. 게임 규칙/코드·W01 원본·고정 DATA 출처604751d는 변경하지 않는다. 실제 preflight base/head는 PR에 기록한다.

## PR #52 이력 복구·대체 PR 검증

- 최신 제출 base `88496d0c3bcef8d59e76c9977ee6ff07d01339fe`, 브랜치 `codex/DEV-011-w02-clock-ledger-recovery`. Design PR #54의 문서2개를 보존한다.
- 실패 원인: 원격 Update branch의 부모2개 커밋 `42a82c2340a52b0ca8baa863796a46b214c21c1e`를 단일 부모 검사가 거부했다. 원래 승인 개발 커밋만 최신 main으로 옮겼으며 게임 소스/데이터/테스트/UID 내용은 원래 검증 제출과 동일하다. 복구 문서만 추가했다.
- 이번 재검증은 doctor/check·원본 코드 blob 보존·기존 W01/해당 모델 자동검사·실패 종료·엔진 headless 로드·단일 부모/경로/preflight 및 새 PR의 실제 두 CI로 구분해 PR 본문에 기록한다. 과거 성공 CI나 실패 run 재실행을 새 head PASS로 재사용하지 않는다.
- GUI·실제 UI 통합·빌드/성능·사용성/전체 AC/VP는 이번에도 NOT_RUN. 현재 재제출은 이력 복구이며 새 게임 기능 구현이 아니다. 기존 PR은 대체본 준비 후 미병합 종료, 원격/로컬 기존 브랜치와 실패 기록은 보존한다.

## Issue #48 자정 복합 경계 회귀 보완

- 기준 main `87342cd5c29a3047695c11bfd7f2b76415cdf4d8`, 브랜치 `codex/DEV-011-w02-midnight-regression-submit`, 담당 Development Project Leader / LAPTOP / 2026-11-01 / **REVIEW / REGRESSION_VERIFIED**. 이번 Owner의 테스트 보완·Commit/Push/PR 추가 승인과 5파일 경로는 [티켓의 후속 승인](DEV-011_W02_CLOCK_LEDGER.md#issue-48-자정-복합-경계-회귀-보완--2026-11-01)에 기록한다.
- [기획 요청](https://github.com/wisberry2022/MetroManager/issues/48#issuecomment-6557554353)의 공백은 이전 81단언으로 해소되지 않았다. 이번에 테스트 전용 fixture/UID와 기존 W02 러너, 본 결과/티켓의 5파일만 보완한다. 제품 소스·큐·씬·설정·승인 데이터·정책/CI·타 부서 문서는 변경하지 않는다.

### 실제 실행 경계와 한계

`w02_midnight_fixture.gd`는 제품 MinutePipeline을 상속하며 기존 `_tick/advance_usec`를 실행한다. `_stage`는 super 호출을 유지하고 **T=1440 CONTRACT에만** 내부 확정 지급의 `ledger.contract("MIDNIGHT",80,80,1440)`을 공급한다. 지급 직전 전일 마감 보고/자금 사본을 관측하고, 실제 DailyLedgerReport.close를 super로 호출하는 관측용 하위 클래스로 호출 수를 센다. 기성60과 이전 구간 비용3은 기존 `set_fixture(1440, ...)`를 통과한다. 단계 순서·마감·보고/원장 계산을 테스트가 재구현하지 않는다.

이 공급은 **이미 확정된 테스트 내부 사건**이다. 실제 정부 지급 스케줄러·제품 계약/시공 기능을 구현하거나 검증했다고 주장하지 않는다. 같은 실행의 별도 PLAYER 명령은 수정하지 않은 CommandQueue.submit을 통과하고 effective_at=1800이며 T=1440에는 due가 없고 결과는 여전히 pending이다. 내부 지급 주입을 플레이어 시간 외 계약 허용의 증거로 사용하지 않는다.

### 초기·기대·실제 원장/보고

초기 게임분1439 / C100/R=K=B=0 / 정부80·총액80으로 자기 예약0인 테스트 사건. 새날 시작은1440이고 관측 종료1441이다.

| 경계 | 기대값 | 실제값 |
| --- | --- | --- |
| 전일 구간 비용/지급 | operating_cost=3, payment=3, effective_at=1439 | 일치 |
| 전일 마감·지급 직전 | day_id=1, closing C97/R0/F97/K0/A97/B0 | 일치, 지급 전에 고정 보고 존재 |
| 새 날짜 지급 | government=80, effective_at=1440 | 일치, 양수 행1개 |
| 같은 사업 기성 | construction_cost=60, construction_payment=60, effective_at=1440 | 일치, 각 양수 행1개 |
| 최종 현재 자금 | C117/R20/F97/K0/A97/B0, 해당 사업 R20/K0 | 일치 |
| 전일 보고 | 비용3/지급3, 정부·기성·운임0, closing cash97 | 전체 dictionary 일치 |
| 새 날짜 진행 보고 | day_id=2, 정부80/기성비60/기성지급60, 운영비·운영비지급·B지급·운임0 | 전체 dictionary 일치, 고정 report(2)는 아직 없음 |
| 자정 마감/내부 지급 | 전일 close 호출1회, 지급 dispatch1회 | 일치, 후속 진행에도 동일 |

기존 원장은 금액0인 fare 행도 남기므로 전체 원장을 5행이라고 주장하지 않는다. **양수 거래5행**의 종류/금액/시각과 전체 원장·전체 Pipeline 상태/trace는 별도로 검증한다. 현재 돈으로 고정 보고를 덮지 않고 반환 사본을 수정해도 내부 보고가 바뀌지 않음을 확인했다.

기준 현실 입력은 1,000,000μs/1배이며 2/4배는 같은 게임시간 총량이 되도록 입력을 나눈다. 분할 입력 `[4,996,50000,199000,750000]μs`도 각 배속으로 나눠 제공해 부분분/나머지를 보존한다. **1/2/4배속×일괄/분할 6조합** 모두 속도 필드만 제외한 clock·전체 원장/분 단계 trace·현재 snapshot·전일/당일 보고·마감/지급 횟수가 동일했다. 정지 중 무진행, 재개, 중복 fixture 거부·이미 처리된 시각 거부, 동일 명령 재접수, 중복 사업 지급 거부, 재조회/0시간/후속 시간 진행에서 양수 거래·과거 보고의 불변을 확인했다.

### 검증 명령과 증거

- 엔진: Godot `4.7.2.stable.official.ed1daf0bf`, 프로젝트 상위 godot 폴더의 콘솔 실행 파일. worktree에서는 `../../../../godot/Godot_v4.7.2-stable_win64_console.exe`.
- `--headless --path . --script res://tests/game/run_w02_tests.gd`: **W02_TEST_RESULT checks=309 failures=0 / 종료0**. 기존81+복합 회귀228단언. `W02_MIDNIGHT_EVIDENCE` 한 줄 JSON에 전체 실제 clock/원장/현재 snapshot/전일·당일 보고/trace/횟수를 출력한다.
- 첫 실행의 분할 입력 배열 타입 오류를 수정한 뒤 전체를 다시 실행했다. 최종 판정은 종료코드와 `SCRIPT ERROR/ERROR:` 없음, 기대 TEST_RESULT를 함께 확인한 결과다. 최초 실행의 부분 단언/종료0를 PASS로 사용하지 않았다.
- 같은 러너 `-- --verify-failure-exit`: 의도적1실패/예상 종료1. W01 `run_w01_tests.gd` **219단언**, W03 `run_w03_tests.gd` **101단언**, 각각 failures0/종료0.
- `--headless --editor --path . --quit`: 프로젝트 로드 종료0, 스크립트/엔진 오류 없음. `--headless --path . --quit-after 3`: 기존 메인 종료0/W01_INIT_OK, 오류 없음. 실제 GUI 조작과 구분한다.
- `.venv/Scripts/python.exe tools/policy.py doctor` / `check`: PASS(files206/GDScript16), 고정 gdtoolkit 스타일 PASS. `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v`: **49테스트 OK(153.595초)**, 예상 부정 입력 bad_script.gd의 파싱 거부는 전체 실패와 구분한다. UTF-8/LF·공백·승인5파일·제품 경로 불변을 검토했다. 커밋 후 fetch/preflight·필수 두 CI/검증 head와 tree는 제출 PR에 연결한다.
- 원시 로컬 실행 로그는 무시 경로 `.local/verification/`에 보관하며 재현 가능한 기대/실제와 명령은 위 본문·테스트/PR에 남긴다. 공개 저장소에 생성 캐시/환경/로그를 추가하지 않는다.

**미해결/인수:** 검증한 복합 경계에서 기대·실제 차이 없음. Planning 재검토 및 Owner 부분 인수는 PENDING이다. 게임 규칙/명세 변경 필요 없음. GUI/실제 UI 통합·플레이·Windows 빌드·성능·외부 사용성·전체 Stage/AC/VP는 각각 **NOT_RUN**. 이번 모델 회귀로 해당 GUI나 Stage를 ACCEPTED/DONE 처리하지 않는다. main 병합은 Owner 별도다.

- 제출 기준 갱신: 작업 중 DEV-014/PR #60이 main 804fc58f81f81638e8ca4f16ab0e77029be02683에 병합됐다. 미공유 5파일을 그대로 새 제출 브랜치로 옮겼다. 게임 소스·기존 게임 테스트·프로젝트 설정은 두 base 사이 동일하므로 실제 엔진 결과는 같은 blob의 검증이며, 변경된 정책 도구는 최신 base에서 전체 회귀를 다시 실행한다. 실제 제출 SHA와 최신 정책 결과는 PR에 기록한다.

- 최신 제출 base 804fc58에서 doctor/check PASS(files210/GDScript16), 정책 도구 전체 **57테스트 OK(192.528초)**. 위 49테스트는 이전 base의 실행 이력이며 최종 제출은 새 정책을 포함한 57테스트 결과를 사용한다.
