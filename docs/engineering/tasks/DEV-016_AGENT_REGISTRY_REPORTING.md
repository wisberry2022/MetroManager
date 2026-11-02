# DEV-016 — INF 회신 검토 및 등록부 보고 연동

- Convention Team / `AGT-DEV-0002` / 2026-11-02 / REVIEW, DONE 아님.
- 착수 근거: 현재 채팅 Owner 직접 요청. 원문:

> 컨벤션 팀. 인프라 에이전트가 당신의 요청사항을 답변한 사항을 원격 저장소의 main에 머지하였습니다. 해당 내용 검토하여 검토 및 구현해주세요.
> 참고로, 현재 PRoject Leader B가 다른 채팅에서 코드 작업을 진행하고있습니다. Project LEader B가 사용하고 있는 브랜치와 겹치지 않도록 워크트리를 사용하던지, 다른 방법을 사용하여 현재 진행중인 소스코드에 간섭이 없는 선에서 작업 착수해주세요

- 승인된 범위: 회신 조사·로컬 구현·검증·보고. commit/push/PR·main 병합은 이번 요청에 없으며 별도 승인 필요.
- 조사 기준 main: `682a4f10f2cfe14bed6984e87bff75c05f37d8b5`, INF-002 PR #64.
- 브랜치: `codex/DEV-016-agent-registry-reporting`, worktree `.local/worktrees/DEV-016-agent-registry-reporting`. 원격/문서의 DEV-016 미사용 확인 후 부여; 미공유 타 환경 예약은 UNKNOWN.
- B 작업: `codex/DEV-015-stage1-ui-integration`의 main.gd/UI·scene·W07 테스트 미커밋 상태를 읽기 확인. 기존 root/main·B·DEV-011/014 worktree의 checkout·index·파일·공유 hooks/config를 변경하지 않는다. fetch는 원격 추적 refs만 갱신하므로 B도 제출 직전 preflight 재확인 필요.
- 포함: INF 실제 등록부 검토·구조/delta 검증·오프라인 PENDING 제안·PENDING PR 자동 생성기/workflow 후보·독립 REPORT_ONLY CI 후보·DEV-014 snapshot 호환·회귀/운영 가이드.
- 제외: INF 등록부 수정/실제 ID 발급·활성화·실제 원격 등록 PR 실행·자동 main 병합·ENFORCE/새 필수 체크 설정·게임 소스·UI/기획/디자인·기존 CI/훅 수정·공통 현황표 편집.

## 수용 기준

1. 실제 bootstrap ID 8개와 기존 null 시각을 보존하며 Convention/Leader B/DESKTOP의 독립 ID를 확인한다.
2. 삭제/재할당·부서/계보·버전·시각·신규 ACTIVE/번호 재사용은 거부하거나 미결 전환 검토 진단으로 남긴다.
3. 오프라인 제안기는 read-only이며 자동 PR 생성기는 승인된 main workflow에서만 신규 PENDING draft PR을 생성하도록 구현한다. stale base/진행 중 등록 PR/번호 충돌·부분 실패를 검증하며 ID 예약이나 승인 인증을 주장하지 않는다.
4. CI는 base code/registry만 읽으며 PR 코드·metadata를 실행하지 않는다. 결과는 REPORT_ONLY이고 기존 두 CI를 유지한다.
5. 무충돌 sync 이전/이후의 일반 작업 snapshot을 정확한 당시 main에 대조하고 main 파일을 작업 에이전트에게 재귀속하지 않는다.
6. 자동/정적 검증·Godot/플레이/빌드 NOT_RUN, 변경 파일·미해결·권한 경계·B 간섭 여부를 [결과](DEV-016_RESULT.md)에 보고한다.

상세 회신은 [검토·사용·RFC](../provenance/DEV-016_INF_REVIEW_AND_ROLLOUT.md)에 기록한다.

## Owner 전달 INF 후속 요구 — 2026-11-02

1. 신규 후임 등록은 PENDING 등록 PR 자동 생성 → INF 수용 검증 → PM 전환 확인 → Owner 활성화 승인 및 병합 순서다.
2. 신규 후임 활성화 시각은 실제 승인된 효력 시각을 기록한다.
3. REPORT_ONLY→ENFORCE는 별도 Owner 승인 대상이다.
4. 등록부 관리는 INF, 자동 등록·검증 도구 구현은 Convention이다.

현재 Owner는 위 항목이 빠졌다면 검토·반영하도록 지시했다. 이를 DEV-016 로컬 보완 구현 범위로 반영하며 실제 원격 실행 승인은 아니다. 기본 prepare-only PR 생성기와 명시적 main workflow_dispatch 후보를 추가한다. 절차·원격 권한·실행/미실행 구분은 [자동 PR 생성 보완](../provenance/DEV-016_REGISTRATION_PR_AUTOMATION.md)에 기록한다.

## 후속 개발 PR 제출 승인 — 2026-11-02

> 컨벤션 팀 PR 생성해주세요

- 승인자/원문 위치: Owner, 현재 Convention Team 채팅의 DEV-016 구현·보완 보고 직후 직접 요청.
- 대상: `wisberry2022/MetroManager`, DEV-016의 위 구현·테스트·문서 14개 파일.
- 브랜치: `codex/DEV-016-agent-registry-reporting`, base=main.
- 허용: 이번 DEV-016 제출에 필요한 로컬 commit·일반 push·PR 생성 및 원격 CI 확인. 유효 범위는 이번 제출 완료까지이며 포괄 위임 아님.
- 제외: main 병합·직접 쓰기, 강제 push, 보호/필수 CI 변경, 실제 INF 등록 자동화 실행·시크릿 설정·신규 ID 발급/활성화, ENFORCE 전환, 릴리스·배포.
- 제출 기준 main: `591091d8916a7a6100972b8807503765bb82b9b0`. 미공유·자체 커밋 없는 DEV-016 브랜치만 fast-forward했고 변경 14개 파일을 보존했다. B/root의 checkout·index는 변경하지 않았다.
