# DEV-027 W04B·VS-02 증거 색인 — P1 비의존 모델

- 작성: Development / AGT-DEV-0004 / 2026-11-22 KST.
- 상태: **P1_LOCAL_REVIEW**. 본문은 단독 모델 검증이며 전체 W04B/VS-02 인수가 아니다.
- run_id: `DEV027-P1-20261122-01`.
- base: `1a941196cc6d963db93a9fba6a0386b16710aa46`, 작업 브랜치 `codex/DEV-027-w04b-p1-model`. 작업 커밋 없음.
- 실제 시험 코드: [JSON](DEV-027_W04B_VS02_RESULTS.json)의 `runtime_sha256`(이번13개 런타임 파일)와 `baseline_runtime_sha256`(재사용 소스 포함). 문서만으로 실행 SHA를 만들지 않는다.
- [Owner 승인·20경로](../tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md#7-p1-비의존-모델-로컬-구현검증-승인--2026-11-22) / [결과](../tasks/DEV-027_RESULT.md#7-p1-비의존-모델-로컬-결과--2026-11-22) / [실제 모델 계약](../gate3/DEV-027_W04B_SUPPLY_CONTRACT.md).
- Godot: `4.7.2.stable.official.ed1daf0bf`, Windows headless. 본체 SHA-256 `ab1824f85bfd8e0e4128182c000c4003a3e042245b2967848d089b2a04b22424`, console `c8f0a6bc45a19b33541501e57f6f7cd972ab18453743266339d495cbbe846643`.

## 1. 실행·원본 위치

모든 경로는 이번 worktree 기준이다. 저장소 원본·과거 ZIP·실패 기록을 덮지 않는다. 실행 명령/exit/오류/개수/소요시간/원본 해시는 JSON의 `runs`, 최초 시도/한계는 `prior_attempts`에 기록한다.

| 실행 | 원본 |
| --- | --- |
| 프로젝트 로드 | `.local/validation/DEV-027/p1/final-02/project-load.console.log` |
| P1 모델 자동·입력/기대/관측 | `final-02/model.console.log`, `final-02/model.json` |
| 고의 실패 종료 | `final-02/failure-exit.console.log` |
| W02·W03·W04A 회귀 | `final-01/w02.console.log`, `w03.console.log`, `w04a.console.log` |
| W05 회귀 | `w05-recheck/w05.console.log`, `w05-recheck/result.json` |
| 초기 실패·수정 중 실행 | `load-01.log`, `model-01~05.log`, `model-02~05.json` |
| 검사 감사·정책·범위/출처 | `audit-final.json`, `policy-final.log`, `doctor-final.log` |
| 이번 로드가 생성한 비제품 메타데이터 | `generated-metadata-cleanup.json`에176개 경로/해시 보관. 새 worktree의 untracked import/translation만 제거, 원본 이미지/CSV 보존 |

표의 두 번째 행 이후 짧은 경로는 모두 `.local/validation/DEV-027/p1/` 아래다. JSON의 단언에서 큰 객체는 canonical JSON SHA-256·원본 참조로 축약했고 정상 seed·실제 시각·계획·판정·명령/거래 계보는 `model.records`에 남겼다. 전체 raw 모델 출력은 로컬 원본을 사용한다.

최종 감사에서 신규 GDScript6개의 CRLF만 LF로 정규화했다. `lf-normalization.json`·`tested-source-before-lf/`에 전후 해시/원바이트를 보존한다. final-02는 최종 LF 모델·실패 종료·로드 재검사, final-01과 w05-recheck는 그 이전 실행이다. 기존 회귀/의존 소스는 변경0으로 재사용하며 JSON에 두 소스 집합을 별도 보관한다.

실제 명령 형식:

```text
<Godot> --headless --path <worktree> --editor --quit
<Godot> --headless --path <worktree> --script res://tests/game/run_w04b_tests.gd -- --output=res://.local/validation/DEV-027/p1/final-02/model.json
<Godot> --headless --path <worktree> --script res://tests/game/run_w04b_tests.gd -- --verify-failure-exit
<Godot> --headless --path <worktree> --script res://tests/game/run_w02_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_w03_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_w04a_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_w05_tests.gd
.venv/Scripts/python.exe tools/policy.py doctor
.venv/Scripts/python.exe tools/policy.py check
.venv/Scripts/python.exe .local/validation/DEV-027/p1/audit_local.py
git diff --check
```

외부 실행 감사는 exit뿐 아니라 결과 marker·실패 개수·ERROR/SCRIPT ERROR·실행 중 소스 불변을 함께 검사한다. 따라서 model-02의 exit0과 일부 단언 통과는 PASS가 아니다. 실패 종료 검사의 의도한1개 오류/exit1은 해당 러너 계약의 정상 증거다. 첫 W05 시도는150초 제한에 종료하여 최종 결과 미확인으로 보존하고, 같은 소스로 해당 회귀만 재실행했다.

## 2. 승인 행별 증거 범위

| PLN-013/DI 행 | 실제 P1 근거 | 이번 판정·잔여 |
| --- | --- | --- |
| W4B-01~04 | 5/6/8/9역·단절·중복/외부 ID, 요청 뒤 편집·현재 예측/과거 승인, 심사 잠금, 이름·역순·교체·교차 슬롯/과거 연결 | **MODEL_PASS**. 화면의 편집/잠금 표현은 L2 대기 |
| W4B-05~09 | 기존 W03 하루 예측과 무현금 효과, 순수 −1/0/+1 및 격리 음수/0 모델, 시청 반복, 업무시간 경계·실제 접수부터30분·야간 계속 | **MODEL_PASS**. 경계 fixture를 제품 P-A 실측이라고 표기하지 않음 |
| W4B-10~14 | 정부 정상 RNG3분기·설득 판정별1회, 60/30분, 보류 사본/초안, 허가와 지급800000/640000, 사실 없는 재접수 제한 | **MODEL_PASS**. E01 성공 재접수는 별도 보류 |
| W4B-15 | 실패+1440 기준을 DI03_PENDING 메타데이터로 기록, 시간이 지나도 fact 임의 생성0 | **DEPENDENT_SCOPE_PENDING**. 실제25% 수요/OD·발생·carry·반복 의미 미구현 |
| W4B-16 | 관련 사업·해당 판정·판정 후/발생 후·미사용의 순수 입력 검사 | **PURE_FIXTURE_PASS / PRODUCT_PENDING** |
| W4B-17 | stale 예약의 횟수/추출/지급0·명시적 새 요청, 중복 결과 보존 | **PARTIAL_SCOPE**. 실제 E01 소비/재접수·후속 실패 후 미복원은 DI-03 종속 미실행 |
| W4B-18~20 | 정상 전용 RNG·seed/state/draw ID, 동시 접수 순서·조회/중복 무추출, 독립 모델 정상 분기 재현 | **MODEL_PASS**. 자연 VS-02 및 사실 소비 재현은 미실행 |
| W4B-21~23 | 독립 원장의 허가→별도 계약/실제 지급·고정 허가 계획, 경쟁 계약 재검사, W04A 출처 읽기 호환 | **MODEL_PARTIAL**. 새 W04B 공사/운영 전체 연결·공사 후 금액·B 경계는 기존 규칙/회귀와 구별 |
| W4B-24~26 | 기존 W02/W04A/W05 회귀, 기존 원본 소스 보존 | **BASE_REUSE / W04B_INTEGRATION_NOT_RUN**. 공통 Pipeline 신규 단계·W04B 실제 공사/운행/보고는 P3 |
| W4B-27 | 정상 seed 후보 확보 | **VS02_NOT_RUN**. 정상 UI 전체 완주·첫 유효 영업 보고·다음 후보 미검증 |
| W4B-28 | 기존 코드 변경0 및 W02/W03/W04A/W05 집중 회귀 | **FOCUSED_REGRESSION**. 기존 수용의 시험 SHA/범위를 바꾸지 않음 |
| W4B-29 | 실제 모델 action_states·실패 사유·당시/현재 사본 | **MODEL_SUPPLIED / UI_PENDING**. Session/root·지역 의존표·실제 UI L2 미공급 |
| W4B-30 | GameClock1/2/4배·분할/일괄/정지, 동일 명령/효력 순서의 전체 모델 snapshot·추출 계보 동일 | **MODEL_PASS**. 사실/공사/운영/보고를 포함한 제품 전체 재현은 미실행 |

W4B 행은 추적 색인이지 테스트 횟수/GUI 횟수가 아니다. 전체 행을 PASS로 일괄 변경하지 않는다. 독립 실행/Design/VS-02·빌드/export·새 CI는 **NOT_RUN**이다.

## 3. 보존·다음 검토

- P1 비의존 범위의 결과와 위 보류 행을 검토 요청한다. 구현 결과 승인·Git 제출·main 병합·전체 Stage 인수는 각각 별도다.
- DI-03의 실제 의미 확인 및 종속 범위 착수, P3 실제 Session/Pipeline 공급, 해당 Design L2 수용 후 화면 통합을 순서대로 진행한다. 현재 승인으로 이 단계를 실행하지 않았다.
- DEV-026 한정 수용·PARTIAL/INCONCLUSIVE·미관측, S3-12/HQ·Owner 최종 인수 대기는 그대로다. 원본 검증/정정 문서를 재작성하거나 과거 미확인을 PASS로 바꾸지 않았다.
- 기존 공통표 검토 완료는 #92 후속 댓글과 연결하며 새 문서 PR·전체 GUI 반복을 종료 조건으로 추가하지 않는다. F08 최종 규격 대기는 유지한다.
- 새 게임 규칙 변경 필요 없음. 기존 RFC-DEV-027-01의 종속 확인만 유지한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
