# DEV-005 프로젝트 현황 분석

- 작성: LAPTOP Project Leader / 2026-11-01 (Asia/Seoul) / REVIEW
- 조사 기준: `dc06e48b1dbc7745dcb0a29e424cd0416767ab38` (fetch 후 로컬 HEAD=origin/main).
- 방법: Git 추적 파일, 승인 원문 보존 문서, 기획 A/B/C/D/DATA, 부서 검토·결과, Godot 설정, 정책 코드·CI 조사. 다른 PC의 채팅·미공유 파일은 조사 범위 밖이다.

## 판단

**Gate 1은 Owner 승인, Gate 2는 최신 개발·디자인 재검토와 HQ 조건부 승인을 마쳤고 기획 보완 3건 및 Owner 최종 결정을 기다리는 단계다. 게임 구현은 착수 전이며 Gate 3 일정 수립도 미완료다.** 최초 저장소 조사 이후 Owner가 전달한 같은 기준 SHA의 검토 원문을 반영했다. 이번 보고 자체가 Gate 승인이나 신규 전문 재검토를 대신하지 않는다.

| 구분 | 확인 결과 | 근거 |
| --- | --- | --- |
| Gate 1 | A/B v0.3 OWNER_APPROVED, 콘셉트·핵심 루프 승인 | [Owner 기록](../../planning/sources/PLN-001_OWNER_DECISIONS.md), [A](../../planning/PLN-001-A.md), [B](../../planning/PLN-001-B.md) |
| Gate 2 최신 범위 | C v0.5-draft REVIEW, D v0.8-draft DRAFT. 이후 PM-006 HQ 조건부 승인, 공식 Gate 2 OWNER_PENDING | [C](../../planning/PLN-001-C.md), [D §5~7](../../planning/PLN-001-D.md), 아래 전달 자료 |
| 수치·정책 | PAR-01~05 수치 사용 승인, SEM-01~03 Owner 결정 반영 | [Owner Gate 2 기록](../../planning/sources/PLN-001_GATE2_OWNER_DECISIONS.md), [DATA v1.2-draft](../../planning/PLN-001_GATE2_DATA_v1_DRAFT.md) |
| 전체 승인 절차 | APP-01 OWNER_PENDING | DATA §1·7 및 D 최신 결정 |
| 부서 검토 | 최신 dc06e48 기준 DEV/Design CONDITIONAL, HQ 조건부 승인 | Owner 전달 DEV-004 SEM 재검토, DSG-001 v0.2, PM-006 |
| 구현·일정 | 게임 스크립트·씬·게임 데이터/테스트·빌드 설정 없음. Gate 3 일정안 미수립 | Git 추적 파일·project.godot, D §6 |

위 표의 구현 설명은 아래 소스 조사 기준이며 `.godot/` 캐시는 구현 산출물로 보지 않는다.

## 제품과 현재 MVP 경계

정체성은 수요 분석 → 자체 제안의 시청/정부 심사 또는 공공입찰 → 시공 → 시험/안전 검증 → 영업/시민 반응 → 재무 확인 → 다음 사업의 반복이다. 행정 절차가 핵심이며 단순한 선로 배치 게임으로 축소하지 않는다.

현재 선택은 쉬움·시철, 도1/시1/구4/동8, 후보역12 중 노선당 서로 다른 6~8역, 입찰2·제안 시나리오2, 동시 운영/시공 각각1이다. 하루 현실10분·정지/1·2·4배속·영업06~24, 경로별30~45분은 시연 출발값/목표이며 실측 성능·재미 보장이 아니다.

8영역과 MUST 11개(F-ADM/CITY/COMP/BID/PROP/CONST/OPEN/OPS/FIN/NEXT/TIME), AC-01~10, 독립 VP-01(회사 제안)/VP-02(공공입찰)를 유지한다. 두 경로를 합친 시연 하나로 대체할 수 없다. 사용자 저장·장기 파산/구제는 SHOULD이며, 저장 제외와 무관하게 반복 재현 검수 계획은 필요하다.

SEM의 최신 의미는 운영비 발생/지급/미지급 B 분리, B>0 시 새 탑승만 제한·기존 승객 도착 허용, 도착 운임의 B 우선 자동 정산, R(정부 제한잔액)/K(자체 공사 예약) 보호, 고정 게임 분 사건 순서다. 미지급 즉시/6개월 신규 사업 제재와 플레이어 공사 계약 직접 취소는 MVP 제외다. [Idea Library](../../planning/idea-library/README.md)의 미래 방침을 MVP에 추가하지 않는다.

## 실제 소스·검사 기반

| 경로 | 관찰 | 의미 |
| --- | --- | --- |
| project.godot | config_version=5, 표시 이름 `새 게임 프로젝트`, features 4.7/Forward Plus, Windows d3d12, canvas_items/expand, Jolt 설정 | 생성 프로젝트 설정만 존재. 설치 엔진 버전·실제 지원 여부는 별도 확인 필요 |
| scripts/, scenes/, assets/ | 해당 디렉터리 없음. 추적 .gd/.tscn/.tres/.cs 0개 | 게임 로직·UI·씬·콘텐츠 구현 없음 |
| project.godot의 run/main_scene, export_presets.cfg | 없음 | 실행 가능한 메인 게임과 Windows 내보내기 구성이 준비되지 않음 |
| icon.svg, icon.svg.import | 기본 프로젝트 리소스 | 게임 아트 제작 완료 증거 아님 |
| tools/policy.py, department_policy.py, install_hooks.py | 텍스트/GDScript·메시지·티켓·부서 경로·이력·훅 검사 도구 | 현재 개발 코드는 저장소 운영 도구 중심 |
| tests/tooling/ | 정책 도구 테스트 2파일 | 게임 경제/시간/E2E 테스트가 아님 |
| .github/workflows/ | policy: PR 코드·테스트; department-policy: 신뢰한 base 코드의 경로/이력 검사 | 원격 실제 보호 설정·최근 실행 결과를 파일 존재만으로 단정하지 않음 |

코드 컨벤션의 Godot 4.7.2 표현, project.godot의 4.7 기능 표기와 랩탑 실제 설치 버전은 구별해야 한다. 이번 PATH에서 godot/godot4는 발견하지 못했으며 설치 자체가 없다고 단정하지 않는다. 엔진·렌더러를 변경하지 않았다.

## 검토 이력과 최신성 한계

DEV-001은 저장소 초기화, DEV-002는 코드/Git 규칙·검사, DEV-003은 부서 정책과 원격 보호 도입 기록, DEV-004는 Gate 2 2차 개발 검토다. 과거 완료 보고의 REVIEW를 이번 조사에서 DONE으로 바꾸지 않는다.

DEV-004와 실제 저장소의 DSG-001/PM-005 보고서는 `e18b047848108383acdcef47250ee81393df2058` C/D 기준의 CONDITIONAL이다. 이후 main에는 기획 수치 승인 반영 `c0c5f547...`, 최신 SEM/Library 반영 `dc06e48...`가 있다. 따라서 과거 DEV-R05 BLOCKED나 Q 미승인 표현은 해당 검토 당시 상태다. 최신 결정은 반영됐지만 이를 근거로 개발 검증 완료·RESOLVED를 자동 선언할 수 없다.

D v0.8은 c0c5f547 기준 3차 개발/디자인/HQ 회신을 요약한다. 그러나 현재 추적 파일에는 별도의 3차 원본 보고서가 없다. 3차 내용은 **기획 인수인계서의 요약을 확인한 수준**이며 독립 원문 대조를 마쳤다고 주장하지 않는다. 예를 들어 디자인 24~40일은 이 요약의 예비 추정이고 기존 DSG 원문 20~31일과 기준이 다르다. 개발 M/L과 합산하거나 출시 날짜로 환산하지 않는다.

## 최초 저장소 조사 시점의 잔여 목록 (이력)

아래 표는 전달 자료 수령 전 상태다. 현재 판정과 담당·처리 시점은 뒤의 최신 회신 절이 우선한다.

| 잔여 | 다음 증거/책임 |
| --- | --- |
| 최신 승인 묶음 고정·APP-01 | Planning/Owner가 버전·승인 범위와 절차를 정리. 부분 승인과 Gate 전체 승인 구별 |
| BLOCK-G2-02/03/04 | 최신 DATA의 확대 도시/입찰/행동표·장부·계약·미지급·자정 순서/분할 결과를 DEV가 검산하고 기존 ID별 재판정 |
| UI 데이터 공급 계약 | DEV/Design이 C/R/F/K/A/B, 현재/과거, 예상/실적, 탑승/이동/완료·차단 사유의 의미·공급 책임 합의 |
| BLOCK-G2-05 | DEV/Design이 대상 PC·해상도·연출 상한·측정 장면/성능 대안 제시 후 Owner 선택 |
| BLOCK-G2-06 | 같은 버전·초기 상태·시드·입력/시각을 쓰는 두 독립 VP 재현 수단·검수 계획·공수·세션 가정 |
| BLOCK-G2-07 및 01 종결 | 최신 부서 수용/새 견적·인력·외부 사용성 대안과 HQ의 블로커 종결/잔여 위험 통합 |
| 최종 결정 | Owner Gate 2 최종 승인 후 Gate 3 일정안. 별도 승인된 개발 티켓 없이 게임 구현에 착수하지 않음 |

Gate 2에서 필요한 것은 구현 가능한 명세·검수 계획·견적과 승인이다. 아직 존재하지 않는 완성 게임 E2E PASS를 문서 게이트의 선행조건으로 추가하지 않는다. 실제 MVP 인수 단계에는 별도의 실행 증거가 필요하다.

## RFC-DEV-005-01 — 3차 회신 원본 인계

- 상태: ANSWERED (최신 검토 기준 확보) / 요청: Development LAPTOP / 응답 책임: Development DESKTOP, 필요 시 Planning/HQ 출처 확인
- 연관: DEV-005, PLN-001 / 근거: 기준 SHA의 D v0.8 §4 최신 3차 검토 요약
- 현황: c0c5f547 기준 3차 회신 요약은 있으나 원본 경로·버전·출처 대조 자료가 추적 파일에서 발견되지 않음.
- 질문: 기존 3차 개발·디자인·HQ 원본이 있으면 경로/버전/기준 SHA/Owner 인계 근거를 제공하고, 없다면 미확보 상태를 확인해 후속 재검토 기준을 고정해 주시기 바람.
- 영향: 과거 검토 재사용·수정 공수 판단. 이번 협업 문서 작성은 계속 가능하며 게임/세이브 변화 없음. 외부 작업 일정은 산정하지 않음.
- 개발 의견: 요약은 참고하되 최신 dc06e48 묶음의 정식 재검토로 대체하지 않음. HQ 조정/답변: PENDING.
- Owner 결정 필요: 원본 인계 자체는 추가 게임 정책 결정 아님. 부서 경계·범위가 달라지면 Owner/HQ 조정. 반영 대상은 후속 개발 검토와 인계 기록이며 타 부서 원문은 수정하지 않음.

### Owner 전달 자료 수령 후 답변 (2026-11-01)

Owner가 이번 채팅에서 Downloads의 다음 세 원문을 제공했다. 파일명 뒤 (1)/(2)는 다운로드 사본 표기이며 원문 문서 ID를 대체하지 않는다. 원문은 읽기만 했고 타 부서 파일을 개발 경로에 재게시하거나 수정하지 않았다. 다른 환경에서는 Owner 전달본을 확보해 아래 SHA-256으로 대조할 수 있다.

| 전달 파일 | 기준 / 판정 | SHA-256 |
| --- | --- | --- |
| DEV-004_GATE2_SEM_REVIEW_20261101(1).md | dc06e48 / DEV-004 후속 / CONDITIONAL | 4fb1a51e49466a8fe086b55c5b0b95550842c9dfc174c9fef5652dd17c0420ed |
| DSG-001_GATE2_HQ_REVIEW_2026-11-01(2).md | dc06e48 / v0.2 / CONDITIONAL | 58c338c7d7a645d2b04b37ecdff94f67a04bd5c8e321be9251b3c17bc2ff6cf8 |
| PM-006.md | dc06e48 / REVIEW / HQ 조건부 승인 | 55a1965aa6fec0b7a447992a5225c0a60302db384e52153250b321b66e1a1779 |

최신 기준의 재검토 여부는 원문으로 확인됐다. c0c5f547 기준 과거 3차 원본 자체를 확보한 것은 아니지만 현재 판정에 필요한 최신 원문이 확보돼 본 질의는 ANSWERED로 정리한다. 문서 내 후속 작업 요청은 검토 의견이며 이번 DEV-005의 구현·타 부서 수정 지시로 실행하지 않는다.

## 최신 Gate 2 판정과 다음 단계 (전달 자료 반영)

- DEV-R01~08: RESOLVED 5 / PARTIAL 3 / OPEN 0 / BLOCKED 0. DEV-R05는 BLOCKED→PARTIAL. SEM 정책의 구현 가능성을 인정했으며 잔여 승객 비용 해석과 UI 공급 계약·환경·작업계획은 후속 조건이다. 개발 보고의 산술 10 assertions PASS는 데스크톱의 정적 검산 보고이며 랩탑 실행 결과나 게임 PASS가 아니다.
- DSG-R01~08: RESOLVED 1 / PARTIAL 7 / OPEN 0 / BLOCKED 0. 최소 시민 표현 정책은 해소, UI 데이터 계약·지도 가독성·기기/성능·수정 WBS는 후속 조건이다. 24~40 디자이너 작업일은 미실측 예비 범위이며 확정 일정이 아니다.
- PM-006: HQ CONDITIONAL/조건부 승인. BLOCK-G2-01/03 RESOLVED, 04 CONDITIONALLY_RESOLVED, 02/05/06/07 PARTIAL. 이전 PM-005의 상정 BLOCKED를 현재 HQ 결론으로 재사용하지 않는다. APP-01 및 공식 Gate 2는 OWNER_PENDING이다.

| 기획 직접 보완 | 완료할 내용 / 처리 시점 |
| --- | --- |
| PLN-G2-CLOSE-01 | 기존 이동 중 승객의 잔여 도착에 별도 운영비를 더하는지 단일 해석과 경계 기대 장부로 확정. 시간·원장 티켓 확정 전. 개발 권고는 기존 서비스 구간 비용에 포함, 추가 비용 의도 시 Owner 결정 필요 |
| PLN-G2-CLOSE-02 | PAR 승인·SEM 결정·APP/Gate 대기를 일관 표기하고 과거 상태를 이력으로 구분. 최신 부서 판정 반영. Gate 2 결재 묶음 고정 전 |
| PLN-G2-CLOSE-03 | 버전/SHA·승인 범위·보완 결과·부서 회신·잔여 책임과 해소 시점을 Owner 결재용 묶음으로 제출 |

DEV/Design의 UI 의미 데이터 계약은 UI 통합 티켓 전, 지도 가독성은 상세 에셋 확정 전, 기기/성능 기준은 해당 규격 종속 작업 확정 전, WBS/작업량·인력·사용성 계획은 Gate 3 일정 승인 전의 조건이다. 기획에 이 업무를 모두 재위임하지 않는다. HQ의 조건부 이월·APP-01은 Owner 판단 대기이며 이월이 면제를 뜻하지 않는다.

기획 보완 후 Owner가 Gate 2 승격 여부를 판단한다. PM-006은 Owner가 별도로 요청하지 않으면 HQ 재심사를 필수 반복 절차로 두지 않는다. 실제 VP/AC·Godot/빌드·성능·사용성 검증은 구현 후 인수 단계다. Gate 2 승인만으로 개별 개발 착수나 Git/릴리스 권한을 부여하지 않는다.

## 검증·변경 영향

실행 결과는 [DEV-005 결과](../tasks/DEV-005_RESULT.md)에 모은다. 이번 작업은 개발 문서와 로컬 검사 환경 준비뿐이다. DEV-005 자체의 게임 기획/디자인 명세 변경 필요 없음. Planning의 CLOSE-01~03 보완은 담당 부서 후속 과제다. PR 제출 시 branches/main API로 protected=true와 필수 policy/department-policy(GitHub Actions App 15368)를 재확인했다. 세부 보호 설정 전체의 재검증을 뜻하지 않는다.
