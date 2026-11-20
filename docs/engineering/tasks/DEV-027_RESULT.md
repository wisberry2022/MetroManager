# DEV-027 — 이슈 철회·착수 계획 문서 PR 전환 결과

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

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027
