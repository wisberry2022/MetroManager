# DEV-017 — INF 출처 보고·후임 등록 운영 검증 회신

- Convention Team / `AGT-DEV-0002` / 2026-11-08 / REVIEW, DONE 아님.
- 요청 기준 및 착수 fetch 후 최신 main 모두 `fba3fd575c83e1eae234dc77aa9207898e0849b3`. 기준 변경 없음.
- 근거: 현재 Owner가 전달한 INF 후속 검토 요청. DEV-013/#58, INF-002/#64, DEV-016/#66 병합을 운영 실행·ENFORCE 승인으로 확대하지 않는다.
- 최초 회신은 로컬 구현/검증과 실행 계획이며, 이후 Owner의 명시적 승인으로 이번 DEV-017 개발 commit/push/PR을 제출한다. 실제 제출 SHA/CI는 PR과 채팅에 연결하고 아래 사건의 기준·Actions SHA 및 [검토 snapshot 해시](DEV-017_SOURCE_HASHES.json)는 보존한다.

## 1. 실제 Actions 조사·재현

| Run / 실제 job 로그 | trusted base SHA | head SHA | 원래 출력 | 후보 검사기로 재생한 현재 입력의 진단 |
| --- | --- | --- | --- | --- |
| [41447976166](https://github.com/wisberry2022/MetroManager/actions/runs/41447976166/job/125285739634) / PR #67 | `2ae5161a8d61a77b69b71dac09c9cfc1c3fa0df5` | `a77ece72c38e63a27248f9139b471e617d565a72` | INPUT_OR_EXISTING_POLICY_INVALID | MANIFEST_NOT_FOUND / commit_manifest |
| [42424360330](https://github.com/wisberry2022/MetroManager/actions/runs/42424360330/job/128559346129) / PR #69 | `55b5e360d22c10e865cb71a17eb9ba73268ffece` | `dd2f1b4f2644b1c2a5f197302dcdf68473ec05bf` | INPUT_OR_EXISTING_POLICY_INVALID | MANIFEST_NOT_FOUND / commit_manifest |
| [42315780526](https://github.com/wisberry2022/MetroManager/actions/runs/42315780526/job/128227894565) / PR #68 | `bc495d66e99414e6e734df45de283e5d186829c5` | `a497bdec7bb4f2be956621a6fceca0af43bdfd6b` | TRAILER_BLOCK | TRAILER_BLOCK / pr_declaration |
| [42315909404](https://github.com/wisberry2022/MetroManager/actions/runs/42315909404/job/128228319377) / PR #68 | 동일: `bc495d66e99414e6e734df45de283e5d186829c5` | 동일: `a497bdec7bb4f2be956621a6fceca0af43bdfd6b` | TRAILER_BLOCK | TRAILER_BLOCK / pr_declaration |

각 job의 checkout 명령과 JSON 출력에서 base/head를 직접 대조했다. 경로는 모두 `.github/workflows/agent-provenance-report.yml` → `python -I tools/agent_provenance_ci.py` → base registry/registry delta → `agent_provenance.audit` → 기존 `department_policy.range_check` → PR 선언 → 각 작업 commit 선언/Manifest다. 실행한 checker는 해당 base의 파일이며 head의 코드를 checkout/실행한 증거는 없다.

모든 head를 기존 부서 gate로 재생했을 때 PASS다. #67/#69는 현재 PR 본문과 해당 불변 commit의 Agent-ID/Task-ID 선언도 통과한다. 그러나 `docs/engineering/tasks/DEV-015_PROVENANCE.json`이 그 head에 없다. 구 구현은 `git cat-file`의 missing-blob 예외를 기존 정책 오류와 같은 일반 코드로 묶었다. **제출의 Manifest 누락과 검사기의 진단 분류 결함**을 구분한다. 이 일반 코드가 부서 경계 위반이나 작성자 신원 위반을 증명한 것은 아니다.

#68은 현재 공개 PR 본문의 최종 독립 블록에 Trailer가 없으며 pr_declaration에서 TRAILER_BLOCK을 재현한다. 이는 현재 입력의 형식 누락으로 재현되며, 실제 제출자의 의도·신원·권한을 판정하지 않는다. 첫 실패에서 멈추는 검사이므로 PR 선언 뒤의 모든 항목이 정상이라는 뜻도 아니다.

원래 Actions event 파일의 PR 본문 전체는 로그에 남아 있지 않다. 따라서 과거 원문을 완전히 복원했다고 주장하지 않는다. **불변 Git 객체·실행 로그의 SHA는 확정**, 본문/제목은 2026-11-08 현재 공개 PR snapshot으로 재생했다. 원래 base 소스의 audit로 같은 코드를 재현하고 후보 소스로 구체 단계를 확인했다. 본문/제목 SHA-256·checker blob·Manifest 존재 여부·원문 확보 한계는 [기계 판독 증거](DEV-017_ACTIONS_REPLAY.json)에 기록했다. 원본 PR 본문을 새 공개 산출물로 복사하지 않았다.

## 2. 구현·로컬 검증

- Manifest 부재를 MANIFEST_NOT_FOUND로 분리하고 registry 부재·Git 읽기 실패와 구분했다. 기존 policy 검사를 통과시키기 위한 예외는 추가하지 않았다.
- audit_detailed가 고정 진단 code/stage, 해당할 때 검증된 commit SHA·정해진 Manifest 경로를 반환한다. 기존 audit의 code-list 인터페이스는 유지한다. 기존 정책 거부의 호환 코드에는 existing_policy 단계를 붙인다.
- CI 로그에 현재 event의 PR 본문/제목 SHA-256을 남겨 후속 변경 여부를 대조할 수 있게 했다. 원문/임의 예외 메시지·토큰은 출력하지 않는다. 정상 CRLF 운송 개행만 LF로 정규화하며 footer 문법·단일 primary·Task 일치·ACTIVE 검사는 유지한다.
- 자동 등록 API의 HTTP 상태 코드를 비밀정보 없이 구분하고 복구 단계·예상 브랜치·제안 head·쓰기 시도 여부를 기록한다. 시도와 실제 생성 성공을 혼동하지 않는다.

실제 승인 등록부를 가진 위 main의 객체를 임시 저장소에서 읽고, 승인된 Convention ID `AGT-DEV-0002`의 **임시 시험 산출물/Trailer/정확한 Manifest**로 DECLARATION_CONSISTENT를 검증했다. 시험 commit은 임시 객체 저장소에만 생성했으며 운영 refs·등록부에 시험용 ID를 추가하지 않았다. 이것은 로컬 기술 검증이지 정상 원격 PR 검증이 아니다.

누락 PR/commit Trailer, 비활성·미등록 ID, head 자기 등록, 잘못된 blob, 기존 경로 위반, Git 읽기 오류, 정상 CRLF, 원문 비노출·base 신뢰 경계와 등록 실패 복구를 회귀로 확인한다. 실제 명령·최종 결과는 [DEV-017 결과](../tasks/DEV-017_RESULT.md)에 기록한다.

| 구분 | 의미 |
| --- | --- |
| workflow/job success | REPORT_ONLY 프로그램 실행이 끝났다는 의미. 진단이 있어도 exit0 |
| DECLARATION_CONSISTENT | 검사한 범위에서 등록된 선언·Trailer·Manifest·Git 객체가 일치 |
| identity_authenticated=false | 실제 세션의 신원을 인증하지 않음 |
| approval_authenticated=false | 승인 참조 문자열로 실제 Owner 승인 진위를 인증하지 않음 |
| enforcement_enabled=false | 기존 필수 CI를 대신하거나 신규 출처 강제를 활성화하지 않음 |

## 3. 자동 후임 등록 실운영 준비

2026-11-08 GitHub 읽기 조회에서 저장소 전체 workflow_dispatch run은 0건, 열린 PR은 0건이었다. 호출한 경로는 `actions/runs?event=workflow_dispatch&per_page=100`, `pulls?state=open&per_page=100`이다. 토큰·시크릿 내용은 조회하지 않았다. 그 시점의 상태이며 실제 실행 직전에 재확인해야 한다.

현재 승인된 **신규 후보·그 INF 티켓·해당 Git 실행 승인·전용 토큰 준비 확인**은 제공되지 않았다. [실행 계획·입력 양식·중단/복구 표](DEV-017_REGISTRATION_RUN_PLAN.md)를 준비했으며 INF 운영 검수와 Owner 실행 승인을 기다린다. 수동 main 기동 → PENDING draft PR 자동 생성 → INF 수용 → PM 전환 → Owner 활성화 승인 및 병합 순서다. 인수인계 이벤트 감지·자동 ACTIVE까지 제공하지 않는다.

fake API 테스트와 실제 GitHub 성공은 별개다. 단일 부모·두 INF 파일·stale main·등록 PR 중복·브랜치 충돌·HTTP 권한/검증 실패·부분 실패를 로컬 검증했으며 실제 dispatch·원격 생성·필수 CI 실행/통과는 NOT_RUN이다.

## 4. 등록부 계약·ENFORCE

INF가 정본과 잔존 registry_state 문구를 관리한다. 이번 DEV는 INF 데이터를 수정하지 않는다. [RFC-DEV-017-01](RFC-DEV-017-01_REGISTRY_CONTRACT.md)에 루트 갱신, 상태 전환·append-only 이력·기존 시각 보존·신뢰된 승인 근거 계약을 제안했다. 현재의 보수적 ROOT_REVIEW_REQUIRED/TRANSITION_REVIEW_REQUIRED 진단을 임의 해제하지 않는다.

ENFORCE·새 필수 체크·보호 변경은 승인 대기다. 정상·부정 원격 시범 이후에 적용 SHA·대상 PR·PR번호/head/task에 고정한 legacy 예외·은퇴/역사 기여자·최종 Trailer/Manifest·squash 후 근거 보관·필수 job 이름·rollback 기준과 Owner 승인권을 확정해야 한다. 날짜나 작성자 시각으로 소급 예외를 추정하지 않는다. 이 회신으로 전환 SHA나 시점을 자체 결정하지 않는다.

## 회신 상태

| 항목 | 상태 | 증거·한계 |
| --- | --- | --- |
| 단계별 진단·비밀정보 없는 입력/복구 증거 | 구현 완료 (개발 제출 승인 수신) | 변경 파일·해시·테스트는 DEV-017 결과 |
| 네 Actions의 로그/SHA 조사 및 현재 입력 재현 | 검증 완료 | 실제 로그·불변 head, 과거 event 본문 원본은 미확보 |
| 정상·부정 출처 및 등록 중단 동작 | 검증 완료 (로컬) | 임시 Git/fake API이며 원격 성공과 구분 |
| 실제 후임 등록·정상/부정 원격 PR 시범 | 승인 대기 / 미실행 | INF 검수, Owner 후보/Git 승인, 전용 토큰 준비 필요 |
| 등록부 메타데이터/생애주기 계약 | 제안 완료 / 승인 대기 | INF 데이터 검토·PM 전환·Owner 결정 필요 |
| ENFORCE/필수 검사/보호 변경 | 승인 대기 / 미실행 | 기존 policy·department-policy와 REPORT_ONLY 유지 |

후속 Owner가 이번 DEV-017 개발 commit/push/PR을 명시 승인했다. main 병합·실제 등록 workflow·ENFORCE는 별도 승인을 유지한다. INF에 보내는 외부 메시지는 작성·발송하지 않고 이 회신을 Owner에게 제공한다.
