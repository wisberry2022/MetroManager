# DEV-012 — W03 행정·노선 검증·OD 예측 실행 티켓

- Development Project Leader / LAPTOP / 2026-11-01 / **REVIEW · IMPLEMENTED / MODEL_VERIFIED**.
- 기준 main: `604751d79bba86cad179ca6434a5ec5b42640d71`, [W01 PR #47](https://github.com/wisberry2022/MetroManager/pull/47) Owner 병합 확인.
- 브랜치: `codex/DEV-012-w03-route-prediction`, 독립 worktree에서 이번 승인 범위 구현/검증.
- 실행 승인 요청: [Issue #49](https://github.com/wisberry2022/MetroManager/issues/49). 병행 후보: [DEV-011/W02 #48](https://github.com/wisberry2022/MetroManager/issues/48), 별도 승인·브랜치·PR 대상.
- 상위: [#25](https://github.com/wisberry2022/MetroManager/issues/25), [W01 #44](https://github.com/wisberry2022/MetroManager/issues/44), [W01 인계](DEV-010_RESULT.md).
- 기준: [PM-011 승인 Stage 1](../../hq/PM-011_GATE3_2_APPROVED_PLAN.md)·[개발 요청](../../hq/requests/PM-011_DEVELOPMENT_KICKOFF.md), [C v0.6](../../planning/PLN-001-C.md), [D v0.9](../../planning/PLN-001-D.md), [DATA v1.3](../../planning/PLN-001_GATE2_DATA_v1_DRAFT.md) §2/4/6, [최종 승인](../../planning/PLN-001_GATE2_FINAL_APPROVAL.md), [UI 계약 v0.2.1](../gate3/DEV-006_UI_DATA_CONTRACT.md) §1/6/7.

## 1. 목표·구현 단위·제외

| 단위 | 포함할 결과 | 연결 기준 |
| --- | --- | --- |
| W03-A | 승인 행정 부모/역 소속·관할 조회, 후보12·순서가 있는 6~8 고유역 계획·선택/제거/정렬/되돌리기 결과·중복/재방문/단절/관할외 거부·이유 | F-ADM/CITY/PROP-001 일부, AC-01/02/04 부분, S1-03 |
| W03-B | 승인 OD/접근 배분·거리/시간·선택률/공유 용량을 반영한 기간 명시 예측, 계획/입력revision·유효성·없음/0·실패/낡은 결과 분리 | AC-04/08 기반, S1-04 |

DATA §4의 출발수요 2000/1500/1200/800/600/400/300/200·다음 동 목적지, 최소시간 역쌍/ID 동률 배분·중복 수요 금지, 간선1분/중간정차1분, q의5/10분 경계, 06~24·1080분/공유 U10·소수 이월/미탑승 정수 소멸을 예측의 순수 계산에 적용한다. 결과의 대상 기간·예상 요청/탑승/완료와 생성 기준을 구분하고 미래 완료 운임을 현재 원장에 넣지 않는다. 실제 완료일/부분일 보고와 예측을 같은 실적처럼 표시하지 않는다.

제외: 실제 운행·승객/도착 사건·운임 원장/일일 운영 보고·만족 변화(W06), W02 시각/원장 수정, 입찰·심사/제안 제출·계약, 지도/목록/예측 GUI·아트/표시 도형·제품 규격, 개별 시민·저장/복원·범용 비동기 프레임워크·정책/CI·타 부서/기획 수정. 계산 상태 CALCULATING은 의미 표현이며 동기 계산이면 READY/FAILED로 직접 끝낼 수 있다.

## 2. Owner에게 요청할 변경 경로

| 실제 경로 | 용도 |
| --- | --- |
| `scripts/model/administrative_network.gd` | 안정 ID/부모·역 소속·관할/간선 조회 |
| `scripts/model/route_plan.gd` | 계획 편집·revision·유효성/허용행동·오류 |
| `scripts/simulation/demand_predictor.gd` | 승인 OD/거리/시간·기간별 순수 예측 |
| `scripts/model/prediction_state.gd` | 입력/결과revision·처리상태·유효성·생성 시각 |
| `assets/data/gate2_w03_demand_v1_3.json` | W01과 분리된 승인 DATA §4 입력/출처 |
| `tests/game/run_w03_tests.gd` | 순수 계산/편집·정상/실패/경계·재현 검증 |
| 위 신규 `.gd` 각각의 `.gd.uid` | 실제 생성 시 추적 |
| `docs/engineering/tasks/DEV-012_W03_ROUTE_PREDICTION.md`, `DEV-012_RESULT.md` | 승인·실제 결과 |
| `docs/engineering/collaboration/WORK_STATUS.md` | 자기 작업 인계 상태 |

W01 로더/초기 데이터/회사 상태·메인/프로젝트 설정 및 DEV-011 소스는 **읽기 전용**. 외부 관할·광역/특별시 등 부정 입력은 테스트 fixture이며 제품 지역 확장이나 W01의 고정 승인 로더를 완화하는 변경이 아니다. 필요한 최소 네트워크 검증을 이 소관 모듈에서 테스트하며 새 제품 데이터를 창작하지 않는다.

## 3. 필수 수용 증거

| ID | 입력 → 기대·실패 경계 |
| --- | --- |
| W03-AC01 | W01 1도/1시/4구/8동/12역·부모·역 소속/17 간선 조회 일치. 별도 행정 위계/외부관할 fixture·고아/순환·중복/없는 ID 거부. 지도 도형으로 관할 재분류 금지 |
| W03-AC02 | DATA의 P-A/P-B 정상6역과8역 예시 허용, 5/9·중복/재방문·불연결·관할외 거부. 선택/제거/정렬/되돌리기 시 대상ID/순서·revision·오류/가능행동 일관, 실패 입력은 계획/경제/난수 부작용 없음 |
| W03-AC03 | OD 출발/목적 동 모두 접근 가능할 때만 배분. 같은 동 복수역은 최소시간 한 쌍/동률 ID로 배분. 접근/수요 복제 없음, 노선 역순에서 OD 시간 대칭, 단위 km/게임분/통행 명시 |
| W03-AC04 | q(T) 5분=1, 6/10분=0.8, 11분=0.5. 영업기간1080·공유 용량/OD ID 순 배분·소수 이월·미탑승 정수 소멸을 반영. DATA §6의 경계용 U1/10분 요청12 → 탑승10/미탑승2를 기본 U10과 구분. 0수요·0/없음·부분기간/날짜 경계·일괄/분할 동일 검증 |
| W03-AC05 | FX-R04-P: rev7 READY/유효0 → 입력rev8 변경/미계산 또는계산중(이전값은 현재값 아님) → 실패/이유 → rev8 완료. 늦은rev7 응답 덮기 금지, 같은 입력 재조회는 시간/난수/원장 효과0 |
| W03-AC06 | 승인 입력을 수작업 산술한 고정 기대값과 엔진 실제값/차이를 보존. 계획/수요 입력revision·기간·입력/결과 생성 게임시각/단위 추적. 현재 유효 예측만 소비, 이전값은 비교용 별도 출처. 성공/실패 종료코드·W01 회귀 확보 |

검증 명령(승인 후 예정): `.venv/Scripts/python.exe tools/policy.py doctor`/`check`, 정책 도구37테스트, 기존 `run_w01_tests.gd`, 새 `run_w03_tests.gd`를 Godot4.7.2의 `--headless --path . --script res://tests/game/<파일>`로 각각 실행. 새 러너의 `-- --verify-failure-exit` 예상 종료1/정상0, 별도 headless editor 로드와 필요 W01 GUI 회귀. 모델 자동검증과 실제 지도/목록 GUI 조작은 별도 증거다. 커밋 후 fetch/preflight·PR head 두 CI를 기록한다.

## 4. 의존성·소비/통합과 L2

- W01 출력은 main에 존재하며 버전/안정 ID·로더/실패 러너를 그대로 읽는다. 시각은 명시적 입력으로 받아 W02 서비스 구현/병합을 순수 계산의 선행으로 요구하지 않는다.
- **L2 데이터 공급 영향**: 실제 UI 통합 전 Design에 같은 계획/input revision의 역/노선·거리/기간·예측/상태·reason/allowed_actions와 정상6/8·오류·없음/0/낡은 응답 fixture를 공급한다. 기존 UI-DC-01/02/07 의미를 유지하며 변경 행만 재검토한다. 표현/목업은 Design 소관이다.
- W03 실패는 해당 예측/지도·노선 통합만 차단하고 W02 독립 시간/원장 검증은 차단하지 않는다. 미승인 뷰포트/폰트/성능 기준·Planning 새 폴리곤을 모델 선행으로 요구하지 않는다.
- DEV-011과 신규 코드/테스트/데이터 경로를 분리한다. 공통 WORK_STATUS.md는 자기 행만 수정하고 PR 제출 순서에 따라 최신 main 기준 재검증한다. 미공유 재배치와 공유 후 새 브랜치/대체 PR을 구분하며 Update branch(Merge)·force push 금지.
- 실제 지도/목록·시간·현재 장부의 최소 GUI 통합/Stage S1-07/08은 두 모델 및 Design 입력을 모은 별도 승인 티켓에서 검증한다. 이 두 백엔드 티켓만으로 Stage 종료를 선언하지 않는다.

## 5. 개별 승인 요청·현재 검증

Owner에게 요청: `wisberry2022/MetroManager` / DEV-012 / 위 브랜치·§1~3/§2 경로의 **구현·검증, Commit, 작업 브랜치 Push 또는 규정 API 공유, base=main PR 생성·필수 CI/동일 범위 검수 수정**을 각각 승인. 기간은 명시 승인 시점부터 이번 티켓 PR/검수 대응까지이며 DEV-011·최소 GUI로 승계하지 않는다. main 직접 쓰기/Merge·강제 push·정책/CI 우회·릴리스/배포·명세/타 부서 변경 금지. 실행/제출 시 최신 main 재확인.

현재 Owner 채팅의 개별 실행/Git 승인 원문: “개발 에이전트. Issue #48의 DEV-011 W02와 Issue #49의 DEV-012 W03 구현 및 각 브랜치의 Commit·Push·PR 생성을 승인합니다. 각 티켓 범위에 한해서 작업하고 검증 후 PR 생성해주세요. main 병합은 별도 승인하겠습니다.”

승인자는 Owner, 저장소·작업·브랜치·경로·허용 동작·유효기간/금지는 위 요청 범위 그대로다. 이전 DEV-010 권한을 재사용하지 않았다. 구현·검증·Commit/Push/PR 허용, main Merge/릴리스는 제외한다. 실제 결과는 [DEV-012 결과](DEV-012_RESULT.md)를 따른다. 현재는 검수 요청 REVIEW이며 Owner ACCEPTED/DONE·전체 Stage 완료가 아니다.

- 제출 기준 갱신: 구현 중 Design PR #50의 문서2개만 main 5c91d56c78c2de5bd94bea7ee66b5c86181f4cb8에 추가됐다. 미공유 작업을 최신 main 위로 재배치하고 승인된 자기 변경만 제출한다. 게임 규칙/코드·W01 원본·고정 DATA 출처604751d는 변경하지 않는다. 실제 preflight base/head는 PR에 기록한다.
