# DEV-013 — Agent Identity·Artifact Provenance 구현 착수 검토

- Convention Team / 2026-11-01 / v0.1 / REVIEW·DESIGN_PROPOSAL.
- 착수 base: `5c91d56c78c2de5bd94bea7ee66b5c86181f4cb8`.
- INF 회신 수신 후 조사 main: `88496d0c3bcef8d59e76c9977ee6ff07d01339fe`.
- 입력: Owner 제공 INF-002 구현 착수 요청 v1.0 및 현재 채팅으로 전달한 INF 정책 제안 회신.
- 입력 상태는 SPEC_PROPOSED / INF_POLICY_PROPOSAL / OWNER_APPROVAL_REQUIRED다. 실제 ID 발급·정식 정책·Git 쓰기·main 병합 승인으로 확대하지 않는다.

## 1. 작업 ID·소유 경로·worktree 및 권한

정식 추적 ID는 DEV-013이다. DEV-011/012는 Project Leader B의 실제 작업이므로 재사용하지 않는다. 새 브랜치 `codex/DEV-013-agent-provenance-foundation`, 전용 worktree `.local/worktrees/DEV-013-agent-provenance-foundation`을 만들었다. 공유 루트·DEV-011/012의 브랜치·인덱스·소스·미커밋 작업을 변경하지 않는다. 원격 Git 제출은 이번 요청에서 별도 승인 대상으로 명시되었으므로 commit/push/PR은 실행하지 않는다.

소유 경로는 신규 `tools/agent_provenance.py`, `tests/tooling/test_agent_provenance.py`, `docs/engineering/provenance/`, DEV-013 티켓/결과다. INF 실제 등록부·기획/디자인 문서·게임 코드·협업 공통 현황표는 수정하지 않는다. 기존 검사기·훅·CI·PR 템플릿·AGENTS도 이번 단계에서는 그대로 둔다.

worktree별 작업 파일/인덱스/.venv는 분리되지만 Git object DB·refs·일부 config는 공유된다. 이번에는 자체 .venv만 준비하고 install_hooks.py/config 변경을 하지 않는다. fetch는 원격 추적 refs를 갱신하므로 B의 fetch 후 검사 결과도 다시 확인해야 한다. worktree는 원자적 업무 잠금이 아니며 같은 파일의 향후 병합 충돌까지 없애지는 않는다.

확인 시 B의 DEV-011·012는 clean이었다. 작업 중이라는 Owner 안내를 우선하며 idle로 판정하지 않는다. INF 회신 이후 remote head가 진전한 것을 확인했으나 기존 worktree를 pull/switch하지 않았다. 공유 루트 main은 로컬 기준으로 남겨두었다. 후속 제출 전에는 당시 최신 main 기반 새 브랜치에서 이 변경만 재검증한다.

## 2. R&R과 현재 차이 분석

| 대상 | 현재 | 담당·권한 / 이번 처리 |
| --- | --- | --- |
| 실제 ID/등록부 | INF의 빈 Markdown 템플릿, registry.json 없음, 공식 ACTIVE ID 미등록 | INF 작성·세대/이력 관리, Owner 활성화 승인, PM 전환 시점 확인. Convention이 실제 데이터를 만들지 않음 |
| 기존 템플릿 | 건강 상태에 RETIRED 포함, 공식 ID/생애주기 JSON과 분리 필요 | INF가 별도 개정. Convention은 인터페이스 제안·스키마 테스트만 |
| department_policy.py | 부서/티켓/단일 부모/경로, base 예외 목록 검사 | 그대로 보존. provenance는 선행 부서 검사를 재사용하고 권한을 확장하지 않음 |
| policy.py·훅 | 코드·메시지·merge 예방·preflight/push | 현재 변경 없음. 승인 후 등록부/Manifest 사전 검사 어댑터 추가 |
| policy CI | PR 코드·테스트 실행, read 권한 | 기존 필수 job 보존. 향후 시제품 테스트가 추가될 수 있지만 출처 누락 강제와는 다름 |
| department-policy CI | pull_request_target에서 base 코드만 실행 | 보존. 별도 agent-provenance job을 같은 신뢰 모델로 제안 |
| PR/squash | 제목/티켓·본문 템플릿, Owner squash | 신규 메타데이터와 최종 메시지 보존은 별도 설계/Owner 확인 필요 |
| 실제 산출물 | W01 코드·씬/UID·JSON, 향후 이미지/바이너리 포함 | 파일 포맷을 수정하지 않고 Git blob 기반 Manifest로 추적 |

독립 `agent-provenance` job을 권고한다. 기존 두 job의 의미·필수 보호 이름을 유지하면서 시범/강제 결과를 명확히 분리할 수 있다. 기존 department-policy 안에 곧바로 편입하면 등록부 부재나 전환 정책 미결이 기존 업무를 차단한다. 현재는 독립 로컬 REPORT_ONLY 도구만 착수했다. 새 workflow·필수 체크는 아직 만들지 않았다.

## 3. INF 회신 반영과 기술적 수정 권고

INF는 4자리 `AGT-(PM|PLN|DSG|DEV|INF)-[0-9]{4}`, 부서별 증가·재사용 금지, 동일 세션 ID 유지, 공식 교체 시 신규 ID, 임시 Subagent의 감독 주체 귀속, 독립 개발 직무별 ID 검토를 제안했다. 시제품도 4자리로 맞췄다. 시퀀스와 generation은 다르므로 숫자가 같아야 한다는 규칙은 추가하지 않는다. 9999 소진 시 확장은 별도 스키마 개정 사항이다.

등록부 후보 정본은 `docs/infra/agents/registry.json`이다. 원본은 반드시 PR base의 고정 blob에서만 읽는다. 운영 시 경로도 승인된 base 정책에서 고정하고 PR 입력으로 대체 경로를 고르게 하지 않는다. 시제품 CLI의 명시적 --registry는 인터페이스 실험용이며 운영 설정 권한이 아니다.

Owner/INF 합의 전에는 다음을 제안으로만 둔다.

- schema_version과 각 record_version/이력 event 버전의 역할을 분리한다. 최초 요청의 최소 필드에는 record_version이 있지만 두 JSON 예시에는 없어 필수 여부를 확인해야 한다.
- agent_id·department·generation·predecessor는 발급 후 불변, 기존 항목 삭제·ID 재사용 금지. status 변경은 승인 참조와 append-only 이력을 남긴다. 건강 상태와 생애주기는 별도 키/문서로 둔다.
- ACTIVE는 승인 근거·시간대 포함 activated_at이 필요하고 RETIRED에는 retired_at·후임/인계 근거가 필요하다는 안을 제시한다. INF 예시의 ACTIVE/activated_at=null은 실제 운영 승인 예시가 아니므로 초기 등록 전 정합성을 결정한다.
- predecessor는 등록된 같은 부서 ID여야 하고 자기 참조/순환을 금지한다. 병렬 Convention/Leader를 억지로 predecessor 관계로 묶지 않으며 세대와 직무 구분 키가 필요한지 INF가 결정한다.
- 승인 참조는 공개 가능한 결정/인계 기록으로 검토한다. 문자열이 있다는 사실을 승인 원문의 진위 확인으로 표현하지 않는다. 비공개 세션 URL·평가 점수·토큰은 넣지 않는다.

## 4. Commit·PR·파일 출처 데이터 계약 후보

기존 제목은 그대로 둔다. 후보는 마지막 독립 Trailer 블록에 정확히 1개 Agent-ID·Task-ID를 두고 Contributor-Agent-ID를 중복 없이 반복한다. Task-ID는 제목·브랜치·티켓과 일치한다. PR 본문 끝에도 동일한 선언 블록을 두는 안이다. 대소문자·공백·folding 허용 여부와 다른 Trailer와의 결합은 RFC에서 확정한다.

Manifest 후보는 `docs/<부서>/tasks/<TASK-ID>_PROVENANCE.json`, DEV는 기존 `tasks/DEV-NNN_PROVENANCE.json`도 허용한다. 루트에는 schema_version, task_id, primary_agent_id, base_sha, artifacts를 둔다. 파일 항목은 path, change_type, agent_id/modified_by, created_by, contributors, source_refs, blob_sha, old_blob_sha, 필요 시 old_path·generator·review_ref를 다룬다. source_refs는 승인 출처이고 사람/에이전트의 저자 ID가 아니다.

시제품은 핵심 항목인 agent_id·contributors·source_refs·blob_sha 및 이전 SHA를 검증한다. created_by/modified_by의 이력 승계, timestamp/record_version, 승인된 source_refs의 의미, reviewer/approver의 실제 확인은 아직 구현하지 않았다. 이를 정식 전체 검증기로 사용하면 안 된다.

### 자기 참조·중간 커밋·rename

Manifest 자체의 blob은 그 Manifest 안에 넣지 않는다. 면제는 정확히 선택한 한 Manifest 경로뿐이다. 티켓·UID·코드·씬·이미지·결과 문서 등 나머지 변경은 모두 포함한다. 임의 디렉터리 제외나 모든 JSON 제외는 허용하지 않는다.

각 커밋은 동일 pinned base부터 해당 커밋까지의 누적 Manifest snapshot을 포함하는 안을 권고하며 시제품으로 검증했다. head만 검사하면 중간에 생성·삭제한 파일이나 잘못된 과거 snapshot을 놓치므로 모든 커밋 snapshot을 대조한다. 후속 정상 Manifest가 앞선 불일치를 숨기지 못한다. 실제 생성 도구는 commit 전 index의 write-tree/blob ID를 계산하고 Manifest를 마지막에 stage하면 commit hash 자기 참조를 피할 수 있다.

Git rename 유사도는 휴리스틱이므로 시제품은 no-renames diff의 D+A 쌍과 Manifest의 old_path/old_blob_sha를 명시적으로 대응한다. 이름 변경과 내용 변경을 함께 검증한다. 기존 부서 검사도 출발·도착 경로를 모두 검사한다. mode 변경도 추적 대상이다. 바이너리는 실행/디코딩하지 않고 Git blob SHA를 대조한다.

created_by는 확인된 최초 기록만 보존하고 기존 파일의 불명확한 작성자는 UNKNOWN으로 둔다. 후임 수정은 새 modified_by/primary를 기록하되 이전 저자를 후임으로 바꾸지 않는다. report-only 시험 후 파일별 최종 작성자와 해당 커밋의 primary/contributor 연결을 더 엄격히 검사해야 한다. 선언이 일치해도 실제 세션 신원을 인증하는 것은 아니다.

## 5. 판정·보안·전환

생산 구성의 순서는 기존 부서 정책→base 정책/등록부→제목·티켓·Commit/PR Trailer→각 커밋 Manifest coverage→Git diff/tree/old/new blob→선언 결과다. PR 코드는 실행하지 않는다. base 코드·등록부·전환 설정 SHA를 증거로 남기고 head 등록으로 자기 활성화를 인정하지 않는다.

JSON은 크기·행 수·깊이 제한, 중복 key·NaN·잘못된 UTF-8·경로 우회·잘못된 객체 형식을 거부한다. 출력은 정해진 오류 코드만 사용하고 원본 메시지/JSON을 로그로 덤프하지 않는다. 시제품 후보 한도는 JSON 1MiB·등록 1000행·산출물 5000행·깊이32다. 실제 작업 규모·바이너리 수·성능을 보고 INF/Owner 검수 후 조정한다. 바이너리 자체는 읽지 않는다.

### 기존 PR과 RETIRED

INF의 비소급·명시적 예외안을 반영한다. 강제 전환 시 Owner가 승인한 전환 commit SHA와 각 기존 PR 번호·정확한 head SHA·task_id·LEGACY_ACCEPTED/MIGRATE_REQUIRED/OWNER_EXCEPTION·승인 참조를 base의 별도 전환 설정에 고정한다. PR 날짜/commit author date로 면제하지 않는다. head가 달라지면 일치하던 면제도 무효이며 후임 재제출 또는 새 명시적 예외를 요구한다. 정책 변경 PR은 자기 예외를 적용받지 못한다.

RETIRED/SUSPENDED의 신규 primary는 거부한다. 과거 정상 이력은 소급 실패 처리하거나 신규 세대로 재작성하지 않는다. 이미 열려 있던 PR은 승인된 정확한 PR/head/task 예외로 처리한다. 기존 기록의 created_by와 과거 contributor는 역사 역할이므로 신규 작성용 ACTIVE 확인과 구분한다. 과거 contributor를 역사 링크로 남길 별도 필드/증거 형식은 INF/Owner 확인 후 구현한다. 현재 시제품은 시간/예외를 확정하지 않고 base ACTIVE의 보수적 후보 판정만 시험하므로 이 운영 규칙을 완성한 것은 아니다.

### REPORT_ONLY와 ENFORCE

지금 도구는 오직 독립 REPORT_ONLY다. 진단이 있어도 exit0이며 출력 result=DIAGNOSTICS와 identity_authenticated=false를 명시한다. CLI 잘못된 사용은 argparse 오류일 수 있다. no diagnostics는 DECLARATION_CONSISTENT이며 신원/승인/품질 PASS가 아니다.

등록부 승인 후 시범 workflow는 별도 agent-provenance job, contents:read, persist-credentials=false, secrets/쓰기 권한 없이 base의 코드만 실행한다. 이벤트 JSON을 데이터로 읽고 PR 제목/본문을 셸 코드로 보간하지 않는다. report-only는 기존 두 필수 CI를 대체하지 않으며 새 필수 체크로 강제 승격하지 않는다. 시범 job이 성공했다고 정식 enforce 통과로 표현하지 않는다.

Owner가 전환 SHA·대상·예외·검사 이름을 승인한 후 별도 PR로 fail-closed ENFORCE 및 로컬 어댑터를 활성화하고 원격 보호에 새 체크를 추가한다. base 등록부 부재/손상·설정 불일치도 fail-closed다. 정상·부정 PR과 실제 merge blocked 상태를 증거로 확인한다. REPORT_ONLY로 되돌리는 것도 base 정책/Owner 결정이며 PR head가 임의 변경할 수 없다.

## 6. Squash 보존·증거 한계

PR primary 선언과 최종 squash author/committer 계정을 동일시하지 않는다. Owner는 merge 직전 검증한 head SHA와 Agent-ID·Task-ID·Manifest 경로·Provenance-Head(PR head SHA) 보존을 확인해야 한다. 승인된 merge helper는 expected head SHA를 고정하고 명시적인 최종 메시지를 전달하는 안이 가능하지만 자동 병합 권한을 만들지 않는다.

기존 squash 기본 본문=PR 설명만으로 누락을 완전히 차단하지 못한다. PR CI는 미래의 실제 squash 메시지를 알 수 없고 같은 관리자 계정의 수동 편집을 기술적으로 막지 못한다. 예방 체크리스트/승인된 helper와 병합 후 read-only 감사의 차이를 Owner가 결정한다. 사후 누락을 발견해도 자동 amend/force push하지 않고 기존 오류/RFC 절차로 처리한다.

모든 개별 커밋의 중간 파일 버전은 PR audit head와 snapshot으로 연결하지만 squash/브랜치 정리 후 원본 Git object의 영구 도달성은 별도 문제다. PR refs 유지 또는 승인된 감사 bundle/이벤트 원장 보관 중 무엇을 보장할지도 결정해야 한다. SHA가 적혀 있다는 이유만으로 모든 과거 blob을 영구 조회 가능하다고 주장하지 않는다.

## 7. 단계별 구현·검증·의존성

| 단계 | 담당·산출물 | 착수/완료 조건·검증 | 현재 |
| --- | --- | --- | --- |
| 0 영향 조사·시제품 | Convention / DEV-013 계획·RFC·독립 parser/validator·fixtures | worktree 간섭 확인, base self-registration 거부·snapshot/hash·기존 회귀 검증 | 로컬 착수 |
| A 정책/초기 등록 | INF / 실제 등록부·스키마·불변성·전환안 | Owner의 실제 담당·ID·상태 승인, PM 전환 근거, INF PR/main 반영 | 미착수, Convention 대행 금지 |
| B 생산 검사 | Convention / 승인 스키마 전체·registry delta·created/modified/historical·생성 도구·로컬 어댑터 | A와 RFC 확정 후 DEV 별도 티켓, 안전 JSON·부서/구 커밋·스테이징/Blob 회귀 | 계획 |
| C 원격 시범 | Convention+각 부서 / base-only 독립 report-only CI·가이드 | 실제 승인 등록부, Git/API 정상·부정 PR, 오탐·크기/시간·squash 시범 증거 | 계획, 현재 CI 미변경 |
| D 강제 전환 | Owner+Convention+HQ / 전환 SHA·정확한 legacy 목록·필수 체크 | 최소 정상/부정 CI·실제 merge 차단, 신규/은퇴 PR 적용, 기존 두 필수 job 유지 | Owner 승인 필요 |
| E 운영 이관 | INF+Convention+각 부서 | INF 등록부/세대 관리, DEV 도구/검사 유지, 각 부서 선언/Manifest, HQ 도입 조정 | 계획 |

Stage 3-2의 기존 DEV-011/012·디자인 PR에는 현재 신규 출처 검사를 적용하지 않는다. 검사 구현과 게임 작업은 경로를 분리한다. B 이후 공통 훅/CI 수정은 공유 충돌이 생길 수 있으므로 Owner/HQ가 적용 순서를 조정하고 최신 main에서 재검증한다. 날짜·맨먼스를 임의 약속하지 않고 등록부/정책 합의를 선행조건으로 둔다.

## 8. AC-ID-01~12 추적

| AC | 시제품/검증 계획 | 완료 판정에 남은 것 |
| --- | --- | --- |
| 01 정상 등록·부서·Blob | 5부서 synthetic ACTIVE·Trailer·Manifest·Git object 로컬 시험 | 실제 승인 등록부·원격 PR |
| 02 누락/중복/형식 | Commit/PR footer 누락·중복·Task 불일치·4자리 ID 시험 | 최종 Trailer/PR 계약 승인 |
| 03 미등록/부서 불일치 | base ID 존재·상태·부서 대조 시험 | 실제 활성화 승인 |
| 04 자기 등록 | head registry에 신규 ID를 넣어도 base lookup 거부 시험 | registry delta 불변성·부트스트랩 운영 |
| 05 파일 누락/오래된 SHA | 중복·coverage·base/new/old SHA·중간 snapshot 오류 시험 | 생산 생성기·전체 metadata 스키마 |
| 06 바이너리·리소스·삭제/rename | PNG bytes·tscn·D/A explicit rename·old SHA 시험 | 실제 디자인 파일/크기·mode 시범 |
| 07 복수 기여 | 등록된 contributor/PR 연계, 타 부서 경로는 기존 gate로 거부 | 과거/현직 기여자 역할·파일별 최종 행위자 연결 강화 |
| 08 은퇴/열린 PR | 신규용 inactive 거부 시험 | INF/Owner의 snapshot 예외·historical 정책 구현·시범 |
| 09 기존 정상·경계 | 기존 도구 테스트 회귀, 독립 도구라 active CI 영향 없음 | legacy 전환 예외·enforce 도입 회귀 |
| 10 API 훅 우회 | 로컬에선 누락 진단을 재현 | 실제 base-only CI FAIL·merge blocked는 NOT_RUN |
| 11 squash 보존 | 보존 전략·Owner 확인·기술적 한계 설계 | 메시지 계약·helper/감사 선택·실제 merge 시범 NOT_RUN |
| 12 부서/발급 권한 | base registry·기존 경로 검사 재사용, 실제 INF 데이터 미생성 | 승인된 등록부 변경 규칙/Owner 검수; 실신원 보장은 불가 |

현재 코드/fixtures 통과는 전체 AC 수용이나 DONE이 아니다. 실행 증거·파일 목록과 NOT_RUN은 DEV-013_RESULT에서 구분한다. 미확정 결론과 요청 책임은 [RFC-DEV-013-01](RFC-DEV-013-01_POLICY_DECISIONS.md)에 모은다.
