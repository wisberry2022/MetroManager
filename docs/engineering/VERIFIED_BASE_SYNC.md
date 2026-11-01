# DEV-014 — 검증된 base 동기화·반복 오류 수정 검수안

- Convention Team / 2026-11-01 / REVIEW. 정책 Owner 검수·main 반영 전 운영 허용 아님.
- 근거: Owner의 ERR-002/동일 Update branch 실패 수정 지시, main `87342cd5c29a3047695c11bfd7f2b76415cdf4d8`.

## 바뀌는 동작

다른 PR이 먼저 병합된 뒤 GitHub Update branch를 누르면 부모 2개 커밋이 생긴다. 현재 검사기는 모두 거부하므로 로컬 훅·금지 안내만으로 원격 반복을 해소하지 못했다. 이 검수안은 일반 작업의 단일 부모/부서 검사를 유지하면서 순수한 base 가져오기만 내용으로 검증한다.

| 입력 | 후보 판정 |
| --- | --- |
| 자기 부서·티켓의 부모 1개 작업 | 기존 제목/본문/경로/모드 검사 유지 |
| 첫 부모=이전 작업, 둘째 부모=신뢰된 base 조상, 정확한 clean merge tree | 검증된 base-sync, 같은 PR에서 허용 |
| 알려진 main이 아닌 부모·부모 뒤집기·octopus | 거부 |
| 무충돌 merge에 임의 수정 추가 | 자기 경로여도 거부. 작업은 별도 정상 커밋으로 기록 |
| 실제 내용 충돌을 수동 해소한 merge | 거부. 승인 변경만 최신 기반 대체 PR으로 검토 |
| 과거 부서/메시지 위반을 sync 뒤 숨김 | 중간 일반 커밋 검사에서 거부 |
| 일반 작업 없이 sync만 제출·최종 유효 변경 없음 | 거부 |
| Git 기능 부족/시간 초과/검증 불가 | fail-closed |

반복 갱신은 기존 head를 첫 부모로 덧붙여 force push 없이 기존 커밋/PR 번호를 보존한다. 최신 main 포함 여부와 strict 검사는 계속 필요하다. base가 다시 진전하면 다시 읽고 갱신·검증한다.

## 신뢰 경계

policy와 department-policy는 공통 range_check를 사용한다. 후자는 기존대로 base의 코드만 실행한다. 임시 bare 저장소의 alternates로 source objects만 읽고 merge 결과 objects는 임시 저장소에 쓴다. 원본 refs/index/checkout에 쓰지 않는다. 셸 호출 없이 명령 인수를 넘긴다. source-local/global/system merge driver와 Git 환경 설정을 가져오지 않아 PR attributes로 외부 스크립트를 호출하지 않는다. 외부 driver 방지와 원본 refs/status 불변을 회귀로 검증한다.

main은 squash-only로 여전히 선형 이력이다. 작업 브랜치의 sync 예외와 main merge 방식을 혼동하지 않는다. 부서·티켓·경로·파일모드·base 예외 목록·force push 금지·Owner 병합 승인은 유지한다. 로컬 자동/수동 merge 생성 훅은 유지하고 승인된 GitHub 무충돌 결과를 fetch해 검증한다.

## 사건 대조와 도입 순서

- PR #52 job 124830059694와 #53 job 124830042516의 단일 부모 실패 로그를 직접 재조회했다.
- 같은 당시 base `88496d0...`와 실제 head `42a82c2...`/`e4bfed3...`를 후보로 재생: 각각 work=1, verified_base_sync=1 PASS. 과거 원격 failure run이 변경된 것은 아니다.
- 후보 구현/회귀를 Owner에 제출→정책 DEV PR의 기존 두 CI 확인→Owner의 별도 main 반영 승인→그 이후 승인된 무충돌 시험 PR을 실제 Update branch로 갱신하고 두 CI·동일 PR 번호·기존 head 보존을 확인한다.
- 정책이 base에 들어오기 전 기존 PR의 버튼이나 검사 해제로 시험하지 않는다. 실제 원격 검증 전 전체 운영 해결/DONE으로 선언하지 않는다.

## 공통 현황 표

WORK_STATUS의 과거 행을 보존하고 각 티켓/결과·Issue/PR을 상태 정본으로 사용한다. 병렬 티켓마다 표의 같은 위치에 행을 넣는 관행을 기본 제출 조건에서 제외한다. 집계는 통합 담당이 순차 갱신한다. 모든 내용 충돌을 자동 제거하는 기능은 아니다.

## RFC-DEV-014-01 — 제한 동기화 예외·통합 방식 결정

- 상태 ANSWERED / 요청 Convention / 응답 Owner (현재 채팅, 2026-11-01). 정책 채택 승인, main 적용 대기.
- 근거: ERR-002의 RFC-DEV-012-ERR-002와 Owner의 현재 반복 오류 수정 요청. 전면 merge 금지·공유 이력 보존·strict 최신성 요구가 함께 적용돼 재제출 반복이 생겼다.
- 권고: 위 tree 검증 예외와 티켓별 상태 정본을 채택한다. 필수 체크/strict를 낮추지 않고 같은 PR의 무충돌 갱신을 수용한다.
- 대안 1 기존 규칙+재제출 도구: 경계는 유지하지만 PR 번호와 링크가 바뀌어 반복 비용이 남는다.
- 대안 2 lease 기반 rebase/force 갱신: 같은 PR은 가능하나 공유 이력 불변과 충돌하고 추가 권한/감사가 필요하므로 이번에 시행하지 않는다.
- 대안 3 strict 해제 또는 merge 일괄 허용: 검증/승인 경계를 약화하므로 채택하지 않는다.
- 영향: 메시지 예외는 검증된 sync만, 게임/세이브 영향 없음. merge-tree 지원이 필요하고 충돌 시 여전히 별도 검수·대체 PR이 필요하다. 향후 provenance ENFORCE 전 sync metadata/Manifest baseline 정합화가 필요하다. 현재 provenance는 REPORT_ONLY로 운영 차단 영향 없음.
- Owner 결정 필요: 일반 작업의 단일 부모 유지+검증된 base-sync 예외 채택, 상태 정본/집계 절차. 현재 구현은 검수안이며 이 RFC만으로 정책을 자체 승인하지 않는다.
- Convention 의견 위와 같음 / HQ 별도 조정 요청 없음 / Owner 결정: 제한 예외·상태 개선 채택 승인. 반영 대상: DEV 정책 PR·Git/협업 안내. commit/push/PR 승인, main 병합 미승인.

## DEC-DEV-014-01 — Owner 정책·제출 승인 기록

- 결정 일시: 2026-11-01, 현재 Convention Team 채팅의 DEV-014 제출 승인 메시지.
- 결정권자: Owner / 상태 APPROVED / 연관 RFC-DEV-014-01, DEV-014.
- 승인 원문:

> 컨벤션 팀. DEV-014의 검증된 무충돌 base-sync 예외와 상태 관리 개선안을 승인합니다. 기존 Git 규정을 준수하여 커밋·푸시하고 PR 생성해주세요. main 병합은 별도 승인 후 진행해주세요.

- 확정: 검증된 무충돌 base-sync 예외와 상태 관리 개선안. 일반 merge·force push·필수 CI 완화 대안은 채택하지 않는다.
- 대상 저장소: `wisberry2022/MetroManager`, 작업 브랜치 `codex/DEV-014-verified-base-sync`.
- 허용: DEV-014 범위의 commit, 일반 push, base=main PR 생성. 기간: 이번 DEV-014 제출 완료까지의 개별 승인. 미래 작업 포괄 위임 아님.
- 금지/제외: main 병합·직접 쓰기, force push, 보호/CI 해제, 릴리스·배포. main 병합은 별도 승인 후 진행.
- 적용 기준 커밋: PENDING (정책 PR main 반영 후 확정). 원격 Update branch 실증·ERR-002 종결은 후속 검증 대상.
