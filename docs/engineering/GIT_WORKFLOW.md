# Git 운영 규칙 v1.1

- 작업: DEV-002 / 담당: Convention Team / 날짜: 2026-10-31 / 상태: REVIEW
- Owner의 이번 직접 지시로 전략을 선정하고 구현한다. 기존 HQ 규정의 DRAFT 상태와 승인 권한은 유지한다.

## 선택: 단기 작업 브랜치와 PR

초기 개발, 소수 개발 채팅, 단일 제품인 현재에는 GitHub Flow 기반 운영을 사용한다. `main`은 검증된 통합 기준이며 매 커밋이 출시 가능한 게임이라는 뜻은 아니다. 작업마다 `codex/DEV-002-repository-policy`처럼 브랜치를 만들고, 하나의 티켓을 하나의 PR로 제출한다. DEV/PLN/DSG/PM/INF ID와 소문자 kebab 설명을 사용한다.

Git Flow의 상시 develop/release/hotfix 분리는 병행 지원 버전이 없는 현재에는 관리 부담이 크다. main 직접 커밋 중심 운영은 검수 경계가 약하다. 따라서 main + 단기 브랜치를 선택한다. 장기 유지보수 버전이 생기면 release 브랜치 전략을 RFC로 재검토한다. 에이전트별 영구 브랜치는 만들지 않는다.

## 일상 절차

1. 승인 근거·티켓·AGENTS.md·본 문서 확인, Git 상태 및 미완료 작업 조사. `doctor`로 훅 점검.
2. 작업 시작 전 원격 fetch. main 작업 트리가 깨끗할 때 `git switch main`, `git pull --ff-only origin main`, `git switch -c codex/<TASK-ID>-<description>`. 다른 채팅이 작업 중이면 별도 worktree를 사용한다. 변경을 자동 stash/폐기하지 않는다.
3. 구현과 검증 후 결과 보고. 필요한 파일만 명시적으로 stage하고 `git diff --cached` 검토. 검증되지 않은 변경과 unrelated 파일을 섞지 않는다.
4. Owner의 커밋 승인이 있을 때만 커밋. 푸시 승인/유효한 위임이 있을 때만 해당 작업 브랜치를 일반 push. push 권한은 main 병합 권한이 아니다.
5. PR 제목은 커밋 제목 규칙과 동일하다. PR 템플릿에 승인 원문 위치·검증·미해결 사항을 기록한다. CI `policy` 성공과 독립 리뷰를 확인한다.
6. Owner의 별도 병합 승인 후 **squash merge**. 최종 squash 제목은 PR 제목, 본문은 변경 효과·검증 및 승인 근거를 포함한다. 자동 병합은 사용하지 않는다.
7. 병합 후 fetch/pull --ff-only로 main 동기화. 결과와 main SHA를 보고한다. 작업 브랜치 삭제는 해당 브랜치 종료 승인 범위에 있을 때만 수행한다.

작업 브랜치에 main을 merge하여 merge commit을 만들지 않는다. 최신 main이 필요하면 미푸시 커밋은 rebase할 수 있다. 이미 공유한 브랜치는 강제 push 대신 최신 main에서 새 작업 브랜치(같은 티켓·새 설명)를 만들고 필요한 커밋을 cherry-pick하여 대체 PR을 제출한다. 기존 PR에 대체 관계를 기록한다. 충돌은 의미와 테스트를 재검토한다.

## 커밋 형식

DEV-003부터 모든 부서는 `DEPARTMENT_WORKFLOW.md`의 부서·티켓·디렉터리 매핑을 따른다. 아래 형식이 DEV-002 형식을 대체한다.

```text
[DEV][chore] DEV-003 부서별 Git 검사 절차를 추가합니다

개발 규칙과 자동 검사를 연결하여 변경 이력을 일정한 형식으로 남깁니다.
정책 테스트와 저장소 검사를 통과했으며 게임 플레이와 빌드는 실행하지 않았습니다.
```

- 제목: `[부서][type] TASK-ID 요약`, 최대 100자. 부서는 HQ/기획/디자인/DEV/INF. 호환성 변경은 본문에 영향을 설명한다.
- type: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.
- 빈 줄 후 본문 필수. 타 부서가 이해할 수 있게 효과·이유·검증을 2~3문장 정도로 설명한다. 기계는 제목·본문 존재·티켓 일치만 검사하며 문장 의미는 리뷰한다.
- 하나의 커밋은 설명 가능한 하나의 목적. 관련 테스트는 같은 커밋에 포함한다. 비밀정보·생성 캐시·실패 은폐·불완전한 WIP 커밋은 제출하지 않는다.
- 이미 공유한 이력은 amend/rebase/force-push로 덮어쓰지 않는다. 롤백은 별도 승인된 티켓과 `[부서][revert]` 커밋/PR로 한다. Git 기본 revert 메시지는 이 형식으로 수정한다.
- 도입 이전 main 커밋에는 새 형식을 소급 강제하지 않는다. CI는 PR base 이후 커밋만 검사한다.

DEV-007 INF 등록 검수안: INF도 동일한 작업 브랜치·메시지·승인·일반 push·PR/squash 절차를 따른다. 실제 사용은 등록 변경의 main 반영 후 가능하며, 개별 티켓 승인 확인은 유지한다.

## 권한 위임

현재 미래 작업에 대한 포괄 위임은 없다. DEV-001의 main 직접 push는 해당 작업의 일회성 승인이다. DEV-002 최초 요청은 규칙·프로세스 구축 지시였으며, 후속 Owner 지시로 초기 설정의 main 직접 반영이 승인되었다. 이번 일회성 예외는 `docs/governance/DEC-0001_DEV-002_BOOTSTRAP_MERGE.md`에 기록한다.

Owner가 향후 위임할 때 다음을 결정 기록에 남긴다: 승인자, 원문 위치·일시, 대상 저장소, 작업 ID/범위, 브랜치 패턴, 허용 동작(commit/push/merge 별도), 유효 기간·종료 조건, 금지 동작, 검증 요건, 철회 방식. 승인 여부를 에이전트가 자체 파일에 APPROVED라고 써서 만들어내지 않는다. 실제 근거가 없는 위임 기록 예시는 효력이 없다.

Project Leader에는 작업 브랜치 push 권한만 위임하는 구성이 권장된다. Owner가 main 병합·릴리스와 규칙 변경 권한을 보유한다. 에이전트가 Owner와 동일한 관리자 자격증명을 사용하면 기술적으로 완전한 분리는 불가능하다.

## 변경 운영

Convention Team은 규칙·검사 도구를 유지보수한다. Project Leader는 작업별 준수 증거를 남긴다. 실패는 원인을 고치거나 RFC로 해소하고 우회하지 않는다. 정책/CI/훅/AGENTS 변경은 Owner 리뷰 대상이다. 릴리스 태그·빌드 배포는 별도 승인 티켓으로만 수행한다.

## 조사 근거

- [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow): 브랜치와 PR 기반 경량 흐름.
- [Conventional Commits 1.0](https://www.conventionalcommits.org/en/v1.0.0/): 메시지 구조. scope·티켓·본문 의무는 본 프로젝트가 추가.
- [Git 훅](https://git-scm.com/docs/githooks): 클라이언트 훅의 실행과 우회 가능성.
- [GitHub 보호 브랜치](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches): 필수 리뷰·검사·선형 이력·우회 제한.

2026-10-31 확인. 전략 비교와 최종 선택은 현재 저장소 규모에 대한 자체 판단이다.
