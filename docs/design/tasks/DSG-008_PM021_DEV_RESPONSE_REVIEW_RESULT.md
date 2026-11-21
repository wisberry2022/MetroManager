# DSG-008 — PM-021 DEV 공동 확인 회신 검토 결과

- 작성: Design Track B / AGT-DSG-0003 / 2026-11-21 / v0.1.
- 상태: **LOCAL_REVIEW_REQUESTED / DEV_RESPONSE_REVIEWED / FINAL_SPEC_PENDING / PRODUCT_APPLICATION_SCOPE_PENDING / F08_OPEN**.
- 기준 main: `1a941196cc6d963db93a9fba6a0386b16710aa46` (DEV027 문서 PR161 병합본).

## 1. 요청·근거·판정

Owner의 “개발 에이전트가 이슈 #92에 공동 확인 회신을 등록했으니 확인해주세요. 회신을 바탕으로 DSG-008 공통 적용표의 후속 반영 범위와 남은 미결 항목을 정리하고, 최종 규격 미확정·PARTIAL·NOT_RUN을 구분해 로컬 산출물로 먼저 검토 요청해주세요”에 따른 로컬 문서 작업이다.

[DEV 회신 #7057935798](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057935798), [DEV027 계획 §12](../../engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md#12-pm-021-후속--f-08-공통-적용표의-dev-검토안), [Track A 영향 행](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057637207), [Track B 전달](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057792628)을 대조했다. DEV의 **준비·재사용·조건부 적용 경계에 기술적 이견 없음**을 수신했고 Track B 정적 검토에서도 이 범위에 추가 이견은 없다. 최초 회신 대기 단계는 해소됐으며 최종 규격·제품 적용·새 L2/공동 인수 완료는 아니다.

DEV 문서의 LOCAL_REVIEW/NOT_SENT·공동 검토 대기 문구는 당시 작성 이력으로 읽는다. PR161 병합 및 이번 #92 회신과 연결하여 현재 수신 사실을 갱신하되 과거 원문은 보존한다. [Owner O01~07 승인](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335)과 PR160 방향 연결도 유지하며 재승인을 요청하지 않는다.

## 2. 로컬 산출물·후속 반영 범위

| 산출물 | 범위 |
| --- | --- |
| [공통 적용표 v0.2 반영안](DSG-008_PM021_F08_APPLICATION_MATRIX.md) | PR160 v0.1 원문을 바이트 그대로 보존하고 현재 효력 안내·§6 O/M 7행을 추가. 수신 사실, DEV의 변경0 판단, 조사 후보/실제 공급 공백·최소 경로/검증을 연결 |
| 이 검토 결과서 | 변경 효과·미결/담당·권한·검증/NOT_RUN·로컬 검토 요청 |
| [출처 선언](DSG-008_PROVENANCE.json) | 이번 Markdown2개만 기준 SHA/원본·현재 blob으로 선언. PR160 manifest는 기준 Git 원본에 보존. REPORT_ONLY이며 승인·실행 증명이 아님 |

후속 반영의 핵심은 O01 F-BUNDLE 후보 NOT_DEFINED→DEV 조사 후보 식별, O05 제품 전체 이름 공급의 부재 확인, O06 DEV027 최소 적용 단위 연결이다. 후보 식별을 폰트 선정·반입/권리 검증으로, ID 기반 재사용을 긴 전체 이름의 제품 공급 완료로 바꾸지 않는다. 구체 후보·조건부 경로·필수 기준은 공통표 §6의 한 묶음으로 관리한다.

## 3. 남은 미결과 다음 담당

| 잔여 | 필요한 다음 입력/판단 | 담당·실제 적용 시점 |
| --- | --- | --- |
| F08-01 / M03 폰트 | Noto Sans CJK KR 2.004는 DEV 조사 후보만. 사용 범위·실제 파일/해시·고지 구성·추가 경로·유효 반입/실행 권한, fallback/영향 문자열 대조 필요 | DEV 구성·Track B 판독, 필요 선택/권한은 Owner. 폰트 반입/규격 확정 전 |
| F08-01 / O02 지원 규격 | 비교 기준과 최소 지원을 구별. OS/DPI·client/논리영역·지원 배율 최종 수치 미정 | DEV/Track B·HQ/Owner, 실제 지원 규격 채택 전 |
| F08-02 / M04 아트/필터 | 실제 아트 경로·크기·위상·역할별 최종 필터 미공급. 기존 T02 뒤 직접 영향만 확인 | Track B 자원 조건·DEV, 규격 종속 자원 채택 전 |
| F08-03 / M01 배치 | B/관련 배치 채택 때만 포커스·선택/스크롤·사용자 이동·정보 전환 효과0 검증 | DEV 공급·Track B 표현·Track A 동선, 해당 변경 전. 현재 A 우선 유지 중 B 수정0 |
| F08-03 / M02 전체 이름/목록 | 표시 요구·콘텐츠 공급 주체/형식은 미정. 실제 이름을 임의 생성하지 않음. 같은ID/전체 이름·순서/키보드·현재 선택·정보/편집 영향 대조 | Track B 표시 요구·DEV 공급 계약, 콘텐츠 주체 필요 시 HQ 조정. 실제 이름/밀집 목록 적용 전 |
| F08-04 / O06 W04B | DEV027 최소 단위는 제시됐으나 실제 payload/지역 의존표 NOT_SUPPLIED. 공급 후 해당 L2와 화면 통합. 후보41개 밖 guard/시험 수정 시 먼저 경로/권한 특정 | DEV 실제 공급·Track A 기능/Track B 예외·소속, DEV027 P3. 구현/검증 권한·DI03 종속 의미는 DEV 회신 시점의 별도 잔여 |
| F08-04 / M05 성능 | 목표환경·장면/표현량·기간·목표/FPS 상한 미정. O07 이월 방향 승인 완료 | DEV 측정안·HQ/Owner 목표·Track B 정보 보존, 성능 인수 시점 |
| 공동표 취합·최종 인수 | 준비 경계 의견은 연결됨. 이 로컬 반영안 검토·HQ 적용 범위 취합 및 실제 변화 행 인수는 별도 | Owner 로컬 검토→유효 공유 범위에서 전달·HQ 취합. S3-10-C·S3-12/Stage 최종 인수 별도 |

전 행 일정/공수 **NOT_ESTIMATED**. F08 전체 확정을 W04B 전체 착수 차단으로 만들지 않는다. 현재 새 필수 제품 수정·추가 GUI/전체 T01~04 반복 요구는 없다. 새로운 변화가 생기면 영향 행/부족 이유를 먼저 특정하고 Track A/B가 같은 고정 패킷을 사용한다.

## 4. PARTIAL·NOT_RUN·완료한 일의 구분

- **완료:** DEV 공동 확인 회신 수신·원격 기준 문서 대조·Track B 후속 반영안 준비. 최초 DEV 기술 회신·DEV025 공급/#97 기술 종료·PR157 심사·O01~07 방향 승인·DEV026 현재 공급 한정 수용/P07 구분 승인도 재사용한다.
- **미확정:** F08-01~04 OPEN / FINAL_SPEC_PENDING / PRODUCT_APPLICATION_SCOPE_PENDING. 후보 식별·변경0 의견으로 규격이나 제품 적용을 확정하지 않는다.
- **과거 PARTIAL/INCONCLUSIVE:** B 포커스/합성 마커 겹침, 고정일1 비영점 중첩 복귀 미관측·내부 수명/옛 callback 추가 OS 가시성 한계. P07 일반 재진입과 저장 문맥 복귀를 구별하며 일반 재진입의 항상 스크롤 복원 의무를 추가하지 않는다. 기존 실패·NOT_CAPTURED·NOT_VERIFIED를 PASS로 바꾸지 않는다.
- **이번 NOT_RUN:** 새 자동 게임 테스트·Godot 프로젝트 로드·GUI/독립 입력/게임 플레이·DEV025 재실험·폰트 다운로드/설치/반입/실물 고지 구성 및 fallback 실행·목표 DPI/타PC 인수·프로파일·빌드/export. 제한 raw 재해시·물리 DPI/신원은 NOT_VERIFIED. DEV 회신 자체는 수신했으므로 NOT_RUN/대기로 표기하지 않는다.

## 5. 검증·보존·권한

별도 worktree `codex/DSG-008-pm021-dev-response`에서 디자인 3파일만 변경한다. 공유 main·기존 데이터 수정2개와 이전 worktree, 과거 선택안/결과·DEV 원문은 보존한다. 제품·설정·테스트·정책·타 부서 파일 변경0이다. 신규 RFC 충돌이나 게임·경제·시간·세이브 명세 변경 요구 없음. 기존 RFC-DEV-027-01 종속 의미는 DEV의 보고 범위로 연결하며 임의 종결하지 않는다.

검증 명령: 루트 Python으로 `tools/policy.py doctor`/`check`, `git diff --check`, 기준 blob 원문 포함·변경3개·UTF-8/LF·상대 파일 링크/출처 blob 대조. `git diff --name-only ae614d922c837eddf4e615fda985bd978e217461 HEAD -- scripts scenes assets tests/game project.godot` 결과0개: 기존 제품 시험본 이후 지정 경로 변화 없음. 새 제품 시험 PASS를 의미하지 않는다.

검증 결과: doctor PASS / check PASS(exit0, worktree733개·GDScript57개) / git diff --check PASS. 기준 v0.1 원문 포함·O/M7행·변경3개 한정·UTF-8/LF·상대 파일 링크·출처 blob 대조 PASS. 문서/정적 검사이며 제품 실행이 아니다. 커밋하지 않아 preflight 및 새 PR CI는 NOT_RUN이다. 검증 원본은 작업 트리 `.local/validation/pm021-dev-response/audit.json`에 보관한다.

이번 요청은 로컬 문서 검토까지다. 커밋·푸시·PR·원격 댓글·main 병합·이슈/RFC 종료·제품 실행은 수행하지 않는다. 이전 제출/전달 승인은 완료된 당시 범위로 보존한다.

## 6. Owner 로컬 검토 요청

회신 대기 해소, 변경0·조건부 적용 경계, 폰트 조사 후보/전체 이름 미공급/W04B 실제 공급 잔여의 반영 정확성을 검토 요청한다. 문서 검토와 최종 규격·제품 적용·S3-12/Stage 인수는 구분한다. 검토 후에는 필요한 범위에서만 공동표 최신 반영·HQ 연결로 이어갈 수 있다. 현재 원격 문서는 바꾸지 않았다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008

## 7. Owner 제출 승인 후속 — 2026-11-21

위 로컬 준비·미제출 기록은 당시 이력으로 보존한다. 이후 이 디자인 채팅에서 Owner가 다음과 같이 승인했다.

> DSG-008 DEV 공동 확인 회신 반영 산출물 3개의 커밋·푸시 및 PR 생성을 승인합니다. O-01~07 방향 승인과 과거 기록을 보존하고, 최종 규격 미확정·F-08 미결·PARTIAL·NOT_RUN을 PR에 명시해주세요. main 병합은 하지 마세요.

대상 저장소는 wisberry2022/MetroManager, 작업 DSG-008, 브랜치는 `codex/DSG-008-pm021-dev-response`이며 위 3개 산출물의 이번 커밋·일반 푸시·PR 생성만 허용한다. 승인 출처는 현재 Owner 채팅의 이 요청이다. 원격 승인 URL을 창작하지 않으며 main 병합·릴리스·배포·신규 제품 실행·이슈 댓글 권한으로 확대하지 않는다.

제출 전 fetch 결과 origin/main과 작업 base는 `1a941196cc6d963db93a9fba6a0386b16710aa46`로 동일하다. 정상 훅·doctor/check·문서 무결성을 확인하고 커밋 후 preflight 및 실제 head의 원격 CI/출처 진단을 PR에 기록한다. DEV 준비 경계의 이견 없음과 최종 규격·제품 적용/공동 인수는 계속 구분한다. 기존 PARTIAL·미실행 원본 및 O01~07 방향 승인은 유지한다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008

## 8. PR162 충돌 해소·대체 제출 — 2026-11-22

Owner가 현재 디자인 채팅에서 “PR이 main에 머지되었습니다. 당신이 예전에 등록했던 https://github.com/wisberry2022/MetroManager/pull/162 이슈에 conflict가 발생하였습니다. conflict 해소 후 main까지 병합해주세요”라고 지시했다. 대상은 PR162의 승인된 산출물3개이며 필요한 충돌 해소·커밋·일반 푸시·대체 PR·검사 후 main squash 병합을 이번 범위로 수행한다. 제품 실행·이슈/RFC 종료·릴리스/배포는 포함하지 않는다.

- 최신 base `b34079d5fa85c2eb61604406c3680c62e1e09857`에는 PR164 Owner 선택과 PR163 기획 결정이 이미 반영됐다. PR162 head `b919b1c5f0177f75fcadd60af352a4761a21cb0c`와 실제 겹치는 경로는 `DSG-008_PROVENANCE.json` 1개다.
- GIT_WORKFLOW/GITHUB_SUBMISSION의 실제 충돌 시 대체 PR 절차를 적용해 `codex/DSG-008-dev-response-conflict-resolution`에서 PR162 Markdown2개를 원 바이트로 복원하고 이 인계 기록만 추가한다. 강제 푸시·수동 merge commit·정책 완화 없이 단일 부모로 제출한다. PR162 원 head/본문/검증은 원격에 보존하며 대체 관계를 연결한 뒤 종료한다.
- manifest는 최신 base와 이번 Markdown2개의 blob으로 재작성한다. PR164의 MVP 선택안/결과/공급 계획3개는 변경0, 당시 manifest는 PR164 병합 Git 원본에 보존한다. manifest는 제출 delta 선언이므로 과거 PR164 행을 이번 변경으로 복제하지 않는다.
- PR164의 S1/E1/F1/N1/A1/P1 Owner 선택이 현재 효력이다. 위 DEV 회신 당시 미공급/후속은 당시 사실이다. PR163의 PLN016으로 DI03/E01 정책 질문2건의 Owner 결정이 반영됐으므로 과거 답변 대기 문구를 현재 정책 미결로 되돌리지 않는다. 실제 W04B 공급·기술 대조·UI L2는 별도이며 기획 문서는 수정하지 않는다.
- O01~07 방향 승인·과거 검증·DEV026 현재 공급 한정 수용/P07 구분 유지. 최종 규격 미확정·F08 OPEN·PARTIAL/INCONCLUSIVE·제품 NOT_RUN과 S3-10-C/S3-12/Stage 최종 인수는 별도다. 문서/Git 충돌 해소를 제품 재검증으로 세지 않는다.

검증: 정상 doctor/check·원본 포함·변경3개·최신 main의 MVP/기획/제품 경로 불변·출처 blob·공백/링크 확인 후 커밋/preflight 및 새 head 원격 필수 CI를 확인한다. 실제 commit/대체 PR·CI·병합 SHA는 PR과 완료 보고로 연결한다. 신규 게임 자동검사·Godot 로드·GUI/플레이·폰트/성능·빌드/export는 NOT_RUN이다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008
