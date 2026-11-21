# [HQ → Design Track B] F-08 승인 방향의 적용 준비·잔여 연결

- 수신: **AGT-DSG-0003** / 최신 갱신 PM-021 / 2026-11-21.
- 기준 main `74cd75045feb1369aa429feaec64fd3558c14813`. [이번 HQ 요청·권한](../tasks/PM-021_STAGE3_F08_DIRECTIONS.md), [Stage 3 계획](../PM-020_STAGE3_EXECUTION_PLAN.md).
- 상태: **O01_O07_OWNER_DIRECTION_APPROVED / FINAL_SPEC_PENDING / PRODUCT_APPLICATION_SCOPE_PENDING / F08_OPEN**.

## 완료한 결정과 현재 후속

[PR #157](https://github.com/wisberry2022/MetroManager/pull/157)의 RD별 심사와 [전달](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057347487), [#92 Owner 결정](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335)을 현재 근거로 사용한다. **O-01~07 모두 권고 방향 승인 완료**다. 초기 PM-020의 첫 심사·선택안 요청은 이행된 범위이며 재제출/동일 방향 재승인을 요구하지 않는다. #97 기술 종료도 유지한다.

1. 소관 선택안에 결정 링크와 후속 상태를 연결한다. 과거 LOCAL_REVIEW/미선택 원문·판정 이력을 보존하며 소관 문서 개정은 기존 유효 Git 범위에서 수행한다. HQ가 Design 원문을 대신 수정하지 않는다.
2. [승인 방향표](../PM-020_STAGE3_EXECUTION_PLAN.md#22-o-0107-owner-승인-방향과-최종-규격-잔여--pm-021)를 후보·적용 전제·필수 판독/입력 기준으로 구체화한다. **A 잠정 우선/B 비교 유지**, 정수 nearest 우선 비교/동적 문자 분리, 동일 ID 목록 대안, 역할 분리 원칙을 따른다.
3. DEV와 **공통 적용표 한 묶음**을 제출한다: O/M ID → 현재 충족·재사용/변경0 → 실제 경로·자기 티켓 → 입력/기대·최소 검증 → 담당/적용 시점 → 유효 승인/부족 범위. Track A는 기능 영향 행을 연결한다. 일정/공수는 현재 NOT_ESTIMATED다.

## 제품 적용·검수 시점

정본은 [S3-10 하위 인수표](../PM-020_STAGE3_EXECUTION_PLAN.md#61-s3-10-하위-인수적용-시점표)와 [M-01~05](../../design/tasks/DSG-008_DEV025_DESIGN_REVIEW.md)다.

| 조건 | 필요한 후속 |
| --- | --- |
| M-01: B/관련 배치 채택 전 | 전환 직후 유효 포커스 가시성·사용자 이동 존중·선택/스크롤·명령 무효과. A 유지 중 B 수정을 공통 차단으로 만들지 않음 |
| M-02: 밀집 표현/목록 변경 전 | 동일 ID·전체 이름·순서·키보드·선택·정보/편집 구분. 기존 M04 접근 재사용 후 실제 미입증 영향 행만 확인 |
| M-03: 폰트 반입/지원 규격 확정 전 | 후보 버전·권리·fallback과 실제 목표 창/배율 조건의 판독/행동 접근. 1280×720/root1은 비교 기준이며 최소 지원 보장 아님 |
| M-04: 규격 종속 아트/필터 적용 전 | 실제 크기·위상·필터·문자/포커스 선. T02 재사용 후 선택 조건의 직접 영향만 대조 |
| O-06: 실제 제품 변경 시 | DEV가 정한 최소 역할 분리·공급계약과 표현/입력 영향. 전면 리팩터링 의무 없음 |
| M-05: 목표환경·성능 인수 시 | 목표/상한 결정 시점 이월 승인 유지. 원시 Debug를 보존하고 해당 시점에 DEV 측정 조건·HQ/Owner 목표 연결 |

폰트·최소창/지원 배율·최종 필터/레이아웃·FPS는 **FINAL_SPEC_PENDING**이다. #92/F08-01~04는 OPEN 유지하며 방향 승인과 제품 적용 완료를 구별한다. 새 폰트·코드·실험·Git 권한은 기존 승인과 대조하고 실제 부족한 범위만 제시한다.

## 증거·기존 수용 유지

자동497·렌더53조건·실제 GUI7캡처·Debug22조건/2639프레임은 별도 계보다. 이번 심사는 기존 증거 검토이며 새 독립 GUI 실행이 아니다. 조건 한정 NO_ISSUE_OBSERVED/ISSUE_OBSERVED/INCONCLUSIVE·선호와 과거 실패/미확인을 보존한다. 폰트 설치 성공은 배포권, root 배율은 OS/DPI, 짧은 Debug는 최종 FPS 합격이 아니다.

[DEV-026 한정 수용·P07 구분 승인](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7057161624)과 PR #158을 유지한다. 원본 PARTIAL/미관측·W04B 미래 공급·필요한 Track A 분담/HQ 취합·S3-12/Stage 최종 인수는 별도다. 관련 변경·새 결함·증거 신뢰성 문제가 확인된 영향 행만 재개방하며 Stage 2/DEV-026/전체 T01~04 반복은 요구하지 않는다.

DEV·Track A와 한 패킷/검수표에서 주관 행을 나누고 자동·실제 GUI·Design 심사·빌드/성능을 구분한다. 문서 게시만으로 부서 숙지·실행 완료를 가정하지 않는다. 이번 HQ의 새 제품 실행은 NOT_RUN이다.
