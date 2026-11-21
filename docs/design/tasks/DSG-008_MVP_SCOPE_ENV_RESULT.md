> **현재 후속 — 2026-11-22:** Owner가 S1/E1/F1/N1/A1/P1 권고 묶음을 모두 선택하고 판단을 포함한 PR 생성을 요청했다. **OWNER_SELECTED_ALL_RECOMMENDED / FINAL_SPEC_PENDING / F08_OPEN**. 아래 MVP_OPTIONS_UNSELECTED·로컬 미제출은 당시 이력이다. 현재 제출 근거와 잔여는 §7을 따른다.

# DSG-008 — MVP 규격 범위·지원 환경 선택안 로컬 결과

- Design Track B / AGT-DSG-0003 / 2026-11-22 / v0.1.
- **LOCAL_REVIEW_REQUESTED / MVP_OPTIONS_UNSELECTED / O01_O07_OWNER_DIRECTION_APPROVED / FINAL_SPEC_PENDING / F08_OPEN**.
- 기준 `1a941196cc6d963db93a9fba6a0386b16710aa46` (PR161 main).

## 1. 요청·범위

Owner 요청: “우선 MVP에서 확정할 규격 범위와 지원 환경에 대한 Owner 선택안을 정리해주세요. 폰트·전체 이름·아트의 공급 조건과 부서별 선행 작업·최소 검증 범위를 포함하고, 기존 O-01~07 승인을 보존하며 최종 규격 미확정·PARTIAL·NOT_RUN을 구분해 로컬 산출물로 먼저 검토 요청해주세요.”

실행은 로컬 문서 작성·정적 대조만이다. 제품·폰트 반입·실제 아트 제작·이름 작명·환경/OS 설정 변경·신규 실험·Git/외부 게시는 승인되지 않았다. 현재 별도 브랜치 `codex/DSG-008-mvp-scope-environment`의 격리 worktree에서 준비한다.

## 2. 산출물4개

| 파일 | 결과 |
| --- | --- |
| [MVP 범위·환경 Owner 선택안](DSG-008_MVP_SCOPE_ENV_OWNER_OPTIONS.md) | MV-S/E/F/N/A/P의 권고/대안·대가·선택 양식. 모든 MV는 미선택, O01~07은 승인 완료로 분리 |
| [공급·선행 작업·최소 검증안](DSG-008_MVP_SUPPLY_VALIDATION_PLAN.md) | 환경·폰트·전체 이름·아트 공급 조건, 부서별 순서, 조건부 V01~07·M01~05 및 권한 경계 |
| 이 결과서 | 근거·변경/검증·미결/NOT_RUN·검토 요청 |
| [출처 선언](DSG-008_PROVENANCE.json) | 이번 신규 Markdown3개만 기준 SHA·현재 blob으로 선언. 기존 main manifest는 Git 원본으로 보존. REPORT_ONLY/승인·신원 인증 아님 |

과거 선택안·공통표·실험 심사·승인/검증·DEV/Track A 원문은 수정하지 않았다. 공통표 v0.2를 담은 PR162는 확인 시점 **OPEN/미병합**이며 이번 선택안에 섞어 main 승인본으로 승격하지 않는다. 같은 DSG008의 독립 문서 후속이고 PR162를 대체하지 않는다. 향후 제출 시 최신 main과 승인된 자기 변경/manifest를 다시 대조해야 하며 현재 Git 제출은 하지 않는다.

## 3. 근거·기존 결정 보존

- [O01~07 Owner 승인](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057405335), [승인 방향 후속](DSG-008_F08_OWNER_OPTIONS.md), [PM021 Track B 요청](../../hq/requests/PM-020_DESIGN_B_STAGE3.md).
- [DEV 회신](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057935798)·[DEV027 계획 §12](../../engineering/gate3/DEV-027_EXECUTION_VALIDATION_PLAN.md#12-pm-021-후속--f-08-공통-적용표의-dev-검토안)·[Track A 검토 완료](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057978655). 준비 경계 이견 없음·현재 추가 GUI 요청 없음은 유효하다. 새 선택안이 실제 변경 행을 정하기 전 같은 검수를 반복하지 않는다.
- [DSG006 결과](DSG-006_RESULT.md)·[공용 원본 보관 준비](DSG-006_VISUAL_ARCHIVE_PREPARATION.md)·[DSG007 시스템](DSG-007_MVP_DESIGN_SYSTEM.md)·[DEV025 심사](DSG-008_DEV025_DESIGN_REVIEW.md). 디오라마 MVP 방향·추후 대규모 재배치/콘셉트 개편 가능성·정적 원본/제품 적용의 차이를 유지한다.

권고는 한정 환경에서 정보·행동·가독성 우선 규격을 준비하고 후보/공급을 좁히는 것이다. 새 MV 선택 승인이나 최종 치수/폰트/지원 수치가 아니다. E1의 OS/배율·창 값은 검증 후보다. 기준 PC 프로파일을 실제 공급받지 않았으며 Windows11/유효 DPI/작업영역 적합성을 인증하지 않는다.

## 4. 상태 구분

| 구분 | 현재 상태 |
| --- | --- |
| 기존 완료 | O01~07 방향 승인·DEV025 기술 공급/#97 종료·기존 RD 심사·DEV/Track A 준비 경계 확인·DEV026 현재 공급/P07 구분 승인 보존 |
| 신규 선택 | MV-S/E/F/N/A/P 전부 **미선택**. 권고 묶음 S1/E1/F1/N1/A1/P1은 제안 |
| 최종 규격/F08 | **FINAL_SPEC_PENDING / F08-01~04 OPEN**. 폰트/권리 구성·지원 환경/창·실제 아트/필터·이름/목록·재사용 적용·성능 미확정. O02/O07 이월 방향은 승인 완료 |
| PARTIAL/INCONCLUSIVE | B 포커스 가시성·합성 마커 겹침, DEV026 고정일1 비영점 중첩 복귀·내부 수명/옛 callback 추가 OS 가시성 한계 보존. 한정 수용과 추가 관측 부족을 구분 |
| 이번 NOT_RUN | 게임 자동검사·Godot 로드·GUI/독립 입력·게임 플레이·DEV025 재실험·폰트 반입/설치/실물 구성·대상PC/DPI 인수·프로파일·빌드/export·외부 사용성 검증 |
| NOT_VERIFIED | 실제 기준 PC 환경/유효 DPI·제한 raw 직접 재해시·신원·선택 폰트 바이트/배포 구성. 문서상의 후보/DEV 조사와 실측 구분 |
| 인수/권한 | 새 선택/구현/실험·원격 전달·Git 승인 대기. W04B 실제 공급/L2·S3-10-C·S3-12/Stage 최종 인수 별도. 게임 규칙/경제/시간/세이브 변경 요구 없음 |

## 5. 로컬 검증·보존

공유 main의 기존 데이터2개 변경과 다른 worktree는 보존한다. 이번 변경은 디자인4파일(신규 Markdown3개+기존 provenance 갱신)뿐이며 제품/설정/테스트·타 부서/정책은 수정하지 않는다. 명령: 루트 venv Python으로 `tools/policy.py doctor`/`check`, `git diff --check`, UTF-8/LF·상대 파일 링크·O7 승인/신규 선택 미선택·기존 파일 불변·출처 blob 검사.

검증 결과: doctor PASS / check PASS(exit0, worktree735개·GDScript57개) / git diff --check PASS. UTF-8/LF·상대 파일 링크·MV6개 미선택·O01~07 승인 참조·기존 문서 불변·출처3개 blob 대조 PASS. 작업 트리 `.local/validation/mvp-scope-env/audit.json`에 정적 감사 결과를 보관한다. 게임/GUI 실행 또는 환경/권리 인증은 아니다. 커밋하지 않아 preflight·새 원격 CI는 NOT_RUN이다.

## 6. 로컬 검토 요청

Owner에게 MV 선택 범위·지원 환경 후보의 적절성, 공급 담당/조건·최소 검증의 충분성을 검토 요청한다. 지금 선택 가능하며 구체값이 아직 없는 항목은 선행 공급을 요청할 수 있는 양식이다. 이번 검토 요청을 제품 구현/실험·폰트 반입·Git·main 병합 승인이나 F08 전체 확정 요청으로 해석하지 않는다. 일정은 NOT_ESTIMATED다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008

## 7. Owner 결정·PR 제출 승인 후속

[선택안 §7](DSG-008_MVP_SCOPE_ENV_OWNER_OPTIONS.md#7-owner-결정제출-후속--2026-11-22)에 Owner 원문과 6개 선택 결과를 기록했다. 현재 요청은 “OWNER의 판단을 포함하여 PR을 생성해주세요 / 모두 권고안대로 선택하겠습니다”이며 이 선택 결정·공급/검증 계획·결과/출처4개를 현재 작업 브랜치에서 커밋·일반 푸시·PR로 제출한다. 대상 저장소 wisberry2022/MetroManager, 작업 DSG008. main 병합은 별도 승인 대상으로 유지한다.

기존 O01~07 승인·최초 로컬 선택안3개 원문·미실행/검증 기록은 보존했다. 새 선택6개는 대기 해소이며 **구체 폰트·지원 최소값/DPI·이름/아트 공급·제품 적용·FPS 확정은 아니다**. 기준 PC 제공자/실측 사양·현용 배율·이름 콘텐츠 담당/실제 목록·검토용/제한 배포 목적은 NOT_SUPPLIED. 필요한 시점에 해당 입력만 확인하며 같은 선택을 재요청하지 않는다.

제출 전 fetch 기준 origin/main은 `1a941196cc6d963db93a9fba6a0386b16710aa46`로 작업 base와 동일하다. 정상 훅·doctor/check·원문 포함/선택6행·출처 blob을 검증하고 커밋 후 preflight 및 실제 head의 원격 policy/department-policy·REPORT_ONLY 진단을 PR에서 보고한다. 이번 제출 검사와 최초 로컬 검증을 구분한다.

남은 F08 미결·PARTIAL/INCONCLUSIVE·제품 검증 NOT_RUN·물리 DPI/신원 NOT_VERIFIED·S3-10-C/S3-12/Stage 인수 경계를 유지한다. 제품/설정/테스트·타 부서 파일 변경0, 새 게임 규칙 변경 요구 없음. 이슈 댓글·제품 구현/시험·폰트 다운로드/반입·OS 설정 변경·main 병합·릴리스/배포는 수행하지 않는다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008
