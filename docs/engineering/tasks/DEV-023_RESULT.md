# DEV-023 — 착수 준비와 P1 공급 구현·검증 결과

- 담당: Development Project Leader / AGT-DEV-0004 / 2026-11-15 (Asia/Seoul).
- 상태: **P3_MERGED / DESIGN_L2_ACCEPTED / INDEPENDENT_GUI_24_CONDITIONS_ACCEPTED_STAGE_CLOSED**. DEV-023 전체 DONE·상위 인수와 구별한다.
- 현재 P3 기준 main: `3e2982ac71be28344c3be5360652f4071c678ce3`. 이전 P1 기준은 각 실행 이력에 보존.
- 후속 기록 브랜치: `codex/DEV-023-design-acceptance-note`. §10의 로컬 검토 기준은 a9ce63a, 현재 제출 기준은 `9d6b4614b6eeeb2f3a3410e584de12329bc251f5`이며 이번 Git 승인·HQ의 별도 Owner DONE 결정은 §11을 따른다.
- 이전 구현 브랜치 `codex/DEV-023-operations-screen-integration`의 PR #128은 병합됐다. 당시 P3 검증 기준은 위 SHA와 §9에 보존한다.

> §1~5는 Owner 실행 승인 전 준비 기록, §6은 최초 P1 검토 결과다. Design 회신 후 보완 결과는 §7, 이전 원격 제출 승인·단계는 §8, P3 통합 당시 결과는 §9, 현재 독립 GUI 수용 후속 기록은 §10을 따른다. 이전 PENDING/PARTIAL/NOT_RUN과 실행 증거를 소급 변경하지 않는다.

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

## 9. Design L2 수용 후 P3 화면 통합 결과

Owner의 최신 후속 구현·PR 지시와 [Design L2 정본](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6886354300)을 범위 §1.4에 연결했다. **L2-01~04/RFC L2-A/B/C ACCEPTED**, P2 공급 협의 선행 조건 해소다. PR #127 병합 main 3e2982ac71be28344c3be5360652f4071c678ce3에서 codex/DEV-023-operations-screen-integration으로 진행했다. 공식 제품 인수/DONE이나 main 병합 승인은 아니다.

### 구현과 파일

승인23개 중 **17개 파일**: scripts/main.gd, stage1_view.gd, stage1_map.gd 수정; operations_view.gd/finance_view.gd와 UID, operations_panel.tscn/finance_panel.tscn, run_operations_gui_cases.gd와 UID 신규; 범위/결과/공급계획/검증계획 4개와 validation/provenance 2개 갱신. Session·모든 모델·기존 테스트·P1 fixture 생성기/runner·fixture JSON·DATA·설정·타 부서 파일은 보존했다.

- 제품 초기화에서 W06 명시 활성화. 개통 전/실패를 정상0으로 숨기지 않고 기존 W07 격리 fixture를 유지한다.
- P06 운영 실적/현재 이동 중·만족도 원분수·별도 예상, P07 현재 재무/당일 흐름/고정 마감 보고·실제 첫 보고 조회를 연결했다. 오류/없음/0, 운영비 지급 합계와 공사 기성을 분리했다.
- S01/P05→P06/P07→P01 왕복의 반환 화면·보고일·선택·포커스/스크롤을 보존한다. accepted=true에서만 조회 이동하며 역순 모델/View 관측을 거부한다.
- 실제 운영선/OD/cohort의 대표 이동·역 집계 표시와 가까운 설명을 추가했다. 시간/원장/수요/도착을 연출이 만들지 않는다.
- 새 패널 읽기 키는 Home/End가 컨테이너에 선소비되지 않게 처리한다. 숨은 패널 입력/갱신 포커스 이동과 기존 P05 입력의 범위를 분리했다.

### 검증과 관측

신규 **AUTO_UI 202단언 PASS / 실패0 / exit0**. 의도적 실패1은 **exit1 확인 PASS**이며 정상 증거 파일과 분리한다. 기존 W07 322, 입찰 UI460, 공사 UI898 회귀는 각 PASS다. 자동 실행은 각각의 실제 소스/로그 해시에 고정했다. 공사898은 최종 새 패널 읽기 키/문구 전 실행이며, 최종 U17 P05 왕복을 새 검사로 보완했다. 전체1882를 단일 최종 head 실행으로 주장하지 않는다. 이전 P1 3041과 L2 55도 원래 실행으로 보존한다.

Godot 4.7.2 / Python3.12 / gdtoolkit4.5.0. 명령은 기존 run_checks.py가 보관한 실제 명령을 검증 JSON에 기록했다. 신규 자동은 Godot --headless --path . --script tests/game/run_operations_gui_cases.gd -- --auto, 실패는 --verify-failure-exit, 로드는 --headless --editor --path . --quit이다. 실행별 exit·SCRIPT ERROR/ERROR 검사를 적용했다. 최종 LF 정규화·정상/실패 원본 증거 파일 분리 후 신규 자동/실패/프로젝트 로드를 다시 실행했다.

DEV 자체 REAL_GUI는 G01~G06으로 구분한다. 제품 main 초기화·개통 전/보고 없음, 정상 명령 초기화의 현재/고정 보고·첫 조회/복귀·Tab/Space/End, 미지급 제한/R 보호, 800x600(논리 viewport1152x864)의 긴 분수/큰 금액/Home/End, 실제 운영선의 정지/재개/1·2·4배속, 만족도 산술 오류를 관측했다. 각 실행은 종료0이며 캡처·로그·해시를 로컬 .local에 보관하고 검증 JSON에 색인했다. 초기 제한 fixture 로그 minute360은 backing pipeline이며 실제 표시 T362와 구별하도록 후속 runner에서 필드를 분리했다.

첫 탐색의 타입 추론 오류, 새/기존 노드 이름 충돌, 작은 창 Home 선소비, 만족도 오류의 미산출 혼동 및 자동 원본 덮어쓰기 문제를 수정했다. 실패/탐색 로그를 PASS 합계에 포함하지 않았다. source hash는 실행별로 보존하고 이후 문구/바이트 변경을 소급하지 않는다.

### 잔여와 검토 요청

[검증 계획 §9](../gate3/DEV-023_UI_VALIDATION_PLAN.md#9-p3-실행-결과-행별-인계)와 JSON의 20행은 AUTO/DEV GUI/독립 인수를 구분한다. **U01~U20 전체 GUI PASS가 아니다.** 정상수요0·CLOSE-01 전용00:09·회복 연속·역순 응답의 직접 GUI·계산 완료 예측 등 미관측 조건은 명시된 후속이다. Design 독립 GUI는 PENDING이며 수용한 공급 L2를 다시 열지 않는다. DEV-024 자연 전체 완주/Windows build/export/FPS/DPI 확정은 NOT_RUN이다.

기존 Q03~05·W05·OBS-01·Q12 한정 수용/원래 P05 인계 종료 가능과 상위 PARTIAL, 환경/DPI·기존 ERROR 정합성·R02 등의 별도 상태를 보존한다. DEV-026 구현·제품 검증 보류 유지. 새 게임/경제 명세 변경 필요 없음. 이 PR은 P3 구현·DEV 검증 결과의 검토 요청이며 main 병합·Stage DONE 승인이 아니다.

후속 증거 감사: 반복 실행한 long/만족도 GUI 프로필에서 각각 shader cache 하위 경로 생성 ERROR68건(스크립트 오류0)을 확인했다. 해당 로그를 정상 PASS에서 제외하고 짧은 실행별 .local/g23 프로필로 분리해 G03/G06을 다시 관측·종료0·SCRIPT ERROR/ERROR0으로 확보했다. 엔진/OS의 정확한 원인은 확정하지 않았고 캐시·safe-save·제품 설정을 끄거나 변경하지 않았다. 기존 환경/DPI 인수의 해소로 확대하지 않는다. 엔진이 생성한 untracked 이미지 .import151개만 원본 자산/추적 여부 확인 후 제거했으며 원본은 보존했다.

## 10. Design 독립 GUI 24조건 수용 수신 — 후속 기록

Owner의 이번 지시: “개발 에이전트. 디자이너 에이전트가 원격 저장소의 79번, 81번 이슈에 회신을 등록했으니 확인하여 응답 및 조치가 필요한 부분이 있으면 진행해주세요”.

[Design #79 최종 정본](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6887989037)과 [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6887995179)을 확인했다. **기존 IG1115A 21조건 + SUP1115B 보완3조건 = CASE_MATRIX 총24조건 한정 수용, 합의된 독립 GUI 검수 단계 종료**다. 해당 범위에 미충족 필수 조건이나 추가 구현·증거 재공급·GUI 재실행 요청은 없다. U01~U20 모든 조합 PASS, DEV-023 전체 DONE, Issue 종료 또는 Stage 최종 인수로 확대하지 않는다.

### 근거·이력·확인 수준

- PR #128 제출 head `b1d9da850960627297651fb42fef2f89353a7daf`와 병합/독립 시험 SHA `bf99dd11f3d8cd4d6dc07e38de164cd0b27f8dba`의 tree diff 없음.
- fetch 후 최신 main `a9ce63a09e0778435bb8c7ef1fd0501aa10f430d`를 확인했다. 시험본 이후 변경은 POST-MVP 기획 문서3개뿐이며 제품·시험·설정 변경 없음. SHA 진전 자체를 GUI 재실행 사유로 삼지 않는다.
- [앞선21조건 수용·PARTIAL 정본](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6887692818)의 당시 3조건 NOT_RUN은 최종 판정으로 해소됐다. 원래 PARTIAL/NOT_RUN 기록은 유지하고 후속 판정을 별도로 연결한다.
- 원본은 Owner 보관이며 이번 DEV 작업에서 ZIP을 새로 수신·재해시하거나 독립 GUI를 재실행하지 않았다. 아래 원본 크기·해시·파일 감사·종료 결과는 **Design이 확인해 공개한 판정의 인용**이다. DEV 신규 실행으로 합산하지 않는다.

| Owner 보관 원본 | 크기 / SHA-256 | Design 심사 범위 |
| --- | --- | --- |
| DEV-023-INDEPENDENT-GUI-20261115-IG1115A.zip | 13,855,687 bytes / `ebaa73558475895cfe10540606fc8d33c0f4299b887edbb83bd28f1558b95195` | 파일362/362, 원격 시험 소스644/644·실제 주입22/22 대조, 원래21조건 수용 |
| DEV-023-INDEPENDENT-GUI-SUPPLEMENT-20261115-SUP1115B.zip | 6,344,934 bytes / `0e95d4ca611af091c5f091f0fba84acce571ce841e7b049b1e3597ef47e469c1` | 파일108/108, 소스644개 및 실행 전 도구 사본/해시 대조. B01·B02 exit0, ERROR/SCRIPT ERROR0 |

### 보완3조건의 수용 범위

| 원본 CASE_MATRIX 행 / 검증 행 | 최종 판정과 관측 범위 |
| --- | --- |
| 행17 / IG-06 U11 | PASS. 같은 Session/Host에서 실제 이전 Day1 응답을 Day4 표시 후 전달해 거부. 보고·키·본문·조회 허용·버튼 포커스·scroll605와 게임 효과 유지. 주입 뒤 재선택/비교 기준 초기화로 복구한 증거가 아님 |
| 행22 / IG-08 U18·U19 | PASS. 525자 한국어 불가 사유가 800×600에서 끝까지 표시되고 키보드 상세/복귀 접근·사유 유지 확인. CONSUMER_FIXTURE 범위이며 자연 모델 실패 발생 증거로 확대하지 않음 |
| 행25 / IG-08 U17 | PASS. P05 실제 입력의 이동 직전/제품 저장/복귀 scroll234→234→234, 포커스·공사 공급·게임 효과 유지. 코드로 scroll/context를 강제한 결과가 아님 |

기존21조건의 정확한 행·TEST_ONLY/소비 사본·관측 한계는 앞선 정본을 재사용한다. CLOSE-01은 R12로 이미 보완됐으며 다시 미검증으로 되돌리지 않는다. 신규 상태 색인은 [검증 JSON](../gate3/DEV-023_UI_VALIDATION.json)의 `design_independent_acceptance`다. 기존 root·l2_followup·p3_integration 등 모든 값은 변경하지 않았다.

### 유지할 잔여와 필요한 조치

- A01-Q12 상위 PARTIAL, Q03~05·QA-001/002·Q12 28조건·W05/OBS-01·A02-11·원래 P05 인계/복귀 종료 가능 판단 및 L2 수용을 각각의 원래 범위로 보존한다.
- 일부 IG1115A R03~R11 실행 당시 보조 도구 바이트, 초기 import/캐시 오류의 정확한 원인·물리 DPI/과거 창 동등성은 NOT_VERIFIED다. 최초 비프로필 전체 콘솔과 Q12 R02 종료 NOT_CAPTURED, R13/R14 timeout·exit4294967295, R09 당시 PARTIAL은 이력으로 보존한다.
- Q12 ERROR 집계2→7의 인계 정정 연결 완료 NOT_VERIFIED 등 기록 잔여는 별도다. 이번24조건의 새 차단 조건으로 편입하지 않는다.
- 남은 상위 인수는 DEV-024의 자연 표준 VS-01 완주·HQ 증거 통합·Owner 최종 판단이다. 수용된 GUI 증거는 실제 관측 범위에서 재사용한다. 이번 지시로 DEV-024 제품 실행·새 Git 권한 또는 완료를 선언하지 않는다.
- Track B/F08-01~04·최종 규격·빌드/export/FPS·모든 문맥×키 조합의 별도 범위와 DEV-026 구현·제품 검증 HOLD를 유지한다.
- 현재 필요한 조치는 수용 결과 기록·#79 정본 응답/#81 연결이며 제품 수정이나 추가 GUI는 없다. 관련 코드/계약/환경 변화, 새 결함 또는 증거 신뢰성 문제 발생 시 PM-015에 따라 영향 행만 재개방한다.

### 이번 수행과 로컬 검토

실제 변경은 본 결과서, 검증 계획의 후속 §10, 검증 JSON 색인 **3개 문서/증거 파일**이다. 제품·테스트·fixture·기존 provenance 제출 manifest는 그대로이며, manifest는 PR #128 당시 출처 기록으로 보존한다. 새 Git 제출이 승인되면 해당 제출의 base/변경 목록으로 별도 갱신한다.

이번 정적 확인은 doctor, git diff/tree 대조, JSON 이전 필드 보존·24행 집계·근거 링크·허용 경로 검사, policy check다. 검증 로그는 로컬 `.local/validation/design-acceptance/`에 둔다. **게임 자동 테스트 / Godot 프로젝트 로드 / 실제 GUI·플레이 / 빌드·export·FPS: NOT_RUN**이며 문서 수신·정적 기록 작업이므로 재실행하지 않았다. 기존 자동·GUI·CI 결과는 원래 실행으로 보존한다.

게임/경제 명세 변경 필요 없음. 신규 Commit·Push·PR·병합은 수행하지 않고 로컬 결과부터 검토 요청한다. 이번 결과나 회신을 공식 DONE/상위 인수로 처리하지 않는다.

후속 회신: [개발 #79 정본](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6888066340)과 [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6888069422)을 게시하고 등록 본문 일치를 재조회로 확인했다. 이번 정적·정책 검사 PASS, 기존 JSON 필드/결과서 §1~9 및 검증 계획 이력 보존, 수용24행 중복 없음·근거 링크·시험본 동등성을 확인했다.

## 11. Owner 후속 기록 제출 승인·HQ 완료 결정 연결

Owner의 이번 개발 대화 지시:

> DEV-023 로컬 후속 기록 3개 파일을 승인합니다. codex/DEV-023-design-acceptance-note 브랜치에 Commit·Push하고 PR을 생성한 뒤 필수 CI 결과까지 확인해주세요. main 병합은 별도 승인하겠습니다. DEV-026 구현·검증 보류는 유지합니다.

대상은 wisberry2022/MetroManager / DEV-023 / AGT-DEV-0004 / codex/DEV-023-design-acceptance-note → main이다. **승인된 결과서·검증 계획·검증 JSON 3개 파일만** Commit·일반 Push·PR·필수 CI 확인에 제출한다. 유효 기간은 이번 제출 및 동일 범위 보완 종료 또는 Owner 철회까지다. main 병합·직접 쓰기·강제 Push·릴리스·배포·추가 제품 구현·DEV-026 보류 해제는 포함하지 않는다. §10과 JSON의 LOCAL_REVIEW_ONLY는 승인 전 검토 시점 기록이며 이 절이 현재 Git 권한의 근거다.

### 최신 통합 기준과 별도 Owner 완료 결정

fetch한 최신 main은 `9d6b4614b6eeeb2f3a3410e584de12329bc251f5`다. 로컬 검토 기준 a9ce63a 이후 Design2개·HQ5개 문서만 추가 변경됐으며 개발 제품/검증 파일은 동일하다. 승인된3개 파일의 바이트를 이전 감사 SHA-256과 대조하고 사본을 보존한 뒤, 이 작업 브랜치만 최신 main으로 fast-forward했다. 공용 main과 다른 worktree의 작업은 변경하지 않았다.

[HQ PM-018 Owner 결정](../../hq/tasks/PM-018_DEV023_CLOSEOUT.md)과 [결과](../../hq/tasks/PM-018_RESULT.md), [#79](https://github.com/wisberry2022/MetroManager/issues/79)를 확인했다. **DEV-023은 별도 Owner 결정에 따라 OWNER_ACCEPTED / DONE이며 #79는 CLOSED/completed**다. Design의 24조건 한정 수용이 스스로 전체 DONE을 부여한 것이 아니므로, §10의 당시 한정 수용/권한 경계는 그대로 보존하고 이 후속 결정을 연결한다. 현재 기록 근거는 위 최신 main의 PM-018이며 해당 문서의 MAIN_MERGE_PENDING은 작성 시점 이력이다.

DEV-024 자연 표준 VS-01·최종 영향 회귀, HQ 증거 통합 및 Owner 최종 Stage 인수는 후속이다. 기존 A01-Q12 상위 PARTIAL·환경/기록 잔여·Track B/F-08 별도 범위 및 DEV-026 구현·제품 검증 HOLD는 유지한다. 이번 PR 제출을 전체 S2 PASS·Stage DONE으로 확대하지 않는다.

### 제출 범위·검증·출처 보고의 한계

기존 승인3개 파일 안에 이번 제출 승인·최신 HQ 근거만 후속으로 연결한다. 검증 계획은 승인본 그대로이며, 검증 JSON의 기존 P1/L2/P3·Design 판정 원본 값과 결과서 §1~10은 보존한다. 제품·테스트·fixture·정책·CI·타 부서 파일 변경 없음. 게임 자동검사·Godot 로드·GUI/플레이·빌드/export/FPS 및 원본 ZIP 재해시는 이번에도 NOT_RUN이며 기존 수용을 새 실행으로 합산하지 않는다.

기존 `DEV-023_PROVENANCE.json`은 PR #128의 base/16개 artifact를 설명하는 제출 당시 기록이다. 이번 Owner가 지정한 **3개 파일 범위를 유지하기 위해 해당 네 번째 파일은 수정하지 않는다**. [DEV-016 보고 운영 규정](../provenance/DEV-016_INF_REVIEW_AND_ROLLOUT.md)의 비필수 REPORT_ONLY 검사에서는 이전 manifest와 현재 제출 base의 차이로 MANIFEST_BASE 진단이 예상된다. 이를 출처 일관성 PASS나 신원/승인 인증으로 표시하지 않고 실제 진단을 PR/CI 결과에 공개한다. 정책/CI를 수정하거나 우회하지 않는다. 이번3개 파일의 경로·blob·변경자는 실제 Git diff, Commit/PR Agent-ID·Task-ID 및 제출 검증으로 별도 확인한다.

제출 검사는 doctor/check·승인본 보존/JSON/링크/경로·git diff --check, 정상 Commit/Push 훅, 커밋 후 preflight와 실제 제출 head의 **policy·department-policy**를 따른다. 정확한 commit/PR/CI 결과는 해당 PR 본문·Checks에 기록한다. main 병합은 별도 승인 대기다.
