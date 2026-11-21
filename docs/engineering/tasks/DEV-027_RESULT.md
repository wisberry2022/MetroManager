# DEV-027 — 이슈 철회·착수 계획 문서 PR 전환 결과

> **현재 후속 — 2026-11-21:** PR #149 병합 후 #146 Design 사전 의견을 반영한 문서 보완이다. 제출 base는 `de0f03f9d2fcc301940a4176f1359b2788a51950`, 브랜치는 `codex/DEV-027-design-plan-followup`이며 현재 권한·결과는 §5을 따른다. 앞선 제출 식별·검증은 PR #149 당시 기록으로 보존한다. 제품 구현·실행·최종 L2·main 병합은 별도 대기다.

- 작성: Development / AGT-DEV-0004 / 2026-11-21 (Asia/Seoul).
- 상태: **DOCUMENT_REVIEW / PRODUCT_IMPLEMENTATION_NOT_RUN**.
- 제출 base: `f047edbf67a6f888eda5eed24309b78554b3c2ed`.
- 브랜치: `codex/DEV-027-stage3-start-plan`.
- [티켓·Owner 요청/제출 권한](DEV-027_W04B_VS02_IMPLEMENTATION.md) / [전체 계획](../gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md).

## 1. 변경 결과

Owner의 후속 요청에 따라 [#148](https://github.com/wisberry2022/MetroManager/issues/148)을 CLOSED/not_planned로 철회하고 개발 문서4개로 변환했다. 원문은 삭제·덮어쓰기하지 않았으며 [철회 기록](https://github.com/wisberry2022/MetroManager/issues/148#issuecomment-7053231691)을 연결했다. 이슈 제출 방식 철회이며 DEV-027·DEV-026의 작업 취소/완료가 아니다.

계획 본문의 재사용/공백, DI-01~03, RFC-DEV-027-01, L2/RP/EX 적용, 구현 후보 경로41/24개, 실행·검증 계획과 잔여는 유지했다. 현재/당시 제출 상태·문서 Git 권한·후속 연결 표현만 문서 PR에 맞췄다. 실제 제품 구현에 착수하지 않았다.

현재4개 경로는 티켓 §2에 명시했다. Markdown3개와 그 출처 JSON1개만 추가한다. DEV-026 원문, 이전 증거/정정, 공유 루트의 기존 데이터 수정2개는 보존했다.

## 2. 원본과 변환 식별

- 원본: Issue #148 본문, `updated_at=2026-11-20T23:27:21Z`, 23,683 Unicode 문자.
- 본문 식별: UTF-8 원문 SHA-256 `f26c3e26488de5c3b0d214780ad3cc7f849e7d1600ad116d0a4e5293de2a44d7`. Markdown 추가 표제·현재 제출 상태 설명·Agent-ID footer와 제출 상태 문구 변경을 원문 전체 동일성으로 주장하지 않는다.
- 정적 기준: 원문과 이번 문서 모두 위 main SHA. 기준 문서 링크는 고정 SHA를 보존했다.
- 원문 §2 재사용/공백, §4~7 DI/RFC·DEV-026/L2, §8.1/8.2 파일 표, §9의 제품 검증 내용과 VS-02 종료 조건은 대조한다.
- 이번 변환은 새 게임/경제/시간/세이브 규칙이나 RFC 답변을 확정하지 않는다.

## 3. 문서 검증

아래 문서 정적 검사를 실행했다. 제품 실행을 대신하는 검사가 아니다.

| 구분 | 명령/범위 | 결과 |
| --- | --- | --- |
| 로컬 규칙/훅 | `.venv/Scripts/python.exe tools/policy.py doctor` | PASS / exit0. 기존 `.githooks` 활성·gdtoolkit4.5.0 확인 |
| 정책/정적 소스 검사 | `.venv/Scripts/python.exe tools/policy.py check` | PASS / exit0. 708파일·GDScript53개 formatter/linter; 게임 실행 아님 |
| 변환 대조 | `.venv/Scripts/python.exe .local/validation/DEV-027-docs/audit_docs.py` | PASS / exit0. 원문 §2·4~7 보존, 후보 경로65행/고유63개 동일, 변경4개 한정, UTF-8/LF·JSON·문서 링크·출처 blob 일치 |
| 공백 검사 | `git diff --cached --check` | PASS / exit0. 문서4개 추가만 스테이징 |
| 제출 이력 검사 | fetch·정상 Commit 후 `.venv/Scripts/python.exe tools/policy.py preflight` | 제출 직전 실행, 실제 결과는 PR에 연결 |
| 원격 필수 CI | 실제 제출 head의 `policy`·`department-policy` | PR 생성 후 확인, 실제 결과는 PR Checks/후속 회신에 연결 |
| 게임 자동 테스트 | 문서 전환에 제품 변경 없음·제품 실행 별도 승인 | NOT_RUN |
| Godot 프로젝트 로드 | 동일 | NOT_RUN |
| 게임 플레이·GUI·RNG seed 탐색 | 동일 | NOT_RUN |
| 빌드/export/FPS | 이번 범위 밖 | NOT_RUN |

로컬 검사 로그/변환 원문/감사 출력은 작업 트리의 `.local/validation/DEV-027-docs/`에 보관한다. CI의 정책 도구 테스트와 게임 자동 테스트도 구분한다. 커밋 자기 SHA나 아직 실행하지 않은 CI 성공을 문서에 미리 기록하지 않는다.

새 작업 트리의 고정 검사 의존성을 설치할 때 제한된 네트워크의 이름 해석 실패가 있었고, 허용된 네트워크 실행으로 같은 requirements 설치 후 정상 검사했다. 검사 우회/의존성 변경은 없다. GitHub 플러그인의 main 보호 세부 조회는 403(Resource not accessible by integration)이어서 그 응답만으로 세부 설정을 인증하지 않는다. 원격 실제 head의 필수 CI와 병합 승인 여부는 별도로 확인한다.

## 4. 제출·후속 경계

이번 승인에 따라 문서 Commit·일반 Push·PR·필수 CI 확인을 진행한다. 실제 commit/PR/CI는 PR 본문·Checks·철회 이슈 후속 연결로 고정한다. #146/#104에는 원문 회신을 보존한 채 새 PR 위치를 알린다.

남은 제품 권한은 계획 §10의 로컬 구현·제품 실행 및 미래 구현 산출물의 Git 제출이다. Design L2·독립 실행/수용, RFC-DEV-027-01 Planning 답변, main 병합·HQ/Owner 인수도 별도다. DEV-026은 Stage 3 필수 편입/착수 준비 상태를 유지하며 과거 HOLD 또는 제품 DONE으로 변경하지 않는다.

새 명세 변경 필요: **확정 없음**. 기존 DI-03 의미 확인만 OPEN이며 이번 변환으로 닫지 않았다.

## 5. Design 사전 의견 문서 반영 — 2026-11-21

- 제출 base: `de0f03f9d2fcc301940a4176f1359b2788a51950` / `codex/DEV-027-design-plan-followup`.
- Owner의 현 요청·문서4개 제출 권한: [티켓 §5](DEV-027_W04B_VS02_IMPLEMENTATION.md).
- 근거: [Track A](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053550740), [Track B](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7053570152). 앞선 변환/검증/CI는 PR #149 당시 이력이다.

| 반영 항목 | 이번 변경·확인 수준 |
| --- | --- |
| 사전 의견과 권한 | 비의존 모델 디자인 선행 차단 없음 / 실제 공급·UI L2_FINAL_PENDING / 제품 NOT_RUN. 문서 병합·Design 의견을 실행 승인으로 사용하지 않음 |
| 접수·사본 | 대기 당시 제출 입력과 현재 초안, 심사/보류 근거·설득 사용 이력·허가 계획을 별도 표현. 재검사 실패·현재 행동·명시적 새 요청·다른 초안 대체 금지의 공급 요구 명시 |
| 다음 L2 입력 | #146 01~14·RP/EX별 실제 코드·고정본·표본·기대/관측·원본을 한 패킷에 연결. 부족 행만 보완 |
| 제한 범위 | DI-03 대상/반복 효과 종속 부분만 보류. F08 전체 확정/같은 GUI 반복/제품 후보 경로 확대 없음 |
| DEV-026 | 원문 계약·검증 계획은 별도 DEV-026 문서 PR. 두 작업의 문서/제품 권한 구분 |

실제 변경은 기존 계획·티켓·결과서·PROVENANCE **4개**다. 원문 후보 경로65행/고유63개, DI-02 확률/추출안 및 DI-03 RFC 미결, 이전 제품 증거와 NOT_RUN은 보존한다. 현재 출처 JSON은 이번 base/문서 blob으로 갱신하고 PR #149 제출 당시 manifest는 [고정 원본](https://github.com/wisberry2022/MetroManager/blob/d098d47e32159e5438aff7d702ff19f2c5d37d0f/docs/engineering/tasks/DEV-027_PROVENANCE.json)에 보존한다.

문서 검사: 실행 후 아래에 기록한다. `.local/validation/design-plan-followup/`에 정적 감사·로그를 분리 보관한다. 게임 자동/프로젝트 로드/GUI·독립 실행/seed 탐색/빌드/export는 모두 **NOT_RUN**이다.

- `.venv/Scripts/python.exe tools/policy.py doctor` 및 `check`: PASS / exit0. 파일708개·GDScript53개 정적 formatter/linter, 포맷 변경 없음. 로그 `doctor.log`·`check.log`.
- `문서 경로·링크·UTF-8/LF·출처 blob, 후보 경로/DI-02·03 불변`: PASS. 변경4개·Markdown blob3개·상대 링크7개·고정 SHA 링크9개·후보65행/고유63개·DI-02/03 원문 대조. 일회성 문서 감사 `audit_docs.py`의 출력은 `audit.json`에 보관.
- diff --check 및 정상 Commit 후 preflight: 제출 단계에 확인, 실제 결과는 PR에 연결.
- 필수 CI: 새 head에서 확인, PR #149 CI를 재사용하지 않는다.
- 새 게임 명세 변경 필요 확정 없음. RFC-DEV-027-01 OPEN, 실제 L2·제품 수용·구현 승인·main 병합 별도.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
