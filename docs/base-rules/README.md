# PM-001 초기 운영체계 패키지

- 문서 상태: **DRAFT / 검토 대기** (Owner가 이미 승인한 7개 정책과 GOV-001을 문서화했으나, 문구·양식은 별도 검토 대상)
- 작성일: 2026-10-31
- 대상: Windows용 2D 픽셀 아트 경영 시뮬레이션 / Godot 프로젝트
- 관리 주체: HQ(PM)

## 구성

| 파일 | 용도 | 권장 저장소 위치 |
|---|---|---|
| `governance/HQ_OPERATING_RULES.md` | 프로젝트 운영 규정 | `docs/governance/HQ_OPERATING_RULES.md` |
| `templates/PLANNING_HANDOFF.md` | 기획 인수인계 양식 | `docs/templates/PLANNING_HANDOFF.md` |
| `templates/DESIGN_HANDOFF.md` | 디자인 인수인계 양식 | `docs/templates/DESIGN_HANDOFF.md` |
| `templates/DEVELOPMENT_HANDOFF.md` | 개발 인수인계 양식 | `docs/templates/DEVELOPMENT_HANDOFF.md` |
| `templates/RFC_AND_DECISION.md` | 부서 간 질의, 변경 및 결정 기록 양식 | `docs/templates/RFC_AND_DECISION.md` |
| `work_orders/DEV-001_REPOSITORY_INITIALIZATION.md` | Codex 저장소 초기화 작업 지시서 | `tasks/DEV-001_REPOSITORY_INITIALIZATION.md` |

## 적용 방법

1. Owner가 초안을 검토하여 확정하거나 수정사항을 지시합니다.
2. Codex 개발 세션에 `DEV-001_REPOSITORY_INITIALIZATION.md`를 전달합니다.
3. Codex는 **기존 저장소를 먼저 확인**하고, 승인된 문서를 정해진 위치에 배치합니다. 프로젝트와 저장소가 아직 없다면 작업 지시서에 따라 초기화합니다.
4. Owner가 Git 변경사항을 검토·커밋합니다. PM은 직접 저장소를 수정하거나 코드를 구현하지 않습니다.
5. 기획·디자인 ChatGPT 채팅에서는 공통 프로젝트 지침과 필요한 Git 문서의 **최신 승인 버전**을 참조하도록 합니다. 필요한 경우 Owner가 승인된 응답 또는 자료를 프로젝트 소스에 등록합니다.

> ChatGPT 프로젝트의 대화 참조와 프로젝트 소스는 **정보 접근을 보조**하지만, Git 파일의 자동 최신화나 다른 세션에 대한 자동 업무 전달을 보장하지 않습니다. 항상 Git 원본의 버전·승인 상태를 확인해야 합니다.
