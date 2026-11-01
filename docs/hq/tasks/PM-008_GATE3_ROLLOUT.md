# PM-008 — Gate 3 협업 운영 규정 및 병렬 착수 요청서 제출

- 작업 ID: PM-008 / 담당: HQ(PM) / 2026-11-01 / 상태: REVIEW
- 기준 main: `fc283b7bbf0cbb1e63dac9af8dbe663e3862330e`
- Owner 지시 근거: 2026-11-01 HQ 대화에서 8개 Gate 3 운영 원칙을 명시 승인하고, 이어 **A안 단계적 전환** 승인 및 “PM-008 운영 규정과 부서별 최초 요청서의 문서 제출을 준비하고, 원격 Commit/Push/PR 및 공통 규정 변경은 정해진 승인 범위에 따라 진행” 요청.
- Commit/작업 브랜치 업로드/PR 범위: **HQ 소관 신규 문서만** `docs/hq/` 아래 생성하여 Owner 검수 요청. Owner 최종 Merge·릴리스 승인 없음. 공통 정책·타 부서 파일 수정 권한 없음.
- 브랜치: `codex/PM-008-gate3-operating-rollout`; 실행 이후 PR/commit 결과는 PR 메타데이터와 별도 HQ 보고에서 확인.

## 제출
- [PM-008 운영 기준](../PM-008.md)
- [Planning 최초 요청](../requests/PM-008-PLN.md)
- [Design 최초 요청](../requests/PM-008-DSG.md)
- [Development 최초 요청](../requests/PM-008-DEV.md)
- [Git 규칙 차이·이관](../PM-008-GIT.md)
- [PM-008_RESULT](PM-008_RESULT.md)

## 포함
8개 승인 원칙 및 A안, Gate 2 기준선과 3개 부서 병렬 분석, Issues/PR 경량 기록, L1/L2/L3, Owner의 제한적 티켓별 위임, 최소 Markdown 티켓+필수 CI 보존, HQ 전문 영역 경계, 첫 Stage 시범 평가.

## 제외
타 부서 업무의 정식 티켓 생성/내용 결정, 실제 Godot 코드·아트 제작, 공통 Git 정책·CI 수정, main Merge/릴리스, 포괄 권한 위임.

## 완료 기준
1. 승인된 정책과 아직 승인되지 않은 구현·공통 규정 변경을 구별한다.
2. 첫 요청서 3개가 동일 Gate 2 기준으로 **병렬** 제출될 수 있다.
3. Git 권한 위임이 개별 승인 티켓 범위를 넘어 확장되지 않는다.
4. 부서별 Review/Issue 기록과 현재 Markdown 티켓·두 CI가 공존할 수 있다.
5. HQ 경로 변경만 있는 PR, CI 확인 및 Owner 검수 요청으로 종료한다.
