# DEV-006 — Gate 3-0 개발 분석 결과

현재 분석 통합 산출물은 [인수인계 v1.0](../gate3/DEV-006_ANALYSIS_HANDOFF.md)과 본 문서 마지막의 분석 통합 후속 제출 절을 따른다. 앞부분은 최초 PR #27의 제출/검증 이력이다.

- 담당: Development / LAPTOP / 2026-11-01 / REVIEW / L2 계획 제안
- [티켓·Owner 착수 근거](DEV-006_GATE3_DEVELOPMENT_PLAN.md), 기준 `ca597ec541647aa2e9701ec93972e8763eae066d`.
- 추적: [Issue #25](https://github.com/wisberry2022/MetroManager/issues/25), 산출물 검수·외부 계약 상태·PR 제출을 구분해 추적.
- 브랜치: codex/DEV-006-gate3-development-plan. 최초 로컬 분석 후 Owner가 이번 제출의 commit/작업 브랜치 공유/PR 생성을 승인했다. 실제 head SHA·PR URL·CI 결과는 PR 본문에 기록한다. main 병합·릴리스 없음.

## 결과와 변경 파일

| 파일 | 작성 내용 |
| --- | --- |
| docs/engineering/tasks/DEV-006_GATE3_DEVELOPMENT_PLAN.md | 착수·명세·범위·권한·수용 기준 |
| docs/engineering/gate3/DEV-006_DEVELOPMENT_PLAN.md | WBS·11 MUST/10 AC/2 VP 연결, 첫 입찰 Slice와 제안 경로 확장, 재현·회귀·외부 계약/위험 |
| docs/engineering/gate3/DEV-006_UI_DATA_CONTRACT.md | Design 협의용 의미 필드·시각/기간·돈/인원·원인/행동·경계 fixture 초안 |
| docs/engineering/collaboration/WORK_STATUS.md | DEV-006 담당/로컬 상태와 기존 DEV-005 병합 사실 추적 |
| docs/engineering/tasks/DEV-006_RESULT.md | 본 검증·미해결·다음 단계 |

신규 작업을 구현 가능한 묶음으로 분해했고 첫 VS-01은 입찰→공사→시험/안전→실제운행·보고→다음사업을 제안한다. VP-01 회사 제안도 별도 VS-02와 독립 인수 경로로 유지한다. 공통 시각/원장/OD 검수와 UI 의미 협의를 병행하도록 구성했다. 미승인 게임 기능·납기·성능 목표를 확정하지 않았다.

## 실제 검증과 한계

| 종류 | 명령·증거 | 결과 |
| --- | --- | --- |
| Git 상태·기준 | git status --short --branch, git worktree list, git fetch origin, 원격 branches/main·열린 Issue/PR 조회 | PASS. 시작 main clean, worktree1, 최신 ca597ec 기준 새 브랜치. DEV-006 기존 정식 티켓·열린 Issue/PR 없음 확인 |
| 규정·승인 | AGENTS·개발 공통 규정·README, PM-007/008/008-GIT/008-DEV, C/D/DATA·최종 승인·이월 자료, INF README/정책 확인 | Gate 2 OWNER_APPROVED, Gate 3-0 분석 범위·A안 확인. PM-008 내부 REQUEST_DRAFT/옛 게시 상태와 Owner의 이번 착수 지시를 구분 |
| 로컬 도구 | .venv/Scripts/python.exe tools/policy.py doctor | PASS |
| 엔진 실측 | ../godot/Godot_v4.7.2-stable_win64_console.exe --headless --version | PASS: 4.7.2.stable.official.ed1daf0bf |
| Godot 프로젝트 로드 | 같은 실행 파일 --headless --editor --path . --quit | PASS, 종료0. filesystem scan/editor layout 완료. headless 에디터 초기화에 한정 |
| 소스 조사 | git ls-files의 .gd/.tscn/.tres/.cs/export 경로, project.godot 확인 | 게임 소스0, main_scene/export preset 없음. 도구/정책 테스트만 존재 |
| 정책·문서·추적 검사 | tools/policy.py check, UTF-8/LF·링크·11 MUST/10 AC/2 VP·WBS 식별자 및 git diff --check | PASS. 문서 5개와 매핑·부서 경로·브랜치/티켓 규칙 검사, GDScript0 |
| 게임 자동/회귀 테스트 | 게임 코드 미구현 | NOT_RUN. 미래 검수 계획·정적 기대값을 실행 PASS로 표현하지 않음 |
| 정책 도구 테스트 | .venv/Scripts/python.exe -m unittest discover -s tests/tooling -v | PASS, 23/23. 예상 bad_script.gd 파싱 거부 출력은 부정 입력 테스트이며 전체 OK. 게임 테스트와 구분 |
| 실제 게임 플레이·GUI 렌더링 | main_scene/게임 없음 | 각각 NOT_RUN. headless PASS로 대체하지 않음 |
| Windows 빌드·성능·사용성 | export preset/합의 목표·화면 미구현 | 각각 NOT_RUN |
| 원격 CI | 제출 후 최신 head의 policy/department-policy 확인 | 제출 전 PENDING, 실제 job 결과·링크는 PR 본문 기록 |

Godot 로드 과정의 .godot 캐시는 무시 경로이며 추적 게임 파일·설정·아이콘·타 부서 문서를 수정하지 않았다.

## 최초 제출 시 미해결과 다음 인계 (이력)

- UI 의미 계약 v0.1은 L2 초안이다. Design 수용과 Planning 의미 확인은 PENDING이며 P05/06/07/다음사업 통합 전 합의한다.
- 지도 경계 도형·밀집 목업, PC/뷰포트·폰트/표시 상한·FPS 목표, 외부 사용성 표본/비용은 해당 부서/Owner의 G3 이월 조건이다. 순수 규칙 분석 전체를 차단하지 않는다.
- HQ가 본 WBS와 다른 부서 결과의 의존성을 통합하고 첫 Stage/실행 티켓을 Owner에게 상정한다. 실제 게임 코드 착수는 해당 티켓 승인 후다.
- DEV-006 분석 문서의 원격 제출은 이번 Owner 직접 승인에 따라 진행한다. 승인 원문·허용 범위는 티켓의 후속 원격 제출 승인 절을 따른다. Design/Planning 계약 수용·HQ Stage 통합은 별도 PENDING이다.
- 게임 기획 명세 변경 필요: 현재 없음. 모호성/부서 경계 변경 발견 시 Issue RFC로 상정하며 담당과 차단 시점을 기록한다.
- 이번 보고는 검수 요청이며 DONE·ACCEPTED·최종 계약 수용·게임 구현 완료가 아니다.

## 분석 통합 후속 제출 — 2026-11-01 / REVIEW

- Owner 승인·경로·기간은 티켓의 분석 통합 후속 제출 승인 절을 따른다. 기준 main 4bdf65f9b832ab8235f818441bddae6423951585, 브랜치 codex/DEV-006-gate3-analysis-consolidation.
- 변경6파일: gate3/DEV-006_ANALYSIS_HANDOFF.md 신규, gate3/DEV-006_UI_DATA_CONTRACT.md v0.2 및 DEV-006_DEVELOPMENT_PLAN.md v0.2, tasks의 DEV-006 티켓·본 결과, collaboration/WORK_STATUS.md.
- #25/#24의 개발 결정·답변을 파일로 동기화했고 Design PR #30 head 47fe5923c8ff730dbbf6c03daace304e96a856bc에서 UI-DC-01~07 DESIGN_SEMANTIC_ACCEPTED·미해결 의미 질문 없음을 확인했다. 최초 조회 당시 미병합이었으나 제출 직전 main 8ef97626ba96844648a6de2e2cb9654e6816ce40에 #30 병합을 확인했다. 최종 구현 인수/Planning 후속 ACCEPT를 대리 선언하지 않는다.
- PLN-R01 계약 단계/현재 안내 분리·R02 같은T/비영업 판정·R03 공급/소비/행동/fixture·R04 예측/cohort/시각/명령 연결·R05 표시도형/판정 원본 분리 정리. 새 게임 정책 변경·부서 전체 재검토/L3 상정 필요 없음.
- 정적 산술 검산: 자기약정80000/부족1000/후순위운임 뒤80000, B정산500→C320/R20/F300/B0, 12:00/00:09 영업조건, cohort8→2. 게임 실행 검증과 구분한다.
- doctor·policy check PASS(worktree121파일/GDScript0), 정책 도구 테스트23/23 PASS. 문서6개 UTF-8/LF/공백/링크·11 MUST/10 AC/2 VP/UI-DC-01~07 매핑·원문 보존 및 diff 검사 PASS. 정적 금액/시각/cohort 검산 PASS. bad_script.gd 오류는 부정 입력 거부 테스트의 예상 출력이며 전체 OK.
- 이번 Godot 프로젝트 로드·게임 자동테스트·실제 플레이/GUI·Windows 빌드·성능·사용성: 각각 NOT_RUN. 문서 전용 통합이며 이전 headless 로드/도구 테스트 증거와 구분한다.
- 추가 외부 질의 없이 분석 산출물 제출 가능. 실제 공급/fixture·지도 목업·기기/표현/사용성 목표·실행 티켓/Stage의 기존 후속 의무는 인수인계표에 유지한다. 게임 명세 변경 필요 없음.
- 이전 Git HTTPS 인증 실패가 확인돼 base tree 보존·단일 부모 커밋·새 작업 브랜치의 GitHub API 방식으로 제출한다. 로컬 검증 트리와 동일성 확인 후 로컬 브랜치를 원격 head로 정렬한다. 실제 SHA·PR·CI 결과는 PR 본문 기록. main 병합 없음.

- 동시 main 갱신 대응: #30의 Design 문서2개가 main 8ef9762에 병합됐음을 확인하고 미공유 단일 DEV 커밋을 최신 main 위로 rebase했다. 분석 근거4bdf65f/고정 Design head는 보존하며 제출 base만8ef9762로 갱신. 타 부서 변경 보존, merge commit·force push 없음.
