# PM-007 — 산출물 제출 및 검증 보고

- 작업: PM-007 / HQ
- 날짜: 2026-11-01
- 상태: REVIEW — Owner의 문서 검토 및 PR 병합 승인 대기
- 기준 main: `5b507fa767982531fde4dad8b0c1210eab9733a7`
- 브랜치: `codex/PM-007-agent-quality-planning`
- 제출 내용: [운영 기준 초안](../PM-007.md), [작업 티켓](PM-007_AGENT_QUALITY_MANAGEMENT.md), 본 결과 보고.
- 원격 PR/커밋/CI: PR 및 GitHub Actions 기록을 **실제 생성·확인 후** PR 메타데이터와 HQ 완료 보고로 전달. 본 문서 작성 시점에는 결과를 추정해 기재하지 않음.

## 문서 검증
- 작업 범위: `docs/hq/` 내 신규 문서만 제안, 기존 문서·게임 소스는 변경 없음.
- 문서 ID/파일명: PM-007 일치, 결과 파일은 기존 HQ 결과 접미사 규약을 사용.
- 승인 기준: Gate 2 Owner 승인본, GOV-001/PM-001의 R&R, 최신 Git 부서 규칙 참조.
- 문서 검토: 기획/디자인/개발 품질 관점과 세부 소관의 분리, 단계/주차/AC/증거 규칙 정합성 확인.
- 로컬 Git 훅 / `policy.py doctor/check`: NOT_RUN (GitHub API 기반 작업).
- Godot 프로젝트 로드/자동 게임 테스트/플레이/Windows 빌드/성능·사용성 테스트: NOT_RUN (운영 문서 작업).
- Owner의 문서 정식 승인 / 타 세션 전달 완료 / main Merge: NOT_RUN (별도 단계).

## 후속
1. GitHub PR의 `policy` 및 `department-policy` 최신 결과를 확인하고 Owner에 보고한다.
2. Owner가 문서 내용 및 main 병합을 승인한 이후 별도 Merge 절차를 따른다.
3. 병합 후 각 부서 채팅에 공식 문서 경로·기준 SHA와 승인 범위를 전달하고 숙지 확인을 받는다.
4. Gate 3 실제 작업 분해는 담당 개발/디자인/기획이 제안하며 HQ가 의존성·주차 목표를 통합한다.
