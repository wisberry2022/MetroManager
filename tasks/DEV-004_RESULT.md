# DEV-004 — Gate 2 2차 개발 검토 결과

- 담당: Development / 상태: REVIEW
- 제출일: 2026-10-31 (Asia/Seoul)
- 작업 티켓: [DEV-004_GATE2_SECOND_REVIEW.md](DEV-004_GATE2_SECOND_REVIEW.md)
- 결과 보고서: [Gate 2 2차 개발 검토](../docs/engineering/reviews/DEV-004_GATE2_SECOND_REVIEW.md)
- 기준 SHA: `e18b047848108383acdcef47250ee81393df2058`
- 작업 브랜치: `codex/DEV-004-gate2-second-review-current` / PR base: `main`
- PR 작성 기준 main: `68f8aeeae0c651240a1bf63550962c1d1aa6b7d3` (검토 대상의 기준은 e18b047 유지)
- Owner 허용 범위: 현재 채팅의 2차 검토 요청에 따른 읽기·보고서 작성·작업 브랜치 commit/push·PR 생성·검사 확인. main 병합·릴리스는 포함하지 않음.

## 검토 결과

- 최종 판정: **CONDITIONAL**.
- 1차 검토 ID별: DEV-R02 RESOLVED, DEV-R05 BLOCKED, 나머지 6개 PARTIAL. OPEN 0은 개별 G2-Q가 승인됐다는 뜻이 아니다.
- RFC-DEV-004-01을 보고서 안에 기록. F-01~08별 위치·문제·개선 방향·책임·영향·종료 증거를 제시했다.
- 주요 미해결: 제한자금과 운영비 부족/약정 관계, 완료통행 과금 시점, 고정 공기와 입찰 평가, 동일 사업·신규 사실, OD/수송량의 시간 단위, 자정 명령 순서, 승인된 최소 검수 데이터, 성능·세션 범위.
- 개발 결정: 안정 ID/참조 검증, 정수 시각·고정 계산 경계, 사업별 약정 갱신, 상태/명령 중복 방지, 로그 재현, 시뮬레이션·연출 분리. 게임 정책 선택과 구별했다.
- Gate 1 및 8개 MVP 영역 변경 없음. G2-Q01~08 추천 정책을 확정하지 않음. MUST 11개 및 VP-01/02 유지.
- 규모: 행정 구조의 불확실성 감소. OD·완료통행·자금예약·시험 재시도·시각 피드백으로 M/L 내부 구현·검증량 증가. 확정 인일·일정은 미산정.

## 변경 파일

| 파일 | 변경 | 목적 |
| --- | --- | --- |
| `tasks/DEV-004_GATE2_SECOND_REVIEW.md` | 신규 | Owner 지시·권한·범위·수용 기준 기록 |
| `docs/engineering/reviews/DEV-004_GATE2_SECOND_REVIEW.md` | 신규 | 검토 ID별 회신, 통합 RFC, 기술 결정, 규모·의존성 및 다음 단계 조건 |
| `tasks/DEV-004_RESULT.md` | 신규 | 본 검증·제출 보고 |

기획 원문, 이전 회신, 게임 코드, 프로젝트 설정, 정책/훅/CI는 수정하지 않았다. 작업 전 main clean, 원격 fetch 후 main/HEAD/검토 기준 SHA가 일치했으며 기존 DEV 번호·브랜치·작업 트리를 조사하고 새 DEV-004 브랜치를 생성했다.

## 검증 명령·증거

| 항목 | 명령 / 방법 | 결과 |
| --- | --- | --- |
| 원격 기준·규칙 | GitHub fetch_file로 기준 SHA의 AGENTS·engineering 규칙·C/D·기획 결과·Gate 1 A/B·Owner 원문 읽기, `git fetch origin`, `git rev-parse HEAD` | PASS, 기준 `e18b047...` 확인 |
| 1차 회신 출처 | `Get-FileHash -Algorithm SHA256`로 Downloads 원본 확인 | PASS, `27cb0f025f4ad11b819533c1affa32a4562664586713685489de9606b9caf2b8`, 기획 제출 보고와 일치 |
| 로컬 훅·도구 | `.venv/Scripts/python.exe tools/policy.py doctor` | PASS. 원격 보호나 Owner 승인 진위를 대신 검증하지 않음 |
| 정책 검사 | `.venv/Scripts/python.exe tools/policy.py check` | PASS. 게임 GDScript 0개 |
| 정책 도구 자동 테스트 | `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v` | PASS, 19개. 최초 샌드박스 실행은 임시 `.git/config` 쓰기 제한으로 2개 ERROR; 승인된 권한으로 동일 명령 재실행 후 19/19 OK |
| 문서 검산 | Python Fraction/정수 연산으로 C 장부·OD 예시, TD-03 예약 갱신, F-01/F-05 반례의 값 검증 | PASS. 문서 산술이며 게임 자동 테스트 아님 |
| 문서 구조·참조 | UTF-8/BOM 없음·LF·개행, DEV-R01~08 상태 8개, F-01~08·TD-01~06 존재, 상대 링크 목적지·고정 SHA/행 링크 범위 확인 | PASS |
| 보존·공백 | `git diff --exit-code e18b047848108383acdcef47250ee81393df2058 -- docs/planning project.godot`, `git diff --check` 및 스테이징 diff 검토 | PASS, 대상 원문·설정 변경 없음 |

도구 테스트 중 출력되는 `bad_script.gd` 문법 오류는 잘못된 staged 코드를 검사기가 거부하는지 확인하는 테스트의 예상 출력이다. 실제 게임 코드 오류나 실패 은폐가 아니다.

문서 산술 재검증 값:

- C §5-5: `(총현금, 제한잔액, 자유자금, 손익) = (127, 20, 107, 27)`.
- C §5-7: `(예상, 요청, 탑승, 미탑승, 예시 운임) = (50, 10, 8, 2, 8000)`. 완료통행 시점 가정의 부족은 F-02로 별도 보고.
- TD-03: 기성90 후 `(C,R,F,K,A)=(90,0,90,20,70)`, 기성20 후 `(70,0,70,0,70)`.
- F-01 반례: `C=20, R=20`에서 운영비3을 단순 현금 차감하면 `F=-3`.
- F-05 반례: `min(10,8)=8`, 호출마다 용량8을 재부여하면 `min(5,8)+min(5,8)=10`.

## 실행 검증의 한계

- 게임 자동 테스트: NOT_RUN — 게임 기능을 구현하거나 변경하지 않음. 위 19개는 저장소 정책 도구 테스트다.
- Godot 프로젝트 로드: NOT_RUN — 문서 전용 변경.
- 게임 플레이 / Windows 빌드 / 성능 측정: NOT_RUN — 이번 검토 범위에서 실행하지 않음.
- 예시 산술·정책 검사·CI 통과는 경제 구현, 두 E2E 플레이, Gate 2 승인 또는 성능 보장의 증거가 아니다.

## 수용 기준·Git 제출

티켓 수용 기준 1~4는 본 검토 보고서의 ID 추적·RFC·기술 결정·규모 비교로 충족했다. 기준 5의 최종 판정과 검증은 이 보고서에 기록하며, 실제 커밋 SHA·PR 링크·최신 head의 `policy`/`department-policy` 결과는 생성 후 PR 본문과 최종 채팅에 기록한다. 이는 제출 전 문서에 미래 CI 성공을 미리 기입하지 않기 위한 구분이다.

- 커밋/PR 제목: `[DEV][docs] DEV-004 Gate 2 개정 기획서의 2차 개발 검토를 제출합니다`
- 승인된 작업 브랜치의 일반 push 및 PR만 수행. main 직접 push·병합·릴리스·강제 push 금지 유지.
- 문서 보고 상태: REVIEW. HQ 통합 검수와 Owner 정책·병합 결정은 대기.
- 미해결/RFC: 보고서 3절 RFC-DEV-004-01. Planning의 상세 명세 보완과 Owner의 정책 결정 필요.
- 명세 변경 필요: 후속 C/D의 미결정 연결 규칙·검수 입력 보완 필요. Gate 1·8개 영역 변경 필요 없음.

## 동시 main 갱신 대응

첫 브랜치 `codex/DEV-004-gate2-second-review`의 `2d1c0cd1043b9d038ed73a7562f32c4214e8dedd`를 푸시하고 PR #8을 작성하는 동안, main에 HQ의 PM-005 보고서 2개가 `68f8aee...`로 추가되었다. `git diff --name-status e18b047848108383acdcef47250ee81393df2058 origin/main`으로 확인했으며 기획 검토 대상·정책·게임 코드에는 변경이 없었다.

공유 브랜치 amend/rebase/force push 또는 main merge를 하지 않고, 규칙에 따라 최신 main의 대체 브랜치에 기존 검토 커밋을 cherry-pick했다. 검토 내용은 동일하며 이 절과 티켓의 제출 브랜치·기준만 보완한다. PR #8은 대체 관계를 기록하고 닫으며, 최종 대체 PR 및 최신 head 검사 결과를 제출 응답과 PR 본문에 기록한다. 다른 부서의 문서는 보존한다.
