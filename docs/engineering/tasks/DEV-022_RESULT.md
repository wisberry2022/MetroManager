# DEV-022 — PR #120 확인·HQ 후속 착수 준비 결과

- 담당: Development / AGT-DEV-0004 / 2026-11-14.
- 상태: **OWNER_LOCAL_RESULT_ACCEPTED / GIT_SUBMISSION_APPROVED / MAIN_MERGE_PENDING**.
- 실행 기준 main: `2507cda419ed27e96c5d64ced7666ed7a2e58227`. 최초 준비 기준은 `3db401fc19b03e8719e4cccd741a8e1afe3df119`.
- 로컬 브랜치: `codex/DEV-022-operations-model`. 별도 worktree의 미커밋 로컬 결과다.
- [착수 범위·권한](DEV-022_W06_OPERATIONS_MODEL.md), [공급·실행·L3](../gate3/DEV-022_W06_SUPPLY_AND_EXECUTION_PLAN.md), [검증 계획](../gate3/DEV-022_W06_VALIDATION_PLAN.md).

최신 구현·검증 결과는 **§5 후속 기록**이다. §1~4의 최초 준비·NOT_RUN 기록은 당시 이력으로 보존하며 현재 상태와 구별한다.

## 1. PR #120과 DEV-026 — 최초 준비 기록

Owner의 병합 승인 후 원격 확인 시 [PR #120](https://github.com/wisberry2022/MetroManager/pull/120)은 **이미 MERGED**였다. 이번 DEV-022 준비 작업에서 merge 명령을 실행하지 않았다.

- 제출 head: `779583d7fc100a160ecad11dc163a94ad677a3f8`.
- main 병합 SHA: `3db401fc19b03e8719e4cccd741a8e1afe3df119`.
- GitHub merged_at: `2026-11-14T12:18:55Z` (Asia/Seoul 21:18:55).
- head↔병합 SHA tree diff 없음. DEV-026 검토 Markdown 4개와 출처 JSON 1개의 병합을 확인했다.
- 제출 head의 최신 [policy 실행](https://github.com/wisberry2022/MetroManager/actions/runs/43594081891)과 [department-policy 실행](https://github.com/wisberry2022/MetroManager/actions/runs/43594082290)은 SUCCESS. provenance 실행은 SUCCESS이나 `REPORT_ONLY / AGENT_UNREGISTERED` 관측을 등록 완료로 해석하지 않는다.

DEV-026의 `OWNER_IMPLEMENTATION_DEFERRED`는 유지한다. 해당 문서에 남은 과거 제출/미실행 기록을 지우지 않는다. DEV-022~025 선행 후 재개 시 최신 실제 공급·UI 변경과 적용 범위를 다시 대조한다.

마지막 원격 확인에서 [INF-010 PR #121](https://github.com/wisberry2022/MetroManager/pull/121), head `12c7a6a76a4d09c0010453499d7503acb7454e5a`가 새로 제출됐다. 전임 은퇴·후임 활성화와 17:37 효력의 후속 등록이며, 공개 PR은 Owner가 이번 등록 실행을 AGT-INF-0002에게 위임했음을 기록한다. 확인 시 OPEN/미병합으로 main은 위 SHA 그대로다. 과거 Owner 직접 처리 지정과 최신 후속 담당을 구분해 티켓에 반영했다. 업무상 승계는 유지하고 등록 상태는 REGISTRY_RECORD_PENDING이다. #121의 병합은 이번 #120 병합 승인에 포함하지 않는다.

## 2. HQ 확인과 후속 처리 — 최초 준비 기록

이번 확인 기준 main에는 [PM-016 PR #119](https://github.com/wisberry2022/MetroManager/pull/119), merge `2baed0518e5443007c159962bfba46a8eeae5fdb`의 [S2 통합 인수표](../../hq/STAGE2_ACCEPTANCE_MATRIX.md)가 반영돼 있다. [GUI 증거 재사용 규약](../../hq/GUI_REVIEW_PROTOCOL.md) 및 PM-014 원래 승인 범위를 함께 확인했다. 문서 작성 당시의 PR_REVIEW 문구와 실제 병합 상태를 구분한다.

원격 HQ의 후속 종료 정리는 #24/#25/#26/#38/#46/#51/#74/#76에 연결돼 있다. 분석·모델/자동 범위 종료를 Stage 2 전체 DONE으로 확대하지 않는다. #74/DEV-018과 #76/DEV-020의 기존 모델 근거를 재사용하되 UI/통합 잔여는 #75/#77/#78/#79/#80/#81에 유지한다. #78은 확인 시 OPEN·댓글0·EXECUTION_APPROVAL_PENDING이다. 공개 담당명은 과거 기록이며 현 담당·승계는 티켓에 명시했다.

| HQ 후속 | 이번 준비 결과·담당 경계 |
| --- | --- |
| DEV-022 실행 패킷 우선 | 현 담당/기존 권한 승계, 정확한 미래 제품·테스트10개/문서·증거8개 경로, W05 공급→W06 소비, 함수와 L3 영향·검증 제안 |
| S2-06/07 실제 운행·정산·보고 | OD/carry/cohort·공유 U10·비용/도착 운임/B·만족도·자정 고정 보고 계획 |
| S2-09 다음 조회 | 첫 실제 유효 영업 보고와 원본 공고 조회 공급. 현재 CLOSED/BUSY를 숨기거나 새 회차/두 번째 수주를 추가하지 않음 |
| S2-08/10 실제 화면·완주 | DEV-023 활성화/최소 UI·Design L2 → DEV-024 실제 VS-01 전체 GUI. DEV-022 자동 연결만으로 완료 처리하지 않음 |
| Q03~05·Q12 | Q03~05 종료와 Q12 한정 수용 재사용. Q12 상위 PARTIAL·원래 행 색인 대조는 HQ/Design 병행 잔여. 새 결함 근거 없이 전체 재검수 요청 없음 |
| DEV-025/F-08·DEV-026 | 각 적용 시점 유지. 최종 규격을 최소 모델의 일괄 선행조건으로 추가하지 않으며 DEV-026 구현/제품 검증 보류 |

## 3. 소스 대조의 결론과 미해결 — 최초 준비 기록

기술적 W05 개통 입력과 원장·시각 기반은 존재한다. 현재 Pipeline의 arrival_fare는 시험 주입이므로 실제 OD 운행 공급은 새로 구현해야 한다. 회사 원장과 수요 예측기의 공개 함수는 읽기 재사용하고, 새로운 서비스·노선 모델 및 Pipeline/보고의 제한적 변경으로 시작하는 것이 적절하다.

실제 공급이 제품에서 활성화되는 시점은 DEV-023이다. DEV-022는 정상 명령 기반 모델 연결과 공급 증거를 책임진다. 이를 명시해 사용자 화면 없이 실제 경제가 조용히 활성화되는 범위 확장을 피한다. MODEL_CHAIN·MODEL_FIXTURE·CONSUMER_FIXTURE와 실제 GUI를 구별하는 18개 검증 행을 준비했다.

현재 **명세 변경 필요 없음**. 다만 구현·검증은 미실행이므로 L3 안전성 확인이나 인수 PASS를 선언하지 않는다. 향후 정확한 공급 필드/사유·fixture의 Design L2, 실제 구현/검증 및 개별 Git 권한, DEV-023/024 후속 실행·HQ/Owner 인수는 남아 있다. 미확정 F-08/등록부 지연/Q12 상위 PARTIAL을 DEV-022 전체 차단으로 추가하지 않는다.

## 4. 최초 로컬 준비 산출물과 검사

새 Markdown은 아래 4개뿐이다. 제품/테스트/씬/데이터·타 부서 파일은 변경하지 않는다. 기존 root 및 DEV-019/DEV-026 worktree의 작업물을 보존한다.

| 파일 | 내용 |
| --- | --- |
| [DEV-022_W06_OPERATIONS_MODEL.md](DEV-022_W06_OPERATIONS_MODEL.md) | Owner 지시·승계·포함/제외·정확한 미래 경로·단계/권한 |
| [DEV-022_W06_SUPPLY_AND_EXECUTION_PLAN.md](../gate3/DEV-022_W06_SUPPLY_AND_EXECUTION_PLAN.md) | 실제 소스/신규 제안, 권위 ID·분 순서·경제·보고/조회·L3 |
| [DEV-022_W06_VALIDATION_PLAN.md](../gate3/DEV-022_W06_VALIDATION_PLAN.md) | W06-01~18·수치 oracle·명령·영향 회귀·증거/종료 기준 |
| 본 결과서 | 원격 확인·HQ 반영·로컬 검사·잔여 상태 |

검사 환경은 기존 DEV-026 worktree의 `../DEV-026-s01-exception-contract/.venv/Scripts/python.exe`를 읽기 재사용한다. PYTHONUTF8=1, TEMP/TMP는 이 worktree의 .local/temp다. 정책 검사는 제품 실행 또는 원격 보호 검증이 아니다.

| 이번 검사 | 결과·증거 |
| --- | --- |
| `tools/policy.py doctor` | PASS / exit0. 로컬 훅·도구만 확인 |
| `tools/policy.py check` | PASS / exit0, files=604 / GDScript=39, 포맷 변경 없음. `.local/validation/DEV-022_POLICY.log` |
| 일회성 정적 감사: UTF-8/LF/링크·현재/미래 경로·검증 행·기준 SHA·원본 보존 | PASS / exit0, Markdown 4개·상대 링크31개·미래 경로18개·W06-01~18 대조. `.local/validation/DEV-022_STATIC_AUDIT.json` |
| `git diff --check`, tracked/staged 변경과 신규 파일 대조 | PASS. tracked/staged 변경0, 신규 Markdown 4개만 존재. 제품 소스 blob 보존 및 root/DEV-019/DEV-026 기존 상태 확인 |

- DEV-022 구현/신규 테스트 작성: NOT_RUN.
- 게임 자동검사·Godot 프로젝트 로드: NOT_RUN.
- 실제 GUI/키보드·게임 플레이·VS-01: NOT_RUN.
- 빌드/export·성능·폰트/DPI·외부 사용성: NOT_RUN.
- Design 독립 L2/GUI·HQ 통합/Owner 최종 인수: NOT_RUN.
- DEV-022 Commit·Push·PR·새 원격 CI·preflight·병합·외부 댓글/메시지: NOT_RUN.
- DEV-026 구현·제품 검증: OWNER_IMPLEMENTATION_DEFERRED / NOT_RUN.

이번 결과는 **로컬 검토 요청**이며 실행/Git 승인이나 DONE 처리가 아니다. 기존 승인 정책과 수용 증거는 보존하고 새 실행 범위만 검토할 수 있도록 준비했다.

## 5. Owner 승인 후 로컬 구현·검증 — 2026-11-14

Owner는 위 검토안의 정확한 범위로 구현·검증하고 로컬 결과부터 검토 요청하도록 승인했다. 원문·유효 범위는 [티켓 §1.1](DEV-022_W06_OPERATIONS_MODEL.md#11-owner-로컬-구현검증-승인--2026-11-14)에 기록했다. Commit·Push·PR·main 병합은 별도 승인으로 유지하며 수행하지 않았다.

실행 전 fetch와 main 대조 결과 추가 변경은 INF-010 등록부/문서3개뿐이었다. 기존 로컬 검토안을 보존한 DEV-022 작업 브랜치만 `2507cda`로 fast-forward했다. main 브랜치 수정·새 커밋 생성은 없으며 AGT-DEV-0004 등록은 **REGISTRY_RECORDED**다. 17:37 업무 효력과 이후 등록/병합 시각은 구별한다.

### 구현 결과와 실제 동작

실제 W04A/W05 공급의 권위 사업·공사 ID/지급/조건/개통을 연결해 OD 요청·탑승·정수 미탑승·소수 carry·이동 cohort·도착 운임을 구현했다. 공유 U10, 허용 서비스 구간당 비용100, R/K 보호·B 정산 후 재개, 유리수 만족도·고정 일일보고·첫 유효 실적 보고 이후 조회 공급을 포함한다. CompanyLedger/DemandPredictor/기존 W05·시각 코드는 읽기 재사용했다.

정상 명령 기반 자동 실행에서 **T4805 개통 → T5760 Day4 마감**을 확인했다. 요청/탑승4296, 미탑승0, 완료4291, 운임429100, 서비스955분/운영비95500, 만족도50→55다. 마감 C1533600/R200000/F1333600/K0/B0이며 실제 실적 보고를 참조한 다음 공고 조회가 가능하다. 기존 공고의 실제 마감/자격 상태를 보존하고 두 번째 수주를 만들지 않았다.

DEV-022는 모델 opt-in을 제공한다. 실제 제품 Session 활성화·P06/P07/S01·사용자 다음 사업 조작은 DEV-023, 전체 VS-01 실제 GUI는 DEV-024에 남는다. 이번 모델 자동 연결을 실제 게임 플레이 완료로 표시하지 않는다.

### 변경 파일 — 승인된 18개 경로

| 구분 | 실제 변경 |
| --- | --- |
| 신규 모델/서비스 4개 | `scripts/model/operating_line.gd`와 UID, `scripts/simulation/operations_service.gd`와 UID |
| 공통 연결 수정 2개 | `scripts/simulation/minute_pipeline.gd`: 명시적 활성화/단계·조회/fixture 충돌 방지. `scripts/model/daily_ledger_report.gd`: 누적 운행 사본·마감 불변 |
| 신규 자동검사 4개 | `tests/game/run_w06_tests.gd`·`w06_fixtures.gd`와 각각 UID. 정상 명령과 통제 반례를 구분 |
| 기존 로컬 계획/결과 4개 | DEV-022 범위·실행계획·검증계획·본 결과서의 후속 승인/실행 기록 |
| 신규 증거/출처 4개 | [실제 공급 인계](../gate3/DEV-022_W06_SUPPLY_AND_VALIDATION.md), [검증 JSON](../gate3/DEV-022_W06_VALIDATION.json), [fixture JSON](../gate3/DEV-022_W06_FIXTURES.json), [출처 manifest](DEV-022_PROVENANCE.json) |

타 부서 산출물·프로젝트 설정·씬/UI·DATA·정책/CI·기존 테스트는 변경하지 않았다. Godot이 생성한 승인 소스의 UID4개는 보존했다. 최초 로드가 만든 untracked 이미지 import 메타데이터151개는 사전에 없던 생성 파일만 확인하여 제거했고 원본 이미지/기존 .import는 보존했다.

### 실제 검증

Godot `4.7.2.stable.official.ed1daf0bf` 및 기존 DEV-026 .venv의 gdtoolkit 4.5.0을 사용했다. 아래 자동검사는 `Godot --headless --path . --script tests/game/<runner>`로 실행했다. W06는 `-- --evidence`, 의도적 실패는 `-- --verify-failure-exit`를 사용했다. 정확한 명령·실행별 소스/로그 해시·입력·판정은 검증 JSON에 기록한다.

| 검증 | 실제 결과 |
| --- | --- |
| W06 `run_w06_tests.gd` | **179단언·실패0·exit0**, W06-01~18 PASS. 일괄/분할/1·2·4배속·일시정지·자정/잔여 도착·첫 실제 보고/조회 포함 |
| W06 실패 감지 | 의도적 실패1건·**exit1 확인 PASS**. 제품 실패와 구분 |
| W02 / W03 / W04A / W05 | 각각 **309 / 101 / 204 / 191단언**, 모두 실패0·exit0 |
| W07 / 입찰 UI / 공사 UI 자동 | 각각 **322 / 460 / 898단언**, 모두 실패0·exit0. 실제 GUI 인수와 구분 |
| 정상 자동 합계 | **2664단언 PASS** = W06 179 + 기존 회귀2485. 의도적 실패1건은 합산 제외 |
| Godot headless editor 프로젝트 로드 | **exit0·SCRIPT ERROR/ERROR0**. `.local/validation/DEV-022_PROJECT_LOAD_FINAL_CONSOLE.log` |
| `tools/policy.py doctor` / 지정 GDScript formatter·linter | PASS. 규칙/훅 우회 없음 |
| 최종 `tools/policy.py check` | **PASS / exit0**, files=618 / GDScript=43. `.local/validation/DEV-022_FINAL_POLICY.log` |
| 문서·JSON·출처·경로 정적 감사 / `git diff --check` | **PASS / exit0**. 승인18개 경로·manifest17개+self·상대 링크47개·최종 실행 소스43개 해시·로그 해시·UTF-8/LF·staged0 대조. `.local/validation/DEV-022_FINAL_AUDIT.json` |

회귀 실행 이후 변경은 W06 신규 모델/서비스의 입력 버전·자료형/시간 역행·유리수 자료 실패와 신규 W06 반례 보강이다. 공통 Pipeline/Report 동작과 기존 테스트는 동일하며 LF 정규화는 별도 기록했다. 최종 W06를 다시 실행했고 각 실행의 실제 소스 해시를 보존했다. 기존 회귀를 최종 파일의 새 실행으로 소급 표시하지 않는다.

초기 오류도 보존한다. 최초 로드의 Godot 설정 폴더 접근/safe-save 오류는 APPDATA·LOCALAPPDATA·TEMP/TMP를 .local 아래로 분리해 해소했다. safe save를 끄거나 프로젝트/검사 정책을 변경하지 않았다. 최초 자동검사의 bool 타입 추론, 잘못된 P-B fixture 역 목록·정부 지급 인덱스, 의도치 않은 지연 clamp 입력은 수정 후 재검증했다. 실패한 탐색 실행은 PASS 합계에 포함하지 않았다.

### L3 판단·잔여·검토 요청

공통 분 순서, T−1 비용/도착일 운임, 동일 T 계약 선사용 거부, R/K/B 보호·정산·재개, 유효 개통과 조건 실효, 소수 carry/공유 용량, 현재/고정 보고 불변 및 기존 소비 영향의 계획된 자동 회귀를 통과했다. **새 기획/경제 명세 변경 필요 없음**이다.

만족도는 내부 유리수를 유지한다. int64로 정확하게 표현할 수 없는 극단 입력은 근사/0점 대신 명시적 자료 실패로 반환하며 반례로 검사했다. 이는 새 만족도 정책이나 수용된 정상 운행 값 변경이 아니다.

- 실제 GUI/키보드·게임 플레이·VS-01 제품 완주: **NOT_RUN**, DEV-023/024 후속.
- Design 독립 L2/GUI 수용·HQ 통합·Owner DONE: **NOT_RUN/PENDING**. 실제 공급/fixture를 로컬 인계 자료로 준비했다.
- 빌드/export·FPS·폰트/DPI·외부 사용성: **NOT_RUN**. 자동검사의 실행 시간을 제품 성능 인수로 사용하지 않는다.
- Commit·Push·PR·원격 CI·preflight·main 병합·외부 댓글/메시지: **NOT_RUN**, Owner 별도 승인 범위.
- DEV-026 구현·제품 검증: **OWNER_IMPLEMENTATION_DEFERRED / NOT_RUN**.

기존 Q03~05 Design 수용, Q12 한정 수용/상위 PARTIAL, F-08 미확정·개별 적용 시점은 유지한다. 기존 root/DEV-019/DEV-026 작업물도 보존했다. **이번 제출은 승인된 DEV-022 범위의 로컬 결과 검토 요청이며 공식 수용이나 DONE 처리가 아니다.**

## 6. Owner 로컬 결과 수용과 원격 제출 승인 — 후속 기록

Owner가 본 개발 대화에서 DEV-022 로컬 구현·검증 결과와 승인18개 파일의 Commit·Push·PR·필수 CI 확인을 승인했다. 원문·브랜치·기간·제외는 [티켓 §1.2](DEV-022_W06_OPERATIONS_MODEL.md#12-owner-로컬-결과-수용commitpushpr-승인--2026-11-14)에 기록했다. 위 §5의 미커밋/원격 NOT_RUN은 로컬 검토 시점 이력이며 이번 제출 권한과 구별한다.

최신 제출 base는 `f13b97d4871e8c73452134fb64c06e1fc919d779`다. 실제 제품 검증 base `2507cda419ed27e96c5d64ced7666ed7a2e58227` 이후 Design 문서2개만 변경됐다. 미공유 작업 브랜치만 fast-forward했고, 승인된 제품/테스트의 바이트·실행 증거와 기존 업무 파일을 보존했다. 이 차이는 새 게임 테스트가 필요한 기능 변경이 아니다.

전용 .venv에 저장소 고정 검사 도구를 설치해 정상 Git 훅을 사용한다. 제출 전 정책/문서·출처/18개 경로 검사와 커밋 후 preflight를 수행하며, 실제 제출 head·PR·필수 CI 결과는 해당 PR에 후속 기록한다. 아직 실행하지 않은 Git/원격 CI 결과를 이 문서에 미리 PASS로 표시하지 않는다.

Owner의 이번 로컬 결과 수용은 DEV-022 모델·자동검증 범위다. DEV-023 제품 UI 활성화/Design L2, DEV-024 실제 VS-01 GUI, HQ 통합/Stage DONE, 빌드/성능 인수의 잔여 상태를 유지한다. **main 병합은 별도 승인 대기이며 DEV-026 구현·제품 검증 보류를 유지한다.**
