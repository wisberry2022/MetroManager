# <TASK-ID> — <인계 주제>

- 인계 ID: <TASK-ID>_<YYYY-MM-DD>_<FROM>_TO_<TO>[_회차]
- 작성 일시(Asia/Seoul): <...>
- 송신 환경 / 담당: <DESKTOP 또는 LAPTOP / 역할>
- 수신 환경 / 담당: <...>
- 작업 상태: <IN_PROGRESS / REVIEW 등 기존 티켓 상태>
- 전달 상태: <LOCAL_ONLY / SHARED / ACKNOWLEDGED>
- 승인 근거: <Owner 원문 위치·일시·허용 범위, commit/push/merge 각각 구분>
- 티켓: <경로·ID·상태>
- 기준 main SHA / 검토 SHA: <전체 SHA>
- 명세: <경로·버전·승인 상태·근거 SHA>
- 작업 브랜치 / 산출물 head SHA: <브랜치 / 전체 SHA 또는 PENDING>
- 실제 공유 증거: <커밋/PR URL 또는 Owner 전달 파일·버전, 없으면 PENDING>

## 현재 결과와 남은 작업

<완료 사실, 변경 파일, 판단·의도와 미완료를 구분. 기준 이후 변경 및 충돌 가능 경로 포함>

## 검증 증거

| 구분 | 명령·환경·검사 SHA/버전 | 결과·로그 경로 |
| --- | --- | --- |
| doctor / check | <...> | <PASS/FAIL/NOT_RUN> |
| 관련 자동 테스트 | <정책 도구와 게임 테스트 구분> | <...> |
| 문서/원문 보존 검사 | <...> | <...> |
| Godot 프로젝트 로드 | <실제 엔진 버전 포함> | <...> |
| 게임 플레이 / 빌드 / 성능 | <각각 구분> | <...> |

## 다음 행동·제약

<다음 담당, 순서, 선행 승인, 작업 경로, 수정 금지 범위, 미해결/RFC, 명세 변경 필요 여부>

## 수신자 확인 — 수신 환경이 직접 작성

- 상태: PENDING
- 수신자 / 환경 / 직접 확인 일시: PENDING
- 확보한 브랜치·head SHA 또는 전달 파일/버전: PENDING
- 승인 범위·diff·기존 로컬 변경 대조: PENDING
- 본인 환경 검증 / 미실행: PENDING
- 인수 판정: <수용 / 조건부 수용 / 반송, 사유>
- 다음 작업 담당·티켓·수정 경로: PENDING

송신자가 수신 확인을 대신 채우지 않는다. ACKNOWLEDGED는 수신 확인이며 Owner 승인·DONE·Gate 종결과 별개다.
