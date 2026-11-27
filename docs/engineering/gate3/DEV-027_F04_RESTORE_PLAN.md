# DEV-027 — K01 수용 후속·F04 복원 우선순위 최소 수정 및 검증 계획

- 작성: Development / AGT-DEV-0004 / 2026-11-27 KST.
- 상태: LOCAL_DOCUMENT_REVIEW / IMPLEMENTATION_AND_VALIDATION_NOT_AUTHORIZED / REMOTE_NOT_SENT.
- 기준 main: b0447defe57abe173d10dcc05784f79313ff69ca. 2026-11-27 fetch 및 #146 최신20댓글 확인. PR177 head cc5727ee13c720cb59c8cab7fdc41872e961af95와 전체 tree 동일.
- 로컬 브랜치: codex/DEV-027-f04-restore-plan. 이 브랜치 생성은 문서 격리이며 Commit·Push·PR 권한이 아니다.
- 연결: [K01 수용 후속 §7](../evidence/DEV-027_KEYBOARD_FOCUS_EVIDENCE.md), [공동 잔여 처분표](DEV-027_RESIDUAL_DISPOSITION.md), [기존 승인 계획](DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md), [결과 §18](../tasks/DEV-027_RESULT.md).

## 1. Owner 요청과 현재 권한

본 개발 대화의 이번 원문:

> 개발 에이전트. K01의 Track A/B 수용 결과를 후속 기록하고, 공동 잔여 처분표와 F04 5행의 최소 수정·검증 계획을 로컬로 준비해주세요. INCONCLUSIVE 10행의 필수 여부, 정확한 변경 경로와 승인 필요 범위를 포함해주세요. 구현·검증 및 Commit·Push·PR은 별도 승인하며, DI-03 보류와 기존 PARTIAL·최종 인수 대기는 유지합니다.

허용된 작업은 §6.1의 개발 문서7개 작성, 기존 소스/증거 읽기·해시 대조·문서 정적 검사다. 신규 게임 자동·프로젝트 로드·OS GUI·실험·계측·제품/검사 구현은 실행하지 않는다. 아래 실행안은 검토 대상이며 승인됐다고 표시하지 않는다. 이전 PR177의 승인은 그때의 K01/무입력 복귀 보완에 재사용할 수 있는 근거이지, 당시 명시적으로 제외한 same-owner restore 확장의 승인이 아니다.

DI03 실제 사건·대상 동/OD·수요/carry·소비·성공 재접수 HOLD, DEV026 한정 수용·기존 PARTIAL/미관측·P07 구분, F08 최종 규격/인증 및 S3-10-C·S3-12/HQ·Owner 최종 인수 대기를 유지한다.

## 2. 확정된 기대와 최소 문제

[Track B §3](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7077351699)는 같은 화면·scope/세대·유효 문맥에서 처리된 사용자 읽기가 유효 범위 안의 스크롤을 바꿨다면, 뒤늦은 이전 ensure/저장복원이 그 위치를 덮지 않아야 한다고 확인했다. [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7077287550)의 5행 기대/관측 연결 요청에 이를 대응한다.

- 무입력 복귀는 유효 저장 문맥을 복원한다.
- 새 Tab/Shift+Tab은 새 유효 focus를 가시화할 수 있다.
- 실제로 내부 Control에서 소비된 키, clamp로 이동0, 무효 문맥/옛 scope는 위 읽기 이동의 전제로 세지 않는다.
- owner가 같다는 이유만으로 읽기 이동이 없었다고 판단하지 않는다.
- 일반 P07 재진입과 저장 문맥 복귀, 기존 명령 유효성·안전한 fallback은 유지한다.

현재 Host의 _restore_reading은 _show_reading 뒤 navigation generation/owner를 저장하고2 frame 뒤 binding·generation·screen·owner를 검사한다. 같은 owner로 처리된 새 읽기 입력의 이력은 검사하지 않고 context.scroll을 적용한다. _input의 read_construction_key는 Home/End/PageUp/PageDown을 실제 바깥 scroll에 적용한다. 아래 기존 trace와 이 코드의 연결은 정적 원인 판단이며 이번 새 실행 결과가 아니다.

## 3. F04 5행 전제·관측·판정

원본: [기존 결과 JSON](../evidence/DEV-027_KEYBOARD_FOCUS_RESULTS.json)의 primary_run=view-05-final, keyboard_focus. 초기 PR head4f18678의737/0 실행 기록이며, 이번 main에서 새로 실행한 값이 아니다. 해당 Host 코드와 관측 로직은 후속 PR177에서도 보존됐다. 원 JSON의 OBSERVED_REVIEW_REQUIRED/design_status=PENDING은 당시 기록으로 그대로 둔다.

| 행 ID | 입력 시점 | 기존 frame / scroll 흐름 | 새 기대 대조·필요 조치 |
| --- | --- | --- | --- |
| F04:home:0:restore | 예약과 같은 frame |2912:215→0,2913:0,2914:215 | 처리된0 보존 필요. 기대 불일치·보완 필요 |
| F04:end:0:restore | 예약과 같은 frame |2931:215→430,2932:430,2933:215 | 처리된430 보존 필요. 기대 불일치·보완 필요 |
| F04:page_up:0:restore | 예약과 같은 frame |2950:215→0,2951:0,2952:215 | 처리된0 보존 필요. 기대 불일치·보완 필요 |
| F04:page_down:0:restore | 예약과 같은 frame |2969:215→430,2970:430,2971:215 | 처리된430 보존 필요. 기대 불일치·보완 필요 |
| F04:end:1:restore | 예약 후1 frame, 복원 전 |3045:215,3046:215→430,3047:215 | 처리된430 보존 필요. 기대 불일치·보완 필요 |

5행 모두 입력 전후 owner=Proposal_P-A, 화면=proposal, scope 불변. 예약 후 navigation generation=2 유지, model hash 불변·명령수0, scroll 유효 범위0..430이다. 따라서 이 구성요소 시험에서는 기대 적용 전제가 성립한다. 215는 이 fixture의 저장값이며 제품 상수로 사용하지 않는다. 실제 OS P05/P07 복귀 경쟁 재현으로 확대하지 않는다. 819/0·안정 GUI 수용과 별도이며 최종 복귀 동작 수용 전 해결 또는 HQ/Owner의 명시적 범위 처분이 필요하다.

## 4. 최소 구현 제안 — 아직 미착수

제품은 scripts/ui/stage1_view.gd 한 파일의 _input·_restore_reading 및 필요한 Host 내부 상태에 한정한다.

1. Host가 실제 처리한 읽기 키에서 바깥 scroll 전후를 비교한다. 유효 문맥에서 위치가 변한 경우에만 읽기 입력 세대를 진전시키는 안을 우선한다. 단순 키 수신, 이동0, 내부에서 소비된 키를 유효 바깥 읽기로 세지 않는다.
2. 복원 예약 시 현재 읽기 세대를 navigation generation과 함께 캡처한다. callback이 실행될 때 더 최근의 유효 읽기가 있으면 이전 저장 위치/포커스로 되감지 않는다. 사용자 입력이 있었지만 원래 위치로 되돌아온 경우도 단순 최종 좌표 비교로 놓치지 않는다.
3. 기존 binding/scope/screen/navigation/owner/target-valid 보호는 그대로 적용한다. 무입력 복원·새 Tab 추적·다른 owner/화면 이동 보호·선택 사업/역/보고 문맥을 보존한다. 새 Session/재바인딩 시 옛 callback이 유효해지지 않게 한다.
4. 먼저 5행을 해결한다. _ensure_focus_region의 기존 follow_focus 보호와 공통 read_construction_key의 외부 호출 계약은 보존한다. 꼭 필요한 동일 파일 내부 정리는 허용 후보지만 전면 리팩터링·일반 포커스 정책 재설계는 제외한다.

휠 입력은 GUI 전달 뒤 실제 이동이 발생할 수 있다. 단순 MouseButton 수신이나 모든 scroll value_changed를 사용자 읽기로 세면 자동 레이아웃/restore/ensure도 취소 근거가 된다. 이번 최소 제품안에 그런 포괄 처리를 포함하지 않는다. §5의 기존 runner에서 실제 휠 이동·동일 문맥·시점을 먼저 입증하며, 휠 제품 수정이 추가로 필요하면 증거/최소 추가 동작을 제시해 별도 승인받는다. 디버그 제품 로그·새 runner/씬·외부 도구 도입은 제안하지 않는다.

## 5. 실행·검증 계획

### 5.1 결정적 자동과 전제 검사

검사 수정은 기존 tests/game/run_proposal_view_tests.gd 안에서 한다. 새 runner·별도 UID는 없다. 현재974행으로 길이 여유가 작으므로 기존 helper/자료 표현을 정리하더라도 원 단언/기능 범위를 보존한다. 상한·정책/CI를 완화하지 않는다. 두 코드 경로만으로 수용 가능한 보완이 불가능하면 추가 경로를 쓰기 전에 최소 변경안을 제출한다.

| 검사 묶음 | 최소 기대/증거 |
| --- | --- |
| F04 5행 | 같은 runner의 수정 전 실패/후 성공, 실제 키 dispatch→처리된 이동→callback 후5 frame 유지. boolean owner 동일만으로 null==null을 유효 focus로 세지 않음 |
| 입력 전제 | key/wheel 실제 소비·scroll delta·owner의 존재/유효성·screen/scope/navigation/읽기 세대·예약/입력/callback frame·scroll limit/page·context 저장값. 직접 scroll 할당은 fixture 준비만 |
| INCONCLUSIVE10 | [처분표 §3](DEV-027_RESIDUAL_DISPOSITION.md)의10행을 각각 연결. 기존 push_input 좌표/내부·외부 hit 영역/이동 여부와 실제 return의 null-owner 구간을 기존 runner에서 한정 확인. 임의 유효 owner 주입·강제 scroll로 원 시험 PASS 만들기 금지 |
| 양성/음성 경계 | 무입력 복원, 복원 완료 후 End, 새 Tab/역Tab 추적, 다른 owner/화면·옛 scope/재바인딩, 유효 읽기 후 원좌표로 재이동, clamp 이동0 및 실제 내부 소비키 구분 |
| 공통 불변식 | 읽기 자체의 추가 편집/심사/RNG/지급0·snapshot 불변. K01 skip/계약·설득/마지막 행 단언 보존. fixture/시간 환산과 OS 입력 구분 |

필수 입력 전제를 만들지 못한 사례는 구체 이유와 INCONCLUSIVE를 남기고 자동 통과로 집계하지 않는다. 정확한 null-owner 시점은 same-owner 읽기 우선순위에 비적용인 근거 후보지만, 화면 복귀 기능 자체의 제외/완료는 아니다. 필요한 공동 판단 없이10행을 삭제하거나 전부 N/A로 바꾸지 않는다.

### 5.2 영향 회귀·로드·제출 검사

아래 게임 실행은 승인 후 수행할 계획이며 이번에는 NOT_RUN이다. 문서 정적 검사는 이번 결과서에 별도로 기록한다. Godot는 기존4.7.2 console을 재사용하고 각 run을 새 출력 폴더/APPDATA/LOCALAPPDATA로 격리한다. 공통 인자: `<Godot> --headless --path <worktree>`.

| 목적 | 추가 인자/명령 | 변경 권한 |
| --- | --- | --- |
| 제안 View 전후·최종 | `--script res://tests/game/run_proposal_view_tests.gd -- --output=<fresh-run>/evidence.json` | 검사1개 수정 후보 |
| 운영·저장 복귀 | --script res://tests/game/run_operations_gui_cases.gd -- --auto | 기존 검사 실행만 |
| 공사·공유 읽기 | --script res://tests/game/run_construction_ui_tests.gd | 기존 검사 실행만 |
| Session/scope/수명 | --script res://tests/game/run_s01_exception_tests.gd | 기존 검사 실행만 |
| 최종 프로젝트 로드 | --editor --quit | 실행만, project.godot 수정 없음 |
| 문서·코드 정합성 | .venv/Scripts/python.exe tools/policy.py doctor 및 check; git diff --check | 정책 수정 없음 |
| Git 제출 시 | fetch·정상 commit 뒤 policy.py preflight; PR head의 policy/department-policy | Commit·Push·PR 승인 후에만 |

각 실행의 소스 SHA/161개 기존 소스 해시 범위·명령·원 로그·실패·단언 ID/개수·exit·ERROR/SCRIPT ERROR·출력 저장 성공을 연결한다. 원 737/819·회귀 수치를 이번 실행과 합산하지 않는다. harness 실패 집계 자체를 바꾸지 않으면 기존 exit1 근거를 재사용한다. 새 F04 결과는 별도 JSON에 저장해 기존 대용량 JSON과 실패 원본을 덮지 않는다.

### 5.3 독립 GUI·A/B 재수용

새 독립 GUI 실행은 현재 승인 요청 범위에 자동 포함하지 않는다. 결정적 자동 전후 증거를 A/B가 먼저 검토하고, 실제 부족한 영향 행/입력/필드가 확인되면 그 국소 OS 범위만 별도로 제시한다. 공통 Host 변경의 안정 P05/제안·P07 복귀 영향이 있으면 해당 동작의 국소 확인을 연결한다. 같은 패킷으로 A 기능/행동과 B 읽기/수명/복귀를 각각 판정받는다.

K01 지정 경로와 자연 VS02·공사/영업/첫 보고 전체를 반복 종료 조건으로 만들지 않는다. OS 도구의 약2초 지연으로1~2 frame 동기화를 못 하면 RACE INCONCLUSIVE를 유지한다. 결정적 자동 증거의 충분성·추가 OS 필수 여부는 공동 판정 사항이며 DEV 단독 최종 면제도 아니다.

## 6. 정확한 변경 경로와 승인 단위

### 6.1 이번 로컬 문서 — 정확한7개

| 번호 | 경로 | 작성 내용 |
| --- | --- | --- |
| D1 | docs/engineering/gate3/DEV-027_F04_RESTORE_PLAN.md | 신규 최소 수정·검증·권한 계획 |
| D2 | docs/engineering/gate3/DEV-027_RESIDUAL_DISPOSITION.md | 신규 공동 잔여 처분표·10행 필수 여부 제안 |
| D3 | docs/engineering/gate3/DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md | 기존 원문 뒤 §13 후속 연결 |
| D4 | docs/engineering/evidence/DEV-027_KEYBOARD_FOCUS_EVIDENCE.md | 기존 원문 뒤 §7 A/B 한정 수용·원본 식별 |
| D5 | docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md | 기존 원문 뒤 §20 문서 작성 권한·잔여 |
| D6 | docs/engineering/tasks/DEV-027_RESULT.md | 기존 원문 뒤 §18 로컬 결과/검사 |
| D7 | docs/engineering/tasks/DEV-027_PROVENANCE.json | 이번6문서의 base/blob 출처. 과거 선언은 base Git 원본으로 보존 |

### 6.2 향후 구현·검증 승인 후보 — 최대10개 고유 경로

위 D1~D7의 결과 후속 갱신7개에 아래3개만 추가한다. 이번에 제품/검사/새 결과 JSON을 생성·수정하지 않는다.

| 번호 | 경로 | 허용 후보 |
| --- | --- | --- |
| C1 | scripts/ui/stage1_view.gd | §4의 F04 5행 최소 보호 |
| T1 | tests/game/run_proposal_view_tests.gd | §5 전후 단언·10행 전제 분류·기존 회귀 보존 |
| E1 | docs/engineering/evidence/DEV-027_F04_RESTORE_RESULTS.json | 새 실행·전후 trace/소스/원 로그 해시·미확인 분리 |

기존 DEV-027_KEYBOARD_FOCUS_RESULTS.json, proposal_view.gd, 씬·모델·Session·Pipeline·데이터·에셋·폰트/이름·다른 부서 산출물·정책/CI는 변경 제외다. operations/construction/S01 runner는 실행만 하며 수정하지 않는다. 새 UID/runner·제품 진단 계측·휠 우선순위 제품 확장·범위 밖 파일이 필요하면 해당 최소 추가분을 먼저 제시한다.

### 6.3 승인 경계

| 동작 | 현재 상태·다음 승인 |
| --- | --- |
| D1~D7 로컬 작성·기존 자료 대조·문서 정적 검사 | 이번 Owner 요청으로 승인됨 |
| C1/T1/E1 포함 최대10경로 구현·게임 자동/회귀·로드 | 별도 Owner 착수 승인 필요. 5행 보완+10행 전제 확인 범위를 명시 |
| 독립 GUI·새 관측 장치/제품 계측 | 별도 범위 확정·승인. 기존 수용은 재사용 |
| Commit·Push·PR·#146 게시 | 별도 승인. PR177 권한을 신규 제출로 확대하지 않음 |
| main 병합·이슈/RFC 종료·최종 인수·릴리스 | 별도 Owner/HQ 절차 |
| DI03 실제 종속 구현/검증 | HOLD 유지. 이 계획으로 해제하지 않음 |

## 7. 완료 판정과 공동 확인사항

로컬 구현의 검토 종료 조건은5행의 같은 runner 전후 증거·해당 회귀/로드·정확한 변경 경로·원본 보존,10행 각각의 전제/필수 여부/미확인·후속 담당이 연결된 결과다. 미해결 필수 행이 남으면 부분 결과로 제출하며 전체 PASS/DONE으로 표시하지 않는다.

Track B에 필요한 판단은 기존 읽기 우선 기대의 재승인이 아니라, 최소 기술안의 적용 경계와10행 대체 증거 충분성이다. Track A는 비의존 기능/행동·남은 접근/카운터 필수 범위를 확인한다. HQ/Owner는 실제 미해결 필수 행의 제외/이관 또는 최종 인수 수준을 결정한다. 현재 새 게임·경제·시간·세이브 명세 변경 요구는 없다. 적용 기대가 충돌하거나 범위를 바꿔야 할 때만 [RFC 절차](../../templates/RFC_AND_DECISION.md)로 해당 행을 제시한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 8. Owner 승인에 따른 로컬 구현·검증 — 2026-11-27

> DEV-027 F04 최소 수정·검증 계획을 승인합니다. 최대 10개 경로 안에서 F04 5행 보완과 INCONCLUSIVE 10행의 전제 확인을 진행하고 로컬 결과부터 검토 요청해주세요. 독립 GUI·Commit·Push·PR·main 병합은 별도 승인하며, DI-03 보류와 기존 PARTIAL·최종 인수 대기는 유지합니다.

§1~7은 승인 전 계획으로 보존한다. 위 승인은 §6.2의 정확한10경로에 적용하며, 소스/검사2개·문서7개·새결과JSON1개로 완료했다. 기준 b0447defe57abe173d10dcc05784f79313ff69ca, 작업 브랜치 codex/DEV-027-f04-restore-plan. 새 commit SHA는 없다. [로컬 결과 §19](../tasks/DEV-027_RESULT.md)와 [실행 증거](../evidence/DEV-027_F04_RESTORE_RESULTS.json)를 검토 대상으로 한다.

Host는 실제 처리한 바깥 읽기 키의 이동이 있을 때만 읽기 세대를 진전시킨다. 저장 복원 예약 뒤 세대가 바뀌면 오래된 위치/포커스를 적용하지 않는다. clamp 이동0·LineEdit 내부 입력·무입력 복원·scope/navigation/owner/수명 보호를 유지했다. 공통 read_construction_key 계약 및 휠 제품 처리는 변경하지 않았다. 파일 상한 내에서 caption/기존 조건의 지역 참조를 정리했고, 검사에서도 중복 대기·기대값 표현을 정리했다. 최종 Host999행/runner1000행, 기존818개 JSON 단언 ID의 중복 개수까지 보존했다.

동일 runner SHA의 집중 전후 실행은209검사/6실패→209/0이다. 원 F04 5행과 End→Home 원위치 재이동1행이 전후 실패/성공으로 연결된다. 전체 검사는846/0이며 원819검사에 새27검사를 더한 결과다. 집중 실행용 --f04-only는 기존 runner 안에서 동일 F행/경계 함수를 선택하며 새 runner/UID가 아니다. 최종 전체 실행 소스는 전후 검사 소스를 LF로 정규화한 것뿐이다. 운영/공사/S01 회귀·프로젝트 로드 결과는 결과서에 실행별로 연결한다.

휠 합성 입력은 viewport 내부 좌표로 보내고 mouse-enter 상태를 통지하여 실제 이동을 확인했다. push_input의 in_local_coords 의미는 [Godot 공식 Viewport 문서](https://docs.godotengine.org/en/stable/classes/class_viewport.html#class-viewport-method-push-input)를 따른다. 직접 scroll 할당은 fixture 준비에만 쓰며 입력 뒤 보존 성공을 만들지 않는다. 독립 OS 관측·Design 재수용으로 확대하지 않는다.

## 9. 새로 특정된 휠 잔여와 추가 승인 경계

§4의 “휠 제품 수정이 추가로 필요하면 증거/최소 추가 동작을 제시해 별도 승인받는다”를 적용한다. 이번 승인은 휠 전제 확인까지이며 아래 구현은 NOT_RUN이다. 승인된 키5행 보완은 완료했지만 전체 F행을 PASS/DONE으로 만들지 않는다.

| 추가 대상 | 현재 확인 / 최소 후속안 | 정확한 후보 경로 / 승인 |
| --- | --- | --- |
| F03 wheel_down0 ensure; F04 wheel_up0·wheel_down0·wheel_down1 restore | 실제 소비·이동·유효 동일 owner 성립 후4행에서 덮어쓰기. GUI 전달로 발생한 휠 이동을 해당 event와 연결하여 읽기 세대/ensure 보호에 반영하는 최소안 검토. 모든 value_changed나 단순 MouseButton 수신을 사용자 읽기로 세지 않음 | scripts/ui/stage1_view.gd, tests/game/run_proposal_view_tests.gd, docs/engineering/evidence/DEV-027_F04_RESTORE_RESULTS.json 및 §6의 기존7문서, 최대10경로 재사용 후보. 휠 제품 확장 로컬 구현·검증은 별도 Owner 승인 필요 |
| P05/P07 return 휠2행 | owner=null이어도 실제105 이동 후462/215로 덮임. null만으로 비적용 처리 불가. 휠의 유효 hit 영역/화면 복귀 중 입력 우선 기대를 Track B/A가 확인하고 필요한 범위를 위 안에 특정 | 동일 후보 경로. 기대 확정 없이 제품 정책을 임의 변경하지 않음. 새 OS/계측 필요 시 영향 행·사유를 먼저 제시 |
| End return2행 | owner=null, handled=false, 이동0 재확인. 해당 시점의 same-owner 키 경쟁은 성립하지 않음. 원 INCONCLUSIVE 및 무입력 복귀 증거 보존 | 현재 추가 제품 수정 근거 없음. 특정 시도 비적용/대체 충분성은 A/B 확인 대기 |

같은10경로라도 휠 제품 확장은 이번 실행 승인에 포함되지 않는다. 4행은 유효 읽기 보호의 실제 필수 보완이며 관련 최종 수용 전 해결 또는 권한 있는 명시 처분이 필요하다.2개 null-owner 휠의 필수 적용 범위는 공동 판단 대기다. 독립 GUI·Commit·Push·PR·#146 게시·main 병합 및 DI03 해제는 별도 승인이다. 새 게임/경제/시간/세이브 명세 변경은 필요하지 않으며, null-owner 기대가 기존 계약과 충돌할 때 해당 행만 RFC로 제시한다.


## 10. 제출 승인·최신 A/B 적용 후속 — 2026-11-27


Owner의 이번 제출 승인 원문: “독립 GUI Commit, Push PR 생성까지 승인합니다”. 실행 주체 확인 후 선택: “Design Track A/B의 독립 GUI 실행 대기”. 승인된10경로의 Commit·Push·PR 및 필수 CI 확인을 진행한다. 독립 GUI는 Design 대기이며 DEV GUI를 독립 실행으로 대체하지 않는다. main 병합·휠 제품 확장·DI03 보류 해제는 승인 범위에 포함하지 않는다. 이번 #146 댓글 게시는 수행하지 않는다.

[Track B B2](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7216115783), [Track A A2](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7216152833), [Planning P2](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7216239510)를 제출 전 확인했다. B2는 유효 바깥휠 이동이면 owner=null에도 보호 계약이 적용된다고 명시한다. 새 자동 trace의 return_p05/return_p07 휠2행은 proposal 화면·동일 scope·generation3, handled=true, 각각0→105→462 및22→127→215다. 따라서 앞선 “적용 기대 판단 대기”는 당시 검토 기록으로 보존하고, 최신 계약에 따른 DEV 판단은 기존4행과 합친 **휠6행 실제 보완 잔여**로 갱신한다. 수정본 Design 수용은 별도다. 기대 재승인 요청은 없으며 기술 보완 범위의 Owner 승인만 남는다. End return2행의 정확한 null-owner 시점 비적용과 안정휠 재사용도 B2 원범위로 연결한다.

키5행의 전후 성공·공통 회귀/로드와 원 INCONCLUSIVE10을 보존한다. B2/A2는 신규 OS timing 인증·전체 자연VS02 반복을 종료 조건으로 요구하지 않는다. P2는 A1+B1 정책 해결과 DI03 실제 구현 HOLD를 구분한다. 이 제출은 게임/경제/시간/세이브 명세를 변경하지 않는다.

§9의 동일10경로 후보는 유효 휠6행의 기술 보완 계획으로 검토한다. 신규 휠 제품 구현은 수행하지 않았으며, 독립 GUI/Design 수용 및 기존 PARTIAL·최종 인수는 대기한다. 제출 브랜치는 codex/DEV-027-f04-restore-plan이다.
