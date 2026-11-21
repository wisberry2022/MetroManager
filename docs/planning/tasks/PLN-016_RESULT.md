# PLN-016 결과 — E01 A1+B1 결정의 기획 문서 반영

> **2026-11-21 후속 승인:** Owner가 PLN-016 산출물과 Commit·일반 Push·PR 생성을 승인했다. 현재 **OWNER_DELIVERABLE_APPROVED / GIT_SUBMISSION_AUTHORIZED / MAIN_MERGE_PENDING**이며 승인 범위는 [PLN-016 §6](PLN-016_E01_OWNER_DECISION.md#6-산출물git-제출-후속-승인--2026-11-21)을 따른다. 아래 PLN-016의 review 버전명·LOCAL_REVIEW·GIT_APPROVAL_PENDING·Git 미수행 표기는 승인 전 작성 이력으로 보존한다. 게임 규칙 본문은 승인 검토본과 동일하며, 실제 제품 검증과 RFC 별도 발송은 수행하지 않았다.

- 담당: Planning 추적 / AGT-PLN-0003 / 2026-11-21 (Asia/Seoul).
- 상태: **OWNER_POLICY_APPROVED / LOCAL_DOCUMENT_REVIEW / GIT_APPROVAL_PENDING / REPLY_NOT_SENT**.
- 기준 main: `d7483a97e701c30e73f87d20ba5c0ca78a54de4a`.
- [Owner 승인·DEC·범위](PLN-016_E01_OWNER_DECISION.md) / [DEV·HQ 회신안](PLN-016_RFC_DEV027_E01_REPLY_DRAFT.md).

## 변경 결과

C v0.8-review·DATA v1.5-review에 실패 심사 계획의 고유 출발 동 집합(A1), 동일 사업 최초 해당 실패의 E01 총1회(B1)를 반영했다. PLN-013의 W4B-15~17·DI-03에는 두 정책 질문의 해소와 실제 공급/제품 검증 대기를 구분했다. 문안 review는 승인된 정책의 효력 대기가 아니다.

대상·시점·중복 동·사업 동일성·접수 실패/성공 후 실패·다른 사업 격리·예측/실운행/보고 연결의 정적 기대값 E01-01~12를 DATA에 추가했다. 기존1440분·25%·관련/미사용·소비 규칙·R01~03·PAR/SEM/CLOSE·도시/OD 원값·확률·MVP/VP를 유지했다. 소스·제품 DATA·타 부서 문서는 변경하지 않았다.

변경 파일은 티켓 §3의 기획6개다. D v0.9·Gate 2 승인 원본·과거 기획 결정/검증과 PLN-013 초기 기준 SHA/링크를 보존했다. 별도 승인 기록과 미발송 RFC 회신안을 작성했으며 DEV/HQ의 수신·동의나 실제 구현/Stage 완료를 주장하지 않는다.

## 원격·로컬 기준 확인

- 승인안 비교 기준 `fa968b94641d24e8d68b3c6cb903f9e809d02814` 이후 [PR #160](https://github.com/wisberry2022/MetroManager/pull/160)이 반영됐다. 차이는 Design 문서4개이며 기획/DEV E01 원문·공통 지침·제품 변경은 없다.
- 작성 중 [PR #161](https://github.com/wisberry2022/MetroManager/pull/161)이 병합돼 최종 조회 main은 `1a941196cc6d963db93a9fba6a0386b16710aa46`다. d7483a9…와의 차이는 DEV 문서4개이며 기획3개/정책/제품 변경0, RFC §6 원문 불변을 확인했다. §12.4의 DI-03 답변 대기는 이번 회신 미전달 상태와 구분해 연결했다. 로컬 HEAD/검사 base는 d7483a9…이고 원격 최신 SHA에서 새 검사를 실행했다고 기록하지 않는다.
- 최신 main의 새 별도 사본에서 작업했다. 공유 checkout의 main·기존 데이터2개 미커밋 변경을 보존한다. 기존 PLN-013 사본도 수정하지 않는다.
- 현행 지침·기존 파일·project.godot·RFC 양식·HQ 운영 규정의 승인 상태를 읽었다. 새 사본의 정상 훅 설치·doctor PASS. 원격 보호/Owner 승인 인증 또는 Git 제출 PASS를 뜻하지 않는다.
- 원격 반영 SHA·Commit·PR: **PENDING / NOT_PERFORMED**. 이번 승인에 Git 권한은 포함되지 않는다.

## 검증 기록

작업 위치는 공유 저장소 아래 `.local/pln016-e01-review`, 검사 Python은 `../../.venv/Scripts/python.exe`다. 아래 명령은 이 격리 사본에서 실행했다.

| 검증 명령·대조 | 결과·증거 |
| --- | --- |
| `../../.venv/Scripts/python.exe tools/policy.py doctor` | **PASS / exit0**. 정상 훅 설치 후 실행, 정책 우회 없음 |
| `../../.venv/Scripts/python.exe tools/policy.py check` | **PASS / exit0**. `57 files would be left unchanged`, `Success: no problems found`, `PASS: worktree files=735, GDScript=57`. 코드 정적 검사이며 게임 테스트가 아님 |
| `git diff --check` | **PASS / exit0**. 추가3개 파일의 UTF-8/LF·공백은 아래 감사로 함께 검사 |
| `../../.venv/Scripts/python.exe .local/validation/PLN-016/audit_docs.py` | **PASS / exit0**. 기획6개 경로·상대 링크54개 참조·표23개 열 수·W4B30개 및 E01 정적 기대12개 ID. 과거 감사 블록·C 경제/시간/OD·DATA 도시/확률/기존 수치 표·W05/SEM·D/최종 승인·PLN-013 비영향27행/초기 링크 보존 |
| DATA 원값에서 정수/유리수 정적 검산 | **PASS**. P-A6역→고유5동(D01/02/03/04/08), D08 두 역에도200→250 한 번,8동 결과2500/1875/1500/1000/600/400/300/250. 격리101→126.25, T600+1440=2040·직전2039, D04→D05 접근0 유지 |
| 원격 main·비교 API, 로컬 HEAD/status·공유 데이터 SHA-256 대조 | **PASS**. PR161은 DEV4개만 변경·기획 충돌0. 로컬 HEAD d7483a9…·별도 브랜치 유지, staged0·기획6개 변경. 공유 기존 데이터2개 해시 불변 |

문서 감사/정적 산술의 PASS이며 E01 게임 상태 전이12건을 자동 실행한 결과가 아니다. 접수/재실패·사업 격리·소비의 기대값은 승인 결정과 수동 대조했고 제품 검증은 NOT_RUN이다. 보조 스크립트·기준 파일·결과 JSON·원격 차이 목록은 격리 사본의 `.local/validation/PLN-016/`에 보관하며 Git 제출 경로에 포함하지 않는다. 기준 원본 blob은 C `2227eb0fe390abe3e19d9ac83b96c4f1ef3bc0ce`, DATA `8d41c93cc8a62a46c5c9c587614a6003095f559b`, PLN-013 `ff77065679482df8efc897a9f1fd7863d8f3c92d`다.

## 미실행·후속

- 실제 W04B/E01 공급·DEV 계약 반영·DEV/HQ 수신 확인: **NOT_VERIFIED / NOT_SENT**.
- 게임 자동 테스트·Godot 프로젝트 로드·GUI/플레이·독립 Design·VS-02·성능·빌드/export: **NOT_RUN**.
- Commit·Push·PR·병합·Issue 변경/댓글·타 채팅 메시지·릴리스: **NOT_PERFORMED**. 커밋 후 preflight·신규 원격 CI: **NOT_RUN**.
- 정책 질문2건의 Owner 결정은 완료. RFC 원격 상태는 미변경이며 실제 공급/검증과 해당 UI 수용·S3-12/Stage 인수는 별도다. 전달 후 DEV/HQ가 계약/인수표의 해당 행을 연결한다.
- 명세 변경 필요: **승인된 A1+B1의 C/DATA·PLN-013 문안 반영 완료(로컬 검토본)**. 추가 정책 선택을 이번 작업에서 만들지 않았다. 새 충돌이 실제 발견되면 영향 행만 보고한다.

Agent-ID: AGT-PLN-0003
Task-ID: PLN-016

## 후속 승인 및 Git 제출 기록 — 2026-11-21

Owner가 PLN-016 산출물과 Commit·일반 Push·PR 생성을 승인했다. 정확한 승인 원문·6개 경로·브랜치·허용 동작·유효 범위는 티켓 §6을 따른다. 위 로컬 검토/Git 대기 기록은 승인 전 이력이다. RFC 회신안의 별도 발송·수신 확인과 main 병합은 이번 실행에 포함하지 않는다.

- 제출 base: `1a941196cc6d963db93a9fba6a0386b16710aa46`. d7483a9… 이후 DEV 문서4개만 변경·기획/지침/제품 변경0. 승인된6개 원본 SHA-256 일치 확인 후 이 전용 사본의 작업 브랜치만 fast-forward했다. 원격 동일 이름 브랜치·열린 PR은 없음으로 확인했다.
- 승인 문서 본문 보존: **PASS**. 6개 파일의 후속 승인 안내와 본 티켓/결과의 제출 이력만 추가했다. A1/B1·기존 규칙·정적 기대값·원래 검증 이력은 승인 검토본 그대로다.
- `.venv/Scripts/python.exe tools/policy.py doctor`: **PASS**. 정상 훅이 기존 Python을 사용하도록 이 사본에 `.venv` junction을 연결했다. 상대 대상 경로와 일반 권한 생성 시도는 실패했고 절대 경로·승인된 권한으로 생성한 뒤 doctor가 통과했다. 훅/정책 변경이나 우회는 없다.
- `.venv/Scripts/python.exe tools/policy.py check`: **PASS / exit0**, 파일735개·GDScript57개, 포맷 변경0. `.local/validation/PLN-016/submission_policy_check.log`에 출력 보관.
- `.venv/Scripts/python.exe .local/validation/PLN-016/audit_submission.py` 및 `git diff --check`: **PASS / exit0**. 기획6개 경로·상대 링크60개 참조·표23개·W4B30개/E01 기대12개·기존 규칙/감사 이력/승인 본문 보존·정적 산술을 확인했다. 기록은 `.local/validation/PLN-016/`의 승인 원본/해시 및 `submission_audit_result.json`에 보관한다. 게임 실행을 대신하지 않는다.
- 원격 main은 protected=true, 필수 `policy`·`department-policy`를 확인했다. GitHub 연결의 상세 protection 조회는 권한403으로 strict/관리자 강제/선형 이력 등 상세 설정의 독립 재확인은 **NOT_VERIFIED**다. 보호 설정을 변경하지 않았다.
- 일반 권한 Git fetch는 네트워크 시작 오류로 실패했으며 승인된 네트워크 권한으로 fetch 성공 후 위 main을 비교했다. 같은 제한의 ls-remote 대신 GitHub 브랜치 목록/PR 조회로 이름 충돌을 확인했다. 오류를 최신 상태 확인 성공으로 기록하지 않는다.
- 제출 커밋·PR 번호, 커밋 후 preflight, 실제 원격 head의 필수 CI 결과는 이 제출의 PR 본문과 완료 보고에 기록한다. 커밋 전 문서에 미래 결과를 PASS로 선기록하지 않는다.
- 신규 게임 자동 테스트·Godot 로드·GUI/플레이·독립 Design·VS-02·빌드/export는 **NOT_RUN**. 공유 checkout의 기존2개 데이터 변경과 HEAD는 보존한다. main 병합·릴리스·Issue 댓글·부서 별도 메시지는 미수행이다.
