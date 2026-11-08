# INF-005 — PM 후임 등록 제출 및 검증 결과

- 부서: INF / 제출 선언 `AGT-INF-0001` / 2026-11-08
- 상태: `OWNER_APPROVED_FOR_PR / REGISTRY_DIFF_REVIEW / MAIN_MERGE_PENDING / NOT_DONE`
- 기준 main: `02146a027a373b6a2d42fa40c581812e84ad6c44`
- 기준 registry blob: `89f371e953ea505619488d3e0b0634d3f24fc42b`
- 브랜치: `codex/INF-005-pm-succession`
- 티켓·Owner 승인 근거: [INF-005_PM_SUCCESSION.md](INF-005_PM_SUCCESSION.md)
- 원격 PR의 실제 head·필수 CI·출처 진단은 PR 본문과 GitHub 원격 결과를 정본으로 별도 확인.

## 승인된 변경 결과

| 파일 | 변경 |
| --- | --- |
| `docs/infra/agents/registry.json` | `AGT-PM-0001` RETIRED 및 `AGT-PM-0002` 신규 ACTIVE |
| `docs/infra/tasks/INF-005_PM_SUCCESSION.md` | INF 수용·Owner 직접 전환·두 효력 시각·업무/권한 경계 |
| `docs/infra/tasks/INF-005_RESULT.md` | 제출 검증 방법·한계·후속 의무 |

- `AGT-PM-0001.retired_at = 2026-11-08T17:24:00+09:00`.
- `AGT-PM-0002.activated_at = 2026-11-08T17:25:00+09:00`.
- 두 효력 시각은 별개이며 1분 간격을 유지한다.
- 새로운 PM은 `generation=2`, `predecessor_agent_id=AGT-PM-0001`, `record_version=1`, 공식 승인 ACTIVE이다.
- 기존 PM만 `record_version 1→2`로 갱신하고, 다른 기존 ID 9개와 root·초기 `null`·기존 증거를 보존한다.
- 예상 등록부 합계 **11개 / ACTIVE 8 / RETIRED 3**.

## 실행 검증과 한계

| 검증 | 결과 |
| --- | --- |
| 기준 main·등록부·열린 등록 PR·동일 브랜치 | GitHub API 읽기 조회 후 이번 제출 기준 대조 |
| Owner 상태·효력·계보·ID 고유성·기존 행 보존 | 전송 전 JavaScript 구조 대조 및 JSON parse 검증 |
| 변경 경로 | 허용된 INF 3개만 포함하도록 단일 tree 생성 |
| 단일 부모 Git 커밋 | 실제 생성 시 main 부모 SHA·제출 head 재확인 |
| 로컬 `tools/policy.py doctor/check/preflight`, `git diff --check`, Git hooks | **NOT_RUN** — GitHub API 작성으로 로컬 실행 미지원 |
| 등록부 기존 tooling 13개 회귀 | **NOT_RUN** — 로컬 실행 미지원 |
| 원격 `policy` / `department-policy` | **PR 생성 후 실제 제출 head 체크를 별도로 확인** |
| 원격 `agent-provenance-report` | **REPORT_ONLY**. ACTIVE/RETIRED 전환은 `REGISTRY_TRANSITION_REVIEW_REQUIRED` 진단 가능; CI 통과와 구분 |
| 게임 테스트·Godot 프로젝트 로드·실제 GUI·Windows 빌드·성능 | **NOT_RUN** — 비게임 문서·등록부 변경 |
| 신규 PM의 Git 작성 권한·Owner main 병합 | **NOT_GRANTED / NOT_RUN** — 별도 승인 필요 |

## 제출 이후 검수

- 실제 PR head와 base SHA, 변경 파일 3개 및 단일 부모 Commit·Agent-ID/Task-ID Trailer를 확인한다.
- 해당 head의 필수 CI `policy`·`department-policy` 및 출처 REPORT_ONLY 진단을 확인한다. 검사 결과 미확인은 PASS로 쓰지 않는다.
- 승인되지 않은 CI·validator 예외, root 변경, Manifest, 타 부서 파일·게임 변경은 없다.
- 구 HEAD 문구 및 이전 세대교체의 제출 당시 상태 표시는 역사로 보존한다.
- 실제 `main` 병합 전에는 등록부가 아직 proposal이며, 병합·릴리스 자동 실행 금지.
