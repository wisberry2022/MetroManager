# INF-009 — 통상 인계 간소화와 등록부 후속 기록 규정

- 담당: INF / AGT-INF-0002 / 2026-11-14 Asia/Seoul
- 상태: OWNER_POLICY_APPROVED / OWNER_COMMIT_PUSH_PR_APPROVED / PR_REVIEW / MAIN_MERGE_PENDING
- 기준 main: 7febce1389d2bb7020178040ef17cfad0057a4a8
- 브랜치: codex/INF-009-lightweight-succession / base: main
- [검증·결과](INF-009_RESULT.md)

> §1~5는 PR #115의 최초 제출 기록이다. 해당 PR은 main 1f331a232865967a391d535ec9756be9584ecbc0에 병합됐다. 후속 등록 담당에 관한 최신 보완 지시·범위는 §6을 따른다.

## 1. 문제·제안과 Owner 결정

에이전트 수 증가에 따라 예방적 컨텍스트 교체마다 자기보고·독립 채점·T1~T10·INF 판정·HQ 확인·Owner 재승인을 반복하는 부담을 줄인다. Owner가 인계서 작성을 지시하고 후임에게 전달한 뒤, 전환 정보와 권한이 명확하면 즉시 업무를 시작하도록 변경한다.

INF는 최초 Owner 지시에 후임 임명·기존/신규 ID·세대·효력 시각·승계 업무·명시적인 유효 권한 이전을 포함하고, 후임 원본 확인·짧은 회신 후 추가 승인 없이 시작하는 방안을 제안했다. INF는 후속 등록·이력·예외 복구, HQ는 담당·의존성 갱신을 맡는다. ACHC/T1~T10은 요청된 상세 검증에만 사용하고, 미반영 기간의 ID 중복과 업무 효력/등록 시각을 구분한다.

2026-11-14 현재 INF 대화에서 Owner가 해당 방향과 아래 실행을 직접 승인했다.

> 제안한 방향으로 간소화하겠습니다. 관련 정책·인수인계 양식·등록부 전환 규정을 수정하고 원격 저장소에 PR을 생성해주세요. 해당 범위의 Commit·Push·PR을 승인하며, main 병합은 별도 승인 후 진행해주세요.

승인 원문은 Owner와 INF의 현재 대화에 있으며 공개 URL은 제공되지 않았다. 이 티켓은 필요한 운영 결정만 요약하며 비공개 대화 전체나 세션 URL을 게시하지 않는다. 문자열·동일 GitHub 계정·CI가 실제 Owner 신원을 인증하는 것은 아니다.

## 2. 실행 권한과 경계

- 저장소 wisberry2022/MetroManager, 위 INF-009 전용 브랜치, 아래 INF 파일의 작성·검증·Commit·Push/API 브랜치 게시·PR 생성·동일 범위 검수 대응까지 승인됐다.
- 유효 범위는 INF-009 제출·동일 범위 보완 종료 또는 Owner 철회까지다. 미래 인사 전환·모든 후속 등록 작업의 포괄 Git 위임이 아니다.
- main 직접 쓰기·병합·자동 병합·force push·릴리스·배포·Issue 변경은 수행하지 않는다.
- 게임 코드·타 부서 산출물·AGENTS.md·CI·검사기·path_exceptions는 변경하지 않는다. Convention 구현을 INF가 대행하지 않는다.
- 신규 ID 발급·개별 ACTIVE/RETIRED 변경은 이번 작업에 없다. 기존 13개 agent 행은 전부 보존한다.

## 3. 포함 파일

| 파일 (docs/infra/ 기준) | 변경 |
|---|---|
| README.md | 새 운영 흐름·책임·진입 링크 |
| AGENT_HEALTH_POLICY.md | 최초 지시·후임 확인·업무 개시, 상세 진단 선택화 |
| AGENT_HANDOFF_TEMPLATE.md | 최소 전환·업무·권한·짧은 인수 확인 양식 |
| AGENT_REGISTRY_TEMPLATE.md | 업무상 효력·미반영/반영 완료·감사 기록 분리 |
| PLANNING_SUCCESSION_RUNBOOK.md | 기존 필수 수용·재승인 단계 제거 |
| AGENT_HEALTH_REPORT_TEMPLATE.md | 요청된 진단용 선택 양식임을 명시 |
| AGENT_ASSESSMENT_TEMPLATE.md | 요청된 독립 평가용이며 통상 인계 승인 게이트 아님을 명시 |
| agents/REGISTRY_TRANSITION_RULES.md | 신규 ID 예약·권한·시각·후속 등록·도구 경계 정본 |
| agents/REGISTRATION_AUTOMATION_REVIEW.md | 과거 제안과 새 수동 인계 규정의 적용 관계 |
| agents/registry.json | activation_time_policy 문자열만 새 전환 규정으로 교체 |
| tasks/INF-009_LIGHTWEIGHT_SUCCESSION.md | Owner 결정·범위·적용 계획 |
| tasks/INF-009_RESULT.md | 실제 검증·진단·미실행·후속 의무 |

activation_time_policy는 필수 INF acceptance/PM confirmation을 명시한 현행 전환 규정이므로 이번 Owner 요청에 직접 포함된다. 이는 R-INF-01의 오래된 registry_state·registry_version·source_main_sha 정리와 다른 변경이다. 그 밖의 root 값·schema_version·모든 agent 행·레거시 null·과거 승인 이력은 보존한다.

## 4. 적용과 호환성

- 정책 방향은 Owner가 승인했다. 공통 원격 문서로의 적용 기준은 별도 main 병합 승인·실제 반영 후이며 PR 게시를 병합 완료로 간주하지 않는다.
- 완료된 INF-001~008의 승인·시험·실패·복구 기록을 고치거나 기존 합격을 취소하지 않는다. 기존 미결 인사 사건을 자동 전환하지 않는다. 새 전환마다 해당 Owner 지시와 효력을 사용한다.
- 통상 수동 인계의 과거 필수 단계는 이 정책으로 대체한다. DEV-017/RFC-DEV-017-01의 도구 내 과거 절차, append-only schema·재활성화·ENFORCE 등 미결 계약은 자동 해결되지 않는다.
- Owner 지시가 준비만 허용했으면 ACTIVE 전환 승인으로 확대하지 않는다. 유효한 Git 권한 이전이 명시되면 같은 범위의 재승인은 불필요하고, 명시되지 않은 동작은 실행하지 않는다.
- 새 전환과 main 등록 사이의 차이는 REGISTRY_RECORD_PENDING으로 기록한다. 후임 업무 개시를 등록 PR 병합까지 일괄 보류하지 않지만 필수 CI를 우회하지 않는다.
- 독립 시험을 생략한 사실은 NOT_RUN/NOT_ASSESSED로 보존한다. 후임 자기 확인을 독립 평가 PASS로 표시하지 않는다.

## 5. 검증·후속

문서 연결·전환 시나리오를 검토하고 실제 base 대비 변경 경로·registry 보존을 확인한다. policy.py doctor/check 및 제출 범위 검사를 수행하고 실제 PR head의 policy·department-policy를 확인한다. root 변경은 현 비교기의 REGISTRY_ROOT_REVIEW_REQUIRED 진단 대상이며, 진단을 숨기기 위해 검사기를 수정하지 않는다.

Convention 후속 검토는 미반영 ID 예약·새 승인 근거·기존 review_sequence/requires와 도구 계약의 정합성이다. 해당 기술 수정·실운영시험은 본 PR에 포함되지 않는다. DEV-017 정상/부정·stale base·API 오류·부분 생성 복구, provenance ENFORCE, 일반 append-only schema, R-INF-01 역사 메타데이터 정리 및 F-12 QA 원본·접근권한·백업 복구 의무는 유지한다.

새 인사 전환 실증·workflow_dispatch·게임 자동검사·Godot 로드·실GUI·빌드/성능은 NOT_RUN이다. 게임 명세 변경은 없으며 운영 명세만 개정한다.

## 6. Owner 직접 후속 등록 보완

- 기준 main: 1f331a232865967a391d535ec9756be9584ecbc0 / 2026-11-14 Asia/Seoul.
- 브랜치: codex/INF-009-owner-registration / base: main.
- 상태: OWNER_DIRECTION_CONFIRMED / OWNER_PR_SUBMISSION_AUTHORIZED / MAIN_MERGE_PENDING.
- [후속 결과](INF-009_OWNER_REGISTRATION_RESULT.md). 최초 PR #115의 승인·검증 기록과 INF-009_RESULT.md는 보존한다.

Owner는 현재 진행 중인 개발 에이전트 인계에서 Agent-ID·업무 전환 시각 등 후속 등록을 직접 수행하겠다고 지시했다. 이어 원격 INF-009에 필요한 수정이 있으면 수정 후 PR을 제출하도록 허용했다. 본 작업은 앞선 INF-009 Commit·Push·PR 승인과 이 후속 지시에 따른 동일 범위 보완이다. 원문은 현재 Owner–INF 대화이며 공개 URL은 제공되지 않았다.

Owner가 직접 등록하거나 지정·승인한 담당자에게 맡길 수 있음을 정책·양식·가이드·전환 규정에 맞춘다. Owner 직접 수행 시 INF의 추가 수행·승인·검수는 필수가 아니고 INF는 중복 등록하지 않으며 요청 시 지원한다. 이번 개발 인계의 담당 지정은 다른 모든 인계의 자동 담당 변경이 아니다.

포함 파일은 README.md, AGENT_HEALTH_POLICY.md, AGENT_HANDOFF_TEMPLATE.md, AGENT_REGISTRY_TEMPLATE.md, PLANNING_SUCCESSION_RUNBOOK.md, agents/REGISTRY_TRANSITION_RULES.md, 본 티켓 및 INF-009_OWNER_REGISTRATION_RESULT.md의 INF Markdown 8개다. 동일 범위 문서 작성·검증·Commit·작업 브랜치 게시·PR·검수 보완까지 수행하며 main 병합은 별도 승인 전 진행하지 않는다.

registry.json·개별 Agent-ID/세대/상태/효력 시각·과거 결과·CI/도구·타 부서 파일은 변경하지 않는다. 개발 인계의 구체 ID·효력 시각·완료 사실을 이 지시만으로 추정하거나 등록 완료로 보고하지 않는다. 기존 ID 중복 방지·시각 구분·권한·Git/필수 CI·공개정보 제한·NOT_RUN 규칙은 유지한다.
