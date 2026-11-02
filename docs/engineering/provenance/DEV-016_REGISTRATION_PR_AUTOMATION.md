# DEV-016 보완 — PENDING 등록 PR 자동 생성

- Convention Team / `AGT-DEV-0002` / 2026-11-02 / 로컬 REVIEW, 원격 배포·실행 NOT_RUN.
- 근거: 현재 채팅에서 Owner가 전달하고 반영을 요청한 INF의 네 가지 요구. 등록부 책임은 INF, 도구 구현은 Convention이다.

## 요구 대조와 확정 순서

| 전달 요구 | 반영 |
| --- | --- |
| PENDING 등록 PR 자동 생성 → INF 수용 → PM 전환 → Owner 활성화 승인 및 병합 | 기존 오프라인 제안에 PR 자동 생성기와 수동 기동 workflow 후보 추가. 순서를 데이터·생성 티켓·PR 본문에 기록 |
| 실제 승인된 후임 활성화 효력 시각 | 생성 시 activated_at=null. 실행/PR 생성/병합 시각으로 채우지 않음. INF가 Owner 승인 원문의 실제 효력 시각을 확인해 오프셋 포함 ISO 8601로 기록 |
| REPORT_ONLY→ENFORCE 별도 Owner 승인 | 기존 보고 검사·필수 두 CI 유지. 생성기는 enforcement_enabled=false. 이번 요청을 ENFORCE 승인으로 간주하지 않음 |
| INF 등록부 / Convention 도구 책임 | 실제 등록부는 로컬에서 변경하지 않음. 향후 자동 제출은 승인된 INF 티켓·ACTIVE INF Agent-ID·INF 경로 2개만 사용 |

자동 생성 결과는 PENDING 검토용 **draft PR**이다. 후보 지정과 Git 실행 승인은 별도 참조로 받으며 INF 수용·PM 확인·Owner 활성화가 완료됐다고 표시하지 않는다. 수용 기록과 PM 전환 근거를 순서대로 확보한 뒤 INF가 최종 상태/효력 시각을 준비하고 Owner가 활성화 및 main 병합을 검수한다. 생성기가 상태를 ACTIVE로 바꾸거나 병합하는 단계는 없다. 미병합 PENDING 후보 ID는 정식 발급/예약이 아니다.

새 ACTIVE/상태 전환은 기존 구조 검사에서 검토 진단으로 남을 수 있다. REPORT_ONLY에서는 이 진단 자체가 두 기존 필수 CI를 대신하거나 Owner 결정을 자동 거부하는 게이트가 아니다. 향후 ENFORCE에서는 승인된 이벤트/이력 계약을 먼저 구현해야 하며 이번에 자의적 예외로 통과시키지 않는다.

## 로컬 검토와 자동 생성 경로

`tools/agent_registration_pr.py`는 기본이 **prepare only**다. 토큰 조회·네트워크·Git 쓰기 없이 PR 계획과 두 파일 내용을 stdout으로 출력한다.

```powershell
.venv/Scripts/python.exe tools/agent_registration_pr.py `
  --base $reviewedMainSha --task $approvedInfTask --department $departmentCode `
  --role $publicRole --scope $publicScope --predecessor $registeredPredecessor `
  --candidate-ref $publicCandidateDecision --handoff-ref $publicHandoff `
  --git-approval-ref $publicGitAuthorization --actor $activeInfAgentId
```

INF/Owner가 확인한 공개 값으로 채운다. 후보 지정 참조는 최종 활성화 승인과 다르다. 공개 Git 실행 승인 참조는 해당 등록 작업의 commit/push/PR 범위여야 하며 활성화·병합 권한으로 확대하지 않는다. 문자열·Agent-ID·GitHub 실행자 이름의 존재는 실제 신원이나 Owner 승인 진위를 인증하지 않는다.

실제 자동 생성은 `.github/workflows/agent-registration-proposal.yml`을 Owner 검수 후 main에 반영하고 별도 Git 실행 승인을 확보한 뒤 **main의 workflow_dispatch**로 기동한다. 이는 수용/전환을 자동 판정하는 이벤트 감시가 아니라 명시적으로 승인된 후보에 대한 수동 기동·PR 자동 생성이다.

- workflow는 main 코드만 checkout하고 credentials를 저장하지 않는다. 사용자 입력은 env로 전달하고 셸 코드에 직접 보간하지 않는다.
- `agent-registration-single-writer` concurrency 그룹으로 실행을 직렬화한다. 실행 중인 job을 취소하지 않는다. 대기 실행의 보존·순서는 별도 보장하지 않으므로 취소된 요청은 확인 후 다시 기동한다.
- 생성기는 `--submit`과 올바른 main workflow 실행 문맥을 요구한다. 이는 오작동 방지 검사이며 같은 계정 관리자에 대한 보안 경계나 Owner 신원 인증은 아니다.
- dedicated `AGENT_REGISTRATION_TOKEN`은 Owner가 별도 준비한다. 대상 저장소의 contents:write/pull requests:write에 한정한 최소 권한을 검토하고 비밀 저장소에 보관한다. 도구는 권한·시크릿을 생성하거나 저장소 설정을 바꾸지 않는다. 기본 GITHUB_TOKEN으로 우회하지 않는다.
- 토큰/네트워크/API 오류·리다이렉트는 원문 비노출로 중단한다. 미설정·권한 부족을 성공으로 간주하지 않는다. 자동 생성 후에도 두 필수 CI가 실제 실행·통과했는지 확인한다.

## 쓰기 범위·경합·실패 처리

1. local origin/main과 확인 SHA가 일치하는지 검증하고 pinned base 등록부의 ACTIVE INF 주체만 사용한다.
2. 원격 main을 재확인하고 열린 모든 PR의 파일 목록을 페이지 단위로 검사한다. registry 변경 PR이 하나라도 진행 중이면 새 등록 PR 생성을 중단한다. 조회 한도 초과도 중단한다.
3. 사용된 최댓값+1의 ID를 계산한다. 신규 PENDING 1개만 추가하고 기존 8개 등 등록 항목은 수정하지 않는다. 정확히 registry와 `docs/infra/tasks/<INF-TASK>_AGENT_REGISTRATION.md` 두 파일만 허용한다.
4. 기존 base tree에 두 파일만 적용한 tree와 부모 1개 커밋을 만든다. 원격 main 재확인 후 **새 작업 브랜치만 생성**한다. 기존 브랜치가 있으면 실패하며 update/force/delete를 수행하지 않는다.
5. 브랜치 생성 후 main을 다시 확인하고 draft PR을 생성한다. 임의 병합·자동 활성화·보호 설정·ENFORCE 변경 API는 없다.

동일 workflow 밖에서 같은 자격증명으로 수행하는 수동 INF 쓰기까지 잠글 수는 없다. INF는 같은 writer 통로를 사용하고 수동 등록과 겹치지 않게 운영해야 한다. GitHub는 main 조회와 새 브랜치/PR 생성을 하나의 원자적 예약으로 처리하지 않으므로 최종 Owner 검수 때 base/head·중복·상태와 두 CI를 다시 확인한다. 번호 충돌 시 최신 base에서 재계산하고 공유 이력을 재작성하지 않는다.

API 실패 후 detached Git object나 작업 브랜치가 남을 수 있다. 생성기는 실패를 감추거나 기존 브랜치 삭제/force 재시도를 하지 않는다. INF/Owner가 남은 refs와 PR을 확인한 후 기존 브랜치에서 복구할지 새 티켓으로 재제출할지 결정한다. 실제 등록은 Owner main 병합 이후 trusted base로 효력이 생긴다.

## 검증·미실행

테스트는 fake API로 요청 순서·두 경로/부모1·PENDING·stale main·진행 중 등록 PR·페이지 한도·부분 실패·자동 ACTIVE/merge 금지·토큰 비노출과 workflow 설정을 검증한다. 실제 원격 commit/push/PR 생성·시크릿 설정·workflow 실행·INF 수용·PM 전환·Owner 활성화/병합·ENFORCE는 NOT_RUN이다. 구체 명령/결과는 [DEV-016 결과](../tasks/DEV-016_RESULT.md)에 기록한다.

구현 참고: [Git tree API](https://docs.github.com/en/rest/git/trees), [commit API](https://docs.github.com/en/rest/git/commits), [reference API](https://docs.github.com/en/rest/git/refs), [PR API](https://docs.github.com/en/rest/pulls/pulls), [workflow concurrency](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/control-workflow-concurrency). 2026-11-02 확인.
