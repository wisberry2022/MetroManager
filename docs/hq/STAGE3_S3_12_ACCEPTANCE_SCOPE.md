# PM-022 — S3-12 인수 범위·Owner 결정 및 DI-03 착수

- 작성: HQ / AGT-PM-0002 / 2026-11-28 KST.
- 상태: **OD_S312_01_02_APPROVED / NONDEPENDENT_SCOPE_CLOSED / DI03_LOCAL_START_AUTHORIZED / S3_12_FINAL_PENDING**.
- 확인 main: `1c4481187980fe6b37de0fec8e0019f2736ce1f2` (PR #184). 이 문서의 PR 게시/병합과 제품 시험본을 구분한다.
- [Owner 결정 기록](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7236141995), [PM-022 승인·범위](tasks/PM-022_S3_12_DI03_TRANSITION.md), [부서별 실행 요청](requests/PM-022_DI03_DEPARTMENT_REQUESTS.md).
- 후속: [DI-03 #185](https://github.com/wisberry2022/MetroManager/issues/185), [HQ 최종 인수 #186](https://github.com/wisberry2022/MetroManager/issues/186), 기존 [RP/EX #104](https://github.com/wisberry2022/MetroManager/issues/104), [F-08 #92](https://github.com/wisberry2022/MetroManager/issues/92). #146은 원 협의/비의존 검수 기록으로 종료하고 이 링크에서 잔여를 관리한다.

## 1. 적용 결론

**OD-S312-01·02 승인으로 DEV-027의 현재 승인된 DI-03 비의존 구현과 관측된 국소 검수는 한정 종료한다.** N01~N14의 기존 수용과 보충 근거, N15의 근거 취합을 인정한다. N15에 연결되는 S3-12/S3-11 최종 결정은 후속 의무로 남는다. Track B B06-02/OVERALL_PARTIAL 원판정·관측 한계는 보존한다. [Track A][A184S]·[Track B][B184]의 판정을 HQ가 전체 PASS로 변경하지 않는다.

**DI-03은 Stage 3 필수 범위로 유지하며 착수 가능하다.** A1+B1 정책 확정과 실제 비의존 Session/Pipeline 기반이 준비되어 Owner의 조건부 착수 지시에 따라 일정상 HOLD를 해제한다. [부서 요청](requests/PM-022_DI03_DEPARTMENT_REQUESTS.md)의 정확한 포함/제외와 순서에 한해 로컬 구현·검증을 진행한다. 실제 공급 L2는 해당 화면 통합 전 조건이며 공급을 만들 모델 구현을 막는 조건이 아니다. 제품 구현·수용은 아직 완료가 아니다.

- 새로운 비의존 필수 제품 결함/추가 독립 GUI 요청은 특정되지 않았다. C01~05는 현재 한정 인수의 새 GUI 차단이 아니며 과거 미관측은 그대로 보존한다.
- DEV-027 **전체 DONE**, 전체 Design 최종 수용, S3-12 최종 인수, S3-11/Stage 3 최종 결정은 #185/#186 후속이다. 비의존 단계 종료와 전체 티켓 종료를 구분한다.
- F-08은 #92에 별도 유지한다. 기존 방향·MVP 선택은 완료이며 실제 공급·최종 규격·제품 적용/검증의 미결을 이번 승인으로 확정하지 않는다.
- EX-05 소비 fixture 한정, EX-16 일반 S01 대기 제외, EX-18 격리 외부역, [P07 일반 재진입/저장 문맥 구분][O26]을 유지한다.

## 2. 증거 식별과 SHA 계보

표의 E번호는 다음 고정 근거를 뜻한다. 문서 게시 SHA, 제품 시험 SHA, 미커밋 실행의 base+파일 해시는 서로 바꾸어 쓰지 않는다. 각 실행·자동 단언·캡처·해시 대조 건수를 합산하지 않는다.

| 증거 ID | 시험본·수행 식별 | 근거와 수용 범위 |
| --- | --- | --- |
| E01 | DEV-026 독립 검수 제품 `ae614d922c837eddf4e615fda985bd978e217461` | [Owner 한정 수용·P07 구분][O26], [Track B 원 판정][B26], [DEV 행별 EX/RP 증거][EV26]. 기존 DEV 자동 334/158/322/266과 독립 GUI·심사를 각각 원 수행으로 재사용 |
| E02 | P3-A 검토 고정본 `cc8814097634013be8df8b27f166bdee09c7bac6`; DEV 자동 실행은 base `97cc5472f11a97d5f7d7c1b89dc12edeace36e1f` + JSON의 source_sha256 | [Track A P3-A L2 한정 수용][A3A], [Track B P3-A 정적 의견][B3A], [L2 실행 JSON][J3A]. 실제 Session/Pipeline의 비의존 공급 수용이며 제품 화면·자연 GUI 수용과 구분 |
| E03 | P3-B/자연 VS-02 독립 시험 `37596bd6d646f9d0454280477e60a2e652f06613` | [Track A 자연 VS-02][AN], [Track B 18행 한정 수용][BN]. A seed2의 동일 P-A 사업: 정상 RNG sample50/draw1 → 표준 공사 → 시범/안전 → 개통 → 일4 실제 완료통행4852/운임485200/운영비108000/서비스1080분 → 후보 조회·보고 복귀. B의 별도 실행 수치와 섞지 않음 |
| E04 | P3-B DEV 자동 실행 base `1a24e3346d0ec46ca692fe54d5de5656913c3450` + [JSON][JSCREEN]의 실행 소스 해시 | [화면 통합 증거][SCREEN], [공동 GUI 매핑][GUI]. View225/영향회귀3120 및 정상 RNG·무효과·guard·표시 fixture. 자연 GUI나 새 HQ 실행이 아님 |
| E05 | PR #177 독립 시험 `b0447defe57abe173d10dcc05784f79313ff69ca` | [Track A K01][A177], [Track B K01][B177]. K01-12/13/14 지정 키보드 경로·계약/설득 입력, K01-04 마지막 행 전체 가시성과 안정 읽기 한정 수용 |
| E06 | PR #178 독립 시험 `03c7d9346f49eb04347343e6e7f510cf9f549d47`; DEV 전후 실행 base `b0447defe57abe173d10dcc05784f79313ff69ca` + [JSON][JKEY] 해시 | [Track A][A178], [Track B][B178]. 키5행+End→Home. DEV 집중209/6→209/0; A 독립 stdout209/0과 JSON208/0은 저장 성공 단언 전후 차이. B는 기존 자동 근거 심사로 신규 자동0 |
| E07 | PR #182 독립 시험 `d0f49eb33ec6bd0efebf5352de315b4b16a3ae07`; DEV 전후 실행 base `b4010d4169b7c66a833820ee03905ffd242ff84a` + [JSON][JWHEEL] 해시 | [Track A][A182], [Track B][B182]. 휠6행+세로 바 위 휠1행, P05 무입력 복귀, 키보드 재무→제안 가시 복귀. DEV 집중253/7→253/0, 전체890/0·운영271/0·공사898/0·S01334/0·로드. A 독립 stdout253/0과 JSON252/0은 같은 실행의 저장 성공 단언 차이 |
| E08 | DEV 재무 클릭·키보드 왕복 시험 base `556d04e7cf420c883838ea2bf0416fab42bc36c0` + 계측 Host; 공개 기록은 PR #184 | [공동 잔여표 §9][RES], [A 문서 검토][A184], [B 원 로그·diff·해시 대조][B184]. 하나의 GUI 프로세스에서 왕복2개. 원 Host `33e13c7feb0746309b27dbefea18f07c9cc5318862ce7eec32a086198cde033f`, 계측 Host `b73beaec2edd5fdeedca3656a7d69b65f449d55caa09c694df66e518f0ca26a1`, 로그 `776250fa5fccbbbe6b959353e2db1534f3f7dce94af99d0a0d7958215d8adf01` |

E08은 원 제품과 바이트 동일한 무계측 실행이 아니다. Track B는 입력/복원 분기·scroll 대입·대기 frame·모델 명령의 변경이 없음을 대조했지만, 계측의 미세 타이밍 영향은 NOT_VERIFIED다. Track A는 원 로그를 직접 읽지 않은 사실을 유지한다. HQ도 이 로컬 원 로그를 새로 재검증한 것으로 기록하지 않는다.

PR #182 시험본에서 현재 main까지 [비교][CMP]는 Planning 문서3개와 DEV 공동 잔여표1개뿐이다. 제품·씬·데이터·검사 변경이 없으므로 E07을 최신 main에서 새로 실행했다고 바꾸거나 SHA 진전만으로 반복하지 않는다. 이전 시험본에서 #177/#178/#182로 이어지는 Host 변경은 해당 후속 검증·회귀에 한정하여 연결한다.

## 3. S3-12 필수 행과 현재 충족 범위

N행은 **현재 비의존 인수 범위의 필수 기능·통합 기록**이다. `REUSE_READY`는 기존 부서 증거의 대응 상태다. OD-S312-01로 이 범위의 재사용·한정 종료는 승인됐으나 새 부서 PASS나 전체 Owner 최종 인수를 뜻하지 않는다. 조건별 OS 직접 관측 한계는 §4에 별도 보존한다. 아래 E번호 링크의 시험 SHA를 각 행에 적용한다.

| 행 ID·DEV-026 대응 | 필수 여부·범위 | 시험 SHA·증거 | 담당 Track의 기존 판정 | 남은 공백 | HQ 처분안 | 담당·적용 시점 |
| --- | --- | --- | --- | --- | --- | --- |
| S3-12-N01 · EX-01/02/09/10/17/20 · RP-01/02/08 · X-01/03/06/07 | 필수: root/지역 오류 분리, 독립 유효값·행동 유지, 누락0치환 금지 | E01 [EX/RP 증거][EV26] + E04 [B04 자동][JSCREEN] | B: DEV-026 Owner 한정 수용 유지. A/B: W04B 관측 범위 수용; L08의 신규 OS 주입은 별도 | W04B 모든 오류의 OS 직접 관측은 NOT_RUN | REUSE_READY. 자동 guard/복구와 기존 가시 수용 재사용, 새 전수 주입 없음 | DEV 근거 / B 예외·A 기능 / 현재 범위 취합 |
| S3-12-N02 · EX-03/18 · RP-07/08 · X-06 | 필수: 빈 계획·명시 선택·정보 열람/편집 분리·기존 후보 유지 | E01 + E03 B01-01~05 + E04 map_list_read_effect0/locked_read_effect0 | A 기능·B 정보/표현의 한정 수용 | 실제 전체 역명은 별도 F-08 공급. 외부역은 격리 fixture | REUSE_READY. EX-18을 자연 제품 사례로 확대하지 않음 | DEV/A/B / 현재 범위; 이름은 F03 |
| S3-12-N03 · EX-04~08 · RP-01/02/08 · X-02 | 필수: 미계산/0/실패/이전 값 구분, 낡은 결과 차단 | E01 + E02 L2 + E04 zero_fixture_valid/zero_is_number/failed_fixture_valid/failed_is_not_zero | A: 공급·현재/이전 기능 한정 수용. B: 기존 자동/표시 fixture 재사용 | 자연 유효0·예측 실패의 새 OS 관측 NOT_RUN | REUSE_READY. EX-05 CALCULATING은 소비 fixture만; 동기 제품에 가짜 대기 추가0 | DEV/B·A / 현재 범위; 표현 변경 시 해당 행 |
| S3-12-N04 · EX-11/12/19 · RP-05/06 · X-04/05 | 필수: 보고 없음/실패/유효0, 선택일·보고키·확인 사본, 조회 무효과 | E01 fixed_day_after_midnight/old_confirmation_no_effect + E03 일4 보고·왕복 | B: Owner 승인된 P07 구분, 일4 저장 문맥 수용. A: 같은 사업 실제 보고·후보 흐름 | 고정일1 비영점 중첩 OS는 C02. 재무→제안은 P07 내부 보고 복귀 증거가 아님 | REUSE_READY. 일반 재진입의 상시 스크롤 기억을 새 요건으로 추가하지 않음 | DEV/B·A / 현재 범위; C02 별도 |
| S3-12-N05 · EX-13/14/15/19 · RP-03/04/08 · X-05/07 | 필수: 실행 귀속·현재/과거·미상 사유·옛 callback/판 거부 | E01 + E04 old_scope_discard/retired_callback_no_effect + E06/E07 old_scope/replace 회귀 | B: 자동·소스 기술 근거 재사용, OS 내부 가시성 한계 유지. A: 기능 무효과 연결 | 내부 callback/재binding 전 과정을 독립 OS에서 직접 보는 것은 NOT_VERIFIED | REUSE_READY. 기능 차단 계약은 필수, 모든 내부값의 OS 재관측은 현재 필수 아님 | DEV/B / 현재 범위 및 수명 변경 영향 시 |
| S3-12-N06 · EX-16 · RP-08 · X-07 | 필수: 실제 W04B 요청/등록/접수·효력 구분; 일반 S01 가짜 pending 제외 | E02 UI04~07 + E03 B02/B03 + E04 office·pending 표본 | A/B: 자연 도달 상태의 현재/당시·허용 행동 한정 수용 | 모든 대기 분기를 자연 전체 E2E로 반복한 것은 아님 | REUSE_READY. EX-16 일반 S01 제외를 W04B 실제 대기 면제로 전용하지 않음 | DEV/A·B / 현재 범위 |
| S3-12-N07 · RP-08 · X-01/05/07 · UI01~11/13~14 | 필수: 실제 W04B 공급과 화면 소비 연결 | E02 실제 Session/Pipeline → E03 제품 화면 → E04 guard/지역 공급 | A: P3-A L2 한정 수용·P3-B 기능 수용. B: 정적 계약 의견+관측18행 한정 수용 | UI12·UI11의 실제 사실 공급 뒤 행동은 D01 | **W04B 비의존 NOT_SUPPLIED 해소 근거 연결**. RP-08 전체·DI-03 완료로 확대0 | DEV/A/B / 현재 비의존 인수 |
| S3-12-N08 · RP-04/05/06/07/08 · X-05/06/07 · UI13~14 | 필수: 동일 사업 계약·지급→P05→운영·유효 보고→후보·보고 복귀 | E03의 동일 P-A 자연 VS-02; E04 자동 체인은 보조 | A: 자연 관측 PASS. B: B05-01~04 실제 읽기/복귀 한정 수용 | 마지막 OS 내부 카운터 C01, 일1 C02. 실제 두 번째 수주 요구 없음 | REUSE_READY. S3-06/08에도 같은 증거를 관측 범위로 공동 연결 | DEV/A·B / 현재 인수; 전체 재완주0 |
| S3-12-N09 · RP-07 · X-06/07 · K01 | 필수: 지정 접근 경로·가시 포커스·마지막 행 | E05 K01-12/13/14·K01-04 | A/B 지정 경로 수용 완료. 원 FAIL/PARTIAL은 당시 기록 보존 | 모든 Control×상태×키 인증은 아님 | REUSE_READY. 지정 수용 경로 재검수 없음 | DEV/B 접근·A 행동 / 현재 인수 |
| S3-12-N10 · RP-04/07 · X-06/07 · F04 키 | 필수: 유효 새 읽기를 옛 복원이 덮지 않음 | E06 키5행·End→Home + E07 회귀 | A/B 결정적 순서 계약 한정 수용 | OS1~2frame 경쟁은 C01 | REUSE_READY. 0/215/430은 fixture 값; 키5행을 미수정으로 되돌리지 않음 | DEV/B 읽기·A 효과 / 현재 인수 |
| S3-12-N11 · RP-04/07 · X-06/07 · F03/F04 휠 | 필수: 유효 바깥 휠6행과 바 위 휠1행 보호, 내부/clamp 분리 | E07 휠7경로·253/0 및 W-G01/02 | A/B 읽기 보호·실제 관측 한정 수용 | 바 드래그 전부·모든 OS 타이밍 인증은 아님 | REUSE_READY. null-owner라도 유효 휠 이동2행은 보호 대상. End 미소비2행의 정확한 시점 비적용과 구분 | DEV/B·A / 현재 인수 |
| S3-12-N12 · RP-04/07 · X-06/07 · P05/재무 키보드 복귀 | 필수: 저장된 유효 문맥·위치·가시 포커스 복귀 | E07 P05 A062→064/065, B055→057/058; B067→070/071 키보드 재무 복귀 | A: P05 반환 포커스 한정 해소. B: P05/키보드 재무 가시 복귀 수용 | P05 반환 별도 수치·엔진 첫 frame 미측정. 출발1055를 반환 실측값으로 쓰지 않음 | REUSE_READY. 새 입력 전 무입력 가시 복귀와 자동 수치 근거를 조합 | DEV/A·B / 현재 인수 |
| S3-12-N13 · RP-04/07 · X-06/07 · 재무 클릭 보충 | 필수 계약의 보충: 실제 저장 시점의 값 복원 | E08 클릭 전79→focus획득62→저장62→복원62, owner open_finance; 키보드62→62 | A: 문서/diff 검토. B: 원 로그·계측 diff/해시 직접 대조. **DEV_SUPPLEMENT_REVIEWED** | 과거 계약·지급 후 B 실행과 다른 초안/revision 상태; 계측 타이밍 한계 | REUSE_READY_SUPPLEMENT. DEV 경로만 인정, 과거 B 클릭은 C03. 현재 추가 독립 GUI0 | DEV 공급/B 정합·A 문맥 / 현재 인수 보충 |
| S3-12-N14 · EX-15 · RP-05/06/08 · X-05/07 · 무효과/RNG | 필수: 조회·읽기·중복 입력에 추가 추첨·계약·지급 없음 | E02 pending_duplicate_same/persuasion_duplicate_no_draw/no_duplicate_payment/next_no_effect; E04 candidate_query_no_rng/no_payment/reading_roundtrip_effect0; E03 QUERY·화면 | A: 내부 OS 한계 보존하며 기존 자동·QUERY 재사용. B: 관측/자동 경계 유지 | 마지막 왕복 뒤 raw counter·일부 seed OS RNG 미수집 | REUSE_READY. 마지막 과거 수치의 복원이 현재 기능 계약의 필수 증거는 아님. C01에 보존 | DEV/A / 현재 인수 및 RNG·명령 변경 영향 시 |
| S3-12-N15 · S3-11 연결 | 필수: 근거·회귀·부서 판정·CI·잔여 처분 기록 | §2, §7 및 E01~08. #177/#178/#182/#184 제출 head 필수 CI 재조회 | 기존 A/B 판정을 각각 유지; 전체 Design 최종 수용 미선언 | OD-S312-01·02 처분 완료. DI-03/F-08 후속과 S3-12 최종 수용·S3-01~10 취합은 별도 | **EVIDENCE_MAPPING_ACCEPTED / FINAL_ACCEPTANCE_PENDING (#186)** | HQ/Owner / S3-11 최종 결정 전 |

검증 묶음 X-01~07은 반복 횟수가 아니다. EX-01~20·RP-01~08 모두 위 행으로 연결되지만, 전체 조합·전체 제품의 GUI PASS를 뜻하지 않는다. 현재 새로운 비의존 필수 구현/GUI 보완 행은 **특정되지 않음**이며, 미관측 행의 공식 처분은 승인된 다음 절과 §6을 따른다.

## 4. 관측 한계의 필수 여부·보완 조건

다음 처분은 OD-S312-02로 승인됐다. `비필수`는 과거 관측을 PASS로 바꾸거나 기능 계약을 없앤다는 뜻이 아니다. 특정 OS 상태까지 포함하는 더 넓은 인수 범위를 결정하면 그 상태에만 증거를 추가한다.

| 행 ID | 현재 상태·근거 | 이번 인수의 승인된 필수성 | 처분·담당·재개 조건 |
| --- | --- | --- | --- |
| S3-12-C01 | OS RACE **INCONCLUSIVE**. 마지막 후보 왕복 raw counter·seed0/8/1 OS RNG **NOT_VERIFIED**. E03/E04/E06/E07 | 읽기/명령/RNG 기능 계약은 필수이며 N05/N10/N11/N14의 자동·QUERY·GUI 조합으로 원범위 충족 근거 확보. 정확한 OS1~2frame 동기화·이미 끝난 실행의 raw 수치 회수는 별도 필수로 추가하지 않음 | 한계 보존·신규 실행 없음. DEV 원자료/A 기능·B 순서 계약. 실제 반대 증거 또는 해당 입력/RNG/지연 경로 변경 시 영향 필드·시점만 재개방. OD-S312-02 승인 완료; #104 추적 |
| S3-12-C02 | B05-05 고정일1·비영점 중첩 문맥 복귀 **PARTIAL / NOT_RUN**. E01/E03의 일4로 대체 불가 | 현재 비의존 한정 인수에는 이 정확한 OS 조합을 새 필수로 추가하지 않음. FIXED_DAY 의미·사본 검사·공통 복귀 계약은 N04/N05/N12에서 필수 유지 | OD-S312-02 **비차단 처분 승인 / 원 상태 보존**; #104 추적. DEV/B가 관리. 이 조합을 포함한 P07 포괄 수용 또는 해당 날짜/중첩 복귀 코드 변경 전, day/key·비영점 저장/반환·owner·무입력 상태만 국소 대조. 일4 재완주0 |
| S3-12-C03 | 과거 B 계약·지급 후 클릭의 정확 저장/반환값·순서 **PARTIAL / NOT_VERIFIED**. E07 원본 유지, E08은 초안 상태 보충 | 공통 저장 기전·관측 문맥 수용은 충분한 근거가 있음. 과거 계약 후 클릭의 정확한 수치를 직접 입증하는 별도 조건은 이번 한정 인수에 추가하지 않음 | OD-S312-02 **비차단 처분 승인 / 원 상태 보존**; #104 추적. 현재 추가 독립 GUI 요청 없음. 향후 해당 계약 후 상태까지 정확 수치 인수를 요구하면 DEV/B가 클릭 직전→focus→저장→복원4시점의 scroll/owner·사업/계약/지급 문맥만 특정. E08의62로 과거 수치를 채우지 않음 |
| S3-12-C04 | L08/L10 신규 OS 오류 주입 **NOT_RUN**; 내부 callback/옛 scope 독립 OS 가시성 **PARTIAL/NOT_VERIFIED** | N01/N03/N05의 실제 자동·표시 fixture·변경 영향 회귀로 기능 계약을 대조. 모든 내부값의 OS 노출/신규 runner는 현재 필수 아님 | DEV/B 기존 증거 재사용. 표현·guard·수명에 반대 증거/직접 변경이 있을 때 해당 필드만 보완. 소비 fixture를 자연 발생 PASS로 확대0 |
| S3-12-C05 | 과거 helper/UID 실행 시점 동시 해시 **NOT_PROVIDED**; A 패킷 cache66개 후속 부재의 원인/시점 **NOT_VERIFIED**; 기존 오류·DPI 한계 | E07의 A 고정본 재실행·B 원증거 심사 등 현재 사용 가능한 근거와 구분한 출처 한계. 현재 수용을 막는 증거 훼손으로 판정한 부서 근거 없음 | 원본/정정·시점별 검증 주체 보존. 과거 해시를 생성했다고 하지 않음. 실제 사용하는 증거가 접근 불가/불일치하면 그 의존 행만 재검토. 원 보관 담당/DEV·Design |

**비의존 수용 범위에는 추가 구현·새 GUI·새 runner를 요구하지 않는다.** DI-03의 신규 구현·검증은 별도 #185와 부서 요청을 따른다. 아래 기존 근거 연결로 부족분을 확인했으며, 새로운 필수 공백이 특정되는 경우에만 다음 형식의 한 행으로 후속 요청한다: `인수행 / 부족 필드 / 필요한 상태·시점 / 기존 증거로 부족한 이유 / 최소 관측 / 실행·Git 권한 / 완료 조건`. 과거 raw 미수집 자체를 전면 재검수 요청으로 바꾸지 않는다.

## 5. DI-03 착수와 F-08 적용 시점

| 행 ID·연결 | 필수 여부·현재 상태 | 영향·담당 | 적용 시점·처분안 |
| --- | --- | --- | --- |
| S3-12-D01 · UI11 종속/UI12·W4B-15~17·RP-08·S3-05/09 | **실제 구현·검증 필수 / LOCAL_START_AUTHORIZED / 신규 제품 수용 NOT_RUN**. A1+B1 정책 결정 완료. E01 예정 메타데이터는 실제 발생 근거가 아님 | DEV: 사건·실패 근거 계획·고유 동/OD·동일 사업1회·T+1440·×5/4·사업별 수요/carry·소비·성공 재접수. Planning: 승인 의미 차이만. A: 기능·입력 효과, B: 실제 공급/소속·표현 | 이번 비의존 인수 제외는 기존 승인 경계. **DEV-027 전체 및 DI-03 포함 제품 인수 전 반드시 구현·검증·수용 또는 Owner 공식 범위 변경**. Stage 3 유지 결정 완료. 일정상 HOLD 해제. #185 및 부서 요청의 정확한 로컬 범위에서 착수; UI L2/독립 GUI·미래 Git 권한은 단계별 경계 적용 |
| S3-12-F01 · F08-01·S3-10-M03 | 방향 O01/02 및 S1/E1/F1 완료. 실제 환경·폰트/배포 구성·지원 규격 **FINAL_SPEC_PENDING** | HQ/Owner: 기준 PC 제공자·검토용/제한 배포 목적. DEV: OS/build/GPU/driver/renderer/유효 DPI·창/client/viewport·폰트 파일/해시/권리/fallback. B: 가독성, A: 기능 영향 | 현행 기본/fallback의 관측 조건 인수는 재사용. 실제 폰트 반입/제품 적용·지원환경 인증·배포 전 해당 셀 검증. 현재 관측 PC를 최종 지원 PC로 임의 지정하지 않음 |
| S3-12-F02 · F08-02·S3-10-M04 | O03/A1 승인, 기존 draw/Control 유지·아트 준비 완료. 실제 아트/필터 적용은 조건부 | Track B/DEV: 실제 교체 역할 선택 시 원본/export·권리·치수/위상·필터·동적 문자/포커스 영향 | 현행 유지 시 새 이미지·Theme 전면 추출 요구0. 실제 자원 교체/필터 적용 전 검증. 격리 T02 결과를 제품 아트 완료로 쓰지 않음 |
| S3-12-F03 · F08-03·S3-10-M01/M02 | O04/05·N1 승인, NR01~13·DA01~08 준비/DEV 수신 완료. 실제 승인 이름12행·소비 계약/제품 적용 잔여 | HQ/Owner: 이름 작성/승인 담당·공급 창구. 콘텐츠 담당: 안정ID/전체 표시명12행·버전/출처/locale. DEV: 동일 ID·순서/오류/이름판·읽기/편집 분리. A/B 공동 영향 심사 | 현재 ID/동 기반 한정 수용과 구분. 승인 전체 이름 공급·제품 적용/그 콘텐츠 인수 전 N01~08 최소검증. B 배치·밀집 변경은 채택 시만. 실제 이름 미공급을 기준 미수신으로 되돌리지 않음 |
| S3-12-F04 · F08-04·S3-10-O06/M05 | O06/07·P1 원칙 승인. 성능 목표 결정 시점 이월은 이미 승인됨 | DEV: 현재 구조 재사용/실제 변화 경로·측정안. HQ/Owner: 목적/목표환경·부하/기간·목표. B: 표현 영향 | 전면 리팩터링·신규 벤치마크 의무0. 실제 구조 변경 시 영향 검증, 성능/배포 인수 때 목표·프로파일/export 구체화. 현재 FPS/상한 보장 없음 |

F-08의 [최신 공급 인계][FNAME]와 [MVP 선택 완료 기록][FMVP]을 우선 적용한다. 초기 공통표의 NOT_SENT·DEV_CONFIRMATION_PENDING은 당시 이력이다. **O01~07 및 S1/E1/F1/N1/A1/P1 재선택은 요청하지 않는다.** 미공급 담당·실제 자원/환경·지원 수치·제품 적용의 미결만 남긴다. #92/F08-01~04는 OPEN, S3-10-C는 별도 취합 대기다.

DI-03의 [Planning 정본 회신][PLN]에는 새 정책 충돌/명세 변경 필요 NONE이 기록돼 있다. 기술 구조·필드 형식·같은 분 처리 순서 구현은 DEV가 구체화하고 기존 승인 의미를 대조한다. 현재 Owner의 조건부 착수 지시와 HQ 준비도 판단에 따른 HOLD 해제를 §6에 기록한다. 기존 기술 제안 전체를 포괄 승인하거나 구현 완료로 바꾸지 않는다.

## 6. Owner 결정과 후속 관리

정본: [2026-11-28 Owner 결정 기록](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7236141995). OD-S312 식별자는 기존 F-08 O-01~07과 다르다. 이 결정은 부서 판정과 과거 관측의 소급 변경이 아니다.

| 결정 ID | 현재 확정 내용 | 남은 일·책임 |
| --- | --- | --- |
| OD-S312-01 | **APPROVED** — N행으로 대응한 DEV-027 DI-03 비의존 구현·관측된 국소 검수의 한정 종료 | #146 원 기록 보존·후속 연결 후 종료. DEV-027 전체 DONE·전체 Design·S3-12/Stage 최종 수용은 #186 |
| OD-S312-02 | **APPROVED** — C01~05 원 상태 보존, 현재 한정 인수의 추가 독립 GUI 차단으로 삼지 않음 | #104에서 실제 영향·반대 증거·더 넓은 인수 주장 시 해당 필드/상태만 재검토 |
| OD-S312-03 | **STAGE3_SCOPE_RETAINED / LOCAL_START_AUTHORIZED** — Owner가 Stage 3 유지 및 가능 시 착수를 지시; HQ가 가능으로 판단하여 일정상 HOLD 해제 | #185에서 실제 사건·동/OD·수요/carry·소비·재접수 구현. 정확한 로컬 경로·검증·단계별 권한은 부서 요청 적용. 정책 A1+B1 재심사0 |
| OD-S312-04 | **F08_OPEN / FINAL_SPEC_PENDING** — Owner가 F-08 미결을 별도로 유지하도록 결정 | #92의 기존 방향/선택을 재사용. 미공급 환경·실제 자원·이름과 지원/배포 규격은 미확정 유지. 새 이월/범위 제외까지 승인된 것으로 확대0 |

### #146 종료와 분리 원칙

#146의 원래 UI 검토·공급 L2 협의 및 비의존 국소 검수는 종료 근거가 확보됐다. Owner가 종료 가능성 판단·미종료 업무 분리를 요청했고 HQ는 **후속 이슈·인수표 연결 후 completed 종료 가능**으로 판단한다. #146 제목/원문/댓글은 유지하고 종료 안내를 덧붙인다. #146 종료는 DEV-027 전체 DONE 선언이 아니다.

| 관리 항목 | 담당 정본 | 완료/재개 기준 |
| --- | --- | --- |
| DI-03 신규 실제 구현·검증 | [#185](https://github.com/wisberry2022/MetroManager/issues/185), DEV-027 / DEV·Planning·A/B | 신규 필수 행 공급·검증·수용을 #186에 인계 |
| S3-12 취합 → S3-11 최종 판단 | [#186](https://github.com/wisberry2022/MetroManager/issues/186), HQ/Owner | 필수 제품 잔여·CI·부서 판정·MVP 차이·적용/이월 취합과 Owner 최종 결정 |
| DEV-026 RP/EX·C01~05 관측 한계 | [#104](https://github.com/wisberry2022/MetroManager/issues/104), DEV·Track B/A | 원 PARTIAL·NOT_VERIFIED 보존; 해당 변경/반대 증거/더 넓은 범위 주장 전 국소 검토 |
| F-08 실제 공급·최종 규격·적용 | [#92](https://github.com/wisberry2022/MetroManager/issues/92), HQ/Owner·DEV·Track B/A | F01~04의 실제 적용 시점별 완료 또는 명시적 이월 |

새 이슈2개와 기존 이슈2개를 상호 링크로 연결한다. GitHub 네이티브 sub-issue 관계 등록과는 구별한다. #139 INF 원본 보관·백업 의무는 변경하지 않는다. 다른 부서 작업 티켓 번호를 HQ가 새로 발급하지 않으며 DEV-027/DSG/PLN의 기존 담당 티켓으로 연결한다.

## 7. S3-12 → S3-11과 부서 실행 순서

1. **완료 근거 재사용:** N01~14·E01~08·C01~05를 현재 범위의 기준으로 확정한다. 이미 대조된 무효과/RNG·old scope/callback·0/오류 fixture를 다시 제출하거나 같은 GUI를 반복할 의무는 없다. 실제 부족 필드가 새로 발견될 때만 `행/필드/상태·시점/기존 근거의 부족 이유/최소 관측/권한/완료 조건`으로 요청한다.
2. **#185 DI-03 실행:** DEV는 로컬 모델/공급·자동 경계를 시작하고 최신 base와 실제 선택 경로를 자기 티켓에 기록한다. Planning은 실제 의미 차이만 확인. 실제 payload 후 Track A/B L2를 대조하고 해당 화면을 연결한다. 새 독립 실행·부서별 Git의 유효 원문은 그 단계 전에 연결한다. [정확한 경로·요청·완료 기준](requests/PM-022_DI03_DEPARTMENT_REQUESTS.md).
3. **Design 분담:** A는 기능·입력 효과·사업 문맥, B는 RP/EX·읽기/복귀·Control 수명·표현. 한 고정 패킷을 공동 사용하며 개별 판정은 보존한다. 단순 수신 확인·전체 재승인 문서를 새 차단으로 추가하지 않는다.
4. **#186 S3-12 최종:** 현재 한정 종료와 DI-03 신규 수용, F-08 적용 경계, 원 미확인·이월을 합친다. N15의 증거 정리 완료와 최종 S3-12 인수는 다르다. 현재 **FINAL_ACCEPTANCE_PENDING**이다.
5. **S3-11 최종:** S3-01~10·AC/VP·필수 CI·부서 수용·이월 승인·MVP 차이를 취합해 Owner 결정에 연결한다. 본 문서/PR/Issue 종료만으로 Stage 3 또는 전체 MVP DONE을 선언하지 않는다.

### 필수 CI의 정확한 적용 범위

2026-11-28 GitHub check-runs를 조회하여 아래 제출 head의 `policy`·`department-policy` SUCCESS를 확인했다. 병합은 네 PR 모두 완료다. 동일 head의 재실행은 별도 제품 검증 수로 더하지 않는다. 비필수 출처 보고의 job success는 신원/승인 인증이나 진단 없음의 의미가 아니다.

| PR | 제출 head | policy | department-policy |
| --- | --- | --- | --- |
| #177 | `cc5727ee13c720cb59c8cab7fdc41872e961af95` | [SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/45002424968/job/137146655729) | [SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/45002425417/job/137146660640) |
| #178 | `f4d35a0f5c7fd96f79ff42beca084ea0e65ddb6d` | [SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/45988023597/job/140468492217) | [SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/45988024598/job/140468500728) |
| #182 | `e637fcf4e0b7a816c13b433c026f77c0c153257e` | [SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/45996907154/job/140498476347) | [SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/45996907961/job/140498483218) |
| #184 | `1f3e0a486a11e4dca6460711b927236cba903f80` | [SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/46119866929/job/140901797095) | [SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/46119866864/job/140901798619) |

§2의 DEV 자동검사·로드·실제 GUI·독립 실행·Design 심사는 원 수행자의 기록이다. HQ가 이번에 실행한 것으로 표시하지 않는다.

## 8. 이번 HQ 검증과 한계

- 원격 main·PR #177/#178/#182/#184·#146/#104/#92와 공동 잔여표, DEV-026 EX/RP/X 및 실제 자동 결과 JSON을 정적으로 대조했다. 로컬 origin/main은 확인한 원격 SHA와 일치하며 고정 SHA의 `git show`로 읽었다.
- candidate_query_no_rng/no_payment·reading_roundtrip_effect0·old_scope/retired_callback·zero_is_number/failed_is_not_zero·P3-A 중복 단언은 **기존 기록 재사용**이다. HQ가 게임을 새로 실행하거나 원 ZIP 전체를 재해시한 결과가 아니다.
- PM-022 변경 경로·UTF-8/LF·참조·표·JSON/출처 blob을 정적 검사한다. API 제출은 원격 base/head·부모1개·docs/hq/ 경로·expected SHA와 PR head 필수 CI를 확인한다. 상세 수행/한계는 [PM-022 결과](tasks/PM-022_RESULT.md) 및 실제 PR 검사를 따른다.
- 신규 게임 자동검사 / Godot 로드 / 실제 GUI·플레이 / 독립 GUI / 빌드·export / 성능: **이번 HQ NOT_RUN**. 물리 환경·실행 주체 신원·비공개 원본 전체 재해시: **HQ NOT_VERIFIED**.
- 공유 checkout의 기존 데이터2개 변경은 보존한다. HQ 문서7개만 제출하며 제품·테스트·타 부서 원본은 수정하지 않는다. 원격 게시와 다른 채팅의 전달·숙지 완료는 구분한다.
- 명세 변경 필요 **NONE**. 이미 승인된 의미/한정 종료/비차단 처분을 반영한다. F-08 최종 규격·DEV-027 전체/Stage 최종 수용은 별도 미결이다.

## 9. 공식 근거

- [기존 HQ S3-11/12 및 S3-10 인수 기준][S3]
- [부서 공통 GUI 검수·증거 재사용 지침][PROTOCOL]
- [DEV 공동 잔여 처분표 — §2~7 과거 상태와 §8~9 후속을 함께 적용][RES]
- [DEV-026 EX20/X7 검증 대응표][PLAN26]
- [DEV-026 RP 계약·P07 승인 후속][CON26]
- [DEV-027 DI-03 승인 의미·후속 범위][PLN]
- [F-08 O/M 적용표][F08] / [MVP 선택 완료][FMVP] / [이름·아트 기준 수신 완료 및 실제 공급 잔여][FNAME]

아래 링크는 고정 SHA 또는 공식 댓글 정본이다. 후속 자료가 생기면 새 판정을 덧붙이고 과거 실패·PARTIAL·NOT_RUN을 소급 덮어쓰지 않는다.

[S3]: https://github.com/wisberry2022/MetroManager/blob/1c4481187980fe6b37de0fec8e0019f2736ce1f2/docs/hq/PM-020_STAGE3_EXECUTION_PLAN.md
[PROTOCOL]: https://github.com/wisberry2022/MetroManager/blob/1c4481187980fe6b37de0fec8e0019f2736ce1f2/docs/hq/GUI_REVIEW_PROTOCOL.md
[RES]: https://github.com/wisberry2022/MetroManager/blob/1c4481187980fe6b37de0fec8e0019f2736ce1f2/docs/engineering/gate3/DEV-027_RESIDUAL_DISPOSITION.md
[CMP]: https://github.com/wisberry2022/MetroManager/compare/d0f49eb33ec6bd0efebf5352de315b4b16a3ae07...1c4481187980fe6b37de0fec8e0019f2736ce1f2
[O26]: https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7057161624
[B26]: https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7056903693
[EV26]: https://github.com/wisberry2022/MetroManager/blob/1c4481187980fe6b37de0fec8e0019f2736ce1f2/docs/engineering/evidence/DEV-026_S01_EXCEPTION_EVIDENCE.md
[PLAN26]: https://github.com/wisberry2022/MetroManager/blob/1c4481187980fe6b37de0fec8e0019f2736ce1f2/docs/engineering/gate3/DEV-026_S01_EXCEPTION_VALIDATION_PLAN.md
[CON26]: https://github.com/wisberry2022/MetroManager/blob/1c4481187980fe6b37de0fec8e0019f2736ce1f2/docs/engineering/gate3/DEV-026_S01_EXCEPTION_CONTRACT.md
[A3A]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7073746341
[B3A]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7073690611
[J3A]: https://github.com/wisberry2022/MetroManager/blob/cc8814097634013be8df8b27f166bdee09c7bac6/docs/engineering/evidence/DEV-027_SESSION_PIPELINE_L2_RESULTS.json
[AN]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075072443
[BN]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075447846
[SCREEN]: https://github.com/wisberry2022/MetroManager/blob/37596bd6d646f9d0454280477e60a2e652f06613/docs/engineering/evidence/DEV-027_SCREEN_INTEGRATION_EVIDENCE.md
[JSCREEN]: https://github.com/wisberry2022/MetroManager/blob/37596bd6d646f9d0454280477e60a2e652f06613/docs/engineering/evidence/DEV-027_SCREEN_INTEGRATION_RESULTS.json
[GUI]: https://github.com/wisberry2022/MetroManager/blob/1c4481187980fe6b37de0fec8e0019f2736ce1f2/docs/engineering/evidence/DEV-027_GUI_REVIEW_FOLLOWUP.md
[A177]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7077287550
[B177]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7077351699
[A178]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7217256518
[B178]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7217623381
[JKEY]: https://github.com/wisberry2022/MetroManager/blob/03c7d9346f49eb04347343e6e7f510cf9f549d47/docs/engineering/evidence/DEV-027_F04_RESTORE_RESULTS.json
[A182]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7218342889
[B182]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7218774784
[JWHEEL]: https://github.com/wisberry2022/MetroManager/blob/d0f49eb33ec6bd0efebf5352de315b4b16a3ae07/docs/engineering/evidence/DEV-027_F04_WHEEL_RESULTS.json
[A184]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7235832194
[B184]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7235848546
[A184S]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7235888443
[PLN]: https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7216239510
[F08]: https://github.com/wisberry2022/MetroManager/blob/1c4481187980fe6b37de0fec8e0019f2736ce1f2/docs/design/tasks/DSG-008_PM021_F08_APPLICATION_MATRIX.md
[FMVP]: https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7070990615
[FNAME]: https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7073024413
