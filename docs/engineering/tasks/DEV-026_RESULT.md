# DEV-026 — DSG-008 후속 계약 검토·Owner 착수 순서 결정

- 담당: Development / AGT-DEV-0004 / 2026-11-14.
- 현재 상태: **DOCUMENT_REVIEW / CONTRACT_PROPOSED / OWNER_IMPLEMENTATION_DEFERRED**.
- 기준 main: `9e6154e926d44cdbbb2fb117fb7d3fc56d152eac`. 브랜치 `codex/DEV-026-s01-exception-contract`.
- 문서 제출 기준 main: `2baed0518e5443007c159962bfba46a8eeae5fdb`. 최초 소스 분석 기준은 위 SHA로 보존한다.
- Owner 지시·문서 제출 권한은 [티켓](DEV-026_S01_EXCEPTION_SCOPE.md) §1과 아래 후속 결정을 따른다.

## 결과

#104 최신 Design 회신과 선행 DEV 회신의7영역을 현재 S01 소스·20사례/38문구에 대조했다. 현재 공급 필드와 새 제안을 분리하고, 최소 실행 소속/계약 메타데이터·지역 guard·새 Session의 전체 View 재생성을 권고안으로 구체화했다. 정책·경제·세이브 규칙은 변경하지 않는다.

새 모델 enum/API가 이미 있다고 주장하지 않는다. 현재 제품은 완전한 동기 snapshot을 전제로 하며 일반 S01 pending은 없다. 예측 입력판·보고 run/day 식별·부분 누락·복귀는 새 검증이 필요한 소비 경계다. 같은 view_revision에서도 clock.remainder가 변할 수 있다는 현행 특성을 보존한다. report UNAVAILABLE을 일괄 미마감으로 해석하지 않는다.

| 신규 로컬 파일 | 내용 |
| --- | --- |
| [DEV-026_S01_EXCEPTION_SCOPE.md](DEV-026_S01_EXCEPTION_SCOPE.md) | 현재 지시·로컬 범위, 개발 분해·정확한 미래 변경 경로·승인 선택안 |
| [DEV-026_S01_EXCEPTION_CONTRACT.md](../gate3/DEV-026_S01_EXCEPTION_CONTRACT.md) | 고정 SHA 실제 코드/필드·책임·지역 행동·Session/보고/예측·복귀 계약 및 L2 RFC 초안 |
| [DEV-026_S01_EXCEPTION_VALIDATION_PLAN.md](../gate3/DEV-026_S01_EXCEPTION_VALIDATION_PLAN.md) | 20사례/copy_ids 적용·제외, X-01~07 검증·기존 증거 재사용·종료 기준 |
| 본 결과서 | 정적 확인·검증/NOT_RUN·기존 작업 보존·검토 요청 |

최초 로컬 검토에서는 위 Markdown 4개만 작성했다. 이번 제출은 그 4개와 새 `DEV-026_PROVENANCE.json`의 문서 출처 선언만 포함한다. 제품·테스트·씬·DATA·기존 UI-DC/Design/HQ/기획·기존 PROVENANCE·원본 증거는 수정하지 않는다. 기존 root main 및 DEV-019 로컬 4개 산출물도 보존한다. DEV-019의 HQ 전달 완료·별도 PR 없음과 이번 DEV-026 문서 PR 승인은 별개의 지시다.

## Owner 후속 결정과 개발 판단 — 2026-11-14

Owner는 본 개발 대화에서 DEV-026의 현재 검토 내용을 디자이너 사전 확인용으로 원격에 반영하고, 개발 측 이견이 없으면 이 결정을 결과서와 PR에 포함하도록 지시했다. **DEV-026 구현·제품 검증은 지금 착수하지 않으며 DEV-022~025의 선행 업무를 수행한 뒤 착수한다.** 원문과 정확한 문서 제출 범위는 티켓 §1에 기록한다.

**개발 판단: 이견 없음.** 기능 공급과 같은 UI 파일의 변경을 먼저 안정화한 뒤 예외 소비 계약을 최신 상태에 맞추는 순서는 타당하다. 다만 DEV-022~025 모두가 DEV-026의 절대 기술 선행조건이라는 뜻은 아니며, 이번 결정은 Owner의 작업 우선순위다.

| 선행 업무·공개 상태 | DEV-026보다 먼저 진행하는 이유·경계 |
| --- | --- |
| [DEV-022 #78](https://github.com/wisberry2022/MetroManager/issues/78): W06 실제 운행·정산·보고 공급, 실행 승인 대기 | current·daily·예측/실적·고정 보고의 실제 공급 기반이 바뀔 수 있다. 먼저 구현한 실제 필드를 기준으로 이번 계약을 재대조하면 두 번 수정하는 일을 줄인다. |
| [DEV-023 #79](https://github.com/wisberry2022/MetroManager/issues/79): W06 운행·재무 UI, 실행 승인 대기 | 제안 경로가 stage1_session/view/map과 직접 겹친다. 실제 공급·화면 연결과 정상/필수 예외의 L2 검토를 먼저 수행하고, 공통 S01 guard와 생명주기를 이어 적용하는 편이 안전하다. |
| [DEV-024 #80](https://github.com/wisberry2022/MetroManager/issues/80): VS-01 통합 재현·회귀·GUI 증거, 실행 승인 대기 | 기능 구현만이 아니라 DEV-018~023의 실제 연결과 인수 증거를 확보하는 업무다. 확인된 흐름을 DEV-026의 영향 회귀 기준으로 쓸 수 있다. 이후 변경 영향은 별도로 확인한다. |
| [DEV-025 #97](https://github.com/wisberry2022/MetroManager/issues/97): F-08 격리 기술 실험, 실행/Git 승인 대기 | 제품 기능 추가가 아닌 폰트·배율·배치·입력/포커스·성능 비교다. 결과는 복귀·포커스와 표현 구현 판단에 도움이 된다. 모든 F-08 최종 규격 확정을 최소 UI/DEV-026의 새 일괄 차단조건으로 만들지는 않는다. |

최신 [HQ 통합 인수표](../../hq/STAGE2_ACCEPTANCE_MATRIX.md)의 DEV-022 → DEV-023 → DEV-024 → HQ/Owner 인수 경로와 일치한다. DEV-025를 이들 업무와 무조건 직렬화하는 새 기술 의존성이나 별도 일정은 이 문서에서 만들지 않는다. #78/79/80은 댓글 0개, #97과 #104의 현재 공개 기록을 확인했으며, 기존 담당명/승인 대기 표시는 작성 당시 기록으로 읽는다. Owner가 승인한 담당 승계는 유지하고 이 우선순위 지시를 DEV-022~025의 미승인 구현/Git 범위에 대한 포괄 승인으로 전용하지 않는다.

다음 경계를 함께 유지한다.

1. DEV-023의 실제 화면 통합 전 정상/필수 오류 공급·Design L2, DEV-024의 실제 완주와 인수 기준은 그대로 필요하다. DEV-026 연기는 기존 필수 품질 기준의 면제가 아니다.
2. 선행 업무에서 실제 제품 결함이나 차단 영향이 발견되면 해당 티켓의 승인 범위에서 처리한다. DEV-026 전체를 앞당기거나 결함을 미해결인 채 PASS로 만들지 않으며, 범위 충돌이면 해당 차이만 HQ/Owner에 보고한다.
3. DEV-026 재개 시 선행 결과와 최신 통합 SHA에서 snapshot/명령·화면 수명·정확한 경로·20사례 적용/제외·검증 계획을 다시 대조한다. 이번 초안의 버전 문자열/API/경로를 확정 구현 계약으로 사용하지 않는다. 바뀐 의미/직접 영향 행만 Design과 대조한다.
4. DEV-024 증거를 미래 DEV-026 head의 새 실행으로 표시하지 않는다. 변경 영향이 없는 증거는 재사용하고 영향 행만 회귀한다. 기존 Q03~05 수용·Q12 한정 수용과 상위 PARTIAL·F-08 미확정은 보존한다.
5. 이번에는 Design이 사전 열람할 문서 PR과 저장소 제출 검사만 수행한다. 게임 자동·Godot 로드·실제 GUI·복구/부분 자료/새 Session 실험은 계속 NOT_RUN이며, DEV-026의 구현·제품 검증 착수는 보류한다.

이번 결정으로 새로운 게임/경제/세이브 명세 변경이나 현재 일정 차단 사유는 발견하지 못했다. 정확한 DEV-026 실행 일정과 확정 구현 범위는 선행 결과 대조 후 정한다.

## 정적 근거와 확인 수준

- #104 최신 [Design 회신](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6874170205)과 [선행 DEV 회신](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6873960483)을 원격에서 재확인했다. 작성 시 최신 댓글6개, 새 추가 질문 없음.
- 최신 main의 PR #118/PLN-008은 기획 문서3개 변경이다. 이전 `a65591b1e632121cd6dab4b66a23424fe8803869` 대비 이번 조사 제품 코드 변경 없음. 정책 문서 게시를 구현/Git 승인으로 해석하지 않았다.
- 실제 소스: main·Stage1Session/View/Map·PredictionState·RoutePlan·DailyLedgerReport·MinutePipeline·GameClock·기존 W04A/W05 소비기·W07 자동/GUI/fixture를 읽었다. 계약안에 함수/행 고정 링크를 제공한다.
- 기존 UI-DC 정적 의미 수용·DSG-008 v0.2/작업표·PM-015 REVIEW 상태와 후속 이슈 판정을 구분한다. 7영역은 대조 단위이며 GUI7회/20회 의무가 아니다.
- DEV-026 검색에서 main/refs/commit 제목/worktree 파일명과 GitHub Issue/PR 기존 사용을 찾지 못했다. 이는 로컬 작업 식별이며 원격 예약/신원 인증이 아니다.

## 최초 로컬 검토의 검증·NOT_RUN — 당시 기록 보존

검증은 이 worktree에서 기존 DEV-019 QA 환경의 `../DEV-019-q03-q05-qa/.venv/Scripts/python.exe`를 읽기 재사용했다. `PYTHONUTF8=1`, TEMP/TMP는 이 worktree의 `.local/temp`로 설정했다. 원격 보호·권한 인증은 검사 범위가 아니다.

| 검증 명령·대상 | 실제 결과·증거 |
| --- | --- |
| 위 Python으로 `tools/policy.py doctor` | PASS. 로컬 정책 환경 확인 |
| 위 Python으로 `tools/policy.py check` | PASS, exit 0. 검사 시 files=595 / GDScript=39, 포맷 변경 없음. `.local/validation/DEV-026_POLICY.log` |
| 위 Python의 `-` 표준입력 일회성 정적 감사 | PASS. 신규 Markdown 4개 UTF-8/BOM 없음·LF·끝줄·공백, 상대 링크 18개, 원본 카탈로그/검수표와 20사례·copy_ids 일치, 카탈로그 38문구. `.local/validation/DEV-026_STATIC_AUDIT.json` |
| `git diff --check`, `git status --short` 및 tracked/staged diff 대조 | PASS. 기존 tracked/staged 변경 0개, 신규 문서 4개만 존재. Design의 actual_result=null·evidence_refs=[]·NOT_RUN도 유지 |

- 게임 자동 테스트: NOT_RUN.
- Godot 프로젝트 로드: NOT_RUN.
- 실제 GUI/키보드·게임 플레이·부분 자료/새 Session/지연 응답/복귀 실험: NOT_RUN.
- 빌드/export·성능·폰트/DPI/필터·접근성/외부 사용성 인수: NOT_RUN.
- Commit·Push·PR·이번 원격 CI·preflight·병합·외부 댓글/메시지: NOT_RUN.

## 문서 제출 검증 — 후속 기록

제출 기준까지의 진전은 PR #119/PM-016의 HQ 문서 6개뿐이다. 제품·테스트·정책·Design 원본은 최초 분석 기준과 동일하다. 미공유 작업 브랜치를 정상 fast-forward로 동기화했으며 root main이나 다른 worktree는 전환하지 않았다.

문서 제출용 전용 `.venv`를 준비했다. 최초 제한 환경의 pip 연결은 DNS 오류로 실패했으며 정상 네트워크 설치로 저장소 고정 요구사항을 설치했다. 검사 우회나 의존성 파일 변경은 없다. GitHub 플러그인의 보호 설정 조회는 403으로 제한되어 기존 Git 인증의 읽기 전용 API로 확인했다. main은 strict `policy`·`department-policy`, 관리자 적용·선형 이력·대화 해결 필수, force push/삭제 금지다. 승인 리뷰 수 0은 기존 단일 계정 운영이며 Owner의 별도 병합 승인 원칙을 유지한다.

문서·정책 검증 결과는 아래와 같다. 커밋 이후 preflight·원격 head와 CI는 이 PR 본문 및 실행 결과를 정본으로 연결하며, 아직 실행하지 않은 검사를 이 문서에서 PASS로 표시하지 않는다.

- `.venv/Scripts/python.exe tools/policy.py doctor` 및 `check`: PASS. 고정 gdtoolkit의 GDScript 39개 포맷 변경 없음·lint 정상. 로그 `.local/validation/DEV-026_SUBMISSION_POLICY.log`. TEMP/TMP는 이 worktree의 `.local/temp`.
- Python 정적 감사: PASS. 신규 Markdown 4개·출처 JSON 1개만 존재, 기존 tracked 파일 변경 0개, UTF-8/LF·상대 링크 20개·20사례/copy_ids·38문구·출처 blob 4개 대조. `.local/validation/DEV-026_SUBMISSION_STATIC_AUDIT.json`. 기존 Design 실제 결과/증거/NOT_RUN과 분석 기준 이후 제품·시험·Design 원본 불변 확인.
- `git diff --check`: PASS. stage/commit 시 정확한 5개 경로와 정상 훅을 다시 확인하며, 문서 제출의 정책/도구 검사를 제품 자동검사로 합산하지 않는다.
- 제품 자동·Godot 로드·실제 GUI/플레이·빌드/export·성능: NOT_RUN — Owner의 DEV-026 착수 보류.
- main 병합·릴리스/배포·별도 Issue 댓글/부서 메시지: NOT_RUN.
- 출처 선언은 REPORT_ONLY이며 신원·승인 인증이 아니다. 등록부 지연은 실제 Agent-ID와 유효 Owner 전환 기록을 유지하여 보고한다.

## 남은 결정과 검토 요청

권고 계약의 채택은 아직 확정되지 않았다.
Design의 사전 검토 대상은 지역 자료/행동군 의존성, 최소 메타데이터, 새 Session의 View 재생성, 실제 복귀 포커스, 적용/제외 사례다. RFC-DEV-026-01은 OPEN / PROPOSED이며 Design의 새 수용은 PENDING이다. 문서 PR 공유는 승인됐으며 B/C 구현·제품 검증은 Owner 결정으로 보류한다. 정확한 일정은 NOT_ESTIMATED다.

게임/경제/세이브 명세 변경 필요 NONE. 기술 계약은 PROPOSED이며 구현 승인 후 검증과 영향 행 Design 인수가 필요하다. Q03~Q05 잔여 PASS, QA-001/002·OBS-01·A02-11·Q12의28조건 한정 수용, A01-Q12 상위 PARTIAL, F08-01~04 및 최종 규격 미확정을 보존한다. DSG-008 전체·S2-D01·Stage DONE을 선언하지 않는다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-026
