# DSG-004 — Stage 1 지도·노선·예측 저충실도 설계 결과

- 문서: `DSG-004-RESULT` / 버전: **v0.1 / REVIEW / 2026-11-01**
- 담당: Design / Art Director & UI/UX Designer
- 작업: [Issue #51](https://github.com/wisberry2022/MetroManager/issues/51) / 상위 [DSG-002 #24](https://github.com/wisberry2022/MetroManager/issues/24) / S01 선행 [DSG-003 #46](https://github.com/wisberry2022/MetroManager/issues/46)
- **본문:** [DSG-004_STAGE1_MAP_ROUTE_PREDICTION.md](DSG-004_STAGE1_MAP_ROUTE_PREDICTION.md)
- **Owner 승인 원문:** “디자이너 에이전트. 51번 이슈에 대한 산출물 구현 및 PR 생성을 승인합니다.”
- **원격 작성 시작 기준:** `main` `5c91d56c78c2de5bd94bea7ee66b5c86181f4cb8`. PR 제출 전 최신 SHA/브랜치·단일 부모/허용 경로를 재확인한다.
- **결과 상태:** `DESIGN_LOWFI_DOCUMENTED / STATIC_CASE_REVIEWED / IMPLEMENTATION_NOT_RUN / REVIEW`

## 1. 작성한 산출물과 결정

| 범위 | 이번 문서 결과 | 판단 경계 |
|---|---|---|
| S01-B 지도 | DATA v1.3 `2에 대응한 **4열×3행, S01~S12** 텍스트 목업과 G01~04/D01~08·C01 경로 표시 | 도형은 시각 가설. 행정/역 소속 판정은 DEV 권위 stable ID·승인 데이터 |
| S01-F 역 목록 | 지도/목록에서 동일 entity_id의 보기·추가·제거·순서 위/아래·되돌리기·노선 검사 의도/상태와 오류 복구 매트릭스 | 실제 명령·허용/거부·undo 구현은 DEV 공급. UI가 독자 판정하지 않음 |
| 노선 정상/부정 | 공식 P-A 6역·P-B 6역·8역 및 파생 5/9·중복·단절·외부 관할(별도 fixture) 구분 | 정적 기대값이지 Godot 실제 응답·버튼 활성 PASS 아님 |
| 예측 최소 | NOT_CALCULATED/CALCULATING/READY=0/FAILED, 이전 revision·자료없음, 기간·단위·생성 게임시각을 분리하는 화면 상태표 | W03 실제 계산·API/최신 revision 판정은 DEV. 실제 통행·영업 실적과 혼용 금지 |
| DSG-003 통합 | S01-A 시간 HUD·S01-C/D 현재자금/보고·S01-E 명령/오류의 기존 위치/의미 보존 | DSG-004가 시간·장부 기능을 재구현·변경하지 않음 |
| 사용성·품질 | 12개 마커 밀집·색상 외 식별·목록 대체 조작·키보드 접근·명령 결과/예측 덮어쓰기 검수 계획 | 실제 인터랙션·성능·가독성 사용자 실측 NOT_RUN |

## 2. 승인 DATA 정적 fixture 점검

**근거:** [PLN-001 Gate 2 DATA v1.3 `2](../../planning/PLN-001_GATE2_DATA_v1_DRAFT.md). 후보 12개, D01~04 각 1역/D05~08 각 2역. 간선은 맨해튼 거리 1인 역쌍의 양방향이고 유효 노선은 **고유역 6~8개 + 각 연속 연결**이다.

| Fixture | 고유/표기 | 간선 정적 검사 | 기대 표시 |
|---|---:|---|---|
| MAP-01 P-A `S01→S02→S03→S04→S08→S12` | 6/6 | 연결됨 | 정상6 |
| MAP-02 P-B `S01→S05→S09→S10→S11→S12` | 6/6 | 연결됨 | 정상6 |
| MAP-03 8역 `S01→S02→S06→S05→S09→S10→S11→S12` | 8/8 | 연결됨 | 정상8 |
| MAP-04 5역 `S01→S02→S03→S04→S08` | 5/5 | 연결됨 | **최소6 미달** |
| MAP-05 9역 `S01→S02→S03→S04→S08→S07→S06→S05→S09` | 9/9 | 연결됨 | **최대8 초과** |
| MAP-06 중복 `S01→S02→S06→S02→S03→S04` | 5/6 | 연결됨 | **S02 재방문** |
| MAP-07 단절 `S01→S03→S04→S08→S12→S11` | 6/6 | **S01→S03 간선 없음** | **연결 끊김** |

- **정적 점검 결과:** 위 7건의 개수·고유성·연속 간선 검사 결과가 각 예상 분기와 일치함. 검사에는 승인 좌표의 **단순 기하/집합 계산만** 사용했으며 런타임 사업 자격/명령 응답/노선 모델은 실행하지 않음.
- **MAP-08 외부 관할:** 승인 후보 12개 안에 존재하지 않는 **DEV 부정 입력 fixture**로만 요구하며 신규 S13이나 승인 외 행정 데이터를 생성하지 않음. 실제 입력값·reason은 DEV가 공급해야 함.
- **MAP-09~10:** 자료 미수신/잠금·stale 명령·오래된 예측은 화면 상태·검수 조건을 문서에 기록했으며 실제 입력 재현 NOT_RUN.
- 지도 4구·8동 소속의 정적 행렬은 승인 `P01/C01/G/D` 부모 관계를 읽기 위한 시안이며 **지리 경계가 행정 소속의 판정 원본이라고 주장하지 않음**.

## 3. 검증 등급과 NOT_RUN

| 검증 항목 | 상태 | 근거·남은 증거 |
|---|---|---|
| 원격 승인 DATA/DSG-002·003/DEV-006 계약 정적 대조 | **DONE** | 문서의 고정 뜻·버전/행정 소속/상태 구분 비교 |
| 공식 6·6·8 및 파생 5/9·중복·단절 기하/집합 정적 검산 | **DONE (정적 한정)** | 위 MAP-01~07의 고유성·간선·범위; DEV 모델 검증은 아님 |
| 저충실도 텍스트 목업·상태/동등 조작·예측 표시 매트릭스 | **DOCUMENTED** | 본문 `2~7. 실제 사용성 평가나 동작 증거 아님 |
| 실제 클릭/키보드·지도 겹침/스케일·가독성·대조 | **NOT_RUN** | DSG-005·최소 UI 통합에서 화면·실제 명령 로그/캡처 확보 |
| Godot W03 모델·OD 예측 자동 테스트 / GUI 로드·게임 플레이 | **NOT_RUN** | DEV-012 담당, 실제 결과와 Design 소비 검수 분리 |
| 이미지/픽셀 PNG·고충실도 UI·Windows 빌드·FPS/외부 사용성 | **NOT_CREATED / NOT_RUN** | DSG-004 비범위, UI-DC-08 후속 Owner 결정 |
| 독립 VP-01/02 E2E 및 전체 Stage S1-01~09 인수 | **NOT_RUN** | 첫 Stage 부분 검증과 전체 MVP 인수 구분 |
| Git 로컬 hooks / policy.py doctor/check/preflight | **NOT_RUN** | GitHub API 방식으로 제출할 경우 직접 실행되지 않음 |
| 원격 `policy` + `department-policy` | **PR 확인 대상** | 생성된 PR 최신 head의 검사 결과만 별도 Issue/PR에 기록 |

## 4. DEV 공급·후속 작업 인계와 차단 시점

1. **DEV-012 W03 → DSG-004/DSG-005 (L2):** 실제 `entity_id/plan_revision`, 행정 부모/역/간선·검증 reason_codes/allowed_actions·동작별 반환, 정상/오류/외부관할 fixture, `prediction_input_revision/status/available/value`·기간·단위/시각·과거 결과. **실제 W03 UI 통합/동작 검수 전** 공급되어야 하며 이 문서의 정적 설계 제출을 차단하지 않음.
2. **DSG-003 S01 + DEV-011 W02:** HUD/읽기 전용 원장·과거 보고의 실제 연결은 별도 승인된 최소 UI 개발·디자인 QA에서 검수. 이번 PR은 DSG-003 소유 파일을 변경하지 않음.
3. **DSG-005 후속 (별도 Owner 승인):** 지도/역 목록의 실제 입력→실제 snapshot/result→화면 동등성, 예측 rev7→8·오류/늦은 응답, 밀집/클릭 대체 조작·키보드 관찰을 통해 S1-08/09 부분 검증.
4. **Planning/HQ/Owner:** 승인 규칙 충돌·행정 범위 변경 필요 발견 시에만 해당 ID·AC로 L2/L3 처리. 현재 **추가 정책 질문 없음**. 제품 PC/폰트/뷰포트·FPS·외부 사용성 표본/예산은 각 규격 종속 제작·모집 전에 Owner 선택 필요.
5. **MVP 범위 변경 없음:** 8 MVP 영역·11 MUST·AC-01~10 및 독립 VP-01·02를 보존. 실사업 계약·제안/입찰·공사·운행 구현이나 저장·복원을 이번 디자인 PR에서 추가하지 않음.

## 5. Owner 제출 권한·완료 판정

- **승인 범위:** Issue #51의 디자인 문서/텍스트 목업과 정적 검수. `docs/design/tasks/DSG-004_STAGE1_MAP_ROUTE_PREDICTION.md` 및 `docs/design/tasks/DSG-004_RESULT.md`만 `codex/DSG-004-stage1-map-route-prediction-lowfi` 브랜치에서 단일 부모 Commit·Push·PR 및 필수 CI로 제출.
- **종료:** 위 두 파일의 공식 PR 제출·동일 범위 리뷰 대응까지. `main` 직접 수정·병합·릴리스·Godot/아트 PNG·타부서 파일·DSG-005까지 자동 승인하지 않음.
- **실행 후 인수 요청 대상:** 문서의 저충실도 **표현·상태·검수 기준**. 실제 UI/Godot 작동·사용성 합격과 Stage 종료는 **별도**다.
- **최종:** `DSG004_STATIC_DESIGN_REVIEWED / GIT_PR_REVIEW / GUI_AND_MODEL_NOT_RUN`. 새 기획 변경/RFC 불필요. 최신 PR/head·CI 결과는 Issue #51에 별도 제출 기록.
