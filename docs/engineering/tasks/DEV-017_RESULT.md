# DEV-017 — 출처 보고·후임 등록 운영 준비 결과

- Convention Team / `AGT-DEV-0002` / 2026-11-08 / REVIEW. 공식 승인·DONE 아님.
- 요청 main = 착수 fetch 최신 main = `fba3fd575c83e1eae234dc77aa9207898e0849b3`. 기준 변경 없음.
- branch/worktree: `codex/DEV-017-provenance-operations`, `.local/worktrees/DEV-017-provenance-operations`.
- 최초 검토 시 수정 commit은 없었다. 후속 Owner 승인으로 DEV-017을 제출하며 정확한 제출 commit SHA·PR·CI 결과는 PR 본문과 채팅에 기록한다. 기존 DEV-016 제출 승인을 재사용하지 않았다. 검토 코드 식별은 [소스 SHA-256](../provenance/DEV-017_SOURCE_HASHES.json), 실제 사건의 불변 base/head·checker blob은 [재현 JSON](../provenance/DEV-017_ACTIONS_REPLAY.json)을 참조한다.
- [작업 범위](DEV-017_PROVENANCE_OPERATIONS.md) / [INF 항목별 회신·실제 Actions 링크](../provenance/DEV-017_OPERATIONS_REVIEW.md) / [실행 계획](../provenance/DEV-017_REGISTRATION_RUN_PLAN.md) / [계약 RFC](../provenance/RFC-DEV-017-01_REGISTRY_CONTRACT.md).

## 변경 파일

| 파일 | 변경 |
| --- | --- |
| tools/agent_provenance.py | audit_detailed·단계/commit/Manifest 진단, Manifest/registry 부재와 Git 읽기 실패 구분, 정상 CRLF 운송 개행 처리, 기존 audit code-list 호환 |
| tools/agent_provenance_ci.py | 단계별 진단 전달·오류 위치, PR 본문/제목 SHA-256. REPORT_ONLY/false 인증·강제 상태 유지 |
| tools/agent_registry.py | 실제 registry 부재를 REGISTRY_NOT_CONFIGURED로 분리. INF 데이터/전환 허용 규칙 변경 없음 |
| tools/agent_registration_pr.py | HTTP 상태별 안전한 코드, 부분 실패 단계·예상 branch/head·쓰기 시도 문맥. 실제 성공/생성 사실로 오인하지 않음 |
| tests/tooling/test_provenance_operations.py | 신규 정상/부정·원문 비노출·실제 승인 등록부 임시 검증 8개 |
| tests/tooling/test_agent_registration_pr.py | HTTP 상태/부분 실패 문맥 검증 보강, 기존 자동 생성 계약 유지 |
| docs/engineering/provenance/DEV-017_ACTIONS_REPLAY.json | 4건 실제 run/job/base/head·원래 코드·현재 입력 재현·해시·확보 한계 |
| docs/engineering/provenance/DEV-017_SOURCE_HASHES.json | 최초 로컬 검토 snapshot의 코드/테스트 해시, 변경하지 않은 workflow 식별 |
| docs/engineering/tasks/DEV-017_PROVENANCE.json | 이번 실제 변경 14개 파일의 정확한 Git blob·승인 근거를 기록한 제출용 누적 Manifest. 자기 Manifest만 해시 면제 |
| docs/engineering/provenance/DEV-017_OPERATIONS_REVIEW.md | INF 회신, 원인 구분·상태·증거·한계 |
| docs/engineering/provenance/DEV-017_REGISTRATION_RUN_PLAN.md | 무쓰기 실행 계획·승인 입력·예상 두 파일·원격 검증/복구 표 |
| docs/engineering/provenance/RFC-DEV-017-01_REGISTRY_CONTRACT.md | root-only 갱신·전환/event·승인 정본·ENFORCE 전제 제안 (OPEN) |
| docs/engineering/provenance/README.md | 후속 회신/계획/RFC 진입점 |
| docs/engineering/tasks/DEV-017_PROVENANCE_OPERATIONS.md | 현재 Owner 요청 근거·범위·간섭 방지·수용 기준 |
| docs/engineering/tasks/DEV-017_RESULT.md | 본 보고 |

## 검증 명령·결과

전용 `.venv`, 고정 requirements 사용. TMP/TEMP는 이 worktree의 `.local/validation-tmp`. Git 쓰기가 필요한 fixture 검증은 승인된 도구 환경의 **임시 저장소**에서만 실행한다. 검증 과정에서는 실제 후보 지정/등록·운영 refs·원격 쓰기를 하지 않았다. 후속 승인된 개발 PR 제출은 별도 기록한다.

| 구분 | 명령/증거 | 결과 |
| --- | --- | --- |
| 환경 | .venv/Scripts/python.exe tools/policy.py doctor | PASS, 공유 hooks/config 설치·변경 없음. 원격 보호 검증을 뜻하지 않음 |
| 실제 4건 조사 | GitHub run/job logs + PR API snapshot, git show/rev-list/ls-tree, base 소스 audit 재생 | 네 원래 코드 재현. 후보는 두 건 MANIFEST_NOT_FOUND/commit_manifest, 두 건 TRAILER_BLOCK/pr_declaration |
| 진단/실제 승인 등록부 로컬 시험 | unittest discover -s tests/tooling -p test_provenance_operations.py -v | 8 tests PASS / 26.301s |
| 자동 등록 중단/복구 회귀 | unittest discover -s tests/tooling -p test_agent_registration_pr.py -v | 11 tests PASS / 26.298s. fake API, 실제 네트워크 쓰기 없음 |
| 최종 토큰 무연결/복구 회귀 | unittest discover -s tests/tooling -p test_agent_registration_pr.py -v | 11 tests PASS / 27.580s. 토큰 누락 시 opener 자체 미생성 검증 포함 |
| 전체 tooling 회귀 | unittest discover -s tests/tooling -v | 89 tests PASS / 294.168s (최종 토큰 무연결 assertion 보강 전 전체본) |
| 정책/formatter/lint | .venv/Scripts/python.exe tools/policy.py check | PASS, 385 files/GDScript=22, formatter 22 unchanged/lint success |
| 텍스트·링크·경계 | base path_check/ticket_check, UTF-8/no BOM/LF/상대 링크, git diff --check | PASS, 최초 검토 14개 파일 (제출 Manifest 포함 15개), INF/game/workflow/훅 불변 |
| 실제 등록 workflow 운영 | 읽기 Actions 조회: workflow_dispatch total_count=0, 열린 PR 0건 | 준비만 완료. 실행/성공 NOT_RUN |
| 정상·부정 원격 PR 시범/신규 CI 배포 | 신규 후보·Git 실행 승인·토큰 준비·개발 변경 main 반영 필요 | NOT_RUN |
| Godot 프로젝트 로드 | 게임 파일 변경 없음 | NOT_RUN |
| 게임 플레이 | 게임 파일 변경 없음 | NOT_RUN |
| 빌드 | 게임 파일 변경 없음 | NOT_RUN |

초기 임시 저장소의 alternates 파일을 Windows 기본 CRLF로 써 real-base read-tree가 실패한 fixture 오류는 LF로 정정해 위 8개에서 재검증했다. 운영 파일/검사기를 우회한 수정이 아니다. 원격 정상 선언 일관성 검증을 로컬 정상 사례로 대체해 완료 표시하지 않는다.

## 원인·한계

PR #67/#69의 불변 head에는 canonical Manifest가 없고, 기존 부서 gate와 현재 PR/commit Trailer는 통과한다. Manifest 읽기 실패를 기존 정책과 같은 코드로 묶은 진단 분류 결함을 고쳤다. PR #68의 현재 PR 선언 footer 누락을 재현했다. 과거 event 원문 전체는 없으므로 당시 모든 입력을 완전히 복원했다고 주장하지 않으며, 실행의 base/head/log와 현재 입력 재현을 분리한다.

job success/출처 DECLARATION_CONSISTENT/실제 신원·승인 인증은 다른 판정이다. 프로그램은 REPORT_ONLY·exit0이며 false 인증/강제 상태를 유지한다. 정상/부정 진단의 코드·단계가 달라도 기존 policy·department-policy 검사를 해제하거나 내용 위반을 허용하지 않는다.

## 상태·승인 대기

- **구현 완료(로컬):** 진단 분류·단계/해시·부분 실패 복구 문맥. 실제 INF 등록부, 기존 두 필수 workflow·훅·보호 설정·게임/타 부서 산출물 변경 없음.
- **검증 완료(로컬/읽기):** 4건 SHA/로그·현재 입력 재생, 실제 승인 등록부의 임시 정상 선언, 부정/복구 fake API 회귀. 원격 등록 성공은 해당 없음.
- **승인 대기:** 실제 후보 지정·승인 INF 티켓/공개 입력·해당 Git 실행 승인·전용 토큰 준비 확인·INF 운영 검수/PM 전환. root·전환·event 계약과 ENFORCE 적용 SHA/범위/예외/증거 보관/필수 체크/rollback은 별도 결정.
- **미실행:** 실제 dispatch·시험 ID 운영 추가·원격 등록 PR·원격 정상/부정 시범·자동 ACTIVE/merge·ENFORCE/필수 체크/보호 설정 변경·main 병합. DEV-017 개발 commit/push/PR은 후속 Owner 승인 범위에서 제출한다.
- 게임 명세 변경 불필요. 등록부 문구 정리는 INF 소관이며 Convention은 계약 제안과 도구 검증을 담당한다.

기존 root/main과 모든 타 worktree는 읽기 조사만 했다. DEV-017 전용 브랜치·인덱스·환경에서 작업했고 공유 Git 설정을 변경하지 않았다. fetch가 원격 추적 refs를 갱신하므로 다른 담당자도 제출 직전 최신 main·preflight를 재확인해야 한다.

최종 원격 main 읽기 확인도 `fba3fd575c83e1eae234dc77aa9207898e0849b3`이며 protected=true/필수 policy·department-policy를 유지한다. 설정 쓰기나 새 필수 체크 등록은 하지 않았다.

## 후속 승인된 DEV-017 제출

- Owner 승인 원문·저장소·브랜치·허용 동작·기간·제외 범위는 티켓 후속 승인 절에 기록했다. 최신 main 재조회는 위 기준 SHA와 동일했다.
- 소스 변경 없이 문서의 승인/제출 상태를 갱신하고, 승인된 Convention ID와 실제 staged blob의 Manifest를 추가한다. 과거 사건 재현은 기존 입력 해시/한계를 그대로 보존한다.
- source hash JSON은 최초 로컬 검토 snapshot의 지문이며 자기 commit SHA를 파일 안에 요구하지 않는다. 실제 commit ID는 PR/채팅으로 연결한다.
- 제출 전 doctor/check·staged diff·fetch 후 commit preflight·일반 push 훅 및 원격 policy/department-policy를 확인한다. 이번 정상 개발 PR의 REPORT_ONLY 결과도 확인하며 실제 후임 등록 실행 성공과 구분한다.
