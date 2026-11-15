# DSG-008 — DEV 회신 후 상태와 P06/P07 재대조 준비

- 작업: DSG-008 / Design Track B / AGT-DSG-0003 / 2026-11-15 / v0.1.
- 상태: **LOCAL_REVIEW / DEV_RESPONSE_RECEIVED / RECOMPARE_REQUIRED / FINAL_SPEC_PENDING / NOT_DONE**.
- 기준 main: `a9ce63a09e0778435bb8c7ef1fd0501aa10f430d`.
- 브랜치: `codex/DSG-008-dev026-p06-p07-recompare`.
- 범위·검증·검토 요청: [이번 결과서](DSG-008_DEV026_RESPONSE_RESULT.md).

## 1. 수신 근거와 과거 기록

[Design 전달](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6885445825)에 대한 [DEV 회신 6887686597](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6887686597)을 확인했다. 등록·수정 시각은 2026-11-15T02:03:59Z(한국 11:03:59)이다. DEV는 L2-A/B/C에 의미상 이견 없음, 포커스 복귀 순서 잠정 유지, 신규 P06/P07까지 재개 전 대조할 것을 회신했다. 계약 문서 개정·제품 검증 완료라는 회신은 아니다.

이 문서는 [기존 L2 사전 의견](DSG-008_DEV026_L2_DESIGN_REVIEW.md)과 [당시 결과·후속 제출 승인](DSG-008_DEV026_L2_REVIEW_RESULT.md)의 후속 상태다. 원본의 LOCAL_REVIEW·PENDING·NOT_SENT·NOT_RUN을 당시 기록으로 보존한다. [PR #122](https://github.com/wisberry2022/MetroManager/pull/122) 병합 SHA `f13b97d4871e8c73452134fb64c06e1fc919d779`, [PR #128](https://github.com/wisberry2022/MetroManager/pull/128) 병합 SHA `bf99dd11f3d8cd4d6dc07e38de164cd0b27f8dba`를 구분한다. 최신 main까지의 후속 기획 문서 변경을 UI 신규 실행·수용으로 간주하지 않는다.

## 2. 현재 후속 상태

| 항목 | 이번에 기록할 상태·다음 처리 |
| --- | --- |
| DEV-026 L2-A 지역 제한 | 양측 의미상 이견 없음. 지역 의존·독립 영역·자식 호스트 경계는 최신 구현에 재대조 필요 |
| DEV-026 L2-B 실행 소속 | 양측 의미상 이견 없음. 새 Session의 전체 View/자식 수명·옛 응답 배제는 제품 구현/증거 후속 |
| DEV-026 L2-C 선택/포커스 | 양측 의미상 이견 없음. 기존 계획 목록→유효 후보→기존 제목의 fallback은 실제 검증 전 잠정 |
| DEV-023 공급·표현 L2 | [Track A #79 판정](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6886354300)으로 L2-01~04 및 **RFC-DEV-023-01** L2-A/B/C ACCEPTED. 화면 연결 전 공급 요청을 중복하지 않음 |
| DEV-023 구현·DEV 검증 | PR #128 병합. [공급계획 §10](../../engineering/gate3/DEV-023_UI_SUPPLY_AND_EXECUTION_PLAN.md), [결과 §9](../../engineering/tasks/DEV-023_RESULT.md), [행별 검증 §9](../../engineering/gate3/DEV-023_UI_VALIDATION_PLAN.md)에 연결. 개발 자체 실행을 Track B 신규 실행으로 합산하지 않음 |
| DEV-023 독립 GUI | [Track A 최신 #79](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6887692818) / [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6887698478): **21조건 한정 PASS / 전체 PARTIAL**, 보완3조건. 전체 PENDING이라는 이전 snapshot과 구별 |
| DEV-026 계약 문서·제품 | CONTRACT_PROPOSED / OWNER_IMPLEMENTATION_DEFERRED 유지. 회신 수신과 문서 개정·RFC 종결·제품 수용은 별개 |

RFC-DEV-023-01의 수용을 RFC-DEV-026-01의 최종 확정으로 전용하지 않는다. 후자는 양측 사전 의견 일치·선행 후 재대조 필요 상태이며 원격 계약 문서를 이번에 수정하거나 CLOSED 처리하지 않는다.

## 3. P06/P07 추가로 재대조할 항목

아래 RP 번호는 **문서 대조 행 식별자**다. 새 제품 상태/API, 테스트 수·GUI 실행 횟수 또는 새 필수 전체 행렬이 아니다. 현재는 기준 소스의 정적 관찰과 재개 전 확인 대상을 연결했으며 최종 재대조·제품 인수는 미완료다.

| ID·연결 | 기준 소스의 현재 관찰 | DEV-026 재개 전 확인·기대 의미 |
| --- | --- | --- |
| RP-01 / L2-A / EX-01·02·17 | Host `present`가 P06/P07에 전체 state를 전달하고, 새 패널은 operations_ui/finance_ui/next_business_ui를 소비한다. 기존 계약안의 자식 경계 설명은 주로 Tender/Construction 대상이다. | 실제 새 자식·세 봉투를 지역 의존표에 포함할지 DEV가 명시. root 미확인과 단일 자식 오류를 구분하고 이전 현재 입력이 남지 않음. 깊은 자식 guard 개편은 자동 범위 확장하지 않음 |
| RP-02 / L2-A / EX-09·10·17·20 | P06 실적은 operations_ui, 운임/운영비 부연은 finance_ui를 읽는다. P07은 현재 재무·당일·report·조회 봉투를 별도 소비한다. | 한 봉투 실패를 모든 화면의 전역 실패로 확대하지 않음. 현재/과거 출처·행동 의존을 구체 대조. 새 관측의 누락을 이전 금액/허용값 또는0으로 채우지 않음 |
| RP-03 / L2-B / EX-14 | Host와 P06/P07에 shown이 있고 View판·모델분/판 역행 검사가 있다. `reset_observation`은 새 패널 shown도 비운다. | 이 초기화만으로 새 Session 전체 안전을 입증하지 않음. P06/P07 인스턴스·선택일·범위 캐시·확인 보고·피드백까지 새 실행으로 이관되지 않는지, 새 scope 낮은판/old scope 높은판/같은판 remainder를 구분 |
| RP-04 / L2-B·C / EX-14·17 및 복귀 | Host는 `_screen_history`, `_report_return`, Control 포커스 참조와 스크롤 문맥을 보관하고 signal로 보고 선택·조회를 연결한다. `_restore_reading`에는 프레임 대기가 있다. | 새 View 재생성·옛 process/input/signal/callback 차단에 새 패널과 대기 중 복원도 포함할지 확인. 사라진/다른 실행 Control을 되살리지 않고 숨은 패널 명령·중복 신호를 남기지 않음. 기술 방식은 DEV 소관 |
| RP-05 / L2-B / EX-11·12·19 | root.report는 직전 마감일 요약이다. finance_ui.report는 LATEST_CLOSED 또는 FIXED_DAY의 선택 마감일이며 day/key/value를 갖는다. | **root의 clock.day−1 조건을 P07 FIXED_DAY에 그대로 적용하지 않음.** 기대일은 해당 선택 문맥·허용 범위와 대조하고 binding의 실행 소속·실제 key/value를 함께 확인. 자정 뒤 고정 선택 보고를 현재값으로 덮지 않음. 영구ID/세이브 추가 없음 |
| RP-06 / L2-A·B / EX-13·15·17·19 직접 영향 | P07은 표시한 첫 실적 보고의 key/day/완료·서비스분·운임과 next_business_ui를 대조한 확인 사본을 Session에 전달한다. Host는 accepted=true일 때 P01로 이동한다. | 오래된 확인 사본·다른 실행/보고일을 현재 조회 근거로 쓰지 않음. query 허용과 실제 조회 성공·응찰 가능을 구분. 과거 거부가 현재 허용을 덮지 않으며 읽기/왕복으로 원장·시간·계약을 변경하지 않음 |
| RP-07 / L2-C / EX-03·13·15·공통 복귀 | P05/S01→P06/P07, P06→P07, P07→P01→보고 복귀 동선과 보고일·선택·포커스/스크롤 보존이 추가됐다. | 현재 화면 안의 유효 목적지를 기준으로 fallback을 재대조. S01 전용 순서를 P07에 기계적으로 강제하지 않음. 사용자 이동을 빼앗지 않고 대상 소멸은 선택 없음. 같은 Session 복구와 새 Session 초기화를 별도 취급 |
| RP-08 / L2-A·C / EX-04~08·13 직접 영향 | P06 실제/예상·만족도, P07 재무/고정보고의 한국어 표현은 Track A 수용 범위를 따른다. S01에는 대표 운영선/표식이 추가됐다. | 새 일반 미수신 안내와 기존 상태 문구가 충돌하는 행만 대조. 원분수/미산출/오류/정상0과 현재/이전 예측을 보존. 미확인 시 남는 대표 표식/클릭도 해당 입력과 일치하도록 확인 |

정적 근거: [Host](../../../scripts/ui/stage1_view.gd)의 `present/reset_observation/_reading_context/_restore_reading/_select_report/_query_business`, [P06](../../../scripts/ui/operations_view.gd)의 `present/is_older/packet`, [P07](../../../scripts/ui/finance_view.gd)의 `present/_update_days/_update_query`, [Session](../../../scripts/ui/stage1_session.gd)의 공급·선택·조회. 현재 코드의 결함을 재현한 표가 아니며 신규 구현 알고리즘을 확정하지 않는다.

특히 RP-05는 기존 [DEV-026 계약 §4](../../engineering/gate3/DEV-026_S01_EXCEPTION_CONTRACT.md)의 S01 직전일 보고와 새 선택 보고의 **적용 문맥 차이**다. 게임 정책 변경이 아니라 재개 시 기술 계약의 적용 범위를 명시할 필요다. 실제 충돌/범위 확장이 확인되면 [RFC 양식](../../templates/RFC_AND_DECISION.md)에 따라 해당 차이만 DEV/HQ/Owner에 상정한다.

## 4. 기존 증거 재사용과 Track A 잔여 연결

최신 Track A IG1115A 판정은 원본 CASE_MATRIX의 21조건에 한정된 독립 실행 증거 심사 결과다. Track B가 원본 ZIP을 다시 열거나 GUI를 독립 실행한 결과가 아니다. 전체 DEV-023 독립 GUI PARTIAL과 A01-Q12 상위 PARTIAL은 서로 별도로 보존한다.

| Track A 잔여·상태 | DEV-026 대조와의 연결 |
| --- | --- |
| 보완-1 / IG-06 U11 / P07 과거 보고를 선택한 뒤 늦은 응답 / NOT_RUN | RP-03·05·07의 **같은 Session/Host** 표시·key/본문·허용·포커스·스크롤 보존 증거 후보. 새 Session/old scope 차단의 증거로 확대하지 않음 |
| 보완-2 / IG-08 U18·19 / 긴 한국어 불가 사유·작은 창 / NOT_RUN | RP-08의 읽기/버튼 접근성 및 F08-01·03 참고. 특정 조건 수용을 최종 폰트/최소창/DPI 확정으로 바꾸지 않음 |
| 보완-3 / IG-08 U17 / P05 이동 직전 scroll>0 왕복 / NOT_RUN | RP-04·07의 기존 복귀 문맥 증거 후보. scroll0의 기존 수용을 비영점 증거로 전용하지 않음 |

이3조건은 Track A가 이미 정한 보완 범위이며 이번 Track B의 새 실행 요청이 아니다. #79 정본에 한 패킷으로 후속 연결하고 #104에서 같은 보완을 중복 발송하지 않는다. 수용된21조건·공급 L2·Q03~05·W05·OBS-01·QA-001/002·A02-11·Q12 28조건/원래 P05 인계 수용을 자동 재개방하지 않는다.

원본 보조 도구의 과거 바이트 NOT_VERIFIED, 도구 timeout 중단·종료4294967295, 초기 import/환경·물리 DPI NOT_VERIFIED, 기존 R02 NOT_CAPTURED 등의 원래 기록도 보존한다. 관련 소스/계약/환경의 영향과 실제 관측 범위가 맞는 증거만 재사용하며 [PM-015](../../hq/GUI_REVIEW_PROTOCOL.md)에 따라 부족한 행만 보완한다. 필수 자동 회귀/CI는 면제하지 않는다.

## 5. 재개 시 받을 입력과 종료 구분

1. DEV는 DEV-022~025 선행 결과 후 최신 통합 full SHA·유효 실행 범위·실제 공급/자식 수명/동선과 계약안 차이를 제시한다. 위 RP행 중 영향 있는 항목, 기존 EX/copy_ids 적용/제외와 추가 증거 이유를 함께 연결한다.
2. Track B는 기술 계약의 의미 차이를 묶어 대조한다. Track A의 DEV-023 공급 L2 수용을 재요구하지 않으며 기존 독립 GUI 수용·보완 결과는 실제 범위로 재사용한다. 계약 문서 반영과 구현/제품 수용의 종료는 구분한다.
3. DEV-026 제품 구현·검증은 기존 Owner 선행 순서와 유효 권한에 따른다. 이번 로컬 문서가 재개 승인이나 새 P06/P07 전체 개편·깊은 봉투 검증 권한을 부여하지 않는다. 정확한 일정은 NOT_ESTIMATED이다.

EX-05의 소비 fixture/동기 제품 대기 제외, EX-16 일반 S01 CP-S13 제외, EX-18 격리 외부역 입력 구분을 유지하고 재개 때 실제 경로만 재확인한다. F-08 전체 확정을 최소 UI/DEV-026의 새 일괄 선행조건으로 만들지 않는다. DEV-024 자연 VS-01·HQ/Owner 상위 인수도 별도다.

## 6. F-08 미해결과 NOT_RUN

| 기술 협의 | 상태 |
| --- | --- |
| F08-01 환경·창/DPI·글꼴/가독성 | OPEN |
| F08-02 픽셀/텍스트 필터·정수/비정수 배율 | OPEN |
| F08-03 지도 밀집·긴 문자열·안정 ID 입력/포커스·가림 | OPEN |
| F08-04 재사용/인계·성능 측정·상한 | OPEN |

별도 추적은 [#92](https://github.com/wisberry2022/MetroManager/issues/92) / [DEV-025 #97](https://github.com/wisberry2022/MetroManager/issues/97)이다. 위 OPEN은 협의 상태이며 실행 결과가 아니다.

**이번 Track B 작업:** 게임 자동 테스트·Godot 프로젝트 로드·실제 GUI/키보드/플레이·부분 자료/새 Session/복구 실험·브라우저 검사·Windows 빌드/export·성능/폰트/DPI/필터·접근성/외부 사용성 검증은 모두 **NOT_RUN**이다. DEV-023의 실제 개발 실행과 Track A의 한정 수용을 취소하거나 전부 NOT_RUN으로 덮지 않는다. DEV-026 구현·제품 검증은 보류/NOT_RUN, 최신 P06/P07 계약 재대조·제품 수용은 후속이다.

최종 글꼴·치수·최소창·DPI/배율·배치·필터·FPS·표현 상한은 **미확정**이다. 기존 철도 모형 디오라마 MVP 방향과 MVP 이후 대규모 개편 가능성을 보존한다. 게임/경제/시간/세이브 명세 변경 필요는 현재 NONE이며 기술 계약 문맥 보완은 DEV 재개 시 검토한다. DSG-008·S2-D01·Stage DONE 또는 전체 제품 합격을 선언하지 않는다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008
