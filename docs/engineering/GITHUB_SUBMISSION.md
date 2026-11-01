# GitHub 제출 전 확인과 merge 오류 예방

- DEV-009 / Convention Team / 2026-11-01 / REVIEW, Owner 검수 요청.
- 근거: ERR-20261101-001, main `ac04302f2bdab75aab49f0950bce92f115ec8047`, Owner의 재발 방지·PR 제출 직접 지시.

## 확인한 사건과 현재 상태

PR #35에 부모 2개인 merge commit `d69268c35c88b177f919260a49fcbe393c3f53c5`가 들어가 단일 부모 규칙으로 실패했다. 실제 버튼 클릭·주체는 미확인이다. 디자인 브랜치 삭제를 원인으로 단정하지 않는다. 기획 본문은 PR #36으로 복구됐고 공용 경로는 DEV-008/PR #39, 오류 보고서는 대체 PR #40으로 main에 반영됐다. 원래 Draft #37은 미병합 종료됐다.

등록된 보고서 본문의 PENDING 문구는 최초 조사 시점의 기록이다. 최신 원격 상태와 Convention 후속 기록을 함께 읽는다. 보고서 등록과 재발 방지 조치의 검수·완료 판정은 구분한다.

## 로컬 Git에서 제출하기

1. 승인 티켓·자기 부서 경로·Git 동작별 승인 범위·작업 중복을 확인한다. 각 clone/worktree의 `.venv`를 준비하고 `tools/install_hooks.py`, `tools/policy.py doctor`를 실행한다. 새 pre-merge-commit 훅이 설치된 상태여야 한다.
2. 원격 fetch 후 최신 main SHA를 기록한다. 다른 채팅의 브랜치를 변경하지 않는다. main이 진전한 공유 브랜치는 main을 merge하거나 force push하지 않고 최신 main의 새 작업 브랜치로 승인된 변경만 옮긴다. 미공유 커밋의 rebase는 기존 규정 범위에서만 가능하다.
3. 정책/관련 테스트와 stage diff를 확인하고 승인된 커밋을 만든다. pre-merge-commit은 자동 merge commit을, pre-commit/commit-msg는 MERGE_HEAD가 남은 수동 merge 커밋을 거부한다. 작업 파일·진행 중 merge를 도구가 자동 폐기하지 않는다. 중단된 merge는 파일 상태를 검토한 뒤 담당자가 별도 복구한다.
4. `git fetch origin` 후 `.venv/Scripts/python.exe tools/policy.py preflight`를 실행한다. Linux에서는 `.venv/bin/python`을 사용한다. branch/task·fetch된 origin/main 포함 여부·base 이후 모든 커밋의 단일 부모·제목/본문·티켓·부서/경로를 검사한다. 빈 작업 범위·다른 티켓·merge commit도 통과하지 못한다.
5. preflight가 출력한 base/head SHA를 PR에 기록한다. 이 검사는 커밋된 HEAD만 읽으며 미커밋 파일·코드 테스트·실시간 원격·Owner 승인·CI 결과를 대신하지 않는다. 승인 범위에서 일반 push한다. pre-push도 같은 최신 main 포함/이력 검사를 수행한다.
6. 실제 PR head의 필수 policy/department-policy 성공과 최신 main 상태를 확인한다. 검사 후 main이 다시 진전했다면 새 상태로 재검토한다. Owner의 별도 승인 후 squash 통합한다.

## GitHub 플러그인/API 또는 웹에서 작업하기

API/UI는 로컬 훅을 실행하지 않는다. 로컬 사전 검사를 실행할 수 없는 경우 다음 원격 대조와 기존 두 필수 CI를 사용한다. 확인할 수 없으면 UNKNOWN/NOT_RUN으로 남기고 검수에 필요한 증거를 확보한다.

1. main ref·작업 ref의 실제 SHA, 승인 티켓, 부서 README/공통 규정, 중복 브랜치 여부를 읽는다. 새 작업 브랜치는 최신 main SHA에서 만든다.
2. 갱신 전에 현재 head를 다시 읽어 이전에 확인한 SHA와 대조한다. head가 달라지면 중단하고 새 변경을 다시 읽는다. Contents 쓰기는 branch와 현재 파일 SHA를, Git Data update_ref는 expected_sha와 force=false를 명시한다.
3. 기존 작업 브랜치가 최신 main을 포함하는지 Compare API 등의 ancestry 정보로 확인한다. 최신 main 기준 `base...head`가 ahead/identical인지 대조하되 identical은 새 작업 커밋이 없는 상태다. behind/diverged이면 기존 브랜치에 main을 merge하지 않는다. 승인된 변경만 최신 main의 새 브랜치에 단일 부모 커밋으로 옮겨 대체 PR을 준비한다.
4. 제안 커밋은 현재 작업 head만 부모로 지정한다. base 이후 **모든** 작업 커밋에 대해 부모 1개·제목/본문/티켓 일치·허용 경로를 확인한다. 최종 diff에서 위반을 지워도 중간 위반은 남는다. base의 예외 목록만 유효하다.
5. GitHub의 merge 방식 Update branch, branch 동기화 API, 작업 브랜치 대상 merge API를 사용하지 않는다. 웹 rebase로 이미 공유한 이력을 바꾸는 것도 기존 규정상 금지다. 최신 main에서 새 작업 브랜치·대체 PR을 사용하는 절차를 따른다.
6. PR에 확인 base/head SHA·티켓·승인 범위·부모/경로 대조·미실행 사항을 기록하고 두 CI를 확인한다. 이후 base/head가 바뀌면 다시 대조한다. 자기 PR의 CI 성공을 Owner 승인·DONE으로 표현하지 않는다.

## 서버 설정과 예방의 한계

2026-11-01 API 조회에서 allow_update_branch=false, squash만 허용, merge/rebase merge 및 auto-merge 비활성을 확인했다. 기존 설정을 유지한다. GitHub 공식 설명상 Always suggest updating 설정을 꺼도 최신 base를 요구하는 보호 조건에서는 Update branch가 제공될 수 있다. 따라서 이 값을 버튼 사용의 기술적 차단으로 설명하거나 strict 검사를 끄는 방식으로 해결하지 않는다.

로컬 훅은 정상 로컬 merge 생성·제출을 조기에 막는다. fast-forward·서버 API/UI에서 새 로컬 훅이 실행되는 것은 아니다. 동일 관리자 계정이 정책을 우회해 작업 브랜치에 merge commit을 올리는 행위까지 막았다고 주장하지 않는다. 최종 main 통합은 기존 필수 CI·보호와 Owner 검수로 제한한다.

근거: [Git 공식 훅 문서](https://git-scm.com/docs/githooks), [GitHub branch 갱신 제안 설정](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-suggestions-to-update-pull-request-branches). 2026-11-01 확인. 실제 UI 재현은 NOT_RUN이다.
