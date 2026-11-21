# PM-021 — Stage 3 F-08 방향 승인·부서 후속 반영

- 담당: HQ / AGT-PM-0002 / 2026-11-21 (Asia/Seoul).
- 상태: **OWNER_DOCUMENT_GIT_APPROVED / REVIEW / MAIN_MERGE_PENDING**.
- 저장소: wisberry2022/MetroManager. 기준 main `74cd75045feb1369aa429feaec64fd3558c14813`.
- 브랜치: `codex/PM-021-stage3-f08-directions`.
- 산출물: [실행 계획·S3 인수표](../PM-020_STAGE3_EXECUTION_PLAN.md), 부서 요청서6개, [결과](PM-021_RESULT.md), [출처 선언](PM-021_PROVENANCE.json).

## Owner 요청과 승인 범위

현재 HQ 대화의 이번 원문:

> PM 에이전트. 이번 O-01~07 방향 승인과 부서별 후속 업무를 Stage3 실행 계획 및 인수표에 반영하여 PR을 생성해주세요. 최종 규격 미확정 사항은 별도로 유지하고, 해당 작업의 커밋·푸시·PR 생성을 승인합니다.

정책 선택은 이미 [#92에 기록된 Owner 결정](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335)으로 완료됐다. 이번 요청은 해당 결정을 HQ 문서에 반영할 작성·Commit·Push·PR 승인이다. 위 저장소/PM-021/브랜치/아래 HQ 경로에 한정하며 이번 제출과 같은 범위 검수 대응 또는 Owner 철회까지 유효하다. main 병합·Issue 변경/종료·타 부서 파일/제품 변경·폰트 반입·실험·릴리스·배포·타 채팅 메시지 발송은 포함하지 않는다. 같은 방향 선택의 재승인 절차를 만들지 않는다.

## 포함·제외와 수용 기준

- 계획 §2.2에 O-01~07 승인 방향/최종 규격 잔여, §6에 S3-10 현재 상태·하위 인수/적용 시점표를 반영한다. S3-10 전체 PASS·F-08 종료·Stage DONE을 선언하지 않는다.
- DEV·Track B 공통 적용표와 Track A 영향 행, Planning의 실제 의미 차이만, Convention/INF의 필요 시 지원을 요청서6개에 연결한다. 기존 유효 권한·증거를 재사용하고 부족한 실제 범위만 제출한다.
- #97 기술 종료·PR #157 심사와 DEV-026 Owner 한정 수용/PR #158을 현재 맥락으로 연결한다. 원본 PARTIAL·미관측·W04B 미래 공급·S3-12 상위 인수 대기를 보존한다. W04B 전체 진척의 재평가·신규 규칙/기술 구조 확정은 제외한다.
- A 우선/B 조건부, O-02/07 수치 결정 시점 보류, M-01~05의 적용 조건을 지킨다. 전면 재검수·새 벤치마크·전면 리팩터링을 추가하지 않는다.
- HQ README와 본 티켓/결과/REPORT_ONLY 출처를 포함한다. 11파일 모두 docs/hq/ 아래이며 기존 PM-020 티켓/결과·과거 저자·타 부서 원본·S2 원본은 보존한다.

변경 경로: `docs/hq/PM-020_STAGE3_EXECUTION_PLAN.md`, `docs/hq/README.md`, `docs/hq/requests/PM-020_{DEVELOPMENT,PLANNING,DESIGN_A,DESIGN_B,INFRA,CONVENTION}_STAGE3.md`, `docs/hq/tasks/PM-021_STAGE3_F08_DIRECTIONS.md`, `PM-021_RESULT.md`, `PM-021_PROVENANCE.json`(마지막 두 파일도 동일 tasks/ 경로).

## 검증과 경계

최신 main/Owner 댓글·원본 선택안/M 조건·담당 등록을 대조한다. doctor/check·diff·문서 상대 링크/표·정확한 경로·출처 blob·정상 훅·fetch/preflight 및 실제 PR head의 필수 CI를 확인한다. 출처 REPORT_ONLY는 신원/승인 인증이 아니다. 새 게임 자동검사·Godot 로드·GUI·프로파일·빌드/export는 NOT_RUN, 비공개 원본 재해시는 NOT_VERIFIED. 게임/경제/시간/세이브 명세 변경 필요 NONE.

공유 main의 기존 데이터2개 미커밋 변경을 보존하고 HQ 전용 격리 사본의 최신 origin/main에서 작업한다. PM-021은 해당 base HQ 티켓에 사용되지 않은 번호이며 타 부서 티켓을 발급하지 않는다.
