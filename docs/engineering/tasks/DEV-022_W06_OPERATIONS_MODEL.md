# DEV-022 — W06 실제 운행 모델 착수 검토안

- 담당: Development Project Leader / LAPTOP / AGT-DEV-0004 / 2026-11-14.
- 상태: **OWNER_LOCAL_RESULT_ACCEPTED / GIT_SUBMISSION_APPROVED / MAIN_MERGE_PENDING**.
- 저장소: `wisberry2022/MetroManager`, [Issue #78](https://github.com/wisberry2022/MetroManager/issues/78).
- 기준 main: `3db401fc19b03e8719e4cccd741a8e1afe3df119`. 로컬 전용 브랜치: `codex/DEV-022-operations-model`.
- 연결: [공급·실행 계획](../gate3/DEV-022_W06_SUPPLY_AND_EXECUTION_PLAN.md), [검증 계획](../gate3/DEV-022_W06_VALIDATION_PLAN.md), [검토 결과](DEV-022_RESULT.md).

## 1. 현재 지시와 권한

Owner의 본 개발 대화 지시:

> PR #120의 main 병합을 승인합니다. DEV-026 구현·검증 보류 상태는 유지하고, 다음으로 DEV-022의 착수 범위와 실행·검증 계획을 준비해주세요.
>
> 그리고 원격 저장소에 HQ의 지시사항이 업데이트되었으니 확인하여 후속 진행 작업 착수 범위/실행검증 계획 준비해주세요

PR #120은 확인 시 이미 main 병합 완료였다. 병합을 중복 수행하지 않았으며 확인 결과는 결과서에 기록한다. 최초 준비 단계의 DEV-022 권한은 원격·승인 원본·소스 조사, 독립 로컬 worktree와 검토 문서 작성, 문서 정적/정책 검사다. 신규 제품/테스트 작성·Godot/게임 실행·Commit·Push·PR·이슈 댓글은 이번에 수행하지 않는다.

Owner는 앞서 “전환 효력 시각은 2026-11-14 17:37분, 티켓별 권한 이전은 OWNER가 모두 승인합니다”라고 지시했고 후임 임명을 확인했다. Asia/Seoul 기준 AGT-DEV-0004가 DEV-022 담당을 승계한다. #78의 AGT-DEV-0001은 작성 당시 기록으로 보존한다. 승계는 기존 유효 권한의 이전이며, #78에 없던 구현/Git 승인을 새로 만들지 않는다. [INF 전환 규정](../../infra/agents/REGISTRY_TRANSITION_RULES.md)에 따라 `REGISTRY_RECORD_PENDING`만으로 작업을 막거나 담당 승계를 재승인 요청하지 않는다. 최신 [INF-010 PR #121](https://github.com/wisberry2022/MetroManager/pull/121)은 이 사건의 등록 후속 실행자를 Owner 위임의 AGT-INF-0002로 갱신해 제출했으며 확인 시 OPEN/미병합이다. 등록부 main 반영 완료로 표시하지 않으며 이 DEV 티켓에서 INF 파일이나 #121 병합을 처리하지 않는다.

### 1.1 Owner 로컬 구현·검증 승인 — 2026-11-14

> DEV-022의 착수 범위와 실행·검증 계획을 승인합니다. 검토안에 명시한 범위로 구현·검증을 진행하고, 로컬 결과부터 검토 요청해주세요. Commit·Push·PR과 main 병합은 별도 승인하겠습니다. DEV-026 보류는 유지합니다.

이 후속 지시는 아래 18개 경로의 로컬 구현·테스트·자동검증·Godot 로드·문서 증거 작성과 동일 범위 보완을 승인한다. 대상은 wisberry2022/MetroManager, DEV-022, AGT-DEV-0004, codex/DEV-022-operations-model이며 이번 로컬 수용 검토 종료 또는 Owner 철회까지 적용한다. Commit·Push·PR·main 병합·외부 회신·릴리스·배포는 제외한다. DEV-026 구현·제품 검증 보류를 유지한다.

실행 기준은 최신 main 2507cda419ed27e96c5d64ced7666ed7a2e58227이다. 초기 준비 기준 이후 INF-010 등록 파일3개만 변경돼 제품/명세 차이는 없다. 기존 검토안을 보존한 로컬 작업 브랜치만 fast-forward했고 커밋 생성/main 변경은 없다. PR #121 main 반영으로 AGT-DEV-0004의 상태는 REGISTRY_RECORDED이며 17:37 업무 효력은 바뀌지 않는다.

### 1.2 Owner 로컬 결과 수용·Commit/Push/PR 승인 — 2026-11-14

> DEV-022 로컬 구현·검증 결과를 승인합니다. 승인된 18개 파일을 codex/DEV-022-operations-model 브랜치에 Commit·Push하고 PR을 생성한 뒤 필수 CI 결과까지 확인해주세요. main 병합은 별도 승인하겠습니다. DEV-026 보류는 유지합니다.

대상은 `wisberry2022/MetroManager` / DEV-022 / AGT-DEV-0004 / `codex/DEV-022-operations-model` → base `main`이다. 아래 승인18개 파일의 정상 훅 Commit·일반 Push·PR 생성·필수 CI 확인과 동일 범위 제출 기록/검수 대응을 이번 제출 종료 또는 Owner 철회까지 허용한다. 기존 로컬 수용/실행 증거는 보존하고 이번 승인 기록과 출처 manifest만 갱신한다. 제품/테스트의 승인된 구현은 바꾸지 않는다.

제출 준비 기준 main은 `f13b97d4871e8c73452134fb64c06e1fc919d779`다. 검증 기준 `2507cda` 이후 변경은 PR #122의 Design DEV-026 사전 의견 문서2개뿐이며 제품·테스트·명세 변경은 없다. 해당 의견은 선행 DEV-022~025 후 재대조이며 DEV-026의 구현·검증 보류를 해제하지 않는다.

main/자동 병합·강제 push·릴리스·배포·브랜치 삭제·별도 이슈 댓글/부서 메시지는 포함하지 않는다. PR 생성/필수 CI 통과를 DEV-023/024 GUI·Design 독립 인수·HQ 통합·Owner Stage DONE으로 확대하지 않는다. 앞 절의 Git 권한 대기는 이번 명시적 승인으로 갱신되며 main 병합은 계속 별도다.

## 2. HQ 지시 반영과 착수 경계

[PM-016 최신 인수표](../../hq/STAGE2_ACCEPTANCE_MATRIX.md) §4~5에 따라 실제 잔여는 DEV-022 모델 → DEV-023 최소 운영·재무 UI → DEV-024 실제 VS-01 완주 → HQ 통합/Owner 최종 인수다. 기존 Q03~05 Design 수용, W05·OBS-01·Q12의 한정 수용을 재사용한다. Q12 상위 PARTIAL과 하위 증거 색인 대조는 보존하되 전체 모델 착수 차단이나 반복 GUI로 확대하지 않는다.

- **포함:** 유효 W04A 사업/정부 지급과 W05 개통의 권위 ID 연결, 실제 OD 요청·탑승·미탑승·이동 중·완료, 공유 U10·소수 이월, 도착 운임, 서비스 구간 비용, B 자동 정산·재개, 만족도, 현재/고정 일일 보고, 첫 유효 실제 보고 후 다음 공고의 읽기 전용 조회 공급.
- **단계 경계:** DEV-022는 실제 W04A/W05 명령 경로를 자동 실행해 W06 모델 연결을 입증한다. 제품 Session의 활성화·화면/조작 연결은 DEV-023이다. 이 분리는 게임 플레이 완료나 DEV-024 완주를 대신하지 않는다.
- **제외:** 새 게임/경제 정책, 요금 편집·수동 운행 시작/중지, 복수 사업 실제 수주, W04B/VS-02, POST-MVP 회사 상태/파산, 데이터·씬·UI·에셋·프로젝트 설정·정책/CI·타 부서 파일 변경.
- **후속 유지:** DEV-025의 격리 F-08 실험과 DEV-026의 S01 예외 계약 적용은 별도 티켓이다. Owner가 정한 DEV-022~025 선행 순서를 유지하되 F-08 최종 규격을 모든 최소 기능의 새 선행조건으로 만들지 않는다. DEV-026 구현·제품 검증은 계속 보류한다.

승인 의미는 [Gate 2 최종 승인](../../planning/PLN-001_GATE2_FINAL_APPROVAL.md), C v0.7/D v0.9/DATA v1.4, SEM-01~03/CLOSE-01, [PLN-005 정식 개정](../../planning/tasks/PLN-005_RESULT.md)을 따른다. 승인 명세 버전과 런타임 `data_version: "1.3"`은 구별하며 이번 계획에 데이터 버전 교체를 넣지 않는다.

## 3. Owner가 후속 승인한 정확한 실행 경로

아래 **제품·테스트 10개 경로**는 최초 계획의 제안 목록이며 §1.1 승인 후 구현·검증했다. 같은 경로의 검수 수정은 포함하되 새 파일·새 공통 정책이 필요하면 차이와 영향을 보고한다.

| 경로 | 변경 함수/책임 제안 |
| --- | --- |
| `scripts/model/operating_line.gd` | 신규 OperatingLine: 권위 계약/노선 식별, OD carry·이동 cohort·일별 집계·만족도 상태. 공개 함수 제안은 공급 계획 §2. |
| `scripts/model/operating_line.gd.uid` | 위 소스 UID, 엔진 생성값 보존 |
| `scripts/simulation/operations_service.gd` | 신규 OperationsService: 원본 연결 검증, 단계별 운행 처리, 현재/보고/다음 조회 공급 |
| `scripts/simulation/operations_service.gd.uid` | 위 소스 UID |
| `scripts/simulation/minute_pipeline.gd` | 신규 `enable_operations`, 조회 wrapper; 기존 `_tick/snapshot/set_fixture/_valid_fixture`의 활성화 분기·실제 공급 연결. SEM 순서·비활성 기존 동작 보존 |
| `scripts/model/daily_ledger_report.gd` | 신규 `sync_operations`, 기존 `sync/close/current/report`의 운행 집계 병합·deep copy·마감 불변 처리. 기존 재무 필드 의미 보존 |
| `tests/game/run_w06_tests.gd` | 신규 W06 수용/반례·정상 명령 연결·분할 동등성·실패 종료코드 검사 |
| `tests/game/run_w06_tests.gd.uid` | 위 테스트 UID |
| `tests/game/w06_fixtures.gd` | 신규 실제 명령 시나리오 빌더와 명시적 TEST_ONLY 경계 입력. 제품에 fixture 진입점 추가하지 않음 |
| `tests/game/w06_fixtures.gd.uid` | 위 fixture UID |

문서/증거는 아래 8개 경로다. 최초 준비에는 앞의 Markdown 4개만 있었으며 실행 후 실제 공급·검증·fixture·출처를 추가했다.

1. `docs/engineering/tasks/DEV-022_W06_OPERATIONS_MODEL.md`
2. `docs/engineering/gate3/DEV-022_W06_SUPPLY_AND_EXECUTION_PLAN.md`
3. `docs/engineering/gate3/DEV-022_W06_VALIDATION_PLAN.md`
4. `docs/engineering/tasks/DEV-022_RESULT.md`
5. `docs/engineering/tasks/DEV-022_PROVENANCE.json`
6. `docs/engineering/gate3/DEV-022_W06_SUPPLY_AND_VALIDATION.md`
7. `docs/engineering/gate3/DEV-022_W06_VALIDATION.json`
8. `docs/engineering/gate3/DEV-022_W06_FIXTURES.json`

`company_ledger.gd`와 `demand_predictor.gd`는 #78의 수정 가능 후보였으나 현재 공개 API로 재사용 가능하므로 **읽기 전용**으로 좁힌다. GameClock/CommandQueue/Network/RoutePlan, W04A/W05 공급, 기존 테스트와 Stage1Session/View/Map도 읽기 전용이다. 구현 중 재사용 불가가 입증되면 정확한 추가 함수·경로·회귀를 제시하며 조용히 범위를 넓히지 않는다. .local의 로그·엔진 캐시는 Git 산출물에서 제외한다.

## 4. 실행 순서와 승인 범위 제안

| 단계 | 수행·종료 조건 | 현재 상태 |
| --- | --- | --- |
| P0 준비 | 최신 main/HQ/승계 대조, 정확한 경로·함수·공급·L3·검증 계획 로컬 작성 | 이번 작업 |
| P1 모델 | 권위 W05 연결, OD/carry/cohort, 단위 반례. 아직 UI 연결 없음 | IMPLEMENTED |
| P2 통합 | 실제 Pipeline 단계·원장 API·자정 보고·다음 조회 공급, 실제 W04A→W05→W06 자동 연결 | IMPLEMENTED / AUTO PASS |
| P3 검증 | W06 전체 및 공통 영향 회귀, 프로젝트 로드, 공급/fixture·L3 결과·증거 작성 | PASS / LOCAL_REVIEW |
| P4 제출 | 승인된 정확한 diff·출처·정책 검사, Commit·일반 Push·PR·필수 CI | NOT_RUN / 별도 Git 권한 필요 |
| P5 후속 | DEV-023 화면 통합 전 Design L2, DEV-024 실제 GUI 완주, HQ/Owner 인수 | 후속 티켓 |

§1.1에서 승인된 실행 단위는 위 **18개 경로의 로컬 구현·테스트 작성·자동검증·Godot 로드·문서 증거 작성**이다. 범위는 이번 DEV-022 로컬 수용 검토 종료 또는 Owner 철회까지다. 실제 실행 전 최신 main과 계획의 차이를 대조했다. 해당 구현 승인을 Git 승인으로 확대하지 않으며 Commit·Push·PR·main 병합은 미실행이다. force push·릴리스·배포·외부 댓글/메시지도 포함하지 않는다.

실제 함수·필드와 검증 결과는 [공급 인계](../gate3/DEV-022_W06_SUPPLY_AND_VALIDATION.md), [실행 증거](../gate3/DEV-022_W06_VALIDATION.json), [결과서 후속 기록](DEV-022_RESULT.md)에 정리한다. 앞의 원격/권한 대기 기록은 최초 준비 시점의 이력이며 후속 승인·REGISTRY_RECORDED·실제 검증 결과와 구별한다.

현재 새 기획 의미 결정은 필요하지 않다. 정확한 해석 충돌이나 범위 변경이 발견되면 [RFC 양식](../../templates/RFC_AND_DECISION.md)에 조건·현재 근거·대안·차단 대상만 보고한다. 기존 승인 정책의 재선택이나 전체 일정 중단을 요구하지 않는다.
