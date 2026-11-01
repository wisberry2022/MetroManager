# INF 등록·초기 게시 및 원격 검증

- DEV-007 / Convention Team / 2026-11-01 / REVIEW.
- 기준: main `06d6a28071c037d6b4ef9a745032ba650e985c57`, Owner의 현재 등록 구현 요청.
- 아래 README는 INF가 초기 게시할 준비 원본이다. 아직 `docs/infra/README.md`가 게시되거나 INF에 Git 권한이 위임된 것으로 표시하지 않는다.

## 적용 순서

1. Owner가 DEV-007의 구체적인 변경·검증을 검수하고 commit/push/PR 제출 범위를 승인한다. DEV 작업 브랜치의 PR에서 기존 `policy`·`department-policy`를 확인한다. main 병합은 Owner 별도 승인 후 squash로 수행한다.
2. INF는 등록이 반영된 실제 main SHA를 확보하고 AGENTS.md·DEPARTMENT_WORKFLOW·본 문서의 초기 README 원본을 직접 읽는다. API 사용 시 branch를 항상 지정한다. 로컬 사용 시 해당 PC의 `.venv`·훅·doctor를 확인한다.
3. INF의 후속 작업은 Owner가 승인한 별도 티켓에서 수행한다. `INF-001`은 예시이며 원격의 기존 번호·브랜치와 대조 후 확정한다. 티켓에 승인 원문 위치·일시, 저장소, 작업·경로·브랜치, commit/push/PR 각각의 허용 여부, 기간·종료 조건·금지 사항·검증·철회 방식을 남긴다.
4. 등록 후 main 기반 `codex/INF-NNN-description`을 만들고 `docs/infra/tasks/INF-NNN_TITLE.md` 및 아래 README를 `docs/infra/README.md`에 함께 게시한다. 커밋 제목 `[INF][docs] INF-NNN 인프라 작업 진입점을 등록합니다` 뒤 빈 줄과 효과·검증 본문을 쓴다. 승인 범위에서 일반 push와 base=main PR을 제출한다.
5. 실제 head SHA에서 `policy`·`department-policy` 성공, 승인 티켓·경로 일치와 현재 main 보호 설정을 확인한다. 이때 정상 INF PR의 원격 검증이 완료된다. main 직접 쓰기 시험이나 보호 해제는 하지 않는다. 실패하면 원인을 수정하거나 RFC로 보고한다.
6. INF PR도 Owner main 병합 승인·squash 절차를 따른다. GitHub 플러그인 API는 로컬 훅을 실행하지 않으며 같은 계정의 부서 신원을 기술적으로 분리하지 못한다. CODEOWNERS는 경로 쓰기 ACL이 아니다.

DEV가 초기 INF README까지 같은 PR에 넣으면 기존 base 검사기가 타 부서 경로로 거부한다. DEV의 허용 경로 확대나 자기 브랜치 예외 추가 대신 위 순서를 적용한다. 기존 두 CI 워크플로와 보호 설정을 유지한다.

## `docs/infra/README.md` 초기 게시 원본

```markdown
# 인프라 산출물

INF는 컨텍스트 건전성·세션 연속성·후임 인계 정책과 검증을 담당합니다.
장기 진단·인계 정책의 공식 소유 원본은 docs/infra/에 둡니다.
게임 규칙·디자인·개발 코드·HQ 일정/Stage 결정은 해당 부서 소관입니다.

- 시작 시 main의 AGENTS.md, docs/engineering/DEPARTMENT_WORKFLOW.md와 이 README를 직접 읽습니다.
- 티켓: docs/infra/tasks/INF-NNN_TITLE.md, 결과: 같은 경로의 INF-NNN_RESULT.md.
- 브랜치: codex/INF-NNN-description. main 직접 쓰기·force push·공유 이력 재작성은 금지합니다.
- 제목: [INF][docs] INF-NNN 작업 내용. 100자 이하, 빈 줄 뒤 효과·검증 본문을 작성합니다.
- Owner가 승인한 개별 티켓의 경로·기간·동작 범위에서만 commit/push/PR을 수행합니다.
- API 쓰기 도구에 branch를 명시하고 최신 head·파일 SHA를 대조합니다.
- main 기반 PR의 policy·department-policy 성공을 확인합니다. 병합·릴리스는 Owner 별도 승인 대상입니다.
- 타 부서 산출물·공통 정책·CI·게임 소스를 수정하지 않습니다.
- 공개 Git에는 최소 진단 상태·근거만 둡니다. 내부 대화 원문·상세 세션 평가는 Owner 제한 보관합니다.
- 결과에 작업 ID, 변경 파일, 검증 명령·증거, 미해결 사항과 명세 변경 필요 여부를 기록합니다.
- 자동 테스트·프로젝트 로드·게임 플레이·빌드를 구분하고 미실행은 NOT_RUN입니다.
- 모호한 명세·범위 충돌은 docs/templates/RFC_AND_DECISION.md 양식으로 보고합니다.

기존 HQ ZIP의 관련 초안은 출처·버전·승인 상태를 확인한 뒤 INF 정책과 대조합니다.
타 부서 문서를 임의 이동·삭제하거나 미승인 초안을 공식 정책으로 승격하지 않습니다.
```

## RFC-DEV-007-01 — 기존 HQ ZIP과 INF 정책 원본 대조

- 상태: OPEN / 요청: Convention Team / 응답 책임: INF·HQ, 필요 시 Owner.
- 연관 작업: DEV-007 / 근거: Owner 제공 등록 요청의 완료 조건.
- 현황: 현재 추적 파일에 INF 장기 진단·세션 연속성 정책이나 해당 HQ 초기 ZIP을 식별할 경로·버전·SHA가 없다. 기존 개발 환경 인계 문서는 별도 소관이다.
- 질문: HQ는 해당 초안의 위치·버전·승인 상태를 제공하고, INF는 후속 승인 티켓에서 항목별 유지/대체/중복 목록과 정본 링크를 제안해 주기 바람.
- 영향: Git 검사 등록과 독립적인 후속 문서 정합성 작업. 일정은 원본 확보 후 산정, 게임·세이브·테스트 동작 영향 없음.
- Owner 결정 필요: 기존 소유권 충돌이나 타 부서 문서 변경이 필요한 경우. 현재는 문서 삭제·이전·진단 정책 확정을 하지 않는다.
- 반영 대상: 후속 INF 정책/티켓, 필요 시 HQ의 자기 소관 정합성 수정. 답변·HQ 조정·최종 결론: PENDING.
