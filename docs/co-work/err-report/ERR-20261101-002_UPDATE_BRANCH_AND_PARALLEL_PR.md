# ERR-20261101-002 — Update branch CI 실패와 병렬 PR 동기화 반복

- 신고: Development / LAPTOP / DEV-012 / 2026-11-01.
- 상태: **OPEN / Convention Team 검토 요청**. 충돌 복구와 프로세스 개선 완료를 구분한다.
- 관련: [DEV-012 티켓](../../engineering/tasks/DEV-012_W03_ROUTE_PREDICTION.md), [결과](../../engineering/tasks/DEV-012_RESULT.md), [Issue #49](https://github.com/wisberry2022/MetroManager/issues/49), [선행 오류 ERR-001](ERR-20261101-001_PR35_BRANCH_UPDATE.md).
- 근거: Owner의 이번 PR #56 충돌 해소·PR 갱신·공용 오류 보고서 동봉 지시. 정책/CI 수정이나 main 병합 승인이 아니다.
- 적용 규정: [Git 운영](../../engineering/GIT_WORKFLOW.md), [제출 안내](../../engineering/GITHUB_SUBMISSION.md), [공용 경로](../../engineering/SHARED_ERROR_REPORTS.md). 문서의 REVIEW 상태와 실제 main 검사 동작을 구분한다.

## 1. 증상과 영향

1. Owner가 다른 PR 병합 후 GitHub `Update branch`를 실행했다고 보고한 PR #52/W02와 #53/W03에서 필수 `policy`·`department-policy`가 실패했다. 실제 커밋은 부모 2개이며 department-policy 로그는 단일 부모 위반을 명시했다.
2. 규정에 따라 최신 main에서 각각 대체한 PR #55/W02와 #56/W03는 두 필수 CI가 통과했다. 이후 Owner가 #55를 squash 병합하자 #56이 `mergeable=false / dirty`가 됐다. 이번 #56 head는 그대로이며 부모 2개 커밋이 추가된 사건이 아니다.
3. 두 티켓이 공통 `docs/engineering/collaboration/WORK_STATUS.md`의 같은 위치에 자기 현황 행을 추가해 충돌했다. 모델 코드 충돌은 없었다. 공유 브랜치 main 병합·이력 재작성 금지와 최신 main 요구가 결합돼, 후속 PR을 다시 새 브랜치/대체 PR로 제출해야 한다.

사용자는 최신 main으로 동기화하려다 CI 실패 또는 PR 교체·검수 링크 변경을 반복하게 된다. 독립 티켓의 게임 코드가 정상이더라도 공통 현황 파일과 제출 절차 때문에 Owner 검수 비용이 증가한다. 이 보고서는 검사 우회 요청이 아니라 안전한 동기화 절차 개선 요청이다.

## 2. 확인한 이력과 로그

| 사건 | 기준 / head / 부모 | 실제 증거 |
| --- | --- | --- |
| PR #52 Update branch 후 | main `88496d0c3bcef8d59e76c9977ee6ff07d01339fe`; head `42a82c2340a52b0ca8baa863796a46b214c21c1e`; 부모 `95cc470259528b461520685f670aed89df618c49`, `88496d0c3bcef8d59e76c9977ee6ff07d01339fe` | [department 실패](https://github.com/wisberry2022/MetroManager/actions/runs/41300438611/job/124830059694), [policy 실패](https://github.com/wisberry2022/MetroManager/actions/runs/41300438660/job/124830059044) |
| PR #53 Update branch 후 | 같은 main; head `e4bfed3fb597a32d9f03cc5b9186addc25528f00`; 부모 `598cc19e28ad9751913eee6b7d3808463c6567a7`, `88496d0c3bcef8d59e76c9977ee6ff07d01339fe` | [department 실패](https://github.com/wisberry2022/MetroManager/actions/runs/41300432239/job/124830042516), [policy 실패](https://github.com/wisberry2022/MetroManager/actions/runs/41300433097/job/124830043935) |
| 복구 PR #55 / #56 | base `88496d0c3bcef8d59e76c9977ee6ff07d01339fe`; head 각각 `09c5b2629bd171af87e5128ee967780caabde621`, `338a8cb75bdda61f5af1632aa22d99af70e5f467`; 각각 같은 base만 부모 1개 | #55 [department](https://github.com/wisberry2022/MetroManager/actions/runs/41301121787/job/124832057628)·[policy](https://github.com/wisberry2022/MetroManager/actions/runs/41301121496/job/124832055755), #56 [department](https://github.com/wisberry2022/MetroManager/actions/runs/41301126463/job/124832071679)·[policy](https://github.com/wisberry2022/MetroManager/actions/runs/41301126123/job/124832069073) 모두 success |
| #55 병합 후 #56 충돌 | 최신 main `826111ec1860a3a060644e2233892da285b5e981`; #56 head는 위 `338a8cb...` 그대로, 부모는 `88496d0...` 1개 | [#55 병합](https://github.com/wisberry2022/MetroManager/pull/55), [#56](https://github.com/wisberry2022/MetroManager/pull/56)의 REST 상태 `mergeable=false / dirty`; 아래 로컬 충돌 재현 |

두 과거 department 로그를 이번 조사에서 다시 조회했으며 공통 오류는 `FAIL: Expected single-parent work commit: <head>. Do not merge main into a work branch.`다. 보고된 UI 동작과 Git/로그로 확인한 사실을 구분한다. policy의 별도 전체 로그 원인은 이 문서에서 동일하다고 단정하지 않는다.

## 3. 재현 조건과 원인 구분

### A. Update branch / 부모 수 거부

같은 base의 작업 PR을 공유한 뒤 다른 PR을 main에 병합하고, 작업 브랜치에 main을 merge하는 Update branch를 수행하면 부모 2개 작업 커밋이 생긴다. 현재 검사기는 base 이후 작업 커밋의 부모가 1개인지 검사하므로 거부한다. 이는 실제 실패 이력으로 확인했다. 이번 조사에서 GitHub UI 버튼을 다시 클릭하는 재현은 **NOT_RUN**이며 기존 원격 실패 기록을 보존했다.

### B. #55 병합 뒤 #56 내용 충돌

새 격리 작업 브랜치에서 다음 명령으로 재현했다. 원래 공유 브랜치는 수정하지 않았다.

```powershell
git fetch origin
git switch -c codex/DEV-012-w03-conflict-report origin/main
git cherry-pick 338a8cb75bdda61f5af1632aa22d99af70e5f467
git diff --name-only --diff-filter=U
git diff -- docs/engineering/collaboration/WORK_STATUS.md
```

출력은 `CONFLICT (content)`와 충돌 파일 `docs/engineering/collaboration/WORK_STATUS.md` 한 개였다. HEAD 쪽 DEV-011 행과 W03 쪽 DEV-012 행이 같은 표의 DESKTOP 행 직전에 추가되어 있었다. 두 행 모두 보존하고 표시자만 제거해 해소했다. 모델 코드·데이터·테스트의 의미 변경은 없다.

- **확인:** 위 SHA/부모/실패 로그, #55 병합, #56 dirty, 공통 파일 한 곳의 충돌, 현행 새 브랜치/대체 PR 절차.
- **추정:** 현황을 단일 표에 함께 추가하는 구조가 병렬 제출 시 반복 충돌 가능성을 높인다. 이번 한 사례를 모든 PR 충돌의 원인으로 일반화하지 않는다.
- **미확인:** 현재 Owner 화면에서 제공되는 버튼/방식, 원격 보호 설정 전체의 관리자 권한 조회, 모든 브라우저 조합. 기존 문서의 서버 설정 기록을 이번 조회 결과로 주장하지 않는다.

## 4. 즉시 복구와 검증

- 최신 main `826111ec1860a3a060644e2233892da285b5e981`에서 승인된 W03 변경만 옮겼다. W02 현황 행과 main의 W02 파일을 보존하고 W03 행의 제출 기준만 갱신한다.
- 현재 규정으로 #56의 기존 공유 head에 최신 main을 포함시키면서 단일 부모·이력 보존을 모두 만족하는 일반 fast-forward 갱신은 불가능하다. 새 브랜치/대체 PR을 제출하고 #56에 상호 연결한다. 번호 변경의 원인은 현행 운영 규정이며 기능 범위 변경이 아니다.
- 변경 파일: 기존 W03 승인 14파일 및 이 보고서·공용 README, 총16파일. 정책·CI·훅·부서 예외·게임 명세는 수정하지 않는다. 실제 제출 head/tree 및 새 CI 링크는 대체 PR 본문/댓글에 기록해 자기 SHA 삽입 문제를 피한다.

실행 명령과 증거:

| 구분 | 명령 / 결과 |
| --- | --- |
| 모델 회귀 | Godot4.7.2 `--headless --path . --script res://tests/game/run_w01_tests.gd` / `run_w02_tests.gd` / `run_w03_tests.gd`: 각각 219 / 81 / 101단언, failures=0, 종료0 |
| 실패 감지 | W03 러너 `-- --verify-failure-exit`: 의도적 1실패, 예상 종료1 |
| 프로젝트 로드 | `--headless --editor --path . --quit` 및 `--headless --path . --quit-after 3`: 종료0, 후자 W01_INIT_OK |
| 정책·스타일 | `.venv/Scripts/python.exe tools/policy.py doctor` / `check`: PASS, 15 GDScript 스타일 검사 통과. 커밋 후 fetch·`preflight`와 실제 제출 head 결과는 제출 PR에 기록 |
| 정책 회귀 | `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v`: 37테스트 OK, 종료0. 의도적 bad_script.gd 부정 입력 출력을 전체 실패와 구분 |
| 파일 보존 | W03 게임/데이터/테스트/UID = #56 원본 blob, W02 파일과 현황 행 = 최신 main 대조 PASS. 승인 16파일·UTF-8/LF·충돌 표시자 없음·공백 검사 PASS |
| 미실행 | GUI 버튼 재현·게임 플레이·실제 W02/W03 UI 통합·Windows 빌드·성능·전체 Stage/AC/VP: NOT_RUN, 이번 충돌/보고 범위 밖 |

최초 제한 환경 실행에서는 Godot 사용자 로그·에디터 설정 디렉터리 쓰기가 거부됐다. 종료0만으로 로드 성공 판정하지 않고 정상 권한으로 위 전체 엔진 검증을 재실행했다. 이는 Git/PR 충돌 원인과 별도인 실행 환경 제약이다.

## 5. RFC — Convention Team 개선 검토 요청

- RFC ID: **RFC-DEV-012-ERR-002** / 상태 **OPEN**.
- 요청 부서: DEV / 응답 책임: Convention Team. 운영 변경은 Owner 결정 필요.
- 근거: 위 규정과 SHA, [RFC 템플릿](../../templates/RFC_AND_DECISION.md).

### 질문 또는 변경 제안

1. **안전한 동기화 도구/절차:** 최신 base 감지부터 승인된 diff 보존, 충돌 확인, 검사, 대체 PR과 기존 PR 연결까지 반복 작업을 줄일 수 있는가? 현행 규정을 유지하면 새 PR 수는 줄지 않지만 수동 누락/승인 부담을 줄일 수 있다. 충돌 자동 선택·타인 작업 폐기·무조건 broad push 권한은 허용하지 않는 설계를 요청한다.
2. **공통 현황 충돌 감소:** 티켓별 현황 파일을 원본으로 삼고 집계표를 별도 갱신하거나, 통합 담당이 표를 갱신하는 방식의 비용을 비교해 달라. 병렬 티켓이 같은 위치를 수정하지 않도록 하되 환경 간 인수인계와 최신성은 유지해야 한다.
3. **같은 PR 번호 유지의 정책 선택:** Owner가 원하는 UX를 만족하려면 공유 이력 불변 정책과 어떤 절충이 필요한가? 제한된 lease 기반 재작성 등은 현재 금지이며 이 보고서에서 실행/승인하지 않는다. 허용을 검토한다면 변경 감지·동시 작업 보호·승인 diff/감사 이력 보존을 함께 설계해 Owner에게 선택지를 제시해 달라. merge commit을 일괄 허용하거나 최신성/부서 검사를 끄는 방식으로 처리하지 않는다.
4. **제출 안내/검수 순서:** 병렬 PR의 선행 병합 직후 남은 PR을 누가 언제 갱신하는지, UI 버튼과 규정이 충돌할 때 Owner가 실행할 정확한 흐름을 한 곳에 안내해 달라. 실제 원격 설정/UI로 가능 여부를 검증하고 설정 값만으로 버튼이 사라졌다고 판단하지 않는다.

### 영향도와 답변

- 일정: 수동 새 브랜치/대체 PR·검증·리뷰 링크 전환 반복. 시간 비용의 정량 측정은 미수행.
- 개발/타 부서: 모든 병렬 제출 흐름에 적용 가능성이 있어 Convention 검토 필요. 기획 규칙·디자인 의도·세이브/게임 데이터 호환 변경은 이번 요청에 없다.
- 담당 의견/HQ 조정/Owner 결정: **PENDING**. 본 문서는 DEC/정책 승인/DONE이 아니다.
- 반영 후보: Git 운영·제출 안내·현황 기록 방식, 필요 시 별도 승인 티켓의 검사/도구/회귀 테스트. DEV-012에서는 수정하지 않는다.

### 종료 조건

Convention Team이 원인·선택지·범위/위험을 답변하고 Owner가 운영 방식을 결정한 뒤, 별도 티켓에서 정상/충돌/동시 head 변경/오래된 base/타 부서 경로/중간 merge commit 사례를 검증한다. 두 필수 CI와 승인 경계를 유지하고, 실제 사용자 동기화 흐름에서 재발 또는 반복 작업이 어떻게 줄었는지 증거를 남긴다. W03 대체 PR의 CI 성공은 즉시 복구 증거일 뿐 이 개선 요청의 종료 근거가 아니다.

## 6. Convention Team 후속 — DEV-014 (2026-11-01)

- 기준 main `87342cd5c29a3047695c11bfd7f2b76415cdf4d8`, 기존 리포트의 관찰·로그·복구 기록은 보존한다.
- 단순 사용 금지·로컬 훅만으로는 GitHub Update branch와 strict 최신성 요구 사이의 반복을 해소하지 못했음을 확인했다.
- 제한적 수정 검수안: 일반 작업 커밋의 단일 부모/티켓·메시지·부서/모드 검사를 유지하고, 신뢰된 base 부모·격리 재계산 무충돌 merge tree가 정확히 일치하는 동기화만 허용한다. 추가 수정·외부 부모·수동 충돌 해소·octopus는 거부한다. 같은 PR/브랜치에 덧붙이는 정상 갱신은 이력을 재작성하지 않는다.
- 실제 #52/#53 head를 동일 당시 base로 후보 검사에 재생해 각각 work=1 / verified_base_sync=1 PASS. 과거 원격 failure나 실제 운영 CI가 수정된 것은 아니다.
- WORK_STATUS의 기존 행은 보존하고 개별 티켓/결과·Issue/PR을 상태 정본으로 안내했다. 병렬 PR마다 공통 표 행 추가를 기본 변경 범위로 요구하지 않고 통합 담당이 순차 집계한다. 실제 내용 충돌을 자동 선택하는 기능은 아니다.
- [검증 조건·대안·RFC-DEV-014-01](../../engineering/VERIFIED_BASE_SYNC.md), [실행 증거·미해결](../../engineering/tasks/DEV-014_RESULT.md). 기존 두 필수 CI·strict·Owner 병합·squash·force push 금지를 유지한다.
- 현재 로컬 수정/정책 검수안이며 Owner의 정책 검수·DEV 제출/통합·이후 승인된 실제 Update branch 원격 검증 전까지 RFC-DEV-012-ERR-002는 OPEN으로 둔다. 재발 방지 DONE을 선언하지 않는다.
