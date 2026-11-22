# DEV-027 — 이슈 철회·착수 계획 문서 PR 전환 결과

> **2026-11-22 문서 Git 제출 후속:** §12의 Owner 승인에 따라 이번 문서7개만 지정 브랜치에 Commit·Push·PR 제출한다. P3-B 구현·검증/Track A·B L2/DI03·main 병합 대기는 유지한다. 앞선 Git 미승인·미제출 표시는 당시 기록이다.


> **2026-11-22 P3-A 수용·P3-B 계획 후속:** Track A 공급 L2 한정 수용·Track B 정적 이견 없음을 마지막 후속 절에 연결한다. [화면 계획](../gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md)은 이번 문서7개와 미래 실행19개를 구분한다. 실제 화면 통합은 계획에 포함하되 구현·게임 검증·Git/GUI·DI03 보류는 유지한다. 앞선 상태/증거는 당시 이력이다.


> **2026-11-22 Git 제출 후속:** §10에 Owner의 지정 브랜치 Commit·Push·PR 및 필수 CI 확인 승인을 기록한다. 기존 로컬 시험 원본은 보존하며 main 병합·DI03·L2 전 화면 통합·독립 심사 대기는 유지한다.

> **2026-11-22 P3-A 구현 후속:** 승인된 Session·Pipeline 연결과 L2 공급 준비의 로컬 검토 결과는 문서 마지막의 P3-A 후속 절을 따른다. 앞선 미실행/미승인 문구는 당시 기록이다. DI03·L2 전 화면 통합·Git/최종 인수 대기는 유지한다.

> **2026-11-22 최신 로컬 결과:** §8과 [다음 착수안](../gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md)은 문서5개 준비 결과다. 새 Session/Pipeline·제품 구현/검증은 NOT_RUN이며 P1/PR166의 기존 결과와 구별한다. DI03·화면 L2·최종 인수 대기를 유지한다.

> **2026-11-22 P1 최신 결과:** §7은 승인된 비의존 모델의 로컬 구현·검증 결과다. **LOCAL_REVIEW / GIT_SUBMISSION_NOT_AUTHORIZED**. DI-03 종속 범위·L2 전 화면 통합 및 DEV-026 한정 수용/PARTIAL·S3-12 최종 인수 대기는 유지한다. 아래 과거 기록은 보존한다.

> **PM-021 최신 후속 — 2026-11-21:** §6이 현재 **LOCAL_REVIEW / TRACK_B_COMMON_TABLE_REVIEW_PENDING / GIT_SUBMISSION_NOT_AUTHORIZED** 상태를 설명한다. O01~07 방향 승인·DEV026 현재 공급/P07 수용은 유효하다. 아래 과거 제출·미실행·선택 대기는 당시 이력으로 보존한다. 이번 작업은 기존 DEV027 문서4개 로컬 보완·정적 검사다.

> **현재 후속 — 2026-11-21:** PR #149 병합 후 #146 Design 사전 의견을 반영한 문서 보완이다. 제출 base는 `de0f03f9d2fcc301940a4176f1359b2788a51950`, 브랜치는 `codex/DEV-027-design-plan-followup`이며 현재 권한·결과는 §5을 따른다. 앞선 제출 식별·검증은 PR #149 당시 기록으로 보존한다. 제품 구현·실행·최종 L2·main 병합은 별도 대기다.

- 작성: Development / AGT-DEV-0004 / 2026-11-21 (Asia/Seoul).
- 상태: **DOCUMENT_REVIEW / PRODUCT_IMPLEMENTATION_NOT_RUN**.
- 제출 base: `f047edbf67a6f888eda5eed24309b78554b3c2ed`.
- 브랜치: `codex/DEV-027-stage3-start-plan`.
- [티켓·Owner 요청/제출 권한](DEV-027_W04B_VS02_IMPLEMENTATION.md) / [전체 계획](../gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md).

## 1. 변경 결과

Owner의 후속 요청에 따라 [#148](https://github.com/wisberry2022/MetroManager/issues/148)을 CLOSED/not_planned로 철회하고 개발 문서4개로 변환했다. 원문은 삭제·덮어쓰기하지 않았으며 [철회 기록](https://github.com/wisberry2022/MetroManager/issues/148#issuecomment-7053231691)을 연결했다. 이슈 제출 방식 철회이며 DEV-027·DEV-026의 작업 취소/완료가 아니다.

계획 본문의 재사용/공백, DI-01~03, RFC-DEV-027-01, L2/RP/EX 적용, 구현 후보 경로41/24개, 실행·검증 계획과 잔여는 유지했다. 현재/당시 제출 상태·문서 Git 권한·후속 연결 표현만 문서 PR에 맞췄다. 실제 제품 구현에 착수하지 않았다.

현재4개 경로는 티켓 §2에 명시했다. Markdown3개와 그 출처 JSON1개만 추가한다. DEV-026 원문, 이전 증거/정정, 공유 루트의 기존 데이터 수정2개는 보존했다.

## 2. 원본과 변환 식별

- 원본: Issue #148 본문, `updated_at=2026-11-20T23:27:21Z`, 23,683 Unicode 문자.
- 본문 식별: UTF-8 원문 SHA-256 `f26c3e26488de5c3b0d214780ad3cc7f849e7d1600ad116d0a4e5293de2a44d7`. Markdown 추가 표제·현재 제출 상태 설명·Agent-ID footer와 제출 상태 문구 변경을 원문 전체 동일성으로 주장하지 않는다.
- 정적 기준: 원문과 이번 문서 모두 위 main SHA. 기준 문서 링크는 고정 SHA를 보존했다.
- 원문 §2 재사용/공백, §4~7 DI/RFC·DEV-026/L2, §8.1/8.2 파일 표, §9의 제품 검증 내용과 VS-02 종료 조건은 대조한다.
- 이번 변환은 새 게임/경제/시간/세이브 규칙이나 RFC 답변을 확정하지 않는다.

## 3. 문서 검증

아래 문서 정적 검사를 실행했다. 제품 실행을 대신하는 검사가 아니다.

| 구분 | 명령/범위 | 결과 |
| --- | --- | --- |
| 로컬 규칙/훅 | `.venv/Scripts/python.exe tools/policy.py doctor` | PASS / exit0. 기존 `.githooks` 활성·gdtoolkit4.5.0 확인 |
| 정책/정적 소스 검사 | `.venv/Scripts/python.exe tools/policy.py check` | PASS / exit0. 708파일·GDScript53개 formatter/linter; 게임 실행 아님 |
| 변환 대조 | `.venv/Scripts/python.exe .local/validation/DEV-027-docs/audit_docs.py` | PASS / exit0. 원문 §2·4~7 보존, 후보 경로65행/고유63개 동일, 변경4개 한정, UTF-8/LF·JSON·문서 링크·출처 blob 일치 |
| 공백 검사 | `git diff --cached --check` | PASS / exit0. 문서4개 추가만 스테이징 |
| 제출 이력 검사 | fetch·정상 Commit 후 `.venv/Scripts/python.exe tools/policy.py preflight` | 제출 직전 실행, 실제 결과는 PR에 연결 |
| 원격 필수 CI | 실제 제출 head의 `policy`·`department-policy` | PR 생성 후 확인, 실제 결과는 PR Checks/후속 회신에 연결 |
| 게임 자동 테스트 | 문서 전환에 제품 변경 없음·제품 실행 별도 승인 | NOT_RUN |
| Godot 프로젝트 로드 | 동일 | NOT_RUN |
| 게임 플레이·GUI·RNG seed 탐색 | 동일 | NOT_RUN |
| 빌드/export/FPS | 이번 범위 밖 | NOT_RUN |

로컬 검사 로그/변환 원문/감사 출력은 작업 트리의 `.local/validation/DEV-027-docs/`에 보관한다. CI의 정책 도구 테스트와 게임 자동 테스트도 구분한다. 커밋 자기 SHA나 아직 실행하지 않은 CI 성공을 문서에 미리 기록하지 않는다.

새 작업 트리의 고정 검사 의존성을 설치할 때 제한된 네트워크의 이름 해석 실패가 있었고, 허용된 네트워크 실행으로 같은 requirements 설치 후 정상 검사했다. 검사 우회/의존성 변경은 없다. GitHub 플러그인의 main 보호 세부 조회는 403(Resource not accessible by integration)이어서 그 응답만으로 세부 설정을 인증하지 않는다. 원격 실제 head의 필수 CI와 병합 승인 여부는 별도로 확인한다.

## 4. 제출·후속 경계

이번 승인에 따라 문서 Commit·일반 Push·PR·필수 CI 확인을 진행한다. 실제 commit/PR/CI는 PR 본문·Checks·철회 이슈 후속 연결로 고정한다. #146/#104에는 원문 회신을 보존한 채 새 PR 위치를 알린다.

남은 제품 권한은 계획 §10의 로컬 구현·제품 실행 및 미래 구현 산출물의 Git 제출이다. Design L2·독립 실행/수용, RFC-DEV-027-01 Planning 답변, main 병합·HQ/Owner 인수도 별도다. DEV-026은 Stage 3 필수 편입/착수 준비 상태를 유지하며 과거 HOLD 또는 제품 DONE으로 변경하지 않는다.

새 명세 변경 필요: **확정 없음**. 기존 DI-03 의미 확인만 OPEN이며 이번 변환으로 닫지 않았다.

## 5. Design 사전 의견 문서 반영 — 2026-11-21

- 제출 base: `de0f03f9d2fcc301940a4176f1359b2788a51950` / `codex/DEV-027-design-plan-followup`.
- Owner의 현 요청·문서4개 제출 권한: [티켓 §5](DEV-027_W04B_VS02_IMPLEMENTATION.md).
- 근거: [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053550740), [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053570152). 앞선 변환/검증/CI는 PR #149 당시 이력이다.

| 반영 항목 | 이번 변경·확인 수준 |
| --- | --- |
| 사전 의견과 권한 | 비의존 모델 디자인 선행 차단 없음 / 실제 공급·UI L2_FINAL_PENDING / 제품 NOT_RUN. 문서 병합·Design 의견을 실행 승인으로 사용하지 않음 |
| 접수·사본 | 대기 당시 제출 입력과 현재 초안, 심사/보류 근거·설득 사용 이력·허가 계획을 별도 표현. 재검사 실패·현재 행동·명시적 새 요청·다른 초안 대체 금지의 공급 요구 명시 |
| 다음 L2 입력 | #146 01~14·RP/EX별 실제 코드·고정본·표본·기대/관측·원본을 한 패킷에 연결. 부족 행만 보완 |
| 제한 범위 | DI-03 대상/반복 효과 종속 부분만 보류. F08 전체 확정/같은 GUI 반복/제품 후보 경로 확대 없음 |
| DEV-026 | 원문 계약·검증 계획은 별도 DEV-026 문서 PR. 두 작업의 문서/제품 권한 구분 |

실제 변경은 기존 계획·티켓·결과서·PROVENANCE **4개**다. 원문 후보 경로65행/고유63개, DI-02 확률/추출안 및 DI-03 RFC 미결, 이전 제품 증거와 NOT_RUN은 보존한다. 현재 출처 JSON은 이번 base/문서 blob으로 갱신하고 PR #149 제출 당시 manifest는 [고정 원본](https://github.com/wisberry2022/MetroManager/blob/d098d47e32159e5438aff7d702ff19f2c5d37d0f/docs/engineering/tasks/DEV-027_PROVENANCE.json)에 보존한다.

문서 검사: 실행 후 아래에 기록한다. `.local/validation/design-plan-followup/`에 정적 감사·로그를 분리 보관한다. 게임 자동/프로젝트 로드/GUI·독립 실행/seed 탐색/빌드/export는 모두 **NOT_RUN**이다.

- `.venv/Scripts/python.exe tools/policy.py doctor` 및 `check`: PASS / exit0. 파일708개·GDScript53개 정적 formatter/linter, 포맷 변경 없음. 로그 `doctor.log`·`check.log`.
- `문서 경로·링크·UTF-8/LF·출처 blob, 후보 경로/DI-02·03 불변`: PASS. 변경4개·Markdown blob3개·상대 링크7개·고정 SHA 링크9개·후보65행/고유63개·DI-02/03 원문 대조. 일회성 문서 감사 `audit_docs.py`의 출력은 `audit.json`에 보관.
- diff --check 및 정상 Commit 후 preflight: 제출 단계에 확인, 실제 결과는 PR에 연결.
- 필수 CI: 새 head에서 확인, PR #149 CI를 재사용하지 않는다.
- 새 게임 명세 변경 필요 확정 없음. RFC-DEV-027-01 OPEN, 실제 L2·제품 수용·구현 승인·main 병합 별도.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 6. PM-021 공통 적용표 준비 결과 — 로컬 검토

- 기준 `fa968b94641d24e8d68b3c6cb903f9e809d02814`; 브랜치 `codex/DEV-027-pm021-application-plan`. Owner 요청/정확한4개 경로는 [티켓 §6](DEV-027_W04B_VS02_IMPLEMENTATION.md#6-pm-021-적용표착수-상태-후속--로컬-검토).
- [계획 §12](../gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md#12-pm-021-후속--f-08-공통-적용표의-dev-검토안)에 O01~07·M01~05의 현재 제품/격리 실험 차이·변경0·공백·경로·입력/기대/최소 검증·권한을 정리했다. Track B 공동 검토 **PENDING**. 소관 Design/HQ 문서는 수정하지 않았다.
- 중요한 공백: A/B는 실험 배치, 실제12역에는 전체 이름 필드 없음, 폰트/최소창/최종 아트·필터/성능 목표 미확정. 이를 제품 필수 결함으로 확정하거나 표시 이름/규칙을 새로 만들지 않았다.
- 공식 자료로 Noto Sans CJK KR2.004 Regular OTF 후보·라이선스·조건부 최소 경로만 준비. 파일 반입·선정·호환/렌더·fallback 실행은 **NOT_RUN**.
- DEV026 현재 공급/P07 한정 수용과 PR158 반영, 원본 PARTIAL/미관측·W04B 미래 공급·S3-12 대기 보존. 제품 시험본 ae614d9…→이번 main의 제품/게임 검사 경로 diff0 확인. 현재 main에서 새 제품 시험을 수행했다고 기록하지 않았다.
- 다음 제품 단위 DEV027 P1의 유효 권한/부족 범위와 DI03 종속 행·P3 실제 L2를 연결했다. 후보41개 및 과거 DEV02624개 표·DI02/03 원문은 수정하지 않았다. DEV026 검사 경로는 자기 티켓의 후속 재지정 승인이 우선한다.
- 원격 댓글은 게시하지 않았고 계획 §12.6에 **복사용/NOT_SENT** 전달문을 마련했다.

### 이번 검증·한계

정적 검사 결과는 실행 로그와 대조하여 아래에 기록한다. 검사는 제품 실행·Design 수용·승인을 대신하지 않는다. 로컬 보조 자료는 `.local/validation/pm021-followup/`에 보관한다.

- doctor: PASS / exit0. 첫 일반 권한의 .venv junction 생성은 Access denied로 실패해 doctor가 실행되지 않았다. 권한 있는 연결 생성 후 정상 doctor를 실행했다. 정책/패키지 변경·검사 우회 없음.
- `.venv/Scripts/python.exe tools/policy.py check`: PASS / exit0, 파일729개·GDScript57개 정적 검사, 포맷 변경 없음.
- `git diff --check` 및 `.venv/Scripts/python.exe .local/validation/pm021-followup/audit_docs.py`: PASS / exit0. 정확한4개 변경·기존 Markdown3개 본문 보존·상대 링크/절19개·새 표2개·O7행/M5조건·기존 후보65행/고유63경로·출처 blob3개·UTF-8/LF 대조. E26 이후 제품/검사 변경0, 실제12역 데이터 필드·W04B 미공급 경로도 정적으로 확인했다.
- 신규 게임 자동검사·Godot 프로젝트 로드·게임 플레이/실제 GUI·독립 실행·프로파일·빌드/export: 각각 **NOT_RUN**.
- 비공개 raw 재해시·물리 DPI/신원: **NOT_VERIFIED**. 원문 증거/공식 수용만 재사용.
- 새 Commit·Push·PR·필수 CI: **NOT_RUN**, 원격 게시 **NOT_SENT**, main 병합 미수행.
- 출처 JSON은 이번 base/blob으로 갱신. 이전 manifest는 [이번 base의 원본](https://github.com/wisberry2022/MetroManager/blob/fa968b94641d24e8d68b3c6cb903f9e809d02814/docs/engineering/tasks/DEV-027_PROVENANCE.json)에 보존. REPORT_ONLY 정합성이 신원/승인을 인증하지 않음.

잔여: 로컬4개 검토, Track B 공통표·Track A 영향 행 대조, 필요한 경우 이4개 문서 Git 제출/회신 게시 승인, DEV027 실제 구현·검증 승인, DI03 종속 의미 및 실제 UI L2. O01~07 재승인은 필요 없다. F08/#92 OPEN/FINAL_SPEC_PENDING, S3-10-C·S3-12·Stage 인수는 별도. 신규 게임 명세 변경 필요 확정 없음; 기존 RFC-DEV-027-01 OPEN.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 7. P1 비의존 모델 로컬 결과 — 2026-11-22

**P1_LOCAL_REVIEW**. [Owner 승인·정확한20개 경로](DEV-027_W04B_VS02_IMPLEMENTATION.md#7-p1-비의존-모델-로컬-구현검증-승인--2026-11-22)로 구현·검증했다. 기준 main `1a941196cc6d963db93a9fba6a0386b16710aa46`, 브랜치 `codex/DEV-027-w04b-p1-model`. 작업 커밋은 없으며 시험본은 base와 [실제 파일 해시](../evidence/DEV-027_W04B_VS02_RESULTS.json)로 식별한다.

### 변경·의미

- 제안 데이터/검증 로더, CompanyProposal, ProposalService, BusinessSources와 각 UID, 모델 fixture/러너·UID를 추가했다. 제품9·검사4·문서7의 **총20개**이며 기존 승인 후보41개 안이다.
- 시청 30분·정부60분·설득30분, 시청 −1/0/+1·정부3분기·설득1회, 업무시간/T+1 효력·접수 재검사·잠금·중복 요청, 현재 초안/심사·보류·허가 사본 분리, 이름/역순/역 교체/슬롯 변경의 정부 제한 계보를 구현했다.
- 전용 정상 RNG의 seed/추출 상태·순서·심사 ID를 기록한다. seed2=정부50 적합, seed0=83→83 설득 실패, seed8=84→13 설득 성공, seed1=97 부적합을 실제 엔진에서 찾아 독립 모델로 재현했다.
- 허가액800000/640000과 별도 계약의 실제 원장 지급을 구분했다. 기존 원장 API와 사업별 R/K를 재사용하며 계약의 허가 계획 사본·지급 거래를 읽기 전용 사업 출처로 연결한다. W04A 공급의 읽기 호환도 검사했다.
- 이 공급은 [P1 단독 모델 계약](../gate3/DEV-027_W04B_SUPPLY_CONTRACT.md)이다. 실제 Session/Pipeline/공사·운영/UI 연결이나 자연 VS-02 완료는 아니다. 기존 제품/화면/수요 코드와 데이터2개는 변경0이다.

### 검증

| 구분 | 결과·범위 |
| --- | --- |
| Godot 프로젝트 로드 | exit0 · ERROR/SCRIPT ERROR0 |
| P1 모델 자동 | 425개 통과 · exit0 · ERROR/SCRIPT ERROR0 |
| 고의 실패 종료 계약 | 의도한1개 실패·exit1 확인 (검사 계약 PASS) |
| 기존 W02 회귀 | 309개 통과 · exit0 · ERROR/SCRIPT ERROR0 |
| 기존 W03 회귀 | 101개 통과 · exit0 · ERROR/SCRIPT ERROR0 |
| 기존 W04A 회귀 | 204개 통과 · exit0 · ERROR/SCRIPT ERROR0 |
| 기존 W05 회귀 | 191개 통과 · exit0 · ERROR/SCRIPT ERROR0 |
| 정책/범위/출처 | PASS · doctor/check(exit0, 파일748·GDScript63) · 정확한20경로/기존 기록/19개 blob·UTF-8/LF·diff --check 확인 |
| GUI·독립 실행·Design·VS-02·빌드/export | NOT_RUN / 실제 통합·수용 대기 |

Godot `4.7.2.stable.official.ed1daf0bf`의 엔진 본체/console SHA-256, 실제 명령·exit·오류·소스/로그 해시 및 입력/기대/관측은 [증거 색인](../evidence/DEV-027_W04B_VS02_EVIDENCE.md)과 JSON에 연결한다. 원본은 작업 worktree의 `.local/validation/DEV-027/p1/`에 보존한다.

최초 시도도 보존한다: 일반 권한 로드의 사용자 설정/디렉터리 오류, model-01 타입 추론 파싱 오류, model-02의 잘못된 타입 비교 SCRIPT ERROR(프로세스 exit0·일부 단언 통과를 PASS로 인정하지 않음), model-04의 검사 입력 오분류1건, 첫 W05 회귀의150초 시간 초과. 로더/명령/사업 지급의 잘못된 타입을 거부하도록 수정했고 추가 경계 검사로 확인했다. 고의 실패 exit 검사는 결함 건수와 분리한다.

최종 파일 감사에서 formatter가 신규 GDScript6개에 기록한 CRLF를 규정된 LF로 정규화했다. 이전 시험 바이트·전후 해시는 보존하고 LF 본의 모델425개·실패 종료·프로젝트 로드를 재확인했다. 기존 회귀/의존 소스는 변경0이므로 W02/W03/W04A/W05 결과는 원 실행 식별자로 유지한다.

### 잔여와 검토 요청

- **DI-03 종속 보류:** E01 대상 OD/동·반복/중첩·실제 발생/수요/소수 carry·예측 무효화·소비 및 성공 재접수. 현재는 승인된+1440 기준 메타데이터와 순수 사실 자격 fixture만 공급한다. 모델은 사실이 없는데 시간이 지났다는 이유로 제한을 풀지 않는다.
- **P3/P4 대기:** Session/Pipeline 전체 단계·W05/W06 실제 소비, UI root/지역 의존표·실제 공급 L2, 해당 화면 통합, GUI·독립 실행·Design 심사·자연 VS-02.
- DEV-026 한정 수용·PARTIAL/미관측·P07 구분, S3-12/HQ·Owner 최종 인수 대기 유지. 과거 원본 검증·정정·승인 기록은 보존한다. #92 공통표는 [DEV 회신](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057935798)·[Track A 검토 완료](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057978655)로 연결하며 같은 문서/GUI 재제출을 요구하지 않는다.
- 게임 규칙 변경 필요: **새 변경 요구 없음**. RFC-DEV-027-01의 DI-03 종속 의미 확인만 OPEN.
- **Commit·Push·PR·CI·main 병합 미실행/별도 승인 대기.** 이번 보고는 승인된 P1 로컬 결과의 검토 요청이며 전체 DEV-027/Stage DONE 또는 Design 수용 선언이 아니다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 8. Session·Pipeline/L2 착수안 로컬 결과 — 2026-11-22

**LOCAL_PLAN_REVIEW / PRODUCT_IMPLEMENTATION_NOT_RUN / REMOTE_NOT_SENT**. [Owner 요청·문서5개](DEV-027_W04B_VS02_IMPLEMENTATION.md#8-92146-후속-착수안-로컬-준비--2026-11-22)에 따라 계획만 준비했다.

### 결과·변경 파일

- [신규 상세 계획](../gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md): P3-A 비의존 Session/Pipeline·공유 원장/분 단계·실제 사업 소비와 L2 입력 준비를 다음 단위로 제안했다. 화면 없는 공급 검사와 UI 통합/자연 VS02를 구분한다.
- 기존 실행계획·티켓·이 결과서에 최신 안내/후속을 추가했고 provenance를 이번4개 Markdown의 base/blob·근거로 갱신했다. **총5개 문서만 변경**했다.
- 미래 최대22개(제품8/검사6/문서·증거8)를 열거하고 기존41개 밖5경로를 명시했다. 특히 ConstructionProject의 tender.terms 의존과 guard 변경을 추가 범위로 드러냈다.
- #92의 NR/DA 기준은 수신 완료다. 실제 이름12행·작성/승인 담당·기준 PC 목적/배율/접근·폰트 실물/고지/fallback은 남은 입력이다. 앞선 미게시 F08 검토6파일은 보존하고 공식 댓글만 연결했다.
- #146의 실제/모델/fixture·현재/당시·행동 권위·예외/지역 의존을 L01~10 및 V01~09로 정리했다. 신규 증거2개는 미래 생성 후보이며 현재 실제 공급 표본은 없다.
- DI03의 A1+B1 정책 완료를 연결하고 종속 생성/수요/carry/소비·성공 재접수 구현/검증 보류를 유지했다. 새 게임/경제/시간/세이브 명세 변경 요구 없음. 공동 원장 경쟁 등 실제 의미 충돌이 드러나면 해당 행만 RFC로 다룬다.

### 정적 검수

검사 결과: **PASS — 문서/저장소 정적 검사에 한정**.

| 검사 | 결과 |
| --- | --- |
| `.venv/Scripts/python.exe tools/policy.py doctor` | PASS. 원격 보호/승인 인증 아님 |
| `.venv/Scripts/python.exe tools/policy.py check` | PASS·exit0, worktree761파일/GDScript63. formatter/linter이며 게임 자동검사가 아님 |
| `git diff --check`·UTF-8/LF | PASS |
| 실제/미래 경로·참조 | 실제5개·미래22개(8/6/8), 기존41개 안17/밖5, 이번 후속의 상대 링크/anchor19개 확인 |
| 기록/출처 | 기존 Markdown3개 원문 보존, pinned base·이번4개 blob 일치, 기존 P1 증거/제품 변경0 |
| 기존 로컬/공유 상태 | F08 검토6파일·공유 데이터2개 해시 불변, HEAD=기준 main·index 비어 있음 |

감사 원본은 이 worktree의 `.local/validation/DEV-027/session-pipeline-plan/audit.json` 및 최종 `audit-final.json`에 보관한다. 로컬 도구 연결 과정의 권한 오류는 기존 venv junction을 정상 생성한 뒤 doctor/check로 해소했으며 게임 실행은 하지 않았다. Git 커밋이 없어 preflight·신규 원격 CI는 NOT_RUN이다.

### 실행·승인 경계와 잔여

이번 신규 게임 자동 / Godot 프로젝트 로드 / GUI·플레이·독립 실행·자연 VS02 / 환경·DPI·폰트·아트 계측/반입 / 성능·빌드/export는 각각 **NOT_RUN**. 신규 Commit·Push·PR·CI·main 병합 및 #92/#146 원격 댓글 게시도 미실행이다. 기존 P1 자동425/회귀805/로드/CI·제출/병합 식별과 과거 실패·timeout은 원래 증거에 보존한다.

검토 요청은 [상세 계획 §7.2·8](../gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md#72-다음-p3-a-실행-후보--최대22개--현재-미승인)의 최대22경로 P3-A 로컬 구현·자동/직접 영향 회귀·프로젝트 로드·L2 패킷 로컬 준비다. 이번 문서 승인은 그 실행 권한을 만들지 않는다. 실제 L2 수용 전 화면 통합, DI03 종속 범위, DEV026 한정 수용/PARTIAL·미관측·P07 구분, #92/F08 및 S3-10-C·S3-12/HQ·Owner 최종 인수는 유지한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 9. P3-A 로컬 구현·검증 결과 — 2026-11-22

**LOCAL_IMPLEMENTATION_REVIEW / L2_INPUT_SUPPLIED_LOCALLY / L2_ACCEPTANCE_PENDING / GIT_NOT_AUTHORIZED**.

- base `97cc5472f11a97d5f7d7c1b89dc12edeace36e1f` + [실행 소스 SHA256](../evidence/DEV-027_SESSION_PIPELINE_L2_RESULTS.json). 실제 변경 **22개 = 제품8 + 검사6 + 문서·증거8**. 목록은 상세 계획 §7.2를 그대로 따른다.
- 모델/Session/자동 연결 **677개**, 영향 회귀 **3204개** 정상 통과. 프로젝트 로드 오류0, 새 runner2개의 고의 실패 exit1 검출. 자동 검사는 GUI·자연 VS02·Design/독립 수용이 아니다.
- 실제 Session opt-in·공유 시계/원장, 마감 뒤 심사·CONTRACT 지급 분리, 허가 사본/지급→공사→실제 운행/첫 보고/후보 조회를 연결했다. W04A 기존 기본 진입과 뒤늦은 W04B 활성화를 검사했다.
- `proposal_ui`/지역 guard 및 L01~10 실제 출력·오류/표시 fixture를 [L2 색인](../evidence/DEV-027_SESSION_PIPELINE_L2_EVIDENCE.md)에 준비했다. main/View·화면 호출은 추가하지 않았다.
- DI03 생성·×5/4 수요/소비/재접수, 이름12행/실제 loader·폰트·환경·아트 적용은 미실행. PLN016 A1+B1 결정 완료를 보존하며 정책 미답변으로 되돌리지 않는다.
- DEV026 한정 수용·PARTIAL/미관측·P07 구분, #92/F08 FINAL_SPEC_PENDING, S3-10-C·S3-12/HQ·Owner 최종 인수 대기를 유지한다. 신규 게임 명세 변경/RFC 요구 없음.
- Commit·Push·PR·CI·main 병합·원격 댓글은 미실행/별도 승인. 이 결과는 P3-A 로컬 검토 요청이며 DEV027/Stage DONE 또는 Design 수용 선언이 아니다.

### 검증과 보완 이력

| 실행 | checks | exit | 판정 |
| --- | --- | --- | --- |
| load | — | 0 | PASS / 오류0 |
| w04b | 437 | 0 | PASS / 오류0 |
| proposal_ui | 165 | 0 | PASS / 오류0 |
| vs02 | 75 | 0 | PASS / 오류0 |
| w02 | 309 | 0 | PASS / 오류0 |
| w03 | 101 | 0 | PASS / 오류0 |
| w04a | 204 | 0 | PASS / 오류0 |
| w05 | 191 | 0 | PASS / 오류0 |
| w06 | 179 | 0 | PASS / 오류0 |
| w07 | 322 | 0 | PASS / 오류0 |
| tender_ui | 460 | 0 | PASS / 오류0 |
| construction_ui | 898 | 0 | PASS / 오류0 |
| operations_ui | 158 | 0 | PASS / 오류0 |
| s01_exception | 334 | 0 | PASS / 오류0 |
| vs01 | 48 | 0 | PASS / 오류0 |
| proposal_ui-intentional | — | 1 | 의도한 실패1 검출 |
| vs02-intentional | — | 1 | 의도한 실패1 검출 |

검증 명령·원본 로그/해시·실행별 표본·소스 바이트는 신규 JSON에 있다. 첫 사용자 설정 경로 접근 실패, 새 검사 타입/API/정지 fixture 오류, 잘못된 기대 사유, 설득30분 소비 guard 보완 이력을 모두 보존했다. exit0/실패0 표시가 있더라도 SCRIPT ERROR가 있던 실행은 PASS로 세지 않았다. 반복 원장 복사는 소비자 소유 캐시로 줄이며 다른 원장/변경 지급 재사용 거부를 검사했다. 성능 벤치마크로 판정하지 않는다.

### 로컬 검토 요청

22개 파일 및 새 L2 공급 표본을 검토 요청한다. 승인 뒤 Git 제출이 별도 허용되기 전까지 staging/commit/push/PR을 하지 않는다. `policy.py doctor/check`, diff·경로·출처/원본 보존 감사의 최종 결과는 L2 색인과 로컬 audit-final.json을 따른다. preflight/원격 CI는 새 커밋이 없으므로 NOT_RUN이다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 10. P3-A 제출 준비 후속 — 2026-11-22

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


## 11. P3-A 수용 후속 및 P3-B 로컬 계획 결과 — 2026-11-22

**LOCAL_PLAN_REVIEW / PRODUCT_IMPLEMENTATION_VALIDATION_NOT_RUN / GIT_NOT_AUTHORIZED**. 기준 `cc8814097634013be8df8b27f166bdee09c7bac6`, 로컬 브랜치 `codex/DEV-027-p3b-screen-plan`.

[PR #171](https://github.com/wisberry2022/MetroManager/pull/171)은 main `cc8814097634013be8df8b27f166bdee09c7bac6`에 병합됐다. 제출 head `a9111742a74c7369ab7c52f5e24ef5ca51d2c217`와 병합 tree가 동일하며 기존 모델/연결677·영향 회귀3204·로드/의도 실패 및 필수 CI는 원 실행 식별로 재사용한다. 이번 새 게임 실행이나 최신 main 자연 VS02 결과가 아니다.

- [Track A / AGT-DSG-0004](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7073746341): **TRACK_A_P3A_L2_LIMITED_ACCEPTANCE**. 비의존 기능 공급·백엔드 연결 한정 수용, 기능 의미의 추가 필수 수정 없음. UI11은 제한/미공급 의미만, UI12 실제 DI03은 보류.
- [Track B / AGT-DSG-0003](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7073690611): **P3A_SUPPLY_REVIEWED / TRACK_B_STATIC_NO_OBJECTION / SCREEN_ACCEPTANCE_PENDING / GUI_NOT_REQUESTED_NOW**. 공급 의미 이견 없음이며 실제 화면/표현·읽기·수명·복귀 수용은 별도다.
- 과거 P1의 Session/Pipeline 미공급, 승인 전 Git/실행 대기는 당시 이력이다. 원문·기존 검증·raw·실제/fixture 구분과 DEV026 한정 수용/PARTIAL·미관측·P07 구분을 보존한다. DI03 실제 종속 구현·검증 및 S3-10-C·S3-12/HQ·Owner 최종 인수 대기도 유지한다.

### 작성 결과와 정확한 파일

| 종류 | 정확한 경로 |
| --- | --- |
| 신규 | `docs/engineering/gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md` |
| 수정 | `docs/engineering/gate3/DEV-027_W04B_SUPPLY_CONTRACT.md` |
| 수정 | `docs/engineering/gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md` |
| 수정 | `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md` |
| 수정 | `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md` |
| 수정 | `docs/engineering/tasks/DEV-027_RESULT.md` |
| 수정 | `docs/engineering/tasks/DEV-027_PROVENANCE.json` |

[상세 계획](../gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md)에 실제 화면 통합을 다음 P3-B 범위로 명시했다. 정상 진입·회사 제안/편집/심사/계약·P05/P06/P07·후보 조회/복귀를 최대19경로로 특정하고, Track A/B B01~06 확인과 승인 경계를 나눴다. P3-A 한정 수용을 재요청하지 않고 기존 표본31개를 연결했다. UI12 실제 DI03은 제외하고 미공급 표시만 포함한다.

표시/소비 제안은 검토 대기다. previous 소유·채택/거부/복구, 현재/당시 사본과 0/실패/미계산, 정보 읽기/명시 편집·잠금, 같은/새 Session과 P07 일반 재진입/저장 복귀를 구체화했다. 실제 이름12행/환경·폰트/아트 공급은 별도 담당·적용 시점으로 남겼다.

### 이번 수행·문서 검증

- 수행: #146 양 Track 원문/PR171 병합·tree, 공급/Host·진입/씬·설정·기존 검사/승인 문서 정적 대조. 게임 실행 없음.
- 보관: `.local/validation/DEV-027/p3b-plan/baseline.json`·`originals/`에 이번 수정 전6개 파일과 추적783개 해시. P3-A 원본 evidence2개·P1 증거·공유 데이터2개·별도 F08 로컬6개를 보존한다. 이전 manifest는 PR171 고정본과 로컬 원본에 보존한다.
- 정적 확인: `policy.py doctor/check`, `git diff --check`, 정확한7경로·상대 링크·UTF-8/LF·provenance6개 blob·원문 보존/비문서 소스 불변 감사를 수행한다. 실제 결과는 마지막 정적 확인 후속과 `.local/validation/DEV-027/p3b-plan/audit-final.json`에 연결한다.
- 새 worktree의 첫 .venv junction 연결은 접근 거부되어 doctor를 실행하지 못했다. 동일 기존 환경을 정상 권한으로 연결한 뒤 doctor를 재실행해 PASS를 확인했다. 제품/테스트 실패로 집계하지 않으며 우회·도구 버전 변경은 없다.

이번 신규 게임 자동검사·Godot 프로젝트 로드·DEV GUI/플레이·독립 실행·자연 VS02·환경/DPI·폰트/이름/아트 계측/반입·성능·Windows 빌드/export는 각각 **NOT_RUN**. P3-A677/3204/로드와 과거 CI·실패/미포착은 원 식별로 유지한다. 이번 Commit/Push/PR·원격 CI·main 병합·#146 댓글 게시도 미실행이다.

### 로컬 검토 요청

문서7개와 다음 P3-B 최대19경로·B01~06 L2/승인 조건을 검토 요청한다. 화면 통합은 이번 **계획의 구현 대상**에 포함되며 실제 구현은 별도 승인 뒤다. P3-B 실화면 제공 이후에만 P4의 공동 GUI 실행 조건을 충족할 수 있다. 이번 문서 검토를 구현/게임검증·Git·Design 화면 수용·Stage DONE 승인으로 확대하지 않는다. DI03 보류·DEV026 한정 수용/PARTIAL·S3-12 최종 인수 대기 유지, 새 게임 명세 변경 요구 없음.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

### 이번 문서의 최종 정적 확인

- `.venv/Scripts/python.exe tools/policy.py doctor` PASS.
- `.venv/Scripts/python.exe tools/policy.py check` PASS·exit0: 전체784파일/GDScript65. 로그는 `.local/validation/DEV-027/p3b-plan/policy-check.log`.
- `git diff --check` PASS. 문서7경로·UTF-8/LF·상대 링크79개·provenance6개 blob·미래 후보19개(7/3/9) 대조 PASS.
- 기존 Markdown5개의 원문 보존, 비변경 추적777개·공유 데이터2개·별도 F08 로컬6개 해시 일치. HEAD는 기준 main 그대로이며 staging/새 commit0.
- 최종 결과 문구와 provenance 해시 갱신 후 동일 경로/원문·링크·UTF-8/LF/JSON 감사를 다시 통과했다. 이는 문서 정적 확인이며 게임 검증은 NOT_RUN이다.

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


## 13. P3-B 로컬 구현·검증 결과 — 2026-11-22

- 기준: `1a24e3346d0ec46ca692fe54d5de5656913c3450` + [실행 JSON](../evidence/DEV-027_SCREEN_INTEGRATION_RESULTS.json)의 최종 파일 해시. 신규 commit 없음.
- [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074162935) / [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074161321) B01~06 방향 확인과 Owner 최대19경로 승인에 따라 구현했다. 현재 **LOCAL_REVIEW_PENDING / P4_GUI_INDEPENDENT_NOT_RUN / REMOTE_NOT_SENT**.
- 새 실제 View 자동 **225 PASS**, 영향 회귀 **3120 PASS**(그중 P3-A 모델/공급/VS02 재실행677), 정상 실패0·SCRIPT ERROR0. 새 runner 의도 실패 exit1을 별도로 확인했다. Godot4.7.2 최종 로드 exit0·오류0.
- 제품 코드는 main/Host와 새 proposal View/표시 매핑/씬에 한정한다. 모델·Session·Pipeline·원장·시계·기존 씬·자산/데이터·CI 변경0. 기존 UI 입력 공통 처리와 표시 helper를 재사용해 Host를1000행 이내로 유지했다.
- B02는 `effective_not_before`→접수 가능 최저 시각(성공 보장 아님), `admitted_at`→실제 접수, `completes_at`→실제 접수부터의 완료 예정으로 소비한다. 기존 게임 규칙·심사/난수/지급 계산 추가0.
- 자동 검사에는 실제 Control 신호/합성 키보드와 게임 시간 환산이 있다. 실제 OS GUI·독립 실행·자연 VS02·최종 가독성/물리 DPI·빌드/export·성능은 각각 NOT_RUN. 표시0/실패 등 사본 fixture는 실제 자연 발생과 분리했다.
- P1/P3-A 결과·실패/원본과 Markdown 원문을 보존했다. 비변경 추적774개·공유 데이터2개·별도 F08 문서9개 해시 일치. 검사 당시 CRLF 바이트는 로컬 보관하고 LF 정규화 외 변경0을 검증했다. 최종 로드는 LF 파일로 실행했다.
- DI03 종속 범위 보류, DEV026 한정 수용/PARTIAL·미관측·P07 구분, #92 실제 이름/환경/폰트/아트·최종 규격, S3-10-C·S3-12/HQ·Owner 최종 인수 대기 유지. 새 명세 변경/RFC 필요 없음.
- 로컬 제출 검사: `.venv/Scripts/python.exe tools/policy.py doctor` 및 `check` PASS(793파일/68 GDScript), `git diff --check` PASS. 정확한19경로·18개 provenance blob·UTF-8/LF·원문 보존을 재확인했다. 원격 필수 CI는 PR 미생성으로 NOT_RUN이다.

### 변경 파일과 검토 요청

정확한 변경은 상세 계획 §6.2의19개다. 신규9개/기존10개이며 [증거 색인](../evidence/DEV-027_SCREEN_INTEGRATION_EVIDENCE.md)에서 행별 결과/한계를 연결한다. 아래 파일과 B01~06 실제 연결 결과의 로컬 검토를 요청한다. 제품 자체 검증 PASS는 Design 화면 수용·DEV027 DONE·Stage 최종 인수가 아니다.

1. `scripts/main.gd`
2. `scripts/ui/stage1_view.gd`
3. `scripts/ui/proposal_view.gd`
4. `scripts/ui/proposal_view.gd.uid`
5. `scripts/ui/proposal_presentation.gd`
6. `scripts/ui/proposal_presentation.gd.uid`
7. `scenes/proposal_panel.tscn`
8. `tests/game/run_proposal_view_tests.gd`
9. `tests/game/run_proposal_view_tests.gd.uid`
10. `tests/game/run_operations_gui_cases.gd`
11. `docs/engineering/gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md`
12. `docs/engineering/gate3/DEV-027_W04B_SUPPLY_CONTRACT.md`
13. `docs/engineering/gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md`
14. `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md`
15. `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md`
16. `docs/engineering/tasks/DEV-027_RESULT.md`
17. `docs/engineering/tasks/DEV-027_PROVENANCE.json`
18. `docs/engineering/evidence/DEV-027_SCREEN_INTEGRATION_RESULTS.json`
19. `docs/engineering/evidence/DEV-027_SCREEN_INTEGRATION_EVIDENCE.md`

| 로컬 run ID | 결과 marker | exit | SCRIPT ERROR/ERROR |
| --- | --- | --- | --- |
| view-03 | PROPOSAL_VIEW_TEST_RESULT checks=225 failures=0 | 0 | 0 |
| regression-w04b | W04B_P1_TEST_RESULT checks=437 failures=0 | 0 | 0 |
| regression-proposal_ui | PROPOSAL_UI_TEST_RESULT checks=165 failures=0 | 0 | 0 |
| regression-vs02 | VS02_AUTO_TEST_RESULT checks=75 failures=0 | 0 | 0 |
| regression-w07 | W07_TEST_RESULT checks=322 failures=0 | 0 | 0 |
| regression-tender_ui | DEV019_UI_TEST_RESULT checks=460 failures=0 | 0 | 0 |
| regression-construction_ui | DEV021_UI_TEST_RESULT checks=898 failures=0 | 0 | 0 |
| regression-operations_ui | DEV023_SUPPLY_TEST_RESULT checks=158 failures=0 | 0 | 0 |
| regression-s01_exception | DEV026_TEST_RESULT checks=334 failures=0 | 0 | 0 |
| regression-operations_gui_cases | DEV023_UI_TEST_RESULT checks=271 failures=0 | 0 | 0 |
| intentional-01 | PROPOSAL_VIEW_TEST_RESULT checks=2 failures=1 | 1 | 0 |
| final-load | 프로젝트 로드 | 0 | 0 |

Commit·Push·PR·main 병합·독립 GUI·이슈 회신·릴리스/배포는 수행하지 않았다. 승인 범위 밖 후속은 기존 별도 승인 경계를 유지한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 14. 통합 GUI 심사 수신·잔여 매핑 로컬 결과 — 2026-11-22

- 근거: [Track A 자연 VS02 결과](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075072443), [Track B 최종 증거 심사](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075447846). PR #174는 main에 병합됐으며 양 Track 고정 시험본과 이번 기준 main은 `37596bd6d646f9d0454280477e60a2e652f06613`이다.
- Track A의 정상 자연 VS02 관측 구간 PASS, Track B의 관측18행 **TRACK_B_P3B_GUI_LIMITED_ACCEPTANCE / OVERALL_PARTIAL**을 후속 연결했다. 전체 PARTIAL, B06-02/03 PARTIAL2와 신규 GUI NOT_RUN5를 유지한다. 이전 “독립 GUI 전체 대기/NOT_RUN”은 당시 이력이며 현재는 확인한 구간만 갱신한다.
- 확정 제품 결함은 보고되지 않았으며 DEV의 이번 확인도 새 제품 FAIL을 확정하지 않았다. 제품 재구현·전체 자연 완주 반복을 추가하지 않았다. [근거 매핑·최소 후속안·#146 회신 초안](../evidence/DEV-027_GUI_REVIEW_FOLLOWUP.md)을 준비했다.
- B06-02는 fallback/1프레임 ensure-visible/2프레임 저장문맥 복귀와 일반 P07 진입을 원 로그·캡처에 대응시켰다. 다른 focus로 이동하는 경쟁과 같은 focus의 휠/읽기 키 경합을 분리했다. 후자는 기존 자동 근거의 공백이며 원인 확정·수정 완료·OS PASS가 아니다.
- A manifest256개/B SHA256SUMS307개 재해시 불일치0, 댓글 핵심 SHA6개 일치. 기존 DEV 소스161개 및 raw로그12개·full view evidence도 일치. View225/회귀3120은 당시 실행을 재사용하며 이번 재실행이 아니다. A/B의 일4 실적·게임 시각과 seed8 지급 관측 범위를 서로 대체하지 않는다.
- DI03 실제 종속 구현·검증 HOLD, DEV026 한정 수용/PARTIAL·미관측·P07 일반 재진입/저장문맥 구분, #92 규격/입력 및 S3-10-C·S3-12/HQ·Owner 최종 인수 대기를 유지한다. 전체 Design 수용·필수 미충족0·DEV027 DONE·이슈 종료는 선언하지 않는다.
- 이번 게임 자동·프로젝트 로드·GUI/플레이·독립 실행·자연 VS02·빌드/export·성능·새 계측/반입은 각각 NOT_RUN. Commit·Push·PR·병합·이슈 게시0. 현재 **LOCAL_REVIEW_PENDING / 원격 미제출**이며 이번 결과로 추가 실행/Git 권한을 만들지 않는다.

### 변경 경로와 검토 요청

1. `docs/engineering/evidence/DEV-027_GUI_REVIEW_FOLLOWUP.md`
2. `docs/engineering/gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md`
3. `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md`
4. `docs/engineering/tasks/DEV-027_RESULT.md`
5. `docs/engineering/tasks/DEV-027_PROVENANCE.json`

제품·테스트 소스·씬·데이터·CI·디자인 원본 변경0. 기존 Markdown3개는 원문 뒤 후속을 추가하고 provenance는 기준 main의 원 manifest를 보존한 채 이번4개 산출물을 선언한다. #146 회신 초안은 새 증거 문서 §7에 포함한다. 후속5개 파일과 최소 보완안의 로컬 검토를 요청한다.

### 검증 명령과 결과

- `.venv/Scripts/python.exe tools/policy.py doctor`: PASS, 로컬 훅/도구 확인. 원격 보호 확인·게임 검증이 아님.
- `.venv/Scripts/python.exe -X utf8 .local/validation/DEV-027/gui-review-followup/check_inputs.py`: PASS. 원본 manifest·댓글 SHA·기존 실행 해시 대조. 제품 실행 없음.
- `.venv/Scripts/python.exe tools/policy.py check`: **PASS**, 801파일/68GDScript. 제품 재실행이 아닌 정책/형식 검사다.
- `git diff --check`, 정확한5경로·Markdown 원문 prefix·provenance4 blob·나머지796개 추적 파일·공유 기존 데이터2개·Design 원본 재대조: **PASS**. 최종 감사에 기록했다.
- 감사 원본: `.local/validation/DEV-027/gui-review-followup/input-audit.json` / `final-audit.json`. 신규 게임 검사/GUI/로드를 수행했다고 합산하지 않는다.

추가 명세 변경/RFC는 현재 필요 없음. 같은-focus 휠/지연 복원 기대가 달라져야 하는 것으로 확인되면 기존 RFC 절차로 먼저 보고한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 15. 키보드 접근·포커스/스크롤 로컬 계획 결과 — 2026-11-22

- 상태: **LOCAL_PLAN_REVIEW / IMPLEMENTATION_AND_EXECUTION_AUTH_PENDING**. Owner의 PR175 병합 후 로컬 착수·실행/검증 계획 작성 지시를 이행했다.
- 원격 확인: [PR175](https://github.com/wisberry2022/MetroManager/pull/175) MERGED, main `1b80303636c5eddfbeddac9d288b0124b0093966`. [#146 승인 회신](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075655059)은 게시 완료이며 이후 Design 응답은 확인되지 않았다. §14의 로컬/미게시 문구는 당시 이력이다.
- 새 [검증 계획](../gate3/DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md)에 K01~12 Control군·하위행, F01~06 같은/다른 focus·입력 프레임 순서, 기대/실제 관측과 종료선을 구체화했다. A 자동8개 경로, 재현·기대 확인 후 B 제품1개 추가, C 독립 OS/Design을 구분한다.
- 기존 직접 grab_focus·합성 Enter 근거는 순수 OS Tab 전수 도달이 아니다. 1프레임 ensure/2프레임 restore의 같은 owner 사용자 휠/읽기 키는 검증 공백으로 유지한다. 확정 제품 FAIL이나 수정 완료를 선언하지 않았다.
- 양 Track 시험37596bd→현재 main은 후속 문서5개만 달라 제품/테스트/씬/데이터/설정 차이0. 기존 View225/회귀3120/로드·A/B 관측·원본 무결성은 PR175 근거로 재사용하며 이번 재실행·원본 전체 재해시가 아니다.

### 이번 정확한 변경 파일

1. `docs/engineering/gate3/DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md`
2. `docs/engineering/gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md`
3. `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md`
4. `docs/engineering/tasks/DEV-027_RESULT.md`
5. `docs/engineering/tasks/DEV-027_PROVENANCE.json`

기존 Markdown3개는 원문 뒤에 추가하고 기존 GUI 후속 증거·자동 JSON·A/B 패킷은 수정하지 않는다. 이전 provenance 원본은 PR175 병합본에 보존하며 이번 문서4개의 출처를 새로 기록한다. 공유 작업 경로의 기존 데이터2개는 보존한다.

### 이번 문서 검증·한계

- `.venv/Scripts/python.exe tools/policy.py doctor`: PASS. 로컬 훅/도구 확인이며 원격 보호·게임 실행 검증이 아니다.
- `git diff --exit-code 37596bd6d646f9d0454280477e60a2e652f06613 HEAD -- scripts tests scenes assets project.godot`: PASS, 제품 관련 차이0.
- `.venv/Scripts/python.exe tools/policy.py check`: **PASS**, 802파일/68GDScript. 정책/형식 검사이며 게임 자동 검증이 아니다.
- `.venv/Scripts/python.exe -X utf8 .local/validation/DEV-027/keyboard-focus-plan/audit.py`: **PASS**. 정확한5경로·provenance4개·원 Markdown3개 prefix·비변경 추적파일797개·공유 데이터2개 보존, 새 상대 링크8개·K12개 그룹/F6개 순서 확인. 신규 문서까지 UTF-8/LF·줄 끝 공백 검사 포함.
- `git diff --check`: PASS. 원격 제출용 stage/commit은 하지 않았다. 결과 기록 후 변경 문서/provenance를 다시 검사하며 최종 해시를 `final-audit.json`에 보관한다.
- 게임 자동 테스트 / Godot 프로젝트 로드 / 게임 플레이 / DEV·독립 GUI / 자연 VS02 / 빌드·export / 성능·새 계측·자원 반입은 각각 **NOT_RUN**. Git commit/push/PR/병합·원격 댓글 게시0.
- 로컬 감사/명령 로그: `.local/validation/DEV-027/keyboard-focus-plan/`. 초기 환경 연결 실패는 보존하고 절대경로 .venv junction 설정 후 doctor PASS를 구분한다.

추가 기획 명세 변경은 현재 필요 없음. 같은-focus 우선순위와 K/F 공통 필수 하위행은 Track A/B 확인 대기이며 전체 기존 L2 재승인으로 확대하지 않는다. DI03 HOLD, 기존 PARTIAL·미관측·DEV026 한정 수용/P07 구분·#92/F08·S3-10-C·S3-12/HQ·Owner 최종 인수 대기를 유지한다. 실행·Git 권한은 별도이며 이번5개 문서부터 로컬 검토를 요청한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 16. 키보드 접근·포커스/스크롤 구현·회귀 결과 — 2026-11-22

- 상태: **DEV_LOCAL_VALIDATION_PASS / OS_AND_DESIGN_REVIEW_PARTIAL**. [계획 §9·11](../gate3/DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md)에 Owner의 구현·PR 및 제품1개 추가 승인을 구분해 기록했다. 이번 결과는 검수 요청이며 DONE/Stage 최종 인수가 아니다.
- 저장소 wisberry2022/MetroManager, 브랜치 codex/DEV-027-keyboard-focus-plan, 기준 main `1b80303636c5eddfbeddac9d288b0124b0093966`. Commit·Push·PR·필수 CI는 승인 범위다. main 병합·#146 게시·독립 GUI는 수행하지 않는다.
- `stage1_view.gd`: 제안 Tab/Shift+Tab 직전 비활성 버튼/빈 목록의 focus_mode 동기화, follow_focus=false인 제안의 지연 ensure 중지. 로그 필드·fallback 순서를 유지하는 표현 정리로 기본1000줄 규칙을 만족했다.
- 기존 검사·문서·A/B 증거를 보존하고 [새 증거](../evidence/DEV-027_KEYBOARD_FOCUS_EVIDENCE.md)·[JSON](../evidence/DEV-027_KEYBOARD_FOCUS_RESULTS.json)에 입력/프레임·소스 해시·실패 이력·최종 결과를 분리했다. 기존 Markdown4개는 승인본 뒤 추가하고 provenance는 이번8개 산출물로 갱신한다.

### 정확한 변경 파일9개

1. `scripts/ui/stage1_view.gd`
2. `tests/game/run_proposal_view_tests.gd`
3. `docs/engineering/gate3/DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md`
4. `docs/engineering/gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md`
5. `docs/engineering/evidence/DEV-027_KEYBOARD_FOCUS_EVIDENCE.md`
6. `docs/engineering/evidence/DEV-027_KEYBOARD_FOCUS_RESULTS.json`
7. `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md`
8. `docs/engineering/tasks/DEV-027_RESULT.md`
9. `docs/engineering/tasks/DEV-027_PROVENANCE.json`

### 실행·검증 결과

| 구분 | 명령 / 결과 | 근거 |
| --- | --- | --- |
| 제안 View 자동 | `--headless --script res://tests/game/run_proposal_view_tests.gd -- --output=<fresh-evidence>` / **737단언·실패0, exit0, ERROR/SCRIPT ERROR0** | view-05-final. 기존225(저장1 포함) 보존 + Tab 대상60·명시 command13·순환3·순서28사례 |
| 운영 화면 자동 | `--headless --script res://tests/game/run_operations_gui_cases.gd -- --auto` / **271/0** | regression-operations |
| 공사 화면 자동 | `--headless --script res://tests/game/run_construction_ui_tests.gd` / **898/0** | regression-construction |
| S01 예외·복구 자동 | `--headless --script res://tests/game/run_s01_exception_tests.gd` / **334/0** | regression-s01 |
| 프로젝트 로드 | `--headless --editor --quit` / **exit0·ERROR/SCRIPT ERROR0** | final-load; 초기 import와 구분 |
| 기존 자연/OS GUI | **NOT_RUN** | 기존 Track A/B의 당시 한정 수용을 재사용. 새 OS/독립 실행·자연 완주·Design 재수용 아님 |
| 실제 게임 플레이·빌드/export·성능 | 각각 **NOT_RUN** | 이번 자동/최소 수정 범위 밖 |

엔진 공통 인자는 `--path <worktree> --log-file <fresh-run>/engine.log`; Godot4.7.2 `ed1daf0bf` console, 실행별 APPDATA/LOCALAPPDATA 격리다. 마지막 View와 최종 로드는 최종 소스161개 해시로 식별한다. 직접 영향 회귀와 최종 View 사이 제품 변경0, 동일성 차이는 새 단언을 추가한 검사 파일1개뿐이며 run별 해시를 공개 JSON에 보존한다.

수정 전 동일 runner의745/44에서 제품 수정 후703/0으로 바뀌었다. 비활성 Tab 정지점42회가 제외되어 동적 순환 단언 수가 줄었고 무입력 저장 복귀2개도 통과했다. 이후 계획의 역방향/가시성34단언을 보완해 최종737/0을 확인했다. 개발 중 view-01 검사 오류, view-02의709/47(HUD3 포함), view-03의745/44 raw를 삭제/승격하지 않았다. 실패 집계/저장 코드는 바꾸지 않아 별도 deliberate failure는 NOT_RUN이며 동일 runner view-03의 exit1 근거를 연결한다.

### 미해결·승인 범위

F04 same-owner restore의 Home/End/PageUp/PageDown(delay0)·End(delay1) **5개 관측은 사용자 위치 우선 제안을 충족하지 않음**을 그대로 남겼다. 입력 취소 세대 확장은 이번 최소 수정 밖이며 Track B 기대 확인 후 필요한 행만 별도 계획한다. 합성 휠6행·실제 return의 읽기/휠4행은 전제 미성립으로 INCONCLUSIVE다. 공통 HUD resume3회도 원 FAIL/범위 밖 관측을 보존한다. 이를 자동 통과나 B06-02 전체 해소로 바꾸지 않는다.

기획 명세 변경은 현재 없음. 같은-owner 기대 변경이 필요한 경우 해당 행에만 RFC 절차를 적용한다. DI03 HOLD·DEV026 한정 수용/PARTIAL·일1 미관측·P07 구분·#92/F08·기존 A/B PARTIAL·S3-10-C/S3-12/HQ·Owner Stage 최종 인수 대기를 유지한다. 정책/무결성 검사는 아래 후속과 PR에 연결하고 원격 CI 완료는 PR head 기준으로 확인한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

### 제출 전 정책·무결성 후속

- `policy.py doctor`: PASS. 훅/도구 유효; 원격 보호와 별도.
- `policy.py check`: **PASS**,804파일/68GDScript, formatter/linter 오류0.
- `.local/validation/DEV-027/keyboard-focus/audit.py --manifest`: **PASS**, 정확한9경로·provenance8개·승인 Markdown4개 prefix·원 View JSON224단언·소스161개·비변경 추적795개·공유 기존 데이터2개 보존. `git diff --check`도 PASS.
- Godot가 생성한 untracked import/translation176개는 경로·해시 확인 후 `.local/validation/DEV-027/keyboard-focus/generated-imports/`에 보존 이동했다. 원본 추적 파일·디자인 산출물을 수정/삭제하지 않았으며 제출 파일에 포함하지 않는다.
- 로그/최종 산출물 해시는 `.local/validation/DEV-027/keyboard-focus/`의 `doctor.txt`, `policy-check.txt`, `final-audit.json`에 보관한다. JSON 포장 중 summary 변수 충돌은 문서 생성 전 감사에서 중단되어 정정했고, 원 실행 결과·제품에는 영향이 없다.
- 원격 main 보호는 policy·department-policy strict/Actions App15368·관리자 적용·선형 이력·force/delete 금지 확인. 이 확인은 병합 권한을 부여하지 않는다. Commit 이후 fetch·preflight, push·PR·CI 완료는 실제 PR head에 연결하며 본 문서에서 미래 PASS를 선언하지 않는다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 17. #146 Track A 확인사항 수정·PR177 후속 — 2026-11-22

Owner의 새 확인사항 수정·기존 PR 포함 지시를 [계획 §12](../gate3/DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md)에 기록했다. [Track A 댓글](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7076149744)의 원본 패킷181개, REPORT/manifest 해시·정정문·FOCUS 연결·046화면을 대조했으며 원문/과거 검증은 보존했다. 제품 시험37596bd의 관측을 최신 main 실행으로 바꾸지 않는다.

### 변경 파일·실제 보완

이번 후속의 정확한9개 파일은 아래와 같다. 초기 PR의stage1_view.gd는 그대로이므로 **PR 전체10개 경로**다.

1. `scripts/ui/proposal_view.gd`
2. `tests/game/run_proposal_view_tests.gd`
3. `docs/engineering/gate3/DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md`
4. `docs/engineering/gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md`
5. `docs/engineering/evidence/DEV-027_KEYBOARD_FOCUS_EVIDENCE.md`
6. `docs/engineering/evidence/DEV-027_KEYBOARD_FOCUS_RESULTS.json`
7. `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md`
8. `docs/engineering/tasks/DEV-027_RESULT.md`
9. `docs/engineering/tasks/DEV-027_PROVENANCE.json`

K01-12/13/14의 비활성 건너뜀은 초기 Host 수정으로 동작하므로 제품 추가 변경 없이 **단일 Tab/역Tab11경로**를 고정했다. 즉시 owner→실제 Host.present fallback→안정 owner/가시성 및 모델 무효과를 확인한다. 계약/설득의 Enter/Space 명령1회도 실제 합성 입력으로 확인한다. 기존 `_tab_to`의 최종 도달만으로 보고된 잘못된 중간 경로를 통과시키지 않는다.

K01-04는 S12 선택인데 마지막 행이 내부scroll0·y139+27/목록높이130 밖으로 잘리는 것을 확인했다. `proposal_view._render_map`의 동일 선택에 대한 deselect/select 반복을 제거하고 선택 변경/선택 없음 분기는 유지했다. 수정 뒤 내부scroll40·행y99+27로 목록/외부 영역 안에 들어온다. 버튼 활성화·유효성/focus 소유권 검사·기획 규칙·모델·CI 변경0이다.

### 실행 명령·검증

[증거 §6](../evidence/DEV-027_KEYBOARD_FOCUS_EVIDENCE.md)과 [JSON followups[0]](../evidence/DEV-027_KEYBOARD_FOCUS_RESULTS.json)에 실제 명령·소스161개·실패/최종 raw 해시를 연결했다. 기존 JSON 최상위의737/0 등은 과거 근거로 그대로 보존한다.

| 구분 | 실행 / 결과 |
| --- | --- |
| 수정 전/후 동일 runner | `<Godot> --headless --path <worktree> --script res://tests/game/run_proposal_view_tests.gd -- --output=<fresh-evidence>`: **819/1→819/0**, 각각 engine exit1→0, ERROR/SCRIPT ERROR0. 원 실패는 K01-04:last_row_inside_list1개 |
| 직접 영향 회귀 | `--headless --script res://tests/game/run_s01_exception_tests.gd`: **334/0**, exit0·ERROR/SCRIPT ERROR0 |
| 프로젝트 로드 | `--headless --editor --quit`: 초기/최종 각각 exit0·ERROR/SCRIPT ERROR0 |
| 이전 회귀 | 초기 PR의1503회귀는 당시 범위 재사용. 이번334와 중복 합산하지 않음 |
| OS GUI·독립 실행·새 자연 VS02 | 각각 **NOT_RUN**. 보완본 Design 재수용 별도 |
| 게임 플레이·빌드/export·성능 | 각각 **NOT_RUN** |

원 view-01의807/3은 목록1개와 이미 소유한 요청 버튼의 시작 가시성 가정2개로 구분해 보존했다. helper는 새 도달이 필요할 때만 시작점의 Tab 가시성을 단언하고 이미 소유한 시작점은 실제 owner/trace를 기록한다. 한 Tab 후 목적지 owner/가시성 단언은 강화했다. 목록 좌표는 내부 스크롤을 차감하여 비교한다. 이 검사 정정 후 view-02/03은 정확히 같은 runner 해시이며 다른 제품 변경은 없다.

### 범위·대기 상태

기존 main이 기획 문서7개로 d8b6f4a에 진전하여 무충돌 GitHub base-sync325b54a를 fast-forward로 수신했고, 사전 검사에서 `work=1, verified_base_sync=1` PASS를 확인했다. main 병합/강제 push/기획 산출물 직접 수정은 아니다. 이번 제출도 정상 Commit·Push와 동일 PR177의필수 policy/department-policy를 사용한다.

원 K01 OS FAIL/PARTIAL 및 순수 OS 계약·설득 NOT_VERIFIED는 수정본 독립 재검수 전까지 유지한다. 재검수 제안은 K01-12/13/14·K01-04 국소 행이며 전체 자연 완주를 새 조건으로 삼지 않는다. F01 RACE INCONCLUSIVE·기존 F04 자동 우선순위5개/INCONCLUSIVE10, GUI shader cache 오류 실행별4개(원인/연관 미확인)를 구분한다. 기존 DEV026 한정 수용/PARTIAL·P07 구분·DI03 정책결정/실제구현 HOLD·F08 선택/최종인증·S3-10-C/S3-12·HQ/Owner 최종 인수 대기를 유지한다. 기획 명세 변경 필요 없음.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

### 후속 제출 전 정적 검사

- `policy.py doctor` PASS, `policy.py check` **PASS(810파일/68GDScript)**, formatter/linter·`git diff --check` PASS.
- `keyboard-focus-issue146/audit.py --manifest`: **PASS**. PR10경로·provenance9개·기존 Markdown5개 prefix·원 JSON 최상위 값·기존736개 JSON 단언(+저장1)·현재 소스161개·PR 경로 밖800추적파일·기존 Host·공유 데이터2개·Design 패킷181개 보존.
- 생성된 import/translation176개는 해시 확인 후 새 로컬 generated-imports 보관 위치로 이동했다. 추적된 디자인/제품 파일 삭제 없음.
- 원격 보호: policy·department-policy/Actions15368 strict, 관리자 적용·선형 이력·force/delete 금지 확인. 로컬 감사/실행 원본은 `.local/validation/DEV-027/keyboard-focus-issue146/`. 원격 CI는 후속 commit head로 다시 확인하며 검증 통과를 main 병합 승인으로 사용하지 않는다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
