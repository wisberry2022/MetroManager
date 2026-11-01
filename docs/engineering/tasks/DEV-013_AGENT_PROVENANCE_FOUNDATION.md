# DEV-013 — INF-002 Agent Identity 구현 계획·독립 검증기 착수

- 담당: Convention Team / LAPTOP / 2026-11-01 / 상태: REVIEW, 공식 승인·DONE 아님.
- 착수 승인자·근거: Owner의 현재 채팅 요청. 첨부 INF 문서와 후속 INF 회신은 정책 제안으로 구분.

> 첨부 요청서의 배경·의의, 상세 데이터 모델, 기록·검증 로직, 구현 범위, 수용 기준을 검토하여 Convention Team 소관으로 구현 계획을 수립해 주세요.
>
> worktree 활용하여 해당 작업 진행 시 이슈가 있는지 확인 후 구현 작업 착수해주세요.

- Git 권한에 관한 Owner 원문: “본 요청은 구현 착수를 위한 업무 요청이며, 원격 Commit/Push/PR 또는 main 병합에 필요한 개별 승인 절차를 생략하는 것은 아닙니다.”
- 정책 미승인 시 독립 시제품까지 진행한다는 질의에 INF 정책 제안 회신을 수신. 실제 ID와 enforce 시점은 미정이며 OWNER_APPROVAL_REQUIRED를 유지.

## 기준·선행조건·범위

- 최초 main/worktree base: `5c91d56c78c2de5bd94bea7ee66b5c86181f4cb8`. INF 회신 후 최신 조사 main `88496d0c3bcef8d59e76c9977ee6ff07d01339fe`, 관련 AGENTS/engineering 규정·tools/CI/INF의 두 SHA 차이 없음 확인.
- 브랜치/worktree: `codex/DEV-013-agent-provenance-foundation`, `.local/worktrees/DEV-013-agent-provenance-foundation`.
- ID는 현 문서·원격 브랜치에서 DEV-013 미사용 확인 후 부여. DEV-011/012는 Project Leader B 작업이므로 보존, 미공유 ID 예약 UNKNOWN.
- 적용 지침: AGENTS, CODE_CONVENTIONS, GIT_WORKFLOW, ENFORCEMENT, DEPARTMENT_WORKFLOW, 개발 README, GOV-001 승인 원칙, RFC/DEC 양식, project.godot 및 INF 등록/인계 템플릿 직접 확인.
- 포함: R&R·기존 CI 차이·단계 계획·AC 매핑·결정 RFC, base registry/Commit·PR 선언/각 커밋 Manifest를 읽기 대조하는 draft REPORT_ONLY 시제품·synthetic fixture 테스트, 검증 결과.
- 제외: 실제 Agent ID 발급·INF registry 수정, 승인 전 정책 확정, 훅/기존 검사기/CI 연결·강제 적용, 게임 코드/기획/디자인·공통 작업 현황표, 공유 config 변경, commit/push/PR/main 병합·배포.
- 영향: L2(향후 공통 인터페이스), 운영 강제/권한·예외 확정은 Owner 정책 검수 필요. 게임 명세 변경 없음.

## 수용 기준·산출물

1. B의 브랜치·미커밋·worktree를 확인하고 전용 경로에서 진행하며 공유 설정/기존 작업을 보존한다.
2. INF의 등록/세대 권한과 Convention 검사기 권한을 구분한다. INF 회신을 승인된 실제 ID로 오인하지 않는다.
3. 6항 회신 구조와 AC-ID-01~12의 구현/검증/미실행·의존성을 [계획](../provenance/DEV-013_IMPLEMENTATION_PLAN.md)에 명시한다.
4. [RFC](../provenance/RFC-DEV-013-01_POLICY_DECISIONS.md)에 미정 스키마·legacy/retired·squash·전환·보존·한도를 질문/대안/영향과 함께 정리한다.
5. 독립 검증기는 base 등록부·실제 Git Blob·부서 경계를 대조하고 synthetic ID만 시험한다. REPORT_ONLY 출력은 실신원 인증이나 enforce PASS가 아니다.
6. 변경 파일·명령·증거·미해결·NOT_RUN을 [결과](DEV-013_RESULT.md)에 기록하고 실제 원격 제출/강제는 수행하지 않는다.

## 후속 Git 제출 승인 (2026-11-01)

- 승인자: Owner / 원문 위치: 현재 Convention Team 채팅의 DEV-013 검수 보고 후.

> 컨벤션팀. DEV-013 구현 계획·RFC·독립 검증기 시제품을 기존 Git 규정을 준수하여 커밋·푸시하고 PR 생성해주세요.

- 대상: `wisberry2022/MetroManager`, DEV-013의 위 신규 파일 7개, `codex/DEV-013-agent-provenance-foundation`.
- 허용: 이번 계획·RFC·독립 REPORT_ONLY 시제품의 commit·작업 브랜치 일반 push·base=main PR 생성/수정·필수 CI 확인. 이번 제출·검사 확인까지 유효, Owner 후속 철회 시 중단.
- 금지: 실제 ID 발급·INF 등록부 수정·ENFORCE/새 필수 CI 활성화, main 직접 쓰기·병합·force push·릴리스. 정책 제안의 최종 채택 승인과 구분한다.
- 제출 준비: 미공유·자체 커밋이 없는 전용 브랜치만 당시 최신 main `f5d2878e26b9c1c061998c4ff7161f850682f568` 기준으로 갱신하고 신규 파일을 보존했다. 공유 브랜치 이력 재작성·main merge commit 없음.
