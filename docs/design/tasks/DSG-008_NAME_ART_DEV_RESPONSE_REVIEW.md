# DSG-008 — 이름·아트 DEV 후속 회신 대조 결과

- Design Track B / AGT-DSG-0003 / 2026-11-22 / v0.1.
- **LOCAL_REVIEW_REQUESTED / DEV_RESPONSE_RECEIVED / NR_DA_NO_OBJECTION / FINAL_SPEC_PENDING / F08_OPEN / OVERALL_PARTIAL**.
- 기준 main: `97cc5472f11a97d5f7d7c1b89dc12edeace36e1f` (PR168 병합본).
- 근거: [DEV 후속 회신](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7072852286), [Track B 인계](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7072803420), [PR168](https://github.com/wisberry2022/MetroManager/pull/168).

## 1. 이번 요청·효력

Owner는 최신 DEV 회신에 따른 진행 가능한 후속 업무·남은 공급 입력을 로컬 산출물로 먼저 검토 요청하도록 지시했다. 이번 범위는 디자인 문서와 출처 선언뿐이며 제품 구현·실험·아트 제작·외부 게시·Git 제출은 수행하지 않는다. 검토 완료나 Stage DONE을 선언하지 않는다.

[NR01~13](DSG-008_STATION_NAME_READING_CRITERIA.md)과 [DA01~08](DSG-008_MINIMUM_DIORAMA_ART_HANDOFF.md)은 **DEV 수신 완료·기준/재사용 방향 이견 없음**이다. 최초 기술 회신·Track B 기준 미공급으로 되돌리지 않는다. 실제 이름 콘텐츠/표시 계약·제품 L2와 최종 시각 수용은 별도 대기다.

기존 O01~07 방향 승인과 [S1/E1/F1/N1/A1/P1 Owner 선택 §7](DSG-008_MVP_SCOPE_ENV_OWNER_OPTIONS.md#7-owner-결정제출-후속--2026-11-22)을 보존한다. 같은 선택을 재요청하지 않는다. 기존 문서의 LOCAL_REVIEW_REQUESTED·NOT_SENT는 당시 기록이며 PR168 병합→#92 인계→DEV 수신 회신을 후속 이력으로 연결한다. 원문 승인·검증·미선택 당시 기록은 수정하지 않는다.

## 2. DEV 회신 대조·디자인 후속 판단

아래는 계약 대조 방향이며 새 구현 승인 또는 완성된 제품 계약이 아니다. 소스 확인은 위 SHA의 `scripts/ui/stage1_view.gd`의 `_select_station`·`present`·`_render_plan`·`_build_candidates`와 `stage1_map.gd`의 표현 접점을 읽은 정적 확인이다. 실제 실행 근거로 집계하지 않는다.

| 대상 | DEV가 확인한 실제 상태 | Track B 후속 판단·남은 대조 |
| --- | --- | --- |
| NR01~03 | 모델/지도/후보/계획은 안정 ID 기반. 실제 표시명 미공급 | 전체 이름+ID를 목록/읽기 영역에서 연결하고 지도 ID/계획번호/선택 의미 유지. 동명 허용·중복 ID 거부 구분. 실제 12행/승인 입력 필요 |
| NR04~06 | 계획은 `plan.station_ids` 순서. 후보는 기존 Button 재사용으로 같은 ID 집합의 공급 순서 변경 시 재배열 보장 없음 | 유효 `stations` 배열 순서와 실제 계획 순서를 구분하는 계약 방향에 이견 없음. 이름 배열/이름 갱신 자체로 재정렬하지 않음. 같은 ID 공급 순서 변화·표시/키보드 순서·포커스/읽기 위치 보존을 후속 사례에 포함 |
| NR07~10 | 포함역 선택은 정보 선택, 미포함역은 편집 명령. 잠금 중 미포함역 버튼 disabled | Host 안의 별도 읽기 전용 목록+전체 이름 정보 영역 제안은 대조 가능. 읽기 대상과 편집 선택 분리·편집 handler 호출0. 정확한 Control/Tab/배치는 미확정이며 현재 동작을 전체 열람 PASS로 보지 않음 |
| 읽기 의존 경계 | 현재 Host는 plan 무효 때 지도/계획 표시도 제거 | 초기안은 유효 root·map·해당 표시 문맥 안에서 잠금과 읽기 분리. plan 무효를 우회하는 fallback을 강제하지 않음. 독립 읽기를 추가하려면 의존 조건부터 해당 L2에 제시 |
| NR11~12 | 이름 지역/guard 미구현. 표시명 전체 단위 검증·거부 제안 | 누락/중복·외부 ID·빈 이름·타입 오류 시 이름 전체 미확인, 유효 map/ID 유지 방향에 이견 없음. 행별 부분 수용 가정0. fallback 문구는 카탈로그/실제 L2 대조 후 확정하며 ID만 표시한 것을 이름 성공으로 세지 않음 |
| NR13 | `_list_stops`는 ID 배열 변화 때만 계획 문자를 재생성. 이름판만 바뀌는 갱신 미구현 | 같은 ID/plan revision의 이름판 변경·유효→오류 전환에서 실제 문자/tooltip/정보 갱신 필요. 유효 ID Control/선택/포커스·사용자 읽기 의도 보존. 새 Session에 옛 이름/읽기 선택 이관0 |
| 버전/소속 | content_version은 동일성/캐시 식별 제안. 문자열 사전순 최신 판정 안 함 | 실제 수신 순서·root/이름판 연결·old scope/동일판 상충 거부 조건과 반례는 DEV 계약 대기. 임의 판 비교·새 프로토콜 확정 없음 |
| DA01~03 | 현재 기능 충족을 위한 필수 신규 이미지/교체 확인 없음 | 참고/조건부 장식 유지. 실제 역할 선택 전 아트 제작·제품 경로 추가 없음 |
| DA04~08 | 기존 Button/draw/동적 문자·선택/포커스·패널 재사용 가능 | 운영/오류/후보/계획선·cohort 통행·허용 행동 보존. 새 아이콘/패널·Theme 전면 추출 의무 없음. 재사용 가능을 포커스/겹침 검증 PASS로 확대하지 않음 |

읽기 효과0은 읽기 자체의 추가 명령·계획/원장/시간/RNG 변동에 한정한다. 자연 시간 진행·의도적 편집의 정상 효과는 별도다. 독립 읽기 중 게임 시간이 정지해야 한다는 새 규칙은 없다.

## 3. 현재 할 수 있는 후속과 공급 대기

이번에는 [공급 입력·최소 검증 준비표](DSG-008_NAME_ART_SUPPLY_READINESS.md)를 로컬로 작성했다. 읽기/의존/오류/버전 반례와 담당별 입력을 식별하는 작업은 실제 콘텐츠 없이 가능하다. 실제 이름 작명·제품 schema 확정·새 Control 구현·아트 생산·폰트 반입은 이번 범위가 아니다.

DEV는 기존 N13 후보 경로 안에서 보완 검토 가능하며 추가 제품 경로는 현재 발견하지 않았다고 회신했다. 이는 실행 권한이 아니다. 별도 파일/씬 추출·자원 추가가 필요하면 착수 전 정확한 경로/행동을 제시해야 한다. E5/F11/N13 합집합18 및 공통 문서6개 후보는 기존 제안으로 보존하며 DEV 미게시 6문서의 게시를 새 완료 조건으로 추가하지 않는다.

실제 콘텐츠 작성/승인 담당·12행·출처/버전/locale/승인, 기준 PC 제공자·목적·현용 배율/접근 창구는 여전히 미공급이다. 과거 환경/폰트 후보는 수신 완료이며 현재 환경 실측·실제 폰트 파일/해시·고지/fallback·반입/시험은 별도다. 일정/공수 NOT_ESTIMATED.

## 4. 미결·PARTIAL·NOT_RUN·인수 분리

| 구분 | 유지 상태 |
| --- | --- |
| 최종 규격/F-08 | FINAL_SPEC_PENDING / PRODUCT_APPLICATION_SCOPE_PENDING / F08-01~04 OPEN / #92 OPEN. 실제 이름·계약/읽기 경로·환경/창/DPI·폰트/배포·실제 아트/필터/치수·배치/마커·성능 인수 규격 미확정. 기준 수신/이견 없음과 최종 수용은 다름 |
| PARTIAL/INCONCLUSIVE | DEV025 B 전환 포커스 가시성·겹침 마커, DEV026 고정일1 비영점 중첩 복귀 미관측·내부 수명/옛 callback 추가 OS 가시성 한계 보존. 새 미구현 이름 공급은 별도 미공급 항목이며 확정 신규 결함으로 확대하지 않음 |
| P07/DEV026 | 현재 공급 한정 수용 유지. 일반 닫기/재진입의 scroll 초기화와 저장 문맥 복귀를 구분. 일4→P01→보고 scroll605 복귀 증거를 일1 미관측에 전용하지 않음 |
| 이번 NOT_RUN | 신규 게임 자동검사·Godot 로드·GUI/실제 입력/플레이·현재 환경 계측·이름 구현·폰트 다운로드/설치/반입/fallback 실행·아트 제작/수출/반입·성능·빌드/export·사용성. 제한 raw 재해시·물리 DPI·새 자원 배포권은 NOT_VERIFIED |
| 기존 증거 | DEV025/026 증거·DEV027 P1 자동425/회귀805/로드는 원 범위로 보존. 새 실행으로 재집계하지 않음. 과거 실패·의도 실패·미포착·NOT_RUN 및 #97 기술 종료 유지 |
| 통합/인수 | DEV027 P1 모델 완료와 Session/Pipeline·W04B 전체 통합 완료를 분리. PLN016 정책 결정 완료와 DI03 종속 구현/검증 대기·L2 전 화면 통합 대기 구분. S3-10-C·S3-12/Stage 최종 인수는 별도. Stage DONE·이슈 일괄 close·RFC 종결 없음 |

F08 전체를 W04B 비의존 작업의 일괄 선행조건으로 추가하지 않는다. 최소 검증은 실제 변경 행에 좁히고 기존 수용/GUI 반복은 요구하지 않는다.

## 5. 로컬 검증·검토 요청

별도 브랜치 `codex/DSG-008-name-art-dev-followup`에서 Markdown2개 신규 작성과 출처 선언1개 갱신만 수행한다. PR168 산출물·기존 승인/실패 기록·공유 main의 기존 데이터2개 변경은 보존한다. 출처 선언의 과거 버전은 Git 원본에 보존하며 이번 delta만 선언한다.

검증 명령: `.venv/Scripts/python.exe tools/policy.py doctor`, `tools/policy.py check`, `git diff --check`, UTF-8/LF·상대 링크/이슈 근거·변경3개·기존 추적 파일 불변·출처 blob 정적 대조. doctor PASS, check PASS(exit0: worktree762개·GDScript63개), diff --check PASS. UTF-8/LF·상대 파일 링크8개·출처 blob2개·변경3개/그 외 추적 파일 불변 PASS. 새 제품 테스트를 대신하지 않는다. 커밋 전이므로 preflight·새 원격 CI NOT_RUN.

환경 준비 이력: 최초 sandbox fetch는 FETCH_HEAD 접근 거부로 실패했고 이어진 worktree 생성도 미취득 SHA 때문에 실패했다. 승인된 권한 상승으로 fetch·격리 worktree 생성에 성공했다. venv junction 최초 sandbox 생성도 접근 거부였고 권한 상승 후 기존 venv 연결·doctor PASS를 확인했다. 훅/정책 우회·기존 파일 폐기는 없으며 이 환경 준비 실패를 제품 실패나 게임 검사로 집계하지 않는다.

Owner에게 DEV 수신 완료 상태·NR 계약 대조 방향·신규 아트 비필수 판단과 준비표의 공급/검증 분리를 로컬로 검토 요청한다. 커밋·푸시·PR·이슈 게시·병합은 수행하지 않는다. 새 게임·경제·시간·세이브 명세 변경 요구 없음. 실제 계약 충돌 시 영향 행만 기존 RFC로 연결한다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008

## 6. Owner 제출 승인 후속 — 2026-11-22

위 로컬 미제출/권한 기록은 당시 이력으로 보존한다. 현재 디자인 채팅에서 Owner가 다음과 같이 승인했다.

> DSG-008 이름·아트 DEV 회신 반영 산출물 3개의 커밋·푸시 및 PR 생성을 승인합니다. 기존 Owner 선택과 과거 기록을 보존하고, 최종 규격 미확정·F-08 미결·PARTIAL·NOT_RUN 및 Stage 최종 인수 별도 상태를 PR에 명시해주세요. main 병합은 하지 마세요.

대상은 wisberry2022/MetroManager / DSG-008 / `codex/DSG-008-name-art-dev-followup`의 신규 Markdown2개·출처 선언1개다. 승인 출처는 현재 Owner 채팅의 위 원문이며 별도 공개 승인 URL은 제공되지 않았다. 이번 커밋·일반 푸시·PR 생성에만 유효하고 main 병합·릴리스/배포·이슈 게시·새 제품/아트 제작·실험 권한으로 확대하지 않는다.

제출 전 fetch와 원격 읽기에서 최신 main은 작성 base와 같은 `97cc5472f11a97d5f7d7c1b89dc12edeace36e1f`임을 확인했다. 기존 자료·제품·공유 데이터는 변경하지 않는다. O01~07·S1/E1/F1/N1/A1/P1 선택과 과거 승인/검증 기록은 보존하며 DEV 수신/이견 없음과 실제 공급·최종 계약/제품 L2·F08 규격 수용을 구별한다.

정상 훅·doctor/check·파일/출처 정적 검사를 거쳐 커밋 후 preflight·실제 PR head의 필수 CI/출처 진단을 확인해 PR에 연결한다. 위 커밋 전 preflight/CI NOT_RUN은 당시 기록으로 보존한다. 제품 자동·로드·GUI·플레이·환경/폰트/아트·성능·빌드/export NOT_RUN 및 기존 PARTIAL/INCONCLUSIVE·최종 규격 미확정/F08 OPEN·Stage 최종 인수 별도는 그대로다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008
