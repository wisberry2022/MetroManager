# DEV-026 — DSG-008 후속 계약 검토·Owner 착수 순서 결정

> **현재 로컬 후속 — 2026-11-21:** 경로 재지정 승인 적용·기존35개 실패 해소·자동 GUI266/266 PASS. LOCAL_REVIEW / PRODUCT_L2_PENDING. 후속8개 파일은 미커밋이며 Commit·Push·main 병합은 별도 승인이다. 아래 이전 본문의 PARTIAL·승인 대기·NOT_RUN은 당시 기록이고 최신 근거는 마지막 후속 절과 증거 JSON gui_followup을 따른다.

<!-- 아래 이전 본문은 당시 상태로 보존한다. -->

> **현재 상태 — 2026-11-21:** PR_REVIEW_PARTIAL / TEST_PATH_REASSIGNMENT_PENDING / PRODUCT_L2_PENDING. Owner가 기존23개 파일의 Commit·Push·Draft PR 공유를 요청했다([티켓 §9](DEV-026_S01_EXCEPTION_SCOPE.md)). 기존 GUI35개 실패·검사기 재지정 승인 대기·Design 수용 대기는 유지한다. 앞선 HOLD/NOT_RUN·로컬 검토 기록은 당시 이력이며 main 병합은 별도 승인이다.

- 담당: Development / AGT-DEV-0004 / 2026-11-14.
- 현재 상태: **DOCUMENT_REVIEW / CONTRACT_PROPOSED / OWNER_IMPLEMENTATION_DEFERRED**.
- 기준 main: `9e6154e926d44cdbbb2fb117fb7d3fc56d152eac`. 브랜치 `codex/DEV-026-s01-exception-contract`.
- 문서 제출 기준 main: `2baed0518e5443007c159962bfba46a8eeae5fdb`. 최초 소스 분석 기준은 위 SHA로 보존한다.
- Owner 지시·문서 제출 권한은 [티켓](DEV-026_S01_EXCEPTION_SCOPE.md) §1과 아래 후속 결정을 따른다.

## 결과

#104 최신 Design 회신과 선행 DEV 회신의7영역을 현재 S01 소스·20사례/38문구에 대조했다. 현재 공급 필드와 새 제안을 분리하고, 최소 실행 소속/계약 메타데이터·지역 guard·새 Session의 전체 View 재생성을 권고안으로 구체화했다. 정책·경제·세이브 규칙은 변경하지 않는다.

새 모델 enum/API가 이미 있다고 주장하지 않는다. 현재 제품은 완전한 동기 snapshot을 전제로 하며 일반 S01 pending은 없다. 예측 입력판·보고 run/day 식별·부분 누락·복귀는 새 검증이 필요한 소비 경계다. 같은 view_revision에서도 clock.remainder가 변할 수 있다는 현행 특성을 보존한다. report UNAVAILABLE을 일괄 미마감으로 해석하지 않는다.

| 신규 로컬 파일 | 내용 |
| --- | --- |
| [DEV-026_S01_EXCEPTION_SCOPE.md](DEV-026_S01_EXCEPTION_SCOPE.md) | 현재 지시·로컬 범위, 개발 분해·정확한 미래 변경 경로·승인 선택안 |
| [DEV-026_S01_EXCEPTION_CONTRACT.md](../gate3/DEV-026_S01_EXCEPTION_CONTRACT.md) | 고정 SHA 실제 코드/필드·책임·지역 행동·Session/보고/예측·복귀 계약 및 L2 RFC 초안 |
| [DEV-026_S01_EXCEPTION_VALIDATION_PLAN.md](../gate3/DEV-026_S01_EXCEPTION_VALIDATION_PLAN.md) | 20사례/copy_ids 적용·제외, X-01~07 검증·기존 증거 재사용·종료 기준 |
| 본 결과서 | 정적 확인·검증/NOT_RUN·기존 작업 보존·검토 요청 |

최초 로컬 검토에서는 위 Markdown 4개만 작성했다. 이번 제출은 그 4개와 새 `DEV-026_PROVENANCE.json`의 문서 출처 선언만 포함한다. 제품·테스트·씬·DATA·기존 UI-DC/Design/HQ/기획·기존 PROVENANCE·원본 증거는 수정하지 않는다. 기존 root main 및 DEV-019 로컬 4개 산출물도 보존한다. DEV-019의 HQ 전달 완료·별도 PR 없음과 이번 DEV-026 문서 PR 승인은 별개의 지시다.

## Owner 후속 결정과 개발 판단 — 2026-11-14

Owner는 본 개발 대화에서 DEV-026의 현재 검토 내용을 디자이너 사전 확인용으로 원격에 반영하고, 개발 측 이견이 없으면 이 결정을 결과서와 PR에 포함하도록 지시했다. **DEV-026 구현·제품 검증은 지금 착수하지 않으며 DEV-022~025의 선행 업무를 수행한 뒤 착수한다.** 원문과 정확한 문서 제출 범위는 티켓 §1에 기록한다.

**개발 판단: 이견 없음.** 기능 공급과 같은 UI 파일의 변경을 먼저 안정화한 뒤 예외 소비 계약을 최신 상태에 맞추는 순서는 타당하다. 다만 DEV-022~025 모두가 DEV-026의 절대 기술 선행조건이라는 뜻은 아니며, 이번 결정은 Owner의 작업 우선순위다.

| 선행 업무·공개 상태 | DEV-026보다 먼저 진행하는 이유·경계 |
| --- | --- |
| [DEV-022 #78](https://github.com/wisberry2022/MetroManager/issues/78): W06 실제 운행·정산·보고 공급, 실행 승인 대기 | current·daily·예측/실적·고정 보고의 실제 공급 기반이 바뀔 수 있다. 먼저 구현한 실제 필드를 기준으로 이번 계약을 재대조하면 두 번 수정하는 일을 줄인다. |
| [DEV-023 #79](https://github.com/wisberry2022/MetroManager/issues/79): W06 운행·재무 UI, 실행 승인 대기 | 제안 경로가 stage1_session/view/map과 직접 겹친다. 실제 공급·화면 연결과 정상/필수 예외의 L2 검토를 먼저 수행하고, 공통 S01 guard와 생명주기를 이어 적용하는 편이 안전하다. |
| [DEV-024 #80](https://github.com/wisberry2022/MetroManager/issues/80): VS-01 통합 재현·회귀·GUI 증거, 실행 승인 대기 | 기능 구현만이 아니라 DEV-018~023의 실제 연결과 인수 증거를 확보하는 업무다. 확인된 흐름을 DEV-026의 영향 회귀 기준으로 쓸 수 있다. 이후 변경 영향은 별도로 확인한다. |
| [DEV-025 #97](https://github.com/wisberry2022/MetroManager/issues/97): F-08 격리 기술 실험, 실행/Git 승인 대기 | 제품 기능 추가가 아닌 폰트·배율·배치·입력/포커스·성능 비교다. 결과는 복귀·포커스와 표현 구현 판단에 도움이 된다. 모든 F-08 최종 규격 확정을 최소 UI/DEV-026의 새 일괄 차단조건으로 만들지는 않는다. |

최신 [HQ 통합 인수표](../../hq/STAGE2_ACCEPTANCE_MATRIX.md)의 DEV-022 → DEV-023 → DEV-024 → HQ/Owner 인수 경로와 일치한다. DEV-025를 이들 업무와 무조건 직렬화하는 새 기술 의존성이나 별도 일정은 이 문서에서 만들지 않는다. #78/79/80은 댓글 0개, #97과 #104의 현재 공개 기록을 확인했으며, 기존 담당명/승인 대기 표시는 작성 당시 기록으로 읽는다. Owner가 승인한 담당 승계는 유지하고 이 우선순위 지시를 DEV-022~025의 미승인 구현/Git 범위에 대한 포괄 승인으로 전용하지 않는다.

다음 경계를 함께 유지한다.

1. DEV-023의 실제 화면 통합 전 정상/필수 오류 공급·Design L2, DEV-024의 실제 완주와 인수 기준은 그대로 필요하다. DEV-026 연기는 기존 필수 품질 기준의 면제가 아니다.
2. 선행 업무에서 실제 제품 결함이나 차단 영향이 발견되면 해당 티켓의 승인 범위에서 처리한다. DEV-026 전체를 앞당기거나 결함을 미해결인 채 PASS로 만들지 않으며, 범위 충돌이면 해당 차이만 HQ/Owner에 보고한다.
3. DEV-026 재개 시 선행 결과와 최신 통합 SHA에서 snapshot/명령·화면 수명·정확한 경로·20사례 적용/제외·검증 계획을 다시 대조한다. 이번 초안의 버전 문자열/API/경로를 확정 구현 계약으로 사용하지 않는다. 바뀐 의미/직접 영향 행만 Design과 대조한다.
4. DEV-024 증거를 미래 DEV-026 head의 새 실행으로 표시하지 않는다. 변경 영향이 없는 증거는 재사용하고 영향 행만 회귀한다. 기존 Q03~05 수용·Q12 한정 수용과 상위 PARTIAL·F-08 미확정은 보존한다.
5. 이번에는 Design이 사전 열람할 문서 PR과 저장소 제출 검사만 수행한다. 게임 자동·Godot 로드·실제 GUI·복구/부분 자료/새 Session 실험은 계속 NOT_RUN이며, DEV-026의 구현·제품 검증 착수는 보류한다.

이번 결정으로 새로운 게임/경제/세이브 명세 변경이나 현재 일정 차단 사유는 발견하지 못했다. 정확한 DEV-026 실행 일정과 확정 구현 범위는 선행 결과 대조 후 정한다.

## 정적 근거와 확인 수준

- #104 최신 [Design 회신](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6874170205)과 [선행 DEV 회신](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6873960483)을 원격에서 재확인했다. 작성 시 최신 댓글6개, 새 추가 질문 없음.
- 최신 main의 PR #118/PLN-008은 기획 문서3개 변경이다. 이전 `a65591b1e632121cd6dab4b66a23424fe8803869` 대비 이번 조사 제품 코드 변경 없음. 정책 문서 게시를 구현/Git 승인으로 해석하지 않았다.
- 실제 소스: main·Stage1Session/View/Map·PredictionState·RoutePlan·DailyLedgerReport·MinutePipeline·GameClock·기존 W04A/W05 소비기·W07 자동/GUI/fixture를 읽었다. 계약안에 함수/행 고정 링크를 제공한다.
- 기존 UI-DC 정적 의미 수용·DSG-008 v0.2/작업표·PM-015 REVIEW 상태와 후속 이슈 판정을 구분한다. 7영역은 대조 단위이며 GUI7회/20회 의무가 아니다.
- DEV-026 검색에서 main/refs/commit 제목/worktree 파일명과 GitHub Issue/PR 기존 사용을 찾지 못했다. 이는 로컬 작업 식별이며 원격 예약/신원 인증이 아니다.

## 최초 로컬 검토의 검증·NOT_RUN — 당시 기록 보존

검증은 이 worktree에서 기존 DEV-019 QA 환경의 `../DEV-019-q03-q05-qa/.venv/Scripts/python.exe`를 읽기 재사용했다. `PYTHONUTF8=1`, TEMP/TMP는 이 worktree의 `.local/temp`로 설정했다. 원격 보호·권한 인증은 검사 범위가 아니다.

| 검증 명령·대상 | 실제 결과·증거 |
| --- | --- |
| 위 Python으로 `tools/policy.py doctor` | PASS. 로컬 정책 환경 확인 |
| 위 Python으로 `tools/policy.py check` | PASS, exit 0. 검사 시 files=595 / GDScript=39, 포맷 변경 없음. `.local/validation/DEV-026_POLICY.log` |
| 위 Python의 `-` 표준입력 일회성 정적 감사 | PASS. 신규 Markdown 4개 UTF-8/BOM 없음·LF·끝줄·공백, 상대 링크 18개, 원본 카탈로그/검수표와 20사례·copy_ids 일치, 카탈로그 38문구. `.local/validation/DEV-026_STATIC_AUDIT.json` |
| `git diff --check`, `git status --short` 및 tracked/staged diff 대조 | PASS. 기존 tracked/staged 변경 0개, 신규 문서 4개만 존재. Design의 actual_result=null·evidence_refs=[]·NOT_RUN도 유지 |

- 게임 자동 테스트: NOT_RUN.
- Godot 프로젝트 로드: NOT_RUN.
- 실제 GUI/키보드·게임 플레이·부분 자료/새 Session/지연 응답/복귀 실험: NOT_RUN.
- 빌드/export·성능·폰트/DPI/필터·접근성/외부 사용성 인수: NOT_RUN.
- Commit·Push·PR·이번 원격 CI·preflight·병합·외부 댓글/메시지: NOT_RUN.

## 문서 제출 검증 — 후속 기록

제출 기준까지의 진전은 PR #119/PM-016의 HQ 문서 6개뿐이다. 제품·테스트·정책·Design 원본은 최초 분석 기준과 동일하다. 미공유 작업 브랜치를 정상 fast-forward로 동기화했으며 root main이나 다른 worktree는 전환하지 않았다.

문서 제출용 전용 `.venv`를 준비했다. 최초 제한 환경의 pip 연결은 DNS 오류로 실패했으며 정상 네트워크 설치로 저장소 고정 요구사항을 설치했다. 검사 우회나 의존성 파일 변경은 없다. GitHub 플러그인의 보호 설정 조회는 403으로 제한되어 기존 Git 인증의 읽기 전용 API로 확인했다. main은 strict `policy`·`department-policy`, 관리자 적용·선형 이력·대화 해결 필수, force push/삭제 금지다. 승인 리뷰 수 0은 기존 단일 계정 운영이며 Owner의 별도 병합 승인 원칙을 유지한다.

문서·정책 검증 결과는 아래와 같다. 커밋 이후 preflight·원격 head와 CI는 이 PR 본문 및 실행 결과를 정본으로 연결하며, 아직 실행하지 않은 검사를 이 문서에서 PASS로 표시하지 않는다.

- `.venv/Scripts/python.exe tools/policy.py doctor` 및 `check`: PASS. 고정 gdtoolkit의 GDScript 39개 포맷 변경 없음·lint 정상. 로그 `.local/validation/DEV-026_SUBMISSION_POLICY.log`. TEMP/TMP는 이 worktree의 `.local/temp`.
- Python 정적 감사: PASS. 신규 Markdown 4개·출처 JSON 1개만 존재, 기존 tracked 파일 변경 0개, UTF-8/LF·상대 링크 20개·20사례/copy_ids·38문구·출처 blob 4개 대조. `.local/validation/DEV-026_SUBMISSION_STATIC_AUDIT.json`. 기존 Design 실제 결과/증거/NOT_RUN과 분석 기준 이후 제품·시험·Design 원본 불변 확인.
- `git diff --check`: PASS. stage/commit 시 정확한 5개 경로와 정상 훅을 다시 확인하며, 문서 제출의 정책/도구 검사를 제품 자동검사로 합산하지 않는다.
- 제품 자동·Godot 로드·실제 GUI/플레이·빌드/export·성능: NOT_RUN — Owner의 DEV-026 착수 보류.
- main 병합·릴리스/배포·별도 Issue 댓글/부서 메시지: NOT_RUN.
- 출처 선언은 REPORT_ONLY이며 신원·승인 인증이 아니다. 등록부 지연은 실제 Agent-ID와 유효 Owner 전환 기록을 유지하여 보고한다.

## 남은 결정과 검토 요청

권고 계약의 채택은 아직 확정되지 않았다.
Design의 사전 검토 대상은 지역 자료/행동군 의존성, 최소 메타데이터, 새 Session의 View 재생성, 실제 복귀 포커스, 적용/제외 사례다. RFC-DEV-026-01은 OPEN / PROPOSED이며 Design의 새 수용은 PENDING이다. 문서 PR 공유는 승인됐으며 B/C 구현·제품 검증은 Owner 결정으로 보류한다. 정확한 일정은 NOT_ESTIMATED다.

게임/경제/세이브 명세 변경 필요 NONE. 기술 계약은 PROPOSED이며 구현 승인 후 검증과 영향 행 Design 인수가 필요하다. Q03~Q05 잔여 PASS, QA-001/002·OBS-01·A02-11·Q12의28조건 한정 수용, A01-Q12 상위 PARTIAL, F08-01~04 및 최종 규격 미확정을 보존한다. DSG-008 전체·S2-D01·Stage DONE을 선언하지 않는다.

## 2026-11-21 후속 — Stage 3·Design 사전 의견 반영

- 기준 main: `de0f03f9d2fcc301940a4176f1359b2788a51950` / 브랜치 `codex/DEV-026-design-plan-followup`.
- 현재 효력: **STAGE3_SCOPE_CONFIRMED / IMPLEMENTATION_READINESS_PENDING / PRODUCT_VALIDATION_NOT_RUN**.
- Owner 현 요청·문서5개 권한: [티켓 §7](DEV-026_S01_EXCEPTION_SCOPE.md).
- 근거: [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053550740), [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053570152), [병합 PR #149](https://github.com/wisberry2022/MetroManager/pull/149).

이전 OWNER_IMPLEMENTATION_DEFERRED·DEV-022~025 선행 대기는 당시 기록으로 보존한다. PM-020으로 공식 편입됐고 현재 사전 의미 의견도 수신했으므로 **미수신/무기한 HOLD를 현재 상태로 재사용하지 않는다**. 다만 현재 지시는 문서 보완 PR이며 실제 구현/게임 실행은 별도 승인 대기다.

| 변경 파일 | 보완한 내용 |
| --- | --- |
| S01_EXCEPTION_SCOPE | Owner 요청·정확한 문서5개, 현재24개 미래 후보·4개 추가 이유, 제품/Git 권한 구분 |
| S01_EXCEPTION_CONTRACT | 지역 의존표에 P06/P07/W04B 포함, FIXED_DAY·확인 사본·새 자식 수명/옛 callback, 실제 기존 Control을 근거로 한 화면별 fallback 후보, 요청 사본/현재 초안 표현 |
| S01_EXCEPTION_VALIDATION_PLAN | 기존20사례·copy_ids 보존, RP-01~08·X 묶음의 최소 표본·기대·정상/fixture·공동 심사 구분 |
| 본 결과서·PROVENANCE | 현재 문서 검증/잔여·새 base/4개 Markdown blob 선언 |

구체 fallback 순서는 DEV 후보이며 Track B가 최종 수용한 구현으로 기록하지 않는다. P06 `controls.back/labels.title`, P07 `controls.day/controls.refresh/labels.title`의 존재는 위 main 소스로 확인했고 실제 복귀 실행은 하지 않았다. 심사/편집/접수의 게임 규칙은 DEV-027/Planning의 승인 의미를 따르며 Track B 표현 의견으로 신설하지 않는다.

기존24개 미래 후보를 확대하지 않고 실제 문서5개만 수정했다. 과거20개 후보/최초 검토 원문은 이력으로 보존하며 현재 적용 차이는 후속 절에 명시했다. 기존 PROVENANCE의 최초 제출 원본은 [병합 기준 고정 파일](https://github.com/wisberry2022/MetroManager/blob/de0f03f9d2fcc301940a4176f1359b2788a51950/docs/engineering/tasks/DEV-026_PROVENANCE.json)에 보존하고 현재 manifest는 이번 base/수정 blob으로 갱신한다.

- `.venv/Scripts/python.exe tools/policy.py doctor` 및 `check`: PASS / exit0. 파일708개·GDScript53개 정적 formatter/linter, 포맷 변경 없음. 로그 `doctor.log`·`check.log`.
- `문서5개 한정·기존 본문/20사례·EX 적용/제외 보존·UTF-8/LF·링크·출처 blob`: PASS. 변경5개·Markdown blob4개·상대 링크19개·고정 SHA 링크16개·기존 본문4개와20사례/copy_ids·EX-05/16/18 보존. 일회성 문서 감사 `audit_docs.py`의 출력은 `audit.json`에 보관.
- diff --check·정상 Commit 후 preflight·새 head 필수 CI: 제출 단계 확인, 실제 결과는 PR에 연결.
- 정적 검사 로그: `.local/validation/design-plan-followup/`.
- 제품 자동/프로젝트 로드/GUI/독립 실행/실험/빌드/export: **NOT_RUN**.

미해결: 실제 공급/제품 L2·검증 수용, RFC-DEV-026-01 OPEN·PROPOSED, 별도 구현/실행·미래 제품 Git 및 main 병합 권한. DI-03 Planning 확인은 종속 W04B만의 잔여다. Track B RD별 최종 심사/F08 선택/적용은 #92에 유지한다. 새 게임 명세 변경 필요는 현재 확정하지 않았다.

## 2026-11-21 후속 — DEV-026 로컬 구현·검증

Owner가 두 문서 PR의 main 병합 후 DEV-026 우선 진행을 지시했다. [티켓 §8](DEV-026_S01_EXCEPTION_SCOPE.md)의 원문·범위에 따라 base `ecb2708bfa7bd3230d56c60b910d6831511953c6`에서 독립 worktree/브랜치 `codex/DEV-026-s01-exception-implementation`로 작업했다. 공유 root의 기존 DATA 수정2개는 보존했다. 앞선 문서 검토/보류·기존 Stage 2 증거는 당시 기록이며 이번 구현을 과거 수용으로 소급하지 않는다.

현재 결과는 **LOCAL_REVIEW_PARTIAL / OWNER_TEST_PATH_REASSIGNMENT_PENDING / PRODUCT_L2_PENDING**이다. [증거 색인](../evidence/DEV-026_S01_EXCEPTION_EVIDENCE.md)과 [결과 JSON](../evidence/DEV-026_S01_EXCEPTION_RESULTS.json)에 실제 명령·종료·오류·범위별 근거·파일 해시·남은 행을 연결한다.

| 변경 묶음 | 실제 효과 |
| --- | --- |
| Session·신규 순수 계약 검사기 | 최소 메타데이터/실행 소속·선택 보고일 공급, 구조·지역·판·행동 guard, 부분 자금/당일 독립 공급 |
| Stage1 View/Map | 잘못된 현재 관측의 표시·입력 제한, 사라진 marker 제거, 표시 계획판 명령 전달, 새 Session 전체 View 재생성·옛 callback 차단·유효 포커스 복귀 |
| P06/P07 | 실제 Session 귀속, 독립 유효 영역 유지, FIXED_DAY/확인 사본 검증 및 오래된 조회 보류 |
| W07/F08 기존 전환기·신규 자동/GUI fixture | 기존 새 Session 대입을 새 호스트로 정렬, 경계 반례·실패 감지·실제 OS 입력/화면/무효과 기록. F08 규격 재선정 없음 |
| 계약/범위/계획/본 결과·출처/증거 | 현재 구현 권한·행 의존성·실행 구분·원본 로그 식별과 남은 검토 범위 |

실제 경로 목록과 변경 해시는 JSON의 `changed_files`를 정본으로 삼는다. 승인된 최대24개 경로 밖 제품 변경은 없으며 `run_operations_gui_cases.gd` 재지정은 §8.1 승인 대기다. 원장/시각/경제 모델·DATA·scenes·project.godot·타 부서 문서·정책/CI는 변경하지 않았다.

미해결은 기존 소비 전환기 경로 재지정/관련 회귀, 실제 공급 L2·독립 실행·Design 검증 수용 및 Owner 로컬 검토다. W04B 실제 공급은 DEV-027 후속, DI-03/E01과 F08 최종 규격은 별도다. 새 게임/경제/세이브 명세 변경 필요 NONE, RFC-DEV-026-01은 제품 수용까지 OPEN이다.

이번 제품 Commit·Push·PR·원격 필수 CI·main 병합·릴리스/배포는 **NOT_RUN / 별도 승인**이다. 승인된 이전 문서 PR의 CI를 이번 미커밋 제품 검증으로 전용하지 않는다. 빌드/export·성능·전체 자연 VS-02는 NOT_RUN이다. 완료 보고는 검수 요청이며 공식 승인/DONE이 아니다.

### 최종 로컬 대조 — 승인 대기 잔여 분리

- 신규 자동 경계 **334/334 PASS**, W07 **322/322 PASS**, 각 exit0·엔진/스크립트 오류0. 타입 검사를 선행하도록 보완하고 첫날 이후 보고 없음·root/P07 보고 식별·부분 재무 공급·복귀를 단언했다.
- W03 **101**, 입찰 UI **460**, 공사 UI **898**, P06/P07 공급 **158** 검사 PASS. 각 실행의 원본 SHA 대신 착수 full base와 당시 파일 해시를 연결하며 최신 main에서 새로 실행한 것으로 기록하지 않는다.
- 기존 GUI 자동 검사 **245개 중35개 FAIL / exit1 / 엔진 오류0**. V05·U11·U17의 최초 실패6개는 후속 대조에서 해소됐고, 남은35개는 `_consumer_cases()`의 Session 미귀속/다중 실행 표본 경로에 있다. 검사기를 아직 수정하지 않았고 전체 PASS를 선언하지 않는다. 정확한 단언/로그는 증거 JSON `operations-02`에 연결한다.
- DEV 자체 GUI2회에서 총21개 viewport 캡처를 보관했다. 전체 자료/자금 지역 누락·동일 Session 복구, 지도→목록 포커스·같은 ID, P07 Tab/Enter 왕복·고정 과거 보고, 새 Session의 새 View를 관찰했다. 자동 단언 수에 합산하지 않는다.
- 프로젝트 로드·제품 headless 초기화 PASS. 격리 DATA 실패는 실제 main의 exit1, 제품 DATA 불변. 제한 환경 Safe save 오류·초기 parse 오류·포커스 실패1/263·타입 경계 SCRIPT ERROR6개는 원본 보존했다. **종료0이나 failures0만으로 PASS로 처리하지 않는다.**
- doctor/check PASS. gdtoolkit GDScript57개 포맷·lint 정상. 최종 문서/23개 경로·UTF-8/LF·상대 링크·출처 blob·미수정 모델/DATA 대조는 `.local/validation/DEV-026/final-audit.json`을 따른다. SHA-256 정본은 결과 JSON이며 마지막 LF 정리는 전후 바이트 해시를 별도 기록한다.

현재 로컬 변경은 **23개 파일**이다. 최대24개를 유지하는 검사기1개 재지정 승인을 받으면 기존 단언을 보존한 전환기 정렬과 해당 회귀를 마무리할 수 있다. 이는 현재 정확한 후보 경로에 없는 파일이므로 [AGENTS.md](../../../AGENTS.md)의 “작업 티켓의 포함·제외 범위를 준수”에 따라 요청한 구체 차이다. 요청 원문/제안은 티켓 §8.1에 보존했다. 이 승인을 Commit·Push·PR 권한으로 확대하지 않는다.

## 2026-11-21 후속 — 기존 PARTIAL 작업본의 Draft PR 제출

Owner의 “개발 에이전트. 작업 내용을 PR로 만들어주세요”에 따라 [티켓 §9](DEV-026_S01_EXCEPTION_SCOPE.md)의 기존23개 파일 Commit·Push·Draft PR·필수 CI 확인을 진행한다. 현재 판정은 **PR_REVIEW_PARTIAL / TEST_PATH_REASSIGNMENT_PENDING / PRODUCT_L2_PENDING**이다. 앞 절의 Git 미승인/미실행은 로컬 검토 당시 상태로 보존한다.

제출 base `63550826af8b6ae9a46bda2e4bb826dd1ed7cd79`는 최초 시험 base 이후 기획 문서3개만 포함한다. 소스/시험16개와 기존334·322·101·460·898·158 검사·GUI21캡처의 원본 해시는 보존했다. 제출 준비에서 새 게임 실행·GUI·빌드를 반복하지 않는다. 원본은 로컬 `.local/validation/DEV-026/`, PR에는 결과 JSON/단언 요약·35개 실패 항목·해시 색인만 포함한다. 로컬 경로는 GitHub에서 제공되는 원본 다운로드 링크가 아니다.

신규334/W07 322 및 기존 공급 회귀 PASS와 기존 GUI245개 중35개 FAIL을 구분한다. CI `policy`·`department-policy`는 저장소/경로 검사이며 Godot 게임 실행을 포함하지 않는다. CI 통과로35개 실패나 Design 수용 대기를 해소하지 않는다. 검토할 잔여는 그대로이며 main 병합 승인은 별도다.

정상 훅/출처 선언·최신 main 포함/단일 부모·경로·preflight 및 원격 head CI를 제출 단계에서 확인한다. 정확한 head와 실제 검사 결과는 이 PR의 본문/Checks에 연결한다.

## 2026-11-21 후속 — 승인된 GUI 검사 경로 보완 결과

**LOCAL_REVIEW_GUI_REGRESSION_PASS / PRODUCT_L2_PENDING**. [티켓 §10](DEV-026_S01_EXCEPTION_SCOPE.md)의 재지정 승인에 따라 main 3695c1eefc76fe257c66bd9c4fbbd7d62ae1f572에서 codex/DEV-026-operations-gui-followup로 로컬 보완했다. 이전 PR #153의35개 실패는 당시 기록으로 보존한다.

원인은 검사기의 P06/P07 미귀속, 여러 실행/시각 표본의 동일 View 재사용과 shown 초기화, 실제 Session 선택 보고일/실행별 보고 key 문맥 누락이다. 제품 코드 대신 검사1개에서 독립17표본을 새 Session/View에 귀속하고 제한→복구4단계는 같은 Session/View에서 연속 대조한다. 선택일 기대값을 준비 시 고정하며 보관 JSON 복제본의 일치하는 보고/조회 key만 시험 실행에 연결한다. 금액·상태·기대값·제품 guard는 변경하지 않는다.

| 검증 | 결과 | 실행/원본 |
| --- | --- | --- |
| 수정 전 재현 | 245개 중35개 FAIL·exit1·오류0 | gui-followup-baseline |
| 수정 후 GUI 자동 | **266/266 PASS·exit0·오류0** | gui-followup-01 |
| 단언 보존 | 기존 호출식86곳·단언245개 보존,35개 모두 해소·추가21개 | assertion-preservation.json |
| DEV-026 경계 / P06·P07 공급 / W07 | **334 / 158 / 322 모두 PASS** | gui-followup-regression |
| 의도적 실패 감지 / 프로젝트 로드 | 실패1·exit1 / 로드exit0, 모두 엔진 오류0 | 같은 회귀 묶음 |
| 정책·범위·출처/링크·해시 | PASS | doctor.log·check.log·audit.json |
| 실제 GUI·자연 완주·독립 실행·빌드/export·성능 | **NOT_RUN** | 기존 GUI 원본/수용 범위 보존 |

추가21개는 다른 실행/낡은 관측 거부·표시 유지·보고 scope/day/value 오류와 복구·정상 확인 사본·모델 무효과·표본 원문 불변을 확인한다. 실제 제품 사슬 V05/U11/U17의 기존 단언도 그대로 실행했다. 이번 자동 GUI는 headless Control/신호/포커스 검사이며 실제 OS 입력/Design 심사가 아니다.

변경8개는 검사 파일·티켓·본 결과·계약/검증 계획·증거 Markdown/JSON·PROVENANCE다. 제품 소스·모델·DATA·씬·설정·공급 검사·UID는 불변이다. 정확한 경로/해시·명령·35개 전후 결과는 [증거 JSON](../evidence/DEV-026_S01_EXCEPTION_RESULTS.json)의 gui_followup을 따른다. 원본은 후속 worktree의 .local/validation/DEV-026/, 과거 로그/PNG는 기존 구현 worktree에 보존한다. 원격 업로드는 하지 않았다.

남은 사항은 Owner 로컬 검토·실제 공급 L2/독립 실행·Design 수용 및 RFC-DEV-026-01 OPEN이다. DEV-027 W04B·DI-03/E01·F08 최종 규격은 별도이며 게임/경제/세이브 명세 변경 필요 NONE. 후속 Commit·Push·PR·원격 CI·main 병합은 NOT_RUN / 별도 승인이다. 기존 CI를 이 미커밋 보완의 검사로 전용하거나 DONE을 선언하지 않는다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-026
