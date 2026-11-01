# PLN-002 — Gate 3-1 기획 체크리스트·첫 Stage 입력

- 담당: Planning / 2026-11-01 / 상태: REVIEW (검수 요청; DONE 아님).
- 기준 main: `177c2e4af3e15e15b15888c40eecb0f3ea983213`; 추적 [Issue #26](https://github.com/wisberry2022/MetroManager/issues/26).
- 결과: [PLN-002_RESULT.md](PLN-002_RESULT.md). 문서 정리 L1; 기존 L2 의미 수용을 재사용. 실제 W02 공통 시각/원장 실행 영향 L3는 HQ/Owner 검토 유지.

## 이번 Owner 승인과 권한

2026-11-01 현 Codex 대화의 직접 요청:
> 영향이 없으면 기존 승인 Gate2 및 Gate3-0 분석 근거로 기획 R&R 범위의 Gate3-1 체크리스트/첫 Stage 규칙 입력 및 검수·의존성/차단조건을 최소 Markdown 티켓과 결과문서로 정리하고, Owner의 이번 PR 작성 요청에 한정된 권한 내에서 docs/planning/만 변경, codex/PLN-... 작업 브랜치, 일관된 커밋·PR 제목/본문, 승인된 두 필수 CI 검증 후 main 대상 PR 생성(merge는 수행하지 않음).

- 저장소: `wisberry2022/MetroManager`; 작업: PLN-002 이번 Gate 3-1 문서 제출.
- 브랜치: `codex/PLN-002-gate3-1-planning`; 경로: `docs/planning/`.
- 허용: 이번 산출물 작성·commit·브랜치 push/API ref 갱신·main 대상 PR 생성 및 검증. 유효기간: 이번 제출·검수 대응 종료까지; 향후 작업 포괄 위임 아님.
- 금지: main 직접 쓰기·merge·강제 push·릴리스, 타 부서 문서·Godot 소스·기존 승인 게임 규칙 변경.
- 조건: DEV PR/DSG 상호 회신·Owner 요청을 먼저 확인. 새 규칙 변경·중대한 충돌·기획 산출물 변경을 요구하는 미결 Owner 판단이면 제출 중단하고 근거/SHA 보고.

## 포함·제외 및 완료 증거

포함: PM-010-PLN 6항목 회신, 기존 R01~05 판단 연결, W01~W03의 승인 입력·부분 검수, 최소 UI 의미·의존성·차단 시점, Owner 결정 상태, 검증/NOT_RUN.
제외: 기술 WBS/API·UI 배치·제품 규격의 독자 확정, 신규 실행 티켓 발급, 구현/아트·기획 규칙 개정·Stage 실행 승인.

- [x] AGENTS·부서 Git 운영·Planning README·PM-008/PM-010/기획 체크리스트 직접 확인.
- [x] DEV PR #33 및 #24/#25/#26의 요청·회신/Owner 기록 영향 분류.
- [x] 승인 C v0.6/D v0.9/DATA v1.3·최종 승인 및 Gate 3-0 의미 근거 대조.
- [x] 신규 규칙·중대한 충돌·현재 제출 차단 판단 없음; 결과문서 작성.
- [ ] 이번 PR head의 policy / department-policy 성공 확인 (PR 이벤트 실행 후 PR 본문에 SHA·링크 기록).
- [ ] HQ/Owner 검수 및 main 병합 (이번 에이전트 수행 범위 밖).

필수 CI는 현재 두 workflow 모두 PR 이벤트로 실행되므로 API 브랜치 제출 → PR 생성 → 동일 head의 두 CI 확인 순서를 따른다. CI 전후를 혼동하거나 검사 전 PASS로 표시하지 않는다. 로컬 훅/doctor/check와 게임 검증의 수행 여부는 결과문서에 별도 기록한다.
