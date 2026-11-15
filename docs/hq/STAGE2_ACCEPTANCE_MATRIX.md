# Stage 2 통합 인수표와 잔여 업무

- 최신 갱신: PM-018 / HQ / AGT-PM-0002 / 2026-11-15 (Asia/Seoul).
- 상태: `DEV023_OWNER_ACCEPTED_DONE / DESIGN_GUI_24_ACCEPTED / DEV024_VS01_PENDING / STAGE2_ACCEPTANCE_PENDING / PR_REVIEW`.
- 기준 main: `6e8e5869d13a7e14dc2d70ef35d5340ab2967e41`. GUI 시험 SHA: `bf99dd11f3d8cd4d6dc07e38de164cd0b27f8dba`. 이번 Commit·Push·PR과 #79 종료는 Owner 승인 범위이며 PM-018 main 병합은 별도다. 제출 head·CI·병합 상태는 PM-018 PR에서 확인한다.
- 승인 기준: [PM-014 S2-01~11](PM-014_STAGE2_VS01_EXECUTION_PLAN.md), [PM-015 증거 재사용 지침](GUI_REVIEW_PROTOCOL.md), [PM-018 Owner 결정·작업 승인](tasks/PM-018_DEV023_CLOSEOUT.md). 기존 기준·부서 수용·승인 이력을 보존한다.
- 이전 집계: [PM-016 / PR #119](https://github.com/wisberry2022/MetroManager/pull/119), [PM-017 / PR #126](https://github.com/wisberry2022/MetroManager/pull/126). 이 표는 후속 증거와 Owner 결정을 연결한 최신 현황이다.
- 검증 수준: 공식 GitHub 문서·Issue·PR·변경 파일·CI 대조. 아래 게임 검증은 DEV/Design의 기존 실행·수용 근거다. HQ의 새 게임 실행은 NOT_RUN, Owner 보관 ZIP의 직접 재해시는 NOT_VERIFIED.

## 1. 이번 반영의 결론

**DEV-023은 Owner 완료 결정에 따라 OWNER_ACCEPTED / DONE이며 #79는 completed로 종료했다.** 구현·L2·제품 연결은 PR #127/#128에 반영됐고 Design은 기존21+보완3의 **24조건 한정 수용 및 합의된 독립 GUI 단계 종료**를 확정했다. S2-06·07·08·09의 DEV-023 해당 화면·조작에 대한 Design 인수 대기는 해소됐다. S2 각 행 전체 PASS·Stage 2 DONE과 구별한다. [E13~E15]

**DEV-022 모델 공급·자동검증·main 병합 완료를 유지한다.** 다음 필수 경로는 **DEV-024 실제 표준 VS-01 완주·최종 영향 회귀 → HQ S2-01~11 통합 → Owner 최종 Stage 인수**다. 이미 수용한 GUI의 전면 반복은 다음 선행조건이 아니다. [E08, E12~E15]

원래 Q12 P05 인계·복귀 6범위는 증거 대조 완료·필수 누락 없음·종료 가능이다. 상위 A01-Q12 PARTIAL은 기존 공식 집계 상태로 보존하며 원래 P05 미충족이나 W06 완료 대기를 뜻하지 않는다. QA-001·002, Q03·04·05 잔여 PASS/검수 종료, W05 기능, OBS-01, A02-11 한정 PASS와 Q12 28조건도 유지한다. [E01~E05, E11]

## 2. S2 통합 인수표

하위 수용은 명시한 범위에 한정한다. 모델 자동검사·실제 GUI·Design 독립 심사·개별 작업 Owner DONE·HQ 통합·Owner Stage DONE은 각각 구별한다.

| 항목 | 연결한 증거·현재 수용 범위 | 실제 남은 필수 조건 | 다음 담당·적용 시점 |
| --- | --- | --- | --- |
| S2-01 기반 보존·시간·원장 | Stage 1 DONE 및 기존 DEV-022 자동검사 유지. DEV-023 P1 공급/회귀3041·L2 보완55, P3 AUTO_UI202와 기존 회귀는 각 실행 해시에 연결 [E01, E02, E06, E12, E13]. | DEV-024 최종 통합본 W01~03/W07 주요 회귀·공통 시간/원장/보고의 실제 변경 영향. 과거 실행을 최종 head의 새 실행으로 소급하지 않음. | DEV-024 최종 취합. |
| S2-02 공고·관할·자격 | Q03 잔여 PASS: B-X 비노출·실제 UNKNOWN_TENDER/효과0·BUSY·B=0/100. 관할·공기 사유는 표시 소비 fixture 한정. QA-001/002 유지 [E01, E02]. | 새 필수 결함·GUI 추가 요청 없음. 표시 fixture를 모든 모델 실패 구현으로 확대하지 않음. | 기존 차단 해소. 영향이 확인된 행만 재개방. |
| S2-03 입찰·계약 | Q04의 358→359 거부, 359→360 검증용 직접 요청, 360→361 제품 버튼 PASS. Q03 정산·접수 사본, Q05 단회성·기존 점수/동점/중복 유지 [E01, E02]. | 새 필수 결함·GUI 추가 요청 없음. 기존 수용을 신규 실행 합계로 중복 계상하지 않음. | 향후 명령·원장 변경 영향은 DEV 검증. |
| S2-04 공사·기성·자금 보호 | DEV-020/W05 A02-01~10·12·13, 표준2880분/600000·R/K/B, TEST_ONLY 부족/미지급/중단/재개, Q12-FIN 유지. DEV-023 P05 복귀234 보완 수용 [E03~E06, E12, E14]. | 이 수용 범위의 추가 구현 요청 없음. DEV-024 동일 사업/공사 권위 ID·원장 연속성과 실제 변경 영향 연결. | DEV-024; 기존 증거 재사용. |
| S2-05 시험·안전·개통 | 표준 정상·빠른 합성 수리30분/재시험60분, DEV-022 유효 개통 소비, DEV-023 제품 Session 활성화·개통 전 제한/개통 후 표시 수용 [E03~E06, E12~E14]. | DEV-024 표준 경로에서 동일 권위 개통→영업의 연속 관측. 빠른 공사 별도 전체 E2E는 새 필수 조건 아님. | DEV-024 표준 실제 경로. |
| S2-06 실제 OD·도착 운임 | DEV-022 모델 공급/자동검증 완료. DEV-023 제품 Session opt-in·P06/S01 실제 OD/cohort 대표 표현·역 집계·수요0·제한/잔여 도착·만족도 구분의 합의 범위 Design 수용 [E12~E14]. | 해당 화면 Design 대기 해소. DEV-024 자연 전체 경로에서 실제 완료 통행·영업 실적 관측. 대표 표시를 실제 열차 수/모든 정차 이벤트로 확대하지 않음. | DEV-024 통합; L2-C의 최소 표현 범위 유지. |
| S2-07 정산·일일 보고 | SEM/CLOSE·Q05·DEV-022 모델 유지. DEV-023 P07 발생/현금지급/후정산·현재/고정·예측/실적·정상0/자료 없음/실패 구분 및 P07 역순 응답 보완 수용 [E01, E09, E12~E14]. | 해당 화면 Design 대기 해소. DEV-024 실제 영업→첫 유효 보고와 최종 원장/보고 일치 연결. 통제 CLOSE-01 관측을 자연 완주로 확대하지 않음. | DEV-024. 실제 승인 의미 차이만 Planning. |
| S2-08 실제 GUI | Q03~05 종료·W05/OBS-01/A02-11·Q12 28조건·원래 P05 6범위 유지. DEV-023 기존21+보완3=24조건 수용·GUI 단계 종료 [E01~E05, E11, E14]. | DEV-023 추가 GUI 요청 없음. DEV-024 자연 완주와 실제 변경 영향의 관측 범위를 독립 실행/Design 심사로 연결. Q12 오류 집계 정정은 별도 기록. | DEV/독립 실행·Design 심사/HQ. 기존24 반복 금지; 영향 행만 재개방. |
| S2-09 다음 사업 조회 | DEV-022 MODEL_CHAIN의 실적 있는 보고 공급, DEV-023 실제 GUI의 보고 선택→다음 사업 조회→복귀/포커스·스크롤 보존 수용 [E12~E14]. | 제품 조작 전체를 NOT_RUN으로 표시하지 않음. 모델 경로 준비 후 GUI 수용과 별도로 DEV-024 자연 전체 경로의 첫 유효 보고→조회가 남음. 영업0/완료0 보고로 성공 선언 금지. | DEV-024. 두 번째 실제 수주는 비범위. |
| S2-10 VS-01 전체 완주 | W04A/W05·DEV-022 모델 연결·DEV-023 실제 GUI는 하위 증거. 독립 초기 상태부터 자연 실제 제품 전체 완주는 **NOT_RUN** [E01, E03, E04, E12~E14]. | B01→입찰/사업 계약→표준 공사→시범/안전→개통→실제 영업→첫 유효 실적 보고→다음 사업 조회의 연속 실제 입력·로그. | DEV-024. 자동 러너·강제 성공 fixture·분리 검수 합계로 대체 금지. |
| S2-11 교차 인수·기록 | 기존 수용·PLN-005·Q12 대조·DEV-022에 DEV-023 PR127/128·L2·24조건·DEV 수신·Owner DONE/#79 종료를 연결 [E01~E06, E09, E11~E15]. | DEV-024 증거·Design 심사·필요 Planning 회신, 최종 필수 CI·미해결/이월, HQ 통합·Owner 최종 Stage 결정. | HQ 취합, Owner 최종 결정. DEV-023 DONE을 전체 Stage DONE으로 확대하지 않음. |

## 3. 원래 Q12 대조 완료와 상위 PARTIAL의 분리

원래 [A01-Q12 계획](../design/tasks/DSG-010_A01_QA_PLAN.md)은 계약/지급 전·자료 없음의 제한, 유효 계약/지급 뒤 올바른 사업으로 P05 이동/복귀, 이동만으로 공사계약·착공을 만들지 않는 것이다. 아래 초기 캡처/로그는 [E11]의 ZIP 내부 위치이며 전체 대응 정본은 Design 댓글이다.

| 원래 조건 | 기존 증거 대응 [E11] | HQ 연결 상태 |
| --- | --- | --- |
| 계약·지급 전 진입 제한 | 초기008 / product-engine.log 9행, T438/revision624. 미체결·미지급 표시, enter_p05=false·버튼 비활성. | 대조 완료·종료 가능 |
| 지급자료 없음의 차단·복구 | 초기061→062→063 / fixture-engine.log 41→42행, T1800/revision11524. 비활성·클릭 무효 후 동일 계약/거래/자금으로 재조회 복구. | 표시 소비 fixture 범위 대조 완료·종료 가능 |
| 자료 없음·조회 오류 | 초기035→036, 038→039. 상태 구별·상세 진입 제한·재조회 목록 복구, 자동 P05 진입 없음. | 관측 진입 경로 대조 완료·종료 가능 |
| 정상 사업 인계 | 초기078→079, T5487/revision41020. B01/P-A·B01-R1-BUSINESS·B01-R1-GOVERNMENT 전달. | 대조 완료·종료 가능 |
| 이동의 무효과·계약 분리 | 초기079 + W05 A02-01의018→019→020. T1997/revision13100에서 공사계약 NOT_CREATED, projects/requests 비어 있음. 별도 요청 이후 공사계약 생성. | 대조 완료·종료 가능 |
| 복귀·선택·상태 보존 | 초기080→081→082 + OBS-R05의027→039·078→084. 공정 중 T2525/revision17326과 개통 후 T17022/revision133305의 왕복·사업·표시 상태 보존. | 대조 완료·종료 가능 |

**원래 P05 범위:** 필수 증거 누락 없음. 추가 구현·증거 재공급·GUI 반복 요청 없음. 새 GUI 시험 6건 PASS로 합산하지 않는다. PAYMENT_MISSING은 실제 모델 지급 후 UI 소비 packet의 지급자료만 제거한 반례다. 실제 정부 지급 실패·지연·재지급이나 모든 P05 비동기 장애의 수용으로 확대하지 않는다.

**상위 상태:** A01-Q12 PARTIAL은 기존 공식 상태로 보존한다. 본 표에서는 원래 인계 조건의 미충족을 해소하고 W05·OBS-01·A02-11 한정 PASS·Q12 28조건 수용을 별도로 유지한다. W06 화면 인수 [E14]와 DEV-024 VS-01·최종 인수는 별도 범위이며 원래 P05 종료의 새 선행조건이 아니다. 이번 Owner 결정으로 DEV-023/#79만 DONE/종료한다. 상위 Q12 PASS·#77/#81 전체 종료·Stage DONE을 선언하지 않는다.

**기록 잔여:** ERROR 2→7건 정정은 [E05]·[E11] 원문에 연결했다. 다만 원본 인계 기록까지 정정이 반영됐다는 완료 증거는 **NOT_VERIFIED**다. HQ는 기존 인계 기록의 정정 참조 여부를 확인·연결하고 Design은 필요한 원본 위치를 확인한다. GUI 재실행을 요구하지 않는다. DPI·환경 NOT_VERIFIED, R02 종료코드 NOT_CAPTURED 및 범위 밖 UNKNOWN/NOT_RUN을 보존한다.


## 4. 남은 필수 업무의 우선순위

| 순서 | 실제 업무·완료 산출물 | 담당·선행조건 |
| --- | --- | --- |
| 1 | DEV-024 현재 담당·고정 시험본·실행 범위와 유효한 개별 실행/Git 승인 원문을 하나의 실행 패킷에 연결. | DEV/HQ. 제품 경로는 DEV-023으로 공급·수용 완료. 이미 유효한 승인은 재사용하며 미확인 범위만 Owner 결정 대상으로 남김. |
| 2 | 독립 초기 상태의 실제 표준 VS-01 전체 완주. 실제 완료 통행/영업 실적이 있는 첫 보고와 다음 사업 조회까지 증거 확보. | DEV 및 독립 실행·Design 심사. 실제 입력·명령·효력시각·원장·도착·보고·종료코드·해시를 연결. |
| 3 | 최종 통합본 주요 회귀·실제 변경 영향 취합. 동일 완주 증거를 관측 범위 안에서 S2-08·09·10에 공동 사용. | DEV 실행, Design 해당 GUI 심사, HQ 색인. 새 영향이 없는 기존24조건 반복 없음. |
| 4 | S2-01~11 필수 증거·부서 수용·미해결/이월·필수 CI 종합 후 Owner 최종 인수·종료 기록. | HQ 정리는 병행. Q12 ERROR 2→7 인계 정정 연결도 기록으로 처리. Owner Stage DONE 별도. |

F-08/Track B 규격·에셋 계약, Windows export/FPS 최종 인수, W04B/VS-02, POST-MVP 회사 상태 설계, F-12 운영 회고는 각 적용 시점을 유지한다. Stage 2의 일괄 선행조건으로 올리지 않는다. P07 F-02(발생/현금지급/후정산 설명)·F-10(UI 계약)은 DEV-023 L2/실제 화면의 합의 범위로 연결하며 미래 변경 영향은 별도다. Track B 별도 소유/승인과 DEV-026 구현·제품 검증 HOLD를 유지한다. [E07, E13~E15]

## 5. DEV-023 완료 범위와 DEV-024 이관 경계

**DEV-022: MODEL_IMPLEMENTED / AUTO_VALIDATED / MAIN_MERGED. DEV-023: OWNER_ACCEPTED / DONE.** 모델 공급, 실제 제품 연결, 부서 한정 수용, Owner 작업 완료를 각각 연결했다. 이번 결정은 DEV-024나 Stage 전체의 완료 결정이 아니다.

| DEV-023 수용 구분 | 완료 근거·한계 | 후속 처리 |
| --- | --- | --- |
| L2·제품 공급 | PR #127/#128 main 반영, L2-01~04 및 RFC-DEV-023-01 L2-A/B/C ACCEPTED. Session 활성화·P06/P07·S01·보고/조회/복귀 연결. | DEV-023 개별 구현/Git 승인 원문은 공개 티켓 §1.1~1.4에 확인됨. 더 이상 미확인 승인으로 표시하지 않음 [E13]. |
| 기존 독립21조건 | 정상·0·자료 없음·실패, 현재/고정·예측/실적, 보고→조회·복귀, P06 stale·대표 운영 표현, 기본 창/키 조작 등 원문 행별 한정 수용. MODEL_CHAIN_SETUP·MODEL_FIXTURE·CONSUMER_FIXTURE를 구별. | 전체 U01~U20 문맥×키 조합이나 자연 VS-01을 모두 수용한 것으로 확대하지 않음 [E14]. |
| 보완 P07 | 과거 Day1 응답을 Day4 선택 상태에서 거부; 선택 보고·버튼·포커스·스크롤605·효과 보존. | 기존 선택을 초기화한 우회 PASS가 아님. 해당 필수 미충족 해소 [E14]. |
| 보완 긴 사유 | 525자 한국어 사유, 800×600 작은 창의 끝까지 가독성·상세/복귀·키보드 동선 확인. | 소비 fixture 한정. 실제 모든 모델 실패 경로의 수용으로 확대하지 않음 [E14]. |
| 보완 P05 | 실제 이동 직전·저장·복귀 스크롤234→234→234, 포커스·공사 상태·게임 효과 보존. | 원래 Q12 및 기존 OBS/A02-11 수용 유지. 추가 GUI 요청 없음 [E14]. |
| Owner 작업 완료 | 이번 Owner 결정으로 DEV-023 DONE/#79 CLOSED(completed). DEV도24조건 수용·GUI 종료를 확인. | 후속 통합은 #80/HQ로 이관. 기존 개발·Design 문서의 과거 PENDING/PARTIAL 헤더는 당시 이력 [E15]. |

**DEV-024 실행 패킷:** #80은 OPEN/댓글0이고 최초 AGT-DEV-0001·실행 승인 대기 기록을 유지하고 있다. 등록부의 AGT-DEV-0004 ACTIVE와 DEV-023 유효 승계·승인은 확인했으나 **DEV-024의 현재 지정 담당·고정 시험본·개별 실행/Git 승인 원문은 NOT_VERIFIED**다. DEV/HQ가 실제 유효한 원문을 연결하고 부족한 권한만 Owner에게 구체적으로 상정한다. 이번 PM-018 승인이나 #79 종료로 DEV-024 권한을 생성하지 않는다. [E08, E10, E13, E15]

**DEV-024 실행·인수:** 독립 초기 상태에서 B01→입찰·사업 계약→표준 공사→시범운행·안전검증→개통→실제 영업→첫 유효 실적 보고→다음 사업 조회를 실제 제품 입력으로 완주한다. 실제 완료 통행·영업 실적, 실제 입력·명령·효력시각·원장·도착·보고·종료코드·해시와 최종 회귀/변경 영향을 한 패킷에 연결한다. 자동 러너·강제 성공 fixture·분리 검수 합계로 대체하지 않는다. 두 번째 실제 수주·빠른 공사 별도 전체 E2E는 추가 의무가 아니다. 같은 증거는 실제 관측 범위 안에서 S2-08/09/10에 공동 연결한다.

**보존할 한계:** 과거 일부 보조 도구의 실행 당시 바이트·초기 환경 오류 원인·물리 DPI·Q12 ERROR 2→7 인계 정정 연결 완료는 NOT_VERIFIED. 최초 원본 콘솔·Q12 R02의 NOT_CAPTURED, GUI 도구 timeout·비정상 종료 이력도 보존한다. 자연 VS-01 전체 완주·빌드/export·성능·모든 문맥×키 조합·Track B/F-08은 이번24조건 범위 밖이다. 해당 미확인 항목은 종료된 GUI의 추가 차단으로 편입하지 않는다.

승인 규칙 C v0.7/D v0.9/DATA v1.4·SEM-01~03/CLOSE-01 및 R01~03 결정·PLN-005 정식 개정을 유지한다. 실제 승인 의미 차이만 Planning, 새로운 정책/범위 변경만 RFC로 처리한다. 관련 변경·새 결함·증거 신뢰성 문제가 확인될 때 영향 행만 재개방하며 SHA 진전·기록 정정만으로 기존 GUI를 반복하지 않는다.

## 6. 공식 근거 색인

원문 판정·시험 SHA·과거 실패/미포착 기록을 보존한다. E01~E05의 기존 수용을 신규 실행으로 합산하지 않는다.

- **E01 — Q03·04·05 종료:** [Design 상세 판정 #75](https://github.com/wisberry2022/MetroManager/issues/75#issuecomment-6876401724), [상태 연결 #81](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6876407979), [공급 PR #117](https://github.com/wisberry2022/MetroManager/pull/117). 시험/merge SHA `a65591b1e632121cd6dab4b66a23424fe8803869`. 독립 초기 세션20 PASS/FAIL0/필수 NOT_RUN0, 종료·엔진·스크립트 오류0. Q05는 4경계×1/2/4배속12조합·정지/재개/T1800 완료. Design은 Owner 제출 독립 실행 증거를 심사했으며 DEV 자체 실행과 구별한다. 물리 DPI·실행자 등록 ID·일부 첫 복귀 입력 원인은 NOT_VERIFIED, 이번 한정 수용의 차단조건 아님.
- **E02 — QA-001/002:** [Design 수용 #81](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6717973962), [PR #85](https://github.com/wisberry2022/MetroManager/pull/85). 시험 main `8f8cc57d71b42b8c5132e93e24475caa052db273`. Q07 결함 해소와 개선 수용, 당시 기존 PASS7과 PARTIAL4 구별. 원래 개별 PASS7의 비공개 전체 보고서는 이번 HQ 재열람 NOT_VERIFIED. Q03~05 잔여는 E01, Q12 후속은 E03~E05로 연결.
- **E03 — W05 기능:** [Design 판정 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6867023824), [PR #102](https://github.com/wisberry2022/MetroManager/pull/102). 시험 SHA `58bbde35bed88df9138b40d13588fe7382127a30`. A02-01~10·12·13 명시 범위 수용; A02-13은 자동 보조. 당시 A02-11 PARTIAL은 E04로 갱신. 표준 정상 제품과 TEST_ONLY 자금/빠른 공사 반례 구분.
- **E04 — OBS-01:** [독립 재검수 수용 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6869633367), [보완 PR #106](https://github.com/wisberry2022/MetroManager/pull/106). 시험 SHA `73a1ada09f15c72e9bb68efbd3c54ca605952012`. A02-11 키보드·스크롤·포커스 한정 PASS. 정상 표준 공사 착공2420→완공5300, 개통16850→16851 및 P05 왕복. 환경 ERROR·DPI 미확인은 별도 보존.
- **E05 — Q12 28조건:** [Design 한정 수용 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6873738131), [입력 공급 PR #111](https://github.com/wisberry2022/MetroManager/pull/111). 시험 main `d1773e3d6f1ef04ab3f994854affce7908e71a17`, 공급 head `d3281b52d9f9415dff7e30c3a49dd1f04d1fa6ad`. 문자열18+LF2+권위/시점/재원8. 자동662와 독립 GUI28조건은 별도. A01-Q12 상위 PARTIAL, 새 반복 GUI 요청 없음.
- **E06 — 기존 모델·계약 원본:** [DEV-018 W04A 공급](../engineering/evidence/DEV-018_SUPPLY_AND_VALIDATION.md), [DEV-019 UI 계약](../engineering/evidence/DEV-019_UI_CONTRACT.md), [DEV-020 결과](../engineering/tasks/DEV-020_RESULT.md), [W05 공급](../engineering/evidence/DEV-020_W05_SUPPLY_AND_VALIDATION.md), [DEV-021 UI 공급](../engineering/evidence/DEV-021_W05_UI_SUPPLY_AND_VALIDATION.md). 과거 arrival_fare fixture와 PR #123 이후 실제 operations 공급 [E12]를 구별.
- **E07 — 승인 범위:** [PM-014](PM-014_STAGE2_VS01_EXECUTION_PLAN.md), [PM-015 / 병합 PR #113](https://github.com/wisberry2022/MetroManager/pull/113). #113 merge `6e9ae33eba3437e2aa38ba2627e7e70643581568`. 하위 수용의 보존, 영향 행만 재개방, 독립 실행/심사 구별, 빠른 전체 E2E 추가 의무 없음, Track B/F-08 적용 시점 준수.
- **E08 — 담당 티켓:** [DEV-022 #78](https://github.com/wisberry2022/MetroManager/issues/78), [DEV-023 #79](https://github.com/wisberry2022/MetroManager/issues/79), [DEV-024 #80](https://github.com/wisberry2022/MetroManager/issues/80). PM-017 당시 OPEN 기록과 구별한다. DEV-023은 이번 Owner 결정·HQ 기록으로 CLOSED/completed [E15]. #80은 OPEN/댓글0이며 초기 담당·실행 승인 대기 기록만 확인됐다. 후속 담당·고정 시험본·개별 권한은 §5에 따라 대조한다.
- **E09 — 승인 의미·정식 개정:** [Gate 2 최종 승인](../planning/PLN-001_GATE2_FINAL_APPROVAL.md), [Owner R01~03 결정 #26](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6719007539), [DEV-020 연결 #76](https://github.com/wisberry2022/MetroManager/issues/76#issuecomment-6719012772), [PLN-005 결과](../planning/tasks/PLN-005_RESULT.md), [병합 PR #108](https://github.com/wisberry2022/MetroManager/pull/108). #108 merge `6fbb9e400f9c185814c465935c30c9739d49f6db`. C v0.7/DATA v1.4 정식 반영 완료. 이후 POST-MVP 회사 상태 문서는 현행 W06 MVP 범위를 자동 확장하지 않음.
- **E10 — 담당 연속성:** [전환 규정](../infra/agents/REGISTRY_TRANSITION_RULES.md), [등록부](../infra/agents/registry.json), [PR #115](https://github.com/wisberry2022/MetroManager/pull/115), [PR #116](https://github.com/wisberry2022/MetroManager/pull/116). 기준 main에서 AGT-PM-0002·AGT-DEV-0004 ACTIVE. 등록 상태는 신원 인증이나 후속 티켓 Git 권한이 아니다.
- **E11 — 원래 Q12 대조 완료:** [Design 상세 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6885431567), [상태 연결 #81](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6885439128). 대조 기준 `f13b97d4871e8c73452134fb64c06e1fc919d779`, 게시 확인 `e379e584e6a9fefa0c581f27903c16e4fc0f5136`. 초기 시험 `06274e8557a8bbe4d8880fd02aac892c15e49f98`. Design이 DSG-010_QA_EVIDENCE.zip 7,643,211 bytes / SHA-256 `1e273b7457a71a3ef972affafba9950cafc36f22e3d4322f25e00f68bccd8169`의 manifest123/123 크기·해시·CRC를 확인하고 E03/E04를 연결. HQ의 ZIP 재검증 아님. Design도 W05/OBS 원본 ZIP의 이번 재해시는 수행하지 않음.
- **E12 — DEV-022 공급 완료:** [병합 PR #123](https://github.com/wisberry2022/MetroManager/pull/123), [승인 티켓](../engineering/tasks/DEV-022_W06_OPERATIONS_MODEL.md), [결과](../engineering/tasks/DEV-022_RESULT.md), [공급·검증 인계](../engineering/gate3/DEV-022_W06_SUPPLY_AND_VALIDATION.md). 제출 head `00be38d232308a4d4c01b203af8bab6122eed34c`, merge `e379e584e6a9fefa0c581f27903c16e4fc0f5136`. 정상 자동2664단언 = W06 179 + 기존 회귀2485. 당시 제품 GUI·Design L2/독립 GUI 잔여는 E13~E15의 DEV-023 완료로 갱신한다. 실제 VS-01·HQ 통합·Owner Stage DONE은 여전히 별도 잔여. 제출 head의 [policy](https://github.com/wisberry2022/MetroManager/actions/runs/43600827545)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/43600827846) SUCCESS. [출처 CI](https://github.com/wisberry2022/MetroManager/actions/runs/43600827805)는 REPORT_ONLY이며 신원/승인 인증 아님.
- **E13 — DEV-023 구현·L2·자동검증:** [PR #127](https://github.com/wisberry2022/MetroManager/pull/127) merge `3e2982ac71be28344c3be5360652f4071c678ce3`, head `b18db70eb6ebf00dbc104bb941dbf8d3fb479f35`; [PR #128](https://github.com/wisberry2022/MetroManager/pull/128) merge `bf99dd11f3d8cd4d6dc07e38de164cd0b27f8dba`, head `b1d9da850960627297651fb42fef2f89353a7daf`. 두 제출 head의 policy·department-policy SUCCESS 확인. [Owner 실행/Git 승인 티켓](../engineering/tasks/DEV-023_W06_OPERATIONS_UI.md), [DEV 결과](../engineering/tasks/DEV-023_RESULT.md), [L2 수용 #79](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6886354300). P1 자동3041=158+회귀2883, 후속 L2 보완55, P3 AUTO_UI202와 W07 322/입찰460/공사898은 원래 실행별 해시로 보존한다. P3 합계1882는 단일 최종 head 실행이 아니며 공사898 이후 변경 영향은 최종 P05 왕복 검증과 구분한다. DEV headless editor/자체 GUI 결과와 Design 독립 수용도 별개다.
- **E14 — 독립 GUI24 수용·종료:** [기존21 판정 #79](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6887692818), [보완3 최종 정본 #79](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6887989037), [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6887995179). 시험 `bf99dd11f3d8cd4d6dc07e38de164cd0b27f8dba`. Owner 제출 독립 실행 증거를 Design이 심사했으며 HQ/Design의 새 GUI 실행이 아니다. IG1115A ZIP SHA-256 `ebaa73558475895cfe10540606fc8d33c0f4299b887edbb83bd28f1558b95195`, Design manifest362/362; SUP1115B ZIP SHA-256 `0e95d4ca611af091c5f091f0fba84acce571ce841e7b049b1e3597ef47e469c1`, manifest108/108·소스644 일치·보완 B01/B02 종료0·엔진/스크립트 오류0. HQ 직접 ZIP 재해시는 NOT_VERIFIED. 과거 R09 부분 관측과 R12 CLOSE-01 보완, 실행/도구 실패 이력은 원문에 보존.
- **E15 — Owner DEV-023 DONE·후속 이관:** [Owner 결정·PM-018 승인](tasks/PM-018_DEV023_CLOSEOUT.md#요청과-승인-범위), [#79 종료 기록](https://github.com/wisberry2022/MetroManager/issues/79), [DEV 수신 확인](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6888066340). Owner는 DEV-023 완료와 #79 close를 명시 승인했다. #79 원래 본문·댓글 이력은 보존하고 최신 결정/이관을 앞에 기록했다. DEV의 미게시 후속 로컬 문서3개는 직접 검증 NOT_VERIFIED이며 추가 PR을 #79 종료의 새 선행조건으로 두지 않는다. DEV-024 #80과 HQ/Owner Stage 인수는 별도다.

GUI 시험 SHA 이후 기준 main까지 변경은 PR #129 Planning3개와 PR #130 Design2개 문서뿐이며 제품 소스 차이는 없다. PR #130의 DEV-023 기존21+보완3대기 설명은 작성 당시 기록으로, 최신24조건 판정 [E14]와 Owner 결정 [E15]를 우선한다. Track B RP-01~08 재대조 준비를 DEV-023 재개방이나 DEV-026 실행 승인으로 해석하지 않는다. 이후 새 변경은 실제 영향에 따라 판단한다.

DEV-022 원래 공급/회귀 소스 해시와 과거 DEV 미게시 로컬 문서4개 직접 검증 NOT_VERIFIED도 유지한다. 게임 명세 변경 필요 없음. [PM-018 티켓](tasks/PM-018_DEV023_CLOSEOUT.md) / [검증 결과](tasks/PM-018_RESULT.md).
