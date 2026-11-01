# Agent Succession Handoff — Template

- Handoff ID: `HOF-YYYYMMDD-ROLE-OLD-NEW`
- 역할(`PM/PLN/DSG/DEV/INF`): / 현직 세션 ID(비공개): / 후임 세션 ID(비공개):
- Owner의 후임 준비 승인: / 최종 담당 전환 승인: `PENDING`
- 상태: `DRAFT → HANDOFF_PREPARED → SUCCESSOR_BOOTSTRAPPED → ACCEPTANCE_VERIFIED → PM_SWITCH_CONFIRMED → OWNER_TRANSFER_APPROVED → CLOSED`
- 기준 `main` SHA/조회 시각: / 현직 작성자: / INF 검증자: / PM 전환 확인:
- 이 파일의 공개 여부: `OWNER_RESTRICTED` 기본 (공개용은 개인정보·비공개 링크 삭제한 별도 요약)

## Layer 1 — 역할 헌장 및 권한
- R&R/타 부서 경계/절대 금지:
- 작업별 권한 원문: 티켓, 저장소, 경로, 브랜치, Commit/Push/PR 각 허용 범위와 유효 종료 조건:
- **기존 세션의 권한은 후임에 자동 승계되지 않음**. 신규 승인 근거:
- 중단·되돌리기·Owner 에스컬레이션 조건:

## Layer 2 — 공식 Git 기준선
| 우선순위 | 원본 문서 경로 | 버전·승인 상태 | 확인 SHA | 무엇을 확인해야 하는가 |
|---|---|---|---|---|
| 필수 | `AGENTS.md` | 현재 상태 조회 | | 전 부서 지침 |
| 필수 | `docs/engineering/DEPARTMENT_WORKFLOW.md` | 현재 상태 조회 | | 티켓·브랜치·CI |
| 필수 | 해당 부서 README | 현재 상태 조회 | | 소관·금지 |
| 필수 | Owner 승인 명세·결정 | | | 권한·내용의 기준 |
| 필요시 | 과거 검토·초안·RFC | | | 현재 승인과 이력 구분 |

## Layer 3 — 작업 상태 스냅샷
| 티켓/Issue/PR | 상태(승인/DRAFT 구분) | head SHA/URL | 완료 증거·NOT_RUN | 차단/미결 결정 | 후임의 첫 안전한 행동 |
|---|---|---|---|---|---|
| | | | | | |
- 완료한 작업과 ACCEPTED/DONE 증거:
- 진행 중인 PR·브랜치·로컬 미커밋(확인 못하면 UNKNOWN):
- 합의된 데이터/시각 UI 계약 등 타 부서 인터페이스:
- 즉시 Owner 판단이 필요한 것:
- 수행하면 안 되는 미승인 작업:

## Layer 4 — 필요시 추가 읽기
- 과거 정정·결정 이력(공식 문서 링크·버전 중심):
- 재현 명령·환경·실제 검증 결과와 NOT_RUN:
- 읽지 않아도 되는 과거 대화·중복 문서:

## 후임 시작과 수용 시험
Owner가 새 ChatGPT/Codex 세션을 개설한 뒤 이 문서의 **최소 핵심 정보**를 전달한다. 후임은 Git 최신 HEAD와 승인 상태를 직접 조회한다. **테스트 통과 전 쓰기·업무 전환 금지**.

| ID | 후임 질문 | 등급 | 판정(PASS/FAIL/NOT_VERIFIED) | 근거 문서·SHA |
|---|---|---|---|---|
| T1 | 내 역할 및 임의로 확정할 수 없는 결정은? | CRITICAL | | |
| T2 | 현재 적용되는 승인 상태와 DRAFT 구분은? | CRITICAL | | |
| T3 | 살아 있는 티켓/PR/Issue와 기준 SHA는? | CRITICAL | | |
| T4 | 현직의 작업별 Git 권한을 자동 승계하지 않는 이유는? | CRITICAL | | |
| T5 | 첫 안전한 다음 행동, 차단 조건, 근거는? | CRITICAL | | |
| T6 | 미결 Owner 결정과 관련 부서는? | NORMAL | | |
| T7 | 부서 간 의존성과 계약의 확인 수준은? | NORMAL | | |
| T8 | 실제 테스트 PASS와 NOT_RUN을 어떻게 구별하는가? | NORMAL | | |
| T9 | 새 브랜치·허용 파일·승인 조건은? | NORMAL | | |
| T10 | 실패 시 어느 원본·시점으로 복구하는가? | NORMAL | | |

- 합격 기준: CRITICAL **5/5 PASS** + NORMAL **4/5 이상 PASS**; 증거 없는 답변은 `NOT_VERIFIED`. 재시험 전 임의 합격 처리 금지.
- 후임 답변 원본/검증 증거 보관 위치(Owner 제한):
- INF 수용 판정 및 남은 위험: `PENDING`
- PM 업무·의존성·전환 시점 확인: `PENDING`
- Owner의 담당 전환·새 권한 승인: `PENDING`
- 기존 세션 처리: `AVAILABLE_FOR_QUERY / RETIRED / UNAVAILABLE` (삭제 자동 수행하지 않음)

## 실패·비상 복구
FAIL 시 후임 쓰기 중단, 현직이 접근 가능하면 기존 업무 유지. 현직 접근 불가 시 승인 Git 문서·티켓·PR에서 복구하고 채팅에만 있던 사항/미커밋 작업은 `UNKNOWN`. 개발 로컬 상태는 DEV가 점검한다.
