# DSG-008 — 이름 열람 기준·최소 아트 인계목록 로컬 결과

- AGT-DSG-0003 / Design Track B / 2026-11-22 / v0.1.
- **LOCAL_REVIEW_REQUESTED / O01_O07_OWNER_DIRECTION_APPROVED / MVP_RECOMMENDATIONS_OWNER_SELECTED / FINAL_SPEC_PENDING / F08_OPEN**.
- 기준 main `5d7f57fd6c47df1747cb312d996c73c77338e4f9` (PR166 P1 모델 병합본).

## 1. 요청·소관 범위

Owner: “DEV 회신을 반영해 Track B 담당인 동명이름 구별·읽기순서·전체 이름 열람 기준과 최소 디오라마 아트 인계목록을 정리해주세요. 기존 Owner 선택을 보존하고 최종 규격 미확정·PARTIAL·NOT_RUN을 구분해 로컬 산출물로 먼저 검토 요청해주세요.”

[DEV 회신](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7071365138)의 N1 표현 입력·A1 인계목록 요청을 로컬 문서로 준비했다. 소관 디자인4파일만 변경하며 실제 이름 작명/데이터 추가·새 아트 제작·폰트 반입·제품/guard/loader·타 부서/정책/CI를 수정하지 않는다. DEV의 미게시 로컬6문서를 원격 근거나 새 완료 조건으로 요구하지 않는다.

## 2. 산출물4개

| 파일 | 인계 내용 |
| --- | --- |
| [역 표시명/읽기 기준](DSG-008_STATION_NAME_READING_CRITERIA.md) | NR01~13: 동명ID 구별·공급/계획 순서·독립 전체 이름 열람·권위 효과·잠금/오류·이름 버전 갱신, 최소 사례 |
| [최소 디오라마 아트 목록](DSG-008_MINIMUM_DIORAMA_ART_HANDOFF.md) | DA01~08: 참고/재사용/조건부 신규 역할·실제 source/export 인계 필드·의미/입력 보존·최소 확인. 실제 이미지8장 아님 |
| 이 결과서 | 권한·변경/검증·미결·과거 이력과 로컬 검토 요청 |
| [출처 선언](DSG-008_PROVENANCE.json) | 이번 신규 Markdown3개의 base/blob·근거. 기존 main manifest는 Git 원본에 보존. REPORT_ONLY이며 신원/승인 인증 아님 |

이름 표시는 `[승인 표시명] · S01`처럼 **승인 콘텐츠 변수+ID**로 설명했고 실제 역명을 창작하지 않았다. 읽기는 후보의 공급 순서와 계획의 실제 순서를 분리한다. 현재 미포함역 클릭이 편집 명령일 수 있으므로 전체 이름을 읽기 위해 그 명령을 실행하도록 요구하지 않는다. 별도 읽기 경로의 정확한 Control/키와 namespace/L2는 DEV 제안으로 대조할 잔여다.

아트는 DSG006 원본/파생물·DSG007 production_ready=false 토큰과 현행 draw/Control을 조사했다. 재사용 **방향/참고**와 실제 제품 자원 공급을 구분했으며 기존 PNG를 spritesheet나 전체 UI 텍스처로 채택하지 않았다. 미래 source/export 경로·치수/개수·게임 import를 임의 확정하지 않았다.

## 3. 기존 선택·후속 책임

O01~07 승인 및 [S1/E1/F1/N1/A1/P1 Owner 선택](DSG-008_MVP_SCOPE_ENV_OWNER_OPTIONS.md#7-owner-결정제출-후속--2026-11-22)을 그대로 따른다. [공급·검증 계획](DSG-008_MVP_SUPPLY_VALIDATION_PLAN.md), [공통표](DSG-008_PM021_F08_APPLICATION_MATRIX.md), [DEV/Track A 준비 경계 확인](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7057978655)을 재사용하며 같은 선택·첫 기술 회신을 재요청하지 않는다.

| 담당 | 다음 입력·시점 |
| --- | --- |
| Owner/HQ | 콘텐츠 작성/승인 담당·실제12행 공급 창구, 기준 PC 제공 주체/목적·현용 배율 확보. 선택 자체 재승인 아님 |
| 콘텐츠 담당 | 승인 id/display_name 표·출처/버전/locale·승인 주체. 데이터 의미 변화가 실제 있으면 Planning 확인 |
| DEV | NR 기준에 대한 실제 표시/오류 격리·거부 단위/캐시·읽기/편집 경로·namespace/지역 의존표·추가 경로/권한 제안. 실제 공급·해당 L2 후 UI 연결 |
| Track B | 이번 NR/DA 로컬안 검토 후 실제 환경/승인 이름·선택 역할에 연결해 공급/판독 준비. 실제 아트 제작은 별도 범위 |
| Track A | 실제 변경 기능/동선 행만 한 패킷에서 공동 대조. 기존 준비 검토를 반복하지 않음 |

이번에는 요청된 NR/DA 문서 준비까지이며 원격 전달은 NOT_SENT, 공동 L2/제품 검증은 PENDING이다. 일정/공수 NOT_ESTIMATED. DEV027 P1 구현·검증/main 반영은 완료 범위로 보존하되 Session/Pipeline·W04B 화면·자연 VS02는 아직 별도다. F08 전체 확정을 그 비의존 부분의 일괄 선행조건으로 만들지 않는다.

## 4. 미결·PARTIAL·NOT_RUN

- **최종 규격 미확정/F08 OPEN:** 실제 이름 콘텐츠/담당·schema/namespace/오류/버전 계약·정확한 열람/키보드 경로, 지원 PC/DPI·창·폰트/배포 구성, 실제 아트/수출물·필터/치수·마커·배치·성능 목표/인수는 미확정. 이번 NR/DA는 로컬 제안이며 N1/A1의 실제 공급/L2 수용이 아님.
- **PARTIAL/INCONCLUSIVE:** DEV025 B 전환 후 포커스 가시성·겹침 마커, DEV026 고정일1 비영점 중첩 복귀 미관측·내부 수명/옛 callback 추가 OS 가시성 한계는 보존. P07 일반 재진입/저장 문맥 복귀 구분과 현재 공급 한정 수용 유지. 제안 목록으로 과거 문제를 PASS/수정 완료로 바꾸지 않음.
- **이번 NOT_RUN:** 이름 데이터/코드 구현·자동 게임검사·Godot 로드·브라우저/GUI·실제 입력/플레이·새 아트 생성/수출·font/filter/DPI 실측·성능·빌드/export·사용성. 기존 raw 직접 재해시·실물 환경/물리 DPI·새 자원 배포권은 NOT_VERIFIED.
- **기존 실행 재사용:** DEV025/DEV026 및 DEV027 P1 자동425·회귀805·로드는 원 수행 범위로 보존하며 새 검사로 집계하지 않음. 과거 실패·의도 실패·미포착·NOT_RUN 원문은 수정하지 않음.
- **인수·명세:** 실제 W04B L2·S3-10-C·S3-12/Stage 최종 인수는 별도. PLN016 정책 결정 완료와 종속 구현/검증 대기를 구분. 새 게임·경제·시간·세이브 규칙 변경 요구 없음. 실제 계약 충돌 발견 시 영향 행만 기존 RFC로 연결.

## 5. 로컬 검증·보존

작업 브랜치 `codex/DSG-008-name-art-handoff`의 별도 worktree를 사용한다. 공유 main 기존 데이터2개 변경·이전 작업물·원문/승인 이력은 보존한다. 기존 디자인 자료는 읽기만 했고 이번 diff는 신규 Markdown3개+기존 provenance 갱신1개다.

검증 명령: 루트 venv Python으로 `tools/policy.py doctor`/`check`, `git diff --check`, UTF-8/LF·상대 파일 링크·NR13/DA8행·변경4개/기존 파일 불변·출처 blob 대조. 참고 원본6개(DSG006 명세/추가4안 HTML/디오라마 PNG·DSG007 토큰/HTML/PNG)의 경로·SHA256은 `.local/validation/name-art-handoff/audit.json`에 기록한다. 해시/소스 조사이며 새 이미지 육안·브라우저 렌더/게임 검증이 아니다.

검증 결과: doctor PASS / check PASS(exit0, worktree758개·GDScript63개) / git diff --check PASS. UTF-8/LF·상대 파일 링크·NR01~13/DA01~08·변경4개·기존 자료 불변·출처3개 blob·참고 원본6개 해시 기록 PASS. 게임/GUI·새 아트 제작/렌더 검증은 아니다. 커밋하지 않아 preflight·새 원격 CI는 NOT_RUN이다.

## 6. 로컬 검토 요청

Owner에게 NR 동명 구별·공급/계획 읽기순서·비편집 전체 열람과 버전/오류 경계, DA 최소 역할의 재사용/조건부 제작 구분을 검토 요청한다. 검토 후 유효한 전달 범위에서 DEV/HQ에 인계할 수 있다. 이번 요청으로 커밋·푸시·PR·이슈 댓글·main 병합·외부 전송·제품 실행은 수행하지 않는다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008

## 7. Owner 제출 승인 후속 — 2026-11-22

위 로컬 미제출 기록은 당시 이력으로 보존한다. 현재 디자인 채팅에서 Owner가 다음과 같이 승인했다.

> DSG-008 이름 열람 기준·최소 디오라마 아트 인계 산출물 4개의 커밋·푸시 및 PR 생성을 승인합니다. 기존 Owner 선택과 과거 기록을 보존하고, 최종 규격 미확정·F-08 미결·PARTIAL·NOT_RUN을 PR에 명시해주세요. main 병합은 하지 마세요.

대상은 wisberry2022/MetroManager / DSG008 / `codex/DSG-008-name-art-handoff`의 위 4개 파일이다. 이번 커밋·일반 푸시·PR 생성에만 유효하며 main 병합·릴리스/배포·이슈 댓글·새 제품/아트 제작·실험 권한으로 확대하지 않는다. 승인 출처는 현재 Owner 채팅의 이 요청이며 원격 승인 URL은 제공되지 않았다.

제출 전 fetch에서 main은 `cef43fca6f96d9b6e53cfe91584a7a4cae77bbbc`로 진전했다. 작성 base 이후 변경은 INF013의 등록부/인프라 문서3개뿐이고 디자인/제품/시험/설정은 동일하다. 미게시 작업 브랜치를 무충돌 fast-forward로 갱신했다. 일반 작업 커밋의 부모는 최신 main1개, base-sync merge commit0으로 제출한다. INF013 변경은 이 PR 산출물/수정 범위로 귀속하지 않는다. Track A 협업은 최신 등록 담당과 기존 수용/원문을 연결하며 과거 ID/작성자를 소급 변경하지 않는다.

원래 작성·로컬 검증 base/수치는 위에 보존하고 출처 선언의 제출 base만 최신 기준 및 현재 Markdown3개 blob으로 갱신한다. 정상 훅·doctor/check·원문/링크/NR13·DA8·출처 검사를 거쳐 커밋 후 preflight·실제 head의 원격 필수 CI/REPORT_ONLY 진단을 PR에 연결한다. 합격을 미실행 제품/가독성/아트 검증으로 확대하지 않는다.

O01~07 및 S1/E1/F1/N1/A1/P1 Owner 선택·과거 승인/실패/미포착을 유지한다. 이름 콘텐츠/담당·표시/namespace L2·실제 자원/환경/권리 구성·최종 규격/F08·PARTIAL/INCONCLUSIVE·제품 NOT_RUN·Stage 최종 인수는 별도로 남는다. 실제 역명/아트/제품·타 부서 파일 변경0, 새 게임 명세 변경 요구 없음.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008
