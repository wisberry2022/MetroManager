# 개발 환경 간 협업 공간

- 개설: DEV-005 / 2026-11-01 / REVIEW (Owner 검수 요청)
- 대상: DESKTOP 및 LAPTOP의 Development / Project Leader
- 근거: [DEV-005 티켓](../tasks/DEV-005_ENVIRONMENT_COLLABORATION.md). 기존 운영 규정의 대체·권한 위임 문서가 아니다.

대화 기억 대신 Git의 문서 경로·버전·승인 근거·커밋 SHA를 공유한다. 환경명은 실행 위치이며 별도 의사결정 계층이 아니다. 최종 결정권자는 Owner다.

## 시작점

| 문서 | 용도 |
| --- | --- |
| [현황 분석](DEV-005_PROJECT_STATUS.md) | 조사 기준 시점의 승인/구현/잔여 조건 |
| [작업 현황](WORK_STATUS.md) | 담당 환경·티켓·변경 경로·인계 상태 |
| [DESKTOP](environments/DESKTOP.md) | 데스크톱이 직접 확인하고 갱신할 환경 기록 |
| [LAPTOP](environments/LAPTOP.md) | 랩탑의 실제 확인 환경·검증 |
| [인수인계 양식](templates/HANDOFF.md) | 송신 기록과 수신 확인 작성 양식 |
| [최초 인계](handoffs/DEV-005_2026-11-01_LAPTOP_TO_DESKTOP.md) | 이번 분석·협업 공간의 전달 준비 기록 |

## 작업 시작·중복 방지

1. 매 작업 AGENTS.md, 개발 README와 필수 규정을 직접 읽고 `git status --short --branch`, `git worktree list`, doctor를 확인한다. 기존 변경을 자동 stash·폐기하지 않는다.
2. fetch 후 기준 main/작업 head SHA와 승인 문서 버전을 다시 확인한다. 원격 미확인·오프라인이면 마지막 확인 SHA와 한계를 적는다. 최신 커밋을 승인으로 간주하지 않는다.
3. WORK_STATUS와 상대 환경 기록에서 같은 티켓·경로의 진행 여부를 확인한다. 미공유 로컬 기록은 보이지 않으므로 동시 작업 필요 시 Owner가 제공한 최신 인계도 확인한다. 표는 안내 기록이며 원자적 잠금이 아니다.
4. 신규 DEV ID는 저장소·원격의 사용 여부를 확인하고 이번 작업의 번호/담당/경로를 기록한다. 미공유 번호 충돌 시 기존 이력을 덮지 말고 조정한다. 환경별 영구 브랜치 대신 `codex/<TASK-ID>-<lower-kebab-description>`을 쓴다.
5. 같은 티켓을 두 환경이 이어 수행할 때는 순차 인수한다. 독립 작업은 티켓과 변경 경로를 분리한다. 같은 경로의 동시 수정이나 승인 범위 충돌은 중단하여 Owner/HQ 조정을 요청하고 RFC 양식을 따른다. 다른 채팅이 쓰는 로컬 브랜치를 바꾸지 않는다.

## 인계 → 공유 → 인수

1. 송신 환경은 `handoffs/<TASK-ID>_<YYYY-MM-DD>_<FROM>_TO_<TO>.md`를 양식에서 작성한다. 같은 날 추가 인계는 `_02`처럼 새 이름을 사용한다. 완료/미완료, 변경 경로, 기준·산출물 SHA, 검증, 다음 행동과 금지 범위를 적는다.
2. 로컬 파일만 있으면 상태는 LOCAL_ONLY다. 공유 SHA는 PENDING이며 상대 PC에 도달했다고 표시하지 않는다. commit/push/PR/merge는 각각의 Owner 승인 범위를 확인한 뒤 수행한다. 승인 전에는 Owner가 파일 또는 diff를 직접 전달할 수 있다.
3. Git 공유가 승인됐다면 브랜치/커밋/PR 링크, 검증한 정확한 head SHA와 실제 CI 결과를 남긴다. main 반영 전에도 승인된 작업 브랜치 SHA로 전달 가능하다. OneDrive 경로나 같은 폴더 이름만으로 동일 checkout·동기화를 가정하지 않는다.
4. 수신 환경은 원격/전달본을 확보하고 SHA·diff·승인 범위와 필수 검사 결과를 직접 대조한다. SHA 없는 전달본은 파일·버전·검증 한계를 적고 별도 작업 브랜치에서 검토한다. 상대 환경의 검증을 본인 실행 결과로 복사하지 않는다.
5. 수신자가 인계 문서의 수신 확인란에 날짜·환경·확인 SHA·수용/조건/반송과 다음 담당을 기록한 뒤 작업 현황을 갱신한다. 인수 전 상대가 착수했다고 추정하지 않는다. 수신 확인도 Git을 통해 공유해야 송신자가 확인할 수 있다.

공통 표·인계 파일을 동시에 편집하지 않는다. 다른 환경 문서의 실측값은 그 환경이 작성한다. 오래된 IN_PROGRESS는 자동 인수 사유가 아니며 인계·담당 조정 후 진행한다. 공유 브랜치의 이력 변경·강제 push 대신 기존 Git 운영 규칙의 대체 브랜치 절차를 따른다.

## 기록과 승인

- 작업: 기존 BACKLOG/APPROVED/IN_PROGRESS/REVIEW/DONE 체계를 사용한다. REVIEW는 검수 요청이며 DONE·Gate 승인이 아니다.
- 전달: LOCAL_ONLY → SHARED → ACKNOWLEDGED로 구분한다. 작업 상태와 독립이며 SHARED는 실제 전달 증거, ACKNOWLEDGED는 수신자 확인이 있을 때만 쓴다.
- 미확인 환경/명세는 UNKNOWN 또는 NOT_CONFIRMED, 미실행 검증은 NOT_RUN으로 표시한다.
- 명세 모호성·부서 경계·범위 변경은 [RFC 양식](../../templates/RFC_AND_DECISION.md)으로 보고한다. 기존 승인 원문과 타 부서 산출물은 수정하지 않는다.
- 환경 기록에 자격증명·토큰·개인 계정 설정을 저장하지 않는다. 도구/엔진 버전·필요한 경로·검증 사실만 기록한다.
