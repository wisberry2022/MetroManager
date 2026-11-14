# DEV-026 — DSG-008 후속 계약·적용 범위 검토 티켓

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

Agent-ID: AGT-DEV-0004
Task-ID: DEV-026
