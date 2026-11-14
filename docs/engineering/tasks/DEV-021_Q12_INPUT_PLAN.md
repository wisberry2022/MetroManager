# DEV-021 Q12 검수 입력 공급 및 W05 키보드 읽기 보완 결과

담당: Development / LAPTOP / AGT-DEV-0001. 개발 검증 완료, **DESIGN_RETEST_READY** 후보 제출이다. Design 독립 재검수·Owner 수용은 별도이며 **A01-Q12 전체 PARTIAL**을 유지한다. 원격 필수 CI는 생성된 PR의 실제 head에서 별도로 확인한다.

## 승인 근거와 정확한 범위

기준 main: `273f725adba2ade4d491b6cbf94b01757be341ef`. 전용 브랜치: `codex/DEV-021-q12-input-supply`. 공유 main과 다른 작업 디렉터리의 변경은 보존했다.

- [Issue #77 실행 패킷·전체 행렬](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6870738022)
- [긴 문자열 Design L2](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6870544219)
- [키보드 읽기 추가 RFC](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6871614789)
- [키보드 읽기 Design L2 수용](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6871729584)
- 원 티켓: `docs/engineering/tasks/DEV-021_W05_CONSTRUCTION_UI.md` / Issue #77.

현재 Owner 개발 세션의 승인 원문:

> 개발 에이전트. Issue #77의 DEV-021 Q12 검수 입력 공급과 승인 패킷의 6개 경로에 대한 구현·검증·Commit·Push·PR 생성을 승인합니다. Design L2와 기존 Owner 정책을 유지하며 티켓 범위만 작업해주세요. 제품 변경이 필요한 경우 추가 범위를 먼저 보고하고, main 병합은 별도 승인하겠습니다.

추가 경로 승인 원문:

> 개발 에이전트. scripts/ui/stage1_view\.gd 추가 1개 경로의 키보드 읽기 보완과 Design L2 협의를 승인합니다. L2 회신 확인 후 기존 6개 경로와 함께 구현·검증하고 Commit·Push·PR 생성까지 진행해주세요. main 병합은 별도 승인하겠습니다.

실제 파일명에 백슬래시는 포함하지 않는다. 이후 Owner는 L2 회신 확인 및 기존 7개 경로의 구현·검증·Commit·Push·PR 계속 진행을 명시했고, 실수로 입력한 Escape 이후 GUI 재개도 지시했다. 추가 승인을 자체 문서로 만들어낸 것이 아니다.

대상 저장소는 `wisberry2022/MetroManager`, 승인 동작은 아래 7개 경로의 구현·재현/검증·Commit·일반 Push·PR 및 같은 범위 검수 보완이다. 유효 범위는 해당 작업 제출·검수 보완 종료 또는 Owner 철회까지다. main 병합·강제 Push·릴리스 권한은 없다.

| 경로 | 최종 변경 |
| --- | --- |
| `tests/game/construction_ui_fixtures.gd` | 결정적 문자 표본·연결 참조·표시 사본과 권위 반례 Session 공급 |
| `tests/game/run_construction_gui_cases.gd` | 기존 패널/제품 호스트의 TEST_ONLY 진입·명령·시간·조건·역순 수신·정상 복구 |
| `tests/game/run_construction_ui_tests.gd` | 6개 영역·표본·읽기 위치·native 소비자 제외·모델 불변성 자동검사 |
| `docs/engineering/tasks/DEV-021_Q12_INPUT_PLAN.md` | 본 승인·구현·재현·결과·미해결 기록 |
| `docs/engineering/evidence/DEV-021_Q12_INPUT_CASES.json` | 입력 원문·해시·자동 assertion·전후 모델·직접 GUI 결과와 원본 식별자 |
| `docs/engineering/tasks/DEV-021_PROVENANCE.json` | base와 본 manifest 외 6개 산출물의 Git blob 연결 |
| `scripts/ui/stage1_view.gd` | 추가 승인된 W05 키보드 읽기 및 포커스 추적 복구 |

경제·시각·명령·ID 규칙, 모델·ledger·service·scene·에셋·CI·타 부서 산출물은 변경하지 않았다. TEST_ONLY 반례를 정상 사업 경로나 새로운 정책으로 일반화하지 않는다.

## 제품 읽기 동작과 L2 반영

W05가 보이고 포커스가 W05 내부에 있을 때만 PageUp/PageDown과 Home/End, Ctrl+Home/End를 처리한다. Page 이동은 현재 viewport 높이의 80%로 앞뒤 내용을 겹쳐 읽고, 처음·끝에서는 clamp한다. 한 키 입력을 두 번 처리하지 않는다. 포커스가 HUD/S01/입찰에 있거나 OptionButton·LineEdit·TextEdit 등 native 소비자인 경우 읽기 키를 가로채지 않는다. 다른 modifier 조합은 추가하지 않았다.

읽는 동안 포커스는 원래 행동에 유지하고 자동 포커스 추적과 지연된 가시화 요청이 읽기 위치를 끌어오지 않게 했다. Tab/Shift+Tab은 소비하지 않고 기존 추적을 복구한다. 마우스 입력·재조회·resize에서도 기존 포커스/사유 시작을 다시 평가한다. 동일 주기 present는 읽기 위치를 덮지 않는다.

보조 호스트는 제품 `Stage1View.read_construction_key`를 재사용한다. 별도 축약·유리한 글꼴·새 읽기 위젯으로 테스트만 통과시키지 않았다. 제품 호스트는 실제 Stage1View/ScrollContainer/ConstructionView를 사용하며 공급 사본과 시간 진행만 TEST_ONLY로 관리한다.

## 6개 공급 영역과 실제 결과

| 영역 / 재현 ID | 입력과 기대 | 실제 결과·증거 |
| --- | --- | --- |
| 중복 / Q12-CMD-01 | 같은 command_id를 pending/완료 후 반복 | 기존 결과 재사용, 계약 1회, C1800000/R800000 유지. 자동·직접 GUI PASS |
| 조건 / Q12-REV-01 | 과거 target 조건으로 착공 요청 | STATE_CHANGED, 착공/금액 효과 0. 자동·직접 GUI PASS |
| 역순 / Q12-ORD-01 | 늦은 성공, 낡은 snapshot, 완료 후 pending | 과거 성공은 원 ID 이력에만 귀속, 낡은 두 입력 거부, 현재 권위/개통 비활성 유지. 자동·직접 GUI PASS |
| 문자열 / LTXT-G01~07 | 아래 단일 표본·복합·기본/축소·제품 호스트 | 전체 단일 자동 및 직접 GUI 행렬 PASS. 최초 실패는 별도 보존 |
| 시험 / Q12-HIS-01 | 시범→안전 결함→수리→재시험의 실제 시점 관측 | 시범 3243~3303, 안전 3304~3364, 수리 3365~3395, 재시험 3396~3456. 각 시작/완료 GUI, 완료 직전 자동 관측 PASS |
| 재원 / Q12-FIN-01~04 | 자기 R, R/A 혼합, 1원 부족, 타 사업 K 보호 | 아래 원장 비교 및 직접 GUI PASS |

시험 시점은 해당 시점에 채집한 snapshot이다. 과거 시각을 현재 UI에 재구성한 제품 이력 기능이 아니다. 재시험 통과 후 개통 허용을 관측했으며 이 사례에서 개통 명령을 실행하거나 정상 제품 전체 E2E를 주장하지 않는다.

| 수리 반례 | 수리 전 | 수리 후 / 판정 |
| --- | --- | --- |
| FIN-01 | C1080000, 자기 R80000, A1000000 | C1060000, 자기 R60000, A1000000. R만 20000 지급 |
| FIN-02 | C30000, 자기 R10000, 다른 R5000/K5000, A10000 | C10000, 자기 R0, 다른 R5000/K5000, A0. 자기 R/A 각10000 |
| FIN-03 | C29999, 자기 R10000, 다른 R5000/K5000, A9999 | REPAIR_FUNDS_INSUFFICIENT, 원장 자금·수리 절차 불변 |
| FIN-04 | C30000, 자기 R10000, 다른 R5000/K5001, A9999 | 같은 거부. 다른 사업 K를 1원 차감해 수리하지 않음 |

거부 효력분에도 기존 분 파이프라인의 0원 운영 기록은 생길 수 있다. 이를 수리 지급 부작용으로 잘못 판정했던 초기 검사 기대값을 바로잡았다. 최종 검사는 자금·수리 지급·절차와 construction_payment 유무를 구분하며 실제 ledger delta도 D2에 남긴다. 경제 규칙 수정은 없다.

## 문자열·GUI 행렬

길이는 Unicode code point 수이며 NFC 한글과 실제 LF를 사용한다. 4종 ID 각64/256자, command/result ID64/256자와 다른 END_A/B, FAILED.reason 한글256·혼합1024·LF2개 변형·공백 없는1024, 현재/과거 사유의 알려진 코드+미등록64/256 및 8개×128을 공급한다. D2에 수정 필드·원문·길이·UTF-8 바이트 수·SHA-256를 기록했다. LF는 혼합 표본의 1-based256/768번째 문자를 치환하며 전체1024자를 유지한다. 이는 제품 최대 입력 길이 규칙이 아니다.

| 직접 GUI | 기본 | 관측 축소 | 추가 조건 |
| --- | --- | --- | --- |
| G01 ID256 동시+다른 명령2건 | PASS | PASS | 끝 식별부, 최대화/복원 |
| G02 한글 FAILED256 | PASS | PASS | 현재 권위 없음과 이력 분리 |
| G03 혼합1024 및 실제 LF 변형 | PASS | PASS | 별도 변형 화면, 재조회 동일 입력 |
| G04 공백 없는1024 | PASS | PASS | 가로 이탈/겹침 없이 끝 접근 |
| G05 비활성 open+미등록256 | PASS | PASS | 사유 시작/끝, 활성 safety 접근 유지 |
| G06 현재/과거8×128 | PASS | PASS | 순서·현재/이력·다른 거부 귀속 |
| G07 G01+G06 | PASS | PASS | 끝 읽기·복귀·최대화/복원 |
| 실제 제품 호스트 G05/G07 | 각 PASS | 각 PASS | 제품 공유 읽기 제어, 모델 효과0 |

계수는 보조 호스트14 + 제품 호스트4 = **문자열 주요 조건18**, G03의 LF 변형2개 추가 관측, 권위/시점/재원 직접 조건8개다. 재확보·반복 촬영은 조건 수를 늘리지 않는다. F5는 시작 포커스를 고정하는 TEST_ONLY 준비 입력이고, 이후 실제 Tab/Shift+Tab은 기존 순서다. 합성 표시 ID로 활성 명령 성공을 요구하지 않았다. 비활성 open Enter의 명령 효과0도 확인했다.

각 장문 run의 원본 권위 조합(게임분·snapshot revision·자금·사업·실제 requests)은 하나로 유지됐다. F6 재조회는 view revision만 갱신할 수 있고, 표시용 합성 이력은 원본 requests와 분리한다. Raw 창 설정은 기본1100×900 / 기존 관측 축소 재현 인수1104×900이다. 이 이름을 새 최소 해상도나 모든 창 크기 보장으로 해석하지 않는다. Godot viewport·캡처 좌표는 별도 기록이며 유효 DPI·과거 원창 동등성은 NOT_VERIFIED다.

## 실패와 원본 증거 보존

최초 제품 G07 축소에서 PageDown/Ctrl+End/Down으로 긴 이력 끝에 도달하지 못했다. 마우스 대조에서는 END_B와 과거 사유가 보여 내용 누락과 키보드 접근 공백을 구분했다. D2의 `direct_gui`는 **FAIL_KEYBOARD_HISTORY_ACCESS** 원본 기록이다. 31개 포커스 표본의 권위 상태1개·새 명령0·종료0·엔진 오류0과 원본 해시를 보존했다. 추가 승인·L2 후 수정한 결과는 `direct_gui_after`에 별도로 기록했다.

구현 중 첫 Home 뒤 지연 가시화가 위치를 끌어오던 실패도 보존하고, 읽기 중 추적 억제로 해소했다. 해당 집중 검사64개 통과와 최종 전체662개 통과를 구분한다.

후속 캡처 아카이브의 파일명 충돌로 **16개 덮어쓴 기록을 제외**했다. 원래 실패 기록은 영향이 없다. 나머지 원본은 run 시각과 마지막 쓰기를 대조해 분리했고, 제품 축소 G07·기본 G07 및 G01 초기 화면은 고유 파일명/캡처 시점 해시로 재확보했다. 제외된 파일을 다른 조건의 증거로 재사용하지 않는다. D2에 제외 목록·회복 run·실제 보존 원본 식별자/해시를 남겼다.

원본 묶음 식별자: `DEV-021-Q12-EVIDENCE-20261114`. Tool 원본 JPEG와 동일 디코딩 픽셀의 PNG 형식 변환본을 구분한다. 새 PNG를 더 높은 충실도의 원본으로 부르지 않는다. 원본 이미지·로그는 로컬 증거 묶음으로 보관하며 승인된7개 외 공개 Git 파일을 추가하지 않는다. D2에는 로컬 절대 경로·환경 상세정보를 포함하지 않는다.

Input/focus 콜백은 레이아웃 반영 전일 수 있다. 전환 직후 캡처만으로 판정하지 않고 안정된 후속 화면·인접 입력·자동 정확 좌표 검사를 함께 사용했다.

## 재현과 검증 명령

```text
Godot --headless --path <worktree> --script res://tests/game/run_construction_ui_tests.gd -- --q12-only --q12-evidence
Godot --path <worktree> --script res://tests/game/run_construction_gui_cases.gd -- --q12-case=LTXT-G07 --q12-host=product --small
Godot --path <worktree> --script res://tests/game/run_construction_gui_cases.gd -- --q12-case=Q12-CMD-01
Godot --headless --path <worktree> --script res://tests/game/run_construction_ui_tests.gd
Godot --headless --path <worktree> --script res://tests/game/run_w07_tests.gd
Godot --headless --path <worktree> --script res://tests/game/run_tender_ui_tests.gd
Godot --headless --path <worktree> --editor --quit
.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v
.venv/Scripts/python.exe tools/policy.py doctor
.venv/Scripts/python.exe tools/policy.py check
.venv/Scripts/python.exe tools/policy.py preflight
```

F6 같은 표본 재조회, F7 정상 표시 복구, F8 고정 ID/현재 단계 요청, F9 1분, F10 REV 조건 변경, F11 절차 완료 시각 이동, F12 다음 case다. CMD는 F8→F8→F9→F8, REV는 F10→F8→F9, ORD는 F8 3회, HIS는 각 절차마다 F8→F9→F11, FIN은 F8→F9다. F12의 권위 case 전환 뒤 준비 완료 화면/로그를 확인한다. 이 제어는 제품 기능이 아니다.

| 구분 | 실제 결과 |
| --- | --- |
| Q12 자동 | 최종662 assertions / 실패0 / exit0 |
| 기존 W05 UI | 898 / 실패0 / exit0 |
| 기존 W07 | 322 / 실패0 / exit0 |
| 기존 W04A UI | 235 / 실패0 / exit0 |
| tooling | 89 tests / OK |
| 프로젝트 로드 | Godot4.7.2 headless editor --quit / exit0 |
| 직접 GUI | 위18+8 조건 및 LF 변형 / 각 run exit0·엔진/스크립트 오류0 |
| 빌드/export/성능 | NOT_RUN / 이번 범위 제외 |

D2의 source_hashes는 실행한 worktree 원시 바이트의 SHA-256다. LF로 정규화되는 Git blob은 provenance와 별도로 대조한다. 문서/증거를 포함한 최종 제출 SHA는 PR head로 식별해 재귀 self-hash를 만들지 않는다. 로컬 제출 검사·원격 CI 결과는 해당 제출 head와 함께 PR에 기록한다.

## 인계와 미해결 경계

Design은 고정 PR head로 해당 행을 독립 재검수하고 명시적 수용을 판단한다. 이번 개발 직접 PASS를 Design PASS나 DONE으로 승격하지 않는다. 기존 OBS-01 수용, A02-11 한정 PASS, QA-001/002 수용을 보존하며 **A01-Q12 전체 PARTIAL**은 유지한다.

정상 빠른 공사 제품 전체 E2E, W04A Q03~05 잔여, W06·VS-01·Stage·Track B/F-08, 과거 환경 오류의 근본 원인/DPI 확정, export/성능은 이번 증거로 해소하지 않는다. 새 명세 변경·추가 경로 요청은 없다. main 병합·공식 인수는 Owner 별도 결정이다.
