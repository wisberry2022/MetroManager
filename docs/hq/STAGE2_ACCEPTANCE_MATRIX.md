# Stage 2 통합 인수표와 잔여 업무

- 최신 갱신: PM-017 / HQ / AGT-PM-0002 / 2026-11-15 (Asia/Seoul).
- 상태: `Q12_ORIGINAL_EVIDENCE_RECONCILED / Q12_ORIGINAL_CLOSE_READY / DEV022_MODEL_SUPPLY_MERGED / STAGE2_ACCEPTANCE_PENDING / PR_REVIEW`.
- 기준 main: `e379e584e6a9fefa0c581f27903c16e4fc0f5136` (DEV-022 PR #123 merge). 이번 HQ 갱신의 Commit·Push·PR은 Owner 승인 범위이며 PM-017 자체의 main 병합은 별도 승인 대상이다. 제출 head·CI·병합 상태는 PM-017 PR에서 확인한다.
- 승인 기준: [PM-014 S2-01~11](PM-014_STAGE2_VS01_EXECUTION_PLAN.md), [PM-015 증거 재사용 지침](GUI_REVIEW_PROTOCOL.md). 기존 기준과 부서별 수용·Owner 승인 이력을 보존한다.
- 최초 PM-016 기록은 [PR #119](https://github.com/wisberry2022/MetroManager/pull/119), [티켓](tasks/PM-016_STAGE2_ACCEPTANCE_UPDATE.md), [결과](tasks/PM-016_RESULT.md)에 보존한다. 이 표는 후속 증거를 연결한 최신 현황이다.
- 검증 수준: 공식 GitHub 문서·Issue·PR·변경 파일·CI 대조. 아래 게임 검증은 DEV/Design의 기존 실행·수용 근거다. HQ의 새 게임 실행은 NOT_RUN, Owner 보관 ZIP의 직접 재해시 검증은 NOT_VERIFIED.

## 1. 이번 반영의 결론

**원래 Q12 P05 인계·복귀 6범위는 증거 대조 완료·필수 누락 없음·종료 가능**으로 연결한다. 종전 하위 행의 증거 대응 NOT_VERIFIED는 해소됐다. 기존 독립 실행의 대응을 정리한 것이며 새 GUI 실행이나 신규 시험 6건 PASS가 아니다. 상위 A01-Q12 PARTIAL은 보존하되 원래 인계 미충족이나 W06 완료 대기를 뜻하지 않는다. [E11]

**DEV-022 실제 운행 모델 공급·자동검증 제출·main 병합은 완료**됐다. 실제 제품 잔여는 **DEV-023 Session·운영/재무 UI·Design 인수 → DEV-024 실제 VS-01 완주·영향 회귀 → HQ 통합·Owner 최종 인수**다. DEV-022를 다시 착수 대기·미구현으로 표시하지 않는다. [E08, E12]

QA-001·002, Q03·04·05 잔여 PASS/검수 종료, W05 기능, OBS-01, A02-11 한정 PASS와 Q12 28조건은 유지한다. 관련 변경 영향·새 결함·증거 신뢰성 문제가 확인될 때 영향 행만 재개방한다. SHA 진전·기록 정정만으로 같은 GUI를 반복하지 않는다. [E01~E05, E07, E11]

## 2. S2 통합 인수표

하위 수용은 명시한 범위에 한정한다. 모델 구현/자동검사, 실제 GUI, Design 독립 심사, HQ 통합, Owner Stage DONE은 별개다.

| 항목 | 연결한 증거·현재 수용 범위 | 실제 남은 필수 조건 | 다음 담당·적용 시점 |
| --- | --- | --- | --- |
| S2-01 기반 보존·시간·원장 | Stage 1 DONE 및 기존 자동검사 유지. DEV-022 W06 179단언과 W02/W03/W04A/W05/W07/입찰·공사 UI 회귀2485단언 증거 연결 [E01, E02, E06, E12]. | DEV-023 이후 공통 시간·원장·보고 변경 영향, DEV-024 최종 통합본 W01~03/W07 주요 회귀. 기존 실행 소스 해시·시점을 보존하고 신규 head 실행으로 소급하지 않음. | DEV-023 영향 검증, DEV-024 최종 취합. |
| S2-02 공고·관할·자격 | Q03 잔여 PASS: B-X 비노출·실제 UNKNOWN_TENDER/효과0·BUSY·B=0/100. 관할·공기 사유는 표시 소비 fixture 한정. QA-001/002 수용 유지 [E01, E02]. | 새 필수 결함·GUI 추가 요청 없음. 표시 fixture를 모든 모델 실패 구현으로 확대하지 않음. | 해당 차단 해소. HQ 색인 유지, 후속 영향이 확인된 행만 재개방. |
| S2-03 입찰·계약 | Q04의 358→359 거부, 359→360 검증용 직접 요청, 360→361 제품 버튼 접수 PASS. Q03 정산·접수 사본, Q05 계약·정부 지급 단회성, 기존 점수/동점/중복 근거 유지 [E01, E02]. | 새 필수 결함·GUI 추가 요청 없음. 점수86/80·동점·중복의 기존 수용을 20세션 신규 실행으로 합산하지 않음. | 해당 Q03/04 차단 해소. 향후 명령·원장 변경 영향은 DEV 검증. |
| S2-04 공사·기성·자금 보호 | DEV-020 모델·W05 A02-01~10·12·13 수용. 표준 착공2068→완공4948, 2880분/600000, C1200000/R200000/F1000000/K0/B0. 부족·미지급·중단/재개는 TEST_ONLY 범위. Q12-FIN·DEV-022 W05/R/K/B 회귀 연결 [E03, E05, E06, E12]. | 이 수용 범위의 추가 구현 요청 없음. 제품 결합 시 사업/공사/운행 권위 ID·R/K/B 표시 보존과 변경 영향 확인. | 기존 증거 재사용. DEV-023/024 실제 영향 행 검증. |
| S2-05 시험·안전·개통 | 표준 정상 및 빠른 합성 수리30분/재시험60분 수용. DEV-022 유효 개통 소비·미개통 제한, 실제 명령 기반 표준 개통→운행 모델 연결 제출 [E03~E06, E12]. | 제품 Session의 동일 권위 개통 소비와 필요 상태 GUI 확인. 빠른 공사 독립 전체 사업 E2E는 새 필수 조건 아님. | DEV-023/Design 제품 연결, DEV-024 표준 경로. |
| S2-06 실제 OD·도착 운임 | **모델 공급 완료·자동검증 제출·main 병합 완료.** 요청/탑승/미탑승/이동 중/완료, 소수 이월·공유U10·수요0·만족도·도착 운임 공급 [E12]. | 제품 Session opt-in과 실제 상태·열차 이동/정차·승하차 최소 피드백, 제한/잔여 도착 구별·Design 독립 인수. | DEV-023/Design, DEV-024 통합. |
| S2-07 정산·일일 보고 | SEM/CLOSE·Q05 유지. DEV-022 R/K/B 보호·자정 순서·잔여 도착 추가비0·B 우선 정산/재개·고정 보고 자동검증 제출 [E01, E09, E12]. | P07·보고 화면의 발생/현금지급/후정산, 현재/마감·예측/실적, 정상0/자료 없음/원본 실패 구별과 영향 인수. | DEV-023/Design. 실제 승인 의미 차이만 Planning, DEV-024 통합. |
| S2-08 실제 GUI | Q03·04·05 종료, W05·OBS-01/A02-11 한정 PASS·Q12 28조건 유지. **원래 P05 인계·복귀 6범위 증거 대조 완료·종료 가능** [E01~E05, E11]. | P06/P07·S01 최소 운영 표현·보고/다음 사업 제품 조작, 오류·0·자료 없음·현재/과거·revision 구분과 신규 GUI 독립 수용. Q12 오류 집계 정정은 별도 기록 잔여. | DEV-023/Design. 원래 P05 종료에 W06를 선행조건으로 붙이지 않음. |
| S2-09 다음 사업 조회 | DEV-022 MODEL_CHAIN의 실제 완료 통행·영업 실적이 있는 첫 마감 보고 후 다음 조회 공급 확인. **모델 공급 완료; 제품 조작 NOT_RUN** [E12]. | 같은 유효 보고를 제품에서 조회하고 다음 공고/후보로 이동하는 조작·관측. 영업0/완료0 보고로 성공 선언 금지. 두 번째 실제 수주 비범위. | DEV-023 조작 연결 → DEV-024 실제 완주 증거. |
| S2-10 VS-01 전체 완주 | W04A/W05 실제 실행과 DEV-022 모델 연결은 하위 증거. 단일 초기 상태부터 실제 제품 전체 완주는 **NOT_RUN** [E01, E03, E04, E07, E12]. | 독립 초기 상태 → B01 → 계약 → 표준 공사 → 시험/안전 → 실제 운행 → 첫 유효 실적 보고 → 다음 사업 조회의 실제 제품 입력·로그. | DEV-023 제품 경로 후 DEV-024. 자동 러너·강제 성공 fixture로 GUI 완주 대체 금지. |
| S2-11 교차 인수·기록 | 기존 DEV/Design 수용·PLN-005 개정, Q12 6범위 대조와 PR #123 모델·필수 CI 연결 [E01~E06, E09, E11, E12]. | DEV-023/024 증거·필수 CI·Design 독립 수용·필요 Planning 회신, 미해결/이월, HQ 통합·Owner 최종 결정. | 기록은 실행과 병행. 전체 S2 PASS·Stage DONE·관련 Issue 전체 종료는 별도. |

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

**상위 상태:** A01-Q12 PARTIAL은 기존 공식 상태로 보존한다. 본 표에서는 원래 인계 조건의 미충족을 해소하고 W05·OBS-01·A02-11 한정 PASS·Q12 28조건 수용을 별도로 유지한다. W06·VS-01은 S2-06~11과 DEV-023/024의 별도 인수이며 원래 P05 종료의 새 선행조건이 아니다. Issue 전체 종료·상위 Q12 PASS·Stage DONE을 선언하지 않는다.

**기록 잔여:** ERROR 2→7건 정정은 [E05]·[E11] 원문에 연결했다. 다만 원본 인계 기록까지 정정이 반영됐다는 완료 증거는 **NOT_VERIFIED**다. HQ는 기존 인계 기록의 정정 참조 여부를 확인·연결하고 Design은 필요한 원본 위치를 확인한다. GUI 재실행을 요구하지 않는다. DPI·환경 NOT_VERIFIED, R02 종료코드 NOT_CAPTURED 및 범위 밖 UNKNOWN/NOT_RUN을 보존한다.

## 4. 남은 필수 업무의 우선순위

| 순서 | 실제 업무·완료 산출물 | 담당·선행조건 |
| --- | --- | --- |
| 1 | DEV-023 실제 공급 계약 DEV022-W06-UI-1·fixture의 Design L2 대조, 실행 범위/권한 확인. 정상·오류·0·자료 없음, 현재/고정 보고, 사유/행동/권위 ID 대응. | DEV 공급·Design Track A 수용. 실제 해석 차이만 Planning. 모델은 이미 공급됨. 미확인 DEV-023 권한만 Owner 결정. |
| 2 | DEV-023 제품 Session 활성화, P06/P07·S01 최소 운영 피드백·보고/다음 사업 조작, 자동검증과 신규 실제 GUI·Design 독립 수용. | 해당 화면 통합 전 L2. 실제 상태·입력·효과·종료코드와 원본 증거 연결. 고충실도 아트 비선행. |
| 3 | DEV-024 실제 표준 VS-01 완주·변경 영향 회귀. 같은 실행 증거를 관측 범위 안에서 관련 S2 행에 공동 연결. | 재현 규격·색인은 병행 준비 가능. 전체 실행은 DEV-023 제품 경로 후. 개별 실행/Git 권한 확인. |
| 4 | S2-01~11 필수 증거·부서 수용·미해결/이월·필수 CI 종합, Owner 최종 인수·종료 기록. | HQ 기록 정리는 앞 단계와 병행. Q12 오류 집계 인계 정정도 기록으로 처리. Owner Stage DONE은 별도. |

F-08/Track B 규격·에셋 계약, Windows export/FPS 최종 인수, W04B/VS-02, POST-MVP 회사 상태 설계, F-12 운영 회고는 각자의 적용 시점을 유지한다. Stage 2 전체의 일괄 선행조건으로 올리지 않는다. P07 발생/현금지급/후정산 설명(F-02)과 UI 계약(F-10)은 해당 화면 통합 시 필수다. [E07]

## 5. DEV-022 공급 완료와 DEV-023·024 실행 경계

**DEV-022: MODEL_IMPLEMENTED / AUTO_VALIDATED / MAIN_MERGED.** PR #123의 제출 head `00be38d232308a4d4c01b203af8bab6122eed34c`, merge `e379e584e6a9fefa0c581f27903c16e4fc0f5136` 및 필수 policy·department-policy SUCCESS를 확인했다. `MinutePipeline.enable_operations()`로 명시적으로 활성화하는 모델 공급이며 제품 Session/View 연결은 DEV-023이다. [E12]

| 구분 | 완료 근거 또는 후속 필수 범위 | 담당·적용 시점 |
| --- | --- | --- |
| DEV-022 모델·증거 | W06 최종179단언·기존 회귀2485단언 PASS, 의도적 실패1건 exit1, Godot headless editor exit0/오류0. MODEL_CHAIN의 개통T4805→Day4 마감T5760, 완료4291·운임429100·운영비95500·다음 조회 가능. | DEV 기존 결과 연결. HQ 신규 실행 NOT_RUN. MODEL_CHAIN/통제 MODEL_FIXTURE/소비 fixture/GUI 구분. |
| DEV-023 실제 공급 L2 | operations_snapshot·reports.current/report·next_business_query, ID/revision·reason/allowed_actions 대조. 정상0·자료 없음·원본 실패·개통 전·재무 제한·현재/고정 보고 및 만족도 미산출/산술 한계의 가용성 구별. | DEV/Design, 해당 화면 통합 전. 공급 계약 버전은 Design 수용 자체가 아님. UI가 별도 원장·수요·운행 정책을 소유하지 않음. |
| DEV-023 제품 인수 | Session opt-in, P06/P07/S01의 실제 관측·열차/승하차 최소 피드백, 보고→다음 공고 이동, stale 거부 및 신규 GUI 독립 수용. F-02/F-10 포함. | DEV 자동/실GUI 제출, Design 독립 실행 또는 독립 실행 증거 심사. 기존 P05 일괄 반복 없음. |
| DEV-024 실제 완주 | B01→계약→표준 공사→시험/안전→실제 영업→첫 유효 실적 일일보고→다음 사업 조회. 명령/시각/원장/도착/보고·입력·종료코드·해시 및 영향 회귀. | 제품 연결 후 실제 마우스/키보드 경로. 실제 완료 통행·영업 실적 필수. 두 번째 수주·빠른 공사 전체 E2E 추가 의무 없음. |
| 담당·권한 | #79/#80의 초기 담당 AGT-DEV-0001·승인 대기는 작성 당시 기록. 현재 등록부 AGT-DEV-0004 ACTIVE와 DEV-022 권한은 확인되지만 **DEV-023/024 개별 구현/Git 승인 원문은 이번 확인에서 NOT_VERIFIED**. | 현 DEV/HQ가 유효 승계·작업별 범위 확인. 부족한 승인만 Owner 결정. PM-017 승인으로 DEV 후속 권한을 생성하지 않음 [E08, E10, E12]. |
| 승인 규칙·L3 영향 | C v0.7/D v0.9/DATA v1.4·SEM-01~03/CLOSE-01 유지. R01~03 결정·PLN-005 정식 개정 완료. 공통 시간·R/K/B·자정/잔여 도착·보고 변경 영향은 DEV 검증. | 새 정책 재선택 없음. 실제 승인 의미 차이만 Planning, 새 범위/규칙 변경만 RFC. DEV-026 구현·제품 검증 보류 유지 [E09, E12]. |

[DEV-022 공급·소비 계약](../engineering/gate3/DEV-022_W06_SUPPLY_AND_VALIDATION.md), [fixture](../engineering/gate3/DEV-022_W06_FIXTURES.json), [검증 JSON](../engineering/gate3/DEV-022_W06_VALIDATION.json)을 후속 작업 입력으로 사용한다. 검증 JSON의 실행별 소스 해시를 보존한다. 회귀 후 W06 전용 입력 검증을 보강하고 최종 W06를 재실행했으므로 회귀2485개를 최종 head의 신규 실행으로 소급하지 않는다.

DEV-022의 과거 '착수 승인 대기'와 공급 문서의 '로컬 검토/병합 대기' 헤더는 당시 이력이다. 최신 승인·제출·병합 근거 [E12]를 우선한다. DEV-023/024도 이미 유효한 권한은 재승인하지 않으며, 등록 지연이나 Q12 PARTIAL만으로 새 인수시험·전면 GUI 반복을 추가하지 않는다. 필요한 시점의 L2·제품 연결·영향 검증·필수 CI는 유지한다.

## 6. 공식 근거 색인

원문 판정·시험 SHA·과거 실패/미포착 기록을 보존한다. E01~E05의 기존 수용을 신규 실행으로 합산하지 않는다.

- **E01 — Q03·04·05 종료:** [Design 상세 판정 #75](https://github.com/wisberry2022/MetroManager/issues/75#issuecomment-6876401724), [상태 연결 #81](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6876407979), [공급 PR #117](https://github.com/wisberry2022/MetroManager/pull/117). 시험/merge SHA `a65591b1e632121cd6dab4b66a23424fe8803869`. 독립 초기 세션20 PASS/FAIL0/필수 NOT_RUN0, 종료·엔진·스크립트 오류0. Q05는 4경계×1/2/4배속12조합·정지/재개/T1800 완료. Design은 Owner 제출 독립 실행 증거를 심사했으며 DEV 자체 실행과 구별한다. 물리 DPI·실행자 등록 ID·일부 첫 복귀 입력 원인은 NOT_VERIFIED, 이번 한정 수용의 차단조건 아님.
- **E02 — QA-001/002:** [Design 수용 #81](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6717973962), [PR #85](https://github.com/wisberry2022/MetroManager/pull/85). 시험 main `8f8cc57d71b42b8c5132e93e24475caa052db273`. Q07 결함 해소와 개선 수용, 당시 기존 PASS7과 PARTIAL4 구별. 원래 개별 PASS7의 비공개 전체 보고서는 이번 HQ 재열람 NOT_VERIFIED. Q03~05 잔여는 E01, Q12 후속은 E03~E05로 연결.
- **E03 — W05 기능:** [Design 판정 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6867023824), [PR #102](https://github.com/wisberry2022/MetroManager/pull/102). 시험 SHA `58bbde35bed88df9138b40d13588fe7382127a30`. A02-01~10·12·13 명시 범위 수용; A02-13은 자동 보조. 당시 A02-11 PARTIAL은 E04로 갱신. 표준 정상 제품과 TEST_ONLY 자금/빠른 공사 반례 구분.
- **E04 — OBS-01:** [독립 재검수 수용 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6869633367), [보완 PR #106](https://github.com/wisberry2022/MetroManager/pull/106). 시험 SHA `73a1ada09f15c72e9bb68efbd3c54ca605952012`. A02-11 키보드·스크롤·포커스 한정 PASS. 정상 표준 공사 착공2420→완공5300, 개통16850→16851 및 P05 왕복. 환경 ERROR·DPI 미확인은 별도 보존.
- **E05 — Q12 28조건:** [Design 한정 수용 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6873738131), [입력 공급 PR #111](https://github.com/wisberry2022/MetroManager/pull/111). 시험 main `d1773e3d6f1ef04ab3f994854affce7908e71a17`, 공급 head `d3281b52d9f9415dff7e30c3a49dd1f04d1fa6ad`. 문자열18+LF2+권위/시점/재원8. 자동662와 독립 GUI28조건은 별도. A01-Q12 상위 PARTIAL, 새 반복 GUI 요청 없음.
- **E06 — 기존 모델·계약 원본:** [DEV-018 W04A 공급](../engineering/evidence/DEV-018_SUPPLY_AND_VALIDATION.md), [DEV-019 UI 계약](../engineering/evidence/DEV-019_UI_CONTRACT.md), [DEV-020 결과](../engineering/tasks/DEV-020_RESULT.md), [W05 공급](../engineering/evidence/DEV-020_W05_SUPPLY_AND_VALIDATION.md), [DEV-021 UI 공급](../engineering/evidence/DEV-021_W05_UI_SUPPLY_AND_VALIDATION.md). 과거 arrival_fare fixture와 PR #123 이후 실제 operations 공급 [E12]를 구별.
- **E07 — 승인 범위:** [PM-014](PM-014_STAGE2_VS01_EXECUTION_PLAN.md), [PM-015 / 병합 PR #113](https://github.com/wisberry2022/MetroManager/pull/113). #113 merge `6e9ae33eba3437e2aa38ba2627e7e70643581568`. 하위 수용의 보존, 영향 행만 재개방, 독립 실행/심사 구별, 빠른 전체 E2E 추가 의무 없음, Track B/F-08 적용 시점 준수.
- **E08 — 담당 티켓:** [DEV-022 #78](https://github.com/wisberry2022/MetroManager/issues/78), [DEV-023 #79](https://github.com/wisberry2022/MetroManager/issues/79), [DEV-024 #80](https://github.com/wisberry2022/MetroManager/issues/80). 확인 시 OPEN. #78 제목/본문의 초기 승인 대기는 PR #123 이후 현재 구현 상태가 아니다. #79/#80의 공개 실행 승인 대기와 비공개 추가 승인 NOT_VERIFIED를 구분하고 실제 유효한 승계/권한을 대조.
- **E09 — 승인 의미·정식 개정:** [Gate 2 최종 승인](../planning/PLN-001_GATE2_FINAL_APPROVAL.md), [Owner R01~03 결정 #26](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6719007539), [DEV-020 연결 #76](https://github.com/wisberry2022/MetroManager/issues/76#issuecomment-6719012772), [PLN-005 결과](../planning/tasks/PLN-005_RESULT.md), [병합 PR #108](https://github.com/wisberry2022/MetroManager/pull/108). #108 merge `6fbb9e400f9c185814c465935c30c9739d49f6db`. C v0.7/DATA v1.4 정식 반영 완료. 이후 POST-MVP 회사 상태 문서는 현행 W06 MVP 범위를 자동 확장하지 않음.
- **E10 — 담당 연속성:** [전환 규정](../infra/agents/REGISTRY_TRANSITION_RULES.md), [등록부](../infra/agents/registry.json), [PR #115](https://github.com/wisberry2022/MetroManager/pull/115), [PR #116](https://github.com/wisberry2022/MetroManager/pull/116). 기준 main에서 AGT-PM-0002·AGT-DEV-0004 ACTIVE. 등록 상태는 신원 인증이나 후속 티켓 Git 권한이 아니다.
- **E11 — 원래 Q12 대조 완료:** [Design 상세 #77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6885431567), [상태 연결 #81](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6885439128). 대조 기준 `f13b97d4871e8c73452134fb64c06e1fc919d779`, 게시 확인 `e379e584e6a9fefa0c581f27903c16e4fc0f5136`. 초기 시험 `06274e8557a8bbe4d8880fd02aac892c15e49f98`. Design이 DSG-010_QA_EVIDENCE.zip 7,643,211 bytes / SHA-256 `1e273b7457a71a3ef972affafba9950cafc36f22e3d4322f25e00f68bccd8169`의 manifest123/123 크기·해시·CRC를 확인하고 E03/E04를 연결. HQ의 ZIP 재검증 아님. Design도 W05/OBS 원본 ZIP의 이번 재해시는 수행하지 않음.
- **E12 — DEV-022 공급 완료:** [병합 PR #123](https://github.com/wisberry2022/MetroManager/pull/123), [승인 티켓](../engineering/tasks/DEV-022_W06_OPERATIONS_MODEL.md), [결과](../engineering/tasks/DEV-022_RESULT.md), [공급·검증 인계](../engineering/gate3/DEV-022_W06_SUPPLY_AND_VALIDATION.md). 제출 head `00be38d232308a4d4c01b203af8bab6122eed34c`, merge `e379e584e6a9fefa0c581f27903c16e4fc0f5136`. 정상 자동2664단언 = W06 179 + 기존 회귀2485. 실제 제품 GUI·VS-01·Design L2/독립 GUI·HQ 통합·Owner Stage DONE은 별도 잔여. 제출 head의 [policy](https://github.com/wisberry2022/MetroManager/actions/runs/43600827545)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/43600827846) SUCCESS. [출처 CI](https://github.com/wisberry2022/MetroManager/actions/runs/43600827805)는 REPORT_ONLY이며 신원/승인 인증 아님.

PR #123은 공통 minute_pipeline·daily_ledger_report 및 새 운행 모델/시험을 변경했다. 제품 Session/View와 tender_view·w019_ui_fixtures는 변경하지 않았다. 이전 표의 'Q03~05 시험본 이후 Planning 문서만 변경'은 PM-016 당시 설명이며 현재 범위에 재사용하지 않는다. 공통 변경의 기존 자동 회귀 [E12]와 후속 실제 UI·통합 인수를 분리하고, 확인된 영향 행만 재검수한다.

Owner가 과거 전달한 DEV의 미게시 로컬 문서4개는 직접 검증 NOT_VERIFIED로 보존한다. 이번 HQ 기록은 공개 공식 근거를 사용한다. 게임 명세 변경 필요 없음. [PM-017 티켓](tasks/PM-017_Q12_W06_ACCEPTANCE_UPDATE.md) / [검증 결과](tasks/PM-017_RESULT.md).
