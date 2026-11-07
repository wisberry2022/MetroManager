# DSG-005 독립 QA 산출물 제출 기록

- 부서: Design / 상태: REVIEW / 2026-11-07.
- 검증 기준과 제출 base: `bc495d66e99414e6e734df45de283e5d186829c5`.
- 제출 브랜치: `codex/DSG-005-residual-qa-submission`.
- 이번 Owner 승인 원문: **“산출물들을 원격 저장소의 PR로 생성해주세요”**(동일 QA 채팅의 결과 수령 후 직접 지시).
- 적용 범위: 이번 생성한 QA 보고서·HQ 권고·실제 입력·캡처·로그·체크섬과 동일 SHA 선행 증거를 `docs/design/` 안에 제출하기 위한 Commit/일반 Push/PR 생성 및 CI 확인.
- 과거 두 Markdown 전용 제출 승인을 재사용하지 않으며 이번 직접 지시가 추가 증거 제출 근거다. 게임 코드·씬·정책·원래 디자인 명세는 수정하지 않는다. main 병합·릴리스·Issue 편집은 수행하지 않는다.
- 기존 개발 Worktree와 detached 실행 QA는 보존하고 제출 전용 Worktree를 사용한다.
- 결과: DSG-QA-01·02 선행 PASS 유지. 시간/지도/예측 주요 조작 검증 완료. R-01 비용/지급 상세 표현, R-02 늦은 실패 실행 증거, R-03 RNG 증거 한계가 남아 **ACCEPTANCE_PENDING**.
- 명세 변경 필요 여부: QA가 변경하지 않음. 필수 표현/증거의 보완 또는 이월 결정은 Design+DEV L2 및 HQ/Owner 판단 필요.
- 이번 제출 검증: `python tools/policy.py doctor`, `check`, Commit 후 `preflight` 및 두 필수 원격 CI 확인. 검사 결과는 PR에 기록한다. 게임 자동검사 902개와 GUI 결과는 기존 실행 기록으로 연결하며 이번 PR 준비에서 재실행하지 않는다. 빌드/export NOT_RUN.
- 공개 사본은 로컬 홈 경로를 `<USER_HOME>`으로 치환했고 실행/캐시/진단 스크립트는 제외했다. 이미지 바이트와 핵심 게임 로그 수치는 보존했다.

산출물: [잔여 보고서](DSG-005_RESIDUAL_QA_REPORT.md), [HQ 권고](DSG-005_HQ_ACCEPTANCE_RECOMMENDATION.md), [증거/ZIP/체크섬](../evidence/DSG-005-residual-20261107/README.md).
