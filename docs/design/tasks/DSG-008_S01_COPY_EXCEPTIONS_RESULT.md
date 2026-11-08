# DSG-008 — S01 문구·미수신/예외 정적 보완 결과

- Design / Track B / AGT-DSG-0003 / 2026-11-08
- 상태: REVIEW / OWNER_GIT_SUBMISSION_APPROVED / STATIC_DESIGN / FINAL_SPEC_PENDING / NOT_DONE
- 기준 main: 8a9515a781e8864de211df0ece3a52568df1154a
- 브랜치: codex/DSG-008-s01-copy-exceptions
- 승인·범위: [문구 정리](DSG-008_S01_COPY_GUIDE.md)

## 1. 변경 파일 — 신규5개

| 파일 | 내용 |
| --- | --- |
| [DSG-008_S01_COPY_GUIDE.md](DSG-008_S01_COPY_GUIDE.md) | 승인·표현·문맥/사유별 안내·행동 범위 |
| [DSG-008_S01_EXCEPTION_DESIGN.md](DSG-008_S01_EXCEPTION_DESIGN.md) | EX01~20·지역 영향/복구·자료 의존성·L2 RFC 초안 |
| [s01_copy_catalog.json](../assets/source/dsg_008/copy_exceptions/s01_copy_catalog.json) | 사유18+상태20=38문구·20정적 사례 |
| [s01_copy_review.html](../assets/source/dsg_008/copy_exceptions/s01_copy_review.html) | 현재/과거·행동·유지정보/복귀조건·전체 문구 열람 |
| 본 결과 | 검증·미해결·NOT_RUN·검수 경계 |

[PR100](https://github.com/wisberry2022/MetroManager/pull/100) 병합 SHA를 확인하고 새 worktree에서 시작했다. 과거 승인/검증 기록·기존 IA/목업/토큰·게임/설정·타 부서 파일은 보존한다. JSON은 엔진 payload/새 enum·API가 아니며 HTML 선택은 정적 사례 전환이다.

후속 Owner의 신규5개 Commit·Push·PR 승인은 문구 정리의 원문과 범위로 기록했다. 분석 기준/과거 검증 기록은 보존하고 제출 브랜치만 main 58bbde35bed88df9138b40d13588fe7382127a30으로 전진했다. DEV-021 공사 UI 추가의 정적 비교에서 기존 S01 핵심 분기 의미는 유지되었다. JSON/HTML은 로컬 검토 원본 그대로다. 제출 SHA·최종 정책 검사·원격 CI 결과는 PR에서 확인하며 최종 규격 승인으로 간주하지 않는다.

## 2. 수행한 설계

18개 현행 사유와20개 상태/문맥의 문구를 지역·현재/과거·원인/다음 허용 행동에 연결했다. 무사유 성공을 오류로 표시하지 않고, 미상 code의 제품 fallback/개발 진단을 구분했다.

전체/지도 미수신과 실제 빈 계획, 예측 미계산/계산중/실패/유효0·이전값, 현재 재무/당일 누계 불일치, 보고 없음/실패/식별 미확인, 오래된 응답, 당시 거부/현재 허용, 실제 pending, 누락 행동·관할외 별도 입력을 정리했다. CP-S20은 오래된 응답의 검토 진단이며 제품 배너/거부 결과를 새로 생성하지 않는다.

현행 코드·계약상 분기·설계 guard를 나눴다. 전역 재조회·취소·타임아웃·자동 재요청을 신규 기능으로 확정하지 않았다. RFC-DSG-008-EX-01은 적용 전 필요한 세 질문의 로컬 초안이며 발송/회신/합의는 미수행이다.

## 3. 검증

- 변경 전 .venv/Scripts/python.exe tools/policy.py doctor: PASS.
- 기준 코드/계약/기존 상태표/프로젝트 설정 정적 읽기: 완료. 실제 게임 실행 아님.
- .venv/Scripts/python.exe .local/copy-exceptions/build_copy.py 및 prepare_qa.py로 생성/검증 준비. node --check .local/copy-exceptions/check_board.cjs, node .local/copy-exceptions/check_board.cjs: **489 checks PASS / runtime JavaScript exception0**.
- 전용 Windows Chrome headless CDP의 로컬 파일에서 20사례×1280/760/375/320 CSS px의 현재/과거·행동/유지/복귀·참조문구·전체38문구 보존, 가로 넘침 없음, 제품 조작 버튼/요청 없음 확인. stale 진단·당시 거부의 영역 분리와 유효0의 비용/기간·보고 없음·실제pending 조건을 별도 확인했다.
- 시각 검토에서 당시 거부 문구를 현재 자료와 별도 요청 결과 영역으로 옮기고 stale 검토 진단도 별도 구획으로 분리한 뒤 전체 재실행했다. 최종 EX-15/EX-01 검토 캡처를 작성자가 시각 확인했다. 실제 제품/가독성/접근성 인수 증거가 아니다.
- .venv/Scripts/python.exe .local/copy-exceptions/check_package.py: PASS. 정확한 신규5개·기존 추적 파일 무변경, UTF-8/LF·끝개행/공백·링크·JS구문·JSON/내장동일성·38문구/20사례·참조/현행18코드·489검증결과를 확인했다.
- 최초 로컬 검수의 .venv/Scripts/python.exe tools/policy.py check: PASS (worktree files=518, GDScript=35, formatter/linter 정상). git diff --check: PASS. 신규 텍스트는 별도 검증으로 확인했다.
- 생성기/QA 러너·원시결과·프로필·검토 캡처는 제외 경로 .local/copy-exceptions에 보존하며 신규5개에 포함하지 않는다. 다른 clone에 자동 제공되지 않는다.

## 4. 미해결과 NOT_RUN

EX-Q01 자료/행동 준비·버전/실행 경계, EX-Q02 실제 pending·행동 공급, EX-Q03 보고 원인/식별·문구 적용은 OPEN이다. F08-01~04 폰트/배율/필터·밀집/입력·재사용/성능과 최종 규격도 OPEN/미확정이다. 기존 기술 의견 수신과 이번 새 RFC 회신 필요를 혼합하지 않는다.

| 항목 | 상태 |
| --- | --- |
| 게임 자동 테스트 | NOT_RUN — 문구/정적 설계만 |
| Godot 프로젝트 로드 | NOT_RUN — 제품/씬/설정 미변경 |
| 실제 미수신·부분 snapshot·늦은 응답·pending/재조회 실행 | NOT_RUN — 정적 사례 전환과 구분 |
| 실제 GUI·키보드 편집·입찰 진입/복귀 | NOT_RUN — 제품 적용·공급/포커스 검증 후속 |
| Windows 빌드·대상 PC 성능·폰트/DPI/필터 | NOT_RUN — F08/W09 |
| 외부 사용성·제품 접근성 인수 | NOT_RUN |
| RFC 발송·DEV 회신·HQ 조정 | 미수행 / PENDING. 테스트와 별도 협의 상태 |
| Commit·Push·PR·원격 CI | 최초 로컬 검수 시 미수행. 후속 Owner 제출 승인에 따라 수행하고 SHA/결과를 PR에 기록 |
| main 병합·자동 병합·릴리스·배포 | 미수행 / 승인 범위 밖 |

정적 열람기의 문구 보존·반응형 표시를 확인하더라도 실제 게임 guard/동등성·가독성/접근성 합격으로 보지 않는다. 명세 변경 필요: NONE. 최종 치수·글꼴·배율·배치·필터·FPS·상한은 미확정이며 DSG008 전체·S2-D01·Stage DONE을 선언하지 않는다.

제출은 AGT-DSG-0003 / Design Track B의 DSG-008 작업이다. 과거 산출물 작성자/승인을 소급 변경하지 않는다. Provenance manifest는 승인된5개에 포함되지 않아 별도 생성하지 않는다. REPORT_ONLY 진단은 PR에 실제 결과를 기록하고 신원/승인 인증이나 정책 강제 적용으로 해석하지 않는다.

## 5. 검수 요청

현재/과거·0/없음/실패의 구분, 확인된 원인/대상과 조건부 다음 안내, 미수신/예외의 지역 영향·복구 설계 적합성 검토를 요청한다. 검수 대상은 문구/정적 설계이며 실제 제품 적용·신규 DEV 구현 승인을 요청하는 것이 아니다.
