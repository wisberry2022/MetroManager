# LAPTOP 환경 기록

- 직접 확인: 2026-11-01 (Asia/Seoul) / 랩탑 Project Leader / DEV-005
- Owner가 이번 채팅에서 랩탑 개발 리더로 선정. 다른 환경에 대한 지휘 권한이나 Git 권한 위임은 추가하지 않음.

| 항목 | 확인 값 |
| --- | --- |
| 운영 환경 | Windows / PowerShell |
| checkout | C:/Users/kitak/OneDrive/바탕 화면/develop/game-dev/MetroManager |
| worktree | 시작 시 위 경로 1개 |
| 조사 기준 HEAD / fetch 후 origin/main | dc06e48b1dbc7745dcb0a29e424cd0416767ab38 |
| 현재 티켓 / 브랜치 | DEV-005 / codex/DEV-005-environment-collaboration |
| 변경 경로 | docs/engineering/README.md, collaboration/, tasks/DEV-005_*.md |
| 작업 시작 Git 상태 | main clean |
| Python / 로컬 도구 | Python 3.12 / 프로젝트 .venv / tools/requirements-dev.txt 고정 버전 |
| 로컬 훅 | 최초 doctor FAIL(Hooks inactive), 기존 커스텀 훅 충돌 없이 install_hooks.py로 .githooks 설치 |
| doctor / check / 문서 검사 | 최종 증거는 [DEV-005 결과](../../tasks/DEV-005_RESULT.md) 참조 |
| Godot | PATH의 godot/godot4 미발견. 설치 경로·실제 엔진 버전 UNKNOWN |
| Godot 로드 / 게임 플레이 / 빌드 | NOT_RUN |
| 전달 상태 | 최초 LOCAL_ONLY → 후속 Owner 승인으로 Git 제출. 실제 head SHA/PR/CI는 PR 본문 확인, 수신 확인 PENDING |
| 다음 담당 | Owner 검수, 공유 후 DESKTOP 인수 확인 PENDING |

프로젝트 설정의 4.7 기능 표기는 설치 엔진 실측 버전이 아니다. Godot 설정을 변경하지 않았다. 이번 .venv 설치는 로컬 환경 준비이며 다른 PC에서 재설치·doctor가 필요하다. Git 훅 설정과 .venv는 문서를 복사하는 것만으로 전파되지 않는다.
