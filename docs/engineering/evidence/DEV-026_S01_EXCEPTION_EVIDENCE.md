# DEV-026 — 로컬 구현·검증 증거 색인

> **최신 후속 — 2026-11-21:** [Track B 검수 의견](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7056903693) 수신 / LIMITED_ACCEPTANCE_RECOMMENDED / OVERALL_PARTIAL / OWNER_REVIEW_REQUESTED. PR #153·#154 병합과 현재 공급에 대한 독립 실행·Design 증거 심사 보고를 연결했다. 이는 Owner 최종 수용·RFC 종결·S3-12/DONE이 아니다. 아래 이전 PENDING/HOLD/미커밋 기록은 당시 이력이며 현재 판단과 잔여는 마지막 후속 절을 따른다.

<!-- 이전 본문은 당시 상태로 보존하며 최신 효력은 후속 절을 따른다. -->

> **현재 로컬 후속 — 2026-11-21:** 경로 재지정 승인 적용·기존35개 실패 해소·자동 GUI266/266 PASS. LOCAL_REVIEW / PRODUCT_L2_PENDING. 후속8개 파일은 미커밋이며 Commit·Push·main 병합은 별도 승인이다. 아래 이전 본문의 PARTIAL·승인 대기·NOT_RUN은 당시 기록이고 최신 근거는 마지막 후속 절과 증거 JSON gui_followup을 따른다.

<!-- 아래 이전 본문은 당시 상태로 보존한다. -->

- 작업/담당: DEV-026 / AGT-DEV-0004 / 2026-11-21 KST.
- 판정: **PR_REVIEW_PARTIAL / 검사기 경로 재지정 승인 대기**. 제품 전체 검증 종료나 Design 수용이 아니다.
- base: `ecb2708bfa7bd3230d56c60b910d6831511953c6`. 브랜치 `codex/DEV-026-s01-exception-implementation`, 미커밋 소스다. [기계 판독 결과](DEV-026_S01_EXCEPTION_RESULTS.json)의 경로/해시·실행별 source-hashes로 식별한다.
- 환경: Godot4.7.2.stable.official.ed1daf0bf, Windows. GUI D3D12 Forward+ / Intel Iris Xe, raw window1440×1000·viewport1152×799(관측 로그). OS DPI/전체 접근성 기준은 NOT_VERIFIED다.

## 실제 결과

| 종류 | 명령/결과 | 원본 증거 |
| --- | --- | --- |
| 신규 경계 자동 | `godot --headless --path . --script tests/game/run_s01_exception_tests.gd` · 334/334, exit0, 엔진/스크립트 오류0 | boundaries-05 로컬 원본: `.local/validation/DEV-026/boundaries-05/results.json`, 단언 로컬 원본: `.local/validation/DEV-026/boundaries-05/automatic.json` |
| 실패 감지 | 같은 명령 `-- --verify-failure-exit` · 의도 실패1/exit1, 엔진 오류0 | boundaries-03/results.json. 제품 실패로 합산하지 않음 |
| W07 | 322/322 · exit0 | boundaries-05/run_w07_tests.log |
| W07/F08 전환기 직접 호환 | 기존 runner를 상속한 로컬 headless probe, 각각8/8·exit0·오류0 | w07-transition.log/f08-transition.log 및 JSON의 probe 소스 해시. F08 GUI/성능 재실험 아님 |
| W03·입찰·공사·P06/P07 공급 | 각각101/460/898/158 검사 모두 PASS·exit0 | regression-01 로컬 원본: `.local/validation/DEV-026/regression-01/results.json` |
| 프로젝트 로드 | `godot --headless --path . --editor --quit` · 정상 권한 재실행 exit0·오류0 | project-load-03.log 로컬 원본: `.local/validation/DEV-026/project-load-03.log`. 이전 제한 환경의 Safe save 오류는 보존 |
| 제품 초기화 | `godot --headless --path . --quit-after 3` · W01/W07_INIT_OK·exit0 | regression-01/product-init.log. GUI 자연 완주 아님 |
| 초기 DATA 실패 | 격리 사본의 DATA를 `{}`로 만든 실제 main · W01_INIT_FAILED/exit1·제품 DATA 불변 | initial-failure-01 로컬 원본: `.local/validation/DEV-026/initial-failure-01/result.json` |
| DEV GUI | 실제 OS 마우스/키보드·F2/F3·P07 Tab/Enter 복귀·고정일·새 Session 전환 | gui-01/gui-02 events.jsonl, viewport PNG. 아래 설명 및 JSON 해시 |
| 기존 GUI 자동 | `run_operations_gui_cases.gd -- --auto` · 245개 중35개 FAIL·exit1, 엔진 오류0·실패 이력 보존 | [경로 재지정 요청](../tasks/DEV-026_S01_EXCEPTION_SCOPE.md). 수정 승인 전 전체 PASS 불가 |

regression-01 이후 자식 화면 복구 시 버튼 잠금이 남는 문제와 빈 목록 포커스 복귀를 보완했다. 후속334개 검사에 해당 행과 타입 경계를 추가하고 W07을 재검사했다. coherent 문자열 비교 등 타입 오류도 보완했으며 boundaries-04는 exit0/단언 failures0이어도 SCRIPT ERROR6개가 있어 FAIL로 기록했다. 모델·정상 입찰/공사 공급은 그대로이며 이전 성공을 최신 SHA의 새 실행이라고 쓰지 않는다. 파일 변경과 실행별 해시는 JSON을 따른다. 마지막 LF 정리는 별도 전후 해시가 있으며 로직 변경이 아니다.

## 행별 연결

아래 PASS_DEV는 DEV 자체 근거에 한정한다. W07 원래 단언·과거 수용은 해당 의미에만 재사용하며 신규 guard의 증거와 합치지 않는다.

| 사례/연결 | 현재 판정 | 실행 단언/증거 |
| --- | --- | --- |
| EX-01 | PASS_DEV | root_rejected/root_missing/root_no_command; initial-failure-01; gui-01 002/003 |
| EX-02 | PASS_DEV | regional_accept/map_cycle_rejected/map_cycle_callback_no_effect; gui-02 003-EX-02 |
| EX-03 | PASS_DEV | new_scope_no_selection; W07 case_switch_clears; gui-02 NEW_SESSION |
| EX-04 | PASS_DEV | missing_action_no_effect_predict; W07 prediction NOT_CALCULATED; gui-01 READY |
| EX-05 | PASS_CONSUMER_ONLY | calculating_fixture_only; synchronous product intermediate frame EXCLUDED_FROM_PATH |
| EX-06 | PASS_DEV | real_zero_current_prediction/prediction_identity_mismatch/prediction_bad_period; W07 ready_zero |
| EX-07 | PASS_DEV | W07 failed_not_zero/render_error; failed_report_recovery is report-only, not prediction evidence |
| EX-08 | PASS_DEV | W07 previous_retained/R02_late_fail_*; prediction_identity_mismatch |
| EX-09 | PASS_DEV | funds_missing_not_zero/funds_missing_clock_kept/funds_missing_plan_kept; gui-01 EX-09/NORMAL |
| EX-10 | PASS_DEV | daily_bad_* 4 fields x null/string/bool/negative; daily_funds_independent |
| EX-11 | PASS_DEV | later_missing_report_neutral; W07 report_absent/real_zero; day>0 UNAVAILABLE is neither first close nor zero |
| EX-12 | PASS_DEV | real_failed_report_hidden/failed_p07_hidden/failed_report_recovery; W07 report_error |
| EX-13 | PASS_DEV | unknown_reason_neutral/unknown_reason_not_raw_ui; regional command_result rejection |
| EX-14 | PASS_DEV | stale_same_scope/same_revision_remainder/foreign_high_revision/reset_preserves_floor/new_scope_low_revision/retired_callback_no_old_effect |
| EX-15 | PASS_DEV | stale_display_request_rejected/displayed_revision_not_replaced; allowed actions independent of past result |
| EX-16 | EXCLUDED_FROM_GENERAL_S01 | general_sync_no_pending; existing W04A 460/W05 898 normal delivery regression; no synthetic wait |
| EX-17 | PASS_DEV | missing_action_no_effect_*/missing_plan_action_*; callbacks blocked without model effects |
| EX-18 | PASS_ISOLATED_FIXTURE | W07 QA-M02-EXTERNAL model jurisdiction + actual candidate callback; default DATA unchanged |
| EX-19 | PASS_DEV | wrong_report_*/wrong_report_hidden_*; fixed_day_report; independent_p07_report; old_confirmation_no_effect |
| EX-20 | PASS_DEV | daily_observation_mismatch_day_id/simulation_minute/snapshot_revision; daily_mismatch_funds_kept_* |
| RP-01/02 | PASS_DEV | regional fields/root/type matrix; independent_p07_report/partial_p07_report_kept; missing-child hidden and recovery |
| RP-03/04 | PASS_DEV | same_revision_remainder/reset_preserves_floor; new View/children/empty history; foreign observations/old callback/direct rebinding rejection |
| RP-05/06 | PASS_DEV | fixed_day_after_midnight; stale confirmation vs actual first-report query; report return; GUI fixed day1 while root day2 |
| RP-07 | PASS_DEV_LIMITED | removed_marker_fallback/gone_id_fallback/no_data_focus_title/deferred_restore_respects_user; gui-02 map/list + P07 keyboard return; no full accessibility acceptance |
| RP-08 | PARTIAL_FUTURE_SUPPLY | existing P06/P07/tender/construction boundary verified; W04B actual envelope absent until DEV-027; not invented PASS |

X-01은 EX-01/02/17, X-02는 EX-04~08, X-03은 EX-09/10/20, X-04는 EX-11/12/19, X-05는 EX-13~15/19, X-06은 EX-02/03/17/18·RP-07, X-07은 새 자식 수명/복귀·기존 전달에 연결한다. W04B 실제 공급은 DEV-027 후속이며 현재 NOT_SUPPLIED다.

## GUI와 원본 보관

`gui-01`: 정상 → root null → 자금만 누락 → 같은 Session 정상 복귀 → 기존 S02 정보 선택·Tab. 명령/원장/시간 효과 해시는 같은 값으로 유지됐다. `gui-02`: 지도 S02 정보 선택 → F2로 지도 공급만 제거 → 목록 fallback → F3 같은 ID 복구, P07 클릭 진입 → Tab/Enter 뒤로 → 원래 화면/포커스, FIXED_DAY(실제 모델을2880분까지 준비·선택일1) → 보고 읽기 스크롤 → NEW_SESSION 낮은판·빈 계획으로 교체다. 고정 보고는 마감일1, S01 직전일은2로 구분됐다.

두 실행은 제품 View를 사용하는 **소비/모델 준비 fixture**다. TEST_ONLY 표식을 유지하며 시간 가속 준비를 자연 게임 완주로 계산하지 않는다. GUI 확인은 자체 검증이며 Design 독립 실행/수용이 아니다. 후속 빈 ItemList fallback은 `no_data_focus_title`, 잘못된 타입 비교는 `coherence_requires_bool_*`/`root_type_*`/`regional_type_*`로 확인했다. 정상 입력의 의미가 같은 GUI 행은 재사용하고 전체 GUI를 반복하지 않았다. 실제 선택 대상 소멸·사용자 포커스 이동 중 지연 callback은 자동 경계 단언에 연결한다.

원본 `.local/validation/DEV-026/`의 초기 parse 실패·기존 GUI 실패41/245·boundaries-02의 빈 목록 포커스 실패1/263·제한 환경 로드 오류를 덮지 않았다. 현재 코드의 관련 수정과 최종 성공을 별도 실행 ID로 기록했다. 편집기가 생성한 범위 밖 import/translation176개는 `generated-imports/` 및 `generated-imports-load03/`로 보관했으며 Git 변경에 포함하지 않는다.

## 남은 조건·권한

- 기존 `run_operations_gui_cases.gd`는 실제 Session binding 없이 다중 실행 표본을 같은 소비기에 주입/하한 초기화한다. 최대24개를 유지하며 `run_operations_ui_tests.gd` 후보를 해당 경로로 재지정하는 승인이 필요하다. 새 계약에 맞춘 실제 binding/선택일·새 View 준비만 수정하고 기존 단언을 보존할 계획이다. 승인 전 미수정이다.
- 실제 공급 L2·독립 실행·Design 심사 PENDING. DEV-027 W04B·DI-03/E01·F08 최종 규격·이전 Stage 2 한정 수용/NOT_VERIFIED는 보존한다.
- Commit/Push/PR·필수 원격 CI·main 병합·빌드/export·성능·전체 자연 VS-02는 NOT_RUN. 이 로컬 검토로 승인/DONE을 선언하지 않는다.

## PR 공개 범위와 현재 승인

Owner의 현재 작업본 PR 요청에 따라 기존23개 파일을 공유한다. [권한 §9](../tasks/DEV-026_S01_EXCEPTION_SCOPE.md)를 따르며 새 제품 구현/검사기 재지정·main 병합 승인은 포함하지 않는다. 제출 base `63550826af8b6ae9a46bda2e4bb826dd1ed7cd79`, 원래 시험 base·원본 로그·334개 단언·35개 실패는 보존한다.

이 문서의 `.local/` 경로는 개발 작업 디렉터리의 보관 위치다. 원본 로그/PNG는 원격에 업로드하지 않았다. 원격에서 확인할 수 있는 단언 이름/판정334개와 남은 실패35개, 각 원본 해시는 결과 JSON의 `publication_evidence`에 제공한다. 실제 제품/Design 검수에 원본이 필요한 행은 후속 패킷에서 공급하며 현재 독립 수용으로 간주하지 않는다.

제출 정책/출처 검사와 필수 원격 CI 결과는 PR에 연결한다. 저장소 CI와 Godot 게임 검증의 범위는 다르며35개 실패는 계속 잔여다.

## 승인된 검사 보완 증거 — 2026-11-21

현재 로컬 검토본은 main 3695c1eefc76fe257c66bd9c4fbbd7d62ae1f572 + 변경 파일 해시이며 codex/DEV-026-operations-gui-followup의 미커밋 결과다. **수정 전245/35FAIL → 수정 후266PASS**, 기존245개 단언과86곳 호출식을 보존하고35개를 모두 해소했다. 추가21개와 회귀334·158·322도 PASS, 의도적 실패exit1·프로젝트 로드exit0·오류0이다.

후속 원본은 .local/validation/DEV-026/ 아래 gui-followup-baseline, gui-followup-01, gui-followup-regression의 results.json/로그·source-hashes.json과 assertion-preservation.json이다. 정적/경로 감사는 check.log·audit.json이다. [기계 판독 결과](DEV-026_S01_EXCEPTION_RESULTS.json)의 gui_followup에35개 이름별 전후 결과와 실행 식별을 연결한다.

이전 원본은 기존 구현 worktree와 [Git 고정본](https://github.com/wisberry2022/MetroManager/blob/3695c1eefc76fe257c66bd9c4fbbd7d62ae1f572/docs/engineering/evidence/DEV-026_S01_EXCEPTION_RESULTS.json)에 보존한다. publication_evidence.pending_legacy_gui_failures는 과거 기록이며 현재 실패 목록이 아니다. 수정 후 자동 실행과 최종 LF 파일의 해시는 line_ending_normalization에 연결하고 차이가 CRLF→LF뿐임을 확인했다. 이후 회귀는 LF 파일로 실행했다.

로컬 원본은 원격 다운로드 링크가 아니다. 이번 실제 GUI·독립 실행/Design 심사·빌드·전체 자연 VS-02·원격 CI는 NOT_RUN, 실제 공급 L2/검증 수용은 PENDING이다. 제품 코드가 바뀌지 않은 행의 기존 GUI를 반복하지 않았다.

## 2026-11-21 후속 — 독립 실행 보고·Design 심사 수신

현재 연결은 [Track B 정본 의견](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7056903693)과 시험본 ae614d922c837eddf4e615fda985bd978e217461다. PR #153 구현 head350a55b1b6f7f182774d4ae74772425e4bca2299 → merge3695c1eefc76fe257c66bd9c4fbbd7d62ae1f572, PR #154 보완 head d24290d6f2d8ed7e9c0ff9b931f290810f768915 → merge ae614d922c837eddf4e615fda985bd978e217461를 구별한다. #154 head/main의 트리 동일성을 확인했다.

| 수행 주체·종류 | 근거/한계 |
| --- | --- |
| DEV 기존 자동/자체 GUI | 실행 JSON gui_followup의266/334/158/322, 최초 GUI21캡처. 과거245/35FAIL은 보존 |
| 독립 실행자 | Track B가 보고한3프로세스·PNG73개·정상 종료/오류0. 모델 준비/소비 변조 fixture이며 자연 완주 아님 |
| Design Track B | 댓글의128개 파일 해시 목록 불일치0·행별 관측/입력/소스·대표 화면 심사. LIMITED_ACCEPTANCE_RECOMMENDED / OVERALL_PARTIAL |
| DEV 이번 후속 | 댓글·고정 소스·공개 실행 기록 정적 대조. Owner 제한 원본의128개 파일/화면/입력을 이번 DEV가 직접 재검증했다고 주장하지 않음 |
| HQ/Owner | S3-12·한정 수용안 최종 판단/RFC 종결은 별도 PENDING |

기존 필수 CI는 원 head에만 연결한다: #153 [policy](https://github.com/wisberry2022/MetroManager/actions/runs/44857424008)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/44857424780), #154 [policy](https://github.com/wisberry2022/MetroManager/actions/runs/44859448207)·[department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/44859448299). 이번 미커밋 문서의 CI나 게임 재실행 결과로 전용하지 않는다.

P07 일4/스크롤605의 문맥 복귀와 일1/628→0의 일반 재진입은 별도 관측이다. 일1의 비영점 중첩 문맥 복귀는 미관측/PARTIAL로 남긴다. 새 Session 내부 수명의 OS 가시성 PARTIAL/INCONCLUSIVE는 자동/소스의 기술 근거와 함께 읽되 GUI PASS로 바꾸지 않는다. 환경/훅 실패·DPI 미확인·W04B NOT_SUPPLIED 및 F08 FINAL_SPEC_PENDING도 보존한다.

기존 JSON/원본은 수정하지 않았다. 이전 PENDING/NOT_RUN은 각 수행 전 이력이며 Design 심사 수신 후의 현재 의견은 위 댓글과 [DEV 검토 결과](../tasks/DEV-026_RESULT.md), [RFC 후속](../gate3/DEV-026_S01_EXCEPTION_CONTRACT.md)에 연결한다. 새 코드·지원 환경·시험 입력 변경이나 반대 증거가 없어 이번 GUI/게임 실행은 NOT_RUN이다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-026
