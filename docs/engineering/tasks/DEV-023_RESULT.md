# DEV-023 — 착수 준비와 P1 공급 구현·검증 결과

- 담당: Development Project Leader / AGT-DEV-0004 / 2026-11-15 (Asia/Seoul).
- 상태: **OWNER_PR_SUBMISSION_APPROVED / DESIGN_ACCEPTANCE_PENDING / UI_INTEGRATION_NOT_RUN**.
- 기준 main: `e379e584e6a9fefa0c581f27903c16e4fc0f5136`.
- 브랜치: `codex/DEV-023-operations-finance-ui`. 독립 로컬 worktree의 미커밋 검토안이다.

> §1~5는 Owner 실행 승인 전 준비 기록, §6은 최초 P1 검토 결과다. Design 회신 후 보완 결과는 §7, 현재 원격 제출 승인·단계는 §8을 따른다.

## 1. PR #123 병합과 최신 지시 확인

Owner의 “PR이 main에 머지되었습니다 … DEV-023의 착수 범위와 실행·검증 계획을 준비해주세요” 지시에 따라 원격을 읽기 확인했다.

- [PR #123](https://github.com/wisberry2022/MetroManager/pull/123): CLOSED / MERGED.
- 제출 head: `00be38d232308a4d4c01b203af8bab6122eed34c`.
- main merge: `e379e584e6a9fefa0c581f27903c16e4fc0f5136`, 2026-11-14 22:41:54 Asia/Seoul.
- head↔merge tree diff 없음. 이후 확인한 main 추가 변경 없음. 병합 명령을 중복 실행하지 않았다.
- 기존 제출 최종 [policy](https://github.com/wisberry2022/MetroManager/actions/runs/43600827545)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/43600827846) PASS는 DEV-022의 제출 기록이다. 이번 DEV-023 신규 CI가 아니다.
- DEV-022 모델 결과는 합병됐지만 P06/P07 제품 통합·Design L2/독립 GUI·DEV-024 완주/HQ 통합은 잔여다.

원격 #79/#80과 최신 main의 PM-014/015/016, 승인 C0.7/D0.9/DATA1.4, DSG-002 의미 계약, DEV-022 공급·fixture, DSG-008의 DEV-026 사전 의견을 대조했다. PM-016의 과거 “DEV-022 구현 미완료”와 이번 병합 확인을 구별하며 HQ/Design 문서를 대신 수정하지 않았다.

## 2. 착수 제안과 중요한 경계

DEV-023은 제품 Session의 W06 명시적 활성화, P06 운영/실적, P07 현재 재무/고정 보고, S01 최소 운영 연출과 다음 공고 조회 동선을 담당한다. 첫 유효 실제 보고 뒤 조회까지이며 새 회차·두 번째 수주는 추가하지 않는다.

소스 대조에서 두 연결 위험을 확인했다.

1. 기존 W07 fixture의 합성 운임과 W06 활성화는 혼용 불가다. 공통 View에서 무조건 활성화하는 대신 **제품 main의 명시적 연결**을 제안했다. #79 최초 후보에 없던 main.gd와 새 fixture/GUI runner를 후속 승인 경로에 드러냈다.
2. 현재 보고는 전일 요약이고 next_business_query의 query 허용과 available은 별개다. P07 선택 과거 보고를 별도 봉투로 공급하고, 조회 권한만으로 실패한 공급을 정상 목록으로 표시하지 않게 계획했다.

정확한 후속 경로는 제품·테스트16개 + 문서·증거7개 = **23개**다. 현재 작성한 것은 Markdown 4개뿐이다. 새 코드·씬·테스트·JSON/에셋은 작성하지 않았다.

## 3. Design L2와 DEV-026

실행 계획 §5에 **RFC-DEV-023-01 / LOCAL_DRAFT / NOT_SENT**를 준비했다. 새 실제 공급의 데이터/오류 표현(L2-A), 보고→다음 조회·복귀/입력 동선(L2-B), 사건 공급 한계를 반영한 경량 운행 표현(L2-C)을 묻는 안이다. 기존 UI-DC-01~07 전체 재승인이나 F-08 최종 규격 확정을 요구하지 않는다.

후속 Owner 실행 승인 후 독립 공급/자동검사 패킷을 먼저 준비할 수 있고, 해당 화면 통합 전에 영향 L2 수용이 필요하다. 이번에는 외부 메시지/Issue 회신을 보내거나 Design 수용을 선언하지 않았다.

DEV-026 구현·제품 검증은 **OWNER_IMPLEMENTATION_DEFERRED / NOT_RUN**이다. S01 공통 root/세션 수명/20예외 전체 처리는 유지 보류한다. 새 P06/P07의 자료 오류·낡은 관측·복귀 검증은 DEV-023 필수 품질 범위다. DEV-023 결과의 실제 필드/자식/신호·동선 변화만 향후 DEV-026 재대조 입력으로 남길 계획이다.

## 4. 로컬 산출물·검증

| 변경 파일 | 내용 |
| --- | --- |
| [DEV-023_W06_OPERATIONS_UI.md](DEV-023_W06_OPERATIONS_UI.md) | Owner 지시·승계·명세·포함/제외·정확한 23개 미래 경로·승인 단계 |
| [DEV-023_UI_SUPPLY_AND_EXECUTION_PLAN.md](../gate3/DEV-023_UI_SUPPLY_AND_EXECUTION_PLAN.md) | 실제 소스→신규 소비 봉투·무효과 동선·L2 RFC·L3 영향 |
| [DEV-023_UI_VALIDATION_PLAN.md](../gate3/DEV-023_UI_VALIDATION_PLAN.md) | U01~U20 기대값·명령·회귀·실제 GUI/독립 검수의 구분 |
| 본 결과서 | 원격 병합 확인·준비 판단·실행/검증 상태 |

검사 도구는 기존 DEV-022 worktree의 고정 .venv를 읽기 재사용한다. PYTHONUTF8=1, TEMP/TMP는 이번 worktree의 .local/temp로 한정한다. 신규 작업과 다른 worktree의 branch/index/파일을 변경하지 않는다.

| 이번 실제 검사 | 결과 |
| --- | --- |
| `../DEV-022-operations-model/.venv/Scripts/python.exe tools/policy.py doctor` | PASS: local hooks/tooling. 원격 보호/Owner 권한 인증 아님 |
| `tools/policy.py check` | PASS / exit0, files=624 / GDScript=43, formatter 변경 없음. `.local/validation/DEV-023_POLICY.log` |
| `.local/validation/audit_preparation.py`: UTF-8/LF·상대 링크·U01~20·미래 경로/기존 소스 대조 | PASS / exit0, Markdown4개·상대 링크25개·검증 행20개·미래 경로16+7개. `.local/validation/DEV-023_STATIC_AUDIT.json` |
| `git diff --check`, 로컬 변경·base 대조 | PASS. tracked/staged 변경0, 신규 Markdown4개만 존재. root main/기존 파일 보존, 규칙·project.godot 동일. 마지막 원격 main도 위 기준 SHA와 동일 |

이번 제품/테스트/씬 구현·자동 게임 테스트·Godot 로드·실제 GUI/플레이·빌드/export/FPS·Design 독립 검수·Commit/Push/PR·새 CI/preflight는 모두 **NOT_RUN**이다. 문서/정책 검사를 게임 실행으로 표시하지 않는다.

## 5. 검토 요청

후속 승인 대상은 범위 문서의 **23개 경로 로컬 구현·검증**이며 외부 전달/Git 제출/main 병합은 별도다. 이번 결과는 구체적인 착수 검토안이고 실행/Git 승인이나 DONE 선언이 아니다.

현재 게임·경제 명세 변경 필요 **없음**. 미해결은 Owner 개별 실행 승인, 실제 공급 패킷에 대한 Design L2, 구현·자동/GUI/독립 인수다. DEV-024 전체 제품 완주, F-08/DEV-025 적용 시점, Q12 상위 PARTIAL·증거 색인, HQ/Owner 최종 인수는 기존 책임·범위로 남긴다.

## 6. Owner 승인 후 P1 공급 구현·검증 — 로컬 결과

현재 Owner 지시 원문과 권한은 [범위 §1.1](DEV-023_W06_OPERATIONS_UI.md#11-owner-로컬-구현검증-승인--2026-11-15)에 기록했다. **P1 Session 공급·자동검사·실제 패킷을 완료하여 로컬 검토를 요청한다. DEV-023 전체 화면 구현 완료나 공식 수용/DONE 선언은 아니다.** Design L2가 필요한 화면 통합은 수용 후 진행하라는 조건을 적용했다.

### 구현 결과

같은 Session에서 W04A→W05→W06를 명시적으로 연결하는 중복 안전 활성화 API와 operations_ui/finance_ui/next_business_ui 봉투를 추가했다. 신규 소비의 가용성·타입·관측 일치·실패/회복을 처리한다. 현재 재무와 선택 마감 보고를 분리하고, 기존 root.report는 전일 요약을 유지한다. 보고일 선택·확인한 실제 보고에 따른 다음 공고 조회는 시계/원장/명령 큐/계약을 바꾸지 않는다. 실제 첫 보고와 Tender 봉투를 다시 대조하므로 조회 허용만 있고 공급이 실패한 경우 정상 목록으로 처리하지 않는다.

정상 Session 명령으로 **T4805 개통→T5760 Day4 마감**을 재현했다. 요청/탑승4296·완료4291·운임429100·서비스955분/운영비95500·만족도55/1, 마감 C1533600/R200000이다. 마감 이동 중5와 관측 시점 이동 중1의 구별도 확인했다. 이는 실제 모델을 사용한 **자동 공급 연결**이며 실제 마우스/키보드 플레이가 아니다.

제품 main에는 활성화 호출을 아직 연결하지 않았다. 기존 제품 부팅/Host/Map/P05의 동작은 현재대로이며 신규 P06/P07·씬·GUI runner는 생성하지 않았다. 임시 화면이나 강제 성공 버튼을 추가하지 않았다.

### 실제 변경 파일 — 승인23개 중 12개

| 구분 | 변경 |
| --- | --- |
| 기존 공급 수정1개 | scripts/ui/stage1_session.gd: 활성화·세 봉투·보고 선택·읽기 전용 조회 |
| 신규 자동검사4개 | tests/game/run_operations_ui_tests.gd, tests/game/operations_ui_fixtures.gd와 각각 UID |
| 계획/권한/결과4개 | DEV-023 범위·공급/실행 계획·검증 계획·본 결과서. 기존 준비/미실행 기록을 이력으로 보존 |
| 실제 증거/출처3개 | [fixture](../gate3/DEV-023_UI_FIXTURES.json), [검증 JSON](../gate3/DEV-023_UI_VALIDATION.json), [provenance](DEV-023_PROVENANCE.json) |

기준 main/HEAD는 e379e584e6a9fefa0c581f27903c16e4fc0f5136, 실제 브랜치는 codex/DEV-023-operations-finance-ui다. 미커밋 파일 해시로 증거를 고정한다. 게임/경제 모델·DATA·기존 테스트·프로젝트 설정·정책/CI·타 부서 산출물은 변경하지 않았다. root main과 다른 작업물은 보존했다. 엔진이 새로 만든 untracked 이미지 import 메타데이터151개만 별도 확인 후 제거했으며 원본 이미지/기존 메타데이터와 새 테스트 UID2개는 보존했다.

### 실제 검증

전용 .venv의 Python 3.12/gdtoolkit 4.5.0과 Godot 4.7.2.stable.official.ed1daf0bf를 사용했다. APPDATA/LOCALAPPDATA/TEMP/TMP는 실행별 .local/engine 아래로 분리했다. safe-save나 훅/정책 검사를 끄지 않았다.

자동검사 명령은 `Godot --headless --path . --script tests/game/<runner>`다. 신규 run_operations_ui_tests.gd에는 `-- --evidence`, 의도적 실패에는 `-- --verify-failure-exit`를 사용했다. 정확한 명령·실제 기대/결과·실행별 소스/로그 해시는 검증 JSON에 기록했다.

| 검사 | 실제 결과 |
| --- | --- |
| 신규 P1 공급 자동 | **158단언·실패0·exit0**, P1-01~11. 운행 집계/분수/cohort 누락·타입 반례, 정상 명령 공급, 재무/고정보고/조회 무효과·복구 포함 |
| 의도적 실패 감지 | P1-12의 실패1건을 **exit1**로 반환, 검사 PASS. 정상 합계에서 제외 |
| W01 / W02 / W03 / W04A / W05 / W06 | 각각 **219 / 309 / 101 / 204 / 191 / 179단언**, 실패0·exit0 |
| W07 / 입찰 UI / 공사 UI 자동 | 각각 **322 / 460 / 898단언**, 실패0·exit0. 기존 자동 포커스 검사는 실제 GUI 인수를 대신하지 않음 |
| 정상 자동 합계 | **3,041단언 PASS** = 신규158 + 기존 회귀2,883 |
| `Godot --headless --editor --path . --quit` | **exit0·SCRIPT ERROR/ERROR0**. 최종 `.local/validation/DEV-023_PROJECT_LOAD_20261115-080731.log` |
| `tools/policy.py doctor` | PASS / exit0. 훅·고정 도구 확인이며 원격 보호나 Owner 승인 인증은 아님 |
| `tools/policy.py check` 및 문서/경로/출처 감사 | **PASS / exit0**, files=631 / GDScript=45. 승인23개 중 실제12개·manifest11개+self·상대 링크36개·소스45개/로그 해시·UTF-8/LF·staged0 대조. .local/validation/DEV-023_FINAL_CHECK.log 및 DEV-023_FINAL_AUDIT.json |

신규 P1 최종 158단언 실행 뒤에는 지정 GDScript 3개의 CRLF→LF 정규화만 수행했다. 의미 변경은 없고 정규화 전/후 해시와 바이트 변환을 기록했다. 최종 프로젝트 로드·W07·입찰/공사 UI는 LF 파일에서 실행했다. 먼저 실행한 W01~W06의 전이 GDScript 의존성은 그대로이며, 그 뒤 보강한 P1 Session/신규 테스트는 해당 모델 테스트의 의존성 밖이다. 실행별 원래 해시를 보존하고 과거 검사를 최종 파일의 새 실행으로 소급 표시하지 않는다.

초기 신규 runner의 Variant 타입 추론 오류2건은 Dictionary 명시로 수정했다. 탐색 실패 로그와 이전 145단언 PASS는 .local에 보존하고 최종 158단언과 구별한다. 엔진 오류가 있는 탐색 실행을 정상 합계에 포함하지 않았다.

### L2 전달 자료·잔여·검토 요청

실제 **17개 공급 패킷**을 MODEL_CHAIN_SETUP/MODEL_FIXTURE/MODEL_FIXTURE_TO_CONSUMER/CONSUMER_FIXTURE로 구분했다. [실행계획 §7](../gate3/DEV-023_UI_SUPPLY_AND_EXECUTION_PLAN.md#7-p1-실제-공급-패킷--dev023-ui-1--local_review)에 DEV023-UI-1 필드/사유·소스 근거와 **Owner 복사·전달용 Design L2 요청문**을 준비했다. RFC-DEV-023-01은 LOCAL_DRAFT / NOT_SENT / DESIGN_ANSWER_PENDING이다. 외부 회신을 보내거나 Design 의견을 대신 작성하지 않았다.

- P2 Design L2 수용: **PENDING**. A(실적/재무·오류/만족도 표현), B(보고→조회/복귀), C(경량 운영 표현)를 실제 패킷과 대조해야 한다.
- P3 제품 main/Host/Map/P06/P07·씬 통합 및 새 GUI runner: **NOT_RUN**, 위 수용 후 진행한다.
- U01~U20 전체 UI 수용, 실제 마우스/키보드 GUI·플레이, Design 독립 GUI, DEV-024 VS-01 전체 완주: **NOT_RUN**. 현재 P1 부분 검증을 전체 PASS로 표시하지 않는다.
- 빌드/export·FPS·폰트/DPI 최종 인수·외부 사용성: **NOT_RUN**. 이번 자동검사의 소요 시간을 성능 인수로 쓰지 않는다.
- Commit·Push·PR·원격 CI/preflight·main 병합·외부 댓글/메시지: **NOT_RUN**, 현재 Owner 별도 승인 조건을 유지한다.
- DEV-026 구현·제품 검증: **OWNER_IMPLEMENTATION_DEFERRED / NOT_RUN**. 신규 Session 봉투의 필수 검사는 전역 root/run_scope·재생성·20예외 공통 구현 완료가 아니다.

현재 새 게임/경제 명세 변경 필요 **없음**. L2 보완이 모델 정책·공급 변경을 요구하면 영향과 RFC를 먼저 구체화한다. 기존 Q03~05 Design 수용·W05/OBS-01·Q12 한정 수용/상위 PARTIAL·F-08 및 DEV-024/HQ/Owner 인수의 잔여 상태는 유지한다. 검토 대상은 이 12개 로컬 파일과 P1 증거이며 Git 제출이나 전체 DEV-023 수용을 요청하는 결과가 아니다.

## 7. #79·#81 Design 회신 후 후속 결과 — 로컬 검토 요청

Owner의 후속 지시로 [#79 정본](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6885914882)과 [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6885920998)을 확인했다. **정적 공급·소비 검토는 완료됐고, 실제 화면 통합 L2 최종 수용은 보완 후 PENDING**이다. 기존 Owner 실행 승인과 담당 승계는 범위 §1.1~1.2에 연결했으며 원격의 NOT_VERIFIED 문구를 승인 취소나 재승인 필요로 해석하지 않았다.

L2-01~04에 대한 [단일 회신 패킷](../gate3/DEV-023_UI_SUPPLY_AND_EXECUTION_PLAN.md#8-design-l2-0104-후속-패킷--dev023-l2-input-1)을 준비했다. 실제 공급→화면/기간/단위/행동 매핑, T362 자금 부족·미지급·K 보호 입력, 제한→잔여 도착→B0/자금 부족→재개의 연속 입력, 필수 상태 색인과 P05/P06/P07/공고 복귀·경량 연출/검증 계획을 포함한다. 패킷 revision은 DEV023-L2-INPUT-1이다.

Design의 공개 restricted 지적은 확인됐다. 이전 DEV-022 추출은 T359 초기 객체였고 실제 제한 검사 시점 T362와 달랐다. 승인된 DEV-023 경로에 대체 증거를 연결했으며 기존 DEV-022 파일/모델은 변경하지 않았다. 실제 통제 연속 입력은 **T366 B50/A0 제한 → T367 B0/A50 비용 부족 → T368 B0/A150 재개**다. TEST_ONLY 수요·비용 의무 입력을 명시했고 자연 제품 플레이로 주장하지 않는다.

### 이번 변경·검증

- 기존 승인12개 로컬 파일 중 **8개 후속 변경**: 신규 run_operations_ui_tests.gd의 L2 분기, 범위/실행계획/검증계획/결과4개, fixture/validation/provenance3개. Session 제품 소스·모든 모델·기존 테스트/fixture/UID는 P1 검토본과 동일하다.
- 기존 P1 입력17개를 값 변경 없이 보존하고 **보완 입력8개**를 l2_supplement에 추가했다. 원래 검증 기록·소스/로그 해시와 .local의 P1 전체12개 파일 사본도 보존했다.
- 신규 보완 자동검사 **55단언 PASS·실패0·exit0**, 의도적 실패1건 **exit1 확인 PASS**, SCRIPT ERROR/ERROR0. 기존 3,041단언은 과거 실행으로 보존하고 이번 신규 실행에 합산하지 않는다.
- 최종 정책·출처/경로·이전 기록 보존 검사: **PASS / exit0**. doctor·policy check(files631/GDScript45), 실제12개/후속8개 경로, manifest11개+self, 상대 링크41개, P1 시험 함수13개·원본 검증 JSON/입력17개 보존, 소스·로그 해시·UTF-8/LF·staged0 확인. .local/validation/l2-followup/policy.json 및 audit.json에 기록했다.
- 원격 최신 main 30cc2ea의 추가 변경은 HQ5개/POST-MVP Planning3개뿐이다. PM-017 인수표를 원격 고정 SHA로 대조했고 제품/테스트/규칙/승인 MVP 의미 차이 없음. 로컬 base e379e58와 branch/공용 main은 변경하지 않았다.

### 진행·남은 조건

L2-01~04의 개발 보완안은 **DEV_RESPONSE_READY / LOCAL_REVIEW / NOT_SENT**다. Design 수용을 대신 선언하지 않았으며 UI 통합/실제 GUI는 해당 수용 뒤 진행한다. 새로운 commit SHA는 없고 base+실제 blob/SHA-256으로 로컬 시험본을 고정했다. Owner 전달용 회신안도 단일 패킷 끝에 포함했다.

새 게임/경제 명세 변경 필요 없음. Q12 원래 P05 인계·복귀는 추가 GUI 불필요라는 공식 판정을 유지하고 상위 PARTIAL·오류 정정/환경 미확인 등 기존 기록 잔여는 별도로 보존한다. 제품 UI·Design 독립 수용·DEV-024 실제 표준 완주·HQ/Owner 인수는 남아 있다. 이번 후속 프로젝트 editor 로드/실GUI/빌드·Git/원격 댓글/CI/preflight는 **NOT_RUN**이며 **DEV-026 구현·제품 검증 보류**를 유지한다.

## 8. Owner 원격 PR 제출 승인·출처 고정 — 후속 기록

Owner가 “해당 구현 내용을 원격 저장소 PR로 생성해주세요”라고 직접 지시했다. [범위 §1.3](DEV-023_W06_OPERATIONS_UI.md#13-owner-원격-pr-제출-승인--2026-11-15)에 Commit·일반 Push·PR/필수 CI 확인의 대상·기간·제외를 기록했다. §6~7의 미커밋/NOT_SENT/원격 NOT_RUN은 로컬 검토 시점 기록이며 이번 PR 게시 이후의 상태를 대신하지 않는다. 원격 head·PR·필수 CI는 실제 PR 본문/Checks 및 제출 결과에 연결한다.

제출 parent/base는 30cc2ea5f6e7c03aebff1315b6fd00530871ebec다. 기존 구현·시험 base e379e58 이후 HQ/POST-MVP 문서8개만 진전했다. DEV-023 브랜치만 fast-forward했고 검토받은 12개 파일을 모두 보존했다. 이후 제품·테스트·fixture/validation JSON은 변경하지 않고 승인/제출 문서와 manifest만 갱신했다. 공용 main과 타 작업물은 보존했다.

제출 범위는 Session 공급1개·신규 테스트/fixture와 UID4개·문서/증거7개로 총12개다. 기존 P1 정상3,041단언 및 프로젝트 로드, 후속 L2 55단언/의도적 exit1은 각각 당시 소스 해시의 실행으로 보존한다. 새 원격 SHA의 전체 게임 재실행으로 소급하지 않는다. 제출 전 doctor/check·파일/경로·해시·출처 확인, 정상 Git 훅과 커밋 후 preflight, 제출 head의 policy/department-policy를 확인한다. 검사 우회나 신규 제품 범위 추가는 없다.

**Design 최종 L2 수용과 제품 main/Host/Map/P06/P07·씬 통합·실제 GUI는 후속이다. main 병합은 별도 승인 대기이며 DEV-026 구현·제품 검증 보류를 유지한다.** PR 제출을 전체 DEV-023 DONE·Issue 종료·Stage 인수로 처리하지 않는다.
