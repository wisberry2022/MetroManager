# PM-021 — Stage 3 F-08 승인 반영 결과

- HQ / AGT-PM-0002 / 2026-11-21 / **REVIEW / MAIN_MERGE_PENDING**.
- 기준 main `74cd75045feb1369aa429feaec64fd3558c14813`. [Owner 승인·범위](PM-021_STAGE3_F08_DIRECTIONS.md), [계획·S3 통합 인수표](../PM-020_STAGE3_EXECUTION_PLAN.md).

## 결과

O-01~07 방향 승인을 완료 상태로 연결하고 최종 규격·제품 적용/검증을 별도로 남겼다. S3-10-D/R의 결정·심사 완료와 A/M01~05/O06/C의 실제 적용 전제/잔여를 분리했다. 일정은 적용 조건으로 특정하고 공수·날짜를 생성하지 않았다. 부서 요청6개는 Track B·DEV 공통 적용표, Track A 공동 증거, Planning/Convention/INF의 실제 필요 범위만 연결한다.

#97 종료·PR #157 심사·[Owner 결정](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335)·DEV-026 한정 수용/PR #158을 반영한다. #92 OPEN/FINAL_SPEC_PENDING, 원본 PARTIAL·미관측·W04B 미래 공급·S3-12/Stage 최종 인수 대기는 유지한다. 기존 초기 NOT_RUN은 후속 실행·수용을 취소하는 상태로 쓰지 않는다. 이번 변경은 HQ 문서11개이며 게임/타 부서 문서·S2 원본·과거 PM-020 티켓/결과는 변경하지 않았다.

## 검증 기록

- 원격 근거·Owner 댓글·선택안7행·M-01~05·등록 역할: 대조 완료. 기준 main과 PR #158 문서 병합은 새 게임 시험본이 아니다.
- `tools/policy.py doctor`, `tools/policy.py check`, `git diff --check`: PASS. 정상 훅/도구·문서/코드 형식 검사이며 게임 자동검사가 아니다.
- 문서 정적 대조: HQ 11경로, 상대 링크/절 98개, 표10개, O 결정7행·S3 기준12행, UTF-8/LF·출처10개 산출물의 base/blob 대조 PASS. 로컬 감사 기록은 `.local/pm021_audit.json`이며 공개 원본 증거를 대체하지 않는다.
- 커밋 후 preflight·REPORT_ONLY 진단과 실제 PR head의 원격 필수 CI는 제출 PR 본문에 연결한다. PR 생성 전 상태를 CI PASS/게시 완료로 앞당겨 쓰지 않는다.
- 신규 게임 자동검사 / Godot 프로젝트 로드 / 실제 GUI·독립 입력 / 프로파일 / Windows 빌드·export: **NOT_RUN** (HQ 문서 변경).
- 비공개 raw 증거 재해시·물리 신원/DPI: **NOT_VERIFIED**. 이전 실패·미포착·출처 보고의 한계 보존.

## 잔여

Track B·DEV의 실제 적용표, 최종 폰트/지원 창·배율/역할별 필터/배치·치수/성능 목표와 실제 제품 적용·영향 행 검증은 별도다. O-02/O-07의 결정 시점 보류는 승인 완료한 방향이며 같은 선택을 다시 묻지 않는다. S3-10 통합 수용·S3-12·Stage 최종 결정 및 이번 PR main 병합은 별도다. 게임 명세 변경 필요 **NONE**. 이 문서의 제출은 자동 DONE이 아니다.
