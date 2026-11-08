# INF-003 — Track A 세대교체 등록 검증·제출 결과

- 담당: INF / `AGT-INF-0001` / 2026-11-08
- 상태: REVIEW / OWNER_APPROVED_FOR_SUBMISSION / MAIN_MERGE_PENDING / NOT_DONE
- 티켓·승인 범위: [INF-003_TRACK_A_DESIGNER_SUCCESSION.md](INF-003_TRACK_A_DESIGNER_SUCCESSION.md)
- 기준 main: `3b61628bc2e733452ed0448450d00fb3beff784d`
- 기준 registry blob: `bb2feea7ec788ddec029949b058b8ccad5cdbdb0`
- 브랜치: `codex/INF-003-track-a-designer-succession`

## 변경 결과

Owner가 승인한 Track A 후임 `AGT-DSG-0002` ACTIVE와 기존 `AGT-DSG-0001` RETIRED를 같은 등록부 변경으로 제출한다. 두 효력 필드는 HQ 확정 `2026-11-08T15:49:28+09:00`을 사용한다. 실제 세션 장애·커밋·PR·병합 시각을 추정하지 않았다.

| 파일 | 변경 |
| --- | --- |
| `docs/infra/agents/registry.json` | 0001 상태·종료 효력·근거·record_version 2, 0002 신규 ACTIVE·generation 2·predecessor 0001·승인 활성화 시각·record_version 1 |
| `docs/infra/tasks/INF-003_TRACK_A_DESIGNER_SUCCESSION.md` | Owner·INF·HQ 근거, Git 허용 범위, 역할/QA 경계, Track B 0003 예약·등록 조건, DEV-017 계약 한계 |
| `docs/infra/tasks/INF-003_RESULT.md` | 실제 검증·제출 절차·미해결·NOT_RUN 구분 |

기존 8개 ID의 activated_at=null, 기획 전임 retired_at=null, 다른 에이전트 7개 행과 registry root 전체를 보존했다. 0001의 immutable 필드·초기 승인·handoff_ref·기존 근거는 유지했다. 기존 디자인 산출물·저자·QA 판정은 수정하지 않았다. 결과는 9개 ID, ACTIVE 7 / RETIRED 2다.

Track B `AGT-DSG-0003`은 Owner 승인 예약만 기록했다. registry에 PENDING/ACTIVE 행은 없다. Track A의 main 반영 후 별도 등록 작업에서 독립 세션·역할·INF 검토·PM 담당/효력·Owner 실제 활성화 및 Git 범위를 확인한다. 향후 generation=1, predecessor=null이며 정확한 활성화 시각·실행일은 미확정이다. 0003 예약은 문서 대조 대상이며 기존 자동 제안기가 이를 기계적으로 강제하지 않는다.

## 검증 기록

최신 main을 fetch하고 기존 HQ worktree와 분리된 INF-003 worktree에서 수행했다. 기본 `.githooks`를 유지하고 고정 requirements를 전용 `.venv`에 설치했다. 도구·테스트·정책·CI 변경은 없다.

| 검사 | 결과 |
| --- | --- |
| `tools/policy.py doctor` | PASS — 기존 훅 및 gdtoolkit 4.5.0 확인. 원격 보호·승인 진위 인증은 아님 |
| 기준 등록부 `tools/agent_registry.py check --base 3b61628bc2e733452ed0448450d00fb3beff784d` | STRUCTURALLY_CONSISTENT / 초기 8개 ID |
| 신규 데이터·허용 diff·참조·텍스트 검증 | PASS — 구조·허용 변경 대조, 9개 ID/ACTIVE 7/RETIRED 2, 레거시 null 8개·다른 7개 행·root 보존, 정확한 3개 경로·UTF-8/LF·근거 링크 확인 |
| 기존 등록부 회귀 `unittest discover -s tests/tooling -p test_agent_registry_reporting.py -v` | 13 tests PASS / 49.208s — 임시 Git fixture, 실제 원격 등록 시험 아님 |
| `tools/policy.py check` / `git diff --check` | PASS — worktree files=469, GDScript=31, formatter/linter 정상 / 공백 오류 없음 |
| Commit 후 `tools/policy.py preflight` 및 정상 Git 훅 | 제출 시 실제 결과를 PR에 기록 |
| 원격 `policy` / `department-policy` | PR 생성 후 실제 head 결과를 PR에 기록 |
| 원격 출처 보고 | 실제 job 결과와 REPORT_ONLY 진단을 PR에 별도 기록; DECLARATION_CONSISTENT로 추정하지 않음 |

재현용 기본 명령은 전용 `.venv/Scripts/python.exe`로 위 도구를 실행한다. 로컬 제외 경로 `.local/inf003/validate.py`는 실제 main의 `agent_registry.trusted`·`bootstrap_legacy`와 변경본의 `validate`를 사용하고, root/다른 행·레거시 null·immutable·승인 효력·세대·버전·번호·Track B 미등록·정확한 3개 경로·UTF-8/LF·상대 링크/앵커를 대조한다. 이 보조 검사기는 제출 산출물에 포함하지 않는다.

최초 회귀 실행은 샌드박스 임시 폴더 접근 제한(WinError 5)으로 8개 fixture 오류가 났다. 전용 `.local/validation-tmp`와 허용된 도구 실행 환경에서 검사 코드를 바꾸지 않고 재실행해 위 13개를 모두 통과했다. 가상환경 초기 ensurepip도 실행 환경 제한 후 정상 설치를 완료했다. 검사 실패를 숨기거나 훅을 우회하지 않았다.

제출 전 GitHub branch API에서 main SHA 동일, protected=true, 필수 context `policy`·`department-policy`와 GitHub Actions App 바인딩을 확인했다. 세부 protection API는 연결 App 권한의 HTTP 403으로 읽지 못했으므로 strict·관리자 우회 등 전체 보호 설정을 새로 검증했다고 주장하지 않는다. 보호 설정 쓰기는 없다.

## DEV-017 상태 전환 진단

현재 일반 비교기는 승인 여부를 자동 판정하지 않으므로 실제 base→변경본 비교에서 `REGISTRY_TRANSITION_REVIEW_REQUIRED`를 확인했다. 기존 행을 그대로 둔 메모리 내 신규 ACTIVE 단독 비교에서도 `REGISTRY_NEW_PENDING_ONLY`를 확인했다. 이 결과는 구조 검증 PASS와 구분하며 해당 비교 자체를 PASS라고 보고하지 않는다.

이번 수동 전환은 이미 확인한 INF 수용·HQ 전환·Owner의 실제 상태 결정에 근거한다. 검사기를 고치거나 새 예외·event schema·ENFORCE를 도입하지 않는다. 원격 REPORT_ONLY는 첫 전환 진단에서 멈출 수 있으므로 뒤의 PR/commit 선언·Manifest 검사까지 통과했다고 주장하지 않는다. 승인 경로 밖 `_PROVENANCE.json`은 추가하지 않았으며 완전한 출처 선언 일관성을 주장하지 않는다.

신규 0002로 이 제출의 주체를 자체 인증하지 않는다. 기존 base의 ACTIVE `AGT-INF-0001`을 INF 업무 선언에 사용한다. `identity_authenticated=false`, `approval_authenticated=false`, `enforcement_enabled=false`의 의미를 유지한다.

## Git 제출과 잔여 사항

- Owner의 이번 승인으로 위 3개 파일만 명시적으로 stage하고 정상 Commit·일반 Push·base=main PR을 제출한다. 실제 commit/head·PR URL·필수 CI·출처 진단은 PR과 최종 보고에 연결한다. 자기 commit SHA를 파일에 요구하지 않는다.
- 작업 커밋은 단일 부모이며 기준 main을 포함해야 한다. 제출 전 최신 main과 중복 브랜치/등록 PR을 확인한다. force push·공유 이력 재작성·자동 merge·main 쓰기는 없다.
- registry root의 오래된 pending 문구 정리는 별도 후속이다. 이번 생애주기 변경과 섞지 않았다. RFC-DEV-017-01의 일반 전환/event/신뢰된 승인 계약 및 출처 강제 도입은 여전히 별도 INF·DEV·Owner 결정 대상이다.
- **main 병합은 Owner 별도 승인 대기**다. PR 제출·CI 성공이 main 정본 반영·공식 DONE·디자인 기능 수용을 의미하지 않는다.
- 게임 명세 변경 필요: NONE. Track B 등록과 후임의 신규 제작·Git 권한은 별도 작업이다.

| 실행 수준 | 상태·이유 |
| --- | --- |
| 자동 게임 테스트 | NOT_RUN — INF 등록부·문서 변경 |
| Godot 프로젝트 로드 | NOT_RUN — 게임 소스·씬·설정 변경 없음 |
| 게임 플레이·실제 GUI 검수 | NOT_RUN — 인수인계/등록 검증과 별개 |
| Windows 빌드·성능 | NOT_RUN — 이번 승인 범위 밖 |
| 자동 등록 workflow_dispatch·자동 ACTIVE | NOT_RUN — 승인된 수동 전환 PR 경로 |
| main 병합·릴리스 | NOT_RUN — 별도 Owner 승인 대상 |
