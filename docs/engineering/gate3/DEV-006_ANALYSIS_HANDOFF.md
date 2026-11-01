# DEV-006 — Gate 3-0 분석·개발 결정 인수인계 v1.0

- 작성: Development / LAPTOP / 2026-11-01 / REVIEW
- 작업: DEV-006 / [Issue #25](https://github.com/wisberry2022/MetroManager/issues/25)
- 제출 브랜치: `codex/DEV-006-gate3-analysis-consolidation` / 제출 base main: `8ef97626ba96844648a6de2e2cb9654e6816ce40` (분석 고정 기준 4bdf65f).
- 영향: L2 문서·공급 의미 정합화. 게임 정책 변경 없음. 실제 코드/화면/에셋 구현·인수 완료가 아니다.
- 입력: Gate 2 승인 C v0.6 / D v0.9 / DATA v1.3 / 최종 승인 v1.0. 8개 MVP 영역·11 MUST·AC-01~10·독립 VP-01/02 유지.

## 1. 현재 결론과 추가 확인 여부

개발의 작업 분해·T 사건/자금·UI 공급 의미 판단과 디자인 소비표의 정적 대조를 마쳤다. **이번 분석 산출물 작성에 앞서 새로 타 부서에 질문해야 할 미해결 공급 의미는 발견하지 않았다.** Design은 고정된 개발 보강 revision을 수용했다. 이미 정해진 SEM/CLOSE·관할 규칙을 다시 선택하거나 전체 부서 검토를 반복할 사안은 없다.

Design 수용은 최초 확인 당시 PR #30의 미병합 head에 있었으나, 제출 직전 main 8ef97626ba96844648a6de2e2cb9654e6816ce40에 병합됨을 확인했다. Planning의 별도 후속 회신은 당시 조회 시 없었다. 현재는 [Planning 의미 재확인 #26](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6555112937)로 의미 충돌 해소를 확인했다. 과거 조회 이력과 실제 구현 인수는 구분한다. 실제 타입/구현·fixture/화면 조작·지도 목업·제품 목표/사용성은 아래 선행 시점의 후속 의무다. 이월 항목이 있다는 이유로 현재 분석 제출 전체를 BLOCKED로 바꾸지 않는다.

## 2. 근거와 수용 수준

| 근거 | 고정 참조·확인 내용 |
| --- | --- |
| 최초 DEV 분석 | [PR #27](https://github.com/wisberry2022/MetroManager/pull/27), main 반영 4aaf1df5a7aab5b12dd0beb22c0456e028104c69. W01~W09·두 Slice·UI v0.1 |
| Planning 정합성 검토 | [#26 PLN-R01~05](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6554791565), [#25 개발 요청](https://github.com/wisberry2022/MetroManager/issues/25#issuecomment-6554802064). 작업 분해는 분석 입력으로 수용 가능, 문구/공급 의미 보강 요청 |
| 개발 결정 | [#25](https://github.com/wisberry2022/MetroManager/issues/25#issuecomment-6554863216), DEV006-UI-v0.2-decision-1. R01/03/04 결정·fixture, R02/05 지원 |
| Design 자체 결정 | [#24](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6554855720). 동일 T 표현·추상지도·상태 소비 결정 |
| 개발 공급 확인 | [#24](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6554936447). UI-DC-01~07 공급, 추가 필드·집계 도착·명령 revision·수신/표시시각 명료화 |
| Design 정적 의미 수용 | [PR #30 head 47fe5923c8ff730dbbf6c03daace304e96a856bc의 결정서 v0.2 §9](https://github.com/wisberry2022/MetroManager/blob/47fe5923c8ff730dbbf6c03daace304e96a856bc/docs/design/tasks/DSG-002_UI_PRESENTATION_DECISIONS.md), 결과 v0.4 §11. UI-DC-01~07 DESIGN_SEMANTIC_ACCEPTED, 불일치/추가 의미 질문 없음. 최초 확인 시 PR OPEN/REVIEW, 제출 직전 #30 병합·main 8ef9762 확인 |

고정 복합 revision은 기존 UI v0.1 Blob a6410b13914812d92369a7ac1286b90172935dfd + 두 개발 댓글이다. 이번 [UI 계약 v0.2](DEV-006_UI_DATA_CONTRACT.md)는 그 내용을 파일로 동기화한다. 이후 의미가 달라지면 같은 수용 기록을 자동 재사용하지 않고 변경 행만 대조한다. DESIGN_SEMANTIC_ACCEPTED·DEV_CONFIRMED는 공동 구현 인수 ACCEPTED·게임 PASS·Owner 최종 승인/DONE과 다르다.

## 3. 개발에서 결정한 사항

| 항목 | 결정·반영 | 연결·수용 상태 |
| --- | --- | --- |
| PLN-R01 | 계약 effective_at의 계약 단계 자격/자금·B 우선의무·K 검사와 틱 완료 뒤 현재 향후여력 표시 분리. 같은 T 후순위 운임 선사용·과거거부 소급성공 금지. A 정의 유지 | AC-06/08/09/10. UI v0.2 §5, 계획 §7 문구 정정. DEV 결정·Design 표시 대조 완료, 현재 Planning 의미 재확인 완료(#26); 당시 미확인 이력 보존 |
| PLN-R02 | 같은 T 도착운임→B정산→같은 T 탑승판정. B0만으로 재개 불가, 00:09 비영업 제한 | AC-08/10. Design 자체 표현 결정과 DEV 공급 일치, 실제 실행 NOT_RUN |
| PLN-R03 | UI-DC-01~07의 의미·단위/시각·화면·상태/사유·행동·fixture를 같은 revision으로 연결 | AC-01~10. UI v0.2 §7, Design 정적 의미 수용. UI-DC-08은 별도 목표 과제로 제외 |
| PLN-R04 | 입력revision·예측상태/유효성·생성시각 추가, 이동중을 cohort count로 집계. 현재snapshot 생성게임분/event T/과거보고/UI 로컬시각 분리 | AC-04/08/10. UI v0.2 §6. 개별 시민 시뮬레이션·로딩용 지연 도입 없음 |
| 명령/낡은 화면 | 요청·대기/효력당시결과/현재버튼 구분. 의미가 바뀐 대상은 STATE_CHANGED, 봉투revision만 변경됐다고 일괄거부하지 않음. 동일ID 중복경제효과 금지 | UI v0.2 §1/5. Design 결과카드·갱신/재확인 소비와 일치 |
| PLN-R05 | 관할은 승인 안정ID·행정부모·역소속·간선이 원본. 표시도형으로 재판정하지 않음. Planning의 신규 경계폴리곤 제공을 선행조건으로 요구하지 않음 | AC-01/02/04. Design 추상4×3 표현시안과 연결 가능. 도형 형태/실제 목업 검증은 Design 후속 |

문서에서는 UI 계약 v0.2를 현재 공급 의미로 사용한다. 구체 Godot 클래스/enum·직렬화·실제 fixture 러너는 필요한 실행 티켓에서 확정한다. 보호 R/K·미지급 B·기존 승객 추가잔여비0·MVP 제외 기능은 유지한다.

## 4. 실행 계획의 다음 입력

[개발 분해안 v0.2](DEV-006_DEVELOPMENT_PLAN.md)의 W01~W09, 11 MUST/10 AC/2 VP 추적과 회귀 경계는 변경하지 않았다. 최초 VS-01은 입찰 B01→표준공사→시범/안전→실제영업·보고→다음사업, VS-02는 회사 제안 독립 경로다. 이는 구현 순서 제안이며 승인된 두 VP 중 하나를 생략하지 않는다.

| 후속 항목 | 주 담당 / 차단 시점 | 완료 증거 |
| --- | --- | --- |
| 첫 Stage·실행 티켓 | HQ 통합→Owner, 실제 코드 착수 전 | WBS·담당·범위·AC·독립 검증·영향등급·commit/push/PR 동작별 권한 |
| 구체 공급·명령·fixture/화면 연결 | DEV+Design, P05/P06/P07/다음사업 통합 티켓 확정 전 | 이 고정 revision·정적 수용 기록을 입력으로 실제 값/행동·원장·화면 검증 계획 연결. 새 의미 차이가 있을 때만 해당 행 재협의 |
| 지도 목업·목록 동등 조작 | Design 주도·DEV 판정 지원, 상세 지도/역 에셋 확정 전 | 후보12/6·8역·중복/단절/관할외·밀집/클릭/되돌리기 검증 |
| UI-DC-08 기기/성능·표현 예산 | DEV+Design 대안→HQ→Owner, 규격종속 제작/성능합격 전 | PC·뷰포트·폰트/배율·FPS·표시상한·측정장면 결정. 1280×720/40px은 미승인 시안 |
| 외부 사용성 | Design/HQ→Owner, 모집·예산 집행 전 | 표본·관찰/합격 기준·예산 승인 |
| 구현 인수 | DEV/Design·HQ, MVP 인수 전 | 두 VP 독립 실플레이·시드/명령/원장/보고 재현, AC/회귀·Godot/빌드·대상기기 성능 증거 |

과거 “Design 추가 공급 의미 대기”는 보강/수용 원문으로 해소된 정적 분석 이력이다. 이를 실제 구현/목업 완료로 바꾸지 않는다. 기존 Stage/지원환경 결정까지 새 협업 질문이 모두 해결된 것으로 확대하지 않는다.

## 5. 검증·제출·권한

실제 검사 결과는 [DEV-006 결과의 분석 통합 절](../tasks/DEV-006_RESULT.md)에 기록한다. 경계 fixture의 정적 산술·문서 구조/링크·승인명세 보존·정책 검사를 구분한다. 이전 프로젝트의 headless 에디터 로드 PASS와 현재 게임 자동/플레이·빌드 NOT_RUN을 혼동하지 않는다.

이번 Owner는 “더 이상 추가로 타 부서에 확인 요청할 것이 없다면 현재까지의 분석 내용을 별도 산출물로 만들어 PR 생성해주세요”라고 지시했다. 추가 정책 질문이 필요하지 않음을 확인했고 이 분석/계약·원문 보강을 검수 가능한 개발 산출물로 제출한다. 허용 범위는 DEV-006/본 브랜치/docs/engineering/의 문서 commit·작업 브랜치 공유·PR 생성/CI·Issue 연결까지이며 이번 제출에 한정된다. main 병합·게임 구현·타 부서 변경·강제 push·릴리스는 제외한다.

게임 기획 명세 변경 필요 없음. 문서 게시/PR 병합만으로 최종 DONE/공동 구현 ACCEPTED 또는 후속 실행 티켓 승인을 생성하지 않는다.

## 6. Gate 3-1 후속 인계

[Gate 3-1 개발 분석 v1.0](DEV-006_GATE3_1_ANALYSIS.md)가 현재 Stage 검토 연결점이다. 디자인의 #25 DSG_SCOPE_ACCEPTED와 #24 개발 확인을 반영했으며 추가 부서/Owner 질문 없이 분석 제출 가능하다. 실행 티켓/목업·실제 공급·제품 목표는 해당 시점의 후속 의무로 유지한다. UI 계약 v0.2.1은 의미 변경 없는 L1 표/상태 정정이다.
