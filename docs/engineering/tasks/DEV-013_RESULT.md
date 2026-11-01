# DEV-013 — 구현 계획·독립 검증기 착수 검수 보고

- Convention Team / LAPTOP / 2026-11-01 / REVIEW, 공식 승인·DONE 아님.
- 입력: INF-002 구현 착수 요청 v1.0(SPEC_PROPOSED) 및 Owner가 전달한 INF 정책 회신(INF_POLICY_PROPOSAL / OWNER_APPROVAL_REQUIRED).
- 요청서 SHA256: `BD129873DC725A191AA31B4C19FA54A4FAACE5BCBA17FD91B15C7AB86C114563`. 원문을 공개 저장소에 복사하지 않음.
- 착수 worktree base: `5c91d56c78c2de5bd94bea7ee66b5c86181f4cb8`. 최신 조사 main: `88496d0c3bcef8d59e76c9977ee6ff07d01339fe`.
- 작업: [티켓](DEV-013_AGENT_PROVENANCE_FOUNDATION.md), `codex/DEV-013-agent-provenance-foundation`, 최초 LOCAL_ONLY → 후속 Owner 승인으로 Git 제출 진행. 실제 head SHA·PR·최종 CI는 PR 본문과 채팅에 기록.

## 완료한 착수 범위와 변경 파일

| 경로 | 이번 결과 |
| --- | --- |
| docs/engineering/provenance/DEV-013_IMPLEMENTATION_PLAN.md | 6항 회신·R&R·기존 CI 차이·모델/이력/squash·Phase A~E·AC-ID-01~12 매핑 |
| docs/engineering/provenance/RFC-DEV-013-01_POLICY_DECISIONS.md | INF 회신 반영, 10개 결정 질문·담당·대안·영향·승인 PENDING |
| docs/engineering/provenance/README.md | 로컬 시제품 사용·명시적 REPORT_ONLY·운영 미연결 범위 |
| tools/agent_provenance.py | base registry·부서 정책·Commit/PR 선언·커밋별 누적 Manifest와 실제 Git old/new Blob 대조하는 독립 draft 시제품 |
| tests/tooling/test_agent_provenance.py | 신규 synthetic fixture 12개 테스트, 5개 부서 정상 및 누락/부정/자기등록/바이너리/rename/중간 snapshot/JSON·로그 검증 |
| docs/engineering/tasks/DEV-013_AGENT_PROVENANCE_FOUNDATION.md | Owner 요청·범위·worktree·권한 경계·수용 기준 |
| docs/engineering/tasks/DEV-013_RESULT.md | 본 보고 |

실제 등록 ID를 발급하거나 docs/infra 파일을 수정하지 않았다. AGENTS/기존 검사기·CI·훅·PR 양식·공통 작업 현황표·게임 소스·Godot 설정은 변경하지 않았다. 본 시제품을 운영용 전체 validator로 연결하지 않는다.

시제품은 4자리 ID·core registry·canonical Trailer·파일 coverage/old/new SHA·명시적 rename·각 커밋 snapshot을 시험했다. registry record 불변성/이력, timestamps, created_by/modified_by 승계, 역사 기여자·legacy/retired 예외, 승인 출처의 의미, squash 보존, 생성기·로컬/원격 adapter는 후속 단계다. AC 전체 완료로 보고하지 않는다.

## worktree 간섭 확인

- 최초 root: clean main `604751d`, 초기 origin/main `5c91d56`보다 뒤처진 상태. 자동 pull/switch하지 않았다.
- DEV-011/012의 별도 worktree와 기존 DEV-008/009 worktree 확인. DEV-011/012는 확인 시 clean이며 작업 중인 B의 소유로 간주했다. 새 DEV-013은 공통 tools/tests 및 신규 전용 문서만 다룬다.
- 독립 `.venv`를 준비했으며 install_hooks.py나 Git config를 수정하지 않았다. fetch에 의한 remote-tracking refs 갱신 외 다른 브랜치/파일 변경 없음.
- 중간에 B의 remote head 진전·recovery 브랜치 전환·root main 동기화를 관찰했다. 이 작업이 수행한 switch/pull이 아니며 B의 변경을 되돌리거나 해당 worktree에 쓰지 않았다.
- worktree별 index는 분리되지만 object DB·refs/config 일부는 공유된다. 공통 파일을 B가 향후 수정하면 통합 충돌 가능성은 남는다. fetch 이후 각 담당자의 preflight 재확인과 최종 제출 시 최신 main 기준 재검증 필요.
- 현재 DEV-013 base와 최신 main의 AGENTS/engineering 규정·tools/CI/INF 관련 차이는 없다. 최신 main을 검토 기준으로 추가했으나 기존 작업 이력을 임의로 이동하지 않았다.

## 검증 명령과 실제 증거

전용 worktree에서 실행, TMP/TEMP는 쓰기 허용된 세션 시각화 경로에 한정. 모든 시험 ID/승인 참조는 임시 Git 저장소의 synthetic fixture다.

- `git status --short --branch`, `git worktree list`, root/DEV-011/DEV-012 read-only status·head diff: PASS, 위 간섭 조건 확인.
- `.venv/Scripts/python.exe -m pip install -r tools/requirements-dev.txt`: PASS, 자체 venv에 고정 의존성 설치.
- `.venv/Scripts/python.exe tools/policy.py doctor`: PASS, 기존 hooksPath=.githooks와 도구를 읽기 확인. 공유 설치/설정 변경 없음.
- `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -p test_agent_provenance.py -v`: PASS, 12 tests(초기 95.628s). INF 회신 후 ID 정규식을 정확히 4자리로 수정하고 전체 회귀에서 다시 검증.
- `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v`: PASS, 49 tests / 110.646s. 신규 12개 + 기존 37개. 기존 실제 Git shell 훅 시험은 허용된 실행 환경에서 격리 저장소로 수행, 현재 프로젝트 commit/merge를 하지 않음.
- `tools/policy.py check`: PASS, 최종 결과는 문서 추가 후 재확인. 기존 GDScript 4개 formatter/linter 정상. 이 코드를 수정하지 않았다.
- 현재 origin/main 코드로 DEV-013 경로·작업 브랜치·티켓·후보 메시지 형식, UTF-8/LF/개행·문서 상대 링크 대조: PASS.
- `git diff --check`: PASS. 변경 목록은 신규 7개 파일에 한정.
- live registry 확인: `git cat-file -e origin/main:docs/infra/agents/registry.json`은 path 없음 반환. 예상된 미구성 상태이며 임의로 생성하지 않음.
- GitHub main branch API: `88496d0...`, protected=true, 필수 policy/department-policy, Actions App 15368 바인딩 유지. 보호/필수 체크 변경 없음. 상세 보호 전체 설정 재실측은 NOT_RUN.
- 실제 등록부 기반 운영 검증 / 신규 원격 CI·PR / 강제 전환·merge 차단 / squash 시범 / 성능·최대 한도 부하 시험: NOT_RUN, 실제 ID·Owner 정책 승인과 후속 단계 필요.
- 자동 게임 테스트 / Godot 프로젝트 로드 / 게임 플레이 / Windows 빌드·성능·사용성·VP: 각각 NOT_RUN. 게임 소스/설정 변경 없음.

## 미해결·의사결정·다음 단계

1. INF 회신의 ID 규격·경로·비소급/예외·은퇴·단계 적용 권고를 수용 가능한 후보로 반영했다. Owner의 정식 채택·실제 ID 활성화·적용 SHA는 아직 없다.
2. INF는 실제 등록부/세대·직무·활성 상태를 Owner와 확정하고 자기 경로/티켓/승인 PR로 제출해야 한다. Convention이 대신 등록하지 않는다.
3. RFC Q01~Q10에서 production schema/이력·Trailer/Manifest·historical/legacy·squash/감사 보존·전환/한도를 확정한 뒤 생산 validator와 별도 base-only 시범 CI를 구현한다.
4. 신규 출처 검사로 기존 Stage 3-2 PR을 차단하지 않는다. 현재 시제품은 독립 REPORT_ONLY이며 진단 시에도 exit0, 출력 result/diagnostics·identity_authenticated=false를 읽어야 한다. 코드0을 ENFORCE PASS로 해석하지 않는다.
5. commit/push/PR·main 병합은 이번 요청의 개별 승인 절차를 유지한다. 다른 채팅에 메시지를 보내지 않았으며 INF 회신에 대한 Convention 답변은 계획/RFC와 현재 채팅으로 제출한다.
6. 게임 명세 변경 필요 없음. 공통 정책 도입·신규 필수 CI·운영 예외는 Owner 승인 대상이다. 동일 계정의 실신원 인증은 불가하며 등록된 선언의 일관성 수준만 제공한다.

## 후속 승인된 PR 제출

- Owner가 현재 채팅에서 DEV-013 계획·RFC·독립 검증기 시제품의 commit·push·PR 생성을 명시 요청했다. 원문·대상·유효 범위는 티켓의 후속 Git 제출 승인에 기록.
- 제출 기준 main: `f5d2878e26b9c1c061998c4ff7161f850682f568`. DEV-011/W02 및 DEV-012/W03 통합 후 상태. AGENTS/관련 개발 규정·검사기·CI/INF는 착수 기준과 차이 없음 확인.
- 미공유 DEV-013 브랜치에 자체 커밋이 없는 상태에서 rebase로 최신 main 기준을 반영했다. 미추적 신규 파일 7개 보존, 다른 worktree의 브랜치·인덱스·소스 변경 없음. 기존 조사 SHA·검증 이력은 위에 보존.
- 최신 기반의 정책·도구 테스트와 실제 커밋 훅·preflight·push 및 원격 CI 결과는 제출 시 재확인해 PR 본문에 기록한다. 새 provenance CI 활성화나 실제 ID 등록은 수행하지 않는다.
- 최신 기반 재검증: doctor PASS, policy check PASS(files=204/GDScript=15), 도구 unittest 49 tests PASS(149.779s), staged diff/7개 경로·UTF-8/LF/링크 검사 PASS. 통합된 게임 소스는 검사 대상으로 읽었으며 수정하지 않았다.
- 제출 전 main branch API: 위 기준 SHA 동일, protected=true, 필수 policy/department-policy와 Actions App 15368 바인딩 유지 확인.
