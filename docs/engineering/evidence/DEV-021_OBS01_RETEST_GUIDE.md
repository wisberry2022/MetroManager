# DEV-021 OBS-01 독립 재검수 입력

담당 AGT-DEV-0001. Issue #77 OBS-01에 한정하며 Design A02-11/A01-Q12의 최종 판정은 Design이 수행한다.

## 자동 검사

저장소 루트에서 Godot 4.7.2 console 실행 파일을 사용한다.

```text
Godot --headless --path . --script tests/game/run_construction_ui_tests.gd -- --obs01-only --obs01-evidence
Godot --headless --path . --script tests/game/run_construction_ui_tests.gd
Godot --headless --path . --script tests/game/run_w07_tests.gd
Godot --headless --path . --script tests/game/run_tender_ui_tests.gd
```

첫 명령은 새 OBS01_CASES의 fixed 부분만 갱신한다. 원 DEV-021_CASES를 쓰는 `--evidence`는 사용하지 않는다. baseline은 수정 전 UI와 새 하네스의 자체 관측이다. 374개 검사의 통과와 잘림 6건을 함께 읽는다. 수정 후 포커스 725개/전체 UI 898개와 각 종료 코드를 VALIDATION에서 대조한다.

## 실제 GUI

1. 정상 프로젝트 실행 후 B01 응찰→낙찰·정부 지급→P05→공사 화면에서 표준 계약·착공·시범·안전·개통을 실제 조작한다. 시간 대기는 배속으로 처리하고 테스트 fixture와 구분한다.
2. 보조 GUI는 아래처럼 실행한다. `TEST_ONLY` 표식을 유지한다. FOCUS_POST_REPAIR는 T3432, 빠른 공사 수리 후 안전 재시험 가능/개통 불가다. FOCUS_OPEN_READY는 T3493, 재시험 통과/개통 가능이다. 둘 다 C1060000/R60000/F1000000/K0/B0이다.

```text
Godot --path . --script tests/game/run_construction_gui_cases.gd -- --case=FOCUS_POST_REPAIR --small
Godot --path . --script tests/game/run_construction_gui_cases.gd -- --case=FOCUS_OPEN_READY --small
```

3. 마우스 스크롤 없이 최초 Tab으로 상단 fixture 선택에 포커스한 뒤 Shift+Tab으로 마지막 개통 버튼에 이동한다. 버튼 테두리와 바로 아래 허용/거부 사유가 함께 보이는지 확인한다. 비활성 개통은 계속 비활성이고 Enter가 경제 상태를 바꾸면 안 된다. 활성 개통 Enter는 정지 중 명령 대기로 구분된다.
4. Tab/Shift+Tab 양방향으로 순회하고, 최대화→복원·재조회·사업 인계 복귀→재진입을 확인한다. 완료 게임분·명령 ID·효력분과 원장을 함께 기록한다.
5. 자동 하네스는 raw 1104×900, 1280×720, 1280×960에서 세 상태·양방향 이동·재조회·복귀 및 상태 불변성을 검사한다. 실제 GUI 직접 검수와 자동 입력을 혼동하지 않는다.

`--small` raw Window는 1104×900이다. OS 배율과 Godot stretch 때문에 캡처나 viewport와 같지 않다. effective window DPI는 NOT_VERIFIED이며 새 제품 최소 해상도를 승인한 것이 아니다.

## 화면 증거

- [보완 전 자체 재현](DEV-021_OBS01_BEFORE_SMALL.png): 원 QA 캡처와 동일 조건이라고 주장하지 않는다.
- [보완 후 비활성 개통과 사유](DEV-021_OBS01_AFTER_SMALL_DISABLED.png)
- [보완 후 활성 개통과 사유](DEV-021_OBS01_AFTER_SMALL_ACTIVE.png)
- [실제 제품 복귀 포커스](DEV-021_OBS01_AFTER_RETURN.png)

캡처는 게임 창만 저장하며 원 JPEG를 픽셀 내용 변경 없이 PNG로 변환한다. 원본·변환본 해시와 크기, 로그 발췌는 VALIDATION에 기록한다. 실제 수행 여부와 미실행 항목은 해당 JSON을 정본으로 읽는다.
