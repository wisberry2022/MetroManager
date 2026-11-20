# PLN-013 — W04B 승인 의미·정적 경계 준비

- 담당: Planning 추적 / AGT-PLN-0003.
- 작성일: 2026-11-21 / Asia/Seoul.
- 상태: OWNER_STATIC_DELIVERABLE_APPROVED / COMMIT_PUSH_PR_AUTHORIZED / MAIN_MERGE_APPROVAL_PENDING.
- 기준 main: `a72daa410670e60463becca73e69e474221ee605` (PM-020 PR #145 병합).
- 로컬 작업 브랜치: `codex/PLN-013-w04b-static-contract`.
- 주 산출물: [승인 규칙·반례·AC/VP/S3 대응표](../PLN-013_W04B_RULES_AND_BOUNDARIES.md).
- 결과: [PLN-013_RESULT.md](PLN-013_RESULT.md).

§1~4는 최초 정적 준비 시점의 요청·범위·검증 계획이다. 후속 Git 제출 권한은 §5의 Owner 승인으로 갱신한다.

## 1. Owner 요청·작업 범위

현재 Planning 추적 대화에서 Owner가 다음과 같이 지시했다.

> 기획 에이전트 1~2번 정적 준비 진행해주세요

직전 제안의 1번은 C v0.7·D v0.9·DATA v1.4의 W04B 규칙과 AC-04/05·VP-01·S3를 연결하는 작업, 2번은 정상·경계 기대값을 정리하는 작업이다. 이번 지시를 그 두 작업의 로컬 문서 작성·정적 검증 승인으로 적용한다. [PM-020 Planning 요청서](../../hq/requests/PM-020_PLANNING_STAGE3.md)의 첫 준비 산출물을 구체화한다.

새 게임 정책 확정, 기존 C/D/DATA 개정, 실제 DEV 공급 수용, 엔진/GUI 구현·인수, 다른 부서에 메시지나 Issue 댓글 전송, Commit·Push·PR·main 병합은 이번 범위에 포함하지 않는다. 이전 PLN-005 Git 승인을 재사용하지 않는다. 이번 로컬 결과 제출 뒤의 후속 동작은 해당 유효 승인 범위를 확인한다.

PLN-013은 원격 main 트리·21개 원격 브랜치·정확한 제목 검색과 로컬 전체 참조 로그에서 기존 작업이 발견되지 않아 이번 기획 작업 ID로 선정했다. 새 Agent-ID를 발급하지 않았다. 원격 검색의 일반 문자열 결과는 다른 작업 본문을 반환해 번호 충돌 증거로 사용하지 않았으며, 정확한 제목 검색과 실제 트리/참조를 대조했다.

## 2. 포함 산출물

1. `docs/planning/PLN-013_W04B_RULES_AND_BOUNDARIES.md`: 승인 정본·30개 정적 행·DEV/Design 소비·AC/VP/S3·공급 확인 항목을 한 대응표로 연결한다.
2. 본 티켓: 이번 요청과 담당·기준 SHA·허용 범위·검증 경계를 기록한다.
3. `docs/planning/tasks/PLN-013_RESULT.md`: 실제 정적 검산·문서 검사와 NOT_RUN, 후속 입력을 기록한다.

공유 checkout의 브랜치와 기존 데이터2개 변경을 보존하기 위해 최신 원격 SHA의 별도 로컬 사본에서 작성한다. 변경 산출물은 위 기획3개 경로다. 원격 문서·제품 DATA·코드·테스트·HQ/Design/DEV/INF 산출물은 수정하지 않는다. 로컬 검증 로그·일회성 감사 도구는 사본의 무시 경로 `.local/validation/PLN-013/`에만 둔다.

## 3. 판정·완료 조건

- 승인 원문 → 현재 C/D/DATA → PM-020의 추적 기준 순으로 해석한다. D v0.9의 C v0.6/DATA v1.3 연결 표는 당시 이력이며 최신 C v0.7/DATA v1.4와 PLN-005를 사용한다.
- 시청/정부 분기·설득/감액·심사 시간·동일성/revision·E01·RNG·공통 자금/후속 경로의 기대값과 근거가 대응돼야 한다.
- 기존 승인으로 해결되는 행은 `기존 규칙 적용`, 실제 공급 확인이 필요한 사항은 `DEV_INPUT_PENDING`으로 구분한다. 공급 미수신 자체를 Owner 정책 미결이나 제품 결함으로 확정하지 않는다.
- 문서·산술 검산 PASS는 엔진 자동·실제 GUI·독립 Design·VS-02·Stage 수용 PASS가 아니다. 30행은 추적용 색인이며 신규 GUI30회 의무가 아니다.
- 실제 충돌이 확인될 때만 [RFC 양식](../../templates/RFC_AND_DECISION.md)에 근거·기대/실제·영향·대안·Owner 필요 여부를 기록한다. 현재 기획 정책 변경 요청은 없다.

이번 완료 조건은 정적 준비 결과의 Owner 검토 제출이다. Stage 2 DONE은 유지하고 Stage 3 실행/최종 인수를 선언하지 않는다. DEV-026은 Stage 3 필수 범위지만 이번 작업에서는 그 제품 계약/구현 수용을 진행하지 않는다. POST-MVP 회사 상태값은 별도 전담 작업으로 유지한다.

## 4. 검증 계획

- 최신 remote main/관련 PR·원문·파일 blob과 별도 사본 HEAD를 대조.
- 정상 경로의 역 수·고유성·간선, 시청 −1/0/+1, 70/20/10·60/40, floor 감액, 시간/자금·보고 예시를 표준 Python의 정수·유리수로 정적 검산.
- 30개 행의 고유 ID·근거/AC/VP/S3 연결·표 구조·링크·UTF-8/LF·기획3개 변경·원본 보존 확인.
- `tools/policy.py doctor`, `tools/policy.py check`, `git diff --check`. 실제 결과는 결과서에 기록한다.
- 게임 자동·Godot 로드·실제 GUI/플레이·빌드·성능: NOT_RUN. 미커밋 상태이므로 제출 preflight·원격 CI도 NOT_RUN.

## 5. Owner 산출물·Git 제출 승인 — 2026-11-21

승인 원문 위치: 현재 Planning 추적 대화의 PLN-013 산출물 검토 후 Owner 메시지.

> 좋습니다. PLN-013 정적 준비 산출물을 승인합니다. 최신 원격 main과 변경 여부를 다시 확인한 뒤 커밋·푸시·PR을 생성해주세요. main 병합은 별도 승인하겠습니다.

- 대상 저장소: `wisberry2022/MetroManager`.
- 담당: Planning 추적 `AGT-PLN-0003` / 작업 `PLN-013`.
- 제출 브랜치: `codex/PLN-013-w04b-static-contract`; PR base는 `main`.
- 승인 산출물 기준 main: `a72daa410670e60463becca73e69e474221ee605`. 제출 직전 최신 원격 main·작업 브랜치·경로·부모를 다시 확인한다.
- 허용 경로: §2의 기획 문서3개. 승인 본문을 보존하고 이번 승인·제출·검증 기록만 추가한다.
- 허용 동작: 승인 산출물 Commit·Push·PR 생성과 해당 제출의 필수 검증·결과 기록. 다른 작업의 과거 권한을 재사용하지 않는다.
- 적용 범위·기간: 이 PLN-013 제출 요청을 완료할 때까지의 해당 제출 건. 후속 새 작업에 포괄 권한을 부여하지 않는다.
- 제외: main 직접 수정·병합, 강제 푸시, 릴리스/배포, 신규 게임 정책 확정, 타 부서 파일·제품 코드·DATA 변경, Issue 댓글·타 채팅 메시지 전송.

이번 승인은 정적 준비 산출물의 승인이다. 실제 DEV 공급·게임 자동/GUI·Design·VS-02·Stage 3 수용의 PASS 또는 DONE을 뜻하지 않는다. main 병합은 Owner 별도 승인 대기다.
