# DEV-010 — W01 구현·검증 결과

- Development Project Leader / LAPTOP / 2026-11-01 / **REVIEW**.
- 품질: W01 IMPLEMENTED / 아래 범위 VERIFIED. Owner ACCEPTED·DONE 및 Stage 1 전체 완료 아님.
- [티켓·Owner 실행/Git 승인](DEV-010_W01_EXECUTION_FOUNDATION.md), [Issue #44](https://github.com/wisberry2022/MetroManager/issues/44).
- base main: `1356c4b2ec824ca51e807bd9754a891aaa57e13d`, 브랜치 `codex/DEV-010-w01-execution-foundation`.
- Commit/작업 브랜치 공유/PR은 현재 Owner가 승인한 W01 티켓 범위에 한정한다. 실제 제출 head·원격 tree/CI·preflight 결과는 PR 본문/후속 댓글에서 확인한다. main 병합 미수행.

## 1. 구현 결과와 변경 파일

Godot 메인 씬에서 승인 입력을 검증한 뒤 초기 회사 상태를 생성·표시한다. 오류는 사유 코드와 종료1로 드러나며 검증에 실패한 입력의 부분 데이터/회사 상태를 반환하지 않는다. 로더는 캐시나 전역 상태를 변경하지 않고, 호출별 데이터·초기 상태를 분리한다. JSON의 정수값은 정수 여부를 검사하고 경제·시각의 초기 상태는 Godot int로 생성한다.

| 변경 파일 | 내용 |
| --- | --- |
| `project.godot` | run/main_scene 한 줄 추가. 기존 엔진/렌더러/배율/이름 보존 |
| `scenes/main.tscn` | 최소 초기화 상태 관찰 씬. 메뉴·상세 HUD/아트 없음 |
| `scripts/main.gd` | 정상 초기값·오류 사유 표시, W01_INIT_OK/FAILED 로그·실패 종료1 |
| `scripts/data/gate2_data_loader.gd` | 파일/JSON·버전/출처·행정ID/부모·역 소속/좌표·17 양방향 간선·초기값 검증 |
| `scripts/model/initial_company_state.gd` | 승인 입력 재검증 후 초기 회사·게임 시각의 독립 읽기 값 생성 |
| `assets/data/gate2_w01_v1_3.json` | DATA §2~3의 W01 입력·기준 문서/커밋 출처 |
| `tests/game/run_w01_tests.gd` | 승인 기대값·39 부정 입력 변형·루트/파일/JSON 오류·초기화 독립성·실패 종료 검증 |
| 위 `.gd` 4개의 `.gd.uid` | 실제 Godot 생성 UID 보존 |
| 본 결과·DEV-010 티켓·collaboration/WORK_STATUS.md | 승인·실제 검증/한계·후속 인계 |

총14파일. 승인 경로 밖 변경·새 의존성·도구/CI·타 부서/기획 문서 수정 없음. 데이터의 고정 ID/값 검사는 현재 W01 승인 기준에 한정하며 범용 데이터 편집기나 새 규칙을 만들지 않았다.

## 2. 실제 검증과 증거

아래 엔진 명령은 저장소 루트에서 `../godot/Godot_v4.7.2-stable_win64_console.exe`로 실행했다.

| 종류/기준 | 실제 명령·결과 | 판정 |
| --- | --- | --- |
| 도구 환경 | `.venv/Scripts/python.exe tools/policy.py doctor` | PASS |
| 엔진 버전 | `--headless --version` → `4.7.2.stable.official.ed1daf0bf` | PASS |
| headless 에디터 로드 / W01-AC01 | `--headless --editor --path . --quit`, scan/클래스 등록·편집기 초기화, 종료0 | PASS. 게임 GUI와 별도 |
| W01 실제 자동검사 / AC02~05 | `--headless --path . --script res://tests/game/run_w01_tests.gd` → `W01_TEST_RESULT checks=219 failures=0`, 종료0 | PASS |
| 자동검사 실패 종료 / AC04 | 같은 러너 뒤 `-- --verify-failure-exit` → `FAIL intentional_failure_probe expected=false actual=true`, checks1/failures1·종료1 | PASS(의도적 실패 감지). 정상 기능 실패로 혼동하지 않음 |
| 실제 headless 메인 / AC01~02 | `--headless --path . --quit-after 4` → W01_INIT_OK·아래 초기 상태, 종료0 | PASS |
| 실제 메인 오류 경로 / AC01·04 | 무시 경로 `.godot/w01-failure-fixture`에 원본 코드/씬/설정·데이터를 복사하고 복사본 버전만 invalid-test-only로 변경. 그 경로로 `--headless --quit-after 5` → `W01_INIT_FAILED ["DATA_VERSION_MISMATCH"]`, 종료1 | PASS. 원본 승인 데이터 보존, fixture는 제품/커밋 제외 |
| 실제 Windows GUI / AC01 | `--path .`, D3D12 12_0 / Forward+ / Intel Iris Xe 로그. 제품 DEBUG 창을 computer-use로 관찰해 아래 초기값·한국어 초기화 완료/미구현 범위 표시 확인. 검증 창만 닫아 종료0 | PASS(진입/초기 관찰 한정). 화면 캡처는 현재 채팅 도구 증거이며 저장소 에셋 아님 |
| 스타일·정책 | gdformat/gdlint 및 `tools/policy.py check` → 4 scripts, PASS. 정책 check는 정상 임시 폴더 권한에서 실행 | PASS |
| 기존 정책 도구 회귀 | `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v` → 37 tests OK | PASS. 게임 자동검사219개와 별도 |

정상 메인 로그는 `W01_INIT_OK`와 city_id=C01, data_version=1.3, day_id=1, simulation_minute=360, cash/free_cash/available_cash=1000000, unpaid=0, restricted_by_project/reserved_by_project={}, capability=80, financial_score=100을 기록했다. 화면에도 C1000000/R0/F1000000/K0/A1000000/B0·시작일1/06:00·후보역12를 확인했다. 현재 표시값은 초기값이며 실제 시간 진행/원장 서비스가 아니다.

219개는 검사 단언 수다. 39개 부정 입력에 대해 거부·사유·부분 데이터 없음·부분 상태 없음·원본 불변을 반복 확인하고, 승인 행정14개/역12개/간선17개·초기값·정수 타입/재초기화 독립성·양방향 간선·루트/파일 오류를 별도 검사한다. 전역 난수/경제 사건은 이번 코드에 없다.

첫 자동검사에서는 JSON 좌표의 실수 표현과 정수 기대 배열 비교 및 비문자 부모의 비교 오류를 발견했다. 좌표는 정수 검증 후 비교하고, 로더의 메타/부모/소속/도시 타입을 가드한 뒤 전체219 검사를 재실행해 통과했다. 이후 로그에 SCRIPT ERROR 없음. 기존 도구 테스트의 bad_script.gd 파싱 오류는 부정 입력 거부 테스트의 예상 출력이며 전체37테스트 OK다.

정책 check는 개발 소스와 도구 테스트를 검증하지만 Godot 게임 테스트를 CI에 새로 추가하지 않았다. 원격 두 필수 CI와 위 로컬 Godot 실행 증거를 구분한다.

## 3. 미실행·잔여·후속 인계

- **NOT_RUN/범위 제외:** 실제 시간 진행/배속·거래/원장·마감·노선 편집/예측·지도/목록 GUI 조작·입찰/제안/영업·전체 AC/두 VP E2E, Windows export·성능/FPS 합격·외부 사용성. GUI 진입 PASS를 Stage 1 S1-01~09 전체 PASS로 확장하지 않는다.
- 현재 W01 검증 범위의 미해결 결함 없음. 초기 화면은 기본 Godot 설정의 최소 관찰 화면이며 고충실도 UI/제품 폰트·뷰포트 규격 인수가 아니다. 최초 GUI executable 직접 호출 후 창이 사라져 콘솔 실행으로 창·로그를 유지해 실제 검증했으며 기존 렌더러를 변경하지 않았다.
- W02/W03 소비자는 `Gate2DataLoader.load_data()`/`validate_data()`의 ok/data/errors, `InitialCompanyState.from_data()`의 ok/state/errors를 사용한다. 승인 데이터 버전/출처·안정 ID/부모/역/간선을 유지한다. 정상 시 별도 deep copy, 오류 시 data/state 빈 객체를 받는다.
- W02는 시간/명령·R/K/B/자정/SEM/CLOSE 회귀, W03는 노선/OD/예측을 별도 승인 티켓에서 구현한다. W01의 정적 초기 값을 동적 snapshot revision/allowed_actions 공급 완료로 표시하지 않는다. 실제 UI 통합 전에 해당 상태·사유·명령/fixture를 Design에 공급한다.
- 신규 기획 의미 변경·외부 부서 재검토/RFC 필요 없음. W01 결과 검수와 main 병합은 Owner 별도 결정이다. #44/#25는 구현 완료/DONE으로 자동 종료하지 않는다.
