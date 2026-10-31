# PM-005 — MetroManager Gate 2 HQ/PM 2차 검토

- 담당: HQ / PM. 상태: REVIEW. 작성일: 2026-10-31 (Asia/Seoul).
- 목적: PM-004 1차 의견의 개정본 반영, 범위·의존성·견적·게이트 판단 및 PR 제출.
- 승인자: Owner. 현재 Codex 채팅의 직접 요청을 근거로 착수/commit/작업 브랜치 업로드/PR 생성 허용.
- 승인 원문: “Owner가 쓰기 및 PR 생성 승인. 변경은 HQ 기본 경로 docs/hq/ 내부 보고서에 한정” 및 “보고서를 작성해 커밋, 브랜치 업로드, PR 생성 후 URL, 커밋 SHA, 검증 항목과 미실행 항목을 보고하세요.”
- 승인 원문 위치: 현재 채팅의 “Continuing from HQ(PM)” 사용자 요청(2026-10-31). 선행 대화: chatgpt-conversation://6ae545e7-5c98-83e8-86fd-15b5854397b2.
- 저장소: https://github.com/wisberry2022/MetroManager
- 기준/분기 main: e18b047848108383acdcef47250ee81393df2058. 작업 시작 시 최신 SHA와 동일.
- 브랜치: codex/PM-005-gate2-second-review. 같은 이름 및 PM-005 원격 브랜치 없음 확인 후 생성.
- 유효 범위/종료: 이번 검토 보고서와 티켓의 commit·작업 브랜치 업로드·PR 생성·검사 확인까지. 향후 작업에 대한 포괄 위임 아님.
- 금지: main 직접 변경, 병합/자동 병합/강제 push/릴리스, 타 부서·소스·CI·정책 변경.
- 선행 근거: PLN-001-C v0.2-draft, D v0.5-draft, Gate 2 결과 보고; A/B v0.3 및 Owner QD/P·Gate 1 승인. 모두 위 SHA에서 읽음.
- 1차 회신: PM-004의 전달용 PLN-001_GATE2_HQ_REVIEW.md. 원문 접근/동일성 한계와 해시는 결과 보고 §1.
- 적용 규정: AGENTS.md, DEPARTMENT_WORKFLOW.md, GIT_WORKFLOW.md, ENFORCEMENT.md, CODE_CONVENTIONS.md, docs/hq/README.md 직접 조회. HQ_OPERATING_RULES는 DRAFT 상태를 함께 확인.
- 포함: ID별 반영 판정, 미해결 문제/개선/영향, 선행 승인·8영역 보존, 규모 변화, HQ 게이트·인수인계·일정 조정, 다음 조치.
- 제외: 게임 규칙 채택, 기술/디자인 전문 타당성 승인, 구현, 타 부서 작업 지시 발송, 최종 Gate 2·DONE 처리.
- 산출물: 본 티켓 및 [PM-005_RESULT.md](PM-005_RESULT.md).

## 수용 기준

- G2-Q01~08, BLOCK-G2-01~07 및 선행 HQ 요청 모두 근거 위치와 상태로 추적한다.
- 문서 반영 완료와 정책 승인·부서 재검수·실제 구현 검증을 분리한다.
- 최종 OK/CONDITIONAL/BLOCKED 중 하나와 승인 상정 여부, 책임자/선행조건/해소 증거를 제시한다.
- 변경은 위 HQ 2개 문서만, 올바른 제목/본문/브랜치로 PR 제출 후 policy·department-policy 확인.
- PR/CI 통과는 Owner 병합 승인이나 프로젝트 DONE이 아니다.
