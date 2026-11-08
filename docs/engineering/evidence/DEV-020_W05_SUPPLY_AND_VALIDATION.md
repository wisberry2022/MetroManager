# DEV-020 W05 모델 공급·검증 인계

- 담당 Development / LAPTOP / AGT-DEV-0001, REVIEW. 기준 main `98d56eb97f8a030912bea534ff1c330e9c40188e`.
- 승인: [실행 티켓](../tasks/DEV-020_W05_CONSTRUCTION_MODEL.md) §10·12, Owner의 기존 16개 경로 구현·검증·Commit·Push·PR 승인. main 병합은 별도다.
- 규칙 우선 근거: [Planning의 Owner R01~03 결정](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6719007539). 기존 사업계약 기산 문구를 실제 착공 기산으로 명시 개정한 결정이다. Planning 공식 문서 개정은 후속이며 개발이 타 부서 문서를 수정하지 않는다.

## 진입과 권위 경계

`MinutePipeline.enable_tenders()` 후 `enable_construction()`을 한 번 호출한다. 실제 B01/B02의 입찰·낙찰·사업계약·정부 지급을 먼저 완료한다. W05는 새 정부금을 지급하지 않으며 기존 `CompanyLedger`를 공유한다. 사업 계약의 EFFECTIVE, project_id/business_contract_id, 지급 available/transaction_id/amount/effective_at/ledger_entry_index/restricted_project_id와 실제 government 원장 항목 및 R/K 키를 대조한 뒤 공사 계약을 생성한다. 외부 클라이언트가 사업계약 사본을 명령 payload로 주입하는 API는 없다.

공사 계약 ID는 `business_contract_id + '-CONSTRUCTION'`이고 사업 계약 ID와 다르다. 표준/빠른 모드 600000/2880, 720000/1440은 고정이다. 현재 승인 데이터의 B01/B02는 정부금800000, 두 모드 모두 K0이다. 정부금보다 공사비가 큰 미래 모드의 추가 K 약정은 `MODE_RESERVATION_POLICY_REQUIRED`로 통합을 막고 별도 결정을 요구한다. 현재 K0 사례로 미래 모드 약정 정책을 일반화하지 않는다. 비영 K와 두 사업 보호는 승인된 내부 원장 fixture로 별도 검사한다.

이 모델 공급은 기존 DEV019 UI를 자동 확장하지 않는다. 현행 P05는 읽기 전용이다. DEV021이 신규 W05 공급을 소비하고 실제 버튼·화면·오류·역순 응답을 검수받아야 한다. W04A의 기존 `construction_contract: NOT_CREATED`는 W04A 부분 계약의 한계이며, 실제 W05 상태는 아래 construction 봉투를 사용한다.

## 명령 공급

`submit_construction(Dictionary)` → pending 또는 즉시 거부, `construction_result(command_id)` → 완료 결과다. 모든 반환값·저장 입력·snapshot은 깊은 복사다.

| 필드 | 실제 타입·단위 |
| --- | --- |
| command_id | 비어 있지 않은 String, 최초 pending/최종 결과를 재사용. 다른 payload라도 같은 ID면 재집행0 |
| project_id / business_contract_id | String, W04A 유효 사업과 연결 |
| action | String: contract/start/resume/trial/safety/repair/open |
| mode | contract에서 STANDARD/FAST. 다른 명령에서는 사용하지 않음 |
| requested_at / effective_at | 0 이상 int 게임분. 요청은 현재 완료분 이하, 효력은 현재 완료분 이후. 완료된 분으로 소급하지 않음 |
| expected_snapshot_revision | 0 이상 int, 관측 출처. 시각 경과만으로 거부하지 않음 |
| target_revision | 0 이상 int, 공사 condition_revision. 변경되면 STATE_CHANGED |

공사 contract만 00:00~06:00의 예정 효력을 해당 일06:00으로 이연한다. 다른 작업은 24시간 가능하지만 실제 선행조건·자금 검사는 효력 단계에서 다시 실행한다. contract는 CONTRACT, start/resume은 PROGRESS, trial/safety/repair/open은 VALIDATION에서 처리한다. 각 단계에서 command_id 정렬로 결정적으로 처리한다. 같은 단계의 다중 명령은 ID 순서 영향을 받을 수 있으므로 UI는 선행 명령의 최종 결과를 확인하고 다음 명령을 보낸다.

결과는 accepted/pending(bool), command(Dictionary 처리 사본; 계약 이연 시 effective_at은 조정된 효력분), command_id(String), requested_at(int 또는 잘못된 입력값), effective_at/phase_revision/result_revision(int 또는 즉시 거부의 null), decision_phase(String), reason(String), reason_codes(Array[String])이다. 처리된 명령의 result_revision은 phase_revision+1이며 최종 T_COMPLETE 봉투보다 앞선 출처를 유지한다. 이력을 현재 허용 행동으로 덮어쓰지 않는 실제 UI 소비는 DEV021 책임이다.

사유: INVALID_COMMAND/FIXED_TERMS/CLOSED_EFFECTIVE_TIME/INVALID_MODE/INVALID_ACTION, CONSTRUCTION_NOT_ENABLED, CONSTRUCTION_ENABLE_PREREQUISITE, BUSINESS_PAYMENT_NOT_EFFECTIVE, CONSTRUCTION_CONTRACT_EXISTS, MODE_RESERVATION_POLICY_REQUIRED, UNKNOWN_CONSTRUCTION_PROJECT, BUSINESS_CONTRACT_MISMATCH, STATE_CHANGED, PREREQUISITE_NOT_MET, CONSTRUCTION_PAYMENT_DUE, REPAIR_FUNDS_INSUFFICIENT.

## snapshot 공급

`Pipeline.snapshot().construction`은 `rules_version='RFC-DEV-020-01-OWNER-20261108'`, `data_version='1.3'`, `ui_contract_revision='DEV020-W05-UI-1'`, available(bool), simulation_minute/day_id/snapshot_revision(int), observation_phase=T_COMPLETE, funds(Dictionary), projects(Array[Dictionary]), contract_candidates(Array[Dictionary])를 제공한다. 분·revision은 Pipeline의 최종 관측과 같다.

| 공급 | 실제 경로·타입·의미 |
| --- | --- |
| 계약 전 행동 | contract_candidates[].project_id, business_contract, target_revision=0, allowed_actions.contract(bool), reason_codes(Array), modes(Dictionary: 모드→[통화 정수, 기간 정수]) |
| 계약/노선 | projects[].project_id/construction_contract_id/construction_contract_status/mode(String), business_contract(Dictionary 사본), station_ids(Array[String]), contract_effective_at(int) |
| 공정 | status(String: CONTRACTED/BUILDING/SUSPENDED/COMPLETED/OPEN), total_cost/duration_minutes/elapsed_minutes/accrued/paid/construction_payable(int), started_at/completed_at(int 또는 null) |
| 검증 | trial_status/safety_status(String NOT_STARTED/RUNNING/PASSED 또는 안전 FAILED), procedure(String 빈 문자열/trial/safety/repair), procedure_started_at/procedure_completes_at/procedure_revision(int 또는 null) |
| 안전/개통 | defects/repair_paid/condition_revision(int), first_defect_issued/service_ready(bool), opened_at(int 또는 null) |
| 행동/거부 | allowed_actions(Dictionary bool), action_reason_codes(Dictionary Array[String]), reason_codes(Array[String]) |
| 재무 | funds의 기존 cash/restricted/reserved/free_cash/available_cash/unpaid 및 restricted_by_project/reserved_by_project. 전역 funds가 단일 권위. unpaid는 운영 B만 의미 |

공정률은 elapsed_minutes/duration_minutes의 정확한 비율이다. 발생 기성 accrued, 실지급 paid, 공사 미지급 construction_payable을 구별한다. 정상 0을 자료 없음으로 치환하지 않는다. 타임스탬프 null은 아직 발생하지 않은 상태다. 수리비 repair_paid는 기성 paid/accrued에 합산하지 않으며 회사 보고의 construction_cost/construction_payment에는 반영한다.

## 단계·자금 의미

실제 착공 T부터 N분 경과한 T+N에 완료 가능하다. PREVIOUS_INTERVAL에서 끝난 구간의 공정과 누적 floor 차액을 확정하고 비용을 minute-1로 기록한다. 자정은 이 발생비를 전날 마감에 포함한다. 뒤 PROGRESS에서 실제 지급을 해당 minute로 기록하므로 자정 지급은 새날이다. 기존 W02 테스트 주입 construction_payment의 기본 발생/지급 동시 동작은 보존한다.

실패한 기성은 이미 수행한 elapsed/accrued를 보존하고 construction_payable로 남는다. 다음 구간부터 SUSPENDED로 진행0, B증가0이다. resume은 기존 미지급 전액을 먼저 지급하며 실패 시 계속 중단한다. 성공한 시각에는 새 공정0, 다음 구간부터 재개한다. 최종 기성 실패는 elapsed=기간이어도 완공 미승인이다. 기성은 자기 R 우선→약정 자기 K의 실제 자유현금으로만 지급하며 다른 R/K를 사용하지 않는다.

수리는 해당 R 우선→A의 전액20000을 원자적으로 선지급한 뒤30분 진행한다. 부족하면 현금/R/K/B·기성·수리 시작 효과0이다. 시범60과 안전60은 독립 절차이고 빠른 공사의 첫 안전 실패1개는 수리 후 안전60을 다시 요구한다. 난수는 사용하지 않는다. 조건 변경 무효화는 내부 모델 어댑터이며 이번 티켓에 플레이어 편집 기능은 없다.

일반 영업은 service_ready=OPEN 전 차단한다. Pipeline에 W05를 활성화하면 테스트 eligible=true도 OPEN 전 탑승을 허용하지 않는다. W06 실제 OD/승객/운임은 미구현이다. 기존 set_fixture의 arrival_fare는 단계 순서 검증을 위한 테스트 전용 원장 입력이며 일반 승객 운임 경로로 연결하지 않는다.

## 검증과 후속 인수

[fixture 원본](DEV-020_W05_FIXTURES.json), [단언·엔진 실행 결과](DEV-020_W05_VALIDATION.json), [검수 요청 및 실제 명령](../tasks/DEV-020_RESULT.md)을 사용한다. fixture의 내부 자금 부족·회복·비영K는 정적 승인 반례이며 제품에 자금 주입/추가 약정 기능을 제공하지 않는다. 초기/기대/실제 snapshot·원장·명령 결과와 실행 상태를 구분한다.

S2-04/05 모델·자동 증거, S2-07 원장/보고 회귀, S2-11 버전·로그/종료·SHA를 개발이 공급한다. Design에는 DEV021 실제 화면 통합 전에 본 공급 및 정상/부족/실패 상태를 L2 검토 요청한다. A01-Q12, S2-04/05/08 GUI, W05 실제 플레이·VS01 완주·Windows export는 NOT_RUN이다. F05/F10/F11의 모델·공급·실행 승인 의무를 추적하되 F07 전체 MVP 회귀·F08 규격/성능은 후속이다. RNG 미사용이므로 F01은 최초 RNG 통합 전 의무로 유지한다.
