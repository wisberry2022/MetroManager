# 검사 설치와 강제 적용

- DEV-002 / v1.0 / REVIEW / 2026-10-31

## 로컬 설치 (clone/worktree별 확인)

```powershell
python -m venv .venv
.venv/Scripts/python.exe -m pip install -r tools/requirements-dev.txt
.venv/Scripts/python.exe tools/install_hooks.py
.venv/Scripts/python.exe tools/policy.py doctor
.venv/Scripts/python.exe tools/policy.py check
.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v
```

훅 설치는 이 저장소의 core.hooksPath만 설정한다. 기존 커스텀 훅은 덮어쓰지 않고 중단한다. worktree는 Git config를 공유할 수 있으므로 실제 적용값을 doctor로 확인하고 각각 .venv를 준비한다. Python 3.10 이상, Git, gdtoolkit 4.5.0을 사용한다. `doctor`는 원격 보호나 Owner 승인 진위를 확인하지 않는다.

| 계층 | 적용 내용 | 한계 |
|---|---|---|
| AGENTS.md | 작업마다 규칙·승인·검증 확인 의무 | 모델 지침, 보안 경계 아님 |
| EditorConfig | 문자·개행·들여쓰기 | 에디터 지원 필요 |
| pre-commit | 작업 브랜치·스테이징 티켓·스테이징 코드 검사 | --no-verify로 우회 가능 |
| commit-msg | 티켓 일치·제목 형식·본문 | 승인/의미 판정 아님 |
| pre-push | main/tag/삭제/비정상 브랜치 차단, fast-forward, 커밋 형식 | 로컬 설정으로 우회 가능; 서버 최신 상태는 Git이 재확인 |
| PR CI policy | PR 제목·브랜치·커밋·티켓·통합 코드 검사 | 원격 등록 전 비활성, PR에서 CI 자체 변경 가능 |
| 원격 main 보호 | 필수 PR·독립 리뷰·필수 CI·관리자 우회 금지 | 저장소 플랜·권한·서버 설정 필요 |

pre-push는 커밋/대상 ref를 검사하고 코드 정합성은 pre-commit과 PR CI에서 검사한다. 작업 브랜치의 원격 업로드 자체를 GitHub main 보호가 차단하는 것은 아니다. 잘못된 변경의 main 유입을 차단하는 구조이다.

## GitHub 원격 적용 사양

대상: `wisberry2022/MetroManager`, 기본 브랜치 `main`.

1. 저장소 merge 설정: squash만 허용, merge commit/rebase merge/auto-merge 비활성. squash 제목은 PR 제목, 본문은 PR 설명으로 설정하고 최종 메시지를 리뷰.
2. main 보호: PR 필수, 승인 리뷰 1명 이상, 새 커밋 시 기존 승인 취소, 마지막 push에 독립 승인, 대화 해결 필수, 필수 검사 `policy`, 최신 main 기준 검사 필수, 선형 이력, force push·삭제 금지, 관리자 우회 금지.
3. `.github/CODEOWNERS`를 적용하고 코드 오너 리뷰를 필수화. 정책·CI·훅·도구를 Owner가 검토한다. 실제 계정은 원격 URL의 소유자 `@wisberry2022`를 지정하였으며 실효 권한은 원격에서 검증해야 한다.
4. Project Leader 인증은 규칙 수정/우회 권한이 없는 별도 주체로 운용. PR 작성자와 승인자가 같은 계정이면 독립 승인 조건을 충족할 수 없다. 동일 Owner 계정으로 모두 실행하는 구조라면 분리 전까지 Owner의 수동 병합 운영을 유지한다.
5. 규칙이 있는 main 기준의 CODEOWNERS가 적용되므로 최초 도입 PR은 Owner가 전체 차이를 직접 검토한다. 첫 CI 실행 후 정확한 job 이름 `policy`를 필수 체크로 선택한다.

로컬 코드를 변경할 수 있는 에이전트가 CI도 변경할 수 있으므로 CI 파일 존재만으로 강제를 보장하지 않는다. CODEOWNERS/독립 리뷰/서버 권한 분리까지 적용해야 한다. 필요한 플랜이 아니면 업그레이드를 임의 실행하지 않고 RFC로 보고한다.

## 인수 검증

Owner 관리 하에 별도 시험 PR에서 잘못된 제목·코드가 CI 실패하는지, 필수 검사 실패 상태에서 병합이 불가한지, 에이전트 계정의 main 직접 push·규칙 변경·강제 push가 거부되는지 확인한다. 실제 main을 손상시키는 시험은 하지 않는다. 허용된 작업 브랜치 push → 독립 승인 → squash 병합의 정상 흐름도 확인한다.

서버 설정과 원격 CI 실행은 미검증이다. DEV-002 최초 제출 후 Owner가 초기 설정의 main 직접 반영을 승인했으며, 근거는 DEC-0001에 기록했다. 현재 워크플로는 PR 이벤트용이므로 직접 main 반영만으로 CI가 실행되지는 않는다. 원격 강제 적용 완료로 보고하지 않는다. 원격 적용의 미해결 조건은 `docs/governance/RFC-0001_REMOTE_ENFORCEMENT.md` 참조.

## 기존 채팅 인수인계

Project Leader는 다음 작업 시작 시 변경된 AGENTS.md와 이 문서들을 직접 읽고 doctor를 실행한다. 채팅 사이의 자동 메시지 전달이나 기존 문맥 갱신을 가정하지 않는다. 본 작업에서는 다른 채팅에 메시지를 전송하지 않았다.

[OpenAI 공식 AGENTS.md 문서](https://learn.chatgpt.com/docs/agent-configuration/agents-md)를 근거로 저장소 공통 진입점을 사용한다. 별도 스킬 없이 모든 작업의 공통 규칙으로 연결했다.
