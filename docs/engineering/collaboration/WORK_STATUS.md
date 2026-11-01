# 개발 작업 현황

- 갱신: 2026-11-01 / LAPTOP / DEV-010 / REVIEW
- 이 표는 공유된 시점의 현황이며 실시간 잠금·업무 배정·승인이 아니다. 미공유 상대 환경의 작업은 UNKNOWN이다.

| 작업 | 담당 환경 | 작업 상태 / 전달 상태 | 기준 / 브랜치 | 변경 경로 | 다음 행동 |
| --- | --- | --- | --- | --- | --- |
| DEV-005 현황 분석·환경 정정 | LAPTOP | 과거 REVIEW 제출 / PR #13·#18 병합 확인 | 기존 기준 dc06e48, 환경정정 #18 / 현재 main ca597ec에 포함 | 과거 개발 문서 | 수신 확인은 별도 PENDING. 과거 기록을 현재 구현 증거로 재사용하지 않음 |
| DEV-006 Gate 3-1 분석 정리 | LAPTOP | REVIEW / Owner의 이번 문서 Git 제출 승인(실제 PR 본문 확인) | b1a8a1f981d066fce6f5ca516e821e4ff018daf8 / codex/DEV-006-gate3-1-analysis | docs/engineering/gate3/, tasks/DEV-006_*.md, 이 파일 | [분석 v1.0](../gate3/DEV-006_GATE3_1_ANALYSIS.md)·[Issue #25](https://github.com/wisberry2022/MetroManager/issues/25), Design 범위 수용/Planning 의미 재확인 완료. 이번 문서 PR·CI·Owner 검수, 실제 Stage 실행은 별도 |
| DEV-010 W01 실행 기반 | LAPTOP | REVIEW / W01 구현·검증, 이번 Commit/Push/PR 승인 | 1356c4b2ec824ca51e807bd9754a891aaa57e13d / codex/DEV-010-w01-execution-foundation | project.godot 메인 씬 연결, 승인 데이터·씬/스크립트·자동검사/UID, DEV-010 티켓/결과, 이 파일 | [Issue #44](https://github.com/wisberry2022/MetroManager/issues/44)·[실제 검증](../tasks/DEV-010_RESULT.md), PR/필수 CI·Owner 검수. W02/W03는 별도 승인 후 W01 출력을 소비 |
| DEV-011 W02 시간·명령·원장/마감 | LAPTOP | REVIEW / 이번 구현·Commit/Push/PR 승인, 모델 검증 | 88496d0 / codex/DEV-011-w02-clock-ledger-recovery | 티켓의 신규 모듈/테스트·UID, DEV-011 티켓/결과, 이 파일 | [Issue #48](https://github.com/wisberry2022/MetroManager/issues/48)·[결과](../tasks/DEV-011_RESULT.md), 필수 CI/Owner 검수. 실제 최소 GUI·main 병합은 별도 |
| DEV-012 W03 행정·노선/OD 예측 | LAPTOP | REVIEW / #55 병합 후 #56 현황 충돌 해소·오류 보고, 모델 재검증 | 826111e / codex/DEV-012-w03-conflict-report | 티켓의 신규 모듈/테스트·UID·예측 데이터, DEV-012 티켓/결과, 이 파일, ERR-002/공용 색인 | [Issue #49](https://github.com/wisberry2022/MetroManager/issues/49)·[결과](../tasks/DEV-012_RESULT.md), #56 대체 PR·필수 CI/Owner 검수. [프로세스 개선 요청](../../co-work/err-report/ERR-20261101-002_UPDATE_BRANCH_AND_PARALLEL_PR.md)은 Convention 검토 OPEN |
| DESKTOP의 현재 작업 | DESKTOP | NOT_CONFIRMED / UNKNOWN | UNKNOWN | UNKNOWN | DESKTOP이 본인 환경 문서와 이 표를 직접 확인·갱신 |

DEV-004는 과거 검토 이력이며 여기서 새 작업으로 배정하지 않는다. Owner가 전달한 최신 개발·디자인·HQ 원문은 현황 분석에 반영했다. 추가 전문 재검토는 이번 DEV-005 범위 밖이다. 다음 담당은 승인 티켓·최신 인계와 경로 중복을 확인한 뒤 등록한다.

- [최초 인계 기록](handoffs/DEV-005_2026-11-01_LAPTOP_TO_DESKTOP.md)
- [랩탑](environments/LAPTOP.md) / [데스크톱](environments/DESKTOP.md)
