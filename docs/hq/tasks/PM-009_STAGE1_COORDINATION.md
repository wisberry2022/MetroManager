# PM-009 — Gate 3-1 최초 Stage 계획 수립·PR 제출 티켓

- ID: **PM-009** / 담당: HQ(PM) / 2026-11-01 / 상태: **REVIEW**.
- 기준 main: `5a24ddb375b5859a033055566353e932754a525e`
- Owner 승인 원문: “피드백 확인하였습니다. 에이전트의 요구대로 3-1 단계 진입을 OWNER가 승인합니다. 요청한대로 최초 Stage의 범위/부서별 작업 의존성/검증 조건 확정을 담은 PM 산출물을 생성하여 PR 생성해주세요.”
- 승인된 작업 행위: **PM-009 HQ 문서 작성과 `codex/PM-009-gate3-stage1-plan` 작업 브랜치 Commit/Push/PR**, 원격 필수 CI 확인. **main 병합·부서별 실제 구현·게임 기능 정책 변경·릴리스 권한은 미포함.**
- 작업 브랜치: `codex/PM-009-gate3-stage1-plan`
- 연관: [PM-008](../PM-008.md), [Stage 1 계획](../PM-009_STAGE1_PLAN.md), [결과](PM-009_RESULT.md), 분석 Issue [#24](https://github.com/wisberry2022/MetroManager/issues/24) / [#25](https://github.com/wisberry2022/MetroManager/issues/25) / [#26](https://github.com/wisberry2022/MetroManager/issues/26).

## 목적
Owner가 승인한 **Gate 3-1 진입** 이후 개발 W01~W03, 디자인 S01/P03 및 기획 규칙 지원을 통합해 **Stage 1 실제 실행 범위와 의존성·품질 게이트를 검수 가능한 PM 산출물**로 제출한다.

## 포함
- 최초 Stage의 목표/포함·제외 범위, VS-01/02와의 경계.
- 소관별 제안 작업 매핑과 선행·병렬·차단 조건.
- Stage 1 수용 S1-AC01~09와 미실행 구분.
- 기획 승인 불변, UI-DC 정적 수용과 실제 검증의 차이, 남은 G3 이월 책임.
- Owner의 Stage 실행·부서별 Git 권한 결정을 **별도** 요청하는 의사결정 표.

## 제외
- 실제 게임 코드·Scene/아트 제작, UI 데이터 엔진 API 확정, 기획 수치·MVP 범위 변경, 타 부서 소유 문서 수정.
- Github Issue #24·25·26을 독단 완료 처리, 새로운 개발/디자인 티켓의 승인 대행.
- `main` 직접 수정/병합, 릴리스·배포.

## 수용 기준
1. 기준 `main` 및 PR #30/#31·Planning #26 인계 근거 정확.
2. W01→W02/W03→최소 UI의 의존성, 담당·허용 병렬성이 명확.
3. S1-AC의 최소 실제 실행·테스트 증거가 포함되고 AC-01~10/VP-01·02 전체 합격과 혼동하지 않음.
4. Owner가 추가 결정해야 할 Stage 실행 범위·권한·제품 미확정 규격을 별도 구분.
5. 신규 HQ 경로 파일만 PR 제출, `policy` 및 `department-policy` 상태를 원격 근거로 보고.
