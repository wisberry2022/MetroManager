# DEV-024 — VS-01 로컬 구현·검증 결과

- Development / AGT-DEV-0004 / 2026-11-15 (Asia/Seoul).
- 상태: **LOCAL_RESULT_ACCEPTED / SUBMISSION_APPROVED / INDEPENDENT_DESIGN_PENDING**.
- §1~5는 준비, §6~9는 로컬 구현·검토 이력이다. 이번 Owner 결과 승인·제출 권한은 **§10**에 추가했다.
- 기준 main/HEAD: `0a76a2e924ec0b661e3cdbd858ed6bfd665f3dc9`.
- 브랜치: `codex/DEV-024-vs01-integration-evidence`.
- [작업 티켓·Owner 지시](DEV-024_VS01_INTEGRATION_EVIDENCE.md).

## 1. 검토 결과

DEV-024는 기존 하위 GUI 재검수가 아니라 **정상 독립 초기 상태에서 표준 VS-01을 한 실제 제품 경로로 완주하고 최종 영향 회귀를 연결하는 작업**으로 준비했다. 기존 DEV-02324조건과 Q03~05·W05/Q12 수용은 유지한다. 현재 자연 전체 완주·신규 게임 검증은 NOT_RUN이며 실행 결과나 완료를 선포하지 않는다.

최신 [#80 Design 정본](https://github.com/wisberry2022/MetroManager/issues/80#issuecomment-6888452975), [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6888459436), [PM-018 S2 표](../../hq/STAGE2_ACCEPTANCE_MATRIX.md)·[PM-014](../../hq/PM-014_STAGE2_VS01_EXECUTION_PLAN.md)·[PM-015](../../hq/GUI_REVIEW_PROTOCOL.md)를 대조했다. DEV-023은 별도 Owner 결정으로 DONE/#79 CLOSED이며 #131/#132 main 반영을 확인했다. HQ의 과거 댓글0·미병합·담당 미확인 문구는 당시 이력으로 구분했다.

최종 원격 재확인에서 [HQ의 #78 종료 기록](https://github.com/wisberry2022/MetroManager/issues/78)(2026-11-15T03:24:43Z 갱신)도 확인했다. **DEV-022 역시 Owner 결정으로 OWNER_ACCEPTED / DONE·#78 CLOSED/completed**다. Issue만 갱신됐고 main SHA는 동일하다. 기존2664단언/PR #123 근거를 유지하며 DEV-024 자연 완주·최종 회귀와 HQ/Owner 최종 인수로 남는 후속 범위를 계획에 반영했다. #78 종료는 DEV-024 실행/Git 권한 부여가 아니다.

현재 준비 담당은 승계된 AGT-DEV-0004이며 Owner의 이번 직접 지시를 연결했다. 새로운 DEV-024 구현/검증·Git 권한은 승인 대기다. DEV-026 구현·제품 검증 HOLD를 유지한다.

## 2. 로컬 산출물4개

| 파일 | 검토 내용 |
| --- | --- |
| [착수 범위/승인안](DEV-024_VS01_INTEGRATION_EVIDENCE.md) | Owner 원문·담당·포함/제외·후속 로컬 실행 최대8경로·제품 결함 환류 |
| [실행 계획](../gate3/DEV-024_VS01_EXECUTION_PLAN.md) | Design 입력6묶음, 고정 시험본/정상 프로필, 실제 버튼·대기·ID/시각, 관측/종료 패킷 |
| [검증 계획](../gate3/DEV-024_VS01_VALIDATION_PLAN.md) | 기존 수용과 S2-01~11 잔여, 회귀·자동/로드/GUI/독립 심사 구분·재사용 |
| 본 결과서 | 조사/정적검증·한계·다음 승인 범위 |

신규 Markdown4개만 작성했다. 제품·테스트/fixture·프로젝트 설정·정책/CI·기존 DEV 증거·타 부서 파일 변경 없음. 루트 main과 기존 DEV-023 worktree를 보존했다.

## 3. 구현 전에 확인한 사실과 제안

1. GUI 시험 SHA `bf99dd11f3d8cd4d6dc07e38de164cd0b27f8dba` 이후 현재 main은 문서13개(Planning3·Design2·HQ5·DEV3)만 변경됐다. 제품/데이터/씬/설정/테스트 차이가 없어 기존 수용을 유지한다. 실행 환경 동일성은 앞으로 실제 기록으로 확인한다.
2. 정상 `scripts/main.gd`는 DATA→초기 회사→Session→운행 UI를 생성한다. B01 고정 노선의 정상 버튼 경로가 공급돼 있다. 소스 조사이며 실제 부팅/완주 PASS는 아니다.
3. 기존 DEV-023 GUI runner는 개통/보고를 모델로 미리 준비하거나 소비 fixture를 사용한다. 기존 화면 수용은 유효하지만 자연 초기 전체 완주로 승격할 수 없다.
4. 제품 로그는 초기화·요청·화면/보고/조회 정보를 제공한다. 실제 입력과 전체 원장/도착/보고 연속 색인을 보완할 최소 TEST_ONLY 관측 호스트를 제안했다. 정상 main·제품 시간/버튼을 그대로 쓰며 상태 주입·직접 명령·시간 점프는 금지한다. 기존 로그/수집으로 충분하면 신규 helper를 생략한다.
5. 첫 유효 보고는 실제 service_minutes>0·completed>0·운임 일치를 요구한다. 조회 성공과 다음 응찰/수주는 별개다. 실제 조작 시각에 따라 수익·완료 수가 달라져 과거 fixture 수치를 합격 값으로 고정하지 않는다.

실행은 B01→표준 공사→시범60/안전60→개통→실제 영업→첫 유효 보고→다음 공고 조회의 한 경로다. 동일 증거를 S2-08/09/10에 공동 사용하며 최종 W01~03/W07·Stage2 자동 회귀, 독립 실행/Design 심사, HQ/Owner 최종 인수는 각각 구분한다.

## 4. 이번 준비 검증

아래는 이번 문서 준비에서 실제 수행한 정적 검사다. 게임 실행 검증과 구별한다.

| 확인 | 결과/증거 |
| --- | --- |
| 원격 main·#80/#81 최신 회신·HQ 상태 | 기준 SHA·Design6묶음·PM-018 DONE/후속 잔여 확인. 원격 게시/상태 변경 없음 |
| 기존 수용 시험본→main diff | 문서13개만 변경, 제품/게임 테스트/설정 차이0 |
| doctor | 기존 DEV-023 고정 Python으로 PASS. 로컬 hooks/tooling 확인이며 원격 보호/Owner 승인 인증 아님 |
| policy check | **PASS / exit0**, worktree files655 / GDScript48, formatter 변경0·linter 정상. `.local/validation/DEV-024-preparation/policy.log` |
| 문서·범위 감사 | **PASS / exit0**. Markdown4개 UTF-8/LF·해시, 상대 링크29개, S2 11행·Design 입력6묶음·V01~V05·제안8경로, 기존 tracked/staged 변경0. `.local/validation/DEV-024-preparation/audit.json` |
| Git 상태/공용 작업 보존 | `git diff --check` PASS. 새4문서만 untracked. 루트 main `293b5f956316f2be877e547fbfc223b9446f82bd`·기존 DEV-023 브랜치 `03b11bfe6bfd6fbcaf469544337e6f3cd266518c` 모두 clean·변경 없음 |

실행한 명령/출력과 파일 해시는 로컬 `.local/validation/DEV-024-preparation/`에 보관한다. 실제 Python은 `../DEV-023-operations-finance-ui/.venv/Scripts/python.exe`이며 이 worktree에서 `tools/policy.py doctor`, `tools/policy.py check`, `.local/validation/DEV-024-preparation/audit.py`를 실행했다. 문서 정적 검사·정책 check를 게임 테스트로 세지 않는다. 초기 감사에서 실행계획의 HOLD 명시 누락을 발견해 보완하고 재검사 PASS를 확인했다. 초기 소스 탐색의 잘못된 경로/PowerShell glob 오류는 올바른 실제 경로 재조회로 해소했으며 게임 검증 실행 실패와 혼동하지 않는다.

**게임 자동검사 / Godot 프로젝트 로드 / 실제 GUI·플레이 / 독립 GUI·Design 새 심사 / Windows 빌드·export·FPS: NOT_RUN.** 새 관측기/fixture 구현, 원본 ZIP 신규 수신·재해시, Commit·Push·PR·main 병합, 신규 CI/preflight·Issue 댓글/종료도 NOT_RUN이다.

## 5. 미해결·보존·다음 승인 범위

자연 VS-01 완주 증거, 최종 후보 회귀/로드/자체 GUI, 관측 도구 사전 고정/검증, 독립 실행 주체·결과 및 Design 심사, 제출 시 필수 CI·HQ 통합·Owner Stage 인수가 남아 있다. 제품 경로가 구현·수용돼 있다는 사실과 전체 실행 증거 미확보를 구별한다.

기존 A01-Q12 상위 PARTIAL, 물리 DPI/초기 환경 원인·과거 도구 바이트·Q12 ERROR2→7 인계 정정 완료 NOT_VERIFIED, 최초 콘솔/Q12 R02 NOT_CAPTURED·과거 중단/비정상 종료는 그대로다. 관련 실제 신뢰성 영향이 없는 기록 잔여를 전체 실행 차단으로 확장하지 않는다. Track B/F-08 및 DEV-026 HOLD는 별도다.

다음 검토 대상은 티켓 §4의 **최대8경로에 한정한 로컬 관측 보완·자동검증·프로젝트 로드·DEV 자체 실제 GUI·독립 인계 자료 준비와 결과 정리**다. 유효 권한을 가진 별도 실행자의 독립 결과/Design 판정은 따로 기록한다. Commit·Push·PR·main 병합·외부 게시·릴리스는 별도 승인이다. 이는 [AGENTS.md](../../../AGENTS.md)의 작업 범위/개별 실행·Git 승인 분리와 Owner의 이번 준비 지시에 따른 경계이며 이미 받은 승인을 다시 요구하는 것이 아니다.

**현재 게임 명세 변경 필요 없음.** 실제 제품 결함이 확인되면 원 담당 티켓·재현/영향/필요 경로를 제시하고, 승인 의미 변경/부서 경계/불가능 명세만 RFC로 처리한다. 본 결과는 로컬 계획 검수 요청이며 DEV-024 DONE·Stage 인수가 아니다.

## 6. 승인 후 구현 결과와 정확한8경로

2026-11-15 Owner가 승인한 최대8경로 안에서 구현·검증했다. 승인 원문과 허용/제외 동작은 [티켓 §1.1](DEV-024_VS01_INTEGRATION_EVIDENCE.md)에 있다. 정상 main 관측기를 추가해 실제 입력·상태·원장·보고·캡처를 하나의 run으로 연결했다. 게임 명령/시각/상태 주입이나 fixture로 경로를 단축하지 않았다.

| 변경 파일 | 실제 변경 효과 |
| --- | --- |
| [작업 티켓](DEV-024_VS01_INTEGRATION_EVIDENCE.md) | Owner 로컬 승인·현재 권한·8경로 결과 연결 |
| [실행·인계 계획](../gate3/DEV-024_VS01_EXECUTION_PLAN.md) | 준비 이력 보존, 실제 V01~V05·입력6묶음·독립 인계 잔여 |
| [검증 계획](../gate3/DEV-024_VS01_VALIDATION_PLAN.md) | 준비 이력 보존, 신규 회귀·자체 GUI와 S2-01~11 대응 |
| 본 결과서 | 실제 검증·실패/환경 probe·로컬 검토 요청 |
| [run_vs01_tests.gd](../../../tests/game/run_vs01_tests.gd) | 정상 제품 호스트·읽기 관측·입력/원장 증분·캡처·자체검사/exit1 감지 |
| [run_vs01_tests.gd.uid](../../../tests/game/run_vs01_tests.gd.uid) | Godot 생성 UID |
| [검증 JSON](../gate3/DEV-024_VS01_VALIDATION.json) | 실행18개와 로그/소스·캡처 해시, 실제 ID/값·판정·NOT_RUN |
| [출처 JSON](DEV-024_PROVENANCE.json) | 기준 base·나머지7개 add 경로의 Git blob. REPORT_ONLY/신원·승인 인증 아님 |

제품 scripts/scenes/assets/project.godot·정책/CI·타 부서·기존 DEV-023 출처/수용 기록은 변경하지 않았다. run별 launcher·감사 도구·소스 사본과 화면 원본은 gitignored `.local/` 제한 보관이다. 로드가 새로 생성한 문서 이미지 `.import`151개는 본 작업 생성 여부·경로·해시를 확인하고 `.local/validation/DEV-024-execution/generated-imports/`에 보존한 뒤 작업 트리에서 제거했다.

## 7. 실제 검증 결과

아래는 동일한 최종 제품·관측 소스의 신규 실행이다. 원래 준비 검사나 과거 DEV 증거를 재계상하지 않는다. 실제 명령은 검증 계획 §3.2와 검증 JSON의 각 `runs[].command`에 있다. 각 자동 실행의 로그·소스 사본·시작/종료·exit를 보존했다.

| 분류 | 실제 결과 |
| --- | --- |
| W01 / W02 / W03 / W07 | 219 / 309 / 101 / 322 단언 PASS |
| W04A / W05 / W06 | 204 / 191 / 179 단언 PASS |
| 입찰 UI / 공사 UI / 운영 UI | 460 / 898 / 158 단언 PASS |
| 운영 GUI 소비 자동검사 | 202 단언 PASS. headless 자동이며 실제 GUI와 별개 |
| 새 관측기 정상 자체검사 | 48 단언 PASS. 정상 초기화·읽기 무효과·입력 직렬화·순서/출력·덮어쓰기 거부 |
| 정상 자동 합계 | **3291개 / 실패0 / exit0**, 기존 게임3243+관측기48 |
| 의도적 실패 경로 | 49개 중 예상 실패1·exit1 감지 PASS. 정상3291에서 제외 |
| 최종 프로젝트 로드 | `DEV024-PROJECT_LOAD-20261115T040152`, headless editor exit0·ERROR/SCRIPT ERROR0·실행 중 소스 변경0 |
| DEV 자체 실제 GUI | `DEV024-GUI-20261115T035321`, 정상 초기 T360→최종6701, 실제 입력 자연 완주·exit0·오류0, 1018.89초 |
| GUI 원본 감사 | 입력70·조작36·상태971·캡처24·원장14142·trace44387 연결, **23245개 대조/실패0**. 게임 단언에 합산하지 않음 |

첫 유효 Day4는 T5760 마감(관측5764), 서비스439분·완료1969·운임196900·운영비/지급43900이다. 표준 공사 T2042→4922(2880분/600000), 시범5095→5155·안전5196→5256·개통5321에서 같은 사업/공사 source를 유지했다. Day4 마감 자금 C1353000/R200000/F1153000/K0/B0와 원장이 일치했다. 첫 보고 표시 키 `run--9223371984979622399/day-4`와 T6400 QUERY의 보고 키가 일치한다. 부호가 포함된 실제 키를 임의 정정하지 않았다.

**조회 후 화면 경로:** QUERY accepted 후 기존 P05 인계 화면이 열렸고, 실제 `공고 상세로`→`목록으로`를 추가 조작해 P01을 확인했다. 단일 클릭으로 P01에 직행한 것으로 기록하지 않는다. 반환 B01 AWARDED/B02 CLOSED·응찰 불가를 그대로 확인했으며 새 회차·두 번째 수주를 증명하지 않는다. 이 동작의 Design 수용은 PENDING이다.

원본 위치는 공용 저장소 루트 `.local/g24/<run-id>/`(본 worktree의 `../../g24/<run-id>/`)다. 정상 GUI의 파일별 해시·24캡처 색인은 검증 JSON에 있다. 도구 입력 기록과 제품 수신 시각의70개 대응은 물리 입력 주체 인증이 아니다. 실제 화면·명령 효력·원장/보고를 함께 대조했다. 고정 보고 Day4와 이후 현재 자금/Day5를 구별했다.

최종 문서/범위 검사는 `.venv/Scripts/python.exe tools/policy.py doctor`, `tools/policy.py check`, `git diff --check` 및 `.local/validation/DEV-024-execution/final_audit.py`로 수행하고 해당 디렉터리에 로그를 둔다. 대상은 UTF-8/LF·상대 링크·정확한8경로·출처 blob·원본 해시·제품 동일성·공용/기존 worktree 보존이다. 최종 판정은 아래 §9에 기록한다.

## 8. 실패·부분 실행·원본 이력 보존

1. `DEV024-OBSERVER-20261115T034351`: Window에 `auto_accept_quit`를 설정해 SCRIPT ERROR가 발생했다. 실패 프로세스가 남아 있는 동안 보조 코드를 수정한 사실과 변경 경로를 기록하고, 해당 프로세스만 종료해 exit4294967295·원래 소스/로그를 보존했다. 실행 중 source 고정 조건을 충족하지 못한 실패본으로 분류하며 정상 증거에 합산하지 않는다. SceneTree 속성으로 수정한 최종본은 새 run 자체48검사·의도적 exit1·최종 로드·GUI에서 검증했다. API 근거: [Godot SceneTree 문서](https://docs.godotengine.org/en/stable/classes/class_scenetree.html).
2. `DEV024-GUI-20261115T035048`: DEV 최초 Computer Use 조작 전에 탐색 입력10개를 관측했다. 주체는 **NOT_VERIFIED**이며 Owner 입력으로 추정하지 않는다. 실제 입찰/공사/영업은 진행하지 않은 환경 probe로 보존하고 정상 종료했다. process exit0은 자연 완주 PASS가 아니다. 별도 빈 프로필에서 새 run `035321`로 시작해 정본 증거를 확보했다.
3. 첫 project load `DEV024-PROJECT_LOAD-20261115T034251`는 exit0/오류0이나 새 UID 생성 및 관측기 수정 전 시점이다. 최종 로드 `040152`와 구분한다. 이후 성공 실행은 원래 실패/부분 기록을 삭제하거나 소급 PASS로 바꾸지 않는다.
4. 최종 정적 감사 최초 실행에서 관측기/생성 JSON2개의 CRLF3건을 발견했다. 원래 실패 감사도 보존하고 LF로 정리했다. 관측기 시험 원본 SHA-256 `be5d52f6d5196deed95c50e1b5e0123490c577f6599dec8cf3f00244ee1cf7be`와 LF 후보 `fa20d87f05d3726e9ca583a92e113977b9060932438bb27aec6b5eda0ecefd81`는 개행 정규화 후 완전히 같다. 원래 실행의 소스 사본/해시를 보존하며 후보 바이트로 소급 실행했다고 표시하지 않는다. 제품/코드 내용 변경이 없어 게임 재실행은 NOT_RUN, 정책/문서·원본 감사만 재검사했다.

## 9. 로컬 검토 요청과 잔여

최종 doctor·policy check·`git diff --check`·문서/범위/원본 감사는 **PASS / exit0**다. policy는 files659/GDScript49, formatter 변경0·linter 정상이다. 정확한 신규8경로·tracked/staged 변경0, 출처7개 blob·원본 해시·상대 링크·UTF-8/LF와 기존 두 worktree clean 보존을 확인했다. 로그는 `.local/validation/DEV-024-execution/final-checks.json`, `final-doctor.log`, `final-policy.log`, `final-audit.json`에 있다. 최종 원격 main API 재확인도 기준 `0a76a2e924ec0b661e3cdbd858ed6bfd665f3dc9`와 같았다. protected=true·필수 context policy/department-policy 확인은 새 PR의 CI 실행이나 병합 권한을 뜻하지 않는다.

승인된8경로의 로컬 구현·검증 결과를 Owner 검토 대상으로 제출한다. **독립 GUI 실행/Design 새 심사 NOT_RUN**, 실제 원본 전달·독립 실행 주체/권한·결과 및 P05→P01 실제 경로 심사가 후속이다. 자체 완주가 해당 단계를 대신하지 않는다. 기존 Design24조건·Q03~05·W05/Q12 수용과 A01-Q12 상위 PARTIAL·과거 NOT_VERIFIED/NOT_CAPTURED는 보존한다.

게임 명세 변경 필요 없음. 제품 경로를 막는 새 결함/원장·ID 연속성 누락은 이번 자체 실행에서 발견하지 않았다. HQ 통합·Owner Stage 인수와 DEV-024 DONE/Issue 종료는 아직 별도다. **DEV-026 구현·제품 검증 HOLD**를 유지한다.

Commit·Push·PR·main 병합·신규 CI/preflight·외부 게시·빌드/export/FPS는 **NOT_RUN**이다. Owner가 이 대화에서 별도 승인을 명시한 단계이므로 이번에는 로컬 결과만 검토 요청한다.

## 10. Owner 로컬 결과 승인·Commit/Push/PR 제출 승인 — 2026-11-15

Owner의 본 개발 대화 원문:

> DEV-024 로컬 구현·검증 결과를 승인합니다. 승인된 8개 파일을 codex/DEV-024-vs01-integration-evidence 브랜치에 Commit·Push하고 PR을 생성한 뒤 필수 CI 결과까지 확인해주세요. 독립 실행·Design 심사 대기는 유지하고, main 병합은 별도 승인하겠습니다. DEV-026 보류는 유지합니다.

대상은 `wisberry2022/MetroManager` / DEV-024 / AGT-DEV-0004 / `codex/DEV-024-vs01-integration-evidence` / §6의8파일이다. 로컬 결과 승인에 따라 정상 훅을 통한 Commit·일반 Push·base=main PR 생성·커밋 후 preflight·해당 제출의 필수 `policy`와 `department-policy` 확인을 수행한다. 효력은 이번8파일 제출·CI 확인 완료 또는 Owner 철회까지다. main 병합·자동 병합·강제 Push·브랜치 삭제·Issue 게시/종료·릴리스/배포는 포함하지 않는다.

제출 직전 승인된8파일을 기존 최종 감사의 SHA-256과 대조해 전부 바이트 일치를 확인하고 로컬 `.local/validation/DEV-024-submission/approved/`에 사본을 보존했다. 이번에는 티켓·본 결과서에 승인 기록을 후속 추가하고 출처 manifest의 해당 blob을 갱신한다. 관측기/UID·검증 JSON3개는 승인 바이트를 유지하며 실행/검증 계획의 내용과 기존 준비/실행 본문도 보존한다.

staging 후 신규 파일 전체에 대한 `git diff --cached --check`에서 Markdown4개의 마지막 빈 줄을 발견해 제거했다. 이전 untracked 상태의 `git diff --check`는 신규 파일 전체를 검사하지 않았으므로 해당 PASS만으로 이 항목을 확인했다고 하지 않는다. 최종 개행1개를 유지하는 서식 보완이며 관측기·검증 JSON·게임 동작 변경은 없다. 최초 출력과 정리 후 검사를 별도 보존한다.

fetch와 원격 main API에서 기준 `0a76a2e924ec0b661e3cdbd858ed6bfd665f3dc9` 동일성, 원격 동일 작업 브랜치 미생성을 확인했다. 제품·데이터·설정·테스트 내용/실행 환경 변경이 없어 기존 자동3291·프로젝트 로드·DEV 자체 자연 GUI 결과를 재사용한다. **이번 제출 단계 신규 게임 자동검사·프로젝트 로드·GUI·빌드/export/FPS는 NOT_RUN**이다. 문서/출처·정책·정상 훅·preflight와 새 PR CI는 제출 단계의 별도 검사다.

커밋 전에는 아직 head/PR/CI 결과가 없으므로 PASS를 미리 선언하지 않는다. 실제 제출 SHA·정상 훅/preflight·원격 필수 CI의 최종 결과는 이번 PR과 Owner 완료 보고에 연결하며, 로컬 원본은 `.local/validation/DEV-024-submission/`에 보관한다. §1~9 및 검증 JSON의 기존 NOT_RUN은 해당 로컬 결과 시점의 이력이다.

**독립 실행·Design 심사 대기와 DEV-026 구현·제품 검증 HOLD를 유지한다.** 이번 로컬 결과 승인·PR/CI 성공을 독립 수용, DEV-024 DONE, HQ/Owner Stage 인수 또는 main 병합 승인으로 확대하지 않는다.
