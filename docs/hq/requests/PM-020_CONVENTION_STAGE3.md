# [HQ → Convention] Stage 3 제출·재현 검사 지원 요청

수신: Convention Team / **AGT-DEV-0002**. Git·CI·공용 검사 정책 소관.
최초 요청(2026-11-15) 상태: **OWNER 전달용 요청안 / PLAN_REVIEW**. 당시 기준 main `96c51ae6c3352195b9a8e8b89f92dd51c13be81c`. [Stage 3 공통 계획](../PM-020_STAGE3_EXECUTION_PLAN.md)·[Owner 요청/Git 범위](../tasks/PM-020_STAGE3_ENTRY_PLAN.md)를 함께 읽는다. Stage 2 DONE은 유지하며, 실제 새 제작/검증/Git은 자기 티켓의 유효한 개별 승인 범위에서 수행한다. 기존 유효 승인을 재사용하고 부족한 범위만 제시한다. 이 파일 게시가 자동 전달·숙지 완료 또는 새 포괄 권한 부여는 아니다.

## PM-021 최신 적용 — 2026-11-21

기준 main `74cd75045feb1369aa429feaec64fd3558c14813`. [Owner O-01~07 승인](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335) / [계획 §2.2](../PM-020_STAGE3_EXECUTION_PLAN.md#22-o-0107-owner-승인-방향과-최종-규격-잔여--pm-021) / [S3-10 하위 인수표](../PM-020_STAGE3_EXECUTION_PLAN.md#61-s3-10-하위-인수적용-시점표).

**방향 승인 완료 / FINAL_SPEC_PENDING / PRODUCT_APPLICATION_SCOPE_PENDING**. DEV-025 공급·Track B 심사는 완료, #97 기술 종료 유지, #92 OPEN이다. A 잠정 우선/B 비교 유지이며 최종 폰트·지원 창/배율·필터/배치·FPS를 이번 방향 승인으로 확정하지 않는다. 아래 초기 요청은 이미 제출·수용된 부분을 다시 요구하지 않고 실제 남은 범위에만 적용한다.

이번 부서 후속: **실제 제출·검사 도구의 공백이 제기될 때만 지원한다. 기존 필수 CI와 REPORT_ONLY 경계를 유지하며 F-08 전용 CI·벤치마크를 선행 의무로 만들지 않는다. 공백이 없으면 추가 작업 없음.**

현재 DEV-026의 [한정 수용·P07 구분 승인](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7057161624)과 PR #158은 유효하다. 원본 PARTIAL/미관측·W04B 미래 공급·필요한 분담 수용·S3-12/Stage 최종 인수는 별도다. 이 문서는 기존 유효 개별 실행/Git 승인을 재사용하며 새 포괄 권한을 부여하지 않는다.

## 필요한 경우 지원할 범위

1. 새 W04B/RNG·DEV-026 관측/실행 소속·명령 재현 증거를 기존 검사/출처 보고에 연결할 때 실제 지원 공백이 있는지 DEV 요청 범위에서 확인한다. 공백이 없으면 기존 도구를 재사용하며 Stage 3 전용 CI 개편을 선수조건으로 만들지 않는다.
2. 작업 브랜치·단일 부모/검증된 base-sync·부서 경로·정상 훅·fetch/preflight, main 필수 policy/department-policy를 유지한다. 실패를 훅 해제·force push·CI 완화로 우회하지 않는다.
3. provenance REPORT_ONLY와 실제 신원/Owner 승인 인증을 구별한다. 새 RNG의 게임 정책/seed·난수 소비 의미는 DEV/Planning 소관이다. 도구 지원이 필요한 재현 형식·검사 범위만 협의한다.
4. INF-009 통상 인계 간소화와 DEV-017/root/provenance의 미결 도구 계약을 구별한다. 과거 자동화의 상세 승인 단계 때문에 정상 수동 인계를 일괄 막지 않는다. 실제 검사 차단이 확인되면 해당 원인·영향·복구안만 제시한다.

## 산출물·차단 경계

필요 시 **현재 도구 재사용 / 실제 수정 필요 / 정책 결정 필요**를 나눈 한 회신과 정확한 자기 티켓·경로·검증/권한 범위를 제출한다. 개정은 별도 유효 Owner 승인 후 수행한다. 실제 공백이 없는 경우 '기존 규칙 사용, 추가 작업 없음'으로 끝낼 수 있다.

최종 제품 FPS·폰트/아트 규격·GUI 수용·Stage DONE을 Convention이 확정하지 않는다. 정책/등록부/CI 수정·ENFORCE 활성화·배포는 본 요청의 실행 범위가 아니다. 신규 검사/도구 실행은 수행 사실에 따라 기록하고 NOT_RUN을 유지한다.
