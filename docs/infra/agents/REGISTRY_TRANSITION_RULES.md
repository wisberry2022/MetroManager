# Agent Registry — 전환 및 후속 기록 규정

- ID: INF-REG-TRANSITION / v1.0 / 2026-11-14 / 소유: INF
- 결정: [INF-009](../tasks/INF-009_LIGHTWEIGHT_SUCCESSION.md)의 Owner 간소화 승인
- 상태: OWNER_POLICY_APPROVED / PR_REVIEW / MAIN_MERGE_PENDING
- 적용: 공통 원격 기준은 INF-009의 별도 Owner 병합 승인·main 반영 후 적용한다. 과거 전환·수용 결과는 소급 변경하지 않는다.
- 연결: [건전성·인계 정책](../AGENT_HEALTH_POLICY.md), [인계 양식](../AGENT_HANDOFF_TEMPLATE.md), [기록 양식](../AGENT_REGISTRY_TEMPLATE.md), [등록부](registry.json)

## 1. 업무 효력과 등록 반영

통상적인 컨텍스트 관리 목적의 교체는 Owner의 최초 지시로 후임 임명·이전 담당 종료·효력 시각·승계 업무를 확정한다. 후임이 인계서와 최신 승인 원본을 확인하면 지정 시각부터 허용된 업무를 시작한다. INF 수용시험·HQ 전환 확인·Owner 재승인을 별도로 기다리지 않는다.

다음 두 상태를 분리한다. 아래 기록 상태는 인계서·티켓용이며 registry.json의 lifecycle enum을 추가하지 않는다.

| 구분 | 근거와 의미 |
|---|---|
| 업무상 전환 | Owner의 유효한 전환 결정 + 후임 인수 확인. 결정된 시각의 기존 RETIRED/후임 ACTIVE와 허용 범위를 따른다 |
| REGISTRY_RECORD_PENDING | 해당 결정이 아직 main 등록부에 기록되지 않음. 업무상 권한을 부정하거나 trusted base 반영 완료로 표시하지 않음 |
| REGISTRY_RECORDED | 실제 main의 행·PR·merge SHA를 확인하여 기록 완료. 병합 시각을 전환 효력 시각으로 바꾸지 않음 |

INF의 등록 업무는 후속 기록·정합성 관리다. 작성 책임자와 후속 INF 티켓 또는 추적 참조를 전환 기록에 남기고, 다음 등록 갱신에서 미반영 결정을 함께 대조한다. 누락이 발견되면 복구 대상으로 추적하며 무기한 방치하지 않는다. 등록을 기다리게 하는 별도 인수 승인 단계는 만들지 않는다. 등록 PR 자체의 파일 변경·Commit·Push·PR·main 병합은 유효한 Owner 권한 범위를 확인한다. 이 정책만으로 미래 모든 등록 PR의 쓰기·병합을 위임하지 않는다.

## 2. 신규 ID 확정과 중복 방지

1. 기존 ID는 predecessor로 보존하고 새 세션에 재사용하지 않는다. 같은 부서 후임은 선행자의 generation + 1, 독립 역할은 generation 1이다. 번호와 세대는 다른 개념이다.
2. Owner의 전환 기록에서 새 ID를 확정한다. 작성자는 최신 main의 모든 상태 ID와 열린 등록 PR, **미반영 Owner 전환·ID 배정 기록**을 함께 대조한다. Owner는 후임에게 적용 대상 기록 목록을 전달하며, 이미 사용·확정된 번호를 다시 배정하지 않는다.
3. 동시 전환의 번호 확정은 Owner의 단일 순서로 관리한다. 각 에이전트가 main의 최댓값만 보고 독립적으로 발급하지 않는다. 미반영 기록을 조회할 수 없거나 충돌하면 번호는 UNKNOWN으로 남기고 ID 확정·해당 ID를 사용하는 쓰기만 보류한다. 원본 읽기·복구 준비는 가능하다.
4. 승인된 전환 기록의 ID 확정은 업무상 예약이다. 도구의 PENDING 제안, 미승인 PR 또는 양식의 예시는 예약이 아니다. 자동화는 미반영 예약을 아직 이해한다고 가정하지 않는다.
5. 미반영 ID의 등록은 배정 순서를 보존한다. 취소·번호 공백·동시 갱신은 별도 정정 근거로 처리하며 기존 ID를 삭제하거나 다른 주체로 재할당하지 않는다.

전환 기록은 Owner 제한 보관이 기본이다. INF에 후속 기록용 최소 정보(결정 ID·기존/신규 ID·역할·세대·효력 시각·승계 범위·인계 참조)를 전달하고 공개 Git에는 비공개 대화·세션 URL 없이 최소 근거를 기록한다. 본 정책이 자동 메시지 전송이나 자동 예약 서비스를 구현하지는 않는다.

## 3. 시각·행·이력 규칙

- 이전 담당 종료와 후임 시작을 각각 오프셋 포함 ISO 8601로 기록한다. 같은 시각인지 서로 다른 시각인지 Owner 결정대로 보존한다. 겹치는 동일 업무 쓰기는 허용하지 않으며 공백의 복구·보류 상태를 명시한다.
- 지정 시각보다 후임 확인이 늦으면 결정된 효력 시각과 실제 인수 확인/업무 개시 시각을 따로 기록한다. 늦은 확인을 과거 수행으로 소급하지 않는다. 전임의 쓰기 권한이 자동 복구되지도 않는다.
- activated_at/retired_at은 실제 Owner 승인 효력이다. 작성일·시험일·commit·PR·workflow·merge 시각으로 추정하지 않는다. 효력이 불명확하면 해당 전환은 확정하지 않는다.
- 준비만 지시된 후보는 PENDING이고 activated_at=null이다. 최종 임명·전환이 승인된 통상 인계는 불필요한 PENDING PR·시험 단계를 거치지 않고 ACTIVE/RETIRED를 수동 후속 기록할 수 있다.
- 새 행 record_version=1, 기존 행 변경은 정확히 +1이다. 기존 ID와 승인된 bootstrap 레거시 활성화 시각 null, 과거 작성자·승인·계보는 보존한다. 새로운 정보 없이 session_kind를 추측하여 채우지 않는다.
- 인계 ID, Owner 결정 참조, 업무 효력 시각, 실제 인수 확인 시각, 기록 시각과 base/head/merge SHA를 구분해 티켓·결과에 연결한다. 수행하지 않은 시험은 NOT_RUN(통상 인계 정책상 생략)이며 ACCEPTANCE_VERIFIED로 꾸미지 않는다.
- 이미 병합된 기록의 정정은 사유와 이전/새 값을 새 티켓·PR로 남긴다. 원래 승인 기록·과거 commit을 덮어쓰지 않는다. 일반 append-only event 저장소/schema와 재활성화 계약은 아직 별도 미결이며, 본 규정으로 구현 완료를 선언하지 않는다.

## 4. 업무 권한과 제출 주체

Owner 최초 지시에 티켓·저장소·경로·브랜치·Commit/Push/PR 허용 동작·기간/종료 조건을 명시하거나, 정확히 열거한 기존 유효 권한을 같은 범위로 후임에게 이전한다고 명시할 수 있다. 이 경우 같은 권한을 다시 승인받지 않는다. 인계서에 적었다는 사실만으로 미승인·만료된 권한이 생기지 않으며, 명시되지 않은 Git 동작은 수행하지 않는다.

후임은 새 Agent-ID로 자신의 작업을 기록한다. 전임의 ID·author·과거 승인 주체를 빌리거나 기존 commit의 저자를 치환하지 않는다. 전임은 정해진 종료 시각 이후 인계 업무에 신규 쓰기를 하지 않고 질의에만 응답한다. 새 범위·main 병합·릴리스는 해당 동작에 대한 Owner 승인 또는 유효한 명시 위임이 필요하다.

후임 ID가 trusted base에 미반영이어도 유효한 Owner 실행 권한이 있는 업무는 진행할 수 있다. PR에는 전환 결정 참조와 REGISTRY_RECORD_PENDING을 밝히고 실제 새 ID를 사용한다. 이 사실을 도구의 신원 인증이나 필수 CI 면제로 해석하지 않는다. 필수 검사가 실제로 차단하면 해당 제출을 멈추고 등록 반영 또는 승인된 Convention 수정으로 해결한다. 다른 승인된 읽기·분석까지 일괄 중단하지 않는다.

INF 자체 교체에도 통상 절차를 적용한다. 후속 등록은 Owner가 지정·승인한 실제 작성자가 수행하고 자기 PR의 새 ID로 자기 권한을 인증하지 않는다. 상세 독립 평가를 요청받은 경우에는 평가 대상자가 자신을 독립 평가하지 않는다.

## 5. 기존 도구·계약과의 연결

[등록 자동화 검토](REGISTRATION_AUTOMATION_REVIEW.md)와 [RFC-DEV-017-01](../../engineering/provenance/RFC-DEV-017-01_REGISTRY_CONTRACT.md)의 과거 필수 INF 수용·PM 확인 순서는 통상 **수동 인계**에 대해서 본 규정으로 대체한다. RFC의 도구 구현·append-only schema·재활성화·ENFORCE·rollback 계약 전체를 확정한 것은 아니다.

- DEV-017은 PENDING 제안 도구다. 내장 review_sequence/requires에 과거 단계가 남아 있으며, 이 PR은 도구를 변경하거나 workflow_dispatch를 실행하지 않는다. 미반영 예약이 있으면 해당 ID 범위의 자동 제안을 사용하지 않고 승인된 수동 기록으로 처리한다.
- 현재 비교기는 activation_time_policy 변경에 REGISTRY_ROOT_REVIEW_REQUIRED, 수동 전환에 REGISTRY_TRANSITION_REVIEW_REQUIRED 또는 REGISTRY_NEW_PENDING_ONLY를 낼 수 있다. 미등록 후임도 진단 대상일 수 있다. 실제 로그를 확인하고 승인 근거·구조 검사·진단을 구분한다.
- agent-provenance-report는 REPORT_ONLY, identity_authenticated=false, approval_authenticated=false, enforcement_enabled=false를 유지한다. job SUCCESS는 진단 없음 또는 실제 승인 인증을 뜻하지 않는다.
- policy·department-policy, trusted base 사용, 경로·브랜치·Owner 병합 규칙은 유지한다. head 자기 예외·ID 사칭·검사기 완화·CI 우회로 통과시키지 않는다.
- Convention 후속 검토 범위: 미반영 ID 예약 대조, 새 전환 근거와 기존 review_sequence 정합성, root/전환/이력 검사 및 정상·부정·stale base·API/부분 실패 복구. 기술 수정·실운영시험·ENFORCE는 별도 실행 승인과 증거가 필요하다.

## 6. 예외와 복구

Owner가 상세 검증을 요청하거나 권한 충돌·중대한 인계 누락이 있으면 필요한 항목만 검증한다. 미확인 내용은 UNKNOWN/NOT_VERIFIED, 미실행은 NOT_RUN으로 남긴다. 전환 결정이 없는 후보를 자체 활성화하지 않는다. 현직 세션 접근 불가 시 승인 Git·티켓·PR로 복구하고 미커밋·비공개 결정은 추측하지 않는다. 이미 RETIRED인 ID의 복귀는 자동 처리하지 않는다.
