# PM-022 — DI-03 착수 및 부서별 실행 요청

- 발신: HQ / AGT-PM-0002 / 2026-11-28 KST. 정본 후속: [#185](https://github.com/wisberry2022/MetroManager/issues/185).
- 원문: [Owner 결정/HQ 착수 판단](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7236141995), [PM-022 승인 범위](../tasks/PM-022_S3_12_DI03_TRANSITION.md).
- 기준 main `1c4481187980fe6b37de0fec8e0019f2736ce1f2`; 착수 시 최신 main을 재확인하고 실제 실행 base/파일 해시를 기록한다. 기존 공유 데이터2개 변경은 가져오지 않는다.
- **DI03_POLICY_DECIDED / STAGE3_SCOPE_RETAINED / LOCAL_IMPLEMENTATION_START_AUTHORIZED**. 일정상 HOLD 해제. 실제 구현/제품 검증/수용은 아직 완료 아님.

## 1. 지금 시작할 수 있는 범위와 권한

Owner가 DI-03의 착수 가능성 판단 및 가능하면 부서가 착수하도록 문서화를 지시했다. HQ는 정책 A1+B1과 비의존 기반이 준비되어 가능하다고 판단했다. 따라서 아래 범위의 **로컬 모델·실제 공급 구현, 자동검사·회귀·프로젝트 로드, DEV 자체 국소 제품 확인, 부서 정적/L2 검토**를 시작할 수 있다. 승인된 같은 범위에 다시 포괄 승인 회차를 요구하지 않는다.

DEV는 첫 수정 전 자기 티켓에 기준 SHA·아래 후보 중 실제 선택 경로·구현 단위·실행 명령/도구·예상 영향과 기존 유효 권한을 기록한다. 이는 범위를 좁히는 실행 기록이며 기술 아키텍처는 DEV 소관이다. 경로 추가·게임 의미 변경·새 범위가 필요한 경우에만 차이와 이유를 좁혀 상정한다. 과거 41경로 계획 전체나 이전 단계의 Git 승인을 자동 승계하지 않는다.

미래 **DEV/Design/Planning Commit·Push·PR, main 병합, 독립 GUI 실행**은 이 PM-022 HQ Git 승인으로 위임하지 않는다. 해당 단계의 기존 유효한 승인 원문은 재사용하고 실제 미확인 범위만 Owner에게 요청한다. 독립 GUI는 먼저 필수 행·고정 시험본·실행 주체/권한·증거 위치를 정한다. 문서 게시 자체로 타 채팅의 수신·숙지 완료를 주장하지 않는다.

## 2. 정확한 로컬 변경 후보

이 목록은 승인된 DI-03 의미를 위한 최대 후보이며 전부 바꿀 의무가 아니다. 기존 UID 보존, 새 GDScript UID만 명시된 쌍으로 관리한다. 삭제·이름 변경·범위 밖 경로는 포함하지 않는다. 기존 DEV 기술안의 경로를 현재 공급 구조에 맞춰 좁혔으며 클래스/필드 형식을 HQ가 확정하지 않는다.

| 구분·시점 | 정확한 경로 | 허용 목적 |
| --- | --- | --- |
| 모델·효과 / 즉시 | `scripts/model/company_proposal.gd`, `scripts/simulation/proposal_service.gd`, `scripts/simulation/proposal_demand_profile.gd`, `scripts/simulation/proposal_demand_profile.gd.uid` | 실패 근거·동일 사업 E01 1회·사실/효과/소비 분리. demand_profile 신규 분리는 DEV 선택 |
| 수요·실운행 / 즉시 | `scripts/simulation/demand_predictor.gd`, `scripts/model/operating_line.gd`, `scripts/simulation/minute_pipeline.gd`, `scripts/simulation/business_sources.gd`, `scripts/simulation/operations_service.gd` | 사업별 출발 동/OD·정확한 배율/carry·예측/실운행 동일 공급·기존 처리 순서 보존 |
| 실제 공급 / 즉시 | `scripts/ui/stage1_session.gd`, `scripts/ui/s01_observation_contract.gd` | 실제 사건/접수 봉투·허용 행동/사유·원천판·지역 guard. UI L2를 위한 공급 생성 |
| 데이터 연결 / 필요 시 | `assets/data/stage3_proposals_v1_4.json`, `scripts/data/proposal_data_loader.gd` | 승인 수치/형식 연결만. W01/W03 원본 수요나 확률/경제 의미 변경 없음 |
| 제품 화면 / 해당 L2 후 | `scripts/ui/proposal_view.gd`, `scripts/ui/proposal_presentation.gd`, `scripts/ui/stage1_view.gd`, `scenes/proposal_panel.tscn` | UI11/12와 실제 사실/재접수 표시·입력. Host는 해당 봉투/행동 연결만; 완료한 K01/F04/수명 전면 재작성 제외 |
| 자동/회귀 / 구현과 병행 | `tests/game/w04b_fixtures.gd`, `tests/game/run_w04b_tests.gd`, `tests/game/run_proposal_ui_tests.gd`, `tests/game/run_proposal_view_tests.gd`, `tests/game/run_vs02_tests.gd`, `tests/game/run_w03_tests.gd`, `tests/game/run_w06_tests.gd` | 신규 경계/무효과·실제 변경 영향만. 정상 제품/강제 fixture 구분 |
| DEV 기록 / 진행 중 | `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md`, `docs/engineering/tasks/DEV-027_RESULT.md`, `docs/engineering/tasks/DEV-027_PROVENANCE.json`, `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md`, `docs/engineering/gate3/DEV-027_W04B_SUPPLY_CONTRACT.md`, `docs/engineering/gate3/DEV-027_DI03_IMPLEMENTATION_PLAN.md`, `docs/engineering/evidence/DEV-027_DI03_RESULTS.json`, `docs/engineering/evidence/DEV-027_DI03_EVIDENCE.md` | 이번 범위·실행/미실행·해시·공급·검수/잔여를 분리. 과거 증거 보존 |

제외: W04A/도시 원본 데이터 수정, 시계·원장·심사 확률/경제 규칙 변경, 새로운 반복 E01 보상, 소급 통행/운임/마감 재계산, 세이브/POST-MVP, F-08 폰트·아트·이름/지원환경 채택, CI/훅/정책·타 부서 원본 수정, 새로운 GUI runner/관측 도구 제작, 전면 리팩터링. 실제 추가 필요만 RFC/좁은 범위 확인으로 처리한다.

## 3. 역할·순서·종료 신호

| 담당 | 지금 할 일 | 다음 단계로 넘길 결과 |
| --- | --- | --- |
| DEV / AGT-DEV-0004 | #185에 위 후보의 실제 선택·base·명령을 연결하고 D1 모델/실제 공급·자동 경계를 진행 | 실제 payload·명령 코드 위치, 입력→기대→실제, 실패/발생/효과/소비 시각·사업/계획/판·원장/수요/carry 해시, 정상/fixture 구분 |
| Planning / AGT-PLN-0003 | 이미 확정된 [DI-03 의미](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7216239510)를 정본으로 제공·실제 공급과 차이만 대조 | 차이 NONE 또는 구체 의미 행/반례. 새 전체 기획 승인·A1+B1 재선택 없음 |
| Design Track A / AGT-DSG-0004 | 실제 공급 후 UI11/12의 실패·사실·성공 접수/미소비·사업 문맥 L2 대조 | 해당 UI 통합 전 필수 차이 해소, 신규 제품 독립 검수 행과 기능/입력 효과 기대값 |
| Design Track B / AGT-DSG-0003 | 같은 payload/패킷에서 RP-01/02/08과 영향 RP/EX·현재/당시·읽기/복귀/수명·표현 대조 | 실제 미공급/누락/오류와 게임상 실패 분리, 영향 행 한정 판정. F-08 #92 별도 |
| DEV / 실제 공급 L2 후 | 해당 화면 연결·자동/회귀·로드·DEV 자체 국소 실행, 독립 검수용 고정 패킷 제공 | 새 DI-03·직접 영향 범위만 공동 검수. 기존 자연 VS-02 수용을 NOT_RUN으로 되돌리지 않음 |
| HQ / AGT-PM-0002 | #185의 부서 판정·시험본/CI·공백을 #186 및 S3-05/07/09/12에 취합 | S3-11/Owner 최종 결정 자료. 부서 전문 판정·Owner 권한 대행 없음 |
| Convention / 필요 발생 시 | 현재 policy·department-policy 유지, 실제 도구/CI 문제만 소관 판단 | 이 작업에서 새 도구/CI 수정·Git 권한을 자동 부여하지 않음 |

INF의 신규 업무는 배정하지 않는다. 동시 공통 파일 수정은 DEV가 순차 통합한다. 부서별 상세 기록은 자기 기존 티켓/경로에 두고 #185에 링크한다. HQ 문서를 타 부서가 대신 수정하거나 같은 증거를 둘로 재실행하지 않는다.

## 4. 신규 필수 수용 행

모든 아래 제품 증거는 신규 공급 전 **NOT_RUN / ACCEPTANCE_PENDING**이며 계획을 PASS로 기록하지 않는다. 기존 명세 정본과 충돌하면 해당 행만 RFC로 대조한다.

| 행 | 필수 의미/기대 | 최소 증거·주관 |
| --- | --- | --- |
| D01-01 | 정부 부적합은 해당 심사 계획, 설득 실패는 연결된 보류 계획. 실패 시 고유 출발 동을 고정; 이후 초안 변경으로 이동하지 않음 | 실제 실패 근거/계획 사본·동/OD 매핑, 중복 동·다른 사업 반례. DEV/Planning·A |
| D01-02 | 동일 사업은 슬롯/이름/순서/revision 우회 없이 E01 1회; 다른 사업 격리 | 사건 ID·business identity·원천 계획/판·대상, 반복/별칭/격리 자동 경계. DEV/Planning |
| D01-03 | 실패T600 → T2039 미발생 → T2040 1회 → T2041 추가0; 기존 SEM-03/요청T+1 순서 유지 | 실제 Pipeline 전/정각/후·정지/재개 영향과 시각. 내부 미래 fact 주입은 fixture로만 구분. DEV/A |
| D01-04 | 고유 출발 동/OD ×5/4 1회, 조기 절사 금지. D08 두 역으로 동200을 중복 증폭하지 않고250. 예측·실운행 동일 원천·판, 영향 예측 무효화 | 0/소수·다른 사업·도시 원본 불변·carry 잔존, 예측과 실운행 결과. DEV/Planning·A |
| D01-05 | 효과 발생·소비 분리. 등록 미소비, 효력 재검사/접수 성공1회 소비, 실패 미소비; 후속 재실패 무환급·새 E01 없음 | 사건2040→접수2100→실패2160→3600 새 E01 없음. command/review/fact·시각·결과/소비 상태. DEV/Planning·A |
| D01-06 | UI11/12 실제 공급: 예정/발생/관련·미사용/사용·실패 사유·현재 가능한 행동과 과거 근거 구별 | 실제 payload 후 A/B L2, 제품 입력/표시 한정 독립 검수. 예정 메타데이터/소비 fixture를 자연 실제 사실로 확대0 |
| D01-07 | 기존 비용/원장·마감·완료 통행/운임 소급 변경0, 조회/재클릭/복귀 추가효과0, RP/EX 영향 guard 유지 | 직접 변경 W03/W06/Session·View 회귀와 영향 RP/EX만. 기존 자연 VS-02 전체·모든 OS 조합 반복0 |

독립 GUI의 정확한 필수 행은 실제 공급 후 A/B가 위 의미 중 제품 입력/표시로 확인해야 할 부분에 한정한다. 모델 자동검사로 충분한 내부값에 별도 OS 노출/전수 GUI를 추가하지 않는다. 공급 SHA·실행 소스 해시·명령·효력/권위 상태·종료코드/오류·캡처/로그 위치를 한 패킷으로 기록한다.

## 5. 완료와 재개방

DI-03 완료는 D01-01~07의 실제 공급/검증·해당 부서 수용·필수 CI와 HQ/Owner 인수로 판단한다. #185에는 증거 없는 하위 행을 미완료로 남긴다. 기존 #146 비의존 종료와 무관하게 DEV-027 전체/Stage 3 완료를 선언하지 않는다.

관측 한계 C01~05는 [S3-12 범위](../STAGE3_S3_12_ACCEPTANCE_SCOPE.md)와 #104에서 보존한다. 새 제품 변경·반대 증거·신뢰성 문제의 영향 행만 재개방한다. F-08 #92의 미결을 DI-03 모델 착수의 일괄 선행조건으로 추가하지 않는다. 일정/공수는 DEV 구체화 전 NOT_ESTIMATED.
