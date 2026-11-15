# DEV-024 — VS-01 로컬 구현·검증 결과

- Development / AGT-DEV-0004 / 2026-11-15 (Asia/Seoul).
- 현재: **OWNER_ACCEPTED / SUBMISSION_APPROVED / DESIGN_GUI_ACCEPTED**.
- 수용·DOC-01·HQ 인계·로컬 문서 검증은 **§15**, 최신 Owner 제출 승인은 **§16**. §1~15의 실행·실패·당시 상태는 이력으로 보존한다.
- 후속 기준 main/HEAD: `324faf9b7d81540240217d2757f26de6f07460ba`. 최초 기준: `0a76a2e924ec0b661e3cdbd858ed6bfd665f3dc9`.
- 이번 브랜치: `codex/DEV-024-design-acceptance-handoff`. 최초 브랜치: `codex/DEV-024-vs01-integration-evidence`.
- [작업 티켓·Owner 지시 §11](DEV-024_VS01_INTEGRATION_EVIDENCE.md).

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

## 11. 독립 Design 판정 수신 — 2026-11-15

[#80 정본](https://github.com/wisberry2022/MetroManager/issues/80#issuecomment-6889738120)과 [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6889744888)을 확인했다. **V01~V04·V05-1/2 한정 PASS 수용, V05-3 승인 L2 불충족/보완 필요, DEV-024 독립 GUI 전체 PARTIAL**이다. 기존 자체 GUI의 “추가 탐색 후 도달/Design PENDING” 기록은 보존하고 이번 판정을 후속 연결한다.

독립 시험본/현재 main은 `0865e5a2cdf168dac14167922c9e59b16796fa81`이며 PR #134는 원격에서 병합된 상태다. 원본 `DEV-024-VS01-INDEPENDENT-GUI-20261115-1115A.zip`(37,649,968 bytes / SHA-256 `d34c0ca6098a9e5b6bbe39028ae25e4a9afb2417a4f780ec0b34d6e52634452e`), run `DEV024-IG-20261115-1115A`의 수치와 출처 대조는 Design 보고를 인용한다. DEV가 이번에 원본 ZIP을 새로 열거나 재해시하지 않았다.

독립 실행의 첫 Day4 보고는 서비스169분·완료754·운임75400·운영비16900이며 T6327 조회 accepted다. 기존 DEV 자체439분·완료1969건과 다른 정상 실행이다. 둘을 같은 run/자동 단언으로 합산하지 않는다. Design은 manifest816/816·소스661/661·실제 종료0/엔진 오류0을 대조했다. PROV-01 사전 입력 wrapper 사본/해시 NOT_CAPTURED 및 신원·환경·프로세스 미확인은 원래 상태로 유지한다.

## 12. OBS-V05-01 원인·후속 로컬 검토 요청

정적 조사에서 `_query_business`는 accepted 후 보고 복귀 문맥을 저장하고 `_open_tenders`를 호출하지만 `TenderView.page`를 P01로 지정하지 않는다. 이 때문에 이전 P05가 남는다. 기존 자동 U14도 panel visible만 검사하여 실제 P01 페이지 여부를 확인하지 못했다. 새 게임 규칙/데이터 문제로 확대하지 않는다.

수정안은 **성공한 보고 조회 분기에만 `tender_view.page = "P01"`1줄 추가**, 기존 GUI 검사에 실제 P05 선행 문맥·P01 목록/컨트롤·보고 복귀·읽기 무효과·실패 비이동을 보완하는 것이다. 공통 `_open_tenders`나 일반 P05 왕복/선택을 일괄 초기화하지 않는다. 검토 가능한 코드 위치·후속8경로·자동/로드·실GUI F1~3은 [실행 계획 §7](../gate3/DEV-024_VS01_EXECUTION_PLAN.md)에 정리했다.

이번 Owner 지시로 최신 main 기반 `codex/DEV-024-v05-entry-fix`에서 티켓·본 결과서·실행/검증 계획·검증 JSON **기존5파일에 수신/검토 기록만 로컬 반영**했다. 기존 JSON 필드와 준비/실행 본문을 보존했다. 제품·테스트/관측기·타 부서·정책/CI는 변경하지 않았다. 이전 provenance는 PR #134 당시 기록이며 이번 준비의 새 manifest로 위장하지 않는다.

**필요한 추가 확인은 제품 Host와 기존 GUI 검사2경로를 포함하는8경로 재지정 및 해당 로컬 구현·검증이다.** 원래 Owner 승인은 티켓 §3의 제품 scripts 제외·§4의 정확한8경로에 한정됐으므로 같은 개수라는 이유로 경로를 교체하지 않는다. 이미 승인된 Design L2를 다시 승인받을 필요는 없으며, 실제 추가 개발 경로만 확인 대상으로 남긴다. 수용된 V01~V04/V05-1/2·기존24조건과 독립 원본 전체 완주를 재실행하지 않는다.

게임 명세 변경 필요 없음. DEV 자체 보완 뒤 별도 독립 증거/Design 명시 수용이 필요하며 현재 전체 PARTIAL·A01-Q12 상위 PARTIAL을 유지한다. DEV-024 DONE/Issue 종료/HQ·Owner Stage 인수는 별도다. **DEV-026 구현·제품 검증 HOLD**. 이번 새 제품 구현·게임 자동검사·프로젝트 로드·실GUI/빌드·독립 보완·Commit/Push/PR/CI·main 병합·외부 회신 게시는 NOT_RUN이다.

## 13. OBS-V05-01 로컬 구현·검증 결과 — Owner 검토 요청

### 13.1 승인·변경 범위

Owner는 본 개발 대화의 실행 계획 §7.2 경로 재지정 질문에 다음과 같이 승인했다.

> 8개 경로 재지정·로컬 수정 및 검증 승인

기준 **0865e5a2cdf168dac14167922c9e59b16796fa81**, 브랜치 **codex/DEV-024-v05-entry-fix**, 담당 AGT-DEV-0004다. §12의 승인 대기는 해소됐고 아래 정확한8경로 안에서 작업했다. 새 Commit·Push·PR·main 병합은 승인/실행하지 않았다.

| 파일 | 최종 변경 |
| --- | --- |
| `scripts/ui/stage1_view.gd` | accepted 보고 조회 분기에서 `tender_view.page = "P01"`1줄 추가 |
| `tests/game/run_operations_gui_cases.gd` | 실제 P05 선행·즉시 P01·거부/숨은 화면·보고 복귀·일반 P05 왕복 회귀43개 추가; 기존 입력/캡처에 page·focus·scroll·보고/권위 해시와 성공/복귀 캡처 연결 |
| `docs/engineering/tasks/DEV-024_VS01_INTEGRATION_EVIDENCE.md` | 독립 판정 수신·Owner 경로 승인·이번 로컬 결과 |
| `docs/engineering/gate3/DEV-024_VS01_EXECUTION_PLAN.md` | 원인/수정안·승인8경로·실제 실행·독립 보완 인계 |
| `docs/engineering/gate3/DEV-024_VS01_VALIDATION_PLAN.md` | 기존 수용/실패와 새 자체 보완 검사 구분 |
| `docs/engineering/tasks/DEV-024_RESULT.md` | 본 검수 요청·명령/증거·잔여 |
| `docs/engineering/gate3/DEV-024_VS01_VALIDATION.json` | 원래 필드 보존 + Design 수신/승인 후 보완 별도 키 |
| `docs/engineering/tasks/DEV-024_PROVENANCE.json` | 이번 base 기준7개 변경 artifact의 old/new blob; 자기 파일 제외 |

일반 `_open_tenders`와 TenderView 선택/이력·Session·게임 모델·원장·명세·디자인/정책/CI·기존 자연 관측기/UID는 바꾸지 않았다. 제품 수정은 기존 승인 L2 복원이며 **게임 명세 변경 필요 없음**이다.

### 13.2 자동·프로젝트 로드·정적 검증

모든 명령은 이 worktree에서 Godot `4.7.2.stable.official.ed1daf0bf`로 실행했다. 테스트 공통 앞부분은 `Godot_v4.7.2-stable_win64_console.exe --headless --path . --script`다. 최종 검사는 작업 폴더 안의 실행별 빈 APPDATA/LOCALAPPDATA/TEMP/TMP를 사용했다.

| 스크립트/명령 뒤 인수 | 결과 |
| --- | --- |
| `tests/game/run_operations_gui_cases.gd -- --auto` | **245개 PASS**, 실패0/exit0 |
| `tests/game/run_operations_ui_tests.gd -- --evidence` | **158개 PASS**, 실패0/exit0 |
| `tests/game/run_tender_ui_tests.gd` | **460개 PASS**, 실패0/exit0 |
| `tests/game/run_w07_tests.gd` | **322개 PASS**, 실패0/exit0 |
| `--headless --editor --path . --quit` | 프로젝트 로드 exit0/엔진 오류0 |
| `.venv/Scripts/python.exe tools/policy.py doctor` / `check` | PASS; gdformat/gdlint 포함 |
| `git diff --check` / 로컬 범위·이력·출처 감사 | 별도 후보 검증; 원격 CI/신원 인증 아님 |

총 **1185개/실패0**, 최종5실행 모두 엔진/스크립트 오류0이다. 기존 자동3291·과거 DEV023 수치와 합산하지 않는다. 수정 전 같은 보강 회귀는245개 중 **5실패/exit1**로 P05 page·목록/detail·back/공사 표시 결함을 재현했다. 기존 통합202개 대비43개를 추가했고 입력 wrapper/GUI 감사11개는 게임 단언에 합산하지 않는다. 최종 제품 SHA-256은 `d65d8f6e722a4ad880969fb9cb3841e6a220c1b5883d79aaf499c6024d065370`, 검사 SHA-256은 `1d5f62974469846c7807dd9450b600bc711010cad134a3fda27c99f2c3736e14`이며 최종 자동/GUI가 같은 바이트를 사용했다.

### 13.3 DEV 자체 실제 GUI F1~3

정본 run **DEV024-V05-DEV-20261115 / DEV_SELF_GUI / MODEL_CHAIN_SETUP**. 기존 fixture가 첫 유효 보고까지 준비한 다음 실제 Computer Use 입력을 사용했다. 이 fixture의 Day4 서비스955분/완료4291은 준비 상태이며 기존 자연 DEV439분/1969 및 독립169분/754와 별개다.

- **F1 PASS:** P05 인계·공사→P06→P07, 첫 보고 `run--9223371980483328539/day-4` 표시/확인 후 Enter 조회 accepted. 즉시 P01 목록·B01 선택·보이는 refresh 포커스. 상세/목록 추가 탐색0.
- **F2 PASS:** P01에서 원래 P07로 복귀하여 Day4/key/본문/확인값·query 포커스·비영점 scroll **605**를 보존했다.
- **F3 PASS:** 전·조회 직후·복귀 및 관측19개 모두 정지 **T5760**, 권위 상태 SHA-256 `c32d96d9d2d05f417150fa1f4a997cd95b85e8c89098f403bc1048ace89efb80` 동일. FX.effects는 clock/model/원장/명령·결과/마감·당일보고/계획·예측을 포함한다.
- 정상 Alt+F4 **exit0/엔진·스크립트 오류0**. 종료 후 OS 스크린샷은 창 소멸로 실패했으나 게임 내부 EXIT 캡처와 실행기 exit0을 보존했다. 종료 오류나 누락을 숨기지 않는다.

D3D12 12_0 / Forward+ / Intel Iris Xe, 요청 창1100×900/엔진 viewport1152×942. 새 실행은 런타임 관련107파일·launcher/input wrapper를 실행 전에 사본/해시로 고정하고 종료 시 동일성을 확인했다. 엔진/GUI 형제 바이너리 사전 해시와 실제 launcher27464→console33224→game9512 프로세스 연결을 기록했다. 관측은 캡처19개·게임 입력18레코드·도구 조작17회/정상 후관측16회이며 마지막 종료 후관측은 창 소멸로 미포착이다. 입력 수는 Alt 조합 등 이벤트 단위와 조작 단위가 달라 일대일 건수로 주장하지 않는다. 물리 조작자/등록 신원·DPI 인증을 뜻하지 않으며 과거 PROV-01을 소급 해소하지 않는다.

### 13.4 로컬 원본·초기 실패·남은 검수

원본 경로는 **본 worktree**의 `.local/validation/DEV-024-v05-review/`다. `run_checks.py`, 실행별 log/JSON, 수정 전 실패 단언, `gui-run/manifest-before.json`·source/·입력 wrapper/launcher·console·operator-actions·캡처·process·result·gui-audit를 보존한다. 소스 고정·F1~3·종료 감사 **11개/실패0**는 게임 자동1185개와 별도다.

초기 실행기는 엔진 경로의 부모 단계 오류로 엔진 시작 전 FileNotFoundError가 났고 수정했다. 최초 기본 프로필 editor는 exit0이지만 사용자 폴더 접근/설정 저장 오류가 있어 PASS에서 제외했다. 수정 전 회귀의 user:// 로그 오류도 별도 보존하며 최종 분리 프로필 실행은 오류0이다. 새 .venv 의존성 설치는 최초 DNS 제한 후 허용된 네트워크 설치로 성공했다. 프로세스 조회도 최초 CIM 제한 뒤 읽기 전용 권한으로 성공했다. 임시 콘솔 표시 스크립트의 JSON 접두부 길이 오류는 원본 변경 없이 정정했다. editor가 생성한 미추적 .import151개는 출처/범위 확인 후 무시 폴더로 보관해 제출 범위에서 제거했다.

로컬 후보 감사는 정확한8경로, 기존 본문/JSON 필드 보존, 원래 관측기/UID 및 타 부서·제품 모델 무변경, provenance7행의 base old/new blob 일치를 확인한다. 첫 감사에서 문서 생성기의 Windows 기본 CRLF를 검출해6개 문서/JSON을 LF로 정리하고 출처를 재계산했다. 최초 실패 보고서를 보존하며 제품·검사 소스와 검증 바이트는 변경하지 않았다. 기존 PR #134 provenance는 Git 이력에 남고 새 manifest는 이번 후보만 식별한다. 커밋/서버의 agent provenance·preflight·필수 CI는 **NOT_RUN**이며 로컬 후보 일치를 원격 PASS로 표시하지 않는다.

**Owner 로컬 검토 요청:** 보완 구현·자동1185·자체 GUI F1~3·위8파일을 검토해 주시기 바란다. 독립 보완 실행 **NOT_RUN**, Design 재수용 **PENDING**, 전체 독립 GUI/A01-Q12 **PARTIAL** 유지. 이전 V01~V04/V05-1/2 수용과 과거 PROV-01/환경·신원/Q12 잔여는 보존한다. 별도 독립 증거와 Design 명시 수용 후 해당 단계 종료를 판단한다. 빌드/export/FPS·전체 자연 재실행·Commit/Push/PR/CI/main 병합·Issue 게시/종료는 미실행이며 **DEV-026 HOLD**를 유지한다.

## 14. Owner 승인 후 Commit·Push·PR 제출 — 2026-11-15

Owner의 본 개발 대화 원문:

> DEV-024 V05-3 로컬 수정·검증 결과를 승인합니다. 승인된 8개 파일을 codex/DEV-024-v05-entry-fix 브랜치에 Commit·Push하고 PR을 생성한 뒤 필수 CI 결과까지 확인해주세요. 독립 보완 실행·Design 재수용 대기는 유지하고, main 병합은 별도 승인하겠습니다. DEV-026 보류는 유지합니다.

대상은 wisberry2022/MetroManager / DEV-024 / AGT-DEV-0004 / codex/DEV-024-v05-entry-fix / §13.1의8파일이다. 이번 제출·필수 CI 확인 완료 또는 Owner 철회까지 정상 훅 Commit·일반 Push·base=main PR 생성·필수 policy/department-policy 확인만 허용한다. main 병합·자동 병합·force push·브랜치 삭제·Issue 게시/종료·릴리스/배포 권한은 포함하지 않는다.

제출 전8파일의 SHA-256을 승인된 candidate-audit와 대조해 모두 일치했고, 원본은 .local/validation/DEV-024-v05-submission/approved/에 보관했다. 티켓/본 결과서의 승인 후속 기록과 provenance만 갱신한다. 제품·검사·실행/검증 계획·검증 JSON5파일은 승인 바이트를 유지하며 §1~13의 검증/실패/미실행 기록은 당시 이력으로 보존한다.

fetch/API 기준 main은 0865e5a2cdf168dac14167922c9e59b16796fa81로 로컬 검증 base와 같다. 제품/검사·환경 변경이 없어 승인된 자동1185·프로젝트 로드·DEV 자체 GUI F1~3를 재사용한다. 이번 제출 단계의 신규 게임 자동검사·프로젝트 로드·GUI·빌드/export/FPS는 NOT_RUN이며, 정상 훅·policy·출처·커밋 후 preflight 및 새 PR CI를 별도로 확인한다.

실제 commit/PR SHA와 CI 결과는 생성 후 해당 PR/Owner 완료 보고에 기록하고 로컬 제출 로그를 위 디렉터리에 보존한다. 아직 생성 전인 결과를 PASS로 미리 선언하지 않는다. **독립 보완 실행·Design 재수용 대기, 전체 독립 GUI/A01-Q12 PARTIAL, DEV-026 HOLD**를 유지하며 이 제출을 DONE/Stage 인수·main 병합 승인으로 바꾸지 않는다.

## 15. Design 수용 후 기록·DOC-01 정정·HQ 인계 로컬 검토안

### 15.1 수신한 판정과 종료 범위

[Design #80 정본](https://github.com/wisberry2022/MetroManager/issues/80#issuecomment-6890415230)은 2026-11-15 15:33:14 KST, [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6890437629)은 15:35:30 KST 등록이다. Design Track A / AGT-DSG-0002가 F1~F3 PASS와 OBS-V05-01/V05-3 보완을 수용했다. 기존 V01~V04·V05-1/2와 연결해 **합의된 DEV-024·VS-01 독립 GUI 검수 단계가 종료**됐으며 추가 필수 GUI·제품 보완·증거 재공급 요청은 없다.

이전 §12~14 및 JSON의 독립 GUI PARTIAL·Design PENDING은 해당 시점의 기록이다. 이번 판정은 그 GUI 잔여 조건을 해소하지만 **A01-Q12 상위 PARTIAL**, 전체 DEV-024 DONE·Issue 종료·Stage 인수를 대신하지 않는다. 이전 수용을 재개방하지 않는다.

### 15.2 병합·CI와 증거 계보

[PR #135](https://github.com/wisberry2022/MetroManager/pull/135)는 head `f508d88281dc84b1a9d7e4399f5eba06a89d3ce6`에서 2026-11-15 15:01:42 KST에 병합돼 main `324faf9b7d81540240217d2757f26de6f07460ba`가 됐다. 원격 API와 fetch로 확인한 사실이며 이번 문서 작업에서 병합하지 않았다. PR head와 병합 main의 tree diff는 없다.

| 확인 구분 | 결과/범위 |
| --- | --- |
| PR #135 필수 department-policy | [SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/43683416561/job/132718749518), 위 head 기준 |
| PR #135 필수 policy | [SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/43683416572/job/132718747793), 위 head 기준 |
| PR #135 agent provenance | [report-only SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/43683416579/job/132718749511), DECLARATION_CONSISTENT. 신원/실행 권한 인증 아님 |
| 원래 독립 자연 실행 | `DEV024-IG-20261115-1115A` / `0865e5a2cdf168dac14167922c9e59b16796fa81`. V01~V04·V05-1/2 기존 수용 유지 |
| DEV 자체 보완 | §13의 자동1185·프로젝트 로드·`DEV024-V05-DEV-20261115` 자체 GUI. 독립 실행과 별도 |
| 이번 독립 보완 | `DEV024-V05-IG-20261115-1115B` / 위 병합 main. MODEL_CHAIN_SETUP 뒤 실제 입력의 국소 재검수 |
| Design 심사 | 제출 원본/소스·로그·화면 대조. Design이 새 게임/GUI를 실행한 것은 아님 |
| 이번 DEV 문서 작업 | 원격 수신·원본 메타데이터/바이트 읽기·문서 정적 검증. 새 게임/GUI 실행 아님 |

실행자 표기 `LOCAL-CODEX-INDEPENDENT-V05-1115B`는 등록 Agent-ID나 물리 신원 인증이 아니다. 제출자 오프라인 감사130개·기존 DEV 게임 자동1185개·Design 증거 심사·이번 DOC-01 원본 읽기 검사를 합산하지 않는다.

### 15.3 독립 보완 수용 근거 — Design 판정 인용

정본 ZIP PNG 접두부는 `captures/DEV023_GUI_first_report_1794723092-651_`다. 기존 DEV023 파일명은 유지한다. A=36 조회 직전, B=38 QUERY_RESULT, C=40 TENDER_EXIT이며 전환37·39도 보존됐다.

| 항목 | 수용한 실제 관측 |
| --- | --- |
| F1 | 재개 F12/PNG28 이후 실제 P05 인계30→공사31→P06 32→P07/첫 보고33~36. Enter1회, 표시/QUERY key 일치·accepted, B 즉시 page=P01·목록·보이는 Tender_refresh 포커스, P05 전용 컨트롤 없음·추가 탐색0 |
| F2 | 복귀 클릭1회로 원래 P07. A/C day/key/객체·본문·확인값 동일, P07_query2 포커스·보고 scroll **605→605**, 수동 복원0. B 목록 scroll124는 별도이며 목록0 조건을 신설하지 않음 |
| F3 | A/B/C displayed/backing minute5760, 원장·clock/model·명령/결과·계약·보고/계획 효과 해시 동일 |

보고 key는 `run--9223371980500105755/day-4`, 효과 해시는 `c32d96d9d2d05f417150fa1f4a997cd95b85e8c89098f403bc1048ace89efb80`다. 앞선 V05-2의 P05→P02→P01 최종 도달 한정 PASS와 이번 성공 직후 P01 수용은 서로 다른 시험본 관측이다.

Design은 실행 전 소스125/125와 main blob, ZIP manifest221/221을 대조했다. tracked661개의 전후 무변경은 실행자 보고이며 Design이661개 전체 원문을 새 대조했다는 뜻은 아니다. 원본 stdout 캡처40·입력38·QUERY2 중 **재개 후 알려진 QUERY(stdout102행)와 복귀**만 F1~F3 수용에 사용했다. 중단 중 raw 입력7~25·캡처8~27·첫 QUERY(stdout71행)의 주체/개입은 NOT_VERIFIED로 제외하며 Owner나 실행자에게 귀속하지 않는다.

실제 process exit0·stdout/stderr 엔진/스크립트 오류0. **EXIT-labelled 내부 PNG/기록 NOT_CAPTURED, runner requested_exit NOT_PROVIDED**를 유지한다. C는 마지막 안정 복귀 화면이며 종료 PNG가 아니다. DEV 자체 run의 종료 기록을 독립 보완의 누락에 전용하지 않는다.

### 15.4 DOC-01 정정과 원본 보존

대상은 검수 패킷 README §2다. [별도 정정문](../gate3/DEV-024_DOC-01_PACKET_README_CORRECTION.md)에 원문 위치·실측표·대체 문단·원본 SHA를 준비했다. `실제 PNG40개1100×900` 서술을 **01~11·28~40:1100×900 24개 / 12~27:2880×1659 16개**로 정정한다. 재개28~40은 모두1100×900이며 F1~F3 수용에 영향이 없다. 크기 변화 주체는 NOT_VERIFIED다.

외부 `v05r.zip`(13,831,128 bytes, SHA-256 `4f282f8561517b58b7dadb3b59b1e9bf7fc0a8bc925ce198cbc3da77512d4610`)과 내부 `DEV-024-V05-INDEPENDENT-RETEST-20261115-1115B.zip`(6,937,676 bytes, SHA-256 `708c4f8df69109f0ec6c52d08eda367388d82d6b577237fa32340ac73fe1f12d`)을 읽기 전용 대조했다. ZIP CRC0, 외부/내부 동일 바이트, manifest221파일 해시/크기, 추출 패킷222파일, PNG40개 IHDR/기존 색인·환경·viewport가 일치했다.

원본 ZIP·추출 README·로그·PNG를 포함한 로컬230파일의 작업 전후 경로·크기·SHA-256이 동일하다. 새 ZIP을 만들지 않았으며 원본 README의 당시 PENDING/잘못된 서술도 그대로 보존하고 후속 기록으로 연결한다. 원본 보관·작성 담당에게 정정문 연결을 요청할 문안은 [HQ 인계안](../gate3/DEV-024_DESIGN_ACCEPTANCE_HQ_HANDOFF.md)에 준비했다. 전달/게시·원본 담당의 반영 완료는 아직 주장하지 않는다.

### 15.5 이번8파일·검증 및 로컬 검토 요청

변경8경로는 [티켓 §11](DEV-024_VS01_INTEGRATION_EVIDENCE.md)에 있다. 제품·테스트·타 부서 산출물·기존 worktree는 변경하지 않았다. 기존4개 Markdown의 §1 이후 본문과 검증 JSON의 기존 모든 키/값을 보존하고 후속 절/키만 추가했다. 헤더는 최신 절을 가리킨다. provenance는 이번 base/7산출물 old·new blob으로 갱신하며 기존 PR #135 선언은 Git 이력에 남는다.

아래는 이번 문서 작업의 검증이다. Python은 기존 보완 worktree의 고정 venv `../DEV-024-v05-entry-fix/.venv/Scripts/python.exe`를 사용했다.

| 명령/검증 | 결과·증거 |
| --- | --- |
| 위 Python `tools/policy.py doctor` | PASS, 작업 환경/훅·고정 도구 확인 |
| 위 Python `tools/policy.py check` | PASS, 저장소 정적 정책 검사. 게임 단언 아님 |
| `git diff --check` | PASS |
| 위 Python `.local/validation/DEV-024-design-acceptance/inspect_packet.py` | PASS, 원본 ZIP/PNG·DOC-01 읽기 감사, `packet-read-audit.json` |
| 위 Python `.local/validation/DEV-024-design-acceptance/audit_candidate.py` | PASS,8경로·기존 본문/JSON·원본230파일·문서 링크·UTF-8/LF·provenance7행 대조, `candidate-audit.json` |
| 원격 #80/#81·PR #135·main/CI 조회 | 수신 기록 `remote-receipt.json`; 위 PR의 기존 CI이며 새 문서 CI 아님 |
| 새 게임 자동검사 / 프로젝트 로드 / 실제 플레이·GUI / 빌드·export·FPS | **NOT_RUN / NOT_RUN / NOT_RUN / NOT_RUN**. 문서 변경에 대한 불필요한 재실행 없음 |
| 새 문서 Commit·Push·PR·preflight·서버 provenance/CI·main 병합·외부 게시 | **NOT_RUN**, 이번 권한은 로컬 검토까지 |

위 로컬 증거는 이 worktree의 `.local/validation/DEV-024-design-acceptance/`에 보관하며 Owner 제한 원본 패킷을 공개 Git에 추가하지 않는다. 후보 provenance 대조는 서버의 출처 검증이나 신원 인증이 아니다.

**검토 요청:** 수용 후속 기록·DOC-01 정정문·HQ 복사 전달안을 로컬 검토해 주시기 바란다. 새 게임 규칙/Design 명세 변경은 필요 없다. 남은 것은 문서 검토·정정문 전달 연결과 HQ의 최종 회귀/CI·부서 수용·잔여 취합, Owner의 전체 DONE/Issue 종료/Stage 인수 판단이다. 이번 문서 작업으로 이를 완료 처리하지 않는다.

A01-Q12 상위 PARTIAL, 이번 중단 구간 주체/전체 console→GUI 연결·물리 신원·DPI/OS 배율/native 크기 NOT_VERIFIED, 이번 EXIT PNG·기존1115A PROV-01·최초 콘솔/Q12 R02 종료 NOT_CAPTURED, 과거 환경/보조 도구 바이트·Q12 ERROR2→7 인계 정정 연결 NOT_VERIFIED 및 실패/중단·UNKNOWN/NOT_RUN을 유지한다. 기존24조건/Q03~05/W05/Q12 한정 수용도 유지한다. 새 전체 자연 완주·전체 회귀·모든 키/배속/창 조합·빠른 별도 E2E·두 번째 수주/Track B는 NOT_RUN. **DEV-026 구현·제품 검증 HOLD**.

## 16. Owner 승인 후 후속 문서 Commit·Push·PR 제출 — 2026-11-15

Owner의 본 개발 대화 원문:

> DEV-024 로컬 후속 기록 8개 파일을 승인합니다. codex/DEV-024-design-acceptance-handoff 브랜치에 Commit·Push하고 PR을 생성한 뒤 필수 CI 결과까지 확인해주세요. main 병합은 별도 승인하겠습니다. DEV-026 구현·검증 보류는 유지합니다.

[티켓 §12](DEV-024_VS01_INTEGRATION_EVIDENCE.md)의 이번 승인에 따라 동일 브랜치에서 §15의 문서8파일을 제출한다. 이전 PR #135 제품 보완 제출 권한을 재사용하지 않는다. main 병합·자동 병합·force push·브랜치 삭제·Issue 게시/종료·릴리스는 제외하며 **DEV-026 구현·제품 검증 HOLD**를 유지한다.

제출 준비 직전8파일의 SHA-256을 승인 후보 감사와 대조해 모두 일치했고, 승인본과 manifest를 `.local/validation/DEV-024-design-acceptance-submission/approved/` 및 `approved-manifest.json`에 보관했다. 이번에는 티켓/본 결과서의 승인 기록과 provenance만 갱신하며 다른5파일은 승인 바이트를 유지한다. §1~15의 과거 검증/미제출/PENDING과 원본 ZIP/README·로그/PNG는 보존한다.

fetch 및 원격 API로 확인한 main은 `324faf9b7d81540240217d2757f26de6f07460ba`로 승인 후보 base와 같다. 실제 main 보호는 strict=true·필수 policy/department-policy·관리자 적용·선형 이력·force push/삭제 금지, squash-only·자동 병합 비활성 상태다. GitHub 연결의 보호 조회는 권한 부족403이었고 로컬 Git 인증의 읽기 전용 API로 별도 확인했다. 자격증명은 출력/저장하지 않았다.

정상 훅 실행을 위해 이 worktree에 별도 `.venv`를 만들고 `tools/requirements-dev.txt`의 고정 도구를 설치했다. 설치된 훅/doctor·policy·diff·8경로/승인 바이트/기존 기록/원본 보존을 확인한 뒤 명시 경로만 stage하고 커밋 후 preflight·REPORT_ONLY 출처 검사를 실행한다. 신규 게임 자동검사·Godot 프로젝트 로드·GUI/플레이·Windows 빌드/export/FPS는 문서 제출에 대해 **NOT_RUN**이며 기존 검증을 새 실행으로 표시하지 않는다.

실제 제출 SHA·PR·preflight·필수 CI 결과는 생성 후 PR/Owner 완료 보고와 위 로컬 제출 폴더에 기록한다. 아직 생성 전인 서버 결과를 PASS로 선언하지 않는다. Design 수용/합의된 GUI 단계 종료·DOC-01 정정문·HQ 인계안을 공유하는 제출이며 원본 보관 담당/HQ의 후속 반영·A01-Q12 상위 PARTIAL·미확인/미포착·Owner의 전체 DONE/Issue 종료/Stage 인수 판단은 별도로 유지한다.
