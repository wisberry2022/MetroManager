# INF-008 — INF 2세대 공식 활성화 및 1세대 은퇴 등록

- 업무 소관: INF / 실제 작성·제출: HQ `AGT-PM-0002` / 2026-11-14
- 상태: `OWNER_TRANSFER_APPROVED / SUCCESSOR_ACCEPTANCE_VERIFIED / PM_SWITCH_CONFIRMED / OWNER_PR_SUBMISSION_APPROVED / MAIN_MERGE_PENDING`
- 저장소: `wisberry2022/MetroManager`
- 브랜치: `codex/INF-008-infra-succession`
- 기준 main: `4b3f73c5d8b87630cc96eb90f950761f79bb861b`
- 기준 registry blob: `884cf3efd03bacc0e7e5004b4897f2c251a0bb13`
- [등록부](../agents/registry.json) / [검증·결과](INF-008_RESULT.md)
- Handoff ID: `HOF-20261108-INF-AGT-INF-0001-UNASSIGNED`

<a id="handoff-acceptance"></a>
## 1. 인계·독립 수용 근거

Owner가 INF 자체 세대교체의 독립 검증자로 지정한 HQ `AGT-PM-0002`는 현직 자기보고·4계층 인계를 보충사항과 함께 수용하고, 후임의 T1~T10 답안을 공식 Git·Issue·PR과 대조하여 `SUCCESSOR_ACCEPTANCE_VERIFIED`로 판정했다. 필수 수정·재시험은 없다.

상세 ACHC 평가·점수, 비공개 답안·대화 전문·세션 식별자 및 로컬 보관 경로는 Owner 제한 자료로 보존하며 공개 Git에 싣지 않는다. 이 문서는 운영 결정의 최소 공개 기록이다. 실제 게임 QA·자동 등록 실운영 성공·기술적 신원 인증으로 확대하지 않는다.

<a id="hq-switch"></a>
## 2. HQ 담당 전환 확인

HQ는 INF 책임·미결 업무·부서 의존성을 복원하고 `PM_SWITCH_CONFIRMED`로 회신했다. Owner가 지정하고 아래 최종 결정에서 재확인한 양쪽 효력은 **`2026-11-14T07:47:00+09:00`**이다. 종료·시작은 같은 시각이며 commit·시험·PR·병합 시각에서 추정하지 않았다.

승계 범위는 컨텍스트 건전성·에이전트 연속성, Agent-ID/생애주기 관리, 인계·수용시험 운영, 승인 원본 기반 장애 복구, INF-001~007 승인·감사 이력 보존, DEV-017·root·provenance 운영 검토 및 F-11/F-12 지원이다.

<a id="owner-transfer"></a>
## 3. Owner 최종 임명·효력 승인

2026-11-14 현재 HQ 대화에서 Owner가 다음과 같이 직접 승인했다.

> AGT-INF-0002를 정식 INF로 임명하고 ACTIVE 전환을 승인합니다. 기존 AGT-INF-0001은 RETIRED로 전환하며, 양쪽 효력 시각은 2026-11-14T07:47:00+09:00으로 확정합니다.

| 항목 | 기존 INF | 후임 INF |
| --- | --- | --- |
| Agent-ID | AGT-INF-0001 | AGT-INF-0002 |
| 상태 반영 | ACTIVE → RETIRED | 미등록 → ACTIVE |
| 세대 / 선행 ID | 1 / null 보존 | 2 / AGT-INF-0001 |
| 실제 승인 효력 | 2026-11-14T07:47:00+09:00 | 2026-11-14T07:47:00+09:00 |
| 변경 시각 필드 | retired_at | activated_at |
| record_version | 1 → 2 | 신규 1 |

후보 준비만 승인된 PENDING 제안과 달리, 이번에는 최종 임명·ACTIVE/RETIRED가 명시 승인됐다. 이를 일반 자동 활성화 계약으로 확대하지 않는다. 기존 INF의 activated_at=null 및 과거 승인·저자·계보·인계 이력은 보존한다. 후임의 session_kind는 확인된 선언이 없어 `UNCONFIRMED`로 기록한다. 기기·파일 위치로 추정하지 않는다.

<a id="submission-authority"></a>
## 4. 이번 제출 위임과 실제 작성자

Owner는 위 결정에 이어 **“이에 따라 INF-008을 작성하여 원격 저장소에 PR을 생성해주세요”**라고 HQ에 직접 지시했다.

- 이번 사건의 작성·제출자는 기존 base의 ACTIVE HQ **`AGT-PM-0002`**다. 현직 INF 또는 후임 INF의 ID를 빌려 쓰지 않는다.
- Owner의 현재 지시는 이 INF-008 등록 변경·검증·단일 부모 commit·전용 작업 브랜치 제출·PR 생성과 동일 범위 검수 대응을 HQ에 맡긴 사건 한정 근거다. 일반 HQ/INF 권한 이전이나 미래 작업 위임이 아니다.
- `[INF]` 제목과 INF-008 브랜치는 요청된 등록 업무·경로 분류다. 실제 작성자 Trailer와 문서는 `AGT-PM-0002`를 그대로 밝힌다.
- base의 `path_exceptions.json`은 비어 있으며 이 PR에서 수정하지 않는다. 일반 경로·CI·출처 정책 예외를 새로 추가하거나, 검사로 이번 Owner 위임이 인증됐다고 주장하지 않는다.
- 공개 Owner 원문 URL은 제공되지 않았다. 본문은 현재 직접 결정의 운영 요약이며 문자열·동일 GitHub 계정이 기술적 승인 인증을 뜻하지 않는다.

### 허용된 최소 파일·동작

| 파일 | 변경 |
| --- | --- |
| docs/infra/agents/registry.json | 기존 INF 은퇴 및 후임 INF 신규 활성화 |
| docs/infra/tasks/INF-008_INFRA_SUCCESSION.md | 인계·HQ 확인·최종 Owner 결정·실제 제출 주체·범위 |
| docs/infra/tasks/INF-008_RESULT.md | 검증·미실행·진단·미결 기록 |

허용 동작은 위 세 파일 작성·검증·Commit·작업 브랜치 공유·base=main PR 및 동일 범위 검수 대응까지다. **main 직접 쓰기·병합·자동 병합·force push·릴리스는 포함하지 않는다.** 게임·타 부서 산출물·CI·도구·정책 변경 및 후임의 과거 Git 권한 자동 승계는 없다.

## 5. 미결 업무·부서 경계 보존

- INF-001~007의 과거 작성자·승인·수용·실패/복구 기록을 보존하며 완료 작업을 중복 생성하지 않는다.
- R-INF-01: root pending 문자열·초기 source_main_sha 정리는 별도 계약·승인 대상이다.
- R-INF-02: [DEV-017 실행 계획](../../engineering/provenance/DEV-017_REGISTRATION_RUN_PLAN.md)의 자동 등록 실운영·정상/부정·부분 실패 복구 및 일반 생애주기/append-only 계약은 별도 미결이다.
- R-INF-03: [RFC-DEV-017-01](../../engineering/provenance/RFC-DEV-017-01_REGISTRY_CONTRACT.md)은 OPEN. REPORT_ONLY를 유지하며 Owner 별도 결정·검증 없이 ENFORCE로 전환하지 않는다.
- R-INF-04: Python 다운로드 HTTP 504와 후속 성공 이력을 함께 보존한다. 도구·검사기·CI 구현은 Convention 소관이다.
- R-INF-05: F-11은 작업별 권한 확인, F-12는 **HQ 주관·INF/Convention 지원**이다. QA 원본·접근·백업 복구는 이번 등록 작업에서 NOT_VERIFIED/NOT_RUN이다.
- 게임 규칙·디자인·개발 코드·HQ Stage/인수 판단 및 Owner 정책·권한 승인은 후임 INF가 대행하지 않는다.

## 6. 등록·출처 검사 경계

예상 등록부는 **13 ID / ACTIVE 8 / RETIRED 5 / PENDING 0**이다. 다른 기존 11개 행과 root 전체는 그대로 유지한다.

현재 비교기는 승인된 수동 생애주기 전환도 `REGISTRY_TRANSITION_REVIEW_REQUIRED`로 진단한다. 또한 실제 작성자 PM과 업무 INF의 조합은 현행 일반 출처 계약의 부서 일치 조건과 다르다. registry_delta에서 먼저 멈추면 이후 선언 검사는 미실행이며, 그 뒤 독립 선언 검사에서는 `AGENT_DEPARTMENT` 진단을 예상한다. 해당 계약 공백을 INF ID 사칭·validator 수정·head 자기 예외로 숨기지 않는다.

`agent-provenance-report`는 REPORT_ONLY다. job success를 DECLARATION_CONSISTENT 또는 Owner/세션 인증으로 해석하지 않으며 `identity_authenticated=false / approval_authenticated=false / enforcement_enabled=false`를 유지한다. 실제 head의 필수 `policy`·`department-policy`와 출처 진단은 PR에서 별도 확인한다.

**Owner 최종 인사 결정은 승인됐으며, 이 등록 diff의 main 반영은 별도 병합 승인 대기다.**
