# [PLN-001-D] HQ 제출용 콘셉트/MVP 통합 인수인계서
## 현재 승인·제출 범위 (2026-10-31)
- OWNER가 DATA-v1.0-draft의 제안 수치를 그대로 사용하도록 승인했다. 수치값은 변경하지 않았다.
- 수치 승인과 부서 타당성 검토, 추가 연결 세칙(SEM-01~03), 전체 승인방식(APP-01), Gate 2 최종 승인을 구분한다. 수치 외 세칙의 별도 승인을 확대 추정하지 않으며 이번 PR에서 함께 검토한다.
- 현재 문서는 DRAFT/REVIEW. HQ·개발·디자인 재검토를 위한 commit·작업 브랜치 업로드·PR 생성이 승인됐다. main 병합·자동 병합·릴리스는 승인되지 않았다.
- GitHub API 제출 절차 사용: 최신 main 기반 단일 부모 커밋, docs/planning/만 변경, force=false. 실제 PR/커밋/원격 검사 결과는 PR 본문에 기록한다.

- 작업: PLN-001 / Planning → HQ·OWNER
- 버전: **v0.8-draft / 2026-11-01**
- 상태: **DRAFT — OWNER 정책 선택 반영, 제안 수치 OWNER 승인 반영, 세칙·승인방식 및 부서 검토 대기**
- Gate 2 최종 승인 PENDING / 최종 상정 BLOCKED. 새 개정본 부서 재검토 NOT_REVIEWED.
- 원격 기준 main: `fa3cecff660c2bb7f68f9b381e66feaa13c0b1b0`. 작업 브랜치 제출본이며 main 병합은 별도 승인.
- 승인 근거: [OWNER 답변 원문·선택 매핑](sources/PLN-001_GATE2_OWNER_DECISIONS.md), 후보12 후속 답변 포함.

## 최신 Owner SEM 승인·HQ 보완사항 (2026-11-01)
- **적용 범위는 MVP 쉬움 난이도·시철 고정**이다. Gate 1 및 PAR-01~05 수치 승인 유지. 다른 난이도/주체로 자동 확장하지 않는다.
- **SEM-01 Owner 채택:** 운영비 발생/실제 지급 분리, B 미지급 시 신규 승차 제한·이동 중 승객 도착 허용. 완료 운임은 도착 시 자유현금 유입과 동시에 B 우선 자동 정산. B=0·다음 운행 구간 비용 충당 시 신규 승차 재개.
- **중요한 최종 범위 정정:** 미지급 즉시/6개월 경과의 **신규 사업 계약 제한은 둘 다 MVP 제외**, [IDEA-003](idea-library/PLN-IDEA-003.md)에 보존. 일반 사업 자격·가용 현금·K 예약 검사는 유지.
- **SEM-02 Owner 채택:** 정부 제한잔액 R과 자기 공사 예약금 K는 별개 보호 대상. 미지급·공정 중단으로 자동 해제하거나 전용하지 않음. [플레이어 직접 계약 취소](idea-library/PLN-IDEA-002.md)는 MVP 제외.
- **SEM-03 Owner 최종 승인:** T 시각 비용 누적→자정 마감/새 날짜→계약/지급→기성/완공→시험/개통→도착 완료 운임 인식→B 자동 정산→영업 상태/신규 탑승 판정. 후순위 운임의 계약 시점 선사용 금지; 시간 분할/배속 결과 재현은 Dev 검증 대상.
- 이후 회사 방침으로 [자동 정산 ON/OFF](idea-library/PLN-IDEA-001.md)하는 기능은 MVP 외 Library 보관.
- **APP-01 Owner 승인 PENDING.** SEM 승인이나 PR 제출로 Gate 2 최종 승인·구현 착수로 간주하지 않는다. 개발·디자인 3차 CONDITIONAL 및 HQ CONDITIONALLY HOLD 기준은 c0c5f547. 본 개정의 후속 검토 미완료.

## 1. 산출물·기준 원본
| 문서 | 버전/상태 | 역할 |
|---|---|---|
| [A](https://github.com/wisberry2022/MetroManager/blob/fa3cecff660c2bb7f68f9b381e66feaa13c0b1b0/docs/planning/PLN-001-A.md) / [B](https://github.com/wisberry2022/MetroManager/blob/fa3cecff660c2bb7f68f9b381e66feaa13c0b1b0/docs/planning/PLN-001-B.md) | v0.3 / Gate 1 OWNER_APPROVED | 읽기 전용 기준, 이번 변경 없음 |
| [C](PLN-001-C.md) | v0.5-draft | 정책 반영 MVP 범위/검수 명세 |
| D | v0.8-draft | 회신·잔여 승인·인수인계 |
| [DATA-v1](PLN-001_GATE2_DATA_v1_DRAFT.md) | v1.2-draft / PAR 수치 승인·SEM Owner 결정 반영 | 새 수치·세칙·승인방식과 정답 예시 |
| [OWNER 기록](sources/PLN-001_GATE2_OWNER_DECISIONS.md) | 직접 답변 증빙 | 1~12 및 후보12 확정 |
| [작업 결과](tasks/PLN-001_GATE2_OWNER_RESULT.md) | REVIEW | 변경/검증/잔여·게시 상태 |

이전 C/D는 [PR #5](https://github.com/wisberry2022/MetroManager/pull/5) 병합본이다. 그 안의 미게시/Git NOT_RUN은 과거 작성 이력이며 이번 기준은 최신 원격 C/D다. 로컬 동명 별도 초안을 혼합하지 않았다.
공통 [AGENTS](https://github.com/wisberry2022/MetroManager/blob/fa3cecff660c2bb7f68f9b381e66feaa13c0b1b0/AGENTS.md), [부서규칙](https://github.com/wisberry2022/MetroManager/blob/fa3cecff660c2bb7f68f9b381e66feaa13c0b1b0/docs/engineering/DEPARTMENT_WORKFLOW.md), [기획 README](https://github.com/wisberry2022/MetroManager/blob/fa3cecff660c2bb7f68f9b381e66feaa13c0b1b0/docs/planning/README.md)를 읽었다. 과거 Git 승인은 재사용하지 않는다.

## 2. 핵심 결론
1. OWNER가 정책 권고를 선택했고 지도를4구/8동, 노선을6~8역으로 확대했으며 후속 질의에서 후보12곳을 선택했다.
2. C의 정책과 DATA-v1 수치 사용 승인을 반영했다. 세칙·전체 승인방식 및 부서 검토는 별도이며 DRAFT를 유지한다.
3. MVP는 미지급·운행 제한·예약금 보호를 사용한다. 이후 신용/부채와 운영비 우선 예약금 사용은 필수 고도화 방향이다.
4. 세 부서 2차 회신은 모두 수령/CONDITIONAL이지만 이번 개정본을 검토한 회신은 아니다.
5. Gate 2 최종 승인·확정 일정·게임 구현 인수는 별도이며 Git 병합은 수행하지 않았다.

## 3. 정책 선택과 잔여 승인
| ID | 현재 정책 상태 | 잔여 승인·검토 |
|---|---|---|
| G2-Q01 | POLICY_DECIDED: MVP 쉬움·시철 | 개정본 부서 수용 |
| G2-Q02 | POLICY_DECIDED: 도1/시1/구4/동8/후보12/노선6~8, 입찰2·제안2, 동시 운영·시공 각1 | 배치·연결 데이터 타당성 재검토, 확대 견적 |
| G2-Q03 | POLICY_DECIDED: 후보 선택·순서, 같은 노선 중복/재방문·단절 금지, 슬롯 동일성 | 슬롯별 변형 데이터·목업 |
| G2-Q04 | POLICY_DECIDED: 음수 시청 거부, 고정 공기, 공개 점수·정부 확률표, 신규 사실 사건 | 수치 승인 완료, 경계 정답 개발 검산·세칙 검토 |
| G2-Q05 | POLICY_DECIDED: 완료 통행·자정 순서·OD, 하루10분·배속1/2/4·영업06~24 | 비용/기간/수요/만족·달력 수치 승인 완료, 연결 세칙 검토 |
| G2-Q06 | POLICY_DECIDED: 일회 지급·기성·잔액 제한·예약 보호·미지급/신규 운행 제한 | 미지급·탑승 중 처리·예약 취소 세칙과 장부 검산 |
| G2-Q07 | POLICY_DECIDED: 저장/파산 SHOULD, 재현 필수, 세션30~45분 목표 | 실제 세션·재현 소요·HQ 인수 |
| G2-Q08 | POLICY_DECIDED: 집계+열차+승하차 아이콘 | PC/해상도/표시 상한/프레임의 부서 제안 및 OWNER 선택 |

답변12의 재승인 요청 후 OWNER가 제안 수치를 그대로 사용한다고 회신했다. 수치 승인은 완료됐고 세칙·전체 승인방식과 Gate 2 최종 승인은 구분한다.
후보6/노선6~8 충돌은 RFC-PLN-001-G2-01로 추적했고 후보12 답변으로 해소됐다. 동별 배분·좌표·연결·슬롯 정답은 여전히 데이터 승인 대상.
Gate 1 유지: 모드 배타성, 쉬움 시철 관할, 정부 매출/공사 용도 제한, 시설 유지비 면제/운임100%, 시청/정부 분리, 제출 총횟수, 파산24/12/6/3개월·지원5/4/3/2회·회복 초기화·인피니트OFF, 극한 운임25/25/50, 공고 전 허가. 음수 사업성 거부는 이번4b 선택으로 추가된 MVP 규칙이며 과거 Gate 1 승인으로 소급하지 않는다.

### SEM 승인·검증 인계 표
| 항목 | 승인/검수 상태 | 남은 책임 |
|---|---|---|
| SEM-01 | OWNER_DECIDED / 구현 미검증 | Dev: 운임 유입·B 정산·기존 승객/계약 자금 상태·회복 불능 경계; Design: 제한/복구 UI |
| SEM-02 | OWNER_DECIDED / 구현 미검증 | Dev: 공정 중단·기성 K 차감·취소 검증 사건; Design: 공정 상태·이유 |
| SEM-03 | OWNER_DECIDED / 구현 미검증 | Dev: T 사건·자정/분할 재현; Design: 발생/지급/예상/실적/보고 기준 |
| APP-01 | OWNER_PENDING | HQ 승인 절차 통합 → Owner 승인 요청 |

## 4. 부서 회신·추적·요청
| 부서 | 현재 확보한 2차 회신 | 이번 개정본에 대한 상태 |
|---|---|---|
| Development | DEV-004 CONDITIONAL. R02 RESOLVED, R01/03/04/06/07/08 PARTIAL, R05 BLOCKED | NOT_REVIEWED: OWNER 정책 및 DATA-v1 검산·견적 필요 |
| Design | DSG-001 CONDITIONAL. R01~06/08 PARTIAL, R07 BLOCKED | NOT_REVIEWED: 확대 지도·후보·노선과 미지급 재무 상태 재검토 |
| HQ | PM-005 CONDITIONAL, 이전 C/D 조건부 접수, 최종 승인 상정 BLOCKED | 최종 통합 PENDING, 새 회신·세칙 검토 필요(수치 OWNER 승인 완료) |

공식 원격 증거:
- [개발 DEV-004](https://github.com/wisberry2022/MetroManager/blob/fa3cecff660c2bb7f68f9b381e66feaa13c0b1b0/docs/engineering/reviews/DEV-004_GATE2_SECOND_REVIEW.md), [PR #9](https://github.com/wisberry2022/MetroManager/pull/9).
- [디자인 DSG-001](https://github.com/wisberry2022/MetroManager/blob/fa3cecff660c2bb7f68f9b381e66feaa13c0b1b0/docs/design/tasks/DSG-001_RESULT.md), [PR #10](https://github.com/wisberry2022/MetroManager/pull/10).
- [HQ PM-005](https://github.com/wisberry2022/MetroManager/blob/fa3cecff660c2bb7f68f9b381e66feaa13c0b1b0/docs/hq/tasks/PM-005_RESULT.md), [PR #7](https://github.com/wisberry2022/MetroManager/pull/7).
PR #6/#8은 실제 병합 회신으로 인용하지 않는다. 세 부서의 검토 기준은 e18b047의 C v0.2-draft/D v0.5-draft이며 제출 기준 최신화와 검토 대상 버전을 구별한다.

| 회신 항목 | 이번 반영/요청 |
|---|---|
| DEV-R01/F-03/04/07 | C §5-3/4·DATA 평가/슬롯/사실, 승인 수치로 두 취득경로 정답 재검토 |
| DEV-R02/TD-01 | 계층·관할·안정ID 답변 반영. 확대 데이터 실행 검증은 별도 |
| DEV-R03/F-02/05/08 | 완료통행·OD·표현 C §5-6~8, 분할/용량/도착일 데이터 검산 |
| DEV-R04/F-06/TD-02 | 자정 대기계약/지급→기성, 분 경계 세칙 제안. 시간분할 검증 |
| DEV-R05/F-01/TD-03 | 예약 감소 및 미지급·예약 보호 반영, 두 사업·부족·회복 장부 승인/재판정 요청 |
| DEV-R06/F-03/04/07/TD-04 | 공기·동일성·신규 사실·회차/멱등성, 실패/재시험 표 |
| DEV-R07/TD-05 | 저장 SHOULD·재현 실행기, 사용자 저장과 구분. 세션 검토·개발 공수 요청 |
| DEV-R08 | 정책/콘텐츠 확대/미지급에 따른 새 견적 및 의존성 요청 |
| DSG-R01/04 | 8동·12후보·6~8역 지도·밀집/목록조작 재검토 |
| DSG-R02/06 | OD/예상·실적, 완료/탑승/이동 중, 아이콘 최소선·성능 대안 |
| DSG-R03/05 | 음수 거부·슬롯/신규 사실, 자금 중단/시험실패/운행제한의 사유·허용행동 |
| DSG-R07 | 과거 일별 흐름/현재 C/R/F/K/A·미지급 B 분리, 비용발생/현금지급 시차 |
| DSG-R08 | 신규 상태와 확대 데이터 재견적, 화면/소스 파일/검수 작업량 분리 |
| HQ RFC-PM-005-01 | 고정 공기·K 소진·취소 세칙·재현·사용성 입력을 DATA-v1로 연결. 종료 판단 요청 |

TD-01~06 및 DD-01~08은 각 부서 소관 답변으로 반영한다. 개발 구조·UI 배치를 OWNER에게 다시 선택시키지 않는다.
디자인 20~31 작업일(160~248시간, 디자이너1명·8시간/일)은 **이전 작은 도시/노선 가정의 조건부 추정**이다. 과거15~25 대비 +5~6일이지만 현재 확대 규모의 추가분은 미산정. 기존1셸+7패널+3대화상자/소스24~36도 보장치 아님. 엔진 통합/외부 사용자 연구/승인 변경/대기 제외. 개발 M/L과 합산하여 출시일을 만들지 않는다.
이번 문서는 전달용이며 부서 채팅 발송·실행 업무 배정은 하지 않았다.

### 최신 3차 부서 검토 및 HQ F01~03 대응
- Development c0c5f547 기준 보고: CONDITIONAL. 원칙의 구현 가능성을 인정하지만 수정 SEM/계약·정산·재현성·잔여 운행비·확대 공수와 기기/성능 목표는 후속 확인 필요.
- Design 같은 기준 보고: CONDITIONAL. DSG-R06 문서 수준 RESOLVED, 다른 7개 PARTIAL. 상태 의미 데이터 계약·밀집 지도·고충실도 스펙·24~40일 예비 견적(미실측) 재검토 필요.
- HQ: CONDITIONAL / 최종 승인 보류. **PLN-G2-F01**은 Owner 채택 및 제외 규칙을 C §5-5~6/DATA §4~5에, **F02**는 C/R/F/K/A/B 및 상태·비용/현금·예상/실적·현재/과거 의미를 C §5-8/후속 표에, **F03**은 C v0.5/D v0.8/DATA v1.2·Owner 승인 범위·8개 영역/11 MUST/AC-01~10/두 VP·Library 분리에 반영했다.
- 잔여: APP-01 미승인, 미지급 상태와 계약 자금 검산, UI 데이터 공급 계약, PC/성능·지도·제작 규모, HQ 블로커 최종 해소 판정. 이전 CONDITIONAL을 임의로 RESOLVED 변경하지 않는다.

## 5. 블로커·범위·후속 고도화
| ID | 이번 기획 추적 상태 | 해소 증거/잔여 담당 |
|---|---|---|
| BLOCK-G2-01 | 정책 선택 반영 / HQ 종결 확인 대기 | 쉬움·시철 OWNER 기록과 C 반영 |
| BLOCK-G2-02 | OPEN | 4구/8동/12후보/6~8역 데이터 검토, Dev/Design 확대 견적 |
| BLOCK-G2-03 | OPEN | 평가·신규 사실·설득·시험 수치 승인 완료, 행동표 검토 및 개발 검산 |
| BLOCK-G2-04 | BLOCKED_BY_REVIEW | 경제·시간 정책 선택 완료, DATA-v1 수치 승인 완료, 세칙 검토 및 DEV-R05 재판정 필요 |
| BLOCK-G2-05 | OPEN | 최소 연출 선택 완료, 대상 PC·해상도·성능 기준 미정 |
| BLOCK-G2-06 | OPEN | 재현 TD-05 수용 방향, 실행 계획·공수·HQ 인수 및 세션 검토 필요 |
| BLOCK-G2-07 | OPEN | 개정본별 부서 수용·새 견적·외부 사용성 계획과 HQ 통합 |

위 상태는 기획의 후속 추적이며 타 부서의 판정을 임의 변경하지 않는다. OWNER 정책 선택만으로 DEV-R05/DSG-R07을 RESOLVED 처리하지 않는다.
고도화 필수 방향:
- 신용/부채: 쉬움/중간/어려움/극한 및 회사 시철/사철/국철·인피니트 설정의 차등 모델. 한도·금리·상환·공적지원·부도 및 장부 표현은 후속 상세 기획/OWNER 승인.
- 운영비 우선: 공사 예약금 침식 허용, 공정 중단·재개·추가재원·플레이어 경고를 함께 설계. 현재 MVP의 예약 보호와 혼용하지 않음.
이는 MVP 개발 이후 방향 확정이며 이번 구현 티켓/추가 예산/일정 승인 아님.

## 6. HQ 검수와 다음 단계
1. 승인 수치가 반영된 DATA-v1을 세 부서가 검토하고 SEM-01~03·APP-01의 의견/필요한 추가 결정을 구분한다. 이번 PR 제출·검토 요청은 OWNER가 직접 승인했다.
2. 기획이 승인/미승인 범위와 버전을 고정하고 같은 자료로 Dev/Design 재검토.
3. Dev는 장부/상태/OD/분할 재현·검수 계획·수정 공수, Design은 데이터 계약/밀집 목업·신규 상태·수정 공수·기기/표현 대안을 회신.
4. PC/해상도/상한/성능은 양 부서 제안 후 OWNER 선택. 외부 사용성 표본/성공률/예산도 Design/HQ 제안 후 별도 선택. 내부 두 VP 관찰은 수요/심사 이유/개통 재무효과 설명 여부 기록.
5. HQ가 잔여 위험·BLOCK 해소·인력/공수/의존성을 통합, OWNER Gate 2 최종 승인 이후 Gate 3 일정안.
완성 게임 E2E PASS를 Gate 2 문서 승인 선행으로 요구하지 않는다. 실제 MVP 인수에서는 두 VP의 독립 실행·AC 증거를 요구한다.

## 7. 변경 이력·완료 조건
| 항목 | 현재 |
|---|---|
| Gate 1 | 원격 A/B v0.3 승인 기준 보존, 수정 없음 |
| 정책 선택 | 이번1~12 및 후보12 직접 답변 반영 |
| 데이터 수치/세칙/승인방식 | PAR 수치 OWNER_APPROVED / SEM-01~03 OWNER_DECIDED / APP-01 OWNER_PENDING |
| 이전2차 회신 | 수령/CONDITIONAL |
| 이번 개정본 부서 검토/HQ 최종 통합 | NOT_REVIEWED / PENDING |
| Gate 2 | 최종 승인 PENDING, 상정 BLOCKED |
| 실행 검증 | 게임 테스트/Godot/플레이/빌드/성능 NOT_RUN |
| 이번 Git 쓰기 | 작업 브랜치 commit/push/PR 승인·제출, merge 미수행; 실제 결과는 PR 본문 |

- [x] 승인 수치와 미검토 세칙을 분리한 C/D 작성.
- [x] 2차 회신 및 범위 확대·미지급·고도화 요구 추적.
- [x] OWNER 제안 수치 사용 승인.
- [ ] 추가 세칙·전체 승인방식 검토.
- [ ] 개정본 부서 수용/견적 및 HQ 통합.
- [ ] OWNER Gate 2 최종 승인.

v0.3 Gate1 → v0.4-draft 최초Gate2 → v0.5-draft 1차 회신통합(PR#5) → v0.6-draft OWNER 정책·2차 회신 반영 → **v0.7-draft 제안 수치 승인·PR 제출**.

**v0.8-draft / 2026-11-01:** SEM Owner 채택·6개월 제재 MVP 제외·Library 및 PLN-G2-F01~03 추적. 다음 Dev/Design/HQ 재검토 전 Gate 2 최종 승인 PENDING.
