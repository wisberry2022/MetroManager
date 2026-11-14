# MetroManager AI Infrastructure — 문서 진입점

- 관리 작업: INF-001, INF-009 / 문서 버전 v1.1 / 개정 2026-11-14
- 상태: OWNER_POLICY_APPROVED / PR_REVIEW / MAIN_MERGE_PENDING. [INF-009 결정·범위](tasks/INF-009_LIGHTWEIGHT_SUCCESSION.md)에 따라 통상 인계를 간소화한다. 공통 원격 기준은 별도 Owner 병합 승인·main 반영 후 적용한다.
- 소관: INF (AI Infrastructure Manager), 공식 경로 `docs/infra/`
- 최초 작성 기준 main: `0303a929b682efb8c75b20eed2994b3a36ecafae` (DEV-007 INF 정책 등록 반영)
- 참고: `AGENTS.md`, `docs/engineering/DEPARTMENT_WORKFLOW.md`, `docs/engineering/INF_ONBOARDING.md`, `docs/hq/PM-008.md`

## 책임과 경계
INF는 ChatGPT·Codex 세션의 **컨텍스트 건전성, 지식 연속성, 인계 양식·등록 이력·예외 복구**를 관리한다. 통상 교체는 Owner 최초 지시 → 인계서 전달 → 후임 원본 확인·업무 시작으로 진행하며 INF·HQ·Owner의 별도 인수 승인을 기다리지 않는다. INF는 후속 정합성을 관리하고 요청 시 상세 검증한다. PM의 Stage·우선순위·의존성 조정, 기획의 규칙, 디자인의 UI/아트, 개발의 코드·Convention의 도구 구현을 대행하지 않는다. Owner는 최초 지시에서 후임·효력 시각·권한 이전을 정하며 main 병합·릴리스는 해당 승인 범위를 유지한다.

공식 업무 근거 우선순위: Owner 승인 원문 → Git의 승인 명세(경로·버전·SHA) → 승인 티켓 → 검토 중 문서 → 대화·메모리. **최신 HEAD, PR 게시, CI 통과만으로 승인/DONE이 되지 않는다.**

## 운영 문서
| 파일 | 사용 시점 | 작성자/검증 |
|---|---|---|
| [AGENT_HEALTH_POLICY.md](AGENT_HEALTH_POLICY.md) | 진단·인계·교체 절차 | INF / Owner 최종 정책 승인 |
| [AGENT_HEALTH_REPORT_TEMPLATE.md](AGENT_HEALTH_REPORT_TEMPLATE.md) | 요청된 자기 진단에만 사용 | 현직 / 필요 시 INF 교차 확인 |
| [AGENT_ASSESSMENT_TEMPLATE.md](AGENT_ASSESSMENT_TEMPLATE.md) | 요청된 독립 평가·교체 권고 | 독립 검증자 / Owner 결정 |
| [AGENT_HANDOFF_TEMPLATE.md](AGENT_HANDOFF_TEMPLATE.md) | 통상 인계와 짧은 후임 확인 | 현직·후임 / 최초 Owner 전환 지시 |
| [AGENT_REGISTRY_TEMPLATE.md](AGENT_REGISTRY_TEMPLATE.md) | 업무 효력·후속 등록·정정 기록 | INF / Owner 결정 연결 |
| [agents/REGISTRY_TRANSITION_RULES.md](agents/REGISTRY_TRANSITION_RULES.md) | ID 예약·전환·권한·미반영 기간 규정 | INF 정합성 / Convention 도구 후속 |
| [PLANNING_SUCCESSION_RUNBOOK.md](PLANNING_SUCCESSION_RUNBOOK.md) | 기획팀 통상 인계 실행 예시 | Planning 작성·후임 확인 |
| [INF-001 티켓](tasks/INF-001_CONTEXT_GOVERNANCE.md) 및 [검증 기록](tasks/INF-001_RESULT.md) | 변경 근거·증거·검수 | INF / Owner |
| [INF-009 티켓](tasks/INF-009_LIGHTWEIGHT_SUCCESSION.md) 및 [결과](tasks/INF-009_RESULT.md) | 간소화 결정·적용 범위·검증 | INF / Owner |

## 평가 대상
Owner 제외: HQ/PM, Planning, Design, Development, Convention, INF(환경/채팅/스레드별 구분). **부서 1개와 세션 1개가 항상 같은 것은 아니다.** 다른 세션의 상태를 하나의 보고서로 전체 검증했다고 간주하지 않는다. INF 자신에 대한 독립 평가가 요청되면 Owner가 지정한 독립 검증자가 수행한다.

## 공개 정보 제한
이 저장소는 공개 저장소다. **이번 PR에 4개 에이전트의 실제 진단 점수·개별 오류·대화 전문·세션 내부 URL·개인정보·인증정보를 포함하지 않는다.** 공개 Git에는 양식, 정책, 작업 ID, 공개된 결정·PR 링크 등 최소 운영 사실만 남긴다. 상세 평가 원본은 Owner 제한 보관하고, 공개가 필요한 경우 Owner가 별도 검토한다.

## 실행 원칙
- 진단은 Owner/PM 요청 또는 승인된 점검 시점에 **명시적으로 실행**한다. 자동 상시 감시는 구축되어 있지 않다.
- 채팅 간 자동 전달이나 완전한 메모리를 기대하지 않는다. 새로운 에이전트는 공식 Git을 직접 읽고 최신 SHA를 확인한다.
- 통상 인계의 ACHC·T1~T10은 필수가 아니다. 실제 업무 전환과 등록부 main 반영을 분리하고 미반영 전환 기록까지 ID 중복 대조에 포함한다.
- 최초 지시에서 명시한 유효한 티켓별 Git 권한 이전은 재승인받지 않는다. 인계서만으로 권한이 생기거나 모든 미래 업무 권한이 승계되는 것은 아니다.
- 근거 부족 시 `NOT_VERIFIED`, 미실행은 `NOT_RUN`, 내부 컨텍스트 사용량은 신뢰 가능한 계측이 없으면 `UNAVAILABLE`로 기록한다.
- 업무별 INF 티켓·브랜치·Commit/Push/PR 위임을 확인한다. `main` 직접 쓰기·force push·검사 우회 및 타 부서 경로 변경 금지. 병합은 Owner 별도 승인 후다.
