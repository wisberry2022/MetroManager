# DEV-027 — W04B·VS-02 및 DEV-026 착수·실행 검증 계획

> **2026-11-21 후속:** PR #149는 main `de0f03f9d2fcc301940a4176f1359b2788a51950`에 병합됐다. [Track A 사전 의견](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053550740)은 **DESIGN_PRELIMINARY_NO_OBJECTION / L2_FINAL_PENDING**, [Track B 의견](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053570152)은 RP/EX 제안 의미에 이견 없음·실제 공급/제품 수용 PENDING이다. 이번 후속은 티켓 §5의 문서 보완 PR이며 제품 구현·실행·미래 구현 Git·main 병합 승인이 아니다. §7.3·11이 이번 반영 범위를 설명한다. 아래 최초 제출 식별·검증 기록은 당시 이력으로 구분한다.

- 현재 제출 상태: **DOCUMENT_PR_SUBMISSION_AUTHORIZED / PLAN_REVIEW**.
- 제품 상태: **IMPLEMENTATION_AUTH_PENDING / PRODUCT_VALIDATION_NOT_RUN**.
- 본문 출처: [철회된 Issue #148](https://github.com/wisberry2022/MetroManager/issues/148), [Owner 요청에 따른 제출 방식 전환 기록](https://github.com/wisberry2022/MetroManager/issues/148#issuecomment-7053231691).
- 현재 문서 제출 권한·정확한4개 경로: [DEV-027 티켓](../tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md).
- 변환·문서 검증 결과: [DEV-027 결과서](../tasks/DEV-027_RESULT.md).

#148의 기술 검토 내용과 미래 구현 후보 경로는 유지한다. Owner의 후속 요청으로 **계획의 제출 방식만 Issue에서 로컬 산출물·문서 PR로 전환**했다. 원문을 삭제하지 않고 CLOSED/not_planned로 보관한다. 이는 계획/Stage 3 범위 취소나 DEV-027·DEV-026 제품 완료가 아니다. 아래의 구현·제품 검증·미래 구현 Git 권한은 이번 문서 제출 권한과 별개다.

- 작성: Development / AGT-DEV-0004 · 2026-11-21 KST
- Task-ID: **DEV-027** (W04B·VS-02 신규 실행 티켓). **DEV-026은 별도 기존 티켓으로 유지**하며 아래에 공동 착수 검토안을 연결한다.
- 상태: **PLAN_REVIEW / IMPLEMENTATION_AUTH_PENDING / PRODUCT_VALIDATION_NOT_RUN**
- 정적 조사 기준 main: `f047edbf67a6f888eda5eed24309b78554b3c2ed`. 아래 클래스·명령·필드는 **구현 제안**이며 이미 공급되거나 수용된 API라는 뜻이 아니다.

## 1. 요청·승인 근거와 현재 판단

최초에는 Owner 요청에 따라 이슈로 제출했고, 후속 요청에 따라 해당 내용을 로컬 문서로 변환하여 PR로 제출한다. **이번 허용 동작은 문서4개 변환·정적 검사·Commit·일반 Push·PR·필수 CI 확인 및 철회/대체 연결이다. 구현·제품 검증과 미래 구현 산출물의 Git 제출은 별도 승인 대상**이다. main 병합도 포함하지 않는다. 과거 DEV-025의 23파일 제출 승인이나 DEV-026의 문서 PR 승인을 이번 제품 작업으로 전용하지 않는다.

- [PM-020 공통 계획](https://github.com/wisberry2022/MetroManager/blob/f047edbf67a6f888eda5eed24309b78554b3c2ed/docs/hq/PM-020_STAGE3_EXECUTION_PLAN.md), [Development 요청](https://github.com/wisberry2022/MetroManager/blob/f047edbf67a6f888eda5eed24309b78554b3c2ed/docs/hq/requests/PM-020_DEVELOPMENT_STAGE3.md).
- [PLN-013 W4B-01~30·DI-01~03](https://github.com/wisberry2022/MetroManager/blob/f047edbf67a6f888eda5eed24309b78554b3c2ed/docs/planning/PLN-013_W04B_RULES_AND_BOUNDARIES.md), [PLN-013 PR #147](https://github.com/wisberry2022/MetroManager/pull/147).
- [Design Track A #146](https://github.com/wisberry2022/MetroManager/issues/146), [DEV의 기존 실제 공급 대조](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7052835175).
- [DEV-026 #104](https://github.com/wisberry2022/MetroManager/issues/104), [기존 계약](https://github.com/wisberry2022/MetroManager/blob/f047edbf67a6f888eda5eed24309b78554b3c2ed/docs/engineering/gate3/DEV-026_S01_EXCEPTION_CONTRACT.md), [RP-01~08](https://github.com/wisberry2022/MetroManager/blob/f047edbf67a6f888eda5eed24309b78554b3c2ed/docs/design/tasks/DSG-008_DEV026_RESPONSE_AND_P06_P07_RECOMPARE.md).
- 게임 의미는 PLN-013이 연결한 Owner 결정·Gate 2 승인·C v0.7/D v0.9/DATA v1.4를 따른다. PM-020의 S3 번호는 인수 기준안 추적이다. 문서 병합·최신 SHA 자체를 새 제품 실행 승인으로 간주하지 않는다.

**DEV-026은 STAGE3_SCOPE_CONFIRMED / IMPLEMENTATION_READINESS_PENDING**이다. 과거 보류 기록은 당시 이력으로 보존하고, 공식 편입을 다시 승인 대상으로 올리지 않는다. S3-12의 실제 구현·검증·부서 수용이 필요하며 문서 정리만으로 종료하지 않는다. 이번에는 그 구체 실행 범위를 검토 요청한다.

Stage 2 DONE과 기존 PASS·한정 수용은 유지한다. DEV-025는 [#97 종료 기록](https://github.com/wisberry2022/MetroManager/issues/97#issuecomment-7052796254)과 #146의 Track A 검토 종료를 연결한다. F-08 최종 규격·Track B 잔여·RD-03/07은 해당 영향만 대조하며 W04B 전체 선행조건으로 확대하지 않는다.

## 2. 재사용 기반과 실제 공백

기준 SHA의 소스 본문/호출 경로를 대조했다. 파일명 검색만으로 미구현을 판정한 것이 아니다.

| 대상 | 실제 존재하는 공급 | 이번 보완 / 증거 경계 |
| --- | --- | --- |
| 노선·예측 | `route_plan.gd`, `prediction_state.gd`, `demand_predictor.gd`; Session의 편집·예측 명령 | 6~8역·연결·중복·관할, 현재/이전 예측 재사용. 제출 가능 검사는 심사 접수 구현과 다름. 슬롯 계보·심사 잠금·수요 revision 추가 필요 |
| 시간·재무 | `game_clock.gd`, `command_queue.gd`, `minute_pipeline.gd`, 원장/보고 모델 | 기존 분 순서·계약/입금·R/K/B·마감 재사용. W04B 접수/심사/E01 처리를 Pipeline에 추가. 시계·원장 규칙 변경은 제외 |
| W04A→W05→W06 | `tender_service.gd`의 실제 사업계약·정부 지급, `construction_service.gd`, `operations_service.gd` | 현재 공사·운영 공급이 tender snapshot에 결합됨. 제안을 가짜 공고로 만들지 않고 출처 종류를 명시한 공통 사업 공급으로 연결 |
| W04B | Session dispatch에 실제 제안/시청/정부/설득/사실 소비 명령 없음 | 모델·RNG·E01·계약 인계·UI 신규. 표시 fixture를 실제 공급으로 대체하지 않음 |
| S01·P06/P07 | 호스트가 전체 state를 전달, 화면 이력·보고일 선택·보고 확인/조회·복귀 존재 | root 실행 소속/계약판 공급, 부분 누락 제한, 새 Session 전체 View 수명, 대기 복원 callback 차단을 DEV-026으로 보완 |
| 기존 수용 | [DEV-022 결과](https://github.com/wisberry2022/MetroManager/blob/f047edbf67a6f888eda5eed24309b78554b3c2ed/docs/engineering/tasks/DEV-022_RESULT.md), [DEV-023 결과](https://github.com/wisberry2022/MetroManager/blob/f047edbf67a6f888eda5eed24309b78554b3c2ed/docs/engineering/tasks/DEV-023_RESULT.md), [DEV-024 인계](https://github.com/wisberry2022/MetroManager/blob/f047edbf67a6f888eda5eed24309b78554b3c2ed/docs/engineering/gate3/DEV-024_DESIGN_ACCEPTANCE_HQ_HANDOFF.md) | 해당 원시험 SHA·행별 수용을 재사용. DEV024-IG-20261115-1115A=`0865e5a2cdf168dac14167922c9e59b16796fa81` 자연 실행, 1115B=`324faf9b7d81540240217d2757f26de6f07460ba` 국소 보완을 구분. 최신 main 전체 자연 완주 증거로 바꾸지 않음 |

원본 결과서의 당시 HOLD/PENDING/NOT_RUN과 후속 수용은 함께 보존한다. DOC-01·Q12 정정/원본 보관, 과거 NOT_CAPTURED/NOT_VERIFIED도 이 작업에서 PASS로 바꾸지 않는다.

## 3. 작업 단위와 순서

| 단계 | 담당 티켓·산출물 | 착수/완료 조건 |
| --- | --- | --- |
| P0 계약 대조 | DEV-027 DI-01~03·W04B-UI-01~14 공급안 / DEV-026 RP·EX 적용표 | 본 계획 검토. Planning은 DI-03의 실제 의미 연결, Track A/B는 자기 영향 행 대조. 실제 미공급은 그대로 표시 |
| P1 순수 모델·자동 경계 | DEV-027 제안/심사/동일성/RNG/수요·사업 공급 모델 | 비의존 부분은 Track A의 디자인 선행 차단 없음. 유효한 로컬 구현·실행 승인 후 진행한다. DI-03 대상/반복 효과에 종속된 구현·기대값만 보류하며, P3의 실제 공급 L2 조건을 그 공급을 만들 모델 구현의 선행조건으로 역전하지 않음 |
| P2 공통 공급·생명주기 | DEV-026 Session 메타데이터·guard·지역 제한·새 View/복귀, 영향 회귀 | Track A 기능 영향 방향 및 Track B RP/EX 제안 의미에 사전 이견 없음. 실제 공급/제품 L2·검증 수용과 유효 로컬 실행 권한은 별도이며 새 전체 디자인 차단을 만들지 않음. W04B 미래 봉투의 선택적 공급도 공통 계약에 포함 |
| P3 실제 W04B 공급·UI | DEV-027 Session/Pipeline·사업 연결, 실제 payload 제출→Track A L2 대조→제안 패널·P05/P06/P07 통합 | 해당 UI 행 L2 수용 전 화면 통합을 선행하지 않음. DEV-026 공통 변경을 먼저 반영한 기준에서 순차 작업 |
| P4 공동 검수본 | DEV-027 VS-02 / DEV-026 적용 RP·EX, 직접 영향 회귀 | 두 작업이 포함된 고정 시험본, 합의 입력/기대/행/주관/원본 위치. DEV 자동·fixture·DEV 실제 GUI·독립 실행·Design 심사를 각각 기록 |
| P5 제출·인수 | 티켓별 로컬 결과 검토→승인된 Git 제출/필수 CI→별도 main 병합→HQ/Owner 인수 | Commit/Push/PR·병합은 각각 유효 승인 후. S3-11/12 최종 인수·Stage DONE은 별도 |

공통 수정 파일은 `scripts/ui/stage1_session.gd`, `scripts/ui/stage1_view.gd` **2개**다. 같은 파일을 두 작업에서 동시에 덮어쓰지 않는다. P1의 비공통 모델 준비와 P2 후, P3가 순서대로 적용한다. Git 권한 전에는 격리된 로컬 통합본과 파일 해시로 연결하고, 이후 승인된 두 PR의 의존성과 실제 base/head를 기록한다. 별도 채팅/에이전트 공동 쓰기는 배정하지 않는다.

예정 작업 브랜치: `codex/DEV-027-w04b-vs02`, `codex/DEV-026-s01-exception-runtime`. 두 구현 브랜치는 이번 문서 제출에서 생성/전환/커밋하지 않는다. 이번 문서 전용 브랜치는 `codex/DEV-027-stage3-start-plan`이다. 기존 shared root의 데이터 수정 2개는 보존하며 가져오지 않는다. 착수 시 최신 main·동일 티켓 경합을 재확인하고 별도 worktree를 사용한다.

일정은 **NOT_ESTIMATED**. 로컬 구현/실행 승인, DI-03 답변 범위, Track A/B 계약 차이와 독립 실행 담당/가능 시점이 정해지면 P1~P4 공수를 산정한다. 최종 F-08 전체 확정은 일괄 산정 선행조건이 아니다.

## 4. DI-01 — 명령·접수·효력·잠금·동일성 계약안

아래는 승인 규칙을 구현하기 위한 **DEV 제안**, 실행 증거는 NOT_RUN이다.

### 4.1 식별·payload·명령

- 실행 내 `run_scope` 아래 `command_id`, `proposal_id`, `slot_id`, `business_identity_id`, `plan_revision`, `prediction_input_revision`, `review_id`, `decision_id`, `fact_id`, `contract_id`를 구분한다. 영구 저장 ID/세이브 기능은 추가하지 않는다.
- 동일 슬롯의 이름·역순·역 교체와 같은 무순서 역 집합의 다른 슬롯 지정은 실패 계보를 없애지 않는다. 제출 계보의 슬롯/역 집합 관계를 보관하며 새 revision/hash를 새 사업 자격으로 쓰지 않는다. 단순 현재 계획 비교만으로 과거 제한을 지우지 않는다. P-A/P-B 슬롯과 실제 사업/계약 ID를 분리해 기존 W04A 사업과 충돌하지 않게 한다. 기존 동시 시공1·운영1 제한과 사업별 자금 격리를 새 제안으로 우회하지 않는다.
- 제안 snapshot은 각 영역의 `available/status/reason_codes`, 원천판/시각, 계획·예측, 심사/판정, 허용 행동, 신규 사실, 계약·실제 지급 출처를 공급한다. 내부 ID 전부를 화면에 노출할 의무는 없다.
- 신규 명령 후보: `submit_city_review`, `submit_government_review`, `submit_persuasion`, `sign_proposal_contract`. 슬롯 선택/계획 편집/예측은 실제 Session 명령으로 연결하고, P05 공사·착공·시험·개통은 기존 명령을 재사용한다.
- 명령에는 대상 식별·기대 의미판·확인한 계획/예측 또는 판정/사실의 참조를 담는다. 단순 화면 봉투판 갱신을 이유로 무조건 거부하지 않는다. 같은 command_id의 재수신은 최초 처리 계보를 재사용하며 별도 접수/추출/지급을 만들지 않는다.

### 4.2 접수·시간·원자성

| 단계 | 모델 처리·표시 의미 | 잠금/부작용 |
| --- | --- | --- |
| UI 요청 | `requested_at`·command_id 기록, 형식/현재 자격 검사 | 클릭 성공을 심사/지급 성공으로 표시하지 않음 |
| 유효 요청의 대기열 등록 | `registered_at`·`effective_not_before`·PENDING 제공 | 심사 횟수/RNG/사실 소비/지급 0. 중복 동일 요청은 재등록하지 않음 |
| 실제 효력 분의 재검사·접수 성공 | 계획/예측/사업·판정·관련 미사용 사실 및 단계 조건을 다시 검사하고 `admitted_at`·review_id 확정 | **성공 접수·필요 사실 소비·회차 증가·심사 잠금이 하나의 원자적 변경**. 설득 1회도 해당 유효 접수 때 소비 |
| 재검사 실패 | 구체 실패 사유·당시 확인 내용/현재 가능한 행동 제공 | 사실 미소비·회차 증가0·RNG0·계약/지급0, 자동 재접수 없음 |
| 심사 완료 | 시청30/정부60/설득30분을 실제 admitted_at부터 계산, decision_id·당시 근거 저장 | 정부/설득의 정상 추출은 DI-02 시점에서 1회. 접수 후 부적합은 접수 실패가 아니며 사용 사실을 복원하지 않음 |
| 허가→사업계약 | 허가액과 실제 계약·지급을 분리, 계약 효력 때 기존 원장 API로 사업 R에 1회 지급/매출 | 직접 적합800000 / 설득 성공640000. 공사계약·착공은 별도이며 화면 진입으로 원장 변경 없음 |

요청 당시 완료된 게임분이 T이면 효력 후보는 **T+1 이상**이다. 후보가 업무시간 06:00 이상~24:00 미만 밖이면 다음 06:00으로 옮긴다. T60 요청→360, T1440 요청→1800, 완료된 T360에서 요청→361을 구분한다. 정지 중에는 게임분/효력/기간이 진행하지 않는다. 시작된 심사의 기간을 밤에 임의 중단하는 정책은 추가하지 않는다.

접수 대기 중에는 편집 가능하되, 변경된 plan/input revision이면 기존 예약은 효력 때 실패하고 명시적 새 요청이 필요하다는 안이다. 심사 중에는 해당 심사 계획을 잠근다. 시청 판정 완료 후 편집은 허용하되 편집 시 이전 승인/예측을 새 계획 자격으로 쓰지 않는다. 정부 보류에서는 당시 계획 사본을 유지해 그 판정에 대한 설득만 1회 연결한다. 별도 초안을 편집해도 그 보류의 설득 기회나 정부 재접수 제한이 초기화되지 않는다. 계약은 허가받은 계획 사본으로 체결한다. **잠금 해제/보류 사본과 편집 초안의 표시 차이는 #146의 02·04·06·09~11 L2 대조 대상**이다.

대기열 등록 당시의 제출 입력 사본과 현재 편집 초안을 각각 식별·표시한다. 편집 뒤 대기 중인 요청이 무통보로 새 초안에 교체되거나 자동 재접수되지 않는다. 효력 시 실패하면 **당시 요청 대상·실패 사유·현재 가능한 행동·명시적 새 요청 필요**를 함께 공급한다. 보류 심사의 고정 계획/근거, 설득 사용 이력, 허가받은 계약 계획도 현재 초안과 분리한다. UI는 실제 모델의 허용 행동을 소비하며 원시 ID/revision/scope를 일반 화면 필수 정보로 추가하지 않는다. 두 Track의 사전 표현 의견을 반영한 계약 제안이며 실제 payload·화면의 최종 L2는 아직 PENDING이다.

### 4.3 Pipeline 삽입 순서

기존 `[이전,T) 비용·공정 → 자정 마감 → CONTRACT → PROGRESS → VALIDATION → ARRIVAL → B SETTLEMENT → BOARDING` 순서는 유지한다. W04B 서비스의 T시각 처리는 **마감 후·기존 CONTRACT 효과 전**에 두고, (1) 발생 예정 E01/수요판 게시 → (2) 완료 예정 심사 결과 확정 → (3) 예약 접수의 자격 재검사·접수, 이후 CONTRACT에서 사업계약/지급을 처리하는 안이다. 같은 단계의 동시 건은 안정된 등록 순서와 ID로 결정한다.

실제 UI는 완료된 T의 사건을 관측한 뒤 새 요청하므로 같은 T로 소급 재접수하지 않는다. 같은 분 입력 순서 검사는 실제 사전 등록 가능한 명령과 내부 경계 fixture를 구분하고, 아직 관측하지 못한 미래 fact ID를 정상 플레이에 주입하지 않는다. 원장 뒤 단계의 운임으로 앞 단계 계약을 성사시키지 않는다. 이 삽입이 SEM-03 의미와 충돌하면 해당 행만 RFC로 확인한다.

## 5. DI-02 — 정상 RNG 공급·재현 계획

- Session 시작 시 명시된 seed로 초기화하는 **제안 심사용 전용 Godot RandomNumberGenerator**를 사용한다. UI/다른 서비스와 RNG를 공유하지 않고 조회·화면 복귀·속도 변경으로 seed를 재설정하지 않는다.
- 제안 샘플 도메인: `randi_range(0, 99)`. 정부 **0~69 적합 / 70~89 보류 / 90~99 부적합**, 설득 **0~59 성공 / 60~99 실패**. 이는 확정 확률70/20/10·60/40의 구현 대응이며 확률 변경이 아니다. [공식 API의 양 끝 포함 범위·seed/state 설명](https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html)을 적용하되 실제 사용하는 엔진의 버전/빌드도 고정한다.
- **추출 시점 제안:** 유효하게 접수된 정부/설득 심사의 최초 완료 처리. 시청은 RNG 0회. 동시에 완료되는 심사는 admitted 순서와 review_id로 정렬한다.
- 추출 기록: 엔진 전체 버전/실행 파일 해시, seed, 논리 draw_index, 처리 단계/게임분, review/decision/command ID, 호출 전후 state, 샘플·적용 구간·결과. 논리 1회는 API 호출 수이며 내부 PRNG의 원시 연산 횟수와 혼동하지 않는다.
- 무효/중복/진행 중 재클릭·같은 결과 재조회는 **추가 draw 0**. 분기 경계 값 fixture와 실제 엔진 seed 재현 검사는 분리한다. 시간 1/2/4배·분할/일괄이 같은 유효 명령/효력 순서를 가지면 추출 계보가 같아야 한다.
- 성공 seed는 **미탐색 / NOT_VERIFIED**. 실행 승인 뒤 실제 고정 엔진으로 탐색하고, 그 seed를 독립 초기 상태의 정상 RNG에 다시 공급해 VS-02를 실행한다. 결과 강제·샘플 주입·MODEL_CHAIN_SETUP으로 정상 완주를 대신하지 않는다. 엔진 버전 간 동일 난수열을 보장하지 않는다.

## 6. DI-03 — E01 수요 연결안과 확인할 의미

현재 `DemandPredictor.od_pairs`는 D01→D02 … D08→D01의 실제 동/역 매핑을 쓰며, 수요는 정수 daily_demand로 받는다. `OperatingLine`은 기존 OD별 소수 carry를 누적한다. **현재 코드에는 제안 슬롯별 수요 프로필·E01 공급이 없다.**

기술안은 `proposal_demand_profile.gd`에서 슬롯/사업의 영향 동·OD·발생/적용판을 공급하고 예측/실운행이 같은 원천을 소비하게 하는 것이다. 25%는 정확한 유리수 5/4로 보관하며 수요 입력에서 조기 정수 절삭하지 않는다. 분별 요청 정수화와 carry는 기존 의미를 유지하고, 변화 전 carry·이미 탑승한 통행·도착/운임·마감 보고를 소급 재작성하지 않는다. 기존 비영향 OD·W04A 경로의 값은 보존한다.

E01은 해당 실패 decision_id와 slot/business에 연결해 결정+1440분에 발생한다. 발생 시 해당 수요판을 증가시키고 그 판에 의존한 예측만 이전 결과로 내려 재계산을 요구한다. T 발생의 수요 변경은 T의 이후 BOARDING부터 적용하며, 사실 소비는 **수요 증가를 다시 실행하거나 취소하는 작업이 아니다**. 사실의 발생/관련성/사용과 수요 효과 적용 이력을 각각 한 번만 기록한다.

다음은 실제 매핑 공백 때문에 필요한 **정적 의미 확인**이다. 1440분·25%·관련/판정 이후/미사용·성공 소비 규칙의 재승인 요청이 아니다.

### RFC-DEV-027-01 — 대상 슬롯 출발수요의 실제 연결

- 상태: **OPEN / PLANNING_CLARIFICATION_PENDING**. 요청: Development / AGT-DEV-0004. 응답 책임: Planning / AGT-PLN-0003, 필요 시 HQ 조정. 연관: DEV-027, PLN-013 DI-03·W4B-15~18.
- 근거: 위 고정 SHA의 DATA v1.4 §2·3·4·6 및 PLN-013 §3. 슬롯은 P-A/P-B이고 예시 경로는 유일한 지리 제한이 아니다. DATA는 대상 슬롯 25%를 정하지만 제품 동/OD 식별 목록은 공급하지 않는다.
- 질문/후보: **실패 심사에 묶인 계획의 역→동 매핑으로 영향 출발 동 집합을 고정하고, 기존 목적지/접근 배분을 그대로 쓰는 안**이 승인 의미에 맞는지 확인한다. 이후 역 교체로 사실의 영향 지역을 임의 이동시키지 않는다. 다른 해석인 **고정 슬롯별 동 목록**이 정본 의도라면 그 목록/근거를 공급받는다. 예시 노선을 강제 지리 경계로 만들거나 도시 전체 수요를 올리는 안은 채택하지 않는다.
- 함께 확인할 한계: 이미 발생한 E01을 사용한 뒤 다시 실패했을 때 추가 E01을 생성하는지, 그렇다면 수요 효과의 누적/중복 범위가 무엇인지. 현재 자료만으로 **무한 반복 보상/중첩 정책을 만들지 않는다**. 첫 E01·1회 소비와 추가 사실 정책을 구분해 답변을 연결한다.
- 영향: 대상 매핑·반복 효과에 종속된 E01 제품 통합/경계 수용은 답변 전 **PENDING**. 비의존 시청/정부/RNG·기존 모델 재사용·DEV-026 준비의 일괄 차단은 아님. 일정은 이 부분만 산정 보류. 세이브 기능/포맷 변경 없음. 해당 fixture와 수요 회귀 기대값에만 영향.
- 담당 의견: 실패 당시 근거 고정이 계보 추적과 우회 방지에 적합하다는 DEV 제안이다. Planning의 승인 의미 대조 전 확정하지 않는다. 답변/결론·HQ 조정 결과는 **미수신**.
- Owner 판단 필요 여부: **현재 새 정책 승인 필요 확정 아님**. 기존 의미의 해석/공급으로 답할 수 있으면 해당 대조로 닫고, 새로운 지리 제한·반복 효과 정책 선택이 실제 필요할 때만 대안/영향을 좁혀 상정한다.
- 반영: DEV-027 공급 계약·실행 계획의 후속, 필요 시 Planning 담당의 PLN-013/정본 보완. DEV가 Planning 문서를 수정하지 않는다.

## 7. DEV-026 적용 범위와 #146 공동 L2 입력

### 7.1 DEV-026 보완

| 대응 | 이번 구현 후보·검수 한계 |
| --- | --- |
| L2-A / RP-01·02·08 | root run_scope/ui_contract_revision, 순수 관측 검사와 지역 의존표. S01·기존 자식 봉투·P06/P07·W04B 봉투를 분리. 누락/오류를 0·과거 값·게임상 거부로 대체하지 않고 실제 의존 입력만 제한 |
| L2-B / RP-03·04 | 같은 Session의 관측 하한을 reset으로 낮추지 않음. 새 Session은 **호스트와 전체 자식 View를 재생성**하고 옛 process/input/signal/응답/대기 복원 callback을 차단. 같은판 clock remainder 변화와 old scope 높은판을 구분 |
| RP-05·06 | S01 직전일 보고와 P07 FIXED_DAY의 선택일/키/값을 별도로 검사. 오래된 확인 사본·다른 run/day로 다음 사업 조회 금지. 조회 성공과 계약/응찰 가능은 구분 |
| L2-C / RP-07 | 같은 Session에서 현재 화면의 유효 선택/포커스/스크롤 복귀. 사용자가 옮긴 포커스를 대기 callback이 빼앗지 않음. 대상 소멸은 선택 없음·해당 화면의 유효 fallback. 새 Session 이력 이관 없음 |
| EX 적용/제외 | EX-05는 동기 예측의 소비 fixture 조건부, EX-16의 일반 S01 가짜 대기는 제외, EX-18 외부역은 격리 입력. W04B의 실제 접수 대기는 신규 실제 경로이며 EX-16을 소급 변경하지 않음 |
| 추가 경로 이유 | 기존20개에서 P06/P07의 관측·확인/복귀 경계2개, 해당 자동 검사1개, F08 GUI runner의 새 Session 전환 호환1개를 더한24개. 깊은 자식 전면 개편·F08 규격/제품 채택 없음 |

`run_f08_gui_cases.gd`는 기존 View에 새 Session을 대입하고 reset하므로 전환부만 새 View 계약에 맞춘다. 기존 DEV-025 T01~04/RD 결과·원본·23파일 제출 증거는 덮지 않는다. F08 전체 재실험을 이 1개 경로 변경의 자동 의무로 만들지 않는다. RD-03/07의 B 전환 후 화면 밖 포커스·행동 노출은 RP-04/07 복귀의 직접 영향 행으로 대조하고, 지도 겹침은 동일 ID 후보/목록 대안 접근을 보존한다. B 배치 채택·마커 재배치·최소창/폰트 규격 확정은 이번 수정에 포함하지 않는다. `run_operations_gui_cases.gd`와 Q12 runner는 관찰한 경로에서 새 호스트를 생성하므로 현재 수정 후보에 넣지 않았다.

### 7.2 Track A/B가 확인할 묶음

| 검토 ID | 공급/명령·현재 상태 | 최소 보완·담당 | 차단 대상·시점 |
| --- | --- | --- | --- |
| W04B-UI-01~03 | 기존 노선/예측 + 신규 slot/business/proposal/잠금; 실제 W04B payload 미공급 | DEV-027 DI-01·03 계약/표본, Track A 대조 | 해당 제안 화면 통합 전 |
| 04~06 | 요청/예약/효력/시청30분·−1/0/+1; 신규 NOT_RUN | DEV-027 실제 상태 전이·시간/사유·잠금, Track A | 시청 UI 통합 전 |
| 07~10 | 정부60분·3분기/설득1회·30분·640000; 신규 NOT_RUN | DEV-027 DI-01·02, RNG 계보·당시 결과/현재 행동 | 정부/설득 UI 통합 전 |
| 11~12 | 정부 실패 제한·E01/소비·재접수; 미공급 | DEV-027 + Planning DI-03 답변, Track A/B는 실패/미수신 의미 | 해당 효과/재접수 통합·수용 전 |
| 13 | 허가·사업계약·실제 지급→P05; 기존 W04A 원장/공사 재사용 | DEV-027 business_sources로 같은 사업/지급/공사 ID 연결 | W04B 공사 인계 통합 전 |
| 14 | P05→P06/P07·유효 보고→다음 후보; 기존 수용 + 신규 제안 출처 | DEV-027 신규 source 연결, DEV-026 보고/복귀 guard | 최종 VS-02 시험본 고정 전 |
| 공통 RP/EX | 기존 사전 의견과 새 실제 공급 구분 | Track B가 예외·소속, Track A가 기능 흐름 영향 행 주관 | 공동 필수 행 합의 및 신규 독립 실행 전 |

실제 공급 후 각 행에 코드 위치·full SHA/파일 해시·입력/기대·실측/NOT_RUN·원증거 링크를 채워 #146에 한 묶음으로 연결한다. **계약안 전달은 L2 수용이 아니며, 독립 실행과 Design 증거 심사도 DEV 자체 실행과 별개**다. 두 Track은 한 검수표/패킷에서 행을 나누고 동일 GUI를 중복 요구하지 않는다.

### 7.3 실제 공급 시 제출할 공동 최소 표본

아래는 새 테스트 횟수나 추가 파일 승인이 아니라 #146의 기존 행에 연결할 **계약/증거 항목**이다. 아직 실제 payload·실행 증거를 생성하지 않았으므로 모든 관측은 NOT_RUN/미공급이다.

| 영향 행 | 실제 공급에 포함할 최소 구분·표본 | 심사/차단 경계 |
| --- | --- | --- |
| UI-02·04~07 | 대기 당시 제출 사본/현재 초안, 요청·등록·실제 접수·완료 시각, 접수 전 편집→효력 재검사 실패·사실/회차/추출/지급 추가효과0, 명시적 새 요청 | Track A 기능 주관·B 당시/현재·실패 표현. 해당 화면 통합 전 L2; 비의존 모델 생성 전 조건 아님 |
| UI-09~11·13 | 심사 기준 계획/근거와 초안, 해당 판정 설득1회 이력, 허가 계획 사본→같은 사업 계약/실제 지급. 다른 초안 대체·과거 이력 소거 없음 | Track A 주관. 공급 표본의 일치/필수 보완/근거 부족/적용 제외를 행별 판단 |
| UI-11·12 / DI-01·03 | Planning 답변→영향 동/OD·추가 발생/중첩→수요판·소수·예측/실운행 반영·경계 기대값. 발생/접수 순서와 접수 실패/후속 부적합을 구별 | 해당 종속 구현/수용만 답변 전 보류. 이미 쓴 사실을 후속 부적합으로 복원하지 않음 |
| RP-01·02·08 | root 무효/단일 자식 오류별 표시·행동 의존표, 독립 유효 자료 유지, 이전 marker/클릭/허용 행동 잔존 없음 | Track B 주관, W04B 실제 기능 영향은 A 공동. 깊은 자식 전면 개편 아님 |
| RP-03~06 | 새 scope 낮은판/old scope 높은판/같은판 remainder, 자식 수명·옛 callback, P07 선택일/key/value/확인 사본, 조회 허용·성공과 계약 가능 구분 | 주입 fixture/정상 제품 구분. 같은 Session reset이나 기존 복귀 수용을 새 Session 증거로 확대하지 않음 |
| RP-07 / RD-03·07 직접 영향 | 화면별 유효 fallback·실제 포커스 도달/가시성·스크롤/읽기 순서, 소멸/숨은 Control 배제, 사용자 이동 보존, 겹친 마커의 같은 ID 목록 접근 | 실제 채택/변경 경로만. B 배치 채택·마커 재배치·F08 전체 재실험 요구 없음 |

한 패킷의 각 행은 **실제 공급/명령 코드 위치, full SHA 또는 base+변경 파일 해시, RP/EX·W04B 행, 입력/기대/관측, 정상 제품/소비 fixture 구분, 증거 원본 위치**를 갖춘다. 그 행의 필수 차이를 해소한 뒤 해당 UI를 수용하며, 미공급 행 때문에 비의존 모델 전체를 멈추지 않는다. 독립 실행 주체·권한·범위는 실행 전에 합의하고 DEV 자체 실행/Design 심사와 구별한다.

## 8. 정확한 변경 경로 — 승인 요청 후보

아래는 원문 조사 main 기준의 **미래 구현 승인 후보 목록**이다. 이번 문서 PR에 실제 추가하는4개와 구분한다. 이4개도 기존 후보41개에 포함돼 있으며 추가 구현 권한을 부여하지 않는다. 후속 구현 착수 시 이미 존재하게 된 문서의 신규/수정 표기는 그때의 base로 갱신한다.

목록은 최대 포괄 디렉터리가 아니라 **허용 후보 파일 목록**이다. 목록 밖 수정/삭제/이름 변경이 필요하면 이유·정확한 경로를 제시해 추가 범위를 확인한다. 기존 UID는 보존하며 신규 GDScript의 UID도 각각 계수했다. 기존 파일 존재/신규 경로 미존재를 위 main 트리와 대조했다.

### 8.1 DEV-027 — 41개: 제품22 + 테스트12 + 문서/증거7

| # | 구분 | 정확한 경로 |
| --- | --- | --- |
| 1 | 신규 | `assets/data/stage3_proposals_v1_4.json` |
| 2 | 신규 | `scripts/data/proposal_data_loader.gd` |
| 3 | 신규 | `scripts/data/proposal_data_loader.gd.uid` |
| 4 | 신규 | `scripts/model/company_proposal.gd` |
| 5 | 신규 | `scripts/model/company_proposal.gd.uid` |
| 6 | 신규 | `scripts/simulation/proposal_service.gd` |
| 7 | 신규 | `scripts/simulation/proposal_service.gd.uid` |
| 8 | 신규 | `scripts/simulation/business_sources.gd` |
| 9 | 신규 | `scripts/simulation/business_sources.gd.uid` |
| 10 | 신규 | `scripts/simulation/proposal_demand_profile.gd` |
| 11 | 신규 | `scripts/simulation/proposal_demand_profile.gd.uid` |
| 12 | 수정 | `scripts/simulation/demand_predictor.gd` |
| 13 | 수정 | `scripts/model/operating_line.gd` |
| 14 | 수정 | `scripts/simulation/minute_pipeline.gd` |
| 15 | 수정 | `scripts/simulation/construction_service.gd` |
| 16 | 수정 | `scripts/simulation/operations_service.gd` |
| 17 | 수정 | `scripts/ui/stage1_session.gd` |
| 18 | 수정 | `scripts/ui/stage1_view.gd` |
| 19 | 신규 | `scripts/ui/proposal_view.gd` |
| 20 | 신규 | `scripts/ui/proposal_view.gd.uid` |
| 21 | 신규 | `scenes/proposal_panel.tscn` |
| 22 | 수정 | `scripts/main.gd` |
| 23 | 신규 | `tests/game/w04b_fixtures.gd` |
| 24 | 신규 | `tests/game/w04b_fixtures.gd.uid` |
| 25 | 신규 | `tests/game/run_w04b_tests.gd` |
| 26 | 신규 | `tests/game/run_w04b_tests.gd.uid` |
| 27 | 신규 | `tests/game/run_proposal_ui_tests.gd` |
| 28 | 신규 | `tests/game/run_proposal_ui_tests.gd.uid` |
| 29 | 신규 | `tests/game/run_proposal_gui_cases.gd` |
| 30 | 신규 | `tests/game/run_proposal_gui_cases.gd.uid` |
| 31 | 신규 | `tests/game/run_vs02_tests.gd` |
| 32 | 신규 | `tests/game/run_vs02_tests.gd.uid` |
| 33 | 신규 | `tests/game/run_vs02_gui_observer.gd` |
| 34 | 신규 | `tests/game/run_vs02_gui_observer.gd.uid` |
| 35 | 신규 | `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md` |
| 36 | 신규 | `docs/engineering/tasks/DEV-027_RESULT.md` |
| 37 | 신규 | `docs/engineering/tasks/DEV-027_PROVENANCE.json` |
| 38 | 신규 | `docs/engineering/gate3/DEV-027_W04B_SUPPLY_CONTRACT.md` |
| 39 | 신규 | `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md` |
| 40 | 신규 | `docs/engineering/evidence/DEV-027_W04B_VS02_RESULTS.json` |
| 41 | 신규 | `docs/engineering/evidence/DEV-027_W04B_VS02_EVIDENCE.md` |

변경 목적:

- 1~11: 승인 수치의 별도 제품 데이터/검증 로더, 제안 상태·심사 서비스·실제 사업 출처·E01 수요 프로필. 기존 W01/W03 DATA 파일을 덮지 않는다. 명세 v1.4와 기존 런타임 봉투의 data_version 1.3을 혼동해 일괄 버전 교체하지 않는다.
- 12~16: 영향 OD의 정확한 수요/실운행, 분 단계 연결, 공사/운영의 실제 사업 출처 확장. 원장·시계·공사 기간/선후·W04A 공고 정책은 그대로 재사용.
- 17~22: 실제 공급·명령/초기화, 새 제안 패널과 진입/복귀. 다음 사업 조회는 제안 후보 또는 기존 공고의 명시적 출처로 이동하며 조회가 새 계약을 만들지 않음.
- 23~34: 모델/소비/UI/VS-02 자동·분기 fixture·실제 GUI 관측을 분리. `run_vs02_gui_observer`는 정상 main/제품 입력의 기록용이며 명령 강제·시간 점프·강제 성공·초기 계약 주입 금지.
- 35~41: 승인 원문·경로·실행 명령·입력/기대/결과·기준/시험본·원본 해시·미해결·명세 변경 필요 여부 기록.

`business_sources`는 실제 tender/proposal의 사업계약·원장 거래·허가계획을 대조하는 읽기/변환 경계다. 새 이중 원장이나 가짜 tender를 만들지 않는다. 기존 W04A 공급 형식은 호환 경로로 수용하고 출처와 데이터/계약판을 명시한다.

### 8.2 DEV-026 — 24개: 제품7 + 테스트10 + 문서/증거7

| # | 구분 | 정확한 경로 |
| --- | --- | --- |
| 1 | 수정 | `scripts/ui/stage1_session.gd` |
| 2 | 신규 | `scripts/ui/s01_observation_contract.gd` |
| 3 | 신규 | `scripts/ui/s01_observation_contract.gd.uid` |
| 4 | 수정 | `scripts/ui/stage1_view.gd` |
| 5 | 수정 | `scripts/ui/stage1_map.gd` |
| 6 | 수정 | `scripts/ui/operations_view.gd` |
| 7 | 수정 | `scripts/ui/finance_view.gd` |
| 8 | 수정 | `tests/game/run_w07_tests.gd` |
| 9 | 수정 | `tests/game/run_w07_gui_cases.gd` |
| 10 | 수정 | `tests/game/run_operations_ui_tests.gd` |
| 11 | 수정 | `tests/game/run_f08_gui_cases.gd` |
| 12 | 신규 | `tests/game/w026_ui_fixtures.gd` |
| 13 | 신규 | `tests/game/w026_ui_fixtures.gd.uid` |
| 14 | 신규 | `tests/game/run_s01_exception_tests.gd` |
| 15 | 신규 | `tests/game/run_s01_exception_tests.gd.uid` |
| 16 | 신규 | `tests/game/run_s01_exception_gui_cases.gd` |
| 17 | 신규 | `tests/game/run_s01_exception_gui_cases.gd.uid` |
| 18 | 수정 | `docs/engineering/tasks/DEV-026_S01_EXCEPTION_SCOPE.md` |
| 19 | 수정 | `docs/engineering/tasks/DEV-026_RESULT.md` |
| 20 | 수정 | `docs/engineering/tasks/DEV-026_PROVENANCE.json` |
| 21 | 수정 | `docs/engineering/gate3/DEV-026_S01_EXCEPTION_CONTRACT.md` |
| 22 | 수정 | `docs/engineering/gate3/DEV-026_S01_EXCEPTION_VALIDATION_PLAN.md` |
| 23 | 신규 | `docs/engineering/evidence/DEV-026_S01_EXCEPTION_RESULTS.json` |
| 24 | 신규 | `docs/engineering/evidence/DEV-026_S01_EXCEPTION_EVIDENCE.md` |

기존 미래 후보20개에 추가되는 정확한4개는 `scripts/ui/operations_view.gd`, `scripts/ui/finance_view.gd`, `tests/game/run_operations_ui_tests.gd`, `tests/game/run_f08_gui_cases.gd`다. P06/P07의 실행 소속·지역 의존·확인/복귀 경계와 새 Session 전환 호환만 포함한다. 과거 DEV-026 결과·PROVENANCE는 제출 당시 부분을 보존하고 이번 후속/새 제출 식별을 분리 기록한다.

**합계:** 41+24개의 티켓별 경로, 공통2개를 제외한 **고유63개**. 공개 캡처 파일은 목록에 없으며 실행 원본은 `.local/validation/DEV-027/<run_id>/`, `.local/validation/DEV-026/<run_id>/`에 분리한다. 공개 증거에는 최소 인덱스·해시·판정만 기록한다. 추가 공개 파일이 필요하면 정확한 경로를 먼저 제시한다.

제외 경로/범위: 타 부서 산출물, `project.godot`, `.github/`, 정책/훅/도구, 기존 승인 데이터2개, F08 원본 증거, 경제/회사 평판 신규 규칙, 저장/불러오기, 최종 아트·폰트/배치/지원 환경 채택, export/FPS/배포. 기존 규칙을 구현하는 신규 제품 데이터 작성은 위1번에 한정한다.

## 9. 실행·검증 계획 — 모두 승인 후

이번 계획 작성 중 신규 게임 자동/프로젝트 로드/GUI/빌드/성능 실행은 **NOT_RUN**이다. 아래는 실행 후보이며 사전 PASS가 아니다.

| 구분 | 최소 검사·기대 | 증거·연결 |
| --- | --- | --- |
| W04B 모델/자동 | W4B-01~04 역수/무효/동일성/판, 05~09 예측·−1/0/+1·수정/업무시간·기간, 10~20 정부3분기/설득/정상RNG·E01/소비·무효/중복 | 신규 `run_w04b_tests`. 소수 보존·영향 OD/미영향 OD·예측 무효화·carry도 포함. fixture와 정상 엔진 결과 구분 |
| 실제 연결 자동 | W4B-21~26 실제 계약/지급/표준공사·시험/개통·완료 통행·마감·B·보고/다음 조회 | `run_vs02_tests`. 자동 연결 PASS는 자연 GUI 완주 PASS가 아님 |
| 공급·UI 자동 | #146 01~14의 실제 payload·명령/disabled 이유·중복/전환·당시/현재·동일 사업/보고 | `run_proposal_ui_tests`, 소비 fixture는 `w04b_fixtures`로 분리 |
| DEV-026 자동/소비 | X-01~07 및 RP-01~08: root 타입/소속, 지역 실패, 새/같은 Session, 오래된/같은판 관측, P07 고정일/확인 사본, callback/포커스 복원 | `run_s01_exception_tests`, `w026_ui_fixtures`. EX-05/16/18 한계 표시. 영향 없는 전체 GUI 재실행 의무 아님 |
| 직접 영향 회귀 | 분 파이프라인→W02/04A/05/06, 예측/carry→W03/06, 호스트→W07·입찰/공사/운영 UI·VS01, F08 전환부→전환 해당 행 | 기존 runner 그대로 실행, 최초 실패 원인/영향을 확인하고 승인 범위 내 수정. 기존 수용 기록은 유지 |
| 시간 분할 | 동일 초기 상태·유효 명령/효력 순서로 1/2/4배속·일괄/분할 결과, 추출 순서·원장/보고·carry 일치 | W4B-30; 모든 배속×키×화면 Cartesian GUI는 요구하지 않음 |
| 프로젝트 로드 | 고정 시험본의 headless editor 로드 exit0·SCRIPT ERROR/ERROR 확인 | 테스트와 별도 로그 |
| DEV 실제 GUI | 정상 제안·실제 대기/판정/계약/공사·보고 및 합의 예외/복귀 직접 영향 행 | 정상 입력과 표시용 fixture 구분. 실제 input/스크린샷/게임분·명령·효과 계보·종료 기록 |
| 독립 실행/Design | 아래 VS-02 + 합의 RP/EX 행을 고정본에서 독립 실행, Track A/B 증거 심사 | 주체/권한·행/입력·원본 위치를 사전에 합의. 현재 둘 다 NOT_RUN/PENDING |
| 빌드·export·최종 FPS | 이번 범위 밖 | NOT_RUN |
| Git/CI | 별도 제출 승인 후 정상 훅·preflight·제출 head의 policy/department-policy | 후속 구현 PR CI NOT_RUN. 이번 문서 PR의 실제 CI는 결과서/PR에 별도 연결 |

승인 후 명령 형식(작업 worktree에서 실제 실행 파일 경로/버전을 기록):
```text
.venv/Scripts/python.exe tools/policy.py doctor
.venv/Scripts/python.exe tools/policy.py check
<Godot> --headless --path <worktree> --script res://tests/game/run_w04b_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_proposal_ui_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_vs02_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_s01_exception_tests.gd
<Godot> --headless --editor --path <worktree> --quit
<Godot> --path <worktree> --script res://tests/game/run_vs02_gui_observer.gd
<Godot> --path <worktree> --script res://tests/game/run_proposal_gui_cases.gd
<Godot> --path <worktree> --script res://tests/game/run_s01_exception_gui_cases.gd
```

신규 runner는 정상 exit0와 고의 실패 모드 exit1을 별도 로그/증거로 확인한다. 신규 선택 옵션은 구현 때 계약 문서에 확정하고 실행 전 존재를 확인한다. 기존 회귀는 `run_w02_tests.gd`, `run_w03_tests.gd`, `run_w04a_tests.gd`, `run_w05_tests.gd`, `run_w06_tests.gd`, `run_w07_tests.gd`, `run_tender_ui_tests.gd`, `run_construction_ui_tests.gd`, `run_operations_ui_tests.gd`, `run_vs01_tests.gd`를 같은 headless 형식으로 사용한다. 운영 GUI 자동 직접 영향은 기존 `run_operations_gui_cases.gd -- --auto`로 구분한다. 파일을 수정하지 않는 회귀 실행은 §8의 변경 경로 추가가 아니다.

각 실행은 run_id, 실행 주체/종류, base full SHA+미커밋 변경 파일 해시(커밋 후에는 해당 full SHA), 엔진·환경, 실제 명령/입력, 기대/관측·exit/오류, 원본 경로·SHA-256, 해당 W4B/DI/UI/RP/EX/S3/AC/VP 행을 기록한다. 판정은 PASS/FAIL/NOT_RUN/NOT_VERIFIED를 구분한다.

### VS-02 정상 완주와 종료 조건

독립 초기 **06:00·C1000000/R0/K0/B0**에서 실제 제품 UI로 행정/수요 확인→후보/순서·예측 비교→제안→시청→**실제 RNG 정부 적합**→같은 사업 계약/지급→표준 공사→시범60/안전60→개통→실제 완료 통행·유효 영업 실적 보고→다음 후보 조회까지 연결한다. **VS-02는 VP-01 대응**이고 두 번째 실제 수주까지 요구하지 않는다.

정상 실제 seed·전체 계보가 있는 실행과 정부 보류/부적합·설득/E01/소비의 국소 실패 경계를 별도로 제출한다. 단축 setup·자동 러너·강제 분기·영업0분 보고는 정상 전체 완주 대체 불가다. 기존 VS-01/VP-02 증거는 원래 범위로 재사용하고 차이만 HQ에 연결한다.

DEV 완료 검토 조건: 승인 경로 내 구현, 해당 필수 자동/로드/자체 GUI 미충족0 또는 정확한 보완 행 명시, 실제 공급/Design L2·독립 실행/수용 상태 분리, DI-03의 종속 의미 해소, 기존 증거/정정 보존, HQ/Owner 최종 인수 잔여 구분. **독립 수용이 남으면 DEV 자체 PASS로 전체 DONE 처리하지 않는다.**

## 10. 승인 필요 범위와 현재 수행 결과

| 항목 | 구체 범위 | 현재 권한/상태 |
| --- | --- | --- |
| 계획·문서 PR 제출 | #148 철회, 로컬 문서4개 변환·검사·Commit·Push·PR·필수 CI, #146/#104 대체 연결 | 후속 Owner 요청으로 승인; 상세는 DEV-027 티켓 |
| DEV-027 로컬 구현 | §8.1 41개 경로, §3 P1/P3/P4의 W04B·VS-02 구현. DI-03 종속 부분은 답변 후 | **추가 승인 필요** |
| DEV-026 로컬 구현 | §8.2 24개 경로, 최신 L2/RP/EX 범위의 공통 계약/화면/전환 보완 | **추가 승인 필요**. Stage 3 편입 승인은 이미 유효 |
| 제품 실행 | §9 모델/자동·직접 영향 회귀·로드·DEV 실제 GUI/경계/VS-02 및 정상 seed 탐색 | **추가 승인 필요**. 독립 실행 담당·권한/일정은 별도 연결 |
| 디자인 계약/수용 | Track A 해당 W04B 실제 공급 L2, Track B RP/EX; 공동 시험본·최소 검수표 | 각 담당 수용 필요. 이번 계획 제출이 수용 선언은 아님 |
| 기획/범위 판단 | RFC-DEV-027-01의 실제 의미 확인. 기존 규칙으로 답할 수 없는 새 선택만 Owner에 상정 | 답변 대기. 확률/수치 전체 재승인 아님 |
| 미래 구현 Commit·Push·PR | 두 제품 티켓의 실제 구현/실행 산출물·브랜치·필수 CI | **별도 승인 필요**. 이번 문서4개 제출 권한과 구분 |
| main 병합·Stage DONE | 제출본·필수 CI·부서 수용 후 각각 결정 | 별도 승인. 릴리스/배포 미포함 |

이번 결과는 #148의 계획을 로컬 문서로 변환하여 문서 PR로 제출하는 것이다. 신규 제품 구현/게임 자동검사/프로젝트 로드/GUI/빌드/실험은 **모두 NOT_RUN**이고 미래 구현 산출물의 Git 제출도 승인 대기다. 문서 검사·Commit/Push/PR·필수 CI의 실제 결과는 DEV-027 결과서와 PR에 연결한다. 새 게임 규칙 변경 필요는 확정하지 않았고 DI-03의 실제 선택 공백만 RFC로 유지한다. 이후 별도로 승인된 단위부터 로컬 구현·검증하고 로컬 결과를 먼저 제출한다.

## 11. #146 Design 사전 의견 반영 — 2026-11-21

기준 main은 `de0f03f9d2fcc301940a4176f1359b2788a51950`. [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053550740)와 [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053570152)를 각각 원문으로 연결한다. 양측 의견의 적용 범위는 다음과 같다.

| 구분 | 현재 확인 | 후속 조건 |
| --- | --- | --- |
| P0·P1 비의존 모델 | 디자인 사전 이견 없음, 추가 디자인 차단 없음 | 별도 유효 구현·실행 권한 연결. 이미 유효한 승인은 재사용하고 부족분만 확인 |
| P2 DEV-026 | 기능 영향 방향/RP·EX 제안 의미에 이견 없음 | 실제 공급·제품 L2/검증 수용은 PENDING. DEV-026 Stage 3 편입은 확정 |
| P3 W04B UI | 실제 payload/명령/상태 표본 미공급, L2_FINAL_PENDING | §7.3 입력을 공급하고 해당 행 수용 뒤 통합 |
| E01 | RFC-DEV-027-01 Planning 확인 대기 | 대상/반복 효과에 종속된 연결·기대값만 보류. DEV-026 전체 선행조건 아님 |
| P4 | 고정 시험본·합의 최소 행/입력/기대·독립 실행 범위 준비 전 | 공통 변경 후 한 패킷, 중복 GUI 요구 없음 |
| DEV-025/F08 | #97 기술 공급 종료·Track A 증거 검토 종료 유지 | Track B의 RD별 새 심사/F08 선택·적용 잔여는 #92. 이번 회신을 RD 최종 판정으로 전용하지 않음 |

이번 보완은 **대기 당시 사본/현재 초안의 표현 요구, 실제 공급 최소 표본, 단계별 차단 시점과 사전 의견의 상태 기록**이다. 시청/정부 확률·기간·E01 승인 수치·동일성/소비 규칙과 미래 후보41/24개 경로는 변경하지 않았다. DEV-026 원문에는 자기 티켓의 별도 문서 PR로 지역 의존·선택 보고일·화면별 fallback·검증 행을 후속 반영한다. 두 문서 PR은 서로 다른 파일을 변경하며 제품 통합 순서와 구별한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
