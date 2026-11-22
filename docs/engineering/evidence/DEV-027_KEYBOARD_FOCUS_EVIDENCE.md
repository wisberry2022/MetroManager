# DEV-027 — 키보드 접근·포커스/스크롤 보완 증거

- 담당: Development / AGT-DEV-0004 / 2026-11-22 KST.
- 기준 main: `1b80303636c5eddfbeddac9d288b0124b0093966`.
- 승인: [계획 §9·11](../gate3/DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md). A8개 + B 제품1개, 정확한9개 경로의 구현·회귀·Commit·Push·PR·필수 CI.
- 현재: **DEV 자동737/0 + 직접 영향 회귀1503/0, 프로젝트 로드 PASS / OS·Design 수용 PARTIAL 유지**. main 병합·최종 인수는 별도다.
- 고정 식별: 기준 SHA + 아래 source SHA256. Commit 이전 실행이며 최신 main의 자연 GUI 완주라고 표시하지 않는다.
- 제품 `scripts/ui/stage1_view.gd`: `fe82f7ca40fe0ce083bf6b7fc6eb7a82c83907450877e454c9243136fee41fb3`.
- 검사 `tests/game/run_proposal_view_tests.gd`: `31b35a372a1279bbf274f929af60703b4c7b9f3cbe2cfa010de6ad83365a660e`.
- [기계 판독 결과](DEV-027_KEYBOARD_FOCUS_RESULTS.json): 소스161개 해시, 실행 명령·exit·ERROR, 압축 단언, 원 JSON/로그 해시, K/F 관측을 포함한다.

## 1. 수정과 검증의 연결

제안 화면의 Tab/Shift+Tab 입력 직전에 현재 disabled 버튼과 빈 계획 목록을 순회에서 제외한다. 제안 지연 ensure도 follow_focus=false를 존중해 저장 복귀 뒤 다시 스크롤하지 않는다. 포커스 진단 dict/fallback의 표현 정리는 기본 파일 길이 규칙을 충족하기 위한 동일 행동 변경이며 로그 필드와 후보 순서는 유지한다. 게임 규칙·명령·데이터·시간·정책·CI를 수정하지 않았다.

동일 runner의 수정 전 view-03-pre-fix는745단언/44실패, 수정 후 view-04-fixed는703단언/0실패다. 차이42는 실제 Tab 순환에서 비활성 제안 Control42회가 제외된 결과이며 단언 코드 삭제가 아니다. 기존 원 View224개 JSON 단언 + 출력 저장1개를 유지했다. 최종 계획 대조에서 K04 목록 역방향 이탈·K08 시청 역방향 도달2건·F06 각28사례의 focus 가시성34단언을 추가하여 view-05-final **737/0**으로 재확인했다. view-04→05 제품 변경0이며 직접 영향 회귀는 동일 제품 소스를 검사했다(검사 파일1개 hash 차이를 JSON에 명시). 저장 복귀2개 실패도 정상화됐다: P05 저장462→462 유지, P07 저장215→215 유지(이전에는 둘 다178로 덮임).

## 2. 실행·원본 보존

| run | 결과 | 의미 |
| --- | --- | --- |
| initial-load | headless editor import/로드 exit0, ERROR/SCRIPT ERROR0 | 최초 view-01과 일부 중첩; view-01은 최종 근거 제외 |
| view-01 | 검사 작성 오류 / SCRIPT_ERROR_TERMINATED | Home을 ItemList 선택으로 가정, 즉시 편집을 심사 큐로 계수, 빈 배열 참조. 원본 보존 후 검사 수정 |
| view-02 | 709/47, exit1, SCRIPT ERROR0 | 제안 Tab42·공통 HUD3·저장 복귀2. 확정 실패를 보존 |
| view-03-pre-fix | 745/44, exit1, ERROR/SCRIPT ERROR0 | 최종 동일 runner의 수정 전 대조. 제안42·복귀2 |
| final-load-pre-fix | exit0, ERROR/SCRIPT ERROR0 | 제품 수정 전 로드; 수정본 근거와 구분 |
| view-04-fixed | **703/0, exit0, ERROR/SCRIPT ERROR0** | 기존 View + K/F 자동 단언 전체 |
| view-05-final | **737/0, exit0, ERROR/SCRIPT ERROR0** | K04 목록 역방향 이탈·K08 역방향 도달·F06 가시성 단언 추가 후 최종본 |
| regression-operations | **271/0, exit0, ERROR/SCRIPT ERROR0** | 실제 Control의 headless `--auto`; OS GUI 아님 |
| regression-construction | **898/0, exit0, ERROR/SCRIPT ERROR0** | 공사 UI·공유 ensure·읽기 회귀 |
| regression-s01 | **334/0, exit0, ERROR/SCRIPT ERROR0** | scope·무효/복구·Session 수명 회귀 |
| final-load | **exit0, ERROR/SCRIPT ERROR0** | 수정본 headless editor 로드 |

원본은 이 worktree의 `.local/validation/DEV-027/keyboard-focus/<run>/`에 보관한다. run.json·output.log·runner-source.gd와 해당 실행의 evidence.json/source-sha256.json을 연결한다. view-03 이후에는 실행 직전 소스161개 해시도 저장했다. earlier runner/실패 로그·기존 A/B 패킷·과거 증거는 덮어쓰지 않았다. 동일 runner의 exit1 실패 집계/저장을 view-03에서 확인했으며 해당 harness 로직은 변경하지 않아 deliberate failure를 재실행하지 않았다.

## 3. K01~12 자동 근거와 한계

| 범위 | 새 자동 근거 | 한계 |
| --- | --- | --- |
| K01~02 | 정상 main 초기 Tab 진입, P-A/B 순·역 Tab·Enter/Space, 선택과 focus/읽기0 구분 | root.push_input 합성 입력. OS 창 활성화/순수 물리 키보드 아님 |
| K03~05 | 목록/지도 역12개씩, 잠금 목록 대체 접근, ItemList Up, 이름 타이핑/선택/삭제/Home/End/명시 적용 | fixture 노선 준비는 별도. 이동 rect 교차 확인은 시각 품질 검수가 아님 |
| K06~09 | 편집 payload·예측·시청/정부/설득/계약 command_requested1회·action/slot | seed2/8·시간 환산 준비 사용. 기존 자연 VS02를 새로 수행한 것이 아님 |
| K10~12 | P05·재무 이동/복귀, 제목 읽기, 유효 Tab 순환·잠금 skip·모델 무효과 | 안정된 초기 anchor 외 대상 이동은 Tab. 공통 HUD는 별도 관측 |

Tab 대상60건·명시 명령 활성화13건·순환3건을 JSON에 기록했다. view-02의 공통 HUD resume3개 실패는 제안 subtree 밖이므로 이후 `outside_proposal_scope`로 분리했다. 원 FAIL은 그대로 보존하고 HUD 수정/수용 PASS로 바꾸지 않았다. 원래 제안42개 실패는 제품 수정으로 해소했다.

## 4. F01~06 잔여: 자동 통과와 Design 기대를 분리

28개 순서 사례에 입력 전후/5frame의 owner·screen·generation·follow_focus·scroll·rect·모델 해시를 기록했다. 무입력 복귀·다른 owner/화면 보호·Tab 추적 재개 등 확정 계약은 단언 PASS다. 관측행의 OBSERVED_REVIEW_REQUIRED는 Design 수용 판정이 아니다.

| 행 | 최종 관측 | 후속 |
| --- | --- | --- |
| F02 ensure + Home/End/PageUp/PageDown | 같은 owner의 입력 이동0/430을 유지 | DEV 자동 관측. OS·Design 우선순위 판정 별도 |
| F04 restore + Home/End/PageUp/PageDown(delay0), End(delay1) | **5개 제안 우선순위 불충족 관측**: 입력0/430이 저장215로 덮임 | 같은-owner restore 입력 취소 세대 확장은 이번 최소 수정 밖. Track B 기대 확인 후 필요한 행만 별도 계획 |
| F04 restore End(delay3) | 복원 완료 후 입력430 유지 | 다른 타이밍의 결과로 위5개를 PASS 처리하지 않음 |
| F03/F04 합성 휠6개 + 실제 P05/P07 return의 End/휠4개 | **INCONCLUSIVE10**. 휠 이동이 없거나 return 입력 시 유효 owner/실제 이동 전제가 성립하지 않음 | OS wheel 성공/순서 PASS 선언 없음. Owner 실행 승인·A/B 공동 행 확인 후 한정 관측 |

`proposed_user_scroll_preserved`는 원 관측값이며 `priority_expectation_applicable=true`인 행만 제안 기대 비교 대상이다. 무입력·Tab/화면 이동의 false를 결함으로 해석하지 않는다. 전체 K/F 잔여를 해소했다고 선언하지 않는다.

## 5. 재현 명령·제출 검사

엔진은 Godot `4.7.2.stable.official.ed1daf0bf`다. 각 실행은 격리 APPDATA/LOCALAPPDATA와 새 출력 디렉터리를 사용했다.

```text
<Godot> --headless --path <worktree> --script res://tests/game/run_proposal_view_tests.gd -- --output=res://.local/validation/DEV-027/keyboard-focus/view-05-final/evidence.json
<Godot> --headless --path <worktree> --script res://tests/game/run_operations_gui_cases.gd -- --auto
<Godot> --headless --path <worktree> --script res://tests/game/run_construction_ui_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_s01_exception_tests.gd
<Godot> --headless --path <worktree> --editor --quit
.venv/Scripts/python.exe tools/policy.py doctor
.venv/Scripts/python.exe tools/policy.py check
.venv/Scripts/python.exe -X utf8 .local/validation/DEV-027/keyboard-focus/audit.py
```

정책·경로/소스/증거 무결성 및 제출 preflight 결과는 [결과서 §16](../tasks/DEV-027_RESULT.md)와 PR의 필수 CI에 연결한다. 원격 policy·department-policy는 게임 자동/독립 GUI/Design 검수와 다르다.

실제 게임 플레이 / DEV OS GUI / 독립 실행 / 새 자연 VS02 / 빌드·export / 성능은 각각 **NOT_RUN**이다. [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075072443)의 정상 자연 VS02 관측 PASS/전체 PARTIAL, [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075447846)의18행 한정 수용 및 기존 PARTIAL/미관측을 유지한다. DI03 HOLD·DEV026 한정 수용/일1 미관측·P07 구분·#92/F08·S3-10-C·S3-12/HQ·Owner 최종 인수는 그대로다. 추가 기획 명세 변경 없음; same-owner 기대가 달라져야 하면 해당 행에만 RFC 절차를 적용한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 6. #146 Track A 재현 후속 — 2026-11-22 / PR177 추가 제출

[Track A 전달](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7076149744)의 시험37596bd와 패킷 `supplement-k01-f01-20261122-a02`를 확인했다. REPORT SHA256 `471bddfdf6fd29931b96031eb15d2e851929143e1826d9683102862db8de87c1`, manifest `1b824f620372ad4205160e046bcaf57657019765cbe91b0b36d9df8762eb3fc1`, 원본181개 불일치0이다. RECORD_CORRECTIONS·FOCUS_LINKS·cases와 원046화면을 대조했다. 개인 절대경로·원 캡처/로그는 공개 업로드하지 않는다. 본문 앞의 수치는4f18678 당시 근거이며 아래 실행으로 덮어쓰지 않는다.

| 전달 행 / 원본 식별 | DEV 후속 | 남는 판정 |
| --- | --- | --- |
| K01-12 이름→Tab,047/048·seq14→15·rev104·log2008/2010 | 한 Tab 직후 및 Host.present 후 다음 유효 제거 버튼 확인. 정부 요청 대기079/080·seq36→37·rev191 및 실제 심사중도 분리 | 기존 Host Tab 수정의 합성 이동 PASS. 수정본 OS 재검수 NOT_RUN |
| K01-13 재조회→Shift+Tab,084~086·seq40→41→42·rev321 | 비활성 P05를 건너 활성 계약 도달, Enter 명령1회/action/slot 확인 | 순수 OS 계약 실행 NOT_VERIFIED를 자동 PASS로 승격하지 않음 |
| K01-14 seed8 보류,141~147·seq16→17→18·rev324/325 | 재조회 역방향→설득과 예측→시청→설득 정방향을 각각 단일 Tab으로 확인. Space 설득1회/action/slot | 순수 OS 설득 실행 NOT_VERIFIED 유지 |
| K01-04 목록,043~047 | 이름→역Tab 목록→Up S08→Down S12. 선택S12지만 내부scroll0/행y139+27이 높이130 밖인 불일치 재현. 이미 선택된 행의 재선택 제거 후 내부scroll40.0, 행[P: (4.0, 99.0), S: (1104.0, 27.0)]·내부/외부영역 포함 PASS | 국소 자동 보완. 기존 OS PARTIAL의 Design 재수용 대기 |
| F01 안정 읽기·경쟁 | 새 OS 실행 없음. 기존28개 자동 순서/읽기 무효과 보존, F04 우선순위5행·INCONCLUSIVE10 유지 | OS 안정 관측과1~2frame RACE INCONCLUSIVE를 구분 |

수정 제품은 **proposal_view.gd의 _render_map 선택 갱신**뿐이다(이번 후속 기준). 선택이 같으면 deselect/select를 반복하지 않아 키 입력이 예약한 행 가시화가 유지된다. 선택 변경 시 select, 선택 없음 시 deselect는 유지한다. 기존 Host invalid-focus fallback·유효성·명령 허용 상태는 그대로이며 버튼을 강제로 활성화하지 않는다. ItemList 행 좌표는 [공식 API](https://docs.godotengine.org/en/stable/classes/class_itemlist.html#class-itemlist-method-get-item-rect)를 참고하고 실제 내부 스크롤을 차감해 clipping을 대조했다. 전수 시각 품질/지원환경 인증이 아니다.

### 새 실행·식별

기준 sync `325b54a0ab45d297add709238a80f881c899912d`, 신뢰 base `d8b6f4abb3e4e6bcb9b8a53394bb600ca14938fc`. 제품 proposal_view SHA256 `1bb18196e273b9961329120d35c3baf6f1dee7c1e0b1b86c29733d377c727249`, 검사 SHA256 `9ac0bf1065eb8f22e658ce081ccb6217de4888609819388154ab61dc24c4b5fa`. [JSON](DEV-027_KEYBOARD_FOCUS_RESULTS.json)의 `followups[0]`에 실제 소스161개, 전체 단언·단일 Tab11경로·선택 행·명령 활성화·실패 원본 해시를 연결했다. 기존 JSON 최상위 실행/판정은 모두 그대로다.

| run | 결과 | 해석 |
| --- | --- | --- |
| initial-load | exit0, ERROR/SCRIPT ERROR0 | 후속 초기 headless import |
| view-01 |807단언/3실패, exit1, ERROR/SCRIPT ERROR0 | 목록 잘림1 + 이미 focus된 정부 요청 버튼을 새로 도달한 것으로 가정한 시작 가시성2. 원 실패 보존 |
| view-02-before-list-fix | **819/1**, exit1, ERROR/SCRIPT ERROR0 | 시작 owner를 직접 확인하고 실제 한 Tab 후 가시성을 단언, 내부 좌표 보정 후 목록 잘림만 FAIL |
| view-03-fixed | **819/0**, exit0, ERROR/SCRIPT ERROR0 | 수정 전과 정확히 같은 runner. 새 이동/목록 및 기존 전체 검사 |
| regression-s01 | **334/0**, exit0, ERROR/SCRIPT ERROR0 | 공통 관측 무효/복구·Session 수명 영향 |
| final-load | exit0, ERROR/SCRIPT ERROR0 | 최종 제품 headless editor 로드 |

이미 focus를 보유한 정부 요청 직후 시작점은 텍스트 증가로 화면 밖일 수 있음을 trace에 남겼다. 시작점을 다시 Tab으로 획득한 것으로 오인한 view-01의 가시성 단언2개와, 요구된 **다음 Control의 즉시/안정 owner·가시성** 검증을 구분한다. 새 helper는 현재 owner가 시작점이면 이를 확인하고 한 Tab을 보낸다. 새로 시작점에 접근하는 경우에는 여전히 실제 Tab 및 가시성 단언을 적용한다. 실패 숨김을 위해 목적지 단언을 제거하지 않았다.

모든 신규 명령은 §5의 공통 Godot4.7.2 `--headless --path <worktree>`를 사용하며 출력 폴더는 `.local/validation/DEV-027/keyboard-focus-issue146/<run>/`다. View에는 `--script res://tests/game/run_proposal_view_tests.gd -- --output=<fresh-run>/evidence.json`, S01에는 `--script res://tests/game/run_s01_exception_tests.gd`, 로드는 `--editor --quit`. 실제 OS GUI·새 자연 VS02·빌드/export·성능은 각각 NOT_RUN이다. 기존1503회귀는 당시 수치로 보존하고 이번334에 중복 합산하지 않는다.

Design 원본 두 GUI 실행의 shader cache 저장 ERROR는 **실행별4건**, exit0/SCRIPT ERROR0과 구분한다. engine/stderr 중복을8건으로 세지 않으며 원인·키보드 결함과의 연관은 미확인이다. 이번 headless 오류0으로 해결했다고 주장하지 않는다.

후속 독립 GUI는 K01-12/13/14 국소 정·역 이동과 활성 계약/설득 실행, K01-04 마지막 행만 요청 대상으로 삼는다. 상태 준비 마우스·합성 자동과 실제 OS 입력을 분리하고 자연 VS02·공사·영업·첫 보고 전체 재완주를 추가 조건으로 만들지 않는다. 독립 실행/Design 판정은 별도 승인 대기다. DI03 A1+B1 정책 결정과 실제 사건·동/OD·수요/carry·소비·성공 재접수 HOLD, F08 선택과 최종 인증, 기존 한정 수용/PARTIAL·S3-10-C/S3-12·HQ/Owner 최종 인수를 구분해 유지한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
