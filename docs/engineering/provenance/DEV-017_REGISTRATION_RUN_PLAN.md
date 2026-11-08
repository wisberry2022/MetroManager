# DEV-017 — INF 운영 검수용 후임 등록 실행 계획

- 2026-11-08 / PLAN_ONLY / 실제 실행 승인 대기. 검토 main `fba3fd575c83e1eae234dc77aa9207898e0849b3`.
- 현재 지정 후보 없음, 시험 ID를 운영 등록부에 임의 추가하지 않음. 등록부 INF / 도구 Convention / 인계 PM / 후보·Git·활성화·병합 Owner 책임.

## 실행에 앞서 채울 입력

| 항목 | 정본·검수 책임 | 현재 |
| --- | --- | --- |
| 실제 후보/부서/공개 role·scope·선행 Agent-ID | Owner 지정, INF 중복·계보·공개 정보 검수 | 미제공 |
| INF 작업 ID·작업 범위·인계 참조 | 승인된 INF 티켓·인계 기록, PM 업무 범위 확인 | 미제공 |
| 후보 지정 공개 결정 참조 | Owner 후보 지정. 최종 활성화와 구분 | 미제공 |
| 이번 commit/push/등록 PR 생성의 Git 승인 참조 | Owner, 저장소·브랜치·기간·허용/금지 동작 포함 | 미제공 |
| 실제 main/registry blob SHA·기존 PR/브랜치 조회 | 실행 직전 Convention 기술 점검, INF 확인 | 이번 검토 SHA만 확보 |
| 전용 AGENT_REGISTRATION_TOKEN 준비 | Owner가 대상 저장소 최소 contents/PR write 권한·시크릿 준비 확인 | 미확인, 토큰 값은 문서/로그에 넣지 않음 |
| INF 수용시험·PM 전환·최종 활성화 | PENDING PR 이후 각 담당 검수. 실제 Owner 승인 효력 시각 포함 | 미실행 |

변수가 채워지기 전에는 실제 candidate ID를 계산·예약하거나 submit하지 않는다. 현재 원격 등록 workflow는 수동 main 기동이며 인계 이벤트 자동 감지가 아니다. 코드의 workflow 문맥 검사는 오작동 방지이며 같은 계정의 실제 승인자 인증은 아니다.

## 준비·검수·실행 순서

1. INF가 실제 후보와 공개 입력을 검수하고 Owner가 해당 Git 실행을 승인한다. 실행 때 최신 main을 fetch/read하고 검토 SHA와 다르면 차이를 다시 확인한다. 초기 8개 ID와 역사 null 시각은 보존한다.
2. 승인 입력으로 `tools/agent_registration_pr.py`를 **--submit 없이** 실행해 계획을 검토한다. 기본 prepare는 네트워크·토큰 조회·원격 쓰기 없이 후보 PENDING/null·부서 시퀀스·예상 경로를 반환한다. prepare 결과가 ID 발급/예약은 아니다.
3. INF가 아래 두 파일의 diff와 후보/선행자/세대/승인 참조를 검수한다. 기존 등록부 항목이 변경되면 중단한다.
4. Owner 실행 승인·토큰 준비를 확인한 후 main의 `agent-registration-proposal.yml` workflow_dispatch를 기동한다. cancel-in-progress=false 전역 concurrency와 열린 registry PR 검사가 적용된다. 워크플로 밖의 수동 INF 쓰기도 겹치지 않게 조정한다.
5. 결과의 실제 branch/head/PR을 읽기 확인한다. 등록부는 신규 PENDING 1개, activated_at=null, 기존 항목 보존이어야 한다. main은 그대로여야 한다. 신규 branch·단일 부모·draft PR·두 필수 CI의 실제 head/실행/통과를 확인한다. job 생성만으로 CI PASS를 추정하지 않는다.
6. PENDING 등록 PR → INF 수용 검증 → PM 전환 확인 → Owner 활성화 승인 및 main 병합 순서로 진행한다. 실제 효력 시각을 Owner 기록에서 확인해 INF가 기입한다. 후보 지정/검사 실행/PR 생성/병합 시각으로 대체하지 않는다.
7. 승인된 별도 시험 환경 또는 실제 승인 후보에 대해 아래 중단 사례를 확인한다. 운영 main에 일부러 잘못된 ID나 권한을 넣는 시험은 하지 않는다. 각 case의 Actions run/branch/head/PR·전후 main과 정본 blob을 증거로 보관한다.

기존 prepare 명령:

```powershell
.venv/Scripts/python.exe tools/agent_registration_pr.py `
  --base $reviewedMainSha --task $approvedInfTask --department $departmentCode `
  --role $publicRole --scope $publicScope --predecessor $registeredPredecessor `
  --candidate-ref $candidateDecisionRef --handoff-ref $publicHandoffRef `
  --git-approval-ref $operationApprovalRef --actor $activeInfAgentId
```

위 값은 실제 승인 입력으로만 채우며 현재 문서의 변수 자체는 실행 입력이 아니다. 공개 참조 문자열이 있다는 사실로 승인 진위를 인증했다고 주장하지 않는다.

## 예상 변경·완료 증거

| 대상 | 기대 결과 |
| --- | --- |
| docs/infra/agents/registry.json | 신규 PENDING 하나, activated_at/retired_at=null, predecessor·generation·후보 근거. 기존 항목 그대로 |
| docs/infra/tasks/<승인 INF-ID>_AGENT_REGISTRATION.md | 후보·기준 SHA·후속 검수 순서·NOT_RUN 기록 |
| codex/<승인 INF-ID>-agent-registration | 새 ref만 생성, 기존 branch update/force/delete 없음 |
| commit / PR | main을 부모 1개로 하는 commit·INF 메시지/Trailer, base=main draft PR |
| CI | 실제 제출 head의 policy·department-policy를 조회. REPORT_ONLY 진단과 CI 성공을 별도 기록 |
| 금지되는 부수 효과 | ACTIVE 자동 확정·자동 main 병합·추정 활성화 시각·ENFORCE/보호 설정 변경 없음 |

## 중단·부분 실패와 복구

| 사례 | 중단 및 확인할 것 | 수동 복구 |
| --- | --- | --- |
| 오래된 local/remote main | PROPOSAL_STALE_BASE, remote_base/base_recheck | 최신 main·정본 blob 재조회 후 입력/diff 재검수 |
| 진행 중 registry PR | REGISTRATION_PR_IN_PROGRESS, open_registration_scan | INF가 기존 PR 완료/중복 여부를 판단. 자동 종료/번호 재사용 안 함 |
| 기존 번호/branch 충돌 | 구조/sequence 진단 또는 API_HTTP_409/422 | 기존 branch/PR의 주체·head를 조회. 새 base에서 재산정, 공유 이력 덮기 금지 |
| 토큰 누락·HTTP 오류 | WRITER_TOKEN_MISSING, API_HTTP_401/403/429 등 | Owner가 토큰/권한/제한 상태를 확인. HTTP 코드만으로 세부 원인을 단정하지 않음 |
| tree/commit 단계 실패 | detached objects가 존재할 수 있으나 live ref 생성은 아직 시도하지 않았을 수 있음 | stage·시도 플래그 확인, 객체 존재를 PR 생성 성공으로 해석하지 않음 |
| branch 생성 후 main 진전 | BASE_CHANGED_BRANCH_RETAINED | 예상 branch와 실제 ref/head를 읽어 비교. 자동 삭제/강제 갱신 없이 재제출 판단 |
| PR 요청/응답 실패 | pr_creation_attempted=true여도 실제 PR이 만들어졌을 수 있음 | head branch로 열린 PR 조회 후 중복 생성 없이 복구. refs/PR 자동 삭제 없음 |

복구 문맥은 code/stage, branch, proposed_head_sha, branch_creation_attempted/pr_creation_attempted로 한정한다. 제안 SHA·시도 여부는 실제 원격 존재/성공 확인이 아니다. 성공 receipt가 없거나 API 연결이 끊겼으면 INF/Owner가 원격 상태를 읽기 확인한다.

위 중단은 fake API·임시 Git 테스트로 검증했다. 실제 GitHub 토큰 오류/branch 충돌/partial failure 실증은 모두 NOT_RUN이다. 신규 DEV-017 코드가 main에 승인 반영되기 전에는 원격 workflow가 보완 진단/복구 필드를 출력한다고 가정하지 않는다.

## 현재 운영 검수 요청

INF: 공개 입력/예상 diff/계보·수용 검수 방법·복구 표 확인. PM: 후보의 인계 범위와 전환 담당 확인. Owner: 실제 후보 및 해당 원격 Git 실행 승인·전용 토큰 준비 확인. 이 문서 검토나 과거 PR 병합은 실행 승인·활성화·ENFORCE 승인으로 자동 전환되지 않는다.
