# DEV-010 — W01 Godot 실행·승인 데이터·초기 상태·자동검사 기반

- 담당: Development Project Leader / LAPTOP / 2026-11-01.
- 상태: **REVIEW / IMPLEMENTED · W01_VERIFIED**. Owner 결과 검수 요청, 전체 Stage/최종 ACCEPTED·DONE 아님.
- 기반 main: `1356c4b2ec824ca51e807bd9754a891aaa57e13d`.
- 작업 브랜치: `codex/DEV-010-w01-execution-foundation`.
- 상위: [DEV-006 #25](https://github.com/wisberry2022/MetroManager/issues/25), [Gate 3-1 분석](../gate3/DEV-006_GATE3_1_ANALYSIS.md).
- 실행 승인 요청: [DEV-010 Issue #44](https://github.com/wisberry2022/MetroManager/issues/44). Issue 게시와 원격 Git 파일 제출은 구분한다.
- 요청: [PM-011-DEV](../../hq/requests/PM-011_DEVELOPMENT_KICKOFF.md) ‘요청된 첫 결과’, [승인 Stage 1](../../hq/PM-011_GATE3_2_APPROVED_PLAN.md), [실행 절차](../../hq/PM-011_GATE3_2_EXECUTION_PROTOCOL.md).
- 승인 명세: [C v0.6](../../planning/PLN-001-C.md), [D v0.9](../../planning/PLN-001-D.md), [DATA v1.3](../../planning/PLN-001_GATE2_DATA_v1_DRAFT.md), [Gate 2 최종 승인 v1.0](../../planning/PLN-001_GATE2_FINAL_APPROVAL.md). 기준 SHA는 위 main이며 파일명의 DRAFT를 미승인으로 해석하지 않는다.
- ID 조사: 기준 main의 티켓·전체 Issue/PR 목록에 DEV-010 없음. 별도 DEV-008/009 worktree는 변경하지 않는다. 미공유 다른 환경의 작업은 UNKNOWN이므로 번호 충돌 발견 시 조정한다.

## 1. 목표·포함·제외

Godot의 실제 메인 진입과 승인 데이터 로드·초기 상태·실패 종료코드를 독립 검증할 최소 기반을 만든다. W02/W03가 이 결과를 소비할 수 있어야 하며 W01 자체가 전체 Stage 완료는 아니다.

포함:

1. `project.godot`에 메인 씬만 연결하고, 씬에서 데이터 버전/초기 회사 상태의 로드 성공 또는 명확한 실패를 관찰한다. 별도 메뉴·상세 HUD·디자인 에셋은 만들지 않는다. 기존 렌더러·엔진 요구·해상도/배율은 보존한다.
2. DATA v1.3 §2~3 및 승인 Stage S1-02의 W01 입력을 코드가 읽을 데이터로 옮긴다. P01/C01/G01~04/D01~08/S01~12의 안정 ID·부모/소속·좌표·허용 간선, 초기 회사 C=1000000/R=K=B=0·이행80/재무100, 시작일06:00과 원본 버전/근거를 포함한다. OD 계산·사업 진행 데이터 전체의 선행 구현은 요구하지 않는다.
3. 데이터의 버전 불일치·중복/누락 ID·고아/순환 부모·존재하지 않는 역 소속/간선 참조를 거부한다. 표시 도형이나 화면 라벨을 판정 원본으로 사용하지 않는다.
4. 초기 회사/게임 시각의 읽기 상태를 명시적으로 생성하고 같은 입력의 재초기화 결과를 비교한다. R/K는 빈 사업별 집계이며 F=1000000/A=1000000은 초기 상태 확인값이다. 지급·예약·정산 등 원장 동작은 이번에 구현하지 않는다.
5. 별도 headless 테스트 진입점이 정상·부정 입력을 실행하고 실패 시 비정상 종료코드를 반환한다. 성공/실패·버전·초기/기대/실제 값을 로그로 구별한다. 잘못된 입력을 승인 데이터 파일 자체에 덮어쓰지 않고 테스트에서 복제·변형한다.

제외: W02 시간 진행/배속·거래/명령 처리·원장·자정 마감, W03 노선6~8역 판정·OD/예측 계산, W04~06, W07 지도/목록·상세 UI, 아트, 사용자 저장/복원·범용 프레임워크/Autoload, Windows export·FPS/외부 사용성·VP E2E, 승인 기획/공통 정책·CI·타 부서 파일 수정.

## 2. 실행 시 변경할 파일

아래는 **Owner가 이번 실행/Git 제출을 승인한 실제 변경 경로**다. 경로 추가·범위 확대가 필요하면 승인 범위를 다시 확인한다.

| 경로 | 용도 |
| --- | --- |
| `project.godot` | 메인 씬 연결만 |
| `scenes/main.tscn` | 최소 제품 진입·초기화 결과 관찰 |
| `scripts/main.gd` | 씬 초기화/실패 표시·종료 처리 |
| `scripts/data/gate2_data_loader.gd` | 승인 입력 로드·버전/ID/참조 검증 |
| `scripts/model/initial_company_state.gd` | 초기 상태 생성·읽기 값 |
| `assets/data/gate2_w01_v1_3.json` | 위 W01 승인 데이터와 출처 |
| `tests/game/run_w01_tests.gd` | 독립 자동검사 러너·정상/부정 fixture |
| 위 신규 `.gd` 각각의 `.gd.uid` | Godot가 실제 생성할 때 원본과 함께 추적 |
| `docs/engineering/tasks/DEV-010_W01_EXECUTION_FOUNDATION.md` | 승인 원문·검수 결과 연결 |
| `docs/engineering/tasks/DEV-010_RESULT.md` | 변경 파일·실제 검증·NOT_RUN·미해결 기록 |
| `docs/engineering/collaboration/WORK_STATUS.md` | 개발 작업/인계 상태 |

명시적 소스 참조·독립 로더/초기 상태와 작은 테스트 러너를 사용한다. 구체 API는 구현 시 DEV가 결정하며 HQ의 노드/클래스 재승인을 요청하지 않는다. 버전 필드는 개발 입력 식별자이며 승인 규칙 버전 자체를 변경하지 않는다.

## 3. 인수 기준·검증 계획

| ID / 연결 | 초기·입력 / 기대·증거 |
| --- | --- |
| W01-AC01 / S1-01 일부 | headless 프로젝트 로드 exit0와 GUI 메인 씬 진입을 각각 기록. GUI에 초기화 결과 관찰, 실행 버전/코드 SHA/로그·캡처 연결 |
| W01-AC02 / S1-02 일부·F-COMP-001·AC-10 초기 | 승인 입력으로 회사 city=C01, C1000000/R0/K0/B0/F1000000/A1000000, 시작일06:00·고정 초기 능력 확인. 동일 입력 재생성 결과 일치 |
| W01-AC03 / S1-02 일부·F-ADM-001·AC-01 초기 | 1도/1시/4구/8동/12역·안정 ID/소속/간선이 원본과 일치. 버전 오류·중복/누락/고아/순환·잘못된 참조 각각 거부 |
| W01-AC04 / S1-09 일부 | 자동 러너 정상 종료0. 테스트 전용 의도적 실패 인수로 비정상 종료도 확인하고 정상 실행과 로그를 구분. 실패 입력은 초기 정상 상태를 부분 변경하거나 난수/경제 효과를 만들지 않음 |
| W01-AC05 / 후속 공급 | 버전·안정 ID·읽기 초기 상태·테스트 입출력과 실패 기준을 W02/W03 인계. W02 명령/snapshot의 실제 갱신·W03 예측 구현으로 확대하지 않음 |

아래 명령은 승인 후 실행/제출 검증에 사용한다. 실제 결과는 [DEV-010 결과](DEV-010_RESULT.md)에 별도로 기록한다. Godot 경로는 LAPTOP 환경 기준이다.

```powershell
.venv/Scripts/python.exe tools/policy.py doctor
.venv/Scripts/python.exe tools/policy.py check
.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v
& '../godot/Godot_v4.7.2-stable_win64_console.exe' --headless --editor --path . --quit
& '../godot/Godot_v4.7.2-stable_win64_console.exe' --headless --path . --script res://tests/game/run_w01_tests.gd
& '../godot/Godot_v4.7.2-stable_win64_console.exe' --headless --path . --script res://tests/game/run_w01_tests.gd -- --verify-failure-exit
& '../godot/Godot_v4.7.2-stable_win64.exe' --path .
# 승인된 커밋 이후 fetch를 수행하고 제출 직전 실행
.venv/Scripts/python.exe tools/policy.py preflight
```

GUI 시작·초기 상태 관찰은 W01 증거이고 시간/지도/목록 실제 조작은 후속 Stage 통합 증거다. 자동 규칙·headless 로드·GUI·도구 테스트를 구분한다. Windows 빌드/성능·외부 사용성·전체 AC/VP는 NOT_RUN으로 유지한다.

## 4. 후속 분할·협업·영향

- **W01 / L1 제안:** 승인 입력을 그대로 로드·초기화하는 개발 내부 작업이다. 이번 단계에 Design 에셋·Planning 새 규칙 입력을 선행으로 요구하지 않는다. 상태 표시 의미가 기존 계약과 달라지면 해당 행만 L2 검토한다.
- **W02-A/B / W01 이후 별도 티켓:** W01 버전/초기 상태·러너를 소비한다. 시간 진행/명령 효력·멱등성 → R/K/B·원장/마감의 독립 검증 단위로 나눈다. 같은 T 계약과 후순위 운임 분리, R/K 보호·B 상환·CLOSE-01·자정/분할·배속/중복 회귀를 완료 조건에 포함한다. 공통 시간/원장 L3 위험은 실행 티켓에서 추적하며, 실패는 W02 수용과 의존 UI 통합만 차단한다. 승인 정책 변경 필요 시 해당 변경만 HQ/Owner에 상정한다.
- **W03-A/B / W01 이후 별도 티켓·W02와 병행 가능:** W01 안정 ID/부모/역/간선을 소비한다. 노선 유효성 → OD/예측·revision/없음/0/실패의 독립 검증 단위. W02와 파일 변경을 분리하고 동일 데이터 버전을 사용한다.
- **최소 UI / 해당 화면 통합 전:** DEV가 simulation_minute/day_id·snapshot_revision/observation_phase·상태·reason/allowed_actions·노선/예측 revision 및 실제 정상/실패/오래된 응답 fixture를 공급한다. Design은 영향 화면만 소비/검수한다. W01의 정적 초기값을 완성된 동적 snapshot 계약으로 표시하지 않는다. 입력 대기는 해당 UI 통합만 차단한다.

## 5. 개별 Owner 승인 기록

- 저장소/담당: `wisberry2022/MetroManager` / Development / DEV-010 / LAPTOP.
- 요청 범위: 본 티켓 §1~3의 W01 구현·검증과 §2 경로. 브랜치 `codex/DEV-010-w01-execution-foundation`, base는 실제 승인 후 착수 시 최신 main 재확인.
- 승인 동작: W01 로컬 코드/씬/데이터·최소 설정 변경, 검증 후 Commit·해당 작업 브랜치 Push/규정에 따른 공유·base=main PR 생성/필수 CI 확인. 모두 이번 Owner 원문 범위에서 허용.
- 기간/종료: Owner 명시 승인 시점부터 해당 W01 결과 PR 제출·필수 CI 및 검수 대응까지, 동일 포함/경로 내 수정만. W02/W03나 향후 티켓으로 승계하지 않는다.
- 금지: main 직접 쓰기/Merge·강제 push·릴리스/배포·검사 우회·타 부서·공통 정책/CI 변경·승인 규칙 변경. 두 필수 CI·최신 main/단일 부모/preflight 규정 유지.
- 최초에는 PM-011-DEV에 따라 승인용 티켓/Issue만 준비했다. 이후 Owner 현재 채팅 원문: “개발 에이전트. Issue #44의 DEV-010 W01 구현과 해당 브랜치의 Commit·Push·PR 생성을 승인합니다. 티켓 범위에 한해서 작업하고 검증 후 PR 생성해주세요. main 병합은 별도 승인하겠습니다.”
- [승인 수신 Issue 기록](https://github.com/wisberry2022/MetroManager/issues/44#issuecomment-6556639375). 승인자는 Owner, 대상 저장소·작업·경로·브랜치·기간/금지는 위 항목을 따른다. 이전 DEV 권한은 재사용하지 않는다.

## 6. 이번 구현 결과

초기 승인용 티켓1개 준비 후, 별도 Owner의 W01 구현/Git 승인에 따라 메인 씬·승인 입력 로드/검증·초기 상태·자동검사·UID를 구현했다. [결과](DEV-010_RESULT.md)에 변경 파일/실제 자동·엔진·GUI 증거·후속 인계·NOT_RUN을 기록한다. W02/W03·전체 Stage 구현은 미수행이다. 명세 변경 필요 없음. PR/CI/head는 제출 PR 본문에서 확인하며 main 병합은 별도 Owner 승인이다.
