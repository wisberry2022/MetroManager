# DEV-021 W05 최소 공사 UI

- 담당: AGT-DEV-0001 / Development / LAPTOP
- 상태: REVIEW_REQUESTED / Owner 병합·Design 독립 검수 대기
- 기준 main: 7735ccff22952dabdf1371c2b29d81b620f4a9c0
- Issue: https://github.com/wisberry2022/MetroManager/issues/77
- 브랜치: codex/DEV-021-construction-ui
- 승인 패킷: https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6720044883

## 실행 권한

Owner의 현재 개발 세션 원문:

> 개발 에이전트. Issue #77의 DEV-021 최소 W05 UI 구현 및 승인 패킷에 명시한 24개 경로의 Commit·Push·PR 생성을 승인합니다. 기존 Owner 정책과 Design L2 협의 내용을 유지하며 티켓 범위만 작업하고 검증 후 PR 생성해주세요. main 병합은 별도 승인하겠습니다.

위 패킷의 코드·씬·테스트·문서/증거 작성과 자동/프로젝트 로드/GUI 검증, 검증 후 Commit·일반 Push·PR 생성 및 같은 범위 검수 보완을 해당 작업 종료/승인 철회까지 수행한다. main 병합·릴리스·강제 Push·정책/명세 변경은 제외한다. 루트 및 타 worktree 작업물을 보존하며 독립 worktree에서 작업한다.

## 승인 입력과 포함 범위

- Owner R01~03 최종 결정: https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6719007539
- Planning 최종 인계: https://github.com/wisberry2022/MetroManager/issues/76#issuecomment-6719012772
- Design L2: https://github.com/wisberry2022/MetroManager/issues/76#issuecomment-6719880336
- Design A-02: https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6718094462
- 선행 DEV-020 PR #95 및 DEV020-W05-UI-1을 동일 Pipeline/원장/시각으로 소비한다.
- 유효 사업 인계 → 표준/빠른 공사계약 → 착공 → 기성/공정 → 부족·재개 → 시범 → 안전 → 결함 수리·재시험 → 개통.
- 계약/지급/착공의 효력 시각, 발생/지급/공사 미지급, 운영비 B, 수리 지급을 구분한다.
- DEV020-GUI-01의 공기 기산 문구를 실제 착공 효력 기준으로 정합화한다.
- 공정 원값의 경과/전체 게임분 및 현 절차 시각만 표시한다. 공급되지 않는 과거 이력·결함 enum·과거 R/A 분담을 만들지 않는다.

## 정확한 변경 경로

기존 3개 수정·신규 21개. 목록 밖 경로가 필요하면 변경 전 추가 승인을 요청한다.

1. `scripts/ui/stage1_session.gd` — 수정 / 동일 Pipeline의 W05 활성화·snapshot/명령/결과 중개
2. `scripts/ui/stage1_view.gd` — 수정 / P05 공사 패널 연결·복귀·갱신·포커스
3. `scripts/ui/tender_view.gd` — 수정 / 실제 공사 화면 진입 신호 및 DEV020-GUI-01 공기 문구 정합화
4. `scripts/ui/construction_view.gd` — 신규 / 권위 상태 표시·모드 선택·명령 버튼·결과 이력
5. `scripts/ui/construction_view.gd.uid` — 신규 / Godot UID
6. `scenes/construction_panel.tscn` — 신규 / 최소 공사 패널
7. `tests/game/run_construction_ui_tests.gd` — 신규 / UI 중개·실제 Control/신호 자동 회귀
8. `tests/game/run_construction_ui_tests.gd.uid` — 신규 / Godot UID
9. `tests/game/construction_ui_fixtures.gd` — 신규 / 정상/실패·역순·자금중단 테스트 입력
10. `tests/game/construction_ui_fixtures.gd.uid` — 신규 / Godot UID
11. `tests/game/run_construction_gui_cases.gd` — 신규 / 테스트 전용 GUI 재현 진입점
12. `tests/game/run_construction_gui_cases.gd.uid` — 신규 / Godot UID
13. `docs/engineering/tasks/DEV-021_W05_CONSTRUCTION_UI.md` — 신규 / 승인 원문·경계·수행 티켓
14. `docs/engineering/tasks/DEV-021_RESULT.md` — 신규 / 변경·검증·제한·인수 요청
15. `docs/engineering/tasks/DEV-021_PROVENANCE.json` — 신규 / 기준 SHA·명세/승인 근거
16. `docs/engineering/evidence/DEV-021_W05_UI_SUPPLY_AND_VALIDATION.md` — 신규 / 공급/소비 계약·재현 절차·Design 인계
17. `docs/engineering/evidence/DEV-021_W05_UI_CASES.json` — 신규 / 사례별 입력·기대/실제·명령/시각/revision
18. `docs/engineering/evidence/DEV-021_W05_UI_VALIDATION.json` — 신규 / 실행 명령·로그요약/해시·종료코드·SHA·NOT_RUN
19. `docs/engineering/evidence/DEV-021_PRODUCT_P05_CONTRACT.png` — 신규 / 실제품 공사계약 화면
20. `docs/engineering/evidence/DEV-021_PRODUCT_P05_PROGRESS.png` — 신규 / 실제품 공정·기성 화면
21. `docs/engineering/evidence/DEV-021_PRODUCT_P05_OPEN.png` — 신규 / 실제품 검증 후 개통 화면
22. `docs/engineering/evidence/DEV-021_FIXTURE_PAYMENT_DUE.png` — 신규 / 테스트 전용 자금중단 화면
23. `docs/engineering/evidence/DEV-021_FIXTURE_FAST_REPAIR.png` — 신규 / 테스트 전용 빠른 공사 결함/수리 화면
24. `docs/engineering/evidence/DEV-021_GUI_NARROW_KEYBOARD.png` — 신규 / 축소 창·키보드 접근 증거

## 제외 및 인수 경계

공통 모델/원장/시각·W05 경제/게임 규칙, W06 실제 영업, W04B, W04A Q03~05 별도 증거, 최종 아트/F-08/Windows export, 도구/CI/정책/타 부서 문서는 변경하지 않는다. UI에는 W06 실제 영업이 후속임을 명시한다.

S2-04/05/08 W05 부분·S2-11 및 F-05/10/11의 개발 검수 요청이다. 모델/자동검사/실제품 GUI/TEST_ONLY GUI/Design 독립 GUI를 구분하며 A01-Q12는 Design 인수 전 PARTIAL이다. VS-01 전체 또는 Stage DONE을 선언하지 않는다.

## 검증

정확한 명령·입력/기대/실제·로그·종료코드·실행 기준은 결과 및 공급 문서에 기록한다. 자동 UI 정상/빠른·중단/재개·수리부족·최종 기성·효력/중복/역순/조회·배속·기존 화면 회귀, W01/02/03/04A/05/07/DEV019 자동 회귀, tooling, policy/doctor/preflight, 프로젝트 로드, 정상 B01 실제 GUI와 TEST_ONLY 보조 GUI를 수행한다. Design 독립 검수와 Windows 빌드는 미실행 시 NOT_RUN으로 유지한다.

Agent-ID: AGT-DEV-0001
Task-ID: DEV-021

## 제출 기준 갱신

최초 구현/게임 검증 기준은 7735ccff22952dabdf1371c2b29d81b620f4a9c0이며, 제출 전 8a9515a781e8864de211df0ece3a52568df1154a까지 디자인 보관9개/INF 등록2개 경로만 추가됐음을 대조했다. 공통 게임 소스·명세는 동일하다. 미커밋 변경을 보존한 fast-forward 후 최종 정책/로드를 확인했다. [결과](DEV-021_RESULT.md)와 실제 PR head/CI를 함께 확인한다.
