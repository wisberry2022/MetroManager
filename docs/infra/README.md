# MetroManager AI Infrastructure — 문서 진입점

- 관리 작업: INF-001 / 문서 버전 v1.0 / 작성 2026-11-01
- 제출 상태: REVIEW — Owner의 운영 방향·Commit/Push/PR 지시에 따라 검토용 PR 작성. **main 병합·개별 문서의 정식 수용은 별도 Owner 판단**
- 소관: INF (AI Infrastructure Manager), 공식 경로 `docs/infra/`
- 최초 작성 기준 main: `0303a929b682efb8c75b20eed2994b3a36ecafae` (DEV-007 INF 정책 등록 반영)
- 참고: `AGENTS.md`, `docs/engineering/DEPARTMENT_WORKFLOW.md`, `docs/engineering/INF_ONBOARDING.md`, `docs/hq/PM-008.md`

## 책임과 경계
INF는 ChatGPT·Codex 세션의 **컨텍스트 건전성, 지식 연속성, 후임 인계 품질, 에이전트 사용성**을 관리한다. PM의 Stage·우선순위·부서 간 의존성 및 인력 전환 시점 조정, 기획의 규칙, 디자인의 UI/아트, 개발의 코드·구현 판단을 대행하지 않는다. Owner는 세션 교체·권한 재부여·중요 변경·main 병합·릴리스 최종 승인자다.

공식 업무 근거 우선순위: Owner 승인 원문 → Git의 승인 명세(경로·버전·SHA) → 승인 티켓 → 검토 중 문서 → 대화·메모리. **최신 HEAD, PR 게시, CI 통과만으로 승인/DONE이 되지 않는다.**

## 운영 문서
| 파일 | 사용 시점 | 작성자/검증 |
|---|---|---|
| [AGENT_HEALTH_POLICY.md](AGENT_HEALTH_POLICY.md) | 진단·인계·교체 절차 | INF / Owner 최종 정책 승인 |
| [AGENT_HEALTH_REPORT_TEMPLATE.md](AGENT_HEALTH_REPORT_TEMPLATE.md) | 현직 세션 자기 진단 | 현직 / INF 교차 확인 |
| [AGENT_ASSESSMENT_TEMPLATE.md](AGENT_ASSESSMENT_TEMPLATE.md) | INF 독립 평가 및 교체 권고 | INF / PM 참고 / Owner 결정 |
| [AGENT_HANDOFF_TEMPLATE.md](AGENT_HANDOFF_TEMPLATE.md) | 세대교체 인계·수용 시험 | 현직·후임 / INF 검증·PM 전환 |
| [AGENT_REGISTRY_TEMPLATE.md](AGENT_REGISTRY_TEMPLATE.md) | 세대·역할·상태 기록 표준 | INF / Owner·PM 확인 |
| [PLANNING_SUCCESSION_RUNBOOK.md](PLANNING_SUCCESSION_RUNBOOK.md) | 기획팀 시범 인계 실행 가이드 | INF 검증 / Planning 작성·Owner 결정 |
| [INF-001 티켓](tasks/INF-001_CONTEXT_GOVERNANCE.md) 및 [검증 기록](tasks/INF-001_RESULT.md) | 변경 근거·증거·검수 | INF / Owner |

## 평가 대상
Owner 제외: HQ/PM, Planning, Design, Development(환경/채팅/스레드별 구분). **부서 1개와 세션 1개가 항상 같은 것은 아니다.** 다른 Codex 작업 스레드나 개발 PC의 상태를 하나의 보고서로 전체 검증했다고 간주하지 않는다.

## 공개 정보 제한
이 저장소는 공개 저장소다. **이번 PR에 4개 에이전트의 실제 진단 점수·개별 오류·대화 전문·세션 내부 URL·개인정보·인증정보를 포함하지 않는다.** 공개 Git에는 양식, 정책, 작업 ID, 공개된 결정·PR 링크 등 최소 운영 사실만 남긴다. 상세 평가 원본은 Owner 제한 보관하고, 공개가 필요한 경우 Owner가 별도 검토한다.

## 실행 원칙
- 진단은 Owner/PM 요청 또는 승인된 점검 시점에 **명시적으로 실행**한다. 자동 상시 감시는 구축되어 있지 않다.
- 채팅 간 자동 전달이나 완전한 메모리를 기대하지 않는다. 새로운 에이전트는 공식 Git을 직접 읽고 최신 SHA를 확인한다.
- 근거 부족 시 `NOT_VERIFIED`, 미실행은 `NOT_RUN`, 내부 컨텍스트 사용량은 신뢰 가능한 계측이 없으면 `UNAVAILABLE`로 기록한다.
- 업무별 INF 티켓·브랜치·Commit/Push/PR 위임을 확인한다. `main` 직접 쓰기·force push·검사 우회 및 타 부서 경로 변경 금지. 병합은 Owner 별도 승인 후다.
