# DEV-017 — 출처 보고 진단·후임 등록 운영 준비

- 담당 Convention Team / `AGT-DEV-0002` / 2026-11-08 / REVIEW.
- 착수 근거: 현재 Owner가 전달한 INF의 “DEV-016 병합 이후 출처 보고·후임 등록 자동화 운영 검증 요청”에 따라 검토·구현·로컬 검증·회신을 준비한다.
- 기준 main 요청 SHA/착수 fetch 결과 모두 `fba3fd575c83e1eae234dc77aa9207898e0849b3`, 변경 없음. DEV-017은 원격 브랜치/티켓에 미사용 확인 후 부여, 미공유 예약 UNKNOWN.
- 브랜치/worktree: `codex/DEV-017-provenance-operations`, `.local/worktrees/DEV-017-provenance-operations`. root/main `293b5f9...`와 기존 DEV/디자인 검수 worktree는 pull/switch/stash/reset/삭제하지 않는다. 전용 venv만 준비하고 공유 hooks/config는 변경하지 않는다.
- 규정: 최신 main의 AGENTS·CODE_CONVENTIONS·GIT_WORKFLOW·ENFORCEMENT·DEPARTMENT_WORKFLOW·개발 README·HQ DRAFT의 승인 원칙·RFC 양식 및 Godot 설정을 읽었다. Owner 직접 요청과 INF 제안/실행 미승인을 구분한다.

## 범위·제외

포함: 네 Actions의 실제 로그·base/head·base checker 조사, 현재 공개 PR 입력과 불변 객체의 재현, 단계별 안전한 진단·입력 해시, 정상/부정 로컬 검증, 등록 중단/부분 실패 문맥, 원격 무쓰기 실행 계획·등록부 root/상태/event 계약 RFC, 항목별 상태와 증거 보고.

제외: 실제 후보 임의 지정·ID 발급/예약·INF 등록부 수정, 원격 workflow 실행·시크릿 조회/설정·등록 PR 생성·기존 PR 본문 편집/재실행·자동 ACTIVE/merge·ENFORCE/새 필수 체크/보호 설정 변경·게임/기획/디자인 소스 변경. 이번 DEV-017 commit/push/PR·main 병합도 개별 승인 없이는 수행하지 않는다. 이전 DEV-016 Git 제출 승인을 재사용하지 않는다.

## 수용 기준

1. 네 실행의 job 성공과 출처 DIAGNOSTICS를 분리하고 base/head·체커 경로·당시 원문 확보 한계 및 현재 입력 해시를 기록한다.
2. Manifest 누락과 PR/commit Trailer·기존 policy·Git 읽기 오류를 단계/commit으로 구별한다. 원문·토큰·임의 예외 메시지를 출력하지 않는다.
3. 정상 Trailer/정확한 Manifest/실제 승인 등록부의 로컬 DECLARATION_CONSISTENT와 부정(누락·비활성/미등록·자기 등록·blob 오류) 진단을 검증한다. 실제 원격 정상 시범과 구분한다.
4. 원격 쓰기 없이 실행 입력·예상 두 INF 파일·분리 책임·토큰 준비/후보/Git 승인·중단/부분 실패 복구를 준비한다. 자동 인계 감지/활성화라고 표현하지 않는다.
5. INF 데이터 소유권을 유지하고 root 갱신·전환·append-only 이력·실제 효력 시각 계약을 제안한다. REPORT_ONLY·두 필수 CI를 보존하고 ENFORCE 조건을 승인 대기로 명시한다.
6. 구현/검증/승인 대기/미실행, 정확한 기준/실제 commit SHA·변경 파일·명령·결과·Actions 로그·미해결을 결과에 기록한다. 미커밋 상태를 commit 완료로 표현하지 않는다.

[INF 회신](../provenance/DEV-017_OPERATIONS_REVIEW.md) / [실행 계획](../provenance/DEV-017_REGISTRATION_RUN_PLAN.md) / [결과](DEV-017_RESULT.md).

## 후속 Owner 제출 승인 — 2026-11-08

> 컨벤션 팀. DEV-017 구현 및 검증 결과를 기존 Git 규정에 따라 커밋·푸시하고 PR 생성해주세요. main 병합과 실제 등록 workflow 실행, ENFORCE 전환은 별도 승인 후 진행해주세요.

- 승인자·원문: Owner, 현재 Convention Team 채팅의 DEV-017 결과 보고 후 직접 요청.
- 대상: `wisberry2022/MetroManager`, DEV-017 구현·검증·문서와 이번 실제 변경의 출처 Manifest.
- 브랜치: `codex/DEV-017-provenance-operations`, base=main `fba3fd575c83e1eae234dc77aa9207898e0849b3`.
- 허용: 이번 제출의 commit·일반 push·PR 생성·자동 CI/출처 보고 확인. 유효 범위는 이번 제출 완료까지이며 포괄 위임 아님.
- 제외: main 병합·직접 쓰기·force push, 실제 후임 등록 workflow/시크릿 설정·후보 발급/활성화, ENFORCE·필수 체크/보호 변경·릴리스/배포.
- 실제 제출 SHA·PR URL·CI 결과는 제출 후 PR 본문과 채팅에 기록한다. 기존 worktree/타 부서 데이터는 변경하지 않는다.
