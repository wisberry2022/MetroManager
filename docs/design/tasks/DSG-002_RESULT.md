# DSG-002 — Gate 3-0 디자인팀 초기 분석 및 작업 분해 보고서

- 프로젝트: MetroManager
- 담당: Design / Art Director & UI/UX Designer
- 작성일: 2026-11-01
- 버전: v0.5 / 상태: REVIEW — Gate 3-0 의미 수용 및 Gate 3-1 첫 Stage 디자인 계획 제출, 실제 목업·제작·인수 전
- 작업 추적: [GitHub Issue #24](https://github.com/wisberry2022/MetroManager/issues/24)
- 기준 저장소: `wisberry2022/MetroManager` / `main` SHA `ca597ec541647aa2e9701ec93972e8763eae066d`
- 승인 기준: [Gate 2 최종 승인](https://github.com/wisberry2022/MetroManager/blob/ca597ec541647aa2e9701ec93972e8763eae066d/docs/planning/PLN-001_GATE2_FINAL_APPROVAL.md) / C v0.6, D v0.9, DATA v1.3
- HQ 요청: [PM-008-DSG](https://github.com/wisberry2022/MetroManager/blob/ca597ec541647aa2e9701ec93972e8763eae066d/docs/hq/requests/PM-008-DSG.md)
- 프로세스: [PM-008](https://github.com/wisberry2022/MetroManager/blob/ca597ec541647aa2e9701ec93972e8763eae066d/docs/hq/PM-008.md) (A안, Markdown 티켓+Issue 병용, L1/L2/L3)
- 이전 디자인 기준: [DSG-001](https://github.com/wisberry2022/MetroManager/blob/ca597ec541647aa2e9701ec93972e8763eae066d/docs/design/tasks/DSG-001_RESULT.md), [1차 에셋 제안](https://github.com/wisberry2022/MetroManager/blob/ca597ec541647aa2e9701ec93972e8763eae066d/docs/design/sources/PLN-001_GATE2_DESIGN_RESPONSE.md)

## 1. 판정과 업무 경계

**Gate 3-0 디자인 분석에 착수하며 HQ에 후속 실행 티켓 분해안을 제출한다.** Gate 2의 8개 MVP 영역, MUST 11개, AC-01~10, 독립 VP-01·02, 쉬움·시철, 도1/시1/구4/동8/후보12/노선6~8역은 변경하지 않는다. PAR-01~05 수치 및 SEM-01~03·CLOSE-01~03·APP-01의 Owner 결정도 유지한다.

본 산출물은 **IA/작업 분해·잠정 UX 및 에셋 명세**이지 최종 디자인 승인이나 목업·에셋 구현 완료가 아니다. 최초 작성 당시에는 GitHub Issue만 등록했으나, 2026-11-01 Owner의 후속 **PR 생성 직접 지시**에 따라 DSG-002 작업 브랜치·필수 Markdown 티켓·본 보고서를 검수용 PR로 제출한다. main 병합·실제 이미지 제작·엔진 구현은 이번 승인 범위 밖이다.

## 2. 현재 자산 및 재사용 조사

원격 `main`의 파일 트리에서 `docs/design/README.md`, `docs/design/tasks/DSG-001_GATE2_REVIEW.md`, `DSG-001_RESULT.md`, `docs/design/sources/PLN-001_GATE2_DESIGN_RESPONSE.md`를 확인했다. **실제 픽셀 아트 PNG, 화면 목업, 완료된 디자인 시스템 에셋은 확인되지 않았다.** 따라서 재사용이란 *이미 제작된 이미지의 재사용*이 아니라 이전 DSG-001의 DD-01~08 **설계 패턴 재사용**을 뜻한다.

- DD-01 단일 강조 지도 레이어 및 행정 브레드크럼
- DD-02 공공입찰/자체 제안 별도 카드 및 단계
- DD-03 기관·상태·사유·가능한 다음 행동의 공통 결과 구성
- DD-04 지도 클릭 + 순서 목록·상하 이동·제거·되돌리기
- DD-05 계약/시공/시범/안전/개통 단계 및 중단 원인 분리
- DD-06 집계 + 열차 이동/정차 + 승하차 아이콘 최소 표현
- DD-07 과거 고정 일일보고와 현재 C/R/F/K/A/B 분리
- DD-08 예상/실적 및 단위·기준시점, 자료없음/0 구분

## 3. 화면·컴포넌트 최초 작업 분해 (MVP 승인 기능과의 연결)

다음은 **문서 설계안**으로, 신규/재사용 표시는 설계 패턴 기준이다. `S01` 공통 셸 + `P01~P07` 패널 + `D01~D03` 공용 대화상자 분류를 유지하되 화면 상태와 재사용 컴포넌트는 별도로 센다.

| 작업 묶음/화면 | 연결 기능 및 AC/VP | 패턴 재사용/신규 | 최소 산출물과 상태 | 사용성 위험·검수 | 입력/선행·병렬성 | 영향 |
|---|---|---|---|---|---|---|
| DSG-G3-A / S01 지도 셸·HUD | ADM, CITY, TIME / AC-01·02·08 | DD-01 재사용, 실제 구현 신규 | 도시맵, 현재 관할·게임시계·레이어·정보바; 정상/일시정지/자료없음 | 행정 계층 혼동·동시 강조 혼잡; 4구/8동 읽기 | 행정 ID·부모·경계·시간; 컴포넌트 규칙은 병렬 | L2 |
| DSG-G3-B / P03 지도·후보역 편집 | CITY, PROP / AC-01·04 / VP-01 | DD-04·08 재사용, 제작 신규 | 후보 12개, 선택 6~8역, 순서·중복·단절·관할 외 오류, 제출 확인 | 밀집 마커·작은 클릭 범위·역 순서 인식; 6·8역 경계 확인 | S01, 후보 좌표·간선·검사 사유; 지도 와이어프레임 일부 독립 | L2 |
| DSG-G3-C / P01·P02 사업 진입 | BID, PROP / AC-02·03·05 / VP-01·02 | DD-02 재사용 | 공공입찰/자체 제안 2카드; 관할·고정값, 공고0건, 자격미달 | 자유 수정 가능 여부와 두 경로의 차이 혼동 | 공고/사업 분류, 관할·자격·사유 | L2 |
| DSG-G3-D / P04·D01 심사 결과 | BID, PROP / AC-03·05 / 두 VP | DD-03 재사용 | 시청 승인/거부, 정부 적합/보류/부적합, 설득 잔여, 낙찰/탈락, 재접수/차단 | 같은 ‘재신청’ 버튼의 잘못된 범용화; 기관별 근거 필요 | 기관/회차/슬롯/허용행동·이유코드 | L2 |
| DSG-G3-E / P05·D03 시공·안전 | CONST, OPEN, TIME / AC-06·07 | DD-05 재사용 | 계약·착공·공정중단·시범·안전·실패·수리·재시험·개통 구분 | 100% 공사를 영업 가능으로 오인, 중단 이유 누락 | 진행도/시간/결함/자금/허용행동 | L2 |
| DSG-G3-F / P06 운행·시민 피드백 | OPS, CITY / AC-07·08 / 두 VP | DD-06·08 재사용 | 실제 집계+열차 이동·정차+승하차 아이콘, 시험/비영업/정지/신규탑승제한/기존승객 이동중 | 아이콘 수를 실제 승객 수로 오인; 정지 상태 혼동 | 완료·이동중·미탑승, 영업상태·시각; 성능 협의 | L2 |
| DSG-G3-G / P07 재무·일일보 | COMP, FIN, TIME / AC-08~10 | DD-07·08 재사용 | 현재 C/R/F/K/A/B, 발생비용/지출/정산, 날짜별 고정 보고, 미지급·회복, 0/자료없음 | 예약 K를 지출처럼 중복 표시, 과거 수치를 현재 수치로 덮음 | 승인 장부 의미·기준일·지급사건, DEV 공급 계약 | L2 |
| DSG-G3-H / 다음 사업·D02 확인 | NEXT, BID, PROP / AC-09·10 / 두 VP | DD-03·04 재사용 | 실적 보고 이후 다음 사업 접근·차단 이유, 역 순서/제출 요약 | 계약 가능과 신규 탑승 가능 혼동 | 사업 자격·사용 가능 자금·허용행동 | L2 |
| DSG-G3-I / 공용 UI 시스템 | 전 화면 | DD-01~08 통합 신규 제작 | 패널·탭·목록·단계·정보/주의/오류/차단 배지·툴팁·범례·상태 아이콘·컨트롤 | 색상만으로 상태 전달·대비·텍스트 밀도 | 디자인팀 독립 IA 가능; 기술/폰트 확정은 공동 | L1→L2 |
| DSG-G3-J / Art & QA | OPS, MAP / AC-01·04·08 | 기존 파일 아님, 제안 규격 기반 신규 | 도시 타일·역·노선·열차·승하차 최소 에셋, 상태/시나리오 검수표 | 시각 밀도 및 애니메이션 비용; 성능 검증 미실시 | 실제 장면·뷰포트·성능 상한 확정 후 본제작 | L2 |

### 기능·화면 경계의 필수 UX 결정(디자인팀 제안)

1. **B>0은 신규 탑승 제한이지 신규 사업 계약 금지가 아님.** ‘신규 승차 제한’과 ‘사업 계약 가능 여부’를 별도 필드·경고로 표기한다. 일반 자금/자격 검사에 따른 계약 차단은 독립적으로 설명한다.
2. 기존 승객은 이동/완료 상태를 계속 표시한다. 기존 탑승객 도착 후 **추가 잔여 서비스 운영비 0**(CLOSE-01)을 화면이 임의 과금으로 표현하지 않는다.
3. T 분 경계에서 완료 운임 인식→미지급 자동 정산→신규 탑승 판정은 별도 사건이다. 수익 및 부채 흐름을 각각 표시하고, 지출 비용을 두 번 기재하지 않는다.
4. 현재 현금·예약과 *과거 일일보고 고정 스냅샷*은 탭/섹션을 분리하며 ‘오늘 0’과 ‘아직 보고 없음’을 같은 상태로 만들지 않는다.
5. 데이터 제공 실패/미수신/불가와 계산 결과 0은 구분한다. UI는 경제·관할·사업 자격 로직을 자체 계산해 만들지 않는다.

## 4. 잠정 픽셀/레이아웃·에셋 명세 (최종 확정 금지)

| 구분 | 파일명 또는 컴포넌트 | 제안 규격 | 상태별 표현 | 상태 |
|---|---|---|---|---|
| 화면 | S01-HUD | **1280×720 화면** 참조, 상단 56·좌측 224·우측 312·하단 80px | 정지·정상·오류 배지 | PROPOSED |
| UI 공용 | `art/ui/atlas_ui_chrome.png` | 256×256px (안) | 기본/선택/비활성/포커스 | NOT_CREATED |
| 도시 타일 | `art/world/atlas_city_base.png` | 16×16 소스 타일, 256×256 또는 512×256px 아틀라스(안) | 맵 기본/레이어 강조 | NOT_CREATED |
| 역 마커 | `art/world/station_marker.png` | 16×16 ×3상태 또는 48×16 시트 | 후보/선택/확정, 오류는 별도 오버레이 | NOT_CREATED |
| 노선 | `art/world/route_overlay.png` | 16×16 모듈 또는 선/패턴 렌더링 협의 | 계획/시공/운행 | NOT_CREATED |
| 수요 | `art/world/demand_pattern.png` | 5셀×16×16px 예시 | 등급별 패턴+범례+수치 | NOT_CREATED |
| 열차 | `art/vehicles/train_basic.png` | 64×24 소스 ×2~4프레임 | 이동/정차/시험; 방향·피벗 TBD | NOT_CREATED |
| 승하차 | `art/effects/boarding_feedback.png` | 16×16 소스 ×2~4프레임 | 탑승/하차/비영업 | NOT_CREATED |
| 상태·금융 | `art/ui/icons_status.png`, `art/ui/icons_finance.png` | 각각 80×16, 96×16px 예시 | 경고/차단/복구, 자금 6계열 | NOT_CREATED |

기존 1차 제안의 14개 그룹/24~36 소스 파일은 **예상값이며 확정 자산이 아니다.** `art/...`는 원본 제안명이다. 실제 저장 경로/엔진 에셋 반영은 Development와 협의하며 디자인팀이 개발 코드/프로젝트를 수정하지 않는다. 40×40px 클릭 영역, 한국어 16px 이상, 텍스트 명도 대비 4.5:1 목표를 시안 검증 가설로 유지하나 대상 PC·뷰포트/폰트·스케일은 Owner 선택 전 미확정이다.

## 5. 기획·개발 의미 데이터 계약 질문 (Gate 3-0 우선 인계)

| ID / 우선 | 요청 부서 | 질문 및 필요한 의미 필드 | 연결 화면/AC | 해소 증거 |
|---|---|---|---|---|
| UI-DC-01 / P0 | Planning 확인 + Development 공급 | 회사 관할, 행정 ID/부모/경계/역/동/노선 간선 및 불일치 사유의 동일 기준 정의 | S01/P03, AC-01·02·04 | 8동/12역/6·8역 입력 fixture 및 오류 상태 응답 |
| UI-DC-02 / P0 | Planning 확인 + Development 공급 | 계획 ID/개정 버전/기준일/예상 수요·비용·기간·단위/재계산 상태, 자료없음과 수치0 | P03/P06, AC-04·08 | 예상/실적·노선안 비교 화면 사례 |
| UI-DC-03 / P0 | Planning 확인 + Development 공급 | 심사 기관/회차/판정/사유코드/허용행동/차단 이유/설득 잔여·낙찰 우선순위 | P01/P02/P04, AC-03·05 | 성공/탈락/보류/불가의 행동 매트릭스 |
| UI-DC-04 / P0 | Development 공급 + Planning 의미 확인 | 기성/시범/안전/개통 단계, 남은 게임시간, 결함/자금 중단/복구행동/효력시각 | P05, AC-06·07 | 정상/중단/안전실패/재시험 상태 스냅샷 |
| UI-DC-05 / P0 | Development 공급 + Planning 의미 확인 | `C/Rᵢ/F/Kᵢ/A/B`의 기준 시점·단위·유효값, ‘비용 발생/현금 지급/미지급 정산’ 사건과 과거 보고 구분 | P07/다음 사업, AC-08~10 | 정상·미지급·완납·정산·자정·새 사업 가능 상태 fixture |
| UI-DC-06 / P0 | Development 공급 + Planning 의미 확인 | 신규 탑승 허용 여부/기존 이동중 인원/완료 인원/도착 시간/승차 가능 여부 및 계약 허용 여부를 별개 공급 | P06/P07, AC-08~10 | `B>0`, 동일 T 도착 운임→B 우선 정산→같은 T 신규 탑승 가능 여부 판정, 영업 외 00:09에는 B=0이어도 신규 탑승 불가 |
| UI-DC-07 / P1 | Development 공급 | 이벤트 시각 T/보고 마감일/데이터 생성 시점/조회 시점/프레임 연출 동기화 의미 | HUD/P06/P07, AC-08·10 | 23:59→00:09 및 큰 시간 분할/재조회 사례 |
| UI-DC-08 / P1 | Development와 공동 | 표시할 열차/승하차 동시 상한·정지/시험 연출 기준 및 기기/뷰포트 성능 예산 | S01/P06, AC-07·08 | 측정 장면·FPS 목표 대안과 Owner 선택 |

이 필드는 **UI가 필요로 하는 의미 계약**이며 엔진 클래스/API/DB 스키마 설계 지시가 아니다. L2 교차 검토 대상으로 정리한다.

## 6. 재사용 우선·작업 순서·병렬화

1. **디자인 독립(L1):** 정보 구조, DD-01~08 재사용 패턴 통일, 공통 상태 배지/문구 규칙, 텍스트 중심 저충실도 화면 흐름. 단 실제 고충실도 시안·이미지 제작은 정식 티켓 권한 확인 후.
2. **기획/개발 병렬(L2):** UI-DC-01~07 의미 계약 검토. 지도 경계/관할·OD/심사·회계 사건은 각 부서가 소유한 진실 공급원을 기준으로 고정.
3. **기기·규격 공동(L2, 필요시 L3):** 1280×720·16px 원본 타일·클릭 목표는 시안만. 실제 뷰포트/스케일/성능·외부 사용성 합격선 변경은 HQ 통합과 Owner 최종 선택.
4. **상세 제작은 이후:** 승인된 Stage/DSG 실행 티켓·의미 데이터 공급·표현 규격을 확보한 순서대로 목업·에셋 제작·사용성 검수를 실시한다. 기획팀 전체 결과 완료를 디자인 분석의 선행조건으로 요구하지 않는다.

기존 24~40 *인간 디자이너 8시간/일* 추정은 과거 가정일 뿐 AI 작업의 납기나 실제 작업일 수로 환산하지 않는다. HQ는 완료 증거 중심 Stage/Vertical Slice 단위로 계획해야 한다.

## 7. HQ 결정 요청·위험

| 우선 | 위험·차단 | 제안 처리 | Owner 결정 여부 |
|---|---|---|---|
| P0 | 제출 완료 후 실제 디자인 제작 승인 미확인 | DSG-002 분석용 Markdown 티켓·결과만 PR로 검수 요청, 후속 제작은 별도 실행 티켓 | main 병합·에셋 제작은 Owner 별도 승인 |
| P0 | UI-DC-05·06 데이터 계약 누락 시 재무·운행 오인 | 개발이 기준시각·원장 필드·행동 이유를 공급, 기획이 규칙 의미 대조 | 계약이 승인 규칙을 바꿀 때만 |
| P1 | 지도 12역의 조작 가능/가독성 미측정 | 후보·노선 마커 및 정렬 목록의 저충실도 프로토타입, 6/8역 경계 검수 | 규모 변경시 |
| P1 | 실제 뷰포트·폰트·FPS·동시 연출 상한 미확정 | Design/Development 공동 2~3안→HQ→Owner | 예, 제품 성능 목표/예산 |
| P1 | 외부 사용성 표본·합격선·예산 미확정 | VP-01/02 관찰 질문/측정안 수립→HQ 통합 | 예, 비용/합격선 선택 |

## 8. 검증 이력 및 완료/미완료

| 항목 | 상태 | 근거 |
|---|---|---|
| GitHub `main` 문서 및 트리 조사 | DONE | 위 SHA의 Gate 2 승인/PM-008/PM-008-DSG/DSG-001/README 및 파일 트리 |
| 기존 디자인의 실제 이미지 파일 조사 | DONE(해당 원격 트리 기준) | 관련 PNG/목업 부재; 미존재를 사용성 실패로 단정하지 않음 |
| 공식 디자인 화면·에셋 제작 | NOT_STARTED | 본 요청은 분석 및 작업 분해 |
| 실제 UI 시안/픽셀 아트 제작·사용성/가독성 실측 | NOT_RUN | 제작 전 |
| Godot 플레이/자동 테스트/빌드/성능 | NOT_RUN | 개발 소관·실행 증거 없음 |
| Gate 3-0 정보 구조/작업 분해 | DRAFT_COMPLETE | 본 보고서 / HQ 검수 필요 |
| GitHub Issue | CREATED | [#24](https://github.com/wisberry2022/MetroManager/issues/24) |
| 정식 Markdown 티켓 원격 게시·PR | REVIEW | Owner의 2026-11-01 후속 PR 생성 요청으로 작업 브랜치·커밋·PR 제출. 실제 PR/CI 결과는 원격 메타데이터로 확인 |
| Gate 2 Owner 승인 | CONFIRMED | Gate 2 최종 승인 기록; 화면 최종 승인이 아님 |

**종합 판정: Gate 3-0 디자인 분석 초안 제출 가능 / 제작 단계는 별도 승인·입력 계약 필요.** HQ는 Stage 통합 시 위 L2 데이터 계약과 기기 규격을 교차 의존성으로 등록해 주기 바란다.

**2026-11-01 후속:** [DSG-002 디자인팀 자체 결정 명세](DSG-002_UI_PRESENTATION_DECISIONS.md)에 PLN-R02·R05 자체 결정 및 R03·R04 UI 소비 기준을 분리하여 기록한다. 해당 문서가 본 보고서의 기존 잠정 표현보다 최신이다. UI-DC-01~07은 결정서 v0.2 §9의 고정 복합 revision으로 DESIGN_SEMANTIC_ACCEPTED이며 실제 공급 구현·공동 인수는 PENDING이다.

## 9. 원격 제출 보충 (2026-11-01)

- **Owner 후속 승인:** “디자이너 에이전트 PR 생성해주시기 바랍니다.” 기존 DSG-002 Gate 3-0 분석 결과의 원격 제출에 한정한다.
- **브랜치:** `codex/DSG-002-gate3-design-analysis` (기준 main `ca597ec541647aa2e9701ec93972e8763eae066d`).
- **등록 파일:** `docs/design/tasks/DSG-002_GATE3_ANALYSIS.md`, `docs/design/tasks/DSG-002_RESULT.md`.
- **추적:** [Issue #24](https://github.com/wisberry2022/MetroManager/issues/24). 실제 PR 번호·커밋 SHA·CI 판정은 GitHub PR에서 조회한다.
- **검증:** Markdown/링크/소관 경계 정적 점검만 수행. GitHub API 경로이므로 로컬 훅 및 `tools/policy.py doctor/check`는 **NOT_RUN**. Godot 로드·실제 UX 테스트·게임 플레이·빌드·성능 측정은 **NOT_RUN**.
- **판정:** 분석 문서 **REVIEW**, 제작/실행 **NOT_STARTED**. 최종 DONE·main 병합·릴리스 권한은 Owner에게 있다.


## 10. 디자인 자체 결정·기획 피드백 반영 이력 (2026-11-01, v0.3 당시 기록)

- Owner 지시: 기획팀 [Issue #24 검토 댓글](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6554796711)에 대한 자체 결정은 원격 문서로 관리하고 PR 제출. DEV 답변이 필요한 항목은 보류.
- 디자인팀 결정 근거: [Issue #24 디자인 회신](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6554855720); Git 기준 `4bdf65f9b832ab8235f818441bddae6423951585`, 원본 본 보고서 Blob `121fa8edc970ceb31c4758f0669ca850aedb95f8`.
- 신규 문서: [DSG-002_UI_PRESENTATION_DECISIONS.md](DSG-002_UI_PRESENTATION_DECISIONS.md). **R02(동일 T 정산 이후 탑승 판정), R05(시각 경계 vs 행정 관할 분리)** 디자인 표현 결정; R03/R04는 UI 소비 원칙 결정 및 개발 공급 계약 협의 대기.
- 수정: UI-DC-06 표의 “다음 T 탑승 재개”를 **동일 T의 정산 후 조건 판정**으로 정정. 기존 Gate 2 SEM-01~03/CLOSE-01 규칙 자체는 변경하지 않음.
- 진행 수준: **DESIGN_DECIDED / DEV_SUPPLY_PENDING / MOCKUP_NOT_RUN**. P05/P06/P07/다음 사업 통합 티켓 전에는 같은 계약 revision의 DEV 응답 및 fixture 대조 필요. 성능·사용성·Godot 실행 **NOT_RUN**.
- 이번 후속 PR은 `docs/design/` 내부의 본 문서와 신규 결정 문서만 포함. 실제 에셋·게임 코드 수정, main 병합은 수행하지 않음.

## 11. 개발 회신 검토·동일 revision 수용 보완 (2026-11-01, v0.4)

- Owner의 현 요청 범위: DSG-002 디자인팀으로 Issue #24 최신 DEV 코멘트·PR #30·DEV-006 동일 revision 대조, 디자인 소관 문서 보완을 기존 브랜치에 단일 부모 커밋으로 제출하고 원격 CI 확인. force push·main merge 금지. 이번 제출·보고까지의 권한이며 타 부서 문서/구현/후속 제작을 포함하지 않는다.
- 변경 파일: 본 결과서와 [UI 표현 결정서 v0.2 §9](DSG-002_UI_PRESENTATION_DECISIONS.md#9-dev-회신-대조디자인-수용-기록-2026-11-01-v02). §10의 DEV 대기는 이전 제출 이력이며 현재 판정은 본 절을 따른다.
- 공급 고정 기준: main `4bdf65f9b832ab8235f818441bddae6423951585` / DEV UI 계약 v0.1 Blob `a6410b13914812d92369a7ac1286b90172935dfd` + [#25 `DEV006-UI-v0.2-decision-1`](https://github.com/wisberry2022/MetroManager/issues/25#issuecomment-6554863216) + [#24 DEV 회신](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6554936447). 저장소 v0.1 단독 수용이 아니며 DEV 파일은 수정하지 않는다.
- 디자인 대조 시작 PR head: `4c20924e2fec28b00c4f7ded16d408f80faa573d`, 결과 v0.3 Blob `2e4d7f99f922f2e488665973485096ed37b1725a`, 결정서 v0.1 Blob `76a703895216f0f4bd5b65cdf40b47cd53648bd1`. 이번 제출 head/파일 행·CI의 정확한 증거는 [PR #30](https://github.com/wisberry2022/MetroManager/pull/30)에서 공유한다.

| 항목 / UI-DC·AC | 이번 Design 판정·근거 | 잔여 |
|---|---|---|
| R02 / 06, AC-08·10 | DESIGN_SEMANTIC_ACCEPTED. FX-R02-A/B를 같은T 정산·영업중 허용/00:09 제한에 연결 | 실제 공급·화면/게임 실행 NOT_RUN |
| R03 / 01~07, AC-01~10 | DESIGN_SEMANTIC_ACCEPTED. 결정서 §9.2 전행 공급→단위/시점→화면→상태/사유/행동→정상·실패 fixture 정적 대조 | P05/P06/P07/다음사업 통합 티켓의 입력으로 수용 기록 사용, 구현 fixture와 인수 별도 |
| R04 / 02·06·07, AC-04·08·10 | DESIGN_SEMANTIC_ACCEPTED. 현재 봉투 재사용/예측 입력·결과 revision·생성시각/cohort ETA·실제완료/UI 로컬시각 분리 | 구체 타입·실공급 fixture는 DEV 후속, 실행 검증 NOT_RUN |
| R01 연계 / 05·07, AC-06·08·09·10 | FX-R01-A의 계약 당시 부족1000 거부와 후순위 운임 후 현재80000 분리. 명령 당시 결과/현재 버튼·STATE_CHANGED·중복 결과 UX 결정 | Planning 소관 승인 의미 확인을 대신 완료 처리하지 않음 |
| R05 / 01, AC-01·02·04 | 표시도형/관할 판정 분리의 공급 일치. 추상지도·목록 동일ID 유지 | 목업·클릭/밀집·동등조작 NOT_RUN, 상세 에셋 확정 전 검증 |
| UI-DC-08 | 이번 의미 수용 제외, 제품 목표 선택은 유지 | Design/DEV 대안→HQ→Owner; 폰트/뷰포트/FPS/연출·사용성 기준 미결 |

- 검증 결과: 문서·댓글·정상/실패 정적 fixture의 의미 일치, 불일치 행/추가 의미 질문 없음. 명세 변경 필요 없음; C v0.6 / D v0.9 / DATA v1.3 / SEM-01~03·CLOSE-01 유지. 새로운 Planning 전면 검토나 HQ L3 요청 없음.
- 구분: DEV_CONFIRMED + DESIGN_SEMANTIC_ACCEPTED는 정적 공급·소비 수용 증거다. 최종 공동 구현/통합 인수 ACCEPTED, 실제 AC/VP PASS, Owner 승인/DONE은 선언하지 않는다. DEV 저장소 v0.1 문구 동기화는 소관 후속이며 새 정책 결정의 선행조건이 아니다.
- 제출/검증: 디자인 경로2개만, 기존 브랜치 head를 단일 부모로 추가, base tree 보존·expected_sha 확인·force=false. 원격 CI는 이번 head 기준 확인. API 경로이므로 로컬 훅·policy.py doctor/check NOT_RUN. Godot 자동게임테스트/로드/플레이/Windows 빌드/성능/사용성 각각 NOT_RUN. 실제 목업/PNG NOT_CREATED. main merge·릴리스 미수행.

## 12. Gate 3-1 최초 Stage 디자인 계획·개발 확인 및 Owner 결정 (2026-11-01, v0.5)

- 원격 기준 `main` `177c2e4af3e15e15b15888c40eecb0f3ea983213`. HQ [PM-010 디자인 체크리스트](../../hq/requests/PM-010_DESIGN_CHECKLIST.md) / [Gate 3-1 요청](../../hq/PM-010_GATE3_1_REQUESTS.md).
- [디자인팀 최초 회신](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6555464641), [개발팀 상세 확인](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6555812161), [Design의 #25 수용](https://github.com/wisberry2022/MetroManager/issues/25#issuecomment-6555800425), [Owner Stage 최소 UI/종료기준 동의](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6555874135).
- Development [Gate 3-1 분석 문서](../../engineering/gate3/DEV-006_GATE3_1_ANALYSIS.md), [UI 공급 계약 v0.2.1](../../engineering/gate3/DEV-006_UI_DATA_CONTRACT.md), [PR #33](https://github.com/wisberry2022/MetroManager/pull/33) 병합 내용을 정적 대조. 현재 추가 UI 의미/규칙 질문이나 부서 충돌 없음.
- 후속 Stage 문서: [DSG-002_GATE3_1_DESIGN_STAGE_PLAN.md](DSG-002_GATE3_1_DESIGN_STAGE_PLAN.md). 첫 Stage의 **최소 실제 조작 UI + 자동 검증·UI 조작 증거**를 포함하고 범위 밖 전체 게임 화면/에셋 제작을 제외한다.
- **최종 분석 판정:** `DESIGN_STAGE_PLAN_READY / DEV_STAGE_UI_BOUNDARY_CONFIRMED / OWNER_MINIMAL_UI_SCOPE_AGREED`. 정적 계획 인수 입력이며 `GAME_IMPLEMENTED`/ `UX_PASS`/ `AC_VP_PASS` 아님.
- **권한 경계:** Owner의 이 턴 PR 작성 요청에 따른 디자인 문서 브랜치·Commit/Push/PR 제출. 첫 Stage 실제 코드/씬/아트 제작, W02 L3 실행·main Merge·릴리스는 별도 Owner 승인이 필요.
- **검증:** 문서·Issue·승인 원문 정적 대조 DONE. 해당 Stage의 Godot GUI 진입·게임/자동 규칙·조작·Windows 빌드·성능·외부 사용성 **NOT_RUN**, 이미지/에셋 **NOT_CREATED**. 새로운 게임 규칙 변경 없음.
