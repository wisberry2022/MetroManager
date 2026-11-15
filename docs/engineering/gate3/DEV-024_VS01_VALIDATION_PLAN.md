# DEV-024 — VS-01 검증·기존 수용·잔여 대응표

- AGT-DEV-0004 / 2026-11-15 / **DEV_LOCAL_VALIDATED / INDEPENDENT_DESIGN_PENDING**.
- 기준: `0a76a2e924ec0b661e3cdbd858ed6bfd665f3dc9`.
- [작업·권한](../tasks/DEV-024_VS01_INTEGRATION_EVIDENCE.md) / [실행 패킷](DEV-024_VS01_EXECUTION_PLAN.md) / [준비 결과](../tasks/DEV-024_RESULT.md).
- §1~6은 준비 당시 기록이다. 승인 후 자동검사·로드·DEV 자체 GUI 결과는 §7에 추가했으며 독립 실행/Design 새 심사·빌드는 NOT_RUN이다.

## 1. 이미 수용한 증거와 자연 완주를 구별

[PM-018 S2 표](../../hq/STAGE2_ACCEPTANCE_MATRIX.md), [PM-015](../../hq/GUI_REVIEW_PROTOCOL.md), [Design #80](https://github.com/wisberry2022/MetroManager/issues/80#issuecomment-6888452975)을 적용한다.

| 증거 | 유지하는 현재 판정 | 확대하지 않는 범위 |
| --- | --- | --- |
| DEV-022 / PR #123 | 모델 공급·자동검증·main 반영. 정상2664단언(신규179+기존2485), 원래 해시·CI. [최신 HQ #78 기록](https://github.com/wisberry2022/MetroManager/issues/78)의 별도 Owner 결정으로 OWNER_ACCEPTED / DONE·CLOSED/completed | 실제 화면 전체/자연 VS-01·Stage DONE. 전체2664를 단일 최종 head의 신규 실행으로 소급하지 않음 |
| DEV-023 / PR #127·#128 | L2-01~04 및 L2-A/B/C 수용, Session·P06/P07·S01 실제 제품 연결 | DEV-024 자연 초기 상태의 전체 연속 완주 |
| DEV-023 자동/자체 GUI | P1 3041, L2 보완55, P3 AUTO_UI202 및 W07 322/입찰460/공사898을 각 실행·소스 해시에 연결 | 1882 등을 하나의 최종 head 신규 실행으로 합산하거나 모델 준비→GUI를 자연 전체 완주로 표시하지 않음 |
| Design 기존21+보완3=24조건 | 합의된 독립 GUI 단계 종료. P07 실제 stale 응답·525자 한국어 사유/작은 창·P05 scroll234 왕복 포함 | U01~U20 모든 조합/모든 키·배속 PASS 아님 |
| QA-001/002·Q03~05 | 기존 PASS/종료, Q05 12조합·정지/재개 | 새로운 12조합 재실행 의무 아님 |
| W05·OBS-01·A02-11·Q12 | 한정 PASS·Q12 28조건·원래 P05 인계/복귀 종료 가능 판단 유지 | 상위 A01-Q12 PASS나 전체 Stage DONE 아님 |
| Owner DEV-023 결정 / PM-018 | **OWNER_ACCEPTED / DONE**, #79 CLOSED/completed | Design 판정만으로 DONE을 만든 것이 아님. DEV-024/#80·#81·전체 Stage 인수는 별도 |

원본 위치와 해시는 [DEV-023 검증 JSON](DEV-023_UI_VALIDATION.json), [결과서 §10~11](../tasks/DEV-023_RESULT.md), [Design 최종 정본](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6887989037)을 재사용한다. IG1115A·SUP1115B ZIP의 크기/해시·manifest 대조는 Design 보고의 인용이다. 이번에 Owner 제한 ZIP을 새로 수신·재해시하지 않았으며 새 DEV 검증으로 계상하지 않는다.

## 2. S2-01~11: 기존 증거와 이번 잔여

| 기준 | 기존 수용/재사용 | DEV-024에서 남은 검증 |
| --- | --- | --- |
| S2-01 기반·시간·원장 | Stage1 DONE, DEV-022/023 기존 자동·원래 실행 해시 | 최종 후보 W01~03/W07 주요 회귀 및 공통 시간/원장/보고 영향. 후보 고정·실행별 소스/로그 |
| S2-02 공고·자격 | Q03 B-X·UNKNOWN_TENDER/효과0·BUSY/B 경계 및 QA 수용. 표시 fixture 한계 보존 | V01 실제 초기 B01 진입을 연속 경로에 연결. 새 결함/실제 영향 없으면 기존 조건 재검수 없음 |
| S2-03 입찰·계약 | Q04 경계·Q05 단회성·점수/동점/중복 | V01 실제 응찰→권위 계약/정부 지급·ID/효력시각·원장 |
| S2-04 표준 공사 | W05 표준2880/600000·R/K/B·반례, P05 복귀 수용 | V02 동일 사업/계약·착공→누적 기성→실제 완공·원장 연속성 |
| S2-05 시험·안전·개통 | 정상 표준/빠른 수리 합성 증거, 유효 개통 소비·개통 전/후 UI | V03 표준60/60→개통→동일 운영선 실제 영업. 빠른 별도 전체 E2E는 제외 |
| S2-06 OD·도착 운임 | W06 모델/실제 UI 최소 표현 수용 | V04 동일 실행의 service_minutes/완료통행/도착 운임·운영선 source. 대표 표현을 열차/정차 전체 증거로 확대하지 않음 |
| S2-07 정산·보고 | SEM/CLOSE·W06/P07·역순 응답 수용 | V04 실제 영업일 마감, 발생/현금/도착일·고정 보고·원장 비교 |
| S2-08 실제 GUI | 기존24 및 Q03~05·W05/Q12 유지 | V01~V05 자연 완주 관측, 별도 독립 실행/Design 심사. 같은 화면 통과는 개별 재인수 아님 |
| S2-09 다음 조회 | 모델 준비 후 보고 선택→조회→복귀 실제 GUI는 수용 완료 | V04~V05 자연 초기 상태에서 얻은 첫 유효 보고→권위 조회→P01 도달. 영업0/완료0 보고는 실패 |
| S2-10 전체 VS-01 | 하위 모델/GUI 증거 있음 | **독립 초기 전체 자연 제품 완주 NOT_RUN**. 단일 연속 입력·상태·화면·로그 필요 |
| S2-11 교차 인수 | 기존 Design/Planning·DEV-022·DEV-023 Owner DONE·필수 CI 연결 | DEV-024 최종 회귀/CI·Design 심사·필요 Planning·미해결/이월 → HQ 통합·Owner 최종 Stage 인수 |

S2-08/09/10은 같은 유효 완주 증거를 실제 관측 범위 안에서 공동 사용한다. S2-01 회귀나 S2-11 부서/Owner 결정까지 자동 PASS가 되지 않는다. HQ 표를 DEV가 직접 수정하지 않고 DEV 대응표를 인계한다.

## 3. 승인 후 실행할 검증

### 3.1 정적·정책·소스 고정

전용 Python3.12/gdtoolkit4.5.0·hook 상태를 doctor로 확인한다. 지금 준비 단계에서는 기존 DEV-023의 고정 .venv를 읽어 사용하며 환경/공용 hook 변경을 하지 않는다. 실행 단계에서는 해당 worktree 도구 환경을 확보한다.

~~~powershell
.venv/Scripts/python.exe tools/policy.py doctor
.venv/Scripts/python.exe tools/policy.py check
git diff --check
git diff --name-status bf99dd11f3d8cd4d6dc07e38de164cd0b27f8dba HEAD
~~~

변경 경로·UTF-8/LF·상대 링크·manifest·원본 해시, 제품 코드/데이터/씬 동일성과 관측기에 상태 주입/명령 대행이 없는지를 확인한다. preflight는 Commit/Push 승인 후 fetch·커밋이 존재할 때 실행하며 지금 문서 준비 검사를 Git 승인으로 간주하지 않는다.

### 3.2 게임 자동검사와 프로젝트 로드

아래 `$GodotExe`는 검증한 엔진 절대 경로다. 각 실행은 별도 run ID·원본 로그·exit·ERROR/SCRIPT ERROR·소스 해시를 남긴다. 단언 수는 실제 결과로 기록하며 과거 수를 예정 PASS로 복사하지 않는다.

~~~powershell
& $GodotExe --headless --path . --script tests/game/run_w01_tests.gd
& $GodotExe --headless --path . --script tests/game/run_w02_tests.gd
& $GodotExe --headless --path . --script tests/game/run_w03_tests.gd
& $GodotExe --headless --path . --script tests/game/run_w07_tests.gd
& $GodotExe --headless --path . --script tests/game/run_w04a_tests.gd
& $GodotExe --headless --path . --script tests/game/run_w05_tests.gd
& $GodotExe --headless --path . --script tests/game/run_w06_tests.gd
& $GodotExe --headless --path . --script tests/game/run_tender_ui_tests.gd
& $GodotExe --headless --path . --script tests/game/run_construction_ui_tests.gd
& $GodotExe --headless --path . --script tests/game/run_operations_ui_tests.gd -- --evidence
& $GodotExe --headless --path . --script tests/game/run_operations_gui_cases.gd -- --auto
& $GodotExe --headless --editor --path . --quit
~~~

| 검증 묶음 | 계획·이유 |
| --- | --- |
| W01~03/W07 | 최종 후보의 주요 회귀를 실제 실행. 정상 초기화·시간/원장/보고·network/예측·Session/UI 기반 보존을 HQ S2-01에 제출 |
| W04A/W05/W06 및 기존 UI | 실행 승인 후 위 명령으로 최초 최종 통합 후보를 한 번 대조해 계약→공사→운행·보고를 연결. 이후 제품/계약/환경 변경이 없으면 결과를 재사용하고 문서 갱신만으로 반복하지 않음 |
| 관측기 자체검사 | 구현한 경우 `run_vs01_tests.gd -- --self-test`와 `-- --verify-failure-exit` 제안. 정상 main 초기화·읽기 무효과·manifest/입력 색인·출력 실패와 의도적 exit1 감지. 실제 CLI는 구현 후 확정 |
| 프로젝트 로드 | headless editor exit0 및 SCRIPT ERROR/ERROR0 확인. 프로젝트 로드 PASS는 실제 GUI/플레이 PASS가 아님 |

과거 자동검사는 원래 SHA의 유효 증거로 유지한다. 위 신규 실행은 DEV-024 최종 통합 후보 확인으로 별도 색인하며 기존 수용 GUI24조건을 다시 돌리는 계획이 아니다. 모두 통과한 뒤 새 변경/실패/신뢰성 문제가 없다면 검사 범위를 계속 확장하지 않는다.

### 3.3 실제 GUI·독립 실행

DEV는 관측 보조의 실제 작동과 제품 경로를 자체 확인한다. DEV가 전체 경로를 자체 실행했어도 결과 유형은 DEV_SELF_GUI다. 별도 실행자의 INDEPENDENT_GUI를 대체하지 않는다. 별도 유효 독립 결과가 확보된 뒤 Design이 이를 심사하면 같은 경로의 추가 Design 재실행은 필요하지 않다.

실행 계획 V01~V05의 실제 input→command→effective state→screen→ledger/report를 연결한다. 정지/배속은 실제 제품 버튼만 사용한다. 첫 유효 report의 service_minutes>0·completed>0·fare 일치와 실제 표시 report_key에 대한 QUERY accepted 및 P01 진입을 확인한다. 고정 일일 완료 수·일일 수익을 합격 값으로 만들지 않는다.

정상 종료 exit0·오류0을 확인하되 무조건 PASS로 간주하지 않는다. timeout/강제 종료/ERROR는 원본과 영향을 남기고 증거 유효성을 별도 판정한다. 이후 정상 실행이 과거 실패를 지우지 않는다. 자연 전체 연속성을 증명할 수 없으면 PARTIAL이며 fixture/분리 실행 합계로 메우지 않는다.

## 4. 결과 패킷의 최소 항목과 판정

| 구분 | 필수 기록 |
| --- | --- |
| 실행 식별 | run ID·실행 유형·실행자·권한 근거·source SHA/추가 파일 manifest·명령·시작/종료·환경·exit |
| 입력/권위 | OS 입력 sequence·실시각/게임분, command ID/requested_at/effective_at/result revision, 프로젝트/사업/공사/운영선 source/보고 key |
| 실제 값 | 초기/계약/공사/영업 원장, R/K/B 보호, 공정·시범/안전·개통, 완료/운임/비용·고정 보고·QUERY |
| 증거 | 주요 화면·raw input/state/ledger/report/stdout/stderr 경로·SHA-256·실행 전 helper 사본/해시 |
| 판정 | V01~V05 기대/실제·PASS/PARTIAL/FAIL/NOT_RUN/NOT_VERIFIED, 기능 결함/증거 누락/기록 정정 구분, S2 행 참조 |
| 교차 인수 | Design 심사 범위·필요 Planning 회신·제출 head CI·HQ 인계·Owner 결정은 각각 별도 |

READ_ONLY 관측 결과만으로 내부 불변식을 전부 새로 증명했다고 하지 않는다. 내부 SEM/CLOSE 반례는 적절한 자동 증거로, 실제 UI 인수는 실제 입력/화면으로 연결한다. 종료 기준은 필수 완주/증거·관측 범위 차단 결함 없음·Design 명시 수용이다. 전체 DEV-024/Stage DONE이나 Issue 종료는 이 검증표 자체의 권한이 아니다.

## 5. 보존할 별도 잔여와 재개방 규칙

- **A01-Q12 상위 PARTIAL** 유지. 원래 P05 인계/복귀 필수 누락이 남았다는 의미가 아니며 VS-01을 P05 종료의 새 선행조건으로 추가하지 않는다.
- 초기 환경 원인·물리 DPI·과거 보조 도구 바이트·Q12 ERROR2→7 인계 정정 연결 완료의 NOT_VERIFIED, 최초 콘솔/Q12 R02 NOT_CAPTURED, 과거 timeout/비정상 종료·기타 UNKNOWN/NOT_RUN을 보존한다.
- DEV-022 과거 공급/회귀 해시와 비공개 원본 직접 대조의 미확인 사항은 기존 기록 범위로 남긴다. 이번에 새로 접근하지 않은 원본을 검증 완료로 바꾸지 않는다.
- 새 코드·계약·환경 변경, 실제 결함, 증거 신뢰성 문제가 확인되면 영향 행·이유·필요 재실행을 적는다. SHA 진전·문서 정정만으로 기존24조건을 재개방하지 않는다.
- 승인 의미의 실제 차이만 Planning에 질의한다. 새 규칙/범위·부서 경계는 RFC/HQ/Owner에 연결한다. 이미 수용된 L2를 반복 승인 대상으로 돌리지 않는다.
- Track B/F-08·Windows export/FPS·최종 MVP는 별도 적용 시점이다. **DEV-026 구현·제품 검증 HOLD**를 유지한다.

## 6. 원격 제출·최종 인수 단계

향후 별도 승인으로 Commit·Push·PR을 할 때 최신 base, 실제 변경8경로 이내, 제목/본문·정상 훅, 커밋 후 `.venv/Scripts/python.exe tools/policy.py preflight`와 해당 head의 **policy·department-policy**를 확인한다. 준비 기준 main branch API는 protected=true/required contexts 두 개를 반환했다. 이것이 DEV-024 Git/병합 권한 위임은 아니다.

출처 보고는 REPORT_ONLY이며 manifest의 base/경로/blob을 새 DEV-024 범위로 작성한다. 기존 DEV-023 출처 파일을 수정하거나 출처 보고를 신원/Owner 승인 인증으로 취급하지 않는다. PR/CI가 아직 없으므로 현재 신규 필수 CI는 NOT_RUN이다. HQ는 최종 S2-01~11 증거/부서 수용/미해결/이월을 통합하고 Owner가 Stage 최종 인수를 결정한다.

## 7. 승인 후 로컬 검증 후속 기록

실제 명령·시작/종료 UTC·소스/로그 SHA-256·단언·exit/오류는 [검증 JSON](DEV-024_VS01_VALIDATION.json)의 `runs`18개에 원본 이력까지 포함했다. 최종 정상 자동검사는 **3291 = 게임 회귀3243 + 새 관측기48**, 실패0이다. 의도적 실패 감지49개 중 예상 실패1/exit1과 원본 감사23245개는 정상3291에 합산하지 않는다. [결과서 §7](../tasks/DEV-024_RESULT.md)에 묶음별 수와 최종 프로젝트 로드를 연결했다.

최종 성공 run들은 동일한 고정 제품·최종 관측 소스를 사용하고 실행 중 변경0이다. 최초 editor의 UID 생성과 수정 전 실패 observer는 `runs`에서 별도로 남긴다. 자연 GUI는 **DEV024-GUI-20261115T035321 / DEV_SELF_GUI**, exit0·엔진/스크립트 오류0·한 연속 정상 초기 경로다. 자동 GUI202개는 headless 소비 검사이며 실제 GUI와 구별한다.

최종 제출 후보는 실행 뒤 CRLF→LF만 정리했다. 검증 JSON의 `source_identity.observer_delivery_eol`과 파일 감사에서 모든 유효 run의 관측 소스가 개행 정규화 후 제출 후보와 동일함을 대조했다. 원본 실행 해시는 소급 변경하지 않았고 개행만 바뀐 후보의 게임 재실행은 NOT_RUN이다. 정책·문서/원본 감사는 정리 후 다시 수행했다.

| S2 | 이번 확보한 DEV 증거와 남는 경계 |
| --- | --- |
| S2-01 | 최종 W01~03/W07 및 전체 해당 회귀 PASS; 원장/시간 연속성 원본 감사 |
| S2-02 | 기존 Q03~05 유지 + 실제 초기 B01 진입(V01) |
| S2-03 | 실제 응찰·T1800 계약/정부 단회 지급·동일 ID(V01) |
| S2-04 | 표준 공사2880/600000·기성 floor/지급·완공 및 원장 일치(V02) |
| S2-05 | 실제 시범60·안전60·개통·동일 운영 source(V03) |
| S2-06 | 서비스439분·완료1969·운임196900의 첫 유효 Day4(V04) |
| S2-07 | Day4 마감·보고·원장 일치. 공사 발생125417/현금125625는 발생일/지급일 차이로 대조(V04) |
| S2-08 | DEV 자체 실제 GUI PASS. 별도 독립 실행 NOT_RUN·Design PENDING |
| S2-09 | 첫 보고 표시→T6400 권위 QUERY accepted→P05/상세를 거쳐 P01 도달. 실제 추가 탐색 기록; Design 판단 PENDING |
| S2-10 | 정상 초기 전체 자연 경로 DEV 자체 완료. **독립 실행은 NOT_RUN**이며 대체하지 않음 |
| S2-11 | 로컬 회귀/출처/증거 공급. 제출 CI·독립 실행·Design 심사·HQ 통합·Owner 최종 인수는 별도 잔여 |

새 제품 결함/명세 변경 필요는 확인하지 않았다. 공고 조회 후 기존 페이지 보존은 실제 동작으로 기록하고 Design의 해당 경로 판단을 남긴다. 원장·계약/공사·시범/안전·보고 연속성을 깨는 미해결 사항은 이번 DEV run에서 발견하지 않았다. 과거 실패/NOT_CAPTURED/NOT_VERIFIED와 A01-Q12 상위 PARTIAL, 기존24조건 수용은 그대로 보존한다.

Windows 빌드/export/FPS, 독립 GUI, Design 새 심사, Commit·Push·PR·main 병합·신규 CI/preflight·Issue 게시는 **NOT_RUN**. DEV-026 구현·제품 검증 **HOLD**다. 이 후속 표는 HQ 표 수정이나 Owner DONE 결정을 대신하지 않는다.
