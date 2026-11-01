# PLN-001 — Gate 2 OWNER_APPROVED 변경 목록 및 원격 반영 준비

- 버전: v1.0 / 2026-11-01 / Planning
- 상태: **Owner 최종 승인 정책 정리 완료 / 작업 브랜치 PR 제출 단계 (main 미병합)**
- 기준 `main`: `f76db01ae7b2a094d587e288681b12ebc324bc04`
- 부서 검토 기준: `dc06e48b1dbc7745dcb0a29e424cd0416767ab38`

## 승인 완료 상태표

| 구성 | 상태 |
|---|---|
| Gate 1 Owner 원칙 | OWNER_APPROVED |
| PAR-01~05 검수 수치 | OWNER_APPROVED |
| SEM-01~03 | OWNER_DECIDED |
| CLOSE-01~03 | OWNER_DECIDED |
| APP-01 | OWNER_DECIDED |
| **Gate 2** | **OWNER_APPROVED** |
| Gate 3 티켓·구현 착수 | NOT_AUTHORIZED / NOT_STARTED |
| Godot/Windows 빌드·실제 E2E·FPS | NOT_RUN |

## 차기 기존 파일 교정 명세

| 경로 | 현재 버전 | 개정 버전(로컬 적용 후) | 변경 전 → 변경 후 |
|---|---|---|---|
| `docs/planning/PLN-001-C.md` | v0.5-draft | v0.6 | 승인 전 DRAFT 및 세칙/재검토 PENDING을 `OWNER_APPROVED`로 갱신. CLOSE-01 비용 해석/경계 테스트, Dev/Design 최신 CONDITIONAL 및 HQ 최신 BLOCK 상태로 정리. 기존 §7~9와 서두는 SUPERSEDED 이력으로 보존 |
| `docs/planning/PLN-001-D.md` | v0.8-draft | v0.9 | '최종 승인 상정 BLOCKED' → Owner 공식 승인. APP-01 승인·Gate 3 인수·HQ PM-006 판정, 개발5/3·디자인1/7 최신 상태로 갱신. 이전 §1~6·서두는 SUPERSEDED 이력으로 보존 |
| `docs/planning/PLN-001_GATE2_DATA_v1_DRAFT.md` | DATA v1.2-draft | DATA v1.3 | PAR-01~05 수치 불변. SEM·APP 상태 승인 반영, 신규 계약 제재 MVP 제외 유지, 잔여 운행비 추가0 및 익일 도착·B 정산 검수 추가. 이전 서두·§7~8은 이력 보존 |
| `docs/planning/sources/PLN-001_GATE2_OWNER_DECISIONS.md` | 2026-11-01 SEM 이력 | 최종 승인 추기 | CLOSE-01~03, APP-01, 'Gate 2 최종 승인을 허가합니다' Owner 원문 및 권한 경계 추가 |

**파일명 유의:** DATA의 기존 경로에는 `_DRAFT`가 포함되지만 파일명은 호환성을 위해 이 작업에서는 변경하지 않는 방안을 권고한다. 파일 내부 상태와 버전은 공식 승인본임을 명시한다. 별도 파일명 변경은 HQ 관리와 연결 참조 검토를 거쳐야 한다.

## 추가할 공식 파일 2건

- `docs/planning/PLN-001_GATE2_FINAL_APPROVAL.md`: Owner 공식 승인 원문·범위 및 적용 제한
- `docs/planning/tasks/PLN-001_GATE2_FINAL_HANDOFF.md`: 최신 부서/HQ 평가, BLOCK 상태, Gate 3 조건부 이월별 담당·차단 시점·검증 증거

## 반드시 보존할 기존 정책과 자료

- Gate 1 A/B v0.3 및 Owner 최초 질문·QD/P 기록
- MVP 8개 영역, MUST 11개(F-ADM/CITY/COMP/BID/PROP/CONST/OPEN/OPS/FIN/NEXT/TIME), AC-01~10, VP-01/VP-02
- PAR-01~05 승인 데이터·숫자 원문 및 SEM-01~03 정식 채택
- Idea Library 001~003 — MVP 바깥 기능으로 계속 BACKLOG
- 이전 PR/검토 당시의 판단 및 SHA: 삭제하지 않고 '과거 상태'로 보존
- HQ PM-006 CONDITIONALLY_RESOLVED·PARTIAL 판정은 Owner 승인으로 자동 RESOLVED 하지 않음

## 최종 검수 항목

- [x] 승인 원문·MVP 한정 범위·SEM/CLOSE/APP 내용 확인
- [x] 확정 수치 재계산/재결정하지 않음
- [x] Dev/Design 최신 판정과 HQ PM-006 BLOCK 기록
- [x] 기존 문서 개정을 위한 SHA 검증 로컬 적용기 작성 (source Git Blob 기반)
- [x] 검증된 기존 GitHub Blob SHA 기반으로 동일한 개정 효과를 작업 브랜치 PR에 적용 (로컬 Python 스크립트는 실행하지 않음)
- [x] Owner의 이번 명시 요청에 따라 작업 브랜치 Commit/Push/PR 생성 대상 준비. CI 결과는 PR 생성 후 확인하며 main 병합 별도 승인.
- [ ] HQ의 Gate 3 티켓·일정·인수 체계 확정
