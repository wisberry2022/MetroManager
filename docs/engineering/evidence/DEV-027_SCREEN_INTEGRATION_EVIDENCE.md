# DEV-027 — P3-B 화면 통합 로컬 검증 증거 색인

- 작성: AGT-DEV-0004 / 2026-11-22 KST / LOCAL_REVIEW_PENDING.
- [결과 JSON](DEV-027_SCREEN_INTEGRATION_RESULTS.json) / [결과서](../tasks/DEV-027_RESULT.md) / [정확한19경로·승인](../gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md).
- 기준: `1a24e3346d0ec46ca692fe54d5de5656913c3450` + [실행 JSON](DEV-027_SCREEN_INTEGRATION_RESULTS.json)의 최종 파일 해시. 신규 commit 없음.
- [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074162935) / [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074161321) B01~06 방향 확인과 Owner 최대19경로 승인에 따라 구현했다. 현재 **LOCAL_REVIEW_PENDING / P4_GUI_INDEPENDENT_NOT_RUN / REMOTE_NOT_SENT**.
- 새 실제 View 자동 **225 PASS**, 영향 회귀 **3120 PASS**(그중 P3-A 모델/공급/VS02 재실행677), 정상 실패0·SCRIPT ERROR0. 새 runner 의도 실패 exit1을 별도로 확인했다. Godot4.7.2 최종 로드 exit0·오류0.
- 제품 코드는 main/Host와 새 proposal View/표시 매핑/씬에 한정한다. 모델·Session·Pipeline·원장·시계·기존 씬·자산/데이터·CI 변경0. 기존 UI 입력 공통 처리와 표시 helper를 재사용해 Host를1000행 이내로 유지했다.
- B02는 `effective_not_before`→접수 가능 최저 시각(성공 보장 아님), `admitted_at`→실제 접수, `completes_at`→실제 접수부터의 완료 예정으로 소비한다. 기존 게임 규칙·심사/난수/지급 계산 추가0.
- 자동 검사에는 실제 Control 신호/합성 키보드와 게임 시간 환산이 있다. 실제 OS GUI·독립 실행·자연 VS02·최종 가독성/물리 DPI·빌드/export·성능은 각각 NOT_RUN. 표시0/실패 등 사본 fixture는 실제 자연 발생과 분리했다.
- P1/P3-A 결과·실패/원본과 Markdown 원문을 보존했다. 비변경 추적774개·공유 데이터2개·별도 F08 문서9개 해시 일치. 검사 당시 CRLF 바이트는 로컬 보관하고 LF 정규화 외 변경0을 검증했다. 최종 로드는 LF 파일로 실행했다.
- DI03 종속 범위 보류, DEV026 한정 수용/PARTIAL·미관측·P07 구분, #92 실제 이름/환경/폰트/아트·최종 규격, S3-10-C·S3-12/HQ·Owner 최종 인수 대기 유지. 새 명세 변경/RFC 필요 없음.
- 로컬 제출 검사: `.venv/Scripts/python.exe tools/policy.py doctor` 및 `check` PASS(793파일/68 GDScript), `git diff --check` PASS. 정확한19경로·18개 provenance blob·UTF-8/LF·원문 보존을 재확인했다. 원격 필수 CI는 PR 미생성으로 NOT_RUN이다.

## 행별 실제 구현과 관측 한계

| 행 | 실제 연결 | 근거/한계 |
| --- | --- | --- |
| B01 | 정상 main 활성화1회·P-A/P-B 명시 선택·정보 읽기0효과·편집/예측·합성 키보드 | main/keyboard/editing 검사 |
| B02 | 접수 가능 최저 시각≠성공 보장, 실제 접수 기산, 효력 재검사 실패/새 요청·현재 사유 분리 | pending/failed/admitted 표본·office 검사 |
| B03 | 정상 RNG seed2/0/8/1, 보류 사본·단회 설득 유효 접수, 허가와 실제800000/640000 지급 분리 | branch4 표본·중복/사본/지급 단언 |
| B04 | 실제 last accepted previous·동일판 거부·낡은/다른scope·지역/전체 오류·정상 복구·새 Session | guard/lifetime·지도 무효 편집0효과 |
| B05 | 실제 Control 계약→표준 공사/시범/안전/개통→일3 실적 보고→후보 명시 이동/보고 복귀 | 자동 시간 환산 체인. 자연 GUI 증거 아님 |
| B06 | 상태·0/실패/이전 예측·중립 사유·기본/fallback·800×600/1100×900 headless 배치 폭 | 표시 fixture/자동 geometry. 실제 가독성/최종 DPI 수용 아님 |

## 실행 식별

| 로컬 run ID | 결과 marker | exit | SCRIPT ERROR/ERROR |
| --- | --- | --- | --- |
| view-03 | PROPOSAL_VIEW_TEST_RESULT checks=225 failures=0 | 0 | 0 |
| regression-w04b | W04B_P1_TEST_RESULT checks=437 failures=0 | 0 | 0 |
| regression-proposal_ui | PROPOSAL_UI_TEST_RESULT checks=165 failures=0 | 0 | 0 |
| regression-vs02 | VS02_AUTO_TEST_RESULT checks=75 failures=0 | 0 | 0 |
| regression-w07 | W07_TEST_RESULT checks=322 failures=0 | 0 | 0 |
| regression-tender_ui | DEV019_UI_TEST_RESULT checks=460 failures=0 | 0 | 0 |
| regression-construction_ui | DEV021_UI_TEST_RESULT checks=898 failures=0 | 0 | 0 |
| regression-operations_ui | DEV023_SUPPLY_TEST_RESULT checks=158 failures=0 | 0 | 0 |
| regression-s01_exception | DEV026_TEST_RESULT checks=334 failures=0 | 0 | 0 |
| regression-operations_gui_cases | DEV023_UI_TEST_RESULT checks=271 failures=0 | 0 | 0 |
| intentional-01 | PROPOSAL_VIEW_TEST_RESULT checks=2 failures=1 | 1 | 0 |
| final-load | 프로젝트 로드 | 0 | 0 |

각 run의 명령·raw 로그 SHA256·시간은 JSON에 있으며 원본은 `.local/validation/DEV-027/screen-integration/<run>/`에 보관한다. View JSON 본문224단언과 저장 성공1을 합쳐 stdout225로 기록한다. 검토용 JSON은 224개 단언 ID/판정을 모두 유지하고, 큰 actual/expected 값만 정규 JSON SHA256 참조로 줄였다. 전체 값은 `view-03/evidence.json` 원본과 그 SHA256으로 연결하며 B02~06 표본은 검토용 JSON에도 보존한다. 의도 실패는 정상 회귀 실패에 합산하지 않는다. 초기 개발 실패·환경 오류·view-01/02·operations-01 로그도 보존했다.

## 재현과 후속 GUI 인계

제품 진입: `<Godot> --path <worktree>` → `회사 제안` → 명시적 슬롯 선택 → 지도/목록에서 정보 선택 → `역 추가/제거/위로/아래로/이름 적용` → `예측 계산` → 시청/정부/설득/사업계약 버튼. 기존 HUD 정지/재개/배속을 사용한다. 실제 접수·완료를 기다리고 허가·실제 지급 뒤 `같은 사업 공사·검증(P05)`에서 표준 공사·시범/안전·개통을 진행한다. 운영/재무의 첫 실적 보고→공고 조회 뒤 `회사 제안`은 명시적 후보 이동이며 자동 새 수주가 아니다. 후보 화면 `뒤로`는 선택 보고일/읽기 문맥으로 복귀한다.

정상 RNG 재현 초기 인수는 `-- --w04b-seed=2`(직접 적합), `0`(보류/설득 실패), `8`(보류/설득 성공), `1`(정부 거부)만 허용한다. seed는 초기화1회이며 화면 왕복으로 재설정하지 않는다. 기본 실행은 정상 임의 초기 seed이고 결과 성공 고정이 아니다. 초기화 후 입력/시간/자금/판정 주입 경로는 없다. 네 분기 증거는 위 자동 검사이며 새 seed 탐색0.

검사: `<Godot> --headless --path <worktree> --script res://tests/game/run_proposal_view_tests.gd -- --output=<fresh-output.json>`; 의도 실패는 `--verify-failure-exit`와 별도 output 사용. `run_operations_gui_cases.gd -- --auto`는 기존 UI 자동 회귀이며 OS 실행이 아니다. 다른 실행 명령은 JSON의 run별 command를 참조한다.

P4는 본 실제 화면·고정 base+해시·정상/경계 경로·환경·합의 관측 행·관측 수단/증거 보관·독립 실행 주체/유효 권한을 한 공동 패킷으로 연결한 뒤 재개한다. Track A는 기능/자연 VS02, Track B는 RP/EX·표현/읽기/수명/복귀를 분담한다. 현재 독립 실행/GUI 수용은 미요청·NOT_RUN이다. 기존 관측 도구의 W04B 필드 충분성은 NOT_VERIFIED이며 부족 행/최소 경로만 별도로 검토한다. 새 GUI runner·CI 변경은 없다.

## 원본과 한계

실제 슬롯/역 읽기는 ID/동 공급을 사용한다. 승인 실제 역명12행이나 최종 폰트·DPI/지원환경·아트 규격 수용으로 표시하지 않는다. 내부 수명·옛 callback 자동 단언을 OS 가시성 PASS로 바꾸지 않는다. 일4 증거를 일1 미관측에 전용하지 않는다. 새 경계가 드러나면 영향 B행만 재대조하고 기존 P3-A 공급을 다시 미공급으로 되돌리지 않는다.

기존 결과/manifest 원본은 [PR172 병합 기준 provenance](https://github.com/wisberry2022/MetroManager/blob/1a24e3346d0ec46ca692fe54d5de5656913c3450/docs/engineering/tasks/DEV-027_PROVENANCE.json)와 로컬 `originals/`에 보존했다. 최종 로드가 만든 비제출 import/translation176개는 `.local/validation/DEV-027/screen-integration/generated-imports/`로 바이트/해시 보존 이동했다. 타 부서 원본 이미지·CSV는 변경하지 않았다. 최종 경로·원문·공유 작업·소스 해시 감사는 같은 로컬 디렉터리의 `final-audit.json`에 보관한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
