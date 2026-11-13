# DEV-021 OBS-01 검수 요청

- 담당: AGT-DEV-0001 / LAPTOP. Owner의 Issue #77 15개 경로 승인에 따른 후속 보완.
- 제출 기준 main: `3dfae889c77a0740bfa7dab8ec1db630156dc6d3`. 재현 시작 기준: `4b3f73c5d8b87630cc96eb90f950761f79bb861b`.
- 상태: REVIEW_REQUESTED. main 병합과 Design 독립 재검수는 별도다.
- 승인 패킷: https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6867246123

## 변경 효과

W05 공사 화면에서 Tab/Shift+Tab으로 이동하면 포커스가 있는 행동 버튼과 같은 행의 허용·거부 사유가 함께 스크롤 영역에 들어온다. 레이아웃 반영 후에도 포커스가 같은 대상일 때만 스크롤하며, 화면 갱신·창 크기 변경·사업 인계 화면 복귀에서도 이를 적용한다. 비활성 버튼의 사유를 읽을 수 있는 기존 포커스 경로를 유지한다.

제품 변경은 `scripts/ui/stage1_view.gd`, `scripts/ui/construction_view.gd` 두 파일이다. 나머지는 승인된 GUI 러너·fixture·회귀 검사와 티켓·증거다. 모델, 원장, 시각, 명령 처리, 씬, 게임 규칙은 변경하지 않았다. 신규 명세 결정은 필요하지 않다.

## 재현과 검증의 해석

보완 전 제품 UI 두 파일이 base blob과 일치하는 상태에서 새 검사 하네스를 실행했다. baseline 374개 검사는 잘림을 검출하는 기대값을 포함해 통과했고, 버튼 행 잘림 6건을 확인했다. 따라서 baseline PASS를 제품 결함 없음으로 해석하지 않는다. 수정 후 같은 유형의 3개 상태(PROGRESS, 수리 후 T3432, 재시험 통과 T3493)에서 포커스 회귀 725개가 통과하고 잘림은 0건이다. 기존 UI 검사를 포함한 전체 실행은 898개/실패 0이다.

실제 제품 GUI와 TEST_ONLY 보조 GUI를 구분한다. 보조 창은 경제 상태를 정상 제품에서 직접 생성했다는 증거가 아니다. 실제 키 입력·모델·포커스 로그 발췌와 실행 결과는 `../evidence/DEV-021_OBS01_VALIDATION.json`, 세부 자동 assertion은 `../evidence/DEV-021_OBS01_CASES.json`에 기록한다.

| 검증 | 결과 |
| --- | --- |
| 전체 W05 UI 자동 검사 | 898개 / 실패 0 / exit 0 |
| 최종 소스 포커스 자동 재검사 | 725개 / 실패 0 / 잘림 0 / exit 0 (전체 검사와 중복 집계하지 않음) |
| 기존 S01 W07 / W04A UI | 322개 / 235개, 실패 0, 각각 exit 0 |
| 기존 W05 모델 회귀 | 191개 / 실패 0 / exit 0 |
| TEST_ONLY 실제 GUI 호스트 자동 probe | 수리 후·개통 가능 각각 115개 / 실패 0 / exit 0 |
| 개발 도구 회귀 | 89개 / OK / exit 0 |
| Godot 프로젝트 로드 / 정책 검사 | PASS / 각각 exit 0 |
| 실제 정상 제품 GUI | B01 응찰→정부 지급→표준 공사→시범→안전→개통→복귀·재진입·재조회 PASS / exit 0 |
| TEST_ONLY 직접 GUI | 축소 창 활성·비활성 개통 및 사유, 최대화·복원, Tab/Shift+Tab, 활성 Enter 대기 확인 / exit 0 |

정상 제품의 공사 계약 효력 T2086, 착공 T2193, 완공 T5073, 시범 T5373~5433, 안전 T5521~5581, 개통 T5782를 실제 기록했다. 공사 완료 후 원장은 C1200000/R200000/F1000000/K0/B0이며 개통 뒤에도 동일했다. T5947 일시정지 후 키보드 복귀·재진입·재조회에서 해당 상태를 유지했다. 창은 기본 raw 1280×960, 보조 축소 창 raw 1104×900 및 최대화·복원으로 검증했다. 화면 설정의 제품 사양 수용을 뜻하지 않는다.

raw Window 크기, Godot viewport, 화면 캡처 크기는 서로 다른 단위다. OS 보고 DPI와 effective window DPI도 동일시하지 않는다. 보완 전 자체 GUI 캡처는 원 Design의 552×480 캡처와 정확히 같은 조건이라고 주장하지 않는다. 원 QA ZIP은 이번 작업 환경에서 확보하지 못했으며 내용 검증은 NOT_RUN이다.

## 인수 경계

Design의 기존 한정 수용 PASS 12 / PARTIAL 1 / FAIL 0을 개발팀이 전체 PASS로 승격하지 않는다. A02-11 및 A01-Q12는 독립 재검수 전 PARTIAL이다. W04A 잔여 Q03~05, W06, VS-01 완주, F-08 제품 규격·export·성능은 이번 보완의 인수 대상이 아니다. Windows export/build는 NOT_RUN이다.

재검수 절차와 보완 전/후 화면은 `../evidence/DEV-021_OBS01_RETEST_GUIDE.md`를 따른다. 최종 Commit SHA·필수 CI는 제출 PR에서 확인한다. 검증 통과는 Owner 승인 또는 DONE 처리가 아니다.
