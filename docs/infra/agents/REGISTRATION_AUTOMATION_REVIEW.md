# INF-002 — 후임 Agent-ID 자동 등록 적합성 및 안전 설계
- 문서: v1.0 / 2026-11-02 / 담당: INF / 상태: REVIEW — Owner 구현·운영 승인 필요
- 대상: `docs/infra/agents/registry.json` / DEV-013 REPORT_ONLY 시제품
- 책임: INF=ID·인계·승인 근거 검증, Convention Team=검사/발급 보조도구 구현, HQ/PM=업무 전환, Owner=임명·병합·강제 적용 승인

## 결론
**자동으로 ID와 변경 PR을 생성하는 기능은 적절하며 단계적 도입을 권고한다.** 그러나 자동 ACTIVE 확정과 자동 `main` 병합은 금지한다. 같은 GitHub 계정을 사용하는 에이전트 환경에서는 워크플로 실행자 이름으로 실제 Owner 승인 신원을 인증했다고 주장할 수 없다.

## 레거시·신규 시간 규칙
- Owner가 2026-11-02 승인한 초기 등록의 기존 ACTIVE 에이전트는 `activated_at: null`을 유지한다. 정확한 이전 활성화 시각을 추정하지 않는다.
- 신규 **후임**이 실제 ACTIVE가 되는 경우, INF 수용 검증(핵심 T1~T5 전체·일반 80% 이상), PM 담당 전환 확인, Owner의 최종 임명과 *정확한 효력 시각*이 필요하다.
- `activated_at`은 승인된 효력 시각을 오프셋 포함 ISO 8601(예: `2026-11-02T20:00:00+09:00`, 실제 기록이 아닌 형식 예시)으로 기입한다. 인계서 작성/검사기 실행/PR 병합 시간을 임의로 사용하지 않는다. 시각을 확인할 수 없으면 PENDING/확인 요청 상태로 남긴다.
- 기존 `agent_id`·부서·세대·계보는 불변이고, 상태 전환마다 `record_version`을 증가시키며 승인된 append-only 변경 이력을 후속 설계로 확보한다.

## 이벤트·상태 전환
| 사건 | 필요한 근거 | 생성 결과 | 효력 한계 |
|---|---|---|---|
| Owner의 후임 후보 지정 | 부서·직무·인계 ID·후임 후보 승인 | PENDING 후보 ID를 포함하는 검토용 PR | `main` 병합 전에는 ID 예약 미확정 |
| INF 수용시험 합격 | 시험 ID·검증 기록 | 수용 완료 근거와 후보 갱신 | 임명·실제 Git 권한이 아님 |
| PM 전환 확인 | 기존 담당 종료·후임 담당 시점·의존성 | 전환 증거 갱신 | Owner 최종 결정 필요 |
| Owner 임명·효력 시각 확정 | 결정 참조 + 정확한 시각 | 새 ACTIVE/이전 RETIRED 변경 PR | Owner 별도 `main` 병합 후 trusted-base 등록부 효력 |

## 충돌·신뢰 경계
1. 부서별 사용된 최댓값 + 1로 ID를 산출하되, **단일 writer, workflow concurrency 잠금, 최신 `main`과 expected SHA 기반 갱신**을 강제한다. 동시 제안이 충돌하면 최신 base에서 재산정하고 재검수한다.
2. PENDING ID는 최초 등록 PR의 Owner 병합 이후에만 정식 예약으로 간주한다. 등록된 ID의 삭제/재사용·다른 주체로의 재할당·비승인 계보 변경은 거부한다.
3. 최초 INF 등록부 PR은 기존 `policy`, `department-policy` + Owner 검수로 부트스트랩한다. 신규 ID를 같은 PR head에서 읽어 자기 승인/활성화하지 않는다. DEV-013 검증은 신뢰된 **PR base**의 registry를 사용한다.
4. 자동화는 원칙적으로 등록부와 근거 파일의 **작업 브랜치 PR만 생성**한다. 타 부서 파일·게임 코드·CI/보호 설정·`main` 직접 쓰기, 강제 push 및 자동 병합은 허용하지 않는다.
5. 개인 세션 URL/비공개 수용시험·건강 점수는 공개 저장소에 기록하지 않는다. 공개 참조는 확인 가능한 승인 ID·직무 가명·인계 ID·변경 이력에 한정한다.
6. 활동 세션이 독립적이면 환경명과 무관하게 ID를 나누며, Project Leader LAPTOP/DESKTOP과 Convention Team은 서로 다른 계보의 1세대다. `AGT-DEV-0003`은 3세대라는 의미가 아니다.

## 단계적 도입 / Convention Team 요청
1. **현재 INF-002:** 실제 8개 ID 등록부를 Owner 승인에 따라 PR 제출, Owner `main` 병합 대기.
2. **Convention 후속 DEV 작업(별도 승인):** 발급 CLI·검증·ID 중복/계보·PENDING/ACTIVE 변경 diff/승인 근거 확인·단일 writer·경합 테스트. 수동 실행 가능한 PR 제안기를 먼저 구현.
3. **별도 Owner 승인 후:** 인수 완료 시 검토용 PR을 생성하는 workflow_dispatch/승인 이벤트 자동화. 해당 이벤트는 실제 Owner 승인과 구분하고, Owner가 수동 검토·병합한다.
4. **검증 후:** DEV-013 별도 REPORT_ONLY 원격 시범 → 정상/부정 검사 및 기존 PR 영향 확인 → Owner가 승인한 SHA/기존 PR 예외로 ENFORCE 전환. 현재 시제품은 자동 등록도 강제도 구현하지 않았다.

## 남은 결정
- 자동 등록 트리거의 권한/이벤트 정본, 정확한 Owner 승인 시각 입력 방식, append-only 이벤트 이력과 재활성화·예외 처리 규칙은 Convention 기술 설계+INF 검토+Owner 승인 필요.
- Owner가 별도 인사·Git 실행 권한을 부여하지 않은 후임을 ACTIVE로 등록하거나 기존 세션의 Git 허가를 자동 승계할 수 없다.

**판정: AUTOMATED_PR_CREATION_RECOMMENDED / AUTOMATIC_ACTIVATION_NOT_AUTHORIZED / DESIGN_ONLY.**
