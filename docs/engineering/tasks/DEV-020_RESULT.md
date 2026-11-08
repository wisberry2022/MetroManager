# DEV-020 W05 모델 구현 검수 요청

- 작업 DEV-020 / 담당 AGT-DEV-0001 / LAPTOP / 2026-11-08 / REVIEW.
- 구현 기준 main `98d56eb97f8a030912bea534ff1c330e9c40188e`, 브랜치 `codex/DEV-020-construction-model`.
- 제출 기준 main `02146a027a373b6a2d42fa40c581812e84ad6c44`. 구현 기준 이후 기획의 별도 후임 인계 문서3개만 추가됐으며 게임 소스·검사·기존 승인 명세는 동일하다. 제출 전 전용 브랜치를 fast-forward했고 구현/검증 기준과 제출 기준을 구분한다.
- W05 자동 191단언과 기존 회귀 1390단언, 도구89검사 PASS. 구현 결과의 검수를 요청한다. 이 문서 작성은 승인/DONE이나 main 병합이 아니다.

## 승인과 변경

Owner 원문과 정확한16개 경로는 [티켓 §3·10·12](DEV-020_W05_CONSTRUCTION_MODEL.md)에 보존했다. 신규 코드/검사4개와 UID4개, 공통 소스2개, 개발 문서3개, 공개 증거3개다. main 병합·DEV021 UI·W06·W04B·정책/CI/타부서 문서 변경은 제외한다. 별도 worktree를 사용해 기존 루트와 다른 작업물은 보존했다.

[Planning Owner 정책 결정](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6719007539)으로 R01~03의 차단이 해소됐다. 실제 착공 기산, 수리 자기R+A 전액 선지급, 수행 공정 보존과 기성 미지급/B 분리, 공사계약만 업무시간 이연을 적용했다. 기존 사업계약 기산 문구의 공식 개정은 Planning/HQ 후속이며 승인되지 않은 새 규칙을 추가하지 않았다.

- ConstructionProject는 계약·공정·기성 발생/지급/미지급·시범·안전·수리·개통 상태를 소유한다. 같은 분 공정 누적은 중복되지 않는다.
- ConstructionService는 실제 W04A 사업계약/정부지급 연결을 검증하고 별도 공사계약을 생성한다. 명령ID 멱등, 요청/효력/출처revision, 선행조건·조건revision 거부, 권위 snapshot·행동·사유를 공급한다.
- CompanyLedger는 기존 단일 경제 권위를 유지한다. W05 기성 발생과 실제 지급을 분리하고 자기K의 실제 자유현금 및 타사업 보호금을 검사한다. 수리는 원자적 전액 지급이며 운영 B를 변경하지 않는다. 기존 construction_payment 기본값은 W02 동시 발생/지급과 호환한다.
- MinutePipeline은 기존 단계·자정 보고 순서를 유지하면서 W05를 명시적으로 활성화한다. 유효 개통 전 일반 탑승을 차단한다. 실제 W06 운행이나 운임을 생성하지 않는다.

상세 필드·타입·사유·기간·자정 귀속은 [공급 계약](../evidence/DEV-020_W05_SUPPLY_AND_VALIDATION.md), 실행 원본은 [fixture](../evidence/DEV-020_W05_FIXTURES.json)와 [검증 JSON](../evidence/DEV-020_W05_VALIDATION.json)이다.

## 검증 명령·상태

아래 명령은 이 worktree 기준이다. Godot은 상위 설치의 `../../../../godot/Godot_v4.7.2-stable_win64_console.exe` 4.7.2.stable.official.ed1daf0bf를 사용했다. 검사 로그는 로컬 `.local/`에 있으며 공유 가능한 요약·종료코드·해시·소스 blob은 검증 JSON에 기록한다.

각 기존 회귀 러너에는 `--log-file .local/<runner>.log`를 추가했고 stdout/stderr는 `.local/<runner>.stdout.log`에 저장했다. 이 로그들은 로컬 재현 원본이며 공유된 원본 해시는 검증 JSON에 남긴다. 자동검사와 실제 GUI 인수를 구분한다.

| 검사 | 명령 | 실제 상태 |
| --- | --- | --- |
| W05 | Godot --headless --path . --log-file .local/w05-verified.log --script tests/game/run_w05_tests.gd -- --evidence | 191단언, 실패0, exit0 |
| 실패 검출 | Godot --headless --path . --log-file .local/w05-failure-exit.log --script tests/game/run_w05_tests.gd -- --verify-failure-exit | 의도한 실패1건, exit1 확인 PASS. 제품 실패가 아님 |
| W01 | Godot --headless --path . --script tests/game/run_w01_tests.gd | 219단언, 실패0, exit0 |
| W02 | Godot --headless --path . --script tests/game/run_w02_tests.gd | 309단언, 실패0, exit0 |
| W03 | Godot --headless --path . --script tests/game/run_w03_tests.gd | 101단언, 실패0, exit0 |
| W04A | Godot --headless --path . --script tests/game/run_w04a_tests.gd | 204단언, 실패0, exit0 |
| W07 | Godot --headless --path . --script tests/game/run_w07_tests.gd | 322단언, 실패0, exit0 |
| DEV019 UI 자동 | Godot --headless --path . --script tests/game/run_tender_ui_tests.gd | 235단언, 실패0, exit0 |
| 프로젝트 로드 | Godot --headless --editor --path . --log-file .local/project-load.log --quit | exit0, SCRIPT ERROR 없음. 게임 플레이/빌드와 구분 |
| 도구 회귀 | .venv/Scripts/python.exe -m unittest discover -s tests/tooling -v | 89검사, OK, exit0 |
| 훅/코드 정책 | .venv/Scripts/python.exe tools/policy.py doctor 및 check | PASS. 원격 최신성/Owner 승인 자체 검증은 아님 |
| provenance | tools/agent_provenance.py, 확정 base/head SHA와 manifest로 실행 | 최종 커밋으로 실행, 결과는 Issue76/PR에 기록. REPORT_ONLY |
| 제출 | fetch·정상 commit·tools/policy.py preflight·일반 push·PR | 최종 커밋/PR·preflight 결과는 원격 제출 기록에서 확인 |
| 원격 CI | policy / department-policy | 이 파일 작성 시 NOT_RUN. 생성 PR의 실제 최신 head 검사 결과가 최종 근거 |
| W05 GUI/VS01/Windows export | 이번 모델 티켓 범위 밖 | NOT_RUN |

초기 검사에서 잘못된 지급 연결값의 int/String 비교 오류를 발견해 공급 타입 검사를 추가했다. 초기 오류 로그가 있는 실행은 PASS 증거로 쓰지 않는다. 중복 분 공정 누적 방어·탑승 차단 반례를 추가한 뒤 최종 러너로 다시 검사한다. 원래 보고서의 비용 kind를 추가하지 않고 기존 construction_cost/construction_payment에 연결했다. 새 경제 상태를 원장 밖에 복제하지 않는다.

## 인수·잔여 및 부서 인계

- S2-04/05: 모델/자동 증거만 공급. S2-07은 공통 원장/보고 회귀, S2-11은 버전·명령·입력/기대/실제·종료·제출 증거다. Stage 또는 S2 전체 PASS를 선언하지 않는다.
- Design L2: DEV021 통합 전 DEV020-W05-UI-1의 계약 전 행동, 공정·기성 발생/실지급/미지급, 자금 중단/재개, 시범/안전/수리/개통을 검토받는다. 실제 화면/가독성/오류·역순 소비는 DEV021·Design 독립 검수다. 현행 P05 읽기 전용과 A01-Q12 PARTIAL은 유지한다.
- Planning/HQ: 결정된 착공 기산 및 수리/미지급/시간 세칙의 정식 명세 버전 반영은 후속이다. 새 정책 선택은 현재 필요하지 않다. 미래 비영K 모드 약정, 부분 변제, 지체상금/납기 제재는 추가하지 않았다.
- F05 모델·F10 공급·F11 실행 승인 근거를 인계한다. F01은 RNG 미도입으로 최초 RNG 기능 통합 전, F07 전체 MVP/VP 검증과 F08 규격·성능/Windows export는 후속 의무다.
- 비영K/두사업·부족/회복 fixture는 승인 DATA 및 Owner R03을 위한 내부 반례다. 일반 제품에 자금 주입·추가 약정·동시사업 기능을 추가하지 않는다. 기존 테스트용 arrival_fare를 제품 일반 승객 운임으로 주장하지 않는다.

Agent-ID: AGT-DEV-0001
Task-ID: DEV-020
