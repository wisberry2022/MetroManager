# DEV-011 — W02 권위 시각·명령·자금 원장·마감 실행 티켓

- Development Project Leader / LAPTOP / 2026-11-01 / **REVIEW · IMPLEMENTED / MODEL_VERIFIED**.
- 기준 main: `604751d79bba86cad179ca6434a5ec5b42640d71`. Owner가 병합한 [W01 PR #47](https://github.com/wisberry2022/MetroManager/pull/47)의 tree는 검증된 W01 제출 tree와 동일하다.
- 브랜치: `codex/DEV-011-w02-clock-ledger-recovery`, 독립 worktree에서 이번 승인 범위 구현/검증.
- 실행 승인 요청: [Issue #48](https://github.com/wisberry2022/MetroManager/issues/48). 병행 후보: [DEV-012/W03 #49](https://github.com/wisberry2022/MetroManager/issues/49), 별도 승인·브랜치·PR 대상.
- 상위: [#25](https://github.com/wisberry2022/MetroManager/issues/25), [W01 #44](https://github.com/wisberry2022/MetroManager/issues/44), [W01 인계](DEV-010_RESULT.md).
- 기준: [PM-011 승인 Stage 1](../../hq/PM-011_GATE3_2_APPROVED_PLAN.md)·[개발 요청](../../hq/requests/PM-011_DEVELOPMENT_KICKOFF.md)·[실행 절차](../../hq/PM-011_GATE3_2_EXECUTION_PROTOCOL.md), [C v0.6](../../planning/PLN-001-C.md), [D v0.9](../../planning/PLN-001-D.md), [DATA v1.3](../../planning/PLN-001_GATE2_DATA_v1_DRAFT.md), [SEM/CLOSE 최종 승인](../../planning/PLN-001_GATE2_FINAL_APPROVAL.md), [UI 계약 v0.2.1](../gate3/DEV-006_UI_DATA_CONTRACT.md).

## 1. 목표·구현 단위·제외

| 단위 | 포함할 결과 | 연결 기준 |
| --- | --- | --- |
| W02-A | W01 초기 시각에서 정수 게임분/부분분 보존, 하루 현실600초·정지/재개·1/2/4배속, command_id/requested_at/effective_at·중복 결과 보존, 고정 분 사건 순서 | F-TIME-001, S1-06/07의 모델 부분, AC-06/08 기반 |
| W02-B | C/Rᵢ/F/Kᵢ/A/B·발생비/실제 지급 분리, 사업별 보호·B 우선상환, 자정 마감의 독립 고정 기록, 같은 revision의 읽기 상태·사유/효력 당시 결과 | F-COMP/FIN-001, S1-05/06·S1-09 부분, AC-08/09/10 기반 |

분 T 순서: 이전 구간 비용/공정 → 자정 보고 고정/새날 → 계약/정부지급 → 기성/완공 → 시험/개통 → 도착운임 → B 정산 → 신규탑승 조건 판정. 제품의 입찰·시공·운행 처리기는 아직 없으므로 **테스트 전용 입력/사건**으로 원장/순서 경계를 검증한다. 임의 지급/승차 버튼이나 실제 제품 기능으로 노출하지 않는다. B>0만으로 계약을 차단하거나 A=max(0,F−ΣK)를 재정의하지 않는다.

제외: W03 노선/예측, W04~06의 실제 사업/시공/운행·OD, 메인 씬/시간 UI·P07/지도 통합, 저장/복원·대출/지원/직접 취소/정산 토글·연체 제재, 범용 이벤트 프레임워크, 아트·정책/CI·타 부서 수정. 이 티켓의 자동 시간 검증은 실제 GUI 배속 조작 검증을 대체하지 않는다.

## 2. Owner에게 요청할 변경 경로

| 실제 경로 | 용도 |
| --- | --- |
| `scripts/simulation/game_clock.gd` | 시간/배속·부분분 누적 |
| `scripts/simulation/command_queue.gd` | 식별/효력시각·중복/낡은 입력 처리 |
| `scripts/simulation/minute_pipeline.gd` | 승인된 분 사건 단계 실행·현재 읽기 상태 출처 |
| `scripts/model/company_ledger.gd` | 보호 자금·비용/지급·예약/정산의 승인 경제 효과 |
| `scripts/model/daily_ledger_report.gd` | 일자별 마감·발생비/현금흐름/보고 불변 |
| `tests/game/run_w02_tests.gd` | W02 자동/회귀·정상/부정 fixture·실패 종료 |
| 위 신규 `.gd` 각각의 `.gd.uid` | 실제 생성될 때 함께 추적 |
| `docs/engineering/tasks/DEV-011_W02_CLOCK_LEDGER.md`, `DEV-011_RESULT.md` | 승인 원문·검수 결과 |
| `docs/engineering/collaboration/WORK_STATUS.md` | 자기 작업 인계 상태 |

W01 로더/초기 상태·데이터/메인/프로젝트 설정과 DEV-012 소스는 **읽기 전용**. 범위/경로 확대 필요 시 먼저 변경 영향을 보고한다. 세부 클래스/API는 DEV가 위 단위 안에서 결정한다.

## 3. 필수 수용 증거

| ID | 초기/입력 → 기대·실패 경계 |
| --- | --- |
| W02-AC01 | W01 1일06:00에서 현실600초·1배 → 2일06:00. 현실5초는 1/2/4배 각각12/24/48게임분, 정지 중0. 같은 입력 시간 총량을 일괄/부분분 분할해 시각/사건/잔액·마감 동일 |
| W02-AC02 | C100/R0/K0 → 정부80·총공사110 예약: C180/R80/F100/K30/A70. 기성90 → C90/R0/F90/K20/A70, 기성20 → C70/R0/F70/K0/A70. 두 사업 격리 기대값은 DATA §6 대조 |
| W02-AC03 | C50/K48·비용3 → C48/K48/B1, 발생비3/지급2. 운임11 → C58/K48/B0/A10, 비용 재인식0. C20/R20·비용3이면 지급0/B3. R/K를 B 지급이나 타 사업에 전용하지 않음 |
| W02-AC04 | FX-R01-A: 계약 단계 C79000·자기약정80000 → 부족1000 거부/거래0. 같은 T 후순위 운임1000 후 현재80000이어도 이전 거부를 소급 변경·자동 재시도하지 않음 |
| W02-AC05 | FX-R02-A/B: C20/R20/B500·도착운임800 → C320/R20/F300/B0. 영업 중 다음 구간비100 등 조건 유효 시 같은 T 탑승허용, 00:09는 B0이어도 제한. 실제 탑승 대신 검증용 상태/입력 사용 |
| W02-AC06 | 23:59 탑승8·10분 후 완료8/운임800은 익일00:09 귀속. 잔여도착만 추가비0, B500 상환/자유금 순증300, 전일보고 불변. 재조회/중복·일괄/분할·배속으로 거래/마감/난수 복제 없음 |
| W02-AC07 | 같은 command_id는 같은 기존 결과, 변경된 대상 의미는 거부/재확인 사유. 봉투 revision만 바뀌었다고 일괄 거부하지 않음. 정지 시 시각 의존 효력 동결·재개 시 승인 업무시간/단계 준수. 실패는 부분 원장 변경 없음 |

검증 명령(승인 후 실행 예정): `.venv/Scripts/python.exe tools/policy.py doctor`/`check`, 정책 도구37테스트, 기존 `run_w01_tests.gd`, 새 `run_w02_tests.gd`를 Godot4.7.2의 `--headless --path . --script res://tests/game/<파일>`로 각각 실행. 새 러너 `-- --verify-failure-exit`는 예상 종료1, 정상은0. `--headless --editor --path . --quit` 별도 로드, 기존 W01 GUI 진입은 필요 회귀로 구분한다. 초기/기대/실제·규칙/코드/엔진·명령/효력/사건/원장·보고 diff와 실제 종료코드를 결과에 남긴다. 커밋 후 fetch·preflight, 실제 PR head의 두 CI 확인.

## 4. 의존성·L3 위험과 통합 시점

- W01 선행 충족: load_data/validate_data의 ok/data/errors, from_data의 독립 초기 상태, 버전/안정 ID·실패 종료/러너를 재사용한다. W01 재설계 없음.
- **L3 공통 시간/원장 영향 추적**: 계약·시공·운행/보고·두 VP가 소비할 공통 기반이다. 승인 SEM/CLOSE 그대로 구현하는 것은 새 정책 선택이 아니다. 실제 정책/순서/범위 변경이나 중대한 충돌이 필요하면 해당 변경을 멈추고 HQ/Owner에 RFC·대안·회귀 영향을 제출한다.
- 실패하면 W02 수용·의존 UI/사업 통합만 차단. 별도 W03 계산은 계속 검증 가능하다. 이후 소비자가 생기면 관련 두 경로/보고 회귀를 확장하며 현재 미구현 기능의 회귀 PASS를 주장하지 않는다.
- Design에는 실제 최소 UI 연결 **전** simulation_minute/day_id·snapshot_revision/observation_phase·현재 장부/고정보고·reason/allowed_actions·당시 명령 결과와 fixture를 공급한다. UI 표현/실제 시간 조작은 별도 승인된 최소 UI 통합에서 수행한다. 기존 정적 의미 계약 변경이 있는 행만 L2 확인한다.

## 5. 개별 승인 요청·현재 검증

Owner에게 요청: `wisberry2022/MetroManager` / DEV-011 / 위 브랜치·§1~3/§2 경로의 **구현·검증, Commit, 작업 브랜치 Push 또는 규정 API 공유, base=main PR 생성·필수 CI/동일 범위 검수 수정**을 각각 승인. 유효기간은 명시 승인 시점부터 이번 티켓 PR/검수 대응까지이며 DEV-012·후속 UI로 승계하지 않는다. main 직접 쓰기/Merge·강제 push·정책/CI 우회·릴리스/배포·명세/타 부서 수정 금지. 승인 후 실제 착수/제출 시 최신 main 재확인, 공유 이력 재작성/Update branch(Merge) 금지.

현재 Owner 채팅의 개별 실행/Git 승인 원문: “개발 에이전트. Issue #48의 DEV-011 W02와 Issue #49의 DEV-012 W03 구현 및 각 브랜치의 Commit·Push·PR 생성을 승인합니다. 각 티켓 범위에 한해서 작업하고 검증 후 PR 생성해주세요. main 병합은 별도 승인하겠습니다.”

승인자는 Owner, 저장소·작업·브랜치·경로·허용 동작·유효기간/금지는 위 요청 범위 그대로다. 이전 DEV-010 권한을 재사용하지 않았다. 구현·검증·Commit/Push/PR 허용, main Merge/릴리스는 제외한다. 실제 결과는 [DEV-011 결과](DEV-011_RESULT.md)를 따른다. 현재는 검수 요청 REVIEW이며 Owner ACCEPTED/DONE·전체 Stage 완료가 아니다.

- 제출 기준 갱신: 구현 중 Design PR #50의 문서2개만 main 5c91d56c78c2de5bd94bea7ee66b5c86181f4cb8에 추가됐다. 미공유 작업을 최신 main 위로 재배치하고 승인된 자기 변경만 제출한다. 게임 규칙/코드·W01 원본·고정 DATA 출처604751d는 변경하지 않는다. 실제 preflight base/head는 PR에 기록한다.

## PR #52 대체 재제출 승인·이력 복구

- Owner 현재 채팅: “이전 에이전트의 PR을 승인하여 main에 반영한 뒤 ... update branch를 실행한 뒤 해당 에러가 발생했습니다. 두 PR 모두 동일한 에러가 발생했으니 수정하여 PR 재생성바랍니다”.
- 원격 실패 head `42a82c2340a52b0ca8baa863796a46b214c21c1e`는 부모2개인 main 병합 커밋이다. 실제 department-policy 로그의 `Expected single-parent work commit`와 부모 목록을 확인했다. 기능 코드 오류나 보호/CI 완화가 필요한 사안이 아니다.
- 이번 명시 재생성 요청에 따라 승인된 DEV-011 변경만 최신 main `88496d0c3bcef8d59e76c9977ee6ff07d01339fe`의 새 브랜치 `codex/DEV-011-w02-clock-ledger-recovery`에 옮긴다. 원래 공유 브랜치/실패 이력은 보존하고 force push·Update branch·main Merge·정책/CI 변경은 하지 않는다. 신규 게임 기능/규칙 변경 없음.
- 허용 범위: 기존 티켓의 코드/데이터/테스트·문서 경로 그대로, 이력 복구/검증·Commit·작업 브랜치 공유·대체 PR/CI·기존 PR 대체 관계 기록 및 미병합 종료까지 이번 재제출에 한정한다. 후속 재검토는 같은 승인 범위 안에서 수행한다.

## Issue #48 자정 복합 경계 회귀 보완 — 2026-11-01

- 근거: [Planning 보완 요청](https://github.com/wisberry2022/MetroManager/issues/48#issuecomment-6557554353), [DEV 정적 확인](https://github.com/wisberry2022/MetroManager/issues/48#issuecomment-6557654283). 기존 81단언은 자정의 양수 비용·정부 지급·기성을 결합한 실행 증거가 아니었음을 인정한다.
- Owner 현재 채팅 승인 원문: “Issue #48의 자정 복합 경계 회귀 테스트 보완과 Commit·Push·PR 생성을 승인합니다. 기존 승인 규칙과 시간 외 계약 이연을 유지하며 해당 범위만 작업하고, 검증 후 PR 생성해주세요. main 병합은 별도 승인하겠습니다.”
- 저장소 `wisberry2022/MetroManager` / 작업 DEV-011 / 기준 main `87342cd5c29a3047695c11bfd7f2b76415cdf4d8` / 브랜치 `codex/DEV-011-w02-midnight-regression-submit` / 독립 worktree. 유효 범위는 이번 회귀 보완과 동일 범위 PR 검수 대응까지다.
- 허용: 아래 5파일의 테스트 보완·검증·Commit·해당 작업 브랜치 일반 Push 또는 규정 API 공유·base=main PR·CI 확인/결과 인계. main 병합·릴리스/배포·강제 push·정책/CI·타 부서·게임 규칙 변경은 제외한다. 기존 승인만 재사용한 것이 아니라 이번 명시 추가 승인을 근거로 한다.

| 변경 경로 | 이번 변경 |
| --- | --- |
| `tests/game/run_w02_tests.gd` | 기존 러너에 자정 복합·일괄/분할/배속·중복/조회/마감 회귀 추가 |
| `tests/game/w02_midnight_fixture.gd`, `.gd.uid` | 테스트 전용 Pipeline 단계 사건 공급·실제 생성 UID |
| 본 DEV-011 티켓, `docs/engineering/tasks/DEV-011_RESULT.md` | 승인·범위·검증/기대/실제·잔여 기록 |

제품 `scripts/`·씬·데이터·프로젝트 설정·CommandQueue는 읽기 전용으로 보존한다. 테스트 전용 Pipeline은 기존 `_stage`를 super로 호출한 뒤 T=1440 CONTRACT 단계에만 이미 확정된 내부 지급 사건을 공급하고, 기성60은 기존 set_fixture 입력으로 처리한다. 플레이어 신규 계약은 원래 큐를 통과하며 자정 요청의 효력1800 이연을 같은 실행에서 별도 확인한다. 테스트 사건을 GUI에 노출하거나 실제 W04~06 기능으로 취급하지 않는다.

검수: C100/R=K=B=0·T=1439 → 이전 구간 비용3/지급3·마감 C97 → 새 날짜 정부80·같은 사업 기성60 → C117/R20/F97/K0/A97/B0. 전일/당일 보고·원장 effective_at·마감1회·이후 고정보고 불변, 1/2/4배속×일괄/부분분 분할 6조합의 전체 원장/상태 일치, 중복 입력·재조회·정지/재개·지속 진행의 양수 거래 중복 방지를 검증한다. 상세 실제 결과는 결과 문서 및 제출 SHA의 PR 기록을 따른다.

이번 보완은 기존 승인 의미의 회귀 증거 추가이며 L3 정책 변경은 없다. 결과는 REVIEW이고 Planning의 해당 증거 확인·HQ/Owner S1-05/06 부분 인수와 main 병합은 별도다. W03·Design 독립 준비를 차단하지 않는다.

- 제출 기준 갱신: 작업 중 DEV-014/PR #60이 main 804fc58f81f81638e8ca4f16ab0e77029be02683에 병합됐다. 미공유 5파일을 그대로 새 제출 브랜치로 옮겼다. 게임 소스·기존 게임 테스트·프로젝트 설정은 두 base 사이 동일하므로 실제 엔진 결과는 같은 blob의 검증이며, 변경된 정책 도구는 최신 base에서 전체 회귀를 다시 실행한다. 실제 제출 SHA와 최신 정책 결과는 PR에 기록한다.
