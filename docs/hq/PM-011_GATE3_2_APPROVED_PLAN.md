# PM-011 — Gate 3-1 승인 계획의 공식 인계 및 Gate 3-2 Stage 1 기준

- **문서:** PM-011-G3-2-PLAN / v1.0 / 2026-11-01 / 소유: HQ(PM)
- **상태:** `GATE3_1_PLAN_OWNER_APPROVED / GATE3_2_KICKOFF_REQUESTED / PER_TICKET_EXECUTION_AUTH_PENDING`
- **승인 근거:** Owner는 2026-11-01 HQ 대화에서 「MetroManager — Gate 3-1 HQ 종합 검토 및 Stage 1 통합 계획안」을 보고받은 뒤 **“PM 에이전트 해당 보고서를 승인합니다”**라고 최종 승인했다. 이어서 “현재 확정된 계획과 ... Gate 3-2 단계를 착수할 수 있도록 ... 부서별 작업 착수 요청서를 포함한 PR을 생성”하도록 지시했다. **본 문서는 승인된 계획을 Git에 기록하고 착수 조정을 시작하는 것이며 개별 작업의 Commit/Push/PR·main Merge·릴리스 권한을 대신하지 않는다.**
- **승인 보고서:** `MetroManager_PM_Gate3-1_Integrated_Review_2026-11-01.md` (Owner가 수령·승인한 HQ 대화 첨부; 이 파일 자체는 기존 `main`에 없었음). 현재 문서는 승인 결과의 공식 HQ 요약이며 정책·게임 규칙을 새로 결정하지 않는다.
- **이번 PR 기준 `main`:** `ac04302f2bdab75aab49f0950bce92f115ec8047` (부서가 실제 작업을 시작할 때 최신 HEAD 재확인).
- **원본:** [Gate 2 최종 승인](../planning/PLN-001_GATE2_FINAL_APPROVAL.md), [C v0.6](../planning/PLN-001-C.md), [D v0.9](../planning/PLN-001-D.md), [DATA v1.3](../planning/PLN-001_GATE2_DATA_v1_DRAFT.md), [PM-008](PM-008.md), [PM-010](PM-010_GATE3_1_REQUESTS.md).
- **부서별 입력:** [DEV Gate 3-1](../engineering/gate3/DEV-006_GATE3_1_ANALYSIS.md)·[W01~09](../engineering/gate3/DEV-006_DEVELOPMENT_PLAN.md)·[UI v0.2.1](../engineering/gate3/DEV-006_UI_DATA_CONTRACT.md), [DSG Gate 3-1](../design/tasks/DSG-002_GATE3_1_DESIGN_STAGE_PLAN.md), [PLN Gate 3-1](../planning/tasks/PLN-002_RESULT.md). 병합 [PR #33](https://github.com/wisberry2022/MetroManager/pull/33) / [#34](https://github.com/wisberry2022/MetroManager/pull/34) / [#36](https://github.com/wisberry2022/MetroManager/pull/36); 기초 [Issue #24](https://github.com/wisberry2022/MetroManager/issues/24), [#25](https://github.com/wisberry2022/MetroManager/issues/25), [#26](https://github.com/wisberry2022/MetroManager/issues/26).
- **관련 절차:** [실행 협업·QA](PM-011_GATE3_2_EXECUTION_PROTOCOL.md), [기획 착수](requests/PM-011_PLANNING_KICKOFF.md), [디자인 착수](requests/PM-011_DESIGN_KICKOFF.md), [개발 착수](requests/PM-011_DEVELOPMENT_KICKOFF.md).

## 1. 승인된 결정과 미승인 권한 분리

| 대상 | 상태 | 의미 |
| --- | --- | --- |
| Gate 3-0 부서별 분석 / Gate 3-1 HQ 통합 보고서 | **OWNER_APPROVED** | 본 문서의 아래 Stage 1 범위·의존성·검수 계획을 기준으로 사용 |
| 첫 Stage에 최소 실제 조작 UI 포함 및 자동+GUI 조작 증거 | **OWNER_DECIDED** | [Issue #24 Owner 동의](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6555874135) 유지; 재승인 요구 불필요 |
| Gate 3-2 부서 착수 조정 | **OWNER_REQUESTED** | 본 HQ PR 배포 후 각 부서는 소관 실행 티켓·실행 범위·의존성을 확인하고 요청 가능 |
| 실제 게임 코드·씬·아트 제작 및 관련 Git 동작 | **PER_TICKET_OWNER_APPROVAL_REQUIRED** | 이 HQ PR과 부서 착수 요청만으로 포괄 권한 부여 불가 |
| W02 공통 시각/원장 위험·회귀 범위 | **PRIORITY_REVIEW_ON_EXECUTION_TICKET** | L3 영향 후보로 선제 추적; 승인 SEM/CLOSE 구현 자체가 신규 정책 변경은 아님 |
| `main` 병합·주요 MVP 규칙 변경·릴리스 | **OWNER_SEPARATE_APPROVAL_REQUIRED** | 동일한 Owner의 별도 결정 필요 |

**이번 Gate 3-2 착수는 단계 전환과 티켓별 실행 승인 준비를 의미한다.** 권한이 명시된 개별 티켓은 별도 Owner 승인 후 실제 제작에 착수한다. 부서가 이미 승인된 독립 티켓을 보유했다면 그 유효 범위를 검증하고 중복 승인을 요구하지 않는다.

## 1.1 Planning 담당 전환과 착수 전 확인

- 2026-11-01 Owner의 현직 신규업무 종료·후임 전환 통지와 [PLN-002 #26](https://github.com/wisberry2022/MetroManager/issues/26), [Gate 3-1 PR #36](https://github.com/wisberry2022/MetroManager/pull/36)을 근거로 **Gate 3-1 Planning 공식 담당자는 후임 Game Designer**이다. [HQ 공개 전환 기록](PM-011_PLANNING_SUCCESSION_RECORD.md) 참조. 현직은 신규 업무에서 제외되고 과거 이력 확인용으로 보존하며, 구 세션의 Git 권한은 자동 승계되지 않는다.
- 기획·디자인·개발은 Gate 3-2 신규 실행 전에 병합된 [PM-010](PM-010_GATE3_1_REQUESTS.md)의 자기 부서 체크리스트와 PM-011 계획·착수 요청을 최신 main에서 읽고 기존 Issue에 **수신 확인, 확인 SHA, 담당, 티켓별 권한 상태**를 남긴다. 기존 Gate 3-1 회신을 재활용하며 전체 재검토는 요구하지 않는다. 자세한 절차는 [실행 지침 §0](PM-011_GATE3_2_EXECUTION_PROTOCOL.md).

## 2. Stage 1 목표와 포함·제외

**목표:** 실제 실행 가능한 최소 Godot 게임 진입, 승인 데이터·권위 있는 시각/경제 원장·행정/노선/예측을 테스트로 검증하고, 최소한의 사용자 조작 UI에서 시간 진행과 후보역/노선 편집·예측·현재 자금을 확인하는 것.

| 단위 | 핵심 범위 | 담당 / 역할 |
| --- | --- | --- |
| **W01** | 메인 게임 진입(별도 메인 메뉴 불필요), 승인 데이터/버전/안정 ID·초기 회사 상태, 실패 종료코드와 자동 검증 진입 | DEV 구현; DSG 초기 상태 표현 |
| **W02-A** | 정수 게임분/부분분, 정지·재개/1·2·4배속, 명령 ID·효력시각 및 사건 순서 | DEV 주관 |
| **W02-B** | C/Rᵢ/F/Kᵢ/A/B, 발생비·실제 지급·B 정산, 제한/예약 보호, 일일 마감 스냅샷 불변 | DEV 구현·원장 검증; PLN 승인 규칙 확인 |
| **W03-A** | 1도·1시·4구·8동·후보역12, 안정 ID/소속/간선, 노선6~8 고유역과 오류 판정 | DEV 주관; DSG 지도/목록 검수 |
| **W03-B** | 승인된 OD 수요/예측, 입력·결과 revision, READY=0/미계산/실패/이전값 분리 | DEV 규칙 계산; DSG 최소 예측 표시 |
| **W07 최소 부분집합** | 저충실도 S01 지도·역 목록, 선택·제거·순서·되돌리기/거부사유, 최소 예측, 게임 시간 실제 조작, 현재 자금/마감보고 **읽기 전용** 관찰 | DEV 권위 snapshot/명령·UI 동작, DSG 정보 구조·상태·가독성 |
| **PLN 지원** | 위 항목의 Gate 2 승인 규칙·테스트 반례 확인, 해당 의미 변경만 제한 검토 | PLN; 기존 규칙 재설계 없음 |

**명시적 제외:** 실제 W04A/B 입찰·회사제안/심사·계약, W05 시공/안전·개통, W06 실제 영업·운임·일일보고·다음사업, P01~P07 완성 UI/고충실도 아트·열차 연출, Windows export/FPS 합격, 외부 사용성 집행, 전체 AC-01~10·독립 VP-01/02 E2E 완주. W02의 미구현 계약/도착 사건은 테스트 fixture로 검증할 수 있지만 제품 기능인 것처럼 UI에 노출하지 않는다.

Stage 1 종료는 **전체 MVP/VS-01 완료가 아니다**. 다음 Vertical Slice는 공공입찰 B01 경로 연결 VS-01과, 자체 제안의 독립 VS-02를 유지한다. VP-01 회사 제안과 VP-02 공공입찰은 각각 별도의 독립 초기 상태로 검증한다.

## 3. Stage 1 선행·병렬·통합 순서

1. **실행 승인 확인:** Stage 범위는 승인되어 있다. 각 실제 제작 티켓은 담당/범위/경로/브랜치/Commit·Push·PR/검증/종료조건에 대한 Owner 결정을 기록한다.
2. **W01 먼저:** DEV가 승인 데이터·초기 상태·명령/결과·snapshot/fixture 테스트 경계의 실행 기반 확보. DSG의 라벨/상태·저충실도 정보 구조 제안은 병행 가능.
3. **W02 ∥ W03:** W01 기반 충족 후 DEV가 독립 기술 작업과 통합 시점을 판단. 상호 데이터·코드 충돌 시 **영향받은 작업만** 차단.
4. **UI 최소 통합:** DEV의 실제 동일 revision snapshot·reason/action·정상/실패 fixture 제공 후 DSG 상태/오류/지도·목록 조작과 실제 GUI로 대조. W02 시간·원장 읽기 상태 및 W03 노선·예측의 연결이 필요.
5. **Stage 인수:** DEV 자동 규칙·회귀/실제 엔진·GUI 증거 → DSG 화면/사용성 기본 검수 → 필요시 PLN 승인 의미 확인 → HQ 통합·리스크 정리 → Owner 결과 수용.

**차단 시점을 좁게 관리:** W02 불변식 실패는 W02 인수를 막지만 W03 독립 계산 전체를 자동 중단시키지 않는다. 지도/에셋 최종화는 밀집/동등 조작 검증 전 차단되나 W03 권위 데이터 계산을 막지 않는다. 미승인 PC 성능 기준은 고충실도/성능 인수에만 적용한다.

## 4. Stage 1 부분 인수 기준 (승인 HQ 계획)

| ID | 필수 증거 및 실패 경계 |
| --- | --- |
| **S1-01** | 실제 Godot 프로젝트 headless 로드와 GUI 제품 진입을 **분리**하여 확인. 코드/데이터 버전·초기화·오류/종료코드 기록 |
| **S1-02** | 승인 데이터·초기 C=1,000,000/R=K=B=0, 시작일06:00, 행정 부모/12후보와 잘못된 버전·ID·고아·중복 입력 거부 |
| **S1-03** | 정상 6/8역·비정상 5/9·중복/재방문·단절/관할외 간선의 승인 유효성, 실패시 경제/난수 부작용 없음 |
| **S1-04** | 승인 수요/OD·거리/시간/예측의 기대/실제, revision 일치·READY0/미계산/실패/오래된 결과 구분 |
| **S1-05** | `F=C−ΣRᵢ`, `K=ΣKᵢ`, `A=max(0,F−K)`, R/K 보호·발생비/지급 분리·B 상환. 승인 DATA 경계 fixture 비교 |
| **S1-06** | 같은 T에서 계약→도착운임→B 정산→신규탑승 순서, 후순위 운임 선사용 금지, 자정 보고 불변/CLOSE-01 검증. 미구현 거래는 **테스트 이벤트로만** |
| **S1-07** | 정지/재개·1/2/4배속의 실제 UI 입력과 게임시각 결과; 일괄/분할/반복명령 회귀 및 실패 종료코드 |
| **S1-08** | 지도/역목록 동일 안정 ID·순서/선택/제거/되돌리기와 실제 오류복구, 최소 예측·현재/마감 장부·자료없음/0의 실제 화면/조작 증거 |
| **S1-09** | 승인 명세·티켓·Git 경로, 원격 `policy`/`department-policy`, 소관별 검증/결함/NOT_RUN과 연결된 인수 기록 |

이 S1-01~09는 **Stage 1 한정**이며 기존 MVP AC-01~10 또는 VP-01/02를 대체하지 않는다. 실게임 자동검사·GUI 조작·Windows 빌드/성능 등 **미실행 항목은 NOT_RUN**, 정적 fixture 검산과 실제 구현의 PASS를 구분한다.

## 5. 후속 이월과 Owner 판단 시점

| 추적 | 다음에 반드시 필요한 작업 | 정확한 차단 시점 |
| --- | --- | --- |
| **G3-01** | UI-DC-01~07 중 Stage에서 사용하는 실제 snapshot/명령·허용행동/오류·값/시각 fixture 공급·소비 검증 | **해당 최소 UI 통합 전**; P05/06/07 및 다음사업의 전체 계약은 각각 후속 기능 통합 전 |
| **G3-02** | 12후보·6/8 정상 및 부정 경로 지도 밀집·가독성·목록 동등 조작 검증 | Stage 1 최소 지도 인수 및 상세 아트/역 규격 확정 전 |
| **G3-03** | PC/뷰포트/폰트/배율·FPS/표현 상한·측정 장면 대안 | 규격 종속 고충실도 제작·성능 합격 기준 확정 **전**, DEV+DSG→HQ→Owner |
| **G3-04** | 실행 티켓 분할, W02 중요한 원장 영향·회귀 범위·단계별 검증 | 실제 제작 시작 **전**, 소관팀→HQ 통합→Owner 승인 |
| **G3-05** | Godot 실제 자동·GUI 증거 및 나중 두 VP 독립 플레이/원장 재현 | Stage 부분 인수 / 전체 MVP 인수 각각 |
| **G3-06** | 외부 사용성 표본·합격선·예산 | 외부 사용자 모집·예산 집행 전 |

`1280×720`, `40px` 등의 기존 시안은 **승인된 제품 규격이 아님**. 기획/대상 게임의 추가 규칙이나 수치 변경은 이번 계획으로 허가되지 않는다.

## 6. 실행 승인 체크포인트

**Gate 3-2 작업 착수 요청의 실효 범위:** 각 부서는 최신 승인 원본·티켓 번호 중복·기존 미공유 파일을 확인하고 **자기 실행 작업의 최소 단위와 승인 요청을 제출**한다. 이 단계의 일반 분석·Issue 협의·읽기는 가능하다. **Godot 코드/씬 변경, 신규 아트 제작, 해당 Git Commit/Push/PR은 그 작업의 Owner 승인 범위를 확인한 뒤 진행**한다.

- DEV: W01 실행 기반의 독립 티켓이 첫 우선순위. W02(공통 시간/원장)는 높은 영향도·회귀·권한 경계를 반드시 기록.
- DSG: 개발 W01과 병렬 가능한 저충실도 UI 구조/상태·최소 검증물의 소관 티켓 제안. 실제 디자인 파일/에셋 작성과 원격 제출은 개별 승인.
- PLN: 별도 새 기획 규칙 작성이 아니라 기존 승인 기능·경계 사례 지원. 규칙 영향 차이를 발견할 때만 변경/Owner 판단 필요 여부 검토.

기존 [Issue #24](https://github.com/wisberry2022/MetroManager/issues/24), [#25](https://github.com/wisberry2022/MetroManager/issues/25), [#26](https://github.com/wisberry2022/MetroManager/issues/26) 및 새 실행 Issue를 연결하고, 현재의 분석 Issue를 구현 완료로 임의 종료하지 않는다.

## 7. 과거 초안과 효력 경계

미PR·미병합 `codex/PM-009-gate3-stage1-plan`의 오래된 초기 Stage 초안은 승인 원본이 아니다. **이 PM-011이 Owner가 승인한 최신 Gate 3-1 통합 결과를 `main`에 게시할 대상**이다. 과거 브랜치를 강제 수정·삭제하거나 함께 병합하지 않는다. 동일 Stage 계획 원본을 PM-009와 PM-011로 이중 운영하지 않는다.

이 문서는 HQ 업무/단계 운영 기록이며, [기존 승인된 PM-008](PM-008.md)과 기술 검사기를 완화하거나 타부서 R&R을 변경하지 않는다.
