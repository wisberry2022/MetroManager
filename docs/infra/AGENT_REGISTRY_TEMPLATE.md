# Agent Registry — Schema / Empty Template

- ID: INF-REG-TEMPLATE / v1.0 / 상태: TEMPLATE_ONLY
- 소유: INF / 전환 확인: PM / 인사·권한 승인: Owner
- **이 파일은 실제 4부서 평가 결과나 담당 세션 식별자를 기록하지 않는다.**

| 역할·실제 세션 범위 | 내부 Agent ID(공개 시 가명) | 활성 담당 여부 | 최근 점검 ID/일자 | 상태 | 인계 ID | 기준 SHA |
|---|---|---|---|---|---|---|
| PM / 지정 세션 | TBD | NOT_VERIFIED | | NOT_ASSESSED | | |
| Planning / 지정 세션 | TBD | NOT_VERIFIED | | NOT_ASSESSED | | |
| Design / 지정 세션 | TBD | NOT_VERIFIED | | NOT_ASSESSED | | |
| Development / 세션·환경별 별도 행 | TBD | NOT_VERIFIED | | NOT_ASSESSED | | |

## 필드 규칙
- Agent ID는 Owner가 승인한 세대·역할 식별로 확정하며 세션 URL·대화 제목만으로 고정하지 않는다.
- 상태: `NOT_ASSESSED, NORMAL, WATCH, PREPARE_HANDOFF, RECOMMEND_REPLACEMENT, HANDOFF_IN_PROGRESS, RETIRED`.
- 점수/세부 오류·내부 URL 등 민감한 진단 정보는 공개 등록부에 포함하지 않는다.
- 인계는 Owner 최종 담당 전환·PM 시점 확인·INF 수용 검증이 모두 끝난 후 활성화한다.
- 세대 변경마다 이전·새 Agent ID, 전환 승인, 공개된 근거 SHA, 후임 수용 ID, 최종 담당 범위를 남긴다.
- 실제 개발 세션이 여러 환경·스레드로 나뉘면 각각 별도 행을 둔다.

## 변경 이력
| 일시(KST) | 공개 상태 변경 | 승인 근거·확인 SHA | 작성자 |
|---|---|---|---|
| | | | |
