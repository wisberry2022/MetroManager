# DSG-003 — Stage 1 S01 최소 UI 정보 구조·상태 설계 결과 (초안)

- **문서 ID:** DSG-003-RESULT / **버전:** v0.1 / REVIEW / **작성:** 2026-11-01
- **담당:** Design / Art Director & UI/UX Designer
- **Issue:** [#46](https://github.com/wisberry2022/MetroManager/issues/46) / 이전 분석 [#24](https://github.com/wisberry2022/MetroManager/issues/24)
- **상태:** `DESIGN_STATIC_REVIEWED / PR_REVIEW / GAME_GUI_NOT_RUN` (실제 통합 검증 아님)
- **승인 범위:** Owner “DSG-003 작업 개시를 승인합니다.”(설계 착수), 후속 “디자이너 에이전트. 공식 산출물 제출 승인합니다 PR 생성해주세요.”(이번 DSG-003 디자인 문서 2개의 Commit·Push·PR 및 CI 확인). 메인 병합·릴리스·타 부서 수정/아트 파일 제작은 승인 범위 밖.
- **원격 기준:** `main` `1356c4b2ec824ca51e807bd9754a891aaa57e13d` / [PM-011-DSG](https://github.com/wisberry2022/MetroManager/blob/1356c4b2ec824ca51e807bd9754a891aaa57e13d/docs/hq/requests/PM-011_DESIGN_KICKOFF.md)
- **설계 본문:** [DSG-003_STAGE1_S01_IA.md](DSG-003_STAGE1_S01_IA.md)

## 1. 산출물·완료한 설계 항목

| ID | 산출물 내용 | 판정 |
|---|---|---|
| S01-A | 상단 HUD: 회사/게임일·시각/정지·재개·1·2·4배속 조작의 표시·허용/거부 상태 | **설계 초안 작성** |
| S01-B/F | 중앙 지도 및 역/예측 영역은 DSG-004 소관 자리표시자로 한정 | **책임 분리** |
| S01-C | 총 현금 C, 제한 R, 자유 F, 예약 K, 신규약정 가용 A, 미지급 B를 **읽기 전용**으로 구분 | **설계 초안 작성** |
| S01-D | 현재 자금과 확정 과거 보고의 일자/출처/값·자료없음 상태 분리 | **설계 초안 작성** |
| S01-E | 0/미제공/오류/잠금/명령 대기/당시 결과/최신 허용 행동 10개 표시 규칙 | **설계 초안 작성** |
| UX 검수 | 초기 상태, 제한자금, 예약보호, 자정, 시간조작, 오류, 오래된 명령, 과거 보고 정적 케이스 8개 | **시나리오 작성** |

## 2. 근거·현재 소관 판단

- Gate 2 승인: 초기 게임일 06:00, 초기 총 현금 1,000,000/제한·예약·미지급 0. 사업별 자금 보호·미지급/정산·T 사건 순서 변경 없음.
- DEV UI v0.2.1: 권위 스냅샷의 `snapshot_revision`, `simulation_minute/day_id`, `observation_phase`, `available/value`, `reason_codes/allowed_actions`; 명령 당시 결과와 현재 행동 구분.
- DSG-002 DD-03/07/08: 상태·원인·다음 행동, 현재/과거 보고, 자료없음/0와 단위·기준시각 구별. 기존 실제 PNG나 완성 UI 컴포넌트는 **없음**.
- HQ PM-011: 첫 Stage W01→W02/W03+최소 조작 UI, 자동 검증·Godot GUI/입력을 각각 실제 검증. 고충실도 에셋·완성 P07·Windows export/VP E2E 등 제외.
- 디자인 자체 판단: **읽기 전용은 재무 숫자의 수정 금지**를 뜻하며 시간 조작(정지/재개/배속) 자체를 비활성화하는 의미가 아님. 실제 허용·효력은 DEV 공급 값 사용.

## 3. 검증 요약

| 항목 | 결과 및 근거 |
|---|---|
| 기준 문서·작업 범위·버전 대조 | **정적 대조 수행** — PM-011-DSG, 승인 Stage 1, DEV 계약, DSG-002, 승인 DATA |
| 마크다운 설계 구성/상태표/케이스 | **DRAFT_PREPARED** — 본문 각 절 및 예시. 실화면 품질 PASS 아님 |
| 실제 저충실도 화면/그림·픽셀 PNG | **NOT_CREATED** — 텍스트 와이어프레임만 작성 |
| 실제 Godot 실행·GUI·입력·자동테스트 | **NOT_RUN** |
| Windows 빌드·FPS·기기·폰트 접근성 실측 | **NOT_RUN** |
| 외부 사용성/VP 독립 실플레이 | **NOT_RUN** |
| 원격 Git Commit·Push·PR, 원격 CI | **PR REVIEW** — 본 제출 PR의 실제 SHA·CI 결과는 GitHub 원격 메타데이터 확인 (별도 기록) |
| Issue 추적 | **CREATED** — #46 (공식 원격 이슈). Git 파일 게시와 별개 |

## 4. 아직 남은 작업·인계

1. **Owner Git 제출 승인 확인:** 저장소 `wisberry2022/MetroManager`; 작업 `DSG-003`; 브랜치 `codex/DSG-003-stage1-s01-lowfi-ia`; 허용 경로 `docs/design/tasks/DSG-003_STAGE1_S01_IA.md`, `docs/design/tasks/DSG-003_RESULT.md`; 이번 단일 목적의 Commit·Push·PR·두 CI 확인. 해당 PR 검수 제출 종료 때 유효 범위 종료. `main` 직접 쓰기·병합/릴리스·개발 소스/타 부서 수정 제외.
2. **W02 UI 통합 전 DEV 공급:** 현재 게임시각/정지·배속 처리 결과·`allowed_actions/reason_codes`, 하나의 안정 snapshot과 C/R/F/K/A/B·고정 보고의 정상/0/없음/오류 fixture. 설계 단계에서 게임 이벤트를 새로 계산하지 않음.
3. **DSG-004 연계:** 중앙 지도/역 목록·예측 최소 소비를 별도 소관 티켓에서 설계. 현재 이 문서는 레이아웃 연결부만 제안.
4. **DSG-005 연계:** 실제 Godot GUI 입력 전/후·명령/스냅샷·화면 녹화/캡처, 역순·중복·잠금/오류 복구, 가독성/접근성·지도 조작을 검수해야 Stage S1-07/08의 부분 수용 근거가 생김.
5. **제품 UI-DC-08/사용성 기준:** 대상 PC/뷰포트·폰트/배율·FPS/표시 상한은 규격 종속 제작 전에, 외부 표본/예산은 모집·집행 전에 DEV+Design→HQ→Owner 결정. 1280×720·40px 등은 미승인 가설.

## 5. 최종 판정

**`DSG003_DESIGN_STATIC_REVIEWED / PR_REVIEW / IMPLEMENTATION_NOT_RUN`.**

저충실도 문서 설계는 정적 검토를 거쳐 공식 PR로 제출한다. PR 등록과 CI PASS는 Stage 1 실제 조작 UI 완료·자동 규칙/GUI 검증 PASS·제품 스펙 승인이 아니며, 최종 문서 병합은 Owner의 별도 결정으로 남긴다.
