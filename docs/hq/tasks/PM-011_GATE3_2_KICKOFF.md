# PM-011 — Gate 3-1 승인 계획 기록·Gate 3-2 소관별 착수 요청

- **작업 ID:** PM-011 / 작성: HQ(PM) / 2026-11-01 / 상태: REVIEW — Owner 본 HQ PR 검수 대기
- **Owner 승인 원문:** ① “PM 에이전트 해당 보고서를 승인합니다” — HQ Gate 3-1 통합 보고서의 계획 승인. ② “현재 확정된 계획과 ... Gate 3-2 단계를 착수할 수 있도록 부서별 에이전트(인프라 에이전트 제외)별 작업 착수 요청서를 포함한 PR을 생성해주세요. 실제 구현 착수 시 협업 프로세스 변경이 필요하거나 적절한 방안이 있다면 개선하여 HQ 문서를 갱신하여도 상관없습니다.”
- **저장소/기준:** `wisberry2022/MetroManager` / `main` `3add70d3c787091e17d4cd37af0657e88e869767`.
- **브랜치:** `codex/PM-011-gate3-2-stage1-kickoff-repair`.
- **HQ 허용 범위:** 이 PM-011에 한하여 `docs/hq/` 내 승인 계획 요약·협업 절차 보충·기획/디자인/개발 착수 요청·본 티켓/결과의 **Commit/작업 브랜치 Push/PR 생성·검증**.
- **비허용:** `main` 직접 쓰기/병합, 타 부서 자료/게임 코드/아트/도구·CI 변경, 개별 DEV/DSG/PLN 티켓 자동 승인, 새로운 게임 규칙·제품 성능 수치/릴리스 결정.
- **INF 권고 추가 반영:** Owner의 현직 기획 종료·후임 전환 및 PM-010 수신확인 지시에 따라 [공개 전환 기록](../PM-011_PLANNING_SUCCESSION_RECORD.md)과 PM-011 착수 요청/협업 지침을 같은 PR에 보완. 본 HQ 문서 작업의 승인 범위 내이며 신규 부서별 Git 권한은 발생하지 않음.
- **구 문서:** 미병합 `codex/PM-009-gate3-stage1-plan`의 과거 초안을 자동 게시하거나 이 브랜치에 혼합하지 않는다.

## 산출물

- [Owner 승인 Stage 1 통합 기록](../PM-011_GATE3_2_APPROVED_PLAN.md)
- [Gate 3-2 협업·QA 보완](../PM-011_GATE3_2_EXECUTION_PROTOCOL.md)
- [Planning 요청](../requests/PM-011_PLANNING_KICKOFF.md)
- [Design 요청](../requests/PM-011_DESIGN_KICKOFF.md)
- [Development 요청](../requests/PM-011_DEVELOPMENT_KICKOFF.md)
- [제출 결과](PM-011_RESULT.md)

## 완료 조건

- Owner가 승인한 Stage 1 범위·S1-01~09·부서별 의존성/차단 시점이 문서에 반영됨.
- **이미 결정된 최소 실제 조작 UI 및 자동+GUI 검증**을 중복 승인 질문으로 돌리지 않음.
- 각 부서 요청이 자기 R&R에 머물고, 실제 제작·Git 쓰기·Owner Merge 권한의 별도 승인 경계를 명시.
- HQ 소관 경로만 수정하고 정확한 PR head의 `policy`/`department-policy`를 검증.
- 본 PR은 Owner의 별도 main Merge 승인 전 REVIEW이며, Stage 구현/실검증은 NOT_RUN.
