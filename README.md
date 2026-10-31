# MetroManager

Windows x86_64용 2D 픽셀 아트 경영 시뮬레이션 프로젝트입니다. 기술 스택은 Godot 4.x Stable, GDScript, Git입니다. 현재는 저장소 기반 환경 준비 단계이며 게임 기능과 메인 씬은 없습니다.

## 개발 시작

먼저 `AGENTS.md`와 승인된 작업 티켓을 확인하십시오. 기존 `project.godot`에는 Godot 4.7, Forward Plus, Windows D3D12 설정이 기록되어 있습니다. 실제 설치 엔진의 버전을 확인한 뒤 프로젝트를 여십시오. 초기화 작업에서는 기존 설정을 변경하지 않았습니다.

## 문서 위치

| 경로 | 용도 |
|---|---|
| `docs/governance/` | HQ 운영 규정 |
| `docs/templates/` | 기획·디자인·개발 인수인계 및 RFC/결정 양식 |
| `docs/base-rules/README.md` | Owner 제공 패키지의 원본 안내문 |
| `docs/planning/` | 승인 절차를 거치는 기획 산출물 (필요 시 생성) |
| `docs/design/` | 승인 절차를 거치는 디자인 산출물 (필요 시 생성) |
| `docs/engineering/` | 개발 기술 문서 (필요 시 생성) |
| `tasks/` | 작업 티켓과 결과 보고서 |

패키지의 운영 문서·양식·작업 지시서는 위 지정 경로로 이동했습니다. 패키지 README의 파일 열은 원래 패키지 경로이며, 권장 저장소 위치 열이 현재 위치입니다. 문서의 원문, 버전, DRAFT 및 승인자 표기를 보존했습니다. 빈 소스 디렉터리(`scenes/`, `scripts/`, `assets/`, `tests/`)는 해당 산출물이 생길 때 생성합니다.

## 승인과 Git 절차

Git은 공식 산출물의 단일 원본입니다. 최신 커밋 여부와 문서 승인 여부는 별개입니다. 승인된 티켓 범위에서 작업한 후 변경 파일과 검증 증거를 결과 보고서로 제출하고, Owner가 검토·승인 후 커밋합니다. Development Agent는 추가 승인 없이 커밋·푸시·병합·릴리스하지 않습니다.

HQ·Planning·Design의 별도 ChatGPT 채팅 및 프로젝트 소스는 Git과 자동 동기화되지 않습니다. 인수인계에는 경로, 버전, 승인 상태, 기준 커밋 SHA를 명시하십시오.
