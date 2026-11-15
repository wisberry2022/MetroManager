# [HQ → Design Track B] DEV-025 결과 심사·F-08 선택안 요청

수신: **AGT-DSG-0003**. 이번 첫 우선 업무는 공급된 DEV-025의 시각·정보 보존 심사다.
상태: **OWNER 전달용 요청안 / PLAN_REVIEW**. 기준 main `96c51ae6c3352195b9a8e8b89f92dd51c13be81c`. [Stage 3 공통 계획](../PM-020_STAGE3_EXECUTION_PLAN.md)·[Owner 요청/Git 범위](../tasks/PM-020_STAGE3_ENTRY_PLAN.md)를 함께 읽는다. Stage 2 DONE은 유지하며, 실제 새 제작/검증/Git은 자기 티켓의 유효한 개별 승인 범위에서 수행한다. 기존 유효 승인을 재사용하고 부족한 범위만 제시한다. 이 파일 게시가 자동 전달·숙지 완료 또는 새 포괄 권한 부여는 아니다.

## 검토 정본과 현재 상태

[PR #143](https://github.com/wisberry2022/MetroManager/pull/143) head `8bd236957f5adcf50aeb418cbaa617779eb8241a`, merge `dc3c049134fb45764560e47116b3332bc2f5624d`의 [상세 보고](../../engineering/evidence/DEV-025_F08_REPORT.md)·[실행 JSON](../../engineering/evidence/DEV-025_F08_VALIDATION.json)·[원시 CSV](../../engineering/evidence/DEV-025_F08_PROFILE.csv)와 기존 [공통 샘플/RD 기준](../../design/tasks/DSG-008_DEV025_SAMPLES.md)을 사용한다. **실험 공급은 완료**, 현재 **Design 판정 대기·최종 규격 미확정**이다. #92/#97의 최초 미실행 표현으로 되돌리지 않는다.

## 필요한 심사·산출물

1. T01~04를 F08-01~04·RD-01~08에 대응하고 기존 같은 조건/원본 해시를 대조한다. 판정은 **NO_ISSUE_OBSERVED(조건 한정) / ISSUE_OBSERVED / INCONCLUSIVE / NOT_RUN**, 선호는 PREFERENCE로 분리한다.
2. 특히 **RD-03/07: B 배치 전환 직후 포커스 가림, 겹친 마커의 목록 대체 접근·읽기 순서**를 실제 입력 증거로 심사한다. 격리 배치에서 본 문제를 기존 제품 전체 결함으로 확대하지 않는다. 필수 근거가 부족하면 해당 case/입력/최소 추가 증거만 지정한다.
3. 폰트·최소창/지원 배율·픽셀/문자 필터·A/B 배치·마커/입력·Theme/재사용·측정 조건별로 **수용 근거 / 보완 / 권고 / Owner 선택 / 제품 적용 전 남을 검증**을 제시한다. 수치 후보를 최종 규격으로 채택하지 않는다.
4. [#92](https://github.com/wisberry2022/MetroManager/issues/92)를 심사/선택안 정본 창구로, [#97](https://github.com/wisberry2022/MetroManager/issues/97)을 공급·보완 추적으로 재사용할 회신을 준비한다. 기존 유효 게시/Git 권한에 포함되는 작업만 수행하며 새 문서/제품/폰트 반입은 정확한 범위로 제출한다.

## 검증·소유 경계

자동497·스크립트 렌더53조건·실제 GUI M01~M06/7캡처·Debug22조건/2639프레임은 서로 다른 증거다. 53조건을 실제 GUI53회로 합산하지 않는다. 설치된 시스템 폰트의 표시 성공은 배포 권리/export 보장이 아니며, 현재 짧은 Debug 관측을 최종 FPS 합격으로 만들지 않는다. 브라우저 비교를 Godot 실측으로 대신하지 않는다.

새로운 독립 실행이 필요한 행만 실행자·허용 범위·고정 조건을 명시한다. 기존 자료로 판정 가능한 행부터 심사하며 DEV 실험 전체를 재공급/재실행하도록 요구하지 않는다. 피드백은 한 묶음으로 제출한다.

DEV-026/#104는 **HOLD 유지**. RP-01~08의 현재 공급/영향·기존 수용을 준비 대조하되 제품 구현 완료나 재개 승인으로 표현하지 않는다. Track A의 기능 GUI와 중복 판정하지 않으며 후속 제품 적용에는 실제 변경 행·소유·검증 경계를 합의한다. 첫 회신은 **RD 판정표·최소 보완 목록·Owner 선택안·적용 시점**이다.
