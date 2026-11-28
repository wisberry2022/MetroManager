# PM-020 — Stage 3 실행 계획·통합 인수표

- 최초 계획: HQ / AGT-PM-0002 / 2026-11-15. 최신 갱신: **PM-022 / 2026-11-28 (Asia/Seoul)**.
- 현재 F-08: **O01_O07_OWNER_DIRECTION_APPROVED / FINAL_SPEC_PENDING / PRODUCT_APPLICATION_SCOPE_PENDING / F08_OPEN**.
- 최신 확인 main: `1c4481187980fe6b37de0fec8e0019f2736ce1f2`. 최초 PM-020 기준 `96c51ae6c3352195b9a8e8b89f92dd51c13be81c` 및 [PR #145](https://github.com/wisberry2022/MetroManager/pull/145) 병합 이력은 보존한다.
- [이번 Owner 승인·HQ Git 범위](tasks/PM-021_STAGE3_F08_DIRECTIONS.md) / [검증 결과](tasks/PM-021_RESULT.md) / [최초 요청](tasks/PM-020_STAGE3_ENTRY_PLAN.md).

> **PM-022 현재 적용:** [OD-S312-01·02 승인](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7236141995)으로 DEV-027 DI-03 비의존 구현·관측된 국소 검수는 한정 종료한다. [S3-12 상세 행/증거/처분](STAGE3_S3_12_ACCEPTANCE_SCOPE.md)과 [DI-03 부서 착수 요청](requests/PM-022_DI03_DEPARTMENT_REQUESTS.md)을 현재 정본으로 적용한다. DI-03은 Stage 3 필수 유지, HQ 착수 가능 판단으로 범위 내 로컬 구현·검증을 시작한다. #185는 DI-03, #186은 S3-12→S3-11, #104는 RP/EX 관측 한계, #92는 F-08 잔여를 관리한다. #146은 비의존 협의/검수의 종료 기록으로 보존한다. 아래 PM-020/021 당시의 미래 공급·HOLD·전체 진척 미평가 표현은 그 시점의 이력이며 현재 결정을 되돌리지 않는다. **DEV-027 전체 DONE·전체 Design·S3-12/Stage 최종 인수는 대기**다.

PM-021 갱신은 [#92 Owner 결정](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335)을 실행 계획과 §6 인수표에 반영한다. **O-01~07 방향 선택은 완료**됐으며 같은 선택을 재승인 대기로 돌리지 않는다. 구체 규격·실제 제품 적용·검증·S3-10 전체 수용·Stage 3 DONE은 별개다. O-02/O-07의 구체 수치 결정을 뒤로 두는 방향도 승인된 선택이다.

Stage 2 DONE과 DEV-026의 Stage 3 공식 편입은 유지한다. DEV-026은 [현재 공급 한정 수용·P07 구분 승인](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7057161624) 및 PR #158 병합까지 반영하되 원본 PARTIAL·미관측·W04B 미래 공급과 S3-12 최종 인수 대기는 보존한다. §2.1은 최초 편입 당시 판단 이력이다. W04B·VS-02의 전체 최신 실행 결과를 이번 F-08 문서 작업에서 재평가하지 않는다. 초기 계획의 미실행 기록은 당시 사실이며 후속 부서 증거를 NOT_RUN으로 되돌리는 근거가 아니다.

## 1. 현재 출발점과 우선 판단

| 대상 | 확인 사실 | 이번 적용 |
| --- | --- | --- |
| Stage 2 | Owner 최종 인수, PR #144 main 반영, #141 CLOSED(completed) [R01] | W04A→W05→W06·VS-01 및 기존 GUI 수용을 기반으로 사용. Stage 2를 다시 열지 않음. |
| DEV-025 | PR #143 공급과 [#97 기술 종료](https://github.com/wisberry2022/MetroManager/issues/97#issuecomment-7052796254), PR #157 Track B 심사 게시·병합 완료 [R10] | **기술 공급/심사 완료**. 동일 실험·첫 심사를 다시 요청하지 않음. 최종 제품 규격과 구별. |
| F-08 / #92 | [O-01~07 권고 방향 전부 Owner 승인](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335) [R10] | 방향 결정 대기 해소. **FINAL_SPEC_PENDING / #92 OPEN**. §2.2·§6.1의 실제 적용 전제와 잔여를 추적. |
| DEV-026 / #104 | [현재 공급 한정 수용·P07 일반 재진입/문맥 복귀 구분 승인](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7057161624), PR #158 main 반영 [R11] | **OWNER_APPROVED_LIMITED_ACCEPTANCE / OVERALL_PARTIAL**. 동일 승인/GUI 반복 비요구. W04B 미래 공급·분담 수용 연결·S3-12/Stage 최종 인수 별도. |
| W04B / VS-02 | 승인 MVP의 자체 제안 경로가 Stage 2에서 이월됨 [R04]. 최초 PM-020은 구현 수용 NOT_VERIFIED·HQ 실행 NOT_RUN으로 기록 | PM-022: P3-A/P3-B·자연 VS-02 및 후속 국소 수용을 상세 N행/E01~08로 연결. 비의존 한정 종료 승인, DI-03 #185는 실제 구현·검증 착수, 전체 인수 #186 별도. |
| INF-012 / #139 | Owner 정본·보관 담당 확정, 백업/복구 이월 승인 [R08] | Stage 3 진입의 공통 차단조건으로 올리지 않음. 이월 의무·NOT_RUN 유지. |

**권고:** Stage 3의 필수 경로는 **회사 자체 제안 W04B → 기존 시공·운행 기반 연결 → 독립 VS-02 완주**로 둔다. 공통 UI 안정성을 위한 **DEV-026 구현·제품 검증을 필수 범위로 함께 수행**하고, 완료된 DEV-025 Design 심사와 F-08 승인 방향의 적용 준비를 연결한다. 최종 아트·환경 규격이 미확정이라는 이유로 W04B 의미 검토·순수 모델·최소 기능 UI 준비 전체를 멈추지 않는다. 다만 그 규격을 실제로 채택하거나 관련 제품 UI를 바꾸는 작업은 해당 결정/계약을 먼저 확인한다.

## 2. Stage 3 목표와 포함·제외

**플레이 목표:** 독립 초기 상태에서 행정·수요를 확인하고 후보역/순서와 예측을 비교하여 회사 자체 사업을 제안한다. 시청과 정부 심사를 거쳐 사업을 확보하고 기존 표준 공사·시범운행·안전검증·개통·실제 영업을 수행한 뒤, 첫 유효 실적 보고와 다음 사업 후보 조회까지 제품 UI로 이어간다.

| 구분 | 포함하는 결과 |
| --- | --- |
| 기능 경로 A — 필수 | W04B 시청/정부 심사·보류 설득·사업 동일성/재접수·신규 사실·정상 RNG, 계약/사업비의 W05/W06 연결, 해당 실제 UI, VS-02 독립 초기 상태 완주와 실패/경계 증거 |
| UI 안정성 경로 C — 필수 | DEV-026의 자료/행동군별 안전한 제한, 실행 소속·같은/새 Session 생명주기, 현재/과거 보고 식별과 선택/포커스·스크롤 복귀. 최신 P06/P07·W04B 실제 공통 영향에 계약을 맞추고 구현·자동/실제 GUI·부서 수용까지 확보 |
| 기술·시각 경로 B — 병행 | DEV-025 T01~04·RD-01~08 심사 [R10]와 O-01~07 방향 승인, F08-01~04 최종 규격/적용 잔여표. RD-03/07 관측은 영향 행으로 검토. Stage 3의 산출물은 심사 결과·선택/이월의 명시이며 최종 제품 적용 완료를 선행 가정하지 않음 |
| 통합 | Stage 2 수용 재사용·실제 변경 영향 회귀, AC-01~10·VP-01/02의 기존/신규/미충족 대응, HQ 통합과 Owner Stage 3 인수 |

제외: POST-MVP 회사 상태/평판/협력업체 설계를 MVP로 편입, 새로운 경제·심사 확률·도시/난이도 정책, 저장/불러오기 SHOULD의 임의 MUST 승격, 대량 최종 에셋·전체 고충실도 UI 완성, W09 Windows export/최종 FPS 합격·배포, 외부 사용성 조사/예산 집행, 두 번째 실제 수주나 빠른 공사 전체 E2E의 일괄 추가. DEV-026은 제외 목록에서 제거한다. 기존 티켓의 경제/시간/원장/세이브 변경·가짜 비동기 대기·깊은 자식 guard 전체 개편 제외는 유지하며 실제 필요한 추가 경로만 확인한다.

**Stage 3 완료도 자동으로 전체 MVP DONE은 아니다.** MVP 8개 영역·11 MUST·AC-01~10·독립 VP-01/02와 실행 품질의 최종 인수 범위는 유지한다. Stage 3 말에는 잔여 대응표를 제시하고 실제 증거가 모두 갖춰진 범위만 Owner에게 수용 요청한다. 기존 VS-01 증거를 VP-02에 재사용하되 최종 VP-02 요구와의 차이만 확인한다. [R04, R05]

### 2.1 RFC-PM-020-01 — DEV-026 편입 판단과 범위 결정

아래는 2026-11-15 최초 편입 당시 판단 기록이다. 현재 구현·한정 수용은 §1·S3-12·R11을 따른다.

- 상태: **ANSWERED / DEV026_STAGE3_SCOPE_CONFIRMED**. 요청: Owner → HQ, 응답·조정: HQ / AGT-PM-0002. 관련: PM-020, DEV-026, RFC-DEV-026-01, #104.
- 근거: [Owner 후속 요청 원문](tasks/PM-020_STAGE3_ENTRY_PLAN.md#owner-후속-요청--dev-026-편입), [기존 DEV-026 순서·후보 범위](../engineering/tasks/DEV-026_S01_EXCEPTION_SCOPE.md), [계약안](../engineering/gate3/DEV-026_S01_EXCEPTION_CONTRACT.md), [검증안](../engineering/gate3/DEV-026_S01_EXCEPTION_VALIDATION_PLAN.md), [RP-01~08](../design/tasks/DSG-008_DEV026_RESPONSE_AND_P06_P07_RECOMPARE.md). 당시 조사 main은 `96c51ae6c3352195b9a8e8b89f92dd51c13be81c`, 이전 PR head는 `fcff80bcce6c2fe22921c1722d04b9f5ffebc7c2`.
- **HQ 판단: 편입 적절.** DEV-022~024와 Stage 2가 종료되고 DEV-025 실험 공급도 완료돼 최초 보류의 선행 개발 순서가 진전됐다. W04B가 공통 Session/호스트·보고/복귀를 사용하므로 해당 경계를 지금 정리하면 화면 확장 후 중복 수정·재검수를 줄일 수 있다. 이는 정적 의존성 판단이며 기존 수용 제품 전체의 결함 확정이 아니다.
- **Owner 조건부 지시 적용:** 적절하면 반영하라는 요청에 따라 DEV-026을 Stage 3의 공식 개발·검증 범위로 편입한다. 같은 편입 결정을 다시 승인 대기로 만들지 않는다. 기존 문서의 HOLD는 당시 결정으로 보존하고 현재는 **범위 확정 / 착수 준비 대기 / 제품 NOT_RUN**으로 구별한다. 상세 기술 계약 채택·정확한 변경 경로·개별 실행/Git 권한은 담당자가 기존 유효 원문과 대조하고 부족한 부분만 상정한다.
- **부서 소유:** DEV0004는 계약·구현·시험, Track B는 L2-A/B/C·RP/EX·문구 의미와 해당 독립 증거 심사, Track A는 실제 기능 흐름과 기존 수용의 영향 행을 맡는다. 한 패킷/합의 검수표에서 주관 행을 나눠 중복 독립 GUI를 요구하지 않는다. Planning은 실제 의미 차이만, HQ는 일정·통합, Owner는 필요한 정책·추가 권한과 최종 인수를 담당한다.
- **순서·영향:** W04B 순수 모델/의미 준비는 병행 가능. DEV-026의 공통 공급·생명주기 계약을 먼저 대조하고 같은 파일 변경은 순차 통합한다. 적용할 새 UI의 최종 L2/GUI 및 VS-02 시험본은 해당 공통 변경 반영 후 고정한다. DEV-025의 관련 판정/결함만 연결하며 F-08 전체 확정은 일괄 선행조건이 아니다. 추가 공수는 NOT_ESTIMATED, DEV 분해 후 기존 계획과 차이를 보고한다.
- **완료 영향:** S3-12를 필수 추가하고 S3-11 최종 인수에 연결한다. DEV-026 미완료를 단순 문서 이월로 완료 처리하지 않는다. 실제 일정상 이월이 필요해지면 영향·잔여·대안을 제시해 Owner의 명시적 범위 변경 결정을 받는다. Stage 2 종료는 재개방하지 않는다. 제품 변경/검증은 이번 HQ 문서 작업에서 NOT_RUN이다.
- 반영: 본 계획·6개 부서 요청서·HQ README·S2 이월 연결·PM-020 티켓/결과/출처. DEV/Design 원본의 기술 계약·RFC 종결은 소관 부서가 후속 반영하며 HQ가 대신 수정하지 않는다. 게임/경제/시간/세이브 명세 변경 필요 NONE.

### 2.2 O-01~07 Owner 승인 방향과 최종 규격 잔여 — PM-021

정본: [Owner 결정](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335), [Track B 선택안](../design/tasks/DSG-008_F08_OWNER_OPTIONS.md), [RD 심사·M 조건](../design/tasks/DSG-008_DEV025_DESIGN_REVIEW.md). Design 원문의 `OPTIONS_NOT_APPROVED`·미선택·LOCAL_REVIEW는 결정 전 작성 이력으로 읽는다. 이 HQ 변경은 타 부서 원문을 대신 개정하지 않는다.

| ID | 승인 완료한 권고 방향 | 별도로 남는 최종 규격·적용 전 조건 |
| --- | --- | --- |
| O-01 | 현행 기본/fallback 임시 유지, 배포용 한글 후보 권리·구성 확인 준비 | 폰트명/버전·권리·번들 채택·fallback·목표환경/export. 설치 성공으로 재배포 권리나 최종 채택을 확정하지 않음 |
| O-02 | **1280×720·root 1배는 비교 기준만 유지**, 최소창·지원 배율 결정 보류 | 실제 클라이언트/논리영역·OS 배율/DPI 지원 수치. root 변환을 OS/물리 배율로 전용하지 않음 |
| O-03 | 픽셀 도형 정수·nearest 우선 비교, 동적 문자 별도 유지 | 실제 아트 크기·노드 위상·역할별 필터/배율. 전 아트 일괄 강제 아님 |
| O-04 | **A 잠정 우선 / B 비교 유지** | 최종 배치·치수·브레이크포인트. B/관련 반응형 변경을 채택할 때 M-01; A 유지 중 B 수정을 공통 차단으로 만들지 않음 |
| O-05 | 안정 ID 후보/목록·전체 이름 경로를 기본 대안으로 검토·유지 | 실제 순서·키보드·선택 가시성·정보/편집 구분. 클러스터/팬/확대/자동배치 등 새 지도 기능은 추가 범위 아님 |
| O-06 | Theme/시각 자원·텍스트·상태/행동 소비 분리의 인계 원칙 | 실제 공급계약·재사용 단위·수정 경로는 DEV가 구체화. 클래스 구조 지정·전면 리팩터링 아님 |
| O-07 | 원시 Debug 자료 보존, **목표환경·성능 인수 시점에 목표 결정** | 최종 FPS·표현 상한·장면/기간/환경. 짧은 Debug를 제품 합격·A/B 우열로 전용하지 않음 |

7행 모두 **OWNER_DIRECTION_APPROVED**다. 최종 규격·제품 적용은 **FINAL_SPEC_PENDING / PRODUCT_APPLICATION_SCOPE_PENDING**이며 추가 구현·실험·Git은 기존 유효한 자기 티켓/권한을 재사용하고 부족한 범위만 제시한다. 이번 HQ 문서 PR 승인을 타 부서 포괄 권한으로 사용하지 않는다.

## 3. 진입 조건과 차단 시점

| 시점 | 필요한 조건 | 현재 판정·다음 조치 |
| --- | --- | --- |
| 계획·분해·정적 협의 | Stage 2 최종 인수, 최신 승인 C/D/DATA·기존 증거 접근 | 충족. 본 요청서의 읽기·담당/범위 확인·준비 회신을 시작할 수 있음. 새 코드 제작 승인은 별개. |
| 기존 계획·후속 결정 적용 | PM-020/PR #145와 각 Owner 승인 원문을 구분해 사용 | 이번 O-01~07 결정은 승인 완료. 다른 세부 계획의 승인 범위를 이번에 일괄 재판정하지 않으며 동일 결정 재승인·새 전체 계획 승인 회차를 추가하지 않음. |
| 각 모델/화면/검증 작업 착수 | 자기 티켓·정확한 포함/제외 경로·기준 SHA·실행 범위·개별 Git 권한 | 각 담당이 현재 유효한 원문을 연결. 미확인/부족한 범위만 Owner 결정 대상으로 제출. HQ가 DEV/DSG/PLN 번호를 선점하지 않음. |
| 새 UI 통합 | DEV 실제 payload/명령/허용 행동·사유·revision과 Track A L2 대조 | 해당 행에 계약 차이가 있으면 먼저 해결. 문서 의견·표시 fixture·실제 제품 공급을 구별. |
| F-08 규격 종속 적용 | O-01~07 승인 방향과 Track B 심사 [R10], 실제 적용할 규격·계약 | **방향 승인 완료 / FINAL_SPEC_PENDING**. §6.1에서 해당 제품 변경의 적용 전 조건만 확인. 최종 수치 미정 때문에 W04B 준비 전체를 차단하지 않음. |
| DEV-026 후속 적용 | 현재 공급 한정 수용·P07 구분 승인 [R11], 실제 W04B 공급/변경 영향 | 기존 승인과 증거 재사용. 미관측을 없애기 위한 전면 재실행 비요구. 미래 공급·필요한 분담 수용·S3-12 최종 취합만 구분. |
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

## 5. 현재 작업 순서 — PM-022

| 우선순위 | 수행·결과 | 의존성과 종료 신호 |
| --- | --- | --- |
| P0 | #185 DEV-027 DI-03 로컬 모델·실제 공급·자동 경계 착수 | 정책 A1+B1 확정. 범위 내 실행은 현재 Owner 조건부 지시/HQ 판단 적용. 최신 base·선택 경로·명령 기록 |
| P1 | 실제 payload의 A/B L2 → 해당 화면 통합 → 신규/직접 영향 검수 | 공급 생성 전 L2를 요구하지 않음. 미래 Git·독립 GUI 유효 원문은 해당 단계 전에 연결 |
| 병행 | #104 RP/EX 한계 보존, #92 F-08 실제 공급·최종 규격/적용 준비 | OD-S312-02로 현재 관측 한계 추가 GUI 비차단. F-08 미결은 유지, DI-03 모델 전체를 막지 않음 |
| P2 | #186 S3-12 취합 → S3-01~10/AC·VP/CI·미해결·이월 → S3-11 Owner 결정 | DI-03 실제 필수 수용과 F-08 적용/이월 정리 후 최종 판단. 기존 자연 VS-02·국소 GUI 반복 없음 |

정확한 경로·부서 역할·검증·권한은 [PM-022 요청](requests/PM-022_DI03_DEPARTMENT_REQUESTS.md)을 따른다. 공수/일정은 NOT_ESTIMATED. 최초 P0~P4 및 PM-021 계획 이력은 이전 고정 SHA에서 보존한다.

## 6. Stage 3 종료 기준안

이 절은 Stage 3 통합 인수표다. 최초 계획의 일괄 NOT_RUN 표기는 당시 HQ 실행 기록이며 현재 전 부서 상태가 아니다. **S3-10 방향 결정 대기는 해소**, S3-12는 현재 공급 한정 수용과 상위 인수 대기를 구분한다. S3-01~09의 전체 진척은 이번에 재판정하지 않으며 후속 부서 기록을 보존한다. S3-11/Stage 최종 인수는 별도다. Stage 2/DEV-025에서 이미 수용된 증거는 새 실행 수에 합산하지 않는다. 각 행별 담당 티켓·시험 SHA·기대/실제·부서 판정·잔여를 추적한다.

| ID | 필수 수용 기준안 | 완료 증거·책임 |
| --- | --- | --- |
| S3-01 | 승인 기준·기존 기반·담당/권한 연결 | C/D/DATA 버전, 유효 작업 승인·고정 시험본, Stage 2 재사용/실제 변경 목록. HQ/각 담당 |
| S3-02 | 자체 제안 편집·예측·동일성·잠금 | AC-04의 정상/비정상 노선·revision·재접수 우회 방지, 자동/해당 실제 UI. DEV·Planning·Track A |
| S3-03 | 시청 승인/거부·수정 재제출 | 0 포함 비음수/음수 경계, 시청과 정부 제한 구분, 요청·효력·기간의 명세 대응. DEV·Planning·Track A |
| S3-04 | 정부3분기·설득·감액 | 정상 RNG 경로와 별도 강제 분기 검증 분리, 설득1회·실패/재클릭·정산/기간·재접수 제한. DEV·Planning |
| S3-05 | RNG 재현·E01 발생/소비 | 실제 seed/엔진/추출 이력, 동일 입력 재현, 조회/중복 무효과, 판정 전후/미사용/소비/접수 실패 경계. DEV·Planning. 기존 RNG 증거 재사용; E01 실제 D01-01~05는 #185 실행/수용 대기 |
| S3-06 | 사업 허가·계약·지급과 W05/W06 연결 | 같은 사업 ID·효력시각·원장, 단회 지급·자금 보호·표준 공사·시험/안전·개통·실제 영업의 연속 증거. DEV |
| S3-07 | 신규 실제 UI 독립 수용 | 정상/거부/대기/보류/실패/자료 없음/0·허용 행동/사유·표시 선택/포커스/revision·복귀 의미를 확인. Track A/B 기존 N행 한정 수용 재사용. DI-03 실제 UI11/12는 #185 L2/신규 영향 행 수용 대기 |
| S3-08 | VS-02 독립 초기 상태 실제 완주 | 회사 제안→시청→정상 정부 적합→계약/지급→표준 공사→시범/안전→개통→실제 완료 통행/영업 실적 보고→다음 후보 조회. 독립 실행/Design 심사와 DEV 자체 실행 구별. PM-022 E03 자연 관측 수용 연결, 추가 전체 반복 비요구; 상위 최종 인수 #186 |
| S3-09 | 기존 경로 회귀·MVP 증거 대응 | 실제 공통 변경의 W01~03/W04A/W05/W06/W07·VS-01 영향 회귀, AC-01~10·VP-01/02의 충족/재사용/잔여 표. 기존 E02/E04~08 회귀 재사용, DI-03 직접 영향 #185 및 최종 대응 #186. 전체 동일 GUI 재실행 비요구 |
| S3-10 | F-08 심사·규격 결정 또는 적용 시점 명시 | **심사 게시·방향 승인 완료 [R10] / FINAL_SPEC_PENDING / 적용 범위 취합 대기**. §2.2 결정표·§6.1 하위 인수표 적용. 실제 미확정 규격에 종속되는 변경만 수용 보류. F-08 전체 CLOSED를 Stage 종료의 자동 조건으로 추가하지 않음. S3-10 전체 PASS는 아님 |
| S3-11 | 통합 기록·필수 CI·Owner 최종 수용 | **S3-12 DEV-026을 포함한 필수 범위**의 실행 SHA별 증거·부서 수용·CI·미해결/이월·HQ 보고·Owner Stage 3 결정. 전체 MVP 최종 수용은 실제 남은 범위와 별도 판단. #186 FINAL_ACCEPTANCE_PENDING |
| S3-12 | DEV-026 공통 UI 예외 처리·실행 소속·복귀 수용 | [PM-022 상세 인수표](STAGE3_S3_12_ACCEPTANCE_SCOPE.md): N01~14 기존 증거와 N15 취합, OD-S312-01 비의존 한정 종료·02 관측 한계 비차단 승인. 원 OVERALL_PARTIAL·P07 구분 유지. 실제 W04B 비의존 공급은 수용 연결 완료; DI-03 #185 신규 필수, F-08 #92 별도. **최종 인수 #186 PENDING** |

S3-12는 기존 번호를 보존하여 추가한 필수 행이며 **S3-11 최종 결정 전에 완료**한다. EX-05 소비 fixture 한정·EX-16 일반 S01 대기 제외·EX-18 격리 외부역 입력을 유지한다. RP는 대조 식별자, X는 검증 묶음이며 새 독립 GUI 횟수나 전체 조합 의무가 아니다. P07 FIXED_DAY에 S01 직전일 조건을 일괄 적용하지 않는다.

S3-04/05의 실패 분기는 모든 경로를 독립 전체 사업 E2E로 반복하라는 요구가 아니다. 자동검사와 실제 상태/조작의 필요한 증거를 조합하며, S3-08 정상 성공은 승인된 정상 RNG의 실제 경로로 확보한다. 관측 도구·MODEL_CHAIN_SETUP·강제 분기는 용도를 밝혀야 하며 전체 정상 완주의 시작 상태를 대신하지 않는다.

### 6.1 S3-10 하위 인수·적용 시점표

아래 식별자는 HQ 추적 행이며 신규 부서 티켓이나 추가 검수 횟수가 아니다. 각 실행의 자동검사·실제 GUI·Design 심사·성능/빌드를 구분한다. 일정/공수 **NOT_ESTIMATED**; 시점은 제품 적용 조건으로 명시하고 없는 날짜를 생성하지 않는다.

| 하위 행 | 현재 판정·기존 근거 | 잔여·실제 차단 시점 | 담당·완료 신호 |
| --- | --- | --- | --- |
| S3-10-D | **방향 승인 완료**: O-01~07 [R10] | 같은 방향 선택 재승인 불필요. 최종 규격과 분리 | HQ, §2.2·#92 결정 연결 완료 |
| S3-10-R | **기존 RD 심사 게시·병합 완료**: PR #157 [R10] | 관측 한정 NO_ISSUE/ISSUE/INCONCLUSIVE와 M 조건 보존. 새 독립 GUI 실행으로 합산하지 않음 | Track B, 최초 심사 반복 없음 |
| S3-10-A | **PRODUCT_APPLICATION_SCOPE_PENDING** | 현재 충족/변경0·정확한 공백·경로·티켓·유효/부족 권한·적용 시점을 한 공통표로 제시 | Track B·DEV, Track A 영향 행 연결; HQ 통합 |
| S3-10-M01 | **CONDITIONAL / 적용 전 대기**: RD-03/07·M-01 | B 또는 관련 배치/반응형 채택 시 전환 직후 유효 포커스 가시성·사용자 이동 존중·선택/스크롤·명령 무효과. A 유지 시 B 전면 수정 비요구 | DEV·Track B, 해당 전환/입력의 최소 증거 |
| S3-10-M02 | **기존 접근 증거 재사용 / 제품 조건 별도**: DEV-025 M04·M-02 | 실제 밀집 표현/목록 변경 적용 전 동일 ID·전체 이름·순서·키보드·선택·정보/편집 구분. 아직 미입증한 영향 행만 확인 | DEV·Track B/Track A, 실제 입력·권위 무효과 |
| S3-10-M03 | **FINAL_SPEC_PENDING**: O-01/02·M-03 | 폰트 반입/지원 규격 확정 전 후보 버전·권리·fallback, 실제 목표 창/논리영역/OS 배율에서 글리프·끝자리·긴 문자열·행동 접근. export/타환경은 실제 채택 범위에 맞춤 | Track B·DEV, 구체 후보/조건 근거와 필요한 최종 결정 |
| S3-10-M04 | **FINAL_SPEC_PENDING**: O-03·M-04, T02 재사용 | 규격 종속 아트/필터 적용 전 실제 크기·위상·역할별 필터·문자/포커스 선. 선택 조건의 직접 영향만 대조 | Track B·DEV, 전 에셋/전 배율 반복 비요구 |
| S3-10-O06 | **원칙 승인 / 적용 단위 미확정** | 실제 변경 시 최소 역할 분리·공급 의미 유지·정보/권위/입력 회귀. 전면 리팩터링·새 추상화 의무 없음 | DEV가 경로·계약 제시, Design 영향 확인 |
| S3-10-M05 | **목표 결정 시점 이월 승인**: O-07·M-05 | 목표환경·성능 인수 시 장면/표현량/기간/실행 형태와 목표를 구체화하고 필요한 프로파일/export. 현재 FPS/상한 확정·새 벤치마크 비요구 | DEV 측정안·HQ/Owner 목표, 현재 성능 완료 아님 |
| S3-10-C | **S3-10 통합 수용 대기** | 공통표에서 지금 필요한 적용·조건부/후속 이월을 구분하고 담당/시점/근거 연결. 미확정 규격 종속 변경을 완료로 처리하지 않음 | HQ 취합·Owner 상위 결정; S3-11/Stage와 구분 |

F08-01~04와 #92는 **OPEN / FINAL_SPEC_PENDING**이다. 위 조건부 행 전체를 즉시 실행하거나 모두 CLOSED로 만들어야 Stage 3에 진입한다는 뜻이 아니다. 반대로 방향 승인만으로 제품 적용/검증을 PASS로 표시하지 않는다. 기존 Stage 2·DEV-026 수용은 유지하며 실제 변경·새 결함·증거 신뢰성 문제의 영향 행만 다시 확인한다.

## 7. 부서별 요청서·첫 회신

아래 문서는 Owner 전달 및 부서의 작업 준비용이다. PR 게시를 각 채팅에 자동 전달·숙지 완료한 것으로 가정하지 않는다. 담당 Agent-ID는 현재 등록부의 역할 참조이며 권한 인증이 아니다. 개발 DESKTOP AGT-DEV-0003의 새 공동 쓰기 업무는 배정하지 않는다. [R07]

| 수신 | 요청서 | 첫 회신으로 필요한 것 |
| --- | --- | --- |
| Development / AGT-DEV-0004 | [개발 요청](requests/PM-020_DEVELOPMENT_STAGE3.md) | F-08 현재 충족/실제 변경 경로·최소 검증·유효 권한을 Track B 공통표에 연결. W04B와 DEV-026 후속은 별도 증거로 추적 |
| Planning / AGT-PLN-0003 | [기획 요청](requests/PM-020_PLANNING_STAGE3.md) | 승인 의미/반례·AC/VP 대응, 실제 모호점만 RFC, POST-MVP와 분리 |
| Design Track A / AGT-DSG-0002 | [기능 UI·인수 요청](requests/PM-020_DESIGN_A_STAGE3.md) | 새 UI와 DEV-026 영향 L2/독립 검수 분담, Stage 2 재사용 행 |
| Design Track B / AGT-DSG-0003 | [F-08 승인 후속 요청](requests/PM-020_DESIGN_B_STAGE3.md) | 승인 방향의 후보·적용 전제·M-01~05 대응표. DEV와 한 묶음으로 제출하며 최초 심사·7개 선택 재요청 없음 |
| INF / AGT-INF-0002 | [연속성·이월 요청](requests/PM-020_INFRA_STAGE3.md) | 원본/정정/이월 참조·담당 연속성의 실제 누락만, 통상 인계 간소화 유지 |
| Convention / AGT-DEV-0002 | [검사 지원 요청](requests/PM-020_CONVENTION_STAGE3.md) | 필요한 경우 신규 RNG/재현 검사와 현재 CI의 실제 차이·소관 지원 범위 |

**공통 회신은 한 묶음:** 기준 SHA·담당/자기 티켓, 재사용 증거, 새 작업/경로·유효 승인(부족한 부분만), 산출물·완료 기준, 선행 입력/정확한 차단 시점, 검증 종류와 NOT_RUN, Owner 결정 필요 사항을 짧게 정리한다. 불필요한 일일 장문 보고·동일 자료 재첨부·정상 세대교체 수용시험 반복은 요구하지 않는다. #92/#104의 잔여와 #139 이월을 추적하고 #97의 기술 종료는 유지하며 신규 기능 티켓은 실제 범위가 분해된 때 소관 부서가 발급한다.

HQ는 회신의 중복/누락·같은 파일 동시 변경·범위/일정 충돌을 조정하고, 검토 가능한 단위로 필요한 Owner 결정을 묶는다. 세부 기술 구조는 DEV, 의미는 Planning, 전문 표현은 Design, 도구/CI는 Convention, 연속성은 INF, 최종 선택은 Owner 소관이다.

## 8. 증거 재사용·이월·Owner 결정

- [GUI 검수 지침](GUI_REVIEW_PROTOCOL.md) 준수: 고정 SHA·조건·입력→기대→실제·authority/원장·종료/로그·해시를 한 패킷으로 연결한다. 합의된 범위를 한 번에 심사하고 필수 누락·결함·권고를 분리한다. SHA 진전/기록 정정만으로 이미 수용한 GUI를 반복하지 않는다.
- #97 기술 종료·PR #157 심사와 O-01~07 방향 승인은 완료 [R10]. #92는 최종 규격/제품 적용 잔여로 OPEN 유지한다. 기존 심사·방향 선택을 재요청하지 않으며 이번 PR에서 Issue를 닫지 않는다.
- #104 DEV-026은 Stage 3 필수 범위이며 현재 공급 한정 수용·P07 구분 승인과 PR #158을 연결한다 [R11]. 원본 PARTIAL·미관측은 보존하고 W04B 비의존 공급/분담 수용은 PM-022 N행에 연결했다. DI-03 #185·HQ/S3-12 최종 취합 #186은 별도다. F-08 승인이나 문서 SHA 진전만으로 동일 GUI를 다시 요구하지 않는다.
- #139는 현재 정본/Owner 보관·백업 이월 상태를 유지한다. 백업 없음·복구 NOT_RUN·일정 NOT_SCHEDULED; 다음 재사용/인계 시 이월 전달·재확인, 대상/접근/일정 마련 후 수행. 일반 통상 인계는 INF-009 간소화 절차를 사용한다. [R08, R09]
- 과거 DPI/물리 신원·보조 도구 바이트 NOT_VERIFIED, Q12/EXIT 등 NOT_CAPTURED, requested_exit NOT_PROVIDED와 실패 이력은 사실대로 유지한다. 실제 새 신뢰성 문제의 영향 행만 검토한다.

**이번 PM-021 PR 검토 범위**는 이미 승인된 O-01~07과 부서 후속/적용 시점의 문서 정합성이다. 방향 선택을 재승인받는 절차가 아니다. 실제 추가 제품 변경·실험/Git 중 기존 권한에 없는 부분과 최종 규격이 필요한 해당 단위만 구체화한다. W04B/VS-02·S3-12/Stage 최종 인수는 각 증거와 Owner 결정으로 별도 추적한다. 이번 main 병합은 별도 Owner 승인 대상이다.

## 9. 공식 근거

- **R01 — Stage 2 최종 인수:** [Owner 결정·#141 종료](https://github.com/wisberry2022/MetroManager/issues/141#issuecomment-6892772104), [PR #144](https://github.com/wisberry2022/MetroManager/pull/144), [S2 인수표](STAGE2_ACCEPTANCE_MATRIX.md). merge `96c51ae6c3352195b9a8e8b89f92dd51c13be81c`; PM-019의 승인 대기 문구는 작성 당시 이력.
- **R02 — DEV-025 공급:** [PR #143](https://github.com/wisberry2022/MetroManager/pull/143), [결과](../engineering/tasks/DEV-025_RESULT.md), [상세 보고](../engineering/evidence/DEV-025_F08_REPORT.md), [실행 JSON](../engineering/evidence/DEV-025_F08_VALIDATION.json), [Design 입력/RD 기준](../design/tasks/DSG-008_DEV025_SAMPLES.md). head `8bd236957f5adcf50aeb418cbaa617779eb8241a`, merge `dc3c049134fb45764560e47116b3332bc2f5624d`. 정상자동497, 스크립트 렌더53조건과 실제 GUI M01~M06/7캡처, 짧은 Debug22조건/2639프레임은 각각 별개. [policy](https://github.com/wisberry2022/MetroManager/actions/runs/43697720036)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/43697720029) SUCCESS. 최종 FPS/다른PC/export/Design 수용을 뜻하지 않음.
- **R03 — Track B/DEV-026:** [#92](https://github.com/wisberry2022/MetroManager/issues/92), [#97](https://github.com/wisberry2022/MetroManager/issues/97), [#104 HOLD 후속](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6891486517), [RP 대조표](../design/tasks/DSG-008_DEV026_RESPONSE_AND_P06_P07_RECOMPARE.md). 과거 실험 NOT_RUN은 R02로 갱신한다. DEV-026의 과거 HOLD와 이번 Stage 3 편입/착수 준비는 §2.1로 구별하며 최종 F-08 규격 미확정은 유지.
- **R04 — MVP 승인 원본:** [Gate 2](../planning/PLN-001_GATE2_FINAL_APPROVAL.md), [C v0.7](../planning/PLN-001-C.md), [D v0.9](../planning/PLN-001-D.md), [DATA v1.4](../planning/PLN-001_GATE2_DATA_v1_DRAFT.md), [PLN-005 결과](../planning/tasks/PLN-005_RESULT.md). 파일명의 DRAFT만으로 최신 승인 절을 미결로 되돌리지 않음.
- **R05 — 후속 경로:** [PM-014](PM-014_STAGE2_VS01_EXECUTION_PLAN.md) §1.3/§6/§7, [DEV-006 W04B·VS-02 계획](../engineering/gate3/DEV-006_DEVELOPMENT_PLAN.md). DEV 계획은 기술 입력이며 새 실행 권한은 아님.
- **R06 — 검수 운영:** [PM-015](GUI_REVIEW_PROTOCOL.md), [부서 협업](../engineering/DEPARTMENT_WORKFLOW.md), [HQ 운영 규정](../governance/HQ_OPERATING_RULES.md). 운영 규정 서식 DRAFT와 승인된 Owner 정책을 구별.
- **R07 — 담당:** [등록부](../infra/agents/registry.json). 현재 ACTIVE ID를 확인하되 물리 신원·개별 권한 인증이나 새 역할 등록으로 사용하지 않음.
- **R08 — 원본/백업:** [#138 수용](https://github.com/wisberry2022/MetroManager/issues/138#issuecomment-6891410426), [#139 Owner 결정](https://github.com/wisberry2022/MetroManager/issues/139#issuecomment-6891629210), [#141 최종 이월 기록](https://github.com/wisberry2022/MetroManager/issues/141#issuecomment-6892772104).
- **R09 — 간소화 인계:** [INF-009](../infra/tasks/INF-009_LIGHTWEIGHT_SUCCESSION.md), [전환 규정](../infra/agents/REGISTRY_TRANSITION_RULES.md). 통상 Owner 전환 지시+후임 인수 확인, 불필요한 반복 시험/PM 확인/Owner 재승인 생략. 정확한 효력 시각·실제 기록·Git 권한 경계 유지.

본 HQ 작업의 게임 자동검사·Godot 로드·GUI/플레이·프로파일·빌드/export·백업 복구는 **NOT_RUN**. 비공개 QA 원본 재해시·새 Design 판정은 **NOT_VERIFIED**. 게임 명세 변경 필요 없음. 이번 PM-021은 승인 결정의 문서 반영이며 신규 제품 수용 판정이 아니다.

- **R10 — F-08 최신 결정 계보:** [#97 기술 종료](https://github.com/wisberry2022/MetroManager/issues/97#issuecomment-7052796254), [PR #157](https://github.com/wisberry2022/MetroManager/pull/157) merge `c5000c7094f987a84beb10b2ac2b9219117ceee9`, [Track B 전달](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057347487), [Owner O-01~07 결정](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335). 심사·선택안 원본은 위 merge SHA에 고정. 기존 `OPTIONS_NOT_APPROVED`는 승인 전 이력. 출처 보고 REPORT_ONLY/MANIFEST_NOT_FOUND를 인증 PASS로 바꾸지 않음.
- **R11 — DEV-026 최신 한정 수용:** [Owner 승인](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7057161624), [PR #158](https://github.com/wisberry2022/MetroManager/pull/158) merge `74cd75045feb1369aa429feaec64fd3558c14813`, [DEV 결과](../engineering/tasks/DEV-026_RESULT.md). 문서 병합 SHA이며 새 제품 시험 SHA가 아님. 기존 시험본 `ae614d922c837eddf4e615fda985bd978e217461`의 관측 한계·원본 PARTIAL 보존.

- **R12 — PM-022 현재 결정:** [Owner/HQ 기록](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7236141995), [상세 인수표](STAGE3_S3_12_ACCEPTANCE_SCOPE.md), [DI-03 실행 요청](requests/PM-022_DI03_DEPARTMENT_REQUESTS.md), [티켓](tasks/PM-022_S3_12_DI03_TRANSITION.md). 과거 계획의 HOLD/미공급 표현보다 최신 결정·행별 증거를 우선한다.
