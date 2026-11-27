# DEV-027 — 키보드 접근·포커스/스크롤 잔여 착수·실행 검증 계획

- 작성: Development / AGT-DEV-0004 / 2026-11-22 KST.
- 상태: **LOCAL_PLAN_REVIEW / IMPLEMENTATION_AND_EXECUTION_AUTH_PENDING**.
- 기준 main: `1b80303636c5eddfbeddac9d288b0124b0093966` ([PR #175](https://github.com/wisberry2022/MetroManager/pull/175) 병합본).
- 로컬 브랜치: `codex/DEV-027-keyboard-focus-plan`. 이번 변경은 §7.1의 문서5개뿐이다.
- Owner 요청: “키보드 접근·포커스/스크롤 잔여 검증의 착수 범위와 실행·검증 계획을 로컬로 준비”. 추가 구현·GUI 실행·Commit·Push·PR은 별도 승인. main 병합 권한도 없다.
- [후속 근거 매핑](../evidence/DEV-027_GUI_REVIEW_FOLLOWUP.md), [기존 화면 계획](DEV-027_SCREEN_INTEGRATION_PLAN.md), [결과서](../tasks/DEV-027_RESULT.md) §15.
- 이 문서는 검토안이며 자체 APPROVED·제품 FAIL·PARTIAL 해소·DONE을 선언하지 않는다.

## 1. 기준점과 기존 증거 재사용

[Track A 결과](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075072443)의 정상 자연 VS02 관측 구간 PASS / 전체 PARTIAL, [Track B 결과](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075447846)의 관측18행 한정 수용 / PARTIAL2·신규 GUI NOT_RUN5를 보존한다. [DEV 회신](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075655059)은 PR175 제출 상태까지 게시됐다. 이번 원격 읽기에서 #146의 후속 Design 응답은 확인되지 않았다.

양 Track 시험 SHA는 `37596bd6d646f9d0454280477e60a2e652f06613`이다. 해당 SHA→현재 기준 main diff는 후속 문서5개뿐이며 scripts/tests/scenes/assets/project.godot 차이0을 확인했다. SHA 진전만으로 GUI를 반복하지 않는다. 기존 View225·회귀3120·로드 및 A/B 원본 무결성은 [후속 근거](../evidence/DEV-027_GUI_REVIEW_FOLLOWUP.md)와 [원 실행 색인](../evidence/DEV-027_SCREEN_INTEGRATION_EVIDENCE.md)의 **당시 검증**을 연결한다. 이번 계획 작성에서 게임 재실행·전체 패킷 재해시를 했다고 기록하지 않는다.

| 잔여 | 현재 인정 근거 | 이번 계획의 목표 / 종료 판단 |
| --- | --- | --- |
| A KEYBOARD / B06 접근 | A187/188·B040/041 시청 Tab/Enter, B121/122 복귀 후 Tab; 합성 Enter·읽기 무효과 자동 | 미관측 Control의 실제 도달/읽기/명시적 실행을 K01~12로 분리. 자동과 OS 판정 별도 |
| B06-02 PARTIAL | B062 P05→제안 복귀, B121/122 저장 보고 문맥/Tab, B124 일반 P07 첫 보고 버튼 진입 | 같은 focus의 사용자 스크롤과 지연 ensure/restore 순서를 F01~06으로 한정. 확정 결함 없음 |
| B05-05 고정 일1/중첩·복원 경쟁 | 기존 자동과 일4 관측, 과거 일1 미관측 | 공통 restore 변경 시 자동 영향만 확인. 일4 또는 fixture를 일1 독립 GUI PASS로 전용하지 않음 |
| B06-03·B02-04·B04-01~03·A DUPLICATION/RNG | 기존 자동/QUERY와 원 PARTIAL·NOT_RUN·NOT_VERIFIED | 현 작업 범위 밖. #92 지원환경/공급·최종 내부카운터·raw RNG·오류 주입을 추가 차단으로 편입하지 않음 |

## 2. 착수 단위와 승인 순서

1. **지금 완료할 범위:** 원격/소스/기존 단언의 정적 대조, 이번 계획·후속 기록·문서 검사. 구현·게임 자동·로드·GUI는 각각 NOT_RUN.
2. **A — DEV 자동 보완:** Owner가 §7.2의 8개 경로를 승인한 뒤 기존 `run_proposal_view_tests.gd`에 K/F 단언을 추가한다. 실제 Control·합성 입력·기존 fixture 사용을 명시한다. 제품 동작은 먼저 바꾸지 않는다. 결과를 로컬 검토로 제출한다.
3. **B — 결함이 확인될 때만 최소 수정:** 기존 합의 기대를 위반한 재현이 있어야 한다. `stage1_view.gd`가 원인인 경우 해당 경로를 추가하는 별도 승인(최대9개)을 요청한다. 다른 파일이 원인이면 정확한 경로·영향을 다시 제시한다. 소스 추정만으로 수정하지 않는다.
4. **C — 한정 독립 OS 관측:** A/B가 아래 공동 행의 필수/재사용 구분과 기대를 확인하고 Owner가 실행자·고정 시험본·행을 승인한 뒤 한 번의 공동 패킷으로 관측한다. DEV 자동 승인으로 독립 GUI 권한을 만들지 않는다. 안정된 신규 Control 접근만이면 A 결과 후 진행 가능하며 B 수정은 선행 필수가 아니다.
5. **D — Design 판정·HQ/Owner 인수:** 독립 실행자의 PASS_LOCAL을 A/B가 해당 행만 심사한다. 최종 인수는 별도다. Git 제출 및 main 병합도 각각 별도 승인이다.

기존 L2·정상 완주 전체 재승인을 요구하지 않는다. 아직 확인되지 않은 것은 미관측 목록/입력 순서에 대한 좁은 확인이며 A 자체의 정적 대조·기존 기대 자동 보완 전체를 중단시키지 않는다. 기대가 모호한 특정 F행은 관찰값을 먼저 남기고 합의 전 수용 단언을 확정하지 않는다.

## 3. K01~12 — 실제 Control 접근 목록

기준 소스: `scripts/ui/proposal_view.gd`의 `_ready/_button/_render_map`, `stage1_map.gd`의 `markers`, `stage1_view.gd`의 `_open_proposals/_open_construction/_return_reading`. Control 식별은 아래 dictionary key·노드명으로 하고 런타임 전체 NodePath를 증거에 저장한다. 생성된 역 버튼은 공급 snapshot의 ID를 열거한다. 고정 Tab 횟수나 미공급 승인 역명을 가정하지 않는다.

| ID | 대상·사전 상태 | 검증 입력과 기대 / 기존 증거 구분 |
| --- | --- | --- |
| K01 | Host `controls.open_proposals`; 정상 main 진입 | 창 활성화 이후 Tab/Shift+Tab으로 회사 제안에 도달·Enter로 진입. focus가 P-A에 놓여도 선택은 없음. 초기 포커스 확보를 마우스로 했다면 순수 키보드 진입으로 세지 않음 |
| K02 | `controls["P-A"/"P-B"]` (`Proposal_P-A/P-B`) | 순/역 Tab·Enter/Space. focus 이동만으로 선택하지 않으며 명시 활성화는 읽기 선택만. 기존 합성 P-B Enter/명령0 재사용, 실제 전수 도달은 미확인 |
| K03 | `station_buttons[id]` (`ProposalStation_<id>`)와 `map_view.markers[id]` (`Map_<id>`) | 실제 공급된 활성 역의 키보드 도달·가시성·안정 ID/동 읽기. 지도와 목록은 별도 도달 기록. 잠금 중 지도 비활성 역과 목록 정보 읽기 대체 경로를 구분. 마우스 접근으로 키보드 PASS 대체 금지 |
| K04 | `plan_list` (`ProposalPlan`); 편집으로 역2개 이상 | Tab 진입·방향키 선택, 역 정보/목록 선택 유지·모델 명령0. 내부 목록 스크롤과 바깥 ScrollContainer 이동을 구분. 실제 목록 이탈 Tab/Shift+Tab도 확인 |
| K05 | `name_input` (`ProposalName`), `controls.name` | 타이핑·좌우/Home/End/선택·삭제는 편집 필드가 처리. 이름 적용 전 사업 이름 불변, 적용 버튼만 명시 명령. LineEdit에서 바깥 읽기 키 탈취 금지. 기존 이름 type_text 실패를 PASS로 세지 않음 |
| K06 | `controls.add/remove/up/down`; 미포함역/중간역/경계역 | 각 버튼을 활성 상태에서 도달·한 번 활성화하여 기대 편집1회. 첫/끝 역 등 비활성 버튼은 skip·명령0. 같은 변경을 Enter와 Space로 중복 적용하지 않도록 전제/결과를 별도 기록 |
| K07 | `controls.predict`; 편집 가능·유효 노선 | 키보드 도달·명시 예측1회와 결과 읽기. 화면 읽기만으로 예측 반복0. A 기존 정보/예측 접근을 행 단위로 재사용하고 누락 키/Control만 보완 |
| K08 | `controls.submit_city_review` | A187/188·B040/041의 유효 Tab/Enter는 재사용. 미확인 역방향 접근·비활성 skip만 추가. 시청 전체 심사를 같은 목적으로 재반복하지 않음 |
| K09 | `controls.submit_government_review`, `submit_persuasion`, `sign_proposal_contract` | 각각 시청 승인 / 정부 보류 / 사업 허가 상태에서 도달·명시 입력1회. 접수·허가·실제 지급 구분. DI03 재접수 버튼·성공 분기는 제외 |
| K10 | `controls.construction` 및 P05 `controls.back` | 계약 효력 후 같은 사업 P05 진입·제안 복귀를 키보드로 한정 관측. 공사 실행/시험/개통은 불필요. 기존 B062 왕복은 재사용하고 입력 방식·지연 순서의 부족분만 확인 |
| K11 | `controls.refresh/back`, 제안에서 P06/P07 열기·저장 복귀 | 도달·명시 갱신/뒤로, 선택 슬롯/읽기 문맥 보존. 일반 P07 진입과 저장 문맥 복귀 구분. 기존 B121/122/124와 자동 증거 재사용 우선 |
| K12 | 제목 fallback `labels.title` (`Proposal_title`), 숨김/비활성 Control | 상태 전이 뒤 유효 focus와 가시 정보/행동 접근, 비활성·숨김 대상 skip, focus trap 없음. 제목은 행동 버튼이 아니므로 Enter로 명령을 요구하지 않음 |

K09의 3개 버튼 및 K03의 동적 ID는 결과에서 하위 행으로 펼친다. K01~12는 묶음 ID이며 “12개 Control 전체 PASS”라는 집계가 아니다. 자동은 시작 anchor에 한 번 focus를 줄 수 있으나 이후 도달 검사는 실제 이벤트 dispatch로 이동하고, 매 Control마다 `grab_focus()`를 호출해 접근 PASS를 만들지 않는다. 합성 Tab과 실제 OS Tab은 끝까지 별도 열로 기록한다.

순수 읽기/Tab에서 명령0, 명시 행동에서 지정 payload·명령1회를 검증한다. 자동은 호스트 시간 진행을 정지한 동일 snapshot의 전후 비교로 이력·RNG·지급 변화를 확인하며, 실제 GUI는 가시 상태/기존 로그까지만 판정한다. 자연 시간 진행에 따른 정상 변화까지 읽기 부작용으로 오판하지 않는다.

## 4. F01~06 — 같은 focus의 읽기 의도와 지연 순서

정적 사실: `_ensure_focus_region`은 1 process_frame 뒤 화면 generation/유효 owner를 확인한다. `follow_focus=false` 조기 종료는 construction 자식에만 있다. `_restore_reading`은 2 process_frame 뒤 screen/generation/owner가 같으면 저장 focus/scroll을 복원하지만 사용자 scroll/입력 세대는 검사하지 않는다. `read_construction_key`는 마우스 버튼(휠 포함 가능)을 follow_focus=true로, Home/End/Page를 false로 처리하며 LineEdit/OptionButton/TextEdit는 읽기 키 처리에서 제외한다. 이는 재현 필요 지점이지 결함 확정이 아니다.

| ID | 선행 이벤트 → 입력 순서 | 기대·관측 지점 |
| --- | --- | --- |
| F01 | 정상 키보드 focus 이동 또는 비활성화 fallback → 무입력 → 레이아웃 안정 | 유효 대상이 가시영역에 들어옴. P07 일반 진입은 첫 보고 버튼 가시성이 기준이며 scroll0 강제 금지 |
| F02 | proposal의 ensure 예약 → **owner 유지** → Home/End/PageUp/PageDown → callback 전후 | 읽기 입력이 처리된 이후 늦은 자동 추적이 사용자 위치를 되돌리는지 확인. 무입력 F01과 구분. LineEdit/목록 내부 처리·수정키 조합도 따로 기록 |
| F03 | 같은 ensure 예약 → owner 유지 → 바깥 스크롤 위 실제 wheel up/down → callback 전후 | 유효 범위 안에서 사용자 이동이 실제 발생했는지 먼저 증명. 끝점 clamp/비스크롤 상태는 무효 사례. 마우스 클릭에 의한 다른 focus 이동과 혼동하지 않음 |
| F04 | P05→제안 또는 제안→P07→제안 저장 복귀 예약 → owner 유지 → 읽기 키/휠 | 무입력 / 첫 frame 전 입력 / 첫 frame 후·둘째 전 입력 / 복원 완료 뒤 입력을 분리. scope·선택·저장 문맥은 유지하고 늦은 복원이 새 읽기 위치를 덮는지 관찰 |
| F05 | 같은 복귀 예약 → 다른 Control로 Tab 또는 다른 화면 전이 | 기존 `return_respects_user_focus` 재사용/확장. 새 owner/화면의 focus·scroll을 이전 callback이 덮지 않음. 기존 Session 수명 검증을 OS 수용으로 확장하지 않음 |
| F06 | 읽기 완료 → 사용자가 새 Tab/Shift+Tab으로 이동; 보고 일반 진입/저장 복귀 | 자동 추적 재개로 새 focus가 보임. 저장 복귀와 일반 진입의 서로 다른 기대 보존. F02~04를 고치느라 필요한 focus 가시성을 잃지 않음 |

위 “명시적 사용자 읽기 우선”은 기존 읽기 키 주석·사용자 focus 존중 계약을 근거로 제안한다. **같은 owner의 휠 vs 복원 우선순위**의 구체 판정은 Track B가 해당 F행을 확인해야 하며 Track A는 명령/사업 무효과를 확인한다. 다른 기대가 필요하면 `docs/templates/RFC_AND_DECISION.md`에 따라 해당 행만 질의한다. 현 단계에 새 기획 규칙 변경 요구는 없다.

자동 관측은 frame 경계 전후의 owner NodePath, screen/scope/navigation generation, follow_focus, scroll값·최대값/page, 실제 입력 처리 여부, 관련 Control/viewport rect, before/after snapshot·command count를 **검사 파일의 결과**에 남긴다. 제품 진단 로그 확장은 포함하지 않는다. 입력 주입 자체가 바깥 휠 처리를 유발하지 못하면 `NOT_VERIFIED/INCONCLUSIVE`로 남기며 직접 scroll 할당은 restore의 구성요소 시험으로만 분류한다. 의도한 assertion이 실패한 경우만 FAIL이며 미관측·clamp를 성공으로 세지 않는다.

## 5. 승인 후 DEV 실행·검증 순서와 명령

### 5.1 자동 단계

- 새 격리 worktree에서 시험 full SHA 또는 base+변경파일 SHA256, 엔진4.7.2 식별, 입력 fixture와 실제/합성 구분을 고정한다. 현 계획 문서 기준을 최신 게임 실행 증거로 전용하지 않는다.
- 정상 진입은 기존 `scenes/main.tscn`; 자동은 기존 Host/FX를 쓴다. K01의 main 초기 focus 경로와 나머지 fixture의 설정용 API/시간 환산을 구분한다. 새 runner·새 seed 탐색·모델 변경 없음.
- 기존 `tests/game/run_proposal_view_tests.gd`에만 K/F 검사·진단을 보완한다. 기존 View225 단언 및 다른-owner 보호를 유지한다. unsupported `--case` 등의 새 CLI 필터를 가정하지 않고 해당 runner 전체를 한 번 수행한다.
- 각 경합은 초기 상태를 새로 구성하여 무입력 대조군과 같은/다른 owner 입력군을 분리한다. process_frame을 기다린 결정적 자동 재현과 OS의 사람 입력 타이밍을 분리한다.
- 기대 위반 발견 시 실패 raw/입력/frame 기록을 보존하고 원인·최소 수정 경로를 로컬로 보고한다. 확인 전 제품 수정/수용 판정 변경 없음.

다음은 **향후 승인 후 명령 형식**이다. `<Godot>`는 기존4.7.2 console 실행 파일, `<worktree>`는 격리 시험본이다. 각 run은 새 출력 디렉터리를 쓰고 stdout/stderr/exit/결과 JSON을 보존한다. 아직 실행하지 않았다.

```text
.venv/Scripts/python.exe tools/policy.py doctor
<Godot> --headless --path <worktree> --editor --quit
<Godot> --headless --path <worktree> --script res://tests/game/run_proposal_view_tests.gd -- --output=<fresh-run>/proposal-view.json
.venv/Scripts/python.exe tools/policy.py check
git diff --check
```

headless import/로드의 exit0만으로 오류0을 판정하지 않는다. SCRIPT ERROR/ERROR·출력 저장 성공·기대 assertion ID/실행 개수·failures0·exit를 함께 확인한다. deliberate failure exit 검사는 harness의 실패 집계/저장 경로를 바꾼 경우에만 기존 `--verify-failure-exit`로 별도 실행한다. 현재 harness의 기존 exit1 증거는 재사용한다.

### 5.2 제품 수정 시 직접 영향 회귀

| 실제 변경 | 추가 실행 후보·이유 |
| --- | --- |
| 검사 파일만 보완 | View 전체 + 해당 import/프로젝트 로드, 정책. 변경 없는 W04B437·proposal UI165·VS02 75·전체 자연 완주는 재사용 |
| Host ensure/restore/read key 수정 | `run_operations_gui_cases.gd -- --auto` (일반/저장 복귀·사용자 focus), `run_construction_ui_tests.gd` (공유 읽기 키/ensure), `run_s01_exception_tests.gd` (scope/generation·무효/복구·수명), View 전체 및 최종 로드 |
| 다른 제품 파일·명령/시간/Session까지 영향 확장 | 이번 경로 밖. 정확한 파일·영향 행·필요 회귀를 다시 제시하고 해당 변경 승인 전 착수하지 않음 |

위 회귀의 실제 명령은 공통 `<Godot> --headless --path <worktree> --script res://tests/game/<파일>`이고 operations GUI에는 `-- --auto`를 반드시 붙인다. `run_s01_exception_gui_cases.gd`는 실제 GUI용이므로 자동 회귀 명령으로 사용하지 않는다. 기존 UID/원 테스트 소스는 수정하지 않는다. 게임 플레이·빌드/export·성능은 포함하지 않는다.

## 6. 독립 GUI 공동 패킷과 최소 실행안 — 별도 승인

### 6.1 Track A/B 확인 사항

| 담당 | 이번에 필요한 좁은 확인 | 재확인하지 않을 것 |
| --- | --- | --- |
| A | K01~12 중 실제 기능상 필수 Control/전이, 명시 행동1회·읽기0, seed2/8 상태 준비의 최소 종료선 | 수용된 자연 VS02 사업 완주·P3-A 공급 전체 |
| B | K03 지도/목록 접근의 대체 허용 여부와 동적 하위 행; K04/05 필드 내부 읽기; F02~04 같은 owner 입력 우선순위; 가시성/복원 기대 | B관측18행·기존 P07 일반/저장 문맥 결정·#92 최종 규격을 새 선행조건화 |
| Owner | A 자동8경로, 필요 시 B 제품1경로 추가, C의 실행자·고정본·공동 행별 OS 범위를 각각 승인 | 이 계획의 문서 검토만으로 구현/GUI/Git/Stage 승인 생성 |

현 목록은 DEV 제안이며 A/B 확인 회신은 아직 없다. 새로운 게시·다른 에이전트에 메시지 전송은 하지 않는다. 실제 요청이 필요하면 Owner의 게시 지시에 따라 한 공동 목록으로 전달한다.

### 6.2 준비·실행·중단

- 고정본·DEV 결과·알려진 실패/미관측·K/F 하위행표·기존 캡처/로그 링크를 한 패킷에 제공한다. 실행자와 DEV 구현/검증·Design 심사를 구별하고 같은 계정의 사람 수준 독립성은 인증하지 않는다.
- 기존 게임 프로세스나 저장 상태를 재개할 수 있다고 가정하지 않는다. 정상 UI를 사용할 경우 기존 `-- --w04b-seed=2`를 초기화1회 적용해 K01~08·정부/계약·P05 복귀까지만 도달하고, 필요하면 seed8 별도 실행에서 설득 버튼까지 도달한다. 엔진 기본 경로 `<Godot> --path <worktree> -- --w04b-seed=2` / seed8. 성공 주입·새 seed 탐색 없음.
- K09 상태 준비를 위한 심사/계약까지의 정상 진행과 **사업 전체 완주**를 구별한다. HUD 정지/재개/기존 배속으로 준비하되 측정 구간은 순수 키보드/휠을 구분한다. 표준 공사→시범/안전→개통·첫 보고 전체를 다시 수행하지 않는다.
- P07 기존 B121/122/124는 우선 재사용한다. Host 수정으로 P07 직접 영향이 확인되면 해당 전이만 후속 OS 후보로 올린다. 기존 `run_operations_gui_cases.gd -- --case=first_report`는 **MODEL_CHAIN_SETUP** 시험이며 정상 자연 VS02·일1의 대체가 아니다. 정확한 제안 왕복 상태 공급은 미확인이므로 실행 수단/행을 확정하기 전 이 명령을 W04B 신규 GUI 계획에 자동 편입하지 않는다.
- 창 조건은 기존 관측 조건 또는 Owner가 지정한 한 조건을 run별 기록한다. 엔진/렌더러·window/client/viewport·가능한 DPI를 구별하고 미측정은 NOT_VERIFIED. 모든 창/DPI/폰트·아트 인증을 추가하지 않는다.
- OS 증거는 입력 순서/시간, 화면 전후, 실제 owner(가능한 기존 로그), scroll 이동, 상태·명령 결과와 raw 로그를 함께 남긴다. 기존 FOCUS 로그는 ensure 이후 특정 시점이며 모든 휠/복원 callback의 입력 세대·정확한 프레임은 노출하지 않는다. “정확히1/2프레임 경합을 OS로 재현했다”는 주장은 동기화 증거가 있을 때만 한다.
- OS 시간 해상도가 부족하거나 필요한 활성 상태를 얻지 못하면 해당 행만 INCONCLUSIVE/NOT_VERIFIED로 종료한다. 무한 재시도·타이밍을 맞출 때까지 전체 재완주·새 runner/제품 계측은 하지 않는다. 계측이 필요하면 실제 부족 필드와 정확한 변경 경로를 별도 제출한다.

### 6.3 증거 형식·종료선

각 하위 행은 `ID / 시험SHA·파일해시 / 실제·합성·fixture / 전제상태 / 입력·frame·시각 / 기대 / 실제 / raw·캡처·해시 / DEV 또는 실행자 판정 / Design 판정 / 남은 한계`를 가진다. raw는 새 run ID의 `.local/validation/DEV-027/keyboard-focus/<run-id>/`에 보관하며 공개 문서는 최소 색인/집계로 한다. 기존 A/B ZIP·JPEG/PNG·manifest·실패·정정문·기존 자동 JSON을 덮어쓰지 않는다.

종료는 승인된 K/F 하위 행별 PASS 또는 특정 미확인/보완 사유·담당·적용 시점까지 기록된 로컬 결과다. 기능적 기대 위반은 해당 행 FAIL, 증거 부족은 INCONCLUSIVE/NOT_VERIFIED, 권한/상태 미확보는 NOT_RUN이다. 합의된 필수 행이 남으면 그 행의 수용만 대기한다. 자동 PASS로 A KEYBOARD/B06-02 PARTIAL을 지우지 않으며 Design이 증거를 수용한 행만 후속 갱신한다. “필수 미충족0”은 공동 필수 목록과 실제 판정 없이는 선언하지 않는다.

## 7. 정확한 변경 경로와 승인 표

### 7.1 이번 실제 로컬 문서5개

1. `docs/engineering/gate3/DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md` — 신규 본 계획.
2. `docs/engineering/gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md` — 잔여 계획 연결·과거 기록 보존.
3. `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md` — 이번 계획 권한·실행 제외.
4. `docs/engineering/tasks/DEV-027_RESULT.md` — 문서 검증·현재 NOT_RUN·검토 요청.
5. `docs/engineering/tasks/DEV-027_PROVENANCE.json` — 위4개 문서의 base·출처·blob. 이전 manifest는 PR175 병합본에 보존.

### 7.2 향후 A 자동 보완 후보 — 최대8개, 아직 미승인

| 번호 | 경로 | 변경 목적 |
| --- | --- | --- |
| 1 | `tests/game/run_proposal_view_tests.gd` | K/F 합성 접근·지연 순서 단언·결과 진단. 기존 harness/UID 사용 |
| 2 | `docs/engineering/gate3/DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md` | 실제 승인·실행 조건 후속 |
| 3 | `docs/engineering/gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md` | 해당 단계 연결 |
| 4 | `docs/engineering/evidence/DEV-027_KEYBOARD_FOCUS_EVIDENCE.md` | 신규 증거 색인·한계 |
| 5 | `docs/engineering/evidence/DEV-027_KEYBOARD_FOCUS_RESULTS.json` | 신규 하위행 결과·raw 해시·구분 |
| 6 | `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md` | 유효 범위와 후속 상태 |
| 7 | `docs/engineering/tasks/DEV-027_RESULT.md` | 결과·미해결 |
| 8 | `docs/engineering/tasks/DEV-027_PROVENANCE.json` | 해당 제출 산출물 출처 |

B 조건부 제품 수정 후보는 `scripts/ui/stage1_view.gd` **1개 추가(고유 최대9개)**이며 A의8개 승인에 자동 포함하지 않는다. proposal_view·stage1_map·씬·fixture·새 runner·공유 도구/정책/CI·데이터·DI03·다른 부서 문서는 변경 제외다. 다른 경로 필요 시 그대로 멈추고 최소 변경안만 준비한다. .gd.uid는 기존 파일을 보존한다.

| 행동 | 현재 권한/상태 |
| --- | --- |
| 위5개 로컬 계획 문서·정적 대조·문서 정책 검사 | 이번 Owner 지시로 수행 |
| A 자동 보완8경로·게임 자동·프로젝트 로드 | 별도 착수 승인 필요 |
| B 제품1경로 수정·그 영향 검증 | 재현/기대/범위 확인 후 별도 승인 필요 |
| C 독립 OS GUI·새 계측/runner | 실행 범위 별도 승인; 새 계측/runner는 현재 후보에도 제외 |
| Commit·Push·PR·#146 등 원격 게시 | 별도 승인 필요. PR175 당시 권한 재사용 안 함 |
| main 병합·최종 인수·이슈 종료·릴리스 | 별도 승인, 수행 없음 |

## 8. 이번 문서 검증과 유지 상태

`policy.py doctor/check`, 신규 문서 포함 텍스트/경로/링크·provenance 검사, 기존3개 Markdown prefix와 비변경 추적파일/공유 수정 데이터2개 보존 검사를 수행하고 결과서 §15에 기록한다. 원격 읽기·소스 정적 대조는 제품 검증이 아니다. 이번 게임 자동 테스트 / Godot 프로젝트 로드 / 실제 게임 플레이 / DEV·독립 GUI / 자연 VS02 / 빌드·export / 성능·새 계측·반입은 각각 **NOT_RUN**이다.

DI-03 정책 선택 완료와 실제 사건·수요/carry·소비·성공 재접수 HOLD를 구분한다. DEV026 한정 수용·PARTIAL·일1 미관측·P07 구분, #92 FINAL_SPEC_PENDING/F08-01~04 OPEN, 기존 A/B PARTIAL·NOT_RUN·NOT_VERIFIED와 S3-10-C·S3-12/HQ·Owner Stage 최종 인수 대기를 유지한다. 문서 검토 결과와 다음 실행 승인 요청을 분리하며 현재 로컬 산출물5개부터 Owner 검토를 요청한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 9. Owner 착수·PR 제출 승인 — 2026-11-22

Owner의 후속 원문(본 개발 대화): “개발 에이전트. 계획서를 승인합니다. 계획서대로 구현 진행하고 PR까지 생성해주세요”. 이 요청에 따라 §7.2의 A 자동 보완8개 경로 구현·게임 자동/프로젝트 로드 검증과 정상 Commit·Push·PR 생성·필수 CI 확인을 수행한다. 로컬 계획 단계의 미승인/미제출 표기는 당시 이력이다.

대상 저장소는 wisberry2022/MetroManager, 작업 DEV-027, 브랜치 codex/DEV-027-keyboard-focus-plan, base main이다. 유효 범위는 이번8개 산출물의 제출과 같은 범위 검수 대응까지이며 main 직접 수정·병합·강제 push·릴리스/배포 권한은 없다. B의 제품1개 추가와 C 독립 GUI는 본 계획대로 별도 승인 대상으로 유지한다. #146 신규 댓글 게시도 이번에는 수행하지 않는다.

같은-owner 입력 우선순위의 Design 기대는 미확정이다. 자동으로 확인 가능한 기존 계약은 단언하고, 그 외 F행은 실제 입력 성공·frame/owner/scroll·제안 기대 충족 여부를 함께 기록하여 OBSERVED_REVIEW_REQUIRED 또는 INCONCLUSIVE로 제출한다. 관측 완료를 기능 수용 PASS로 바꾸지 않으며 확정된 계약 위반의 실패는 은폐하지 않는다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 10. A 실행에서 재현된 필수 실패와 B 최소 수정 검토 — 승인 요청 전 초안

시험: `keyboard-focus/view-02`, 기준 main1b80303 + runner SHA256 `f6ea362eead9471e7478c2a9557a642ca409b16aec6f3d92e0ed8c02e81d7c92`. headless 실제 Control/합성 입력709단언 중47실패, SCRIPT ERROR0, exit1이다. PASS나 Design 수용으로 제출하지 않는다. 개발 중 검사 오류로 중단된 view-01은 별도 보존한다.

| 발견 | 구체 증거 | 최소 조치 후보 |
| --- | --- | --- |
| K12 제안의 비활성 Control에 Tab 도달 | 편집 상태8개 + seed2/8 잠금 상태 각17개 =42실패. Proposal_add/down/predict/심사/계약/P05 및 잠금 지도 버튼. 활성화 명령 발생 여부와 구분 | Host에서 **제안 화면의 Tab 입력 직전** 현재 Button.disabled에 맞춰 focus_mode를 갱신하고 빈 계획 목록도 skip. 슬롯/역 정보 선택이 View 내부에서 즉시 바뀌는 경로도 반영 |
| K12 순환 중 공통 HUD resume | 3개 추가 실패. 이번 제안 Control 경로 밖의 기존 HUD 속성 | 테스트의 필수 단언 대상은 제안 subtree로 한정하되 HUD 관측3개는 별도 OUT_OF_SCOPE로 보존. HUD 제품 수정·PASS 선언 없음 |
| F01 무입력 저장 복귀 뒤 추가 scroll 이동 | P05→제안: 저장462→복원462→지연 ensure178. P07→제안: 저장215→복원215→178. owner는 복원 뒤 P-A | proposal의 지연 ensure도 construction과 같이 follow_focus=false를 존중하여 저장 복원/읽기를 덮지 않도록 함 |

B 수정 대상은 **`scripts/ui/stage1_view.gd` 1개 추가**, 기존8개와 합쳐 최대9개다. 검토용 diff는 로컬 `.local/validation/DEV-027/keyboard-focus/stage1_view.proposed.patch`에 준비하며 아직 제품 파일에는 적용하지 않는다. UI 모델/명령·경제·시간·DI03·폰트/규격은 변경하지 않는다. 공통 HUD resume 동작·비활성 시각 표현도 수정하지 않는다.

같은-owner Home/End/Page 입력 뒤 ensure 또는 restore가 덮는 관측도 별도로 있다. proposed priority의 Design 판정은 계속 대기하며 이번 최소 수정은 **확정한 제안 Tab skip와 무입력 저장 복귀**에 우선 한정한다. 제안 ensure의 follow_focus 존중은 처리된 읽기 키도 보존하지만, restore 전에 같은-owner 입력을 취소 세대로 관리하는 확장과 실제 OS 휠은 이번 최소 수정의 자동 포함 범위가 아니다. 휠 합성은 이동이 성립하지 않은 행이 있어 INCONCLUSIVE이며 실제 휠 재현 PASS로 표시하지 않는다.

승인 후 View 전체, operations GUI `--auto`, construction UI, S01 exception 자동 회귀와 Godot 최종 로드·정책 검사를 실행한다. 독립 GUI·Design 수용·main 병합과 기존 HOLD/PARTIAL은 그대로 별도다. 실패를 삭제하거나 green으로 낮추기 위해 테스트를 완화하지 않는다. 적용 뒤 새 source hash로 검사하며 view-02 원본은 그대로 유지한다.


## 11. B 제품1개 추가·수정 검증·PR 승인 — 2026-11-22

Owner는 §10의 추가 경로·두 최소 수정·회귀와 제출 요청에 “제품 1개 추가·수정 검증 및 PR 승인”으로 명시 응답했다(본 개발 대화의 승인 응답). §7.2의8개에 `scripts/ui/stage1_view.gd`를 추가하여 **정확한9개 경로**로 구현·검증하고 §9의 브랜치에서 Commit·Push·PR·필수 CI를 진행한다. §10의 미적용·승인 요청 표시는 당시 이력으로 보존한다.

구현은 Tab/Shift+Tab 입력 직전 제안의 비활성 버튼·빈 목록을 순회 대상에서 제외하고, 제안 지연 ensure가 follow_focus=false를 존중하도록 한정한다. 파일 길이 기본 규칙을 만족시키기 위해 같은 파일의 포커스 진단 dict 출력과 fallback 지역 참조를 정리하되 로그 필드·fallback 순서·행동은 유지한다. 정책/CI나 검사 상한을 바꾸지 않는다.

실제 OS 입력·독립 GUI 실행/Design 수용, 같은-owner restore 입력 취소 세대 확장·휠 우선순위 확정, main 병합·#146 게시·DI03·기존 PARTIAL/최종 인수는 승인 범위 밖이다. 수정 전 view-03-pre-fix의745단언/44실패(제안42·무입력 복귀2)와 raw·runner·소스 해시를 보존하며, 이후 수정본 결과는 [별도 증거](../evidence/DEV-027_KEYBOARD_FOCUS_EVIDENCE.md)로 연결한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 12. #146 Track A 재현 후속·PR177 반영 — 2026-11-22

Owner 최신 지시: “146번 이슈에 다른 확인사항이 등록되었으니 확인하여 수정한뒤 방금 등록한 PR에 포함시켜주세요”(본 개발 대화). [Track A 결함 전달](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7076149744)의 K01-12/13/14 실제 이동 경로 및 K01-04 목록 가시성을 확인·보완하고 기존 PR177에 정상 Commit·Push한다. Design 댓글 자체를 권한으로 사용하지 않으며 이번 Owner 지시를 후속 수정·제출 근거로 삼는다. main 병합·독립 OS GUI·DI03 구현은 포함하지 않는다.

PR 초기 head4f18678의 Tab 수정은 이미 비활성 버튼을 제외한다. 추가 자동 검사는 이름→제거, 정부 요청 대기/심사 중의 다음 유효 Control, 허가 시 재조회→역Tab→계약, 보류 시 재조회→역Tab→설득·예측→시청→설득을 **한 번의 Tab 직후 및 Host.present 뒤** 비교한다. 시작점 준비는 합성 Tab, 명시 실행은 Enter/Space이며 목표 직접 grab_focus·pressed 신호로 이동을 대체하지 않는다. 상태 준비의 기존 fixture·시간 환산은 구분한다.

K01-04는 기존9경로 검사에서 실제 선택S12·목록 scroll0·마지막 행 y139/높이27·목록 높이130으로 잘림을 재현했다. 필요한 최소 제품 수정은 `scripts/ui/proposal_view.gd`의 현재 선택 재설정 제어다. 기존 `_render_map`이 이미 선택된 행을 deselect/select하여 키 입력의 자동 가시화 요청을 취소하는 경로를 보완한다. **이번 #146 수정 지시에 필요한 이 파일1개를 추가하여 PR 전체10경로**가 된다. §7/11의9경로는 직전 제출 이력이며 포괄 신규 기능 승인이 아니다. Host source·유효성 검사·명령 허용 상태·기획 규칙은 추가 변경하지 않는다.

변경 경로는 §7.2의8개 + §11의stage1_view.gd + 이번proposal_view.gd다. 이번 후속 실제 수정은 그 중 Host를 제외한9개이며 계획/결과·증거는 원문 뒤에 추가한다. JSON의 기존 실행 자료도 별도 후속 객체로 보존한다. 공개 Git에는 Design 원본 ZIP/캡처/로그·개인 절대경로를 추가하지 않는다.

검증은 동일 runner의 전체 수정 전/후 대조, 선택 행의 내부/외부 clipping·명령 무효과, S01 예외/수명 회귀, headless 프로젝트 로드, policy/문서·provenance/원본 무결성 및 PR 두 필수 CI로 한정한다. Host 변경이 없으므로 직전 operations271/construction898/S01334의1503회귀는 당시 증거이며 이번 재실행 수와 합산하지 않는다. F01 OS 경쟁은 INCONCLUSIVE, F04 자동5행·휠/return10행은 기존 상태로 유지한다.

main이 PLN-019 문서7개로 d8b6f4a에 진전하여 GitHub 무충돌 Update branch를 사용했다. 서버 sync `325b54a0ab45d297add709238a80f881c899912d`는 부모4f18678/d8b6f4a의 정확한 clean tree로 preflight `work=1, verified_base_sync=1` PASS를 확인했다. 제품/테스트 차이0이며 새 기획 문서를 이번 구현 규칙 변경 승인으로 간주하지 않는다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 13. K01 A/B 수용 및 F04 잔여 계획 연결 — 2026-11-27

PR177은 b0447defe57abe173d10dcc05784f79313ff69ca로 main에 병합됐다. [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7077287550)와 [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7077351699)가 해당 SHA의 K01-12/13/14 실제 접근·명시 실행, K01-04 마지막 행, P05 안정 복귀/읽기를 관측 범위에서 수용했다. §12의 OS/Design 대기는 당시 이력이며 [증거 §7](../evidence/DEV-027_KEYBOARD_FOCUS_EVIDENCE.md)의 후속 판정을 연결한다.

전체 PARTIAL·F01 RACE·F04 same-owner restore5행·INCONCLUSIVE10·B06-02 잔여는 유지한다. Track B가 읽기 우선 기대를 명확히 했으므로 §9~11의 당시 기대 미확정과 구분하고, 실제5행 전제/관측을 [새 F04 계획](DEV-027_F04_RESTORE_PLAN.md)에 연결했다. [공동 잔여표](DEV-027_RESIDUAL_DISPOSITION.md)는10행의 필수성/대체증거/차단시점을 구분한 DEV 검토안이다.

이번 Owner 요청은 로컬 문서7개의 작성·정적 대조만 승인한다. 향후 최대10경로는 새 계획 §6.2의7문서+Host1+기존View검사1+새F04결과JSON1이며 구현·게임검증과 Commit·Push·PR은 별도다. 새 독립GUI·제품계측/runner·main병합·#146게시·DI03 보류 해제를 포함하지 않는다. 기존 실행과 실패/정정·수용 원본은 보존하며, 수용된 K01/자연VS02 전체 반복을 추가하지 않는다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 14. F04 키5행 로컬 보완·휠 전제 후속 — 2026-11-27

Owner의 최대10경로 로컬 구현·검증 승인을 [F04 계획 §8](DEV-027_F04_RESTORE_PLAN.md)에 기록했다. 최근 유효 읽기 세대로 오래된 저장 복원을 취소하는 최소 보호를 적용했다. 동일 runner 집중 전후209/6→209/0, 전체846/0, 원818 JSON 단언 보존(출력 저장 단언은 별도1개)이다. 결과·회귀·로드·해시는 [새 실행 JSON](../evidence/DEV-027_F04_RESTORE_RESULTS.json)과 [결과 §19](../tasks/DEV-027_RESULT.md)에 연결한다.

기존 NOT_RUN/수용 기록은 해당 당시 상태로 유지한다. 이번에는 DEV headless 자동/회귀/프로젝트 로드만 수행했고 독립 GUI/자연VS02/플레이·빌드/export/성능은 NOT_RUN이다. INCONCLUSIVE10의 새 전제는 [처분표 §5](DEV-027_RESIDUAL_DISPOSITION.md)에 별도 추가했다. 키5행 수정으로 휠4행의 실제 덮어쓰기·null-owner 휠2행의 적용 판단을 종료하지 않는다. 휠 제품 확장·원격 제출 및 DI03/최종 인수 권한을 확대하지 않는다.


## 15. 제출 및 독립 GUI 대기 — 2026-11-27


Owner의 이번 제출 승인 원문: “독립 GUI Commit, Push PR 생성까지 승인합니다”. 실행 주체 확인 후 선택: “Design Track A/B의 독립 GUI 실행 대기”. 승인된10경로의 Commit·Push·PR 및 필수 CI 확인을 진행한다. 독립 GUI는 Design 대기이며 DEV GUI를 독립 실행으로 대체하지 않는다. main 병합·휠 제품 확장·DI03 보류 해제는 승인 범위에 포함하지 않는다. 이번 #146 댓글 게시는 수행하지 않는다.

[F04 계획 §10](DEV-027_F04_RESTORE_PLAN.md)과 [공동 처분표 §6](DEV-027_RESIDUAL_DISPOSITION.md)에 최신 B2/A2 적용을 추가했다. return 휠2행을 포함한 휠6행의 보완 잔여가 있으며, 이번 제출은 소스/검사 실행본을 변경하지 않는다.
