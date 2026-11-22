# DEV-027 — P3-A 수용 후속 및 P3-B 화면 통합 착수·검증 계획

- 작성: Development / AGT-DEV-0004 / 2026-11-22 KST.
- 상태: **LOCAL_PLAN_REVIEW / P3B_IMPLEMENTATION_VALIDATION_NOT_AUTHORIZED / REMOTE_NOT_SENT**.
- 기준 main: `cc8814097634013be8df8b27f166bdee09c7bac6` (PR #171 병합). 로컬 브랜치: `codex/DEV-027-p3b-screen-plan`.
- 이번 실제 변경: 문서 **7개**. 다음 P3-B 실행 후보: **최대19개**. 두 목록은 §6에서 구분한다.
- [티켓](../tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md) / [결과](../tasks/DEV-027_RESULT.md) / [공급 계약](DEV-027_W04B_SUPPLY_CONTRACT.md) / [전체 계획](DEV-027_EXECUTION_VALIDATION_PLAN.md).

## 1. Owner 요청과 화면 통합의 포함 여부

> 개발 에이전트. P3-A 수용 결과를 후속 기록하고, P3-B의 착수 범위와 실행·검증 계획을 로컬로 준비해주세요. 정확한 변경 경로와 Track A/B L2 확인사항·승인 필요 범위를 포함해주세요. 구현·검증 및 Commit·Push·PR·main 병합은 별도 승인하며, DI-03 보류와 기존 대기 상태는 유지합니다.
>
> 그리고 TrackA,TrackB가 통합 GUI 테스트 실행 조건으로 화면 통합 연결을 요구했으니 해당 범위가 이번 작업에 포함되는지도 확인해주세요

**화면 통합 연결은 이번에 작성하는 P3-B 계획의 구현 대상에 포함한다. 이번 실제 수행은 문서 작성·정적 대조까지이며 화면 코드를 구현하거나 게임을 실행하는 권한은 아니다.** P3-A 22경로 승인은 main/Host·제안 View를 제외했으므로 미래 P3-B 실행에 재사용할 수 없다.

| 단위 | 포함하는 일 | 현재 권한/선행조건 |
| --- | --- | --- |
| 이번 로컬 검토안 | P3-A 판정 연결, 화면 소비 제안·정확한 경로·행별 L2 질문·검증/승인 범위 | Owner 요청으로 허용. 게임 자동/로드/GUI는 실행하지 않음 |
| P3-B | 정상 main 진입 → 회사 제안 화면 → 실제 명령·상태 표시 → 같은 사업 P05/P06/P07·후보 조회/복귀 연결 | 해당 행의 남은 L2 차이 정리 + Owner의 로컬 구현·검증 승인 후 |
| P4 | 고정된 실제 제품 화면의 DEV GUI·독립 실행·Track A/B 공동 심사, 정상 자연 VS-02 | P3-B 제공과 검수 패킷·주체/환경/유효 권한 확인 후 별도. 현재 NOT_RUN |

L2는 화면 구현 전 소비·표현 계약을 검토하는 단계이고, GUI는 구현된 화면의 실제 동작을 확인하는 단계다. 화면 없는 P3-A에서 GUI를 먼저 요구하거나, GUI가 없다는 이유로 이미 수용된 P3-A 공급을 다시 미공급으로 되돌리지 않는다. 문서 검토 승인, 행별 Design 의견, 구현·검증 승인, Git 승인, main 병합 승인은 각각 구분한다.

## 2. P3-A 수용 기록과 재사용 증거

| 근거 | 확인한 결과 | 확대하지 않을 범위 |
| --- | --- | --- |
| [Track A #146](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7073746341), AGT-DSG-0004 / DSG-011 | **TRACK_A_P3A_L2_LIMITED_ACCEPTANCE**. UI01~10·13~14의 비의존 기능 공급/백엔드 연결, UI11의 제한·DI03 미공급 의미를 한정 수용. 기능 의미의 추가 필수 수정 없음 | 실제 Control·입력/표시/복귀·자연 VS02 수용 아님. UI12 종속 구현/수용 보류 |
| [Track B #146](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7073690611), AGT-DSG-0003 / DSG-008 | **P3A_SUPPLY_REVIEWED / TRACK_B_STATIC_NO_OBJECTION**. 공급·지역 guard·현재/당시·단계 의미에 이견 없음 | **SCREEN_ACCEPTANCE_PENDING / GUI_NOT_REQUESTED_NOW**. 실제 이전 채택본 저장·Control 수명/읽기/복귀·가독성 수용 아님 |
| [PR #171](https://github.com/wisberry2022/MetroManager/pull/171) | 제출 head `a9111742a74c7369ab7c52f5e24ef5ca51d2c217`, 병합 main `cc8814097634013be8df8b27f166bdee09c7bac6`; 두 tree `d102efa8e354c31118b569b2209ac3c9c496bb6d` 동일 | 병합 사실을 P3-B 실행·Stage DONE 승인으로 전용하지 않음 |
| [P3-A 증거 색인](../evidence/DEV-027_SESSION_PIPELINE_L2_EVIDENCE.md) / [실행 JSON](../evidence/DEV-027_SESSION_PIPELINE_L2_RESULTS.json) | 모델/연결677, 영향 회귀3204, Godot4.7.2 로드 오류0, 신규 runner2개의 의도 실패 exit1. 실제/fixture 표본31개. 시험 base `97cc5472f11a97d5f7d7c1b89dc12edeace36e1f` + 파일 해시 | 이번 신규 실행·독립 실행 또는 최신 main 자연 완주가 아님. projection은 전체 root/GUI 입력이 아님 |
| PR171 당시 CI | [policy PASS](https://github.com/wisberry2022/MetroManager/actions/runs/44980957811/job/137081121836), [department-policy PASS](https://github.com/wisberry2022/MetroManager/actions/runs/44980957722/job/137081124299), [출처 보고](https://github.com/wisberry2022/MetroManager/actions/runs/44980957695/job/137081123423) DECLARATION_CONSISTENT·진단0 | 위 head의 결과. 이번 미커밋 문서·미구현 P3-B CI가 아님. 출처 보고는 신원/승인 인증이 아님 |

기존 계약·증거·실패·NOT_RUN 원문은 보존하고 후속 절에서 현재 상태를 연결한다. P1 당시 “Session/Pipeline·봉투 미공급”은 과거 기록이며 현재 미공급은 실제 화면 소비 및 DI03 종속 구현이다. Track A 한정 수용을 Track B 화면 수용이나 전체 L2 완료로 바꾸지 않는다.

## 3. 실제 접점과 P3-B 포함·제외

기준 소스 본문을 대조했다. `project.godot`의 진입은 `scenes/main.tscn`, Host는 `scenes/stage1.tscn`이다. 아래는 아직 구현하지 않은 변경안이다.

| 현재 코드 | P3-B 최소 변경 제안 |
| --- | --- |
| `scripts/main.gd::_ready`는 `enable_operations_ui()`만 호출 | 기존 W04A/W05/W06 초기화 성공 뒤 `enable_proposals(seed)`를 같은 Session에 한 번 연결. 실패 시 기존 유효 기능은 유지하고 회사 제안 진입만 제한 |
| `stage1_view.gd`에는 제안 자식/진입·명령 연결 없음 | 정상 S01에 명시적 회사 제안 진입, 전용 View/씬, Session API 신호 전달, 공통 HUD 재사용. 화면 열기로 심사/계약/시계 변경 없음 |
| P3-A `request_proposal`·`proposal_result`·지역 guard는 존재 | 공급 API와 판정은 그대로 소비. 모델/Session/Pipeline 새 구현·리팩터링 제외 |
| `_open_construction/_close_construction`은 입찰↔P05 고정 | 출발 화면과 같은 사업/허가/계약 식별을 보관해 회사 제안↔P05도 연결. 기존 입찰 왕복 경로 보존 |
| `_query_business`는 조회 성공 후 P01로 이동 | 기존 공고 동선은 유지하면서 공급된 proposals로 이동할 명시적 선택을 Host에서 제공. 조회 성공만으로 새 슬롯 선택/심사/계약을 실행하지 않음 |
| `_reading_context/_restore_reading/retire`는 기존 자식 목록만 관리 | 제안 슬롯·사업·유효 읽기 대상과 자식 수명을 같은 Session의 문맥에 추가. 새 Session에는 옛 선택/봉투/Control/대기 복구를 이관하지 않음 |

**포함:** 정상 main·실제 화면 통합, 두 슬롯의 명시적 선택, 정보 읽기와 편집, 예측/심사/설득/허가·계약 표시와 명령, DI03 미공급 표시, P05/P06/P07 및 다음 후보 조회/복귀. 실제 사업 흐름을 실행할 수 있는 화면을 만드는 범위다.

**제외:** DI03 사건·동/OD·×5/4·carry·소비·재접수 구현, 모델 판정/시간/경제/세이브 규칙 변경, 공용 원장·시계 변경, 신규 수주까지의 VS02 종료 확대, F08 최종 수치/폰트/이름/아트 반입·전면 UI 개편, CI/정책/도구 변경. 새 GUI runner/관측기 작성이나 독립 실행은 이번 P3-B 후보에 자동 포함하지 않는다.

## 4. 화면 소비 계약안 — L2 검토용, 구현 전

### 4.1 진입·행동·지도/목록

- main에서 기존 운영 활성화 뒤 W04B 서비스를 한 번 활성화한다. 새 Session의 seed를 한 번 생성·기록하고, 검수 재현은 명시적 `--w04b-seed=<정수>` 초기화 인수로 기존 seed2/0/8/1만 사용하는 안이다. 기본 실행의 결과를 성공으로 고정하지 않는다. 인수는 초기 seed만 정하며 시간·금액·결과/계약 상태를 주입하지 않는다. 화면 왕복/새로고침/클릭에서 seed를 재설정하지 않는다. 인수 형식·허용값 검사는 main에서 수행하며 새 seed 탐색은 제외한다.
- Host의 “회사 제안” 진입과 P-A/P-B 선택은 읽기 문맥만 변경한다. 첫 진입은 선택 없음과 슬롯 선택 안내를 제안한다. 선택 소멸 시 다른 슬롯/사업을 자동 선택하지 않는다. 실제 기관·관할·사업 이름은 공급 필드만 사용한다.
- 새 View는 원본 root와 `proposal_ui`를 검증한 뒤 실제 슬롯의 `draft.plan`·예측·현재 행동과 당시 사본을 소비한다. 편집은 `edit_state`와 계획 행동, 예측은 `predict_state`, 시청/정부/설득/계약은 각각 `action_states`를 사용한다. 모델 계산·임의 허가액/가능 시각 계산은 하지 않는다.
- 지도/목록은 같은 안정 역ID를 연결한다. **정보 선택은 명령0**, 추가/제거/순서변경/이름 적용은 명시적 편집 버튼으로 분리한다. 기존 `stage1_map.gd`는 변경 없이 재사용하고, 검증한 실제 지도 좌표/간선과 선택 슬롯의 실제 계획을 렌더 입력으로 조합한다. 이 렌더 입력은 새로운 권위 root나 L2 원본으로 취급하지 않는다. 잠금 중에는 읽기 가능한 실제 역 정보를 목록으로 유지하고 편집만 차단한다.
- 실제 승인 역명12행은 미공급이다. 현 ID/동 정보의 읽기만 제공하며 전체 역명 수용으로 표시하지 않는다. 이름 loader/콘텐츠·캐시·정렬 규격 변경은 별도 N 범위다. 지도상 비활성 미포함역도 목록의 읽기 대상에서 누락시키지 않는 안을 Track B에 확인받는다.
- 명령은 마지막 유효 채택본의 scope·slot/binding·해당 decision 참조를 `request_proposal`에 보낸다. 한 요청의 중복 전달에는 같은 command_id, 사용자 명시적 새 요청에는 새 ID를 사용한다. UI가 과거 실패를 자동 재전송하거나 `requires_new_request`를 자동 실행하지 않는다. 단순 view revision 진전을 게임 자격 거부 사유로 추가하지 않는다.

### 4.2 L01~10 표시·행동 매핑 제안

문구는 Track B 검토안이며 게임 의미를 새로 결정하지 않는다. 값은 정수 금액/게임 시각·기간을 구분해 공급 그대로 표시하고, 내부 scope/revision/오류 코드는 일반 사용자 라벨로 직접 노출하지 않는다. 알 수 없는 사유는 “상태를 확인할 수 없습니다”로 표시해 진단 로그의 원 코드와 구분한다.

| 근거 / UI행 | 제안 표시와 구분 | 현재 행동의 권위·확인점 |
| --- | --- | --- |
| L01 / 01~03 | 선택 슬롯·현재 초안, “예측 전 / 현재 예측 / 이전 예측(비교용)”. 기간·예상 운임/운행비·사업성의 단위 표시 | 실제 edit/predict 상태. 읽기는 편집/예측 명령을 내지 않음 |
| L02 / 04~05 | “접수 대기”와 HUD “일시정지”를 별도 표시. 요청·등록·접수 예정·실제 접수·완료 예정 시각 구분 | 공급된 pending/review 시각. UI 타이머로 접수/판정 생성 금지 |
| L03 / 04 | “당시 요청 처리 실패 / 입력 변경 / 새 요청 필요”와 현재 접수 가능 사유를 별도 표시 | submission/당시 result와 현재 action_states. 같은 ID 재요청 효과0 |
| L04 / 02·05~07 | “심사 중 · 편집 잠금”, “당시 시청 판정”, “현재 초안/예측”을 구분 | 잠금 중 읽기 유지. 과거 시청 승인을 변경 초안의 정부 접수 자격으로 표시하지 않음 |
| L05 / 09~10 | “보류 당시 계획”, “현재 초안”, 설득 “요청 대기 / 접수·기회 사용 / 결과” | 사용 시점은 유효 접수. 현재 초안 편집으로 보류 사본/단회 기회를 교체하지 않음 |
| L06 / 08·10·13 | “허가 금액 / 사업계약 대기 / 계약 효력 / 실제 지급”을 분리. 800000/640000은 해당 실제 허가 사본의 값 | 계약 행동과 지급 확인 별개. 허가만으로 공사 이동을 유효 인계로 표시하지 않음 |
| L07 / 11~12 | “추가 사실 자료 미공급 · 재접수 제한” | DI03_PENDING을 “적격 사실0건”으로 표시하지 않음. 실제 재접수 활성화 제외 |
| L08 / RP·EX | “현재 제안 상태 확인 불가”와 유효한 독립 자금/보고를 구분 | 지역 무효 시 제안 명령 제한. root 무효/old scope 처리는 아래 표 적용 |
| L09 / 13~14 | 같은 사업의 공사→운영→첫 유효 보고·다음 후보. 현재금과 선택한 확정 보고일 분리 | 기존 P05/P06/P07 공급·보고 확인 사본. 조회는 계약/심사 명령이 아님 |
| L10 / 03·06 | 유효0은 숫자0, 미계산은 “예측 전”, 실패는 “예측 실패”, 과거 결과는 비교용 표시 | 음수/0/실패 fixture 한계 보존. 표시 fixture를 자연 발생/기능 수용 증거로 사용하지 않음 |

### 4.3 채택본·거부·복구·수명

제안 View가 Session에서 받은 expected_scope 및 마지막 **채택한 proposal packet**을 소유해 `Contract.proposal_region(root, scope, previous)`에 전달한다. Host의 기본 `inspect`만으로 previous 검사를 대체하지 않는다. 채택 실패한 응답을 previous나 선택/현재 행동으로 저장하지 않는다.

| 입력/전환 | 제안 소비안 | 독립 정보·복구 |
| --- | --- | --- |
| 유효 새 봉투 | 실제 채택 후 previous·현재 화면 갱신. 유효한 선택/읽기 위치 유지 | 사용자 이동을 자동 포커스로 덮지 않음 |
| 동일 봉투 재수신 | 읽기 재사용, 새 명령·RNG·지급0 | 선택/스크롤 초기화 없음 |
| old scope/낡은 root·view | 해당 늦은 응답/callback 폐기. 마지막 정상 채택본을 늦은 응답으로 덮지 않음 | 새 scope로 교체된 Host에는 어떤 옛 문맥도 복원하지 않음 |
| 같은판 상충·제안 지역 누락/오류 | previous 보존, 제안 현재 상태는 미확인 표시·관련 행동 차단. 과거 사본을 현재로 제시하지 않음 | 현재 root의 유효 자금/보고는 독립 유지. 정상 guard 통과 봉투로 복구하고 명령은 자동 재시도하지 않음 |
| root 필수자료 무효 | 관련 현재 표시/명령을 미확인 처리. previous는 판 대조용으로만 보관 | root가 확인되지 않는데 자금/보고를 현재 정상으로 표시하지 않음 |
| 대상 소멸·지역 복구 | 사라진 선택 없음. 제안 슬롯 선택→읽기 제목 등 해당 화면의 유효 fallback 순서를 제안 | S01 전용 순서를 P07/제안에 일괄 복제하지 않음 |
| 새 Session | 기존 `replace_session/retire`에 제안 자식·신호·히스토리 포함, 새 Host/자식 재생성 | 옛 process/input/지연 복원은 기존 세대·scope 경계로 차단. 자동 증거와 OS 관측 가능성을 구분 |

### 4.4 P05/P06/P07·후보 조회와 복귀

- 계약/지급의 유효 사업 식별과 허가 계획을 그대로 P05에 넘기고, 돌아올 출처(입찰/제안)·slot/business/decision·선택·스크롤을 Host에 보관한다. `construction_view.select_project`를 재사용하고 back 라벨/목적지만 출발 문맥에 맞춘다. 공사 규칙·표준/빠름 비용/기간·시험/안전/개통은 변경하지 않는다.
- P06/P07 열기·읽기·보고일 선택은 기존 View를 재사용한다. 같은 Session의 일반 재진입과 저장 문맥 복귀를 구분하고, P07 FIXED_DAY와 report_key/first_valid_report를 기존 계약대로 유지한다. 사업/보고 확인 사본 불일치는 현재 조회 권위를 따른다.
- 다음 후보 조회 성공 뒤 기존 P01 경로와 보고 복귀는 유지한다. Host에 명시적 제안 후보 이동을 추가하되 실제 반환 proposals가 유효할 때만 허용한다. 조회 결과 읽기와 새로운 회사 제안의 편집/심사·새 수주를 구분한다. 신규 후보로 이동한 뒤에도 보고 복귀 문맥을 잃지 않는지 검사한다.
- 자동 포커스 복구는 같은 화면·세대·소속이고 사용자가 포커스를 옮기지 않은 경우에만 수행한다. PageUp/Down·Home/End 읽기와 Tab 이동은 기존 Host 규칙을 확장한다. 기존 일4 복귀 증거를 일1 미관측에 대입하지 않는다.

## 5. Track A/B L2 확인표와 중단 범위

아래 행은 **제안/확인 대기**다. 위 P3-A 판정은 이미 유효하며 재수용 대상이 아니다. 이 표/기존 L01~10 링크를 공동 입력으로 사용하고 같은 준비표를 별도로 반복 생성하지 않는다. 이번에는 이슈에 게시하지 않는다.

| ID / 영향 행 | Track A 확인 | Track B 확인 | 남은 판단과 적용 시점 |
| --- | --- | --- | --- |
| B01 / UI01~03 | 정상 main·슬롯 선택과 정보 선택 명령0, 실제 편집/예측 권위 | 진입/선택 없음·목록 읽기·ID 임시 표시와 이름 미공급 경계 | §4.1 동선·읽기/편집 분리. 해당 화면 연결 전 |
| B02 / UI03~07·L01~04/L10 | 현재 행동/당시 요청·계획/예측/시청 사본 분리 | 문구·단위/기간·시간 외/정지·0/실패/미계산·키보드 접근 | §4.2 라벨·배치 역할. 해당 표시/명령 연결 전 |
| B03 / UI08~11·13·L05~07 | 보류/설득 사용·허가/계약/지급·실패 제한 의미 | 사본 제목·접수/사용 시점·DI03 미공급 표시 | UI12 실제 발생/재접수는 제외. 비의존 행 전체 보류 아님 |
| B04 / 공통 RP·EX·L08 | 무효 공급 때 기능 명령0, 독립 유효 지역 유지 | previous 실제 소유/갱신, old scope·동일판, 무효/복구·수명 기대 | §4.3의 채택/폐기/제한 표. 제안 소비 연결 전 |
| B05 / UI13~14·P05/P06/P07 | 같은 사업/허가 계획/지급, 실제 조회와 새 수주 구분 | 화면별 복귀 대상·유효 포커스/스크롤·보고 문맥·새 Session | §4.4의 입찰/제안 분기와 기존 P07 구분. 해당 동선 연결 전 |
| B06 / 공통 시각·가독성 | 실제 기능/읽기 접근의 영향 행 | 현재 기본/fallback·세로 스크롤/기존 배치 원칙 사용. 실제 이름/지원환경·최종 폰트 규격 미확정 | #92 입력이 필요한 행만 별도. P3-A 재검증이나 전체 F08 확정을 공통 차단으로 추가하지 않음 |

새 표현 선택은 Track B의 해당 행 확인으로, 기능 의미 차이는 Track A와 대조한다. 실제 게임 명세 충돌/부서 범위 변경이 발견되면 `docs/templates/RFC_AND_DECISION.md` 형식으로 해당 쟁점·영향·담당을 특정한다. 현재 새 게임 명세 변경 요구는 없으며 PLN016 A1+B1 정책 선택을 다시 질문하지 않는다.

## 6. 정확한 변경 경로

### 6.1 이번 실제 로컬 문서 — 7개

| 번호 | 경로 | 변경 |
| --- | --- | --- |
| D1 | `docs/engineering/gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md` | 신규: 본 P3-B 계획·L2·권한/검증 경계 |
| D2 | `docs/engineering/gate3/DEV-027_W04B_SUPPLY_CONTRACT.md` | 기존 본문 보존, P3-A 판정/화면 소비 후속 링크 |
| D3 | `docs/engineering/gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md` | P3-A 공급 한정 수용·P3-B/P4 구분 후속 |
| D4 | `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md` | 최신 P3-B 후보/승인 경계 연결 |
| D5 | `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md` | 이번 Owner 요청·실제7경로·미실행 권한 기록 |
| D6 | `docs/engineering/tasks/DEV-027_RESULT.md` | 수용 후속·로컬 문서 결과/검수 요청 |
| D7 | `docs/engineering/tasks/DEV-027_PROVENANCE.json` | 이번 base·문서6개 blob 출처. P3-A manifest는 PR171 고정본/원본 보관 |

### 6.2 다음 P3-B 구현·자동/로드 검증 후보 — 최대19개, 현재 미승인

이 목록은 기존41경로/P3-A22경로의 포괄 실행 승인이 아니다. **제품7 + 검사3 + 문서/증거9**만 제안한다. `수정` 경로라도 실제 필요가 없으면 변경하지 않는다. 다른 경로가 필요하면 이유와 영향 행을 먼저 재검토하며 임의 대체하지 않는다.

| 번호 | 종류 | 정확한 경로 | 최소 목적 |
| --- | --- | --- | --- |
| 1 | 수정 | `scripts/main.gd` | 같은 Session의 W04B 단회 활성화·초기 seed/명시 재현 인수·실패 격리 |
| 2 | 수정 | `scripts/ui/stage1_view.gd` | 실제 진입·자식/명령, P05/보고/후보 왕복·입력/수명 경계 |
| 3 | 신규 | `scripts/ui/proposal_view.gd` | 실제 Control·slot/읽기 선택·채택본·허용 행동·신호 |
| 4 | 신규 | `scripts/ui/proposal_view.gd.uid` | 위 신규 소스 UID |
| 5 | 신규 | `scripts/ui/proposal_presentation.gd` | 공급값→라벨/사유/시간·단위 매핑. 모델 판정 없는 표시 책임 |
| 6 | 신규 | `scripts/ui/proposal_presentation.gd.uid` | 위 신규 소스 UID |
| 7 | 신규 | `scenes/proposal_panel.tscn` | Host가 생성하는 실제 제안 패널 진입 |
| 8 | 신규 | `tests/game/run_proposal_view_tests.gd` | 실제 main/View·표시/신호·previous/복귀를 headless로 검사. P3-A API 검사의 독립 후속 |
| 9 | 신규 | `tests/game/run_proposal_view_tests.gd.uid` | 신규 검사 UID |
| 10 | 수정 | `tests/game/run_operations_gui_cases.gd` | 기존 main/P05/P07 호출의 직접 영향 자동 검사·입찰 동선 보존. 자동 Control 호출은 OS 실행 아님 |
| 11 | 수정 | `docs/engineering/gate3/DEV-027_SCREEN_INTEGRATION_PLAN.md` | 승인·실제 범위·미실행/변경 영향 후속 |
| 12 | 수정 | `docs/engineering/gate3/DEV-027_W04B_SUPPLY_CONTRACT.md` | 실제 소비 접점과 행별 Design 연결 |
| 13 | 수정 | `docs/engineering/gate3/DEV-027_SESSION_PIPELINE_L2_PLAN.md` | P3-A 원본 보존·후속 상태 링크 |
| 14 | 수정 | `docs/engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md` | 단계·영향/권한 후속 |
| 15 | 수정 | `docs/engineering/tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md` | 구현 승인 원문/실제 변경 목록 |
| 16 | 수정 | `docs/engineering/tasks/DEV-027_RESULT.md` | 검증·미해결·원 시험/미실행 구분 |
| 17 | 수정 | `docs/engineering/tasks/DEV-027_PROVENANCE.json` | 실제 base와 변경 blob |
| 18 | 신규 | `docs/engineering/evidence/DEV-027_SCREEN_INTEGRATION_RESULTS.json` | 새 자동·로드·직접 영향 결과/소스·로그 해시 |
| 19 | 신규 | `docs/engineering/evidence/DEV-027_SCREEN_INTEGRATION_EVIDENCE.md` | 행별 증거 색인·GUI/독립 검수 인계 |

읽기/실행만 재사용: `stage1_session.gd`, `s01_observation_contract.gd`, `stage1_map.gd`, `construction_view.gd`, `operations_view.gd`, `finance_view.gd`, 기존 씬·W04B 모델/서비스·검사/fixture. 수정 후보에 넣지 않은 파일의 변경 필요가 드러나면 해당 이유를 보고한다. `proposal_presentation`과 새 View 검사는 기존41개에 없었던 **이번 새 후보**이며 과거 승인을 주장하지 않는다. 신규 GUI runner·관측기/CI·도구·환경 설정·폰트/데이터/아트 파일은 19개에 없다.

## 7. 승인 뒤 실행·검증 계획 — 이번에는 NOT_RUN

### 7.1 실행 순서

1. B01~06의 제안·확인·제외/보류를 행별로 연결한다. 실제 기능 공급은 P3-A 고정본을 재사용한다. 미확정 표현/소비 계약을 최종 규격으로 단정해 구현하지 않는다.
2. Owner가 승인한 경로/동작을 티켓에 기록하고 최신 base와 공통 Host 변경을 대조한다. 본 19경로 승인과 각 행 L2 선행조건을 모두 만족한 범위만 진행한다.
3. 표시 매핑/제안 패널 → main·Host 연결 → 실제 P05/보고/후보 동선 순으로 구현한다. 새 Session/지역 거부와 중복 명령 경계를 함께 검증한다.
4. 아래 자동/회귀·프로젝트 로드를 수행하고 실제 파일 해시·정상/고의 실패·미실행을 분리한다. 원 P1/P3-A 결과·raw는 수정하지 않고 새 evidence2개를 생성한다.
5. 로컬 구현 결과를 Owner에게 제출한다. Commit/Push/PR/main 병합과 독립 실행/Design 화면 수용은 별도 범위다.

### 7.2 검사별 기대와 재사용

| 검증 | 필수 확인 | 실행/판정 구분 |
| --- | --- | --- |
| 새 View 자동 | 실제 main 진입/활성화1회·실제 자식, 슬롯/정보 선택 명령0, 편집/예측/4행동 payload·허용/거부, 현재/당시·단위·0/실패 표시 | `run_proposal_view_tests.gd`, headless 실제 Control. 합성 입력/fixture는 명시. OS GUI PASS 아님 |
| 지역·수명 자동 | last accepted previous 불변, 동일 재수신 효과0·같은판 상충·old scope·지역 누락/복구, 독립 자금/보고, 대상 소멸, 새 Session 옛 신호/대기 복구 차단 | 실제 소비자에 잘못된 사본을 공급하는 경계 fixture. 원본 Session 상태 변조와 분리 |
| 동선 자동 | 입찰→P05 기존 경로와 제안→P05, 계약/지급 식별, P06/P07 고정 보고/일반 재진입·저장 복귀, 후보 조회·제안 이동·보고 복귀, 사용자 포커스 이동 존중 | 새 View 검사 + `run_operations_gui_cases.gd --auto`. 일1 비영점 중첩 복귀 미관측을 자동으로 해결했다고 하지 않음 |
| 공급 재사용/회귀 | P3-A W04B·proposal_ui·vs02의 677개 기준, 기존 W07·tender_ui·construction_ui·operations_ui·s01_exception과 operations GUI 자동의 직접 Host 영향 | 기존 명령 재실행 결과는 새 식별로 기록. 정상 실패0·SCRIPT ERROR0, 기존 기준 감소/변경은 이유 명시 |
| 나머지 모델 | 시계/원장/W02~W06 모델·Pipeline·P1/P3-A 원본 소스 변경0 확인 | 기존3204 중 비영향 실행 재사용. 추가 경로/실패가 생긴 경우만 영향 테스트 확대 |
| 프로젝트 로드 | Godot4.7.2 `--headless --editor --quit`, 씬/신규 UID·참조·파싱 오류0 | 로드 PASS는 플레이/빌드가 아님 |
| 정상 종료·실패 감지 | 새 runner 정상 exit0+실패0+오류0 및 `--verify-failure-exit` exit1 | 고의 실패를 정상 실패와 합산하지 않음 |
| 정책/문서 | doctor/check·diff·경로·UTF-8/LF·provenance·원본 해시 | 승인/DONE·CI·Git 권한과 별개 |

계획 명령(모두 제품 실행 승인 후):

```text
<Godot> --headless --path <worktree> --editor --quit
<Godot> --headless --path <worktree> --script res://tests/game/run_proposal_view_tests.gd -- --output=<fresh-output.json>
<Godot> --headless --path <worktree> --script res://tests/game/run_proposal_view_tests.gd -- --verify-failure-exit
<Godot> --headless --path <worktree> --script res://tests/game/run_operations_gui_cases.gd -- --auto
<Godot> --headless --path <worktree> --script res://tests/game/run_proposal_ui_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_w04b_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_vs02_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_w07_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_tender_ui_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_construction_ui_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_operations_ui_tests.gd
<Godot> --headless --path <worktree> --script res://tests/game/run_s01_exception_tests.gd
```

신규 runner의 인수는 구현 제안이며 현재 파일/실행 결과가 아니다. OS 화면을 열지 않는 자동 Control 검사와 DEV 실제 입력·독립 실행을 분리한다. 실행은 증거마다 별도 로컬 저장 위치·환경/엔진 SHA·exit·로그 오류를 기록하고 과거 출력/실패를 덮어쓰지 않는다.

### 7.3 P4 GUI 재개에 넘길 한 공동 패킷

P3-B는 아래 조건 중 **실제 화면 제공**을 담당한다. 화면 제공만으로 독립 GUI가 자동 시작되지는 않는다.

- 고정 full SHA(미커밋이면 base+파일 해시), 실제 `main.tscn` 진입/명령·단계별 정상 조작 경로, 엔진/실행 명령·현재 환경과 기록 위치.
- B01~06의 해결·정확한 보류/제외, 해당 화면/행 변경 영향과 기존 증거 부족 이유, 필수 관측과 종료 기준.
- 실제/fixture·자동/DEV GUI/독립 실행/Design 심사 열을 분리. Track A는 UI01~14 기능/동선, Track B는 RP/EX·지역/표현·읽기/수명/복귀. 같은 고정본·공동 관측은 원 범위로 공유.
- 정상 초기 상태/실제 RNG에서 계약·지급→표준 공사→시범/안전→개통→실제 영업/첫 유효 보고→다음 후보 조회를 **실제 UI로 한 번** 연결한다. 실패 분기별 전체 E2E 반복·다음 실제 수주를 필수로 추가하지 않는다.
- 기존 `run_vs01_tests.gd` 관측 도구는 재사용 가능성만 대조한다. W04B 요청/사본·의도/결과 관측을 충분히 담는다고 아직 판정하지 않는다. 부족하면 정확한 관측 행/필드·최소 수정 경로를 별도 제시하며 이번에 runner를 만들거나 시험하지 않는다.
- 실행 주체·장비 접근·허용 동작·증거 보관과 기존 유효 권한을 확인하고 부족분만 승인 요청한다. 도구로 확인할 수 없는 내부 수명/옛 callback 등은 NOT_VERIFIED/INCONCLUSIVE로 분리한다.

P4 실행 명령은 위 실제 화면과 관측 경로가 고정된 뒤 확정한다. 임시 Control·직접 Session 호출·시간 점프·MODEL_CHAIN_SETUP·강제 분기는 자연 VS02 증거가 아니다. 합의된 단계 필수 미충족0이면 종료하고 범위 밖 미관측을 새 차단으로 추가하지 않는다.

## 8. 미공급 입력·유지할 대기와 승인 표

| 대상 | 현재 상태·후속 담당 | 차단 범위/승인 필요 |
| --- | --- | --- |
| P3-A 공급 | A 한정 수용/B 정적 이견 없음, DEV 기록/원 증거 재사용 | 같은 공급의 재작성/재수용을 P3-B 조건으로 만들지 않음 |
| P3-B B01~06 | DEV 본 제안 → A 기능/B 표현·RP/EX 확인 | 해당 화면 행의 필수 차이 정리 뒤 통합. 이 문서만으로 L2 완료 아님 |
| P3-B 실행 | Owner의 최대19경로 로컬 구현·자동/회귀·로드 검증 승인 미수신 | 현재 제품 구현·검증 NOT_RUN. 로컬 결과부터 검토 요청 |
| Git | 이번 로컬7개와 미래 구현19개 모두 별도 | Commit·Push·PR·이슈 회신 게시·main 병합/auto-merge 미허용. 과거 PR171 권한 재사용 없음 |
| GUI·독립/Design | 실제 P3-B 화면·한 고정 패킷·주체/범위 준비 전 | 별도 유효 권한 확인. 현재 NOT_RUN / SCREEN_ACCEPTANCE_PENDING |
| DI03 / UI12·11 일부 | PLN016 A1+B1 선택 완료. 실제 사건·수요/carry·소비·재접수 미공급/보류 | Owner 별도 지시 전 구현·검증하지 않음. 미공급 표시만 P3-B에 포함 |
| 이름 N | NR01~13 수신. 승인12행/콘텐츠 작성·승인 공급자/버전/locale 미공급 | HQ/Owner 담당 지정·콘텐츠 담당 공급 후 해당 N 적용. ID 읽기를 전체 이름 수용으로 대체하지 않음 |
| 환경 E / 폰트 F | E1 이월·현재 기본/fallback 방향 유지. 기준 PC/목적/배율/접근, 실제 폰트/권리·fallback 공급 잔여 | HQ/Owner·DEV·Track B. 해당 규격/환경 검증 전, 비의존 화면 전체 차단 아님 |
| 아트 A / F08 | DA01~08 수신·새 이미지 필수0. O01~07·S1/E1/F1/N1/A1/P1 선택 완료, 구체 규격 미확정 | 실제 신규 자원 적용 전 공급/권리·경로 확인. 전면 반입/새 벤치마크 없음 |
| 기존 수용/최종 인수 | Stage2 DONE·QA/Q12·DEV02324조건·DEV0241115A/1115B·#97 종료, DEV026 한정 수용/PARTIAL·미관측·P07 구분 유지 | 일4→일1 소급/과거 NOT_CAPTURED→PASS 금지. S3-10-C·S3-12/HQ·Owner 최종 인수 별도 |

## 9. 이번 로컬 검토 결과와 완료선

이번에는 승인된 문서7개만 준비하고 원격/소스 정적 대조·문서/경로/해시·정책 검사를 수행한다. 결과와 실제 검사 명령은 [결과서](../tasks/DEV-027_RESULT.md) §11 및 로컬 `.local/validation/DEV-027/p3b-plan/`에 기록한다. 이번 신규 게임 자동 테스트·Godot 로드·DEV GUI/플레이·독립 실행·자연 VS02·환경/폰트/아트 계측/반입·성능·빌드/export는 각각 **NOT_RUN**이다.

P3-B 향후 로컬 완료선: 승인 경로 안의 실제 정상 진입/소비/왕복이 구현되고, 해당 L2 필수 차이가 해결 또는 정확히 보류/제외되며, 필수 자동/로드 미충족0과 실제 고정본·GUI 인계 입력이 제시된 상태다. 독립 GUI/Design 최종 수용이나 DEV027 전체 DONE을 완료선에 몰래 포함하거나 완료로 주장하지 않는다. 일정/공수는 **NOT_ESTIMATED**이며 미정 행·실행 범위 확정 뒤 산정한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 10. P3-B 실행 승인과 L2 확인 후속 — 2026-11-22

Owner 승인 원문 — 본 개발 대화:

> DEV-027 P3-B의 로컬 구현·검증 착수를 승인합니다. Track A/B L2 조건과 B02 시각 표현 보완을 반영하여 최대 19개 경로 안에서 진행하고, 로컬 결과부터 검토 요청해주세요. Commit·Push·PR·main 병합과 독립 GUI 실행은 별도 승인하며, DI-03 보류와 기존 대기 상태는 유지합니다.

- 상태: **P3B_LOCAL_IMPLEMENTATION_IN_PROGRESS / REMOTE_NOT_SENT**. 앞 절의 작성 당시 미승인·미공급 기록은 보존하며 현재 권한은 본 절을 따른다.
- base: `1a24e3346d0ec46ca692fe54d5de5656913c3450`; 별도 로컬 브랜치 `codex/DEV-027-p3b-screen-integration`. 상세 계획 §6.2의 정확한 최대19경로(제품7·검사3·문서/증거9)만 허용한다.
- [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074162935) / [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074161321)의 B01~06 방향 확인 회신 완료. 기존 P3-A 한정 수용을 재심사하지 않으며 이 확인을 제품 PASS로 쓰지 않는다.
- B02 보완: `effective_not_before`는 접수 가능 최저 시각(성공 보장 아님), `admitted_at`은 실제 접수, `completes_at`은 실제 접수 기준 완료 예정이다. 효력 재검사 실패·명시적 새 요청과 현재 행동 사유를 구분한다. 기존 공급 필드/게임 규칙 변경 없음.
- 비의존 main/Host·제안 View·명령/상태·P05/P06/P07·후보/복귀를 구현하고 자동 Control/회귀·Godot 로드를 분리 검증한다. 실제/합성 입력/시간 환산을 구분하고 소스·실패 로그·원 시험 식별을 보존한다.
- 제외: DI03 실제 생성·수요/carry·소비·재접수, 새 규칙·모델/원장·CI·새 GUI runner·폰트/이름/아트 반입. 독립 GUI·자연 VS02·Design 화면 최종 수용은 별도 대기.
- Commit·Push·PR·main 병합·이슈 댓글·배포0. DEV026 한정 수용/PARTIAL·미관측·P07 구분, #92 규격/공급과 S3-10-C·S3-12 최종 인수 대기 유지.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 11. P3-B 로컬 실행 결과 — 2026-11-22

- 기준: `1a24e3346d0ec46ca692fe54d5de5656913c3450` + [실행 JSON](../evidence/DEV-027_SCREEN_INTEGRATION_RESULTS.json)의 최종 파일 해시. 신규 commit 없음.
- [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074162935) / [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7074161321) B01~06 방향 확인과 Owner 최대19경로 승인에 따라 구현했다. 현재 **LOCAL_REVIEW_PENDING / P4_GUI_INDEPENDENT_NOT_RUN / REMOTE_NOT_SENT**.
- 새 실제 View 자동 **225 PASS**, 영향 회귀 **3120 PASS**(그중 P3-A 모델/공급/VS02 재실행677), 정상 실패0·SCRIPT ERROR0. 새 runner 의도 실패 exit1을 별도로 확인했다. Godot4.7.2 최종 로드 exit0·오류0.
- 제품 코드는 main/Host와 새 proposal View/표시 매핑/씬에 한정한다. 모델·Session·Pipeline·원장·시계·기존 씬·자산/데이터·CI 변경0. 기존 UI 입력 공통 처리와 표시 helper를 재사용해 Host를1000행 이내로 유지했다.
- B02는 `effective_not_before`→접수 가능 최저 시각(성공 보장 아님), `admitted_at`→실제 접수, `completes_at`→실제 접수부터의 완료 예정으로 소비한다. 기존 게임 규칙·심사/난수/지급 계산 추가0.
- 자동 검사에는 실제 Control 신호/합성 키보드와 게임 시간 환산이 있다. 실제 OS GUI·독립 실행·자연 VS02·최종 가독성/물리 DPI·빌드/export·성능은 각각 NOT_RUN. 표시0/실패 등 사본 fixture는 실제 자연 발생과 분리했다.
- P1/P3-A 결과·실패/원본과 Markdown 원문을 보존했다. 비변경 추적774개·공유 데이터2개·별도 F08 문서9개 해시 일치. 검사 당시 CRLF 바이트는 로컬 보관하고 LF 정규화 외 변경0을 검증했다. 최종 로드는 LF 파일로 실행했다.
- DI03 종속 범위 보류, DEV026 한정 수용/PARTIAL·미관측·P07 구분, #92 실제 이름/환경/폰트/아트·최종 규격, S3-10-C·S3-12/HQ·Owner 최종 인수 대기 유지. 새 명세 변경/RFC 필요 없음.
- 로컬 제출 검사: `.venv/Scripts/python.exe tools/policy.py doctor` 및 `check` PASS(793파일/68 GDScript), `git diff --check` PASS. 정확한19경로·18개 provenance blob·UTF-8/LF·원문 보존을 재확인했다. 원격 필수 CI는 PR 미생성으로 NOT_RUN이다.

원 계획의 LOCAL/미승인/미구현 문구는 당시 기록이다. §10 승인과 본 실행 결과를 현재 상태로 연결하며 본문/원 검증 기록을 보존한다. B01~06 구현 방향 확인 대기는 회신 완료이고 실제 화면·독립 GUI 수용 대기는 유지된다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 12. 통합 GUI 심사 후속과 남은 최소 범위 — 2026-11-22

- 근거: [Track A 자연 VS02 결과](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075072443), [Track B 최종 증거 심사](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075447846). PR #174는 main에 병합됐으며 양 Track 고정 시험본과 이번 기준 main은 `37596bd6d646f9d0454280477e60a2e652f06613`이다.
- Track A의 정상 자연 VS02 관측 구간 PASS, Track B의 관측18행 **TRACK_B_P3B_GUI_LIMITED_ACCEPTANCE / OVERALL_PARTIAL**을 후속 연결했다. 전체 PARTIAL, B06-02/03 PARTIAL2와 신규 GUI NOT_RUN5를 유지한다. 이전 “독립 GUI 전체 대기/NOT_RUN”은 당시 이력이며 현재는 확인한 구간만 갱신한다.
- 확정 제품 결함은 보고되지 않았으며 DEV의 이번 확인도 새 제품 FAIL을 확정하지 않았다. 제품 재구현·전체 자연 완주 반복을 추가하지 않았다. [근거 매핑·최소 후속안·#146 회신 초안](../evidence/DEV-027_GUI_REVIEW_FOLLOWUP.md)을 준비했다.
- B06-02는 fallback/1프레임 ensure-visible/2프레임 저장문맥 복귀와 일반 P07 진입을 원 로그·캡처에 대응시켰다. 다른 focus로 이동하는 경쟁과 같은 focus의 휠/읽기 키 경합을 분리했다. 후자는 기존 자동 근거의 공백이며 원인 확정·수정 완료·OS PASS가 아니다.
- A manifest256개/B SHA256SUMS307개 재해시 불일치0, 댓글 핵심 SHA6개 일치. 기존 DEV 소스161개 및 raw로그12개·full view evidence도 일치. View225/회귀3120은 당시 실행을 재사용하며 이번 재실행이 아니다. A/B의 일4 실적·게임 시각과 seed8 지급 관측 범위를 서로 대체하지 않는다.
- DI03 실제 종속 구현·검증 HOLD, DEV026 한정 수용/PARTIAL·미관측·P07 일반 재진입/저장문맥 구분, #92 규격/입력 및 S3-10-C·S3-12/HQ·Owner 최종 인수 대기를 유지한다. 전체 Design 수용·필수 미충족0·DEV027 DONE·이슈 종료는 선언하지 않는다.
- 이번 게임 자동·프로젝트 로드·GUI/플레이·독립 실행·자연 VS02·빌드/export·성능·새 계측/반입은 각각 NOT_RUN. Commit·Push·PR·병합·이슈 게시0. 현재 **LOCAL_REVIEW_PENDING / 원격 미제출**이며 이번 결과로 추가 실행/Git 권한을 만들지 않는다.

이번 후속은 기존 §7.3 P4의 실제 화면·관측 패킷 공급 후 증거 대조다. 추가 GUI 전체를 시작 조건으로 되돌리지 않는다. KEYBOARD와 B06-02의 아직 미관측인 필수 Control/같은-focus 휠·복원 전이만 A/B 공동으로 범위를 확인한다. 코드 보완이 필요해질 때의 후보는 tests/game/run_proposal_view_tests.gd 1개이며, 실제 기대 위반과 합의된 기대가 확인되는 경우에만 scripts/ui/stage1_view.gd를 추가한다. 두 경로는 이번 문서5개 변경에 포함되지 않으며 신규 실행은 하지 않았다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 13. PR175 병합 후 키보드·포커스 잔여 계획 — 2026-11-22

[PR #175](https://github.com/wisberry2022/MetroManager/pull/175)는 main `1b80303636c5eddfbeddac9d288b0124b0093966`에 병합됐고 승인된 [#146 회신](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075655059)도 게시됐다. §12의 로컬 미제출/미게시 표기는 당시 이력으로 보존한다. 양 Track 시험 SHA37596bd부터 제품·테스트·씬·데이터·설정 차이0이며 기존 수용과 실행 증거를 재사용한다.

Owner의 새 지시에 따라 [키보드 접근·포커스/스크롤 검증 계획](DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md)을 로컬로 준비했다. K01~12 Control군과 F01~06 입력 순서, DEV 자동8개 경로 후보·재현 후 조건부 Host1개 추가, Track A/B 공동 확인 및 별도 독립 OS 실행 조건을 구분했다. 추가 구현·게임 자동/로드·GUI·Git 제출·원격 게시는 하지 않았다.

이번 변경은 새 계획·본 문서·티켓·결과서·provenance의5개 문서다. 기존 근거 문서와 원본 패킷은 변경하지 않는다. 계획의 후보 경로는 실행 승인이 아니다. DI03 HOLD, 기존 PARTIAL·미관측·DEV026 한정 수용·P07 구분·#92/F08 및 S3-10-C·S3-12/HQ·Owner 최종 인수 대기를 유지한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 14. 키보드·포커스 A 자동 보완 착수 승인 — 2026-11-22

Owner의 “계획서대로 구현 진행하고 PR까지 생성” 지시로 [잔여 검증 계획](DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md) §7.2의8개 경로와 §9의 제출 범위를 승인받았다. 기존 제품·씬·데이터는 보존하고 View 검사에 실제 합성 Tab 도달·단일 명령·같은-owner 지연 순서를 보완한다. F행의 미확정 우선순위는 원시 관측과 Design 판단 대기로 남긴다.

B 제품 수정과 C 독립 GUI는 별도 승인이고, 기존 자연 VS02·A/B18행 수용·PARTIAL·미관측과 DI03/F08/최종 인수 대기는 유지한다. 실행 결과는 [새 증거 색인](../evidence/DEV-027_KEYBOARD_FOCUS_EVIDENCE.md)과 결과서 후속에 연결한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 15. 키보드/저장 복귀 보완 구현 — 2026-11-22

후속 [검증 계획 §9·11](DEV-027_KEYBOARD_FOCUS_VALIDATION_PLAN.md)의 A8개 + B 제품1개 추가 승인을 이행했다. stage1_view.gd에서 제안 Tab 직전 비활성/빈 목록 제외와 follow_focus=false의 제안 ensure 존중만 보완했다. 기존 P3-B 화면 계약·명령·지급·DI03 규칙은 바꾸지 않았다.

[신규 증거](../evidence/DEV-027_KEYBOARD_FOCUS_EVIDENCE.md)는 View737/0·직접 영향 회귀1503/0·프로젝트 로드와 수정 전 실패를 별도로 연결한다. 동일 runner에서 Tab 정지점42개가 제외되어745→703단언이 되었고 실패44개가0으로 바뀌었다. same-owner restore5행의 우선순위 제안 불충족·휠/return10행 INCONCLUSIVE는 그대로 공개한다. 이는 신규 OS/독립 GUI·Design 재수용이 아니다. 기존 Track A/B 한정 수용·PARTIAL·DI03·DEV026·F08·S3-10-C/S3-12/HQ/Owner 최종 인수 대기를 유지한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
