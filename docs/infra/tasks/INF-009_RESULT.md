# INF-009 — 검증 및 제출 결과

- 담당: INF / AGT-INF-0002 / 2026-11-14 Asia/Seoul
- 제출 전 상태: LOCAL_VALIDATION_COMPLETED / REMOTE_CI_PENDING / MAIN_MERGE_PENDING
- [승인·작업 범위](INF-009_LIGHTWEIGHT_SUCCESSION.md)
- 기준 main: 7febce1389d2bb7020178040ef17cfad0057a4a8

## 변경 결과

최초 Owner 지시로 전환 정보·권한을 확정하고 후임이 원본 확인·짧은 회신 후 업무를 시작하도록 통상 인계를 간소화했다. INF/HQ 재승인·정기 ACHC/T1~T10을 필수에서 제외하고, 등록부 후속 반영·ID 중복 방지·실제 효력 시각·미실행 기록을 분리했다.

INF 소관 12파일만 변경한다. registry.json은 activation_time_policy만 변경하며 개별 ID 발급·인사 상태 변경은 없다. 과거 INF-001~008 이력, 나머지 root, 기존 13개 행·레거시 null, CI·도구·경로 정책은 보존한다.

## 검증

로컬 검증은 위 base의 독립 snapshot에서 설치된 gdtoolkit 4.5.0 가상환경 Python으로 수행했다. 아래 python은 그 실행 파일을 가리킨다.

| 검사 | 실제 결과·범위 |
|---|---|
| python -B tools/policy.py doctor | PASS — snapshot 훅·도구. 원격 보호/승인 인증 검사가 아님 |
| python -B tools/policy.py check | PASS — worktree files=575, GDScript=39, formatter/linter 정상 |
| python -B tools/policy.py pre-commit (수동) | PASS — staged files=575, GDScript=39, INF 경로·티켓 검사. API 제출 훅 자동 실행과 구분 |
| 문서·경로 단발 검증 | PASS — INF 12파일만 변경, Markdown 11개 UTF-8/BOM 없음/LF/마지막 개행, 상대 링크 33개 존재 |
| JSON 전후 대조 | PASS — 변경 root 키는 activation_time_policy 하나, 다른 모든 root 값·13개 agent 행 완전 동일 |
| 등록부 구조 검증 | PASS — 실제 base의 bootstrap legacy 8개를 사용한 validate, ACTIVE 8 / RETIRED 5 / PENDING 0 |
| 등록부 diff 비교 | DIAGNOSTICS — 실제 base compare에서 REGISTRY_ROOT_REVIEW_REQUIRED. PASS로 바꾸거나 진단을 제거하지 않음 |
| git diff --cached --check | PASS — 신규 파일의 마지막 빈 줄 경고를 정리한 뒤 재확인 |

문서 시나리오 대조(실운영 시험 아님):

| 사례 | 규정의 처리 |
|---|---|
| 전환·범위·유효 Git 권한이 최초 지시에 명시됨 | 후임 원본 확인·짧은 회신 후 지정 시각부터 시작, 재승인 불필요 |
| 준비만 지시됨 / 특정 Git 권한이 없음 | 자체 ACTIVE 전환 금지 / 해당 Git 동작만 실행하지 않음 |
| ID 충돌·미반영 배정 조회 불가 | 해당 ID 확정·쓰기 보류, 독립 읽기·복구 준비 가능 |
| 후임 확인이 지정 시각보다 늦음 | 효력과 실제 확인·업무 시작을 분리, 전임 자동 복귀 없음 |
| 등록부 main 반영이 지연됨 | 업무상 전환과 REGISTRY_RECORD_PENDING 구분, 새 ID 사용·후속 기록 |
| 선택 시험 생략 / 필수 CI 실제 실패 | NOT_RUN·NOT_ASSESSED / 해당 제출 보류, 시험 PASS·검사 우회 금지 |

실제 원격 제출 head·부모·변경 경로·policy/department-policy·출처 로그는 연결 PR 본문에 기록한다. 이 문서의 REMOTE_CI_PENDING은 commit 전 스냅샷이며 이후 PR의 실제 SHA별 결과와 구분한다. 원격 결과를 검증하기 전에 PASS로 선기록하지 않는다.

## 미실행·한계

- 실제 새 세션 인계·자동 등록 workflow_dispatch·정상/부정·stale base·API/부분 실패 복구 실운영: NOT_RUN.
- 게임 자동검사·Godot 프로젝트 로드·실GUI/플레이·빌드/export·성능: NOT_RUN — 운영 문서·전환 설명 변경.
- QA 원본·접근권한·백업 복구 직접 재검증: NOT_VERIFIED/NOT_RUN.
- 자동화·일반 append-only schema·provenance ENFORCE 구현은 미완료 상태를 유지한다. REPORT_ONLY의 identity_authenticated/approval_authenticated/enforcement_enabled는 모두 false다.
- 승인 방향·문서 구현·실운영 검증·원격 main 반영을 구분한다. 별도 Owner 병합 승인 전 main 병합하지 않는다.

## 환경과 보존

공유 작업 폴더의 main·미커밋·브랜치를 변경하지 않고 최신 원격과 일치하는 기존 Git 객체에서 별도 검토 snapshot을 만들었다. 초기 로컬 clone은 Windows MSYS 프로세스 접근 오류로 실패하여 git archive와 독립 Git 메타데이터로 복구했다. 검사·훅을 완화하지 않았다.

로컬 snapshot의 설치된 훅·검사기를 사용한다. 원격 제출은 GitHub API의 base tree 보존·단일 부모 commit·expected SHA/force=false 작업 브랜치 게시 방식이다. API 쓰기는 로컬 commit/push 훅을 호출하지 않으므로 훅 실행과 수동 검사 결과를 구분한다.

## 남은 의무

Convention의 새 전환 근거·미반영 예약·기존 도구 절차 정합성 검토, DEV-017 실운영시험, 일반 lifecycle/append-only·ENFORCE 계약, R-INF-01 역사 메타데이터 정리, HQ 주관 F-12를 유지한다. 타 부서에 메시지·Issue 변경을 자동 수행하지 않았다. 게임 명세 변경은 필요 없으며 INF 운영 명세를 개정했다.
