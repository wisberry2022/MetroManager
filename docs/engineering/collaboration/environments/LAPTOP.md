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
| Godot 실행 파일 | 프로젝트 기준 ../godot/Godot_v4.7.2-stable_win64.exe (GUI), ../godot/Godot_v4.7.2-stable_win64_console.exe (콘솔) |
| Godot 실제 버전 | 콘솔 실행 파일의 --headless --version 출력: 4.7.2.stable.official.ed1daf0bf |
| Pixelorama 소스 | 프로젝트와 별도 저장소 ../Pixelorama, origin=https://github.com/Orama-Interactive/Pixelorama.git |
| Pixelorama checkout | master / HEAD fae9327992f1506f340b920e0fa6515a88298079 / 확인 시 clean. git describe: v1.2.3-64-gfae93279 |
| Pixelorama 프로젝트 버전 | project.godot의 config/version=v1.2.4-rc2, features=4.7. 소스 설정값이며 배포 바이너리 실행 버전 확인은 아님 |
| Pixelorama 사용 목적·검증 | Owner가 디자인 작업용 clone으로 안내. 프로젝트 로드·에디터 실행·에셋 제작 검증은 NOT_RUN |
| Godot 로드 / 게임 플레이 / 빌드 | NOT_RUN |
| 전달 상태 | 최초 LOCAL_ONLY → 후속 Owner 승인으로 Git 제출. 실제 head SHA/PR/CI는 PR 본문 확인, 수신 확인 PENDING |
| 다음 담당 | Owner 검수, 공유 후 DESKTOP 인수 확인 PENDING |

프로젝트 설정의 4.7 기능 표기는 설치 엔진 실측 버전이 아니다. Godot 설정을 변경하지 않았다. 이번 .venv 설치는 로컬 환경 준비이며 다른 PC에서 재설치·doctor가 필요하다. Git 훅 설정과 .venv는 문서를 복사하는 것만으로 전파되지 않는다.

## DEV-005 환경 정보 정정 (2026-11-01)

Owner의 상위 Godot 폴더 및 Pixelorama clone 안내에 따라 직접 확인했다. 최초 기록의 PATH 미발견은 경로 검색 결과였으며 설치 여부의 근거가 아니었다. 이제 위 실행 경로와 실제 Godot 버전으로 대체한다. 상위 폴더의 실제 이름은 `godot`이다. 두 도구의 위치는 이 랩탑 기준이며 다른 PC에 동일 경로가 있다고 가정하지 않는다.

```powershell
# MetroManager 루트에서 버전만 확인
& '../godot/Godot_v4.7.2-stable_win64_console.exe' --headless --version
git -C ../Pixelorama status --short --branch
git -C ../Pixelorama rev-parse HEAD
```

Godot 버전 명령은 PASS이며 MetroManager/Pixelorama 프로젝트 로드와 구분한다. Pixelorama 저장소·Godot 파일은 수정하지 않았다. 최초 정정은 로컬 미커밋이었으며 이후 Owner가 후속 PR 제출을 지시했다. 기존 PR #13은 병합 완료되어 codex/DEV-005-laptop-environment-correction 브랜치의 별도 PR로 제출한다. 실제 제출 SHA와 CI 결과는 후속 PR 본문을 기준으로 확인한다. 검증 증거는 [DEV-005 결과의 환경 정정](../../tasks/DEV-005_RESULT.md)에 기록한다.
