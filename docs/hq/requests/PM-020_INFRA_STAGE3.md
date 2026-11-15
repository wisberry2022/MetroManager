# [HQ → INF] Stage 3 연속성·원본 이월 지원 요청

수신: **AGT-INF-0002**. 컨텍스트 연속성·등록/인계 정합성·원본 복구 지원 소관.
상태: **OWNER 전달용 요청안 / PLAN_REVIEW**. 기준 main `96c51ae6c3352195b9a8e8b89f92dd51c13be81c`. [Stage 3 공통 계획](../PM-020_STAGE3_EXECUTION_PLAN.md)·[Owner 요청/Git 범위](../tasks/PM-020_STAGE3_ENTRY_PLAN.md)를 함께 읽는다. Stage 2 DONE은 유지하며, 실제 새 제작/검증/Git은 자기 티켓의 유효한 개별 승인 범위에서 수행한다. 기존 유효 승인을 재사용하고 부족한 범위만 제시한다. 이 파일 게시가 자동 전달·숙지 완료 또는 새 포괄 권한 부여는 아니다.

## 요청 범위

1. Stage 2 [최종 결정](https://github.com/wisberry2022/MetroManager/issues/141#issuecomment-6892772104), 현재 승인 명세/티켓, DEV-025 공급/Design 대기, DEV-026의 **Stage 3 범위 확정/착수 준비 대기**(과거 HOLD와 구별), Stage 3 준비 요청서의 참조를 인계 시 연결한다. 새 전체 인계 패키지·전원 재시험을 요구하지 않는다.
2. [INF-009 간소화 전환 규정](../../infra/agents/REGISTRY_TRANSITION_RULES.md)을 유지한다. 통상 Owner 전환 지시+후임 인수 확인으로 처리하며 반복 INF 수용시험·PM 확인·Owner 재승인 대기를 부활시키지 않는다. 실제 미반영 ID/권한 충돌·필수 정보 누락만 영향 범위로 보고한다.
3. [#139 Owner 결정](https://github.com/wisberry2022/MetroManager/issues/139#issuecomment-6891629210)의 현재 로컬 정본·Owner 보관 담당과 원본+#138 정정+#141을 함께 연결한다. 다른 사용 사본 없음은 Owner 확인 범위이고 모든 기기 조사 결과가 아니다.
4. 백업/복구는 **OWNER_APPROVED_DEFERRED / NO_BACKUP_REPORTED / RESTORE_NOT_RUN / NOT_SCHEDULED**로 유지한다. 다음 원본 재사용/인계 때 이월을 전달·재확인하고, Owner가 대상/접근/담당/일정을 정하면 비파괴 복구·해시 증거를 지원한다. 그 전에 복구 완료를 Stage 3 진입 조건으로 추가하지 않는다.

## 회신·권한 경계

정상 연속성이 유지되면 기존 근거 링크로 짧게 확인하고 추가 진단 보고를 만들 필요가 없다. 실제 문제 발생 시 **영향 작업/자료·확인/추정·최소 복구·담당·미실행**만 한 묶음으로 제출한다. 사후 신원/DPI/도구 바이트 인증이나 없는 과거 증거 생성은 금지한다.

INF는 게임 의미·디자인·구현·Git/CI 정책·HQ Stage 결정을 대행하지 않는다. 새 ID 발급/등록 수정·자동화·권한 변경·원본 이동/삭제/백업 실행을 이 요청으로 포괄 승인하지 않는다. F-12 회고 주관은 HQ이며 Convention 기술 지원은 실제 필요할 때 연결한다.
