# INF-013 — Design Track A 3세대 전환 후속 등록

- 담당·실제 작성자: INF / AGT-INF-0002 / 2026-11-22 Asia/Seoul.
- 상태: OWNER_TRANSFER_CONFIRMED / OWNER_COMMIT_PUSH_PR_APPROVED / PR_SUBMISSION_PREPARED / REGISTRY_RECORD_PENDING.
- 저장소: wisberry2022/MetroManager. 작업 브랜치: codex/INF-013-track-a-succession / base: main.
- 확인 기준 main: `5d7f57fd6c47df1747cb312d996c73c77338e4f9`.
- 기준 registry blob: `0dbbf55b8e20b908d901e6fc44b10a76db4c51d9`.
- [등록부](../agents/registry.json) / [검증·제출 상태](INF-013_RESULT.md).
- 적용: [INF-009](INF-009_LIGHTWEIGHT_SUCCESSION.md), [전환 규정 v1.1](../agents/REGISTRY_TRANSITION_RULES.md).

## 1. 목적·권한 경계

Owner가 직접 지정한 AGT-DSG-0002 → AGT-DSG-0004 전환을 후속 기록한다. 통상 인계에 별도 T1~T10 시험·HQ 전환 승인·동일 Owner 결정의 재승인을 추가하지 않는다. Track A의 기존 유효 권한은 같은 소관·범위로 이전되며 Track B AGT-DSG-0003은 독립적으로 유지한다.

이번 등록 수행자는 Owner가 지정한 Infrastructure / AGT-INF-0002다. 등록은 임명·업무 효력을 새로 만드는 행위가 아니며, 실제 인수 확인·업무 개시나 기술적 신원을 인증하는 작업도 아니다.

<a id="owner-transfer"></a>
## 2. Owner 전환 결정

2026-11-22 Owner는 현재 INF 대화에서 아래 ID·상태·효력 시각·계보를 명시하고 등록부와 관련 기록의 반영을 지시했다. 공개 Owner 대화 URL과 별도 결정 ID는 제공되지 않았다. 이 티켓은 공개가 허용된 최소 전환 근거만 기록한다.

| 항목 | 전임 | 후임 |
| --- | --- | --- |
| Agent-ID | AGT-DSG-0002 | AGT-DSG-0004 |
| 소관 | Design Track A | Design Track A / Art Director & UI/UX Designer |
| generation / predecessor | 2 / AGT-DSG-0001 보존 | 3 / AGT-DSG-0002 |
| 이번 lifecycle 기록 | ACTIVE → RETIRED | 미등록 → ACTIVE |
| 지정 종료 / 시작 효력 | 2026-11-22T08:42:00+09:00 | 2026-11-22T08:42:00+09:00 |
| 시각 필드 | retired_at | activated_at |
| record_version | 1 → 2 | 신규 1 |

전임의 activated_at=`2026-11-08T15:49:28+09:00`, 최초 승인·인계·계보·저자 이력은 보존한다. 전임 종료 이후 권한이 등록 지연으로 복구되지 않는다. 기록·Commit·PR·merge 시각을 전환 효력으로 사용하지 않는다.

<a id="handoff-record"></a>
## 3. 인계·실제 인수 정보

- 인계 참조: HOF-20261122-DESIGN-TRACK-A-AGT-DSG-0002-AGT-DSG-0004.
- Owner가 제공한 OWNER_RESTRICTED 인계서를 직접 읽었다. 공개 산출물에 파일의 개인 경로·대화·세션 정보·원문 전체를 포함하지 않는다.
- 인계서의 실제 후임 인수 확인·업무 개시 시각은 NOT_RECORDED. 관련 공개 Issue 댓글 대조에서도 AGT-DSG-0004의 실제 인수 회신을 확인하지 못했다. 추후 해당 회신을 받으면 실제 시각·근거를 별도로 기록하며 08:42로 소급하지 않는다.
- Owner가 명시한 ACTIVE는 지정 상태·효력을 후속 기록하는 것이며, 실제 업무를 이미 수행했다는 뜻이 아니다. 인수 확인을 INF/HQ의 추가 승인 시험으로 바꾸지 않는다.
- session_kind=UNCONFIRMED. 전임의 CHATGPT나 현재 도구·계정·로컬 문서 위치로 추정하지 않는다.
- session_scope는 전임의 논리적 Track A 역할 범위 `DESIGN-TRACK-A-SUCCESSOR-CURRENT`를 승계한다. 동일한 물리 세션이나 비공개 세션 식별자라는 뜻이 아니다.
- role_observed_on은 Owner의 역할 지정일이며 실제 후임 업무 개시일을 인증하지 않는다.
- ACHC: NOT_ASSESSED. T1~T10: NOT_RUN(통상 인계 정책상 생략).

## 4. 중복·미반영 결정 대조

- 기준 main에는 총 14 ID, 디자인 ID는 0001/0002/0003이며 0004는 없다. 이번 ID는 Owner의 명시 배정이며 최댓번호만 보고 INF가 독립 발급한 것이 아니다.
- 이번 조회에서 열린 PR 0개, 열린 등록 PR 0개. INF-013 원격 티켓/동일 제목 Issue는 확인되지 않았다.
- 원격 Issue 검색과 관련 #146·#92·#104·#137·#139의 공개 댓글을 대조했으며 같은 신규 ID의 다른 배정·등록 근거를 발견하지 못했다. GitHub 검색만으로 모든 비공개 기록을 인증하지 않는다.
- 제공된 미반영 Owner 배정 기록은 이번 직접 지시와 위 인계서이며 서로 일치한다. 제공되지 않은 비공개 배정 내역 전체는 NOT_VERIFIED로 남긴다. 현 자료에 중복·충돌 증거는 없고, 이번 명시 배정을 동일하게 기록한다.
- 제출 직전 최신 main·열린 등록 PR·같은 작업 브랜치를 다시 대조한다. 실제 충돌이 발견되면 해당 등록 쓰기만 보류하고 Owner에 충돌 근거를 보고한다.

## 5. Git 제출 승인·범위

Owner는 기존 유효 Git 권한을 재사용하고 부족한 제출 동작만 알리도록 지시했다. 확인한 INF-009의 Commit/Push/PR 승인은 정책 개정·동일 범위 보완에, INF-010 승인은 AGT-DEV-0001 → AGT-DEV-0004 등록에 한정된다. 두 티켓은 미래 모든 후속 등록의 포괄 위임이 아니라고 명시한다. 이를 이번 INF-013의 제출 권한으로 확대하지 않는다. Track A에 승계된 디자인 권한을 INF 제출 권한으로 사용하지도 않는다.

로컬 변경안 3파일의 작성·검증을 완료한 후, 이번 INF-013의 Commit·일반 Push·PR 생성만 추가 승인 대상으로 제시했다. Owner는 2026-11-22 현재 INF 대화에서 “제출을 승인합니다 PR 생성해주세요”라고 명시 승인했다. 이 응답은 아래 3파일과 전용 브랜치의 제출에 적용되며 기존 인사 전환 결정의 재승인이 아니다. main 병합은 별도 승인 대상이다.

| 변경 파일 | 포함 범위 |
| --- | --- |
| docs/infra/agents/registry.json | 전임 1행의 은퇴 관련 6필드, 후임 1행 추가 |
| docs/infra/tasks/INF-013_TRACK_A_SUCCESSION.md | Owner 전환·계보·시각·제출 범위·미확인 기록 |
| docs/infra/tasks/INF-013_RESULT.md | 실제 검증 결과·제출 상태·병합 후 확인 기준 |

승인된 제출 범위는 위 3파일, codex/INF-013-track-a-succession 브랜치, 단일 부모 Commit·일반 Push/API 게시·base main PR 및 동일 범위 보완 종료 또는 Owner 철회까지다. GitHub Git Data API로 base tree를 보존한 단일 부모 commit과 expected_sha·force=false 브랜치 갱신을 사용한다. 원격 API는 로컬 훅을 실행하지 않으므로 수동 경로·메시지 검사와 원격 부모·tree·파일·필수 CI를 별도로 확인한다. main 직접 쓰기·병합·자동 병합·force push·릴리스·배포·다른 부서·제품·CI/도구·정책 변경은 포함하지 않는다.

## 6. 보존·현재 도구 계약

기존 14행 중 전임 외 13행과 root 전체를 보존한다. 변경할 전임 필드는 status, retired_at, role_retirement_observed_on, role_evidence_refs, record_version, notes다. 원래 evidence와 notes는 삭제하지 않고 은퇴 근거를 추가한다. 예상 결과는 총 15 ID / ACTIVE 8 / RETIRED 7 / PENDING 0이다.

root의 OWNER_APPROVED_PENDING_MAIN_MERGE·최초 source_main_sha는 역사적 메타데이터로 유지하며 이번 전환과 함께 정리하지 않는다. 미해결 lifecycle/append-only·자동 등록 workflow·Provenance ENFORCE 계약을 변경하지 않는다.

수동 ACTIVE/RETIRED 기록은 INF-009에 따르며 불필요한 PENDING 등록 PR을 추가하지 않는다. 현 비교기의 REGISTRY_TRANSITION_REVIEW_REQUIRED 진단은 승인된 수동 전환 근거와 함께 검토한다. 필수 policy·department-policy 검사를 우회하지 않는다. agent-provenance-report는 REPORT_ONLY이며 실제 신원·Owner 승인 인증이 아니다.

Agent-ID: AGT-INF-0002
Task-ID: INF-013
