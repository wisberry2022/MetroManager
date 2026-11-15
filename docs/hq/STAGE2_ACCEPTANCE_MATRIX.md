# Stage 2 통합 인수표와 최종 인수 기록

- 최신 상태 갱신: PM-020 / HQ / AGT-PM-0002 / 2026-11-15 (Asia/Seoul). 증거 취합은 PM-019, 후속 Owner 최종 결정은 E24.
- 상태: `STAGE2_OWNER_ACCEPTED / STAGE2_DONE / HQ_INTEGRATION_COMPLETED`.
- 증거 취합 기준 main: `f925cba4705ad02517f0562f1346df1da1e08462`. PM-019 병합·최종 인수 기준 main: `96c51ae6c3352195b9a8e8b89f92dd51c13be81c`. 두 SHA 모두 새 전체 GUI 시험본을 뜻하지 않는다.
- 승인 기준: [PM-014 S2-01~11](PM-014_STAGE2_VS01_EXECUTION_PLAN.md), [PM-015 증거 재사용](GUI_REVIEW_PROTOCOL.md), [PM-019 요청·Git 승인](tasks/PM-019_STAGE2_FINAL_ACCEPTANCE.md). PM-019 PR #144 main 병합과 Owner Stage 2 최종 인수는 E24로 완료됐다. 아래 증거/이월 범위는 유지한다.
- 후속 대상: [#141](https://github.com/wisberry2022/MetroManager/issues/141) CLOSED(completed). 이전 집계는 [PM-018](tasks/PM-018_DEV023_CLOSEOUT.md), [PM-017](tasks/PM-017_Q12_W06_ACCEPTANCE_UPDATE.md), [PM-016](tasks/PM-016_STAGE2_ACCEPTANCE_UPDATE.md)에 보존한다.
- 검증 수준: 공식 문서·Issue·PR·실행별 증거 색인·CI·Git 변경 대조. HQ 신규 게임 실행은 NOT_RUN, 비공개 ZIP 직접 재해시는 NOT_VERIFIED. DEV 실행과 Owner 제출 독립 실행에 대한 Design 심사를 구별한다.

## 1. 수용·종료 결과

**DEV-019·021·022·023·024의 해당 승인 범위 개발 종료와 Design의 합의된 GUI 수용은 완료됐다. 현재 특정된 추가 필수 구현·GUI 보완 요청은 없다.** HQ는 이를 S2-01~11에 연결했고 PR #144가 병합됐다. Owner 최종 Stage 2 인수와 #141 종료를 E24로 기록했다. [E08, E15~E19]

| 대상 | 현재 공식 상태 | 근거와 경계 |
| --- | --- | --- |
| DEV-019 / #75, DEV-021 / #77, DEV-024 / #80 | Owner 위임에 따른 HQ 완료 수용 / CLOSED(completed) | 개발 종료안 #140도 종료. 최초 전임 담당·실행 승인 대기 본문은 이력으로 보존 [E19]. |
| DEV-022 / #78, DEV-023 / #79 | 기존 Owner DONE / CLOSED(completed) 유지 | 모델 공급 PR #123, 제품 UI·독립24조건·Owner 결정 유지 [E08, E12~E15]. |
| DSG-010 / #81, Design 분류 #137 | 합의된 Design 범위 수용 / CLOSED(completed) | QA-001/002·Q03~05·W05·OBS-01·A02-11 한정 PASS·Q12 28조건·DEV-023 24조건·DEV-024 판정 유지. Stage 전체 PASS와 구별 [E19]. |
| INF-011 / #138 | DOC-01·Q12 정정의 현재 원본 연결 수용 / CLOSED(completed) | 원본 818파일 보존·20개 연결 검증을 INF 보고로 연결. 백업 복구까지 완료한 뜻은 아님 [E20]. |
| HQ / #141 | F01~04 main 반영·Owner 최종 인수 연결 / CLOSED(completed) | PR #144 main 반영과 Owner 명시적 최종 결정 후 공식 종료 [E24]. |

DEV-024 증거는 **1115A 자연 전체 경로 + 1115B 실제 입력 국소 보완**이다. 1115B는 MODEL_CHAIN_SETUP 이후의 F1~F3이며 1115A를 대체하는 새 자연 전체 완주가 아니다. 최신 main에서 전체를 다시 실행했다고 기록하지 않는다. [E16, E17]

## 2. S2 통합 인수표

S2-01~11의 아래 범위·한계·이월을 Owner가 최종 수용했다 [E24]. 자동검사·실제 GUI·Design 심사와 Stage 최종 결정의 증거 종류는 구별한다. 실제 추가 실행이나 과거 미확인의 PASS 승격은 아니다.

| 항목 | 연결한 증거·현재 수용 범위 | 남은 사항·판정 경계 |
| --- | --- | --- |
| S2-01 기반 보존·시간·원장 | Stage 1 DONE, W01~03/W07 및 W04A/W05/W06 회귀, DEV-024 정상3291·직접 변경 영향1185를 실행별 소스에 연결. 자연/보완 실행의 시간·원장·보고 불변도 연결 [E06, E12, E13, E16~E18]. | 기존 실행과 최종 제품 변경을 대조 [E23]. 새 필수 회귀 누락 특정 없음. 과거3291을 최신 main의 새 실행으로 소급하지 않음. |
| S2-02 공고·관할·자격 | Q03 B-X 비노출·실제 UNKNOWN_TENDER/효과0·BUSY·B=0/100, QA-001/002 수용 유지 [E01, E02]. | 관할/공기 사유의 소비 fixture를 실제 모델 실패 전체로 확대하지 않음. 추가 필수 GUI 없음. |
| S2-03 입찰·계약 | Q04 358→359 거부·359→360 직접 요청·360→361 제품 버튼, Q05 단회성·정산/접수 사본. 1115A B01 실제 응찰·낙찰·사업 계약/정부 지급 연결 [E01, E02, E16]. | 기존 점수/동점/중복 자동검사와 실제 정상 경로 구별. 추가 필수 GUI 없음. |
| S2-04 공사·기성·자금 보호 | W05 A02-01~10·12·13, R/K/B·부족/미지급/중단/재개 반례 유지. 1115A 동일 사업 표준600000/2880분 공사·기성, DEV-023 P05 스크롤234 복귀 수용 [E03~E06, E14, E16]. | TEST_ONLY 반례와 자연 표준 경로를 구별. 실제 지급 실패 전체를 UI 반례로 대신 수용하지 않음. |
| S2-05 시험·안전·개통 | 기존 빠른 공사 합성 결함·수리30분/재시험60분 및 개통 전 영업 차단 유지. 1115A 표준 시범5210→5270·안전5361→5421·개통5591 연결 [E03~E06, E12~E14, E16]. | 빠른 공사 별도 전체 E2E는 추가 의무 아님. 동일 권위 사업의 실제 영업까지 E16으로 연결. |
| S2-06 실제 OD·도착 운임 | DEV-022 모델·DEV-023 Session/P06/S01 합의 화면24조건 및 1115A 실제 영업·완료 통행754·운임75400 연결 [E12~E14, E16]. | 대표 운행 표시를 모든 열차/정차 이벤트 검증으로 확대하지 않음. 실제 완료 통행 증거는 확보됨. |
| S2-07 정산·일일 보고 | 승인 SEM/CLOSE·Q05, DEV-023 P07 현재/고정·예측/실적·0/자료 없음/실패·역순 응답 수용. 1115A Day4 영업169분·비용16900·C1258500/R200000의 첫 유효 보고 연결 [E01, E09, E12~E14, E16]. | 통제 CLOSE-01과 자연 실적 보고는 서로 다른 증거. 승인 의미 차이 특정 없음; 차이가 발견된 쟁점만 Planning 확인. |
| S2-08 실제 GUI | Q03~05·W05/OBS/A02-11·Q12 28조건/원래6범위·DEV-023 24조건 유지. 1115A V01~V04/V05-1·2 및 1115B F1~F3 수용으로 합의된 DEV-024 GUI 단계 종료 [E01~E05, E11, E14, E16, E17]. | 추가 필수 GUI·제품 보완·재공급 없음. 기존 수용을 SHA 진전/문서 정정만으로 반복하지 않음. |
| S2-09 다음 사업 조회 | 실제 영업이 있는 첫 유효 보고→조회는 1115A, 조회 성공 직후 P05 문맥에서 P01 목록/refresh 포커스 진입과 원래 P07·스크롤605 복귀/효과 불변은 1115B F1~F3 수용 [E16, E17]. | OBS-V05-01/V05-3 차단 해소. 영업0/완료0 보고로 대체하지 않음. 두 번째 실제 수주는 비범위. |
| S2-10 VS-01 전체 완주 | 독립 초기 B01→입찰/사업 계약→표준 공사→시범/안전→개통→실제 영업→첫 유효 실적 보고→조회의 1115A 자연 실행에 V05-3 국소 보완1115B 수용을 연결. DEV-024 DONE [E16~E19]. | 종전 전체 NOT_RUN/PENDING 해소. 자동 러너·분리 수용 합계를 자연 완주로 대체하지 않았음. 1115B/최신 main의 새 전체 자연 실행을 주장하지 않음. |
| S2-11 교차 인수·기록 | DEV/Design 수용·Owner 개별 종료·Planning 승인 의미·실행 SHA별 회귀/필수 CI·정정 연결·이월을 본 표로 취합 [E01~E23]. | PR #144 필수 CI·main 반영, Owner 최종 Stage 인수/상위 상태와 #141 종료 기록 완료 [E24]. |

## 3. Q12 원래 조건·상위 집계·정정 처리

원래 [A01-Q12 계획](../design/tasks/DSG-010_A01_QA_PLAN.md)은 계약/지급 전·자료 없음의 제한, 유효 계약/지급 뒤 올바른 사업으로 P05 이동/복귀, 이동만으로 공사계약·착공을 만들지 않는 것이다. 아래 초기 캡처/로그는 [E11]의 ZIP 내부 위치이며 전체 대응 정본은 Design 댓글이다.

| 원래 조건 | 기존 증거 대응 [E11] | HQ 연결 상태 |
| --- | --- | --- |
| 계약·지급 전 진입 제한 | 초기008 / product-engine.log 9행, T438/revision624. 미체결·미지급 표시, enter_p05=false·버튼 비활성. | 대조 완료·해당 범위 수용 |
| 지급자료 없음의 차단·복구 | 초기061→062→063 / fixture-engine.log 41→42행, T1800/revision11524. 비활성·클릭 무효 후 동일 계약/거래/자금으로 재조회 복구. | 표시 소비 fixture 범위 대조 완료·해당 범위 수용 |
| 자료 없음·조회 오류 | 초기035→036, 038→039. 상태 구별·상세 진입 제한·재조회 목록 복구, 자동 P05 진입 없음. | 관측 진입 경로 대조 완료·해당 범위 수용 |
| 정상 사업 인계 | 초기078→079, T5487/revision41020. B01/P-A·B01-R1-BUSINESS·B01-R1-GOVERNMENT 전달. | 대조 완료·해당 범위 수용 |
| 이동의 무효과·계약 분리 | 초기079 + W05 A02-01의018→019→020. T1997/revision13100에서 공사계약 NOT_CREATED, projects/requests 비어 있음. 별도 요청 이후 공사계약 생성. | 대조 완료·해당 범위 수용 |
| 복귀·선택·상태 보존 | 초기080→081→082 + OBS-R05의027→039·078→084. 공정 중 T2525/revision17326과 개통 후 T17022/revision133305의 왕복·사업·표시 상태 보존. | 대조 완료·해당 범위 수용 |

**원래 P05 범위:** 필수 증거 누락 없음. 추가 구현·증거 재공급·GUI 반복 요청 없음. 새 GUI 시험 6건 PASS로 합산하지 않는다. PAYMENT_MISSING은 실제 모델 지급 후 UI 소비 packet의 지급자료만 제거한 반례다. 실제 정부 지급 실패·지연·재지급이나 모든 P05 비동기 장애의 수용으로 확대하지 않는다.

**상위 집계:** 원래 P05 6범위·기존 W05/OBS/A02-11/Q12 28조건과 후속 DEV-023/024 GUI 범위는 수용됐고 #77/#81/#137도 종료됐다. 과거 A01-Q12 PARTIAL은 당시 집계 이력으로 보존한다. 현재 HQ 표기는 **OWNER_ACCEPTED / CLOSED_IN_STAGE2_SCOPE**다 [E24]. 원래 P05 미충족·상위 승인 대기는 해소됐으며 과거 미확인/미포착 사실과 범위 밖 의무는 보존한다. W06·VS-01을 원래 P05 종료의 새 선행조건으로 붙이지 않는다. [E11, E14, E17, E19]

**정정 연결:** Q12 ERROR 2→7의 현재 원본 인계 연결과 DOC-01 정정 동봉은 #138에서 수용·종료됐다. 종전 “현재 원본 연결 NOT_VERIFIED”는 해소한다. 초기 ERROR는 7회 출현이며 7개 근본 원인이나 stdout 중복을 더한14회가 아니다. 후속 오류0 실행과 원래 실패 이력은 보존한다. Q12 R02 exit NOT_CAPTURED는 별도 R30 exit0으로 덮지 않는다. [E20]

## 4. #141 조치 연결과 최종 인수 완료

| #141 항목 | 이번 연결 결과 | 완료/잔여 경계 |
| --- | --- | --- |
| F01 DOC-01 | 정정문 main 반영과 원본 연결 수용 #138 / E20 연결 완료 | PNG 24개1100×900,16개2880×1659·제외 구간을 보존. 새 ZIP/GUI 불필요. |
| F02 Q12 ERROR | 원본·7회 정정·실제 제한 보관 연결 #138 / E20 연결 완료 | 현재 정본 연결은 수용 완료. 모든 과거/미식별 사본 확인을 주장하지 않음. |
| F03 HQ 집계·승인/담당 | §1~3·E08/E10/E15~E19에 종료·담당·승인·실행 SHA·CI를 연결 | PR #144의 실제 main 반영 및 Owner 최종 결정 연결 완료 [E24]. AGT-DEV-0004의 공개 실행/제출 승인 확인과 과거 일부 개별 main 병합 승인 원문 직접 대조 NOT_VERIFIED를 구별. 병합 사실로 미확인 원문을 생성하지 않음. |
| F04 이월·재검토 | §5에 담당·시점·트리거·원천 티켓을 연결. #139 최신 Owner 정본/담당·백업 이월 결정과 PR #143 실행 결과 반영 | 이월된 실험·백업을 PASS로 표시하지 않음. §5 범위 자체의 완료는 #141 기록 연결의 새 조건 아님. |

| 순서 | 최종 인수 완료 내역 | 담당·완료 증거 |
| --- | --- | --- |
| 1 | **완료:** PM-019 제출 head의 policy·department-policy SUCCESS, main 반영 대조 | HQ. PR #144와 병합 SHA·5개 HQ blob/tree 일치 확인 [E24]. |
| 2 | **완료:** S2-01~11 범위·한계·이월의 Stage 2 최종 인수 및 A01-Q12 상위 정리 | Owner 명시 결정. 기존 정책/개별 수용 재심사 아님 [E24]. |
| 3 | **완료:** 최종 결정·범위·main SHA 공식 기록과 #141 CLOSED(completed) | HQ가 근거를 기록하고 종료했으며 최초 본문·과거 증거를 보존 [E24]. |

현 시점에서 특정된 필수 구현/GUI 누락은 없다. 실제 신규 결함·의미 차이·증거 신뢰성 문제가 발견되는 경우에만 영향 S2 번호·누락 증거·최소 보완을 특정한다. 과거 일부 승인 원문의 직접 대조 한계 [E19]는 그대로 공개하며, 새로운 소급 권한이나 전 작업 재승인 요구로 바꾸지 않는다.

## 5. 이월·별도 범위와 담당

| 추적 대상 | 현재 상태·Stage 2 관계 | 담당·적용 시점·재검토 조건 |
| --- | --- | --- |
| F-08 / [#92](https://github.com/wisberry2022/MetroManager/issues/92)·[DEV-025 #97](https://github.com/wisberry2022/MetroManager/issues/97) | PR #143의 기술 실험·자동497·실제 GUI M01~M06·결과가 main 반영됨. “전부 미실행” 상태는 해소. Design 검토·최종 폰트/필터/규격·배포 환경 인수는 미완료이며 Issue OPEN [E22]. | DEV AGT-DEV-0004 기술 결과, Design Track B AGT-DSG-0003의 RD-03/07 등 검토, 최종 선택 Owner. 결과 검토→필요한 해당 조건만 보완→승인 규격 연결. 해당 아트/지원 환경 적용 및 W09 최종 인수 전에 판단. Stage 2 합의 GUI의 일괄 재검수 조건 아님. |
| [DSG-008 / DEV-026 #104](https://github.com/wisberry2022/MetroManager/issues/104) | 구현·제품 검증 **HOLD**. DEV-022/023/024 수용·DEV-025 제출을 반영하되 #143 병합만으로 HOLD를 해제하지 않음. | Track B 소유·DEV 구현 경계 유지. DEV-022~025의 실제 공급/검토 결과와 RP-01~08 재대조 준비를 연결한 후 Owner가 개별 착수/Git 범위를 결정. 기존 Session guard를 제품 검증 PASS로 확대하지 않음. |
| F-12 정본·보관 / [INF-012 #139](https://github.com/wisberry2022/MetroManager/issues/139) | Owner가 현재 로컬 원본을 정본·자신을 보관 담당으로 확정. 현재 읽기/해시 일치 확인. 다른 사용 사본 없음은 Owner 현황 보고 범위. 종전 정본/담당 미확정 해소 [E21]. | Owner는 원본+정정+#138+결정 링크를 보존·전달, INF AGT-INF-0002 지원. 새 사본 발견/생성 또는 위치/접근 변경 시 참조 갱신. #139는 현재 OPEN/HQ 종료 검토 대기; 현 단계 종료와 백업 의무 완료는 별개. |
| F-12 백업·복구 / #139 F12-03 → 본 표 및 #141 F04 | **BACKUP_RESTORE_OWNER_APPROVED_DEFERRED / NO_BACKUP_REPORTED / RESTORE_NOT_RUN**. Stage 2 비차단. 고정 실행일 **NOT_SCHEDULED** [E21]. | Owner가 백업 위치·대상·담당/접근·일정 결정→보관 담당이 백업 마련 및 별도 위치 비파괴 복구→INF 해시/증거 지원, HQ 추적. 다음 재사용/인계 때 이월 상태를 전달·재확인; 그 전에 복구 완료라는 새 조건 아님. 완료 시 논리 ID·담당·시각·방법·복구본 해시 기록. |
| 과거 NOT_VERIFIED / NOT_CAPTURED / NOT_PROVIDED | 물리 DPI/배율·창 동등성·환경 원인·입력 주체/신원·전체 프로세스 연결·과거 보조 도구 실행 바이트는 NOT_VERIFIED. Q12 R02·PROV-01 사전 기록/과거 종료·1115B EXIT 내부 PNG는 NOT_CAPTURED, runner requested_exit는 NOT_PROVIDED. 수용 근거에서 제외된 중단 구간 보존 [E01, E04, E14, E17, E20]. | Owner 원본 보관, DEV/Design은 관련 기능·환경 변경 또는 새 결함/신뢰성 문제 발견 시 영향 행만 검토, INF 복구 지원, HQ 분류. 이미 끝난 GUI 전체 재실행·과거 물리 신원 소급 인증을 기본 의무로 만들지 않음. |
| 후속 범위 / PM-014 F-01~12 | RNG·W04B/VS-02·전체 MVP VP-01/02·외부 사용성·Windows build/export/FPS·포괄 키/배율 조합·F-12 운영 회고는 기존 적용 시점 유지. 빠른 별도 전체 E2E·두 번째 실제 수주를 Stage 2 추가 의무로 만들지 않음 [E07]. | 각 기존 담당/후속 티켓·승인 시점에 수행. Convention은 도구/CI, INF는 연속성 지원, HQ는 F-12 회고 주관, Owner는 범위/최종 승인. POST-MVP PLN-012/PR #142도 현행 MVP 규칙 확정·확장으로 해석하지 않음 [E09, E23]. |

이월은 의무 삭제나 실행 성공 판정이 아니다. 이미 결정된 R01~03·PLN-005 개정과 C v0.7/D v0.9/DATA v1.4·SEM/CLOSE 의미를 유지한다. 실제 승인 의미 차이가 없는데 Planning 전체 재승인이나 Design 전면 재검수를 요청하지 않는다.

Stage 2 DONE은 전체 MVP DONE과 구별한다. 다음 단계 목표·부서 요청은 [PM-020 Stage 3 계획안](PM-020_STAGE3_EXECUTION_PLAN.md)에서 검토한다.

## 6. 공식 근거 색인
원문 판정·시험 SHA·과거 실패/미포착 기록을 보존한다. E01~E05의 기존 수용을 신규 실행으로 합산하지 않는다.

- **E01 — Q03·04·05 종료:** [Design 상세 판정 #75](https://github.com/wisberry2022/MetroManager/issues/75#issuecomment-6876401724), [상태 연결 #81](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6876407979), [공급 PR #117](https://github.com/wisberry2022/MetroManager/pull/117). 시험/merge SHA `a65591b1e632121cd6dab4b66a23424fe8803869`. 독립 초기 세션20 PASS/FAIL0/필수 NOT_RUN0, 종료·엔진·스크립트 오류0. Q05는 4경계×1/2/4배속12조합·정지/재개/T1800 완료. Design은 Owner 제출 독립 실행 증거를 심사했으며 DEV 자체 실행과 구별한다. 물리 DPI·실행자 등록 ID·일부 첫 복귀 입력 원인은 NOT_VERIFIED, 이번 한정 수용의 차단조건 아님.
- **E02 — QA-001/002:** [Design 수용 #81](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6717973962), [PR #85](https://github.com/wisberry2022/MetroManager/pull/85). 시험 main `8f8cc57d71b42b8c5132e93e24475caa052db273`. Q07 결함 해소와 개선 수용, 당시 기존 PASS7과 PARTIAL4 구별. 원래 개별 PASS7의 비공개 전체 보고서는 이번 HQ 재열람 NOT_VERIFIED. Q03~05 잔여는 E01, Q12 후속은 E03~E05로 연결.
- **E03 — W05 기능:** [Design 판정 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6867023824), [PR #102](https://github.com/wisberry2022/MetroManager/pull/102). 시험 SHA `58bbde35bed88df9138b40d13588fe7382127a30`. A02-01~10·12·13 명시 범위 수용; A02-13은 자동 보조. 당시 A02-11 PARTIAL은 E04로 갱신. 표준 정상 제품과 TEST_ONLY 자금/빠른 공사 반례 구분.
- **E04 — OBS-01:** [독립 재검수 수용 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6869633367), [보완 PR #106](https://github.com/wisberry2022/MetroManager/pull/106). 시험 SHA `73a1ada09f15c72e9bb68efbd3c54ca605952012`. A02-11 키보드·스크롤·포커스 한정 PASS. 정상 표준 공사 착공2420→완공5300, 개통16850→16851 및 P05 왕복. 환경 ERROR·DPI 미확인은 별도 보존.
- **E05 — Q12 28조건:** [Design 한정 수용 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6873738131), [입력 공급 PR #111](https://github.com/wisberry2022/MetroManager/pull/111). 시험 main `d1773e3d6f1ef04ab3f994854affce7908e71a17`, 공급 head `d3281b52d9f9415dff7e30c3a49dd1f04d1fa6ad`. 문자열18+LF2+권위/시점/재원8. 자동662와 독립 GUI28조건은 별도. 당시 A01-Q12 상위 PARTIAL 이력과 현재 §3의 집계를 구별. 새 반복 GUI 요청 없음.
- **E06 — 기존 모델·계약 원본:** [DEV-018 W04A 공급](../engineering/evidence/DEV-018_SUPPLY_AND_VALIDATION.md), [DEV-019 UI 계약](../engineering/evidence/DEV-019_UI_CONTRACT.md), [DEV-020 결과](../engineering/tasks/DEV-020_RESULT.md), [W05 공급](../engineering/evidence/DEV-020_W05_SUPPLY_AND_VALIDATION.md), [DEV-021 UI 공급](../engineering/evidence/DEV-021_W05_UI_SUPPLY_AND_VALIDATION.md). 과거 arrival_fare fixture와 PR #123 이후 실제 operations 공급 [E12]를 구별.
- **E07 — 승인 범위:** [PM-014](PM-014_STAGE2_VS01_EXECUTION_PLAN.md), [PM-015 / 병합 PR #113](https://github.com/wisberry2022/MetroManager/pull/113). #113 merge `6e9ae33eba3437e2aa38ba2627e7e70643581568`. 하위 수용의 보존, 영향 행만 재개방, 독립 실행/심사 구별, 빠른 전체 E2E 추가 의무 없음, Track B/F-08 적용 시점 준수.
- **E08 — 담당 티켓:** [DEV-022 #78](https://github.com/wisberry2022/MetroManager/issues/78), [DEV-023 #79](https://github.com/wisberry2022/MetroManager/issues/79), [DEV-024 #80](https://github.com/wisberry2022/MetroManager/issues/80). 세 Issue 모두 CLOSED/completed. DEV-022/023의 기존 Owner DONE, DEV-024의 후속 수용·Owner 위임 종료 [E15~E19]를 연결한다. 최초 담당·승인 대기 표시는 이력이며 현재 담당은 AGT-DEV-0004다.
- **E09 — 승인 의미·정식 개정:** [Gate 2 최종 승인](../planning/PLN-001_GATE2_FINAL_APPROVAL.md), [Owner R01~03 결정 #26](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6719007539), [DEV-020 연결 #76](https://github.com/wisberry2022/MetroManager/issues/76#issuecomment-6719012772), [PLN-005 결과](../planning/tasks/PLN-005_RESULT.md), [병합 PR #108](https://github.com/wisberry2022/MetroManager/pull/108). #108 merge `6fbb9e400f9c185814c465935c30c9739d49f6db`. C v0.7/DATA v1.4 정식 반영 완료. 이후 POST-MVP 회사 상태 문서는 현행 W06 MVP 범위를 자동 확장하지 않음.
- **E10 — 담당 연속성:** [전환 규정](../infra/agents/REGISTRY_TRANSITION_RULES.md), [등록부](../infra/agents/registry.json), [PR #115](https://github.com/wisberry2022/MetroManager/pull/115), [PR #116](https://github.com/wisberry2022/MetroManager/pull/116). 기준 main에서 AGT-PM-0002·AGT-DEV-0004 ACTIVE. 등록 상태는 신원 인증이나 후속 티켓 Git 권한이 아니다.
- **E11 — 원래 Q12 대조 완료:** [Design 상세 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6885431567), [상태 연결 #81](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6885439128). 대조 기준 `f13b97d4871e8c73452134fb64c06e1fc919d779`, 게시 확인 `e379e584e6a9fefa0c581f27903c16e4fc0f5136`. 초기 시험 `06274e8557a8bbe4d8880fd02aac892c15e49f98`. Design이 DSG-010_QA_EVIDENCE.zip 7,643,211 bytes / SHA-256 `1e273b7457a71a3ef972affafba9950cafc36f22e3d4322f25e00f68bccd8169`의 manifest123/123 크기·해시·CRC를 확인하고 E03/E04를 연결. HQ의 ZIP 재검증 아님. Design도 W05/OBS 원본 ZIP의 이번 재해시는 수행하지 않음.
- **E12 — DEV-022 공급 완료:** [병합 PR #123](https://github.com/wisberry2022/MetroManager/pull/123), [승인 티켓](../engineering/tasks/DEV-022_W06_OPERATIONS_MODEL.md), [결과](../engineering/tasks/DEV-022_RESULT.md), [공급·검증 인계](../engineering/gate3/DEV-022_W06_SUPPLY_AND_VALIDATION.md). 제출 head `00be38d232308a4d4c01b203af8bab6122eed34c`, merge `e379e584e6a9fefa0c581f27903c16e4fc0f5136`. 정상 자동2664단언 = W06 179 + 기존 회귀2485. 당시 제품 GUI·Design L2/독립 GUI 잔여는 E13~E15의 DEV-023 완료로 갱신한다. 이후 실제 VS-01 수용은 E16/E17, 개발 완료는 E19로 갱신했다. 이후 HQ 문서 반영과 Owner Stage DONE은 E24로 완료됐다. 제출 head의 [policy](https://github.com/wisberry2022/MetroManager/actions/runs/43600827545)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/43600827846) SUCCESS. [출처 CI](https://github.com/wisberry2022/MetroManager/actions/runs/43600827805)는 REPORT_ONLY이며 신원/승인 인증 아님.
- **E13 — DEV-023 구현·L2·자동검증:** [PR #127](https://github.com/wisberry2022/MetroManager/pull/127) merge `3e2982ac71be28344c3be5360652f4071c678ce3`, head `b18db70eb6ebf00dbc104bb941dbf8d3fb479f35`; [PR #128](https://github.com/wisberry2022/MetroManager/pull/128) merge `bf99dd11f3d8cd4d6dc07e38de164cd0b27f8dba`, head `b1d9da850960627297651fb42fef2f89353a7daf`. 두 제출 head의 policy·department-policy SUCCESS 확인. [Owner 실행/Git 승인 티켓](../engineering/tasks/DEV-023_W06_OPERATIONS_UI.md), [DEV 결과](../engineering/tasks/DEV-023_RESULT.md), [L2 수용 #79](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6886354300). P1 자동3041=158+회귀2883, 후속 L2 보완55, P3 AUTO_UI202와 W07 322/입찰460/공사898은 원래 실행별 해시로 보존한다. P3 합계1882는 단일 최종 head 실행이 아니며 공사898 이후 변경 영향은 최종 P05 왕복 검증과 구분한다. DEV headless editor/자체 GUI 결과와 Design 독립 수용도 별개다.
- **E14 — 독립 GUI24 수용·종료:** [기존21 판정 #79](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6887692818), [보완3 최종 정본 #79](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6887989037), [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6887995179). 시험 `bf99dd11f3d8cd4d6dc07e38de164cd0b27f8dba`. Owner 제출 독립 실행 증거를 Design이 심사했으며 HQ/Design의 새 GUI 실행이 아니다. IG1115A ZIP SHA-256 `ebaa73558475895cfe10540606fc8d33c0f4299b887edbb83bd28f1558b95195`, Design manifest362/362; SUP1115B ZIP SHA-256 `0e95d4ca611af091c5f091f0fba84acce571ce841e7b049b1e3597ef47e469c1`, manifest108/108·소스644 일치·보완 B01/B02 종료0·엔진/스크립트 오류0. HQ 직접 ZIP 재해시는 NOT_VERIFIED. 과거 R09 부분 관측과 R12 CLOSE-01 보완, 실행/도구 실패 이력은 원문에 보존.
- **E15 — Owner DEV-023 DONE·후속 이관:** [Owner 결정·PM-018 승인](tasks/PM-018_DEV023_CLOSEOUT.md#요청과-승인-범위), [#79 종료 기록](https://github.com/wisberry2022/MetroManager/issues/79), [DEV 수신 확인](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6888066340). Owner는 DEV-023 완료와 #79 close를 명시 승인했다. #79 원래 본문·댓글 이력은 보존하고 최신 결정/이관을 앞에 기록했다. DEV의 미게시 후속 로컬 문서3개는 직접 검증 NOT_VERIFIED이며 추가 PR을 #79 종료의 새 선행조건으로 두지 않는다. 당시 DEV-024 이관은 E16~E19, HQ/Owner Stage 인수는 E24로 완료됐다.
- **E16 — DEV-024 자연 실행1115A:** [Design 판정 #80](https://github.com/wisberry2022/MetroManager/issues/80#issuecomment-6889738120), [PR #134](https://github.com/wisberry2022/MetroManager/pull/134). 시험/merge `0865e5a2cdf168dac14167922c9e59b16796fa81`. 실제 응찰433/효력434·낙찰/정부800000 지급1800, 표준 공사2187→5067, 시범5210→5270·안전5361→5421·개통5591, Day4 영업169분·완료754·운임75400·비용16900·C1258500/R200000. V01~V04/V05-1·2 수용. 당시 조회 뒤 P05→P02→P01 탐색의 V05-3는 E17에서 국소 보완.
- **E17 — DEV-024 보완1115B·독립 GUI 종료:** [최종 #80](https://github.com/wisberry2022/MetroManager/issues/80#issuecomment-6890415230), [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6890437629), [PR #135](https://github.com/wisberry2022/MetroManager/pull/135), [PR #136 HQ 인계](../engineering/gate3/DEV-024_DESIGN_ACCEPTANCE_HQ_HANDOFF.md). 시험/merge `324faf9b7d81540240217d2757f26de6f07460ba`. MODEL_CHAIN_SETUP 후 실제 입력 F1 P01 즉시 진입/refresh 포커스, F2 원래 P07/스크롤605→605, F3 T5760 권위 상태 효과 불변 PASS. OBS-V05-01/V05-3 수용, 추가 필수 GUI/제품/증거 요청 없음. 중단 중 raw입력7~25·캡처8~27·첫 QUERY 주체/개입 미확인 구간은 수용 근거에서 제외. 캡처28~40의 재개 후 판정을 유지. 실제 종료0/오류0과 EXIT 내부 PNG 미포착·requested_exit 미제공은 구별.
- **E18 — 회귀·권한·필수 CI:** [DEV-024 티켓](../engineering/tasks/DEV-024_VS01_INTEGRATION_EVIDENCE.md) §1.1/후속 승인 절, [결과](../engineering/tasks/DEV-024_RESULT.md), [실행별 JSON](../engineering/gate3/DEV-024_VS01_VALIDATION.json), [검증 계획](../engineering/gate3/DEV-024_VS01_VALIDATION_PLAN.md). 현재 담당 AGT-DEV-0004·공개 로컬 실행/제출 승인 연결. 정상3291=게임3243+관측기48은 최초 제품 `0a76a2e924ec0b661e3cdbd858ed6bfd665f3dc9` 및 실행별 로컬 관측기 바이트/manifest 기준. 보완1185=GUI245+운영158+입찰460+W07 322는 `0865e5a2cdf168dac14167922c9e59b16796fa81` 기반 보완 소스의 실행별 해시 기준. 최초 실패·의도 실패를 합산하지 않음. PR #134 제출 head `0cdd5b3c0ebbbe40b52dc93c2fdc369187c0c655`의 [policy](https://github.com/wisberry2022/MetroManager/actions/runs/43677341800)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/43677341838), PR #135 head `f508d88281dc84b1a9d7e4399f5eba06a89d3ce6`의 [policy](https://github.com/wisberry2022/MetroManager/actions/runs/43683416572)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/43683416561), PR #136 head `5a7182d44f7e18cfc0d9007cc169c33927028291`의 [policy](https://github.com/wisberry2022/MetroManager/actions/runs/43688728163)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/43688728428) SUCCESS. 출처 검사는 REPORT_ONLY이며 신원/승인 인증 아님.
- **E19 — Owner 위임 종료와 한계:** [개발 종료안 수용 #140](https://github.com/wisberry2022/MetroManager/issues/140#issuecomment-6891427272), [DEV-019 #75](https://github.com/wisberry2022/MetroManager/issues/75#issuecomment-6891438056), [DEV-021 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6891439519), [DEV-024 #80](https://github.com/wisberry2022/MetroManager/issues/80#issuecomment-6891440997), [DSG-010 #81](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6891455450), [Design 분류 #137](https://github.com/wisberry2022/MetroManager/issues/137#issuecomment-6891456764). Owner의 HQ/Owner 승인으로 끝낼 항목 close 지시와 한정 수용·후속 이관을 공식 기록. 과거 개별 main 병합 승인 원문 일부 직접 대조 NOT_VERIFIED는 #140/§4에 유지. 병합 사실·필수 CI·Owner 현재 완료 결정과 원문 재열람 한계를 혼동하지 않음.
- **E20 — INF-011 정정 연결 수용:** [#138 수용](https://github.com/wisberry2022/MetroManager/issues/138#issuecomment-6891410426), [DOC-01 정정문](../engineering/gate3/DEV-024_DOC-01_PACKET_README_CORRECTION.md). 제한 기록 `INF-S2-CORRECTION-LINK-20261115`, INF 보고 시각 `2026-11-15T16:45:06.342625+09:00`. 기존818파일 보존·20개 정정 연결 검증. DOC-01 PNG01~11/28~40=1100×900 24개,12~27=2880×1659 16개(제외 구간); Q12 engine ERROR 2·4·7·9·11·504·506행의7회 정정 연결. HQ의 원본 재해시는 아님. 원본 ZIP/README/로그를 그대로 보존했으며 새 ZIP/GUI 불필요.
- **E21 — INF-012 접근·Owner 이월 결정:** [실제 읽기 #139](https://github.com/wisberry2022/MetroManager/issues/139#issuecomment-6891554103), [최신 Owner 결정 연결](https://github.com/wisberry2022/MetroManager/issues/139#issuecomment-6891629210). `2026-11-15T17:13:54.346871+09:00` 현재 ZIP3개 읽기/기존 해시 일치. 논리 ID `INF012-LOCAL-DOC01-OUTER`·`INF012-LOCAL-DOC01-INNER`·`INF012-LOCAL-Q12`와 #138 정정 기록을 현재 정본/Owner 보관으로 확정. 제한 기록 `INF-012-READ-ACCESS-20261115 / read-access.json`, SHA-256 `697b22d89a747e8c27adcb57a2918a06b8661d8b752e1319f0444d08b64bbc85`. 다른 사용 사본 없음은 Owner 보고, 백업 없음/복구 NOT_RUN/일정 NOT_SCHEDULED로 후속 이월 승인. 개인 경로는 공개하지 않음.
- **E22 — Track B·DEV-025 최신 공급:** [#104 HQ 경계](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6891486517), [PR #143](https://github.com/wisberry2022/MetroManager/pull/143), [DEV-025 승인 티켓](../engineering/tasks/DEV-025_F08_TECHNICAL_VALIDATION.md), [결과](../engineering/tasks/DEV-025_RESULT.md). 제출 head `8bd236957f5adcf50aeb418cbaa617779eb8241a`, merge `dc3c049134fb45764560e47116b3332bc2f5624d`. 신규23파일(테스트 GDScript/UID8개·문서/JSON/CSV7개·PNG8개) 제출·병합. 정상자동497=신규175+W07 322; 의도 실패176/실패1 제외. 스크립트 렌더링53조건과 실제 GUI M01~M06/캡처7개 구별. 폰트/필터/레이아웃/T04 단기 Debug 관측은 최종 규격·배포 FPS·다른 PC 인수 아님. [policy](https://github.com/wisberry2022/MetroManager/actions/runs/43697720036)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/43697720029) SUCCESS. RD-03/07 등 Design 검토·최종 규격 미확정 및 DEV-026 HOLD 유지.
- **E23 — 시험본 이후 main 변경 영향:** [324faf9..f925cba 비교](https://github.com/wisberry2022/MetroManager/compare/324faf9b7d81540240217d2757f26de6f07460ba...f925cba4705ad02517f0562f1346df1da1e08462), [PR #136](https://github.com/wisberry2022/MetroManager/pull/136) 문서/JSON8개, [PR #143](https://github.com/wisberry2022/MetroManager/pull/143) 테스트·증거23개, [PR #142](https://github.com/wisberry2022/MetroManager/pull/142) POST-MVP 기획3개. `git diff --name-only 324faf9b7d81540240217d2757f26de6f07460ba..f925cba4705ad02517f0562f1346df1da1e08462 -- scripts scenes assets data project.godot` 결과 없음. 제품 소스 변경 없음과 신규 DEV-025 테스트/증거 추가를 구별한다. 문서 진전을 기존 GUI 반복의 근거로 삼지 않음.

- **E24 — Owner 최종 인수·main 반영:** [#141 최종 결정/종료](https://github.com/wisberry2022/MetroManager/issues/141#issuecomment-6892772104), [PR #144 후속](https://github.com/wisberry2022/MetroManager/pull/144#issuecomment-6892780602). Owner 원문: “main에 머지되었습니다. Stage2 최종 인수를 결정합니다”. merge `96c51ae6c3352195b9a8e8b89f92dd51c13be81c`, head `ccf8d5d85bcb1c1aa7102982c5184cae14379c67`. policy·department-policy SUCCESS, HQ5개 blob 및 tree `488df21fd659473dca2680c14c174fbb90506ff5` 일치 확인. S2-01~11을 위 범위/한계/이월과 함께 최종 수용, A01-Q12 OWNER_ACCEPTED/CLOSED_IN_STAGE2_SCOPE. #141 F01~04 완료 종료. 과거 미확인·이월을 새 실행 PASS로 변경하지 않음.

게임 명세 변경 필요 없음. 증거 취합: [PM-019 티켓](tasks/PM-019_STAGE2_FINAL_ACCEPTANCE.md) / [검증 결과](tasks/PM-019_RESULT.md). 최종 상태 연결: [PM-020 티켓](tasks/PM-020_STAGE3_ENTRY_PLAN.md) / [검증 결과](tasks/PM-020_RESULT.md). 제출 head의 검증·main 반영 상태는 해당 PR의 최신 기록을 따른다.
