# DEV-020 — W05 실행 승인 요청 패킷

- 담당 Development Project Leader / LAPTOP / AGT-DEV-0001.
- 상태 OWNER_EXECUTION_AND_GIT_APPROVED / RULE_INPUT_READY / IMPLEMENTATION_REVIEW. §1~11의 준비·대기 상태는 당시 이력이며 현재 근거는 §12를 따른다.
- 기준 main `8f8cc57d71b42b8c5132e93e24475caa052db273`, 정식 [Issue #76](https://github.com/wisberry2022/MetroManager/issues/76). READY는 승인 요청서 준비이며 구현 착수 가능/검증 완료가 아니다.
- 준비 브랜치 codex/DEV-020-w05-approval-preparation. 실행 제안 브랜치 codex/DEV-020-construction-model: Owner 승인 후 당시 최신 main에서 생성한다.
- 근거: Owner가 전달한 HQ 「Gate 3-2 Stage 2 W05 실행 승인 패킷 준비 및 W04A 잔여 QA 증거 인계 지시」. 이번 허용은 준비·정적 기술 검토이고 신규 코드/테스트/씬·Commit/Push/PR 권한이 아니다.

## 1. 승인 원본·선행 공급

[PM-014](../../hq/PM-014_STAGE2_VS01_EXECUTION_PLAN.md), [Gate2 최종 승인](../../planning/PLN-001_GATE2_FINAL_APPROVAL.md), [C v0.6](../../planning/PLN-001-C.md), [D v0.9](../../planning/PLN-001-D.md), [DATA v1.3 §3·5·6](../../planning/PLN-001_GATE2_DATA_v1_DRAFT.md), [UI 데이터 계약](../gate3/DEV-006_UI_DATA_CONTRACT.md)을 적용한다. DATA의 DRAFT 파일명과 승인된 현재 본문을 구분한다. [Planning 기존 회신](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6716236853)의 고정공기·K0 의미를 보존한다.

DEV018의 [실제 공급 계약](../evidence/DEV-018_SUPPLY_AND_VALIDATION.md): Pipeline.snapshot().tenders.tenders의 terms/decision/business_contract를 소비한다. business_contract.status=EFFECTIVE, project_id, effective_at, 정부 지급 available/transaction_id/amount/ledger_entry_index/restricted_project_id, 해당 사업 R과 고정 노선을 검증한다. business_contract_id와 새 construction_contract_id는 별개다. 낙찰 AWARDED만으로 착공하지 않고 계약/정부지급 누락·거부·다른 사업·중복은 거부한다. 정부금을 다시 지급하지 않는다.

W04A의 QA001/002는 [Design 독립 재검수](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6717973962)에서 FIX_VERIFIED다. Q03/04/05 미완료는 이 패킷 승인 심사의 선행조건이 아니며, Q12 실제 공사는 DEV020→DEV021→Design A02에서 해소한다.

## 2. 포함·제외 및 공급

| 포함 | 구현·검증 목표 |
| --- | --- |
| 공사 계약/착공 | 유효 사업 계약·정부 지급을 소비하는 별도 공사 계약·모드/노선/사업 연결, 명령ID·대상/revision·요청/효력분·멱등 결과 |
| 표준/빠른 공사 | 600000/2880분 및 720000/1440분. 고정 공고 공기 변경·입찰 모드 옵션 추가 없음 |
| 기성/공정 | 누적 floor(총액×유효 경과분/기간)의 차액. 최종합계 정확, 중복지급0, 미지급 최종기성에서는 완공 금지. 부족 중단/복구·재개 및 공정/지급 분리 |
| 자금 | 기존 CompanyLedger 단일 권위, 사업별 R/K 보호·자기부담 기성에서만 자기K 차감. 자금부족으로 R전용/K해제 없음 |
| 검증/개통 | 시범60·안전60 독립 시작/완료, 빠른 첫 안전결함1개→수리20000/30→안전재시험60, 해소 결함 동일재발0. 영향 조건 revision 변경 시 해당 시험 무효화 |
| 영업 차단 | 유효 개통 전 서비스준비 false·일반 탑승/운임0의 경계 공급. 시험열차에 일반매출 부여 금지 |
| 후속 계약 | 동일 snapshot_revision의 공사/공정·누적비용/실지급·자금/중단원인·시범/안전/수리/개통·reason_codes/allowed_actions, 명령별 결과·효력분을 DEV021/022에 공급 |

제외: DEV021 실제 화면/씬·S01/P05 제품 연결, W06 OD/실제 승객/운임/만족/보고 확장, W04B/VS02·RNG, 새로운 계약 제재·취소·대출·약정 정책, 정부잔액 자유해제/반환, 정책/CI·타부서 문서·미승인 제품규격/아트, VS01 완주·Windows export/릴리스. 내부 무효화 시험은 조건 revision 반례이며 플레이어 조건변경 기능 제작이 아니다.

## 3. Owner가 승인할 정확한 파일 경로

| 구분 | 경로 및 한정 변경 |
| --- | --- |
| 신규 모델/서비스 | scripts/model/construction_project.gd 및 .gd.uid; scripts/simulation/construction_service.gd 및 .gd.uid |
| 신규 검사/fixture | tests/game/run_w05_tests.gd 및 .gd.uid; tests/game/w05_fixtures.gd 및 .gd.uid |
| 공통 연결 | scripts/simulation/minute_pipeline.gd: 기존 CONTRACT/PROGRESS/VALIDATION 안에서 W05 명령·기성·검증/개통 처리, 읽기 snapshot/결과/서비스준비 공급. 기존 W04A·자정·도착·정산 순서 보존 |
| 원장 한정 수정 | scripts/model/company_ledger.gd: 기존 기성 지급의 실제 자기자금·타사업R/K 보호 및 원자성 검사, 합의된 수리 지출 연결에 필요한 최소 API. 새 경제 권위/정책·범용 회계 재작성 제외 |
| 문서 | docs/engineering/tasks/DEV-020_W05_CONSTRUCTION_MODEL.md; DEV-020_RESULT.md; DEV-020_PROVENANCE.json |
| 공개 증거 | docs/engineering/evidence/DEV-020_W05_SUPPLY_AND_VALIDATION.md; DEV-020_W05_FIXTURES.json; DEV-020_W05_VALIDATION.json |

총16개 정확한 경로(신규 GDScript4+UID4, 공통2, 문서3, 증거3)다.

```text
scripts/model/construction_project.gd
scripts/model/construction_project.gd.uid
scripts/simulation/construction_service.gd
scripts/simulation/construction_service.gd.uid
tests/game/run_w05_tests.gd
tests/game/run_w05_tests.gd.uid
tests/game/w05_fixtures.gd
tests/game/w05_fixtures.gd.uid
scripts/simulation/minute_pipeline.gd
scripts/model/company_ledger.gd
docs/engineering/tasks/DEV-020_W05_CONSTRUCTION_MODEL.md
docs/engineering/tasks/DEV-020_RESULT.md
docs/engineering/tasks/DEV-020_PROVENANCE.json
docs/engineering/evidence/DEV-020_W05_SUPPLY_AND_VALIDATION.md
docs/engineering/evidence/DEV-020_W05_FIXTURES.json
docs/engineering/evidence/DEV-020_W05_VALIDATION.json
```
 이 외 파일이 필요하면 추가 경로·영향을 제출해 승인 범위를 확정한다. 기존 테스트/CommandQueue/TenderService/DailyLedgerReport/데이터/씬/UI/설정은 읽기·회귀 실행만 한다. 현재 신규 소스/테스트 파일은 작성하지 않았다.

## 4. 공통 시각·원장 영향과 회귀 책임

- MinutePipeline이 유일한 시각/단계 권위다. 이전 구간 누적→자정마감→계약/정부지급→기성/완공→시험/개통→도착운임→B정산→신규탑승 순서를 보존한다. W05는 보조 시계·자체 현금/정부금 잔액을 소유하지 않는다.
- 기존 회사 계약 Queue의 payload는 정부지급/총공사비 전용이다. W05를 임의의 정부금 재계약으로 밀어 넣지 않는다. W05 서비스의 명령 처리와 기존 Pipeline 단계만 연결하며 업무시간 의미는 아래 RFC로 확인한다.
- 현행 construction_payment는 프로젝트 키/자기K/총현금을 검사한다. 지급 가능한 자기 자유현금과 다른 사업 예약 보호를 추가 검토할 지점이다. 정적 위험이며 신규 실패 재현/제품 결함 확정은 아니다. 실제 fixture로 확인하고 승인된 보호 의미에 맞는 최소 검사만 보완한다.
- W02 비용발생/실지급/후정산·보호금·자정 고정보고·시간외 계약 이연, W04A 공개점수/마감·중복계약/정부지급·현재/과거, W01/03/07·DEV019 UI를 DEV가 회귀 책임진다. 공통파일 변경만으로 새 게임 정책을 승인받는 것으로 취급하지 않는다.
- 거래 거부/중복/조회는 원장효과0. 기성·수리의 실제 원장 kind/보고 연동은 합의 의미 안에서 기존 construction_cost/construction_payment와 호환하도록 설계한다. 보고서 스키마 변경이 필요하면 정확한 추가 경로를 먼저 요청한다.

## 5. 검증 계획·승인 fixture — 모두 NOT_RUN

| ID | 입력과 정적 기대/확인 |
| --- | --- |
| W05-N01 | 실제 DEV018 B01 계약·정부금1회→표준 기성합600000. 영업 전 C1200000/R200000/F1000000/K0/B0, 공정100%·기성완료. 시작기산점은 RFC 답변 후 고정 |
| W05-P01 | 표준 누적1분208,2분416,3분625,2879분599791,2880분600000; 빠른1분500/1440분720000. 최종잔액·floor/중복/부분분·분할/배속 동일 |
| W05-K01 | DATA §6 승인 소액단위 fixture: C100/R0/K0→G80/총110→C180/R80/F100/K30/A70; 자기기성90→C90/R0/K20/A70; 추가20→C70/R0/K0/A70 |
| W05-K02 | DATA 두 사업 fixture: C200/R1=80/R2=40/K1=30/K2=10, 사업1기성90→C110/R1=0/R2=40/F70/K1=20/K2=10/A40. 사업2 보호금 불변. 다중 동시사업 제품 허용으로 확대하지 않는 내부 원장 반례 |
| W05-K03 | 부족/재개·최종1회 실패: 초기R/K 보호, 실패 거래/완공효과0, 재원 회복 후 승인 의미의 재개·남은 기성만 집행. 중단 중 공정/비용 누적 기준은 RFC 확인 후 기대값 고정 |
| W05-V01 | 완공전 시험/중복시작/0·59·60분, 시범/안전 독립, 빠른 첫결함/수리30·20000/안전60재시험, 재시험 결함미재발. 영향 revision 변경/낡은 결과/개통 중복·미검증 영업0 |
| W05-T01 | 같은T 계약/정부금→기성/완공→시험/개통→도착운임/B, 후순위 운임 선사용 금지, 자정 고정보고 불변·새날지출. 1/2/4배속·일괄/분할·정지/부분분 동일 |
| W05-F01 | 무효·미지급 사업계약/다른ID/중복정부금·같은command_id/조건변경/재조회·스냅샷 복사/거부 부작용0 |

fixture K01/K02는 Owner 승인 DATA의 정적 정답을 사용한다. B01 K0만으로 비영K 감소/두사업 격리 검증 완료를 주장하지 않는다. 부족 상태/회복 입력 및 실제 요청·효력 시각은 승인 후 fixture JSON에 명시하며 새 재원 지원 기능을 만들지 않는다.

계획 명령: Godot4.7.2 --headless --path . --script tests/game/run_w05_tests.gd, 별도 실패검출/증거 옵션; 기존 run_w01/w02/w03/w04a/w07/tender_ui_tests; --headless --editor --path . --quit. 정책 doctor/check, unittest discover -s tests/tooling -v, 정상훅·fetch/커밋후preflight·PR policy/department-policy. 실제 옵션은 구현 결과에 정확히 기록한다. 모델 티켓에서 제품 W05 GUI/실제 운행/VS01 완주/Windows build는 NOT_RUN 유지한다.

## 6. RFC-DEV-020-01 — W05 시각·비용/복구 의미 확인안

상태 OPEN / PLANNING_RESPONSE_PENDING. [Issue26 등록](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6718170718). 요청 DEV / 응답 Planning, 필요 시 HQ→Owner. 기존 승인 수치의 재설계가 아니라 아래 미확정 연결 행만 확인한다. 원문 기준은 §1의 고정 main 문서와 Planning 회신이다.

| 질문 | 확인 사실·정확한 반례 / 최초 차단 |
| --- | --- |
| R01 계약·착공/공기 기산점 | 공고2880분은 계약 효력 기준, 표준 실제공사도2880분, 실제 UI는 확보 후 별도 공사계약/착공이다. 사업계약T1800 후 사용자가T1801 이후 착공하면 사업계약기준 만료T4680과 실제완공T4681 이상이 달라진다. 기산 계약이 사업계약인지 공사계약인지, 고정공기와 늦은착공 처리의 기존 의미를 확인. 자동착공/소급진행/기간연장/패널티를 임의 추가하지 않는다. 착공/기한 판정 구현 전 차단 |
| R02 수리비20000의 재원·인식 | 금액/30분/재시험60은 확정. 빠른공사후 C1080000/R80000/K0에서 수리를 자기 사업R로 지급하면 C1060000/R60000/F1000000, 자유자금이면 C1060000/R80000/F980000이다. 어느 승인 의미인지, 지출 효력/수리비 예약 필요 여부를 확인. B01 K0을 미래 비영K 모드 약정 정책으로 일반화하지 않는다. 수리 원장/API 구현 전 차단 |
| R03 중단/재개·작업 명령/시험 | 자금부족 분의 유효공정/기성 누적·재개시 재시도 기준 및 실패기성의 발생비/미지급B 귀속, 공사계약의 기존 업무시간 이연과 착공·시범·안전·수리·개통 명령의 적용 범위, 각 시험의 시작분/완료분 기준을 확인. 제안은 실패분 공정 확정0/중복비용0·각 절차 독립 기간이며 확정 아님. 해당 상태전이/시간 경계 기대값 고정 전 차단 |

일정 영향은 해당 구현/기대값 고정 행에 한정한다. 독립 모델구조/기존 원장 검토 및 W04A 잔여 QA 계획은 계속 준비 가능하다. Planning L2로 해소되면 신규 정책 승인 요청을 반복하지 않는다. 승인 원문과 실제로 충돌하거나 새 규칙이 필요할 때만 범위를 특정해 HQ L3/Owner에 상정한다. 담당 의견/답변 PENDING, HQ 조정 PENDING, 명세 변경 필요 여부는 답변 후 판단. Owner의 구현/Git 승인과 별개의 선행 의미 확인이다.

## 7. L1/L2/L3·인수/F-ID와 권한 요청

- L1: DEV 구조·입력검사·멱등·원장/시각 자동회귀·결과/증거·출처 선언.
- L2 Planning: RFC 영향 행은 구현 전, 그 외 승인된 공정/시험·SEM 의미는 실제 공급/원장 반례 완성 후 해당 기능 인수 전 검토. Design: UI-DC04/05/07의 상태·사유·행동·정상/실패 fixture를 DEV021 실제 화면 통합 전 검토. 미확정 콘셉트는 모델 선행조건 아님.
- L3 위험평가: 공통 시각/원장 연결·R/K 보호·후순위 운임·자정은 회귀 필수. 승인 경제 규칙/범위 변경·해결 불가 부서 충돌만 HQ/Owner 결정 대상. 기존SEM 구현 자체에 일괄 새 정책 승인 의무를 부과하지 않는다.
- S2-04/05 모델·자동, S2-07 원장/보고 회귀, S2-11 버전·입력/기대/실제·명령/게임분/원장·로그/종료코드·SHA/CI 취합. 해당 UI 인수와 S2 전체PASS는 별도다.
- F05 시공/검증/영업준비는 해당 경로 인수 전, F10 공급/fixture는 DEV021/022 통합 전, F11 각 실행/제출 전. F01은 RNG 미도입으로 미래 최초기능 전 유지, F07 MVP최종·F08 규격/성능 전 의무는 그대로다.

Owner 요청: wisberry2022/MetroManager / DEV-020 / AGT-DEV-0001 / codex/DEV-020-construction-model / §3의16개 경로와 §2·5 범위에서 코드·테스트·문서/증거 작성, 자동/프로젝트로드 검증, 정상 Commit, 해당 브랜치 일반 Push, base main PR 생성·필수CI 확인 및 동일범위 검수 보완을 개별 승인 요청한다. 유효기간은 명시 승인부터 해당 티켓 제출/같은범위 검수 대응 종료 또는 철회까지다. 의미 미회신 영향 행은 승인 후에도 차단을 유지한다. main 병합·강제Push/공유이력재작성·자동병합·릴리스/배포·다른티켓/정책/타부서 변경은 제외한다.

승인 예시: “Issue #76의 DEV-020 W05 모델 구현 및 명시된16개 경로의 Commit·Push·PR 생성을 승인합니다. RFC-DEV-020-01의 영향 행은 Planning 회신 확인 후 구현하고 기존 규칙·범위를 유지하며 검증 후 PR을 생성해주세요. main 병합은 별도 승인하겠습니다.”

## 8. 이번 준비의 실제 상태

수행: 최신 원격 main/Issue76·Planning/Design 회신·승인 원문/소스/기존증거 정적 대조, 전용 로컬worktree와 이 패킷. 신규 게임코드/테스트/씬/fixture 실행파일 작성0. DEV020 자동/프로젝트로드/GUI/빌드/CI는 NOT_RUN. Commit/Push/PR/main병합0. RFC는 Issue26에 등록했으며 Planning 회신 대기다. 문서 UTF-8/LF·상대링크 검사 PASS, 전용worktree에서 기존 DEV019 가상환경 Python으로 doctor/check PASS(459파일/GDScript31). 최초 TEMP 접근오류는 프로세스 TEMP/TMP를 자체 .local/temp로 바꾼 뒤 재검사해 해소했다. 게임 자동검사·엔진 실행은 하지 않았다.

Agent-ID: AGT-DEV-0001
Task-ID: DEV-020

## 9. Owner 지시에 따른 원격 댓글 등록

[Issue76 승인 패킷 전문](https://github.com/wisberry2022/MetroManager/issues/76#issuecomment-6718174077), [Issue26 RFC](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6718170718)을 등록했다. 게시 시점 최신 main은 c81b29585496fd291cfc4aeb443ed3e5ff14c588이며 기준 후 Design 문서3개만 추가, 관련 게임 소스/기획승인본 불변이다. Design A02 공급 요청6718093921은 댓글의 등록 시점 보충에서 수신/계획과 실제 미구현을 구분했다. 실행/Git 권한은 여전히 대기이며 댓글 등록은 Commit/Push/PR이 아니다.

## 10. Owner 실행·Git 승인 수신 및 Planning 회신 대기

Owner 현재 직접 원문: “개발 에이전트. Issue #76의 DEV-020 W05 모델 구현 및 패킷에 명시한 16개 경로의 Commit·Push·PR 생성을 승인합니다. Planning의 RFC-DEV-020-01 회신을 확인한 뒤 티켓 범위만 작업하고 검증 후 PR 생성해주세요. main 병합은 별도 승인하겠습니다.”

§3의16개 정확한 경로와 §2/5의 구현·검증·정상 Commit/일반Push/PR 권한을 수신했다. main 병합·다른 티켓/정책/타부서 변경·강제Push·릴리스는 제외한다. 실행 브랜치 codex/DEV-020-construction-model, 독립worktree의 base/latest main c81b29585496fd291cfc4aeb443ed3e5ff14c588에서 준비했다. 기존 준비/DEV019/루트 작업물은 보존했다.

Issue26 전체 댓글을 직접 확인했으나 현재 RFC-DEV-020-01 요청6718170718 이후 Planning 회신이 없다. 기존 RFC-DEV-018-01 회신6716236853은 W04A 기준이며 이번 미확정3행 회신으로 재사용하지 않는다. WAITING_FOR_PLANNING_REPLY이며 지정된 “회신 확인한 뒤” 순서를 유지한다. 회신 등록·직접링크·Owner 전달 본문 확보 시 유효한 기존 승인으로 검토 후 진행하며 실행/Git 재승인은 요청하지 않는다.

이번은 전용 실행환경·승인 기록 준비만 수행했다. 신규 게임코드/테스트/씬 작성·DEV020 자동/프로젝트로드/GUI/빌드·Commit/Push/PR은 NOT_RUN/미수행이다.

## 11. Design 추가 회신 재확인·Planning 미해소

[Issue26 Design 회신6718740574](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6718740574)을 직접 확인했다. DESIGN_SUPPLY_SCOPE_REVIEWED를 수신했으나 R01/R02/R03의 Planning 답변은 명시적으로 PENDING이다. Design이 소비/표현을 수용한 사실을 게임 의미 확정이나 PLANNING_RESPONDED로 취급하지 않는다. Owner가 앞서 부여한16개 경로의 구현/Git 권한은 유효하며 재승인은 불필요하다.

최신 원격main96139dfb1fd26f449e84e7f08986b0ab17e06787을 확인했다. 구현 재개 전 이 기준과 적용지침/등록부를 다시 조사한다. 기존 실행 worktree는c81b295에서 준비한 상태로 보존한다. 현재 신규 코드/테스트/씬·Commit/Push/PR/게임 검증은 미수행이며 WAITING_FOR_PLANNING_RFC_DEV_020_01을 유지한다.

## 12. Planning Owner 결정 수신·기존 승인으로 구현 재개

2026-11-08 [Planning 최종 회신6719007539](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6719007539)을 직접 확인했다. R01/R02/R03의 여섯 선택을 Owner가 모두 A안으로 결정했음을 명시하며 RULE_INPUT_READY다. Design 의견을 Planning 결정으로 대체하지 않았고, 미결 답변6718887622는 후속 결정으로 해소됐다.

- 공사 기간은 실제 유효 착공 T부터 N분, 완료 T+N이다. 기존 사업계약 기산 문구는 명시 개정 대상이다.
- 수리비20000은 자기 R 우선→A, 전액 선지급 성공 후 수리30분이다. 부족 시 부분지급/수리진행0, 타사업R/K 및 임의 K 전용0이다.
- 수행 공정과 기성 발생은 실패해도 보존한다. 미지급 기성은 운영 B와 별도로 남기고 후속 진행을 중단한다. 재개는 기존 미지급 전액 우선 지급, 비용 중복발생0이다. 최종 미지급에서는 완공 불가다.
- 공사계약만06:00~24:00 이연, 나머지 명령은 선행조건을 충족하면24시간 허용한다. 시범60/안전60/수리30/재시험60 독립 및 SEM/CLOSE 순서를 유지한다.

공식 기획 문서 개정은 Planning/HQ 후속(SPEC_DOC_REVISION_PENDING)이며 타부서 문서 수정은 §3의16개 경로 밖이다. 기존 §10의 Owner 승인과 현재 직접 재확인 지시로 실행하며 신규 정책 선택·동일 범위 Git 재승인은 필요하지 않다. main 병합·DEV021 UI·W06·정책/CI 변경은 제외한다.

전용 codex/DEV-020-construction-model을 최신 main `98d56eb97f8a030912bea534ff1c330e9c40188e`로 fast-forward했다. 루트/타 worktree 작업물은 보존했다. [Issue76 착수 기록](https://github.com/wisberry2022/MetroManager/issues/76#issuecomment-6719137242)을 등록했다. §5의 과거 NOT_RUN은 계획 당시 상태이며 실제 검증은 [결과](DEV-020_RESULT.md)와 [공급·증거](../evidence/DEV-020_W05_SUPPLY_AND_VALIDATION.md)에서 구분한다. 구현 결과는 검수 요청이며 Owner 승인/DONE이나 S2 전체 PASS가 아니다.
