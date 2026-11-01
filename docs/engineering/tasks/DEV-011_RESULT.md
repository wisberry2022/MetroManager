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
