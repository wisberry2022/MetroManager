# DSG-008 — Agent 등록 확인·F-08 후속 협의 준비

- 담당: Design / Track B / Agent-ID: AGT-DSG-0003 / v0.1 / 2026-11-08
- 상태: REVIEW / OWNER_GIT_SUBMISSION_APPROVED / ISSUE_POSTED / F08_OPEN / FINAL_SPEC_PENDING / NOT_DONE
- 기준 main: `29d8d05a3a6b134bb89c0e4f500d0f52cc09d660`
- 작업 브랜치: `codex/DSG-008-f08-review`
- 연관: [1단계 결과](DSG-008_RESULT.md), [RFC 준비안](RFC-DSG-008-F08-01_TECHNICAL_REVIEW.md)

## 1. 이번 Owner 지시와 실행 범위

본 Track B 세션의 Owner 직접 지시:

> PR을 승인하였습니다.
> 디자이너 에이전트. 인프라 에이전트가 당신에 대한 공식 Agent ID를 부여했습니다. 원격 저장소를 확인한 뒤 다음 작업 진행해주세요

공개 원문 URL은 제공되지 않았다. 이 지시에 따라 원격 상태 확인과 승인된 DSG-008의 후속 기술 협의 준비를 수행했다. 최초 보고는 신규 Git 제출·발송 전 로컬 검토본이었다. F-08 회신 후 최종 규격 확정이라는 기존 조건과 승인된 1단계 6개·기존 저자/승인/검증 기록을 보존한다.

후속 Owner 제출·DEV 이슈 전달 승인:

> DSG-008 후속 문서 2개의 커밋·푸시 및 PR 생성을 승인합니다. F-08 기술 협의 요청도 이슈사항으로 DEV에 전달할 수 있도록 해주세요. 미해결 항목과 NOT_RUN, 최종 규격 미확정 상태를 명시하고 main 병합은 하지 마세요.

대상은 `wisberry2022/MetroManager` / DSG-008 / 현재 브랜치 `codex/DSG-008-f08-review` / §3 신규 문서2개다. 정상 훅·정책·제출 사전 검사 후 Commit·일반 Push·base=main PR 및 F-08 DEV 기술 협의 이슈 등록·제출물 연결을 수행한다. 이번 제출과 같은 범위의 검증·연결 보완까지 유효하며 별도 날짜 만료는 제시되지 않았다. main 직접 수정·병합·자동병합·릴리스·배포·force push·타 부서/정책/CI 변경은 제외한다. 기술 회신이나 최종 규격을 임의 확정하지 않는다.

## 2. 원격 확인 결과

| 항목 | 확인 결과·근거 |
| --- | --- |
| PR #90 | MERGED / 2026-11-08T07:24:17Z / merge SHA `96139dfb1fd26f449e84e7f08986b0ab17e06787`. 이번 세션에서 병합 실행하지 않음 |
| INF-004 / PR #91 | main 반영. 최신 main SHA는 위 기준과 같음 |
| 공식 ID | [registry](../../infra/agents/registry.json)의 AGT-DSG-0003 / DSG / ACTIVE / generation1 / predecessor=null |
| 효력·연속성 | 2026-11-08T16:25:00+09:00 / 기존 DSG-006·007·008 독립 Track B 담당 연속. Track A 세대교체 아님 |
| 과거 기록 | 당시 미등록 문구·PR #90 PRIMARY_COUNT 진단은 해당 시점 사실로 보존. 신규 등록으로 과거 출처 검사가 자동 정정됐다고 표시하지 않음 |
| 권한 한계 | INF ACTIVE 등록은 기술적 신원 인증·기존 산출물 인수·포괄 디자인/Git 권한이 아님 |
| F-08 | 기준 main의 DEV/HQ 경로, Issue #24·#25 본문/댓글에서 네 항목에 대한 최종 기술 답변·제품 결정 미확인. OPEN 유지 |

등록부 root의 `OWNER_APPROVED_PENDING_MAIN_MERGE`는 INF-004가 의도적으로 보존한 과거 메타데이터다. 해당 문자열만으로 개별 신규 ACTIVE 행의 실제 main 반영을 부정하거나 Design이 등록부를 정정하지 않는다. INF 티켓의 승인 참조·실제 원격 트리·PR 병합을 함께 확인했다.

## 3. 변경 파일과 진척

| 신규 파일 | 완료한 준비 |
| --- | --- |
| [RFC-DSG-008-F08-01_TECHNICAL_REVIEW.md](RFC-DSG-008-F08-01_TECHNICAL_REVIEW.md) | 기존 상태표 §4 초안을 구체화한 DEV 질문·필요 증거·대안·반영/차단 기준 |
| 본 기록 | 공식 ID 확인, 승인 이력 분리, 후속 검증표·미실행·다음 책임 |

현재 코드·설정의 정적 관찰을 RFC에 연결했다. 브라우저 CSS px와 Godot 크기를 동치로 삼지 않으며, 현행 가로 컨테이너가 브라우저 반응형 A/B처럼 동작한다고 가정하지 않는다. 목업·PNG·토큰과 게임 소스는 이번에 변경하지 않았다.

## 4. 회신 후 검증과 확정 게이트

아래는 계획이며 실행 PASS가 아니다. 최종 측정 환경·지원 범위·합격 수치는 협의 후 Owner 결정에 따른다.

| 검증 ID / F-08 | 후속 대조 항목 | 합격 판단에 필요한 증거·책임 |
| --- | --- | --- |
| S01-T01 / 01 | 창·배율·긴 한국어·큰 정수 금액·키보드 포커스 | DEV가 환경/후보별 실제 Godot 화면·입력 근거, Design이 누락/잘림·읽기 순서·가려진 행동과 대체 경로 대조. 크기 후보 확정은 Owner |
| S01-T02 / 02 | 정수/비정수 배율·텍스트/배경 선명도·경계선 | 같은 장면/설정별 원본 비교, 선택한 필터/글꼴과 타협점 기록. 시각 판정과 FPS 실측을 구별 |
| S01-T03 / 03 | 12후보·6/8역·5/9역·중복/단절·잠금·정보 선택 | DEV 실제 공급/명령 fixture와 지도↔목록 같은 ID·대상·판정, 키보드·가림·되돌리기. Track B 표현 검토와 Track A 제품 수용 구분 |
| S01-T04 / 01·03 | 현재/이전 예측·유효0/없음/오류·당시 거부와 현재 행동 | 최신 공급 revision·기간/게임시각 유지. 0예측의 운영비를 0으로 만들지 않음. 늦은 응답·실제 대기 경로는 별도 실행 증거 필요 |
| S01-T05 / 01·04 | 현재 C/R/F/K/A/B, 발생·즉시지급·정산·총 현금지급, 과거보고 | 같은 완료 시점·공급 값 보존, 현재로 과거 덮지 않음, R/K 중복차감·B만의 사업차단 금지. UI에서 합계 재계산 안 함 |
| S01-T06 / 04 | A/B 높이 예산·지도와 편집 시선 이동·스크롤/포커스·재사용 | 같은 정보량/장면에서 실제 게임 비교. 전체 문서 PNG 높이를 제품 창 크기로 해석하지 않음. DEV 인계 구조와 Design 배치 대안 연결 |
| S01-T07 / 04 | 정지/배속·상태 갱신·지도 표현 부하·대상 PC 성능 | DEV가 측정 환경·장면/개체 수·재현 입력·방법·raw 기록 제시. FPS/상한 목표 미승인 시 합격 선언 불가; W09 최종 인수 별도 |

진행 순서:

1. Owner 승인에 따라 [Issue #92](https://github.com/wisberry2022/MetroManager/issues/92)에 RFC와 네 항목의 기술 의견·기존/추가 증거를 요청했다. 후속 문서 PR도 연결한다. DEV 수신 확인·회신·합의는 PENDING이다.
2. 회신 항목별로 정적 의견·실측·실험 필요를 분리하고, 미회신 항목은 OPEN 유지한다.
3. Design이 영향 있는 배치/토큰/상태만 갱신할 대안을 작성한다. 기존 승인 UI-DC-01~07 전체 재수용을 요청하지 않는다.
4. HQ 통합 및 Owner의 환경·규격·배치 결정을 연결한 뒤 해당 상세 규격을 확정한다.
5. 실제 Godot 적용·제품 GUI·성능 인수는 담당 DEV/Design 후속 승인 범위에서 수행한다. DSG-009 대량 에셋은 별도 승인 후다.

## 5. 미해결 의존성 — OPEN

F08-01 화면/글꼴/배율, F08-02 렌더링, F08-03 지도/입력, F08-04 적용/재사용/성능 모두 OPEN이다. RFC 준비·Agent-ID 등록·PR 병합을 기술 회신으로 대체하지 않는다. F-08 외에는 DSG-006 시각 원본 공용 보관, Owner 최종 배치 선택, 후속 실제 적용·인수 등이 남아 있다. Track A QA나 Stage 2 전체 수용은 본 작업으로 변경하지 않는다.

## 6. 검증 결과·NOT_RUN

실행한 검증과 미실행 검증을 구분한다. 검사 명령·실제 결과는 아래에 기록하며 자동 게임 테스트와 혼동하지 않는다.

- 원격 fetch·PR #90 상태·main 등록부·INF-004 대조: 확인 완료.
- 변경 전 `.venv/Scripts/python.exe tools/policy.py doctor`: PASS (원격 보호·Owner 진위 검증 아님).
- 정적 소스·프로젝트 설정·기존 IA/상태·RFC 템플릿 대조: 완료.
- `.venv/Scripts/python.exe -`의 읽기 전용 Python 검증: PASS. 정확한 신규 Design 문서2개·기존 추적 파일 무변경, UTF-8/BOM 없음·LF·끝 개행·trailing whitespace 없음·상대 링크 존재, 네 F08-ID·담당 ID 및 trusted main 등록부의 ACTIVE/scope 일치를 확인했다. 게임 테스트가 아니다.
- `.venv/Scripts/python.exe tools/policy.py check`: PASS (`worktree files=479, GDScript=31`, formatter/linter 정상). `git diff --check`: PASS. 신규 파일 텍스트는 위 별도 검증으로 확인했다.

| 구분 | 상태·이유 |
| --- | --- |
| DEV 이슈 전달 | Issue #92 등록 완료 / 수신 확인·DEV 회신·HQ 조정 PENDING. 테스트 NOT_RUN과 별도 협의 상태 |
| 자동 게임 테스트 | NOT_RUN — 게임 변경 없음 |
| Godot 프로젝트 로드 | NOT_RUN — 기술 실험/실제 적용 미수행 |
| 게임 플레이·실제 GUI 검증 | NOT_RUN — 검증표는 후속 계획 |
| Windows 빌드 | NOT_RUN — 후속 W09 범위 |
| 대상 PC 성능·폰트/접근성·외부 사용성 | NOT_RUN — 환경·합격선 미확정 |
| 브라우저 620건 재실행 | NOT_RUN — 1단계 원본 미변경, 기존 결과를 새 실행으로 보고하지 않음 |

최초 보고에서는 Commit·Push·PR·원격 CI를 수행하지 않았다. 후속 Owner 승인에 따른 실제 제출 head·base, 정상 훅·preflight·원격 필수 검사와 REPORT_ONLY 출처 진단은 PR에 별도 기록한다. 승인된 변경은 신규 문서2개이며 게임/목업 테스트 NOT_RUN과 Git 제출 결과를 혼합하지 않는다. Agent-ID는 등록된 AGT-DSG-0003으로 선언하되 신원·승인 기술 인증을 뜻하지 않는다. 별도 출처 Manifest는 승인된 두 문서 범위에 추가하지 않으며 진단이 있으면 그대로 보고한다.

명세 변경 필요: NONE. 제품 규격은 FINAL_SPEC_PENDING이며 DSG-008 전체·S2-D01·Stage 2 DONE은 선언하지 않는다.
