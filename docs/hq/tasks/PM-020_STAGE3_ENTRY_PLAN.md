# PM-020 — Stage 3 진입·목표·부서 요청서 제출

- HQ / AGT-PM-0002 / 2026-11-15 / **OWNER_DOCUMENT_PR_REQUESTED / PLAN_REVIEW / MAIN_MERGE_PENDING**.
- 저장소: wisberry2022/MetroManager. 기준 main `96c51ae6c3352195b9a8e8b89f92dd51c13be81c`.
- 브랜치: `codex/PM-020-stage3-entry-plan`.
- [계획안](../PM-020_STAGE3_EXECUTION_PLAN.md) / [검증 결과](PM-020_RESULT.md).

## Owner 요청과 이번 권한

현재 HQ 대화 원문:

> PM 에이전트. 현재 개발 에이전트가 DEV-025를 완료하여 디자이너 에이전트가 검수 대기중입니다.
> 현재 원격 저장소와 상황을 감안하여, Stage3 단계의 진입 및 Stage3 단계의 목표, Stage3의 부서 에이전트별 요청 지시사항을 산출물로 만들어 PR로 생성해주세요

위 요청에 필요한 HQ 산출물 작성·검증·작업 브랜치 Commit·Push·PR을 수행한다. 대상은 이 저장소/PM-020/위 브랜치/아래12개 HQ 경로이며 이번 제출·같은 범위 검수 대응 또는 Owner 철회까지다. **main 병합은 별도**다. 새 게임/타 부서 산출물 제작·실험·정책 확정·다른 채팅 메시지 발송·Issue 변경/종료·릴리스·배포는 포함하지 않는다.

이 요청은 Stage 3 구체 계획을 작성해 검토받는 지시이며 아직 존재하지 않던 세부 S3 기준·최종 F-08 규격·DEV-026 재개를 모두 승인한 것으로 확대하지 않는다. 기존 Stage 2 최종 인수와 DEV-025 실험 공급 완료를 현재 기준으로 사용한다. 다른 부서의 유효 개별 권한은 그대로 재사용한다.

## 포함·변경 파일

| 경로 | 목적 |
| --- | --- |
| `docs/hq/PM-020_STAGE3_EXECUTION_PLAN.md` | 진입·목표·범위·의존성·S3-01~11 기준안·부서 역할·Owner 결정·근거 |
| `docs/hq/requests/PM-020_DEVELOPMENT_STAGE3.md` | DEV-025 상태 연결 및 W04B 모델/UI/VS-02 분해 요청 |
| `docs/hq/requests/PM-020_PLANNING_STAGE3.md` | 기존 승인 의미·반례·AC/VP 대응 요청 |
| `docs/hq/requests/PM-020_DESIGN_A_STAGE3.md` | 신규 기능 UI·L2·독립 인수 요청 |
| `docs/hq/requests/PM-020_DESIGN_B_STAGE3.md` | DEV-025 RD별 심사·F-08 선택안 요청 |
| `docs/hq/requests/PM-020_INFRA_STAGE3.md` | 간소화 인계·원본/백업 이월 지원 요청 |
| `docs/hq/requests/PM-020_CONVENTION_STAGE3.md` | 필요 시 기존 Git/CI·재현 검사 지원 요청 |
| `docs/hq/STAGE2_ACCEPTANCE_MATRIX.md` | #141 Owner 최종 결정·PR #144 병합을 현재 상태에 연결; 기존 시험/이월 보존 |
| `docs/hq/README.md` | Stage 2 DONE·Stage 3 계획/요청서 진입점 |
| `docs/hq/tasks/PM-020_STAGE3_ENTRY_PLAN.md` | 본 티켓·Owner 원문·범위 |
| `docs/hq/tasks/PM-020_RESULT.md` | 검증·한계·후속 |
| `docs/hq/tasks/PM-020_PROVENANCE.json` | 비자기참조11개 산출물의 base/blob·작성자 선언, REPORT_ONLY |

공유 checkout의 기존 데이터2개 미커밋 변경을 보존하고 최신 main의 별도 사본을 사용한다. PM-020은 main 전체 트리·원격 브랜치·Issue/PR 제목·로컬 HQ 파일 검색에서 기존 사용 없음 확인 후 선정했다. 타 부서 작업 ID를 선점하지 않는다.

## 제출 조건

- 최신 Issue/PR·#141 결정·DEV-025 제출/병합·필수 CI·현재 registry·승인 C/D/DATA를 대조한다. 과거 상태와 최신 사실을 구별한다.
- 6개 요청서의 담당·첫 산출물·완료 조건·권한/차단 시점과 계획의 S3-01~11이 일치해야 한다. Stage 2 수용 재개방·MVP 자동 완료·DEV-026 자동 재개·통상 인계 반복시험을 요구하지 않는다.
- 정상 hooks/doctor, policy check, 문서/링크/표·12개 경로·blob/provenance·diff 검사. API 제출 후 원격 부모/tree/경로·expected SHA·fetch/preflight 및 실제 head의 policy/department-policy 확인.
- 신규 게임 자동검사·로드·GUI·빌드/성능·원본 재해시·백업 복구는 해당 미실행/미확인으로 기록한다. 실행/인수 기준을 문서에서 PASS로 만들지 않는다.

게임 명세 변경 필요 없음. 계획·인수 기준안은 Owner 검토 대상이다. 부서 요청서는 PR 제출 뒤 Owner가 전달할 수 있는 산출물이며 이 작업에서 자동 메시지나 작업 착수를 실행하지 않는다.
