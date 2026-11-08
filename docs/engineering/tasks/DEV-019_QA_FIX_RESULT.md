# DEV-019 QA-001·QA-002 보완 결과

- 담당 Development / LAPTOP / AGT-DEV-0001 / 상태 REVIEW, 독립 Design 재검수 및 Owner 검수 대기.
- 기준 main `06274e8557a8bbe4d8880fd02aac892c15e49f98`, 브랜치 `codex/DEV-019-qa-public-criteria`.
- [티켓·Owner 승인 원문 §12~13](DEV-019_W04A_MINIMUM_UI.md), [Design L2 조건부 문구·배치 수용](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6717520859). 이번 두 결함만 구현·검증·Commit/일반Push/PR 승인. main 병합은 별도이며 미수행이다.

## 변경과 기술 판단

QA001: 응찰 전 공고 상세에 공개 평가방식·경쟁자80점/구성·공급된 동점순위를 표시한다. 고정조건→공개기준→현재자격/마감안내→응찰 요청 순서다. 판정 전 미확정 안내만 실제 decision 생성 후 제거하고 고정기준과 실제 판정 사본을 분리한다. 플레이어 예상점수/낙찰 보장·새 임계값은 추가하지 않는다.

Session은 기존 PublicTender.score를 고정 경쟁자 점수 표시에만 재사용한다. 정수0~100의 경쟁자 능력/재무점수를 검증하고 API 입력 단위로 변환한다. View는 공급 유리수의 정확한 문자열 표시만 수행한다. 누락은 자료 없음이다. 경제 모델·원장·시각·낙찰 명령·데이터/terms/schema를 수정하지 않았다.

QA002: 현재 행동 사유에 기존 한국어 매핑을 적용하고 복수 사유는 공급 순서대로 줄바꿈한다. 미등록 코드는 설명과 코드 모두 표시한다. 원 권위 코드·현재 허용 행동과 과거 명령 결과는 보존한다. 테스트 전용 REASON_FALLBACK은 긴 미등록 사유/복수사유 표시만 검증하며 제품 기능과 분리한다.

수정 소스: scripts/ui/stage1_session.gd, scripts/ui/tender_view.gd, tests/game/run_tender_ui_tests.gd, tests/game/w019_ui_fixtures.gd. DEV 티켓/결과/공급계약·출처기록, 새 자동단언/실행증거/게임창 JPEG12개를 함께 제출한다. 타부서 문서·CI·정책·프로젝트 설정·씬은 수정하지 않았다.

## 실제 검증

[자동 UI 단언235개](../evidence/DEV-019_QA_FIX_ASSERTIONS.json), [실행 결과·실제 GUI 관측·소스/로그/화면 해시](../evidence/DEV-019_QA_FIX_VALIDATION.json).

| 종류 | 실행·결과 |
| --- | --- |
| UI 자동 | Godot --headless --path . --script tests/game/run_tender_ui_tests.gd: 235 checks / 0 failures / exit0 |
| 기존 회귀 | run_w01_tests 219 / w02 309 / w03 101 / w04a 204 / w07 322, 총1155 checks / 0 failures / 각각exit0 |
| 프로젝트 로드 | Godot --headless --editor --path . --quit: 최종exit0, 오류 없음 |
| 검증전용 GUI | run_tender_gui_cases.gd: 정상 B01/B02 사전기준·B02응찰/마감86:80/계약·정부금/P05·1799요청1800거부·긴fallback/복수사유·기본창/최대화/스크롤, exit0 |
| 실제 제품 main GUI | S01→입찰목록→B01 응찰 전 기준→목록복귀→Down/Enter B02 응찰 전 기준, 일시정지586분 유지·응찰명령0, exit0 |
| 정책 | doctor/check PASS(458파일/GDScript31). tooling 전체89개 중88통과·1개 sandbox Git sh.exe 접근오류, 해당1개 일반환경 재실행PASS(exit0). 89개 고유항목의 최종 통과이며 단일실행89/89와 구분. Commit후fetch/preflight는 PR에 기록 |
| Design 독립 재검수 | NOT_RUN / REQUIRED. 개발 GUI·자동검사로 대신하지 않음 |
| 빌드/성능/전체VS01 | NOT_RUN, 이번 보완 범위 아님 |

이번 자동검사는 사전 미응찰 B01/B02의 필수문구/읽기순서, 판정후 미확정 제거 및 실제결과 분리, 조회무효과, 점수API 입력 검증/고정경쟁자 점수, 누락/공급순위 변환, 알려진/미등록/복수사유·이력분리·allowed_actions 보존을 추가 검증한다. 기존 정상/동점/소수79.99997·경계/중복/역순/조회복구/P05는 같은 UI 자동러너로 회귀했다.

원본 QA ZIP 해시·manifest 대조는 티켓 §12를 참조한다. QA 실행 보고와 이번 개발 재검증은 별개다. 샌드박스 최초 실행의 로그경로/에디터 설정 저장 오류와 테스트 타입추론 파싱 실패는 원인 해소 후 최종 실행으로 대체했고 최종 실행은 정상이다. 개발 의존성은 전용 venv의 고정 requirements를 사용했다. 에디터가 생성한 본 worktree의 미추적 docs/*.import만 경로 확인 후 정리했다.

GUI는 기존 설치 Godot4.7.2와 computer-use의 실제 입력/새 창 캡처로 수행했다. 테스트 전용 창과 실제 제품 main을 구분한다. 사용자 Escape 중단 후 Owner의 재개 지시로 제품 검증을 이어갔다. JPEG는 게임창 원본이며 편집/합성하지 않았다. GUI 실행 바이트와 최종 제출 바이트의 차이는 LF 정규화뿐이며 검증 JSON에 두 해시를 남긴다.

## 재검수 인계·잔여

Design은 새 고정 head에서 QA001의 사전 B01/B02 공개정보/읽기순서·좁은창과 QA002의 한국어/fallback을 재검수한다. 정상/동점/소수·마감/이력·조회복구 회귀는 자동 증거와 실제 실행 수준을 구별한다. 이번 개발 GUI에서 동점/소수 사례를 새로 조작하지 않았으며 자동검사 PASS만 기록한다. 이전 QA의 PARTIAL/하위 NOT_RUN을 자동 승격하지 않는다.

P05는 읽기 전용 인계 / A01-Q12 PARTIAL을 유지한다. 실제 공사계약·착공·공정·시범/안전은 DEV020/021 후속이다. 새로운 기획 규칙/L3 요청이나 명세 변경 필요는 발견하지 않았다. 본 결과는 보완 검수 요청이며 Design 수용·Owner DONE·main 병합·Stage2 인수 완료가 아니다.

Agent-ID: AGT-DEV-0001
Task-ID: DEV-019
