# DEV-027 — P3-B 통합 GUI 심사 후속 근거·최소 보완 검토

- 작성: Development / AGT-DEV-0004 / 2026-11-22 KST.
- 기준 main·양 Track 시험 SHA: `37596bd6d646f9d0454280477e60a2e652f06613` ([PR #174](https://github.com/wisberry2022/MetroManager/pull/174) 병합본).
- 현재: **DEV_EVIDENCE_MAPPING_COMPLETE / LOCAL_REVIEW_PENDING / OVERALL_PARTIAL 유지**.
- 요청: Owner의 “작업물에 대한 통합 GUI 검증이 종료되어 결과가 146번 이슈에 등록되었으니 확인하여 후속 작업이 필요한 경우 진행” 지시.
- [Track A 결과](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075072443) / [Track B 최종 증거 심사](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075447846).
- 이번 작업은 원본·소스·기존 실행 증거 대조와 DEV 후속 기록이다. 제품 수정·게임 자동 재실행·새 GUI/독립 실행·빌드/export·새 계측/자원 반입은 **NOT_RUN**. 댓글 게시·Commit·Push·PR·병합은 하지 않았다.

## 1. 수용 결과와 판정 주체

| 근거 | 현재 인정 범위 | 유지할 한계 |
| --- | --- | --- |
| Track A / DSG-011 / AGT-DSG-0004 | `independent-20261122-a01` 정상 자연 VS-02의 동일 사업 완주 관측 구간 PASS | 전체 패킷 PARTIAL. KEYBOARD·마지막 왕복 뒤 내부 카운터·일부 raw RNG·신규 GUI 예외 미확인 유지 |
| Track B / DSG-008 / AGT-DSG-0003 | `DEV027-P3B-TrackB-20261122T-local01`의 B01-01~05, B02-01~03, B03-01~05, B05-01~04, B06-01: 18행 조건 한정 수용 | **TRACK_B_P3B_GUI_LIMITED_ACCEPTANCE / OVERALL_PARTIAL**, PARTIAL2·신규 GUI NOT_RUN5 유지 |
| DEV 기존 자동·로드 | View225 / 영향 회귀3120(P3-A 677 포함)·최종 로드, 당시 base+파일 해시로 재사용 | 실제 OS GUI·독립 실행·자연 완주·Design 판정으로 전용하지 않음 |
| 이번 DEV 후속 | 패킷 무결성, 기록 정정·대표 원본·raw QUERY/FOCUS와 소스/단언 대응 확인 | 새 실행이나 Design 재판정 아님. 확정 제품 FAIL 및 추가 명세 변경 요구 없음 |

실제 OS 실행은 Owner가 별도로 지시한 실행자, Design 심사는 각 Track, 이번 근거 매핑은 DEV의 수행으로 구분한다. 등록 신원이나 사람/계정 수준 독립성 인증을 추가 주장하지 않는다. 종전 문서의 GUI 전체 NOT_RUN/Design 대기는 당시 이력으로 보존하며 현재는 위 관측 구간·18행만 후속 수용을 연결한다. 전체 화면 최종 수용이나 필수 미충족0·DEV027 DONE·Stage DONE은 선언하지 않는다.

## 2. 원본·시험 식별과 재대조

| 패킷 | 원본 위치 — 프로젝트 기준 | 이번 DEV 확인 |
| --- | --- | --- |
| A | `.local/worktrees/DSG-011-track-a-20261122/.local/validation/DSG-011/independent-20261122-a01/` | manifest256개 재해시 불일치0. REPORT·manifest의 댓글 SHA 일치 |
| B | `.local/validation/DSG-008/DEV027-P3B-TrackB-20261122T-local01/` | SHA256SUMS307개 재해시 불일치0. REVIEW·CASES·RECORD_CORRECTIONS·SHA256SUMS의 댓글 SHA 일치 |
| DEV 원 실행 | `.local/worktrees/DEV-027-p3b-screen-integration/.local/validation/DEV-027/screen-integration/` | 기존 결과의 소스161개가 현재 시험본과 일치. raw 로그12개 및 view-03 전체 evidence 해시 일치. JSON224단언+저장성공1=225 |

- A REPORT: `98a4fdb26748ed6dc168450de9057f5c4b46426fb100161b4064541ad10cb2a5`
- A manifest: `9b7088c7b309563f59ba0f993cdbbba21ce77d269e1b83f8e6066c429042a71b`
- B REVIEW: `67f044bfa05af72965ae17ec91a7959b8bea7182251ab47637cf8bd24a08eaf6`
- B CASES: `638dfd0591dd7e4a758e229be1f713a2a3502eb041fdec8b75117a639c2a6052`
- B 정정문: `8319012cdfc412f827795e36f93db75e039bd4f62688b2c4fa887f433513c81d`
- B SHA256SUMS: `f92fc2a54d134c83c7bea0c918e3e932935333a16099ad48fbc053b5dc4c3250`

이번 DEV는 B JPEG 원본 **041/058/062/121/122/124 6개**를 직접 판독했다. 원본 전체 재판독이나 새 캡처가 아니다. B는 고유 캡처129개이며 JPEG129/PNG129를 258관측으로 더하지 않는다. A 캡처195개와 B 캡처129개도 하나의 실행으로 합치지 않는다. 원본·정정문·실패 기록·PNG/JPEG는 변경/반입하지 않는다.

A 원시 `gui-seed2-retry-engine.log:3658` QUERY와 B `run-seed2/stdout.log:4105` QUERY를 각각 파싱했다. 아래 값은 서로 다른 실행의 값이다.

| 값 | A 원 실행 | B 원 실행 |
| --- | --- | --- |
| QUERY 게임분 / 고정 보고일 | 6915 / day4 | 6049 / day4 |
| 완료 통행 / 운임 / 운영비 / 서비스분 | 4852 / 485200 / 108000 / 1080 | 1284 / 128400 / 28700 / 287 |
| QUERY 시 seed2 정부 RNG | sample50 / draw_count1 | sample50 / draw_count1 |
| QUERY 시 P-A | 판정 사본2, 사업계약1, 지급 거래 식별1 | 판정 사본2, 사업계약1, 지급 거래 식별1 |

QUERY에서 연결된 지급 거래 식별의 개수는 전체 원장 전수 덤프와 구분한다. **마지막 후보 왕복 종료 뒤** 새 raw QUERY는 없다. 이 표를 그 마지막 시점의 내부 효과0 확인으로 확대하지 않는다. B의 seed8 실제640000 지급 미관측은 보존하고, A의 별도 seed8 지급 관측과 DEV `actual_payment:8`은 각각 원 식별로만 연결한다.

## 3. 잔여별 기존 근거 매핑

자동 근거는 [P3-B 실행 JSON](DEV-027_SCREEN_INTEGRATION_RESULTS.json)의 정확한 단언 ID와 [원 증거 색인](DEV-027_SCREEN_INTEGRATION_EVIDENCE.md)을 따른다. 아래 PASS는 **기존 자동의 판정**이며 이번 신규 GUI 판정이 아니다.

| 잔여 / 현재 판정 | 재사용할 정확한 근거 | 부족 범위·후속 판단 |
| --- | --- | --- |
| A KEYBOARD / B06-02 PARTIAL | `synthetic_keyboard_slot`, `keyboard_read_effect0`, `reading_end_handled`, `reading_no_focus_jump`, `reading_follow_disabled`, `read_return_slot`, `read_return_scroll`, `return_respects_user_focus`. A187/188과 B040/041은 시청 요청 Tab/Enter, B121/122는 복귀 뒤 Tab 관측 | 합성 Enter/직접 grab_focus를 모든 Control의 OS Tab 도달로 확대할 수 없음. 미관측 Control군과 같은-focus 휠/지연 처리만 §5에 분리 |
| A DUPLICATION PARTIAL | `map_list_read_effect0`, `locked_read_effect0`, `pending_same_request_id`, `candidate_query_no_payment`, `candidate_query_no_rng`, `reading_roundtrip_effect0`; A/B 원 QUERY와 왕복 화면 | 후보 조회·이동의 자동 무지급/무추첨, 이후 P07→P06→제안 복귀 전체 snapshot 일치라는 서로 다른 단언 지점을 구분. 마지막 OS 왕복 내부 카운터 NOT_VERIFIED 유지. 현재 추가 runner 필수 근거 없음 |
| seed0/8/1 raw RNG NOT_VERIFIED | `normal_rng:0/8/1`, `persuasion_branch:0/8`, `actual_payment:2/8` 및 기존 W04B437·proposal_ui165·VS02 75 | 실제 화면 분기와 내부 RNG state/draw 확인은 별개. 실패 분기별 전체 E2E 반복 불필요 |
| B02-04 / L10 신규 GUI NOT_RUN | `zero_fixture_valid`, `zero_is_number`, `failed_fixture_valid`, `failed_is_not_zero`, 이전 결과 비교 단언 | 자연 유효0/실패 미관측 보존. 표현 변경 또는 특정 필수 공백이 확인될 때 해당 행만 관측 |
| B04-01~03 / L08 신규 GUI NOT_RUN | `same_packet_read/effect0`, `conflicting_packet_rejected`, `previous_not_replaced`, `old_scope_discard`, `old_scope_keeps_current`, `stale_view_discard`, `independent_funds`, `root_invalid_funds/proposal`, `recovered`, `new_session_no_selected_slot`, `retired_callback_no_effect` | 자동 사본 주입·수명 검증과 OS 가시성 분리. 정상 제품의 오류 주입/새 Session 교체 경로 미공급. 새 runner 작성/주입 실행을 이번 필수로 추가하지 않음 |
| B05-05 / 기존 일1·복원 경쟁 NOT_RUN | 기존 DEV026 `deferred_restore_respects_user`; P3-B `return_respects_user_focus`, DEV023 `U17_focus_restored/U17_scroll_restored` | 일4 GUI·자동 일3을 고정 일1 비영점 중첩 복귀로 바꾸지 않음. B06-02와 연결하되 별도 기대 유지 |
| B06-03 PARTIAL / F08 | B window DPI192·client1440×829의 해당 관측, #92의 기존 선택·실제 공급 잔여 | 내부 viewport/물리 DPI·전체 창 조합·최종 환경/폰트/이름/아트 인수로 확장하지 않음. 지정 지원환경/규격 공급 시 해당 셀만 검증 |

기존 DEV026 한정 수용/PARTIAL, P07 일반 재진입과 저장 문맥 복귀 구분, Stage2 및 #97 종료·과거 미관측을 보존한다. 위 남은 범위를 관측된18행의 수용 취소나 W04B 비의존 후속의 일괄 차단으로 삼지 않는다.

## 4. B06-02 원인·기대와 실제 증거 대조

소스 링크는 모두 시험 SHA 고정이다.

| 실제 경로 | 코드의 동작·기대 | 캡처/원 로그와 해석 |
| --- | --- | --- |
| [present](https://github.com/wisberry2022/MetroManager/blob/37596bd6d646f9d0454280477e60a2e652f06613/scripts/ui/stage1_view.gd#L263), [fallback](https://github.com/wisberry2022/MetroManager/blob/37596bd6d646f9d0454280477e60a2e652f06613/scripts/ui/stage1_view.gd#L976) | 갱신 전 소유하던 포커스가 비활성/숨김 등으로 무효이면 제안 P-A→뒤로→제목 중 유효 대체를 선택. 포커스 이동은 슬롯 명시 선택·심사 명령을 호출하지 않음 | B058은 P-A 포커스/상단 부근이며 계약대기 캡처가 아님. 로그2279행 seq29는 게임분997/P-A/scroll178. 계약 효력 뒤 버튼 무효와 fallback은 가능한 설명이나, 입력·프레임 완전 기록이 없어 그 캡처의 원인으로 확정하지 않음 |
| [proposal focus signal](https://github.com/wisberry2022/MetroManager/blob/37596bd6d646f9d0454280477e60a2e652f06613/scripts/ui/proposal_view.gd#L92), [ensure-visible](https://github.com/wisberry2022/MetroManager/blob/37596bd6d646f9d0454280477e60a2e652f06613/scripts/ui/stage1_view.gd#L616) | focus_entered→1프레임 대기→Session/화면 generation/대상 가시성/동일 owner를 확인한 뒤 ensure_control_visible. 다음 프레임에 진단 기록 | B040/041의 Tab/Enter와 로그1472행 seq22 시청 버튼/scroll493 대응. 소스는 명령을 다시 실행하지 않고 가시영역 이동을 수행. 휠 의도 침해의 유무까지 입증하지 않음 |
| [P05 복귀](https://github.com/wisberry2022/MetroManager/blob/37596bd6d646f9d0454280477e60a2e652f06613/scripts/ui/stage1_view.gd#L557), [restore](https://github.com/wisberry2022/MetroManager/blob/37596bd6d646f9d0454280477e60a2e652f06613/scripts/ui/stage1_view.gd#L780) | 출발 화면/선택/포커스/scroll 보관. 2프레임 후 같은 화면·generation·owner일 때 저장 문맥 복원 | B062 공사 버튼 focus, 로그2478행 seq34 게임분1292/Proposal_construction/scroll1411. 정상 저장 문맥 복귀를 뒷받침. 모든 지연 경합 PASS 아님 |
| P07 후보 복귀 / 사용자 Tab | 같은 restore 경로. 복원 대기 중 다른 owner로 이동하면 덮어쓰지 않음 | B121 공고 조회 focus, B122 자료 다시 확인 focus. 로그4199행 seq59 query2/884→4232행 seq60 refresh/884. 이 순서의 보존은 확인했으며 초단위 미만 휠 경합은 미확인 |
| [일반 P07 진입](https://github.com/wisberry2022/MetroManager/blob/37596bd6d646f9d0454280477e60a2e652f06613/scripts/ui/stage1_view.gd#L753) | 첫 실적 보고 버튼에 focus, ensure-visible로 해당 버튼이 보이도록 이동. 저장 문맥 복귀와 다른 경로 | B124 및 로그4288/4289행 seq62/63 first/scroll200. “일반 진입은 반드시 scroll0”이라는 기대가 아니며 새 결함으로 취급하지 않음 |
| [읽기 입력](https://github.com/wisberry2022/MetroManager/blob/37596bd6d646f9d0454280477e60a2e652f06613/scripts/ui/stage1_view.gd#L659) | Home/End/Page는 follow_focus=false로 읽기 위치 변경. Tab과 모든 InputEventMouseButton은 follow_focus=true. LineEdit/OptionButton/TextEdit의 읽기 키는 소비하지 않음 | 기존 자동은 End 및 **다른 owner**로 이동하는 경쟁을 검사. 같은 owner에서 휠/스크롤만 움직이는 순서는 별도 미확인 |

**좁혀진 미확인:** restore는 화면 generation과 owner 변경을 확인하지만 사용자 scroll 값/입력 세대 자체를 검사하지 않는다. ensure-visible의 follow_focus=false 조기 종료는 construction 자식에만 적용되고 proposal에는 동일 조건이 없다. 마우스 버튼 분기는 휠도 포함할 수 있다. 따라서 “복귀/초점 처리 대기 중, 같은 owner를 유지한 사용자 휠 또는 Home/End”와 이후 지연 ensure/restore의 순서를 기존 근거로 완전히 판정할 수 없다. 이는 **소스에서 특정한 검증 공백·경합 가능성**이며 B의 당시 입력 의도 침해를 재현·확정한 제품 FAIL이 아니다. 미관측을 PASS로 지우거나 증거 없이 제품 수정하지 않는다.

로그의 scroll 값은 위 특정 진단 시점의 실제 값이다. 모든 캡처/프레임의 정확 scroll 전수 측정이나 모든 입력의 시계열 동기화를 주장하지 않는다.

## 5. 최소 후속안 — 실행 전 범위 확인

| 구분 | 정확한 미관측·최소 방법 | 권한·종료선 |
| --- | --- | --- |
| K01 필수 키보드 접근 | 기존 A187/188·B040/041·121/122를 재사용. 회사 제안 진입, P-A/P-B, 역 정보 선택/계획 목록/이름, 추가·제거·위/아래·이름 적용·예측, 정부/설득/계약, P05·refresh·back의 **아직 OS Tab/Shift+Tab·Enter/Space 도달이 증명되지 않은 경로만** 상태별 확인. 비활성 Control skip·이름 편집 키 처리도 분리. 마우스 클릭 PASS를 순수 키보드 PASS로 세지 않음 | A/B가 공통 필수 Control/전이 목록을 확정하고 실행자·Owner 유효 GUI 범위를 확인한 뒤. 심사 결과별 전체 사업 재완주를 요구하지 않음. 확인 불가 상태는 그 경로만 NOT_VERIFIED |
| F01 같은-focus 스크롤 | P3-B의 명령 후 focus fallback/ensure와 P05→제안 복귀를 대상으로, 안정 상태 읽기·복귀 직후 무입력·같은 focus 휠/읽기 키·다른 focus Tab을 구분. 이미 수용한 P07 복귀는 증거 재사용, 필요할 때 해당 왕복만 관측 | 현재는 계획만. OS 입력/기존 focus 로그의 시간·owner·generation·scroll 대응이 부족하면 INCONCLUSIVE 유지. 새 runner/제품 계측은 자동 포함하지 않음 |
| D01 중복·RNG | 기존 자동·QUERY·가시 왕복으로 기능 근거 연결 완료. 마지막 OS 왕복의 내부 카운터는 원판정 유지 | Design/HQ가 마지막 지점의 어떤 필드를 필수로 요구하는지 특정할 때만 관측 수단 검토. 검토 후보: `tests/game/run_operations_gui_cases.gd`의 관측 필드 충분성 정적 대조. 현재 수정·실행0 |
| X01 GUI 예외 | B02-04/B04-01~03은 기존 자동/fixture 유지. 실제 변경 영향이나 필수 OS 관측 행이 생긴 경우만 최소 입력·필드를 명시 | 관측 수단 검토 후보는 `tests/game/run_s01_exception_gui_cases.gd`. W04B 공급/주입 충분성은 NOT_VERIFIED. 자연 VS02로 분류하지 않으며 이번 변경 경로에 포함하지 않음 |
| E01 환경/규격 | #92 지원환경·이름12행·폰트/권리/fallback·아트·성능 공급 시 해당 셀만 검증 | HQ/Owner·공급 담당·Track B 범위. B06-03 PARTIAL 유지, 공통 선행 차단 추가0 |

F01의 좁은 자동 보완을 별도로 진행할 경우 **검사 후보 경로는 `tests/game/run_proposal_view_tests.gd` 1개**다. 같은 focus의 휠/Home/End, 한 프레임 ensure와 두 프레임 restore의 입력 전후를 결정적으로 구분해 검증할 수 있다. 실제 기대 위반이 확인되고 기존 기대가 합의된 경우에만 **제품 수정 후보 `scripts/ui/stage1_view.gd` 1개**를 추가한다. 자동/코드 변경 승인이 없는 본 후속에서는 두 파일 모두 수정·실행하지 않는다. 회귀는 직접 변경 영향에 따라 proposal View·operations GUI·s01 exception/필요시 construction UI로 한정하고 전체 자연 완주 반복은 하지 않는다. 정확한 UI 기대가 달라져야 하면 기존 RFC 절차로 먼저 보고한다.

이번 Owner 요청의 원본 읽기·근거 대조·로컬 문서 후속은 수행했다. 이전 독립 실행자에게 부여된 GUI 권한을 DEV의 새로운 실행 권한으로 전용하지 않는다. Commit·Push·PR·main 병합, 신규 독립 GUI·계측/runner·제품 보완은 별도 유효 승인 범위를 확인한다. 구체 실행안과 변경 후보는 위와 같으며 이번 후속 전체를 재승인 대상으로 되돌리지 않는다.

## 6. 기록 정정·기존 대기

B 정정문을 우선 연결한다: 021 type_text는 성공 이름 입력 아님(022/023/034 사용); 031의377200은 산술 차액이지 별도 관측 표시값 아님; 056은 진행 중 HUD; 058 계약대기 미포착; 096 현재5역/097 당시6역 분리; 101 사용·129 실제접수·102 완료 시점 분리; 103 작은창/104 최대화와124 일반 진입 중간 위치 보존. B headless import exit0의 저장오류2개와 최초 files0 정책 검사도 유효 무오류 PASS로 바꾸지 않는다. 이후976파일/68GDScript 검사와 실제 GUI2개 정상 로드는 각 원범위로 유지한다.

A의 별도 import/로드 기록, DEV 최종 로드, B의 import 오류를 서로 대체하지 않는다. DI03의 정책 선택 완료와 실제 사건·수요/carry·소비·성공 재접수 HOLD/NOT_RUN을 구분한다. DEV026 한정 수용/PARTIAL·일1 미관측·P07 구분, #92 FINAL_SPEC_PENDING/F08-01~04 OPEN, S3-10-C·S3-12/HQ·Owner 최종 인수를 유지한다.

## 7. #146 회신 초안 — 미게시

> Development / AGT-DEV-0004 / DEV-027
> 시험 SHA37596bd의 Track A 정상 자연 VS02 관측 PASS와 Track B 관측18행 한정 수용을 후속 기록했습니다. 전체 PARTIAL과 신규 GUI NOT_RUN5·B06 PARTIAL2는 유지합니다. 확정 제품 결함은 확인되지 않아 제품 재구현·전체 재완주를 추가하지 않았습니다.
>
> A manifest256개/B307개 및 기존 DEV 소스161개·raw로그12개의 해시를 대조했고 원본을 보존했습니다. 두 실행의 일4 실적·게임 시각은 별도로 유지합니다.
>
> B06-02: fallback→지연 ensure-visible, 2프레임 저장문맥 복귀와 일반 P07 첫 보고 버튼 진입을 캡처·원 로그에 연결했습니다. B062는 공사 버튼 복귀, B121/122는 query→refresh·scroll884, B124는 일반 first/scroll200과 대응합니다. 다른 focus로 이동하는 경쟁은 기존 자동으로 확인됐지만, 같은 focus 상태의 휠/읽기 키와 지연 복원 순서는 미확인입니다. 현재 경합 가능성이지 당시 제품 FAIL 확정이 아닙니다.
>
> A KEYBOARD와 B06-02를 합쳐 미관측 필수 Control과 위 전이만 후속 범위로 제안합니다. 마지막 왕복 내부 카운터·seed0/8/1 raw RNG·B04 OS 예외는 원판정을 유지하고 기존 자동/QUERY 근거를 연결했습니다. 추가 OS 관측·runner/제품 수정은 해당 필드·경로와 유효 실행 범위를 먼저 확정하겠습니다.
>
> DI03 HOLD, DEV026 한정 수용/PARTIAL·P07 구분, #92 규격/입력과 S3-10-C·S3-12/Stage 최종 인수는 유지합니다. 이번에는 근거 매핑·로컬 후속 기록만 수행했으며 신규 게임 실행·Git 제출은 없습니다.

본 초안은 Owner 검토용이며 게시하지 않았다. 과거 댓글 게시 승인은 각각의 당시 초안에 한정하므로 이번 신규 회신 게시에 재사용하지 않는다.

## 8. 이번 로컬 산출물·검증

변경 경로는 아래5개이며 제품/검사/CI/디자인 원본 변경은 없다.

1. `docs/engineering/evidence/DEV-027_GUI_REVIEW_FOLLOWUP.md`
2. `docs/engineering/gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md`
3. `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md`
4. `docs/engineering/tasks/DEV-027_RESULT.md`
5. `docs/engineering/tasks/DEV-027_PROVENANCE.json`

검증·무결성 출력은 별도 worktree의 `.local/validation/DEV-027/gui-review-followup/`에 보관한다. 기존800개 추적 파일 중 변경4개를 제외한796개, 공유 수정 데이터2개, Design 패킷 원본과 기존 DEV 실행을 보존한다. 기존 Markdown3개는 원문 뒤 후속을 추가하고 이전 manifest는 기준 main에 보존한다. 정책 doctor/check·diff·정확한 경로/원문/provenance 검사는 최종 결과서에 기록한다. 게임 자동·프로젝트 로드·OS GUI·독립 실행·자연 VS02·빌드/export·성능·자원 반입은 이번에 각각 NOT_RUN이다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
