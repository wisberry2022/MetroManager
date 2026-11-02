# DEV-016 — INF 회신 검토·구현 결과

- Convention Team / `AGT-DEV-0002` / 2026-11-02 / REVIEW, 공식 승인·DONE 아님.
- 기준 main `682a4f10f2cfe14bed6984e87bff75c05f37d8b5`, INF-002 PR #64.
- [티켓·Owner 요청·범위](DEV-016_AGENT_REGISTRY_REPORTING.md), [INF 검토·도구 사용·RFC](../provenance/DEV-016_INF_REVIEW_AND_ROLLOUT.md).
- 전용 branch/worktree: `codex/DEV-016-agent-registry-reporting`, `.local/worktrees/DEV-016-agent-registry-reporting`.

## 검토 결론

실제 등록부 8개와 초기 승인/null 시각/독립 DEV 직무는 확인했다. 초기 등록 승인을 전체 provenance 계약·자동 등록·강제 적용 승인으로 확대하지 않았다. INF 데이터는 읽기만 하고 상태 전환/append-only 이력·writer의 실제 운영 권한·최종 Manifest/저자 승계·squash 보관 정책은 RFC에 미결로 기록했다.

## 변경 파일

| 파일 | 결과 |
| --- | --- |
| tools/agent_registration_pr.py | 기본 prepare-only/main workflow 제한, 실제 실행 시 신규 INF 브랜치·두 경로·PENDING draft PR만 자동 생성 |
| .github/workflows/agent-registration-proposal.yml | main workflow_dispatch·전역 concurrency·전용 token·입력 env 분리 후보, 실제 배포/실행 없음 |
| tests/tooling/test_agent_registration_pr.py | fake API를 통한 stale/경합/부분 실패·PR 생성 계약·자동 활성화/병합 금지 회귀 |
| docs/engineering/provenance/DEV-016_REGISTRATION_PR_AUTOMATION.md | 후속 4개 요구 대조·순서·원격 권한·실패 복구·한계 |
| tools/agent_registry.py | 실제 bootstrap을 고정한 legacy null 허용, schema/계보/시각/버전·delta 검증, read-only PENDING 제안 CLI |
| tools/agent_provenance.py | DEV-014 검증된 sync의 재귀속 방지, 일반 커밋별 당시 main 기준 누적 snapshot 검증 |
| tools/agent_provenance_ci.py | base checkout·고정 registry만 읽는 REPORT_ONLY 어댑터, 중간 registry 위반·자기 등록 진단, 원문 비노출 |
| .github/workflows/agent-provenance-report.yml | contents:read, persist-credentials=false, base code 실행·PR objects만 fetch, 신규 비필수 보고 job 후보 |
| tests/tooling/test_agent_registry_reporting.py | 실제 등록부/초기 null·계보/상태/번호·stale base/경합·자기등록·sync·어댑터 신뢰/원문 비노출 회귀 |
| docs/engineering/provenance/README.md | 현재 등록/시제품/CI 후보·시범 전환 상태 구분 |
| docs/engineering/provenance/RFC-DEV-013-01_POLICY_DECISIONS.md | 최초 미결 질문 보존, 초기 등록에 대한 부분 회신 수신 상태·후속 연결 |
| docs/engineering/provenance/DEV-016_INF_REVIEW_AND_ROLLOUT.md | INF 검토, R&R, 명령·한계·운영 순서·RFC-DEV-016-01 |
| docs/engineering/tasks/DEV-016_AGENT_REGISTRY_REPORTING.md | 착수 근거·간섭 방지·수용 기준 |
| docs/engineering/tasks/DEV-016_RESULT.md | 본 결과·증거·미해결 |

## 검증

Windows 전용 `.venv`와 고정 requirements를 사용했다. TMP/TEMP는 이 worktree의 `.local/validation-tmp`로 지정하고 Git 쓰기가 필요한 fixture 검증은 승인된 도구 환경에서 실행했다. 실제 등록부·프로젝트 refs에는 시험용 ID를 쓰지 않았다.

| 구분 | 명령·증거 | 결과 |
| --- | --- | --- |
| 환경 | .venv/Scripts/python.exe tools/policy.py doctor | PASS, 공유 hooks/config 변경 없음. 원격 보호 검증 아님 |
| 실제 등록부 | .venv/Scripts/python.exe tools/agent_registry.py check --base 682a4f10f2cfe14bed6984e87bff75c05f37d8b5 | STRUCTURALLY_CONSISTENT, agents=8, identity/approval_authenticated=false |
| 신규 초기 회귀 | unittest discover -s tests/tooling -p test_agent_registry_reporting.py -v | 10 tests PASS / 57.876s (초기본) |
| 전체 회귀 | unittest discover -s tests/tooling -v | 69 tests PASS / 348.674s (최종 Manifest 호환 보완 전 전체본) |
| 최종 어댑터 회귀 | unittest discover -s tests/tooling -p test_agent_registry_reporting.py -v | 13 tests PASS / 48.893s. Manifest 경로·원문 비노출 최종 보완 후 |
| 파일 정책 | .venv/Scripts/python.exe tools/policy.py check | 후속 보완 후 PASS, worktree files=227/GDScript=16, formatter 16 unchanged/lint success |
| 경계·문자/개행 | base의 path_check·ticket_check, UTF-8/no BOM/LF/마지막 개행, git diff --check | 후속 최종 PASS, DEV 범위 14개 파일·상대 링크 확인 |
| 실제 원격 시범 CI/자동 등록/강제 적용·차단 | 새 workflow main 반영 및 후속 개별 승인 필요 | NOT_RUN |
| Godot 프로젝트 로드 | 게임 변경 없음 | NOT_RUN |
| 게임 플레이 | 게임 변경 없음 | NOT_RUN |
| 빌드 | 게임 변경 없음 | NOT_RUN |

## Project Leader B 간섭 방지

- root/main은 `293b5f9...`였고 INF main보다 한 커밋 뒤처졌으나 pull/switch하지 않았다. fetch는 원격 추적 refs만 갱신했다.
- B의 DEV-015 worktree에는 main.gd·stage1/UI·W07 테스트 미커밋 작업이 있었다. 그 경로를 읽기 확인했으며 변경·stage·stash·reset·checkout하지 않았다.
- DEV-011/014 기존 worktree도 보존했다. 신규 DEV-016의 전용 venv·index·파일만 사용하며 install_hooks.py/공유 Git config를 수정하지 않았다.
- 기존 policy/department-policy workflow·훅·INF 등록부·게임 소스/설정과 공통 WORK_STATUS는 변경하지 않았다. 후속 통합 시 공통 tools 충돌 가능성과 fetch 이후 재검증 필요는 남는다.
- 작업 중 B의 DEV-015가 자체 제출·main `591091d...`(PR #65) 반영된 것을 관찰했다. INF base와의 차이는 B의 게임/UI·증거·티켓이며 tools/tooling tests/workflows/provenance/registry에는 차이가 없다. B 브랜치와 root/main은 자동 동기화하지 않았고 DEV-016 기준도 임의 이동하지 않았다.
- 최종 legacy Manifest 테스트에서 기존 gate가 `tasks/*.json`을 기본 허용하지 않음을 재확인했다. 운영 경로를 확장하지 않고 승인된 base 예외가 있는 경우만 통과하는 fixture로 정정해 최종 회귀에서 통과했다. 기본 Manifest는 docs/engineering/tasks 경로다.

## 미해결·승인 경계

- 후속 Owner 전달 INF 요구에 따라 PENDING PR 자동 생성기와 main workflow_dispatch/concurrency 후보를 구현했다. 실제 원격 실행·예약·자동 활성화·병합은 하지 않았다. 오프라인 제안은 예약이 아니며 자동 writer는 진행 중 등록 PR이 있으면 다음 생성을 중단한다. SHA 재확인·동일 계정의 수동 writer 조정·Owner 최종 검수가 필요하다.
- registry_state와 INF 제출 문서의 병합 대기 문구는 INF 소관 후속 정리 사항이다. 현재 도구는 실제 pinned main을 읽고 이 문자열을 ENFORCE 스위치로 사용하지 않는다.
- 새 workflow/검사기는 로컬 검수안이다. Owner 검수·main 반영 후에만 base 코드로 원격 시범을 시작할 수 있다. 기존 두 필수 job과 보호 설정은 유지한다.
- append-only 상태 전환·재활성화, 최종 Trailer/Manifest와 생성기·created/modified/historical·legacy/retired 예외, squash/감사 보관·원격 부정 시험·ENFORCE SHA/적용 대상은 남은 정책·후속 구현이다. [RFC-DEV-016-01](../provenance/DEV-016_INF_REVIEW_AND_ROLLOUT.md#rfc-dev-016-01--남은-정책운영-확인)은 OPEN.
- 게임 명세 변경 불필요. 초기 등록의 승인 기록은 INF main으로 확인했으며 새 정책을 자체 승인하지 않았다. 출처 선언 일관성과 실제 세션/Owner 신원 인증은 다르다.
- 최초 구현 요청에서는 commit/push/PR을 실행하지 않았다. 이후 Owner가 현재 채팅에서 DEV-016 PR 생성을 지시해 이번 개발 제출의 commit·일반 push·PR을 진행한다. 원문·대상·기간·제외 범위는 티켓의 후속 승인 기록에 남겼다. main 병합·INF 자동화 실제 실행·ENFORCE는 여전히 미승인이다. 기존 DEV-014 승인을 재사용하지 않는다.

## INF 후속 네 항목 반영

- 순서: PENDING 등록 PR 자동 생성 → INF 수용 검증 → PM 전환 확인 → Owner 활성화 승인 및 병합. 생성된 티켓·PR 본문·도구 출력에 동일 순서를 기록한다.
- 생성기는 PENDING/activated_at=null만 만들며 활성화 시각을 실행/커밋/PR/병합 시각으로 추정하지 않는다. INF가 실제 Owner 승인 효력 시각을 확인·기록한다.
- REPORT_ONLY 유지, ENFORCE는 별도 Owner 승인. INF 데이터 소유와 Convention 도구 소유를 유지한다.
- 추가 자동 PR 회귀: `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -p test_agent_registration_pr.py -v` — 10 tests PASS / 27.940s. 실제 API 대신 fake client로 기본 무네트워크 CLI·자동 draft PR·두 INF 경로·부모1·main 경합·진행 중 등록 PR·부분 실패·자동 ACTIVE/merge 금지·원문 비노출을 검증했다.
- 등록부/REPORT_ONLY 재회귀: `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -p test_agent_registry_reporting.py -v` — 13 tests PASS / 54.678s. 기존 초기 등록·sync·Manifest·자기 등록 거부 유지.
- 후속 policy check PASS (227 files/GDScript=16), path/ticket·UTF-8/LF/상대 링크·git diff --check PASS. 기존 필수 CI/훅·INF 등록부·게임 파일 보존 확인. 전체 회귀 69개는 앞선 초기본의 증거이며 이번 보완은 영향받는 23개를 재검증했다.
- 실제 원격 제출·시크릿 설정·workflow 실행·Owner 활성화·main 병합은 NOT_RUN이며 이번 전달 요청을 Git 실행 승인으로 확대하지 않는다.

## 최신 main 기반 개발 PR 제출

- 원격 main `591091d8916a7a6100972b8807503765bb82b9b0`의 DEV-015 UI 통합은 승인된 통합 결과로 읽었다. DEV-016의 공통 도구/등록부/보고 경로에는 겹치는 변경이 없음을 확인했다.
- 미공유 DEV-016에 자체 커밋이 없는 상태에서 `git merge --ff-only origin/main`으로 기준만 갱신했다. merge commit·기존 이력 재작성·B/root 변경 없음.
- 최종 commit/preflight·일반 push·PR의 정확 head/두 필수 CI 결과는 PR 본문과 채팅에 기록한다. INF 등록 제안 자동화의 실제 실행을 이 개발 PR 제출과 혼동하지 않는다.

### 최신 제출 기준 검증 이력

- doctor PASS, policy check PASS (249 files/GDScript=22; DEV-015 통합 소스는 읽기 검사만 수행). DEV-016 14개 경로·티켓·UTF-8/LF/문서 링크·staged diff 공백 검사 PASS.
- 전체 tooling 회귀: 80 tests / 338.451s, 기존 base-sync INF 사례의 `git rev-parse --git-path objects` 프로세스 1회 비정상 종료(exit 4294967295)로 errors=1. 실패를 전체 PASS로 표기하지 않는다.
- 동일 소스/환경에서 해당 base-sync 파일을 분리 재검증: `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -p test_verified_base_sync.py -v` — 8 tests PASS / 111.005s, INF의 CI/preflight/pre-push 사례 포함. git rev-parse 직접 조회도 정상. 오류 원인은 확정하지 못했고 재현되지 않았다. 검사/훅 변경·우회 없음.
- 신규 등록/보고·자동 PR 검사와 나머지 전체 사례는 위 실행에서 통과했다. 원격 policy의 전체 80개 실행과 기존 trusted-base department-policy 결과는 제출 PR의 정확한 head 기준으로 확인·공유한다.
- 원격 main branch API: protected=true, 필수 policy/department-policy와 Actions App 15368 바인딩 유지 확인. 상세 보호 설정 전체를 재검증한 것은 아니며 원격 설정 변경 없음.
