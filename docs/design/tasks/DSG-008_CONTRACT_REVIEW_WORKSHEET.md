# DSG-008 — DEV 계약 수신 후 영향 대조 작업표

- 작업: DSG-008 / Design Track B / AGT-DSG-0003 / 2026-11-14 / v0.1
- 상태: LOCAL_REVIEW / CONTRACT_INPUT_PENDING / FINAL_SPEC_PENDING / NOT_DONE
- 기준 main: 49590f3f1b870fac2af7c77bb4cf179933699b8d
- 브랜치: codex/DSG-008-contract-review-readiness
- 결과·승인 범위: [후속 결과](DSG-008_CONTRACT_READINESS_RESULT.md)
- 기존 기준: [제품 검수 준비](DSG-008_PRODUCT_REVIEW_PREPARATION.md), [20사례 확인표](../assets/source/dsg_008/copy_exceptions/s01_acceptance_checklist.json), [v0.2 카탈로그](../assets/source/dsg_008/copy_exceptions/s01_copy_catalog.json)

## 1. 회신으로 완료된 것과 이번 준비

[DEV 회신 6873960483](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6873960483), 수정 시점 2026-11-14T07:39:58Z의 판정은 DEV_REVIEW_INPUT_RECEIVED / CHECKLIST_STATIC_MAPPING_CONFIRMED / EX_IMPLEMENTATION_PENDING / FINAL_SPEC_PENDING이다.

검수 준비3개와20개 case_id/copy_ids의 정적 연결을 DEV가 확인했다. 새 문구·배치 쟁점/L3 정책 질문은 없으며 다음 대조는 구체적인 공급/소비 계약·실제 경로·기대 행동 제안 시점이다. 별도 DEV 작업ID·정확한 경로·API·실행 권한은 아직 확정되지 않았다.

이번에는 이미 인계된20사례/표현을 보존하고, 회신의7개 영역을 **계약 수신·영향 대조 단위**로 연결했다. 이 묶음은 검수 최소 횟수나 새 필수 실행 행렬이 아니다. 같은28조건 반복이나 모든 문맥×키 조합을 새 요구로 추가하지 않는다. 실행 패킷의 실제 영향에 따라 해당 행만 사용한다.

## 2. 계약 수신 작업표 — 현재 전 행 CONTRACT_PENDING

아래 “DEV 입력”은 앞으로 회신/실행 패킷에서 확인할 내용이며 구현된 필드 목록이나 새 질문 발송 기록이 아니다. 해당 경로·조건을 DEV가 제안하면 기존 Design 의미와 차이만 기록한다.

| 대조 영역 | case_id | 유지할 Design 의미 | DEV 입력/대조 대상 | 현재 상태 |
| --- | --- | --- | --- | --- |
| 자료·행동군 | EX-01, EX-02, EX-17 | 초기 실패와 부분 미수신 분리, 지도/목록 공유 의존, 누락군 제한·독립 정보 | 필수 자료/타입·구조/버전·관측 소속, 공급/소비 책임과 행동군 연결 | CONTRACT_PENDING |
| 예측 | EX-04, EX-05, EX-06, EX-07, EX-08 | 현재/이전·유효0/미계산/실패, 동기 대기 강제 없음 | 현재 입력/계획 소속과 결과·기간, 적용/제외 경로·복귀 조건 | CONTRACT_PENDING |
| 재무·당일 관측 | EX-09, EX-10, EX-20 | 지역 검사와 신규 guard 구분,0 보완/재계산/전역정지 없음 | coherent·금액·같은 종류 관측판의 책임, 누락·타입 검증의 추가 영향 | CONTRACT_PENDING |
| 보고 | EX-11, EX-12, EX-19 | 확정 보고 자료 없음, 확인된 원인만 부연, 실패/key·런타임 소속 분리 | day/Session 소속·표시 key·없음/실패/유효0·복구의 실제 연결 | CONTRACT_PENDING |
| 결과·귀속 | EX-13, EX-14, EX-15 | 미상 사유·같은 Session 역행·새 Session·당시 결과/현재 행동 구분 | 실제 수신/생명주기·자식 소비자·이전 응답 배제와 요청 결과 연결 | CONTRACT_PENDING |
| 실제 pending | EX-16 | 일반 동기 S01 CP-S13 제외, 다른 경로 실제 pending만 조건부 | 승인된 해당 경로의 요청 ID/pending/효력/결과/최신 허용값, 제외 근거 | CONTRACT_PENDING |
| 실제 계획·복귀 | EX-03, EX-18 | 빈 계획과 미수신, 실제12후보와 별도 관할 오류 분리 | 실제 조건·유효 대상 선택/포커스와 소멸 시 기존 복귀 목적지 | CONTRACT_PENDING |

공통 복귀/포커스는 각 영향 영역에서 확인한다. 한 묶음의 계약/증거가 같은 조건을 포괄하면 같은 검토를 중복 요구하지 않는다. 계약이 미수신인 현재는 실제 표시/행동 결과를 채우지 않는다.

## 3. 수신 후 사용할 기록 서식

아래 필드는 검토 기록용이며 게임 payload 필드가 아니다. 현재 값은 모두 미수신/미실행 상태다.

| 기록 필드 | 현재 값 / 작성 기준 |
| --- | --- |
| DEV 제안/승인 근거·작업ID·full SHA | PENDING — 실제 자료 수신 후 링크 |
| 영향 영역/case_id·현재 경로/조건 | PENDING — 위7영역 중 실제 영향만 |
| 적용/제외 판단과 근거 | PENDING — 동기 경로의 제외를 비동기 구현 요구로 바꾸지 않음 |
| 기존 Design 의미와의 차이 | 미판정 — 차이가 있는 행만 L2 |
| 공급/소비 책임·자료/행동 의존·생명주기 | PENDING — 실제 계약 인용, 새 API 창작 없음 |
| 유지 가능한 기존 증거 | PENDING — 원래 SHA/경로/조건·증거 범위로 확인 |
| 추가 증거가 필요한 이유/영향 행 | PENDING — 의미 변경·증거 공백 등 구체 근거 |
| 입력→기대→실제·로그/화면·선택/포커스 | 실제 결과 없음 / 증거 없음 / NOT_RUN |
| Design 판정·다음 담당 | CONTRACT_PENDING / DEV 제안 수신 후 해당 영향 대조 |

실제 실행 후에는 기존 검수 준비의 NOT_RUN·INCONCLUSIVE·ISSUE_OBSERVED·NO_ISSUE_OBSERVED/조건 한정 구분을 따른다. 제외 경로는 근거와 함께 EXCLUDED_FROM_PATH로 기록할 수 있다. 이 작업표를 만든 사실만으로 값을 PASS로 바꾸지 않는다.

## 4. 증거 재사용과 검수 착수 조건

1. DEV 계약/실제 경로/영향 case_id·Owner 실행 범위가 확인되면 의미 차이를 우선 대조한다. 차이가 없으면 기존 Design 입력을 다시 승인받을 질문으로 만들지 않는다.
2. 기존 증거를 사용할 때 원래 SHA·관련 소스 차이·환경/상태·조작·관측 범위를 연결한다. 원본의 실패/미포착/미실행도 보존한다.
3. 달라진 의미·경로·상태/입력 또는 입증되지 않은 복구/포커스에 한해 추가 증거 필요를 구체 기록한다. 정확한 실행 범위·빈도는 DEV 패킷 및 HQ/Owner 결정에 따른다. 포괄 검수 면제나 새 필수 조합 수를 정하지 않는다.
4. 자동 단언·직접 GUI·정적 소스·fixture 관측을 각각 구분한다. 자동 성공/카드 선택/단일 화면만으로 실제 복구·모든 입력·가독성/성능을 수용하지 않는다.
5. 최종 계약 수신 전에는 이 작업표 작성으로 준비를 마친다. 다음 실제품 대조는 계약/변경/증거 수신에 따라 진행한다.

## 5. 최신 Track A 결과의 한정 연결

[Track A #77 판정](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6873738131)과 [#81 연결 기록](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6873744971)을 읽었다.

- OBS-01 수용 / A02-11 한정 PASS / QA-001·002 수용 및 Q12 이번28조건 한정 수용을 보존한다. A01-Q12 전체는 PARTIAL이다.
- 같은28조건의 반복 검수 요청은 없다. 향후 검수 빈도/범위와 상위 단계 판단은 HQ/Owner 후속 결정에 따른다. 이 기록으로 Track B나 전체 F-08을 닫지 않는다.
- 최초 로드 ERROR7개 기록(동일 stdout 중복 합산 없음), 후속 로드 오류0/exit0, R02 NOT_CAPTURED와 R30 별도 보완 증거의 구분을 그대로 인용한다. 원본 ZIP/로그를 이번에 독립 열람하거나 새 GUI를 실행한 것으로 주장하지 않는다.
- W05 한정 증거를 S01의 부분 자료/새 Session guard·모든 입력 문맥 PASS로 전용하지 않는다. 기존 문서의 “독립 재검수 대기”는 당시 snapshot이며 현재 상태는 위 후속 링크로 읽는다.

PR #111의 S01 호스트 변경은 공사 화면 읽기 키/포커스 처리다. 이번 S01 범용 guard·Session/보고 소속 구현 완료의 증거가 아니다. PR #112는 회사 재정 정책 문서 통합이며 Design 표현8개와 DEV 확인 항목은 별도 후속이다. 이번 작업에 새 서비스/재정 화면·규칙·영구ID/세이브·전역 재조회/취소 기능을 추가하지 않는다.

## 6. 미해결과 NOT_RUN

| 협의/적용 항목 | 상태 |
| --- | --- |
| 검수표3개/20사례 정적 연결 | DEV 수신·확인 완료 |
| EX 공급/소비 계약·제품 구현/인수 | OPEN / IMPLEMENTATION_PENDING |
| 이번7영역의 실제 계약 입력 | CONTRACT_PENDING |
| F08-01 | 환경·창/DPI·폰트/배율/가독성 OPEN |
| F08-02 | 픽셀/텍스트 필터·정수/비정수 배율 OPEN |
| F08-03 | 지도 밀집·긴 문자열·입력/포커스 OPEN |
| F08-04 | 재사용·인계·성능 측정 OPEN |
| HQ/Owner의 검수 범위·최종 규격 결정 | 후속 결정 대상 |

게임 자동 테스트·Godot 프로젝트 로드·GUI/키보드/플레이·부분 자료/새 Session/복구 실험·Windows 빌드·성능/폰트/DPI/필터·제품 접근성/외부 사용성은 이번 모두 **NOT_RUN**이다. CONTRACT_PENDING/OPEN은 협의 상태이며 테스트 결과가 아니다.

**최종 글꼴·치수·최소창·배율·배치·필터·FPS·표현 상한은 미확정**이다. 기존652브라우저 검사·W07/OBS-01/Q12 증거는 당시 범위로 유지한다. DSG-008 전체·S2-D01·Stage DONE 또는 제품 합격을 선언하지 않는다.
