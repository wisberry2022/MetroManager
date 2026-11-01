# PM-010 — Gate 3-1 최초 Stage 계획 확정을 위한 부서별 확인 요청

- **PM 작업 ID:** PM-010 / 작성: HQ(PM) / 2026-11-01 / 버전: v0.1 / 상태: REVIEW — Owner 요청에 따른 부서별 체크리스트 PR 제출
- **근거 승인:** Owner가 Gate 3-1 진입을 승인했고, 이어서 **Stage 실제 구현은 보류**한 상태에서 이번 HQ 대화로 **계획 확정에 필요한 부서별 체크리스트 요청 문서 작성 및 PR 제출**을 명시 지시.
- **원격 기준:** `main` `5a24ddb375b5859a033055566353e932754a525e`. [Gate 2 최종 승인](../planning/PLN-001_GATE2_FINAL_APPROVAL.md), [PM-008](PM-008.md).
- **분석 근거:** [DEV-006 W01~W09](../engineering/gate3/DEV-006_DEVELOPMENT_PLAN.md), [DEV-006 인계](../engineering/gate3/DEV-006_ANALYSIS_HANDOFF.md), [DEV UI 계약 v0.2](../engineering/gate3/DEV-006_UI_DATA_CONTRACT.md), [DSG-002 결과](../design/tasks/DSG-002_RESULT.md), [DSG 표현 결정 v0.2](../design/tasks/DSG-002_UI_PRESENTATION_DECISIONS.md), [Planning 의미 재확인 #26](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6555112937).
- **기존 Issues:** [#24 Design](https://github.com/wisberry2022/MetroManager/issues/24), [#25 Development](https://github.com/wisberry2022/MetroManager/issues/25), [#26 Planning](https://github.com/wisberry2022/MetroManager/issues/26). 공개된 분석·정적 의미 수용은 유지, 실제 구현/목업/게임 AC·VP·빌드·성능·외부 사용성은 **NOT_RUN**.

## 1. 요청의 범위

- **핵심 질문:** 현재의 첫 Stage 후보(W01 실행 기반 → W02 시각·원장 및 W03 행정·노선, 최소 관찰·조작 UI)의 **범위, 선행조건, 확인 가능한 결과, 결정 주체, 차단 시점**이 충분히 특정되었는가?
- 이는 개발팀의 WBS를 **HQ가 기술적으로 확정하는 작업이 아니다**. 각 전문 부서는 기존 Gate 3-0 분석에 필요한 수정이 있는지만 자체 판단한다.
- **VS-01 공공입찰 경로 우선 및 VS-02 자체 제안 독립 경로**는 기존 제안/승인 MVP 목표를 유지. 이번 체크리스트 회신으로 VS 완주나 Stage 구현을 지시하지 않는다.
- 본 요청은 **Gate 3-1 계획 확정에 필요한 판단만 수집**한다. Stage 1 실행·Git 권한/부서별 본격 제작은 Owner의 이후 별도 결정.

## 2. 각 부서의 체크리스트

| 담당 | 링크 | 이번에 HQ가 받아야 할 최소 결과 |
|---|---|---|
| Planning | [PM-010-PLN](requests/PM-010_PLANNING_CHECKLIST.md) | 승인 규칙/두 VP 범위·해석 공백 및 필요 입력의 담당/차단 시점 |
| Design | [PM-010-DSG](requests/PM-010_DESIGN_CHECKLIST.md) | 첫 Stage의 최소 화면·목업/표현 범위·재사용·선행 입력 및 사용성 증거 |
| Development | [PM-010-DEV](requests/PM-010_DEVELOPMENT_CHECKLIST.md) | W01~W03 작업 단위·병렬/통합 순서·실행/자동 검증 증거·환경 제약 |
| INF | [PM-010-INF](requests/PM-010_INF_CHECKLIST.md) | Stage 계획과 직접 관련되는 세션 인계·연속성 위험, 필요 시 최소 대응만 |

## 3. 짧은 공통 회신 양식

> **[부서 / Gate 3-1 계획 확정 의견 / 확인 main SHA]**  
> 1. 첫 Stage 제안: READY / PENDING / BLOCKED (기존 분석 기준선과 달라지는 부분만)  
> 2. 선행·병렬 의존성: 담당 → 필요한 입력 → 최종 확인 시점  
> 3. 첫 Stage에서 입증할 결과: 관찰/자동/문서 검수 증거와 NOT_RUN 구분  
> 4. Owner 선택 필요사항: 항목/대안/언제까지 필요한지 (없으면 없음)  
> 5. 미해결 차단: 해당 작업만 차단하는지, 전체 Stage 진입을 차단하는지  
> 6. 관련 Issue/문서 URL 및 재검토가 필요한 변경 ID

- 이미 확인한 내용은 **기존 Issue/PR/SHA 링크 + '변경 없음'**으로 답할 수 있다. 부서 간 미묘한 경계만 L2 회신. 승인 규칙 변경/중대한 충돌만 L3 HQ 상정.
- 불필요한 전 부서 상호 대기 금지. Planning·Design·Development는 **병렬로 회신**, INF는 필요한 연속성 위험만 독립 회신.
- **권한 경계:** 각 부서에 Issue 댓글 회신을 요청하는 것과 Commit/Push/PR, 게임 구현·디자인 에셋 제작 권한 위임은 별개. 개별 티켓 승인·필수 Markdown/CI·Owner main Merge 규칙 유지.

## 4. HQ 통합 결과 및 종료 조건

HQ는 받은 회신을 기존 분석에 연결하여 다음만 Owner에게 제출한다.

1. 최초 Stage 후보의 **포함/제외 범위**와 1차 종료 기준.
2. 단계 의존성(선행/병렬/통합) 및 **각 차단 시점**.
3. 부서별 실제 실행 티켓으로 분리할 **결과 중심 단위**(정식 티켓 번호는 소관 부서가 관리).
4. 품질 증거·미실행 검증·반복 재검토 필요 범위.
5. Owner가 선택해야 하는 **실행/제품 규격/추가 범위 결정**만 구분한 승인 요청.

이때 HQ는 소관 부서의 아키텍처·UI/픽셀 상세·게임 규칙을 직접 결정하지 않는다. 첫 Stage 계획을 Owner가 검수하기 전까지 **실제 소스/에셋 작업은 착수하지 않는다**.

## 5. 기존 PM-009 초안과의 관계

작업 브랜치 `codex/PM-009-gate3-stage1-plan`에는 **미PR·미병합 Stage 1 제안 초안**이 존재한다. 본 PM-010은 그 초안을 `main`에 포함하거나 승인된 사실로 승격하지 않는다. **부서 회신 후 HQ가 PM-009 계획안과 불일치 사항을 대조**하고 Owner에게 실행 계획을 상정한다. PM-009는 별도 승인 없는 실제 게임 구현 권한이 아니다.
