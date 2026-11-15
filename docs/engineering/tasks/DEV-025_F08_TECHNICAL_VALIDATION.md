> 최신 제출 후속: 2026-11-15 / OWNER_LOCAL_RESULT_ACCEPTED / GIT_SUBMISSION_APPROVED.
> 과거 준비·로컬 검토·미승인 상태는 당시 이력으로 보존하며, 현재 제출 권한은 티켓 §10·결과서 §5에 기록한다. Design 검토·최종 규격 미확정 및 DEV-026 HOLD 유지.

> 현재 후속 기록: 2026-11-15 / AGT-DEV-0004 / LOCAL_REVIEW_REQUESTED.
> 최초 준비·승인 대기 본문은 이력으로 보존하며, 아래 §9가 이번 작업의 권한·기준이다.

# DEV-025 — F-08 S01 기술 실험 실행 승인 요청

- 담당: Development Project Leader / LAPTOP / AGT-DEV-0001.
- 상태: PREPARED / OWNER_EXECUTION_AND_GIT_APPROVAL_PENDING / EXPERIMENTS_NOT_RUN.
- 기준 main: `e1ccf124a19dd38a40a1462444daa97d4745f90f`. 코드 검토 기준 `7cbb8f9a3c3b21fb2faa4cf3cb879c77ea82b0ae` 이후 INF 등록·인계3개 파일만 변경됐으며 관련 소스/명세는 동일하다.
- 연결: [Issue92 / RFC-DSG-008-F08-01](https://github.com/wisberry2022/MetroManager/issues/92), DSG-008, UI-DC-08, PM-014 F-08·F-11. [DEV-024 #80](https://github.com/wisberry2022/MetroManager/issues/80)의 VS-01 완주나 W09 export/최종 성능 인수를 대체하지 않는다.
- 제안/준비 브랜치: `codex/DEV-025-f08-technical-validation`. 독립 로컬 worktree에 이 승인 요청서만 준비했다. 원격 공유·Commit·Push·PR 승인은 아직 없다.
- Owner의 이번 지시는 Issue92 검토 회신 등록과 별도 실행 티켓·승인 범위 준비다. 신규 실험 실행·검증용 코드 작성·제품 수정 권한으로 확대하지 않는다.

## 1. 배경·기존 증거와 미실행

DSG-008의 A/B는 HTML 정보 구조·상태 비교이며 실제 게임 배치·최소창·DPI·폰트·필터·FPS의 승인이 아니다. 현재 제품은 canvas_items/expand·Forward Plus/d3d12, S01의 ScrollContainer 안 가로 지도/편집 배치, 지도 최소390×230·마커72×36·선폭1/4, 우측 최소폭360이다. 이 수치는 현행 구현 관찰이며 제품 목표가 아니다.

`stage1_view.gd`의 map/list/candidate는 안정 역ID로 연결하고 포함역 정보 선택은 모델 명령을 보내지 않는다. 잠금 중 미포함 후보 추가/편집은 막고 포함역 정보 열람은 유지한다. DEV015 결과에는 정상6역·단절·잠금 포커스의 실제 GUI 증거와 W07 자동 회귀가 있다. DEV020에서 W07 322단언을 재실행해 실패0을 확인했다. 이는 이번 새 F08 실험 결과가 아니다.

2026-11-08 DEV020 head `0038347a5ef536881bc49a263a22f251beb4ce38`의 제품 GUI는 Windows / Godot4.7.2 / D3D12 Intel Iris Xe에서 S01→P01/P02→낙찰/계약/정부 지급→읽기 전용P05를 확인했다. [기존 GUI 보고](https://github.com/wisberry2022/MetroManager/pull/95#issuecomment-6719549135). 엔진 로그/화면상 한글 표시가 가능했다는 제한된 증거이며 실제 선택된 한글 대체 글꼴명·OS DPI·최소창·필터 비교·최종 성능을 입증하지 않는다. 요청 창1280×900과 캡처 크기를 동일한 픽셀 척도로 취급하지 않는다.

이번 F08의 T01~04 자동/GUI·배율·폰트 비교·프로파일링은 모두 NOT_RUN. 기존 게임 성공·브라우저620건·W05 191단언을 새 실험 PASS로 재사용하지 않는다. 제품 W05 GUI는 DEV021 미통합이며 본 티켓 범위가 아니다.

## 2. 최소 실행 분할·의존성

하나의 DEV 티켓 아래 네 실험으로 나눈다. 시험용 코드·테마·배율 적용은 격리 실행기에만 존재하며 제품 entry/씬/설정을 변경하지 않는다. 실제 제품 관찰과 합성 fixture/배치 대안을 보고서에서 분리한다.

| 실험 | 포함·입력 / 기대·판정 | 책임·선행 / 최초 차단 |
| --- | --- | --- |
| T01 / F08-01 / S01-T01·04·05 | LAPTOP의 OS/build·GPU/driver·Godot/renderer·OS DPI 관측값·실제 클라이언트 픽셀·뷰포트/논리좌표·실제 배율을 기록. 요청 창 후보1280×720/1600×900/1920×1080과 Godot 배율 후보1/1.25/1.5/2를 한 변수씩 바꾸어 비교. 같은 한글·큰 정수 금액·오류/0/자료 없음·현재/과거/포커스 문자열을 사용. 기본 폰트/시스템 fallback과 설치된 SystemFont 후보를 비교하고 실제 파일/가용성·글리프 실패·잘림·스크롤 접근 여부를 기록 | DEV 환경/재현, Design 가독성·읽기 순서 대조. 폰트·최소창·정밀 치수 확정 전. 시스템 후보가 없으면 실패/미실행을 기록하고 다운로드/설치하지 않음 |
| T02 / F08-02 / S01-T02 | 시험용으로 메모리에 생성한 고정 체크/경계 패턴과 동일 텍스트/선폭을 사용. nearest/linear를 아트 노드별 비교하고 정수1/2, 비정수1.25/1.5를 구분. 원본 텍셀·텍스처 크기·설정·실제 배율·캡처의 위상/번짐/선 두께/글자 선명도 기록. 텍스트를 픽셀 아트와 함께 저해상도 이미지로 굽지 않음 | DEV 기술 비교, Design 시각 판정. T01의 환경/좌표 척도 기록 선행. 최종 아트 원본·필터·표시 방식 확정 전 |
| T03 / F08-03 / S01-T03·04 | 실제12역 ID와 승인6/8역, 5/9역·중복·단절·잠금·겹침·폭 축소·긴 표시 문자열을 검증 전용 fixture로 재현. 후보 추가와 포함역 열람, 지도/후보/노선행 동일 대상, 키보드 포커스·추가/이동/제거/undo 경계, 선택 후 재조회/레이아웃 전환의 계획·원장 불변을 확인. A 가로/좁은폭 세로 전환과 B 하단 배치를 같은 snapshot·명령 API로 비교. 합성 긴 이름/겹침은 표시 fixture이며 실제 역ID/행정 소속/승인 좌표·게임 규칙은 변경하지 않음 | DEV 명령/공급 검증·실제 입력, Track B 표현 대조. 제품 GUI 수용은 해당 UI 소관 Design 별도. T01의 폭/배율 기준 선행. 최종 지도·마커·입력 규격/실제 적용 전 |
| T04 / F08-04 / S01-T06·07 | 시험용 Theme·Control 패널 구성을 비교하여 원본/텍스처·동적 정보·입력/모델 어댑터 분리 가능성과 A/B 정보 보존을 확인. 현재 S01과 별도 실험 배치를 구분해 측정. 12마커/실제간선·6/8역·중복/단절/겹침·긴 텍스트·예측/보고 상태, 정지/1·2·4배속·동일 입력 패턴으로 CPU/프레임 시간·메모리와 갱신/그리기 부하를 원시 CSV에 기록. GUI 갱신 주기200ms 설정을 FPS/응답속도 실측으로 오인하지 않음 | DEV 측정·구조, Design 정보 보존. T01 기준 환경과 T03 고정 장면/입력 선행. 데이터/장면 준비는 병행 가능하나 별도 에이전트 병렬 운용 지시는 아님. 규격 종속 적용·성능 인수 전 |

전체 조합의 무제한 Cartesian 반복이 아니라 기준 창/배율에서 한 변수씩 바꾸는 최소 행렬을 CASES.json에 사전 기록한다. 누락·실패는 해당 행에 NOT_RUN/FAIL로 남긴다. OS DPI는 읽기만 하며 시스템 설정을 자동 변경하지 않는다. 다른 OS DPI/PC가 확보되지 않으면 그 교차 환경 검증은 NOT_RUN으로 남긴다. 창 후보보다 모니터가 작아 실제 크기가 조정되면 요청값과 실측값을 모두 기록하고 요청값 검증 완료로 처리하지 않는다.

숫자 후보는 실험 조건이며 최종 지원 규격·접근성 합격선·FPS 목표가 아니다. 각 실험 완료는 재현 가능한 대안과 원시 증거의 확보다. 합격선이 없는 측정에는 제품 PASS를 부여하지 않는다.

## 3. 정확한 승인 요청 경로 — 신규23개, 제품 파일 수정0

```text
tests/game/run_f08_tests.gd
tests/game/run_f08_tests.gd.uid
tests/game/run_f08_gui_cases.gd
tests/game/run_f08_gui_cases.gd.uid
tests/game/f08_fixtures.gd
tests/game/f08_fixtures.gd.uid
tests/game/f08_experiment_panel.gd
tests/game/f08_experiment_panel.gd.uid
docs/engineering/tasks/DEV-025_F08_TECHNICAL_VALIDATION.md
docs/engineering/tasks/DEV-025_RESULT.md
docs/engineering/tasks/DEV-025_PROVENANCE.json
docs/engineering/evidence/DEV-025_F08_REPORT.md
docs/engineering/evidence/DEV-025_F08_CASES.json
docs/engineering/evidence/DEV-025_F08_VALIDATION.json
docs/engineering/evidence/DEV-025_F08_PROFILE.csv
docs/engineering/evidence/DEV-025_F08_LAYOUT_WIDE.png
docs/engineering/evidence/DEV-025_F08_LAYOUT_NARROW.png
docs/engineering/evidence/DEV-025_F08_FONT_DEFAULT.png
docs/engineering/evidence/DEV-025_F08_FONT_SYSTEM.png
docs/engineering/evidence/DEV-025_F08_FILTER_INTEGER.png
docs/engineering/evidence/DEV-025_F08_FILTER_FRACTIONAL.png
docs/engineering/evidence/DEV-025_F08_MAP_FOCUS.png
docs/engineering/evidence/DEV-025_F08_MAP_OVERLAP.png
```

4개 GDScript는 자동 러너/GUI 러너/고정 입력/실험 패널로 책임을 나눈다. Theme·패턴 텍스처는 시험 실행기에서 메모리상 생성하며 제품 assets에 추가하지 않는다. PNG8장은 같은 실행의 대표 증거이며 전체 실험의 각 조건·결과·원본 해시/행 번호는 JSON/CSV로 추적한다. 추가 캡처·원시 로컬 로그는 제외 경로 .local에 보존하고 공개 Git에 다른 창/개인 화면은 포함하지 않는다. 추가 추적 경로나 제품 연결이 필요하면 이 목록에 암묵적으로 포함하지 않고 경로·영향을 다시 제출한다.

읽기 전용: scripts/ 전체, scenes/ 전체, assets/ 전체, project.godot·export 설정, 기존 tests/game/*·UID, tools/·CI·훅·AGENTS·거버넌스, 기획/디자인/HQ/INF 문서와 등록부. 기존 DEV020 결과/manifest도 변경하지 않는다. 검증 코드가 기존 Session/Control 공개 인터페이스를 소비하는 것은 허용 요청에 포함하되 제품 소스의 무제한 재구성을 포함하지 않는다.

## 4. 폰트·부서/범위 경계

- 이번 요청은 설치된 시스템 글꼴을 런타임에서 읽어 비교하는 범위다. 폰트 다운로드/설치·바이너리 복사/배포·제품 폰트 채택은 제외한다. 시스템에서 보인 한글만으로 폰트 이름·배포 권한·export 포함 여부를 확정하지 않는다.
- 배포 폰트 비교/선정의 후속 입력은 정확한 파일/버전·출처·사용 범위와 라이선스 검토 기록이다. Design이 시각 후보/표본을, DEV가 실제 지원/임포트/글리프/대체 경로를 확인하고 HQ→Owner가 선택한다. 파일 반입/추적 경로가 필요하면 별도 범위 승인 후 진행한다. 따라서 T01 완료만으로 폰트 배포 항목은 CLOSED가 아니다.
- A 잠정 우선/B 비교 유지에 기술적 이견은 없으나 최종 배치·수치 선택은 Design 대조→HQ 통합→Owner 결정이다. A/B/새 폰트를 제품에 적용하지 않는다.
- 기본 L2 기술·표현 협의다. 게임 규칙/경제/세이브·공통 시각/원장을 변경하지 않는다. 정책 변경·부서 충돌·추가 경로가 실제 필요할 때만 해당 영향의 RFC/L3를 제출한다.
- W05 제품 UI(DEV021), W06, W08 VS01 완주(DEV024), W09 Windows export/성능 최종 합격, 전체MVP/VP·사용성 연구·대량 아트/DSG009 제작은 제외한다. 기존 DEV020-GUI-01의 P02/P05 공기 기산 문구 수정도 본 실험에 섞지 않는다.
- Track A 최소 UI에 미확정 F08/Track B 콘셉트를 일괄 선행조건으로 추가하지 않는다. F08은 규격 종속 제작/최종 인수의 해당 시점에 적용한다.

## 5. 검증 명령과 완료 증거 — 실행 승인 후

아래 옵션 중 새 러너는 아직 미작성이다. 명령은 제안이며 실행 성공으로 보고하지 않는다. 엔진 경로는 각 환경에서 확인한 Godot4.7.2 실행 파일을 사용한다.

```text
.venv/Scripts/python.exe tools/policy.py doctor
.venv/Scripts/python.exe tools/policy.py check
.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v
Godot --headless --path . --script tests/game/run_f08_tests.gd -- --evidence
Godot --headless --path . --script tests/game/run_f08_tests.gd -- --verify-failure-exit
Godot --path . --resolution <조건별 요청값> --script tests/game/run_f08_gui_cases.gd
Godot --path . --resolution <동일 환경 기록값>
Godot --headless --editor --path . --quit
```

- 자동: 같은 ID/선택·잠금/경계·0/없음·명령 부작용·snapshot/현재-과거 보존, 정상0/의도 실패1. 기존 W01/W02/W03/W04A/W05/W07/DEV019 UI 러너를 읽기 전용 회귀로 실행하되 같은 SHA의 변경 없는 기존 실행을 재사용하면 새 실행과 구분한다. 제품 코드는 바꾸지 않으므로 외관·성능을 자동 단언으로 대체하지 않는다.
- 실제 GUI: 마우스/키보드로 지도·목록·편집·잠금·복귀·폭/배율별 표시를 직접 조작. 검증 메뉴로 초기 상태를 만든 사실을 표시하고 실제 명령 결과와 분리한다. 정보 열람/거부/반복 조회는 계획·원장 부작용0이어야 한다. 미노출/가림·대상 오일치·포커스 상실은 실패로 남긴다.
- 프로파일: SHA·OS/build/GPU/driver/renderer/창/뷰포트/DPI/배율·폰트 식별 가능 범위·노드/간선 수·상태·입력 순서·표본/워밍업 기간·수집 방법을 CSV/JSON에 기록. 같은 조건에서 frame-time 분포/최대값·관측 메모리를 제시하며 GPU 전용 계측이 지원되지 않으면 NOT_AVAILABLE로 구별한다. 사전 목표 없는 FPS를 PASS라 하지 않는다.
- 제출: 정확한23개 경로, UTF-8/LF·증거 무결성·기존 파일 보존, 정상 훅·Commit 후 fetch/preflight·일반 Push·PR policy/department-policy, provenance REPORT_ONLY. 검사 PASS는 실행/배포 승인이나 최종 제품 인수가 아니다.
- 원시 실행 증거: 초기/입력/기대/실제·안정ID/계획판/명령·게임분·snapshot/revision·종료코드·로그/캡처 해시·측정치·실패/NOT_RUN을 분리한다. 재현 결과를 Issue92의 네 ID 및 S01-T01~07로 되돌려 인계한다.

## 6. Owner 개별 승인 요청

대상 `wisberry2022/MetroManager` / DEV-025 / AGT-DEV-0001 / `codex/DEV-025-f08-technical-validation` / §3 신규23개 경로 / §2·4·5의 격리 실험에 한정하여 다음을 요청한다.

1. 검증용 코드·fixture·문서/증거 작성 및 설치된 Godot/폰트로 자동·프로젝트 로드·실제 GUI·프로파일 실험 실행.
2. 위23개 경로의 정상 Commit.
3. 해당 작업 브랜치 일반 Push.
4. base=main PR 생성·필수CI 확인 및 같은 범위 검수 대응.

유효 기간은 명시 승인부터 DEV025 제출·동일 범위 검수 대응 종료 또는 철회까지다. main 병합·자동병합·force push/공유이력 재작성·릴리스/배포, 제품 파일/OS 설정 변경·새 폰트 반입·타부서 수정·최종 규격 채택은 제외한다. 실제 착수 전 최신 main·같은 범위 유효성·지침·환경을 다시 확인하며 경합/의미 변경이 있으면 영향만 재검토한다.

승인 요청 예시:

> DEV-025의 F-08 격리 기술 실험과 티켓에 명시한23개 경로의 작성·검증·Commit·Push·PR 생성을 승인합니다. 제품 코드·설정과 OS 설정은 변경하지 않고, 새 폰트 반입·최종 규격 확정·main 병합은 별도 승인 대상으로 유지해주세요.

이번 Owner의 티켓 준비·Issue 댓글 지시는 위 실행/Git의 승인이 아니다. 코드·씬·게임 기능 제작이나 실험을 선행하지 않는다. 현재 상태 APPROVAL_PENDING이며 추가 실험을 이미 완료했다고 표시하지 않는다.

## 7. 준비 결과·ID 확인

DEV025는 최신 main 트리·원격 Issue/PR 검색·전체 Issue 목록·로컬/원격 refs·전체 커밋 제목·worktree와 파일명에서 중복 없음 확인 후 선정했다. DEV024는 VS01 통합 전용으로 보존한다. 담당 Agent-ID는 trusted main 등록부의 ACTIVE LAPTOP 개발 리더다.

수행한 것은 요청/RFC/기존 소스·증거 검토와 이 승인 요청서·Issue 등록 준비다. 게임 자동/프로젝트 로드/새GUI/성능·폰트/배율 실험·빌드·Commit/Push/PR/CI는 이번 티켓에서 NOT_RUN/미수행이다. 기존 DEV020 및 Stage1 실행을 이 티켓의 새 실행으로 승격하지 않는다. 정식 제품 규격·F08 전체 CLOSED·DSG008 DONE을 선언하지 않는다.

## 8. 준비 검증·원격 추적 등록

로컬 승인 요청서의 UTF-8/BOM 없음·LF·마지막 개행/후행공백, 정확한23개 고유 경로와 범위·승인대기/NOT_RUN 표기를 읽기 전용 검사로 확인했다. 기존 DEV020 가상환경의 고정 Python으로 본 worktree의 tools/policy.py doctor/check를 실행해 PASS(worktree files499/GDScript35)했다. 이는 문서 준비 검사이며 새로운 F08 게임 검증이 아니다.

Owner의 현재 지시 범위에서 [별도 실행 승인 요청 Issue97](https://github.com/wisberry2022/MetroManager/issues/97)과 [Issue92 개발 검토 회신](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-6719657980)을 등록했다. 이번 등록은 댓글/티켓 게시이며 저장소 파일의 Commit/Push/PR은 없다. 이 파일은 전용 브랜치의 로컬 미커밋 승인 요청서다. 원격에서 Owner가 검토할 수 있는23개 경로·실행/Git 요청 패킷은 Issue97 본문이다. 구현·실험 및 제출 권한은 여전히 APPROVAL_PENDING이다.

Agent-ID: AGT-DEV-0001
Task-ID: DEV-025

## 9. 승계 후 최신 기준·Owner 작업 지시 — 2026-11-15

Owner 현재 개발 대화 원문:

> 개발 에이전트 97번 이슈(DEV-025)에 대한 작업을 진행해주세요

이번 지시를 #97의 T01~04·신규23경로에 한정한 로컬 실험/검증 착수 근거로 적용한다. 원격 최초 패킷의 과거 실행/Git 승인 원문은 확인되지 않았으며 이번 지시로 과거 승인을 소급 생성하지 않는다. Commit·Push·PR·외부 회신/게시·main 병합은 이번 로컬 수행에 포함하지 않고 로컬 결과 검토 후 필요한 제출 승인을 받는다. DEV-026 구현·제품 검증 HOLD 유지.

- 담당: AGT-DEV-0004. HOF-20261114-DEV-AGT-DEV-0001-AGT-DEV-0004 / 전환 효력 2026-11-14 17:37 KST / 티켓별 유효 권한 이전은 기존 Owner 승인 기록 및 INF-010에 연결.
- 현재 main/base: `d673435ce51f8f10604a93a54aa9ba3060d84ebf`.
- 새 로컬 브랜치: `codex/DEV-025-f08-current-validation`. 전임 `codex/DEV-025-f08-technical-validation`의 미커밋 준비 파일과 공유 main은 변경하지 않는다.
- HQ 지시: https://github.com/wisberry2022/MetroManager/issues/97#issuecomment-6891485883 및 https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-6891485146.
- 기존 Design 공급: PR #98 / `docs/design/tasks/DSG-008_DEV025_SAMPLES.md` 및 `common_samples.json`. 최신 main의 기존 동일 입력을 읽기 전용 재사용한다.
- 최초 본문의 W05/W06 미통합 상태는 과거 이력이다. 현재 Session/S01에는 공사·운영·재무/보고·운행 지도 표시가 통합돼 있다. 기존 public snapshot/dispatch와 실제 map signal을 소비하는 격리 어댑터, 현재 S01 Control 참조 관측, 별도 Design 표시 fixture의 결과를 분리한다.
- §3의23개 경로 유지. 제품/기존 테스트/기획·Design·HQ/정책/설정 수정0. 새4개 GDScript와 UID8경로, 문서/JSON/CSV7경로, 대표 PNG8경로다. 추가 원시는 `.local/f08/`에 둔다.

### 9.1 사전 행렬·검증 경계

[CASES](../evidence/DEV-025_F08_CASES.json)에 렌더링53조건·기초 계측22조건과 실제 입력6범위를 실행 전 기록했다. 한 변수 비교 및 A/B 동일 state/profile을 사용하며 전체 조합을 제품 필수 조건으로 확대하지 않는다. 숫자/폰트/배치 후보는 실험 입력이다.

- T01: Windows/GPU/driver/Godot/D3D12, API DPI·창/뷰포트·실측 변환, 기본 fallback/설치 Malgun Gothic 및 정확한 STR-01~07을 기록.
- T02: 기존 승인된 Design 원본128×64 PNG를 메모리 ImageTexture로 읽기 전용 소비. 두 노드의 nearest/linear와 별도 동적 문자, 실제1/1.25/1.5/2 배율을 비교. 최종 아트 아님.
- T03: 실제 Session의12역·6/8·5/9·단절·중복 거부·잠금/정보열람·추가/이동/제거/undo와 표시 전용 긴 이름·겹침을 분리. A/B 배치와 재조회는 모델/계획/원장 부작용0을 검증.
- T04: 현재 S01 Control·격리 A/B, 정지/1/2/4, 같은 샘플/1초워밍업＋2초관측과 스크립트 입력 패턴. 프레임간격/adapter update CPU구간·엔진 process·메모리/노드/draw-call 원시 CSV. GPU전용 계측은 미지원 범위로 표시. 목표 없는 FPS를 PASS로 표시하지 않음.

자동/렌더링 sweep/실제 OS입력/프로파일/프로젝트 로드/빌드는 각각 기록한다. Design 독립 판정·최종 규격 선택·새 폰트 반입/배포·다른 PC/DPI·장시간/최종 성능·DEV-026은 제외/잔여다. 자세한 실행 결과·실패 이력·실측 및 명령은 결과서/보고서/VALIDATION에 연결한다.

### 9.2 로컬 실행 결과

신규23개 경로의 격리 실험·문서/증거를 준비했다. [결과서](DEV-025_RESULT.md), [T01~04 보고](../evidence/DEV-025_F08_REPORT.md), [실행/해시 검증 JSON](../evidence/DEV-025_F08_VALIDATION.json)으로 연결한다. 자동175＋W07 322·실패0, 의도 실패176중1/exit1, 렌더53·기초 계측22조건/2639프레임, 실제 OS입력M01~M06, 정상 main 초기 진입/정지·프로젝트 로드를 구분한다. B 전환 직후 포커스 가림과 겹침 표시의 대체 접근은 Design 검토 항목이다. 최종 규격·F-08 CLOSED/DONE·독립 수용을 선언하지 않는다. Commit·Push·PR·main 병합 별도 승인, DEV-026 HOLD.

## 10. Owner 로컬 결과 수용·23파일 제출 승인 — 2026-11-15

본 개발 대화의 Owner 직접 승인 원문:

> DEV-025 로컬 구현·검증 결과를 승인합니다. 승인된 23개 파일을 codex/DEV-025-f08-current-validation 브랜치에 Commit·Push하고 PR을 생성한 뒤 필수 CI 결과까지 확인해주세요. Design 검토·최종 규격 미확정 상태는 유지하고, main 병합은 별도 승인하겠습니다. DEV-026 보류는 유지합니다.

대상은 `wisberry2022/MetroManager` / DEV-025 / AGT-DEV-0004 / `codex/DEV-025-f08-current-validation` / §3의 승인된 신규23개 경로다. 승인 시점부터 이번 제출·동일 범위 검수 대응 완료 또는 Owner 철회까지 정상 Commit·일반 Push·base=main PR 생성·필수 CI 확인을 수행한다. main 병합·자동병합·force push·공유 이력 재작성·릴리스/배포·Issue 게시/종료는 포함하지 않는다.

승인된23파일을 SHA-256/크기와 대조하고 `.local/f08/submission/approved/`에 원본으로 보존했다. 이번 제출 준비는 승인 기록을 본 티켓/결과서에 후속 추가하고 provenance를 갱신하는3개 파일에 한정한다. 나머지20개 파일·검증 JSON의 당시 상태/실패·원본PNG·CSV·시험 소스는 승인 바이트를 유지한다. 기존 본문을 소급 APPROVED/PASS로 바꾸지 않는다.

fetch로 기준 main `d673435ce51f8f10604a93a54aa9ba3060d84ebf` 동일·동명 원격 작업 브랜치 없음·main의 필수 policy/department-policy 및 strict/관리자 적용/선형이력/force-push·삭제 금지, squash-only/auto-merge=false를 확인했다. 전용 .venv에 저장소 고정 도구를 설치하고 정상 훅·doctor/check·23경로/승인본 보존·커밋 후 preflight와 REPORT_ONLY 출처 검사를 수행한다. 실제 제출 SHA·PR·필수 CI는 생성 후 PR 및 로컬 제출 기록에 연결한다.

로컬 구현·검증 결과 수용은 독립 Design 심사·최종 폰트/창/배율/필터/마커/FPS 규격 확정이나 F-08/DSG-008 DONE을 대신하지 않는다. 제품 적용0·기존 Stage2 수용 유지·DEV-026 구현/제품 검증 HOLD를 유지한다. 이번 제출에서는 게임 자동/프로젝트 로드/GUI/프로파일/빌드를 새로 수행하지 않으며 기존 승인된 실행 소스·증거를 재사용한다.
