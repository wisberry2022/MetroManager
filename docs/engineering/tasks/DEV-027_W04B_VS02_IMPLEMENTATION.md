# DEV-027 — W04B·VS-02 착수 계획 및 문서 제출 티켓

- 담당: Development / AGT-DEV-0004 / 2026-11-21 (Asia/Seoul).
- 문서 제출: **OWNER_DOCUMENT_PR_REQUESTED / PLAN_REVIEW**.
- 제품 작업: **IMPLEMENTATION_AUTH_PENDING / PRODUCT_VALIDATION_NOT_RUN**.
- 기준 main: `f047edbf67a6f888eda5eed24309b78554b3c2ed`.
- 이번 문서 브랜치: `codex/DEV-027-stage3-start-plan` → base `main`.
- [착수·실행/검증 계획](../gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md) / [결과서](DEV-027_RESULT.md) / [출처 기록](DEV-027_PROVENANCE.json).
- 연결: PM-020 / PLN-013 / [#146](https://github.com/wisberry2022/MetroManager/issues/146) / DEV-026 [#104](https://github.com/wisberry2022/MetroManager/issues/104).

## 1. Owner 요청과 효력

최초 요청은 W04B·DEV-026 착수 범위·실행/검증 계획을 이슈에 등록하는 것이었다. 그 결과인 [#148](https://github.com/wisberry2022/MetroManager/issues/148)의 본문은 보존한다.

### 후속 요청 — 2026-11-21 / 본 개발 대화

> 개발 에이전트. 미안합니다. 이슈를 철회하고 해당 이슈의 내용을 로컬 산출물로 변환하여 원격 저장소에 PR을 생성해주세요

이 요청에 따라 #148을 **CLOSED / not_planned(이슈 제출 방식 철회)**로 전환하고 내용은 개발 문서 PR로 옮긴다. [원격 전환 기록](https://github.com/wisberry2022/MetroManager/issues/148#issuecomment-7053231691)에 연결했다. 작업 취소/DONE이나 기획·디자인 계약 수용으로 처리하지 않는다.

현재 PR 생성 요청은 **아래 문서4개의 로컬 작성/정적 검사·정상 훅 Commit·일반 Push·PR 생성·필수 CI 확인**을 허용하는 지시로 적용한다. #148 및 기존 #146/#104의 후속 연결도 제출 방식 전환에 포함한다. 이는 앞선 문서 Git 보류만 갱신하며 **제품 구현·게임 실행/실험·미래 구현 산출물 제출·main 병합은 승인하지 않는다**.

- 대상: `wisberry2022/MetroManager` / DEV-027 / AGT-DEV-0004.
- 브랜치: `codex/DEV-027-stage3-start-plan`, base `main`.
- 기간: 이번 문서 PR 제출·동일 범위 검수 대응 종료 또는 Owner 철회까지.
- 제외: 제품/씬/데이터/게임 테스트, 타 부서 문서, 정책/CI/훅/도구, 강제 Push·직접 main 수정·병합·auto-merge·릴리스/배포.
- 원문 진위/인사·최종 승인은 문서 자체나 CI가 인증하지 않는다.

## 2. 이번에 제출할 정확한4개 경로

| 경로 | 내용 |
| --- | --- |
| `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md` | 본 티켓, Owner 후속 요청·문서 제출 권한·현재/미래 범위 |
| `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md` | #148의 PM-020/PLN-013/#146 대조·DI-01~03·RFC·정확한 경로·통합 순서·검증 계획 |
| `docs/engineering/tasks/DEV-027_RESULT.md` | 변환 범위·원본 식별·문서 검증·실행 NOT_RUN·미해결 |
| `docs/engineering/tasks/DEV-027_PROVENANCE.json` | 위3개 Markdown의 제출 base·blob·Agent-ID·출처 선언 |

계획의 DEV-027 41개·DEV-026 24개(공통2개, 고유63개)는 **미래 구현 승인 후보**다. 위4개만 이번에 추가하며 이4개는 원래 DEV-027 후보41개 안에 있다. DEV-026 기존 문서/증거와 제품 코드는 수정하지 않는다.

## 3. 제품 단계에서 유지할 검토 경계

- W04B·VS-02는 DEV-027로, 공통 UI 안정성은 기존 DEV-026으로 유지한다.
- DEV-026은 PM-020의 **STAGE3_SCOPE_CONFIRMED / IMPLEMENTATION_READINESS_PENDING**이다. 과거 HOLD를 무기한 제외로 해석하거나 편입 승인을 반복 요청하지 않는다. 실제 구현·제품 검증·수용은 아직 미실행이다.
- DI-01 접수/효력·잠금·사업 계보, DI-02 정상 RNG·seed·추출 순서, DI-03 E01 실제 수요 연결을 계획에 담았다.
- RFC-DEV-027-01은 대상 동/OD와 추가 발생/중첩 의미의 Planning 확인 대기다. 새 정책 필요는 아직 확정하지 않으며 종속 부분만 보류한다.
- DEV-026 공통 계약/변경→DEV-027 실제 공급→해당 UI L2 수용→순차 통합→최종 VS-02 시험본 순서를 유지한다.
- 자동/소비 fixture/DEV 실제 GUI/독립 실행/Design 심사·HQ/Owner 최종 인수를 분리한다. 기존 PASS·한정 수용·원본 정정·미확인을 보존한다.

## 4. 이번 문서 제출 종료 조건

원래 계획의 의미/변경 후보/승인 경계를 보존한 로컬 문서4개를 검증하여 PR로 제출하고, 실제 head의 `policy`·`department-policy`를 확인한다. #148 철회와 #146/#104의 대체 PR 연결을 확인한다. 문서 제출 완료는 구현 계획의 최종 승인이나 제품 DONE이 아니다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
