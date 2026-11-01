# DSG-002 — Gate 3-0 디자인팀 최초 작업 분해 및 분석 제출

- 작업 ID: `DSG-002`
- 담당: Design / Art Director & UI/UX Designer
- 상태: **REVIEW — Owner/HQ 검수 요청** / 2026-11-01
- Issue: [#24](https://github.com/wisberry2022/MetroManager/issues/24)
- 기준 저장소/커밋: `wisberry2022/MetroManager` / `ca597ec541647aa2e9701ec93972e8763eae066d`
- Gate 2 공식 원본: `PLN-001-C.md` v0.6, `PLN-001-D.md` v0.9, DATA v1.3, `PLN-001_GATE2_FINAL_APPROVAL.md`
- HQ 요청: [PM-008-DSG](../../hq/requests/PM-008-DSG.md) / 운영: [PM-008](../../hq/PM-008.md)
- Owner 원문: “변경된 프로세스를 준수하여 Gate2에서 디자이너의 업무를 착수해주시기 바랍니다.” (Gate 2 승인본 기준 Gate 3-0 분석 착수), 이후 “디자이너 에이전트 PR 생성해주시기 바랍니다.” (기존 DSG-002 분석 산출물의 PR 제출)
- 제출 브랜치: `codex/DSG-002-gate3-design-analysis`
- 권한 범위: `docs/design/` 아래 **이 티켓과 분석 결과 2파일의 작업 브랜치 Commit/Push·PR 제출**에 한정. 실제 아트 제작, 타 부서 수정, main 직접 쓰기·병합, 릴리스는 제외.

## 목적과 포함 범위

1. 공통 지도 셸과 4구·8동·후보역12·노선당6~8역 조작/관할/오류 상태를 화면 기능/AC에 연결한다.
2. 두 사업 경로, 공사·안전·운영, C/R/F/K/A/B, 날짜별 보고의 상태 UI·재사용 컴포넌트를 분해한다.
3. DD-01~08 및 기존 에셋 제안의 **설계 패턴 재사용**과 실제 신규 이미지 제작 필요를 구분한다.
4. 개발팀과 교차 협의할 의미 데이터·기준시각·허용행동·값 없음/0·성능/기기 규격을 `UI-DC-01~08`로 추적한다.
5. L1/L2/L3 영향, 선행/병렬성, 화면 가독성·오류 복구·검증 증거를 HQ에 제시한다.

## 산출물

- 이 티켓: `docs/design/tasks/DSG-002_GATE3_ANALYSIS.md`
- 결과 보고: [DSG-002_RESULT.md](DSG-002_RESULT.md)
- 추적 Issue: [#24](https://github.com/wisberry2022/MetroManager/issues/24)

## 완료 조건 및 품질 경계

- [x] 정적 문서·Git 트리 검토, 화면/컴포넌트 10개 묶음과 연결 AC/VP 명시
- [x] 기존 디자인 패턴 재사용과 미제작 실제 에셋 구분
- [x] UI 데이터 의미 계약 8개, L2 의존성·HQ 결정 요청 명시
- [x] 디자인팀 소관 문서 2개만 대상으로 PR 제출 요청
- [ ] HQ/Owner 리뷰 및 Gate 3 Stage 반영/산출물 수용
- [ ] 실제 UI 목업·픽셀 에셋 제작·사용성 테스트 (별도 실행 티켓/승인)
- [ ] 대상 PC/뷰포트/FPS/연출 상한 합의 및 개발팀 입력 계약 확정

## 검증 / 이슈

- 문서 내용 및 링크/범위 정적 대조: **DONE**
- 자동 정책 CI: **PR head에서 원격 결과 확인 필요**
- 로컬 훅, `tools/policy.py doctor/check`: **NOT_RUN** (GitHub API 제출)
- Godot 로드, 게임 플레이, 자동 테스트, Windows 빌드, FPS 및 사용자 사용성: **NOT_RUN**
- 디자인 규격·실제 제작 및 실사용 검증: **NOT_STARTED**
- 수정 필요 조건: 기획 변경·UI 의미 데이터 계약 불일치·성능 제약은 관련 부서 검토, 중대한 정책 변경은 HQ/Owner 상정.
