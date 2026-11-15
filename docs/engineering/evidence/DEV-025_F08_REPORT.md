# DEV-025 — F-08 T01~T04 격리 실험 보고

- 담당 AGT-DEV-0004 / 2026-11-15 / LOCAL_REVIEW_REQUESTED / DEV_SELF_VERIFICATION.
- 기준 `d673435ce51f8f10604a93a54aa9ba3060d84ebf` + 미커밋 신규 시험 소스. 실제 실행 바이트와 LF 제출 바이트는 [검증 JSON](DEV-025_F08_VALIDATION.json)의 `source_identity`에 구분한다.
- 제품 파일 수정0. F08-01~04의 기술 비교 증거를 확보했으며 **제품 규격·Design 수용·F-08 CLOSED/DONE은 미확정**이다. DEV-026 HOLD.
- 입력: [#97](https://github.com/wisberry2022/MetroManager/issues/97), [#92](https://github.com/wisberry2022/MetroManager/issues/92), [기존 Design 공급](../../design/tasks/DSG-008_DEV025_SAMPLES.md), [사전 행렬](DEV-025_F08_CASES.json). 결과 판정은 RD 초안의 관측 범위에만 적용한다.

## 1. 재현 환경·실행 구분

Windows11 Home10.0.26200 / Intel Iris Xe driver32.0.101.7088 / Godot4.7.2 `ed1daf0bf001b61586d9930840f2f1394092c079` / Forward+/D3D12. 화면 API2880×1800·약60Hz·DPI192. Windows 물리 DPI/설정 배율은 확정하지 않는다. `screen_get_scale=1`은 Windows에서 지원되지 않는 API의 기본값이며 100% 증거가 아니다([공식 DisplayServer](https://docs.godotengine.org/en/stable/classes/class_displayserver.html)).

요청/실측 클라이언트1280×720·1600×900·1920×1080을 각 JSON에 기록했다. 1280×720에서 실제 root 변환1/1.25/1.5/2의 논리 뷰포트는1280×720 /1024×576 /853.3333×480 /640×360이다. OS 창 장식/ComputerUse 논리 이미지642×390와 Godot viewport PNG1280×720은 다른 척도다. 초기 자동 stretch1.11111 관측을 보존하고 격리 runner의 `content_scale_size=root.size`로 통제했다([공식 Window](https://docs.godotengine.org/en/stable/classes/class_window.html)). 제품 project.godot은 바꾸지 않았다.

| 증거 종류 | 실행·내용 | 한계 |
| --- | --- | --- |
| 자동 | `auto-final`175 + `w07-final`322, 실패0·exit0 | 시각/실제 입력 인수 아님 |
| 의도 실패 | `intentional-final`176 중 의도 실패1·exit1 | 정상497 합계에서 제외 |
| 렌더링 | `sweep-05`53조건/53원본PNG·JSON | 스크립트 상태 전환/캡처; 실제 입력53건 아님 |
| 실제 입력 | `manual-02` M01~M06, 캡처7·실제 명령6 | MODEL_SETUP 또는 SAMPLE; 독립 검수 아님 |
| 기존 S01 참조 | `PRODUCT-REFERENCE`, manual007 | 준비된 실제 Session을 기존 S01 Control에 공급; 정상 main/자연 완주 아님 |
| 정상 main | `product-normal`, 초기0역→일시정지394분·exit0 | 정상 진입만 관찰. VS-01 완주 NOT_RUN |
| 프로파일 | `profile-03`22조건·2639프레임·exit0 | 별도 GPU/물리 입력지연/최종 FPS 합격 아님 |
| 프로젝트 로드 | `load-final` headless editor·exit0·엔진 오류0 | 게임 플레이/빌드와 별도 |

전체 원본은 이 worktree의 `.local/f08/`에 보존한다. `runs`에 실행 시각·명령·exit·소스/로그 해시를, 각 조건에 요청/실측과 캡처 해시를 연결했다. 원시 전체는 미게시 로컬 증거이며 저장소에 추가할 대표8PNG/JSON/CSV와 구별한다.

## 2. T01 / F08-01 — 문자·폰트·배율

STR-01~07의 Unicode 원문을 보존하고15자리 `999,999,999,999,999`를 지수/반올림으로 바꾸지 않았다. 한글·숫자·기호577 shaping glyph 중 기본은 Malgun Gothic219/Open Sans SemiBold356/Segoe UI Semibold2, SystemFont 후보는 Malgun Gothic577로 관측됐다. index0 항목6은 문자열 사이 개행이며 표시 글리프 누락은0이다. 실제 사용 파일 후보는 OS API의 `C:/WINDOWS/FONTS/malgun.ttf`; 다른 fallback의 파일/버전 및 배포 권한은 NOT_VERIFIED.

기본/시스템 후보는 서로 다른 굵기·줄바꿈을 보인다. 대표 원본에서 긴 이름·금액·식별문자열·현재/이전 기간은 읽을 수 있었고, 배율을 키우면 화면에 동시에 보이는 정보가 줄어 스크롤이 필요하다. 모든53화면·전체 글리프를 사람이 개별 심사했다고 주장하지 않는다. 폰트 다운로드·설치·복사/배포0, 최종 폰트/최소창/지원 배율 결정은 Design→HQ→Owner 잔여다.

## 3. T02 / F08-02 — 픽셀과 별도 동적 문자

Design 원본128×64 SHA-256 `abd71288e9ce006597a946a6896a7d8a7f6d578c9f941c0b63e8b1ee3da54ca1`을 메모리 ImageTexture로 소비했다. 아트 두 노드만 nearest/linear로 구분하고 문자는 독립 Label로 유지한다. 노드128×64, 원점 x0/260을 사용해 네 배율 모두 같은 정수 픽셀 위상을 맞췄다. PNG는 재인코딩하지 않고 RGB를 읽어 비교했다.

| 조건/필터 | 실제 아트 픽셀 | 색 수 | 원본6색 밖 픽셀 | 정확한 원본 정수 반복과 다른 픽셀 |
| --- | --- | --- | --- | --- |
| T02-S1 / nearest | 128×64 | 6 | 0 | 0 |
| T02-S1 / linear | 128×64 | 6 | 0 | 0 |
| T02-S1.25 / nearest | 160×80 | 6 | 0 | 비정수: 동일 폭 요구 안 함 |
| T02-S1.25 / linear | 160×80 | 74 | 6156 | 비정수: 동일 폭 요구 안 함 |
| T02-S1.5 / nearest | 192×96 | 6 | 0 | 비정수: 동일 폭 요구 안 함 |
| T02-S1.5 / linear | 192×96 | 56 | 8909 | 비정수: 동일 폭 요구 안 함 |
| T02-S2 / nearest | 256×128 | 6 | 0 | 0 |
| T02-S2 / linear | 256×128 | 49 | 14308 | 14308 |

1배 양쪽 및2배 nearest는 원본 텍셀 반복과 완전히 같았다. linear 확대에서는 경계 혼합이 관측됐다. 비정수 nearest에서는 텍셀 반복 폭이 균일하지 않을 수 있으며 이는 같은 폭을 보장하는 조건이 아니다. 이 자료는 필터 선택용 비교다. linear 보간을 제품 결함으로, nearest를 자동 제품 PASS로 규정하지 않는다. 최종 아트 크기·위상·필터 선택 후 해당 조건을 다시 확인한다.

## 4. T03 / F08-03 — 실제 모델·표시 fixture·입력

`MODEL`은 기존 Session/W07 fixture와 명령 API를 소비한다. 12역 ID, 정상6/8역, 임시5/9역 invalid, 단절, 잠금, duplicate 명령 거부를 검증했다. 실제 모델은 임시9역 계획 자체를 허용하고 유효성을 거부한다. SAMPLE의 중복 표시 예시는 실제 계획에 주입하지 않는다. `SAMPLE`은 Design JSON 표시 전용이며 명령 버튼은 비활성이다. 겹침/긴 이름은 복제한 표시 snapshot에만 적용하며 실제 역 좌표·소속·원장·규칙을 바꾸지 않는다.

| 실제 입력 범위 | 입력→관측 | 판정/근거 |
| --- | --- | --- |
| M01 동일 대상/편집 | 지도S01/S12→정보, remove→5역, undo→6역, 후보S05추가→7역, up→같은S05순서 이동, undo2회→원래6역 | 명령6개 모두accepted; 캡처003/이벤트 result·plan 전후; 계획 변경과 정보 선택 구분 |
| M02 배치/재조회 | A→B에서 undo 포커스 유지·scroll0·화면 밖. Tab→predict→refresh가 보이도록 스크롤, Enter refresh 후 A복귀 | **ISSUE_OBSERVED** B 전환 직후 포커스 가시성. 정보6회·reset아닌 제어12회 authority 해시 불변 |
| M03 좁은 폭 | 실제1.5배/논리853.3333폭에서 세로 배치, Tab→Action_up·scroll307 | 캡처005; 버튼까지 키보드 도달 확인. 모든 Tab 순환 조합 인수 아님 |
| M04 긴 이름/겹침 | 모든 마커 표시 좌표 겹침→후보S12 선택→전체 STR01. Tab으로 목록, Up으로S08 정보 | 캡처004. 지도 가림 자체는 ISSUE_OBSERVED; 대체 후보/목록은 동일ID 접근 가능. 겹침해소 최종 규격은 미정 |
| M05 잠금 | F4로 locked fixture 준비, 비활성 후보S05 클릭→명령 없음, 포함S01 지도 클릭→정보 표시 | 캡처006; 준비 상태 전환을 게임 명령/자연 경로로 계상하지 않음 |
| M06 기존 S01 | F6로 준비된 PRODUCT Control 전환, 포함S01 클릭→W07_FOCUS, 계획판6불변 | 캡처007. 별도 정상 main 진입/정지 관찰도 `product-normal`에 보관 |

최종 pixels 전용 크기·위상 보정은 manual-02 이후다. 당시 소스 사본과 캡처를 그대로 보존했고 입력/Session/지도/포커스 코드는 변경하지 않았다. 최종 자동/렌더링/프로파일로 직접 영향 범위를 확인했으며 실제 입력 전체를 새로 했다고 기록하지 않는다.

## 5. T04 / F08-04 — 정보 보존·구조·기초 부하

A/B PAIR-01~12의 텍스트·authority 해시가 동일하고 자동검사는15상태의 정보 보존을 확인했다. Theme/텍스처·동적 Label/지도·입력→Session을 격리 패널에서 분리할 수 있었다. 이 실험은 최종 디자인 충실도나 DEV-026 공급·소비 계약의 제품 통합 검증이 아니다.

고정 순서/같은 프로세스에서 UI 워밍업1초＋관측2초. 정지/1·2·4배속의6역 기준 A/B/기존 S01과8역 겹침·긴문자, 단절·잠금·stale·보고 상태를 비교했다. 30표본마다S01/S12정보 선택을 교대로 호출한다. 워밍업 동안 UI를 그리며 모델 시간은 관측 루프에서만 advance한다. 실제 게임분은 정지360→360,1배360→364,2배→369,4배→379다.

| 조건 | 표본 | 프레임 ms 중앙/p95/최대 | adapter 갱신 ms 중앙/p95 | 전체 프로세스 static MiB 범위 | 게임분 |
| --- | --- | --- | --- | --- | --- |
| T04-MODEL-A-0 | 120 | 16.651 / 16.925 / 17.050 | 0.879 / 1.547 | 102.24~102.25 | 360→360 |
| T04-MODEL-A-1 | 120 | 16.673 / 17.001 / 18.232 | 0.923 / 1.997 | 102.24~102.26 | 360→364 |
| T04-MODEL-A-2 | 120 | 16.669 / 16.978 / 17.291 | 1.026 / 1.749 | 102.24~102.29 | 360→369 |
| T04-MODEL-A-4 | 120 | 16.685 / 17.000 / 17.472 | 1.004 / 1.984 | 102.24~102.33 | 360→379 |
| T04-MODEL-B-0 | 119 | 16.683 / 17.140 / 32.980 | 0.773 / 1.631 | 102.24~102.24 | 360→360 |
| T04-MODEL-B-1 | 120 | 16.686 / 16.973 / 18.651 | 0.841 / 1.714 | 102.24~102.26 | 360→364 |
| T04-MODEL-B-2 | 120 | 16.683 / 17.005 / 17.282 | 0.853 / 1.698 | 102.24~102.29 | 360→369 |
| T04-MODEL-B-4 | 120 | 16.663 / 17.125 / 17.513 | 0.954 / 2.028 | 102.24~102.33 | 360→379 |
| T04-PRODUCT-A-0 | 120 | 16.657 / 17.081 / 18.512 | 1.421 / 2.634 | 102.46~102.46 | 360→360 |
| T04-PRODUCT-A-1 | 120 | 16.697 / 17.038 / 20.322 | 1.460 / 2.312 | 102.44~102.52 | 360→364 |
| T04-PRODUCT-A-2 | 120 | 16.658 / 17.026 / 19.081 | 1.498 / 2.236 | 102.44~102.60 | 360→369 |
| T04-PRODUCT-A-4 | 120 | 16.642 / 17.229 / 19.813 | 1.653 / 2.823 | 102.44~102.77 | 360→379 |
| T04-eight-A | 120 | 16.687 / 16.967 / 17.267 | 0.981 / 1.840 | 103.86~103.87 | 360→360 |
| T04-eight-B | 120 | 16.675 / 16.953 / 17.538 | 0.929 / 1.659 | 103.85~103.87 | 360→360 |
| T04-gap-A | 120 | 16.681 / 17.011 / 22.206 | 0.894 / 1.566 | 103.84~103.85 | 360→360 |
| T04-gap-B | 120 | 16.661 / 17.002 / 17.370 | 0.975 / 1.655 | 103.84~103.85 | 360→360 |
| T04-locked-A | 120 | 16.675 / 16.991 / 17.211 | 0.913 / 1.464 | 103.83~103.84 | 360→360 |
| T04-locked-B | 120 | 16.679 / 16.941 / 17.034 | 0.963 / 1.834 | 103.83~103.84 | 360→360 |
| T04-stale-A | 120 | 16.669 / 16.992 / 19.013 | 1.065 / 1.583 | 103.90~103.91 | 360→360 |
| T04-stale-B | 120 | 16.673 / 16.972 / 17.201 | 0.942 / 1.813 | 103.90~103.91 | 360→360 |
| T04-report-A | 120 | 16.657 / 17.060 / 17.493 | 1.000 / 2.191 | 103.77~103.78 | 1440→1440 |
| T04-report-B | 120 | 16.672 / 16.967 / 17.294 | 0.893 / 1.775 | 103.77~103.78 | 1440→1440 |

p95는 nearest-rank다. 전체 프레임 최대32.980ms는B정지 조건에서 관측했고 원본을 제외하지 않았다. 약60Hz/VSync가 걸린 Debug 데스크톱의 짧은1회 측정이며 성능 우열/최종 FPS PASS를 결정하지 않는다. adapter 구간은 Session advance/선택/snapshot/present를 포함하며 전체 CPU나 GPU시간이 아니다. engine TIME_PROCESS도 원시CSV에 별도 보존한다. 숨긴 패널과 S01이 함께 존재하므로 메모리/노드/draw-call은 전체 시험 프로세스 수치다. 순서·캐시·OS부하·S01 focus 로그 출력 차이가 있으며 GPU 전용 계측은 NOT_AVAILABLE. 장시간/다른PC/export 및 동시 표현 상한은 후속 범위다.

## 6. Design 검토에 전달할 관측

| 기준 | DEV 관측 판정 | 범위/제한 |
| --- | --- | --- |
| RD-01 | NO_ISSUE_OBSERVED | Exact STR01-07 stored; 15-digit integer and full S12 text visible in representative captures; all 15 A/B strings preserved. Not all states manually read at all scales. |
| RD-02 | INCONCLUSIVE | Display strings distinguish current/previous/zero/none/failure; model fixtures are separate. Full Design semantic/visual acceptance pending. |
| RD-03 | ISSUE_OBSERVED | B transition retains Action_undo focus offscreen, scroll0. Tab reaches visible predict/refresh. Overlap hides map targets; candidate/list alternative reaches same ID. |
| RD-04 | NO_ISSUE_OBSERVED | Visible corpus missing glyph0; index0 entries6 are newlines. Default3families/systemMalgun observed. Selected captures readable; crossPC/font distribution not verified. |
| RD-05 | NO_ISSUE_OBSERVED | Texture128x64, separate live text, nearest integer exact texel repetition. Linear interpolation is measured behavior, not automatic defect/PASS. |
| RD-06 | NO_ISSUE_OBSERVED | PAIR01-12 content and authority hashes equal; 15-state automated content equivalence. Not product layout acceptance. |
| RD-07 | ISSUE_OBSERVED | B/narrow layout requires scrolling to actions; B switch does not immediately reveal old focus. Preferred reading flow/final layout remains Design decision. |
| RD-08 | NO_ISSUE_OBSERVED | Pinned base plus actual source hashes, environment/window/transform/font glyph names/raw logs/53capture hashes; exclusions preserved. Physical DPI/identity/otherPC not verified. |

DEV 권고: A 잠정 우선/B 비교 상태를 유지하고 B 전환 시 기존 포커스를 보이는 위치로 복원할지 Design과 결정한다. 마커 겹침 시 후보/목록의 같은ID·전체이름 경로를 유지할 필요가 있다. 폰트·최소창·배율·필터·마커 크기·성능 목표는 이번 결과만으로 고정하지 않는다. 신규 제품/명세 변경이 필요해지는 시점에 정확한 행·범위·승인을 받는다. 현재 명세 변경 요청/RFC를 임의 생성할 이유는 없다.

## 7. 실패·제외·과거 증거 보존

- auto-01은 `Panel` native 이름 충돌 parse failure·exit1. 상수를 ExperimentPanel로 고친 후 auto02/final 정상. 원본 오류 로그 보존.
- sweep01의 실제1.11111 변환, sweep02의 과도한 MODEL JSON 표시, sweep03의 아트 가로 stretch, sweep04의1.25배 필터 원점 위상 차이를 보존한다. 최종 비교는 크기/위상을 고친 sweep05다.
- profile01은 이전 presenter, profile02는 실행 중 소스 수정＋다른 Godot sweep과 겹침이 있어 최종 비교 제외. profile03은 소스 불변·이 작업의 다른 Godot 실행 없음으로 고정했다. sweep05는 렌더링 증거에만 쓰며 시간 측정으로 쓰지 않는다.
- Image.load_from_file의 export 경고1종은 로컬 원본 소비에 따른 관측이며 숨기지 않는다. export 검증을 하지 않았고 제품 import/설정을 바꾸지 않았다. 최종 정상 실행의 엔진 ERROR/SCRIPT ERROR는0.
- CIM 초기 권한 거부 후 읽기 전용 조회 성공, native 캡처 형식은 PNG 가정 대신 실제 JPEG로 원본 보관. 도구 probe를 게임 실패/제품 PASS로 혼동하지 않는다.
- tooling-final89개는88성공/1실패였다. 실패 원인은 Git Bash의 샌드박스 IPC 초기화 `NtCreateDirectoryObject ... 0xC0000022`다. 코드/훅 변경 없이 해당 임시 저장소 검사1개만 샌드박스 밖에서 재실행해성공했다. 고유89조건의 성공 근거를 확보했지만 단일89건 무실패 실행으로 기록하지 않는다. 로컬 증거 감사의 첫 숫자 비교는 JSON의1280.0과문자열1280 표현 차이로 실패했고 정수 비교로 바로잡았다.
- 기존 DEV024 전체3291 및 V05 직접 영향1185는 [원래 검증 기록](../gate3/DEV-024_VS01_VALIDATION.json)을 재사용한다. V05 병합324faf9b…→현재base에서 제품/기존 게임 테스트 변경0을 확인했다. 과거 원SHA·로컬 소스 해시는 원기록대로 유지하며 이번497에 합산하지 않는다.

## 8. 대표 원본8장·나머지 원시

| 제출 PNG | 로컬 원본 | 역할 |
| --- | --- | --- |
| [DEV-025_F08_LAYOUT_WIDE.png](DEV-025_F08_LAYOUT_WIDE.png) | `.local/f08/sweep-05/artifacts/001-PAIR-01-A.png` | SAMPLE A baseline; scripted rendering |
| [DEV-025_F08_LAYOUT_NARROW.png](DEV-025_F08_LAYOUT_NARROW.png) | `.local/f08/manual-02/artifacts/005-MANUAL.png` | MODEL A 1.5x, actual Tab focus/scroll |
| [DEV-025_F08_FONT_DEFAULT.png](DEV-025_F08_FONT_DEFAULT.png) | `.local/f08/sweep-05/artifacts/029-T02-S1.png` | SAMPLE long default, bottom scrolled |
| [DEV-025_F08_FONT_SYSTEM.png](DEV-025_F08_FONT_SYSTEM.png) | `.local/f08/sweep-05/artifacts/033-T01-SYSTEM.png` | SAMPLE long installed Malgun Gothic, bottom scrolled |
| [DEV-025_F08_FILTER_INTEGER.png](DEV-025_F08_FILTER_INTEGER.png) | `.local/f08/sweep-05/artifacts/032-T02-S2.png` | Same-phase 2x nearest/linear; separate text |
| [DEV-025_F08_FILTER_FRACTIONAL.png](DEV-025_F08_FILTER_FRACTIONAL.png) | `.local/f08/sweep-05/artifacts/030-T02-S1.25.png` | Same-phase 1.25x nearest/linear; separate text |
| [DEV-025_F08_MAP_FOCUS.png](DEV-025_F08_MAP_FOCUS.png) | `.local/f08/manual-02/artifacts/003-MANUAL.png` | Actual keyboard refresh focus after A/B transition |
| [DEV-025_F08_MAP_OVERLAP.png](DEV-025_F08_MAP_OVERLAP.png) | `.local/f08/manual-02/artifacts/004-MANUAL.png` | Synthetic display overlap; actual S12 candidate selection/full name |

8장은 편집/리사이즈/재인코딩 없는 바이트 복사다. 전체53렌더·실제입력7캡처·run별 원본/시각/로그/소스 및 실패를 `.local/f08/`에 보관했다. 개인/타 앱 화면을 포함하지 않는다. 다른 PC/DPI·독립 Design 심사·최종 제품 수용·빌드/export·전체VS01 재실행·Commit/Push/PR/CI/main병합은 NOT_RUN/승인 범위 밖이다.
