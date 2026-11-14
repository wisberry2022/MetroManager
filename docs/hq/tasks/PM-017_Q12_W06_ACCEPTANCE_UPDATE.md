# PM-017 — Q12 증거 대조·W06 모델 공급 완료와 후속 인수 정리

- 담당: HQ / AGT-PM-0002 / 2026-11-15 / REVIEW.
- 기준 main: `e379e584e6a9fefa0c581f27903c16e4fc0f5136`.
- 브랜치: `codex/PM-017-q12-w06-acceptance-v2` → `main`.
- 목적: S2 인수표의 이전 Q12 미대조·DEV-022 착수 대기 상태를 최신 공식 증거로 갱신하고 DEV-023/024의 실제 제품 인수 잔여를 구분한다.
- 승인 기준: [PM-014 S2-01~11](../PM-014_STAGE2_VS01_EXECUTION_PLAN.md), [PM-015 검수 지침](../GUI_REVIEW_PROTOCOL.md), [Gate 2 최종 승인](../../planning/PLN-001_GATE2_FINAL_APPROVAL.md), C v0.7 / D v0.9 / DATA v1.4 및 SEM-01~03/CLOSE-01. 승인 규칙 변경 없음.

## 요청과 승인 범위

Owner가 2026-11-15 현재 HQ 대화에서 지시했다.

> PM 에이전트. 이번 Q12 증거 대조 결과와 DEV-022 모델 공급 완료 상태를 S2 통합 인수표에 반영하고, DEV-023·024 잔여 업무를 정리하여 원격 저장소에 PR을 만들어주세요. 해당 작업의 커밋·푸시·PR 생성을 승인합니다.

이 지시에 따른 작업 ID를 PM-017로 기록한다. 허용 범위는 `wisberry2022/MetroManager`, 위 작업 브랜치의 아래 HQ 파일 작성·검증·Commit·브랜치 게시·base=main PR 생성과 같은 범위의 검수 대응이다. 유효 기간은 이번 제출·검수 대응 완료 또는 Owner 철회까지다. PM-016의 과거 권한을 재사용하지 않는다. main 병합·강제 push·릴리스/배포, Issue 변경·종료, 다른 부서에 메시지 발송, DEV-023/024 실행·Git 승인, 타 부서/제품/CI 변경은 범위에 포함하지 않는다. 전체 비공개 대화는 게시하지 않는다.

## 변경 파일

| 경로 | 변경 목적 |
| --- | --- |
| `docs/hq/STAGE2_ACCEPTANCE_MATRIX.md` | Q12 6범위 대조 완료, DEV-022 공급 완료, S2별 수용/잔여·우선순위·출처 갱신 |
| `docs/hq/README.md` | 최신 PM-017 진입점과 PM-016 이력 구분 |
| `docs/hq/tasks/PM-017_Q12_W06_ACCEPTANCE_UPDATE.md` | 본 작업 범위·승인·수용 기준 |
| `docs/hq/tasks/PM-017_RESULT.md` | 실제 검증 결과와 한계·미결 |
| `docs/hq/tasks/PM-017_PROVENANCE.json` | 실제 작성자·변경 blob 출처 선언. REPORT_ONLY |

## 선행 근거와 수용 기준

1. [Design Q12 상세 대조](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6885431567)와 [상태 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6885439128)의 원래 6범위를 행별 연결한다. 초기 시험 SHA·W05/OBS 후속 시험 SHA·Design의 ZIP 검증과 HQ 확인 수준을 구분한다.
2. 원래 P05 범위의 필수 미충족을 해소하되 상위 Q12 PARTIAL·Issue 전체 종료·Stage DONE을 별개로 둔다. 지급자료 없음은 UI 소비 packet 반례이며 실제 정부 지급 실패·지연·재지급 검증으로 확대하지 않는다.
3. [PR #123](https://github.com/wisberry2022/MetroManager/pull/123)의 모델 구현/자동검증·main 병합 완료를 S2-01/04/05/06/07/09/11에 연결한다. 모델 자동 연결을 제품 Session 활성화·실제 GUI·VS-01 완료로 확대하지 않는다.
4. DEV-023 공급 계약/Design L2→제품 UI·독립 인수→DEV-024 실제 표준 완주/영향 회귀→HQ/Owner 최종 인수 순서를 명시한다. 유효한 작업별 권한은 재승인하지 않으며 미확인 후속 권한을 이번 지시로 만들지 않는다.
5. QA-001/002·Q03~05·W05·OBS-01·A02-11 한정 PASS·Q12 28조건과 기존 증거 한계를 보존한다. ERROR 2→7 정정의 원본 인계 연결 완료는 NOT_VERIFIED, 신규 GUI 요청 없음.
6. HQ 파일 5개만 변경한다. UTF-8/LF·표/링크·출처 blob·정책·Git 부모/경로를 검사하고 제출 head의 필수 CI를 확인한다. 새 게임 자동검사·Godot 로드·GUI·플레이·빌드는 NOT_RUN으로 보고한다.

게임 명세 변경 필요 없음. 결과와 남은 사항은 [PM-017 결과](PM-017_RESULT.md), 실제 최신 상태는 [S2 인수표](../STAGE2_ACCEPTANCE_MATRIX.md)를 따른다. PR 게시·검사 통과는 main 병합이나 Owner Stage 인수를 대신하지 않는다.
