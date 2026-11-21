# DSG-008 — PM-021 F-08 후속 준비 결과

- 작성: Design Track B / AGT-DSG-0003 / 2026-11-21 / v0.1.
- 상태: **LOCAL_REVIEW_REQUESTED / DEV_CONFIRMATION_PENDING / FINAL_SPEC_PENDING / PRODUCT_APPLICATION_SCOPE_PENDING / F08_OPEN**.
- 기준: `fa968b94641d24e8d68b3c6cb903f9e809d02814` / PM-021 PR #159 main 반영본.

## 1. 요청과 수행 범위

Owner 요청: “디자이너 에이전트 HQ로부터 신규 지시사항(PM-021)이 발생했으니 확인하여 followup 해주시기 바랍니다”. [PM-021](../../hq/tasks/PM-021_STAGE3_F08_DIRECTIONS.md) 및 갱신된 [Track B 요청](../../hq/requests/PM-020_DESIGN_B_STAGE3.md)을 확인하고, 승인 방향 연결과 DEV 공동 적용표의 Track B 입력을 로컬로 준비했다. 이 결과는 신규 구현·실험·Git 게시·이슈 전달 권한이나 Stage 완료 승인이 아니다.

[Owner 결정](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335)에 따라 **O-01~07 권고 방향은 전부 승인 완료**다. 과거 미선택 기록은 당시 사실로 보존하고 현재 방향 승인과 구분한다. 같은 방향의 재승인을 요청하지 않는다. 최종 규격 확정과 제품 적용 범위 합의는 남아 있다.

## 2. 로컬 산출물

| 파일 | 변경 효과 |
|---|---|
| [기존 Owner 선택안](DSG-008_F08_OWNER_OPTIONS.md) | v0.1 원문을 보존하고 현재 효력 안내와 §5 승인 후속을 추가 |
| [공통 적용 준비표](DSG-008_PM021_F08_APPLICATION_MATRIX.md) | O01~07/M01~05별 재사용·조사 경로·최소 검증·담당/시점·권한 잔여를 정리. DEV 확인 전임을 명시 |
| 이 결과서 | 요청 범위·검증·미해결·NOT_RUN과 검토 지점을 기록 |
| [출처 선언](DSG-008_PROVENANCE.json) | 위 Markdown 3개의 기준 SHA·원본/현재 blob·작성자·근거를 기록. REPORT_ONLY이며 승인·실행 증명이 아님 |

별도 브랜치 `codex/DSG-008-pm021-application-readiness`의 격리 worktree에서 준비했다. 공유 main의 기존 데이터 변경 2개를 보존했다. 커밋·푸시·PR·병합·이슈 댓글은 수행하지 않았다.

## 3. 다음 담당과 적용 시점

| 항목 | 현재 상태와 후속 |
|---|---|
| 승인 방향 | O01~07 완료. 방향 자체의 재승인 불필요 |
| DEV 공동 적용 확인 | 준비표의 현행 재사용/변경 없음 판단, 실제 경로·자기 티켓·최소 검증·유효 권한을 DEV가 확인. 현재 **DEV_CONFIRMATION_PENDING / NOT_SENT** |
| Track A 기능 영향 | 실제 변경을 특정한 행에 한해 기능 영향과 기존 수용 재사용 범위를 연결. Track B가 기능 승인이나 구현 범위를 대리 확정하지 않음 |
| M01 | B 또는 관련 배치 채택 전. A 임시 유지의 전역 차단 조건으로 확대하지 않음 |
| M02 | 실제 밀집 마커/목록 변경 전. DEV025의 기존 근거를 재사용하고 영향받는 부분만 보완 |
| M03 | 폰트 도입·지원 규격 확정 전. 버전·권리·fallback·대상 환경 가독성 확인 |
| M04 | 규격 의존 아트/필터 적용 전. 실제 크기·텍셀 위상·텍스트/포커스 선을 대조 |
| O06 | 실제 제품 변경 시 최소 역할 분리. 전체 구조 개편을 지시하지 않음 |
| M05 | 대상 환경/성능 인수 시. 목표·부하·측정 구간을 확정한 뒤 검증 |

일정은 **NOT_ESTIMATED**다. 현재 소스 조사 경로는 제품 수정 승인 목록이 아니다. DEV 공동 확인과 실제 적용 범위가 정해진 후 필요한 추가 Owner 판단을 특정한다. 현재 S3-10 A는 적용표 준비 단계이며 C 통합 인수·S3-12·Stage 최종 인수는 별도다.

## 4. 검증과 이력 보존

문서 검증은 `DSG-008_PM021_F08_APPLICATION_MATRIX.md`의 원문 링크·소스 경로와 기준 SHA를 대조했다. 기준 `ae614d922c837eddf4e615fda985bd978e217461`부터 현재 main까지의 변경은 문서 경로에 한정되어 제품 소스·테스트·설정 변경이 없음을 확인했다. 이는 기존 증거의 적용 경계 판단이며 DEV025 재실행이나 현재 SHA의 신규 게임 검사 PASS가 아니다.

검증 명령: 루트 `.venv/Scripts/python.exe tools/policy.py doctor`, 격리 worktree에서 같은 Python으로 `tools/policy.py doctor` 및 `tools/policy.py check`, `git diff --check`, UTF-8/LF·상대 링크/경로·기존 Owner 선택안 원문 포함·출처 blob 대조. 최종 실행 결과는 아래 로컬 검증 기록에 기재한다.

과거 DEV025의 자동 검사/렌더 캡처/수동 관측/Debug 성능 표본 및 PARTIAL은 원본 기록을 재사용하며 새 실행 횟수로 세지 않는다. PR157 당시 미선택·출처 진단도 당시 기록으로 보존한다. 새 출처 선언은 과거 제출 진단을 소급 정정하지 않는다. DEV026 현재 공급의 한정 수용과 P07 일반 재진입/문맥 복귀 구분은 유지하며 W04B 후속 공급이나 전체 Stage 인수로 확대하지 않는다.

## 5. F-08 미결과 NOT_RUN

- **F-08 미결:** 배포 폰트/버전/권리/fallback, 최소창·지원 배율·DPI, 최종 필터·아트 규격, B/반응형 채택과 포커스 경로, 마커/목록 표현, 제품 재사용 단위, 성능 목표·인수 환경. O02/O07의 보류 방향은 승인 완료이며 최종 수치가 미확정이다.
- **과거 PARTIAL:** B 전환 시 포커스 가시성·겹침 마커 판독 등 기존 제한을 유지한다. 승인 방향만으로 수정/검증 완료로 바꾸지 않는다.
- **이번 NOT_RUN:** 신규 자동 게임 검사, Godot 프로젝트 로드, 실제 OS GUI/게임 플레이, DEV025 전체 재실험, 새 폰트 권리·번들 검증, 대상 DPI/지원 환경 인수, 성능 재측정, 빌드/export, DEV 공동 검토. 미실행을 미결 규격과 합치거나 PASS로 승격하지 않는다.
- **명세 변경 필요 여부:** 게임·경제·시간·세이브 규칙 변경 요구 없음. 승인된 디자인 방향의 제품 적용 상세는 DEV 공동 대조 후 특정하며 현 단계에서 최종 규격을 변경하지 않는다.

## 6. 로컬 검토 요청

Owner에게 승인 방향 연결의 정확성과 공통 적용표의 Track B 준비 범위를 검토 요청한다. DEV 공동 확인 전 상태와 F-08 미결을 유지한다. 이 로컬 검토 요청은 커밋·푸시·PR·원격 전달 승인 요청이나 최종 규격 확정 요청을 포함하지 않는다.

### 로컬 검증 기록

루트 및 격리 worktree의 doctor: PASS(원격 보호 확인 아님). 격리 worktree의 check: PASS(worktree 731개, GDScript 57개). git diff --check: PASS. UTF-8/LF·상대 파일 링크·원문 포함·출처 blob 검사는 PASS. 이 파일 수는 출처 선언 생성 전 검사 기준이며 신규 제품 실행 수가 아니다. 커밋 후 preflight는 NOT_RUN(커밋하지 않음).

## 7. Owner 제출 승인 후속 — 2026-11-21

초기 로컬 검토 상태와 미게시 기록은 위에 보존한다. 이후 이 채팅에서 Owner가 다음과 같이 승인했다.

> DSG-008 PM-021 후속 산출물 4개의 커밋·푸시 및 PR 생성을 승인합니다. O-01~07 방향 승인과 과거 기록을 보존하고, DEV 공동 확인 대기·최종 규격 미확정·F-08 미결·PARTIAL·NOT_RUN을 PR에 명시해주세요. main 병합은 하지 마세요.

대상은 `wisberry2022/MetroManager`, 작업 DSG-008, 현재 `codex/DSG-008-pm021-application-readiness` 브랜치의 위 4개 파일이다. 허용 동작은 이번 커밋·일반 푸시·PR 생성으로 한정된다. main 병합·릴리스·배포·신규 제품 구현/실험·이슈 댓글은 포함하지 않는다. 승인 출처는 현재 Owner 채팅의 이 요청이며 공개 승인 댓글 URL을 만들어내지 않는다.

제출 전 fetch 결과 origin/main은 기준 `fa968b94641d24e8d68b3c6cb903f9e809d02814`와 동일하다. 기존 검증 도구 환경을 worktree의 무추적 `.venv` 연결로 재사용하여 훅을 정상 실행한다. 커밋 후 preflight·실제 head의 원격 CI와 출처 진단은 PR에서 보고한다. 위 초기 로컬 단계의 NOT_RUN을 소급 PASS로 바꾸지 않는다. DEV 공동 확인 대기·최종 규격 미확정·F-08 미결·기존 PARTIAL·제품 실행 NOT_RUN과 S3-12/Stage 별도 인수 상태는 그대로다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008
