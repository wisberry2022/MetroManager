# PM-008-GIT — Gate 3 A안 기존 Git 규칙 차이 및 담당 부서 인계

- 문서 ID: PM-008-GIT / v0.1 / HQ / 상태: **REVIEW — Owner A안 승인 반영, 공통 규정 실제 수정 미실시**
- 기준 main: `fc283b7bbf0cbb1e63dac9af8dbe663e3862330e`; 참조: [PM-008](PM-008.md), [AGENTS](../../AGENTS.md), [DEPARTMENT_WORKFLOW](../engineering/DEPARTMENT_WORKFLOW.md), [GIT_WORKFLOW](../engineering/GIT_WORKFLOW.md), [ENFORCEMENT](../engineering/ENFORCEMENT.md).
- Owner 결정: **A안(기존 Markdown 티켓+필수 CI 유지, Issues/PR 점진 도입)** 승인. 이 결정은 기존 Git 검사기 완화 또는 자동 권한 위임 승인이 아님.

## 1. 충돌·정합성 목록

| 분류 | 현재 원격 규칙 | A안 적용·추가 작업 | 담당 |
|---|---|---|---|
| GitHub Issues | 공식 추적 수단으로 명시 부족 | Issue는 관리 원장, 부서별 최소 Markdown 티켓 유지. 양쪽 ID·링크 연결 | HQ 운영 / 각 부서 |
| PR 댓글 검토 | 원격 필수 CI·Owner Merge 규칙 존재 | 리뷰 경량 양식(부서·head SHA·영향·수용/수정/차단·NOT_RUN) 운영, 주요 결정은 명세에 반영 | 각 부서 / HQ |
| L1/L2/L3 | 공식 영향 등급 없음 | PM-008 기준으로 선택적 교차 검토. 필수 CI·Owner 승인 생략 금지 | HQ / 각 부서 |
| 티켓별 위임 | GIT_WORKFLOW에서 기록 항목 요구, 포괄 위임 없음 | 각 티켓의 Owner 승인 원문에서 Commit/Push/PR 동작별·기간·경로를 기록. 전부 별도 자동 허가 아님 | Owner / 각 부서 |
| Markdown 티켓 검사 | `tools/department_policy.py`가 `docs/<부서>/tasks/<ID>_*.md` 요구 | **현재 유지**. Issues-only로 대체하려면 DEV 정책/테스트/CI 별도 Owner 승인 | Convention Team |
| PM-007 상태 | main의 PM-007 헤더는 이전 DRAFT 표현 | 승인 원문과 현행 적용 범위를 대조해 **HQ 별도 정합성 개정**; 과거 서술을 임의 삭제하지 않음 | HQ |
| GOV-001/AGENTS | 문서 자체 DRAFT/기존 R&R·인수·Git 단계 보존 | PM-008 링크/적용일/승인 범위 보완 시 Owner의 규정 변경 승인 및 해당 소관에 따른 PR 필요 | Owner / Convention Team |

## 2. 이번 HQ 문서 PR 범위

**가능:** `docs/hq/` 하위 PM-008 운영 기준, HQ 작업 티켓/검수 보고, 부서별 최초 분석 요청, Git 변경 요청서의 작성·제출.

**금지:** `AGENTS.md`, `docs/engineering/`, `docs/governance/`, `tools/`, `.github/`, 타 부서 산출물 직접 변경; 정책 검사 완화·main Merge·릴리스. 공통 규정 변경은 Convention Team의 별도 티켓·경로에서 새 PR로 진행하고 Owner가 검수/병합한다.

## 3. Convention Team에 제안할 최소 후속 변경 (별도 승인 대상)

1. 공통 워크플로/README에 **Issue·PR의 역할과 PM-008 링크**를 추가하되 기존 티켓·CI를 유지.
2. 티켓별 Commit/Push/PR 위임의 증거 필드를 설명하는 양식/검사 대상 정합성을 검토. 규칙 변경이 없다면 문서 설명만 추가.
3. 리뷰 등급은 PM-008 관리 원칙으로 두고, CI의 정책 검사나 Owner Merge 승인을 낮추지 않음.
4. Issues-only 방식으로 완전 전환은 첫 Stage 시범 운영 이후 별도 RFC와 Owner 승인으로 판단.
5. 공통 지침 변경 시 시험 PR, 두 필수 CI, 변경 경로와 승인 원문 증거를 남김.

## 4. 공식 의사결정 및 인수

Owner의 A안 승인으로 **운영 방향은 정해졌지만** 공통 정책 코드·공유 파일 변경이 자동 허가된 것은 아님. HQ는 본 차이표를 Convention Team에 전달하고, Owner가 해당 부서의 별도 변경 티켓 및 권한을 확인하면 구현을 조정한다.

본 문서의 작성·PR 제출은 공통 규칙 변경 완료로 해석하지 않는다.
