# [PLN-001] Gate 2 OWNER_APPROVED — HQ·Gate 3 최종 인수인계서

- 문서: v1.0 / 2026-11-01 / Planning → Owner·HQ·Development·Design
- Gate 2 상태: **OWNER_APPROVED (최종 승인 완료)**
- APP-01: **OWNER_DECIDED** (조건부 이월 관리 절차 채택)
- 구현 상태: **NOT_STARTED / NOT_RUN** (이 보고는 구현 착수 지시가 아님)
- 승인 이전 저장소 기준: `f76db01ae7b2a094d587e288681b12ebc324bc04`
- 3차 검토 기준: `dc06e48b1dbc7745dcb0a29e424cd0416767ab38`
- 승인 원문: [Gate 2 최종 승인 기록](../PLN-001_GATE2_FINAL_APPROVAL.md) §1
- 기준 문서: C v0.5-draft / D v0.8-draft / DATA v1.2-draft에서 **차기 승인 개정 C v0.6 / D v0.9 / DATA v1.3**로 정합화 예정; 게시 전 버전은 제안, 현재 저장소 파일에는 아직 미반영

## 1. Gate 2 Owner 승격 판단

Owner가 2026-11-01 “Gate2 최종 승인을 허가합니다”라고 명시. 따라서 Gate 2 최종 상태는 더 이상 `OWNER_PENDING`/`BLOCKED`가 아니라 **`OWNER_APPROVED`**이다. 다만 이 승격은 기획 정책·범위·검수 기준을 승인한 것으로 개발·디자인 실행 검증 PASS와 다르다. Gate 3 업무 착수 및 Git 변경은 부서 규정에 따라 별도 지시한다.

## 2. 승인된 게임 명세 및 검수 범위

| 항목 | 변경 여부 / 승인 내용 |
|---|---|
| Gate 1 A/B v0.3 | 변경 없음. QD-01~10·P1~P6 장기 콘셉트 보존 |
| MVP 기능 | **8개 영역 / MUST 11개** 변경 없음 |
| 고객 경험·사업 경로 | 공공입찰 및 자체 제안 2개 모두 유지 |
| 행정 | 도→시→구→동, 광역시·특별시 예외 규칙 유지. MVP 4구/8동 |
| 콘텐츠 | 후보역12·노선당 6~8역, 입찰2·자체 제안2, 동시 시공·운영 각1 |
| 금액·밸런스 | **PAR-01~05 Owner 기존 승인 수치 불변** |
| SEM-01~03 | Owner 결정 완료; 완료 운임 우선 미지급 정산, 자정 고정 분 경계 등 |
| CLOSE-01 | 기존 승객 잔여 도착에 별도 추가 운영비 0; 정상 서비스 구간 발생분은 보존 |
| CLOSE-02 | 최신 본문만 현행 규칙으로, 과거 문구는 이력 보존 |
| CLOSE-03 / APP-01 | 이월 과제별 책임·선행조건·검수 증거 추적 및 Owner Gate 최종 승인 절차 채택 |
| 기본 검수 | **AC-01~10**, **VP-01 및 VP-02 독립 실행**은 MVP 인수 시 실제 로그/게임 플레이 필요 |
| Idea Library | 001 자동 정산 방침, 002 플레이어 취소, 003 6개월 연체 제재 모두 **MVP 제외** |

## 3. PLN-G2-CLOSE-01~03 완료 대조

| ID | 최종 Owner 선택 | 증거/변경 대상 | 상태 |
|---|---|---|---|
| CLOSE-01 | A — 기존 서비스 구간 비용에 잔여 도착 포함, 추가 비용 없음 | C §5-5~6 / DATA §3·5·6 검산 / AC-08·10 | `OWNER_DECIDED` / 공식 문서 게시 대기 |
| CLOSE-02 | A — 현행/이력 분리, 이전 승인·회신 보존 | C/D/DATA 전체 서두·상태·체크리스트·이력 | `OWNER_DECIDED` / 공식 문서 게시 대기 |
| CLOSE-03 / APP-01 | A — Gate 3 조건부 이월 채택, Gate 2 별도 최종 승인 | D 인수인계 / HQ 책임·해소 시점 / Owner 최종 승인 기록 | `OWNER_DECIDED` / 공식 문서 게시 대기 |

## 4. Gate 3로 조건부 이월할 과제

아래 G3-XX는 **기획팀 임시 추적 ID**이고 HQ 공식 티켓 부여가 필요하다. 업무 면제가 아니며 후속 조건 충족 전 해당 산출물을 확정하지 않는다.

| ID / HQ 추적 | 책임·지원 | 완료 증거 | 차단 시점 / 추가 Owner 결정 여부 |
|---|---|---|---|
| G3-01 / DSG-HQ-01 | Development 공급, Design 표현, Planning 의미 확인 | C/R/F/K/A/B 및 B 정산·비용발생/지출·예상/실적·현재/과거 보고, 원인/허용 행동·자료없음/0의 동일 시점 의미 데이터 계약 | P05·P06·P07·다음 사업 **UI 통합 티켓 확정 전** / 정책 변경시 Owner |
| G3-02 / DSG-HQ-03 | Design 주도, Planning 경계·좌표 입력, Development 공급 | 4구·8동·후보12·노선6/8역의 겹침, 선택/순서/중복/단절/관할 외 사례 목업·가독성 검수 | **지도·역 상세 에셋 명세 확정 전** / 규모 변경시 Owner |
| G3-03 / DSG-HQ-04 | Development+Design 제안→HQ 통합→Owner 선택 | 대상 PC, 기준 뷰포트·배율·글꼴, FPS/표시 상한·열차/승하차 측정 장면 및 승인 기록 | **성능·에셋 규격에 종속된 작업 확정 전** / 제품 성능 목표 Owner 선택 필요 |
| G3-04 / H-03 및 BLOCK-07 | Dev/Design 작업 분해·가용시간→HQ 계획 | 기능별 WBS, 인력·일정 가정, 24~40 디자인 작업일 초기 추정 재검증, 의존성·검수/재작업 포함 | **Gate 3 일정 승인 전** / 예산·인력 변화 시 Owner |
| G3-05 / BLOCK-06 | Development 주도, Design UI·HQ 인수 | Godot 실제 게임 실행, 일괄/분할·자정·배속 로그 동일, AC-01~10 증거, 두 VP 독립 재현 시드/명령·거래 원장 | **MVP 구현 기능 인수 전** / 실행 이전 완료 요구 아님 |
| G3-06 / DSG-HQ-05 | Design+HQ 대안→Owner 선택 | 외부 관찰 프로토콜, 표본/합격선/비용 제안, VP별 인지·성과 판정 | **사용성 테스트 집행·예산 집행 전** / 테스트 기준 Owner 선택 필요 |

### 기능성 검증에서 특별 주의할 경계

- **비용 모델:** 서비스 구간 `100/게임분`이 잔여 도착을 포함. 23:59 탑승8 → 익일 00:09 완료8/운임800, 추가 잔여 운영비0, B500이면 즉시500 정산·자유현금 순증300(다른 제약 없는 경우).
- **미지급:** B>0은 신규 승객 탑승 제한 사유이지 신규 **사업 계약** 제한 사유가 아님. 계약에는 기존 업무시간·자격·예약금 K 및 자유현금 검사만 적용. 미지급금 자동 정산 후 가용액을 실제 효력 시각 기준으로 재계산. 후순위 도착 운임의 소급 사용 금지.
- **보호금:** 사업별 정부 R과 자기예약 K는 보호, 공정 중단·미지급 발생만으로 자동 해제 금지.
- **회복 불가능 상황:** 자유현금/미지급 회복 경로가 없는 경우 새 대출·보조금·직접 취소 등을 몰래 추가하지 않고, 실패 원인과 기존 시나리오 재시작 등 승인된 행동을 정직하게 안내.

## 5. HQ 관리 판정 — 그대로 이관

| BLOCK ID | PM-006 최종 판정 | 이월/종결 |
|---|---|---|
| BLOCK-G2-01 | RESOLVED | 종결 |
| BLOCK-G2-02 | PARTIAL | G3-02 |
| BLOCK-G2-03 | RESOLVED | 종결; 실행 검증은 G3-05 |
| BLOCK-G2-04 | CONDITIONALLY_RESOLVED | CLOSE-01 Owner 해석 확인 완료, Dev 구현 검산 G3-01/05 |
| BLOCK-G2-05 | PARTIAL | G3-03 |
| BLOCK-G2-06 | PARTIAL | G3-05 |
| BLOCK-G2-07 | PARTIAL | G3-04/06 |

부서 최신 검토: Development `CONDITIONAL`(RESOLVED5/PARTIAL3), Design `CONDITIONAL`(RESOLVED1/PARTIAL7), HQ `CONDITIONAL`(조건부 승인). 그 검토 당시 Gate 2가 Owner 결재 대기였던 **과거 상태만** 이번 Owner 최종 승인으로 갱신하며, 기술 검토 원본의 항목별 상태를 소급 수정하지 않는다.

## 6. 업데이트 파일·버전 계획 및 승인 기록

| 파일 | 이전 원격 버전 | 권장 차기 승인본 | 처리 |
|---|---|---|---|
| `docs/planning/PLN-001-C.md` | v0.5-draft | v0.6 / OWNER_APPROVED | 현행/과거 분리, CLOSE-01 경계 명세, Gate 2 체크리스트 업데이트 |
| `docs/planning/PLN-001-D.md` | v0.8-draft | v0.9 / OWNER_APPROVED | 최신 부서·HQ 판정, APP-01·Gate 3 이월·최종 서명 기록 |
| `docs/planning/PLN-001_GATE2_DATA_v1_DRAFT.md` | v1.2-draft | v1.3 / OWNER_APPROVED | CLOSE-01 비용·도착 예시, SEM-03의 확정 상태, PAR 수치 불변. 파일명의 DRAFT는 기존 참조 안정성 때문에 유지; 차기 명칭 변경은 별도 조정 |
| `docs/planning/sources/PLN-001_GATE2_OWNER_DECISIONS.md` | 2026-11-01 SEM 결정 기록 | Owner Gate 2 최종 승인 추가 | Owner 원문 및 CLOSE/APP 이력 누적 |
| `docs/planning/PLN-001_GATE2_FINAL_APPROVAL.md` | 미존재 | v1.0 승인 기록 신규 | Owner 원문·범위·승인 제한 |
| `docs/planning/tasks/PLN-001_GATE2_FINAL_HANDOFF.md` | 미존재 | v1.0 최종 인수인계 신규 | 조건부 이월·책임·검증·Gate 3 인계 |

**주의:** 위 새 승인 기록·인수인계는 로컬에서 작성한 것으로 Git 게시 전. 기존 원격 C/D/DATA가 `OWNER_APPROVED`로 갱신되었다고 주장하지 않는다.

## 7. 완료 및 재심사

- [x] Owner 최종 Gate 2 승격 결정 명시 수령
- [x] 최신 CLOSE-01~03 및 APP-01 정책·승인 경계 확정
- [x] HQ 관리 블로커 상태 및 3차 부서 검토 이력 보존
- [x] Gate 3 이월 과제의 책임/차단 이벤트/검증 증거 제시
- [x] C/D/DATA/Owner 기록의 PR 게시 요청 수행 (원격 CI 결과 별도 확인, main 병합 제외)
- [ ] HQ의 Gate 3 티켓·계획·예산 조정 (HQ 담당)

기획팀의 추가 HQ Gate 2 재심사는 Owner가 요청하지 않는 한 필수 선행 조건이 아니다. 승인받지 않은 신규 기능 추가·실제 게임 구현·릴리스·main Merge는 금지한다.
