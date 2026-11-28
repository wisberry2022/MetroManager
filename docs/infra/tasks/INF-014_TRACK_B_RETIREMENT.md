# INF-014 — Design Track B 업무 종료 후속 등록

- 담당: Infrastructure / AGT-INF-0002.
- 상태: OWNER_RETIREMENT_CONFIRMED / OWNER_COMMIT_PUSH_PR_MERGE_APPROVED / PR_SUBMISSION_PREPARED / REGISTRY_RECORD_PENDING.
- 기준 main: `a1e2534232e4cc71425a47c530240625784c0ae9`.
- 기준 registry blob: `11c2534ed27cc024f5804023e1cdfd730ef5e2cc`.
- 제안 브랜치: `codex/INF-014-track-b-retirement` / base: main.
- [등록부](../agents/registry.json) / [검증 결과](INF-014_RESULT.md).
- 적용: [INF-009](INF-009_LIGHTWEIGHT_SUCCESSION.md), [등록부 전환 규정](../agents/REGISTRY_TRANSITION_RULES.md).

<a id="owner-retirement"></a>
## 1. Owner 종료 결정

Owner는 현재 INF 대화에서 Design Track B 에이전트의 업무 종료를 지시하고, 종료 효력 일시 질문에 2026-11-28 18:27 KST를 지정했다. 아래는 최소 인사 결정 요약이며 비공개 대화·세션 정보는 게시하지 않는다. 별도 공개 결정 URL은 제공되지 않았다.

| 항목 | 확정 내용 |
| --- | --- |
| 대상 | AGT-DSG-0003 / Design Track B 독립 1세대 |
| 상태 | ACTIVE → RETIRED |
| 종료 효력 | retired_at = 2026-11-28T18:27:00+09:00 |
| 기존 활성화 보존 | activated_at = 2026-11-08T16:25:00+09:00 |
| record_version | 1 → 2 |
| 후임·권한 재배정 | 지정되지 않음 |

Owner 종료 결정과 등록부 반영은 구분한다. 종료 효력 이후 전임의 신규 업무 권한이 등록 지연으로 연장되지 않는다. 이 기록은 실제 마지막 작업·세션 종료·자격증명 회수 시각의 기술적 검증을 뜻하지 않는다. 해당 실제 시각·기술적 회수는 NOT_VERIFIED다. 종료 효력을 기록·PR·병합 시각으로 바꾸지 않는다.

후임 인계를 지시받은 것이 아니므로 신규 ID·세대·predecessor를 생성하지 않는다. Track A / AGT-DSG-0004에 업무·권한을 자동 이전하지 않는다. 기존 작성자·승인·활성화·계보와 산출물은 보존한다.

## 2. 잔여 업무와 적용 시점

| 위치 | 보존할 상태 | 후속 담당·적용 시점 |
| --- | --- | --- |
| [#92 F-08](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7236228143) | OPEN. 기존 방향·선택 승인을 유지하며 실제 이름·환경·폰트·아트/지원·배포 규격·제품 적용은 미결 | Design 담당 재배정 미지정. HQ 조정·Owner 지정 후 실제 규격 종속 적용 전에 연결 |
| [#104 RP/EX](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7236227496) | 기존 한정 수용 유지. C01~05 및 PARTIAL/INCONCLUSIVE/NOT_VERIFIED 보존. 현재 추가 독립 GUI 요청 없음 | 관련 변경·반대 증거·신뢰성 문제·더 넓은 인수 주장 시 담당을 지정하고 영향 행만 검토 |
| [#185 DI-03](https://github.com/wisberry2022/MetroManager/issues/185) | Stage 3 범위·기존 로컬 착수 허용 유지. Track B의 RP/EX·소속·표현 L2와 영향 검수 담당이 문서에 남아 있음 | 담당 재배정 미지정. 실제 공급 후 해당 L2·화면 통합/독립 검수 단계 전에 HQ/Owner가 역할을 연결. DEV 모델 착수를 새로 차단하지 않음 |

업무 종료는 미결 작업의 PASS·DONE·취소·이슈 종료가 아니다. 위 표는 INF의 연속성 공백 확인이며 HQ·Design의 범위나 인수 결정을 대행하지 않는다. 실제 후속 통지·이슈 갱신은 아직 수행하지 않았다. 후임/대체 담당 지정과 소관 기록 갱신이 필요하며 이 티켓은 등록부와 INF 기록만 다룬다.

## 3. 변경·보존 범위

- `docs/infra/agents/registry.json`: AGT-DSG-0003의 status, retired_at, role_retirement_observed_on, role_evidence_refs, record_version, notes 6필드만 수정한다.
- `docs/infra/tasks/INF-014_TRACK_B_RETIREMENT.md`: 종료 결정·범위·잔여 책임·제출 권한 기록.
- `docs/infra/tasks/INF-014_RESULT.md`: 검증 결과·실제 제출/병합 상태.

root 전체, 다른 14행, 기존 행 순서와 대상 행의 불변 필드·기존 notes/evidence를 보존한다. 예상 결과는 총 15 ID / ACTIVE 7 / RETIRED 8 / PENDING 0이다. root의 역사적 pending 문자열, lifecycle/append-only 계약, 도구·CI·정책은 변경하지 않는다.

최신 main·열린 PR(0개)·원격 INF-014 파일/브랜치·정확한 제목 검색에서 같은 등록 티켓을 찾지 못했다. 제공되지 않은 비공개 배정·다른 세션의 로컬 작업은 NOT_VERIFIED다. 제출 직전 main·중복 등록·브랜치를 다시 확인한다.

## 4. 제출 권한과 완료 기준

로컬 준비·검증과 위 3파일의 Commit·Push·PR 승인 요청 후 Owner는 현재 INF 대화에서 “Pr생성 후 main 병합까지 승인합니다”라고 승인했다. 이 승인은 위 3파일, codex/INF-014-track-b-retirement 브랜치의 Commit·일반 Push/API 게시·PR 생성·필수 검사 후 main squash 병합에 적용되며, 이번 등록 완료 또는 Owner 철회까지 유효하다. 이전 INF-013 승인을 재사용하지 않으며 종료 결정의 재승인이나 HQ 전환 승인을 추가하지 않는다.

이번 main 병합 승인도 확인됐으며 필수 검사·실제 제출 head 확인 후 실행한다. main 직접 쓰기·force push·자동 병합·릴리스·배포·다른 부서/제품/도구 변경은 범위 밖이다. 제출 시 정상 검사와 `policy`·`department-policy`를 확인한다. `agent-provenance-report`는 REPORT_ONLY이며 수동 전환 진단과 실제 신원·승인 인증을 구분한다.

실제 main의 대상 행·효력과 PR·merge SHA를 확인한 후 REGISTRY_RECORDED로 보고한다. 문서 준비나 승인만으로 기록 완료라고 하지 않는다.

Agent-ID: AGT-INF-0002
Task-ID: INF-014
