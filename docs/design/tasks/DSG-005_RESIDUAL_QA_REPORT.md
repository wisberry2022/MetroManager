# DSG-005 Stage 1 잔여 필수 UX 독립 QA

2026-11-07 Asia/Seoul / 관련 Issue #59, #63 / Design 검수 권고: **ACCEPTANCE_PENDING**.

## 기준·보존·실행 구분

실행 전 `git fetch origin` 성공. 최신 origin/main은 `bc495d66e99414e6e734df45de283e5d186829c5`로 기존 기준과 같았다. 기존 detached `.local/worktrees/DSG-005-pr67-20261107` 재사용. 원본 HEAD `293b5f956316f2be877e547fbfc223b9446f82bd`와 기존 Worktree를 보존했다. 실행 후 상태는 [repository-state.json](../evidence/DSG-005-residual-20261107/repository-state.json) 참조. 게임 코드·씬·규칙·명세 수정, Commit/Push/PR/Merge 및 Issue 작업은 없다.

Godot 지정 폴더의 `Godot_v4.7.2-stable_win64_console.exe`, 실제 버전 `4.7.2.stable.official.ed1daf0bf`, Windows native, D3D12 Forward+ Intel Iris Xe. QA Worktree 안에서만 `.godot` 생성. runtime/temp는 실행별 QA 로그 디렉터리에 격리했다.

이번 실행:
- G1 fixture GUI: `--path <QA> --script res://tests/game/run_w07_gui_cases.gd --log-file <실행별 로그>`; 시작 08:48경. `fixture-launch.json`, `fixture-stdout.log`, `fixture-stderr.log`.
- G2 제품 main GUI: `--path <QA> --log-file <실행별 로그>`; 시작 08:52경. `product-launch.json`, `product-stdout.log`, `product-stderr.log`. 제품 실행에는 fixture 전환 도구가 없다.
- 두 창은 제목/핸들을 구분해 native mouse/key 입력했다. 종료는 창 닫기를 사용. 비동기 launcher가 종료 코드를 보존하지 않아 GUI 종료 코드는 UNVERIFIED. 창 종료 요청 전후 프로세스 존재 여부는 패키징 검증 기록에 남긴다.

등급: **S** 코드 정적 검토 / **A** 독립 자동검사 / **G** 이번 실제 GUI / **G-prior** 동일 SHA 선행 독립 GUI / **DEV** 개발팀 선행 설명. DEV 숫자나 신호 emit은 G 증거로 승격하지 않았다.

**902개 자동 단언은 이번에 재실행하지 않았다.** 동일 SHA의 앞선 독립 W01=219/W02=309/W03=101/W07=273, 실패0·각 종료0을 `prior/automatic`에 연결한다. 의도 실패 종료1, import/main headless 종료0도 같은 선행 증거다. DSG-QA-01·02는 재검수하지 않고 `prior/gui`의 21장·보고서·로그를 연결한다. 이후 편집/조회 검증에 포함 역 선택이 쓰였어도 이미 수용한 결함의 별도 재판정은 하지 않았다.

명세 근거: 대상 SHA의 DSG-005 v0.3 REVIEW와 PM-011 v1.0 승인 Stage 계획 S1-07/08/09. 문서의 과거 W07 미구현 표시는 이번 실행 결과와 구분한다. 이번 사용자 지시가 실행 권한이며 문서의 과거 Git 제출 승인은 재사용하지 않았다.

## 14개 QA 최종 매트릭스

각 행의 SHA/엔진은 위 공통 기준을 적용한다. PASS는 기재한 범위에 한한다.

| QA ID | Stage | 최종 상태 | 실제 입력·관찰 / 증거 |
|---|---|---|---|
| T01 | S1-07 | PASS_LIMITED | G1 초기06:00/게임분360·일시정지1×·현재자금360 일치(`T-initial`). 완료 snapshot의 원자성은 A coherent/query 검사로 보강, GUI만으로 내부 원자성 주장 안 함 |
| T02 | S1-07 | PASS | G2 정지→재개→2→4→1→정지. 선택된 배속 대괄호와 진행 상태, 게임분495→499→508→527→534 변화. 최종534가 후속 캡처에도 유지(`product-*`). G1에서도360→399 후정지 유지 |
| T03 | S1-07/09 | PASS | G2 마지막 요청 `처리됨`, 효력 게임분/로그 일치. pause495/resume495/speed500/509/529/pause534; 각각 고유 command_id, 동기 완료에 pending 없음. 3×/중복 command_id/오래된 expected_plan_revision은 A 기존 W07 증거. 제품 GUI 입력 경로 없는 내부 입력은 G NOT_RUN |
| F01 | S1-08 | PASS | G1 초기 C/F/A1000000, R/K/B0, 게임통화 단위·현재 게임분 표시(`T-initial`, `X01-*`) |
| F02 | S1-05/08 | FAIL (표현 요구 일부) | G1 F02 C20/R20/F0/K0/A0/B3 구분 PASS. F02-K 결과 C48/R0/F48/K48/A0/B1 PASS. 그러나 발생비3/실제지급2는 현재 화면에서 볼 수 없어 해당 의미 구분은 PASS 불가. `F02-K-reserved` 및 R-01 참조 |
| F03 | S1-06/08 | PASS_LIMITED | G1 F03 day2 00:11/게임분1451/C320, 과거 day1/C20, run-…/day-1 표시(`F03-day2-top`, `F03-current-closed`). 현재와 과거 구별 PASS. 23:59→자정 이벤트는 fixture가 로드 전에 실행: 실제 GUI 시간경과 재현은 NOT_RUN, 동결/마감 모델은 A W02/W07 연결 |
| F04 | S1-08 | PASS | F04-ZERO 과거 보고 운영비/지급/운임0, F02 미마감 보고없음, F04 REPORT_READ_FAILED 별도 표시. READY0와 예측 실패도 구별. `F04-zero`, `F04-query-error`, `F02-restricted`, `P01-ready-zero`, `P01-failed` |
| M01 | S1-03/08 | PASS | G-prior 지도/목록 추가·재정렬. 이번 G 키보드 Tab으로 역S02 포커스→Enter 추가, 목록 Up/Down 조회, Tab 편집버튼→Space 재정렬/Enter 제거/Space Undo. rev1→2→3→4→5. `K-*` |
| M02 | S1-03/08 | PASS | G-prior 정상8역/9번째 추가 invalid, 이번 G P01 제거후5역 안내·Undo수정, EXTERNAL 후보 클릭 accepted=false OUTSIDE_JURISDICTION/계획rev0 유지·사유 텍스트. 모델중복 거부는 A 연결. `EXTERNAL-reason`, `P01-edit-invalidates`, prior/gui의8/9역 |
| M03 | S1-08 | PASS | G-prior 잠금 조회·편집금지/제거/Undo. 이번 G 키보드 재정렬·제거·Undo 정상. 이력없음/예외적 Undo 실패는 A/S 범위, 모든 실패유형 실조작을 주장하지 않음 |
| M04 | S1-08 | PASS_LIMITED | G-prior 완전겹침에서 후보S01로 대체 조작 PASS. 이번 G 번호·ID·흰색 포커스 테두리/선택행·텍스트 사유 판독 가능. 전체 색각/스크린리더/제품 최소 화면규격 검증은 NOT_RUN이며 Stage 외부 규격 미승인 |
| P01 | S1-04/08 | PASS | G1 READY0/미계산/실패/이전 비교값 구별. P01 제거시 입력7→8/계획6→7로 미계산, 이전7 비교용; Undo후 유효6역·입력9/계획8 재계산 READY. 정상수요 M02 재계산 요청/탑승/완료4860·예상운임486000·운영비108000/기간[360,1800)·5km/9게임분/생성360/실적아님. `P01-*`, `M02-positive-prediction` |
| P02 | S1-04/08 | PASS_LIMITED | G1 P02 입력8/계획7 계산중·이전7 비교용. 늦은응답 버튼 클릭 W07_LATE_RESPONSE accepted=false, 화면8/7 유지. **늦은 실패 응답**는 GUI 경로없음(NOT_RUN), 기존 A에 명시적 old fail 실행이 발견되지 않아 UNVERIFIED. R-02 참조 |
| X01 | S1-08/09 | PASS_LIMITED | G1 paused360, S01 초기추가 후rev1/C1000000 고정 상태에서 지도→후보→지도 조회 및 스크롤/화면 새 관찰. focus1→1·command_dispatched=false 세번, 자금/시각/예측입력2 불변. duplicate command_id는 A snapshot 비교. 직접 RNG 상태 전후 실행 증거는 없음(UNVERIFIED); 정적/모델 관찰을 RNG 실행검증으로 대체 안 함 |

## A — 제품 시간 제어 세부

제품 main은 실행 즉시 시간이 진행하므로 초기 캡처 시점이06:00이 아니라06:57이었다. 사용자 입력까지의 경과를 초기화 오류로 분류하지 않았다. 처음 small-window pause는08:15/495에서 완료. 이후 1/2/4/1배속 각각 실제 입력, 마지막 요청 처리됨/효력분이 GUI와 stdout에 나타났다. 최종08:54/534 정지 후 후속 캡처도534였다. 배속 비율의 정밀 시간측정은 도구 왕복지연이 있어 GUI에서 주장하지 않고 A의 5초→12×speed 단언으로 연결한다.

최초 제품 좌표 입력 두 번은 대상 창/가림 상태 때문에 도구가 거부했다. 최신 AX+Raise로 복구하고 작은 창에서 정지한 뒤 최대화했다. 거부된 입력은 성공 명령으로 기록하지 않았다. `input-supplement.txt`에 보충했다.

기존 W07 `_test_time_and_commands`: invalid_speed_atomic, duplicate_result/state, stale_meaning/keeps_plan, query_no_effect, same_observation. 속도3/내부명령 입력은 UI에 노출하지 않았다. A의 정확한 명령·종료·시각은 prior/automatic/commands.jsonl, W07 결과는 w07.log.

## B — 자금·보고 세부 및 L2 불일치 R-01

**R-01 / QA-F02 / S1-05·08 / 표현 요구 불일치, 경제 계산 결함은 확인되지 않음.**

재현: picker QA-F02-K 선택 → 전체 화면 아래로 스크롤. 기대: 예약 보호 결과와 발생비3/실제지급2/미지급1의 의미를 구별할 UI 증거. 실제: C48/F48/K48/A0/B1은 정확하지만 현재 운영비·지급 내역은 없고 `확정 보고 없음(미마감)`만 있다. 현재 자금 라벨과 과거 보고 라벨을 구분해도 이 fixture의 발생비/지급 각각은 확인할 수 없다. 정적 `_render_funds`도 현재6개 잔액과 과거 보고의 운영비/지급만 렌더링한다.

A/DEV 원장 검증은 계산 보호/비용 지급 분리를 보강할 뿐 현재 GUI 표시 PASS로 대체하지 않는다. 사용자 지시의 필수 정보 누락 원칙에 따라 F02 전체를 PASS로 처리하지 않는다. 제품용 디버그 UI/새 기능은 추가하지 않았다.

필요 L2: DEV+Design이 승인된 S01 최소 표현에서 이 요구를 충족할 표시/증거 공급을 정하고 재검수하거나, HQ·Owner가 현재6개 자금+과거보고 표시로 Stage1을 수용하고 이 상세 의미 검수를 후속으로 이월한다는 명시적 결정을 해야 한다. QA가 임의로 필수 조건을 삭제하지 않는다.

F03 fixture는 미구현 영업 사건을 테스트 데이터로만 사용한다. 창 상단에 `DEV-015 검증 전용 · 제품 데이터 아님`, 화면 하단에 실제 계약·시공·영업 기능 없음이 표시된다. 실제 영업 구현 완료로 간주하지 않는다.

## C/D — 추가 증거 한계 R-02/R-03

**R-02 / P02 / 늦은 실패 응답 실행 증거 부족.** GUI 버튼은 complete(old revision)만 제공한다. W03은 late complete 거부 및 현재rev8 fail을 검사하지만 oldrev7 fail은 명시적 실행 단언이 없다. PredictionState.fail의 revision mismatch guard는 S 증거다. 따라서 late fail GUI NOT_RUN, A UNVERIFIED. DEV에 기존 실행 근거 보완 또는 승인된 자동검사 범위 보완을 L2 요청한다. 새 테스트/fixture는 이번 QA에서 작성하지 않았다.

**R-03 / X01 / RNG 내부 불변성 실행 증거 한계.** 기존 A는 snapshot/plan/ledger 변화를 비교하고 S는 조회 함수에 난수 진행이 없음을 보이지만, 직접 RNG 상태를 전후 비교한 근거는 찾지 못했다. GUI에서 시간/계획/자금 불변은 PASS. RNG는 UNVERIFIED이며 모델팀 증거 또는 실제 RNG 비사용 범위 확인이 필요하다. 신규 게임 규칙 결함으로 단정하지 않는다.

P02의 계산중은 의도적으로 begin()을 호출하는 검증 fixture이며 제품의 동기 시간 명령에 인위적 pending을 추가한 것이 아니다. 유효하지 않은5역에서 READY를 강제하지 않았다. READY 재계산은 Undo로6역 복구 또는 정상 M02에서만 했다.

## E — 경계 및 키보드

8/9역·겹침 목록 경로는 동일 SHA의 직전 독립 G-prior를 재사용했다. 이번 새 G는 외부관할 클릭 거부와 키보드를 보완했다. 따라서 재사용한 항목을 이번 실행했다고 쓰지 않는다.

키보드 실제 순서: M01 지도S01 마우스로 초기 focus/추가 → Tab/Enter로S02 추가 → Tab23회로계획목록 → Up/Down 정보선택 → Tab으로위로 버튼 → Space재정렬 → Tab2회 제거버튼 → Enter제거 → Tab Undo버튼 → Space복구. 목록·마커 번호와 선택 일치, 흰 테두리가 포커스 위치를 보여준다. 이 키들은 포커스된 기본 컨트롤의 조작이며 전역 단축키로 확정하지 않는다. Tab횟수는 이 fixture/레이아웃에서만 유효하다. 화면리더 접근성은 NOT_RUN.

제거 후 정보 선택 라벨이 방금 제거한 S02 정보를 계속 가리키는 장면은 관찰됐다. 후보 역 자체는 존재하므로 이를 삭제된 역 데이터/노선 오류라고 단정하지 않는다. 제거후 선택 UX 의도는 Design 확인 권고(비차단 관찰), 자동 신규결함 승격 안 함.

## 최종 판정·미실행·제출 경계

**ACCEPTANCE_PENDING.** 필수 표현/증거의 R-01·02·03를 해소하거나 필요한 필수 이월에 대한 HQ·Owner 명시적 결정을 받아야 한다. 주요 제어·예측·자금 상태·키보드 동작의 개별 PASS를 Stage 전체 승인으로 확대하지 않는다. 기존 DSG-QA-01·02 수용은 유지된다.

빌드/export, 성능/FPS, 고충실도 아트, 외부사용자 연구, 실제 계약/시공/영업은 이번 NOT_RUN/Stage 비범위다. 승인되지 않은 해상도/폰트/FPS 수치를 새 합격 조건으로 추가하지 않았다. 원격 policy/department-policy의 현재 CI 상태는 이번 NOT_RUN이며 HQ가 기존 제출 증거와 연결해 S1-09를 종합 판단해야 한다.

산출물은 이 보고서·HQ 인수 권고·실제 입력·캡처·실행 로그·동일 SHA 선행 증거와 SHA256SUMS. 이미지의 실제 형식/디코딩과 ZIP 내 무결성은 validation.json 및 ZIP 체크섬 참조. 로컬 제출이며 GitHub에 등록하지 않았다. 공식 Stage 최종 승인 권한은 HQ/Owner에 있다.

제출 증거: [증거 목차 및 로컬 별칭 안내](../evidence/DSG-005-residual-20261107/README.md). 원래 실행의 캐시·절대 경로·진단 스크립트는 공개 제출에서 제외했다.
