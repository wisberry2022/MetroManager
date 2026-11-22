# DEV-027 — W04B·VS-02 착수 계획 및 문서 제출 티켓

> **2026-11-22 문서 Git 제출 후속:** §12의 Owner 승인에 따라 이번 문서7개만 지정 브랜치에 Commit·Push·PR 제출한다. P3-B 구현·검증/Track A·B L2/DI03·main 병합 대기는 유지한다. 앞선 Git 미승인·미제출 표시는 당시 기록이다.


> **2026-11-22 P3-A 수용·P3-B 계획 후속:** Track A 공급 L2 한정 수용·Track B 정적 이견 없음을 마지막 후속 절에 연결한다. [화면 계획](../gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md)은 이번 문서7개와 미래 실행19개를 구분한다. 실제 화면 통합은 계획에 포함하되 구현·게임 검증·Git/GUI·DI03 보류는 유지한다. 앞선 상태/증거는 당시 이력이다.


> **2026-11-22 Git 제출 후속:** §10에 Owner의 지정 브랜치 Commit·Push·PR 및 필수 CI 확인 승인을 기록한다. 기존 로컬 시험 원본은 보존하며 main 병합·DI03·L2 전 화면 통합·독립 심사 대기는 유지한다.

> **2026-11-22 P3-A 구현 후속:** 승인된 Session·Pipeline 연결과 L2 공급 준비의 로컬 검토 결과는 문서 마지막의 P3-A 후속 절을 따른다. 앞선 미실행/미승인 문구는 당시 기록이다. DI03·L2 전 화면 통합·Git/최종 인수 대기는 유지한다.

> **2026-11-22 현재 후속:** §8은 #92·#146에 따른 **다음 P3-A 착수안의 로컬 작성 권한**이다. [계획](../gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md)은 실제 문서5개와 미래 실행22개를 분리한다. P1 병합 완료·DI03 구현 대기·L2 전 화면 통합 대기를 유지하며 새 제품 실행/Git 권한은 없다. 아래 승인/실행 기록은 원 범위로 보존한다.

> **2026-11-22 P1 최신 후속:** §7은 Owner가 승인한 비의존 모델 로컬 구현·검증 범위다. **LOCAL_REVIEW / GIT_SUBMISSION_NOT_AUTHORIZED**. DI-03 종속 범위·L2 전 화면 통합과 DEV-026 한정 수용/PARTIAL·S3-12 인수 대기는 유지한다. 아래 과거 기록은 당시 이력으로 보존한다.

> **PM-021 최신 후속 — 2026-11-21:** §6이 현재 **LOCAL_REVIEW / TRACK_B_COMMON_TABLE_REVIEW_PENDING / GIT_SUBMISSION_NOT_AUTHORIZED** 상태를 설명한다. O01~07 방향 승인·DEV026 현재 공급/P07 수용은 유효하다. 아래 과거 제출·미실행·선택 대기는 당시 이력으로 보존한다. 이번 작업은 기존 DEV027 문서4개 로컬 보완·정적 검사다.

> **현재 후속 — 2026-11-21:** PR #149 병합 후 #146 Design 사전 의견을 반영한 문서 보완이다. 제출 base는 `de0f03f9d2fcc301940a4176f1359b2788a51950`, 브랜치는 `codex/DEV-027-design-plan-followup`이며 현재 권한·결과는 §5을 따른다. 앞선 제출 식별·검증은 PR #149 당시 기록으로 보존한다. 제품 구현·실행·최종 L2·main 병합은 별도 대기다.

- 담당: Development / AGT-DEV-0004 / 2026-11-21 (Asia/Seoul).
- 문서 제출: **OWNER_DOCUMENT_PR_REQUESTED / PLAN_REVIEW**.
- 제품 작업: **IMPLEMENTATION_AUTH_PENDING / PRODUCT_VALIDATION_NOT_RUN**.
- 기준 main: `f047edbf67a6f888eda5eed24309b78554b3c2ed`.
- 이번 문서 브랜치: `codex/DEV-027-stage3-start-plan` → base `main`.
- [착수·실행/검증 계획](../gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md) / [결과서](DEV-027_RESULT.md) / [출처 기록](DEV-027_PROVENANCE.json).
- 연결: PM-020 / PLN-013 / [#146](https://github.com/wisberry2022/MetroManager/issues/146) / DEV-026 [#104](https://github.com/wisberry2022/MetroManager/issues/104).

## 1. Owner 요청과 효력

최초 요청은 W04B·DEV-026 착수 범위·실행/검증 계획을 이슈에 등록하는 것이었다. 그 결과인 [#148](https://github.com/wisberry2022/MetroManager/issues/148)의 본문은 보존한다.

### 후속 요청 — 2026-11-21 / 본 개발 대화

> 개발 에이전트. 미안합니다. 이슈를 철회하고 해당 이슈의 내용을 로컬 산출물로 변환하여 원격 저장소에 PR을 생성해주세요

이 요청에 따라 #148을 **CLOSED / not_planned(이슈 제출 방식 철회)**로 전환하고 내용은 개발 문서 PR로 옮긴다. [원격 전환 기록](https://github.com/wisberry2022/MetroManager/issues/148#issuecomment-7053231691)에 연결했다. 작업 취소/DONE이나 기획·디자인 계약 수용으로 처리하지 않는다.

현재 PR 생성 요청은 **아래 문서4개의 로컬 작성/정적 검사·정상 훅 Commit·일반 Push·PR 생성·필수 CI 확인**을 허용하는 지시로 적용한다. #148 및 기존 #146/#104의 후속 연결도 제출 방식 전환에 포함한다. 이는 앞선 문서 Git 보류만 갱신하며 **제품 구현·게임 실행/실험·미래 구현 산출물 제출·main 병합은 승인하지 않는다**.

- 대상: `wisberry2022/MetroManager` / DEV-027 / AGT-DEV-0004.
- 브랜치: `codex/DEV-027-stage3-start-plan`, base `main`.
- 기간: 이번 문서 PR 제출·동일 범위 검수 대응 종료 또는 Owner 철회까지.
- 제외: 제품/씬/데이터/게임 테스트, 타 부서 문서, 정책/CI/훅/도구, 강제 Push·직접 main 수정·병합·auto-merge·릴리스/배포.
- 원문 진위/인사·최종 승인은 문서 자체나 CI가 인증하지 않는다.

## 2. 이번에 제출할 정확한4개 경로

| 경로 | 내용 |
| --- | --- |
| `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md` | 본 티켓, Owner 후속 요청·문서 제출 권한·현재/미래 범위 |
| `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md` | #148의 PM-020/PLN-013/#146 대조·DI-01~03·RFC·정확한 경로·통합 순서·검증 계획 |
| `docs/engineering/tasks/DEV-027_RESULT.md` | 변환 범위·원본 식별·문서 검증·실행 NOT_RUN·미해결 |
| `docs/engineering/tasks/DEV-027_PROVENANCE.json` | 위3개 Markdown의 제출 base·blob·Agent-ID·출처 선언 |

계획의 DEV-027 41개·DEV-026 24개(공통2개, 고유63개)는 **미래 구현 승인 후보**다. 위4개만 이번에 추가하며 이4개는 원래 DEV-027 후보41개 안에 있다. DEV-026 기존 문서/증거와 제품 코드는 수정하지 않는다.

## 3. 제품 단계에서 유지할 검토 경계

- W04B·VS-02는 DEV-027로, 공통 UI 안정성은 기존 DEV-026으로 유지한다.
- DEV-026은 PM-020의 **STAGE3_SCOPE_CONFIRMED / IMPLEMENTATION_READINESS_PENDING**이다. 과거 HOLD를 무기한 제외로 해석하거나 편입 승인을 반복 요청하지 않는다. 실제 구현·제품 검증·수용은 아직 미실행이다.
- DI-01 접수/효력·잠금·사업 계보, DI-02 정상 RNG·seed·추출 순서, DI-03 E01 실제 수요 연결을 계획에 담았다.
- RFC-DEV-027-01은 대상 동/OD와 추가 발생/중첩 의미의 Planning 확인 대기다. 새 정책 필요는 아직 확정하지 않으며 종속 부분만 보류한다.
- DEV-026 공통 계약/변경→DEV-027 실제 공급→해당 UI L2 수용→순차 통합→최종 VS-02 시험본 순서를 유지한다.
- 자동/소비 fixture/DEV 실제 GUI/독립 실행/Design 심사·HQ/Owner 최종 인수를 분리한다. 기존 PASS·한정 수용·원본 정정·미확인을 보존한다.

## 4. 이번 문서 제출 종료 조건

원래 계획의 의미/변경 후보/승인 경계를 보존한 로컬 문서4개를 검증하여 PR로 제출하고, 실제 head의 `policy`·`department-policy`를 확인한다. #148 철회와 #146/#104의 대체 PR 연결을 확인한다. 문서 제출 완료는 구현 계획의 최종 승인이나 제품 DONE이 아니다.

## 5. PR #149 병합·Design 회신 후 문서 보완 권한 — 2026-11-21

Owner의 이번 개발 대화 요청:

> 149 PR이 main에 머지되었습니다. 당신의 계획서를 읽고 디자이너 에이전트가 146번 이슈에 코멘트를 등록하였으니 확인하여, DEV-027,026에서 수정해야할 부분이 있다면 수정하여 PR 생성해주세요

[PR #149](https://github.com/wisberry2022/MetroManager/pull/149)의 병합 main `de0f03f9d2fcc301940a4176f1359b2788a51950`와 제출 head `d098d47e32159e5438aff7d702ff19f2c5d37d0f`의 tree가 같음을 확인했다. 최초 문서 PR 제출/CI 기록은 이전 결과로 보존한다.

- 이번 브랜치: `codex/DEV-027-design-plan-followup` → `main`.
- 허용: §2의 동일한 개발 문서4개 수정·문서 정적 검사·정상 Commit·일반 Push·PR·실제 head 필수 CI 확인. 기간은 이번 보완 PR 및 같은 문서 검수 대응 종료/Owner 철회까지.
- 근거: [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053550740)·[Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053570152)의 사전 이견 없음과 실제 공급/L2 PENDING 구분.
- 제외: 제품/게임 테스트·실험, 후보41개 구현, DEV-026 제품 변경, 정책/CI·타 부서 문서, main 병합/릴리스. 제품 구현·실행 및 미래 구현 Git 권한은 별도다.
- DEV-026 자체 문서5개는 별도 `codex/DEV-026-design-plan-followup` PR로 처리한다. 현재 PR에는 섞지 않는다.

계획 §3·4.2·7.3·11에 사전 의견/실제 수용 상태, 제출 사본·초안, 실제 공급/증거 항목, 종속 부분만의 차단을 반영했다. 후보 경로41/24개는 그대로이며 새 정책·수치·Stage DONE을 선언하지 않는다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 6. PM-021 적용표·착수 상태 후속 — 로컬 검토

- Owner 현재 요청: “개발 에이전트 HQ로부터 신규 지시사항(PM-021)이 발생했으니 확인하여 followup 해주시기 바랍니다”.
- 근거: [개발 요청](../../hq/requests/PM-020_DEVELOPMENT_STAGE3.md), [Owner O01~07 결정](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335), [DEV026 한정 수용](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7057161624).
- 기준 main: `fa968b94641d24e8d68b3c6cb903f9e809d02814` / [PR #159](https://github.com/wisberry2022/MetroManager/pull/159). 로컬 브랜치 `codex/DEV-027-pm021-application-plan`.
- 상태: **LOCAL_REVIEW / TRACK_B_COMMON_TABLE_REVIEW_PENDING / GIT_SUBMISSION_NOT_AUTHORIZED**. 기존 §2의 정확한4개만 수정. 공통표는 [계획 §12](../gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md#12-pm-021-후속--f-08-공통-적용표의-dev-검토안)에 한 번 작성하고 티켓/결과에서 참조.
- 포함: 제품/격리 실험 대조, 승인7행·M01~05 재사용/변경0·공백·경로·최소 검증/권한, 폰트 후보 공식 자료, W04B/DEV026 최신 상태, 복사 전달문. DEV025 원시·Design 원문·DEV026 증거·과거 계획 보존.
- 제외: 제품/게임 테스트·데이터·폰트/아트 반입·새 실험, 타 부서/정책/CI 수정, 원격 댓글/Issue 변경, Commit·Push·PR·main 병합. 과거 제출 승인은 당시 PR 범위로 보존.
- 종료 신호: 문서/출처·링크·기존41개 후보 보존 검증과 로컬 검토 요청. DEV 준비를 공동 수용/S3-10-A 완료로 선기록하지 않음.

DEV027 P1 구현·검증은 별도 승인 대상이다. DI03 대상/반복 효과 종속 행과 실제 UI L2는 남고 비의존 모델에 Design 추가 차단은 없다. DEV026은 이미 구현·검증·현재 공급 한정 수용됐으며 과거 HOLD/전체 NOT_RUN으로 되돌리지 않는다. 분담 수용·미래 W04B·S3-12/Stage·원본 PARTIAL은 보존한다. F08 검토를 기존41개 제품 후보 확대나 종료 DEV025 재개로 사용하지 않는다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 7. P1 비의존 모델 로컬 구현·검증 승인 — 2026-11-22

Owner의 본 개발 대화 승인 원문:

> DEV-027 P1 비의존 모델의 로컬 구현·검증 착수를 승인합니다. 계획서 범위로 진행하고 로컬 결과부터 검토 요청해주세요. DI-03 종속 범위와 Design L2 수용 전 화면 통합은 대기하고, Commit·Push·PR·main 병합은 별도 승인하겠습니다. DEV-026 한정 수용·PARTIAL과 S3-12 최종 인수 대기는 유지합니다.

- 상태: **P1_LOCAL_IMPLEMENTATION_AUTHORIZED / LOCAL_REVIEW**. 아래 과거 승인 대기/문서 제출 기록은 당시 범위로 보존한다.
- 기준 main `1a941196cc6d963db93a9fba6a0386b16710aa46`, 독립 worktree·브랜치 `codex/DEV-027-w04b-p1-model`. shared root의 기존 데이터2개 수정은 보존하고 가져오지 않았다.
- 허용: P1 순수 모델·정상 RNG seed 탐색·자동 경계·재사용 모델 회귀·프로젝트 로드·로컬 문서화. Commit/Push/PR/main 병합·원격 댓글은 포함하지 않는다.
- 정확한 변경은 기존41개 후보 중 **20개: 제품9 + 테스트4 + 문서/증거7**. 기존3개 Markdown은 후속 기록만 추가한다. 기존 provenance는 [base 원본](https://github.com/wisberry2022/MetroManager/blob/1a941196cc6d963db93a9fba6a0386b16710aa46/docs/engineering/tasks/DEV-027_PROVENANCE.json)에 보존하고 이번 변경19개 내용 식별자를 갱신한다.

| # | 정확한 변경 경로 |
| --- | --- |
| 1 | `assets/data/stage3_proposals_v1_4.json` |
| 2 | `scripts/data/proposal_data_loader.gd` |
| 3 | `scripts/data/proposal_data_loader.gd.uid` |
| 4 | `scripts/model/company_proposal.gd` |
| 5 | `scripts/model/company_proposal.gd.uid` |
| 6 | `scripts/simulation/proposal_service.gd` |
| 7 | `scripts/simulation/proposal_service.gd.uid` |
| 8 | `scripts/simulation/business_sources.gd` |
| 9 | `scripts/simulation/business_sources.gd.uid` |
| 10 | `tests/game/w04b_fixtures.gd` |
| 11 | `tests/game/w04b_fixtures.gd.uid` |
| 12 | `tests/game/run_w04b_tests.gd` |
| 13 | `tests/game/run_w04b_tests.gd.uid` |
| 14 | `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md` |
| 15 | `docs/engineering/tasks/DEV-027_RESULT.md` |
| 16 | `docs/engineering/tasks/DEV-027_PROVENANCE.json` |
| 17 | `docs/engineering/gate3/DEV-027_W04B_SUPPLY_CONTRACT.md` |
| 18 | `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md` |
| 19 | `docs/engineering/evidence/DEV-027_W04B_VS02_RESULTS.json` |
| 20 | `docs/engineering/evidence/DEV-027_W04B_VS02_EVIDENCE.md` |

결과는 [결과서 §7](DEV-027_RESULT.md#7-p1-비의존-모델-로컬-결과--2026-11-22), API/실제 공급 경계는 [P1 공급 계약](../gate3/DEV-027_W04B_SUPPLY_CONTRACT.md), 명령·해시·잔여는 [증거 색인](../evidence/DEV-027_W04B_VS02_EVIDENCE.md)에 연결한다.

제외·보존: DI-03 대상/반복 효과·실제 E01 생성/수요/소비, Session/Pipeline/화면 통합, Design L2·독립 실행·VS-02, DEV-026 변경, 타 부서·원본 데이터2개·정책/CI/도구/설정, 최종 폰트/아트·지원 조건·빌드/export. DEV-026 한정 수용·PARTIAL과 S3-12 최종 인수 대기 유지. 검증 PASS는 전체 DEV-027 DONE이 아니다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 8. #92·#146 후속 착수안 로컬 준비 — 2026-11-22

Owner의 본 개발 대화 요청 원문:

> 개발 에이전트. 92번·146번 이슈의 회신을 반영하여 DEV-027의 다음 착수 범위와 실행·검증 계획을 로컬로 준비해주세요. Session·Pipeline 연결과 L2 공급 준비, 미공급 입력을 구분하고 DI-03 종속 범위와 L2 전 화면 통합 대기는 유지해주세요. 구현·검증 및 Commit·Push·PR은 별도 승인하겠습니다.

상태는 **LOCAL_PLAN_REVIEW / IMPLEMENTATION_VALIDATION_NOT_AUTHORIZED / REMOTE_NOT_SENT**다. 허용은 정본/코드/댓글 정적 대조·로컬 계획 작성·문서 검수다. 제품 구현·게임 자동/로드·GUI·seed 탐색·계측/반입·원격 게시·Commit/Push/PR/main 병합은 이번 범위가 아니다.

- 기준 main `97cc5472f11a97d5f7d7c1b89dc12edeace36e1f`, 독립 브랜치 `codex/DEV-027-session-pipeline-plan`.
- [#146 DEV 회신](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7072796715), [#92 NR/DA 회신](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7072852286), PR168/NR/DA를 근거로 한다.
- P1의 20개 Commit/Push/PR은 이후 Owner가 승인했고 PR166으로 main에 병합된 사실을 연결한다. §7/과거 결과의 미커밋·Git 대기는 당시 기록이다. 다음 Session/Pipeline·화면 권한으로 확대하지 않는다.
- 이번 정확한5개 파일:

| 종류 | 경로 |
| --- | --- |
| 신규 | `docs/engineering/gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md` |
| 수정 | `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md` |
| 수정 | `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md` |
| 수정 | `docs/engineering/tasks/DEV-027_RESULT.md` |
| 수정 | `docs/engineering/tasks/DEV-027_PROVENANCE.json` |

기존 Markdown3개는 전체 원문을 보존하고 안내/후속을 추가한다. 이전 provenance는 [기준 main 원본](https://github.com/wisberry2022/MetroManager/blob/97cc5472f11a97d5f7d7c1b89dc12edeace36e1f/docs/engineering/tasks/DEV-027_PROVENANCE.json)에 보존한다. 이번 manifest는 실제 Markdown4개의 출처/blob 선언이며 신원·승인 인증이 아니다.

[상세 계획 §7.2](../gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md#72-다음-p3-a-실행-후보--최대22개--현재-미승인)의 최대22경로는 **미래 실행 제안**이다. 새 명령/사업·공유 시간/원장·W05/W06 연결과 화면 없는 L2 표본의 자동/로드가 다음 승인 검토 대상이다. 추가 ConstructionProject/guard 경로·신규 증거를 숨기지 않는다.

DI03 정책 결정 완료와 구현·검증 보류를 구별한다. 화면/씬/main 진입·E/F/N·폰트/아트·자연 VS02·독립 심사는 제외하며 필요한 해당 L2와 별도 권한 뒤 진행한다. 원래 F08 검토 worktree의6문서·공유 main의 데이터2개·기존 증거/타 부서 파일을 보존한다. 원격 전달이나 전체 DONE은 이번 종료 조건이 아니다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 9. P3-A 로컬 구현·검증 승인과 제출 — 2026-11-22

> Owner 승인 원문 — 본 개발 대화, 2026-11-22 KST
>
> DEV-027 P3-A의 착수 범위와 실행·검증 계획을 승인합니다. 계획서의 최대 22개 경로 안에서 Session·Pipeline 연결과 L2 공급 준비를 구현·검증하고, 로컬 결과부터 검토 요청해주세요. DI-03 종속 범위와 L2 전 화면 통합 대기는 유지하며, Commit·Push·PR·main 병합은 별도 승인하겠습니다.

**LOCAL_IMPLEMENTATION_REVIEW / L2_INPUT_SUPPLIED_LOCALLY / L2_ACCEPTANCE_PENDING / GIT_NOT_AUTHORIZED**.

- base `97cc5472f11a97d5f7d7c1b89dc12edeace36e1f` + [실행 소스 SHA256](../evidence/DEV-027_SESSION_PIPELINE_L2_RESULTS.json). 실제 변경 **22개 = 제품8 + 검사6 + 문서·증거8**. 목록은 상세 계획 §7.2를 그대로 따른다.
- 모델/Session/자동 연결 **677개**, 영향 회귀 **3204개** 정상 통과. 프로젝트 로드 오류0, 새 runner2개의 고의 실패 exit1 검출. 자동 검사는 GUI·자연 VS02·Design/독립 수용이 아니다.
- 실제 Session opt-in·공유 시계/원장, 마감 뒤 심사·CONTRACT 지급 분리, 허가 사본/지급→공사→실제 운행/첫 보고/후보 조회를 연결했다. W04A 기존 기본 진입과 뒤늦은 W04B 활성화를 검사했다.
- `proposal_ui`/지역 guard 및 L01~10 실제 출력·오류/표시 fixture를 [L2 색인](../evidence/DEV-027_SESSION_PIPELINE_L2_EVIDENCE.md)에 준비했다. main/View·화면 호출은 추가하지 않았다.
- DI03 생성·×5/4 수요/소비/재접수, 이름12행/실제 loader·폰트·환경·아트 적용은 미실행. PLN016 A1+B1 결정 완료를 보존하며 정책 미답변으로 되돌리지 않는다.
- DEV026 한정 수용·PARTIAL/미관측·P07 구분, #92/F08 FINAL_SPEC_PENDING, S3-10-C·S3-12/HQ·Owner 최종 인수 대기를 유지한다. 신규 게임 명세 변경/RFC 요구 없음.
- Commit·Push·PR·CI·main 병합·원격 댓글은 미실행/별도 승인. 이 결과는 P3-A 로컬 검토 요청이며 DEV027/Stage DONE 또는 Design 수용 선언이 아니다.

승인 직전 계획5개 원본과 SHA256은 `.local/validation/DEV-027/session-pipeline/approval/`에 보존했다. 원격 main PR169는 디자인 문서3개만 추가되었으며 승인 base와 제품/검사 차이는 없다. 최신 커밋을 실행 승인으로 사용하지 않았다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 10. P3-A Git 제출 승인 — 2026-11-22

> Owner 승인 원문 — 본 개발 대화
>
> DEV-027 P3-A 로컬 구현·검증 결과를 승인합니다. 승인된 22개 파일을 codex/DEV-027-session-pipeline-plan 브랜치에 Commit·Push하고 PR을 생성한 뒤 필수 CI 결과까지 확인해주세요. DI-03 종속 범위와 L2 전 화면 통합·독립 심사 대기는 유지하고, main 병합은 별도 승인하겠습니다.

- 대상: `wisberry2022/MetroManager`, 브랜치 `codex/DEV-027-session-pipeline-plan`, 승인된22경로. 이 제출의 Commit·일반 Push·PR 작성·필수 CI 확인에 한정하며 main 병합·auto-merge·릴리스/배포는 제외한다.
- 제출 기준: `690823927e97a29131dbb572bab4aa9d7f6cfd97`. 승인 시험 기준 `97cc5472f11a97d5f7d7c1b89dc12edeace36e1f` 및 source SHA256·원 실행 결과를 보존한다. 사이의 PR169/170은 기획·디자인 문서19개이며 제품/검사·Godot 설정·CI/도구 변화0이다. 겹치는 경로0을 확인해 작업 브랜치만 fast-forward했다. main을 새 게임 시험 SHA로 바꾸지 않는다.
- 승인22개 원본 해시는 `.local/validation/DEV-027/session-pipeline/submission/approval-baseline.json`과 `approved-22/`에 보존했다. 제품8·검사6·L2 증거2개 등은 그대로다. 이 티켓/결과에 제출 승인 후속만 추가하고 provenance를 제출 base/실제 blob으로 갱신한다.
- 모델·Session·자동 연결677 / 영향 회귀3204 / 로드·고의 실패 종료의 기존 실행을 재사용한다. 실제 시험 소스 해시 동일성을 대조하며 문서 동기화만으로 GUI·게임 전체를 반복하지 않는다. 제출 정책·preflight 및 실제 head의 CI 결과는 PR에서 확인한다.
- DI03 종속 범위, L2 전 화면 통합·독립/Design 심사, DEV026 한정 수용·PARTIAL/미관측, S3-12/HQ·Owner 최종 인수 대기를 유지한다. 신규 명세 변경 요구 없음.
- 이 문서는 제출 직전 기록이다. 실제 commit/head·PR·필수 CI는 PR 본문과 완료 보고를 따른다. 과거 GIT_NOT_AUTHORIZED/REMOTE_NOT_SENT는 당시 기록으로 남긴다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 11. P3-A 수용 후속·P3-B 로컬 계획 권한 — 2026-11-22

Owner 요청 원문 — 본 개발 대화:

> 개발 에이전트. P3-A 수용 결과를 후속 기록하고, P3-B의 착수 범위와 실행·검증 계획을 로컬로 준비해주세요. 정확한 변경 경로와 Track A/B L2 확인사항·승인 필요 범위를 포함해주세요. 구현·검증 및 Commit·Push·PR·main 병합은 별도 승인하며, DI-03 보류와 기존 대기 상태는 유지합니다.
>
> 그리고 TrackA,TrackB가 통합 GUI 테스트 실행 조건으로 화면 통합 연결을 요구했으니 해당 범위가 이번 작업에 포함되는지도 확인해주세요

상태: **LOCAL_PLAN_REVIEW / P3B_IMPLEMENTATION_VALIDATION_NOT_AUTHORIZED / REMOTE_NOT_SENT**. 기준 `cc8814097634013be8df8b27f166bdee09c7bac6`, 로컬 브랜치 `codex/DEV-027-p3b-screen-plan`. 이 요청은 아래7개 문서 로컬 작성·정적 확인만 허용한다.

| 종류 | 정확한 경로 |
| --- | --- |
| 신규 | `docs/engineering/gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md` |
| 수정 | `docs/engineering/gate3/DEV-027_W04B_SUPPLY_CONTRACT.md` |
| 수정 | `docs/engineering/gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md` |
| 수정 | `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md` |
| 수정 | `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md` |
| 수정 | `docs/engineering/tasks/DEV-027_RESULT.md` |
| 수정 | `docs/engineering/tasks/DEV-027_PROVENANCE.json` |

[PR #171](https://github.com/wisberry2022/MetroManager/pull/171)은 main `cc8814097634013be8df8b27f166bdee09c7bac6`에 병합됐다. 제출 head `a9111742a74c7369ab7c52f5e24ef5ca51d2c217`와 병합 tree가 동일하며 기존 모델/연결677·영향 회귀3204·로드/의도 실패 및 필수 CI는 원 실행 식별로 재사용한다. 이번 새 게임 실행이나 최신 main 자연 VS02 결과가 아니다.

- [Track A / AGT-DSG-0004](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7073746341): **TRACK_A_P3A_L2_LIMITED_ACCEPTANCE**. 비의존 기능 공급·백엔드 연결 한정 수용, 기능 의미의 추가 필수 수정 없음. UI11은 제한/미공급 의미만, UI12 실제 DI03은 보류.
- [Track B / AGT-DSG-0003](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7073690611): **P3A_SUPPLY_REVIEWED / TRACK_B_STATIC_NO_OBJECTION / SCREEN_ACCEPTANCE_PENDING / GUI_NOT_REQUESTED_NOW**. 공급 의미 이견 없음이며 실제 화면/표현·읽기·수명·복귀 수용은 별도다.
- 과거 P1의 Session/Pipeline 미공급, 승인 전 Git/실행 대기는 당시 이력이다. 원문·기존 검증·raw·실제/fixture 구분과 DEV026 한정 수용/PARTIAL·미관측·P07 구분을 보존한다. DI03 실제 종속 구현·검증 및 S3-10-C·S3-12/HQ·Owner 최종 인수 대기도 유지한다.

[상세 계획](../gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md) §6.2의 **최대19개**는 다음 로컬 구현·자동/회귀·로드 검증 승인 후보다. 실제 화면 통합(main/Host·제안 View·P05/P06/P07/후보 동선)은 그 후보에 포함된다. Track A/B B01~06의 해당 L2 필수 차이 정리와 Owner의 실행 승인을 만족하기 전 구현하지 않는다. P4 GUI/자연 VS02·독립 실행·Design 화면 수용은 고정 시험본/주체·범위 확인 후 별도다.

이번 제품 소스/검사/씬/에셋 변경0, 게임 자동/로드/GUI·빌드/export는 NOT_RUN. staging/Commit·Push·PR·원격 댓글 게시·main 병합/auto-merge·릴리스/배포도 허용되지 않았다. 과거 Git 승인/PR171 병합 사실을 미래 작업에 전용하지 않는다. 새 게임 명세 변경/RFC 요구 없음. 실제 계약 충돌이 드러나면 해당 행만 기존 RFC 양식으로 상정한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 12. P3-B 계획 문서 제출 승인 — 2026-11-22

Owner 승인 원문 — 본 개발 대화:

> DEV-027 로컬 문서 7개를 승인합니다. codex/DEV-027-p3b-screen-plan 브랜치에 Commit·Push하고 PR을 생성한 뒤 필수 CI 결과까지 확인해주세요. P3-B 구현·검증과 main 병합은 별도 승인하며, Track A/B L2 확인 대기·DI-03 보류 및 기존 대기 상태는 유지합니다.

- 대상: `wisberry2022/MetroManager` / DEV-027 / AGT-DEV-0004. 브랜치 `codex/DEV-027-p3b-screen-plan`, 제출 base `cc8814097634013be8df8b27f166bdee09c7bac6`.
- 허용 범위: §11 및 [상세 계획 §6.1](../gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md)의 승인된 문서7개에 대한 정상 훅 Commit·일반 Push·PR 생성·필수 CI 확인. 미래 최대19개 제품 실행 후보의 구현·검증 승인이 아니다.
- 유지: P3-B 구현·검증 미착수, Track A/B B01~06 L2 확인 대기, DI03 종속 구현·검증 보류, DEV026 한정 수용/PARTIAL·미관측·P07 구분과 S3-10-C·S3-12/HQ·Owner 최종 인수 대기. main 병합·auto-merge·릴리스/배포 및 #146 신규 댓글 게시 권한 없음.
- 승인7개 원본과 해시는 `.local/validation/DEV-027/p3b-plan/submission/approved-7/` 및 `approved-audit.json`에 보관한다. 승인된 계획·계약·후속 내용은 보존하고 이 티켓/결과의 제출 승인 기록과 provenance blob만 갱신한다.
- 문서 doctor/check·정확한7경로·상대 링크·원문/소스/공유 보존 검사를 수행하며 커밋 후 fetch/preflight, 원격 실제 head의 `policy`·`department-policy`를 확인한다. 실제 commit/head·PR·CI 결과는 제출 PR과 완료 보고에 연결한다.
- 신규 게임 자동/프로젝트 로드/GUI·플레이·독립 실행·자연 VS02·빌드/export는 각각 NOT_RUN. 원 P3-A 시험/CI와 문서 검사를 구분하며 새 명세 변경 요구 없음. 이 기록은 제출 직전이며 PR 작성/CI는 승인·DONE을 뜻하지 않는다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 13. P3-B 로컬 구현·검증 승인 — 2026-11-22

Owner 승인 원문 — 본 개발 대화:

> DEV-027 P3-B의 로컬 구현·검증 착수를 승인합니다. Track A/B L2 조건과 B02 시각 표현 보완을 반영하여 최대 19개 경로 안에서 진행하고, 로컬 결과부터 검토 요청해주세요. Commit·Push·PR·main 병합과 독립 GUI 실행은 별도 승인하며, DI-03 보류와 기존 대기 상태는 유지합니다.

- 상태: **P3B_LOCAL_IMPLEMENTATION_IN_PROGRESS / REMOTE_NOT_SENT**. 앞 절의 작성 당시 미승인·미공급 기록은 보존하며 현재 권한은 본 절을 따른다.
- base: `1a24e3346d0ec46ca692fe54d5de5656913c3450`; 별도 로컬 브랜치 `codex/DEV-027-p3b-screen-integration`. 상세 계획 §6.2의 정확한 최대19경로(제품7·검사3·문서/증거9)만 허용한다.
- [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074162935) / [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074161321)의 B01~06 방향 확인 회신 완료. 기존 P3-A 한정 수용을 재심사하지 않으며 이 확인을 제품 PASS로 쓰지 않는다.
- B02 보완: `effective_not_before`는 접수 가능 최저 시각(성공 보장 아님), `admitted_at`은 실제 접수, `completes_at`은 실제 접수 기준 완료 예정이다. 효력 재검사 실패·명시적 새 요청과 현재 행동 사유를 구분한다. 기존 공급 필드/게임 규칙 변경 없음.
- 비의존 main/Host·제안 View·명령/상태·P05/P06/P07·후보/복귀를 구현하고 자동 Control/회귀·Godot 로드를 분리 검증한다. 실제/합성 입력/시간 환산을 구분하고 소스·실패 로그·원 시험 식별을 보존한다.
- 제외: DI03 실제 생성·수요/carry·소비·재접수, 새 규칙·모델/원장·CI·새 GUI runner·폰트/이름/아트 반입. 독립 GUI·자연 VS02·Design 화면 최종 수용은 별도 대기.
- Commit·Push·PR·main 병합·이슈 댓글·배포0. DEV026 한정 수용/PARTIAL·미관측·P07 구분, #92 규격/공급과 S3-10-C·S3-12 최종 인수 대기 유지.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 14. P3-B 로컬 검토 요청 — 2026-11-22

- 기준: `1a24e3346d0ec46ca692fe54d5de5656913c3450` + [실행 JSON](../evidence/DEV-027_SCREEN_INTEGRATION_RESULTS.json)의 최종 파일 해시. 신규 commit 없음.
- [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074162935) / [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074161321) B01~06 방향 확인과 Owner 최대19경로 승인에 따라 구현했다. 현재 **LOCAL_REVIEW_PENDING / P4_GUI_INDEPENDENT_NOT_RUN / REMOTE_NOT_SENT**.
- 새 실제 View 자동 **225 PASS**, 영향 회귀 **3120 PASS**(그중 P3-A 모델/공급/VS02 재실행677), 정상 실패0·SCRIPT ERROR0. 새 runner 의도 실패 exit1을 별도로 확인했다. Godot4.7.2 최종 로드 exit0·오류0.
- 제품 코드는 main/Host와 새 proposal View/표시 매핑/씬에 한정한다. 모델·Session·Pipeline·원장·시계·기존 씬·자산/데이터·CI 변경0. 기존 UI 입력 공통 처리와 표시 helper를 재사용해 Host를1000행 이내로 유지했다.
- B02는 `effective_not_before`→접수 가능 최저 시각(성공 보장 아님), `admitted_at`→실제 접수, `completes_at`→실제 접수부터의 완료 예정으로 소비한다. 기존 게임 규칙·심사/난수/지급 계산 추가0.
- 자동 검사에는 실제 Control 신호/합성 키보드와 게임 시간 환산이 있다. 실제 OS GUI·독립 실행·자연 VS02·최종 가독성/물리 DPI·빌드/export·성능은 각각 NOT_RUN. 표시0/실패 등 사본 fixture는 실제 자연 발생과 분리했다.
- P1/P3-A 결과·실패/원본과 Markdown 원문을 보존했다. 비변경 추적774개·공유 데이터2개·별도 F08 문서9개 해시 일치. 검사 당시 CRLF 바이트는 로컬 보관하고 LF 정규화 외 변경0을 검증했다. 최종 로드는 LF 파일로 실행했다.
- DI03 종속 범위 보류, DEV026 한정 수용/PARTIAL·미관측·P07 구분, #92 실제 이름/환경/폰트/아트·최종 규격, S3-10-C·S3-12/HQ·Owner 최종 인수 대기 유지. 새 명세 변경/RFC 필요 없음.
- 로컬 제출 검사: `.venv/Scripts/python.exe tools/policy.py doctor` 및 `check` PASS(793파일/68 GDScript), `git diff --check` PASS. 정확한19경로·18개 provenance blob·UTF-8/LF·원문 보존을 재확인했다. 원격 필수 CI는 PR 미생성으로 NOT_RUN이다.

최대19경로 승인 안에서 구현·자동/회귀·로드를 완료했다. 실제 파일/검증 명령은 DEV-027_RESULT §13 및 새 증거 색인을 따른다. 로컬 결과 검토 단계이며 Git/독립 GUI·최종 인수 권한은 별도다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
