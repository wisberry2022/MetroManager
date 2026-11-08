# DSG-008 — S01 안내·오류 문구 정리

- 담당: Design / Track B / AGT-DSG-0003 / v0.1 / 2026-11-08
- 상태: REVIEW / OWNER_GIT_SUBMISSION_APPROVED / STATIC_COPY_PROPOSAL / FINAL_SPEC_PENDING / NOT_DONE
- 기준 main: 8a9515a781e8864de211df0ece3a52568df1154a (PR100 병합)
- 브랜치: codex/DSG-008-s01-copy-exceptions
- 표본: [문구 JSON](../assets/source/dsg_008/copy_exceptions/s01_copy_catalog.json) / [정적 열람기](../assets/source/dsg_008/copy_exceptions/s01_copy_review.html)
- 관련: [예외 설계](DSG-008_S01_EXCEPTION_DESIGN.md), [이번 결과](DSG-008_S01_COPY_EXCEPTIONS_RESULT.md), [기존 상태표](DSG-008_S01_STATE_FLOW.md), [UI 의미 계약](../../engineering/gate3/DEV-006_UI_DATA_CONTRACT.md)

## 1. 승인·범위·제외

Owner 직접 지시:

> PR #100을 승인하여 main에 머지했습니다. 다음으로 S01 안내·오류 문구 정리와 미수신·예외 상태의 정적 설계 보완을 진행해주세요. 최종 규격은 미확정으로 유지하고 로컬 산출물로 먼저 검토 요청해주세요.

S01 안내·오류 문구와 미수신/예외 표시 설계를 신규5개 로컬 파일로 작성한다. 기존1단계/DEV025 입력/DSG006 보관 산출물·승인·검증 기록은 수정하지 않는다. 게임 소스·씬·테마·설정·명령/계산·타 부서 문서·기획 규칙·최종 규격을 변경하지 않는다. 최초 로컬 검수 단계에서는 신규 Commit·Push·PR·외부 전달·main 병합·릴리스·배포를 수행하지 않았다.

후속 Owner 제출 승인 원문:

> DSG-008 S01 문구·예외 설계 산출물 5개의 커밋·푸시 및 PR 생성을 승인합니다. 미해결 기술 협의와 NOT_RUN, 최종 규격 미확정 상태를 명시하고 main 병합은 하지 마세요.

대상은 wisberry2022/MetroManager, DSG-008, codex/DSG-008-s01-copy-exceptions 브랜치의 결과서 목록 신규5개로 한정한다. 이번 제출의 Commit·Push·PR 생성과 관련 검증만 승인되었다. main 병합·자동 병합·릴리스·배포·강제 푸시·정책/타 부서/제품 수정은 범위 밖이다. 새 RFC의 DEV 발송·회신·합의도 이번 제출 완료와 구분하며 NOT_SENT를 유지한다. 이 승인은 최종 규격 승인이나 DONE이 아니다.

최종 글꼴·치수·최소창·배율·배치·필터·FPS·표현 상한은 미확정이다. 문자열 제안 검토와 실제 게임 적용·가독성/접근성 인수를 구분한다.

## 2. 근거 수준

제출 기준 main은 58bbde35bed88df9138b40d13588fe7382127a30이다. 분석·정적 표본의 원래 기준 8a9515a781e8864de211df0ece3a52568df1154a와 과거 검증 기록은 보존한다. 중간 INF-007 등록과 DEV-021 공사 UI 추가를 비교했으며, 참조한 S01 계획 명령/18사유·재무·예측·보고 핵심 분기는 유지되어 있다. 신규 공사 화면 설계나 실행 검증으로 범위를 넓히지 않는다. JSON/HTML 원본과 기존 브라우저 검증 대상은 변경하지 않았다.

기준 SHA의 stage1_view.gd·stage1_session.gd·route_plan.gd·prediction_state.gd·demand_predictor.gd를 정적으로 읽었다. JSON의 CP/R/EX ID는 디자인 추적 ID이며 새 엔진 enum·필드 계약·상태 기계 구현이 아니다.

| evidence | 의미 |
| --- | --- |
| CODE / CODE_MEANING | 현재 코드의 상태/사유/guard 또는 당시 명령결과 의미. 이번 실행 PASS가 아님 |
| CODE_FIXTURE_ONLY_FOR_OUTSIDE | 관할 오류 코드 존재. 현재12후보를 타관할로 만들지 않음 |
| EXISTING_DISPLAY_FIXTURE | 기존 유효0 예시. 실제 예측 실행값으로 재분류하지 않음 |
| MODEL_STATUS_PRODUCT_TRANSIENT_UNVERIFIED | CALCULATING 모델 상태 존재, 동기 Session 사이 제품 표시 미검증 |
| CONTRACT_ONLY / CONTRACT_GUARD_PROPOSAL | 계약상 의미/필요 guard의 정적 제안. 부분 Dictionary 처리 구현 주장 아님 |
| DESIGN_WORDING_PROPOSAL | 현행 표현을 대체할 문장 초안 |
| REVIEW_DIAGNOSTIC_NOT_PRODUCT_BANNER | 검토자 설명용. 제품 배너 자동 추가 대상 아님 |

정적 차이·적용 전 질문은 예외 설계의 로컬 RFC에 연결한다. 게임 실행 없이 제품 결함을 단정하거나 신규 기능을 구현하지 않는다.

## 3. 문장 구성·용어

기본 구성은 **현재 상태 또는 당시 결과→확인된 원인/대상→공급이 허용한 다음 행동**이다. 원인이 없으면 추정하지 않는다. “다시 시도하세요”만 반복하거나 색상만으로 성공/실패를 구분하지 않는다.

| 의미 | 표현 방침 | 피할 표현 |
| --- | --- | --- |
| 미수신 | 자료를 확인하지 못했습니다 / 현재 자료 없음 | 수치0·후보0·파산으로 치환 |
| 미계산 | 예측을 아직 계산하지 않았습니다 | 예측0·실적0 |
| 유효0 | 현재 입력의 유효 예측 / 숫자0·단위·기간 유지 | 자료 없음·운영비까지0 |
| 조회/계산 실패 | 실패 사실·현재 결과 없음·실제 사유 | 보고 없음·유효0 |
| 빈 계획 | 계획에 포함된 역이 없습니다 / 선택0역 | 지도 미수신·후보 없음 |
| 편집 잠금 | 현재 계획을 편집할 수 없습니다 / 포함역 정보 열람 | 미공급 계약·공사·시간정지 원인 창작 |
| 현재/이전 | 현재 입력 / 이전 입력의 예측·비교용 | 이전값으로 현재 입력판정 |
| 당시 수락/거부 | 당시 요청이 처리됐습니다 / 당시 요청은 처리되지 않았습니다 | 현재 행동까지 성공/불가로 고정 |
| 실제 대기 | 실제 접수 확인이 있을 때만 요청 결과 확인중 | 클릭·전송 의도를 접수·성공으로 표시 |
| 알 수 없는 사유 | 안내 내용을 확인하지 못했습니다 | 내부 코드만 제품 설명으로 노출 |
| 낡은 화면 응답 | 최신 화면 유지, stale은 진단으로 분리 | 요청 거부·전역 잠금으로 표시 |

금액은 공급 정수·단위 그대로 표기하고 합계 재계산·반올림·지수 치환을 하지 않는다. 현재 C/R/F/K/A/B·당일 발생/즉시지급/정산/총현금지급·과거보고는 출처·기간을 분리한다. R/K 중복 차감이나 B 자체의 신규 계약 금지 문구를 만들지 않는다.

예측은 실제 공급의 반열린 기간·입력판·생성게임시각과 함께 표시한다. 기존0 예시는 [1일06:00,2일06:00), 끝 제외, 운영비108000·거리5km·종단9게임분이다. “하루”를 자정까지로 바꾸지 않는다. 실제 없는 영구 보고ID를 만들지 않는다.

## 4. 문구 카탈로그

JSON에 **사유18종 CP-R01~18 + 상태/문맥20종 CP-S01~20 = 38항목**을 기록했다. 각 항목은 title/body/next_step/source/evidence/scope를 가진다. next_step은 조건 설명이며 즉시 버튼을 추가하는 명세가 아니다.

| 그룹 | 현행 사유 코드 |
| --- | --- |
| CP-R01~04 | STATION_COUNT / DUPLICATE_STATION / DISCONNECTED / OUTSIDE_JURISDICTION |
| CP-R05~08 | PLAN_LOCKED / NO_UNDO_HISTORY / UNDO_FAILED / STATE_CHANGED |
| CP-R09~13 | INVALID_SPEED / INVALID_PLAN / INVALID_INPUT / STATION_NOT_SELECTED / INVALID_INDEX |
| CP-R14~18 | INVALID_COMMAND / INVALID_STATION / UNKNOWN_ACTION / INVALID_NETWORK / INPUT_CHANGED |

STATE_CHANGED는 현재 코드의 계획 revision 불일치 문맥으로 한정한다. 시계/봉투 revision만 달라졌다는 이유로 모든 요청을 거부하도록 확대하지 않는다. 중복 역 추가의 거부와 중복이 보이는 정적 유효성 fixture도 문맥을 구분한다.

**사유가 비어 있는 성공 결과를 오류로 표시하지 않는다.** accepted=true·빈 reason은 CP-S17 당시 처리 결과와 현재 snapshot을 연결한다. accepted=false·사유 미상은 거부 사실을 유지하고 CP-S14만 부연한다. 미수신·실제 pending·완료 거부를 합치지 않는다.

알 수 없는 code는 제품에 확인 불가 문구를, 개발 진단에 원래 code·요청ID/판·효력시각을 보존하는 안이다. 미공급 진단 필드를 UI가 창작하지 않는다.

## 5. 지역 표시·다중 오류·행동 의존성

- 지도/역 오류는 신뢰된 대상ID·순서/간선이 있을 때 지역 표식과 목록/안내에 연결한다. 미상 대상을 임의 강조하지 않는다.
- 여러 reason은 공급 사유를 중복 설명 없이 나열하는 표현안이다. 임의 우선순위로 원인을 지우거나 UI가 계획을 재판정하지 않는다.
- 현재 피드백과 과거 요청 결과는 별도 구획이다. 과거 거부가 최신 allowed_actions를 덮지 않는다.
- 예측 실패로 지도 편집 전체를 막거나 보고 실패로 현재 자금을 숨기지 않는다. 의존하는 부분만 확인중으로 표시한다.
- 지도/목록은 같은 안정ID·행동을 유지한다. 목록도 같은 누락 자료에 의존하면 무조건 복구 대안으로 약속하지 않는다.
- 실제 대기의 허용 행동·중복 입력 정책은 공급 확인 대상이다. 새 취소·타임아웃·재접수·재시작·전역재조회 버튼을 만들지 않는다.
- 긴 문구는 줄바꿈/영역 확장을 비교하되 최종 높이·줄수·폰트를 확정하지 않는다. 원인/대상·숫자·끝 제외·시점은 손실 없이 확인 가능해야 한다.

문구 검토→DEV의 영향 있는 공급/복구 분기 L2 확인→해당 적용 티켓의 코드/GUI 대조 순이다. 기존 UI-DC-01~07 전체 정적 수용을 재심사하지 않는다. 최종 규격·F08 실측·Track A 인수는 후속이다. 게임 명세 변경 필요: NONE.
