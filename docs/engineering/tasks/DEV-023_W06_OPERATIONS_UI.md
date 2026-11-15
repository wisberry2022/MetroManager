# DEV-023 — W06 운행·재무 UI 착수 범위 검토안

- 담당: Development Project Leader / LAPTOP / AGT-DEV-0004 / 2026-11-15 (Asia/Seoul).
- 상태: **P3_IMPLEMENTED_REVIEW_REQUESTED / DESIGN_L2_ACCEPTED**.
- 저장소: wisberry2022/MetroManager · [Issue #79](https://github.com/wisberry2022/MetroManager/issues/79).
- 구현·검증 기준 main: `e379e584e6a9fefa0c581f27903c16e4fc0f5136`. 제출 기준 main: `30cc2ea5f6e7c03aebff1315b6fd00530871ebec`.
- 현재 후속 브랜치: `codex/DEV-023-operations-screen-integration`, 기준 main `3e2982ac71be28344c3be5360652f4071c678ce3`. 아래 기존 브랜치·승인/검증 기록은 이력이다.
- 이전 로컬 브랜치: `codex/DEV-023-operations-finance-ui`. #79의 operations-ui는 최초 제안명이며 이번 독립 worktree의 실제 이름은 이 이름이다.
- 연결: [실행·공급 계약/L2 협의안](../gate3/DEV-023_UI_SUPPLY_AND_EXECUTION_PLAN.md), [검증 계획](../gate3/DEV-023_UI_VALIDATION_PLAN.md), [준비 결과](DEV-023_RESULT.md).

## 1. 준비 당시 권한과 선행 상태 — 현재 승인은 §1.1

Owner의 본 개발 대화 지시:

> PR이 main에 머지되었습니다. DEV-026 구현·검증 보류는 유지하고, 다음으로 DEV-023의 착수 범위와 실행·검증 계획을 준비해주세요.

이번 권한은 원격/승인 원본/소스 조사, 독립 로컬 브랜치·worktree 준비, 아래 Markdown 4개의 작성·정적/정책 검사와 로컬 검토 요청이다. 신규 제품·씬·테스트 작성이나 게임 실행, Commit·Push·PR·main 병합·외부 회신은 이번에 수행하지 않는다. DEV-022의 Git 승인을 재사용하지 않는다.

PR #123은 MERGED다. main `e379e584e6a9fefa0c581f27903c16e4fc0f5136`와 제출 head `00be38d232308a4d4c01b203af8bab6122eed34c`의 tree diff는 없다. 병합 시각은 2026-11-14 22:41:54 Asia/Seoul이다. DEV-022의 모델·자동검증 수용을 DEV-023 화면 수용/DEV-024 실제 완주로 확대하지 않는다.

Owner가 승인한 2026-11-14 17:37 승계 및 티켓별 권한 이전에 따라 담당은 AGT-DEV-0004다. INF-010은 main에 반영되어 등록 상태는 REGISTRY_RECORDED다. #79의 AGT-DEV-0001과 과거 기준 SHA는 작성 당시 이력이며 해당 Issue는 실행 승인 대기다. 승계는 없던 제작/Git 권한을 만들지 않는다.

### 1.1 Owner 로컬 구현·검증 승인 — 2026-11-15

> DEV-023의 착수 범위와 실행·검증 계획을 승인합니다. 검토안에 명시한 범위로 구현·검증을 진행하고, 로컬 결과부터 검토 요청해주세요. Design L2가 필요한 화면 통합은 수용 후 진행하고, Commit·Push·PR과 main 병합은 별도 승인하겠습니다. DEV-026 보류는 유지합니다.

위 지시는 §4의 23개 경로 내 로컬 구현·검증과 증거 작성, 같은 범위 보완을 승인한다. 대상은 wisberry2022/MetroManager / DEV-023 / AGT-DEV-0004 / codex/DEV-023-operations-finance-ui이며 이번 로컬 결과 검토 종료 또는 Owner 철회까지다. 최초 준비 단계의 미승인 기록은 이력으로 보존한다. Commit·Push·PR·main 병합·외부 회신·릴리스·배포는 포함하지 않는다.

실행 전 fetch와 원격 main 대조 결과 기준 SHA는 그대로다. #79 댓글0·열린 PR0이며 DEV-023의 실제 공급에 대한 Design L2 수용은 확인되지 않았다. 따라서 P1 Session 공급·독립 자동검사·실제 패킷을 먼저 구현한다. 제품 main 활성화, Host/Map/P06/P07·씬 통합과 해당 GUI는 L2 수용 후 진행한다. DEV-026 구현·제품 검증 보류를 유지한다.


### 1.2 Design 회신 확인·가능한 후속 작업 지시 — 2026-11-15

> 개발 에이전트. 디자이너 에이전트가 원격저장소의 79번, 81번 이슈에 회신을 등록하였습니다. 해당 회신을 확인하여 작업할 수 있는 부분에 대해 후속작업 진행해주세요.

[#79 정본](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6885914882)과 [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6885920998)을 확인했다. 판정은 정적 검토 완료·기존 의미 수용 유지이며 **화면 통합 L2 최종 수용은 보완 후 PENDING**이다. 따라서 §1.1의 유효한 로컬 실행 권한으로 L2-01~04의 공급/증거/계획 보완을 진행한다. 원격 기록상 실행 권한 NOT_VERIFIED는 공개 원문 미게시 상태와 구별하며, 이미 받은 Owner 승인을 다시 요청하지 않는다.

최신 원격 main은 30cc2ea5f6e7c03aebff1315b6fd00530871ebec이며 PM-017 #126의 Q12/DEV-022 인수 기록을 확인했다. 최초 fetch의 FETCH_HEAD 쓰기가 샌드박스로 제한되어 승인된 읽기 목적 fetch를 권한 상승으로 재실행했고 성공했다. 로컬 base e379e58 대비 HQ5개·POST-MVP Planning3개만 변경됐고 제품/테스트/승인 MVP 의미/규칙/Design 파일 차이는 없다. 기존 dirty 작업과 원래 P1 증거를 보존하기 위해 브랜치/base/공용 main은 그대로 두었다. 최신 HQ 문서는 해당 원격 고정 SHA로 읽었으며 향후 Git 제출 전 동기화·preflight는 별도 제출 단계다.

이번 후속 변경은 승인23개 중 기존 P1의 동일12개 경로 안에서 테스트1개와 문서/증거7개 보완이다. 제품 소스는 이전 P1과 동일하며 화면/씬 통합은 아직 하지 않는다. Commit·Push·PR·main 병합·외부 댓글은 승인하지 않은 상태를 유지한다. DEV-026 구현·제품 검증 보류도 유지한다. 실제 제출 패킷과 행별 보완은 실행계획 §8, 결과서 §7을 따른다.


### 1.3 Owner 원격 PR 제출 승인 — 2026-11-15

> 개발 에이전트. 해당 구현 내용을 원격 저장소 PR로 생성해주세요

직전 로컬 검토 결과의 DEV-023 P1 공급·L2-01~04 보완 **12개 파일**을 원격 PR로 제출하라는 Owner 직접 지시다. wisberry2022/MetroManager / AGT-DEV-0004 / codex/DEV-023-operations-finance-ui → main을 대상으로, 이 패킷의 Commit·일반 Push·PR 생성과 필수 CI 확인 및 동일 제출 범위의 보완을 승인한 것으로 적용한다. 권한은 이번 제출 종료 또는 Owner 철회까지이며 별도 재확인을 요구하지 않는다.

main 병합·직접 쓰기·강제 Push·릴리스·배포, 별도 Issue 댓글/메시지·Issue 종료는 포함하지 않는다. 이번 Git 제출은 실제 화면 통합 L2 수용, DEV-023 전체 제품 인수 또는 Stage DONE 승인이 아니다. DEV-026 구현·제품 검증 보류를 유지한다.

제출 준비에서 fetch 후 최신 main 30cc2ea5f6e7c03aebff1315b6fd00530871ebec를 확인했다. 미공유 DEV-023 브랜치만 fast-forward하여 HQ5개/POST-MVP Planning3개를 포함했고, 동기화 직후 검토받은 12개 파일의 바이트/해시가 모두 동일함을 확인했다. 이후 변경은 본 승인·제출 기록과 manifest뿐이다. 검증 당시 base e379e58와 실행 증거는 이력으로 보존하며 실제 제출 parent/base는 최신 main이다.

### 1.4 Owner L2 후속 구현·PR 승인 — 2026-11-15

> 개발 에이전트. 디자이너 에이전트가 79번, 81번 이슈에 L2 회신을 등록하였으니 확인하여 작업할 내용이 있다면 작업에 착수해주세요. 작업 완료 후 PR까지 생성해주세요

[Design 정본](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6886354300) 및 [연결 회신](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6886360127)은 **L2-01~04 및 RFC L2-A/B/C ACCEPTED**다. 공급/표현/동선/연출 계획의 선행 조건은 해소됐고 실제 GUI 독립 수용은 별도다. PR #127은 main 3e2982ac71be28344c3be5360652f4071c678ce3에 병합됐으며 b18db70 제출 tree와 동일하다.

Owner의 이번 지시는 기존 §4 승인23개 경로 내 P3 화면 통합·P4 자동/프로젝트 로드/DEV 실제 GUI·결과 보완과 Commit·일반 Push·PR·필수 CI 확인을 포함한다. 대상은 wisberry2022/MetroManager / DEV-023 / AGT-DEV-0004 / codex/DEV-023-operations-screen-integration → main이며 이번 제출 종료 또는 Owner 철회까지다. main 병합·직접 쓰기·강제 Push·릴리스·배포·별도 Issue 댓글은 포함하지 않는다. DEV-026 구현·제품 검증 보류를 유지한다. 현재 승인 상태는 본 절이며 이전 PENDING/NOT_RUN/12개 제출 승인은 작성 시점 이력으로 보존한다.

## 2. 승인 근거와 적용 경계

모든 아래 경로의 이번 대조 기준 SHA는 위 main이다. 최신 커밋 자체를 승인으로 취급하지 않는다.

| 근거 | 승인/현재 의미 |
| --- | --- |
| [Gate 2 최종 승인](../../planning/PLN-001_GATE2_FINAL_APPROVAL.md), [C v0.7](../../planning/PLN-001-C.md), [D v0.9](../../planning/PLN-001-D.md), [DATA v1.4](../../planning/PLN-001_GATE2_DATA_v1_DRAFT.md) | OWNER_APPROVED. SEM-01~03/CLOSE-01, PLN-005 정식 개정 유지. 런타임 data_version 1.3과 문서 버전을 구별 |
| [PM-014 계획](../../hq/PM-014_STAGE2_VS01_EXECUTION_PLAN.md) | STAGE2_PLAN_OWNER_APPROVED / 개별 실행 권한 필요. Track A 최소 제품 UI, 고충실도 Track B 비차단 |
| [PM-016 인수표](../../hq/STAGE2_ACCEPTANCE_MATRIX.md) §4~5 | DEV-022→023→024→HQ/Owner 순서. #123 후 모델 진전은 본 결과에 연결하고 HQ의 과거 문구는 직접 수정하지 않음 |
| [PM-015 증거 재사용](../../hq/GUI_REVIEW_PROTOCOL.md) | 변경된 화면/포커스/상태 소비와 직접 영향 조건 검수. Q03~05·W05·OBS-01·Q12 기존 수용은 원래 범위로 재사용 |
| [DSG-002 결정 v0.2](../../design/tasks/DSG-002_UI_PRESENTATION_DECISIONS.md), [DEV-006 계약](../gate3/DEV-006_UI_DATA_CONTRACT.md) | UI-DC-01~07 정적 의미 수용. 신규 실제 W06 공급·정상/실패 fixture와 영향 화면 L2 수용은 별도 |
| [DEV-022 실제 공급](../gate3/DEV-022_W06_SUPPLY_AND_VALIDATION.md) / DEV022-W06-UI-1 | 합병된 실제 모델 계약, 자동검증·fixture 확보. Design L2 및 실제 GUI 인수는 미완료 |
| [DEV-026 Design 사전 의견](../../design/tasks/DSG-008_DEV026_L2_DESIGN_REVIEW.md) | 제안 방향 이견 없음/선행 결과 후 재대조. DEV-023 제작 승인이나 DEV-026 보류 해제 아님 |

## 3. 승인된 구현 범위 — 화면 통합은 L2 수용 후

- 제품 초기화에서 같은 Session의 W04A→W05→W06 공급을 명시적으로 활성화한다. 개통 전 일반승객/운임은 모델 판정대로 유지한다.
- P06: 영업/신규 탑승 허용·사유, 요청/탑승/미탑승·현재 이동 중·완료, 실제 운임·만족도와 기간/단위를 표시한다. 기존 예측은 소속 계획/기간을 명시해 실제 실적과 구별한다.
- P07: 현재 C/R/F/K/A/B·사업별 R/K, 당일 발생/즉시 지급/후정산·정부금/운임/기성, 선택 마감일의 고정 보고를 구별한다.
- S01: 운영 상태 요약, 실제 운영 노선의 경량 열차 이동·정차/승하차 피드백과 P06/P07 진입·복귀를 제공한다. 연출은 조회 사본만 소비한다.
- 첫 유효 실제 실적 보고 이후 기존 공고 조회 화면으로 이동한다. CLOSED/BUSY 등 기존 판정을 유지한다. 조회와 실제 새 수주는 별개다.
- 신규 소비 영역의 자료 없음/오류/실제0/낡은 관측, 키보드·포커스·스크롤, 기존 P01/P02/P05/S01 왕복의 직접 영향을 검증한다.

제외: 게임/경제/시간 정책 변경, 수동 운행 시작·중지/요금·정산 토글, 원장/시계/W06 모델 수정, 새 공고 회차·두 번째 수주, W04B/VS-02, 전체 VS-01 인수(DEV-024), 새 아트/폰트/픽셀·뷰포트·FPS 확정, 빌드/export·배포, DEV-025 실험, DEV-026 공통 root run_scope·전체 S01 guard·새 Session/View 재생성·20예외 일괄 적용. DEV-026 보류 때문에 신규 P06/P07의 필수 오류 처리를 생략하지 않는다.

## 4. Owner가 승인한 정확한 23개 경로

**제품·테스트 16개**, 문서·증거 **7개**, 합계 **23개**다. 준비 단계에서는 후보였으며 §1.1 승인으로 로컬 구현 범위가 확정됐다. 현재 P1에서 실제 변경한 것은 이 중 12개다. 나머지 화면/씬/GUI 경로는 L2 수용 후 적용한다. 동일 경로의 보완을 포함하고 추가 경로가 필요하면 이유·영향부터 검토한다.

| 경로 | 변경 책임 / 함수 제안 |
| --- | --- |
| `scripts/main.gd` | `_ready`: 제품 Session 구성 후 `enable_operations_ui` 호출·활성화 실패 가시화. DATA 초기화 실패 경계 보존 |
| `scripts/ui/stage1_session.gd` | `snapshot`의 새 소비 봉투, `enable_operations_ui`, `_operations_snapshot`, `_finance_snapshot`, `_next_business_snapshot`, `select_finance_report`, `query_next_business` 제안 |
| `scripts/ui/stage1_view.gd` | `_ready/present`, 화면 전환·복귀/포커스·운영 요약. 기존 `_render_finance/_render_activity`의 의미 보존 및 새 상세 연결 |
| `scripts/ui/stage1_map.gd` | `present/_draw`와 경량 운행 표현 helper. 계획선·운영선 분리, 기존 선택·목록 동등 조작 보존 |
| `scripts/ui/operations_view.gd` | 신규 P06 `present`·상태/단위·사유 렌더링과 이동 신호 |
| `scripts/ui/operations_view.gd.uid` | 위 신규 소스의 엔진 UID |
| `scripts/ui/finance_view.gd` | 신규 P07 `present`·현재/보고일·발생/지급 표시, 보고일/다음 조회/복귀 신호 |
| `scripts/ui/finance_view.gd.uid` | 위 신규 소스의 엔진 UID |
| `scenes/operations_panel.tscn` | P06 Control 연결 |
| `scenes/finance_panel.tscn` | P07 Control 연결 |
| `tests/game/run_operations_ui_tests.gd` | 신규 공급/소비·활성화·조회 무효과·회귀 반례 자동검사 |
| `tests/game/run_operations_ui_tests.gd.uid` | 위 신규 runner UID |
| `tests/game/operations_ui_fixtures.gd` | 실제 명령 기반 연결과 TEST_ONLY 소비/모델 반례를 명시적으로 분리 |
| `tests/game/operations_ui_fixtures.gd.uid` | 위 신규 fixture UID |
| `tests/game/run_operations_gui_cases.gd` | 검증 전용 GUI 입력 공급·로그. 실제 제품 경로와 분리, 결과 자동 합격 처리 없음 |
| `tests/game/run_operations_gui_cases.gd.uid` | 위 신규 GUI 도구 UID |

#79의 최초 후보에는 없던 `scripts/main.gd`와 fixture/GUI runner를 명시적으로 제안한다. 공통 Stage1View._ready에서 무조건 W06를 켜면 기존 W07의 set_fixture(arrival_fare 등)와 DEV-022의 혼용 거부가 충돌한다. 제품 부팅 경로의 명시적 활성화로 기존 격리 fixture를 보존하고, 실제 UI의 예외 상태를 재현하려면 분리된 fixture/runner가 필요하다. 준비 당시에는 후속 승인 요청이었으며, 지금은 §1.1의 승인 범위다. 화면 통합의 L2 조건은 유지한다.

문서·증거 7개:

1. `docs/engineering/tasks/DEV-023_W06_OPERATIONS_UI.md` — 본 범위/승인 기록.
2. `docs/engineering/gate3/DEV-023_UI_SUPPLY_AND_EXECUTION_PLAN.md` — 공급·실행/L2.
3. `docs/engineering/gate3/DEV-023_UI_VALIDATION_PLAN.md` — 검증 행·명령·기대값.
4. `docs/engineering/tasks/DEV-023_RESULT.md` — 실제 결과/미실행 이력.
5. `docs/engineering/tasks/DEV-023_PROVENANCE.json` — 실제 P1 변경 출처; 제출 전 최종 변경과 재대조.
6. `docs/engineering/gate3/DEV-023_UI_FIXTURES.json` — 실제 소비 패킷/분류/출처.
7. `docs/engineering/gate3/DEV-023_UI_VALIDATION.json` — 실제 입력·판정·소스/로그 해시·GUI 증거 색인.

캡처·실행 로그 원본은 우선 로컬 .local 아래에 보관한다. 공개 최소 증거를 새 경로에 추가할 필요가 생기면 포함 경로를 별도로 검토한다. 기존 소스 UID, `scenes/stage1.tscn`, 입찰/공사 View, 모든 기존 테스트, DATA/에셋/설정/정책/CI/타 부서 산출물은 읽기 전용이다.

## 5. 실행 순서·승인 경계

| 단계 | 종료 조건 | 현재 |
| --- | --- | --- |
| P0 준비 | 이 4개 Markdown과 실제 공급 대조·정책 검사 | OWNER_APPROVED |
| P1 소비 공급 | Session 어댑터·신규 자동검사·실제 정상/반례 패킷, 고정 소스 해시 | P1_SUPPLY_LOCAL_REVIEW; 실제 결과는 결과서 §6 |
| P2 L2 | RFC-DEV-023-01의 필드·문구·동선·경량 표현 영향 행을 Design과 대조. 최종 패킷 revision·판정 원문 연결 | STATIC_REVIEW_RECEIVED / 보완 패킷 LOCAL_REVIEW / 최종 L2 수용 대기 |
| P3 화면 통합 | 해당 영향 행 L2 수용 후 제품 부팅 활성화·P06/P07/S01·다음 조회 연결 | NOT_RUN |
| P4 검증 | 자동/프로젝트 로드/DEV 실제 GUI를 구별, 한 패킷으로 Design 독립 인수 요청 준비 | P1 자동·회귀·로드만 실행; 화면/실제 GUI NOT_RUN |
| P5 제출·후속 | 로컬 결과 Owner 검토→별도 Git 승인→PR/CI→별도 main 병합. DEV-024 전체 완주/HQ 인수 | NOT_RUN |

Owner §1.1이 승인한 실행 단위는 **위 23개 경로의 로컬 구현·테스트 작성·자동검사·Godot 프로젝트 로드·해당 GUI 검증·증거 작성**이며 화면 통합은 Design L2 수용 후다. 대상 저장소/브랜치/담당은 헤더와 같고, 해당 로컬 결과 검토 종료 또는 Owner 철회까지로 적용한다. 외부 전달과 Commit/Push/PR/main 병합·릴리스·배포는 별도다. Design L2는 영향 화면 통합 시 적용하며 독립 공급 준비를 전면 차단하지 않는다.

현재 새 기획 명세 변경 필요 없음. 디자인 실제 공급/표현 협의는 실행계획의 RFC에 한정한다. 모델 변경이 불가피하면 DEV-022 소유 범위의 정확한 변경·L3 회귀와 별도 승인을 먼저 제시한다. DEV-026 구현·제품 검증은 계속 **OWNER_IMPLEMENTATION_DEFERRED / NOT_RUN**이다.

## 6. P3 제출 현재 상태

현재 결과는 [결과서 §9](DEV-023_RESULT.md#9-design-l2-수용-후-p3-화면-통합-결과)와 검증 JSON의 p3_integration을 따른다. P2 공급 L2 수용과 제품 화면 구현은 완료하여 검토 요청한다. DEV 자체 GUI의 관측 범위만 PASS로 기록하며 Design 독립 GUI/DEV-024/HQ 인수·Owner DONE은 별도다. §5 표의 과거 NOT_RUN은 당시 이력이다. 실제 이번 변경은 승인23개 중 17개 경로이며 기존 P1 Session·fixture·공급 runner와 fixture JSON은 그대로다.
