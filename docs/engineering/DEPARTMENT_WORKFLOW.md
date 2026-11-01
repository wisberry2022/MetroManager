# 부서별 GitHub 작업 규칙 v1.1

- DEV-007 / 2026-11-01 / REVIEW: INF 등록 검수안. 기존 DEV-003 승인 범위는 보존하며 원격 적용은 Owner 검수·main 병합 후다.

- 작업: DEV-003 / 상태: REVIEW / 2026-10-31
- 근거: Owner의 부서별 메시지·작업 브랜치·경로 제한 조사 및 가능한 사항 즉시 적용 지시.

## 모든 채팅의 시작점

GitHub로 읽거나 쓰는 HQ/기획/디자인/DEV/INF는 먼저 이 문서와 AGENTS.md를 명시적으로 읽는다. ChatGPT 플러그인이 AGENTS.md를 자동 주입한다고 가정하지 않는다. 부서별 프로젝트 지침에 다음 문구를 넣는다:

> MetroManager 작업 전 main의 AGENTS.md와 docs/engineering/DEPARTMENT_WORKFLOW.md 및 내 부서 README를 읽는다. 승인된 티켓 범위에서 codex/<TASK-ID>-<설명> 작업 브랜치를 만들고 branch 인수를 항상 명시한다. main 직접 쓰기는 금지한다. 내 부서 디렉터리만 수정하고 [부서][type] TASK-ID 설명 형식의 커밋을 사용한다. 결과는 PR/브랜치 링크와 커밋 SHA로 공유하며 main 병합은 Owner 승인 범위에서만 수행한다.

## 부서 매핑

| 부서/커밋 표기 | 티켓 | 기본 산출물 경로 | 브랜치 예 |
|---|---|---|---|
| HQ | PM-NNN | docs/hq/ | codex/PM-002-project-report |
| 기획 | PLN-NNN | docs/planning/ | codex/PLN-001-economy-spec |
| 디자인 | DSG-NNN | docs/design/ | codex/DSG-001-art-guide |
| DEV | DEV-NNN | docs/engineering/ | codex/DEV-003-department-policy |
| INF | INF-NNN | docs/infra/ | codex/INF-001-session-continuity |

“동일한 작업 브랜치”는 전 부서에 동일한 **브랜치 운영 방식**을 적용한다는 뜻으로 해석한다. 서로 다른 티켓의 산출물을 하나의 공용 브랜치에 섞지 않는다. 한 티켓의 후속 수정은 같은 브랜치에 순차적으로 올린다.

HQ/기획/디자인/INF의 티켓·결과도 각 부서의 `tasks/<ID>_TITLE.md`, `tasks/<ID>_RESULT.md`에 둔다. 기존 개발 티켓의 `tasks/DEV-...` 위치는 유지한다. 승인 문서와 과거 기록을 일괄 이동하지 않는다.

## 메시지 (DEV-002 형식을 대체)

```text
[기획][docs] PLN-001 경제 규칙 초안을 공유합니다

검토할 규칙과 미결 질문을 기획 문서로 정리했습니다.
참조 경로와 표를 확인했으며 게임 구현 검증은 NOT_RUN입니다.
```

첫 줄은 `[HQ|기획|디자인|DEV|INF][작업종류] TASK-ID 작업 내용`, 100자 이하. 작업종류는 feat/fix/docs/style/refactor/perf/test/build/ci/chore/revert. 문서 작업은 주로 docs, 절차는 chore, 자동 검사는 ci를 사용한다. 빈 줄 뒤 본문 필수. 부서 표기와 티켓 접두어가 일치해야 한다. PR 제목과 최종 squash 제목도 같은 규칙이다. 기존 main의 과거 커밋은 다시 작성하지 않는다.

## 플러그인으로 공유하는 순서

1. main의 최신 SHA, 승인 티켓, 같은 이름의 브랜치 존재 여부를 읽는다.
2. `create_branch`로 최신 main SHA 기반 작업 브랜치를 만든다. 기존 브랜치에 이어 쓰면 먼저 현재 head와 파일 SHA를 다시 읽는다.
3. `create_file`/`update_file`/`delete_file`에 **branch를 반드시 명시**한다. 생략 시 기본 브랜치가 선택될 수 있다. message에는 위 형식과 본문을 넣는다.
4. 여러 파일이 하나의 산출물이면 create_blob/tree/commit/update_ref 방식으로 한 커밋에 묶을 수 있다. 기존 base tree를 반드시 보존하고 update_ref의 expected_sha를 사용한다. force=false를 유지한다. 충돌 시 최신 head부터 재검토한다.
5. 공유는 브랜치/커밋 URL로 가능하다. 통합할 때 base=main의 PR을 만들고 `policy`, `department-policy` 결과를 확인한다. 실패하면 같은 브랜치에서 수정한다. 부서 밖 파일을 건드린 커밋은 최종 트리에서 되돌려도 실패하므로 최신 main에서 새 브랜치에 허용 변경만 다시 준비한다.
6. 병합 승인 이후 squash merge. 플러그인 쓰기 권한을 정책상 승인으로 간주하지 않는다. “추후 push 가능하게 할 예정”은 미래 모든 작업의 포괄 위임 기록이 아니다.

## 디렉터리 경계

HQ/기획/디자인/INF는 기본 경로 아래 파일의 추가·수정·삭제만 허용한다. 소스·씬·에셋·project.godot·tools·.github·.githooks·AGENTS.md·다른 부서 문서 변경은 거부한다. rename은 원래 경로의 삭제와 새 경로의 추가 모두 검사한다. 중간 커밋도 검사하며 symlink/submodule은 허용하지 않는다.

DEV는 개발 경로와 개발 티켓, 공통 도구/CI/거버넌스/템플릿을 유지한다. 타 부서 실제 산출물은 수정하지 않는다. 이번 Owner 요청에 따른 각 부서 README 3개는 공통 규칙 진입점이므로 Convention Team의 유지 범위에 포함한다. 게임 데이터/디자인 내용의 작성 권한을 뜻하지 않는다.

예외는 먼저 Owner 결정으로 정확한 티켓·파일 경로·만료일·사유를 `docs/governance/path_exceptions.json`에 별도 DEV PR로 등록한다. 검사기는 **PR base의 예외 목록**만 읽는다. 작업 브랜치에 예외를 새로 써서 스스로 권한을 늘릴 수 없다. 승인 원문 진위는 Owner 리뷰로 확인한다. 빈 목록이 기본이며 현재 추가 예외는 없다.

## INF 소관 및 초기 게시

INF는 컨텍스트 건전성·세션 연속성·후임 인계 정책과 검증을 담당한다. 장기 진단·인계 정책의 공식 소유 경로는 `docs/infra/`이다. 기존 개발 환경 협업 기록의 소유권을 이전하지 않으며, 게임 규칙·디자인·코드·HQ 일정/Stage 결정은 담당하지 않는다.

공개 Git에는 최소 진단 상태와 근거만 기록하고 내부 대화 원문·상세 세션 평가는 Owner 제한 보관한다. 첨부 등록 요청의 권한 설명만으로 실제 위임을 확정하지 않는다. 개별 티켓에서 Owner 승인 원문·대상 저장소·브랜치·허용 동작·기간·금지 사항을 확인한다. main 병합·릴리스는 별도 Owner 승인 대상이다.

DEV가 `docs/infra/`를 수정할 수 있도록 허용 경로를 넓히지 않는다. 등록 반영 후 INF의 승인된 초기 티켓에서 README를 게시한다. [등록·게시·원격 검증 절차](INF_ONBOARDING.md)를 따른다.

## 강제 적용의 범위

- 로컬 Git: pre-commit/commit-msg/pre-push에서 같은 부서 검사 실행.
- 플러그인: GitHub Contents/Git Data API는 로컬 훅을 호출하지 않는다. 커밋이 만들어져 작업 브랜치에 올라간 뒤 원격 PR 검사를 사용한다.
- `department-policy`: pull_request_target의 base SHA에서 검사 코드를 가져온다. PR의 Git 객체만 읽으며 PR 코드·테스트·설정 파일을 실행하지 않는다. 권한은 contents:read, checkout 자격증명 저장 없음, 외부 의존성 없음.
- `policy`: 일반 pull_request에서 코드 스타일/테스트를 검사한다. PR 코드 실행 job에는 secrets/쓰기 권한을 주지 않는다.
- main 보호에 필수 검사와 PR을 설정해야 불합격 변경의 main 유입을 막는다. CI 파일만으로 강제가 완료되는 것은 아니다.
- 같은 GitHub 계정으로 연결된 채팅의 실제 부서는 식별할 수 없다. 이 검사는 **선언된 부서/티켓/경로의 일관성 검사**다. 고의로 DEV를 사칭하는 행위까지 막으려면 별도 계정/App과 권한 경계가 필요하다. CODEOWNERS는 파일별 쓰기 ACL이 아니다.
- 작업 브랜치 업로드 자체를 사전 거부하는 push ruleset은 현재 공개 개인 저장소에서 사용할 해결책이 아니다. GitHub 문서상 push ruleset은 Team의 private/internal 저장소 등에 제공되며, 동일 자격증명 문제도 해결하지 못한다. 임의 유료 전환은 하지 않는다.

## 조사 근거 (2026-10-31)

- 현재 연결된 GitHub 도구 스키마: create_file/update_file/delete_file은 Contents API, create_commit/update_ref는 Git Data API. 로컬 쉘/훅 실행 기능 없음.
- [Git hooks](https://git-scm.com/docs/githooks)
- [GitHub Contents API](https://docs.github.com/en/rest/repos/contents#create-or-update-file-contents)
- [GitHub ruleset 규칙 및 플랜](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets)
- [pull_request_target 이벤트와 보안 주의](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#pull_request_target)

원격 조사: visibility=public, 연결 계정=wisberry2022, main protected=false, rulesets=[]였음. 최종 적용 결과는 DEV-003_RESULT.md와 채팅 보고를 확인한다.
