# GitHub 제출 전 확인과 검증된 main 동기화

- DEV-009 안내를 보완하는 DEV-014 / 2026-11-01 / REVIEW 검수안.
- **제한적 동기화 예외는 Owner 검수·정책 PR의 main 반영 후 적용한다.** 그 전에는 기존 검사기가 부모 2개를 거부하므로 실제 PR에서 시험하지 않는다.
- 근거: ERR-20261101-001/002, main `87342cd5c29a3047695c11bfd7f2b76415cdf4d8`, Owner의 반복 오류 수정 요청.

## main이 진전했을 때 선택할 흐름

1. PR의 실제 head SHA·현재 main SHA·권한·필수 검사와 충돌 여부를 다시 확인한다. base/head가 바뀌면 이전 검증을 재사용하지 않는다.
2. 정책이 적용된 main이고 내용 충돌이 없으면, 승인 범위에서 GitHub의 merge 방식 `Update branch`로 main만 가져올 수 있다. 같은 PR 번호·작업 브랜치와 기존 커밋을 보존한다. force push나 공유 이력 재작성은 하지 않는다.
3. 새 head의 두 필수 CI를 확인한다. 부모 2개만으로 실패하지 않으며 `verified_base_sync` 수가 출력된다. tree 불일치·다른 부모·추가 수정·실제 충돌이면 정상 실패다.
4. 내용을 선택해야 하는 충돌은 자동 갱신 대상이 아니다. 최신 main의 별도 작업 브랜치에 승인된 변경만 옮기고 양쪽 작업을 보존해 대체 PR을 제출한다. `Resolve conflicts`의 수동 merge도 clean sync로 간주하지 않는다.
5. 최종 main은 기존 Owner 별도 승인과 squash를 유지한다. strict·선형 이력·필수 검사·관리자 보호를 낮추지 않는다. 이후 main이 진전하면 다시 확인한다.

## 검사기가 인정하는 동기화

일반 작업의 제목·본문·티켓·부서 경로·파일 모드 검사는 유지한다. 중간 위반을 나중에 복구해도 통과하지 못한다. sync의 첫 부모는 이전 작업 head, 둘째 부모는 신뢰된 PR base의 조상이며 두 부모가 실제 분기돼 있어야 한다.

격리 임시 bare 객체 저장소에서 `git merge-tree --write-tree`로 무충돌 tree를 재계산한다. 원본 refs/index/worktree를 변경하거나 PR 코드를 checkout/실행하지 않는다. Git 환경·system/global/source-local 설정과 외부 merge driver를 가져오지 않는다. 예상 tree와 제출 merge tree가 완전히 같아야 한다.

추가 수정·수동 충돌 해소·외부 부모·부모 순서 변경·octopus·실질 변경 없는 sync-only 제출은 거부한다. 동기화 커밋의 기본 메시지에만 제목 형식 예외를 두며 메시지/작성 계정을 믿고 판정하지 않는다.

## 로컬 Git

각 clone/worktree의 .venv·install_hooks.py·doctor 확인을 유지한다. 로컬 자동/수동 merge 생성 훅은 계속 차단한다. GitHub 갱신 뒤 미커밋 작업을 보존하고 `git fetch origin`, 자기 작업 브랜치에 대한 `git pull --ff-only origin <작업브랜치>`로 실제 head를 확보한다. main을 pull해 로컬 merge를 만들지 않는다.

커밋된 head에 `.venv/Scripts/python.exe tools/policy.py preflight`를 실행하고 base/head SHA를 PR에 기록한다. pre-push도 같은 이력/검증된 sync 검사를 한다. 미커밋 파일·실시간 원격 경합·코드 테스트·CI·Owner 승인은 별도 확인한다. Linux는 `.venv/bin/python`을 사용한다.

## GitHub 플러그인/API

main/ref·작업 head와 파일 SHA를 읽고 branch·expected_sha/파일 SHA·force=false를 명시한다. 동시 head 변경 시 중단하고 다시 검토한다. 일반 커밋은 부모 1개와 기존 메시지/티켓/경로를 유지한다. base-only CI가 실제 sync tree를 검증하므로 head의 검사 코드나 자기 예외로 우회하지 않는다.

내용 충돌 없는 base 갱신 API도 해당 티켓의 실행 승인을 확인하고 실제 head·두 CI를 다시 읽는다. 웹 rebase/force update로 공유 이력을 바꾸지 않는다. 미확인은 UNKNOWN/NOT_RUN으로 남긴다.

## 병렬 현황 충돌과 한계

ERR-002의 WORK_STATUS 충돌은 부모 수 오류와 별개다. 상태 정본은 각 티켓/결과·Issue/PR이고 병렬 구현 PR마다 같은 집계표에 행을 추가하는 것을 기본 요건으로 삼지 않는다. 통합 담당이 순차 갱신하는 snapshot으로 둔다. 실제 내용 충돌은 자동 해결되지 않는다.

API/UI는 로컬 훅을 실행하지 않는다. allow_update_branch=false도 strict 조건에서 버튼 제거를 보장하지 않는다. 이번 검수안은 버튼 제거가 아니라 검증 가능한 무충돌 결과를 수용한다. 지원되지 않는 Git·전략/불일치/충돌은 fail-closed다. 정책 도입 후 정상/부정 원격 PR 검증이 필요하다. 동일 계정의 실제 부서/승인 진위 한계와 기존 필수 CI·Owner 검수는 유지된다.

상세 검증 조건·RFC·도입 순서는 [VERIFIED_BASE_SYNC.md](VERIFIED_BASE_SYNC.md)에 있다.
근거: [Git merge-tree](https://git-scm.com/docs/git-merge-tree), [GitHub PR 동기화](https://docs.github.com/en/pull-requests/how-tos/create-pull-requests/keeping-your-pull-request-in-sync-with-the-base-branch). 2026-11-01 확인. 실제 UI 조작·원격 시험 PR은 NOT_RUN이다.
