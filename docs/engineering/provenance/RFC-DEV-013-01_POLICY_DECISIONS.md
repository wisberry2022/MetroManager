# RFC-DEV-013-01 — Agent Identity·Provenance 도입 결정 요청

- 상태: OPEN / 2026-11-01 / 요청: Convention Team / 연관: DEV-013, INF-002.
- 응답 책임: INF(식별/등록/세대), Owner(정식 채택·활성화·Git/강제), HQ/PM(전환·Stage 영향).
- 근거: Owner의 현재 분석/계획·worktree 구현 착수 요청, INF-002 v1.0, 현재 채팅으로 전달된 INF 정책 제안 회신.
- 최신 조사 기준 main: `88496d0c3bcef8d59e76c9977ee6ff07d01339fe`. 요청서/INF 회신은 제안 상태이며 실제 registry와 ACTIVE ID·enforce SHA는 아직 없다.

## 현황·기술 판단과 질문

| ID | 질문·권고 | 결정/응답 책임 | 현재 |
| --- | --- | --- | --- |
| Q01 | ID 4자리 형식, 비재사용 시퀀스, 독립 Convention/Leader별 ID, 임시 Subagent 감독 귀속안을 채택하는가? 9999 이후 개정 방식도 별도 관리 | INF 제안·Owner 채택 | INF 권고 수신, Owner 미승인 |
| Q02 | registry 정본 경로·필수 필드·record_version/event 이력, ACTIVE/RETIRED 시각 null 규칙, predecessor/parallel role 관계를 확정해 달라. 건강 상태는 분리 | INF+Convention 기술 협의·Owner | 경로 후보·core 필드 수신, 전체 계약 PENDING |
| Q03 | 실제 최초 담당 ID·활성/은퇴·공개 승인/인계 근거와 registry 초기 PR의 base SHA를 제공해 달라. 실제 발급은 INF 소관 | INF 작성·PM 전환·Owner 활성화 | ACTIVE_IDS_NOT_REGISTERED |
| Q04 | Trailer 최종 footer의 단일 Agent-ID/Task-ID·중복 없는 contributor, PR 동일 footer, 부서별 고정 Manifest 위치를 채택하는가? 기존 제목 유지 | Convention 권고·INF 검토·Owner | 후보 시제품만 |
| Q05 | 커밋별 누적 Manifest snapshot·정확한 한 Manifest만 자기해시 면제·explicit rename D/A·old/new blob을 채택하는가? 필수 source_refs/생성 도구/created_by/modified_by/UNKNOWN·검토자 증거 범위도 결정 | Convention+INF·Owner | core 검증 시제품, 이력/승인 의미 PENDING |
| Q06 | legacy 예외를 base 정책의 PR번호+정확 head SHA+task+승인 ref로 고정하고 head 변경 시 무효화하는 안을 채택하는가? RETIRED 역사 기여 필드와 진행 PR별 재제출/예외 기준 | INF 권고·Owner·PM | 비소급·명시 예외 INF 권고 수신, 목록/시행 SHA 미정 |
| Q07 | 독립 base-only agent-provenance job·report-only 시범 후 fail-closed enforce를 채택하는가? 새 필수 검사 명칭·전환 commit SHA·대상 PR·rollback 결정권 | Convention 권고·Owner·HQ | 기존 CI 변경 없음 |
| Q08 | squash 최종 메시지의 Agent-ID/Task-ID/Manifest/Provenance-Head 보존, expected head guard helper와 병합 후 감사 중 어느 수준을 적용할 것인가? 수동 관리자 편집의 완전 차단은 못함 | Owner·Convention | 실제 병합 시범 NOT_RUN |
| Q09 | squash/브랜치 정리 후 중간 blob/commit 근거의 보관을 PR refs로 한정할지, 별도 승인 감사 bundle/이벤트 원장을 둘지 결정 | INF 보존정책·Owner·Convention | 영구 도달성 보장 없음 |
| Q10 | JSON 후보 한도(1MiB/등록1000/파일5000/깊이32), 전체 PR/커밋 수 한도·시간 예산·허용 메타데이터·제3자 에셋 라이선스 참조를 확정 | Convention 기술 검증·INF 공개정보·Owner | core 제한 시제품, 운영 부하 미측정 |

## 영향도와 독립 착수 범위

- 일정: Phase A 실제 등록·정책 결정이 없으면 시범/강제 적용은 불가. 계획·순수 Git 객체 기반 fixture 구현은 독립 착수 가능.
- Stage 3-2: 신규 강제 검사를 기존 PR에 적용하지 않음. 현재 게임 작업·CI·훅·공유 Git config를 변경하지 않음. 후속 공통 훅/CI 연결 때 HQ/Owner가 적용 순서를 조정.
- 기획/디자인/개발: 각 부서의 Manifest 작성 비용·스테이징 순서·후임 인수 증거가 추가됨. 파일 자체 헤더나 데이터 포맷은 바꾸지 않음.
- 테스트/세이브: 게임 동작/세이브 형식 영향 없음. registry/PR metadata는 데이터로만 읽고 PR 코드는 실행하지 않음.
- 권한: INF는 등록부, Convention은 검사기, 각 부서는 선언, Owner는 활성화/강제·Git 동작·병합을 승인. 문자열/동일 계정으로 실신원 인증 불가.

## 답변·결론

- INF 회신 수신: 4자리 ID·registry 후보 경로·미등록 ACTIVE·비소급·head 고정 예외·은퇴 신규 제출 거부·단계 도입 권고를 설계와 시제품에 반영. OWNER_APPROVAL_REQUIRED 상태를 유지.
- Convention 의견: 기존 department-policy와 독립된 데이터 전용 검사를 권고. 현재 REPORT_ONLY 독립 로컬 시제품과 계획까지 진행하며 기존 CI/훅에 연결하지 않음.
- HQ 조정 결과: PENDING.
- Owner 결정: PENDING. 위 항목의 제안을 독자 승인하지 않는다. 승인 기록을 받은 항목부터 후속 티켓/설정/스키마에 반영.
- 반영 대상: INF 소관 registry/정책 PR, DEV 소관 생산 검사/문서/CI PR, Owner의 전환/merge 결정. 이번 RFC 파일만으로 타 부서 쓰기·원격 제출 권한을 만들지 않는다.
