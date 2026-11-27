# PLN-020 결과 중앙행정기관 연계 수준 최종 통합안 게시

- 담당: Planning / 기록일: 2026-11-27 (Asia/Seoul)
- 상태: OWNER_POLICY_APPROVED / OWNER_COMMIT_PUSH_APPROVED / OWNER_PUBLICATION_MERGE_APPROVED / REVIEW
- 작업: [PLN-020 티켓](PLN-020_CENTRAL_INSTITUTION_LINKAGE.md)
- base main: 03c7d9346f49eb04347343e6e7f510cf9f549d47 (작성 시작 b0447def)
- 작업 브랜치: codex/PLN-020-central-institution-linkage-design

## 변경 결과

[회사 설계서](../PLN-004_POST_MVP_COMPANY_STATE_V0_7.md)를 v0.20으로 갱신하고 §108~115에 중앙행정기관 연계 수준의 측정 7개·적용/승계 8개·정보 전달 5개와 연결 세칙을 통합했다. 현재 중앙 1차 정책의 추가 결정은 0개다.

국토교통부 실제 심사·발주 입찰, 최초 보류/설득·같은 근거 중복·기관 수·28일·전수 자료, 원래 적용·과거 활동·진행 권리/의무·사실 소비/E01·세이브·정정·분기를 보존했다. 기관 공통의 중립 단계·7일 비교·사유 최대 2개·28개 마감일 이력과 중앙 업무 안내를 연결하고 정확한 내부 점수를 모든 플레이어 경로에서 비공개로 유지한다.

개발 확인 18개·디자인 확인 10개·검증 기대 묶음 36개를 구분했다. 안전·감독기관과 인지도·조건부 확장은 별도 후속이다. 데이터 공급·실제 구현·화면 검증이 완료됐다는 뜻은 아니다.

[채택 당시 기준선](../PLN-020_CENTRAL_INSTITUTION_LINKAGE_BASELINE.md)은 원문 전체를 보존하고 게시 연결 배너만 추가했다. 회사 문서의 헤더·§1·§6·§7·§8·§103은 현재 상태/참조만 갱신하며 나머지 기존 102개 절을 보존한다. 제출은 기획 문서 4파일이며 타 부서·게임 소스·공통 정책/도구/CI는 변경하지 않는다.

## 검증 기록

| 검사 | 결과와 범위 |
|---|---|
| 원격 기준 | 작성 시작 b0447def 이후 PR #178의 main 03c7d934를 fetch하고 미게시 커밋을 rebase했다. 변경 10경로와 기획 4경로는 겹치지 않으며 회사 v0.19 blob 0e323c3616745a7cb3260cd8e6ecf257cbf9663e는 동일하다 |
| 작업 전 정책 | pinned Python의 policy.py doctor PASS |
| 문서 정합성 | PASS — 기존 102개 절 보존, 허용된 현재 상태/참조 18개 역대조, 원문 전체 보존, 신규 정책 7개 절 일치, 승인 20·개발 18·디자인 10·검증 36개, 상대 링크 98개·표 211개·UTF-8/LF 확인 |
| 로컬 저장소 정책 | policy.py doctor/check/pre-commit 및 commit-msg PASS, git diff --check PASS. 최신 base 03c7d934의 로컬 커밋 훅은 816파일·GDScript 68개 PASS, preflight는 기획 1커밋·단일 부모 PASS. 후속 승인 기록을 반영한 최종 커밋·원격 head 검사도 완료 보고에 기록 |
| 정책 도구 단위 테스트 | 89개 중 88개 PASS, Windows 실행 제한으로 실패한 1개는 제한 없는 로컬 임시 환경에서 동일 테스트를 재실행해 PASS. 전체 단일 실행 PASS로 표기하지 않음 |
| 로컬 커밋/원격 게시 | 공개 게시 보류 후 OWNER가 정확한 점수·산식 포함 개발용 문서의 공개 저장소 게시·Push·main 병합을 추가 승인했다. 원격 head bc47c820c99a02e2410ea0d36bcbf309af1d4fda의 4파일·단일 부모·tree를 대조하고 실제 head의 preflight PASS. [PR #179](https://github.com/wisberry2022/MetroManager/pull/179)를 squash 병합하여 main 1daeea11f8573a1aedceef71c56dab794cdcabda에 반영했으며 fetch 후 제출 tree와 main 전체 내용 일치를 확인 |
| 통합 PR 필수 검사 | [policy](https://github.com/wisberry2022/MetroManager/actions/runs/45992001833/job/140481872103)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/45992001857/job/140481877661) 모두 PASS, agent-provenance-report PASS. 실제 제출 head·GitHub Actions app_id 15368·main 보호·clean 상태 확인 후 병합 |

정적 문서 검사에서는 기존 본문의 제한된 현재 상태 갱신을 역대조하고, 원래 로컬 파일·제출 기준선·회사 신규 절의 전체 정책 일치, 승인/확인/검증 ID·링크·표·인코딩을 확인한다. 문서 검산을 실제 게임 테스트로 표시하지 않는다.

정책 도구 테스트의 첫 실행은 상속된 Git 설정의 빈 값으로 임시 저장소 초기화가 실패했다. 테스트 자식 프로세스에서만 해당 설정을 격리한 재실행은 88개가 통과했고, 남은 실제 Git 훅 테스트 1개는 Windows 샌드박스의 셸 실행 제한이 원인이었다. 동일 테스트를 별도 재실행해 통과했으며 저장소 코드·검사기·훅을 변경하거나 해제하지 않았다.

## 권한과 미실행

초기 Commit/Push 승인 후 자동 승인 검토가 공개 저장소의 점수·산식 게시에 추가 승인이 필요하다는 이유로 업로드를 두 차례 거절하여 원격 쓰기를 중단했다. 2026-11-27 OWNER가 해당 개발용 설계서의 기존 공개 저장소 게시·Push·main 병합을 명시적으로 추가 승인하여, 동일 문서 업로드가 성공했다. 승인 내용은 삭제하지 않았으며 플레이어 대상 비공개 원칙을 유지한다. 상세 범위는 티켓 DEC-PLN-020-05를 따른다.

로컬 커밋은 기존 훅을 유지한다. 향후 API 게시 시 원격 commit/push 훅 실행을 주장하지 않고 명시 브랜치·expected head·force=false와 base tree 보존을 확인한다. Agent-ID는 미확인이며 가짜 ID/Manifest를 사용하지 않는다.

| 구분 | 상태 |
|---|---|
| 부서 확인 | 개발 18·디자인 10 질문 준비, 요청 NOT_SENT |
| 검증 기대 묶음 | 측정 12·승계 12·표시 12, 총 36개. 실제 실행 통과 건수 아님 |
| 제품 실행 | 자동 게임 테스트·Godot 로드·플레이·세이브 전환/복원·UI/접근성·성능/밸런스·Windows 빌드·독립 검수 NOT_RUN — 문서 통합 |
| 원격 CI·병합 | PR #179의 실제 head에서 policy·department-policy 통과 확인 후 승인된 squash 병합 완료. 위 검증 기록에 검사 링크·head·main SHA 기록 |
| 제외 동작 | 부서 검토/착수 요청·리뷰어 지정·main 직접 쓰기·보호 우회·auto-merge·릴리스/배포 NOT_PERFORMED |

커밋·게시와 검사 통과는 부서 인수·구현 착수·공식 DONE·제품 출시를 뜻하지 않는다.

## 게시 상태 정정

PR #179 병합 후 회사 문서 §115에 이전 승인 범위의 PR/병합 미진행 문구가 남아 있음을 확인했다. 같은 OWNER 승인 범위에서 §115에 DEC-PLN-020-05와 실제 공개 게시·병합 결과를 반영하고, 이 티켓/결과에 이력을 기록한다. 후속 브랜치는 codex/PLN-020-central-publication-status, base는 1daeea11f8573a1aedceef71c56dab794cdcabda이며 변경은 기획 3문서의 승인·상태 기록뿐이다. 회사 §1~114와 기준선 원문, 모든 게임 정책·기존 승인 사항·플레이어 비공개 원칙을 유지한다. 후속 PR의 필수 검사·실제 병합 결과는 해당 PR과 완료 보고에서 확인한다.
