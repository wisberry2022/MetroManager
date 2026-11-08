# DEV-018 — Stage 2 VS-01 실행 티켓 분할·검증·인계 준비

- 기준 main `b48dd82a9b93d062d1a3bcfdf8750cb260c83e3e` / 2026-11-08 / AGT-DEV-0001 (Development Project Leader LAPTOP).
- [PM-014 공식 계획](../../hq/PM-014_STAGE2_VS01_EXECUTION_PLAN.md)의 Owner 승인 Track A 수신. Track B DSG-006은 병렬/비차단. 본 문서는 승인된 준비 산출물이며 제작·Commit·Push·PR·병합 권한이 아니다.
- 기대 상태 **STAGE2_DEV_SCOPE_ACKNOWLEDGED / W04A_EXECUTION_TICKET_READY**. READY는 구체 승인 패킷 준비이고 W04A 제작/검증 완료가 아니다.
- [DEV-018 첫 실행 티켓](../tasks/DEV-018_W04A_BID_CONTRACT.md)과 #74에 경로·금지·명령/검증·승인 요청 원문 범위를 제시한다. 신규 실행 승인 PENDING. Planning RFC 영향 행은 답변 전 구현하지 않는다.

## 1. 기존 완료와 이번 준비 구분

Stage1은 PM-012 §7/PM-013의 Owner 최종 승인으로 S1-01~09 DONE이다. 기존 W01/W02/W03/최소 W07 및951개 게임 단언·80개 당시 정책 검사·제품/검증 GUI 증거는 해당 제품 QA SHA/수용 범위로 보존한다. PM-014 계획 병합은 Stage2 실제 기능 완성/검증이 아니다.

이번 실제 수행은 Git 상태/미공유 작업 보존·fetch·main/원격 Issue/PR/브랜치·로컬 refs/전체 커밋 제목/파일명 ID 검색, 승인 기획/PM014/원장·시각 소스 검토·doctor·준비 문서/Issue/L2 질의다. 신규 게임 코드·테스트·씬·아트는 작성하지 않는다. Stage2 자동/프로젝트 로드/제품 GUI/VS01/빌드/성능·원격 CI는 NOT_RUN, Commit/Push/PR/병합은 미수행이다.

ID 확인에서 DEV-017은 기존 Convention 출처 작업이며 재사용하지 않았다. DEV-018~024는 중복 없음 확인 후 #74~80으로 등록했다. 등록은 실행 승인/정식 산출물 Git 반영이 아니다. 실행 전에 latest main/티켓·브랜치 권한을 다시 확인한다.

## 2. 분할·담당·브랜치·경로·검증

W04A 모델→입찰 UI, W05 모델→공정 UI, W06 모델→운행/재무 UI, VS01 통합의7개 티켓이다. 모든 구현 주관은 DEV, 표현/실제 사용성 수용은 Design, 승인 의미 차이/반례는 Planning, 인수 통합/우선순위는 HQ, 실행 및 최종 수용 권한은 Owner다.

| 티켓 | 범위 | 검토 수준 | 연결 인수 |
| --- | --- | --- | --- |
| [DEV-018 #74](https://github.com/wisberry2022/MetroManager/issues/74) | W04A 입찰·낙찰·계약 모델 및 자동검증 | L2 / 기존 CONTRACT 단계 연결은 L3 위험 검토·회귀를 명시. 새 경제·시간 정책 변경은 제외. | S2-01, S2-02/03의 모델·자동 부분, S2-11 |
| [DEV-019 #75](https://github.com/wisberry2022/MetroManager/issues/75) | W04A 공고·응찰·결과·계약 최소 UI | L2 (DEV↔Design, 규칙 의미 차이만 Planning) | S2-02/03의 GUI·교차 수용, S2-08 부분, S2-11 |
| [DEV-020 #76](https://github.com/wisberry2022/MetroManager/issues/76) | W05 표준 공사·기성·시범·안전·개통 모델 | L2 + 원장/공통 시각 통합 L3 영향 검토 | S2-04/05 모델·자동, S2-01/07 관련 회귀, S2-11 |
| [DEV-021 #77](https://github.com/wisberry2022/MetroManager/issues/77) | W05 공정·자금 중단·검증·개통 UI | L2 | S2-04/05 GUI, S2-08 부분, S2-11 |
| [DEV-022 #78](https://github.com/wisberry2022/MetroManager/issues/78) | W06 실제 OD 운행·운임·정산·보고·다음 사업 공급 | L3 영향 검토 필수, 승인 의미 구현을 새로운 정책 승인으로 반복 요구하지 않음 | S2-06/07 모델·자동, S2-09 공급, S2-01/11 |
| [DEV-023 #79](https://github.com/wisberry2022/MetroManager/issues/79) | W06 운행·재무·경량 연출·보고·다음 사업 UI | L2 / 연출이 게임 원장·수요를 소유하지 않음 | S2-06/07 표현, S2-08/09 GUI, S2-11 |
| [DEV-024 #80](https://github.com/wisberry2022/MetroManager/issues/80) | W08 VS-01 통합 재현·회귀·실제 제품 GUI 인수 증거 | L2 통합 / 공통 시각·원장 결함 발견 시 해당 L3 영향 재검토 | S2-01/10/11 취합, S2-02~09 누락·인수 상태 연결 |

### DEV-018 — W04A 입찰·낙찰·계약 모델 및 자동검증

- 정식 추적: [Issue #74](https://github.com/wisberry2022/MetroManager/issues/74) / 담당 AGT-DEV-0001 / LAPTOP. 상태 BACKLOG / PREPARED / OWNER_EXECUTION_APPROVAL_PENDING.
- 브랜치: `codex/DEV-018-bid-contract-model`. DEV-018만 문서 준비용 로컬 브랜치를 만들었고 나머지는 미생성. 실제 구현·공유는 개별 승인 후 최신 main 기준이다.
- 선행/병행: Stage 1 W02/W03; Planning RFC의 영향 항목 확정. 제품 UI는 DEV-019에서 연결.
- 범위/경로: 신규 assets/data/stage2_tenders_v1_3.json; scripts/data/tender_data_loader.gd; scripts/model/public_tender.gd; scripts/simulation/tender_service.gd; tests/game/run_w04a_tests.gd·w04a_fixtures.gd; 신규 .gd.uid. 제한 수정 scripts/simulation/minute_pipeline.gd. DEV-018 티켓·결과·분할안·출처 기록 및 최소 증거.
- 등급: L2 / 기존 CONTRACT 단계 연결은 L3 위험 검토·회귀를 명시. 새 경제·시간 정책 변경은 제외.
- 검증: B01/B02·B-X 필터, 고정값/자격, [360,1800) 접수 경계, 마감 판정 860 대800(표시86/80), 동점 경쟁자 우선, 낙찰/탈락/종료회차·중복·stale, 정부 지급1회, 계약 원장 C1800000/R800000/F1000000/K0/B0, W01~03/W07 보존 회귀. GUI NOT_RUN인 모델 티켓.
- 통합 차단: 유효 사업 계약과 1회성 정부 지급을 검증한 후 W05 실제 제품 통합. S2-02/03 전체 인수는 DEV-019의 GUI/Design/Planning 수용까지 대기.
- S2: S2-01, S2-02/03의 모델·자동 부분, S2-11. 각 티켓의 코드/엔진 자동/GUI/교차 수용을 구분하며 이후 실행 전에 정확한 경로·금지·권한을 최종 확인한다.

### DEV-019 — W04A 공고·응찰·결과·계약 최소 UI

- 정식 추적: [Issue #75](https://github.com/wisberry2022/MetroManager/issues/75) / 담당 AGT-DEV-0001 / LAPTOP. 상태 BACKLOG / PREPARED / OWNER_EXECUTION_APPROVAL_PENDING.
- 브랜치: `codex/DEV-019-tender-ui`. DEV-018만 문서 준비용 로컬 브랜치를 만들었고 나머지는 미생성. 실제 구현·공유는 개별 승인 후 최신 main 기준이다.
- 선행/병행: DEV-018 실제 공급 계약/명령/fixture. Design UI-DC-03/05/07 영향 행 수용.
- 범위/경로: scripts/ui/stage1_session.gd·stage1_view.gd, 신규 scripts/ui/tender_view.gd·scenes/tender_panel.tscn; 신규 tests/game/run_tender_ui_tests.gd·.gd.uid; DEV-019 티켓/결과/출처·증거. 추가 진입 경로 필요 시 승인 경로 확정 후 반영.
- 등급: L2 (DEV↔Design, 규칙 의미 차이만 Planning)
- 검증: B-X 데이터 비노출, 고정 조건 수정 차단, 실제 응찰→대기→마감 결과→계약/지급의 상태/효력시각/현재·당시 판정 구분, 중복/stale 응답·오류 복구, 실제 Windows 클릭·로그와 Design 독립 검수.
- 통합 차단: 응찰 UI 통합 전 snapshot/명령 L2 합의. 이 티켓 단독으로 공사/영업 완주를 주장하지 않음.
- S2: S2-02/03의 GUI·교차 수용, S2-08 부분, S2-11. 각 티켓의 코드/엔진 자동/GUI/교차 수용을 구분하며 이후 실행 전에 정확한 경로·금지·권한을 최종 확인한다.

### DEV-020 — W05 표준 공사·기성·시범·안전·개통 모델

- 정식 추적: [Issue #76](https://github.com/wisberry2022/MetroManager/issues/76) / 담당 AGT-DEV-0001 / LAPTOP. 상태 BACKLOG / PREPARED / OWNER_EXECUTION_APPROVAL_PENDING.
- 브랜치: `codex/DEV-020-construction-model`. DEV-018만 문서 준비용 로컬 브랜치를 만들었고 나머지는 미생성. 실제 구현·공유는 개별 승인 후 최신 main 기준이다.
- 선행/병행: 설계/반례 준비는 DEV-018과 병행 가능(각 실행 승인 필요). 실제 통합은 DEV-018 유효 계약/정부 지급 필수.
- 범위/경로: 신규 scripts/model/construction_project.gd·scripts/simulation/construction_service.gd, 제한 scripts/simulation/minute_pipeline.gd 및 필요 시 scripts/model/company_ledger.gd; 신규 tests/game/run_w05_tests.gd·w05_fixtures.gd·UID; DEV-020 문서/출처·증거. 기존 의미 변경은 RFC.
- 등급: L2 + 원장/공통 시각 통합 L3 영향 검토
- 검증: 표준600000/2880분·floor 차액 합계, 타사업 R/K 격리·부족/중단/재개·최종 지급 전 미완공, 시범60/안전60·미개통 영업0, 빠른720000/1440·첫 결함1·수리20000/30·재시험60, 변경 시 시험 유효성·일괄/분할/배속·중복 회귀.
- 통합 차단: W04A 계약 전 착공 금지, 유효 시범/안전·개통 전 W06 영업 금지. 원장/시각 파일은 DEV-018 병합 후 최신 main에서 순차 통합.
- S2: S2-04/05 모델·자동, S2-01/07 관련 회귀, S2-11. 각 티켓의 코드/엔진 자동/GUI/교차 수용을 구분하며 이후 실행 전에 정확한 경로·금지·권한을 최종 확인한다.

### DEV-021 — W05 공정·자금 중단·검증·개통 UI

- 정식 추적: [Issue #77](https://github.com/wisberry2022/MetroManager/issues/77) / 담당 AGT-DEV-0001 / LAPTOP. 상태 BACKLOG / PREPARED / OWNER_EXECUTION_APPROVAL_PENDING.
- 브랜치: `codex/DEV-021-construction-ui`. DEV-018만 문서 준비용 로컬 브랜치를 만들었고 나머지는 미생성. 실제 구현·공유는 개별 승인 후 최신 main 기준이다.
- 선행/병행: DEV-020 상태·원장·허용 행동/오류 공급; DEV-019 사업 조회. Design UI-DC-04/05/07.
- 범위/경로: scripts/ui/stage1_session.gd·stage1_view.gd, 신규 scripts/ui/construction_view.gd·scenes/construction_panel.tscn; 신규 tests/game/run_construction_ui_tests.gd·UID; DEV-021 문서/출처·증거.
- 등급: L2
- 검증: 제품 실제 착공·공정·중단/재개·시범·안전·개통 조작, 발생/지급/보호금 분리, 빠른 공사 결함/수리/재시험 필요한 상태 UI, 낡은 응답/실패 복구·Design 독립 GUI. 빠른 공사 전체 E2E 반복은 필수 아님.
- 통합 차단: 100% 공정/완공/시범/안전/개통 구분. 미검증 영업 입력 허용 금지.
- S2: S2-04/05 GUI, S2-08 부분, S2-11. 각 티켓의 코드/엔진 자동/GUI/교차 수용을 구분하며 이후 실행 전에 정확한 경로·금지·권한을 최종 확인한다.

### DEV-022 — W06 실제 OD 운행·운임·정산·보고·다음 사업 공급

- 정식 추적: [Issue #78](https://github.com/wisberry2022/MetroManager/issues/78) / 담당 AGT-DEV-0001 / LAPTOP. 상태 BACKLOG / PREPARED / OWNER_EXECUTION_APPROVAL_PENDING.
- 브랜치: `codex/DEV-022-operations-model`. DEV-018만 문서 준비용 로컬 브랜치를 만들었고 나머지는 미생성. 실제 구현·공유는 개별 승인 후 최신 main 기준이다.
- 선행/병행: 독립 OD 계산/반례 설계는 선행 가능(승인 필요). 실제 영업은 DEV-020 유효 개통 필수; W02/W03·DATA/SEM/CLOSE.
- 범위/경로: 신규 scripts/model/operating_line.gd·scripts/simulation/operations_service.gd; 제한 minute_pipeline.gd·daily_ledger_report.gd·company_ledger.gd·demand_predictor.gd(각 기존 의미 보존 필요 범위); 신규 tests/game/run_w06_tests.gd·w06_fixtures.gd·UID; DEV-022 문서/출처·증거. 정확한 변경 함수/경로는 실행 승인 패킷에서 확정.
- 등급: L3 영향 검토 필수, 승인 의미 구현을 새로운 정책 승인으로 반복 요구하지 않음
- 검증: OD 소수 이월/공유U10·미탑승 소멸·이동중/완료 분리, 06~24 비용100/분·완료 운임100, 만족도 승인 공식, 영업0/수요0·부분일, R/K/B·SEM01~03·CLOSE01·일괄/분할/배속·현재/고정보고·첫 유효 실적 보고 및 다음 공고 조회 공급.
- 통합 차단: 개통 전 일반승객0/운임0. 첫 유효 보고는 실제 완료통행·영업실적 필요. 다음 사업 조회까지만, 두 번째 실제 수주는 제외.
- S2: S2-06/07 모델·자동, S2-09 공급, S2-01/11. 각 티켓의 코드/엔진 자동/GUI/교차 수용을 구분하며 이후 실행 전에 정확한 경로·금지·권한을 최종 확인한다.

### DEV-023 — W06 운행·재무·경량 연출·보고·다음 사업 UI

- 정식 추적: [Issue #79](https://github.com/wisberry2022/MetroManager/issues/79) / 담당 AGT-DEV-0001 / LAPTOP. 상태 BACKLOG / PREPARED / OWNER_EXECUTION_APPROVAL_PENDING.
- 브랜치: `codex/DEV-023-operations-ui`. DEV-018만 문서 준비용 로컬 브랜치를 만들었고 나머지는 미생성. 실제 구현·공유는 개별 승인 후 최신 main 기준이다.
- 선행/병행: DEV-022 실제 공급, DEV-019/021 연결. Design UI-DC-05/06/07, 기존 01/02 유지.
- 범위/경로: scripts/ui/stage1_session.gd·stage1_view.gd·stage1_map.gd; 신규 scripts/ui/operations_view.gd·finance_view.gd 및 scenes/operations_panel.tscn·finance_panel.tscn; 신규 tests/game/run_operations_ui_tests.gd·UID; DEV-023 문서/출처·증거.
- 등급: L2 / 연출이 게임 원장·수요를 소유하지 않음
- 검증: 실제 영업 입력·열차 이동/정차·승하차 최소 피드백, 신규탑승제한/잔여도착/재개 구분, 발생·즉시/후정산·현재/과거·예측/실적·0/없음, 보고 조회→다음 공고/후보 실제 이동, stale·Design 독립 GUI.
- 통합 차단: 해당 화면 통합 전 실제 상태/정상·실패 fixture L2 수용. DSG-006/고충실도 아트·최종 PC 규격은 선행조건 아님.
- S2: S2-06/07 표현, S2-08/09 GUI, S2-11. 각 티켓의 코드/엔진 자동/GUI/교차 수용을 구분하며 이후 실행 전에 정확한 경로·금지·권한을 최종 확인한다.

### DEV-024 — W08 VS-01 통합 재현·회귀·실제 제품 GUI 인수 증거

- 정식 추적: [Issue #80](https://github.com/wisberry2022/MetroManager/issues/80) / 담당 AGT-DEV-0001 / LAPTOP. 상태 BACKLOG / PREPARED / OWNER_EXECUTION_APPROVAL_PENDING.
- 브랜치: `codex/DEV-024-vs01-integration-evidence`. DEV-018만 문서 준비용 로컬 브랜치를 만들었고 나머지는 미생성. 실제 구현·공유는 개별 승인 후 최신 main 기준이다.
- 선행/병행: DEV-018~023의 유효 연결·DEV 자체검증. 재현 규격 설계는 선행 가능; 완주 실행은 실제 제품 경로 후.
- 범위/경로: 신규 tests/game/run_vs01_tests.gd·vs01_fixtures.gd·UID; DEV-024 티켓/결과/출처·최소 공개 QA 증거. 제품 결함 수정은 원 소유 티켓 승인 범위로 환류하며 이 티켓에 무제한 코드 경로를 넣지 않음.
- 등급: L2 통합 / 공통 시각·원장 결함 발견 시 해당 L3 영향 재검토
- 검증: W01~03/W07 및 Stage2 회귀, 독립 초기 상태의 B01→계약→표준공사→시범/안전→개통→실영업→첫 유효 실적 일일보고→다음 사업 실제 마우스/키보드 완주, 명령/시각/원장·도착/보고 비교·종료코드·해시·Design 독립/필요Planning·CI·S2표.
- 통합 차단: 자동 러너/강제 성공 fixture로 실제 UI 완주 대체 금지. VS-02·최종VP01/02·전체MVP/Windows성능 인수는 제외.
- S2: S2-01/10/11 취합, S2-02~09 누락·인수 상태 연결. 각 티켓의 코드/엔진 자동/GUI/교차 수용을 구분하며 이후 실행 전에 정확한 경로·금지·권한을 최종 확인한다.

## 3. 의존성·병렬·정확한 차단

- **제품 핵심 경로:** DEV-018 유효 계약/정부 지급 → DEV-020 유효 공사/시범/안전/개통 → DEV-022 실제 영업. DEV-019/021/023의 실제 입력 화면을 연결한 뒤 DEV-024가 독립 초기 상태에서 실제 UI 경로를 완주한다.
- DEV-019의 정보 구조/공급 계약 준비는 DEV-018 모델 준비와 병행 가능. 실제 UI 통합은 실제 snapshot/명령/정상·실패 fixture와 Design 영향 행 합의가 선행한다.
- W05 모델/반례 설계는 W04A와, W06 순수 OD 계산/반례 설계는 W05와 병행 가능하나 각각 제작 승인 필요. 테스트 데이터와 실제 계약/개통 상태를 구별하고 제품에서 유효 사업 확보/개통을 우회하지 않는다.
- 공통 minute_pipeline.gd·원장·보고 파일은 별도 worktree로 변경하고 선행 모델 PR main 반영 후 다음 티켓의 최신 base로 순차 통합한다. 독립 준비를 중지시키지 않으며 공유 브랜치 강제 rebase/force push는 금지한다.
- DSG-006 콘셉트 미확정·최종 픽셀 아트·최종PC/FPS 미선택은 최소 기능 UI의 선행조건이 아니다. 규격 종속 제작만 F-08의 적절한 시점에서 차단한다.

## 4. W05/W06 공통 원장·시각 영향 및 회귀

현재 minute_pipeline은 비용·계약·기성·검증·도착·정산·탑승 단계가 있으나 공사/검증/운행은 주로 테스트 사건이다. Stage2에서는 실제 사업 상태와 구간 누적을 연결해야 한다. 제품을 set_fixture 기반 성공 경로로 만들지 않는다.

| 지점 | 예상 영향·변경 한계 | 필수 회귀 |
| --- | --- | --- |
| W04A CONTRACT | 마감 결과→유효 계약·정부금, 동일 회차/명령1회성. 기존 ledger 재사용 | 86/80·동점·마감·자격·중복/stale, 같은T 도착운임 선사용 금지, C1800000/R800000/F1000000/K0/B0 |
| W05 이전구간/PROGRESS | 경과분·누적floor 차액·R/K 기성/완공, 실패 시 미완공. 기존 정책 보존 | 600000/2880 합계·일괄/분할/배속·0/마지막분·자정기성·두사업R/K·부족/중단/재개·중복 지급 |
| W05 VALIDATION | 시범·안전·수리/재시험·개통의 별도 상태/유효성 | 60/60, 빠른 결함1·20000/30·재시험60, 조건 변경 무효화, 미개통 일반승객/운임0 |
| W06 이전구간/ARRIVAL/SETTLEMENT/BOARDING | 실제 운행 허용 구간 비용100/분, OD/U/이동중/완료100, B상환·재개, 시각권위 유지 | SEM01~03·후순위운임 선사용금지·B 비용재인식금지·영업0/수요0/부분일·U공유·소수이월·미탑승소멸 |
| W06 자정·보고 | 발생일/현금지급일/도착일 분리·전일 보고 불변, 만족도/실적/다음 조회 공급 | 23:59탑승8→00:09완료8·운임800·잔여추가비용0, 전일불변·다중날짜·같은입력/효력시각 결과일치 |
| 완료 snapshot/UI | 같은 revision/게임분·당시결과/현재/과거·예측/실적 | 늦은 응답/거부/반복 클릭 부작용 없음,0/없음/오류·허용행동 불일치 거부 |

정상 공사 후 영업 전 C1200000/R200000/F1000000/K0/B0을 검산하고 남은 R200000을 자유현금으로 전환하지 않는다. 이후 n완료통행·실제 지급p/발생e는 시점별 실제 원장으로 비교한다. 고정 일일수익을 꾸며내지 않는다.

공통 변경은 L3 영향·회귀 책임을 실행 티켓에 명시한다. 기존 승인 SEM/CLOSE를 그대로 구현하는 것은 신규 정책 변경 승인을 반복 요청할 이유가 아니다. 순서/수치/정책을 바꿔야 하거나 불가능한 명세면 해당 변경만 RFC→HQ/Owner 결정까지 보류한다.

## 5. S2-01~11 증거 책임

| S2-ID | DEV 담당 티켓/증거 | 교차 인수·한계 |
| --- | --- | --- |
| S2-01 | 018/020/022의 기존 W01~03/W07 회귀·초기 상태/시간/원장,024 누적 | Stage1 완료를 Stage2 회귀 재실행으로 보고하지 않음 |
| S2-02 | 018 공고/필터/자격 모델·자동,019 실제 공고/접수GUI | Planning 의미·Design UI 수용 |
| S2-03 | 018 점수·동점·마감·계약/정부금1회,019 실제 결과/계약GUI | 모델 PASS만으로 전체 인수 아님 |
| S2-04 | 020 공사·floor·R/K·부족/중단 자동,021 제품 진행GUI | Planning 공정/원장 의미, Design 상태 |
| S2-05 | 020 시험/안전/개통 자동,021 실제 조작·실패복구 | 표준 실제완주, 빠른 반례자동+필요UI. 빠른E2E전체 추가 안 함 |
| S2-06 | 022 실제OD/U/도착/만족도 자동,023 운행GUI·경량피드백 | 연출은 경제 소유자 아님 |
| S2-07 | 022 SEM/CLOSE·고정보고 자동,020 공통시각 회귀,023 실제재무표시 | 같은T/자정·잔여도착0추가비용 증거 |
| S2-08 | 019/021/023 입찰·공정·운행/재무/다음사업 실제 입력/복구 | Design 독립실GUI, 정적캡처/러너로 대체금지 |
| S2-09 | 022 유효실적보고/다음조회 공급,023 실제 이동 | 실제 완료통행/실적 없는0보고만으로 성공금지, 두 번째 수주 제외 |
| S2-10 | 024 B01→계약→표준→시험/안전→개통→영업→유효보고→다음조회 실제마우스/키보드 로그 | 독립초기상태·실제 제품경로, 자동 성공/fixture 우회로 대체금지 |
| S2-11 | 전 티켓 SHA/명령/기대·실제/종료/CI/NOT_RUN,024 추적표취합 | Design 독립수용·필요Planning·HQ통합·Owner최종승인 각각구분 |

## 6. L2 입력·RFC·Owner 결정

[Planning RFC-DEV-018-01](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6715929346)은 OPEN이다. 판정 당시 F/재무점수 시점, 응찰과 업무시간/효력/마감 관계, 낙찰 계약→W05 모드/K 예약·공기이행가능 의미를 질문했다. 확정 수치/SEM 재설계나 전체 문서 재검토·Godot 재실행을 요구하지 않는다. 답변 전 해당 판정 구현만 보류하고 Owner 실행 승인된 독립 부분은 진행 가능하다.

Design에는 UI-DC-03(공고ID·관할·고정조건·접수/결과·계획/회차·점수/당시자금),04(기성/공정·중단·시범/안전·개통),05(현재C/R/F/K/A/B·발생·즉시/후정산·고정 보고),06(요청/탑승/이동중/완료·운임/만족도/상태),07(관측분/revision·명령효력/보고일)의 필드·단위·기간·reason/allowed_actions와 정상·거부·0·없음·오류·stale fixture를 해당019/021/023 통합 전 제공·영향행 L2 검수한다. 지금은 공급안이며 실제 Stage2 패킷 생성/GUI 검증은 NOT_RUN이다.

실제 [Design 공급 협의 #24](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6715951143)를 등록했다. Planning/Design 회신은 PENDING으로 보존하며 현재 준비 문서를 실제 공급 합의/수용으로 주장하지 않는다.

Owner 결정 필요: **우선 DEV-018의 정확한 경로/구현/검증·Commit/Push/PR**. 나머지 실행은 각각 후속 승인, main 병합은 별도다. 기획 회신이 새 규칙/범위 결정을 요구할 경우 해당 RFC만 추가 상정한다. 현시점 Stage2 전체제작·F08규격·TrackB콘셉트를 포괄 승인 요청하지 않는다.

## 7. F-ID 적용·후속

| F-ID | 이번 적용·검증 차단 | 후속 추적 |
| --- | --- | --- |
| F-01 | W04A 점수판정은 RNG 없음. 공통계산/시험에 최초 게임RNG가 생기면 그 기능 통합 전 seed/state·조회/거부/중복 시퀀스검증 | W04B/VS02 정상RNG·미래 최초사용 티켓, 가짜RNG 도입 안 함 |
| F-03 | 018/019·S2-02/03 필수 | 공공입찰VP02 관련 증거이나 최종VP02전체/MVP인수로 승격 안 함 |
| F-05 | 020~023·유효계약→개통→영업, S2-04~07 | 실제 사업경로 인수 전 충족 |
| F-07 | 024 VS01 재현·S2-01/10/11 부분 | 전체AC01~10/독립VP01회사제안·VP02공공입찰은 MVP최종인수 전 유지 |
| F-08 | 최소 UI에는 미승인PC/FPS·콘셉트 비차단. DEV는 TrackB 렌더/폰트/재사용 위험 자문 | 규격종속 제작 전 DEV+DSG대안→HQ→Owner. W09 Windows export/최종FPS 별도승인·인수 |
| F-10 | 018→019,020→021,022→023 실제공급/fixture·L2·GUI | 해당 화면통합 전, UI 계약03~07 중심 |
| F-11 | 모든 코드/테스트/씬·Git 실행 전 해당 티켓/Agent-ID/경로/브랜치/행위 승인 | Stage1 권한 승계/포괄 권한 없음, 병합/릴리스 별도 |

## 8. 제출 상태

준비 산출물2개와 Issue #74~80·영향 협의로 제출한다. 이 문서와 DEV-018 티켓은 로컬 미커밋 준비안이며 remote에 파일이 반영됐다고 주장하지 않는다. 첫 Issue #74 본문에 검수 가능한 동일 승인 패킷을 제공한다. 다른6개 티켓은 각 실행 전 정확한 경로·수용/권한을 재확인한다. 실제 구현·새테스트/씬·Commit/Push/PR·Stage2 합격/DONE은 없다.

준비 문서 검증: 전용 .venv doctor/check PASS(worktree files396/GDScript22), 신규2개 Markdown UTF-8/LF·상대 링크·S2-01~11/F-ID·7개Issue/ID 검토. 정책 전체회귀·Godot·게임 자동/GUI·빌드/CI는 NOT_RUN이다.


## 9. DEV-018 개별 실행 상태 갱신

위 §1~8은 티켓 분할 준비 당시 상태다. 이후 Owner가 #74 DEV-018의 구현·검증·Commit·Push·PR을 승인했고 Planning RFC 회신을 확인한 뒤 착수를 직접 지시했다. DEV-018은 REVIEW로 제출하며 [티켓 §9](../tasks/DEV-018_W04A_BID_CONTRACT.md#9-선행-회신-확인-및-실행-승인-적용)·[실제 결과](../tasks/DEV-018_RESULT.md)를 따른다. DEV-019~024의 실행/Git 권한 대기는 그대로이며 Stage2 전체 수용/DONE·main 병합 승인이 아니다.
