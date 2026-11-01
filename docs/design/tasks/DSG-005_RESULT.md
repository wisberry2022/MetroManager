# DSG-005 — Stage 1 최소 UI 검수 준비 결과

- 문서 ID: `DSG-005-RESULT` / `v0.3 / REVIEW` / 2026-11-01
- 담당: Design / Art Director & UI/UX Designer
- 기준 `main`: `87342cd5c29a3047695c11bfd7f2b76415cdf4d8`
- 참조: Issue #24/#46/#51/[#59](https://github.com/wisberry2022/MetroManager/issues/59), DEV-011 PR #55 / DEV-012 PR #57
- 상태: `DEV_L2_REPLY_REVIEWED / DSG005_CHECKLIST_V03_REVIEW / GUI_QA_NOT_RUN / GIT_PR_AUTHORIZED`
- 최신 검토 근거: [Issue #25 DEV→Design W07 L2 회신](https://github.com/wisberry2022/MetroManager/issues/25#issuecomment-6557565493) — 요청 1~4를 W07 통합 공급 항목으로 수용, 현재 구현/미구현 구분

## 1. 작업 결과

- DEV-011/012 모델·테스트가 `main`에 병합된 사실과 실제 소스에 존재하는 W02·W03 스냅샷/조작 API를 정적으로 대조함.
- `scripts/main.gd`가 아직 W01 초기 회사 Label만 보여 주는 것을 확인. **최소 S01 시간/지도·예측 실제 UI 통합은 구현되지 않았음**.
- DSG-003·004의 저충실도 화면·상태/오류 매핑과 연결되는 `QA-T01~03/F01~04/M01~04/P01~02/X01` 14개 실조작 검수 시나리오, 실패 시 결함 기록 템플릿 및 선행 조건을 준비함.
- 개발팀이 [Issue #25 회신](https://github.com/wisberry2022/MetroManager/issues/25#issuecomment-6557565493)에서 요청 1~4를 **W07 공급·검증 조건으로 수용**함. 완결된 동일 시점 Pipeline/clock/보고 사본, 독립 보고ID 부재, 시간제어 중개 미구현, Undo bool 실패 원인, 예측 중첩 결과·revision의 차이를 반영하여 본 검수 계획을 **v0.2-draft**로 개정함. 새 경제·게임 규칙/기술 구현 방식은 디자인팀이 확정하지 않음.
- 다음 단계 GUI 구현에 필요한 PNG는 0개라는 개발팀 제안 유지. Pixelorama 원본·이미지 제작/고충실도 UI·`assets/` 반영은 이 작업에서 하지 않음.

## 2. 검증 단계별 상태

| 검증 | 상태 |
|---|---|
| 최신 main/PR #55/#57 및 W02·W03 코드·기존 디자인 명세·개발팀 Issue #25 회신 정적 대조 | `DONE (source + reply review)` |
| 실제 Godot 자동 규칙/회귀를 디자인팀이 재실행 | `NOT_RUN` (개발 결과서의 별도 보고만 읽음) |
| S01 GUI 시간 제어·지도/역 목록·예측·원장 실제 조작 | `NOT_RUN` (W07 미구현) |
| 실제 오류/겹침/키보드/가독성·사용성 | `NOT_RUN` |
| 픽셀 PNG/고충실도 아트·외부 사용성/Windows 빌드·FPS | `NOT_RUN / NOT_CREATED` |
| Git Commit/Push/PR·원격 policy/department-policy | `REVIEW (제출 승인 확인)` — 정확한 PR/head SHA 및 두 CI 실제 완료 결과는 원격에서 확인·별도 Issue에 기록. 로컬 Git hooks는 API 방식 제출 시 `NOT_RUN` |

## 3. 인계 및 남은 의존성

1. `DEV → DSG`: **W07에서 공급하기로 확인된** 한 Pipeline의 clock/자금/보고 안정 사본·보고 대상일 식별·속도/정지/명령 중개·한 Plan의 편집/검증/Undo·예측 nested result/변경 revision·정상/부정 fixture와 실제 GUI를 제공한 뒤 14개 케이스 검수. DEV-011/012 모델 검증 및 Issue #25 계획 수용만으로 화면 인수 완료 처리 금지.
2. `DSG`: 실제 GUI 결과를 기반으로 가독성·오류·허용행동/원인·지도↔목록 UX 수용/수정 요청·재검수 기록.
3. `Owner`: DSG-005의 **본 두 Markdown 문서**에 대한 Commit·작업 브랜치 Push·PR 및 CI 검증을 명시 승인했음. W07 실제 UI 통합·Git 실행은 Owner가 개발팀에 **별도 지시 예정**이며 본 디자인 승인으로 대체하지 않음. Stage 범위를 재선택하지 않음.
4. `HQ`: Stage S1-07/08/09의 정적/자동/GUI·미실행 검증 단계를 구분하여 통합 인수.

## 4. DEV Issue #25 회신 반영 상세 (W07 구현 전 정적 수용)

| 세부 항목 | 공급·표현 합의 | 여전히 W07에서 검증할 항목 |
|---|---|---|
| 시간/재무·보고 | Pipeline 한 인스턴스의 T_COMPLETE 안정 시점, clock과 자금/보고 사본 결합; 표시용 보고 식별은 **해당 실행 보고 저장소 범위+마감 `day_id`**, 전역 `report_id` 필드 없음 | 시간·snapshot 일치, T=1440에 전일1/현재일2 분리, 미마감 `{}`/실제0/조회오류 구별 |
| 속도·정지 | `set_speed`는 bool, `paused`는 속성; 시간제어 명령 ID·최신 허용·실효결과·화면revision은 **아직 통합 미구현** | W07 최소 중개, 정지 해제는 다음 tick 대기 금지, 동기 완료를 임의 pending으로 표현 금지, 과거 거부로 현재 버튼 덮기 금지 |
| 노선 편집·Undo | 하나의 RoutePlan만 변경, 편집 수락과 validation 유효성 분리. `undo()`는 bool; `locked/allowed_actions.undo`로 잠금·히스토리 없음 분리 | 예기치 않은 false는 일반 실패·재조회, 기존 `validation.reason_codes`를 Undo 실패 근거로 오용하지 않음 |
| 예측 상태 | DemandPredictor 성공 결과는 `PredictionState.current.value`에 중첩, **범용 `units` 필드 없음**. 현재 READY만 유효, previous는 출처 있는 비교 정보 | 편집→`change_input` 동기화, rev7 지연값이 rev8 덮지 않음, 반열린 게임분 기간·km·게임분·통행수·통화정수 표시 |
| 검수 증거 | QA-T01~03/F01~04/M01~04/P01~02/X01 **14개** 모두 W07 티켓에서 공급·검증 항목으로 수용 | 실제 GUI 조작·상태/오류/대체 경로 캡처·로그의 초기/기대/실제와 출처 연결 필수 |

**추가 L2 질문:** 현재 없음. DEV가 확인한 항목을 재질문하지 않고 **실제 W07 공급·검증 단계에서만** 미일치 행을 구체적으로 협의. **추가 기획 규칙 변경·L3:** 없음.

## 5. 후속 시각 산출물 경로·부서별 소유권 인계 (이번 제출 추가)

[Design↔DEV 에셋 위치·인계 수용 기록](https://github.com/wisberry2022/MetroManager/issues/51#issuecomment-6557396587)을 근거로, 다음 **제안 보관·적용 기준**을 이번 PR의 두 문서에 반영했다. 실제 디렉터리나 PNG/SVG/편집 원본은 **이번 DSG-005 티켓에서 생성하지 않음**.

| 관리 책임 | 향후 경로 | 역할 |
|---|---|---|
| Design | `docs/design/tasks/` | 화면·아트 명세, DSG 검수·결과·인계 기록 |
| Design | `docs/design/assets/source/` | Pixelorama 등 **편집 가능한 원본** |
| Design | `docs/design/assets/exports/` | 투명 원본해상도 픽셀 PNG 및 벡터 SVG/PNG **인계본** |
| DEV | `assets/ui/panels/`, `assets/ui/icons/` | Godot 패널/버튼·공용 아이콘 임포트/사용 |
| DEV | `assets/art/world/` | 지도·역·도시 픽셀 아트 임포트/사용 |
| DEV (후속) | `assets/art/vehicles/`, `assets/art/characters/`, `assets/art/effects/` | 후속 열차·승객·효과 적용 후보 |

- **인계 형식:** 영문 `snake_case` 파일명, 원본 해상도·상태/프레임·피벗·사용 화면/위치·라이선스·버전, 원본↔내보내기↔Godot 적용 파일의 대응을 명세한다. 필요한 경로만 실제 승인된 제작 티켓에서 생성한다.
- **권한/검수:** Design은 `docs/design/`만 변경하고 DEV가 승인된 독립 개발 티켓으로 `assets/`에 반영한다. nearest/정수 배율은 픽셀 아트 검증 가설이며 최종 viewport·폰트·타일·FPS 사양이 아니다. 디자인팀은 실제 Godot 사용 상태의 가독성·표현을 검수한다.
- **Stage 1:** DEV가 제안하고 Design이 수용한 최소 실제 UI의 **필수 별도 PNG 0개**를 유지한다. 지금은 문서 검수·S01 UI 통합 준비 단계이고 에셋 제작/실측은 `NOT_CREATED / NOT_RUN`. `docs/governance/path_exceptions.json` 변경 불필요.

## 6. 제출 권한·검증 및 잔여

- Owner 승인: “DSG-005의 두 Markdown 산출물에 대한 PR 제출 권한을 승인합니다”, 추가로 “이전에 ... 디자인 산출물의 디렉토리 관리 방안도 포함해주세요.”
- 제출 범위: `docs/design/tasks/DSG-005_STAGE1_UI_ACCEPTANCE_PLAN.md` 및 `docs/design/tasks/DSG-005_RESULT.md` **두 Markdown 파일만**. 브랜치 `codex/DSG-005-stage1-ui-acceptance-plan`; 단일 부모 Commit·Push·PR 생성·`policy` 및 `department-policy` 확인, 동 범위 검토 대응까지만. `main` 직접 쓰기·Merge·릴리스·게임 코드·기획·PNG/새 에셋 파일 작성 금지.
- PR 병합은 **Owner 별도 승인**이다. 제출/원격 CI 완료를 Stage 1 GUI 인수나 W07 실제 기능 PASS로 표시하지 않는다. 로컬 hooks/preflight 및 Godot 실검수는 실행 증거 없으면 `NOT_RUN`.
- 실제 W07 개발 통합 티켓·Git 권한은 Owner가 **개발팀에 별도로 지시할 예정**. 이번 DSG-005 PR이 W07 실행 승인이나 실제 제품 목표 확정은 아니다.

**최종:** `DSG005_L2_STATIC_MAPPING_ACCEPTED / CHECKLIST_V03_REVIEW / ASSET_HANDOFF_PATH_DOCUMENTED / W07_GUI_INTEGRATION_PENDING / NO_NEW_GAME_RULE_OR_L3_CONFLICT`. 실제 디자인/게임 화면의 수용 `PASS`를 선언하지 않음.
