# INF-004 — Track B 독립 등록 검증·제출 결과

- 담당: INF / `AGT-INF-0001` / 2026-11-08
- 상태: REVIEW / OWNER_APPROVED_FOR_SUBMISSION / MAIN_MERGE_PENDING / NOT_DONE
- 티켓·승인: [INF-004_TRACK_B_AGENT_REGISTRATION.md](INF-004_TRACK_B_AGENT_REGISTRATION.md)
- 기준 main: `96139dfb1fd26f449e84e7f08986b0ab17e06787`
- 기준 registry blob: `30d086e001dfc36c60262c2824213a7c6c6b94b3`
- 브랜치: `codex/INF-004-track-b-agent-registration`

## 변경 결과

Owner 승인 예약 ID `AGT-DSG-0003`을 독립 Track B Visual Design / Art Director 세션의 최초 등록으로 추가한다. `ACTIVE`, `generation=1`, `predecessor_agent_id=null`, `handoff_ref=null`, `record_version=1`, `activated_at=2026-11-08T16:25:00+09:00`, `retired_at=null`이다. DSG-006·007·008 담당 연속성 및 별도 HQ 확인 대체는 Owner 결정으로 기록했다.

| 변경 파일 | 내용 |
| --- | --- |
| `docs/infra/agents/registry.json` | 신규 Track B 한 행 추가 |
| `docs/infra/tasks/INF-004_TRACK_B_AGENT_REGISTRATION.md` | 공개 역할·예약·Owner 활성화·현재 Git 승인·INF 검토·경계 |
| `docs/infra/tasks/INF-004_RESULT.md` | 검증 증거·진단·잔여 사항 |

기존 9개 행 전체 및 상대 순서, 모든 역사 시각·legacy null, root 메타데이터를 보존한다. 결과는 10개 ID, ACTIVE 8 / RETIRED 2다. Track A 계보와 기존 디자인 산출물·저자·승인·QA 판정은 변경하지 않는다.

## 검증 기록

최신 main에서 기존 작업과 분리한 worktree 및 전용 `.venv`를 사용했다. 저장소의 고정 requirements와 기존 `.githooks`를 유지했다. 도구·테스트·정책·CI 변경은 없다.

| 검사 | 실제 결과 |
| --- | --- |
| `.venv/Scripts/python.exe tools/policy.py doctor` | PASS — 정상 훅·도구 확인. 승인 진위·원격 보호 인증은 아님 |
| `tools/agent_registry.py check --base 96139dfb1fd26f449e84e7f08986b0ab17e06787` | STRUCTURALLY_CONSISTENT / 기존 9개 ID |
| `.venv/Scripts/python.exe .local/inf004/validate.py` | PASS — 신규 행 구조·정확한 승인 값·고유 ID/scope·계보·버전·허용된 3개 경로·공개 상대 링크/앵커·UTF-8/LF |
| 기존 데이터 보존 대조 | PASS — 신규 행만 제거하면 기준 registry blob 바이트와 완전히 동일. 기존 9개 행·root·모든 역사 시각·legacy null 8개 보존 |
| `unittest discover -s tests/tooling -p test_agent_registry_reporting.py -v` | 13 tests PASS / 42.077s — 기존 등록부 회귀, 임시 Git fixture |
| `.venv/Scripts/python.exe tools/policy.py check` | PASS — worktree files=477 / GDScript=31 / formatter·linter 정상 |
| `git diff --check` | PASS — 공백 오류 없음 |
| 실제 base→변경본 `agent_registry.compare` | DIAGNOSTICS / `REGISTRY_NEW_PENDING_ONLY`; 구조 PASS와 별개 |
| Commit 후 `policy.py preflight`·정상 Git 훅 | 제출 시 실제 결과를 PR에 기록 |
| 원격 `policy`·`department-policy`·출처 보고 | PR 생성 후 실제 head의 결과·로그를 PR에 기록 |

로컬 보조 검사 `.local/inf004/validate.py`는 실제 main의 `trusted`, `bootstrap_legacy`, `validate`, `compare`를 사용한다. 승인 데이터와 보존 불변조건, 새 행 제거 후 base 바이트 일치까지 대조한다. 보조 검사기는 Git 제외 경로에 있으며 제출 3개 파일에 포함되지 않는다.

첫 policy check는 샌드박스 임시 디렉터리 접근 제한 `WinError 5`로 중단됐다. 검사 코드를 변경하지 않고 정상 임시 디렉터리 접근이 가능한 실행 환경에서 재실행하여 PASS했다. 훅 해제·검사 우회는 하지 않았다.

제출 전 재조회에서 원격 main은 위 기준과 동일하고, 열린 PR은 0개, 동일 작업 원격 브랜치는 없었다. branch API는 `protected=true`와 필수 `policy`·`department-policy`의 GitHub Actions App 바인딩을 반환했다. strict·관리자 우회 등 세부 보호 전체를 새로 검증한 것은 아니다. 보호 설정 변경은 없다.

Commit·Push·PR 이후의 실제 head·URL·원격 검사 결과는 PR 본문과 최종 보고로 연결한다. 파일 안에 자기 commit SHA나 미실행 CI 성공을 기록하지 않는다.

## 출처 보고와 잔여 사항

현재 delta 비교는 신규 ACTIVE를 자동 PENDING 제안으로 수용하지 않으며 `REGISTRY_NEW_PENDING_ONLY` 진단 대상이다. 구조 검사·Owner 승인 내용 대조와 delta 진단을 구분한다. REPORT_ONLY job success는 자동 등록 승인·DECLARATION_CONSISTENT·신원/승인 인증을 뜻하지 않는다. 첫 registry_delta 진단 이후 실행되지 않은 선언·Manifest 검사까지 통과했다고 주장하지 않는다. 승인 범위 밖 `_PROVENANCE.json`은 추가하지 않는다.

main 병합은 별도 Owner 승인 대기다. 기존 root의 과거 pending 문구, DEV-017 일반 생애주기/event 계약 및 ENFORCE는 별도 후속이다. DSG-006 원본 공용 보관·F-08·최종 디자인 규격·S2-D01 인수는 각 담당의 기존 과제로 남는다. 게임 명세 변경 필요는 NONE이며 이번 등록은 Track B의 포괄 제작/Git 권한을 부여하지 않는다.

| 실행 수준 | 상태·이유 |
| --- | --- |
| 자동 게임 테스트 | NOT_RUN — 등록부·INF 문서 변경 |
| Godot 프로젝트 로드 | NOT_RUN — 게임 소스·씬·설정 미변경 |
| 게임 플레이·실제 GUI 검수 | NOT_RUN — 등록 검증과 별개 |
| Windows 빌드·성능 | NOT_RUN — 이번 승인 범위 밖 |
| 자동 등록 workflow_dispatch | NOT_RUN — 승인된 수동 ACTIVE 등록 제출 |
| main 병합·릴리스 | NOT_RUN — 이번 실행 범위 밖 |
