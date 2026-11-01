# PM-011-DEV — Development Gate 3-2 Stage 1 착수 요청

- **수신:** Development / Project Leader (Godot 구현·테스트).
- **참조:** [DEV-006 Gate 3-1](../../engineering/gate3/DEV-006_GATE3_1_ANALYSIS.md), [W01~W09](../../engineering/gate3/DEV-006_DEVELOPMENT_PLAN.md), [UI 계약 v0.2.1](../../engineering/gate3/DEV-006_UI_DATA_CONTRACT.md), [Issue #25](https://github.com/wisberry2022/MetroManager/issues/25).
- **상태:** Gate 3-2 소관 착수 요청 / Stage 1 **승인 계획 입력**. 이번 HQ PR은 부서별 작업 Commit/Push/PR·main Merge 또는 게임 코드/아트 제작의 포괄 승인 문서가 아니다.
- **필독:** [Owner 승인된 Stage 1](../PM-011_GATE3_2_APPROVED_PLAN.md), [협업·검증 절차](../PM-011_GATE3_2_EXECUTION_PROTOCOL.md), [PM-008](../PM-008.md), 최신 `main`의 `AGENTS.md`·`docs/engineering/DEPARTMENT_WORKFLOW.md`·부서 README. 각 부서는 실제 착수 전에 최신 main SHA 확인.
- **간단 회신:** 소관 실행 티켓 후보/단계, 포함·제외, 첫 검증 증거, 선행·공급/소비 및 차단 시점, L1/L2/L3, Owner가 승인할 작업 경로/브랜치/Commit·Push·PR·유효조건, 미해결 여부. 기존 분석 링크로 중복 내용 대체.

## 최초 착수의 우선순위

1. **W01 먼저:** 기존 승인 데이터/회사 초기 상태·안정 ID와 Godot 메인 진입/자동검사 기반을 **구현 가능한 최소 단위**로 분할해 정식 DEV 실행 티켓과 Owner 승인 요청을 제출한다. 별도 메뉴·범용 프레임워크 신설은 필수가 아니다.
2. **W02-A/B, W03-A/B:** W01 선행 출력이 무엇인지, 독립 테스트/병렬 브랜치가 가능한 경계를 지정한다. **W02의 시각·자금 공통 회귀 영향** 및 실패 시 차단 범위를 티켓에 구체적으로 기술한다. 이미 승인된 SEM/CLOSE는 임의 변경하지 않는다.
3. **UI 최소 공급:** DSG가 필요한 `simulation_minute/day_id`, snapshot·상태/허용행동·관할·역 선택/예측 revision·오류 fixture와 공급 시점을 묶어, **해당 화면 통합 전에** 협의한다.
4. **검증 분리:** headless 편집기 로드, 규칙 자동/회귀, 실제 GUI 실행과 시간·지도/목록 조작, Windows export/성능을 각각 다른 증거로 구분한다. Stage 1은 자동 규칙+최소 GUI 실제 조작이 필수, 후속 Windows export/전체 VP는 별도.
5. **반례 유지:** 동일 T 계약 당시 자금·후순위 운임 선사용 금지, R/K 보호·B 자동 정산·자정 보고 불변, 승인된 6/8역과 비정상 경로·예측 상태의 최소 자동 검증을 티켓 완료 기준에 연결한다.

## 요청된 첫 결과

- 작업 ID 중복 확인 후 **W01 최초 실행 티켓/Issue와 Owner 권한 요청**을 먼저 제출하고, 이후 W02/W03 분할·독립 검증·통합 순서를 간결히 제안.
- 티켓별 **실제 소스 경로·브랜치·검증 명령/결과 증거·Commit/Push/PR 각각의 승인 범위**를 지정한다. 개발 소스/공통 파일 소유 경계는 DEV가 기존 정책과 함께 직접 확인한다.
- Owner가 해당 실행 티켓을 명시 승인하기 전에는 새 게임 코드·Scene·설정·공통 CI 변경/원격 쓰기를 착수 승인으로 간주하지 않는다.
- **게임 기술/아키텍처/Godot 패턴 선정은 개발팀의 책임**이다. HQ에 엔진 세부 결정이나 범용 리팩토링 승인을 요청하지 말고 기존 승인 범위와 충돌하는 경우만 상정.
