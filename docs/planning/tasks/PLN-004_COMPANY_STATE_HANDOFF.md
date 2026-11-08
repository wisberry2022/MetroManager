# PLN-004 — POST-MVP 회사 내부 상태값 후임 인계 작업

- **작성/담당:** Planning / 현행 후임 Game Designer (`AGT-PLN-0002` 역할 기준)
- **기준 main:** `98d56eb97f8a030912bea534ff1c330e9c40188e` (제출 시점 재확인 대상)
- **일자:** 2026-11-08 / 문서 버전 v1.0
- **상태:** `OWNER_DOCUMENT_PR_REQUESTED / REVIEW / SUCCESSION_HANDOFF_PREPARED`
- **개별 Owner 지시:** 현재까지 확정된 회사 내부 상태값 정의를 후임 에이전트가 확인할 수 있도록 **별도 PR 생성 요청** (2026-11-08 현재 Planning 대화).
- **범위:** 승인된 과거 Owner 결정의 문서화. 새로운 게임 규칙·점수·재무 거래/입찰 판정·이벤트를 승인하거나 구현하지 않음.
- **공식 본문:** [PLN-004_POST_MVP_COMPANY_STATE_V0_7.md](../PLN-004_POST_MVP_COMPANY_STATE_V0_7.md)
- **결과:** [PLN-004_RESULT.md](PLN-004_RESULT.md)

## 포함

1. 7개 상위/21개 하위 상태값의 Owner 승인 계층 및 자식 수·Depth 무제한 규칙.
2. 0~10·소수·정확한 수치 비공개·5.0 초기화/미관측 분리·향후 난이도별 초기값.
3. 평가형5/규모형2(B안), 기관 연계는 관계 규모이며 호감/우호와 구별.
4. 승인된 재정 3축·6개 말단 및 FIN-01~07 수치 기준선·평가식.
5. 미승인 산식/평가 데이터 예외·후속 작업과 현재 MVP 보존·부서 R&R 경계.
6. 변경 파일·검증/NOT_RUN·Owner 선택 근거의 문서화.

## 제외

- 현행 Gate 2 C/D/DATA 승인 파일의 수정·정책 변경.
- Stage 2 W04A/05/06·기존 재무/시간/입찰 원장 및 화면/테스트 수정.
- 신규 상태값의 실제 구현, 자동/GUI 테스트, 새로운 난이도·이벤트·평판/부채 시스템 구현.
- 다른 부서 문서/등록부/정책/CI/Git 훅/도구 수정.
- `main` 직접 Push·Merge·릴리스·배포; 후임 Planning 세대교체·Agent-ID 등록 자체(Infra/HQ/Owner 소관).

## 실제 제출 파일 (기획 경로 전용)

- `docs/planning/PLN-004_POST_MVP_COMPANY_STATE_V0_7.md`
- `docs/planning/tasks/PLN-004_COMPANY_STATE_HANDOFF.md`
- `docs/planning/tasks/PLN-004_RESULT.md`

브랜치 제안: `codex/PLN-004-post-mvp-company-states`; base=`main`. 하나의 동일 부모 커밋·문서만; PR 검수 후 Owner 결정 전 병합하지 않는다.

## 기획·부서 연계

| 담당 | 후속 역할 |
|---|---|
| Planning 후임 | 승인 문서 읽기/미결 세칙 구분, 서비스 수준부터 단계별 기획, 새 규칙만 Owner 상정 |
| HQ | POST-MVP 이월 및 실제 MVP 범위 침범 여부·PR 권한/인수 추적 |
| Development | 향후 실제 원천데이터/재현/이벤트 처리 기술 설계, 현재 Stage 2 임의 변경 금지 |
| Design | 정확한 내부 숫자 비공개 원칙을 지키는 정보 전달·화면 표현(추후 개별 승인 시) |
| INF | 향후 Planning 세대교체 Agent-ID/인수·권한 승계 여부 별도 절차 |
| Owner | 산식 기준 변경/후속 시스템 범위·main Merge·구현 착수 최종 승인 |

## 수용 기준

- 승인/제안/미승인/NOT_RUN을 항목별로 구별한다.
- FIN-01~06 산식과 0/5/10 기준, FIN-07 미완성 상태를 혼동하지 않는다.
- 현재 MVP의 C/R/F/K/A/B, 공개입찰 0~100 재무점수, 0~100 시민 만족도 독립 유지.
- 파일 경로가 기획 소관에 한정되고 정상 커밋/PR 및 원격 `policy`/`department-policy` 검사를 확인한다.
- 후임이 재승인 없이 읽고 후속 지표 기획에 착수할 수 있다. 공식 기능 구현/검증 PASS와는 구분한다.

## 후속 미결 사항

각 영역의 0/5/10 앵커, 실제 난이도 프리셋, 관측/평가기간의 예외, 사업별 기준 금액 M, 계층 리밸런싱/변경 이력, 이벤트·평판/신용 역방향 효과, 회사 종합점수 유무와 정식 명칭 정정은 후속 검토 항목이다.

기획 채팅 원문 공개 경로는 제공되지 않으며 Owner의 명시 결정이 이 문서의 근거다. 원문 전문이나 개인/비공개 링크를 Git에 게시하지 않는다.
