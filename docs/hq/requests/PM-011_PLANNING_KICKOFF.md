# PM-011-PLN — Planning Gate 3-2 Stage 1 착수 요청

- **수신:** Game Designer / Planning (후임 담당).
- **참조:** [PLN-002 Gate 3-1](../../planning/tasks/PLN-002_RESULT.md), [Gate 2 승인 원본](../../planning/PLN-001_GATE2_FINAL_APPROVAL.md), [Issue #26](https://github.com/wisberry2022/MetroManager/issues/26).
- **상태:** Gate 3-2 소관 착수 요청 / Stage 1 **승인 계획 입력**. 이번 HQ PR은 부서별 작업 Commit/Push/PR·main Merge 또는 게임 코드/아트 제작의 포괄 승인 문서가 아니다.
- **필독:** [Owner 승인된 Stage 1](../PM-011_GATE3_2_APPROVED_PLAN.md), [협업·검증 절차](../PM-011_GATE3_2_EXECUTION_PROTOCOL.md), [PM-008](../PM-008.md), 최신 `main`의 `AGENTS.md`·`docs/engineering/DEPARTMENT_WORKFLOW.md`·부서 README. 각 부서는 실제 착수 전에 최신 main SHA 확인.
- **간단 회신:** 소관 실행 티켓 후보/단계, 포함·제외, 첫 검증 증거, 선행·공급/소비 및 차단 시점, L1/L2/L3, Owner가 승인할 작업 경로/브랜치/Commit·Push·PR·유효조건, 미해결 여부. 기존 분석 링크로 중복 내용 대체.

## 최초 착수의 우선순위

1. **승인 규칙 입력 지원:** W01 초기 상태/버전·W02 게임 시각/자금·W03 행정/12역/노선·OD 예측에 대해, 개발·디자인이 실제로 요청한 의미/반례만 해당 Gate 2 기능 ID/AC·DATA 기준에 연결해 간결히 회신한다.
2. **기존 합의 보존:** PLN-R01~05의 `NO_RULE_CHANGE_REQUIRED`, 계약 단계의 자금 검증과 후순위 운임, 동일 T 정산·탑승, R/K 보호, 관할 권위 ID와 디자인 도형의 분리 원칙을 유지한다. 재검토 대상은 **실제 새 차이가 발견된 규칙/행**에 한정한다.
3. **Stage 1 부분 인수:** DEV 자동 규칙/fixture와 DSG 최소 화면이 **승인 규칙 의미를 벗어나지 않는지** 검토할 기준을 제시한다. 아직 실제 E2E·전체 AC/VP는 NOT_RUN으로 구분하며, 단지 기획 수치의 재설계를 목적으로 반복 검토하지 않는다.
4. **VS 경계:** 최초 Stage에 W04~06 및 VP-01/02 완주 의무를 앞당기지 않는다. 후속 **VS-01 공공입찰 / VS-02 자체 제안** 독립 검증 의무는 계속 보존한다.
5. **질의 라우팅:** 기술 API·Godot 구현은 DEV, 화면 배치·픽셀 규격은 DSG의 판단을 존중한다. 기존 정책을 준수하는 수정은 L2 의미 확인, 실제 승인 규칙·MVP 범위 변경이나 심각한 충돌만 근거·대안과 함께 HQ에 L3 요청한다.

## 요청된 첫 결과

- 독립적인 기획 기능 변경 없이 충분하다면 **“NO_RULE_CHANGE_REQUIRED / 지원 가능한 승인 fixture·ID / 요청 발생 시 검토”**로 간결히 회신한다.
- 개발·디자인의 전문적 세부 작업을 Planning이 대신 확정하거나 해당 부서의 매 PR에 반복 서명하는 절차를 만들지 않는다.
- 실제 기획 문서 개정이나 Git Commit/Push/PR이 필요한 경우에만 구체적인 **PLN 실행 티켓·수정 경로·승인 동작/유효기간**을 Owner에게 별도 요청한다.
