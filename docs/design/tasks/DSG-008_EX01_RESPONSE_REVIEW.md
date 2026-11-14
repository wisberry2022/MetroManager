# DSG-008 — RFC-DSG-008-EX-01 DEV 회신 검토

- 담당: Design Track B / AGT-DSG-0003 / v0.1 / 2026-11-08
- 상태: LOCAL_REVIEW / DEV_STATIC_RESPONSE_RECEIVED / FINAL_SPEC_PENDING / NOT_DONE
- 기준 main: 4b3f73c5d8b87630cc96eb90f950761f79bb861b (PR #103 병합)
- 브랜치: codex/DSG-008-ex01-response-review
- 관련: [후속 반영 범위](DSG-008_EX01_FOLLOWUP_SCOPE.md), [결과·검증](DSG-008_EX01_REVIEW_RESULT.md)

## 1. 승인과 근거

Owner 지시:

> 개발 에이전트가 이슈 #104에 회신을 등록했으니 확인해주세요. 회신에 따른 DSG-008 후속 반영 범위와 남은 미해결 항목을 정리하고, 최종 규격은 미확정으로 유지한 채 로컬 산출물로 먼저 검토 요청해주세요.

이번 범위는 회신 검토·Design 후속 범위/미해결 정리와 로컬 검수 요청이다. Commit·Push·PR·이슈 댓글/종료·제품 코드/테스트/설정 변경·DEV 실행은 수행하지 않는다. 이전 제출/병합 승인을 새 작업의 Git 승인으로 재사용하지 않는다.

- [DEV 회신 원문](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6720694698): AGT-DEV-0001 / 2026-11-08T11:05:03Z. 확인 시 댓글1개, Issue #104 OPEN.
- DEV 판정: DEV_STATIC_RESPONSE_PROVIDED / PARTIAL_GUARD_IMPLEMENTATION_NOT_APPROVED / FINAL_SPEC_PENDING.
- DEV 정적 검토 기준과 이번 main 기준은 동일하다. [PR #103](https://github.com/wisberry2022/MetroManager/pull/103)의 과거 승인/검증·NOT_SENT 기록은 보존한다.
- [기존 예외 설계 §4](DSG-008_S01_EXCEPTION_DESIGN.md), [문구 가이드](DSG-008_S01_COPY_GUIDE.md), [UI 계약](../../engineering/gate3/DEV-006_UI_DATA_CONTRACT.md), [RFC 양식](../../templates/RFC_AND_DECISION.md)을 대조한다.
- GOV-001은 DRAFT이며 승인된 운영 원칙과 서식/세부 표현 검토 상태를 구분한다. 이 문서는 새 공식 DEC가 아니다.

## 2. 회신 검토 결과

| 항목 | 회신으로 확인한 사실 | Design 후속 반영 제안 | 남은 경계 |
| --- | --- | --- | --- |
| EX-Q01 자료 준비 | 초기 DATA 실패는 실패 화면/exit1. Session은 완전한 Dictionary를 동기 공급. S01 전체 준비/available·공개 실행ID·범용 누락 guard 없음 | 초기화 실패와 화면 일부 자료 미확인을 분리. EX-01/02/17은 현행 기능이 아닌 조건부 guard 설계로 유지 | 공급/중개 경계·필드/버전·지역 소비 계약, 부분 입력 적용·검증 필요 |
| EX-Q01 판/실행 | view_revision은 Session 표시판, current.snapshot_revision은 Pipeline 관측판, plan_revision/예측 입력판은 별도. reset_observation은 Session 생성이나 자식 소비자 전체 reset이 아님 | 서로 다른 판 번호를 직접 비교하지 않음. 같은 Session의 낡은 화면과 새 Session 지연 응답을 분리 | 새 Session/View·자식 재생성 또는 수신 귀속 대안은 DEV 검토 대상. 새 영구ID 확정 없음 |
| EX-Q02 대기 | 일반 S01 계획/시간/예측은 동기. 응찰·공사에는 실제 pending/command ID/효력 및 requests[].command/result 있음 | CP-S13/EX-16은 일반 계획/예측에서 제외. 실제 pending 경로만 조건부 참조. 접수·낙찰·계약·공정 완료 분리 | 해당 경로 연결/GUI 검수 전 적용 범위 확인. 입찰/공사 화면 재설계는 이번 범위 밖 |
| EX-Q03 보고 | READY/UNAVAILABLE/FAILED의 실제 조건 확인. UNAVAILABLE은 빈 보고이며 모든 원인 세분 API 없음 | CP-S11/EX-11은 원인 중립 안내 유지. 실제 첫날/조회 생략 문맥이 확인된 경우에만 미마감 부연 | 보고 원인/식별 guard, 부분 자료 불일치/복구 검증 필요 |
| EX-Q03 보고 식별 | display_key는 Session 런타임 범위/day이며 영구ID 아님. View 기대 실행/day 일치 guard 없음 | CP-S19/EX-19는 별도 guard 제안. 현재 보고 존재 시의 key 공급과 소비 검증을 구분 | 새 세이브·영구ID 기능 불필요. 부분 수신의 소속/날짜 검증은 미구현 |
| EX-Q03 예측 | CALCULATING 모델은 있으나 동기 _predict 안에서 끝남. View의 비실패 미가용 안내는 공통 분기 | CP-S05/EX-05는 조건부 상태 표본. 동기 제품에 인위적 대기 없음. 현재/이전·유효0 구분 유지 | 부분/불일치 입력의 소비 guard·실제 GUI 판독/행동 보존 검증 필요 |

이는 Design의 로컬 반영 제안이며 DEV 권고를 새 계약/제품 구현 완료나 Owner 규격 승인으로 바꾸지 않는다. 초기화 실패를 EX-01의 부분 복구 흐름으로 바꾸지 않으며 기존 실패 처리를 개편하는 티켓을 만들지 않는다.

## 3. 정적 근거와 해석 한계

- main._ready/_fail·Gate2DataLoader의 초기화 경계와 Stage1Session.snapshot/dispatch/_predict/request_bid/request_construction을 읽었다.
- Stage1View.present의 view_revision 역행 무시 뒤 직접 필드 접근, _render_finance/_render_activity의 지역 검사, _render_prediction의 공통 미가용 안내, reset_observation 및 Stage1Map.present의 자료 의존성을 대조했다.
- PredictionState.snapshot의 current/previous·입력판·생성시점과 DailyLedgerReport.report의 메모리 조회를 읽었다.
- DEV 회신의 입찰/공사 pending 및 자식 소비자에 대한 세부 관찰은 DEV 정적 회신 근거로 인용한다. 이번 Design이 모든 입찰/공사 경로를 실행·독립 인수했다는 뜻이 아니다.
- DEV가 인용한 기존 W07 322단언/QA-X01은 과거 증거다. 이번 회신이나 본 문서의 새 테스트 PASS로 재기록하지 않는다. 기존 HTML 489검사도 원래 정적 열람기 범위로 보존한다.

## 4. RFC 상태·후속 책임

RFC-DSG-008-EX-01의 기술 현황 설명은 수신했다. 로컬 추적 상태는 **OPEN / DEV_STATIC_RESPONSE_RECEIVED / DESIGN_FOLLOWUP_REVIEW / IMPLEMENTATION_PENDING**으로 둔다. EX-Q01~03을 모두 무응답으로 남기지 않되 전체 해결/CLOSED로 처리하지 않는다. 원격 Issue 상태/본문은 이번에 변경하지 않았다.

- EX-Q01: 현행 경계 설명 수신, 부분 자료/새 실행 guard의 계약·적용·검증 OPEN.
- EX-Q02: 동기/실제 pending 경로 설명 수신, 문구 적용 제한 제안 준비. 제품 연결·인수 미수행.
- EX-Q03: 보고/예측 공급 설명 수신, 원인 중립 표현 방향 대조. 식별·부분 입력 guard/검증 OPEN.
- DEV: 별도 실행 패킷에서 정확한 경로·계약/테스트·권한 제안. 새 DEV ID는 미배정이며 Design이 대신 발급하지 않는다.
- Design: 영향 문구/상태와 허용 행동 의존성 대조, 적용 후 표현 검수. Track A GUI 수용과 Track B 검토 구분.
- HQ: 충돌·기획/세이브 변경·추가 범위/일정 영향이 발생하면 해당 부분 조정. 이번 회신에서 새 L3 상정 사유는 발견되지 않았다.
- Owner: 후속 Git 제출·DEV 실행/구현·최종 제품 규격은 각 범위에서 별도 판단. 이번은 로컬 검수 요청이다.

**최종 글꼴·치수·최소창·배율·배치·필터·FPS·표현 상한은 미확정이다.** F-08, 제품 인수, DSG-008 전체·S2-D01·Stage DONE을 선언하지 않는다.
