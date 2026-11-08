# RFC-DEV-017-01 — 등록부 갱신·상태 전환·이력 검사 계약

- 상태 OPEN / 2026-11-08 / 요청 Convention / 응답 INF·Owner / 전환 조정 PM.
- 근거: INF 후속 운영 검증 요청, INF-002/#64, DEV-013/#58, DEV-016/#66, main `fba3fd575c83e1eae234dc77aa9207898e0849b3`.
- **계약 제안**이며 실제 INF 데이터나 강제 정책을 변경하지 않는다. 기존 ROOT_REVIEW_REQUIRED·TRANSITION_REVIEW_REQUIRED·HISTORY_CHANGED 진단은 유지한다.

## 문제·경계

등록부의 OWNER_APPROVED_PENDING_MAIN_MERGE는 제출 당시 문구로 남아 있다. 현재 구조 비교는 root 변경 전체를 검토 대상으로 보고 모든 상태 전환을 자동 통과시키지 않는다. 문구 정리와 인사 전환을 같은 종류의 데이터 변경으로 취급하면 오탐 또는 무단 활성화가 발생할 수 있어 계약을 분리해야 한다.

INF는 정본·공개 정보·계보·수용·승인 근거·실제 효력 시각을 작성한다. Convention은 도구/검사 계약을 구현한다. PM은 업무 범위/전환을 확인하고 Owner가 후보·Git 실행·활성화·권한·main 병합을 각각 승인한다. 같은 계정의 문자열/버튼 실행으로 실제 승인 신원을 기술적으로 인증할 수 없음을 유지한다.

## A. root 메타데이터 갱신

| 제안 유형 | 필요한 검사 | 승인·반영 |
| --- | --- | --- |
| pending 문구의 병합 후 정리 | agent 행 전부 동일, ID/상태/시각 불변. registry_state의 허용 의미를 INF가 정의 | INF PR·Owner 검수, Convention이 INF 파일을 대신 고치지 않음 |
| registry_version/source_main_sha/공개 승인 참조 갱신 | root 허용 키 목록·이전/새 값·사유·검토 기준 base SHA·승인 참조 검증 | 확정된 schema 버전과 별도 DEV 검증기 구현 후 적용 |
| repository/schema_version/activation_time_policy 등 계약 변경 | 단순 root 정리로 통과시키지 않음. migration·호환·Owner 정책 결정 필요 | RFC·Owner 결정 후 INF/DEV 분리 제출 |

권고: 변경 순서는 별도 정수 registry_revision과 마지막 event 참조로 추적하고 기존 문자열 버전은 표시 용도로 유지하는 안을 INF와 협의한다. 현재 JSON 필드를 임의로 추가하지 않는다. source_main_sha는 **검토 기준 SHA**이며 아직 생성되지 않은 자기 main merge SHA를 JSON 안에 요구하지 않는다. 병합 사실은 별도 감사 receipt에서 실제 merge SHA와 연결한다.

## B. 생애주기 전환 계약 후보

| 변경 | 필요한 근거·효력 시각 | 권고 기본 판정 |
| --- | --- | --- |
| 신규 후보 | Owner 후보 지정·INF 계보/공개 검토·해당 Git 실행 승인 | PENDING, activated_at=null, 새 번호·record_version=1 |
| PENDING→ACTIVE | PENDING PR 생성 이후 INF 수용 근거 → PM 전환 확인 → Owner 최종 활성화 결정과 실제 효력 시각 | 전 근거 연결을 확인한 승인된 전환만 최종 검수 대상으로 제출. 자동 활성화 없음 |
| ACTIVE→SUSPENDED | Owner 중단 결정·PM 업무 영향, 정확한 효력 시각 | 신규 작업 primary 거부, 역사 이력 보존 |
| ACTIVE/SUSPENDED→RETIRED | Owner 종료 결정·PM 전환·INF 인계/후임 연결, 실제 종료 효력 시각 | retired_at 기록, 과거 저자/기여자 치환·삭제 금지 |
| SUSPENDED→ACTIVE | INF 재수용·PM 복귀 확인·Owner 재활성 결정, 정확한 효력 시각 | 첫 activated_at을 덮지 않고 별도 재활성 event로 남기는 안 권고 |
| RETIRED→ACTIVE | 기존 ID 재사용 금지와 충돌 가능 | 기본 거부·새 ID 권고. 예외를 원하면 Owner가 별도 재활성 계약을 승인하기 전 지원하지 않음 |
| role/scope/kind 정정 | 동일 주체인지 INF 확인·공개 정보 정정 결정 | ID/부서/세대/선행자 재할당과 구분한 PROFILE_CORRECTION event 계약 필요 |

기존 초기 8개 ID의 알려지지 않은 activated_at/retired_at=null은 승인된 bootstrap 사실대로 남긴다. 날짜 메모·commit author date·PR/검사/병합 시각으로 채우지 않는다. 미래 전환은 오프셋 포함 ISO 8601 실제 Owner 승인 효력 시각이 없으면 확정하지 않고 검토 요청 상태로 둔다. 재활성화가 과거 최초 활성화의 시각을 발명할 근거가 되지 않는다.

## C. append-only 변경 이력 후보

별도 INF 소관 event 원장의 최소 항목을 제안한다. 경로·schema는 INF/Owner 확정 전 추가하지 않는다.

- event_id, event_version, agent_id, operation, previous_record_version/new_record_version.
- before/after의 허용 필드 diff와 previous_event_ref. 삭제·기존 event 수정·버전 건너뛰기·동일 ID 재할당 금지.
- candidate_decision_ref, inf_acceptance_ref, pm_switch_ref, owner_activation_decision_ref, git_operation_approval_ref. 후보 지정·Git 승인·활성화 근거는 다른 역할로 기록.
- effective_at은 Owner 승인 효력 시각, recorded_at은 기록 시각으로 분리. 둘을 자동 대체하지 않음.
- reviewed_base_sha·검증한 head SHA·실제 병합 감사 receipt 연결. 승인 참조 진위의 책임과 도구의 구조 검사 범위를 구분.

상태 전환은 record_version 정확히 +1과 허용 operation/diff/event를 대조한다. 시퀀스는 기존 PENDING/RETIRED도 포함한 부서별 최댓값 뒤에서만 발급하며 삭제/재사용하지 않는다. predecessor는 같은 부서·세대 연결, 순환/자기 참조 금지, 독립 역할은 1세대다. 건강 상태 NORMAL/WATCH 등은 생애주기와 별도 관리한다.

## D. 승인 신뢰와 PENDING PR 흐름

현재 절차는 PENDING 등록 PR → INF 수용 → PM 전환 → Owner 활성화 승인 및 병합이다. PENDING이 main에 미병합인 동안의 후보 ID는 정식 예약/ACTIVE가 아니다. 생성/활성화 PR의 head에서 추가한 ID로 같은 제출의 작성 주체를 자기 인증하지 않는다. 제출 주체는 trusted base의 기존 ACTIVE INF ID를 유지한다.

ENFORCE에서 승인된 ACTIVE 변경을 자동 판정하려면 Owner 결정의 정본 위치가 필요하다. 권고는 trusted base에 고정한 승인 결정 또는 별도 승인된 변경 불가 결정 원장을 대조하는 안이며, head의 문자열만으로 자기 승인하지 않는다. 같은 PR 안에서 최종 승인 기록을 작성하는 운영을 선택할 경우 CI가 인증할 수 있는 범위와 사람의 Owner 검수를 구분해 명시해야 한다. 어떤 방식을 택할지는 INF·Owner 결정 전 자동 통과 예외를 만들지 않는다.

RETIRED/SUSPENDED의 새 primary는 거부하되 과거 작성자·역사 기여자는 원래 ID로 보존한다. 역사 역할의 별도 필드·근거 commit과 새 Contributor 역할을 구분해야 한다. 기존 Trailer의 Contributor-Agent-ID를 임의로 역사 필드처럼 해석하지 않는다. 새 계약은 기존 PR에 소급 강제하지 않는다.

## E. ENFORCE 전환 전에 남은 승인

정상·부정 **원격** PR 실증과 위 계약 검토가 끝나기 전 전환을 제안하지 않는다. 후속 전환안은 다음을 포함해야 한다.

| 항목 | 현재 |
| --- | --- |
| 적용 기준 main SHA·대상 PR 범위·적용 기록 | 미정. Owner가 별도 승인 |
| 기존 PR 번호+정확 head SHA+task+승인 참조 예외 | 미정. 날짜로 자동 면제하지 않음 |
| 은퇴/역사 기여자·진행 중 PR 처리 | 위 후보 계약 검토 필요 |
| 최종 Trailer/Manifest·파일별 생성/수정/UNKNOWN·sync snapshot 계약 | 미결 항목 유지, 정상/부정 테스트와 작성 도구 필요 |
| squash 후 Agent-ID/Task-ID/Manifest/Provenance-Head 및 중간 객체 보관 | 보관 책임·기간·감사 receipt 검토 필요 |
| 새 필수 체크 이름·App 바인딩·실제 merge 차단 검증 | Owner 별도 승인. 현재 policy/department-policy 보존 |
| rollback 기준·승인권자 | 오탐/실패 영향 기준을 정하고 Owner가 base 정책으로 승인. head 임의 REPORT_ONLY 전환 금지 |

rollback도 기존 두 필수 검사를 해제하는 우회가 아니다. 새 출처 gate의 보고 전용 전환/범위 조정을 승인 기록과 base 정책으로 관리하며 main 이력 재작성·자동 보호 해제는 하지 않는다.

## 회신·영향

- Convention 권고: root-only 정리와 생애주기 전환을 분리하고 전환은 event+근거+실제 효력 시각으로 검토한다. 현 단계는 REPORT_ONLY 유지.
- INF 검토 PENDING / PM 전환 조정 PENDING / Owner 계약·시행 결정 PENDING.
- 반영 대상: INF 등록부/이력 스키마·운영 문서, DEV validator/작성 도구·회귀, Owner 전환 기록. 이 RFC 자체가 승인이나 예외를 만들지 않는다.
- 게임·세이브 영향 없음. 실제 역할/권한 전환과 ENFORCE를 별도 승인으로 분리한다.
