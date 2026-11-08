# DSG-008 — DEV-025 디자인 입력 로컬 결과

- 담당: Design / Track B / Agent-ID: AGT-DSG-0003 / 2026-11-08
- 상태: REVIEW / OWNER_GIT_SUBMISSION_APPROVED / FINAL_SPEC_PENDING / F08_OPEN / NOT_DONE
- 작업 브랜치: `codex/DSG-008-dev025-samples`
- 기준 main: `e1ccf124a19dd38a40a1462444daa97d4745f90f`
- 승인·사용·판정 기준: [DSG-008_DEV025_SAMPLES.md](DSG-008_DEV025_SAMPLES.md)

## 변경 파일 — 신규5개

| 파일 | 내용 |
| --- | --- |
| [DSG-008_DEV025_SAMPLES.md](DSG-008_DEV025_SAMPLES.md) | Owner 로컬 제작 승인·소비 절차·RD-01~08 가독성 판단 초안·미해결 |
| 본 결과서 | 변경·검증·해시·미실행·검수 범위 |
| [common_samples.json](../assets/source/dsg_008/dev025/common_samples.json) | 기존15상태·12역·긴 문자열7종·우선 비교12쌍·픽셀 레시피/해시 |
| [comparison_board.html](../assets/source/dsg_008/dev025/comparison_board.html) | 네트워크 없는 A/B·상태·long 표본·1/1.25/1.5/2배 픽셀 CSS 비교 |
| [pixel_probe_128x64.png](../assets/exports/dsg_008/dev025/pixel_probe_128x64.png) | 정확한128×64 RGB8 불투명 원본·7개 패턴·무문자 |

원본 상태는 기존 DSG-008 1단계 HTML에서 기본값까지 해석한 표시 fixture다. 현재 실제 게임 실행 snapshot으로 재분류하지 않는다. 보드는 원래 정보 구조/명령 의도·토큰을 재사용하고 표시 부하 블록만 별도 추가했다. 신규 폰트/라이브러리/외부 이미지가 없으며 기존 추적 파일·타 부서·게임 코드·설정은 변경하지 않았다.

## 실행 검증

- 변경 전 `.venv/Scripts/python.exe tools/policy.py doctor`: PASS. 원격 보호·승인 진위 검증은 아니다.
- `.venv/Scripts/python.exe .local/dev025-samples/build_samples.py`: JSON·보드·PNG 생성. `.local`의 생성기/러너/브라우저 프로필·QA 캡처는 이번 정식5파일에 포함하지 않으며 다른 clone에 자동 제공되지 않는다.
- `.venv/Scripts/python.exe .local/dev025-samples/prepare_qa.py`, `node --check .local/dev025-samples/check_board.cjs`, `node .local/dev025-samples/check_board.cjs`: **1466 checks PASS / runtime JavaScript exception0**.
- 기존 보드의620개 브라우저 검사도 이번 파생 보드에서 실제 재실행했다. 게임 규칙 테스트·Godot 증거가 아니다.
- 추가 검사는 JSON/내장/원본15상태 일치, 15상태×A/B×baseline/long×1280/760/375/320 CSS px에서 정보/금액/순서·전체 문자열 보존과 가로 넘침 없음,1280px에서 원본128×64·네 비교 배율의 실제 CSS 표시 크기를 확인했다. baseline의 기존 검증 폭은1200/760/375/320이다.
- 최초 검증에서 검사기의 DOM순서 가정과 border-box 크기 가정을 수정했다. A/B의 시각/문서 순서는 다를 수 있어 샘플 ID별 내용을 비교하고 실제 box 크기를 확인했다. 최종 전수 재실행은 위 결과다.
- Chrome 초기 sandbox 실행이 종료되어 전용 프로필의 headless 실행을 승인된 도구 권한으로 재실행했다. 개인 브라우저 세션·외부 사이트를 사용하지 않았다.
- 기본 A·기본 B·단절 B의 long 표본 캡처와128×64 원본 PNG를 작성자가 시각 확인했다. 보드의 긴 블록·숫자와 픽셀 비교 위치를 확인하는 검토이며 실제 Godot 문자 판독·마커 부하·접근성 인수는 아니다.
- .venv/Scripts/python.exe .local/dev025-samples/check_package.py: PASS. 정확한 신규5파일·기존 추적 파일 무변경, 인코딩/링크, 원본15상태·토큰·내장JSON 일치, PNG CRC/크기/픽셀·해시·1466개 결과를 확인했다.
- .venv/Scripts/python.exe tools/policy.py check: PASS (worktree files=503, GDScript=35, formatter/linter 정상). git diff --check: PASS. 신규 파일 텍스트는 별도 인코딩/공백 검사로 확인했다.

## 원본 무결성

샘플 JSON의 `source_html_sha256`는 기준 main의 기존 원본을 가리키며, 보드의 내장 JSON과 sidecar는 일치한다. PNG의 레시피·팔레트·정확한 해시는 JSON에 있다. 다음 파일 해시는 이 패킷을 옮길 때 사용한다.

| 파일 | SHA-256 |
| --- | --- |
| DSG-008_DEV025_SAMPLES.md | 6831767f84ee7b696f513eb54884a9ef6b173604fbe1f94a79d97edcec043c2a |
| common_samples.json | 513cda44b9a358b7a270a8649121cd1ee5a1730d521297c1934eeb7c36b83a85 |
| comparison_board.html | d762a7faa50ee086eea34e0b7562570facd788c9550b43ca470295e744eb6776 |
| pixel_probe_128x64.png | abd71288e9ce006597a946a6896a7d8a7f6d578c9f941c0b63e8b1ee3da54ca1 |

## 미해결 의존성과 검증 한계

DEV 회신은 수신했으므로 무회신 상태로 기록하지 않는다. 기술 의견 제공과 실제 실험·제품 결정은 구분한다. **F08-01~04는 모두 OPEN**이다. 실제 폰트 식별/글리프/배포·클라이언트/DPI/논리좌표·필터/위상·밀집/키보드·패널 재사용/성능 검증이 필요하다. 최종 환경·폰트·크기·배율·필터·배치·FPS·상한은 미확정이다.

보드의 긴 문구는 별도 표시 부하 블록이다. 실제 마커 라벨 주입·가림·같은ID 명령 실험은 DEV T03에서 수행해야 한다. 합성 역명·큰 숫자·긴ID는 실제 DATA/금액 상한/게임 API가 아니다. 희귀 음절은 진단용이며 제품 지원 범위를 확정하지 않는다. CSS pixelated/auto는 Godot nearest/linear의 실행 증거가 아니다.

| 구분 | 상태·이유 |
| --- | --- |
| 자동 게임 테스트 | NOT_RUN — 게임/실험용 Godot 코드 변경 없음 |
| Godot 프로젝트 로드 | NOT_RUN — 이번은 Design 소비 입력 제작 |
| 실제 게임 GUI·마커 긴 라벨·키보드 편집 완주 | NOT_RUN — 브라우저 의도 기록은 제품 명령 실행 아님 |
| 실제 폰트/fallback 식별·DPI/글리프·Godot 필터 | NOT_RUN — DEV-025 실제 환경 실험 필요 |
| 대상 PC CPU/메모리/프레임 시간·동시 표현 상한 | NOT_RUN — 브라우저 검증으로 대체하지 않음 |
| Windows 빌드·export | NOT_RUN — W09 후속 |
| 외부 사용성·제품 접근성 | NOT_RUN — 별도 검토/승인 필요 |
| main 병합·릴리스·배포 | 미수행 |

최초 보고에서는 신규 Commit·Push·PR·원격 CI·전달을 수행하지 않았다. 후속 Owner가 위5개 산출물의 현재 브랜치 제출과 Issue #92 전달을 승인했으며 [사용 기준 §1](DSG-008_DEV025_SAMPLES.md)에 범위를 기록했다. 제출 head/base·정상 훅·preflight·원격 필수 policy/department-policy·Issue 댓글 링크는 PR에 별도로 기록한다. 공식 AGT-DSG-0003을 선언하되 별도 출처 Manifest는 승인된5개 파일 범위에 추가하지 않으며 REPORT_ONLY 진단은 숨기지 않는다. CI 성공을 신원·승인 인증 또는 최종 제품 합격으로 표시하지 않는다.

## 검수 요청

이번 검토 대상은 공통 상태/문자열/PX 샘플의 실험 입력 적합성과 RD-01~08 판단 기준 초안이다. 승인 제품 규격·최종 화면 확정·DEV-025 실행 승인·Track A 실제 제품 수용 요청이 아니다. 회신 후 DEV 실험 결과를 조건별로 대조하고 HQ→Owner 최종 결정에 연결한다. 게임 명세 변경 필요: NONE. DSG-008 전체·S2-D01·Stage2 DONE을 선언하지 않는다.
