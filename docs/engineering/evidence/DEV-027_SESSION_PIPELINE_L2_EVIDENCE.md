# DEV-027 P3-A — Session·Pipeline 및 L2 공급 로컬 검수

- AGT-DEV-0004 / 2026-11-22 KST / **LOCAL_REVIEW / L2_ACCEPTANCE_PENDING**.
- 승인 base `97cc5472f11a97d5f7d7c1b89dc12edeace36e1f` + [실행 JSON의 source_sha256](DEV-027_SESSION_PIPELINE_L2_RESULTS.json). 신규 커밋 SHA가 아니다. 최신 main 전체 자연 실행으로 기록하지 않는다.
- [Owner 승인·22경로](../tasks/DEV-027_W04B_VS02_IMPLEMENTATION.md#9-p3-a-로컬-구현검증-승인과-제출--2026-11-22) / [실제 공급 계약](../gate3/DEV-027_W04B_SUPPLY_CONTRACT.md#8-p3-a-실제-sessionpipeline-공급-계약--2026-11-22) / [결과](../tasks/DEV-027_RESULT.md#9-p3-a-로컬-구현검증-결과--2026-11-22).

## 1. 실행·원본

고정 Godot4.7.2/정상 seed2·0·8·1을 재사용했다. 새 seed 탐색·판정 강제·가짜 지급/공정/매출 주입 없이 L09를 실행했다. 다른 오류/경계 입력은 fixture로 명시했다. 최종 전체 소스는 실행 전후 동일한 LF 바이트이며 자동 677 + 회귀 3204, 정상 실패0이다. 소스/엔진/로그·raw JSON 해시와 정확한 명령은 실행 JSON의 runs/raw_files에 있다.

| 실행 | checks | exit | 판정 |
| --- | --- | --- | --- |
| load | — | 0 | PASS / 오류0 |
| w04b | 437 | 0 | PASS / 오류0 |
| proposal_ui | 165 | 0 | PASS / 오류0 |
| vs02 | 75 | 0 | PASS / 오류0 |
| w02 | 309 | 0 | PASS / 오류0 |
| w03 | 101 | 0 | PASS / 오류0 |
| w04a | 204 | 0 | PASS / 오류0 |
| w05 | 191 | 0 | PASS / 오류0 |
| w06 | 179 | 0 | PASS / 오류0 |
| w07 | 322 | 0 | PASS / 오류0 |
| tender_ui | 460 | 0 | PASS / 오류0 |
| construction_ui | 898 | 0 | PASS / 오류0 |
| operations_ui | 158 | 0 | PASS / 오류0 |
| s01_exception | 334 | 0 | PASS / 오류0 |
| vs01 | 48 | 0 | PASS / 오류0 |
| proposal_ui-intentional | — | 1 | 의도한 실패1 검출 |
| vs02-intentional | — | 1 | 의도한 실패1 검출 |

명령은 `<Godot> --headless --path <worktree> --script res://tests/game/run_<name>_tests.gd`이며 w04b/proposal_ui/vs02 검사3개는 별도 `--output=.../final3-<name>/samples.json`을 사용했다. VS01은 `--self-test --run-id=DEV027-P3A-VS01-REGRESSION --evidence-dir=<fresh dir>` 자동 관측기 검사다. 로드는 `--editor --quit`, 새 runner 고의 실패는 `--verify-failure-exit`이다. 고의 실패2개를 정상 검사의 실패로 섞지 않는다. W03은 새 Session 예측 입력 경계의 영향 확인으로 포함했다.

raw는 이 worktree `.local/validation/DEV-027/session-pipeline/`의 실행별 디렉터리와 final3-runs.json/final3-source-hashes.json에 보존한다. 기존 P1 evidence2개와 원본, 승인 전 계획5개, 앞선 F08 로컬6개, 공유 수정 데이터2개를 덮어쓰지 않았다. 초기 권한/타입/API/fixture·기대값/소비 guard 실패 및 통과 표시는 prior_attempts에 원 상태로 보관했다. 자동 결과에 SCRIPT ERROR가 있는 실행은 제외했다. 캐시 보완의 시간 차이는 정식 성능 판정이 아니다.

## 2. L2 실제 위치와 재사용·미공급

JSON `samples`의 키는 아래와 같다. 각 항목은 원 raw 파일·SHA256·JSON pointer와 **그 원본에서 선택한 정확한 필드**를 제공한다. projection은 완전한 root 재구성이 아니므로 그대로 guard의 전체 입력으로 사용하지 않는다. 로컬 raw의 state가 실제 전체 Session 봉투다. 원본 command/result·당시/현재 판과 입력·기대/관측은 `assertions`와 raw pointer로 연결한다.

| 행 | 실제 samples 키·근거 | 공급/제한·후속 |
| --- | --- | --- |
| L01 / UI01~07 | proposal_ui/L01_registered, L01_government_2/0/8/1 | 실제 편집/예측·시청30/정부60·판정/RNG. Track A L2 판단 대기 |
| L02 / UI04~05 | proposal_ui/L02_pause_60/360/1439/1440, office/period/chunk_speed assertions | 예약·정지·업무시간·1/2/4배속 실제 공급. Control 시간 조작은 미실행 |
| L03 / UI02/04/06 | proposal_ui/L03_stale | 당시 submission·STALE_PLAN_OR_PREDICTION·admitted_at=null·새 ID 접수. 동일 ID 효과0 |
| L04 / UI02/05~07 | proposal_ui/L04_locked, L04_changed | 잠금·시청 사본 보존·현재 정부 불가. 화면 잠금/읽기 수용은 대기 |
| L05 / UI09~10 | proposal_ui/L05_admitted_0/8, persuasion29/30 assertions | 현재 초안과 보류 사본을 분리. 유효 접수1회 사용,30분 설득 성공/실패 |
| L06 / UI08/10/13 | proposal_ui/L06_permission_2/8, L06_contract_2/8 | 허가800000/640000과 실제 지급 분리. 공유 원장1회·계약/transaction/사업 ID 연결 |
| L07 / UI11~12 | proposal_ui/L07_pending_0/1 | +1440 경과 후 DI03_PENDING·미공급. DI03 종속 구현/검증은 Owner 별도 승인 대기 |
| L08 / 공통 RP·EX | proposal_ui/L08_conflict, L08_root, vs02/L08_source_isolation; guard assertions | 오류 사본 fixture·실제 정상 자금 독립·old scope/view/외부 행/상충 거부. 정상 root는 실제 Session |
| L09 / UI13~14 | vs02/L09_construction, L09_report_and_next | 실제 계약T453→공사T454/착공455→완료3335→시범3336/종료3396→안전3397/종료3457→개통3458→보고일3/마감4320·후보 조회. 자동 체인, 자연 GUI VS02 아님 |
| L10 / UI03/06 | proposal_ui/L10_negative, L10_zero_display, L10_failure, L10_zero | 음수는 명시된0수요 fixture를 통한 실제 Session 예측.0/실패 사본은 표시·타입 경계 fixture이며 행동 수용 증거가 아님. 도시0 경계는 순수 규칙. 자연 플레이에서0을 관측했다고 하지 않음 |

P1의 나머지 계보/경계 원본은 [기존 증거](DEV-027_W04B_VS02_RESULTS.json)를 재사용한다. 이번 같은 엔진의 모델437 검사는 기존425+단계12이며 기존 보고/시험 SHA를 변경하지 않는다. UI01~14의 행별 L2 수용은 Track A, RP/EX·가독성/공급 형식은 Track B가 판단하며 P3-B의 선행 조건이다.

## 3. 지역 의존과 승인 경계

| 의존 | 실패/미공급 때 동작 | 남은 적용 시점 |
| --- | --- | --- |
| root revision/scope/view·현재 clock | W04B 전체 미확인, old scope/view 거부 | 실제 Control 채택·이전봉투 보관은 P3-B |
| proposal_ui 관측·1.4 모델·행 ID/plan/prediction/심사 사본 | W04B 지역만 거부, 유효 funds/report는 기존 지역 판단 유지 | L2 수용 뒤 화면 연결 |
| action_states/edit_state/predict_state | 현재 가능/사유를 사용. 과거 receipt 실패와 혼동 금지 | 행동별 표시·잠금/읽기 Design 판단 |
| 허가 decision→contract→payment→출처 | 변조/다른 원장/분/중복 거부. 독립 유효 PUBLIC_TENDER 유지 | 정상 단일 공사·운영만 공급 |
| DI03 fact_supply | unavailable/DI03_PENDING, 적격 사실0건으로 대체 금지 | Owner의 DI03 구현 승인 후 |
| N/E/F/A | NR01~13·DA01~08 문서 수신 보존. 승인12역 이름·작성/승인 담당, 기준 PC 목적/배율/접근, 실제 폰트/권리·fallback 미공급 | 상세 계획 §5의 담당·해당 행 적용 전. P3-A 전체 차단 아님 |

`policy.py doctor/check`·diff/UTF8/LF·정확한22경로·provenance·원본/공유 보존 감사는 로컬 audit-final.json으로 연결한다. Commit 후 preflight/원격 policy·department-policy는 NOT_RUN이며 별도 Git 승인 다음 단계다. 자동/로드 PASS는 승인/DONE/GUI/독립 심사/Design 수용이 아니다.

DI03, L2 전 화면 통합, DEV GUI/자연 VS02·독립 실행·Design L2 수용, 환경/폰트/이름·아트 반입, 빌드/export는 NOT_RUN/대기. DEV026 한정 수용·PARTIAL/미관측·P07 구분, #92/F08·S3-10-C·S3-12/HQ·Owner 최종 인수는 유지한다. 명세 변경 필요 없음.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027

## 4. 최종 정적 확인

`policy.py doctor` 및 `policy.py check` PASS·exit0(767파일/GDScript65), `git diff --check` PASS. 승인된22경로·provenance21개 blob·UTF-8/LF·실행 소스 불변·원본/공유 보존 감사 PASS. 실제/fixture 표본31개를 위 색인과 JSON에 연결했다. 정책 PASS는 Git 권한·원격 보호·최종 인수 확인이 아니다. 로컬 상세: `.local/validation/DEV-027/session-pipeline/static-final.json`, `audit-final.json`.
