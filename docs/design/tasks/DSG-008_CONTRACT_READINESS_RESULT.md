# DSG-008 — 검수표 수신 회신 후 계약 대조 준비 결과

- 담당: Design Track B / AGT-DSG-0003 / 2026-11-14
- 상태: LOCAL_REVIEW / CONTRACT_INPUT_PENDING / FINAL_SPEC_PENDING / NOT_DONE
- 기준 main: 49590f3f1b870fac2af7c77bb4cf179933699b8d
- 브랜치: codex/DSG-008-contract-review-readiness
- 기록 구분: 아래 로컬 검토·검증은 당시 기록으로 보존한다. 후속 Git 제출 승인은 마지막 절에 추가한다.

## 1. Owner 지시·작업 범위

> 개발 에이전트가 이슈 #104에 회신을 등록했으니 확인해주세요. 회신을 바탕으로 현재 진행 가능한 DSG-008 후속 업무를 진행하고, F-08 미해결 항목과 NOT_RUN을 구분해 로컬 산출물로 먼저 검토 요청해주세요. 최종 규격은 미확정으로 유지해주세요.

원격 회신을 확인하고, DEV 구체 계약 수신 후 영향 행만 대조할 수 있는 작업표를 준비했다. 기존20사례 검수표/문구를 보존하며 같은 내용을 새 제품 테스트로 반복하지 않았다. 제품 구현·DEV 실행 패킷/ID·새 화면/기획 규칙·Track A GUI 재검수를 대신 수행하지 않았다.

## 2. 변경 파일 — 신규2개

| 파일 | 내용 |
| --- | --- |
| [DSG-008_CONTRACT_REVIEW_WORKSHEET.md](DSG-008_CONTRACT_REVIEW_WORKSHEET.md) | DEV 회신7영역↔기존20사례 연결, 실제 계약 수신란·영향 대조·증거 재사용/추가 검수 기준, 최신 한정 수용 연결 |
| 본 결과 | 승인·변경·정적 검증·미해결/NOT_RUN·검수 요청 |

신규2개 모두 docs/design/tasks/ 안이다. 기존 승인·검증·문구/열람기·검수표 JSON·게임/설정·타 부서 파일은 수정하지 않았다. 공유 main의 브랜치를 바꾸지 않고 최신 origin/main 기반 새 worktree에서 작성했다.

## 3. 확인한 사실·새 진척

- [DEV 댓글6873960483](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6873960483), 수정 시점2026-11-14T07:39:58Z: 제품 검수 준비3개와20사례/문구 참조 정적 연결 수신 확인. 새 Design blocker 없음. 다음은 구체 계약·영향 행 대조.
- [#77](https://github.com/wisberry2022/MetroManager/issues/77#issuecomment-6873738131)/[#81](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6873744971)의 최신 한정 수용을 직접 읽고, 과거 재검수 대기 snapshot과 분리했다. 같은28조건 재검수 요구 없음, A01-Q12 전체 PARTIAL과 F-08/Track B 잔여 유지.
- main 변경 비교: PR #111은 W05 읽기/포커스 관련 소스/증거, PR #112는 기획 문서3개. Session/Map/PredictionState·S01 보고/예측 핵심 분기 변경은 없다. W05 수용을 S01 EX guard 완료로 전용하지 않는다.
- 회신7영역의 case_id가 기존20개를 빠짐/중복 없이 분담하도록 연결했다. 묶음 수는 새 필수 실행 횟수가 아니다. 계약 입력·실제 결과는 미수신/미실행으로 남겼다.
- 다음 의미 있는 제품 대조는 DEV 계약·변경/증거 수신 시점이다. 이번에는 수신란·책임/범위·기존 증거 재사용 조건까지 로컬 준비했다.

## 4. 검증

- 필수 공통 지침/Design README·GOV-001 DRAFT와 승인 운영 원칙·RFC 양식·프로젝트 설정·PLN-007 결과의 경계 읽기.
- 루트 .venv/Scripts/python.exe tools/policy.py doctor: PASS (local hooks/tooling). 원격 보호/승인·신원 인증 검사 아님.
- PowerShell의 루트 .venv/Scripts/python.exe - 패키지 정적 검사: PASS. 정확한 신규 Design2개·추적/스테이징 무변경·UTF-8/LF/끝공백/상대 링크,7영역이 기존20사례를 빠짐/중복 없이 연결함, 전 행 CONTRACT_PENDING·원래20행의 실제 결과 비움/NOT_RUN·기준 SHA를 확인했다.
- 루트 .venv/Scripts/python.exe tools/policy.py check: PASS (worktree files=568, GDScript=39). git diff --check: PASS. 신규 파일의 형식/링크는 위 패키지 검사로 별도 확인했다.
- 원격 댓글/소스 차이 정적 확인이며 Owner 보관 Q12 원본 ZIP·실제 게임/GUI를 독립 재검증한 결과가 아니다.

## 5. 미해결·NOT_RUN·검수 요청

EX 구체 계약·정확한 실행 패킷/경로·제품 적용/복구·선택/포커스 인수는 OPEN / IMPLEMENTATION_PENDING, 현재 작업표 입력은 CONTRACT_PENDING이다. DEV 기술 설명/자료 수신 완료와 구분한다. F08-01~04는 별도 OPEN, 최종 규격은 미확정이다.

게임 자동 테스트·Godot 로드·GUI/키보드/플레이·부분 자료/새 Session/복구 실험·빌드/성능·폰트/DPI/필터·제품 접근성/외부 사용성은 **NOT_RUN**이다. 신규 HTML/제품 코드 변경이 없어 새 브라우저 검사를 실행하지 않았다. 기존652브라우저·DEV/Q12 증거와 과거 승인·미실행 기록을 보존한다.

게임 규칙/세이브 명세 변경 필요는 현재 NONE이며 기술 계약은 DEV 후속이다. 검수 빈도/범위·상위 단계 인수는 HQ/Owner 소관이다. 이번에는 Commit·Push·PR·이슈 댓글/종료·병합·전체 DSG-008 DONE을 수행하지 않았다.

로컬 작업표의7영역 연결·계약 수신 항목·영향 행만 대조하는 기준·한정 수용/기존 증거의 보존 방식에 대한 검토를 요청한다.

## 6. 후속 Git 제출 승인

Owner 승인 원문:

> DSG-008 계약 대조 준비 산출물 2개의 커밋·푸시 및 PR 생성을 승인합니다. 과거 승인·검증 기록을 보존하고, F-08 미해결 항목과 NOT_RUN, 최종 규격 미확정 상태를 PR에 명시해주세요. main 병합은 하지 마세요.

대상은 wisberry2022/MetroManager / DSG-008 / AGT-DSG-0003 / codex/DSG-008-contract-review-readiness의 위 신규2개 파일이다. 정상 Commit·해당 브랜치 일반 Push·base=main PR 생성·동일 범위 검증만 승인되었다. main/자동 병합·강제 푸시·릴리스/배포·외부 이슈 전달·제품 적용·추가 DEV 실험·타 부서/정책 변경은 포함하지 않는다.

제출 전 확인 main은 49590f3f1b870fac2af7c77bb4cf179933699b8d로 분석 기준과 동일하다. 기존 문구·검수표·과거 승인/검증 및 Q12 한정 수용 기록을 보존한다. 실제 제출 SHA·정상 훅·커밋 후 fetch/preflight·원격 CI는 PR/검증 댓글에 기록하며, 과거 로컬 미수행 기록을 소급 삭제하지 않는다.

F08-01~04·EX 적용/검증은 미해결, 계약 입력은 CONTRACT_PENDING, 제품 실행은 NOT_RUN, 최종 규격은 미확정·NOT_DONE을 유지한다. Provenance manifest는 승인된2개에 없어 추가하지 않으며 REPORT_ONLY 실제 진단을 PR에 기록한다. 자기신고 Agent/Task 표기는 신원·승인 인증 또는 강제 적용 증거가 아니다.

제출 직전 추가 fetch에서 PM-015 공통 지침(PR #113)의 main 반영을 확인해 첫 preflight는 최신 main 미포함으로 정상 중단됐다. 미푸시 커밋을 최신 main으로 rebase한 뒤 다시 확인한다. 최종 제출 base는 6e9ae33 계열의 원격 full SHA를 PR에 기록하며, 위49590f3 기준은 최초 분석/사전 확인 기록으로 보존한다.

[GUI_REVIEW_PROTOCOL.md](../../hq/GUI_REVIEW_PROTOCOL.md)의 REVIEW 헤더와 main 배포 상태·Track B 담당 행을 직접 확인했다. 기존 필수 검수·자동 회귀/CI를 유지하면서 영향 없는 SHA 변경만으로 GUI를 반복하지 않기, 수용된 Q12 자동 재개방 없음, 실제 관측 범위의 증거 재사용, 묶음 회신·변경 행 대조 원칙은 본 작업표와 일치한다. PM-015로 F-08·EX 규격/실행/Git 권한이나 포괄 검수 면제를 새로 부여하지 않는다. 작업표 의미·기존20사례·Q12 판정 변경은 없다.
