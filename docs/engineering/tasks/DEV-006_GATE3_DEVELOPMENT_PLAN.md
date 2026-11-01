# DEV-006 — Gate 3-0 개발 작업 분해·첫 Slice·검수 계획

- 담당: Development / LAPTOP Project Leader / 2026-11-01 / 상태: REVIEW (Owner/HQ 검수 요청)
- 근거: Owner의 이번 채팅 “HQ로부터 Gate3 작업 착수를 진행할 것을 요청받았습니다. 원격 저장소 확인하여 Gate3에 대한 업무를 진행해주세요.” 및 프로세스 변경 문서 확인 지시.
- HQ 요청: [PM-008-DEV](../../hq/requests/PM-008-DEV.md), REQUEST_DRAFT의 Gate 3-0 분석을 이번 Owner 지시로 착수. 게임 구현 지시로 확대하지 않는다.
- 기준 SHA: `ca597ec541647aa2e9701ec93972e8763eae066d` / 원격 main 직접 확인·fetch. 시작 로컬 main clean, 1 worktree.
- 브랜치: `codex/DEV-006-gate3-development-plan`.
- 승인 명세: C v0.6 / D v0.9 / DATA v1.3 / 최종 Gate 2 승인 v1.0, 모두 위 SHA의 승인 상태 확인.
- 운영: PM-008 v0.1의 승인 8원칙·A안, PM-007 품질 기준, AGENTS 및 개발 공통 규정. INF는 별도 소관이며 게임 Stage를 결정하지 않는다.
- 영향 등급: **L2 제안**. Design에 공급할 의미 데이터 계약을 포함한다. 후속 시간/원장 구현은 L3 검토 대상이며 이 분석 문서가 구현 승인은 아니다.
- Issue: [DEV-006 #25](https://github.com/wisberry2022/MetroManager/issues/25), REVIEW 추적. Issue 생성은 Git 쓰기 권한 위임이 아니다.

## 목표·범위·권한

승인된 11 MUST·AC-01~10·VP-01/02를 검증 가능한 Godot 작업으로 분해하고, 첫 플레이 가능한 Slice와 외부 계약·회귀 계획을 제안한다. 기획의 전체 분석 완료를 기다리지 않고 개발 소관 분석을 진행한다.

포함: 현 소스/엔진 실측, 기술 작업·의존성·완료 조건·검증 환경·병렬 가능성·통합 위험·등급, UI 의미 계약 초안, 다음 Stage 우선 과제. 최소 티켓과 Issue를 함께 유지한다.

제외: 게임 코드/씬/설정·CI·공통 정책 변경, 타 부서 원문 수정, 새 게임 규칙·성능 목표 확정, 전체 MVP 구현, 사용자 저장·차입·플레이어 공사 취소·정산 토글·연체 제재, 인일 기반 납기 확약.

최초 착수 지시는 분석·개발 문서 작성과 작업 추적의 근거였으며, 아래 후속 Owner 지시로 이번 DEV-006 Git 제출이 승인됐다. main 병합·릴리스는 제외한다.

## 후속 원격 제출 승인

- Owner 원문(이번 채팅, 2026-11-01): “개발 에이전트. 로컬 변경 사항을 푸쉬 규칙을 준수하여 PR 생성해주세요”
- 대상: wisberry2022/MetroManager / DEV-006 / codex/DEV-006-gate3-development-plan / docs/engineering/의 이 작업 문서 5개.
- 허용: 검증 후 commit, 작업 브랜치 원격 공유, base=main PR 생성·CI 확인 및 Issue #25 연결. 이번 제출까지 유효.
- 제외: main 직접 쓰기·병합·강제 push·릴리스·게임 구현·타 부서 원문 수정.
- 제출: 이전 Git HTTPS 인증 실패가 확인되어 저장소 규정의 GitHub API 절차를 사용한다. 기존 base tree 보존·단일 부모 커밋·새 작업 브랜치, 로컬 검증 트리와 동일성 확인. 정확한 원격 head/PR/CI는 PR 본문에 기록한다.

## 산출물·수용 기준

- [개발 계획](../gate3/DEV-006_DEVELOPMENT_PLAN.md): 11 MUST·10 AC·2 VP 누락 없이 작업/검증에 연결, 단계별 통합과 첫 Slice 종료 조건, 우선순위·차단 시점 제시.
- [UI 의미 계약 초안](../gate3/DEV-006_UI_DATA_CONTRACT.md): 값·단위·시점·버전·원인/허용 행동, 현재/과거·예상/실적·자료없음/0 구분, Design/Planning 확인 범위 명시.
- [결과](DEV-006_RESULT.md): 변경 경로·실측·정적 검사·Godot 로드/자동/플레이/빌드 구분·NOT_RUN·미해결.
- 기존 [작업 현황](../collaboration/WORK_STATUS.md)에 DEV-006 담당/로컬 상태 등록. 데스크톱의 미공유 작업을 추정하지 않는다.

수용 기준은 분석 산출물의 완결성이다. 후속 구현 티켓은 아직 발급/승인하지 않고 아래 WBS 하위 ID로만 제안한다. 검수·Issue 등록·검사 통과를 DONE 또는 Gate 3 실행 승인으로 표시하지 않는다.
