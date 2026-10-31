# DEV-002: 코드 컨벤션과 Git 운영 검사

- 상태: REVIEW
- 담당: Development / Convention Team
- 승인자: Owner (착수 직접 지시), 최종 검수 대기
- 근거: 2026-10-31 Convention Team 채팅의 Owner 역할 부여 및 규칙·강제 프로세스 구축 지시. 기준 SHA `0705d144b75142859d22b4322150d756f797d6de`.
- 목적: Project Leader가 일관된 코드와 Git 흐름으로 작업하도록 규칙과 검사를 연결한다.
- 선행조건: 기존 저장소·승인·Godot 설정 조사 완료.
- 범위: 코드 규칙, Git 전략, AGENTS 연결, 로컬 훅, CI, PR/리뷰 규칙, 권한 위임 형식, 검증 및 원격 적용 사양.
- 제외: 게임 구현/명세 변경, 기존 이력 재작성, 실제 commit/push/merge/release, 포괄 권한 위임 생성.
- 산출물: docs/engineering 문서 3개, 검사 도구·테스트·훅·GitHub 설정 파일, RFC 및 결과 보고.

## 수용 기준

- AC-01: 기존 파일·Git/Godot 상태 보존.
- AC-02: 코드·브랜치·커밋·병합·위임 규칙과 근거 문서화.
- AC-03: AGENTS 진입점과 로컬 검사를 연결하고 정상/실패 사례 검증.
- AC-04: 원격 CI·보호 설정 준비, 실제 적용과 미적용을 구분.
- AC-05: 결과·검증·미해결 사항 보고. Owner 검수 전 DONE 금지.
