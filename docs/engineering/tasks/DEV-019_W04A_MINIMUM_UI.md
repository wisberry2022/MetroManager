# DEV-019 — W04A P01/P02 최소 UI 실행 승인 요청

- 담당 Development Project Leader / LAPTOP / AGT-DEV-0001 / 2026-11-08.
- 상태 REVIEW / OWNER_EXECUTION_AND_GIT_APPROVED / DESIGN_L2_DEADLINE_MAPPING_ACCEPTED / GUI_ACCEPTANCE_PENDING. §1~9는 준비/대기 당시 이력이며 현재 실행·검증은 §10~11 및 결과 문서를 따른다. 구현/검수 제출이며 독립 Design GUI 수용/DONE은 아니다.
- 정식 추적 [Issue #75](https://github.com/wisberry2022/MetroManager/issues/75), Design [DSG-010 #81](https://github.com/wisberry2022/MetroManager/issues/81).
- 최신 확인 main `3aad051c46230fae04314e082dcf5b39a1a1004f`. PR82의 DEV018은 `9090e8501948a86a5f699ac75a96733c8a5420dc`, PR83의 DSG010은 최신 main으로 병합됨.
- 로컬 준비 브랜치 `codex/DEV-019-tender-ui`, 독립 worktree `.local/worktrees/DEV-019-tender-ui`. main/기존 작업 브랜치를 switch/pull/stash/폐기하지 않았다. 원격 DEV019 브랜치/Commit/Push/PR은 미생성.
- Owner 현재 요청은 최신 main·Design 협의/착수 조건 점검 및 승인 요청 준비다. DEV018의 실행/Git 승인을 DEV019로 재사용하지 않는다.

## 1. 목적·기준·선행 확인

B01/B02 공고 조회 P01→고정 조건·현재 자격 P02→실제 응찰 명령/접수→마감 점수·낙찰/탈락→사업 계약/정부 지급→허용된 P05 인계 확인·복귀를 실제 제품 UI로 조작 가능하게 한다. 기존 S01 HUD/지도/노선/예측/자금·보고를 보존한다. 경제·시간 판정은 DEV018 공급만 사용하며 UI는 재계산하지 않는다.

- [PM-014](../../hq/PM-014_STAGE2_VS01_EXECUTION_PLAN.md), Gate2 C0.6/D0.9/DATA1.3·최종 승인 및 Planning [RFC 회신](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6716236853).
- [DEV018 실제 공급 계약](../evidence/DEV-018_SUPPLY_AND_VALIDATION.md), [실제 fixture](../evidence/DEV-018_W04A_FIXTURES.json), [결과](DEV-018_RESULT.md). UI revision DEV018-W04A-UI-1.
- Design [A01 설계 v0.1](../../design/tasks/DSG-010_A01_P01_P02_DESIGN.md), [A01-Q01~12 QA](../../design/tasks/DSG-010_A01_QA_PLAN.md), [결과](../../design/tasks/DSG-010_RESULT.md).
- 문서 병합과 실제 공급/GUI 수용을 구분한다. Design 원문 상태는 STATIC_UI_DESIGN/REVIEW, SUP01~07 공급안 정적 이견 없음·실제 API/fixture PENDING, SUP08 부분공급, GUI12개 모두 NOT_RUN이다. 새 기획 변경/L3 요청 없음.

## 2. Design L2 협의와 정확한 차단

[RFC-DEV-019-01](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6716543642) OPEN / Design 응답 PENDING. 확정 기획을 재질의하지 않고 다음 실제 공급/표현 차이만 확인 요청했다.

| 항목 | 확인된 사실/제안 | 최초 차단·담당 |
| --- | --- | --- |
| SUP01~07 실제 소비 | Pipeline snapshot 봉투·상태/사유·과거/현재·명령ID/revision을 실제 공급 계약으로 대조. CLOSED의 미응찰/탈락 및 낙찰후 계약거부 구분 | 해당 P01/P02 실제 데이터 통합 전 Design L2 |
| 접수 시각/Q04~06 | 완료분 소급 불가. completed360 요청→최초효력361, completed1799 요청→최초효력1800 마감 거부. actual effective360/1440/1799는 직전분 요청으로 재현 | UI 문구/해당 경계 GUI 수용 전. Design 표현 확인; 의미는 기존 Planning 회신 |
| 소수 점수/Q07~08 | 비교 분모10000·공개점수분모100000, 임의 반올림 없음. 정확한 유한소수/끝0 제거는 표시 제안이며 미확정 | 해당 결과 표현 통합 전 Design 확인. UI는 F→점수 재산정 금지 |
| SUP08/Q12 P05 | 사업/계약/지급/R의 읽기 전용 인계 화면과 복귀만 제안. enter_p05 권위 조건 준수, 공사계약 NOT_CREATED·착공0 | 해당 P05 인계 화면 통합/수용 전 Design. 실제 W05 공사/계약은020/021 |
| 오류/역순/Q01·03·10·11 | 실제 동기 조회에 가짜 지연 없음. 미수신/available=false/빈/실패·회복/과거응답/지급자료 없음은 검증 fixture와 실제 소비 경로로 대조 | 해당 UI 통합/GUI 수용 전 Design. 모델경제를 바꾸는 제품 디버그 UI 금지 |

Owner 개별 실행 승인과 Design L2 소비 확인은 별개다. Owner 승인 후 미회신 표현과 무관한 독립 adapter/자동검증 준비는 가능하나 위 영향 화면의 실제 통합·GUI 수용은 회신/해소 전 완료로 처리하지 않는다. 불일치면 해당 행만 RFC 갱신, 새 규칙/범위 변경일 때만 Planning/HQ/Owner로 상정한다. 현재 모든 신규 기능 제작은 승인 전이다.

DSG006 TrackB 콘셉트·최종 아트·미승인 PC/FPS는 최소 UI의 선행조건이 아니다. A01의 문서 REVIEW 상태를 Owner 최종 제품 수용으로 바꾸지 않는다.

## 3. 포함·제외 및 승인 요청 경로

| 승인 요청 경로 | 변경 한계 |
| --- | --- |
| scripts/ui/stage1_session.gd | DEV018 enable/submit/result/snapshot 중개, 입찰 명령 ID·요청/효력·현재/당시 사본·조회 상태 공급. 기존 일반 dispatch의 현재분 결과 병합으로 실제 응찰 효력분을 덮지 않도록 별도 중개. 게임 판정/원장 재구현 금지 |
| scripts/ui/stage1_view.gd | S01↔P01/P02/P05 인계 패널 연결·기존 HUD/시간 진행1개 권위·상태 문구/포커스/복귀. 기존 지도/예측/보고 보존 |
| scripts/ui/tender_view.gd 및 .gd.uid 신규 | 읽기 전용 공고·자격·요청/접수/판정/계약·지급·사유/허용행동, 단일 최신 관측/역순 거부, 선택/키보드/스크롤/새로고침. 표시만 수행 |
| scenes/tender_panel.tscn 신규 | P01/P02와 L2 확인된 P05 읽기 전용 인계 영역. 별도 공사 구현 없음 |
| tests/game/run_tender_ui_tests.gd 및 .gd.uid 신규 | 제품과 같은 공급/소비 API의 자동 UI 회귀 및 의도 실패 exit1 확인 |
| tests/game/w019_ui_fixtures.gd 및 .gd.uid 신규 | 정상/실패/빈/0/없음/오래된응답·시각/자금변동 검증 입력. 제품 사용자 기능에서 분리 |
| tests/game/run_tender_gui_cases.gd 및 .gd.uid 신규 | Design이 직접 조작할 수 있는 검증 전용 GUI 케이스 진입. 제품 정상경로를 강제 성공 fixture로 대체하지 않음 |
| docs/engineering/tasks/DEV-019_W04A_MINIMUM_UI.md, DEV-019_RESULT.md, DEV-019_PROVENANCE.json | 티켓/승인·변경·실제 검증·추적/출처 |
| docs/engineering/evidence/DEV-019_*.md/.json/.png | 최소 공급 매핑·자동/GUI 증거·명령/원장/시각·해시·NOT_RUN. 불필요한 개인정보/개인 절대경로 제외 |

읽기 전용: DEV018 loader/model/service·minute_pipeline·CompanyLedger/Clock/Queue·기존 모델/테스트·main.gd·기존 scenes/main.tscn/stage1.tscn·project.godot·정책/CI·타 부서 산출물. 기존 Stage1 view/session에서 진입을 연결할 수 있음을 소스로 확인했으므로 main.gd나 기존 scene 변경은 현재 요청하지 않는다. 추가 경로/모델 수정 필요 시 원인·대안·영향을 보고하고 승인 범위 확정 전 해당 변경을 수행하지 않는다.

제외: W04B/새 정부 심사·RNG, 새 경제/시간/자격 규칙, 마감 유예·야간 제한, 실제 W05/W06·공사 체결/착공/검증/영업 UI, 새 저장/네트워크 프레임워크, 고충실도 아트/DSG006 콘셉트 반영, Windows export/성능/릴리스, 정책/CI/타 부서 파일 수정.

## 4. 수용·검증 계획

| 증거 | 계획·책임 |
| --- | --- |
| A01-Q01/Q02/Q03 | B01/B02·BX비노출, 선택조회 명령0, 고정조건/계획 읽기 전용, 자격/reason/actions·키보드. 빈/오류/available=false/실제0 분리·회복.DEV 자동/실GUI 후 Design 독립 |
| A01-Q04/Q05/Q06 | 실제효력359/360/1439/1440/1799/1800/1801, 요청분 구분, 정지/재개/1·2·4배속·동일효력/분할재현.DEV018 변경 없이 검사 |
| A01-Q07/Q08 | 정상86:80, F변동80:80 동점 및 정확한 소수표시.접수/마감/현재 사본·동점우선순위·마감분·거래0/1 구분 |
| A01-Q09/Q10 | pending연속 클릭 억제·동일ID 결과/종료회차, 오래된 snapshot/결과 역순, 현재 버튼/선택 덮기 금지, 조건변경 자동실행0, 포커스 유지 |
| A01-Q11/Q12 | 계약/정부 지급 각각1회, ID/효력/R 연결·재조회 부작용0, 허용된사업ID의 P05 인계/복귀.공사계약 미체결·착공0의 부분증거만 |
| 기존 회귀 | W01/02/03/W07 및 W04A 개별 러너.기존951+W04A204는 이전 head 증거이며새 head에서 실제 재실행해 결과기록 |
| 환경/정책 | worktree전용venv·doctor/check, 정책89개 현재기준unittest, 정상훅Commit→fetch/preflight→일반Push→PR policy/department-policy 확인 |
| 엔진/제품 | Godot4.7.2 headless editor load·자동러너·제품 headless 진입과 실제 WindowsGUI를 별도 실행.B01 정상은 제품에서 실제 마우스/키보드로 조회→응찰→판정→계약/지급→인계확인 |

각 fixture는 version·product head·입력/기대/실제·명령ID·요청/효력/판정/완료revision·reason/actions·로그·종료코드·원본해시를 기록한다. GUI 입력/가독성/좁은창·긴사유·Tab/Enter/Space·선택/스크롤/포커스 복귀를 실제 관찰한다. 오류/경계 GUI는 검증용 표시와 제품 정상 경로를 분리한다. Design 독립 검수는 같은 제출 head에서 A01-Q01~12로 의뢰하며 DEV 단독 PASS를 Design 수용으로 승격하지 않는다.

S2-02/03 GUI·S2-08 해당부분·S2-11 증거가 대상이다. SUP08 인계만으로 W05 인수·S2-04/05·VS01 완주/Stage2 DONE을 주장하지 않는다. F03/10은 공급→소비→실제화면, F11은 실행별승인, F07의 최종MVP/VP·F08의규격종속검증·F01의미래최초RNG는 후속의무 유지.

## 5. Owner 개별 실행·Git 승인 요청

- 저장소 wisberry2022/MetroManager / DEV-019 / AGT-DEV-0001 LAPTOP / codex/DEV-019-tender-ui / base는 실행 직전 최신 main 재확인.
- 요청: §3의 포함 경로·최소 UI/공급중개·자동/GUI검증·문서/증거 작성, 정상 Commit, 이 작업 브랜치 일반 Push(필요 시 정책 API공유), base main PR 생성·필수CI확인 및 같은범위 검수수정.
- 유효기간: Owner 명시 승인부터 이번 티켓 제출/동일범위 검수 대응까지. Design L2 미해결 영향 행은 §2의 차단을 유지한다.
- main 병합·강제Push/공유이력재작성·릴리스/배포·다른티켓 권한은 별도.
- 근거: AGENTS.md의 “Owner의 명시적 추가 승인 없이 커밋, 원격 푸시, 브랜치 병합, 릴리스 또는 배포를 수행하지 않는다” 및 Issue75 개별실행승인 조건. 현재 준비 지시/DEV018 승인/Design 문서병합은 DEV019 실행권한이 아니다.

## 6. 이번 준비 실행·NOT_RUN

실행: Git 상태·원격fetch·main/PR82/83·Issue75/24/81와관련댓글, 소스·공급계약·A01설계/QA 정적 검토, 독립로컬준비worktree·본티켓, L2질의·승인패킷 게시.이 문서만 로컬미커밋이며 정식 Git 반영으로 주장하지 않는다. 준비용 doctor/check PASS(418파일/GDScript27), UTF-8/LF·상대 링크·Q01~12 추적·변경범위 검사 PASS. 기존 DEV018 venv의 Python을 읽기 전용으로 사용했으며 실행 승인 후 DEV019 전용 venv를 준비한다.

신규 게임코드/테스트/씬·DEV019 자동/프로젝트로드/실GUI·빌드/CI는 NOT_RUN.Commit/Push/PR/main병합 미수행.설계상 실행승인 요청은 준비되었으나 실제 L2 소비 합의/GUI 인수는 PENDING이다.

Agent-ID: AGT-DEV-0001
Task-ID: DEV-019

## 7. Design 회신 수신·조건 갱신

위 §1~2의 응답 PENDING 표는 최초 질의 시점 이력이다. 이후 Owner가 현재 개발 세션에 전달한 Design 회신을 수신했다. 이번 원격 조회의 Issue81에서는 Design 원댓글이 아직 확인되지 않아 수신 근거를 Owner 전달 회신으로 명시한다. Design의 실행/Git 승인 또는 최종 GUI 수용으로 해석하지 않는다.

- 상태/출처·revision 분리, 공급 분자/분모의 정확한 유한소수·후행0 제거·단위/비교정렬, 동기조회에 가짜지연 없음·정상/검증 fixture 분리를 조건부 수용. 새로운 기획 이견/L3 사유 없음.
- P05 인계는 **A01-Q12 PARTIAL**로 관리한다. 유효 사업 계약/정부 지급/R·공사계약 NOT_CREATED 표시·복귀만 수행하며 실제 공사계약/착공/공정/검증·P05 조작 인수는020/021 후속이다.
- [마감 직전 실제 공급/소비 매핑](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6716637542) 제출: completed1799의 권위 공급은 OPEN/submit_bid=true/현재 사유없음. 버튼은 “응찰 요청”이며 접수 성공을 보장하지 않는다. Session의 다음 명령 후보 effective1800과 마감1800·효력시각 판정 안내를 구분한다. 실제 pending/명령ID를 추적하고1800 처리 결과의 ROUND_CLOSED를 접수 거부로 표시한다. 현재 상태를 미리 CLOSED로 변조하거나 없는 거부코드를 만들지 않는다.
- completed1798→actual effective1799 유효접수, completed1799→effective1800 마감거부, 기존receipt1799→decision1800을 서로 다른 케이스로 검증한다. 버튼입력분/효력분 독립기록, 정지중 미확정/pending 유지, 미래 접수 보장문구 금지.
- 마감 직전 위 매핑의 실제 연결 전 Design 소비 확인을 유지하며 소수문자열/현재행동·이력귀속/Q12부분범위는 구현 head에서 재확인한다. A01-Q01~12 실제 GUI는 NOT_RUN.
- [Issue75 상태 갱신](https://github.com/wisberry2022/MetroManager/issues/75#issuecomment-6716638133). §3/5의 경로·기능·권한 요청 확대 없음. Owner의 DEV019 개별 실행/Commit/Push/PR은 여전히 승인 대기, 준비문서만 갱신.

## 8. Owner 실행·Git 승인 수신 및 잔여 선행조건

- Owner 현재 직접 원문: “개발 에이전트. Issue #75의 DEV-019 W04A 최소 UI 구현 및 Commit·Push·PR 생성을 승인합니다. 마감 직전 버튼·효력 안내에 대한 Design 회신을 확인한 뒤 티켓 범위만 작업하고 검증 후 PR 생성해주세요. P05는 읽기 전용 인계 범위로 유지하며 main 병합은 별도 승인하겠습니다.”
- §3/5의 저장소/DEV019/브랜치/포함 경로·구현/검증·Commit·일반 Push·PR 및 동일 범위 검수 수정 권한을 수신했다. P05 읽기 전용·Q12 PARTIAL, main 병합 별도 조건을 유지한다. 위 승인 대기 문구는 이전 준비 이력이다.
- 이번 원격 확인: Issue81 전체 댓글은 최초 RFC와 DEV의 마감 매핑 제출뿐이고, Issue75/24 및 관련 저장소 검색에서도 마감 매핑에 대한 추가 Design 회신은 확인되지 않았다. Owner가 앞서 전달한 조건부 수용 회신은 보존하되, 그 회신 이후 요청된 completed1799/후보효력1800 안내 매핑의 소비 확인과 구분한다.
- 현재 WAITING_FOR_DEADLINE_DESIGN_REPLY. Owner가 지정한 ‘회신 확인한 뒤 작업’ 순서를 준수한다. 해당 회신이 원격 등록되거나 Owner를 통해 전달되면 유효 승인 범위로 진행하며 동일 Git 권한을 재요청하지 않는다.
- 최신 remote/fetch main은3aad051c46230fae04314e082dcf5b39a1a1004f로 동일, doctor PASS. 변경은 기존 준비 티켓 갱신만이다. 신규 코드/씬/테스트·Commit/Push/PR·게임 자동/로드/GUI/빌드는 미수행/NOT_RUN.

## 9. 최신 재개 지시 수신·회신 조회 불일치

Owner가 “디자이너 에이전트가 Issue #81에 마감 직전 버튼·효력 안내에 대한 회신을 등록했습니다. 확인 후 기존 승인 범위에 따라 DEV-019를 구현하고 검증 후 Commit·Push·PR 생성까지 진행해주세요. P05는 읽기 전용 인계로 유지하며 main 병합은 별도 승인하겠습니다”라고 재개를 지시했다. 기존 실행/Git 권한은 유효하며 재승인을 요청하지 않는다.

Issue81 댓글 목록·전체 페이지 댓글 도구·별도 쿼리·Issue본문·저장소 최근 댓글 및 공개 GitHub API 직접 조회 모두에서 현재 확인 가능한 댓글은 DEV의6716543642/6716637542 두 건뿐이었다. 새 Design 회신 내용을 확인했다고 주장하지 않으며 Owner에게 해당 댓글 직접 링크 또는 회신 내용을 요청했다. 명시된 회신 확인 선행조건을 유지한다.

독립 실행 준비로 DEV019 전용 .venv 및 고정 requirements를 설치했다. doctor/check PASS(418파일/GDScript27), 엔진4.7.2.stable.official.ed1daf0bf 확인, HEAD/origin main3aad051c46230fae04314e082dcf5b39a1a1004f 일치. 작업 파일 변경은 이 준비 문서뿐이다. 신규 코드/씬/테스트·Commit·Push·PR·실제 GUI는 미수행이며 회신이 확보되면 같은 승인으로 구현/검증/제출을 이어간다.

## 10. Design 추가 회신 확인·구현 재개

[Issue81 Design 회신6716760279](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6716760279)을 전체 댓글 도구로 직접 확인했다. DESIGN_L2_DEADLINE_MAPPING_ACCEPTED / DEV019_IMPLEMENTATION_UNBLOCKED_FOR_DESIGN / GUI_QA_PENDING으로 §8~9의 대기 조건이 해소됐다.

Owner의 재개 원문: “디자이너 에이전트가 Issue #81에 마감 직전 버튼·효력 안내에 대한 회신을 등록했습니다. 확인 후 기존 승인 범위에 따라 DEV-019를 구현하고 검증 후 Commit·Push·PR 생성까지 진행해주세요. P05는 읽기 전용 인계로 유지하며 main 병합은 별도 승인하겠습니다.” 기존 §8의 개별 실행·Git 승인과 함께 적용한다. 브랜치/경로/유효기간/제외 범위 변경 없음. 같은 권한을 재요청하지 않았다.

[Issue75 착수 기록](https://github.com/wisberry2022/MetroManager/issues/75#issuecomment-6716794229). P05는 읽기 전용 인계·Q12 PARTIAL, Design 독립 GUI 수용은 후속이다. 실제 구현·검증·제출 상태는 DEV-019_RESULT.md 및 PR로 연결한다.

## 11. 실제 결과 제출

[DEV-019_RESULT.md](DEV-019_RESULT.md), [UI 공급/검수 계약](../evidence/DEV-019_UI_CONTRACT.md), [자동단언](../evidence/DEV-019_UI_ASSERTIONS.json), [실제 검증/GUI/소스해시](../evidence/DEV-019_VALIDATION.json)를 제출한다. Design 표현/소비 착수 조건은 실제 회신으로 해소됐으나 독립 GUI 인수는 여전히 대기다. Owner 수용/DONE·main 병합은 별도다. 위 준비/차단 당시 기록을 현재 미승인/미착수 상태로 해석하지 않는다.

## 12. QA-001·QA-002 보완 승인 및 L2 협의 대기

- 기준 main: `06274e8557a8bbe4d8880fd02aac892c15e49f98` (PR #84 병합). 후속 브랜치 `codex/DEV-019-qa-public-criteria`, 기존 작업물은 보존한다.
- Owner 현재 직접 원문: “개발 에이전트. DEV-019의 QA-001·QA-002 보완 구현 및 Commit·Push·PR 생성을 승인합니다. Design과 문구·배치를 L2 협의한 뒤 해당 범위만 수정하고 검증 후 PR 생성해주세요. P05는 읽기 전용 인계로 유지하며 main 병합은 별도 승인하겠습니다.”
- 위 두 결함의 구현·검증·정상 Commit/일반 Push/PR은 승인됐으나 표현 구현은 Design L2 회신 확인 후 진행한다. main 병합·릴리스/배포·W05 및 다른 티켓은 제외한다.
- Owner 제공 독립 QA ZIP SHA256 `1e273b7457a71a3ef972affafba9950cafc36f22e3d4322f25e00f68bccd8169`. 내부 manifest 123개 해시 일치, 기준 SHA의 UI 소스와 제출본 일치 확인. 보고 권고 DESIGN_L2_REJECTED / RETEST_REQUIRED, PASS7/FAIL1/PARTIAL4. 로그의 UI185+기존1155단언0실패는 독립 QA 실행 이력이며 이번 재실행 결과가 아니다.
- QA001(L2 인수차단): 응찰 전 공개 평가기준·경쟁자 점수·동점순위 소비 누락. QA002(L1): 현재 행동 사유의 원시 enum 가독성. 경제/시간/낙찰 모델 결함으로 확대하지 않는다.
- [RFC-DEV-019-02 구체 문구·배치안](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6717493892), [Issue75 승인/착수 조건](https://github.com/wisberry2022/MetroManager/issues/75#issuecomment-6717496880). 현재 OPEN / DESIGN_RESPONSE_PENDING. 제안을 Design 수용으로 취급하지 않는다.
- 제안: 고정조건 다음·현재 자격/요청 이전의 읽기 전용 공개 평가기준, 고정 경쟁자 점수·terms 순위, 기존 한국어 사유 매핑/줄바꿈. 마감 후 실제 판정은 별도 사본. 구체 표현은 L2 회신에 따른다.
- 검증 예정: 독립 B01/B02의 미응찰 공개정보, 판정 전후 출처 분리, 정상86:80/동점80:80/소수79.99997, BUSY/DURATION/시작전·마감후 한국어 사유, 기본/최대화 줄바꿈·기존 키보드·pending/마감·읽기 전용 P05 회귀. 자동검사·엔진 로드·개발 GUI·Design 독립 재검수를 구분한다.
- 상태: 준비 티켓만 갱신. 신규 코드/테스트/씬 수정·자동검사/로드/GUI 재실행·Commit/Push/PR은 NOT_RUN. 이전 독립 QA의 PARTIAL/하위 NOT_RUN을 이번 보완으로 자동 완료 처리하지 않는다.

## 13. QA 보완 L2 회신 수신·구현

[Design 회신6717520859](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6717520859)을 직접 확인했다. RFC_DEV_019_02_DESIGN_COPY_LAYOUT_ACCEPTED_WITH_CONDITIONS / DEV_FIX_SCOPE_READY / DESIGN_INDEPENDENT_RETEST_REQUIRED. §12의 대기는 해소됐다. 재무점수 상·하한 제한 명시, 판정 전 미확정 안내/판정 후 제거, 미등록 사유 설명+코드 조건을 반영한다. Owner의 기존 개별 구현·Commit/Push/PR 승인과 P05 읽기 전용·main 별도 경계가 유효하다.

실제 결과는 [QA 보완 결과](DEV-019_QA_FIX_RESULT.md), [자동 단언](../evidence/DEV-019_QA_FIX_ASSERTIONS.json), [실행·GUI 증거](../evidence/DEV-019_QA_FIX_VALIDATION.json)를 따른다. 독립 Design 재검수·수용/DONE은 별도다.
