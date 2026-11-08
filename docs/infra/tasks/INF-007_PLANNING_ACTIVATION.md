# INF-007 — Planning 3세대 공식 활성화 및 2세대 은퇴 등록

- 담당: INF / 제출 주체 `AGT-INF-0001` / 2026-11-08
- 상태: `OWNER_TRANSFER_APPROVED / INF_ACCEPTANCE_VERIFIED / HQ_PM_SWITCH_CONFIRMED / OWNER_GIT_PR_APPROVED / PR_REVIEW / MAIN_MERGE_PENDING`
- 저장소: `wisberry2022/MetroManager`
- 브랜치: `codex/INF-007-planning-succession-activation`
- 검토 기준 main: `8a9515a781e8864de211df0ece3a52568df1154a`
- 기준 registry blob: `8b4a65c49e3db915b7a3c2b3f4628bb18ac9d858`
- 등록부: [registry.json](../agents/registry.json) / [INF-007 검증·결과](INF-007_RESULT.md)
- 선행 후보 등록: [INF-006](INF-006_AGENT_REGISTRATION.md) / [PR #99](https://github.com/wisberry2022/MetroManager/pull/99)
- 제한 인계 원본: `ACHC-20261108-PLN-AGT-PLN-0002`, `HOF-20261108-PLN-AGT-PLN-0002-UNASSIGNED` (Owner/INF 비공개 보관)

## 1. 승인된 전환과 근거

<a id="hq-switch"></a>
### HQ 전환 확인

신임 HQ `AGT-PM-0002`는 Owner가 전달한 INF 수용 결과를 확인하고 현직 `AGT-PLN-0002`에서 후임 `AGT-PLN-0003`으로의 업무 연속성과 책임 범위를 검토하여 `PM_SWITCH_CONFIRMED`로 회신했다.

승계 대상은 Gate 2 승인 규칙·변경 이력, Stage 2 W04A/W05/W06의 Planning 의미 검토 및 새 충돌 시 Owner RFC, PLN-004 POST-MVP 기획이다. 전문 디자인·코드 구현·통합 Gate/Stage 수용·Agent-ID/CI 정책은 각 소관 부서가 담당한다.

HQ는 Owner가 2026-11-08 **18:49 KST**를 양쪽 전환 기준으로 지정했다고 보고했고, 종료·시작을 동일한 `2026-11-08T18:49:00+09:00`으로 확인했다. 병합·Commit·검사 시각을 대체값으로 사용하지 않는다.

<a id="inf-acceptance"></a>
### INF 인계 및 후임 수용

- 현직 자기보고·4계층 인계서를 독립 검토하여 `HANDOFF_PACKAGE_ACCEPTED` 판정.
- 후임이 제출한 T1~T10 답안을 공인 Git·Issue·PR과 대조해 `SUCCESSOR_ACCEPTANCE_VERIFIED` 판정.
- 세부 ACHC 점수, 원문 채팅, 내부 세션 식별·비공개 인계 답안 전문은 공개 Git에 기재하지 않는다.
- 이번 수용은 실제 Godot 검증·게임 QA 또는 신규 Git 실행 권한의 합격 인증이 아니다.

<a id="owner-transfer"></a>
### Owner 최종 담당·생애주기 승인

Owner는 위 인계 수용과 HQ 책임 범위·시각 확인 후, **기존 `AGT-PLN-0002` RETIRED와 후임 `AGT-PLN-0003` ACTIVE 등록 및 양쪽 `2026-11-08T18:49:00+09:00` 효력**에 대해 인프라 대화에서 `최종 승인합니다`라고 명시했다. 이는 INF-006 당시의 `OWNER_TRANSFER_PENDING` 상태를 후속 결정으로 갱신한다.

| 항목 | 기존 Planning | 후임 Planning |
| --- | --- | --- |
| Agent-ID | `AGT-PLN-0002` | `AGT-PLN-0003` |
| 세대 | 2 | 3 |
| 이번 lifecycle 변경 | `ACTIVE → RETIRED` | `PENDING → ACTIVE` |
| approved effective_at | `2026-11-08T18:49:00+09:00` | `2026-11-08T18:49:00+09:00` |
| registry field | `retired_at`, record_version 1→2 | `activated_at`, record_version 1→2 |
| predecessor | `AGT-PLN-0001` | `AGT-PLN-0002` |

동일한 업무 전환 시각에 공백·중복을 만들지 않는다. 현직의 `activated_at=null`은 역사적으로 미확인된 최초 활성화 시각이므로 그대로 유지한다. 이전 산출물의 저자, 기존 승인 및 시험 결과는 소급 변경하지 않는다.

### 이번 INF-007 Git 제출 허가

Owner는 위 인사 전환을 별도로 최종 승인하고, INF가 제안한 `INF-007`의 등록부·`docs/infra/tasks/INF-007_*.md` 수정·검증·Commit·일반 Push·PR 생성 요청에 `PR 생성해주세요`라고 명시했다.

- 작업 브랜치: `codex/INF-007-planning-succession-activation`
- 허용 경로: `docs/infra/agents/registry.json`, `docs/infra/tasks/INF-007_PLANNING_ACTIVATION.md`, `docs/infra/tasks/INF-007_RESULT.md`만.
- 허용 행위: 승인 diff 작성·Git 검증·단일-부모 Commit·전용 브랜치 제출·base=main PR 및 동일 범위 검토 대응.
- 제외: main 직접 변경/병합/auto-merge, 릴리스, 강제 Push, 타 부서 기획 명세·게임·CI·정책·tools 변경, 후임 Planning 작업별 Git 권한 자동 이전.
- 실행의 종료 조건: 이번 PR 제출 및 승인된 동일 범위의 검수 대응까지. main 병합은 Owner의 별도 승인 이후.

공개 승인 원문 URL은 별도로 제공되지 않았으므로 본 문서는 Owner 제한 대화의 결정 범위를 최소 공개 요약한다. 문자열이나 동일 연결 계정 자체는 Owner 또는 세션의 신원을 기술적으로 인증하지 않는다.

## 2. 후임 Planning 업무·상태 연속성

- 승인된 Gate 2 PLN-001-C v0.6, D v0.9, DATA v1.3와 SEM/CLOSE/APP 정책은 유지한다.
- W05 R01~03의 여섯 세부 Owner 결정은 이미 확정됐다. [Issue #26 최종 결정](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6719007539)을 재심사하거나 미결로 되돌리지 않는다. C/DATA 정식 문서 개정은 후속 Planning 티켓·Owner Git 승인 범위에서 진행한다.
- DEV-020 PR #95의 모델 공급·검증 기록은 보존한다. 기존 P02/P05 안내의 공기 기산 표현과 DEV-021 실제 UI 인수는 DEV·Design·HQ의 별도 후속 검증이며 자동 수용 대상이 아니다.
- W04A QA-001/002 독립 수용, Q03/04/05/12 PARTIAL은 유지한다. W06·VS-01 실제 제품 인수는 별도다.
- PLN-004 POST-MVP v0.7의 7개 상위·21개 초기 하위·FIN-01~07 기준선은 승인된 미래 기획으로 보존하며 MVP 기존 원장·입찰 점수에 자동 적용하지 않는다.
- 후임에게 이전 `AGT-PLN-0002`의 과거 PLN-002·003·004 Commit/Push/PR 허가는 자동 승계하지 않는다. 각 신규 업무에 Owner 개별 실행 승인 필요.

## 3. 등록부 보존·기술 검사 한계

- 기존 등록부 12개 ID와 root 메타데이터를 보존하며, **PLN 0002·0003 두 행의 lifecycle 관련 허용 필드만 변경**한다.
- 기존 `AGT-PLN-0002`의 `activated_at=null`, 원래 승인 참조·role/scope/kind·이전 계보·이력 보존. retirement 효력만 새로 기록.
- 후임의 PENDING 인계·후보 근거는 [INF-006](INF-006_AGENT_REGISTRATION.md)에서 추적 가능하게 유지한다. 이번 상태 변경에서 `session_kind=UNCONFIRMED`는 **실제 세션 종류가 확인되지 않은 상태의 보존**이며, 승인된 ACTIVE lifecycle이 기술적 세션 신원 인증을 의미하지 않는다. 공식 종류 확인·정정은 별도 검토 사항.
- 등록부 초기 root `registry_state=OWNER_APPROVED_PENDING_MAIN_MERGE`와 최초 `source_main_sha` 등 과거 문자열은 변경하지 않는다. 정리는 별도 작업·승인이 필요하다.
- DEV-017의 `REGISTRY_TRANSITION_REVIEW_REQUIRED`는 현재 자동 수용 계약 미완성을 나타내는 진단이며, 생애주기 변경의 Owner 검수를 대체하지 않는다. `agent-provenance-report`는 REPORT_ONLY로서 `identity_authenticated=false`, `approval_authenticated=false`, `enforcement_enabled=false`가 유지된다.
- GitHub API 제출은 로컬 훅·doctor/check/preflight, 등록부 tooling 회귀를 실행하지 않는다. 실행하지 않은 검사는 `NOT_RUN`으로 기록한다. 실제 PR head의 `policy` 및 `department-policy` 원격 결과를 별도 확인한다.
- 실제 게임 테스트·Godot 로드·GUI·Windows 빌드·성능은 이번 INF 등록 PR의 수행 대상이 아니며 `NOT_RUN`이다.

**현재 제출 상태:** `INF007_OWNER_APPROVED_FOR_PR / MAIN_MERGE_PENDING / NO_AUTOMATIC_GIT_PERMISSION_TRANSFER`. 병합·릴리스·제품 인수 완료로 선언하지 않는다.
