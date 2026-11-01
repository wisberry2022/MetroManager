# ERR-20261101-001 — PR #35 main 동기화 후 필수 CI 실패

- 신고: Planning / 작업 PLN-003 / 2026-11-01 / 수신: Convention Team.
- 상태: 원인 확인 / 기획 대체 PR 복구 진행 / 공용 보고 경로의 검사기 등록 PENDING.
- 공식 저장소: [MetroManager](https://github.com/wisberry2022/MetroManager).
- 이번 조사 main: `80d44a983ce57e4d3d067b15eac7f9cdeadbd3c4`.
- 원본 증상: Owner 첨부 화면(2026-11-01 18:18 KST), [PR #35](https://github.com/wisberry2022/MetroManager/pull/35). 화면에는 2커밋·main merge commit·department-policy 실패·policy 진행 중이 보임. 이후 직접 조회에서는 **두 검사 모두 failure**.
- 첨부 화면의 다른 탭/로컬 경로는 공개 보고서에 복제하지 않음.

## 1. 관찰·타임라인

| 단계 | 증거/상태 |
| --- | --- |
| 정상 최초 제출 | PLN head `824a48d3fede0996ad2db64bc25ef2ff54fde604`, 부모1 `177c2e4af3e15e15b15888c40eecb0f3ea983213`; 기획 문서2개. [policy success](https://github.com/wisberry2022/MetroManager/actions/runs/41292449041/job/124806299734), [department-policy success](https://github.com/wisberry2022/MetroManager/actions/runs/41292449419/job/124806302629) |
| 디자인 먼저 통합 | DSG [PR #34](https://github.com/wisberry2022/MetroManager/pull/34) head `9b220fe986fd366fc6a418e82b4398ce15ef40fc`, merge `80d44a983ce57e4d3d067b15eac7f9cdeadbd3c4`; Owner는 병합 후 해당 디자인 브랜치를 삭제했다고 설명. 현재 브랜치 목록에서도 해당 head 브랜치 없음 |
| PLN 브랜치 이력 변경 | 새 head `d69268c35c88b177f919260a49fcbe393c3f53c5`, 메시지 `Merge branch 'main' into codex/PLN-002-gate3-1-planning`; 부모는 최초 PLN head와 디자인 merge SHA의 **2개**. commit diff에는 디자인 문서2개 포함 |
| 실제 실패 | 18:18 KST 실행에서 두 검사 모두 같은 merge SHA를 단일 부모 규칙 위반으로 거부. 최초 화면의 진행 중 상태와 최종 실패 상태를 구별 |
| 영향 | #35 main 통합 차단. 기획 문서 손상·게임 규칙 결함·main 데이터 손실 증거 없음 |

## 2. 직접 확인한 실패 로그

[department-policy job 124806600248](https://github.com/wisberry2022/MetroManager/actions/runs/41292548835/job/124806600248):
```text
FAIL: Expected single-parent work commit: d69268c35c88b177f919260a49fcbe393c3f53c5
Process completed with exit code 1.
```

[policy job 124806599412](https://github.com/wisberry2022/MetroManager/actions/runs/41292548705/job/124806599412):
- 도구 unittest 23개는 OK.
- 이후 `python tools/policy.py ci`가 같은 단일 부모 오류로 exit 1.
- 따라서 도구 회귀 실패나 게임 기능 실패로 분류하지 않음.

## 3. 원인·비원인·미확인

**확인 원인:** 작업 PR의 base..head에 main 동기화 merge commit이 들어갔다. [department_policy.py](https://github.com/wisberry2022/MetroManager/blob/80d44a983ce57e4d3d067b15eac7f9cdeadbd3c4/tools/department_policy.py)의 `range_check`는 작업 커밋마다 부모1개만 허용하며, [policy.py](https://github.com/wisberry2022/MetroManager/blob/80d44a983ce57e4d3d067b15eac7f9cdeadbd3c4/tools/policy.py)의 CI도 같은 검사를 호출한다.
- 검사기 Blob: department_policy `9864490cf018d11a9e71c38ed9079739e6da6380`, policy `d066edef7a60d15a59a019ca1b4063552019a03a`.
- [Git 운영 규칙](https://github.com/wisberry2022/MetroManager/blob/80d44a983ce57e4d3d067b15eac7f9cdeadbd3c4/docs/engineering/GIT_WORKFLOW.md)은 작업 브랜치에 main을 merge하지 말고, 이미 공유된 경우 최신 main의 새 작업 브랜치로 허용 변경만 옮겨 대체 PR을 제출하도록 규정한다.
- 해당 merge의 기본 메시지 역시 프로젝트 제목 형식과 다르고 부모 대비 디자인 파일도 포함한다. 다만 실제 로그는 부모 수 검사에서 먼저 멈췄으므로 나머지를 별도 실측 실패 원인이라고 단정하지 않는다.
- **디자인 브랜치 삭제 자체는 직접 원인으로 확인되지 않음.** 삭제된 브랜치 이름을 이 검사가 필요로 하는 것이 아니며, 실패 SHA의 부모 수가 직접 근거다.
- GitHub “Update branch”의 merge 방식과 현재 정책이 충돌했을 가능성이 높으나, 실제 클릭/주체는 미확인. commit 메시지만으로 Owner가 특정 버튼을 눌렀다고 확정하지 않는다.
- 정상/실패 이력은 API로 조사했으며 UI 조작 재현·새 실패 시험 PR 생성은 NOT_RUN.

## 4. 즉시 복구·수용 기준

1. 최신 main에서 `codex/PLN-002-gate3-1-recovery`를 만들고 원래 승인 대기 기획 문서2개만 단일 부모 커밋으로 제출.
2. 새 PR의 두 필수 CI success, 부모1개, 기획 경로2개 diff, 원래 내용 보존 확인.
3. 새 PR과 #35에 대체 관계 기록 후 #35는 미병합 종료. 원래 branch/commit 보존, 강제 push·main 직접 push·검사 해제 없음.
4. 새 main 진전이 발생하면 다시 검토 후 새 브랜치 대체 절차. UI의 merge 방식 branch update를 권장하지 않음.
5. main merge는 Owner의 별도 결정. 이번 복구로 Stage 실행/규칙 변경/기능 DONE을 선언하지 않음.

## 5. Convention Team 요청

- 현재 단일 부모·부서 경로 정책과 GitHub 갱신 UI의 안내/운영 절차를 대조하고, 승인자가 “최신 main 필요” 상태에서 사용할 안전한 절차를 명문화.
- 오류 메시지에 새 브랜치 재제출 안내를 제공할지 검토. 검사 완화·merge 허용으로 임의 전환하지 않음.
- Owner가 이번 대화에서 **협업 오류의 통합 관리 경로를 `docs/co-work/err-report/`로 확정**했다. 본 보고서와 README가 최초 등록 산출물이다.
- 현재 main의 부서 경로 매핑에는 공용 경로가 없고 `path_exceptions.json={}`. Owner의 작성 승인은 유효하지만 기존 base 검사기는 아직 이를 인식하지 못한다.
- Convention Team 소관의 별도 DEV 변경으로 공용 경로의 부서별 작성권한·티켓/명명·기존 부서 경계 보존·정상/부정 경로 테스트를 정합화하고 Owner 검수/main 반영 필요. 신규 경로만 허용하며 다른 부서 문서/소스 권한까지 넓히지 않는 방향.
- 이 보고서 PR의 공용 경로 거부는 원래 #35 merge 오류와 **별개인 도입 선행조건**이다. 정책 파일을 본 PLN 브랜치에 추가해 자기 예외를 만들거나 부서 표기를 DEV로 바꾸지 않음.

## 6. 검증과 종료 구분

- PERFORMED: PR/commit 부모·changed files·브랜치 목록·main·실패 job 원문·현재 정책 직접 조회, 첨부 증상 대조.
- FAILED: 로컬 clone 네트워크 `getaddrinfo() thread failed to start`.
- NOT_RUN: 로컬 훅/doctor/check, UI 버튼 재현, 게임/엔진/GUI/빌드/성능/사용성/VP.
- 기획 복구 완료 증거: 대체 PR/head와 필수 CI 결과를 해당 PR에 기록.
- 공용 보고서: 독립 PR로 등록·검수 요청. base에 공용 경로 허용이 반영되기 전 통합은 BLOCKED로 표시.
- Convention 재발 방지 완료: 담당 DEV 변경·Owner 승인·main 반영·검증 증거까지 확보했을 때 별도 판정. 보고서 작성만으로 해결/DONE 아님.

## 7. Convention Team 후속 확인 — DEV-009 (2026-11-01)

- 기준 main: `ac04302f2bdab75aab49f0950bce92f115ec8047`. 원래 조사 본문은 당시 상태로 보존한다.
- 복구·경로: 기획 복구 PR #36 통합, 정책 DEV-008/PR #39 통합, 본 보고서는 대체 PR #40으로 main 반영 확인. 원래 Draft #37은 미병합 종료다. 위 PENDING/진행 중 문구는 최초 관찰 시점 기록이다.
- 재발 예방 검수안: DEV-009에서 로컬 pre-merge-commit과 수동 merge 커밋 거부, fetch된 main 포함/작업 이력 사전 검사 및 pre-push 연결을 추가한다. 플러그인/API는 로컬 훅을 실행하지 않으므로 부모·티켓·경로·최신 main 대조와 새 브랜치/대체 PR 안내를 적용한다.
- 최신 절차·기술적 한계: [GitHub 제출 사전 확인](../../engineering/GITHUB_SUBMISSION.md). 서버/UI의 merge 생성 자체를 새 로컬 훅이 막는다고 표현하지 않는다. GitHub의 allow_update_branch=false도 모든 조건에서 버튼 제거를 보장하지 않는다.
- 이번 DEV 변경은 Owner 요청에 따른 구현·PR 검수 제출이다. 원격 CI는 제출 PR 본문, 로컬 검증·변경 파일·미해결은 [DEV-009 결과](../../engineering/tasks/DEV-009_RESULT.md)에 기록한다. main 반영·최종 검수 전 재발 방지 DONE으로 판정하지 않는다.
