# INF-004 — Track B 독립 Agent-ID 등록

- 담당: INF / 제출 역할 선언 `AGT-INF-0001` / 2026-11-08
- 상태: OWNER_APPROVED_FOR_SUBMISSION / REVIEW / MAIN_MERGE_PENDING / NOT_DONE
- 저장소: `wisberry2022/MetroManager`
- 브랜치: `codex/INF-004-track-b-agent-registration`
- 검토 기준 main: `96139dfb1fd26f449e84e7f08986b0ab17e06787`
- 기준 registry blob: `30d086e001dfc36c60262c2824213a7c6c6b94b3`
- 정본: [registry.json](../agents/registry.json) / 결과: [INF-004_RESULT.md](INF-004_RESULT.md)

## 1. 목적과 승인 근거

기존 Track B Visual Design / Art Director 세션을 `AGT-DSG-0003`으로 처음 정식 등록하는 변경을 제출한다. Track B는 DSG-006·DSG-007·DSG-008을 계속 담당하며 Track A의 `AGT-DSG-0002` 후임이 아니다. [INF-003 예약 기록](INF-003_TRACK_A_DESIGNER_SUCCESSION.md) 및 [PR #89](https://github.com/wisberry2022/MetroManager/pull/89)의 배정 예약과 이번 실제 활성화·Git 실행 승인을 구분한다.

승인 원본 위치는 Owner가 보관하는 INF 승인 대화와 2026-11-08의 현재 INF-004 실행 요청이다. 공개 원문 URL은 제공되지 않았다. 아래는 승인된 역할·결정·범위의 최소 공개 요약이다. 내부 대화 URL·세션 ID·대화 전문·개별 진단 정보는 게시하지 않는다. 공개 참조나 동일 Git 계정 사용은 실제 신원 또는 승인 진위의 기술적 인증이 아니다.

<a id="owner-continuity"></a>
### Owner 담당 연속성 확인

- Owner는 DSG-006·007·008 업무를 기존 독립 Track B 세션이 계속 담당한다고 확인했다.
- Owner는 이번 담당 확인에 한해 별도 HQ 확인을 Owner 승인으로 갈음했다. `OWNER_CONFIRMED / HQ_CONFIRMATION_WAIVED`이며, 실제로 받지 않은 HQ `PM_SWITCH_CONFIRMED` 회신을 만들어 기록하지 않는다.
- INF-003에서 별도 승인된 `AGT-DSG-0003` 예약을 사용한다. ID 번호는 세대 번호가 아니다.
- 최초 등록이므로 `generation=1`, `predecessor_agent_id=null`, `handoff_ref=null`이다. Track A 후임 인수인계나 새 T1~T10 수용시험을 요구하는 세대교체 사건이 아니다.

<a id="owner-activation"></a>
### Owner ACTIVE 등록 결정

| 필드 | 승인된 값 |
| --- | --- |
| agent_id / department | `AGT-DSG-0003` / `DSG` |
| status / generation | `ACTIVE` / `1` |
| predecessor_agent_id / handoff_ref | `null` / `null` |
| session_kind / 공개 범위 | `CHATGPT` / 독립 Track B Visual Design·Art Director |
| effective_at → activated_at | `2026-11-08T16:25:00+09:00` |
| retired_at / record_version | `null` / `1` |

효력 시각은 Owner가 지정한 2026-11-08 16:25 KST를 그대로 사용한다. 과거 DSG 산출물의 작성 시점, Track A의 15:49:28, Commit·PR·CI·병합 시각으로 대체하지 않는다. `role_observed_on=2026-11-08`은 공개 역할 확인일이며 최초 활동 시각의 추정이 아니다. 과거 작업을 당시 이미 등록된 Agent-ID의 작업으로 소급 재작성하지 않는다.

<a id="git-approval"></a>
### 현재 INF-004 Git 실행 승인

| 항목 | 승인 범위 |
| --- | --- |
| 승인자·기록일 | Owner / 2026-11-08 / 현재 INF-004 실행 요청에서 재확인 |
| 저장소·작업 | `wisberry2022/MetroManager` / INF-004 |
| 브랜치 | `codex/INF-004-track-b-agent-registration` |
| 변경 경로 | `docs/infra/agents/registry.json`, `docs/infra/tasks/INF-004_*.md`만 |
| 허용 동작 | 위 파일 작성·검증·Commit·해당 브랜치 일반 Push·base=main PR 생성 |
| 기간·종료 | 이번 INF-004 제출과 동일 범위 검증 보완까지; Owner 철회 시 남은 실행 중지 |
| 제외 | main 직접 수정·병합·자동병합·릴리스, force push·검사 우회, 정책·CI·도구·디자인·타 부서 산출물 변경 |

이번 승인은 등록 제출 권한이다. Track B의 신규 디자인 제작·후속 티켓·포괄 Commit/Push/PR 권한은 별도 승인 범위를 따른다. main 병합은 별도 Owner 승인 대상으로 유지한다.

## 2. 공개 역할 근거와 INF 검토

<a id="inf-review"></a>
### 최신 정본·중복·독립성 검토

이전 main `c58c082509c7d7aa3f031c4b0726cf379823ccde` 이후 [DSG-008 PR #90](https://github.com/wisberry2022/MetroManager/pull/90)이 반영된 위 최신 main을 fetch하고 조사했다. INF-003 예약 기록과 registry는 보존되어 있다. 착수 시 GitHub 열린 PR 목록은 0개이며 진행 중 registry PR도 없었다. 해당 작업 브랜치는 존재하지 않아 분리 worktree에 새로 만들었다. 제출 직전 원격 main·브랜치·열린 PR을 다시 대조한다.

기준 등록부의 DSG 최대 번호는 0002이며 0003 행은 없다. `DESIGN-TRACK-B-INDEPENDENT-CURRENT`는 기존 ACTIVE scope와 중복되지 않는다. Owner의 독립 역할·연속성 확인, 공개 산출물의 담당 표기와 INF-003의 예약을 대조하여 신규 1세대 등록으로 수용한다. 이는 내부 세션 식별자나 계정 인증을 검증한 결과가 아니다.

| 공개 근거 | 확인 범위 |
| --- | --- |
| [DSG-006 비주얼 탐색](../../design/tasks/DSG-006_VISUAL_CONCEPT_EXPLORATION.md), [결과](../../design/tasks/DSG-006_RESULT.md) | 독립 Track B 역할, Owner의 철도 모형 디오라마 MVP 방향 선택·조건 |
| [DSG-007 MVP 디자인 시스템](../../design/tasks/DSG-007_MVP_DESIGN_SYSTEM.md), [결과](../../design/tasks/DSG-007_RESULT.md) | Track B 후속 시스템·토큰 작업과 개별 승인 기록 |
| [DSG-008 S01 설계](../../design/tasks/DSG-008_S01_SCREEN_DESIGN.md), [결과](../../design/tasks/DSG-008_RESULT.md) | Track B S01 1단계 정보 구조·잠정 배치, 미해결 F-08·최종 규격 경계 |
| [PM-014 Stage 2 계획](../../hq/PM-014_STAGE2_VS01_EXECUTION_PLAN.md) | Track A 기능 인수와 Track B/S2-D01의 독립 범위. 이번 HQ 확인의 대체 근거는 위 Owner 결정 |

기존 디자인 문서의 당시 미등록 표기·저자·승인·QA 결과는 역사 기록으로 보존한다. 등록은 DSG-006 시각 원본 공용 보관, F-08 기술 협의, 디자인 산출물 수용 또는 S2-D01/Stage 완료를 해결하지 않는다.

## 3. 변경 불변조건과 검사 한계

- agents에 신규 0003 한 행만 추가한다. 기존 9개 행 전체와 순서, 8개 legacy activated_at=null, Track A의 활성·은퇴 시각, 기획 전임 retired_at=null을 보존한다.
- root 메타데이터 전체를 유지한다. 과거 `OWNER_APPROVED_PENDING_MAIN_MERGE`, 최초 source_main_sha·승인 참조 정리는 별도 후속이며 이번 최신 기준 SHA는 이 티켓에 기록한다.
- 승인 경로 밖 Manifest, event schema, 정책·CI 예외 또는 ENFORCE 변경을 추가하지 않는다.
- [DEV-017 등록 계획](../../engineering/provenance/DEV-017_REGISTRATION_RUN_PLAN.md)의 자동 경로는 PENDING/null 제안이다. 이번에는 Owner가 실제 ACTIVE·효력 시각·수동 Git 제출을 이미 승인했으므로 자동 제안 workflow를 기동하지 않는다.
- 기존 구조 검사와 승인 값·보존 조건 대조를 실행한다. 일반 delta 비교의 `REGISTRY_NEW_PENDING_ONLY`는 현재 계약상 예상되는 검토 진단이며 검사 통과로 바꾸지 않는다. [RFC-DEV-017-01](../../engineering/provenance/RFC-DEV-017-01_REGISTRY_CONTRACT.md)은 계속 OPEN인 별도 계약 과제다.
- 제출 역할은 trusted base에서 ACTIVE인 `AGT-INF-0001`이다. 신규 `AGT-DSG-0003`을 이 PR의 작성 주체로 선언하거나 자기 인증하지 않는다. REPORT_ONLY의 `identity_authenticated=false`, `approval_authenticated=false`, `enforcement_enabled=false`를 유지한다.

수용 기준은 승인된 3개 파일의 최소 diff, 구조·보존·정책 검사, 단일 부모 Commit·일반 Push·단일 PR 및 실제 head의 policy·department-policy·출처 진단 보고다. CI 성공과 진단 의미를 구분한다. main 병합·공식 DONE·디자인 기능 인수는 이번 제출의 완료 조건이 아니다.
