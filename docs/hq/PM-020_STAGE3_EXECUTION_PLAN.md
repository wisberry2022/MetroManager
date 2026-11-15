# PM-020 — Stage 3 진입·목표·부서 실행 요청안

- HQ / AGT-PM-0002 / 2026-11-15 (Asia/Seoul).
- 상태: **STAGE2_DONE / STAGE3_ENTRY_PREPARATION / PLAN_REVIEW / PER_TICKET_AUTH_REQUIRED**.
- 기준 main: `96c51ae6c3352195b9a8e8b89f92dd51c13be81c`.
- [Owner 요청·이번 HQ Git 범위](tasks/PM-020_STAGE3_ENTRY_PLAN.md) / [검증 결과](tasks/PM-020_RESULT.md).
- Owner는 Stage 3 진입·목표·부서별 지시사항을 산출물로 작성하여 PR로 제출하도록 요청했다. **아래 세부 Stage 3 구성·종료 기준은 HQ 검토안**이다. 현재 승인된 MVP 게임 규칙과 Stage 2 최종 인수는 확정 사항이며 재승인 대상이 아니다. 본 PR 제출은 타 부서의 새 구현/Git 권한이나 Stage 3 DONE을 만들지 않는다.

## 1. 현재 출발점과 우선 판단

| 대상 | 확인 사실 | 이번 적용 |
| --- | --- | --- |
| Stage 2 | Owner 최종 인수, PR #144 main 반영, #141 CLOSED(completed) [R01] | W04A→W05→W06·VS-01 및 기존 GUI 수용을 기반으로 사용. Stage 2를 다시 열지 않음. |
| DEV-025 | Owner 로컬 구현·검증 결과 수용, PR #143 신규23파일 병합, 제출 head 필수 CI SUCCESS [R02] | **실험 공급 완료 / Design 검수 대기 / 최종 규격 미확정**. #92/#97의 과거 APPROVAL_PENDING·실험 NOT_RUN을 현재 상태로 사용하지 않음. |
| F-08 / #92·#97 | 원격의 후속 Design 최종 판정은 이번 조회에서 확인되지 않음. Owner도 Design 검수 대기라고 전달 | Track B의 첫 우선 업무는 기존 결과 심사. 최초 기술 회신·공통 샘플·동일 실험을 다시 요구하지 않음. |
| DEV-026 / #104 | L2 대조 준비·기존 후속 기록은 존재하나 구현·제품 검증 HOLD [R03] | 선행 결과가 진전돼도 HOLD 자동 해제 금지. 실제 필요한 영향 범위와 유효 재개 승인을 별도로 연결. |
| W04B / VS-02 | 승인 MVP의 회사 자체 제안 경로가 Stage 2에서 이월됨 [R04]. 현재 `scripts/`·`tests/game/`의 제안 심사/RNG 전용 구현·실행 증거는 확인되지 않음 | **구현 수용 NOT_VERIFIED / 이번 HQ 실행 NOT_RUN**. DEV가 재사용 기반과 실제 공백을 분해하여 제시. 파일명 검색만으로 모든 코드 미구현을 확정하지 않음. |
| INF-012 / #139 | Owner 정본·보관 담당 확정, 백업/복구 이월 승인 [R08] | Stage 3 진입의 공통 차단조건으로 올리지 않음. 이월 의무·NOT_RUN 유지. |

**권고:** Stage 3의 필수 경로는 **회사 자체 제안 W04B → 기존 시공·운행 기반 연결 → 독립 VS-02 완주**로 둔다. 동시에 DEV-025의 Design 검토와 F-08 선택안을 정리한다. 최종 아트·환경 규격이 미확정이라는 이유로 W04B 의미 검토·순수 모델·최소 기능 UI 준비 전체를 멈추지 않는다. 다만 그 규격을 실제로 채택하거나 관련 제품 UI를 바꾸는 작업은 해당 결정/계약을 먼저 확인한다.

## 2. Stage 3 목표와 포함·제외

**플레이 목표:** 독립 초기 상태에서 행정·수요를 확인하고 후보역/순서와 예측을 비교하여 회사 자체 사업을 제안한다. 시청과 정부 심사를 거쳐 사업을 확보하고 기존 표준 공사·시범운행·안전검증·개통·실제 영업을 수행한 뒤, 첫 유효 실적 보고와 다음 사업 후보 조회까지 제품 UI로 이어간다.

| 구분 | 포함하는 결과 |
| --- | --- |
| 기능 경로 A — 필수 | W04B 시청/정부 심사·보류 설득·사업 동일성/재접수·신규 사실·정상 RNG, 계약/사업비의 W05/W06 연결, 해당 실제 UI, VS-02 독립 초기 상태 완주와 실패/경계 증거 |
| 기술·시각 경로 B — 병행 | DEV-025 T01~04·RD-01~08의 Design 판정과 권고, F08-01~04 해결/잔여/Owner 선택표. RD-03/07 관측은 영향 행으로 검토. Stage 3의 산출물은 심사 결과·선택/이월의 명시이며 최종 제품 적용 완료를 선행 가정하지 않음 |
| 통합 | Stage 2 수용 재사용·실제 변경 영향 회귀, AC-01~10·VP-01/02의 기존/신규/미충족 대응, HQ 통합과 Owner Stage 3 인수 |

제외: POST-MVP 회사 상태/평판/협력업체 설계를 MVP로 편입, 새로운 경제·심사 확률·도시/난이도 정책, 저장/불러오기 SHOULD의 임의 MUST 승격, 대량 최종 에셋·전체 고충실도 UI 완성, W09 Windows export/최종 FPS 합격·배포, 외부 사용성 조사/예산 집행, 두 번째 실제 수주나 빠른 공사 전체 E2E의 일괄 추가. DEV-026의 구현·제품 검증은 유효한 별도 재개 승인 전 제외한다.

**Stage 3 완료도 자동으로 전체 MVP DONE은 아니다.** MVP 8개 영역·11 MUST·AC-01~10·독립 VP-01/02와 실행 품질의 최종 인수 범위는 유지한다. Stage 3 말에는 잔여 대응표를 제시하고 실제 증거가 모두 갖춰진 범위만 Owner에게 수용 요청한다. 기존 VS-01 증거를 VP-02에 재사용하되 최종 VP-02 요구와의 차이만 확인한다. [R04, R05]

## 3. 진입 조건과 차단 시점

| 시점 | 필요한 조건 | 현재 판정·다음 조치 |
| --- | --- | --- |
| 계획·분해·정적 협의 | Stage 2 최종 인수, 최신 승인 C/D/DATA·기존 증거 접근 | 충족. 본 요청서의 읽기·담당/범위 확인·준비 회신을 시작할 수 있음. 새 코드 제작 승인은 별개. |
| Stage 3 세부 계획 확정 | 본 문서의 목표·범위·S3 기준·부서 역할에 대한 Owner 검토 | **PLAN_REVIEW**. PR 승인 시 아래 구성 채택 여부를 기록. 별도의 반복 승인 회차를 만들지 않으며 기존 유효 권한은 재사용. |
| 각 모델/화면/검증 작업 착수 | 자기 티켓·정확한 포함/제외 경로·기준 SHA·실행 범위·개별 Git 권한 | 각 담당이 현재 유효한 원문을 연결. 미확인/부족한 범위만 Owner 결정 대상으로 제출. HQ가 DEV/DSG/PLN 번호를 선점하지 않음. |
| 새 UI 통합 | DEV 실제 payload/명령/허용 행동·사유·revision과 Track A L2 대조 | 해당 행에 계약 차이가 있으면 먼저 해결. 문서 의견·표시 fixture·실제 제품 공급을 구별. |
| F-08 규격 종속 적용 | Track B 심사·DEV 기술 조건·Owner 선택 또는 명시된 잠정 적용 범위 | 미확정. 폰트/필터/배치/최소창/FPS를 PM이 확정하지 않음. 관련 적용에만 차단. |
| DEV-026 실행 | RP-01~08/EX 최신 공급 재대조와 Owner의 유효한 재개·개별 실행 승인 | **HOLD 유지**. 준비·읽기·영향 분석과 구현을 구별. |
| Stage 3 최종 인수 | 아래 필수 기준·부서 수용·필수 CI·미해결/이월·Owner 결정 | **NOT_RUN / ACCEPTANCE_PENDING**. 계획 문서 게시·병합만으로 완료 선언 금지. |

## 4. 기존 승인 의미를 사용하는 구현·검증 범위

게임 규칙 정본은 **C v0.7 / D v0.9 / DATA v1.4**, Gate 2·PAR·SEM/CLOSE 및 R01~03 결정이다. 과거 본문의 DRAFT/제안 표현은 최신 승인 절과 함께 읽는다. 아래는 작업 추적 요약이며 정본 수치·정책을 새로 정의하지 않는다. [R04]

| W04B 영역 | 기존 승인 의미와 확인할 경계 | 주 담당·인계 |
| --- | --- | --- |
| 계획·예측·동일성 | 12후보/6~8역·관할/연결·중복/순서·예측 revision·심사 중 잠금. 슬롯/이름/역순/역 교체로 정부 재접수 제한 우회 금지 | DEV가 기존 W03 재사용과 공백 확인, Planning 의미/반례, Track A 사용자 상태·사유 |
| 시청 | 쉬움·시철의 비음수 사업성 승인/음수 거부, 수정 후 재제출. 정부 실패 후 제한과 구별. 업무시간·요청/효력·대기기간은 DATA 정본 적용 | DEV 상태 전이/경계, Planning 계산/행동 의미, Track A 표시 |
| 정부·설득 | 적합/보류/부적합, 보류 설득1회·성공 감액, 실패/부적합 후 재접수 제한. 기존 확률/감액/반올림·기간 유지 | DEV 단위/경계 및 실제 입력, Planning 정답 대조. 강제 분기 fixture는 별도 증거 |
| RNG·신규 사실 | 정상 RNG의 seed/추출 순서 기록, 조회·재클릭·실패 접수의 추가 추출/부작용 차단. 승인 E01의 발생 조건·관련 슬롯·판정 이후 여부·미사용/접수 성공 시 소비·실패 미소비 | DEV 구현/재현, Planning 경계. 성공 seed는 정상 엔진 탐색·기록; 값 주입/강제 성공으로 VS-02 대체 금지 |
| 공통 사업 효과 | 허가·사업 계약·정부 지급·공사 계약/착공은 구분. 중복 계약/지급 방지, R/K/B 및 시점별 실제 자금·기성·보고 의미 유지 | DEV W02/W05/W06 연결. 실제 공통 변경이 있을 때만 VS-01 영향 회귀 |

계약·난수·입력 의미가 모호하거나 구현과 승인 명세가 충돌할 때만 [RFC 절차](../templates/RFC_AND_DECISION.md)로 해당 쟁점·영향·대안을 상정한다. 기존 Owner 결정 전체를 다시 승인 대기로 돌리지 않는다.

## 5. 작업 순서와 부서별 첫 산출물

| 우선순위 | 수행·결과 | 의존성과 종료 신호 |
| --- | --- | --- |
| P0 — 동시에 준비 | Track B는 DEV-025 기존 증거 심사, DEV는 W04B 모델/UI/VS-02 작업 분해, Planning은 승인 규칙/반례 색인, Track A는 신규 화면 상태/검수 행 준비 | 기존 승인·증거로 가능한 준비부터 진행. 같은 파일을 변경해야 하면 HQ가 담당과 순서를 조정. |
| P1 — 모델·계약 | 유효한 실행 승인 아래 W04B 상태/행정/난수/신규 사실·계약 효과 구현·자동 경계 검증 | Planning 의미 차이 해결, Track A가 소비할 실제 공급 계약 준비. 모델 단위 PASS를 GUI PASS로 바꾸지 않음. |
| P2 — 제품 UI | 실제 Session에 제안·심사·설득·재접수·계약/복귀를 연결, 필요한 행만 L2/독립 GUI 수용 | 승인된 최소 기능 UI 사용 가능. F-08 선택을 채택하는 해당 변경에는 경로 B 결정을 먼저 적용. |
| P3 — VS-02·회귀 | 독립 초기 상태의 실제 UI 완주, 실패/경계 증거와 정상 RNG 계보, 공통 변경의 기존 경로 회귀 | 한 고정 패킷을 S3·AC·VP에 공동 연결. 직접 관측 범위와 모델/소비 fixture를 구별. |
| P4 — 통합·최종 결정 | HQ가 S3 인수표·MVP 차이·F-08 판단/이월·CI를 취합하여 Owner에 제출 | 부서 수용과 최종 Stage 3 결정 후 종료. 납기/공수는 담당 분해 전 **NOT_ESTIMATED**. |

경로 B의 순서: **DEV-025 공급 완료 → Track B RD별 심사 → 필요한 행만 DEV 보완 → HQ 선택안/영향 취합 → Owner 규격/적용 범위 결정 → 승인된 제품 적용 티켓**. 현재 바로 필요한 일은 첫 심사이며 전 실험 재실행이 아니다. DEV-026 재개는 이 흐름과 별도의 HOLD 결정이다.

## 6. Stage 3 종료 기준안

모든 S3 행의 현재 실행 상태는 **NOT_RUN / ACCEPTANCE_PENDING**이다. Stage 2/DEV-025에서 이미 수용된 증거는 새 실행 수에 합산하지 않는다. 각 행별 담당 티켓·시험 SHA·기대/실제·부서 판정·잔여를 추적한다.

| ID | 필수 수용 기준안 | 완료 증거·책임 |
| --- | --- | --- |
| S3-01 | 승인 기준·기존 기반·담당/권한 연결 | C/D/DATA 버전, 유효 작업 승인·고정 시험본, Stage 2 재사용/실제 변경 목록. HQ/각 담당 |
| S3-02 | 자체 제안 편집·예측·동일성·잠금 | AC-04의 정상/비정상 노선·revision·재접수 우회 방지, 자동/해당 실제 UI. DEV·Planning·Track A |
| S3-03 | 시청 승인/거부·수정 재제출 | 0 포함 비음수/음수 경계, 시청과 정부 제한 구분, 요청·효력·기간의 명세 대응. DEV·Planning·Track A |
| S3-04 | 정부3분기·설득·감액 | 정상 RNG 경로와 별도 강제 분기 검증 분리, 설득1회·실패/재클릭·정산/기간·재접수 제한. DEV·Planning |
| S3-05 | RNG 재현·E01 발생/소비 | 실제 seed/엔진/추출 이력, 동일 입력 재현, 조회/중복 무효과, 판정 전후/미사용/소비/접수 실패 경계. DEV·Planning |
| S3-06 | 사업 허가·계약·지급과 W05/W06 연결 | 같은 사업 ID·효력시각·원장, 단회 지급·자금 보호·표준 공사·시험/안전·개통·실제 영업의 연속 증거. DEV |
| S3-07 | 신규 실제 UI 독립 수용 | 정상/거부/대기/보류/실패/자료 없음/0·허용 행동/사유·표시 선택/포커스/revision·복귀 의미를 확인. Track A L2/독립 실행 근거 심사·영향 행 판정 |
| S3-08 | VS-02 독립 초기 상태 실제 완주 | 회사 제안→시청→정상 정부 적합→계약/지급→표준 공사→시범/안전→개통→실제 완료 통행/영업 실적 보고→다음 후보 조회. 독립 실행/Design 심사와 DEV 자체 실행 구별 |
| S3-09 | 기존 경로 회귀·MVP 증거 대응 | 실제 공통 변경의 W01~03/W04A/W05/W06/W07·VS-01 영향 회귀, AC-01~10·VP-01/02의 충족/재사용/잔여 표. 전체 동일 GUI 재실행을 기본값으로 두지 않음 |
| S3-10 | F-08 심사·규격 결정 또는 적용 시점 명시 | T01~04/RD-01~08·특히 RD-03/07 판정, 권고/Owner 선택/미결의 영향·담당·적용 시점. 해당 미결에 종속되는 제품 변경을 미확정 상태로 수용하지 않음. F-08 전체 CLOSED·DEV-026 구현 완료를 자동 조건으로 추가하지 않음 |
| S3-11 | 통합 기록·필수 CI·Owner 최종 수용 | 실행 SHA별 증거·부서 수용·정책 CI·미해결/이월·HQ 보고·Owner 명시적 Stage 3 결정. 전체 MVP 최종 수용 여부는 실제 남은 범위와 별도 판단 |

S3-04/05의 실패 분기는 모든 경로를 독립 전체 사업 E2E로 반복하라는 요구가 아니다. 자동검사와 실제 상태/조작의 필요한 증거를 조합하며, S3-08 정상 성공은 승인된 정상 RNG의 실제 경로로 확보한다. 관측 도구·MODEL_CHAIN_SETUP·강제 분기는 용도를 밝혀야 하며 전체 정상 완주의 시작 상태를 대신하지 않는다.

## 7. 부서별 요청서·첫 회신

아래 문서는 Owner 전달 및 부서의 작업 준비용이다. PR 게시를 각 채팅에 자동 전달·숙지 완료한 것으로 가정하지 않는다. 담당 Agent-ID는 현재 등록부의 역할 참조이며 권한 인증이 아니다. 개발 DESKTOP AGT-DEV-0003의 새 공동 쓰기 업무는 배정하지 않는다. [R07]

| 수신 | 요청서 | 첫 회신으로 필요한 것 |
| --- | --- | --- |
| Development / AGT-DEV-0004 | [개발 요청](requests/PM-020_DEVELOPMENT_STAGE3.md) | DEV-025 공급 상태 색인, W04B 모델/UI/통합 분해·경로·유효 승인·최소 검증/의존성 |
| Planning / AGT-PLN-0003 | [기획 요청](requests/PM-020_PLANNING_STAGE3.md) | 승인 의미/반례·AC/VP 대응, 실제 모호점만 RFC, POST-MVP와 분리 |
| Design Track A / AGT-DSG-0002 | [기능 UI·인수 요청](requests/PM-020_DESIGN_A_STAGE3.md) | 새 제품 상태·공급 계약 L2와 최소 독립 검수표, Stage 2 재사용 행 |
| Design Track B / AGT-DSG-0003 | [DEV-025 검토·F-08 요청](requests/PM-020_DESIGN_B_STAGE3.md) | 기존 실험 RD별 판정·보완 최소 행·A/B 권고·Owner 선택안 |
| INF / AGT-INF-0002 | [연속성·이월 요청](requests/PM-020_INFRA_STAGE3.md) | 원본/정정/이월 참조·담당 연속성의 실제 누락만, 통상 인계 간소화 유지 |
| Convention / AGT-DEV-0002 | [검사 지원 요청](requests/PM-020_CONVENTION_STAGE3.md) | 필요한 경우 신규 RNG/재현 검사와 현재 CI의 실제 차이·소관 지원 범위 |

**공통 회신은 한 묶음:** 기준 SHA·담당/자기 티켓, 재사용 증거, 새 작업/경로·유효 승인(부족한 부분만), 산출물·완료 기준, 선행 입력/정확한 차단 시점, 검증 종류와 NOT_RUN, Owner 결정 필요 사항을 짧게 정리한다. 불필요한 일일 장문 보고·동일 자료 재첨부·정상 세대교체 수용시험 반복은 요구하지 않는다. 이미 열린 #92/#97/#104/#139를 재사용하며 신규 기능 티켓은 실제 범위가 분해된 때 소관 부서가 발급한다.

HQ는 회신의 중복/누락·같은 파일 동시 변경·범위/일정 충돌을 조정하고, 검토 가능한 단위로 필요한 Owner 결정을 묶는다. 세부 기술 구조는 DEV, 의미는 Planning, 전문 표현은 Design, 도구/CI는 Convention, 연속성은 INF, 최종 선택은 Owner 소관이다.

## 8. 증거 재사용·이월·Owner 결정

- [GUI 검수 지침](GUI_REVIEW_PROTOCOL.md) 준수: 고정 SHA·조건·입력→기대→실제·authority/원장·종료/로그·해시를 한 패킷으로 연결한다. 합의된 범위를 한 번에 심사하고 필수 누락·결함·권고를 분리한다. SHA 진전/기록 정정만으로 이미 수용한 GUI를 반복하지 않는다.
- #92/#97의 과거 상태는 PR #143 결과와 연결하는 기록 정리 대상이다. DEV 공급 완료·Design 심사 완료·Owner 최종 규격·Issue 전체 종료를 각각 구분한다. 이 HQ PR에서 대신 Issue를 닫거나 검수 결과를 만들어내지 않는다.
- #104 DEV-026은 HOLD 유지. 준비 대조에서 실제 W04B/새 UI에 필요한 결함이 발견되면 영향 행과 최소 해결 경로를 HQ에 제시하고, 제품 변경 전에 유효 승인 범위를 확인한다.
- #139는 현재 정본/Owner 보관·백업 이월 상태를 유지한다. 백업 없음·복구 NOT_RUN·일정 NOT_SCHEDULED; 다음 재사용/인계 시 이월 전달·재확인, 대상/접근/일정 마련 후 수행. 일반 통상 인계는 INF-009 간소화 절차를 사용한다. [R08, R09]
- 과거 DPI/물리 신원·보조 도구 바이트 NOT_VERIFIED, Q12/EXIT 등 NOT_CAPTURED, requested_exit NOT_PROVIDED와 실패 이력은 사실대로 유지한다. 실제 새 신뢰성 문제의 영향 행만 검토한다.

**이번 PR에서 Owner가 검토할 것은** Stage 3의 W04B·VS-02 주 목표, F-08 병행 검토와 해당 적용 시점, S3-01~11 종료 기준안·부서 책임이다. **부서 준비 회신 후 필요한 것은** 새 제작/검증/개별 Git 범위, 실제 남은 F-08 선택안, 필요한 경우에만 DEV-026 재개 범위다. 기존 Gate 2/R01~03·Stage 1/2·DEV-025 실험 공급을 재승인 대상으로 넣지 않는다. 본 PR main 병합은 별도 Owner 결정이며 자동 병합하지 않는다.

## 9. 공식 근거

- **R01 — Stage 2 최종 인수:** [Owner 결정·#141 종료](https://github.com/wisberry2022/MetroManager/issues/141#issuecomment-6892772104), [PR #144](https://github.com/wisberry2022/MetroManager/pull/144), [S2 인수표](STAGE2_ACCEPTANCE_MATRIX.md). merge `96c51ae6c3352195b9a8e8b89f92dd51c13be81c`; PM-019의 승인 대기 문구는 작성 당시 이력.
- **R02 — DEV-025 공급:** [PR #143](https://github.com/wisberry2022/MetroManager/pull/143), [결과](../engineering/tasks/DEV-025_RESULT.md), [상세 보고](../engineering/evidence/DEV-025_F08_REPORT.md), [실행 JSON](../engineering/evidence/DEV-025_F08_VALIDATION.json), [Design 입력/RD 기준](../design/tasks/DSG-008_DEV025_SAMPLES.md). head `8bd236957f5adcf50aeb418cbaa617779eb8241a`, merge `dc3c049134fb45764560e47116b3332bc2f5624d`. 정상자동497, 스크립트 렌더53조건과 실제 GUI M01~M06/7캡처, 짧은 Debug22조건/2639프레임은 각각 별개. [policy](https://github.com/wisberry2022/MetroManager/actions/runs/43697720036)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/43697720029) SUCCESS. 최종 FPS/다른PC/export/Design 수용을 뜻하지 않음.
- **R03 — Track B/DEV-026:** [#92](https://github.com/wisberry2022/MetroManager/issues/92), [#97](https://github.com/wisberry2022/MetroManager/issues/97), [#104 HOLD 후속](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6891486517), [RP 대조표](../design/tasks/DSG-008_DEV026_RESPONSE_AND_P06_P07_RECOMPARE.md). 과거 실험 NOT_RUN은 R02로 갱신하되 HOLD와 최종 규격 미확정은 유지.
- **R04 — MVP 승인 원본:** [Gate 2](../planning/PLN-001_GATE2_FINAL_APPROVAL.md), [C v0.7](../planning/PLN-001-C.md), [D v0.9](../planning/PLN-001-D.md), [DATA v1.4](../planning/PLN-001_GATE2_DATA_v1_DRAFT.md), [PLN-005 결과](../planning/tasks/PLN-005_RESULT.md). 파일명의 DRAFT만으로 최신 승인 절을 미결로 되돌리지 않음.
- **R05 — 후속 경로:** [PM-014](PM-014_STAGE2_VS01_EXECUTION_PLAN.md) §1.3/§6/§7, [DEV-006 W04B·VS-02 계획](../engineering/gate3/DEV-006_DEVELOPMENT_PLAN.md). DEV 계획은 기술 입력이며 새 실행 권한은 아님.
- **R06 — 검수 운영:** [PM-015](GUI_REVIEW_PROTOCOL.md), [부서 협업](../engineering/DEPARTMENT_WORKFLOW.md), [HQ 운영 규정](../governance/HQ_OPERATING_RULES.md). 운영 규정 서식 DRAFT와 승인된 Owner 정책을 구별.
- **R07 — 담당:** [등록부](../infra/agents/registry.json). 현재 ACTIVE ID를 확인하되 물리 신원·개별 권한 인증이나 새 역할 등록으로 사용하지 않음.
- **R08 — 원본/백업:** [#138 수용](https://github.com/wisberry2022/MetroManager/issues/138#issuecomment-6891410426), [#139 Owner 결정](https://github.com/wisberry2022/MetroManager/issues/139#issuecomment-6891629210), [#141 최종 이월 기록](https://github.com/wisberry2022/MetroManager/issues/141#issuecomment-6892772104).
- **R09 — 간소화 인계:** [INF-009](../infra/tasks/INF-009_LIGHTWEIGHT_SUCCESSION.md), [전환 규정](../infra/agents/REGISTRY_TRANSITION_RULES.md). 통상 Owner 전환 지시+후임 인수 확인, 불필요한 반복 시험/PM 확인/Owner 재승인 생략. 정확한 효력 시각·실제 기록·Git 권한 경계 유지.

본 HQ 작업의 게임 자동검사·Godot 로드·GUI/플레이·프로파일·빌드/export·백업 복구는 **NOT_RUN**. 비공개 QA 원본 재해시·새 Design 판정은 **NOT_VERIFIED**. 게임 명세 변경 필요 없음; 세부 계획은 검토안으로 제출한다.
