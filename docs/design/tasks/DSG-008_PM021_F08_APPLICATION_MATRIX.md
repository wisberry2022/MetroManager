> **현재 후속 — v0.2 로컬 반영안 / 2026-11-21:** [DEV 공동 확인 회신](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057935798)을 수신·대조했다. **DEV_RESPONSE_REVIEWED / PREPARATION_BOUNDARY_NO_OBJECTION / LOCAL_REVIEW_REQUESTED / FINAL_SPEC_PENDING / PRODUCT_APPLICATION_SCOPE_PENDING / F08_OPEN**. 아래 v0.1 원문·DEV_CONFIRMATION_PENDING·NOT_SENT는 PR160 준비 당시 이력이다. [#92 전달](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057792628)과 DEV 회신은 완료됐으며 최초 회신 대기로 되돌리지 않는다. 현재 효력의 반영 제안은 §6, 검토 결과는 [후속 결과서](DSG-008_PM021_DEV_RESPONSE_REVIEW_RESULT.md)를 따른다. 제품 공동 인수 완료나 이 로컬 개정안의 Owner 승인은 아니다.

<!-- 아래 v0.1 원문은 이력 보존. 현재 후속은 §6. -->

# DSG-008 — PM-021 승인 방향의 공통 적용 준비표

- 담당: Design Track B / AGT-DSG-0003 / 2026-11-21 / v0.1.
- 상태: **LOCAL_REVIEW / TRACK_B_PREPARED / DEV_CONFIRMATION_PENDING / FINAL_SPEC_PENDING / PRODUCT_APPLICATION_SCOPE_PENDING / F08_OPEN**.
- 기준 main: `fa968b94641d24e8d68b3c6cb903f9e809d02814`.
- [승인 방향 후속](DSG-008_F08_OWNER_OPTIONS.md#5-pm-021-후속--승인-완료7개와-규격적용-잔여) · [로컬 결과/범위](DSG-008_PM021_F08_FOLLOWUP_RESULT.md).

## 1. 근거·표의 효력

[Owner 결정](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335)·[PM021 Track B 요청](../../hq/requests/PM-020_DESIGN_B_STAGE3.md)·[DEV 요청](../../hq/requests/PM-020_DEVELOPMENT_STAGE3.md)·[S3-10 하위 인수표](../../hq/PM-020_STAGE3_EXECUTION_PLAN.md#61-s3-10-하위-인수적용-시점표)를 적용한다. O01~07 방향 승인·PR157 RD 심사·DEV025 공급은 완료이며 반복하지 않는다. 최종 규격/제품 적용은 미확정이다.

이 표는 **Track B가 준비한 공동 대조 입력 한 묶음**이다. DEV가 실제 변경 필요성·자기 티켓·정확한 경로·유효 권한을 확인한 최종 공동 제출본이 아니다. 아래의 제품 경로는 현재 소스의 조사 대상이며 수정 승인 목록/아키텍처 지정이 아니다. 현재 구현 편집0·신규 제품 실행0. DEV는 이 표에 행별 확인/이견을 이어 주면 되며 중복 보고서·새 티켓 발급을 먼저 요구하지 않는다.

제품 소스/시험/설정은 PR154 시험본 이후 현재 main까지 변경되지 않았음을 원격 diff로 확인했다. 따라서 기존 DEV025 실험은 원 시험본으로, DEV026 증거/Owner 수용은 원 범위로 재사용할 수 있다. 시험 runner 전환 호환의 DEV026 변경과 DEV025 원실험 바이트는 구분한다. 이번 작업은 재실행이 아니다.

## 2. O/M → 현재/변경0·경로·최소 검증·권한

| O/M·S3행 | 현재 만족·재사용/변경0 | 실제 경로·티켓 확인 대상 | 입력/기대·최소 검증 | 담당·적용 시점 | 유효 승인/부족 범위 |
| --- | --- | --- | --- | --- | --- |
| O01/M03 · S3-10-M03 | 현행 기본/fallback 유지 방향은 **현재 제품 변경0으로 유지 가능**. T01 대표 문자·글리프 근거 재사용. 시스템 후보와 번들 후보는 실제 채택 안 됨 | `project.godot`, `scenes/stage1.tscn`, `scripts/ui/stage1_view.gd`; 실험 `tests/game/f08_experiment_panel.gd::set_font`. 새 폰트 자원 경로/제품 티켓 **DEV 제안 필요** | 아래 F-CURRENT/F-SYSTEM/F-BUNDLE 분리. STR01~07·끝자리·부호/단위·fallback·행동 도달. 권리·버전/구성·목표 조건이 정해진 후보만 해당 입력 확인 | DEV 권리/공급·Track B 판독, 폰트 반입/지원 규격 확정 전 | 방향/정적 준비 유효. 새 font 다운로드/복사/번들·설정/제품 수정·export/타PC 실행·Git **미승인/미확정** |
| O02/M03 · S3-10-M03 | 1280×720/root1은 **비교 기준 유지**, 최소 지원 보장 아님. 현재 설정 변경0. 기존 창/배율 측정은 조건 한정 재사용 | `project.godot`의 canvas_items/expand, Host의 ScrollContainer/HBox; `tests/game/run_f08_gui_cases.gd`의 시험 창 조건. 최종 설정 변경 경로·티켓 **미확정** | 요청 client/실측 client·논리영역·OS배율 구분. 같은 상태/폰트·폭에서 long 끝까지 접근/버튼 도달. 목표환경 전수 재실험 비요구 | DEV 조건 공급·Track B 입력/가독성, 지원 수치 확정 전 | 보류 방향 승인 완료. 최종 지원 수치·추가 환경/실행 권한 **별도** |
| O03/M04 · S3-10-M04 | T02의 정수 nearest·별도 Label은 **격리 실험 충족**. 제품은 추상 draw/Control 지도이므로 실험 필터 설정을 제품 아트 적용 완료로 전용하지 않음. 현재 변경0 | `tests/game/f08_experiment_panel.gd::_build_pixels`, 원본 pixel_probe, `scripts/ui/stage1_map.gd::_draw`; 실제 신규 아트/import/필터 자원 경로는 **NOT_DEFINED** | 같은 원본·크기·위상에서 nearest/linear·동적문자/포커스선. T02 재사용 후 선택한 실제 적용 조건만 대조 | DEV 자원/설정·Track B 시각, 규격 종속 아트/필터 적용 전 | 비교 방향 승인 유효. 전 에셋 일괄 변경·새 import·최종 필터 채택/실행은 **미승인/미확정** |
| O04/M01 · S3-10-M01 | 제품 Host는 HBox 지도/목록 구성. **실험 A와 유사한 병렬 구조라는 관찰**이며 A 최종 구현 수용 아님. B 토글/880 기준 세로화는 실험 panel 기능이다. **A 잠정 우선 유지 중 B 수정0** | `scripts/ui/stage1_view.gd::_ready/_focus_resized/_ensure_focus_region`, 실험 `_reflow`; 제품 B/반응형 변경 경로·자기 티켓 **채택 시 DEV 특정** | 실제 변경 전후 동일ID·현재 유효 포커스 가시성/키보드 도달·사용자 이동 우선·선택/스크롤·명령 무효과. M02 화면 밖 undo 원본 보존 | DEV/Track B, **B 또는 관련 배치/반응형 변경 채택 전만**. Track A는 기능 영향 | 방향 승인 완료, 현재 B 제품화·전면 수정/실험 **요구 없음**. 실제 채택 시 경로·실행/Git 권한 별도 |
| O05/M02 · S3-10-M02 | 현재 map/후보/계획목록 안정ID 연결·포함역 정보 선택·편집 구분은 코드/DEV026 한정 수용으로 재사용. 긴 full-name·겹침 목록의 전체 읽기순서는 **DEV025 fixture 근거만**. 현재 변경0/추가 공급 확인 필요 | `scripts/ui/stage1_map.gd::present`, `scripts/ui/stage1_view.gd::_build_candidates/_select_station/_focus_station/_render_plan`, `scripts/ui/stage1_session.gd::snapshot`. 표시명 공급/정확한 제품 자원·자기 티켓 **DEV 확인 필요** | 같은ID·중복 이름 혼동 방지·긴 전체 이름 도달·키보드 순서/포커스·잠금 시 정보/편집 구분. 현재 ID-only 라벨을 합성 긴 역명 지원 완료로 표시하지 않음 | DEV 공급/Track B·Track A 영향행, **실제 밀집 표현/목록·이름 공급 변경 적용 전** | 대안 원칙 승인. 새 이름 데이터/키 정책·클러스터/팬/자동배치·마커좌표 변경 **추가하지 않음**. 해당 실제 공급 차이만 협의 |
| O06 · S3-10-O06 | Host/Map/P06/P07/Session·순수 guard가 이미 분리됨. **현재 구조 재사용·변경0을 우선 검토**. Theme 기반 최종 디자인 시스템 적용 완료는 아님 | `scripts/ui/stage1_view.gd`, `stage1_map.gd`, `operations_view.gd`, `finance_view.gd`, `s01_observation_contract.gd`, `stage1_session.gd`; 실제 변화 경로·티켓 **DEV 결정** | 기존 공급/현재·과거·정상0/없음/실패·정보선택/명령·scope/복귀 의미 보존. 변화 행만 자동/GUI 증거 연결 | DEV 구조·Track B 의미/표현·Track A 기능, 실제 제품 변경 시 | 원칙 승인 완료. 새 컴포넌트/클래스·전면 리팩터링·새 러너 의무 없음. 구현/Git 범위는 **기존 권한 대조 필요** |
| O07/M05 · S3-10-M05 | profile03 원시 CSV/22조건2639프레임 보존. **목표 결정 시점 이월 승인**, 현재 측정/변경0 | `docs/engineering/evidence/DEV-025_F08_PROFILE.csv`, 기존 profile runner. 미래 장면/자원/측정 경로·티켓 **목표 시점 DEV 제안** | 목표환경·장면·표현량·기간·Debug/export/VSync 조건 구분 후 필요한 최소 계측. 현재 60FPS 보장/제품 상한/우열 창작 없음 | DEV 측정안·HQ/Owner 목표, 목표환경/성능 인수 시점 | 현재 새 벤치마크·프로파일/export 실행/Git **요구/승인 없음**. 목표 수치/실행 범위는 시점에 좁혀 결정 |

모든 제품 티켓 공백은 **DEV 확인 전**이며 임의 DEV 번호를 발급하지 않는다. DEV026 기존 한정 수용은 재사용 근거이지 신규 폰트/배치/아트 변경에 대한 승인으로 재사용하지 않는다. DEV027에는 실제 기능 변화와 승인 범위가 일치하는 행만 DEV가 연결한다. 일정/공수는 전 행 NOT_ESTIMATED다.

## 3. 후보·필수 판독/입력 기준

### 폰트/환경 후보는 채택안이 아닌 조사 상태

| 후보 | 현재 근거·상태 | 적용 전 필요한 자료 |
| --- | --- | --- |
| F-CURRENT | 현행 기본/fallback 임시 유지 승인. 특정 font family가 모든 환경에서 고정된다는 보장 아님 | 최종 지원환경을 정할 때 실제 family/fallback·줄바꿈·STR01~07과 버튼 도달 |
| F-SYSTEM | DEV025에 설치된 Malgun Gothic의 비교 관측 있음. **번들 채택/배포권 미확인** | 시스템 의존 허용 여부·실제 버전/권리·없는 환경 fallback. 다운로드·설치·복사 안 함 |
| F-BUNDLE | 배포용 한글 후보 권리/구성 **준비 방향만 승인**. 구체 폰트명/버전/경로 NOT_DEFINED | DEV가 후보 식별·권리 원문·배포 범위·fallback·예상 영향 제출. 필요한 반입/실행/최종 결정만 별도 특정 |

1280×720/root1은 동일 조건 대조 기준이다. font_size18·880 세로 전환·실험 배율1/1.25/1.5/2·지도72×36 등 현재 코드/실험 값은 최종 치수/지원 규격이 아니다. 우선 문서화만 하며 제품 값을 변경하지 않는다.

### 필수 기준 — 이미 정한 RD를 실제 영향 행에 적용

- RD01/04: 자릿수·부호·단위·기간 끝 제외·안정ID·전체 이름/원인·한글/기호 보존. 잘림/지수 치환/글리프 누락과 불명확한 상태를 구분한다.
- RD02: 현재/이전·예상/실적·정상0/없음/실패·잠금/정보선택/포커스를 텍스트/상태로 구별한다. UI 계산·모델 결과 창작 없음.
- RD03/07: 실제 유효 Control의 화면 내 포커스·도달·읽기/스크롤 순서·동일ID 대안. 사용자 이동을 빼앗거나 선택/포커스만으로 명령을 발생시키지 않는다. 자료 무효 시 무효 목록을 대안으로 쓰지 않는다.
- RD05/06: 아트와 동적 문자 역할 분리, 같은 state/profile/ID/정보량/명령 권위. layout 변경만으로 효과 추가0.
- RD08: 실제 SHA/파일 해시·장면/입력·요청/실측/배율·원본과 제외 사유. 자동·스크립트 렌더·OS GUI·Design 심사·build/성능을 별도 기록한다.

## 4. DEV·Track A에 받을 확인 — 공동표 완성 조건

1. 위 경로의 **현재 충족·변경0** 판단과 재사용 증거에 이견이 있는지 행별 표시한다. 정적 관찰을 새 OS GUI PASS로 바꾸지 않는다.
2. 당장 적용할 행이 있다면 자기 티켓·정확한 파일/자원·실제 공급 차이·입력/기대/최소 검증·유효 승인 원문·부족 범위를 채운다. 불필요한 전면 분해/새 러너/새 승인 반복은 하지 않는다.
3. A 유지 시 M01은 조건부로 둔다. M02는 실제 밀집/목록/표시명 변화 시점, M03/04는 규격 적용 전, M05는 성능 인수 시점을 지정한다. 날짜를 임의 확정하지 않는다.
4. Track A는 실제 기능/동선 변화 행만 주관/공동 심사 위치를 연결한다. 같은 실행 패킷을 Track B와 공유한다. Planning은 새 규칙/보고 의미 차이가 실제 있을 때만 해당 쟁점, Convention/INF는 실제 도구/인계 공백이 있을 때만 요청한다.

현재 이 표는 **NOT_SENT / DEV_CONFIRMATION_PENDING**이다. 같은 방향 승인 요청은 남아 있지 않다. 미확정 규격과 실제 추가 경로/실행 승인·공동표 확인이 남았다. 신규 기술 충돌/게임 명세 변경 필요는 현재 NONE이며 실제 발견 시 기존 RFC 절차로 영향 행만 보고한다.

## 5. 상태·증거·종료 경계

O01~07 승인 완료와 FINAL_SPEC_PENDING을 동시에 유지한다. 기존 RD의 ISSUE_OBSERVED(B 포커스/겹침), INCONCLUSIVE·원본 실패/미확인·DEV026 원본 PARTIAL은 그대로다. DEV025 기술 공급/#97 종료·PR157 심사·DEV026 현재 공급 한정 수용/P07 구분 승인·Stage2 DONE을 재개방하지 않는다.

이번 후속은 정적 조사·로컬 표 작성이다. 신규 자동게임 검사·Godot 로드·실제 GUI/독립 입력·font/DPI/타PC·프로파일·빌드/export는 **각각 NOT_RUN**이다. 최종 규격 미결/F08 OPEN과 다른 열로 관리한다. S3-10-A는 **TRACK_B_PREPARED / DEV_CONFIRMATION_PENDING**, S3-10-C 및 S3-12·Stage 최종 인수는 별도 PENDING이다. 초기 로컬 준비 시 Git/외부 게시 승인은 없었으며 현재 제품/테스트 수정0이다. 이후 Owner가 이 산출물 4개의 커밋·푸시·PR 생성을 승인했다. 이슈 전달·main 병합은 이번 제출 범위에 포함하지 않는다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008

## 6. DEV 회신 반영 제안 — v0.2 / 로컬 검토

- 기준 main: `1a941196cc6d963db93a9fba6a0386b16710aa46` (PR161 병합본). [DEV 회신](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057935798), [DEV 계획 §12.2~12.5](../../engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md#122-om-공통-적용표--dev-준비--공동-검토-대기), [Track A 영향 행](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057637207)을 연결한다.
- DEV는 준비·재사용·조건부 적용 경계에 기술적 이견 없음으로 회신했다. Track B 정적 대조에서도 이 범위에 추가 이견은 없다. **준비 경계의 상호 의견 연결**이며 최종 규격/제품 적용/L2/공동 인수 수용이 아니다. 이번 개정안은 로컬 검토 전이고 원격에 전달하지 않았다.
- 기존 표 §2의 DEV 제안/확인 대기 중 아래 항목은 답변 수신으로 갱신한다. 신규 기능·규칙·권한을 창작하지 않는다. DEV 계획의 LOCAL_REVIEW/NOT_SENT·공동 검토 대기 문구는 그 작성 시점 기록이며 PR161 병합과 #92 회신을 현재 후속으로 함께 읽는다.

| O/M | 후속 반영 범위 — 수신한 DEV 확인·Track B 대조 | 남은 적용 조건·최소 확인 / 담당·시점 |
| --- | --- | --- |
| O01 / M03 | F-CURRENT 기본/fallback 유지 **변경0** 확인. F-SYSTEM은 기존 맑은 고딕 관측이며 배포권/번들 수용 아님. F-BUNDLE은 **DEV 조사 후보 식별 완료**로 갱신: Noto Sans CJK KR 2.004 / tag Sans2.004 / 정적 Regular OTF. 후보 채택 아님 | DEV 계획 §12.3의 조건부 4경로는 `assets/fonts/noto_sans_cjk_kr/NotoSansCJKkr-Regular.otf`, `LICENSE.txt`, `SOURCE.md`(앞과 같은 디렉터리), `assets/themes/default_ui.tres`; Host `scripts/ui/stage1_view.gd` 적용점. 기존 DEV027 41개 밖 제안이며 반입 전 자기 티켓/정확한 경로·권한 확정. 실제 파일·해시·고지 구성/fallback·호환/렌더 미검증. DEV 구성→Track B STR01~07·끝자리/행동 접근, 폰트 반입/규격 확정 전 |
| O02 / M03 | 1280×720/root1 비교 기준·설정 변경0에 이견 없음. 최소 지원/OS DPI 보장으로 쓰지 않음. 수치 이월 승인 완료 | 실제 지원 조건을 정할 때 client/논리영역/OS 배율을 분리해 필수 정보·행동 도달 확인. DEV/Track B, 지원 규격 채택 전 |
| O03 / M04 | T02 격리 TextureRect/Label과 제품 draw/Control의 구분·현재 변경0 확인. 정수 nearest 우선 비교/동적 문자 분리 유지 | 실제 아트 경로 **NOT_SUPPLIED**. 선택한 크기·위상·필터/문자·포커스 직접 영향만 대조. DEV/Track B, 규격 종속 자원 채택 전 |
| O04 / M01 | A 잠정 우선/B 비교·현재 B 수정0 확인. Host가 실험 A 완성본이라는 수용 아님. W04B 관련 변경 후보는 Host 및 proposal View/scene으로 DEV027 계획에 특정됨 | B/관련 배치 채택 전 포커스 가시성·키보드 도달·사용자 이동 존중·선택/스크롤·정보 전환 명령효과0 확인. 실제 W04B 영향 시 `stage1_view.gd`, 신규 `proposal_view.gd`·`.gd.uid`/`scenes/proposal_panel.tscn` 및 해당 GUI 행만. Track B 표현·Track A 동선·DEV 공급. A 유지 중 전면 B 수정/재실험 비요구 |
| O05 / M02 | 같은 안정ID·포함 역 정보 선택/편집 경계 재사용·현재 변경0 확인. **제품 전체 이름 공급 없음**을 DEV 확인 사실로 명시. 실제12역 필드는 id/neighborhood_id/x_km/y_km; 긴 이름/겹침 판독은 DEV025 fixture 범위 | `stage1_session.gd::snapshot`→`stage1_view.gd::_build_candidates/_select_station/_focus_station`, `stage1_map.gd::present` 연결. Track B 표시 요구·콘텐츠 공급 주체/형식부터 확인 후 승인된 이름/목록 변경 영향의 동일ID·전체 이름 도달·순서/키보드·선택·정보/편집 검증. 이름/좌표·게임 규칙 임의 생성 없음. 콘텐츠 담당 미지정이면 HQ 조정, 실제 이름/밀집 목록 변경 전 |
| O06 | Session→순수 관측 guard→Host/View 소비 경계 재사용·현재 변경0 확인. DEV027의 최소 적용 단위가 제시됨: `scripts/ui/stage1_session.gd`, `stage1_view.gd`, 신규 `proposal_view.gd`·`.gd.uid`, `scenes/proposal_panel.tscn` | 실제 W04B payload/지역 의존표 **NOT_SUPPLIED**. 공급 후 정상/누락/오류/old scope·당시 사본/현재 초안·행동 효력의 영향 행 L2를 Track A/B 분담 후 화면 통합. `s01_observation_contract.gd` 등 기존41개 밖 수정 필요 시 먼저 경로/권한 특정. 전면 Theme·문구 추출 의무 없음 |
| O07 / M05 | Debug22조건/2639프레임 보존·새 측정/변경0 확인. 목표 결정 이월 승인 유지 | 목표환경·장면/표현량·기간·Debug/export 조건·최소 계측안을 실제 성능 인수 시점에 연결. DEV 측정안·HQ/Owner 목표·Track B 정보 보존. 현 시점 FPS/상한·벤치마크 추가 없음 |

### 6.1 범위·권한·종료 신호

O01~07은 방향 승인 완료다. 위 변경0은 **지금 제품을 수정할 필요 없음이라는 범위 의견**이며 미공급 규격·미관측 행의 PASS가 아니다. DEV의 구체 경로/후속은 DEV027 계획으로 참조하고 타 부서 문서를 복제·수정하지 않는다. 추가 폰트 후보 경로는 제품 수정 승인 목록이 아니다.

S3-10-A에는 Track B 준비표·DEV 확인·Track A 기능 영향 의견이 연결된 상태를 후속 근거로 제시한다. **HQ 취합/판정 및 이 로컬 개정안 검토는 별도**이며 S3-10-A 전체 수용·S3-10-C·S3-12/Stage 최종 인수를 선언하지 않는다. 같은 준비표의 최초 DEV 회신을 다시 요청하지 않는다. 필요한 추가 협의는 실제 공급·변경·미입증 영향 행에 한정한다.

DEV 회신 시점의 다음 제품 단위는 DEV027 P1 비의존 모델이며 로컬 구현·검증 권한이 별도 필요하다고 보고됐다. DI03/E01 종속 의미만 구분하고 실제 W04B 공급 이후 P3 L2를 연결한다. 이번 Track B 대조는 그 권한/규칙을 확정하지 않고 F08 전체를 W04B 일괄 착수 차단으로 만들지 않는다. 일정/공수는 NOT_ESTIMATED다.

### 6.2 미결·관측 한계·이번 미실행

- **FINAL_SPEC_PENDING / F08-01~04 OPEN:** 후보 선정/배포 구성·지원 창/배율·실제 아트/필터/배치·목록/전체 이름·재사용 적용·성능 목표는 미확정. O02/O07 결정 이월은 승인된 방향이다.
- **PARTIAL/INCONCLUSIVE 보존:** DEV025 B 전환 후 화면 밖 포커스·합성 마커 겹침, DEV026 고정일1 비영점 중첩 복귀 미관측·내부 수명/옛 callback 추가 OS 가시성 한계. 제품 결함 확정이나 완료로 확대하지 않음.
- **이번 NOT_RUN:** 새 자동 게임 검사·Godot 로드·OS GUI/독립 입력·DEV025 재실험·폰트 반입/실물 권리 고지 구성 및 fallback 실행·DPI/타PC 인수·성능·빌드/export. 제한 raw 직접 재해시·물리 DPI/신원은 NOT_VERIFIED. 회신 대조는 수행했으므로 DEV 회신 자체를 NOT_RUN으로 남기지 않는다.
- DEV026 현재 공급 한정 수용·P07 일반 재진입/저장 문맥 복귀 구분·#97 기술 종료·PR157 심사·과거 승인/실패/미포착을 유지한다. 미래 W04B 수용·최종 규격·Stage 최종 인수는 별도다. 새 GUI 요청을 뒷받침할 변경/결함/증거 신뢰성 문제는 이번 대조에서 확인되지 않았다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008
