> 최신 제출 후속: 2026-11-15 / OWNER_LOCAL_RESULT_ACCEPTED / GIT_SUBMISSION_APPROVED.
> 과거 준비·로컬 검토·미승인 상태는 당시 이력으로 보존하며, 현재 제출 권한은 티켓 §10·결과서 §5에 기록한다. Design 검토·최종 규격 미확정 및 DEV-026 HOLD 유지.

# DEV-025 — F-08 로컬 구현·검증 결과

- 담당 AGT-DEV-0004 / 2026-11-15 / LOCAL_REVIEW_REQUESTED.
- 기준 main `d673435ce51f8f10604a93a54aa9ba3060d84ebf`; 브랜치 `codex/DEV-025-f08-current-validation`; 미커밋23개 신규 파일.
- [Issue97](https://github.com/wisberry2022/MetroManager/issues/97)의 T01~T04를 로컬에서 수행했다. 제품 소스·설정 수정0, DEV-026 구현·제품 검증 HOLD.

## 1. 검토할 결과

설치 환경/폰트·실제 배율, 픽셀 필터, 실제 Session 명령과 표시 fixture 분리, A/B 정보 보존과 기초 성능을 확인할 수 있는 증거를 마련했다. [상세 보고](../evidence/DEV-025_F08_REPORT.md), [검증 JSON](../evidence/DEV-025_F08_VALIDATION.json), [원시 프로파일 CSV](../evidence/DEV-025_F08_PROFILE.csv)가 검토 정본이다.

| 항목 | 결과 | 남는 판단 |
| --- | --- | --- |
| T01 문자/환경 | 기본3종 fallback·시스템 Malgun 실측, 표시 글리프 누락0, 창3종·실제 배율4종 | 최종 폰트/배포·지원창/DPI·다른PC |
| T02 필터 | 원본128×64·별도 동적 문자,1/2배 nearest 원본 반복 일치, linear/비정수 비교 | 최종 아트·필터·배율 선택 |
| T03 입력 | 실제 편집/undo6명령, 정보·재조회·배치 전환은 모델 부작용0, 잠금·동일ID·좁은폭 키보드 접근 | B 전환 직후 포커스 가림, 겹친 마커 대체 접근/읽기 흐름 Design 검토 |
| T04 정보/부하 | PAIR01~12 동일 정보·authority,22조건/2639프레임 원시 확보 | 장시간/export/GPU/최종FPS·제품 통합 수용 |

기술 증거 확보는 제품 PASS/Design 수용/F-08 CLOSED나 Stage DONE이 아니다. A 잠정 우선/B 비교를 유지하고, 표현상 관측 문제는 보고서 RD-03/07의 구체 행으로 인계한다. 게임 규칙·기획 명세 변경 필요 없음. 제품 적용이 필요해지면 별도 범위를 정한다.

## 2. 권한·승계·범위

[티켓 §9](DEV-025_F08_TECHNICAL_VALIDATION.md#9-승계-후-최신-기준owner-작업-지시--2026-11-15)의 현재 Owner 지시를 #97의23경로·로컬 수행에 한정했다. 최초 승인대기 본문과 전임 미커밋 worktree는 보존했다. 과거 DEV-025 실행/Git 승인 원문은 NOT_VERIFIED이며 소급 생성하지 않았다. 승계 HOF-20261114-DEV-AGT-DEV-0001-AGT-DEV-0004·효력2026-11-14 17:37 KST와 HQ #97/#92 지시를 연결했다.

변경은4개 GDScript＋UID8경로, 티켓/결과/provenance 및 보고/CASES/VALIDATION/CSV7경로, 원본 대표PNG8경로로 정확히23개다. 전체 명단은 [티켓 §3](DEV-025_F08_TECHNICAL_VALIDATION.md#3-정확한-승인-요청-경로--신규23개-제품-파일-수정0) 및 [provenance](DEV-025_PROVENANCE.json)에 있다. 제품 scripts/scenes/assets/data/project.godot·기존 테스트·Design 공급5파일·타부서/정책/CI는 변경하지 않았다.

## 3. 검증·재현

| 구분 | 실제 실행·결과 |
| --- | --- |
| 신규 자동 | run_f08_tests.gd 175개, 실패0·exit0 |
| 기존 직접 회귀 | run_w07_tests.gd 322개, 실패0·exit0; 위와 합계497 |
| 실패 감지 | --verify-failure-exit 176중 의도 실패1·exit1; 정상 합계 제외 |
| 스크립트 렌더 | 53조건·53PNG/JSON. 자동 캡처이며 실제 입력53회 아님 |
| 실제 GUI | manual-02 M01~M06/7캡처·product-normal 초기S01/정지, 각각exit0 |
| 기초 계측 | profile-03 22조건/2639프레임, source_changes=[] |
| 프로젝트 로드 | --headless --editor --quit, exit0·엔진 오류0 |
| 정적/도구 | doctor·policy check(686파일/53GDScript)·gdformat --check/gdlint PASS. tooling89중88성공＋환경실패1은 코드/훅 변경 없이 단독 재검사성공. 원문은 검증 JSON runs 참조 |
| 기존 증거 재사용 | DEV024 전체3291＋V05 직접1185는 원래 SHA/소스 근거로 유지; 이번 신규 합계에 포함 안 함 |

설치된 Godot4.7.2와 기존 `../DEV-024-design-acceptance-handoff/.venv/Scripts/python.exe`를 재사용했다. 실제 full 명령·시각·exit·로그 해시는 검증 JSON `runs`에 있다. 공개 가능한 재현 명령은 다음과 같다. 매 실행마다 새 output 폴더를 지정한다. 실제 실행에서는 .local/f08/run.py가 APPDATA/LOCALAPPDATA/TEMP/TMP와 로그·소스 사본을 run별로 분리했다.

```text
Godot --headless --path . --script tests/game/run_f08_tests.gd -- --evidence --output=res://.local/f08/new-auto/evidence.json
Godot --headless --path . --script tests/game/run_f08_tests.gd -- --verify-failure-exit --output=res://.local/f08/new-failure/evidence.json
Godot --path . --script tests/game/run_f08_gui_cases.gd -- --sweep --output=res://.local/f08/new-sweep
Godot --path . --script tests/game/run_f08_gui_cases.gd -- --profile --output=res://.local/f08/new-profile
Godot --path . --script tests/game/run_f08_gui_cases.gd -- --output=res://.local/f08/new-manual
Godot --headless --path . --script tests/game/run_w07_tests.gd
Godot --path . --resolution 1280x720
Godot --headless --editor --path . --quit
python -m unittest discover -s tests/tooling -v
python tools/policy.py doctor
python tools/policy.py check
```

manual은 F1 A/B, F2 font, F3 scale, F4 fixture, F5 capture, F6 MODEL/SAMPLE/PRODUCT, F7 window, F9 long, F10 overlap, Escape종료다. F4는 MODEL_SETUP 초기화이며 실제 게임 진행이 아니다. PRODUCT는 준비된 S01 Control 비교이며 정상 main 진입은 별도 명령이다. 테스트 코드2파일의 CRLF→LF 제출 정규화만 최종 실행 후 적용했고 정규화 바이트 일치를 기록했다. 이 개행 변경 때문에 GUI 전체를 반복하거나 새 SHA에서 자연 완주했다고 쓰지 않는다.

## 4. 실패 보존·남은 일·검토 요청

초기 parse 오류, 배율/텍스처 크기/위상 probe, 실행 중 소스 수정과 겹친 profile02는 원본을 남기고 최종 근거에서 제외했다. 최종 비교는 sweep05/profile03이다. 로컬 PNG 원본 로드의 export 경고를 숨기지 않았으며 빌드/export는 NOT_RUN이다. 동일 파일을 쓰는 전임 worktree와 공유 main을 변경하지 않았다.

로컬23파일의 내용 검토를 요청한다. Design 독립 심사와 최종 폰트·배치·지원 환경·필터·FPS 목표 결정은 별도 잔여다. Commit·Push·PR·필수CI·main병합·외부 게시를 이번 수행에 포함하지 않았다. DEV-026 HOLD와 기존 Stage2 수용을 유지한다.

정확한23경로·UTF-8/LF·로컬 링크·대표PNG 원본동일·provenance22blob·실행 로그/소스 해시를 `.local/f08/bundle-audit.json`으로 감사했다. import가 생성한151개 미추적 sidecar는 `.local/f08/generated-imports/`로 원본과 해시를 보존한 뒤 제출 경로에서만 제거했다. 기존 추적 파일·stage 변경0, 전임 티켓 본문 포함 보존을 확인했다. 이 후보 blob 감사는 REPORT_ONLY이며 커밋 후 preflight/서버 검사를 대체하지 않는다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-025

## 5. Owner 로컬 결과 수용·Git 제출 후속 — 2026-11-15

Owner는 위 로컬23파일과 검증 결과를 수용하고 다음 제출을 직접 승인했다.

> DEV-025 로컬 구현·검증 결과를 승인합니다. 승인된 23개 파일을 codex/DEV-025-f08-current-validation 브랜치에 Commit·Push하고 PR을 생성한 뒤 필수 CI 결과까지 확인해주세요. Design 검토·최종 규격 미확정 상태는 유지하고, main 병합은 별도 승인하겠습니다. DEV-026 보류는 유지합니다.

권한의 대상·범위·기간·금지는 [티켓 §10](DEV-025_F08_TECHNICAL_VALIDATION.md#10-owner-로컬-결과-수용23파일-제출-승인--2026-11-15)에 기록했다. 이전 §1~4·검증 JSON의 LOCAL_REVIEW/미수행 상태는 당시 이력이며, 현재 원격 제출 상태는 이 후속과 PR의 실제 head/CI 기록으로 연결한다. 과거 미확인 실행 승인을 새로 만들어내지 않는다.

승인23파일 해시가 최종 로컬 감사와 일치했다. 승인 원본·manifest는 `.local/f08/submission/approved/`에 보관했고, 제출 준비에서는 티켓/본 결과서/provenance3파일만 갱신한다. 나머지20파일, 실제 실행/실패 원본과 사진·CSV는 그대로다. source SHA/개행 정규화 일치·기존 본문 보존·provenance22blob·정확한23경로·정상 훅/정책·커밋 후 preflight를 확인한다.

본 worktree의 전용 .venv와 기존 공식 훅을 사용한다. 초기 fetch/패키지 조회가 샌드박스 파일/네트워크 경계로 실패했으나 승인된 정상 실행 권한으로 재시도해 해결했으며 훅·CI·검사를 우회하지 않았다. GitHub 연결 도구에 없는 main 보호 세부 항목은 REST 읽기 전용으로 확인했다.

새 게임 자동·프로젝트 로드·GUI·프로파일·빌드/export는 이번 제출에 대해 NOT_RUN이다. 승인된175＋W07 322, 렌더53, 실입력M01~M06/정상 진입, profile22/2639, tooling88＋환경 실패1의 단독 재검사 성공을 그대로 재사용하며 새 제출 SHA에서 재실행했다고 쓰지 않는다. 제출 SHA·PR·필수 policy/department-policy 및 출처 REPORT_ONLY 결과는 PR/Owner 보고와 `.local/f08/submission/`에 보관한다.

Design 검토 대기, B 전환 포커스 가림·겹침의 대체 접근과 최종 규격 미확정, main 별도 병합 승인, DEV-026 HOLD를 유지한다. 이번 수용/PR 작성으로 Issue 종료·제품 규격·Stage DONE을 선언하지 않는다.
