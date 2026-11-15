# DSG-008 — DEV 회신 반영·P06/P07 재대조 준비 결과

- 담당: Design Track B / AGT-DSG-0003 / 2026-11-15 / v0.1.
- 상태: **LOCAL_REVIEW / DEV_RESPONSE_RECEIVED / RECOMPARE_REQUIRED / FINAL_SPEC_PENDING / NOT_DONE**.
- 기준 main: `a9ce63a09e0778435bb8c7ef1fd0501aa10f430d`.
- 브랜치: `codex/DSG-008-dev026-p06-p07-recompare`.

## 1. Owner 지시와 포함·제외

> DEV 회신을 반영해 DSG-008 후속 상태와 DEV-026 재개 전 P06/P07 재대조 항목을 로컬 문서로 정리해주세요. 과거 승인·검증 기록을 보존하고, F-08 미해결 항목과 NOT_RUN을 구분하며 최종 규격은 미확정으로 유지한 채 먼저 검토 요청해주세요.

포함은 수신 회신·관련 판정/계약/소스의 정적 확인, 신규 Design 문서2개와 로컬 검증이다. 기존 문서/문구·검수표·제품·타 부서 파일 수정, 실제 게임/GUI 실험, 외부 댓글, Commit·Push·PR·병합·릴리스/배포는 제외한다. 앞선 PR #122 제출/이슈 전달 승인을 새 작업의 Git·외부 전달 승인으로 재사용하지 않는다.

## 2. 변경 파일 — 신규2개

| 파일 | 내용 |
| --- | --- |
| [DSG-008_DEV026_RESPONSE_AND_P06_P07_RECOMPARE.md](DSG-008_DEV026_RESPONSE_AND_P06_P07_RECOMPARE.md) | DEV 회신 후 상태, P06/P07의 RP-01~08 대조, Track A 한정 수용·잔여 연결, 재개 입력·F-08/NOT_RUN |
| 본 결과서 | 승인 범위·변경·검증·미해결·로컬 검토 요청 |

docs/design/tasks/에만 추가한다. 공유 root main·기존 worktree를 전환하지 않고 최신 origin/main 기반 별도 worktree에서 작성했다. 기존 L2 의견/결과·승인/검증·카탈로그38문구·20사례 JSON·열람기·원본 증거·타 부서 문서를 보존했다.

## 3. 결과·새 확인점

- [DEV 회신](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6887686597): L2-A/B/C 의미상 이견 없음, fallback 잠정, DEV-026 보류·선행 후 재대조. 계약 문서 개정이나 제품 수용 완료는 아님.
- DEV-023 공급 L2는 [#79](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6886354300)에서 수용됐고 PR #128 화면 통합은 병합됐다. 동일 공급 인계를 다시 요구하지 않는다. RFC-DEV-023-01과 RFC-DEV-026-01을 구분한다.
- [최신 Track A 판정](https://github.com/wisberry2022/MetroManager/issues/79#issuecomment-6887692818)은 독립 GUI **21조건 한정 PASS / 전체 PARTIAL / 보완3조건**이다. 기존 원본/중단/미확인 이력과 A01-Q12 상위 PARTIAL을 보존했다. Track B가 원본 ZIP을 독립 열람·재검증했다고 주장하지 않는다.
- 소스 대조에서 새 P06/P07 자식·shown·보고일/조회 확인 사본·Host 복귀 문맥을 재개 대조 대상으로 연결했다. 특히 S01 직전일 요약과 P07 FIXED_DAY의 기대 마감일은 달라 기존 직전일 조건을 새 선택 보고에 일괄 적용하지 않도록 명시했다. 정적 적용 문맥 차이이며 재현 결함 판정이 아니다.
- 기존 계약 문서의 범위 보완은 DEV 재개 시 후속이다. 새 게임/경제/시간/세이브 명세 변경 필요 NONE. 실제 부서 경계/범위 충돌이 생기면 해당 차이만 RFC로 상정한다.

## 4. 검증

- 필수 공통 지침·Design README·GOV-001 DRAFT/승인 운영 원칙·RFC 양식·PM-015·프로젝트 설정을 직접 확인했다. 현재 main까지 공통 진입 지침 변경 없음도 대조했다.
- root `.venv/Scripts/python.exe tools/policy.py doctor`: PASS (local hooks/tooling). 원격 보호·신원/Owner 승인 인증은 범위 밖이다.
- 원격 main·댓글·병합 PR 조회와 `git fetch origin`: 기준 full SHA 일치. 공유 root는 main `293b5f9`와 clean 상태로 보존했다.
- worktree에서 root `.venv/Scripts/python.exe tools/policy.py check`: **PASS / exit0**, files=648 / GDScript=48. TEMP/TMP는 worktree `.local/temp`로 지정했다. 로그는 `.local/validation/DSG-008_RESPONSE_POLICY.log`에 보관한다. 저장소 정책·포맷/린트 검사이며 게임 자동 테스트가 아니다.
- 같은 Python의 `-` 표준입력 일회성 정적 감사: **PASS**. 신규2개 정확한 경로·UTF-8/BOM 없음·LF·끝개행/공백·상대 파일 링크14개·RP행8개·기준 SHA/브랜치·F08-01~04·21조건 한정 PASS/PARTIAL 및 기존20행 null/빈 증거/NOT_RUN·38문구 보존을 확인했다. 소스의 실제 자식 전달/복귀/조회 식별자도 대조했다. 결과·파일 해시는 `.local/validation/DSG-008_RESPONSE_STATIC_AUDIT.json`이다.
- `git diff --check`, 추적/스테이징 diff 및 `git ls-files --others --exclude-standard`: **PASS**. 기존 추적/스테이징 변경0개, 승인된 범위의 신규 Design 문서2개만 존재한다. 정적 소스 대조를 해당 전이의 실행 PASS로 바꾸지 않는다.

## 5. 미해결·NOT_RUN·검토 요청

미해결은 DEV-026 계약 개정·RP행 재대조·실제 guard/실행 소속/복귀 제품 인수, Track A가 지정한3조건 보완과 DEV-023 전체 PARTIAL, F08-01~04 OPEN, DEV-024/HQ·Owner 상위 인수다. 각각의 담당/적용 시점을 유지하고 이번 작업으로 전체 차단이나 완료를 선언하지 않는다.

이번 게임 자동·Godot 로드·GUI/키보드/플레이·부분 자료/새 Session/복구·브라우저·빌드/export·성능/폰트/DPI/필터·제품 접근성/외부 사용성은 **NOT_RUN**이다. 문서 검증만 수행하며 기존 DEV 실행·Track A 수용·과거 실패/미실행·출처/환경 미확인 상태를 소급 변경하지 않는다. 로컬 단계로 원격 CI·커밋 후 preflight도 NOT_RUN이다.

**최종 규격 미확정 / NOT_DONE**을 유지한다. DEV 회신 반영 상태, RP-01~08 범위, S01 직전일/P07 선택 보고의 적용 구분, 기존 증거와 Track A 보완3조건의 재사용 경계에 대한 로컬 검토를 요청한다. Commit·Push·PR·이슈 댓글/종료·병합은 수행하지 않는다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008

## 6. 후속 Git 제출 승인·기록 보존

Owner는 위 로컬 산출물 검토 후 본 Design 대화에서 다음과 같이 승인했다.

> DSG-008 DEV 회신 반영·P06/P07 재대조 준비 산출물 2개의 커밋·푸시 및 PR 생성을 승인합니다. 과거 승인·검증 기록을 보존하고, F-08 미해결 항목과 NOT_RUN, 최종 규격 미확정 상태를 PR에 명시해주세요. main 병합은 하지 마세요.

대상은 `wisberry2022/MetroManager` / DSG-008 / AGT-DSG-0003 / `codex/DSG-008-dev026-p06-p07-recompare`의 위 신규2개다. 이번 정상 Commit·해당 작업 브랜치 일반 Push·base=main PR 생성·필수 검사 및 같은 범위 검수 대응만 승인됐다. 권한은 이번 제출 종료 또는 Owner 철회까지이며 미래 작업의 포괄 위임이 아니다. main/자동 병합·강제 푸시·릴리스/배포·외부 이슈 전달·제품 구현/실험·타 부서/정책 변경은 제외한다.

앞 절의 로컬 미커밋·Git/원격 CI/preflight NOT_RUN·외부 미전달은 당시 기록으로 보존한다. 이번 승인에 따른 제출은 후속 기록으로 연결하며 기존 본문·카탈로그·검수표·승인/검증 증거를 소급 수정하지 않는다. 제출 전 fetch 확인 main은 최초 검토 기준과 동일한 `a9ce63a09e0778435bb8c7ef1fd0501aa10f430d`다.

정상 훅을 위해 전용 worktree `.venv`와 저장소 고정 의존성을 사용한다. 실제 제출 head·정상 훅·커밋 후 fetch/preflight·원격 필수 CI 결과는 PR에 기록한다. 실행 전 PASS를 미리 선언하지 않는다. 승인된2개 밖 provenance manifest는 추가하지 않으며 REPORT_ONLY 진단이 있으면 별도로 공개한다. Agent/Task 자기신고는 신원·Owner 승인 인증이 아니다.

F08-01~04 OPEN, DEV-026 보류/제품 NOT_RUN·선행 후 재대조 미완료, 최종 규격 미확정·NOT_DONE을 유지한다. Track A의21조건 한정 PASS/전체 PARTIAL·보완3조건은 해당 정본의 시점/범위로 보존한다. 이번 문서 제출은 계약 확정·제품 수용·독립 GUI 종료·Stage DONE을 뜻하지 않는다.
