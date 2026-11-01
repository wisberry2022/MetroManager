# DEV-005 — 프로젝트 현황 분석 및 환경별 개발 협업 공간

- 담당: Development / 랩탑 Project Leader
- 작성일: 2026-11-01 (Asia/Seoul) / 제출 상태: REVIEW
- ID: 저장소·fetch 후 원격 추적 브랜치에서 DEV-005 미사용을 확인하여 이번 지시 추적용으로 부여. 타 환경의 미공유 예약 여부는 미확인.
- 착수 근거: 이번 채팅에서 Owner가 랩탑 개발 리더를 선정하고 아래 작업을 직접 지시함. 별도 HQ 티켓 승인·최종 검수 기록으로 확대하지 않음.

> 당신의 첫 임무는, 현재 디렉토리(MetroManager)의 소스코드와 docs 문서를 분석하여 현재 프로젝트가 어느 단계까지 와있는지 분석하는 것입니다.
>
> 환경별(데스크톱, 랩탑)로 개발 작업 시 서로의 작업 내용을 공유하고 인수인계할 수 있도록 docs 디렉토리 내부에 개발 전용 협업 공간을 마련해주었으면 합니다.

## 목적·선행조건·근거

Git의 승인 기록과 실제 파일을 대조하여 구현 착수 가능 여부와 인수인계의 기준을 명시한다. 기존 변경을 보존하고 필수 운영 규정·개발 README를 직접 읽는다.

- 조사 기준: `dc06e48b1dbc7745dcb0a29e424cd0416767ab38` (fetch 후 HEAD=origin/main).
- 운영: AGENTS.md, engineering의 CODE_CONVENTIONS/GIT_WORKFLOW/ENFORCEMENT/DEPARTMENT_WORKFLOW, HQ_OPERATING_RULES v0.1 DRAFT의 승인 원칙.
- 기획: A/B v0.3 Gate 1 OWNER_APPROVED, C v0.5-draft, D v0.8-draft, DATA v1.2-draft 및 Owner 결정 기록. Gate 2 최종 승인 아님.
- 작업 브랜치: `codex/DEV-005-environment-collaboration`.

## 범위·제외·산출물

포함: 읽기 조사, 개발부서 현황 보고, `docs/engineering/collaboration/` 공간·환경별 기록·인수인계 양식, 개발 README 진입 링크, 로컬 필수 검사 환경 준비와 검증 증거.

제외: 기획·디자인·HQ 산출물 수정, 게임 구현, 엔진·렌더러·CI·정책 코드 변경, Gate 2 재판정, 다른 채팅으로 메시지 발송, main 병합·릴리스·배포.

산출물과 검증은 [결과 보고](DEV-005_RESULT.md)에 기록한다. 최초 지시는 분석·문서 작성 범위였으며, 후속 지시로 아래 Git 제출이 승인됐다.

## 후속 Git 제출 승인 (2026-11-01)

이번 채팅 Owner 원문:

> 좋습니다. 현재 세션에서 변경한 파일을, 원격 저장소 푸쉬 규정을 준수하여 PR을 생성해주세요

- 대상: wisberry2022/MetroManager / DEV-005 / codex/DEV-005-environment-collaboration.
- 허용: 이번 세션의 개발 문서를 커밋하고 해당 작업 브랜치에 일반 push, base=main PR 생성·검사 확인. 전달받은 최신 검토 결과를 개발 현황·인계에 반영한다.
- 유효 범위: 이번 DEV-005 제출까지. 미래 작업의 포괄 위임 아님.
- 제외: main 직접 쓰기·병합·강제 push·릴리스·배포. 게임 정책·최종 Gate 승인 권한은 Owner에게 유지.

## 수용 기준

1. 승인 상태·기준 SHA와 실제 소스/씬 존재 여부를 구분한다.
2. Gate 2 잔여 조건, 과거 검토의 적용 범위와 근거 한계를 기록한다.
3. DESKTOP/LAPTOP 상태, 작업 담당·경로·인계/인수·검증을 재사용 가능한 문서로 제공한다.
4. 동시 수정과 미커밋 변경의 전달 한계, 권한 경계를 설명한다.
5. doctor/check 및 문서 검증 결과와 NOT_RUN 항목을 제출한다. Owner 검수 전 DONE 처리하지 않는다.
