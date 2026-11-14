# DEV-019 — W04A 잔여 Q03·Q04·Q05 개발 검증 인계

- 작성: 2026-11-14, AGT-DEV-0004 / LAPTOP 개발 리더. 작업 ID DEV-019.
- 상태: **개발 기능 검증 PASS / 환경 진단 포함 / Design 독립 재검수 PENDING / 전체 QA PARTIAL**. Owner 수용·DONE·Stage 완료 기록이 아니다.
- 기준: main `3e8b74c9c3fe7b1aac3ae309da7b62b31b6ef1a6`; 브랜치 `codex/DEV-019-q03-q05-qa`. 검증은 이 base와 로컬 변경으로 수행했다. Owner의 Git 제출 승인은 [티켓 §15](../tasks/DEV-019_W04A_MINIMUM_UI.md#15-q03q04q05-commitpushpr-명시-승인)를 따르며 실제 제출 SHA·필수 CI 결과는 연결 PR 본문에서 확인한다.
- 근거: [Issue #75 최신 범위](https://github.com/wisberry2022/MetroManager/issues/75#issuecomment-6874277838), [Issue #81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6874285961), [Design 공급 방식 수용](https://github.com/wisberry2022/MetroManager/issues/75#issuecomment-6718807286). Owner의 현 세션 직접 지시로 Q03·04·05 구현·검증을 시작했다.
- [기계 판독 결과·460개 자동 단언·441개 증거 대조](DEV-019_W04A_PARTIAL_QA_RESULTS.json). 원장·프레임·원본 PNG·실행 소스는 같은 이름의 원본 ZIP으로 제공하며 파일명·해시는 결과 JSON의 `raw_artifact`를 따른다.

## 인계와 권한

AGT-DEV-0001 → AGT-DEV-0004, generation 2. Owner 지정 효력은 `2026-11-14T17:37:00+09:00`, 후임 인수 확인은 `2026-11-14T17:38:10+09:00`이다. 인계 참조는 `HOF-20261114-DEV-AGT-DEV-0001-AGT-DEV-0004`이다. 업무상 ACTIVE와 main 등록부 반영은 구분하며 이 기준 SHA에서는 REGISTRY_RECORD_PENDING이다. INF-009의 최신 지시에 따라 후속 등록 담당은 Owner이고 별도 INF 인수 승인을 기다리지 않는다. 기존 기록·전임 저자·Convention/DESKTOP 역할은 변경하지 않는다.

티켓별 유효 권한 이전은 Owner가 승인했다. 로컬 검증 결과를 검토한 뒤 Owner가 2026-11-14 현 세션에서 Q03·04·05를 지정 브랜치에 Commit·Push하고 PR 생성·필수 CI 확인까지 명시 승인했다. 초기 Git 승인 대기는 해소됐으며 main 병합·릴리스·배포는 포함하지 않는다. 아래 검증 표의 Git NOT_RUN은 최초 로컬 검증 기록 시점의 상태이고 실제 제출 결과는 연결 PR 본문이 정본이다.

## 변경 범위

| 파일 | 변경 효과 |
| --- | --- |
| `tests/game/w019_ui_fixtures.gd` | B=0/100 독립 초기 상태, 관할 사유 소비 반례, 유효 형식의 B-X 직접 요청, 경과 시간 예산으로 T 완료 관측, 전체 원장·보고 추출 |
| `tests/game/run_tender_gui_cases.gd` | CLI 초기분/배속/종료분/run ID, 검증 전용 직접 요청, 실제 키·마우스 입력 기록, 사건/렌더 시점별 사본·PNG·소스 해시·종료 기록 |
| `tests/game/run_tender_ui_tests.gd` | Q03 자격·무효과·B 대조, Q04 시작 경계·중복 ID, Q05 12조합과 관측기 상한·정지 검증. 총 460단언 |
| DEV-019 티켓·결과·PROVENANCE·이번 인계/JSON/PNG | 이번 변경의 승인 근거, 새 작성자, 검증과 미실행 경계 |

제품 `scripts/`, 씬, 데이터, 게임 규칙, 타 부서 문서, 정책·CI·공용 도구는 변경하지 않았다. 기존 UID를 유지한다. 별도 worktree에서 수행했고 원래 main과 다른 작업물은 보존했다. 프로젝트 import가 이 worktree에 만든 미추적 `.import` 140개만 출처와 경로를 확인하여 정리했다.

## 실제 공급·GUI 결과

| QA | 독립 실행·기대 | 실제 결과 |
| --- | --- | --- |
| Q03 관할 목록 | `Q03-BX`: C01 정상 목록 B01/B02, B-X 직접 요청 | B-X 미노출. 360 요청→361 `UNKNOWN_TENDER`; 실제 Session 경로, 자금 불변·정부 지급 0. 정상 분 처리의 0원 fare 기록은 보존 |
| Q03 관할 소비 | `Q03-OUTSIDE`: 표시 사본만 C02 관할 검사 | `OUTSIDE_JURISDICTION`/관할 불일치·응찰 비활성. 실제 C01 모델의 자격·원장·요청 불변. B-X 거절 결과와 혼동하지 않음 |
| Q03 진행 사업 | `Q03-BUSY`: OTHER restricted=1 | `PROJECT_IN_PROGRESS`/다른 사업 진행 중·응찰 비활성; R=1의 실제 공급 |
| Q03 공기 | `Q03-DURATION`: 2881 필요/2880 허용 소비 반례 | `DURATION_NOT_FEASIBLE`/공기 이행 불가·응찰 비활성. 모델·원장 불변 |
| Q03 B 대조 | `Q03-B0-Q04-360`, `Q03-B100`: C=1,000,000/R=0/K=0/동일 계획·회차·분, B만 0/100 | 둘 다 자격·행동 허용, 제품 버튼으로 360→361 접수 성공. B100은 접수 전 정산으로 C=999,900/B=0, payment=100. 사전/접수/현재 사본을 따로 보존 |
| Q04 시작 전 | `Q04-358`: 제품 버튼 비활성, 검증용 F6 직접 요청 | 358 요청→359 `NOT_OPEN`, 지급 0 |
| Q04 시작 경계 | `Q04-359`: 제품 버튼 비활성, 검증용 F6 직접 요청 | 359 요청→360 접수 성공, 지급 0 |
| Q04 정상 버튼 | `Q03-B0-Q04-360`: 실제 제품 버튼 | 360 요청→361 접수 성공. 목록 복귀 시 B01 선택·목록 포커스 유지도 관측 |
| Q05 자정 전후 | `Q05-1438-{1,2,4}x`, `Q05-1439-{1,2,4}x` | 각각 1439/1440 접수; 실제 경과 시간으로 T1800 완료. 1일 마감보고·2일 현재보고·전체 원장 보존 |
| Q05 최종 접수 | `Q05-1798-{1,2,4}x` | 1799 접수→1800 낙찰·계약·정부 지급 1회, C=1,800,000/R=800,000 |
| Q05 마감 거절 | `Q05-1799-{1,2,4}x` | 1800 `ROUND_CLOSED`, 정부 지급 0, C=1,000,000/R=0. 기존 접수 건의 마감과 별도 세션 |

Q05-1438-1x의 유효 실행명은 `Q05-1438-1x-R2`이다. 앞선 진단 실행은 SceneTree 단축키 callback이 입력을 받지 않아 1438에서 정지한 채 끝났으며 합격 20개에서 제외했다. Node 입력 관측기를 연결한 뒤 모든 유효 실행을 수행했다. 진단 원본도 삭제하지 않고 ZIP에 남겼다.

각 요청은 정지 중 pending으로 유지되며 재개 이벤트 직전 동일 모델 사본을 대조했다. 첫 Q05 1배속 실행은 진행 중 추가 정지/재개 구간도 불변이었다. 동일 ID의 pending/완료 재호출·조회 무효과는 자동 검사 증거이며 GUI 수동 재호출로 표기하지 않는다. 마우스 선택→상세→실제 응찰 버튼은 12개 Q05 및 B 대조 모두에서 수행했다.

Q05에는 시간 점프 버튼을 노출하지 않는다. 매 프레임 `Time.get_ticks_usec()` 차이만 전달하고, T1800까지 필요한 잔여 시간 예산 이하로 소비한다. 분·판정·원장 값을 직접 덮어쓰지 않는다. 모든 분의 7단계 순서와 최종 `BOARDING` 후 `T_COMPLETE`, 1800 초과 0, 실제 경과보다 소비 시간이 크지 않음을 대조했다. 배속별 전체 모델·원장·보고는 실행별 command ID만 정규화하여 같음을 확인했다. 속도/잔여 시간과 렌더 주기 의존 `view_revision`은 원본에 기록하되 동일값으로 강제하지 않는다.

## 재현 방법과 증거 해석

Godot `4.7.2.stable.official.ed1daf0bf`, Windows D3D12/Forward+에서 실행했다. 독립 Design 검수자는 기준 SHA와 원본 ZIP의 테스트 소스 3개를 사용하고 실행 전 SHA256을 대조한다. 실행은 새 증거 디렉터리를 사용해야 하며 기존 `run.json`이 있으면 도구가 거부한다.

```powershell
# $godot는 설치된 4.7.2 console 실행파일. APPDATA는 쓰기 가능한 짧은 전용 경로 사용.
& $godot --path . --resolution 1280x1200 --script tests/game/run_tender_gui_cases.gd -- --case=NORMAL --start-minute=1438 --stop-minute=1800 --speed=1 --run-id=Q05-1438-1x-retest --evidence-dir=res://.local/retest/Q05-1438-1x
```

초기 일시정지에서 B01 선택→상세→응찰 요청→pending 확인→F9 재개→자동 T1800 정지→종료·증거 저장 순서다. Q05는 1438/1439/1798/1799 × 1/2/4를 각각 새 세션으로 실행한다. Q04 첫 두 경우는 358/359에서 F6 직접 B01 요청, B-X는 F7이다. 검증 전용 입력과 제품 버튼을 혼동하지 않는다. Q03 소비 반례는 `BUSY`, `DURATION`, `OUTSIDE_REASON`, B 대조는 `B_ZERO`, `B_ONLY`를 선택한다. F8은 관측·원장·PNG 저장이며 경제 효과가 없다.

`run.json`에 입력/경과 프레임/사건/원장/보고/소스 해시/exit를 기록한다. 사건 `NNN-event.json`과 실제 렌더 시점 `NNN-event.capture.json`은 시점이 다를 수 있다. PNG는 후자의 게임 viewport 원본이며 편집하지 않았다. 외부 개인 화면을 포함하지 않는다. 프레임별 벽시간과 모델 로그로 배속을 확인하고 정지 캡처 한 장만으로 배속을 주장하지 않는다. source SHA256은 실제 실행 파일 바이트(CRLF 포함) 기준이며 Git blob ID와 다르다.

Git 제출 시 테스트 소스는 LF로 정규화했다. 원본 ZIP의 실행 소스에 CRLF→LF만 적용한 바이트와 제출 후보가 일치함을 확인했고 결과 JSON `submission.lf_normalized_source_sha256`에 대응 해시를 기록했다. 검증 후 기능 변경은 없다. 원본 ZIP과 최초 실행 해시는 갱신하지 않았다.

## 검증·환경 진단·NOT_RUN

| 구분 | 명령/증거 | 결과 |
| --- | --- | --- |
| UI 자동 | `godot --headless --path . --script tests/game/run_tender_ui_tests.gd -- --evidence=res://.local/validation/Q03-Q05/assertions.json` | 460단언, 실패 0, exit 0 |
| 실패 감지 | 같은 러너 `-- --verify-failure-exit` | 의도 실패 1, exit 1 확인 |
| 게임 회귀 | `run_w02_tests.gd`, `run_w04a_tests.gd`, `run_w07_tests.gd` | 309/204/322, 합 835단언, 실패 0, 각 exit 0 |
| 원본 증거 대조 | 원본 ZIP의 `analyze_q345.py` | 20개 GUI 실행, 441대조, 실패 0. 알려진 환경 캐시 진단은 별도 필드로 보존 |
| 프로젝트 로드 | headless editor import, headless 제품 `--quit-after 3` | 전용 APPDATA 적용 재실행 및 제품 로드 exit 0, 오류 없음 |
| 그래픽 로드 | 짧은 APPDATA의 제품 `--quit-after 3` | D3D12/Forward+ exit 0, 셰이더 캐시 오류 0 |
| 개발 GUI | 20개 독립 실행·직접 입력 | 전체 exit 0, 스크립트 오류 0. 아래 캐시 진단 포함 |
| 정책/도구 | `tools/policy.py doctor`, `check`, `python -m unittest discover -s tests/tooling -v`, `git diff --check` | 최종 수치·로그는 결과 JSON `validation` 참조 |
| 빌드/export·성능·VS01·W06·전체 Stage·독립 Design 재검수 | 이번 범위 밖 또는 후속 | NOT_RUN |
| Commit·Push·PR·원격 CI·preflight | 이번 로컬 변경 미제출 | NOT_RUN, 별도 Git 승인 후 실제 SHA 기준 검사 |

최초 editor import는 사용자 설정 저장 경로 오류가 있었고 전용 APPDATA로 재실행하여 해소했다. GUI 20개에는 긴 worktree 임시 APPDATA 하위의 셰이더 캐시 디렉터리 6종 생성 오류가 각각 기록됐다. 같은 제품·렌더러의 짧은 APPDATA 로드에서는 이 오류가 사라졌다. 캐시 경로 길이의 영향으로 판단하며 원본 오류를 지우거나 “모든 엔진 오류 0”으로 보고하지 않는다. 해당 GUI 화면·입력·전체 모델 결과는 확보됐으나 깨끗한 환경의 독립 Design 재검수는 후속이다. 실수로 사용한 `--intentional-failure`는 지원 옵션이 아니어서 정상 460단언을 다시 실행했으며 실패 감지 증거로 쓰지 않는다. 올바른 옵션의 exit 1을 별도 확인했다.

정책 도구 전체 89개 중 88개는 최초 실행에서 성공했고, 실제 Git Bash 훅 검사 1개는 샌드박스의 MSYS 객체 생성 거부(`0xC0000022`)로 실패했다. 동일 검사를 승인된 권한으로 임시 저장소에서 재실행해 1개 성공/exit 0을 확인했다. 프로젝트 커밋·병합 없이 검사했으며 전체 89개를 단일 실행에서 성공한 것으로 표기하지 않는다.

## 잔여 인수 경계

Q03→S2-02/03, Q04→S2-03/08, Q05→S2-08의 해당 증거를 보완한다. 개발 증거로 Design 독립 수용을 대신하거나 전체 W06/Track B를 해제하지 않는다. 이미 수용된 QA-001/002·OBS-01·A02~11·Q12 accepted28은 재개봉하지 않는다. Q12 ZIP과 기존 인수 결과는 보존하며 오류 7 정정·전체 VS01·F08·export는 이번 범위가 아니다. 게임 명세 변경 필요 없음. Git 제출은 Owner 승인으로 진행하며 독립 Design 재검수·Owner 수용·main 병합은 별도다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-019
