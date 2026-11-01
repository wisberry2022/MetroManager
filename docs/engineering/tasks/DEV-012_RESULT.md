# DEV-012 — W03 행정·노선·OD 예측 구현 결과

- Development / LAPTOP / 2026-11-01 / **REVIEW · IMPLEMENTED / MODEL_VERIFIED**.
- [실행/Git 승인 티켓](DEV-012_W03_ROUTE_PREDICTION.md), [Issue #49](https://github.com/wisberry2022/MetroManager/issues/49), 기준 main `604751d79bba86cad179ca6434a5ec5b42640d71`.
- 브랜치 `codex/DEV-012-w03-route-prediction`, Owner의 이번 구현·Commit/Push/PR 승인 안에서 제출. 실제 SHA/CI·preflight는 PR 본문/댓글에 기록. main Merge·GUI/정책/타 부서 변경 제외.

## 구현과 변경 파일

- `scripts/model/administrative_network.gd`: 안정 ID/부모/역 소속·간선 조회, 중복/고아/순환/부정 참조·빈 네트워크 거부. 표시 도형을 소비하지 않음.
- `scripts/model/route_plan.gd`: 선택/제거/순서/되돌리기·revision/잠금, 정상6/8·5/9/중복/재방문/단절/관할외 판정·사유. 편집 중5/9·단절은 오류 상태로 표현하되 submit은 차단. 부정 선택/잠금 실패·같은 계획 재입력은 상태를 변경하지 않음.
- `scripts/simulation/demand_predictor.gd`: 승인 OD 접근·최소시간 역쌍/ID 동률·q·노선 공유 용량을 정수 분자/잔여로 계산. 반열린 기간의 요청/탑승/완료·예상운임/운행비와 기간 이후 잔여 예측을 구분. 실제 원장/시각을 변경하지 않는 순수 계산.
- `scripts/model/prediction_state.gd`: 입력/계획revision·게임 생성/입력시각·NOT_CALCULATED/CALCULATING/READY/FAILED·없음/0/이전 결과/낡은 응답 분리.
- `assets/data/gate2_w03_demand_v1_3.json`: 승인 DATA §4 수요·U10·운임100·운영비100·출처. 정수값/출처/버전 로드 검증.
- `tests/game/run_w03_tests.gd` 및 신규5개 `.gd`의 실제 생성 `.gd.uid`.
- 본 결과·DEV-012 티켓·`collaboration/WORK_STATUS.md` 자기 행. 총14파일. W01·DEV-011·프로젝트 설정/메인/씬·기획/디자인·도구/CI는 변경하지 않음.

## 실제 검증과 독립 기대값

| 종류 | 실제 결과 |
| --- | --- |
| 신규 모델 자동/회귀 | Godot4.7.2 `--headless --path . --script res://tests/game/run_w03_tests.gd` → **W03_TEST_RESULT checks=101 failures=0**, 종료0 |
| 실패 검출 | 같은 러너 뒤 `-- --verify-failure-exit` → 의도적 checks1/failures1·종료1(예상) |
| 기존 게임 회귀 | `run_w01_tests.gd` → **219단언 PASS**, 종료0 |
| 엔진 로드 | `--headless --editor --path . --quit`, 클래스/리소스 초기화·종료0 |
| 기존 메인 headless | `--headless --path . --quit-after 3` → W01_INIT_OK/초기값, 종료0 |
| 도구/정책 | 독립 `.venv` 고정 requirements 설치·doctor·gdformat/gdlint·policy check PASS. 검사기/설정 변경 없음 |
| 정책 도구 회귀 | `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v` → **37테스트 OK**, 게임101단언과 별도 |

101단언은 승인/외부관할 테스트 네트워크·정상6/8·5/9/중복/단절·편집/잠금/복구, OD 접근 중복 방지/최소시간 역쌍·역순 대칭·q5/10 경계, 공유용량/소수 이월·분할/일괄·잔여 도착·기간 구분, 부정/낡은 carry 및 예측revision/0/없음/실패·복사/재조회 불변을 포함한다. 부정 carry 추가 테스트의 타입 추론 오류를 명시 타입으로 수정한 뒤 전체 모델 검사를 재실행했다. 최종 실행 SCRIPT ERROR 없음.

독립 정수/유리수 산술 검산과 고정 엔진 기대값:

- P-A의 접근 OD는 D01→02(2000), D02→03(1500), D03→04(1200), D08→01(200×0.8)이다. D08 출발은 가장 가까운 S08을 사용하고 소요7분이다. 중복 역 수요 복제 없이 하루 요청/탑승4860.
- 첫날06:00~자정 `[360,1440)`은 그 기간 안 완료4852·예상운임485200·운행비108000. 기간 후 도착8은 별도 carry이며 전일 운임에 합치지 않음.
- 첫날06:00~다음날06:00 `[360,1800)`은 잔여 완료까지4860·예상운임486000·운행비108000. 비영업 잔여 도착만으로 추가비 없음. P-B의 같은 온전한 서비스/잔여 도착 기간 완료는1460.
- 용량 경계 전용 D01=1296/일·U1·10분은 요청12/탑승10/미탑승2, 같은 기간 완료9·잔여1. 기본 U10 데이터를 바꾼 제품이 아닌 테스트 전용 입력이다.

이 계산은 지정 기간의 예측이다. 시청 심사/사업성 판정·실제 운임 인식·실제 승객 시뮬레이션을 구현/확정하지 않는다. 승인 규칙·수치를 변경하지 않고 기간/출처를 명시한 공급 결과다.

## 공급·잔여·인수 경계

- AdministrativeNetwork/RoutePlan은 같은 안정 ID·순서·계획revision·validation/allowed_actions를 공급한다. DemandPredictor는 시간/노선/수요 입력을 명시하고 합계/잔여를 반환한다. carry는 시각·노선·입력 파라미터가 바뀌면 거부한다. PredictionState는 그 결과를 입력revision/유효성/과거 결과로 묶는다.
- 실제 최소 UI 통합 전 Design에 정상/오류·0/없음·낡은 응답 fixture와 같은 revision의 결과를 전달한다. 지도/목록 조작·예측 화면·밀집/가독성/제품 규격·공동 UI ACCEPTED는 **NOT_RUN**이며 모델 검증으로 대체하지 않는다.
- W02 실제 시각/원장 연결·W04~06·전체 Stage/AC·독립 VP E2E·Windows 빌드/FPS·외부 사용성은 각각 **NOT_RUN / 범위 제외**. 현재 예측 계산을 위해 W02 병합을 기다릴 필요는 없다.
- 검증 범위의 알려진 잔여 결함·신규 명세 변경/RFC 없음. 실제 UI 소비에서 의미 차이가 발견된 행만 L2로 확인한다. Owner 결과 수용/DONE·main 병합은 별도다.

- 제출 기준 갱신: 구현 중 Design PR #50의 문서2개만 main 5c91d56c78c2de5bd94bea7ee66b5c86181f4cb8에 추가됐다. 미공유 작업을 최신 main 위로 재배치하고 승인된 자기 변경만 제출한다. 게임 규칙/코드·W01 원본·고정 DATA 출처604751d는 변경하지 않는다. 실제 preflight base/head는 PR에 기록한다.
