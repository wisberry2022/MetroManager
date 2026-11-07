# DSG-005 PR #67 독립 GUI 재검수 보고서 — 재개 결과

2026-11-07 Asia/Seoul. 대상 `bc495d66e99414e6e734df45de283e5d186829c5`. 관련 Issue #59/#63. Owner 전달용이며 공식 승인/DONE 처리가 아니다.

**DSG-QA-01, DSG-QA-02: 이번 실제 GUI 재검수 범위 PASS, 수정 수용 권고. DSG-005 전체 ACCEPTED는 선언하지 않음.** 이전 보고서의 GUI BLOCKED 판정을 이번 실행 범위에서 대체한다. 이전 ZIP은 보존했다.

## 환경 및 증거 구분

Windows native, Godot `4.7.2.stable.official.ed1daf0bf`, 지정 폴더의 console 실행 파일. D3D12 Forward+, Intel Iris Xe. 기존 detached QA Worktree `.local/worktrees/DSG-005-pr67-20261107` 재사용. 실행 명령·SHA·경로는 `launch.json`, 실제 GUI의 모델 출력은 `stdout.log`, 입력 기록은 `actual-inputs.json`, 전후 캡처는 이 디렉터리 이미지다.

기존 연결 실패는 Computer Use 파이프 부재였다. 사용자가 앱 재시작 및 Any App 활성화를 확인한 뒤 이번에는 창 목록·캡처·실제 마우스/키보드 입력이 성공했다. 최초 창 크기/전면 상태 변경 중 입력 거부가 있어 상태를 다시 관찰했고, 최대화 후 검수했다. 인터넷 중단 전의 창 핸들을 재사용하지 않았다.

S=코드 정적 검토, A=자동검사, G=실제 Windows 입력. 이번 G는 `cua_repl`의 native click/pressKey를 사용했다. 신호 emit이나 게임 코드 변경은 하지 않았다. 이미지와 로그가 G 증거이고, 전체 모델 snapshot 불변의 A 증거와 구분한다.

## A/B/C/D 기대와 관찰

| 시나리오 / 실제 입력 | 기대 | 독립 관찰 / 판정 |
|---|---|---|
| A / QA-M02: 지도 S12 → 후보 S12 | 정보 선택만, 명령 없음, revision 불변, 지도/후보/행 선택 일치, 중복 오류 없음 | W07_FOCUS S12가 두 번, 각각 6→6, command_dispatched=false. 사이 W07_COMMAND 없음. 6역 유효 유지, S12 세 영역 선택, 오류 없음. PASS |
| A/D: S12 위 이동 → Undo | 단절 표시 후 정상 복구, 오래된 오류 제거 | reorder accepted, revision 7, DISCONNECTED. 목록 `4. S04 → 5. S12: 연결 간선 없음` 및 수정 안내, 지도 오류선. Undo accepted revision 8, 원래 S01/S02/S03/S04/S08/S12와 유효 표시 복구, gap 문구 사라짐. PASS |
| B / QA-M03: 지도 S01 → 비활성 후보 S05 클릭 시도 | 잠금 중 조회 허용, 신규 추가 금지, 편집 disabled | S01 focus 6→6, 명령 없음. S01 지도/후보/행 선택, 편집 잠금 표시. S05는 회색, 클릭 후 계획/선택 유지, 새 명령 없음. 편집 버튼들도 회색 유지. PASS |
| C / QA-M02-DISCONNECTED: S01 선택 → 제거 → Undo | 정확한 gap 사유와 수정 안내, 제거 후5역 invalid, Undo gap 복구 | 초기 `1. S01 → 2. S03: 연결 간선 없음`, 지도 S01→S03 오류선 일치. S01 focus 6→6. remove accepted revision7, 5역·STATION_COUNT, 옛 gap 사라짐. Undo revision8, 6역·DISCONNECTED와 정확한 gap/지도 복구. PASS |

A의 조회 전후 화면에 예측 미계산/입력판7·계획판6, 게임분360, 자금 C/F/A=1000000 및 R/K/B=0이 유지됐다. 명령 결과를 포함한 전체 내부 snapshot 동일성은 이전 A 등급 W07 회귀의 전체 snapshot 비교로 보강하며, GUI만으로 숨은 내부 상태까지 확인했다고 주장하지 않는다. 관련 캡처: `A-before`, `A-map-S12`, `A-candidate-S12`, `D-moved-gap`, `D-undo-normal`, `B-before`, `B-focus`, `B-disabled`, `C-before`, `C-focus`, `C-remove-five`, `C-undo-gap`.

## 관련 회귀

| 범위 | 실제 입력/결과 | 판정 |
|---|---|---|
| QA-M01 | 지도S01 추가 → 후보S02 추가 → S02 위 이동 → Undo. 지도/목록 모두 [S01] rev1, [S01,S02] rev2, [S02,S01] rev3, 복구 rev4. 명령 로그 각1개 | PASS, 실행 범위 |
| QA-M02 | 정상6역(A), 정상8역 화면, 단절(C/D), 제거후5역 invalid, 8역에서 후보S03 추가하여9역 invalid·STATION_COUNT 확인 | PASS, 실행 범위 |
| QA-M03 | 잠금 조회/추가 차단(B), 이동/제거/Undo(A/C/D) | PASS, 실행 범위 |
| QA-M04 | 모든 마커가 같은 위치에 겹쳐 S12만 보이는 fixture에서 후보S01 클릭. S01이 지도·후보·행에 추가/선택되고1역 rev1 | PASS, 목록 대체 조작 |
| 모델 중복 추가 거부 규칙 | 포함 역 클릭은 focus로 바뀌므로 GUI에서 중복 모델 명령을 강제로 생성하지 않음. 이전 W03/W07 자동 회귀 증거만 연결 | A PASS / 직접 모델 중복명령 G NOT_RUN |

타관할 fixture는 전환만 했고 거부 클릭은 하지 않았다(NOT_RUN). M02의 모든 부정 입력 조합을 재실행했다고 주장하지 않는다. 수동 입력 기록은 주요 도메인 입력의 시각/순서를 기록하며, fixture 전환은 stdout의 W07_CASE_READY와 캡처·이 보고서로 연결한다. 최초 키보드 선택은 의도한 M02 대신 M01에 도달하여 다음 사례 버튼으로 M02를 확인한 후 검사했다.

## 기존 자동검사와 전체 수용 범위

동일 SHA에서 앞서 독립 실행한 W01=219, W02=309, W03=101, W07=273, 합902/실패0/각 종료0을 연결한다. 의도적 실패는 종료1, headless import/main 로드와 정책검사는 종료0이었다. 이번에는 GUI 차단 항목을 보완했고 자동검사를 중복 실행하지 않았다. 기존 자동 실행 로그·명령 원장을 `previous-automatic` 하위 폴더에 첨부한다.

DSG-005의 QA-T01/T02/T03, F01/F02/F03/F04, P01/P02, X01 전체 실조작 검수는 이번 재개 범위에서 NOT_RUN이다. 기존 PASS_LIMITED/UNVERIFIED를 승격하지 않는다. M01~M04도 위 실행한 범위에 한정한다. 빌드/export NOT_RUN.

이번 관찰에서 새 게임 결함은 발견되지 않았다. 최초 연결 차단은 사용자 재시작·활성화 후 해소되었으나 앱 초기화의 상위 원인을 코드 수준에서 확정한 것은 아니다. GUI 로그에 ERROR/WARNING이 없는지 패키징 단계에서 확인한다. 실행 프로세스는 검수 뒤 창 닫기로 정상 종료하고 종료 코드를 별도 기록한다.

## 보존과 권고

실행 후 QA HEAD가 대상 SHA임을 재확인했다. 원본 git status 및 QA 추적 diff는 비어 있었다. 코드·씬·명세·정책 변경, Commit/Push/PR/Merge는 없다. QA 안의 Godot 캐시와 별도 증거만 생성했다.

디자인팀에 두 결함의 수정 수용을 권고한다. 공식 승인은 Owner/디자인팀 판단이며, DSG-005 전체 인수는 남은 항목 검수 후 별도로 판단해야 한다. 명세 변경 필요성은 이번 관찰에서 확인되지 않았다.

ZIP에는 보고서·실제 입력·실행 로그·화면 및 SHA256SUMS를 포함한다. 캡처 확장자는 실제 시그니처로 결정했고, 디코딩 및 ZIP 내부 체크섬을 검증한다. 최종 검증 결과는 `validation.json`을 참조한다.
