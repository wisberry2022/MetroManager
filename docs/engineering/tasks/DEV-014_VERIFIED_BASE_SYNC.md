# DEV-014 — ERR-002 Update branch 반복 오류 수정

- Convention Team / 2026-11-01 / REVIEW. 결과는 검수 요청이며 DONE 아님.
- 착수 승인자: Owner, 현재 채팅의 직접 오류 수정 요청. 원격 Git 동작은 별도 승인 확인.

> 해당 오류사항 파악하여 해당 에러 재현되지 않도록 수정 해주세요.
>
> 최초 보고된 에러와 동일한 오류입니다. PR 승인 이전, main이 업데이트되었을 경우 PR을 main에 merge할 수 없는데 이 때 update branch를 실행할 경우 머지 커밋으로 인해 CI가 실패하는 케이스입니다

## 기준·범위·권한

- 기준 main: `87342cd5c29a3047695c11bfd7f2b76415cdf4d8`. fetch·원격 main branch API·신규 리포트 원문·실패 로그 직접 확인.
- ID는 문서·원격 브랜치에서 DEV-014 미사용 확인 후 부여. 미공유 예약 UNKNOWN.
- 브랜치/worktree: `codex/DEV-014-verified-base-sync`, `.local/worktrees/DEV-014-verified-base-sync`. 기본 main checkout은 변경하지 않는다.
- 지침: AGENTS·개발 README·CODE_CONVENTIONS/GIT_WORKFLOW/ENFORCEMENT/DEPARTMENT_WORKFLOW·GOV-001 승인 원칙·RFC/DEC 양식·Godot 설정 확인. ERR-002는 관찰/RFC 근거이며 그 자체를 정책 변경 승인으로 취급하지 않음.
- 포함: trusted-base clean merge의 제한적 검증 예외 코드·회귀, 실제 실패 Git objects 재생, 같은 PR 갱신/충돌 복구 안내, 공통 현황표의 병렬 충돌 감소 규칙, 보고 후속·결과.
- 제외: merge 일반 허용·수동 충돌 자동 선택·공유 이력 재작성·strict/필수 CI 해제·게임 구현/명세·실제 PR 갱신/종료·force push·main 병합/릴리스·provenance 강제 적용.
- 결과는 [동기화/RFC](../VERIFIED_BASE_SYNC.md)와 [검수 보고](DEV-014_RESULT.md)에 기록한다. 구체 정책 예외·commit/push/PR·main 적용은 Owner 검수/해당 승인 범위에서 진행한다.

## 수용 기준

1. PR #52/#53 실제 head와 당시 base의 기존 거부 및 후보의 clean-tree 검증 통과를 확인한다.
2. 5개 부서 정상 갱신이 양쪽 CI 진입점·preflight·pre-push를 통과하며 같은 브랜치·기존 커밋을 보존한다.
3. 외부/역방향/다중 부모·추가 수정·실제 충돌·부서/과거 위반·symlink·검증 불가는 거부한다. 외부 merge driver 없이 원본 refs/index를 보존한다.
4. 두 필수 job·base-only 신뢰 경계·strict·main squash를 유지한다. 실제 원격 동기화 시험은 정책 반영 후 별도 승인 단계로 구분한다.
5. 현황표의 과거 기록을 보존하며 병렬 티켓의 기본 편집 대상에서 제외하고 개별 티켓/결과를 정본으로 안내한다.
6. 변경 파일·명령·증거·실행/NOT_RUN·미해결·명세 변경 필요 여부를 보고하고 로컬 검증을 공식 승인/DONE으로 표시하지 않는다.

## 후속 Owner 승인 — 2026-11-01

> 컨벤션 팀. DEV-014의 검증된 무충돌 base-sync 예외와 상태 관리 개선안을 승인합니다. 기존 Git 규정을 준수하여 커밋·푸시하고 PR 생성해주세요. main 병합은 별도 승인 후 진행해주세요.

대상·브랜치·허용 동작·기간·금지 사항은 [DEC-DEV-014-01](../VERIFIED_BASE_SYNC.md#dec-dev-014-01--owner-정책제출-승인-기록)에 기록했다. 정책안과 commit/push/PR은 승인되었으며 main 병합·운영 적용은 미승인/대기다.
