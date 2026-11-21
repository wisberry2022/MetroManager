# DEV-026 — DSG-008 후속 계약·적용 범위 검토 티켓

> **최신 후속 — 2026-11-21:** [Track B 검수 의견](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7056903693) 수신 / LIMITED_ACCEPTANCE_RECOMMENDED / OVERALL_PARTIAL / OWNER_REVIEW_REQUESTED. PR #153·#154 병합과 현재 공급에 대한 독립 실행·Design 증거 심사 보고를 연결했다. 이는 Owner 최종 수용·RFC 종결·S3-12/DONE이 아니다. 아래 이전 PENDING/HOLD/미커밋 기록은 당시 이력이며 현재 판단과 잔여는 마지막 후속 절을 따른다.

<!-- 이전 본문은 당시 상태로 보존하며 최신 효력은 후속 절을 따른다. -->

> **현재 로컬 후속 — 2026-11-21:** 경로 재지정 승인 적용·기존35개 실패 해소·자동 GUI266/266 PASS. LOCAL_REVIEW / PRODUCT_L2_PENDING. 후속8개 파일은 미커밋이며 Commit·Push·main 병합은 별도 승인이다. 아래 이전 본문의 PARTIAL·승인 대기·NOT_RUN은 당시 기록이고 최신 근거는 마지막 후속 절과 증거 JSON gui_followup을 따른다.

<!-- 아래 이전 본문은 당시 상태로 보존한다. -->

> **현재 상태 — 2026-11-21:** PR_REVIEW_PARTIAL / TEST_PATH_REASSIGNMENT_PENDING / PRODUCT_L2_PENDING. Owner가 기존23개 파일의 Commit·Push·Draft PR 공유를 요청했다([티켓 §9](DEV-026_S01_EXCEPTION_SCOPE.md)). 기존 GUI35개 실패·검사기 재지정 승인 대기·Design 수용 대기는 유지한다. 앞선 HOLD/NOT_RUN·로컬 검토 기록은 당시 이력이며 main 병합은 별도 승인이다.

> **이전 문서 제출 상태 — 2026-11-21:** STAGE3_SCOPE_CONFIRMED / IMPLEMENTATION_READINESS_PENDING / PRODUCT_VALIDATION_NOT_RUN. #146의 사전 의견은 수신했으며 실제 공급·제품 L2/검증 수용은 PENDING이다. 현재 범위·권한은 §7을 따른다. 그 앞의 2026-11-14 검토·선행 티켓 대기·HOLD·검증 기록은 당시 이력으로 보존한다. 이번 승인은 문서 보완·Commit/Push/PR이며 제품 구현·실행·main 병합은 별도다.

- 담당: Development / AGT-DEV-0004 / 2026-11-14.
- 현재 상태: **DOCUMENT_REVIEW / CONTRACT_PROPOSED / OWNER_IMPLEMENTATION_DEFERRED**.
- 문서 제출 기준 main: `2baed0518e5443007c159962bfba46a8eeae5fdb`. 기존 소스 분석 기준과 구분한다.
- 기준 main: `9e6154e926d44cdbbb2fb117fb7d3fc56d152eac`. 브랜치: `codex/DEV-026-s01-exception-contract`.
- 관련: [Issue #104](https://github.com/wisberry2022/MetroManager/issues/104), RFC-DSG-008-EX-01 / DSG-008 / UI-DC-01·02·05·07.
- [계약안·L2 RFC 초안](../gate3/DEV-026_S01_EXCEPTION_CONTRACT.md), [20사례·검증 계획](../gate3/DEV-026_S01_EXCEPTION_VALIDATION_PLAN.md), [검토 결과](DEV-026_RESULT.md).

## 1. 현재 Owner 지시와 효력

> HQ에 전달했습니다. 이제 104번 이슈의 DSG-008 후속 공급·소비 계약과 적용 범위를 구체화하고, 필요한 개발 작업·검증 계획·승인 범위를 로컬 검토안으로 준비해주세요.

최초 승인 범위는 최신 원격/소스 정적 조사와 검토안 4개 문서의 로컬 작성·검증이었다. 당시 구현·게임 실행/실험·외부 회신·Commit·Push·PR·병합은 미승인이었으며, 아래 후속 지시로 문서 제출 범위만 갱신한다. DEV-019의 “별도 PR 없음·Owner 복사 전달” 방침과 로컬 초안은 보존한다.

### 1.1 Owner 후속 지시 — 2026-11-14 / 본 개발 대화

> 개발 에이전트 DEV-026은 현재 구현/검증에 착수하지 않지만, 현재까지 검토한 내용을 우선 원격 저장소에 반영하여 디자이너 에이전트가 사전 확인할 수 있도록 하려 합니다. DEV-026에 대한 착수는, 이보다 더 먼저 구현되어야 하는 DEV-022 ~ 025 개발 사항들을 개발한뒤 착수하겠습니다. OWNER의 판단이 적절한지 판단하여, 이의가 없을 시 OWNER의 결정을 검토 결과서에 작성하여 PR에 포함해주세요

개발 검토 결과 이견이 없어 [결과서](DEV-026_RESULT.md)에 근거·경계·재개 조건을 기록한다. 이번 원격 반영·PR 요청은 다음 문서 제출의 Commit·일반 Push·PR 생성과 필수 CI 확인을 허용하는 지시로 적용한다. 이는 앞선 로컬 전용 범위를 갱신하는 현재 승인 근거이며 과거 DEV-019 권한을 재사용하지 않는다.

- 대상: `wisberry2022/MetroManager` / DEV-026 / AGT-DEV-0004 / `codex/DEV-026-s01-exception-contract` → base `main`.
- 포함: 기존 검토 Markdown 4개에 Owner 결정·현 상태 반영, 해당 4개의 출처를 기록하는 `docs/engineering/tasks/DEV-026_PROVENANCE.json`, 문서/정책 검사·정상 훅 Commit·일반 Push·PR·필수 CI 확인 및 같은 문서 범위 검수 대응.
- 기간: 이번 문서 제출·같은 범위 검수 대응 종료 또는 Owner 철회까지.
- 구현·제품 검증: **OWNER_IMPLEMENTATION_DEFERRED**. DEV-022~025의 선행 업무 후 최신 계약/경로/증거를 대조하여 재개한다. 이번에는 해당 선행 티켓의 구현도 시작하지 않는다.
- 제외: 제품/테스트/씬/데이터·타 부서·정책/CI 변경, 게임 자동·Godot/GUI·성능 실험, 별도 Issue 댓글/부서 메시지, main 병합·auto-merge·force push·릴리스/배포. 미래 구현 파일의 Git 제출 권한도 포함하지 않는다.

DEV-026은 작성 시점 main 트리/본문, fetch된 로컬·원격 refs, 전체 로컬 commit 제목, 모든 로컬 worktree의 DEV-026 파일명, GitHub 전체 상태 Issue/PR 검색에서 기존 사용을 찾지 못한 뒤 이 로컬 검토안에 사용했다. 원격 Issue 발급/예약이나 구현 승인으로 간주하지 않으며 제출 직전 경합을 재확인한다.

## 2. 목적·적용 범위

S01의 자료 준비·허용 행동·예측·현재 자금/당일 관측·과거 보고·결과 귀속·복귀를 실제 공급 필드와 연결한다. 권고 구현은 최소 root 계약/실행 소속 추가, 순수 관측 검사, 지역 렌더/입력 제한, 새 Session의 전체 View 재생성이다.

7영역/20사례 중 EX-05는 소비 fixture 조건부, EX-16은 동기 S01 적용 제외, EX-18은 별도 외부 관할 검증 입력이다. 그 밖의 사례도 실제 모델 경로와 수신 반례를 구분하며 모든 미수신 상태가 현재 제품에서 자연 발생한다고 주장하지 않는다.

제외: 경제·시간·원장·계획/예측 모델 규칙, UI-DC 전체 재정의, W04A/W05 내부 문구·API/깊은 봉투 guard, 새 서비스/재정 화면·PLN-008 대응 기능, 세이브/영구ID, 비동기/네트워크/디스크 처리, 자동재조회·취소·타임아웃·가짜 대기, F-08 수치 규격·고충실도 아트, 상위 Stage DONE.

## 3. 개발 작업 분해 — 미실행 제안

| 순서 | 작업·산출물 | 선행·완료 조건 |
| --- | --- | --- |
| A | 본 계약/20사례의 지역 제한·새 Session·복귀 L2-A/B/C를 Design과 대조 | 이번 문서 PR로 사전 열람 가능하게 공유. 의미 차이·직접 영향 행만, 새 전체 검수행렬 없음 |
| B | Session 최소 메타데이터·관측 검사·binding/생명주기 구현 | 아래 B 권한 선택 필요. 순수 검사의 지역 결과와 상태 누락의 타입 안정성 자동검증 |
| C | View/Map의 구조·상태별 렌더/입력·복귀, 기존 QA 전환기 재생성 정렬 | B에 종속. helper만 추가하고 직접 접근 경로를 남기지 않음. 정상 W04A/W05 전달/복귀 보존 |
| D | 신규 fixture/자동·GUI runner, 기존 영향 회귀·실제 입력 검증 | B/C 및 별도 C 실행 권한. 정상→이상→복귀/같은·새 Session을 구분 |
| E | 증거 묶음·Design 독립 인수 입력·결과 보고 | 유효 실행 SHA·환경·로그/원본 해시·FAIL/NOT_RUN·원래/새 증거 구분. 수용은 Design/Owner 별도 |

정확한 일정·작업시간은 현재 NOT_ESTIMATED. 계약 대조와 실행 승인 범위가 정해지면 산정한다. L2 차이가 없으면 기존 의미에 대한 반복 승인을 만들지 않는다.

## 4. 구현 승인 후보 경로 — 현재 변경 아님

| 경로 | 허용할 변경 한계 |
| --- | --- |
| `scripts/ui/stage1_session.gd` | 기존 _report_scope 읽기 getter·root run_scope/ui_contract_revision 공급. 기존 명령/경제 계산 변경 금지 |
| `scripts/ui/s01_observation_contract.gd`, `.gd.uid` (신규2개) | 순수 필드/소속/지역 의존성 검사. 게임 enum·전역 상태·데이터 보정 없음 |
| `scripts/ui/stage1_view.gd` | _ready/present/render/후보생성/입력/호스트 전달/reset의 일관 guard·binding·문구·복귀. 기존 W05 읽기 키 기능 보존 |
| `scripts/ui/stage1_map.gd` | 유효 자료 소비·무효 관측의 marker 입력/그리기 비움. 지도 배치/소속 재판정 없음 |
| `tests/game/run_w07_tests.gd` | 기존 QA-X01을 새 View 전환 계약으로 정렬, 영향 문구 단언 갱신. 기존 의미 회귀 삭제/약화 금지 |
| `tests/game/run_w07_gui_cases.gd` | _choose의 새 Session+View 전환 및 옛 callback 해제. 기존 사례·수동 관측 보존 |
| `tests/game/w026_ui_fixtures.gd`, `.gd.uid` (신규2개) | 실제 모델 표본과 격리 수신 변조·Session 귀속 표본. 제품 연결 없음 |
| `tests/game/run_s01_exception_tests.gd`, `.gd.uid` (신규2개) | 20사례의 적용/제외·구조·복귀·무효과 단언 및 의도 실패 종료1 |
| `tests/game/run_s01_exception_gui_cases.gd`, `.gd.uid` (신규2개) | 실제 제품 View 재사용, 조건/run ID·입력/상태/화면/종료 관측. 클릭 연출로 성공 대체 금지 |
| 본 티켓·RESULT 및 gate3 계약/검증 계획 (현재4개 문서) | 승인·실제 변경·검증·수용·미해결의 후속 기록 |
| `docs/engineering/tasks/DEV-026_PROVENANCE.json` (이번 문서 제출에 신규) | 현재 문서 4개의 작성자·blob·출처 선언. 미래 코드/실행 증거의 출처는 후속 범위에서 갱신 |
| `docs/engineering/evidence/DEV-026_S01_EXCEPTION_RESULTS.json`, `DEV-026_S01_EXCEPTION_EVIDENCE.md` (실행 승인 후 신규2개) | run/case별 자동·GUI·원본 해시·NOT_RUN 인덱스. 제한 원본은 .local 보관 |

이번 PR은 Markdown 4개와 제출 출처 JSON 1개만 포함한다. 위 미래 경로의 코드는 아직 생성/수정하지 않았다. 기존 UID는 보존한다. 신규 캡처 공개 경로는 이 목록에 넣지 않았으며 실행 원본은 `.local/validation/DEV-026/`의 run_id 하위에 분리 보관한다. 공개 추가 파일이나 목록 밖 경로가 필요하면 이유와 정확한 경로를 제시해 범위를 다시 확인한다.

## 5. Owner 권한 상태와 후속 선택 범위

현재 문서 제출 승인은 §1.1에 한정한다. 아래 B/C 및 미래 구현 Git 제출은 후속 검토 후보이며 지금 승인된 범위가 아니다.

| 선택 | 구체 허용 동작 | 현재 상태 |
| --- | --- | --- |
| A 계약 사전 공유 | 이번 문서 PR로 Design이 열람하도록 공급. 사전 의견과 실제 제품 L2 수용을 구분 | 문서 PR 공유 승인. 별도 #104 댓글/메시지는 포함하지 않음 |
| B 로컬 구현 | §4의 제품5개·테스트8개·DEV 문서/출처/증거 경로 제안. 재개 시 선행 결과에 맞춰 다시 대조 | OWNER_IMPLEMENTATION_DEFERRED |
| C 제품 실행·증거 | 계획 X-01~07의 자동검사·Godot 로드·영향 회귀·실제 GUI·fixture 실험 제안 | OWNER_IMPLEMENTATION_DEFERRED / NOT_RUN |
| G 문서 Git 제출 | Markdown 4개·출처 JSON 1개만 정상 훅 Commit·일반 Push·base main PR·필수 CI 확인 | §1.1 현재 승인. 미래 코드/제품 증거 제출은 미포함 |
| main 병합·릴리스/배포 | 별도 Owner 결정 | 미승인 / 위 선택에서 제외 |

현재 순서는 문서 PR 사전 공유 → DEV-022~025 선행 업무 → 최신 공급/소비 계약과 경로·검증 계획 재대조 → DEV-026 구현/제품 검증 착수다. 선행 업무 중 발견되는 실제 결함·범위 충돌은 결과서의 경계에 따라 처리한다. 이미 유효한 승계 권한은 보존하고 이 지시로 미승인 범위를 확대하지 않는다. main 병합은 별도 Owner 결정이다.

## 6. 완료·잔여

문서 제출 종료 조건은 구체 필드·책임·경계/적용·제외·20사례 기대·필요 파일·검증·권한 범위와 Owner 순서 결정을 PR로 제공하고 필수 CI를 확인하는 것이다. 구현/실험은 보류하며 Design 제품 수용은 PENDING, 실제 제품 실행 결과는 NOT_RUN이다.

게임/경제/세이브 명세 변경 필요 NONE. 기술 계약 보강과 Design 직접 영향은 RFC-DEV-026-01의 제안으로 연결한다. 부서 경계·정책/범위·일정 충돌이 실제 생길 때 해당 차이만 HQ/Owner에 상정한다. F08-01~04·최종 규격 미확정·A01-Q12 상위 PARTIAL·기존 한정 수용과 DEV-019의 종료된 Q03~Q05 잔여 범위를 보존한다.

## 7. Stage 3 편입·Design 사전 의견 및 문서 보완 — 2026-11-21

### 7.1 현재 효력과 근거

현재 상태는 **STAGE3_SCOPE_CONFIRMED / IMPLEMENTATION_READINESS_PENDING / PRODUCT_VALIDATION_NOT_RUN**이다. [PM-020](../../hq/PM-020_STAGE3_EXECUTION_PLAN.md)의 편입 결정과 [병합 PR #149](https://github.com/wisberry2022/MetroManager/pull/149)의 공동 계획을 따른다. §1~6의 OWNER_IMPLEMENTATION_DEFERRED·20개 후보·DEV-022~025 선행 대기는 당시 이력이다. 현재도 제품 실행 권한은 별도지만 편입 자체를 재승인하거나 과거 선행 티켓을 다시 시작하는 조건은 아니다.

기준 main: `de0f03f9d2fcc301940a4176f1359b2788a51950`. [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053550740)는 비의존 모델에 DESIGN_PRELIMINARY_NO_OBJECTION / 실제 UI L2_FINAL_PENDING, [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053570152)는 RP/EX 제안 의미에 이견 없음 / 실제 공급·제품 L2 및 검증 수용 PENDING이다. 두 회신은 제품 실행 승인이 아니며 새 전체 Design 차단을 추가하지 않는다. RFC-DEV-026-01은 OPEN / PROPOSED로 유지하되 Design 의견 미수신 표기는 역사로 구분한다.

### 7.2 이번 Owner 요청·정확한 문서 제출 범위

> 149 PR이 main에 머지되었습니다. 당신의 계획서를 읽고 디자이너 에이전트가 146번 이슈에 코멘트를 등록하였으니 확인하여, DEV-027,026에서 수정해야할 부분이 있다면 수정하여 PR 생성해주세요

이번 개발 대화의 위 요청에 따라 다음 **문서5개만** 수정·정적 검사·정상 훅 Commit·일반 Push·PR·필수 CI 확인한다. 대상은 `wisberry2022/MetroManager`, 담당 AGT-DEV-0004, 브랜치 `codex/DEV-026-design-plan-followup` → `main`. 기간은 이번 문서 PR 및 같은 범위 검수 대응 종료/Owner 철회까지다.

| 정확한 경로 | 보완 |
| --- | --- |
| `docs/engineering/tasks/DEV-026_S01_EXCEPTION_SCOPE.md` | 본 후속 권한·현 상태·24개 미래 후보 연결 |
| `docs/engineering/gate3/DEV-026_S01_EXCEPTION_CONTRACT.md` | RP/EX 수신, 지역 의존·P07 선택 보고일·화면별 복귀·W04B 사본 표현 |
| `docs/engineering/gate3/DEV-026_S01_EXCEPTION_VALIDATION_PLAN.md` | RP/EX 최소 표본·검증 기대·공동 증거 계획 |
| `docs/engineering/tasks/DEV-026_RESULT.md` | 과거 증거 보존·현재 문서 검증·미해결 |
| `docs/engineering/tasks/DEV-026_PROVENANCE.json` | 현재5개 제출 중 Markdown4개의 base/blob/출처 선언 |

제품 소스·게임 테스트/fixture·새 API·실험, 미래 구현24개 경로, 타 부서 문서·정책/CI, main 병합·릴리스/배포는 미포함이다. DEV-027 문서4개는 자기 브랜치/PR로 분리한다. 현재 요청을 제품 구현 승인으로 확대하지 않는다.

### 7.3 현재 미래 구현 후보와 순서

[공동 계획 §8.2의 고정 원본](https://github.com/wisberry2022/MetroManager/blob/de0f03f9d2fcc301940a4176f1359b2788a51950/docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md)의 **24개 경로**를 현재 후보로 재대조했다. 과거20개에서 추가된4개는 아래와 같으며 이번 문서 후속으로 더 늘리지 않는다.

- `scripts/ui/operations_view.gd`: P06 지역 의존·실행 소속/복귀 경계.
- `scripts/ui/finance_view.gd`: P07 선택일·확인 사본·조회·지역 제한.
- `tests/game/run_operations_ui_tests.gd`: 해당 P06/P07 경계 검사.
- `tests/game/run_f08_gui_cases.gd`: 기존 View에 새 Session 대입/reset하던 전환부만 새 View 계약과 정렬.

DEV-026 공통 공급/생명주기 → DEV-027 Session/호스트 통합 → 해당 W04B 실제 공급 L2 → 신규 UI 수용 → 공동 고정 VS-02 시험본 순서다. 비의존 모델의 실제 공급 생성은 UI 최종 L2를 먼저 받아야 하는 작업이 아니다. 제품 구현·실행은 별도의 유효 승인 범위를 연결한 뒤 진행한다.

DI-03의 E01 대상 동/OD·추가 발생/중첩은 Planning 미결이며 종속 W04B 연결만 보류한다. DEV-026 전체 선행조건이나 새 폰트/배치·F08 확정 조건이 아니다. Track B RD별 새 심사/F08-01~04 선택·적용은 #92 별도이며 이번 회신을 RD 최종 판정으로 바꾸지 않는다.

같은 Session·새 Session, 실제 제품·수신 fixture, DEV 자체·독립 실행·Design 심사를 구별한 한 패킷을 제출한다. 기존 Stage 2 DONE·한정 수용과 과거 NOT_VERIFIED/NOT_CAPTURED를 보존한다. 추가 게임 명세 변경 필요는 현재 확정하지 않았으며 실제 차이만 RFC로 연결한다.

## 8. 로컬 구현·검증 착수 — 2026-11-21

Owner 원문(본 개발 대화): “개발 에이전트 두 PR이 모두 main에 머지되었습니다. 우선 DEV-026부터 작업 진행해주세요”.

PR #151 병합 `b319edb2222ae993b3fa5b74694d55f9f833fd2d`, PR #150 병합/착수 base `ecb2708bfa7bd3230d56c60b910d6831511953c6`을 확인했다. 브랜치는 `codex/DEV-026-s01-exception-implementation`, 담당 AGT-DEV-0004다.

이 요청을 병합된 공동 계획 §8.2의 정확한24개 경로 내 DEV-026 로컬 구현·관련 자동/직접 영향 회귀·프로젝트 로드·DEV 자체 GUI 경계 검증 착수 승인으로 적용한다. 최초20개에 P06/P07 및 검증 전환4개를 포함한 목록은 §7.3의 고정 계획과 같다. 신규 파일/UID도 경로에 계수하며 목록 밖 제품 수정은 확대하지 않는다. 실제 변경 목록·명령·base+파일 해시·결과는 결과서와 증거 색인에 기록한다.

목표는 최소 root 계약/Session 소속, 순수 지역 검사와 입력 제한, 새 Session의 새 전체 View, 같은 Session 복귀·P07 FIXED_DAY/확인 사본 및 옛 callback 차단이다. W04B 실제 공급은 DEV-027 후속이며 이번에 가짜 모델/대기를 추가하지 않는다. DI-03/E01 미결은 DEV-026의 선행 차단이 아니다.

현재 요청은 로컬 결과를 먼저 검토하는 기존 제출 절차를 유지한다. 이번 구현물의 Commit·Push·PR·main 병합·릴리스/배포, 독립 실행 주체의 권한 및 Design 최종 제품 L2 수용은 포함하지 않는다. 최초 문서와20사례·Stage 2 기존 수용/미확인을 보존한다.

### 8.1 회귀 전환기 경로 재지정 검토

구현 대조에서 기존 `tests/game/run_operations_gui_cases.gd`의 `_consumer_cases`가 실제 Session binding 없이 P06/P07을 만들고, 여러 실행의 과거 소비 표본을 같은 View에 주입한 뒤 `shown={}`로 하한을 되감는 것을 확인했다. 새 Session 소속/수신 하한·고정 보고일 계약에서는 같은 시험 전제를 유지할 수 없다. 제품 검사를 완화하지 않고 시험 자체의 독립 Session/View와 보고 식별 문맥을 명시해야 한다.

제안은 **최대24개 경로를 유지**하며 `tests/game/run_operations_ui_tests.gd` 수정 후보 대신 `tests/game/run_operations_gui_cases.gd`를 수정 후보로 재지정하는 것이다. 기존 공급 자동검사는 수정 없이 회귀 실행하고, 신규 root 메타데이터·부분 재무 공급 검증은 승인 목록의 `run_s01_exception_tests.gd`에서 수행한다. 기존 GUI 자동검사의 단언/과거 공개 증거는 보존하고 소비 표본 전환/실제 binding·선택 보고일 문맥만 정렬한다. 이 경로 재지정은 Owner 확인 전 미적용이다. 기존 파일을 수정하지 않은 재검사 `operations-02`는245개 중35개 FAIL·exit1이며, 남은 실패는 `_consumer_cases()`에 모여 있다. 다른 승인 경로의 신규334개·W07 322개 경계 검사는 PASS이고 로컬 결과23개 파일을 검토 대상으로 공급한다. 전체 제품 검증 종료/수용은 선언하지 않는다.

## 9. 현재 작업본 PR 공유 승인 — 2026-11-21

Owner 원문(본 개발 대화): “개발 에이전트. 작업 내용을 PR로 만들어주세요”. 직전 검토 결과23개 파일·기존 GUI35개 실패·검사기 경로 재지정/Design 수용 대기를 보고한 뒤 받은 요청이다.

대상은 `wisberry2022/MetroManager`, 작업 DEV-026 / AGT-DEV-0004, 브랜치 `codex/DEV-026-s01-exception-implementation` → `main`이다. **기존23개 작업 파일**과 그 안의 승인/제출 기록을 정상 훅 Commit·일반 Push·Draft PR로 공유하고 필수 CI를 확인한다. 기간은 이번 제출 및 같은 범위 제출 검사 대응 완료/Owner 철회까지다. 변경 경로는 [결과 JSON](../evidence/DEV-026_S01_EXCEPTION_RESULTS.json)의 `changed_files`를 따른다.

이 요청은 현재 PARTIAL 결과의 검토용 공유다. §8.1의 검사기 재지정은 계속 승인 대기이며 `run_operations_gui_cases.gd`를 수정하지 않는다. 기존35개 실패를 숨기거나 단언을 삭제하지 않는다. 실패 상태의 현재 작업본을 공개 검토하는 근거는 이 Owner 요청이며, 완료/병합 가능 판정의 예외가 아니다. main 병합·릴리스/배포·Design 독립 수용은 미포함이다.

제출 base는 `63550826af8b6ae9a46bda2e4bb826dd1ed7cd79`다. 최초 시험 base `ecb2708bfa7bd3230d56c60b910d6831511953c6` 이후 PR #152의 기획 문서3개만 진전했다. 겹치는 경로 없이 작업 브랜치만 fast-forward했고 원래 시험본/로그/해시는 보존했다. 제품/테스트16개 파일 해시를 로컬 검토본과 대조하여 기존 제품 검증을 재사용한다. 새 GUI·자연 완주를 실행한 것으로 기록하지 않는다.

현재 main 보호는 strict `policy`·`department-policy`, 관리자 적용·선형 이력·대화 해결 필수, force push/삭제 금지, squash만 허용으로 확인했다. 리뷰0명은 기존 단일 계정 운영이며 Owner의 별도 main 병합 원칙을 유지한다. 실제 제출 head·preflight·CI는 PR 본문/Checks를 따른다.

## 10. 검사 경로 재지정·로컬 보완 — 2026-11-21

Owner 원문(본 개발 대화):

> DEV-026의 검사 경로 재지정을 승인합니다. run_operations_ui_tests.gd 대신 run_operations_gui_cases.gd를 포함해 최대 24개 경로 안에서 GUI 검사 35개 실패를 수정·검증하고 로컬 결과부터 검토 요청해주세요. Commit·Push와 main 병합은 별도 승인하겠습니다.

tests/game/run_operations_ui_tests.gd 수정 후보를 tests/game/run_operations_gui_cases.gd로 교체한다. 공급 자동검사는 수정 없이 실행한다. 기존 구현23개와 새 검사 경로1개를 합친 누적 허용 경로는 아래 **24개**다. 이번 실제 후속 변경은 검사1개·DEV 기록7개, **8개 파일**이다.

| 번호 | 정확한 허용 경로 |
| --- | --- |
| 1 | `docs/engineering/evidence/DEV-026_S01_EXCEPTION_EVIDENCE.md` |
| 2 | `docs/engineering/evidence/DEV-026_S01_EXCEPTION_RESULTS.json` |
| 3 | `docs/engineering/gate3/DEV-026_S01_EXCEPTION_CONTRACT.md` |
| 4 | `docs/engineering/gate3/DEV-026_S01_EXCEPTION_VALIDATION_PLAN.md` |
| 5 | `docs/engineering/tasks/DEV-026_PROVENANCE.json` |
| 6 | `docs/engineering/tasks/DEV-026_RESULT.md` |
| 7 | `docs/engineering/tasks/DEV-026_S01_EXCEPTION_SCOPE.md` |
| 8 | `scripts/ui/finance_view.gd` |
| 9 | `scripts/ui/operations_view.gd` |
| 10 | `scripts/ui/s01_observation_contract.gd` |
| 11 | `scripts/ui/s01_observation_contract.gd.uid` |
| 12 | `scripts/ui/stage1_map.gd` |
| 13 | `scripts/ui/stage1_session.gd` |
| 14 | `scripts/ui/stage1_view.gd` |
| 15 | `tests/game/run_f08_gui_cases.gd` |
| 16 | `tests/game/run_operations_gui_cases.gd` |
| 17 | `tests/game/run_s01_exception_gui_cases.gd` |
| 18 | `tests/game/run_s01_exception_gui_cases.gd.uid` |
| 19 | `tests/game/run_s01_exception_tests.gd` |
| 20 | `tests/game/run_s01_exception_tests.gd.uid` |
| 21 | `tests/game/run_w07_gui_cases.gd` |
| 22 | `tests/game/run_w07_tests.gd` |
| 23 | `tests/game/w026_ui_fixtures.gd` |
| 24 | `tests/game/w026_ui_fixtures.gd.uid` |

원격 조회에서 [PR #153](https://github.com/wisberry2022/MetroManager/pull/153)의 병합과 main 3695c1eefc76fe257c66bd9c4fbbd7d62ae1f572를 확인했다. 이전 head 350a55b1b6f7f182774d4ae74772425e4bca2299와 트리는 같으며 이 조회로 과거 승인 원문을 생성하지 않는다. 해당 main에서 독립 worktree/브랜치 codex/DEV-026-operations-gui-followup를 만들고 기존 구현 worktree·공유 root의 작업물을 보존했다.

이번 권한은 검사 준비의 Session 귀속·독립/연속 표본·P07 보고 선택 문맥 정렬, 관련 회귀·로드와 로컬 결과 보고다. 후속 Commit·Push·PR 갱신/생성·main 병합은 NOT_RUN / 별도 승인이다. 기존 제출 권한을 재사용하지 않는다. 독립 실행/Design 수용·W04B 공급은 별도이며 기존 단언·실패 원본·제품 guard를 보존한다.

## 11. Design 검수 의견 확인·로컬 후속 — 2026-11-21

Owner 원문(본 개발 대화):

> 개발 에이전트 104번 이슈에 디자이너 에이전트가 DEV-026에 대한 검토 결과를 회신하였으니 확인하여 조치할 부분이 있으면 후속작업 진행해주세요

[정본 회신](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7056903693)과 PR #154 병합을 확인했다. 기준 main ae614d922c837eddf4e615fda985bd978e217461; 브랜치 codex/DEV-026-design-review-followup. 이번 범위는 기존 계약/소스/증거의 정적 대조, Design 의견의 후속 기록, P07 의미 경계에 대한 DEV 검토 및 회신/HQ 인계 초안이다. 새 기능 결함은 확인되지 않았으므로 제품 수정·동일 GUI 반복은 착수하지 않는다.

실제 변경은 기존 허용24개 중 아래 **문서/출처5개**다. 제품·테스트·실행 JSON·원본·Design/HQ 산출물은 변경하지 않는다.

| 경로 | 후속 내용 |
| --- | --- |
| docs/engineering/tasks/DEV-026_S01_EXCEPTION_SCOPE.md | 본 작업 근거·정확한5개 경로·권한 경계 |
| docs/engineering/gate3/DEV-026_S01_EXCEPTION_CONTRACT.md | 기존 RFC-DEV-026-01에 P07 문맥 복귀/일반 재진입 DEV 의견 연결 |
| docs/engineering/tasks/DEV-026_RESULT.md | 검토 결과·잔여·#104 회신 초안/HQ 인계 요약 |
| docs/engineering/evidence/DEV-026_S01_EXCEPTION_EVIDENCE.md | DEV 자체·독립 실행·Design 심사·Owner 결정 분리 및 고정 근거 |
| docs/engineering/tasks/DEV-026_PROVENANCE.json | 현재4개 Markdown의 base/blob/출처 선언 |

이 요청은 코드/Git 권한이나 Owner의 한정 수용안 승인을 새로 생성하지 않는다. 현재 후속의 Commit·Push·PR·main 병합·이슈/RFC 종료·댓글 게시는 NOT_RUN이다. 이전 8개 파일 제출 승인은 완료된 PR #154의 범위이며 재사용하지 않는다. 회신 초안은 로컬 검토용으로 준비했다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-026
