# INF-005 — HQ/PM 후임 세대교체 공식 등록

- 부서·등록 제출 주체: Infrastructure / `AGT-INF-0001` / 2026-11-08
- 범위: 기존 `AGT-PM-0001` RETIRED + 후임 `AGT-PM-0002` ACTIVE
- 상태: `OWNER_TRANSFER_APPROVED / INF_ACCEPTANCE_VERIFIED / PR_SUBMISSION_REVIEW / MAIN_MERGE_PENDING`
- 저장소: `wisberry2022/MetroManager`
- 제출 브랜치: `codex/INF-005-pm-succession`
- 기준 main: `02146a027a373b6a2d42fa40c581812e84ad6c44`
- 기준 registry blob: `89f371e953ea505619488d3e0b0634d3f24fc42b`
- 공식 등록부: [registry.json](../agents/registry.json) / [검증·결과](INF-005_RESULT.md)

## 1. Owner 결정과 인수 배경

기존 HQ/PM 담당 `AGT-PM-0001`이 제한 인계용 자기보고 및 4계층 업무 인계서를 작성했고, INF가 승인 상태·작업 현황·부서 경계·권한을 독립 대조했다. 새 후보가 Owner 제한 인계자료를 확인하고 T1~T10 수용질문에 응답했으며, INF가 수용 기준 충족을 확인했다. 상세 점수·비공개 세션 정보·원문 대화 전문과 첨부파일은 Owner 제한 보관하며 공개 Git에는 게시하지 않는다.

<a id="handoff-acceptance"></a>
### INF 인수 수용

- 현직 인계서: `HANDOFF_PREPARED / INF_CROSS_CHECKED`.
- 후임 응답: `SUCCESSOR_ACCEPTANCE_VERIFIED`; CRITICAL 필수 전부·NORMAL 요구 기준 충족.
- 원본 제한 보관 ID: `HOF-20261108-PM-AGT-PM-0001-UNASSIGNED` (인계 당시 후임 ID 미배정), `ACHC-20261108-PM-AGT-PM-0001`.
- 이번 등록은 후보의 실제 Git 쓰기·멀티부서 프로젝트 인수 능력 또는 게임 기능·GUI QA PASS를 새로 입증하지 않는다.
- 현직 PM의 대화 길이 제한으로 추가 확인에 의존하지 않고, 이미 작성된 인계자료 및 승인 Git·Issue·PR 원본에서 복구한다.

<a id="owner-transfer"></a>
### Owner 공식 임명·상태 및 전환 효력 확정

Owner는 2026-11-08 Infrastructure 대화에서 후임 HQ/PM 임명과 신규 `AGT-PM-0002` 배정, 현직 RETIRED 및 후임 ACTIVE 전환을 모두 승인했다. **명시적으로 서로 다른 효력 시각을 지정했다.**

| 항목 | 공식 등록 값 |
| --- | --- |
| 현직 `AGT-PM-0001` | `ACTIVE → RETIRED`, `retired_at=2026-11-08T17:24:00+09:00`, `record_version=2` |
| 후임 `AGT-PM-0002` | 신규 `ACTIVE`, `activated_at=2026-11-08T17:25:00+09:00`, `record_version=1` |
| 후임 계보 | `department=PM`, `generation=2`, `predecessor_agent_id=AGT-PM-0001` |
| 공개 세션 유형 | 새 후임 후보가 답변한 Codex 세션 / `session_kind=CODEX` |
| 담당 | HQ 통합 PM·Gate/Stage·Owner 의사결정 지원, 부서 의존성·리스크·인수 관리 |

17:24 종료와 17:25 시작 사이의 1분은 Owner가 구분한 **공식 책임 효력 공백**으로 유지한다. 실제 오류·세션 마지막 메시지·후임 시험·Commit·PR·병합 시각으로 대체하지 않는다. 현직 PM이 교체 대상 당사자이므로 PM 전환 확인은 **Owner의 직접 결정으로 갈음**한다. 실제로 받지 않은 별도의 현직 PM `PM_SWITCH_CONFIRMED`를 만들어 기록하지 않는다.

Owner 결정의 공개 원문 URL은 제공되지 않았다. 본 문서는 Owner 제한 원본의 필요한 업무·효력 내용만 공개 요약하며, 같은 GitHub 계정의 댓글·Commit 존재는 Owner/에이전트의 실제 신원 인증이 아니다.

<a id="git-approval"></a>
### INF-005 Git 제출 승인

2026-11-08 Owner는 선행 INF 요청에서 `INF-005`의 `registry.json` 및 `docs/infra/tasks/INF-005_*.md` 수정·검증·Commit·일반 Push·base=main PR 생성 승인 요청을 확인한 뒤 **“PR 생성해주세요”**라고 명시했다. 이 동작 승인 범위를 이번 INF-005 제출에만 적용한다.

| 항목 | 현재 허용 |
| --- | --- |
| 작업·브랜치 | `INF-005` / `codex/INF-005-pm-succession` |
| 수정 파일 | `docs/infra/agents/registry.json`, `docs/infra/tasks/INF-005_PM_SUCCESSION.md`, `docs/infra/tasks/INF-005_RESULT.md` |
| 허용 행위 | 해당 파일 검토·등록부 변경·GitHub Git Data API 단일-부모 Commit·작업 브랜치 생성·PR 제출 및 동일 범위 검수 대응 |
| 제외 | `main` 직접 수정/병합·자동병합, 릴리스, force push, 기존 승인 정책/CI/도구·타 부서 파일 변경, 신규 PM의 포괄 Git 권한 |
| 종료 | 해당 INF-005 PR 제출 및 동일 범위 수정 대응까지; 다른 작업으로 권한 자동 연장 금지 |

## 2. 후임에게 승계되는 책임과 남은 상태

후임 HQ/PM은 [PM-008](../../hq/PM-008.md)과 [PM-014](../../hq/PM-014_STAGE2_VS01_EXECUTION_PLAN.md)에 따라 Gate 3-2 Stage 2 VS-01, Track A W04A→W05→W06→통합 인수, Track B S2-D01 병렬 비차단, F-01~12의 실제 해제 조건 및 Owner 승인 게이트를 관리한다. Planning 규칙·DEV 구현·Design 전문 판정·Convention Git/CI·INF 에이전트 등록은 각 부서의 소관이다.

- Gate 2 Owner 최종 승인과 Stage 1 최종 DONE은 유지한다. Stage 2 계획 승인/코드 PR 병합/실제 제품 인수/DONE은 구분한다.
- DEV-020 R01~03에 대한 Owner 여섯 정책 선택은 [Issue #26 후속 결정](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6719007539)으로 해소됐다. 관련 승인 기획 문서의 정식 개정은 후속이다. DEV-020은 [Issue #76 착수 보고](https://github.com/wisberry2022/MetroManager/issues/76#issuecomment-6719137242)에 따라 개별 승인 범위에서 진행 중이며 모델 PASS·실GUI·Stage 수용은 별도 증거가 필요하다.
- DEV-019의 QA-001·002는 기존 Design 독립 재검수 수용을 보존하고 A01-Q03·04·05·12의 PARTIAL을 임의 PASS로 승격하지 않는다. [Issue #75](https://github.com/wisberry2022/MetroManager/issues/75), [Issue #81](https://github.com/wisberry2022/MetroManager/issues/81).
- Track A `AGT-DSG-0002`, Track B `AGT-DSG-0003`은 독립 ACTIVE 세션이며 기존 소유권을 유지한다.
- F-08의 규격·폰트·입력·성능 기술 협의 [Issue #92](https://github.com/wisberry2022/MetroManager/issues/92)는 실제 DEV 회신·Owner 최종 규격 확인 전까지 OPEN이다.
- 새 HQ 업무의 첫 안전 행동은 최신 Git/Issue/PR 상태 재확인, 기획 개정 책임·DEV-020 후속 의존성 연결 및 Owner 필요한 결정의 자료 준비이다. 이번 등록은 신규 HQ 작업 지시·Issue 수정·Commit/Push/PR 권한을 후임에 발급하지 않는다.

## 3. 정합성·이력 보존과 기술적 검증 한계

- 기존 PM의 `activated_at=null`, 초기 `owner_approval_ref`와 역할·세대·세션 종류·기존 기록은 보존한다. 기존 이력의 저자·검수 판정·보관 자료를 후임 ID로 소급 변경하지 않는다.
- 다른 기존 Agent-ID 9개 행과 배열 상대 순서·역사 시각·초기 레거시 `null`은 그대로 유지한다. 신규 `AGT-PM-0002`는 기존 PM 직후에 삽입한다.
- root `registry_state=OWNER_APPROVED_PENDING_MAIN_MERGE`, `source_main_sha` 등 과거 메타데이터는 이번 범위에서 변경하지 않는다. 오래된 root 정리는 별도 Owner 승인 과제다.
- DEV-017의 자동 등록은 PENDING 후보 제안용이며 이번 Owner 승인 ACTIVE/RETIRED 수동 전환의 자동 통과·신원 인증을 의미하지 않는다. [RFC-DEV-017-01](../../engineering/provenance/RFC-DEV-017-01_REGISTRY_CONTRACT.md)은 OPEN 계약 제안이다.
- `agent-provenance-report`는 REPORT_ONLY. `identity_authenticated=false`, `approval_authenticated=false`, `enforcement_enabled=false`를 유지한다.
- GitHub 플러그인의 Git Data API는 로컬 hook·doctor·preflight를 실행하지 않으므로 **NOT_RUN**으로 보고한다. 실제 head의 원격 `policy`·`department-policy` 및 보고 전용 출처 결과를 별도 확인한다.
- 실제 게임 테스트·Godot 프로젝트/GUI·Windows 빌드·성능은 **NOT_RUN**. PM 등록부·문서만 변경하며 게임·경제 규칙·테스트·제품 수용은 변경하지 않는다.

**현재 결과:** INF 제출 검수용 PR. Owner의 별도 `main` 병합 승인 전 `INF-005 DONE` 또는 등록부 main 반영 완료로 보고하지 않는다.
