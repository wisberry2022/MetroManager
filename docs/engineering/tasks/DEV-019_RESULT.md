# DEV-019 — W04A 최소 UI 구현 검수 요청

- 담당 Development / LAPTOP / AGT-DEV-0001 / 2026-11-08 / REVIEW. 공식 수용·DONE 및 main 병합은 Owner 별도.
- base main3aad051c46230fae04314e082dcf5b39a1a1004f, branch codex/DEV-019-tender-ui. 실제 제출 head/PR/CI는 Issue75·PR에 기록한다.
- 권한: [티켓 §8·10](DEV-019_W04A_MINIMUM_UI.md#8-owner-실행git-승인-수신-및-잔여-선행조건)의 현재 Owner 직접 구현·검증·Commit·Push·PR 지시. [Design 실제 회신](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6716760279)으로 선행 조건 해소. P05 읽기 전용, main 병합 별도 유지.

## 변경 결과·경로

기존에는 DEV018 입찰 모델을 제품 UI에서 조작할 수 없었다. 이제 S01→P01 공고 목록→P02 고정 조건/현재 자격→응찰 요청/실제 접수→마감 점수/낙찰/탈락→사업 계약/정부 지급→허용된 읽기 전용 P05 인계·복귀를 조작한다. HUD는 기존 단일 Session/Clock을 사용한다.

| 변경 파일 | 효과 |
| --- | --- |
| scripts/ui/stage1_session.gd | DEV018 enable/submit/result/snapshot 별도 중개. 실제 효력분을 기존 일반 dispatch의 현재분 결과로 덮지 않음 |
| scripts/ui/stage1_view.gd | 기존 S01/입찰 패널 진입·복귀·같은 HUD/Clock·포커스/기존 상태 보존 |
| scripts/ui/tender_view.gd 및 uid / scenes/tender_panel.tscn | 목록/상세/읽기전용인계, 현재/당시/원명령 이력, 마감 안내·사유/행동, 정확한 유한소수, 역순 소비 |
| tests/game/run_tender_ui_tests.gd·w019_ui_fixtures.gd·run_tender_gui_cases.gd 및 uid | 자동185단언·분리된 검증전용 GUI/반례·의도 실패 exit1. 제품 main에 fixture 참조 없음 |
| DEV019 티켓·결과·PROVENANCE 및 evidence/DEV-019_* | 승인/기준·실제 공급/검증·명령/시각/원장·소스/원본 해시·PNG11개 |

모델·경제/시간 규칙·DATA·기존 테스트·main.gd·기존 scene/project·정책/CI·타 부서 문서는 변경하지 않는다. 새 규칙/RNG·L3 상정 필요 없음. P05는 **A01-Q12 PARTIAL**이며 이동으로 공사 계약·착공을 실행하지 않는다. 실제 W05 P05 조작/공사·검증 인수는020/021 후속이다.

## 실제 검증·증거

[실제 공급/검수 계약](../evidence/DEV-019_UI_CONTRACT.md), [자동 단언](../evidence/DEV-019_UI_ASSERTIONS.json), [검증/GUI 사건·소스/PNG해시](../evidence/DEV-019_VALIDATION.json)를 함께 검토한다. godot는 설치된4.7.2 콘솔 실행파일이다.

| 구분 | 명령/방법 | 결과 |
| --- | --- | --- |
| 환경/정책 | .venv/Scripts/python.exe tools/policy.py doctor/check | PASS. 원격 보호·신원/승인 인증과 구분 |
| 정책 전체 | .venv/Scripts/python.exe -m unittest discover -s tests/tooling -v | 89tests OK /exit0 |
| 신규 UI 자동 | godot --headless --path . --script tests/game/run_tender_ui_tests.gd -- --evidence=res://docs/engineering/evidence/DEV-019_UI_ASSERTIONS.json | 185checks /0failures /exit0 |
| 실패 감지 | 같은러너 -- --verify-failure-exit | 의도실패1/exit1 |
| 기존 게임 회귀 | run_w01_tests/run_w02_tests/run_w03_tests/run_w07_tests/run_w04a_tests 각 gd러너 | 219/309/101/322/204, 합1155checks /0failures /각exit0 |
| 엔진/제품 진입 | godot --headless --editor --path . --quit 및 --headless --path . --quit-after3 | 각각exit0, SCRIPT ERROR/ERROR 없음 |
| 실제 제품 GUI | 기본main·마우스·정지/4배속·실제 시간대기·Return 복귀 | B01 접수→1800판정86:80→계약/정부금1회→P05읽기전용→P02/P01. C1800000/R800000/F1000000/K0/B0. 정상종료exit0 |
| 검증 전용 GUI | run_tender_gui_cases.gd에서 DEADLINE/ERROR/FRACTION 실제입력 | 1799요청/1800pending→실제ROUND_CLOSED, 오류재조회복구, 재무79.9999/공개79.99997·낮은점수탈락. 정상종료exit0 |
| 독립 Design QA·전체S2/VS01 | PENDING / NOT_RUN | 제출head로 독립 Q01~12 요청, Q12는PARTIAL |
| Windows export/성능·전체MVP | NOT_RUN | 티켓 비범위 |

자동 검사는 B01/B02 독립정상·고정조건·빈/없음/오류·자격, 실제효력359/360/1439/1440/1799/1800/1801·정지/1·2·4배속, pending중복·동일ID·종료회차/대상변경·역순/낡은pending·현재/당시·미제공지급·인계부작용0을 포함한다. 개발 자동 성공을 전체 키보드/좁은창/긴문구 사용성 또는 독립 Design12케이스 PASS로 승격하지 않는다.

실제 GUI는 computer-use 스킬의 sky로 게임 창만 조작했다. 최초 사용자입력/창변경 감지 시 입력을 중단하고 Owner의 “지금 GUI 검증 진행” 응답 후 재관측했다. 빈 여백/제품 내 QA식별자 표시 정리 후 최종소스로 제품을 새로 실행해 다시 검증했다. 중간제품 캡처는 최종제품 캡처로 덮어썼다. PNG11개는 게임창 원본 JPEG의 무편집 포맷변환이며 디코딩 픽셀 동일성을 확인했다. 실행소스/제출소스 해시는 LF정규화 전/후를 명시하고 실행 이후 의미변경 없음이다. 공개 증거에 불필요한 개인 화면/절대경로는 포함하지 않는다.

## 인수·잔여/제출 경계

S2-02/03 GUI·S2-08 W04A부분·S2-11 증거 제출이다. Design L2 착수 수용과 독립 GUI 최종 수용은 별개다. P05 인계 PARTIAL, 실제공사/영업·VS01완주·전체Stage2 DONE은 후속이다.

fetch·정상훅Commit·preflight·일반Push·PR 두 필수CI는 실제 제출시점 SHA로 확인해 Issue75/PR에 추가한다. 강제Push·공유이력재작성·main병합·릴리스·타티켓 실행은 수행하지 않는다. Owner 수용/DONE은 별도다.
