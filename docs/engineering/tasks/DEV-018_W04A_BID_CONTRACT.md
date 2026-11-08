# DEV-018 — W04A 입찰·낙찰·계약 모델 및 자동검증

- 담당 AGT-DEV-0001 / Development Project Leader LAPTOP / 2026-11-08.
- 현재 상태 REVIEW / OWNER_EXECUTION_AND_GIT_APPROVED. §1~8은 준비·승인 수신 당시 이력이며 현재 승인/구현/검증은 §9 및 결과 문서를 따른다. 공식 DONE/main 병합은 Owner 별도다.
- 기준 main `b48dd82a9b93d062d1a3bcfdf8750cb260c83e3e`, [PM-014](../../hq/PM-014_STAGE2_VS01_EXECUTION_PLAN.md), [Stage1 DONE](../../hq/PM-012_STAGE1_ACCEPTANCE_RECORD.md#7-owner-최종-종료-결정과-qa-후속-관리-인계), [분할안](../gate3/DEV-018_STAGE2_EXECUTION_BREAKDOWN.md).
- 작업 브랜치 `codex/DEV-018-bid-contract-model`. 최신 main의 독립 worktree에서 문서만 준비했다. Commit/Push/PR 및 신규 코드/테스트/씬은 아직 없다.
- 실행 승인 패킷은 [Issue #74](https://github.com/wisberry2022/MetroManager/issues/74)에 등록했다. Planning [RFC-DEV-018-01](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6715929346), Design [공급 협의](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6715951143)를 연결한다.
- Owner가 전달한 HQ 지시는 개발 착수 준비·티켓/검증 계획 수립이다. Stage2 계획·기존 DEV-015 승인을 이 티켓의 제작/Git 승인으로 재사용하지 않는다.
- ID 점검: main 작업 파일·원격 전체 Issue/PR(현재 총73개 범위), 실제 원격 브랜치·로컬 refs/전체 커밋 제목·worktree 파일명 확인. DEV-017은 Convention이 사용 중. DEV-018~024 중복 없음 확인 후 티켓 추적 등록 대상으로 선정. Issue 번호/후속 상태는 분할안에 연결한다.

## 1. 목표와 인수 경계

W02/W03를 재사용해 B01/B02 공고·관할·접수·자격·점수·마감·낙찰/탈락·계약/정부 지급의 실제 모델을 만든다. B-X는 관할 밖 데이터로 실제 목록에 비노출한다. 판정 당시 자격/점수·고정 조건·계획/회차·효력 시각·명령 결과를 보존하며 신규 계약/정부 지급은1회여야 한다.

이 티켓은 **S2-02/03의 모델·자동 부분**과 S2-01 회귀/S2-11 증거를 담당한다. 공고·응찰·결과 실제 GUI와 Design 수용은 DEV-019에서 연결한다. DEV-018 자동 PASS만으로 S2-02/03 전체·VS-01 완주를 선언하지 않는다.

## 2. 포함·제외

- 포함: C01 B01(시청/P-A)·B02(정부/P-B) 및 비노출 B-X 검증, 운임100/정부 사업비800000/공기2880 고정, 접수 [360,1800) 경계, 마감 판정, 7×이행능력+3×재무점수의 정수 비교(860 vs800, 표시86 vs80), 동점 경쟁자 공개우선순위.
- 자격/종료회차·중복 진행·관할/공기 이행 조건과 이유를 권위 모델에서 제공한다. 같은 command_id 재호출·서로 다른 ID의 같은 종료 결과 재수신 모두 계약/정부 지급 중복을 막는다.
- 낙찰 뒤 정부 신규 심사/RNG를 넣지 않는다. 유효 계약은 기존 원장의 정부금·R/K/B 의미를 사용한다. 정상 계약 후 C1800000/R800000/F1000000/K0/B0을 검증한다. B>0 자체를 새 계약제재로 쓰지 않는다.
- 제품용 계약 공급 경로는 기존 단일 Pipeline의 CONTRACT 단계와 연결하고 완료 관측을 제공한다. 기존 테스트 전용 set_fixture 사건을 실제 제품 사업 확보 입력으로 재사용하지 않는다. 구체 클래스 연결 방식은 구현 시 최소 범위로 선택하되 원장·시각 권위의 소유자를 복제하지 않는다.
- 제외: 실제 공고/응찰 화면(DEV-019), W05/W06 제작, W04B·정부 심사·설득·사실 소비·게임 RNG, 고충실도 아트·DSG-006 결과 의존, Windows export/성능·배포, 정책/CI·타 부서 문서·Stage1 원본 재작성, 범용 이벤트/세이브 프레임워크.

## 3. Owner가 승인할 정확한 경로

| 경로 | 용도 |
| --- | --- |
| assets/data/stage2_tenders_v1_3.json | 승인 DATA를 출처/버전과 함께 고정한 입찰 입력. 새 수치/공고 규칙을 만들지 않음 |
| scripts/data/tender_data_loader.gd | 기존 W01 로더를 변경하지 않는 입찰 데이터 검증 |
| scripts/model/public_tender.gd | 공고·자격·접수·판정/종료 회차 상태 |
| scripts/simulation/tender_service.gd | 명령/마감/유효 계약 공급·중복 효과 방지 |
| scripts/simulation/minute_pipeline.gd | 기존 CONTRACT 단계에서 실제 입찰 결과/계약을 연결하는 한정 변경. SEM/CLOSE 순서 보존 |
| tests/game/run_w04a_tests.gd, tests/game/w04a_fixtures.gd | 정상·반례·원장/시간·멱등성의 실제 엔진 자동검사 |
| 신규 .gd 각각의 .gd.uid | 엔진 생성 식별자 보존 |
| 본 티켓·docs/engineering/tasks/DEV-018_RESULT.md | 실제 승인·변경·검증·불일치/NOT_RUN 결과 |
| docs/engineering/gate3/DEV-018_STAGE2_EXECUTION_BREAKDOWN.md | 준비 분할안/의존성/S2/F-ID 추적 |
| docs/engineering/tasks/DEV-018_PROVENANCE.json | 현 출처 운영 규칙에 따른 실제 제출 선언(필요 필드만, 승인 진위 자체 생성 금지) |
| docs/engineering/evidence/DEV-018_*.md 또는 .json | 최소 재현 입력/기대·실제·명령/원장/시각/종료코드. 개인 대화·절대 개인 경로 제외 |

**읽기 전용:** company_ledger.gd·daily_ledger_report.gd·game_clock.gd·command_queue.gd·RoutePlan/Network·W01 초기 상태/데이터 및 기존 W01~03/W07 검사, UI/scene/project.godot, 기획/디자인/HQ/INF, 정책/CI. 필요 경로를 추가해야 하거나 승인 의미가 불가능하면 영향·대안을 RFC로 보고하고 해당 변경을 승인 범위에 넣기 전 구현하지 않는다.

## 4. 선행·L2/L3·차단

- Stage1 DONE/기존 W02/W03 기반은 준비됨. Planning은 RFC-DEV-018-01의 영향 의미 행만 회신. 판정 시점 재무점수, 시간 외 접수/효력/마감 관계, 낙찰 계약과 W05 공사 모드/K 예약 연결을 명료화한다.
- 답변 전 영향 판정 구현은 보류한다. 자료 로드/독립 상태 계약 설계는 해당 부분 Owner 실행 승인 후 가능하다. 명확한 기존 수치/SEM을 재승인 요청하지 않는다. 정책 변경/충돌이 발견될 때만 HQ/L3·Owner 결정으로 올린다.
- Design에는 모델 snapshot/정상·실패 fixture를 공급한다. DEV-019 UI 통합 전 UI-DC-03/05/07의 영향 행을 합의하며 콘셉트/픽셀 아트 완성을 선행으로 요구하지 않는다.
- 기본 L2, 단일 Pipeline CONTRACT 연결은 공통 시각/원장 L3 위험 검토와 회귀 책임을 명시한다. 기존 SEM-01~03/CLOSE-01 정책 변경은 승인안에 포함하지 않는다.
- DEV-020의 모델 설계/반례 준비는 독립 승인 뒤 병행 가능하나 실제 공사 통합은 이 티켓의 유효 계약·정부 지급 수용이 선행이다.

## 5. 검증·완료 증거 (모두 실행 예정)

- 정상 B01/P-A 및 B02/P-B·B-X 비노출, 잘못된 ID/관할·고정값 변경·중복 진행·공기 이행/자격 실패.
- 접수 시작 직전/정각·마감 직전/정각, 업무시간/효력의 확정 의미에 따른 경계. 고정 점수860>800, 동점800=800 공개우선순위 탈락, 경쟁 근거·판정 사본 보존.
- 접수/판정/계약·정부 지급의 상태·시각 구분, command_id 반복·다른 ID 재응찰/같은 종료 결과 재소비·stale 계획/회차의 상태·원장 부작용 없음.
- 정상 정부금800000 1회, C/R/F/K/A/B 및 원장 항목 기대/실제 일치. 같은 T 후순위 도착 운임 선사용 금지, B 상환과 K 예약의 기존 규칙 보존.
- 동일 초기/명령/효력시각의 일괄/분할·정지·1/2/4배속 결과 일치, 기존 W01/W02/W03/W07(951단언 기준) 및 정책 전체 회귀. 새 W04A 실패 감지 옵션은 정상0/의도 실패1을 검증한다.
- 예정 명령: .venv/Scripts/python.exe tools/policy.py doctor/check, 정책 unittest; Godot4.7.2 --headless --path . --script tests/game/run_w04a_tests.gd; 기존 러너; -- --verify-failure-exit; --headless --editor --path . --quit; 제품 headless 진입. 실제 명령/횟수/로그·SHA·종료코드는 결과에 기록.
- 커밋 정상 훅→fetch/preflight→작업 브랜치 일반 Push 또는 정책 API 공유→PR policy/department-policy. REPORT_ONLY 출처 job은 신원/Owner 인증과 구분한다.
- 이 모델 티켓의 신규 W04A 실제 제품 GUI·Design 최종 수용/VS-01·빌드·성능은 NOT_RUN/후속 DEV-019~024이며 자동 검사로 승격하지 않는다.

## 6. 개별 실행·Git 승인 요청

대상 wisberry2022/MetroManager / DEV-018 / 위 단일 작업 브랜치·§2~5 범위/경로. **구현·관련 자동/엔진 검증, Commit, 해당 브랜치 일반 Push 또는 정책 API 공유, base=main PR 생성·필수 CI 확인 및 동일 범위 검수 수정**을 요청한다. 기간은 명시 승인부터 이 티켓 검수 대응까지다.

main 병합·강제 push/공유 이력 재작성·릴리스/배포·DEV-019~024 실행은 별도 승인이다. W04A GUI를 포함한 Stage2 전체 구현을 포괄 승인받는 요청이 아니다. 현재 제작/Git 승인 미확인으로 코드/테스트/씬·Commit/Push/PR을 실행하지 않았다.

## 7. 준비 검증

실제 수행은 원격 fetch/PM-014·승인 원본/현재 모델·Issue/PR·refs/ID 검색·doctor 및 문서 구조·링크 검토다. Stage1은 PM-013/PM-012의 Owner 최종 DONE 및 기존951개 게임 단언·제품 GUI 증거를 기준으로 재사용한다. 이번 Stage2 자동/로드/실제GUI·VS-01·빌드/성능/CI는 NOT_RUN이다. 준비 결과는 STAGE2_DEV_SCOPE_ACKNOWLEDGED / W04A_EXECUTION_TICKET_READY(승인 패킷 준비)다.

준비 worktree의 전용 .venv doctor/check PASS(worktree files396/GDScript22), UTF-8/LF·상대 문서 링크·S2/F-ID와7개 등록 ID를 검토했다. 정책 전체 테스트·Godot/제품 GUI는 이번 NOT_RUN이며 문서 검사를 게임 검증으로 보고하지 않는다.


## 8. Owner 실행·Git 승인 수신 — 2026-11-08

- 근거: 현재 Development / LAPTOP의 Owner 직접 메시지. 원문: “개발 에이전트. Issue #74의 DEV-018 W04A 구현 및 Commit·Push·PR 생성을 승인합니다. Planning의 RFC-DEV-018-01 회신을 확인한 뒤 티켓 범위만 작업하고 검증 후 PR 생성해주세요. main 병합은 별도 승인하겠습니다.”
- 이 절은 위 준비 당시 승인 대기 기록 이후의 상태 갱신이다. DEV-018의 §2~6 경로·구현/검증·Commit·작업 브랜치 Push·PR 권한 수신. main 병합·타 티켓·범위 확대 권한은 없다.
- 현재 실행 조건: WAITING_FOR_PLANNING_REPLY. Issue #26 전체 댓글 및 #74/#25/#24 관련 댓글·저장소 RFC 검색 결과, RFC 질의 #6715929346 외 Planning의 답변은 확인되지 않았다. 미회신을 승인된 의미로 추정하지 않는다.
- 미결 입력: 판정 당시 F/재무점수·자격 시점; 응찰 접수와 업무시간 이연/마감 및 계약 효력 관계; W05 공사 모드/K 예약·공기 이행 가능 자격의 입력 의미.
- 최신 원격 main과 fetch된 origin/main은 b48dd82a9b93d062d1a3bcfdf8750cb260c83e3e로 일치. 독립 worktree·기존 미커밋 준비 문서 2개 보존, doctor PASS. 코드·테스트·씬 변경 및 Commit/Push/PR은 아직 미수행. Stage2 자동·로드·GUI·빌드는 NOT_RUN.
- Owner가 명시한 ‘회신 확인 후 작업’ 순서를 준수하여 이번에는 승인/차단 상태만 기록한다. 회신 확보 후 권한을 재요청하지 않고 동일 티켓 범위의 구현·검증·PR을 진행할 수 있다.

## 9. 선행 회신 확인 및 실행 승인 적용

- Planning [회신 #6716236853](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6716236853) 수신으로 §8의 대기 조건 해소. 마감 당시 F 점수, 야간 응찰 접수, 표준 경로 K0·사업/공사 계약 분리를 반영. 새 규칙/새 L3 요청 없음.
- Owner 현재 직접 지시: “검토한 회신을 Issue #24와 #74에 코멘트로 등록하고, 기존 승인 범위에 따라 DEV-018 구현에 착수해주세요. 티켓 범위만 작업하고 검증 후 Commit·Push·PR 생성까지 진행해주세요. main 병합은 별도 승인하겠습니다.”
- 승인 대상 wisberry2022/MetroManager, DEV-018, codex/DEV-018-bid-contract-model, §2~6의 경로·구현/검증·Commit·일반 Push 또는 정책 API 공유·base main PR 및 동일 범위 검수 대응. 유효기간은 이 티켓 제출/검수 대응까지. main 병합·강제 Push·타 티켓·릴리스/배포 제외. 과거 권한을 새 티켓에 승계하지 않음.
- 검토 회신 게시: [Design #24](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6716315597), [DEV #74](https://github.com/wisberry2022/MetroManager/issues/74#issuecomment-6716316170).
- [결과](DEV-018_RESULT.md), [실제 공급/검증 계약](../evidence/DEV-018_SUPPLY_AND_VALIDATION.md), [Godot fixture](../evidence/DEV-018_W04A_FIXTURES.json). 구현 범위는 모델/자동 부분이며 DEV-019 UI 제작·실제 공공입찰 GUI와 W05는 포함하지 않는다.
