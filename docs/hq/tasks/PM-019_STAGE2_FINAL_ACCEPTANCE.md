# PM-019 — Stage 2 수용·종료 연결과 최종 인수 정리

- 담당: HQ / AGT-PM-0002 / 2026-11-15 (Asia/Seoul).
- 상태: `OWNER_COMMIT_PUSH_PR_APPROVED / REVIEW / MAIN_MERGE_PENDING`.
- 저장소: wisberry2022/MetroManager / 기준 main `f925cba4705ad02517f0562f1346df1da1e08462`.
- 브랜치: `codex/PM-019-stage2-final-acceptance`.
- 관련: [#141](https://github.com/wisberry2022/MetroManager/issues/141), [S2 통합 인수표](../STAGE2_ACCEPTANCE_MATRIX.md), [결과](PM-019_RESULT.md).

## 요청과 승인 범위

Owner의 현재 HQ 대화 원문:

> PM 에이전트. Issue #141의 후속 조치를 진행해주세요. 이번 수용·종료 결과를 S2 통합 인수표에 반영하고, Stage2 최종 인수를 위한 잔여·이월 사항을 정리하여 PR을 생성해주세요. 해당 작업의 커밋·푸시·PR 생성을 승인합니다.

대상은 위 저장소·PM-019·HQ 담당·위 작업 브랜치이며, 아래5개 HQ 파일의 작성·검증·Commit·Push·PR까지 이번 제출에 한정한다. main 병합·릴리스·배포·게임/정책 변경·Stage DONE·DEV-026 HOLD 해제는 포함하지 않는다. Issue의 기존 수용·종료는 [#140 Owner 위임 기록](https://github.com/wisberry2022/MetroManager/issues/140#issuecomment-6891427272)과 Design/INF 수용 기록을 재사용한다. 기존 유효 승인이나 수용을 새 미결로 돌리지 않는다.

## 포함·제외 및 산출물

| 파일 | 변경 목적 |
| --- | --- |
| `docs/hq/STAGE2_ACCEPTANCE_MATRIX.md` | S2-01~11의 최신 수용·개발 종료·DOC-01/Q12 정정·#141 F01~04 및 이월/최종 결정 연결 |
| `docs/hq/README.md` | 최신 통합 현황 진입점 |
| `docs/hq/tasks/PM-019_STAGE2_FINAL_ACCEPTANCE.md` | 본 티켓·Owner 원문·범위 |
| `docs/hq/tasks/PM-019_RESULT.md` | 실제 검증·미실행·미확인·후속 |
| `docs/hq/tasks/PM-019_PROVENANCE.json` | 4개 비자기참조 산출물의 base/blob·작성자 선언; REPORT_ONLY |

DEV-024 1115A(`0865e5a2cdf168dac14167922c9e59b16796fa81`) 자연 경로와1115B(`324faf9b7d81540240217d2757f26de6f07460ba`) MODEL_CHAIN_SETUP 후 실제 입력 보완을 분리한다. F1~F3·기존24조건/Q12 등의 수용을 유지한다. 정정 연결 완료와 과거 미포착, 로컬 읽기와 백업 복구를 구별한다.

타 부서 문서·소스·테스트·CI·정책 수정은 제외한다. 새 GUI/자동게임검사/로드/빌드·비공개 ZIP 업로드/재해시·백업 생성/복구는 이 작업에 포함하지 않는다. F-08 실제 실험은 PR #143 제출 결과를 연결하고 최종 Design/규격은 미완료로 유지한다. #139의 Owner 정본/보관 담당 결정과 명시적 백업 이월을 반영한다.

## 제출·수용 조건

1. 공식 Issue 상태·원문·SHA·실행/제출 승인·CI·제품 영향 비교를 연결한다. 알려지지 않은 과거 원문은 NOT_VERIFIED로 남긴다.
2. #141 F01/F02의 실제 수용 근거와 F03/F04의 문서 반영 위치를 구별한다. Stage 최종 수용과 문서 PR 제출을 동일시하지 않는다.
3. 격리 사본·고정 의존성·정상 훅 설정에서 doctor/check·문서/출처 대조·diff 검사. API 제출 후 원격 부모/tree/blob 대조·fetch/preflight·제출 head의 policy/department-policy 확인. API 로컬 훅 실행은 NOT_RUN으로 구분한다.
4. Owner main 병합 승인 이후 반영 SHA를 확인한다. Stage 최종 결정은 별도로 기록하며 자동 close 키워드로 #141을 종료하지 않는다.

공유 작업 트리·기존 파일을 보존한다. 게임 명세 변경 필요 없음. 신규 에이전트 신원/권한을 본 출처 선언으로 인증하지 않는다.
