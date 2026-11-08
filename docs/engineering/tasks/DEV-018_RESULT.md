# DEV-018 — W04A 입찰·낙찰·계약 모델 검수 요청

- 담당 AGT-DEV-0001 / LAPTOP / 2026-11-08 / REVIEW. Owner 공식 수용·DONE/main 병합 대기.
- base main b48dd82a9b93d062d1a3bcfdf8750cb260c83e3e, branch codex/DEV-018-bid-contract-model. 최종 제출 SHA/PR/원격 CI는 PR·Issue #74에 기록한다.
- [티켓 §9의 Owner 직접 승인](DEV-018_W04A_BID_CONTRACT.md#9-선행-회신-확인-및-실행-승인-적용)으로 본 티켓 구현·검증·Commit·일반 Push 또는 정책 API 공유·PR을 수행한다. main 병합/다른 티켓 실행·릴리스는 승인되지 않았다.
- [Planning 확정 입력](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6716236853) 반영. Design 회신은 [#24](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6716315597), [#74](https://github.com/wisberry2022/MetroManager/issues/74#issuecomment-6716316170)에 게시.

## 변경 결과

기존에는 공공입찰 사업 확보 모델이 없고 W02 계약 테스트 입력만 있었다. 이번에는 승인 공고의 접수→마감 점수→낙찰/탈락→유효 사업 계약/정부 지급을 실제 Pipeline 진입 API와 권위 모델로 공급한다. UI 연결은 DEV-019에서 수행한다.

| 변경 파일 | 목적 |
| --- | --- |
| assets/data/stage2_tenders_v1_3.json | DATA1.3의 B01/B02와 비노출 외부시 필터용 B-X 입력·출처 고정 |
| scripts/data/tender_data_loader.gd 및 uid | 타입·버전·고정 조건/노선 검증, 정수 통화/게임분 공급 |
| scripts/model/public_tender.gd 및 uid | 접수/마감/당시 판정/사업 계약, 자격·사유·허용행동·정확한 유리수 점수 |
| scripts/simulation/tender_service.gd 및 uid | 응찰 전용 명령·야간 접수·마감 판정·멱등 계약/지급·snapshot 공급 |
| scripts/simulation/minute_pipeline.gd | 명시적 enable/submit/result, 기존 CONTRACT 단계 연결·관측 revision 반영 |
| tests/game/run_w04a_tests.gd·w04a_fixtures.gd 및 uid | 승인 입력의 정상/반례/원장·시간·조회 자동 재현 |
| DEV-018 티켓·결과·분할안·PROVENANCE | 승인 원문/범위·실제 상태·후속 의존성·제출 출처 |
| docs/engineering/evidence/DEV-018_*.md/json | 실제 공급 계약, 자동 fixture·기대/실제·소스 해시·검증 요약 |

정상86:80, F변동80:80 동점 탈락, [360,1800) 야간 접수·마감 거부, 대상/회차/계획 변경·중복, 정부 지급1회 및 C1800000/R800000/F1000000/K0/B0을 검증했다. 표시값 반올림을 비교에 사용하지 않는다. 당시에 판정된 자금과 현재 자금은 분리한다.

## 검증 명령과 실제 결과

아래 godot는 환경에 설치된 Godot4.7.2 콘솔 실행 파일을 의미한다. [기계 판독 검증/소스 해시](../evidence/DEV-018_VALIDATION.json), [실제 fixture](../evidence/DEV-018_W04A_FIXTURES.json), [SUP01~08 실제 계약](../evidence/DEV-018_SUPPLY_AND_VALIDATION.md)을 함께 검토한다.

| 구분 | 명령 | 결과 |
| --- | --- | --- |
| 사전 환경 | .venv/Scripts/python.exe tools/policy.py doctor | PASS. 원격 보호/Owner 인증과 구분 |
| 정책 전체 자동 | .venv/Scripts/python.exe -m unittest discover -s tests/tooling -v | 89 tests, OK, exit0 |
| W04A 자동 | godot --headless --path . --script tests/game/run_w04a_tests.gd -- --evidence=res://docs/engineering/evidence/DEV-018_W04A_FIXTURES.json | 204 checks /0 failures, exit0 |
| 실패 감지 | 같은 러너 -- --verify-failure-exit | 의도 실패1건, exit1 확인 |
| 기존 게임 회귀 | godot --headless --path . --script tests/game/run_w01_tests.gd, run_w02_tests.gd, run_w03_tests.gd, run_w07_tests.gd 각각 실행 | 219/309/101/322, 합951 checks /0 failures, 각각 exit0 |
| 프로젝트 로드 | godot --headless --editor --path . --quit | exit0, SCRIPT ERROR/ERROR 없음 |
| 제품 진입 | godot --headless --path . --quit-after 3 | exit0, 엔진 오류 없음. 신규 W04A UI 실행을 의미하지 않음 |
| 실제 W04A GUI/교차 디자인 수용 | NOT_RUN | DEV-019 이후 실제 P01/P02/P05 조작·역순 응답/조회 실패 UI 검증 |
| VS01 완주·W05/W06·빌드/성능 | NOT_RUN | 후속 개별 승인 티켓 |

최초 sandbox 엔진 로드에서 사용자 설정 경로 접근 오류와 새 코드의 bool 타입 추론 파싱 오류를 확인했다. bool 타입 명시 후 정상 실행 환경에서 오류 없이 재검증했다. 정책 check는 sandbox 임시 폴더 거부 후 같은 검사기를 정상 권한으로 재실행하며 규칙/CI/훅을 수정하거나 우회하지 않았다. 최종 check/preflight·commit/push/PR/CI 결과는 제출 시점의 SHA로 PR에 추가한다.

## 회귀·미해결 및 인계

- S2-01 기존 회귀 및 S2-02/03 모델·자동 부분/S2-11 증거 제출이다. 실제 GUI 및 S2-02/03 전체·S2-08/10/Stage2 DONE을 선언하지 않는다.
- SEM/CLOSE 단계 순서와 기존 원장·Queue·Clock·W01/W03/W07 소스/테스트는 변경하지 않았다. 단일 Pipeline의 CONTRACT에만 실제 입찰 경로를 연결했다.
- 새 게임 RNG 사용 없음. F01은 미래 최초 사용 기능 통합 전 직접 seed/state/시퀀스 검증 의무로 유지한다.
- Design 최초 차단은 DEV-019 실제 공급·UI 통합 전. 명령 requested_at과 실제 접수 effective_at, 판정/계약/지급, 현재/당시 snapshot을 분리해야 한다. 미수신·0·조회 실패 및 역순 응답 소비는 해당 UI에서 검증한다.
- W05는 유효 사업 계약/지급/R·사업ID를 소비하고 공사 계약을 별도로 생성해야 한다. 종료/해제 상태와 진행 사업 판정의 생명주기 연결은020, 비영K 미래 약정은 별도 HQ/Owner 결정이다.
- 명세 변경 필요 없음. 추가 범위 변경·타 부서 산출물·정책/CI 수정 없음. 원격 CI/검토 성공도 Owner 승인/신원 인증/DONE이 아니다.
