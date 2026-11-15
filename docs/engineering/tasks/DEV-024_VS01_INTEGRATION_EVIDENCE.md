# DEV-024 — W08 VS-01 통합 재현·회귀·GUI 증거 착수 검토안

- 담당: Development Project Leader / LAPTOP / AGT-DEV-0004 / 2026-11-15 (Asia/Seoul).
- 상태: **OWNER_ACCEPTED / SUBMISSION_APPROVED / DESIGN_PARTIAL**. §1~9는 단계별 이력이며 최신 제출 권한은 §10을 따른다.
- 저장소: wisberry2022/MetroManager · [Issue #80](https://github.com/wisberry2022/MetroManager/issues/80).
- 기준 main / 로컬 HEAD: `0a76a2e924ec0b661e3cdbd858ed6bfd665f3dc9`.
- 브랜치: `codex/DEV-024-vs01-integration-evidence`. 독립 worktree 사용; 공용 main·기존 DEV-023 작업 보존.
- 연결: [실행·Design 입력 패킷](../gate3/DEV-024_VS01_EXECUTION_PLAN.md), [검증·기존 수용 대응표](../gate3/DEV-024_VS01_VALIDATION_PLAN.md), [준비 결과](DEV-024_RESULT.md).

## 1. 이번 지시와 권한

Owner의 본 개발 대화 원문:

> 개발 에이전트. DEV-026 구현·검증 보류는 유지하고, 다음으로 DEV-024의 착수 범위와 실행·검증 계획을 준비해주세요. 원격 저장소의 80번 이슈, 81번 이슈와 최신 HQ 지시사항을 확인하고, 기존 수용 증거와 실제 VS-01 완주 잔여 범위를 구분해주세요.

현재 권한은 원격·승인 명세·제품 소스 조사, 독립 로컬 브랜치/worktree, 아래 준비 문서4개 작성·정적/정책 검사와 로컬 검토 요청이다. 제품/관측 도구 구현·게임 자동검사·프로젝트 로드·실제 플레이, Commit·Push·PR·main 병합·Issue 게시/종료는 이번에 실행하지 않는다. DEV-026 구현·제품 검증은 **HOLD**다.

2026-11-14 17:37 효력의 승계와 [INF-010 등록](../../infra/tasks/INF-010_DEVELOPMENT_SUCCESSION.md)에 따라 담당은 AGT-DEV-0004다. #80의 AGT-DEV-0001은 최초 작성 이력이다. 이번 Owner 지시는 현재 담당의 준비 권한을 확인하지만 새로운 구현/Git 권한을 만들지는 않는다. DEV-023·PM-018의 개별 실행/Git 승인을 DEV-024에 전용하지 않는다.

### 1.1 Owner 로컬 구현·검증 승인 — 2026-11-15

> DEV-024의 착수 범위와 실행·검증 계획을 승인합니다. 검토안의 최대 8개 경로 안에서 구현·검증을 진행하고, 로컬 결과부터 검토 요청해주세요. 독립 실행·Design 심사는 DEV 자체 검증과 구분하고, Commit·Push·PR과 main 병합은 별도 승인하겠습니다. DEV-026 보류는 유지합니다.

대상은 wisberry2022/MetroManager / DEV-024 / AGT-DEV-0004 / codex/DEV-024-vs01-integration-evidence, §4의 최대8경로다. 정상 제품 관측 보조·관련 자동검증·프로젝트 로드·DEV 자체 실제 GUI·로컬 증거/독립 인계 자료 정리를 승인하며 이번 로컬 검토 종료 또는 Owner 철회까지 유효하다. 독립 실행·Design 심사는 다른 주체/결과로 남긴다. Commit·Push·PR·main 병합·Issue 게시/종료·릴리스·배포는 포함하지 않는다. DEV-026 구현·제품 검증 HOLD를 유지한다.

착수 시 fetch 및 원격 API로 기준 main `0a76a2e924ec0b661e3cdbd858ed6bfd665f3dc9` 동일성을 확인했다. 준비4문서와 원본 감사 결과를 로컬에 보존하며 제품/정책·기존 증거는 변경하지 않는다. 아래 준비 당시 APPROVAL_PENDING/NOT_RUN은 해당 시점 이력이다.

## 2. 최신 승인·HQ·Design 근거

| 근거 | 현재 적용 |
| --- | --- |
| [Gate 2 최종 Owner 승인](../../planning/PLN-001_GATE2_FINAL_APPROVAL.md) | 승인 C/D/DATA, PAR·SEM-01~03·CLOSE-01 의미 유지. 구현/Git 승인과 별개 |
| [PM-014 승인 Stage 2 계획](../../hq/PM-014_STAGE2_VS01_EXECUTION_PLAN.md) | 표준 VS-01 및 S2-01~11. 각 티켓 실행 승인 필요 |
| [PM-015 GUI 증거 재사용](../../hq/GUI_REVIEW_PROTOCOL.md) | 기존 유효 증거 재사용, 실제 영향 행만 재개방, 한 패킷·한 번의 묶음 피드백 |
| [PM-018 Owner 결정](../../hq/tasks/PM-018_DEV023_CLOSEOUT.md) / [최신 S2 표](../../hq/STAGE2_ACCEPTANCE_MATRIX.md) | DEV-023 OWNER_ACCEPTED / DONE·#79 CLOSED. 다음은 DEV-024 자연 완주·최종 회귀 → HQ 통합 → Owner Stage 인수 |
| [최신 HQ #78 종료 기록](https://github.com/wisberry2022/MetroManager/issues/78) | Owner의 별도 완료 결정으로 DEV-022 OWNER_ACCEPTED / DONE·#78 CLOSED/completed. PR #123·기존 검증을 연결하고 DEV-024 및 HQ/Owner 인수로 후속 이관. DEV-024 실행/Git 승인 부여 아님 |
| [Design #80 정본](https://github.com/wisberry2022/MetroManager/issues/80#issuecomment-6888452975) / [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6888459436) | 입력6묶음·한 연속 완주·독립 실행/Design 심사·시작/종료 조건. 기존24조건 재검수 제외 |
| [DEV-023 결과](DEV-023_RESULT.md) / [최종 Design 판정](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6887989037) | 모델 준비 후 실제 GUI 수용은 완료. 정상 초기 상태부터 전체 제품 완주와 구별 |

PM-018의 #80 댓글0·담당/권한 NOT_VERIFIED와 PR #131 MAIN_MERGE_PENDING은 작성 당시 기록이다. 현재 #80에는 위 Design 댓글1개, #81에는 연결 댓글이 있고 #131/#132는 main에 반영됐다. 본 로컬 문서로 담당·준비 권한·기준본을 연결한다. 실제 실행/Git 승인 대기는 그대로이며 원격 문서·Issue를 직접 갱신하지 않는다.

마지막 원격 확인에서 #78의 최신 HQ 종료 기록(2026-11-15T03:24:43Z 갱신)을 추가 대조했다. 이 기록은 main 파일 변경 없이 Issue에만 등록돼 있으므로 PM-018 파일의 모델/병합 완료 표현과 구별해 적용한다. DEV-022와 DEV-023의 개별 DONE은 자연 VS-01·전체 Stage DONE으로 확대하지 않는다.

## 3. 착수 제안

목표는 **정상 독립 초기 상태 → B01 응찰·사업 계약/정부 지급 → 같은 사업의 표준 공사 계약·착공·완공 → 시범운행·안전검증·개통 → 실제 영업·완료 통행 → 첫 유효 마감 보고 → 다음 공고 조회**를 한 제품 실행에서 실제 마우스/키보드로 연결하는 것이다.

포함 범위:

1. 정상 main 장면을 사용하는 최소 관측 보조와 실행별 입력·상태·화면·원장/보고·종료·해시 색인. 게임 상태나 명령을 대신 생성하지 않는다.
2. 최종 통합본의 W01~03/W07 주요 회귀와 W04A/W05/W06·UI 자동검증의 적용/재사용 근거. 자동검사를 실제 GUI 완주로 합산하지 않는다.
3. DEV 자체 확인, 별도 독립 실행자 결과, Design의 GUI 심사를 구분한 인계 패킷. 동일 유효 독립 완주를 S2-08/09/10에 공동 연결한다.
4. 로컬 결과와 미해결/이월 보고. 승인 의미 차이는 Planning, 제품 결함은 원 소유 티켓으로 환류한다.

제외 범위: 제품 `scripts/`·`scenes/`·`assets/`·`project.godot` 변경, 기획/디자인 규칙 변경, 기존24조건 전면 반복, 빠른 공사 별도 전체 E2E, 두 번째 실제 수주, 모든 배속/키 조합, VS-02·최종 VP-01/02·전체 MVP, Windows export/FPS·최종 폰트/DPI 인수, Track B/F-08, DEV-025 선행 착수 및 DEV-026 구현·제품 검증.

## 4. 다음 로컬 실행 승인 대상으로 제안하는 정확한 경로

현재 생성한 것은 1~4의 Markdown4개뿐이다. 다음 승인 시 아래 **최대8개 경로** 안에서만 구현·증거 보완하고, 사용하지 않은 경로는 만들지 않는다.

| 번호 | 경로 | 목적 |
| --- | --- | --- |
| 1 | `docs/engineering/tasks/DEV-024_VS01_INTEGRATION_EVIDENCE.md` | 본 티켓·승인 원문·범위 |
| 2 | `docs/engineering/gate3/DEV-024_VS01_EXECUTION_PLAN.md` | 실행/독립 인계 패킷·실제 조작·보조 도구 계약 |
| 3 | `docs/engineering/gate3/DEV-024_VS01_VALIDATION_PLAN.md` | S2 기존/신규 대응·검증 계획/후속 |
| 4 | `docs/engineering/tasks/DEV-024_RESULT.md` | 실제 결과·검수 요청·잔여 |
| 5 | `tests/game/run_vs01_tests.gd` | TEST_ONLY 정상 main 호스트·관측/기록·관측기 자체검사. 자동 성공 경로/fixture 없음 |
| 6 | `tests/game/run_vs01_tests.gd.uid` | 엔진 UID |
| 7 | `docs/engineering/gate3/DEV-024_VS01_VALIDATION.json` | 실행자/명령/소스·증거 해시·기대/실제·S2 참조·NOT_RUN 색인 |
| 8 | `docs/engineering/tasks/DEV-024_PROVENANCE.json` | 실제 변경 경로·base·blob 출처 보조 기록. 신원/승인 인증 아님 |

DEV-018 최초 분할안의 `vs01_fixtures.gd`는 생성 제안에서 제외한다. 기존 모델/소비 테스트를 재사용하고 자연 완주에는 상태 주입 fixture가 필요하지 않다. 원래 제안 runner 이름은 유지하되 자동 모델 완주 증명이 아닌 정상 제품 관측 용도로 구체화한다. 이는 동일 DEV-024 검증 목적 안의 경로 축소·역할 구체화 제안이며, 아직 도구 구현 승인은 아니다. 기존 로그·외부 입력 기록만으로 필수 증거를 충분히 확보할 수 있으면 5~6도 생략한다.

원본 로그·화면·실행 전 소스 사본·해시는 gitignored `.local/` 또는 Owner 제한 보관소에 둔다. 공개 문서/JSON에는 최소 상대 색인·해시·판정만 남긴다. 로컬 수집/감사 스크립트도 출처·실제 개입을 기록하며 승인 범위 밖의 제품·정책·공용 도구 수정은 하지 않는다.

## 5. 실행 순서와 승인 경계

| 단계 | 수행·종료 조건 | 현재 |
| --- | --- | --- |
| P0 준비 | 본4문서·원격/HQ/소스 대조·정적 검사 | 로컬 검토안 |
| P1 관측 준비 | Owner의 이 경로/범위 로컬 실행 승인 후 최소 관측 보조·자체검사·고정 사본/해시 | APPROVAL_PENDING / NOT_RUN |
| P2 DEV 검증 | 최종 후보 회귀·프로젝트 로드·자체 GUI. 원본/종료 기록, 필수 누락 확인 | NOT_RUN |
| P3 독립 완주·심사 | 입력6묶음 충족 및 별도 실행 주체/권한 확인 후 자연 완주; Design은 충분한 독립 증거를 심사 | NOT_RUN |
| P4 로컬 결과 검토 | 같은 증거의 S2 대응·미해결/이월·필요 Planning 확인 | NOT_RUN |
| P5 원격 제출·최종 인수 | 별도 Commit/Push/PR 승인 후 preflight·필수 CI. HQ 통합·Owner Stage 결정 | APPROVAL_PENDING / NOT_RUN |

다음 승인 요청 대상은 AGT-DEV-0004 / DEV-024 / 위 브랜치·8경로 / P1~P2의 로컬 구현·자동검증·프로젝트 로드·DEV 자체 실제 GUI와 P3 인계 자료 준비·수신 결과 정리다. 승인 효력은 해당 로컬 결과 검토 종료 또는 Owner 철회까지로 제안한다. 독립 실행자의 실행 권한/지정은 해당 주체의 유효 근거를 연결하며 DEV 자체 결과를 독립 결과로 바꾸지 않는다. 새로운 Git·게시·병합·릴리스 권한은 포함하지 않는다.

수정 필요가 제품 소스까지 확대되면 승인 경로에 없는 파일을 임의 수정하지 않고 원 소유 티켓·현상·재현·영향·필요 경로를 구체화한다. 승인 명세의 모호함/불가능·부서 경계 변경은 [RFC 양식](../../templates/RFC_AND_DECISION.md)으로 해당 항목만 상정한다. 현재 게임 명세 변경 필요 없음. **DEV-026 HOLD 유지.**

## 6. 승인 후 로컬 구현·검증 결과 — 2026-11-15

§1.1 승인에 따라 §4의 정확한8경로를 사용했다. 준비4문서는 기존 기록을 보존하고 후속 결과를 추가했으며, 정상 main 관측기/UID·검증 JSON·출처 manifest4개를 보완했다. 제품 소스·씬·데이터·설정과 기존 수용 증거·타 부서 파일은 변경하지 않았다.

정상 자동검사3291개(기존 회귀3243+관측기48), 의도적 실패 exit1 감지, 최종 프로젝트 로드, DEV 자체 정상 초기 VS-01 실제 GUI를 수행했다. GUI는 실제 입력으로 계약→표준 공사→60/60분 검증→개통→실적 마감→공고 조회→추가 정상 탐색을 거쳐 P01에 도달했다. 상세 수치·출처·실패 이력은 [결과서 §6~9](DEV-024_RESULT.md)와 [검증 색인](../gate3/DEV-024_VS01_VALIDATION.json)에 있다.

P1/P2는 로컬 구현·자체검증 완료, P3는 독립 인계 자료 준비/독립 실행·Design 새 심사 NOT_RUN, P4는 **Owner 로컬 결과 검토 요청**이다. P5 Commit·Push·PR·main 병합·필수 CI는 NOT_RUN/별도 승인이다. DEV 자체 성공을 독립 수용·DEV-024 DONE·Stage 인수로 바꾸지 않는다. DEV-026 구현·제품 검증 **HOLD** 유지.

## 7. Owner 로컬 결과 승인·원격 제출 권한 — 2026-11-15

Owner가 본 개발 대화에서 승인된8파일의 Commit·Push·PR 생성과 필수 CI 확인을 승인했다. [결과서 §10](DEV-024_RESULT.md)에 원문·대상·동작·기간·금지 사항을 기록한다. 대상은 본 저장소/DEV-024/AGT-DEV-0004와 `codex/DEV-024-vs01-integration-evidence`이며 §4의8경로를 유지한다. 이번 승인 기록을 티켓·결과서에 추가하고 해당 출처 blob만 갱신한다. 나머지 구현·검증 증거는 승인본을 유지한다.

P4 로컬 결과는 OWNER_ACCEPTED, P5 중 Commit·Push·PR·필수 CI 확인만 승인됐다. 독립 실행·Design 심사는 대기, main 병합은 별도 Owner 승인이다. DEV-024 전체 DONE/Issue 종료·Stage 인수는 선언하지 않으며 DEV-026 구현·제품 검증 **HOLD**를 유지한다.

## 8. 독립 Design 판정 수신·OBS-V05-01 후속 범위 — 2026-11-15

Owner의 본 개발 대화 지시:

> 개발 에이전트 디자이너 에이전트가 80,81번 이슈에 검수 결과를 등록했으니 확인하여 후속 조치 작업을 진행해주세요

[Design #80 정본](https://github.com/wisberry2022/MetroManager/issues/80#issuecomment-6889738120)과 [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6889744888)을 수신했다. **V01~V04·V05-1/2는 관측 범위 PASS 수용, V05-3은 승인 L2 불충족으로 보완 필요, 전체 독립 GUI는 PARTIAL**이다. PR #134의 main 반영 SHA `0865e5a2cdf168dac14167922c9e59b16796fa81`를 기준으로 별도 `codex/DEV-024-v05-entry-fix` worktree에서 수신 기록·정적 원인·수정/검증안을 준비한다. 이전 실행·PR·실패/미확인 기록과 공용/기존 작업 트리는 보존한다.

정적 원인은 `Stage1View._query_business`의 성공 분기가 `_open_tenders()`로 기존 `TenderView.page`를 보존하는 것이다. 기존 GUI 자동 U14는 panel visible만 확인해 P01/P05를 구분하지 못했다. 승인 L2의 P01 진입을 복원하는 제안이며 새 게임 규칙/디자인 결정은 필요 없다.

이전 §3은 제품 scripts 변경을 제외했고 §4는 정확한8경로에 한정했다. 이번 후속 지시에 따라 수행할 수신·범위 준비와 제품 경로 추가를 구분한다. **제품 Host 및 기존 GUI 검사2경로를 포함하는 경로 재지정은 Owner 확인 대상으로 명시하며 적용 전이다.** 과거 DEV-023 완료 티켓의 실행 승인이나 PR #134 제출 승인을 확대 적용하지 않는다. 구체8경로와 성공 분기1줄 제안, 영향 검증은 [실행 계획 §7](../gate3/DEV-024_VS01_EXECUTION_PLAN.md)에 있다. 현재는 기존 문서/JSON5개만 로컬 갱신하며 제품/게임 검사 코드는 변경하지 않는다.

후속 로컬 구현·검증 승인 요청은 `codex/DEV-024-v05-entry-fix`의 실행 계획 §7.2 재지정8경로, OBS-V05-01과 직접 영향3항목에 한한다. Commit·Push·새 PR·main 병합·Issue 게시/종료·릴리스는 포함하지 않는다. 독립 보완 실행·Design 재심사도 DEV 자체 검증과 별도로 남긴다. DEV-026 구현·제품 검증 **HOLD** 유지.

### 8.1 Owner 경로 재지정·로컬 실행 승인

Owner는 본 개발 대화의 실행 계획 §7.2 확인 질문에 다음과 같이 응답했다.

> 8개 경로 재지정·로컬 수정 및 검증 승인

이에 따라 §8의 경로 승인 대기를 해소하고 §7.2의 정확한8경로에서 OBS-V05-01 구현·직접 영향 검증을 진행한다. 대상은 본 저장소/DEV-024/AGT-DEV-0004/`codex/DEV-024-v05-entry-fix`이며 효력은 이번 로컬 구현·검증 완료 또는 Owner 철회까지다. 이전 제출 권한을 재사용하지 않으며 Commit·Push·PR·main 병합·외부 회신은 이번 승인에 포함하지 않는다. 독립 검수의 원래 판정과 DEV-026 HOLD는 유지한다.

## 9. OBS-V05-01 승인 범위 실행·로컬 검수 요청

§8.1 승인과 실행 계획 §7.2의8경로 안에서 구현·검증했다. 성공한 보고 조회가 P05 선행 문맥과 무관하게 즉시 P01에 진입하도록 Host1줄을 추가하고 기존 GUI 검사/관측을 보완했다. 자동1185개·프로젝트 로드·DEV 자체 GUI F1~3를 통과했으며 자세한 명령·증거·한계는 [결과서 §13](DEV-024_RESULT.md)에 있다.

이전 단계의 NOT_RUN/승인 대기는 해당 시점 기록으로 보존한다. 이번 보완의 독립 실행·Design 명시 수용은 아직 대기이며 DEV-024 전체 PARTIAL·A01-Q12 PARTIAL·DEV-026 HOLD를 유지한다. 새 Commit·Push·PR·CI·main 병합과 외부 회신은 미실행/별도 승인이다. 이 문서는 로컬 검수 요청이며 DONE 선언이 아니다.

## 10. Owner 로컬 결과 승인·후속 제출 권한 — 2026-11-15

Owner는 본 개발 대화에서 다음과 같이 승인했다.

> DEV-024 V05-3 로컬 수정·검증 결과를 승인합니다. 승인된 8개 파일을 codex/DEV-024-v05-entry-fix 브랜치에 Commit·Push하고 PR을 생성한 뒤 필수 CI 결과까지 확인해주세요. 독립 보완 실행·Design 재수용 대기는 유지하고, main 병합은 별도 승인하겠습니다. DEV-026 보류는 유지합니다.

대상은 wisberry2022/MetroManager / DEV-024 / AGT-DEV-0004 / codex/DEV-024-v05-entry-fix / 실행 계획 §7.2의8경로다. 정상 훅을 통한 Commit·일반 Push·base=main PR 생성·필수 policy/department-policy 확인을 이번 제출 완료 또는 Owner 철회까지 허용한다. main 병합·자동 병합·강제 Push·브랜치 삭제·Issue 게시/종료·릴리스/배포는 포함하지 않는다.

승인된8파일 바이트를 로컬 검토 감사와 대조한 뒤 보존했다. 이번 제출에서는 티켓·결과서에 승인 기록을 추가하고 그에 따른 provenance blob만 갱신한다. 제품·검사·실행/검증 계획·검증 JSON은 승인 바이트를 유지한다. 실제 제출·검사 결과는 PR 및 Owner 완료 보고에 연결하며 검사 성공을 DONE/Stage 인수로 확대하지 않는다. 독립 보완 실행·Design 재수용 대기와 DEV-026 HOLD를 유지한다.
