# DEV-016 — INF-002 회신 검토·등록부 REPORT_ONLY 연동

- Convention Team / Agent-ID `AGT-DEV-0002` / 2026-11-02 / REVIEW.
- 신뢰 기준: INF-002가 병합된 main `682a4f10f2cfe14bed6984e87bff75c05f37d8b5` (PR #64).
- Owner는 검토·로컬 구현 후 현재 채팅에서 DEV-016 개발 PR 제출을 요청했다. 이번 개발 commit/push/PR만 포함하며 main 병합·INF 자동 등록 실제 실행·ENFORCE는 별도 승인 대상이다.

## 회신에서 확정된 내용

INF 소관 `docs/infra/agents/registry.json`에 8개 ID(ACTIVE 7, RETIRED 1)가 등록됐다. Convention은 `AGT-DEV-0002`, Leader B/LAPTOP은 `AGT-DEV-0001`, 독립 DESKTOP은 `AGT-DEV-0003`이며 각각 1세대다. 시퀀스와 세대를 동일시하지 않는다. 과거 실제 시각을 모르는 초기 등록은 activated_at/retired_at의 null을 보존한다. 이후 후임의 실제 활성화에는 INF 수용·PM 전환·Owner 임명과 정확한 오프셋 포함 효력 시각이 필요하다.

등록부는 INF 소관이며 이번 DEV는 읽기만 한다. 등록부의 `OWNER_APPROVED_PENDING_MAIN_MERGE` 문구와 INF 결과의 병합 대기 문구는 제출 당시 기록으로 남아 있다. 실제 병합 사실은 위 Git SHA로 확인했으며 문구를 자동 수정하거나 강제 적용 플래그로 사용하지 않는다. INF의 후속 정리 대상으로 남긴다.

`REGISTRATION_AUTOMATION_REVIEW.md`는 DESIGN_ONLY다. 자동 ACTIVE·자동 main 병합 금지와 single writer/최신 SHA/수동 검토 원칙을 반영하되, 원격 실행 권한까지 승인되었다고 간주하지 않는다. 후속 Owner 전달 요구로 PENDING PR 자동 생성 → INF 수용 → PM 전환 → Owner 활성화 승인 및 병합 순서를 확인해 [PR 자동 생성 도구와 workflow 후보](DEV-016_REGISTRATION_PR_AUTOMATION.md)를 보완했다.

## 구현 범위와 책임

| 범위 | 구현·판정 | 실행 권한 |
| --- | --- | --- |
| 등록부 구조 검사 | core schema, record_version, 부서·계보·세대·시각·활성 scope 검증. bootstrap의 초기 ID에만 과거 시각 null 허용 | DEV 도구, INF 데이터 정본 |
| 변경 대조 | ID 삭제/재할당·불변 필드 변경·버전 누락·번호 재사용·신규 ACTIVE 거부. 신규는 PENDING/version1만 제안 가능 | 구조 일관성만 검사. 승인 문자열의 진위 인증 아님 |
| 상태·이력 변경 | 자동 승인하지 않고 REGISTRY_TRANSITION_REVIEW_REQUIRED/HISTORY_CHANGED 등 진단 | append-only 이벤트·재활성화 정책은 INF/Owner 확정 필요 |
| 후임 제안 CLI | origin/main의 확인된 SHA·registry blob SHA를 포함한 OFFLINE_PROPOSAL 출력. 파일/index/refs/원격 쓰기 없음 | ID 발급/예약 아님. INF가 별도 승인된 티켓에서 검토 |
| PENDING PR 자동 생성 후보 | 기본 prepare-only 생성기와 main 수동 기동 workflow. INF 티켓·두 경로·부모1·신규 PENDING만 draft PR로 생성 | 로컬 구현/fake API 검증만, 실제 실행·활성화·병합은 미실행 |
| REPORT_ONLY CI 후보 | 별도 agent-provenance-report. base checkout/code/registry만 신뢰, PR Git objects·event는 데이터로 읽음. 결과와 진단 코드만 출력 | 기존 두 필수 job·보호 설정 변경 없음. 신규 필수 체크로 등록하지 않음 |
| DEV-014 호환 | 정확한 clean base-sync는 공통 gate가 증명한 뒤 출처 재귀속에서 제외. 일반 커밋별 merge-base로 snapshot 대조 | 임의 merge·수동 충돌 해결 허용 아님 |

새 등록부 루트 메타데이터 변경·생애주기 전환·승인 근거 변경은 정책 미확정 항목을 통과시키지 않도록 검토 진단으로 남긴다. 이를 자동 인사 판정이나 모든 운영 스키마의 완전 구현으로 해석하지 않는다. legacy/historical 기여자·created_by/modified_by 승계·squash 증거 보관·Manifest 생성 도구·ENFORCE는 후속 범위다.

## 사용 방법

실제 데이터를 쓰지 않는 등록부 확인:

```powershell
.venv/Scripts/python.exe tools/agent_registry.py check --base 682a4f10f2cfe14bed6984e87bff75c05f37d8b5
```

기대 결과는 STRUCTURALLY_CONSISTENT/agents=8이며 identity_authenticated와 approval_authenticated는 false다. `check --base <확인된 SHA> --head <후보 SHA>`는 등록부 변경을 구조적으로 대조한다. check/propose 오류는 exit1이며 기존 policy 검사를 대신하지 않는다.

INF 담당자가 승인된 자기 티켓·후임 후보 근거로 제안을 만들 때:

```powershell
# 먼저 승인 범위에서 fetch하고 실제 main을 재확인한다. 도구 자체는 fetch하지 않는다.
$reviewedBase = git rev-parse origin/main
.venv/Scripts/python.exe tools/agent_registry.py propose `
  --base $reviewedBase --task $approvedInfTask --department $departmentCode `
  --role $publicRole --scope $publicScope --predecessor $registeredPredecessor `
  --approval-ref $candidateApprovalRef --handoff-ref $publicHandoffRef
```

변수는 INF가 검토한 공개 가명·참조로 채운다. 독립 최초 직무는 predecessor/handoff 옵션을 생략할 수 있다. 도구는 사용된 최댓값+1을 계산하고 generation은 선행자+1 또는 독립 직무의 1로 둔다. 새 항목은 반드시 PENDING, 시각 null, session_kind=UNCONFIRMED인 후보이므로 INF가 실제 정보와 공개 범위를 검토한다. 반환된 ID는 예약되지 않았다.

동시 두 제안은 같은 번호를 계산할 수 있다. 이 오프라인 CLI에는 분산 잠금이 없으므로 원격 ID 예약 수단으로 사용하지 않는다. 실제 제출자는 단일 writer/직렬화, 최신 main 재조회, expected main/registry SHA 대조, 충돌 시 새 base에서 재계산, force=false, 별도 Owner 승인·수동 main 병합을 지켜야 한다. 후속 Owner 전달 요구를 반영해 원격 writer와 workflow_dispatch 후보를 로컬 구현했다. 실제 배포·토큰 설정·실행은 하지 않았다. 진행 중인 registry PR이 있으면 다음 자동 제출을 중단하며 자세한 경합/복구 절차는 [자동 PR 생성 보완](DEV-016_REGISTRATION_PR_AUTOMATION.md)을 따른다.

REPORT_ONLY workflow는 이 DEV 변경이 Owner 검수 후 main에 반영된 이후의 PR부터 base 코드로 동작한다. 현재 제출 전 로컬 구현만으로 원격 시범이 시작된 것이 아니다. 진단이 있어도 도구 exit0이며 result=DIAGNOSTICS/diagnostics를 읽는다. 기존 policy/department-policy 실패를 숨기지 않는다. CI 인프라 자체 실패는 성공으로 덮지 않는다.

시범 제출자는 기존 제목을 유지하고 commit/PR 끝의 독립 footer에 Agent-ID/Task-ID를 기록하며 필요 시 Contributor-Agent-ID를 추가한다. 실제 등록 ACTIVE ID만 사용하고 Manifest는 기존 DEV-013 후보 계약에 따라 각 작업 커밋의 당시 main 기준 누적 변경을 기록한다. 동기화 뒤 새 작업 snapshot은 새 main 기준으로 재작성해야 한다. 단순 보고 단계이며 현직 B의 기존 제출을 누락만으로 차단하지 않는다.

Manifest의 기본 위치는 `docs/<부서>/tasks/<TASK-ID>_PROVENANCE.json`이다. DEV-013 parser는 옛 `tasks/DEV-NNN_PROVENANCE.json`도 인식하지만 기존 부서 gate의 legacy 경로는 Markdown만 기본 허용한다. legacy JSON은 Owner가 승인한 base path exception이 있을 때만 유효하다. 이번에 경로 권한을 넓히지 않는다. 두 Manifest 경로가 함께 있으면 MANIFEST_AMBIGUOUS로 진단한다.

## RFC-DEV-016-01 — 남은 정책·운영 확인

- 상태 OPEN / Convention 요청 / INF 기술 검토·Owner 결정 / HQ·PM 전환 조정.
- 근거: INF-002 자동화 검토와 RFC-DEV-013-01 미결 항목. 등록부가 생겼다는 사실을 전체 Q01~Q10 승인으로 확대하지 않는다.
- 제안: 현재 구조 검사/오프라인 PENDING 제안과 독립 REPORT_ONLY 시범부터 검수한다. 실제 상태 전환은 분리하고 PENDING PR 자동 생성 후보를 함께 검수한다.
- 확인 1: immutable role/scope/kind의 정정, root registry_state/version 갱신, append-only event schema, 승인 변경·재활성화 예외를 확정할 것. 지금은 검토 진단으로 유지한다.
- 확인 2: 최종 Trailer/Manifest 계약, 최초/수정 저자 승계·역사 기여자·은퇴/기존 PR 예외, squash 후 보관/검토자 증거를 확정할 것. 일반 작업의 누락은 REPORT_ONLY로만 진단한다.
- 확인 3: 후속 요청에 따라 PR 생성기는 main workflow_dispatch·전역 concurrency·진행 중 등록 PR 중단·SHA 재확인으로 구현했다. 실제 시크릿/실행 Git 권한과 수동 writer 조정·실패 복구는 INF/Owner 운영 확인 대상이다. 같은 계정의 실행자 이름을 Owner 인증으로 사용하지 않는다.
- 확인 4: 원격 시범의 대상 PR·성공/부정 기준을 검수한 뒤 ENFORCE 전환 SHA·범위·예외·필수 검사 이름·rollback 승인권을 별도로 결정할 것.
- 영향: 게임·세이브 변경 없음. 도구/신규 workflow만 변경, 기존 필수 검사와 B 소스 수정 없음. 새 필수 CI 등록·원격 시험은 NOT_RUN.
- Convention 의견 위와 같음 / INF·HQ 회신 PENDING / Owner 운영 전환 결정 PENDING. 부분 승인된 등록 사실과 미결 정책을 구분해 유지한다.
