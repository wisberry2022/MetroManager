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
