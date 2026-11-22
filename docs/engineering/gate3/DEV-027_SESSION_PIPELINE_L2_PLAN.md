# DEV-027 — Session·Pipeline 연결 및 L2 공급 준비 착수안

> **2026-11-22 P3-A 수용·P3-B 계획 후속:** Track A 공급 L2 한정 수용·Track B 정적 이견 없음을 마지막 후속 절에 연결한다. [화면 계획](DEV-027_SCREEN_INTEGRATION_PLAN.md)은 이번 문서7개와 미래 실행19개를 구분한다. 실제 화면 통합은 계획에 포함하되 구현·게임 검증·Git/GUI·DI03 보류는 유지한다. 앞선 상태/증거는 당시 이력이다.


> **2026-11-22 P3-A 구현 후속:** 승인된 Session·Pipeline 연결과 L2 공급 준비의 로컬 검토 결과는 문서 마지막의 P3-A 후속 절을 따른다. 앞선 미실행/미승인 문구는 당시 기록이다. DI03·L2 전 화면 통합·Git/최종 인수 대기는 유지한다.

- 작성: Development / AGT-DEV-0004 / 2026-11-22 KST.
- 상태: **LOCAL_PLAN_REVIEW / IMPLEMENTATION_VALIDATION_NOT_AUTHORIZED / REMOTE_NOT_SENT**.
- 기준 main: `97cc5472f11a97d5f7d7c1b89dc12edeace36e1f` (PR #168). 로컬 브랜치: `codex/DEV-027-session-pipeline-plan`.
- 이번 실제 변경은 문서5개이며 제품 구현·게임 검증은 하지 않는다. 다음 실행 후보22개는 §7에 따로 열거한다.
- [티켓](../tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md) / [결과](../tasks/DEV-027_RESULT.md) / [기존 실행 계획](DEV-027_EXECUTION_VALIDATION_PLAN.md) / [P1 실제 계약](DEV-027_W04B_SUPPLY_CONTRACT.md).

## 1. 권한·근거와 다음 단위

Owner의 이번 요청은 #92·#146을 반영한 **다음 착수 범위·실행/검증 계획의 로컬 준비**다. 구현·제품 검증 및 Commit·Push·PR은 별도 승인이고 main 병합도 포함하지 않는다. 원격 댓글 게시도 이번에 수행하지 않는다.

다음 단위는 기존 계획 P3를 나눈 **P3-A: 비의존 Session·Pipeline 연결 + L2 입력 공급**으로 제안한다. 기존 P2는 DEV-026 공통 계약 단계이므로 번호/소관을 바꾸지 않는다. 이후 **P3-B: 수용된 행의 화면 통합**, **P4: 고정본 GUI·자연 VS-02·독립 심사**는 별도다. P3-A를 만들기 전에 화면 최종 L2를 요구하지 않지만, 실제 화면은 해당 L2 전 연결하지 않는다.

| 근거 | 이번 적용 |
| --- | --- |
| [#146 Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7071238985), [Track A 행별 요청](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7072620059), [DEV 실제 공급 대조](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7072796715) | UI01~14의 모델 의미와 실제 Session/소비 연결을 구분. INTEGRATION_NOT_SUPPLIED / L2_FINAL_PENDING / GUI_NOT_REQUESTED_NOW 유지 |
| [#92 기존 공급안](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7071365138), [NR/DA 인계](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7072803420), [DEV 후속 대조](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7072852286) | NR01~13·DA01~08 수신 완료. 실제 이름/장비/폰트·제품 적용과 분리. 같은 최초 회신/선택 재요청 없음 |
| [PR166](https://github.com/wisberry2022/MetroManager/pull/166), [기존 P1 증거](../evidence/DEV-027_W04B_VS02_RESULTS.json) | P1 제출 head `5d4163991e341b5c8407e73cafdcff5c05bad913`, 병합 `5d7f57fd6c47df1747cb312d996c73c77338e4f9`. 실제 시험 base `1a941196cc6d963db93a9fba6a0386b16710aa46`+시험 파일 해시를 보존. 자동425·회귀805·로드/당시 CI를 새 main 실행으로 바꾸지 않음 |
| [PLN016 Owner 결정](../../planning/tasks/PLN-016_E01_OWNER_DECISION.md), PR163 | A1+B1 정책 질문2건은 결정 완료. DI-03 실제 생성/수요/소비/재접수 구현·검증 대기는 계속 유지 |
| [PM021](../../hq/tasks/PM-021_STAGE3_F08_DIRECTIONS.md), [DEV026 수용](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7057161624) | 기존 방향/수용·PARTIAL/미관측·P07 구분 재사용. F08 전체 확정을 W04B 비의존 연결의 공통 차단으로 추가하지 않음 |

P1 병합 이후 이번 기준까지 차이는 INF013 문서3개와 PR168 디자인4개다. 제품/검사·기존 DEV 문서는 동일하다. 과거 문서의 승인 대기·NOT_SENT·미병합·DI03 정책 미답변 문구는 당시 이력이며, 위 링크가 현재 상태를 설명한다.

## 2. 실제 공백과 P3-A 포함·제외

| 층 | 실제 현재 코드 | P3-A의 결과물 / 남길 경계 |
| --- | --- | --- |
| P1 서비스 | ProposalService의 edit/predict/submit/result/advance_to/snapshot, 독립 RNG·원장 계약 | 기존 의미 재사용. 공유 분 단계 연결·명령/관측 어댑터만 보완 |
| Session | Stage1Session에 W04B 초기화·명령·봉투 없음 | 명시적 활성화, 슬롯/ID 기반 편집·예측·심사/계약 요청·결과 조회, 지역 봉투 공급. main/View 버튼·화면 호출은 추가하지 않음 |
| Pipeline | W04A/공사/운영만 설치. 공사 enable·snapshot·운영/다음 조회가 tender 전제 | 같은 clock/ledger/reports 안에서 W04B 처리. proposal만 있는 초기화와 W04A 호환을 검사 |
| 사업 출처 | BusinessSources.collect는 독립 읽기 변환이며 소비자 호출 없음 | 실제 허가 사본·계약·지급을 공사/운영/보고/다음 후보까지 연결. 새 원장/가짜 tender/공사 상태 주입 금지 |
| 공사 모델 | ConstructionProject._init이 source.terms.station_ids에 직접 의존 | 정상화한 실제 source의 station_ids와 출처 식별을 소비하도록 최소 수정. 공사 비용·기간·공정/시험 규칙은 그대로 |
| L2 소비 계약 | 모델 snapshot과 기존 root/지역 guard만 존재 | root/지역·행동/사유·현재/당시·scope/revision 의존표와 실제 Session 출력 표본. 화면 렌더 완료가 아님 |
| 이름·아트 | NR/DA 문서 인계 완료, 제품 이름/자원 미공급 | 문서에 적용 시점/부족 입력만 연결. 이름 loader/읽기 Control·폰트/환경 계측·아트는 제외 |

**P3-A 완료 검토선:** 승인된 비의존 연결의 필수 자동/로드 미충족0, 실제 Session 명령/표본과 실행 식별·지역 의존표를 로컬 L2 검토 패킷으로 준비한다. 실패가 남으면 정확한 행·원인·최소 보완을 기록한 미완료 검토본으로 제출하며 P3-A 완료로 표시하지 않는다. Design L2 수용·독립 GUI·자연 VS-02·Stage 인수는 별도 상태다.

## 3. 연결 방식 — 실행 승인 뒤 구현할 계약안

### 3.1 초기화·명령과 상태 권위

1. Pipeline이 ProposalService를 한 번 소유하고 **기존 ledger 객체**·같은 network/예측 parameters·Session scope·명시적 seed·현재 완료분을 주입한다. loader 실패는 W04B unavailable로 공급하며 다른 유효 지역을 초기화하지 않는다. 재활성화/조회/화면 왕복으로 seed·심사/사업 계보를 초기화하지 않는다.
2. Session은 명시적 활성화 API를 제공하되 `scripts/main.gd`와 View에서 호출하지 않는다. P3-A 검사에서 실제 Session API로 활성화한다. 따라서 제품 연결 가능한 공급 API와 OS 입력 진입/화면 통합을 구분한다. 활성화하지 않은 기존 W04A 실행 경로를 보존한다.
3. 편집·예측·심사·계약 요청은 안정 slot/사업 ID와 현재 기대 plan/input 또는 decision 참조를 전달한다. seed/ledger/parameters·판정 강제값은 사용자 명령에 포함하지 않는다. 요청 scope를 먼저 확인한 뒤 같은 command_id 재요청은 당시 결과를 재사용한다. 편집/예측도 Session 어댑터에서 중복 실행 경계를 명시한다. 새 ID의 명시적 요청과 동일 요청 재전송은 다르다.
4. 단순 조회판 진전은 의미판 변경이 아니다. 현재 행동 가능/사유와 당시 요청 실패·제출 사본을 각각 공급한다. 현재 초안·예약 당시 사본·심사/보류 사본·허가 계획·계약을 서로 대체하지 않는다.
5. 네 심사/계약 `action_states`, 계획의 편집 `allowed_actions`, **명시적 예측 가능/불가·사유**를 구별한다. 슬롯/읽기 대상 선택은 권위 명령이나 심사 효과로 계산하지 않는다. 최종 API/필드명은 실제 공급 계약에서 명시하며 이 계획의 후보명을 구현 완료로 표시하지 않는다.

### 3.2 같은 분의 처리와 공유 원장

기존 계획 §4.3·SEM-03을 적용한다. 외부 GameClock만 시간을 전진시키고 서비스는 Pipeline이 전달하는 각 분을 순서대로 처리한다. `clock.minute`가 일괄 진전한 최종값을 중간 tick의 현재분으로 오용하지 않는다.

- 이전 구간 운행비/공정 → 자정 마감 → **W04B 완료 심사·예약 심사 접수** → 기존 CONTRACT → PROGRESS → VALIDATION → ARRIVAL → SETTLEMENT → BOARDING·보고 동기화를 유지한다.
- 현 P1 `advance_to`의 `_admit_due`는 사업계약 지급까지 처리한다. 이를 그대로 마감 앞이나 공사 뒤에서 호출하지 않는다. **심사 완료/접수와 사업계약 효력을 단계별로 분리**하고, 독립 모델의 advance_to는 동일 의미의 호환 진입점으로 유지한다. 같은 분 중복 처리·후퇴를 거부한다.
- CONTRACT 내부 후보 순서는 기존 일반 계약 → W04A → W04B 사업계약 → W05 공사계약으로 특정한다. 기존 단계 상호 순서는 보존한다. W04B 내부 동시 요청/심사는 등록 순서·기존 안정 식별로 처리하며 임의 Dictionary 순서에 의존하지 않는다. 공동 원장 경쟁·기존 동시 시공/운영 제한의 의미가 달라지는 사례는 구현으로 새 정책을 만들지 않고 해당 행 RFC로 보고한다.
- T에 관측하고 요청한 명령은 T+1 이상/업무시간 경계로 이동한다. 예약 중 편집은 효력 재검사 실패·명시적 새 요청으로 연결한다. 유효 접수 때 잠금/회차/설득 사용을 확정하고 접수 실패는 이를 소비하지 않는다.
- 허가800000/640000과 실제 지급·사업계약·공사계약/착공을 분리한다. 기존 ledger API로 사업별 R/K·거래를 1회만 생성한다. 뒤 단계 도착 운임으로 앞 단계 계약을 성사시키지 않는다. 동일 요청/조회/반복 tick의 추가 RNG·지급은0.
- DI03 사건 생성 단계는 설치하지 않는다. 실패+1440 메타데이터·DI03_PENDING만 유지하고 시간이 지났다는 이유로 facts를 만들거나 재접수 제한을 풀지 않는다.

### 3.3 W05/W06·보고/다음 후보

BusinessSources를 정상화 경계로 사용한다. 공고와 제안의 출처를 `source_kind/source_id`로 구분하고, 허가 계획 → business_contract_id/project_id → government_payment.transaction_id/원장 항목 → construction_contract_id → 운행 source → 보고일/첫 유효 보고를 연결한다. 제안을 `tenders[].terms`로 위장하지 않는다.

공사 서비스/ConstructionProject는 정상화한 계획을 소비한다. W04A 기존 입력 호환은 유지하고, W04B 미계약 허가·잘못된 지급·중복 출처·변조 계획·다른 원장/분/판은 거부한다. 미설치 출처와 설치 실패 출처를 같은 정상 빈 배열로 처리하지 않는다. 새 출처 오류가 기존 정상 W04A까지 차단하는지 실제 의존별로 검사한다.

운영은 기존 단일 출처 바인딩·실운행 규칙을 보존한다. source 식별을 재대조하되 매 조회마다 운행/소수 carry/cohort를 새로 만들지 않는다. **E01 수요 변경을 제외한** 표준 공사→시범60/안전60→개통→실제 통행/운임→첫 유효 보고를 자동으로 대조한다. 운행1/동시 시공 제한을 여러 사업 지원으로 확대하지 않는다.

다음 후보는 기존 tender 응답을 보존하면서 제안의 명시적 출처/행동 대상을 구분해 공급한다. 보고 확인/후보 조회가 새 계약·심사·난수 추출을 만들지 않으며 기존 P07의 첫 유효 보고·고정 보고일·현재금/과거 실적 구분을 유지한다. P07 화면의 새 이동 버튼/복귀는 P3-B다.

## 4. L2 공급 준비 — 화면 없이 만들 수 있는 입력

### 4.1 root·지역 봉투 제안

기존 root `ui_contract_revision/run_scope/view_revision`과 observation의 완료분/원천판을 유지하고, 선택적 W04B 지역을 추가한다. 제안 데이터의 data_version1.4를 root/기존 W04A의1.3에 덮어쓰지 않는다. 모델 snapshot_revision과 Session view_revision은 서로 다른 판이며 양쪽 식별을 연결한다. 기존 root 판을 일괄 변경할 필요가 생기면 호환 영향부터 재검토한다.

| 지역/입력 | 권위·유지/제한 |
| --- | --- |
| root 무효 | W04B 관측/행동은 미확인. 낡은 상태를 현재처럼 표시하지 않음. 기존 root guard 의미 보존 |
| root 유효·W04B만 누락/오류/비활성 | W04B 의존 읽기/명령만 unavailable. 유효 자금/기존 보고 등은 각 지역의 권위로 유지 |
| plan/예측·심사/판정·계약 | 각 원천 사본/판·nullable 시각·available/status/reason을 구분. 유효0·미계산·실패/미공급을 서로 바꾸지 않음 |
| old scope/오래된 관측 | 현재 Session에서 고정한 소속/관측 하한으로 거부. 수신 자료가 기대 scope를 결정하지 않음 |
| 같은판 재수신 | 같은 내용은 읽기/표본 재사용만, 추가 명령/추출/지급0. 같은판의 상충 내용은 계약 불일치로 거부하며 정상 갱신으로 채택하지 않음 |
| fact_supply | available=false·DI03_PENDING와 정상 공급된 적격 사실0건을 구별. UI11~12의 한계로 유지 |
| 같은/새 Session | 같은 Session의 유효 business/decision 식별 유지, 새 scope에 옛 응답/사본 이관 금지. Control 수명·focus 복귀 실측은 P3-B/P4 |

guard에는 W04B 지역의 타입/판·소속/의존 검증만 추가한다. UI가 원시 모델을 무검증 완성 payload로 소비하지 않게 하며, 서비스의 실제 허용 행동과 소비 거부 조건을 분리한다. RP/EX는 Track B, 기능 흐름/행동 영향은 Track A가 검토한다. S01 전용 fallback 순서를 W04B/P07에 일괄 적용하지 않는다.

### 4.2 최소 표본 목록

표본마다 입력/기대/실제, 실행 식별, Session API·결과·원천 snapshot·지역 봉투, 당시/현재 사본, scope/revision/시각, command/review/decision/contract/거래/보고 키를 묶는다. **실제 Session 출력 / 순수 모델 출력 / 표시·오류 fixture**를 명시한다.

| 표본 | 연결 행 | 필요한 대조 |
| --- | --- | --- |
| L01 정상 편집·예측/시청/정부 | UI01~07 | 슬롯/ID, 편집·예측·네 action_states 차이, 요청→접수→30/60분 판정 |
| L02 시간 외 예약·정지 | UI04~05 | T60→360·T360→361·T1439/1440→1800, pause/배속/분할 시간과 실제 기간 |
| L03 예약 뒤 편집·재검사 실패 | UI02/04/06 | STALE_PLAN_OR_PREDICTION·admitted_at=null·새 요청 필요, 동일 ID 멱등/새 ID 요청 |
| L04 접수 잠금·시청 뒤 초안 변경 | UI02/05~07 | 잠금과 읽기 자료 분리, 당시 시청 결과와 현재 정부 제출 불가 사유 |
| L05 보류 사본·설득 사용 전후 | UI09~10 | 현재 초안과 당시 보류 사본, 예약/유효 접수/1회 사용·성공/실패 |
| L06 허가 후 미계약/계약 지급 | UI08/10/13 | 800000/640000 허가·공유 원장 실제 지급, 중복0·실패 원자성·공사 인계 |
| L07 DI03 미공급 | UI11~12 | 실패 제한·+1440 메타데이터만. 실제 fact/수요/소비·성공 재접수 NOT_RUN |
| L08 예외 봉투 | 공통 RP/EX | root/W04B 지역 오류·old scope·같은판 동일/상충·새 Session, 독립 지역 보존 |
| L09 사업→공사→실제 영업/보고 | UI13~14 | 같은 허가 계획/지급·공사 source, 완료 통행/첫 유효 보고·다음 후보 조회 효과0 |
| L10 유효0/음수·오류 | UI03/06 | 명시된 예측 fixture와 실제 정상 출력 구분. 유효0을 미계산으로 표시하지 않음 |

P1의 DIRECT/HELD_FAIL/HELD_SUCCESS/REJECT·pending_edit 등은 기존 모델 증거로 연결한다. 새 Session 경로에서 확보한 출력만 신규 공급으로 표시한다. 기존 seed2/0/8/1을 고정 엔진에서 재사용하며 이번 단위에 새 seed 탐색·결과 강제 주입을 추가하지 않는다.

실제 L2 패킷은 §7의 신규 증거2개와 기존 공급 계약 후속 절로 만든다. 기존 P1 JSON/Markdown/원본 로그는 그대로 둔다. 각 행의 **실제 위치·full SHA 또는 base+파일 해시 / 입력·표본 / 재사용·미공급 / 보완 담당 / 차단 시점**을 기입하고 P3-B 수용을 기다린다. 이 로컬 계획 자체는 실제 표본 패킷이 아니다.

## 5. #92 반영·미공급 입력·DI03 대기

| 구분 | 공급된 것 | 실제 부족/후속 담당 | 차단 범위·시점 |
| --- | --- | --- | --- |
| N1 이름 | [NR01~13](../../design/tasks/DSG-008_STATION_NAME_READING_CRITERIA.md)·DEV schema/namespace 제안 | HQ/Owner의 콘텐츠 작성·승인 담당/공급 창구, 담당자의 승인12행·출처/버전/locale. DEV의 실제 loader/봉투/읽기 Control·L2 | 이름 공급/적용·해당 N 행. P3-A의 ID 기반 모델/Session 전체를 차단하지 않음 |
| NR 실제 보완 | 같은 ID/실제 계획 순서, 비편집 읽기·전체 이름·오류 전체 거부 기준 수신 | 후보 공급 순서 변경 때 기존 Button 재배열, 이름 버전만 변경한 캐시 갱신, 미포함역 읽기와 기존 select 편집 분리. 이름 오류만으로 계획/유효 지도 초기화 금지 | N 별도13후보 경로와 실제 L2 이후. 이번22개에 합치지 않음 |
| E1 환경 | 과거 DEV025 환경/실측·최대4셀 후보 있음 | HQ/Owner: 기준 PC 제공자·검토/제한 배포 목적·현용 배율/접근 창구. DEV: 승인 후 현재 계측 | 지원 환경/가독성·규격 확정 전. 과거 screen_scale1을 OS100%로 전용하지 않음 |
| F1 폰트 | Noto Sans CJK KR2.004 Regular 후보 식별 | DEV: 실제 파일/고지·SHA256·fallback 구성, 반입/평가 권한. Track B: 해당 판독 | 반입/채택/제품 적용 전. 현재 기본/fallback 유지 |
| A1 아트 | [DA01~08](../../design/tasks/DSG-008_MINIMUM_DIORAMA_ART_HANDOFF.md) 목록 수신 완료 | DA01~03 참고/조건부 제작, DA04~08 draw/Control 재사용. 실제 교체 선택 때 Track B source/export/권리·치수/필터와 DEV 정확한 경로 | 신규 이미지 필수0. 8역할≠8이미지. 참고 PNG를 제품 자원으로 채택하지 않음 |
| DI03 | PLN016 A1+B1 정책 완료·기존 P1 대기 메타데이터/순수 자격 fixture | DEV의 실제 대상 동/OD·최초1회 사건·×5/4 예측/실운행·carry·소비/재접수, 해당 공급/검증은 Owner 별도 승인 대기 | UI11~12의 종속 구현만 보류. 시간이 지나도 적격 사실을 가정하지 않음 |
| UI·독립 인수 | #146 모델 사전 대조·DEV026 기존 수용 | 실제 L2 패킷→Track A/B 행별 수용→화면 통합 권한→고정본/정상 진입·독립 실행 범위 | P3-B/P4. P3-A 입력 준비의 선행 조건으로 역전하지 않음 |

DI03 후속에는 실패 근거 계획의 고유 출발 동, 동일 사업 총1회·T+1440/×5/4, 사업별 영향·기존 carry/cohort 보존, 성공 접수 소비/실패 미소비·후속 심사 실패 시 미복원을 적용한다. 이번에는 구현·종속 실행을 하지 않는다. 과거 정책 미답변 표현을 현재 미결로 되돌리지 않는다.

## 6. 실행 순서와 승인 단위

1. **현재:** 문서5개·정적 검사만. 다음22경로·자동/로드/증거 작성의 로컬 실행 승인을 검토 요청한다.
2. **승인 후 P3-A-1:** 공유 초기화·분 단계·출처 어댑터, W04A 호환과 공사/운영 실제 연결. L01~07/L09의 Session 명령·정상 출력 확보.
3. **P3-A-2:** 지역 guard·예측 행동/사유·버전/의존표, L08/L10 및 실제/fixture 구분. 관련 회귀/로드·원본 보관 후 로컬 결과/L2 패킷 검토 요청.
4. **원격 전달:** 결과 검토 뒤 별도 승인된 문서/구현의 Commit·Push·PR 또는 댓글 동작만 수행. 이번 요청으로 자동 게시하지 않는다.
5. **P3-B:** Track A/B 해당 실제 행 L2 수용과 별도 실행 범위 승인 후 main 진입·proposal View/씬·P05/P06/P07 왕복/현재 행동 UI를 연결한다. 코드/명령·증거 변경 시 영향 행만 재대조.
6. **P4:** 정상 제품 입력/실제 RNG·계약/공사/영업/보고/다음 조회의 고정 시험본과 독립 주체·범위가 준비된 뒤 GUI/자연 VS-02. 자동 체인·fixture를 자연 완주로 표시하지 않는다.

## 7. 정확한 변경 경로

### 7.1 이번 로컬 문서5개

신규 `docs/engineering/gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md`, 수정 `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md`, `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md`, `docs/engineering/tasks/DEV-027_RESULT.md`, `docs/engineering/tasks/DEV-027_PROVENANCE.json`이다. 기존 Markdown3개 전체를 보존하고 최신 안내/후속만 추가한다. 기존 provenance는 기준 main에 보존하고 이번 Markdown4개 blob을 별도로 선언한다.

앞선 F08 검토 worktree의 미게시6파일은 복사/덮어쓰기/제출하지 않는다. 공식 #92/#146 댓글로 필요한 의미를 연결하므로 그6개 게시를 새 종료 조건으로 만들지 않는다. 나중에 두 로컬 문서를 함께 제출하려면 공통 파일의 후속 기록을 비교해 보존하며 자동 덮어쓰기하지 않는다.

### 7.2 다음 P3-A 실행 후보 — 최대22개 / 현재 미승인

원래 §8.1의41개는 포괄 실행 승인이 아니다. 아래는 **제품8 + 검사6 + 문서/증거8**의 제한된 후속 제안이다. 기존 파일 UID는 그대로 사용하며 실제 변경 없는 파일은 제출에서 제외한다.

| # | 정확한 경로 | 구분·목적 | 기존41개 |
| --- | --- | --- | --- |
| 1 | `scripts/ui/stage1_session.gd` | 수정: 초기화/명령/봉투·사업/보고 공급 | 안 |
| 2 | `scripts/simulation/minute_pipeline.gd` | 수정: 공유 분·원장/출처·단계 연결 | 안 |
| 3 | `scripts/simulation/proposal_service.gd` | 수정: 심사/사업계약 단계 분리·호환 처리 | 안 |
| 4 | `scripts/simulation/business_sources.gd` | 수정: 실제 출처/소비 봉투·지급/계획 검증 | 안 |
| 5 | `scripts/simulation/construction_service.gd` | 수정: 제안 출처 공사 후보/명령·W04A 호환 | 안 |
| 6 | `scripts/model/construction_project.gd` | 수정: tender.terms 직접 의존 제거·정상화 source 소비 | **밖·추가 필요** |
| 7 | `scripts/simulation/operations_service.gd` | 수정: 실제 사업 출처·보고/다음 후보·W04A 호환 | 안 |
| 8 | `scripts/ui/s01_observation_contract.gd` | 수정: 선택적 W04B 지역·오류/소속/판 검증 | **밖·추가 필요** |
| 9 | `tests/game/w04b_fixtures.gd` | 수정: 공급/오류 fixture의 명시적 분리 | 안 |
| 10 | `tests/game/run_w04b_tests.gd` | 수정: 단계 호환·P1 직접 영향 검사 | 안 |
| 11 | `tests/game/run_proposal_ui_tests.gd` | 신규: 화면 없이 Session/봉투/guard 계약 검사 | 안 |
| 12 | `tests/game/run_proposal_ui_tests.gd.uid` | 신규: 검사 UID | 안 |
| 13 | `tests/game/run_vs02_tests.gd` | 신규: 실제 Session/Pipeline 자동 체인·회귀 | 안 |
| 14 | `tests/game/run_vs02_tests.gd.uid` | 신규: 검사 UID | 안 |
| 15 | `docs/engineering/gate3/DEV-027_W04B_SUPPLY_CONTRACT.md` | 수정: 실제 API/봉투/의존표 후속, P1 원문 보존 | 안 |
| 16 | `docs/engineering/gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md` | 수정: 현재 계획에 승인/실행 후속 | **밖·이번 신규** |
| 17 | `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md` | 수정: 현재 단계/실행 연결 | 안 |
| 18 | `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md` | 수정: 승인 원문/실제 경로 | 안 |
| 19 | `docs/engineering/tasks/DEV-027_RESULT.md` | 수정: 검증/미해결/로컬 검토 | 안 |
| 20 | `docs/engineering/tasks/DEV-027_PROVENANCE.json` | 수정: 실제 변경 출처·blob | 안 |
| 21 | `docs/engineering/evidence/DEV-027_SESSION_PIPELINE_L2_RESULTS.json` | 신규: 실행 식별·표본/검사/원본 해시 | **밖·추가 필요** |
| 22 | `docs/engineering/evidence/DEV-027_SESSION_PIPELINE_L2_EVIDENCE.md` | 신규: 행별 L2 공급·검증·미공급 색인 | **밖·추가 필요** |

기존41개 안17/밖5다. 특히6번은 현재 소스 조사로 추가된 경로이며 기존 승인을 넓혀 해석하지 않는다. 검사명에 UI/VS02가 있어도 이 단위는 headless 계약/연결 검사다. 새 runner/CI 자체를 부서 인수의 영구 의무로 추가하지 않는다.

**제외:** `scripts/main.gd`, `scripts/ui/stage1_view.gd`, `scripts/ui/stage1_map.gd`, `scripts/ui/proposal_view.gd`·UID, `scenes/proposal_panel.tscn`, GUI/VS02 관측기·씬; `proposal_demand_profile.gd`·UID, `demand_predictor.gd`, `operating_line.gd`의 E01/수요/carry 변경; 이름/폰트/Theme/아트·환경 E/F/N 경로; 기존 P1 증거2개·raw/GUI 원본; 원본 데이터2개·CompanyLedger/GameClock·기획/디자인/HQ 문서·CI/도구/설정/훅. 필요한 변경이 목록을 넘으면 해당 경로/이유부터 로컬 재검토한다.

## 8. 승인 후 검증 계획 — 현재 제품 검증 NOT_RUN

| ID | 종류·필수 기대 | 영향/원본 |
| --- | --- | --- |
| V01 | 실제 Session 활성화·중복/실패 초기화·scope/seed/ledger 동일성, 비활성 W04A 호환 | L01, 공유 원장 단일성·기존 기본 진입 불변 |
| V02 | 요청/효력·업무시간·pause/1·2·4배속·분할/일괄 일치, 자정 마감 전후·분 단계 | L02~04, trace·회차/시각/RNG/거래·보고 대조 |
| V03 | 동일 ID/다른 payload 멱등·old scope 선검사·편집/예측 중복0, 예약 후 편집·새 요청·잠금/사본 | L03~05, 실제 Session 출력과 오류 fixture 분리 |
| V04 | 기존 정상 seed의 정부/설득 분기, 허가/계약/지급 분리·중복0·실패 원자성 | L05~07, P1 계보 재사용·DI03 미공급 보존 |
| V05 | 실제 지급/허가 계획→공사/시험/개통→완료 통행/보고/다음 조회, W04A와 제안별 단일 사업 검사 | L06/L09, 다른 ledger/소속·변조/중복 출처·금액·같은분 경쟁/동시 제한 반례 |
| V06 | root/W04B 지역 실패·old/same revision·실제 행동/사유·유효0/미계산·새 Session | L08/L10, 독립 자금/보고 유지·DI03 unavailable≠사실0 |
| V07 | 기존 영향 회귀 | W02/W04A/W05/W06·W07/입찰/공사/운영 UI·S01/VS01: 공유 Pipeline/Session/guard 변경 영향. W03은 예측 입력/의미가 바뀐 경우 추가하며 P1 원 실행을 그대로 보존 |
| V08 | 고정 엔진 프로젝트 로드·검사 정상 exit0/고의 실패 exit1, SCRIPT ERROR/ERROR도 별도 검사 | exit0만으로 PASS 처리 금지, 실패/timeout 원본 보존 |
| V09 | 문서/경로/출처·정상 정책 검사 | 실제 변경≤22·계약/표본 식별·DI03/L2/GUI/독립 상태 분리 |

예정 명령(실제 구현 승인 후 존재/옵션·엔진 경로를 먼저 고정):

```text
.venv/Scripts/python.exe tools/policy.py doctor
.venv/Scripts/python.exe tools/policy.py check
<Godot> --headless --path <worktree> --script res://tests/game/run_w04b_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_proposal_ui_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_vs02_tests.gd
<Godot> --headless --editor --path <worktree> --quit
```

기존 회귀 대상은 아래 파일명으로 특정한다.
`tests/game/run_w02_tests.gd`, `run_w04a_tests.gd`, `run_w05_tests.gd`, `run_w06_tests.gd`, `run_w07_tests.gd`, `run_tender_ui_tests.gd`, `run_construction_ui_tests.gd`, `run_operations_ui_tests.gd`, `run_s01_exception_tests.gd`, `run_vs01_tests.gd` (모두 tests/game/). 실행만으로 변경 경로가 추가되지는 않으며 수정이 필요하면 정확한 경로를 먼저 확인한다.

새 runner 고의 실패 옵션은 구현 때 실제 지원을 확인하고 정상 실행과 별도 보관한다. 동일 조건의 의미 없는 전체 GUI 반복·F08 전수 조합·새 성능 목표는 추가하지 않는다.

원본 위치 제안: `.local/validation/DEV-027/session-pipeline/<run-id>/`. base full SHA+전체 변경 파일 SHA256(커밋 후 해당 full SHA), 엔진 버전/바이너리 해시·실행 주체/종류·명령·입력·기대/관측·exit/오류·raw 경로/해시·L/V/UI/RP/EX 행을 기록한다. 처음 실패와 수정 후 성공을 둘 다 보존한다. 공개 증거는 최소 JSON/색인만, 추가 PNG Git 반입은 별도 정확한 경로다.

자동 연결 완료와 자연 GUI 완주를 분리한다. P3-A의 게임 자동/로드는 실행 승인 뒤 수행할 예정이며 **현재 NOT_RUN**. DEV GUI·독립 실행·Design 심사·자연 VS02·성능·빌드/export는 P3-A에서도 제외/대기다.

## 9. 검토 요청·완료 판단

Owner가 검토할 다음 실행 범위는 **§7.2 최대22경로의 P3-A 로컬 구현, §8 자동·영향 회귀·프로젝트 로드, 실제 L2 패킷 로컬 준비**다. 이번 계획 작성 승인을 실행 승인으로 기록하지 않는다. 화면/DI03/E/F/N·반입/GUI·Git/병합 권한은 함께 요청하지 않는다.

실행 후에는 실제 변경 파일·명령/증거·실패/미해결·새 명세 변경 필요 여부를 로컬 결과로 먼저 제출한다. 공급 완료 행/미공급 행과 L2 대기·화면/자연 실행 잔여를 분리한다. 일정/공수 NOT_ESTIMATED이며 미공급 입력/실행 범위가 정해진 뒤 산정한다.

새 게임·경제·시간·세이브 명세 변경 요구는 현재 없다. O01~07/S1/E1/F1/N1/A1/P1·Stage2 기존 수용·#97 기술 종료, DEV026 한정 수용/PARTIAL·미관측·P07 일반 재진입/저장 문맥 복귀 구분, #92/F08 OPEN·FINAL_SPEC_PENDING·PRODUCT_APPLICATION_SCOPE_PENDING, S3-10-C·S3-12/HQ·Owner 최종 인수를 보존한다. P3-A 완료도 DEV027/Stage DONE 선언이 아니다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 10. 승인 후 P3-A 실행 후속 — 2026-11-22

> Owner 승인 원문 — 본 개발 대화
>
> DEV-027 P3-A의 착수 범위와 실행·검증 계획을 승인합니다. 계획서의 최대 22개 경로 안에서 Session·Pipeline 연결과 L2 공급 준비를 구현·검증하고, 로컬 결과부터 검토 요청해주세요. DI-03 종속 범위와 L2 전 화면 통합 대기는 유지하며, Commit·Push·PR·main 병합은 별도 승인하겠습니다.

**LOCAL_IMPLEMENTATION_REVIEW / L2_INPUT_SUPPLIED_LOCALLY / L2_ACCEPTANCE_PENDING / GIT_NOT_AUTHORIZED**.

- base `97cc5472f11a97d5f7d7c1b89dc12edeace36e1f` + [실행 소스 SHA256](../evidence/DEV-027_SESSION_PIPELINE_L2_RESULTS.json). 실제 변경 **22개 = 제품8 + 검사6 + 문서·증거8**. 목록은 상세 계획 §7.2를 그대로 따른다.
- 모델/Session/자동 연결 **677개**, 영향 회귀 **3204개** 정상 통과. 프로젝트 로드 오류0, 새 runner2개의 고의 실패 exit1 검출. 자동 검사는 GUI·자연 VS02·Design/독립 수용이 아니다.
- 실제 Session opt-in·공유 시계/원장, 마감 뒤 심사·CONTRACT 지급 분리, 허가 사본/지급→공사→실제 운행/첫 보고/후보 조회를 연결했다. W04A 기존 기본 진입과 뒤늦은 W04B 활성화를 검사했다.
- `proposal_ui`/지역 guard 및 L01~10 실제 출력·오류/표시 fixture를 [L2 색인](../evidence/DEV-027_SESSION_PIPELINE_L2_EVIDENCE.md)에 준비했다. main/View·화면 호출은 추가하지 않았다.
- DI03 생성·×5/4 수요/소비/재접수, 이름12행/실제 loader·폰트·환경·아트 적용은 미실행. PLN016 A1+B1 결정 완료를 보존하며 정책 미답변으로 되돌리지 않는다.
- DEV026 한정 수용·PARTIAL/미관측·P07 구분, #92/F08 FINAL_SPEC_PENDING, S3-10-C·S3-12/HQ·Owner 최종 인수 대기를 유지한다. 신규 게임 명세 변경/RFC 요구 없음.
- Commit·Push·PR·CI·main 병합·원격 댓글은 미실행/별도 승인. 이 결과는 P3-A 로컬 검토 요청이며 DEV027/Stage DONE 또는 Design 수용 선언이 아니다.

§1~9의 미승인/NOT_RUN 표기는 승인 전 기준 이력이다. 이 후속에서 승인된22개만 실행했으며 P3-B/P4·DI03 범위는 확장하지 않았다. 승인 전 원본5개는 approval/에 보관했다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 11. P3-A Design 판정·다음 화면 단계 — 2026-11-22

[PR #171](https://github.com/wisberry2022/MetroManager/pull/171)은 main `cc8814097634013be8df8b27f166bdee09c7bac6`에 병합됐다. 제출 head `a9111742a74c7369ab7c52f5e24ef5ca51d2c217`와 병합 tree가 동일하며 기존 모델/연결677·영향 회귀3204·로드/의도 실패 및 필수 CI는 원 실행 식별로 재사용한다. 이번 새 게임 실행이나 최신 main 자연 VS02 결과가 아니다.

- [Track A / AGT-DSG-0004](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7073746341): **TRACK_A_P3A_L2_LIMITED_ACCEPTANCE**. 비의존 기능 공급·백엔드 연결 한정 수용, 기능 의미의 추가 필수 수정 없음. UI11은 제한/미공급 의미만, UI12 실제 DI03은 보류.
- [Track B / AGT-DSG-0003](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7073690611): **P3A_SUPPLY_REVIEWED / TRACK_B_STATIC_NO_OBJECTION / SCREEN_ACCEPTANCE_PENDING / GUI_NOT_REQUESTED_NOW**. 공급 의미 이견 없음이며 실제 화면/표현·읽기·수명·복귀 수용은 별도다.
- 과거 P1의 Session/Pipeline 미공급, 승인 전 Git/실행 대기는 당시 이력이다. 원문·기존 검증·raw·실제/fixture 구분과 DEV026 한정 수용/PARTIAL·미관측·P07 구분을 보존한다. DI03 실제 종속 구현·검증 및 S3-10-C·S3-12/HQ·Owner 최종 인수 대기도 유지한다.

기존 P3-A22개 실행 범위와 당시 제외 경로를 유지한다. 다음은 [P3-B 화면 계획](DEV-027_SCREEN_INTEGRATION_PLAN.md)의 최대19경로 후보이며 기존22개 승인에 덧붙이지 않는다. 실제 화면 제공은 P3-B, 고정본 GUI/자연 VS02·독립 심사는 P4다. P3-A에 화면이 없다는 이유로 기존 공급을 미공급/재승인 대기로 되돌리지 않는다. 이번 신규 제품 자동/로드/GUI는 모두 NOT_RUN이다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
