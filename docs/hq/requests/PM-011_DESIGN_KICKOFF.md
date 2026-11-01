# PM-011-DSG — Design Gate 3-2 Stage 1 착수 요청

- **수신:** Art Director & UI/UX Designer.
- **참조:** [DSG-002 Gate 3-1](../../design/tasks/DSG-002_GATE3_1_DESIGN_STAGE_PLAN.md), [DSG 표현 결정](../../design/tasks/DSG-002_UI_PRESENTATION_DECISIONS.md), [Issue #24](https://github.com/wisberry2022/MetroManager/issues/24).
- **상태:** Gate 3-2 소관 착수 요청 / Stage 1 **승인 계획 입력**. 이번 HQ PR은 부서별 작업 Commit/Push/PR·main Merge 또는 게임 코드/아트 제작의 포괄 승인 문서가 아니다.
- **필독:** [Owner 승인된 Stage 1](../PM-011_GATE3_2_APPROVED_PLAN.md), [협업·검증 절차](../PM-011_GATE3_2_EXECUTION_PROTOCOL.md), [PM-008](../PM-008.md), 최신 `main`의 `AGENTS.md`·`docs/engineering/DEPARTMENT_WORKFLOW.md`·부서 README. 각 부서는 실제 착수 전에 최신 main SHA 확인.
- **간단 회신:** 소관 실행 티켓 후보/단계, 포함·제외, 첫 검증 증거, 선행·공급/소비 및 차단 시점, L1/L2/L3, Owner가 승인할 작업 경로/브랜치/Commit·Push·PR·유효조건, 미해결 여부. 기존 분석 링크로 중복 내용 대체.

## 최초 착수의 우선순위

1. **DSG-S1-01~04** 중 W01/W02/W03과 병렬로 준비할 **S01 최소 정보 구조·상태/사유·시간 HUD/읽기 전용 장부/지도·목록/예측** 범위를 소관 실행 티켓 후보로 분리한다.
2. 실제 저충실도 목업/상태 표현이 필요한 최소 결과와 신규 에셋/후속 고충실도 범위를 분리한다. 재사용 대상은 아직 존재하지 않는 PNG가 아니라 기존 **DD-01~08 설계 패턴**이다.
3. Stage 1 최소 UI에는 **정지·재개/1·2·4배속 실제 조작**, 12역·6/8 선택 및 비정상/오류 원인, 예측 READY=0/미산출/실패/이전값, 현재 자금·과거 마감 상태 관찰이 포함된다. 기술 데이터/판정은 DEV가 공급한다.
4. 지도/목록 동등 조작, 12역 밀집·읽기/대체 조작·오류 복구의 **실제 조작 검수 기준**과 필요한 DEV 입력(안정 ID, snapshot, allowed_actions/reason_codes, 예측 revision)·공급 시점을 정리한다.
5. 대상 PC·뷰포트/폰트/배율·FPS·표시 상한과 외부 사용성 표본·비용은 **결정 시점 및 필요한 선택 대안**만 별도로 제안한다. `1280×720`·`40px` 등 임시 시안을 제품 확정값으로 사용하지 않는다.

## 요청된 첫 결과

- 첫 최소 화면/상태 시안의 **소관 DSG 실행 티켓 후보와 검증 기준**, DEV의 공급/목업 검증 의존성 및 Owner 작업별 제작·Git 권한 승인 요청.
- 개발팀의 W01 실행/모델 자동검증을 기다려야만 할 일이 아닌 UI 정보구조·재사용 설계는 **승인된 범위에서 병렬 준비**하고, 실제 화면 통합만 데이터/명령 fixture 공급을 전제로 한다.
- 이번 요청으로 고충실도 이미지·에셋 대량 제작/게임 코드 변경이나 제품 해상도·기획 수치·행정 규칙을 독단 확정하지 않는다. **디자인 판단과 인수는 디자인팀 소관**이다.
