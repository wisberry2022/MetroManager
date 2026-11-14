# DSG-008 — 문구·예외 카탈로그/열람기 v0.2 개정 결과

- 작업: DSG-008 / Design Track B / AGT-DSG-0003 / 2026-11-14
- 상태: LOCAL_REVIEW / FINAL_SPEC_PENDING / NOT_DONE
- 브랜치: codex/DSG-008-ex01-response-review
- 작업 기준 main: 3dfae889c77a0740bfa7dab8ec1db630156dc6d3
- DEV 회신/관련 코드 기준: 4b3f73c5d8b87630cc96eb90f950761f79bb861b
- 기록 구분: §1~6은 로컬 검토 당시 결과다. 후속 제출 승인과 최신 기준 비교는 §7에 추가하며 과거 기록을 보존한다.

## 1. 승인·범위

Owner 직접 지시:

> 로컬 문서 3개의 후속 반영 범위를 승인합니다. 이를 기준으로 DSG-008 문구·예외 카탈로그와 열람기를 개정해주세요. F-08 미해결 항목과 NOT_RUN은 구분하고 최종 규격은 미확정으로 유지한 채, 로컬 산출물로 먼저 검토 요청해주세요.

승인된 근거는 [회신 검토](DSG-008_EX01_RESPONSE_REVIEW.md), [후속 범위·20사례 영향표](DSG-008_EX01_FOLLOWUP_SCOPE.md), [기존 검토 결과](DSG-008_EX01_REVIEW_RESULT.md)다. 그 문서3개는 작성 당시 상태/검증 기록 그대로 보존하고 이번 승인·실행 기록을 별도로 추가한다. 새 Commit·Push·PR·이슈 댓글/종료·main 병합은 수행하지 않는다.

최신 main의 INF-008 등록 변경만 작업 브랜치에 fast-forward했다. 이전 코드 기준 이후 디자인/제품 코드 변경은 없다. 공유 main 작업 디렉터리는 변경하지 않았다. 이번 개정은 정적 Design 입력이며 실제 게임/공급 계약·부분 guard·규격 구현이 아니다.

## 2. 변경 파일

| 경로 | 내용 |
| --- | --- |
| [s01_copy_catalog.json](../assets/source/dsg_008/copy_exceptions/s01_copy_catalog.json) | 개정 v0.2·schema2, 승인 근거/기존 이력·회신 기준, 사례별 적용/의존/구현 경계, EX/F-08/NOT_RUN 분리 |
| [s01_copy_review.html](../assets/source/dsg_008/copy_exceptions/s01_copy_review.html) | 같은 JSON 내장, 조건부 표본 별도 구획·사례별 검토 설명·미해결/NOT_RUN 분리 표시 |
| 본 결과 | 승인·변경·검증·미해결·로컬 검수 요청 |

이번 개정2개+신규 결과1개 외 기존 추적 파일 수정은 없다. 이전 로컬 문서3개는 이번 변경 파일과 별개로 미커밋 보존 상태다. 게임 소스·씬·설정·타 부서 산출물·과거 승인/검증 문서를 변경하지 않았다.

## 3. 반영 내용

- **38문구/20사례 및 모든 ID·사례별 문구 참조 유지**. CP-R01~18 사유 항목은 원본과 완전히 같다. CP-S17 당시 수락과 관할 밖 별도 입력·유효0 예시/기간·현재/이전 구분도 유지한다.
- EX-01: 초기 DATA 검증 실패 화면/exit1과 전체 자료 미확인 guard 제안을 구분. 제품 문구와 기술 검토 설명을 분리했다.
- EX-02/17: 지도/목록의 자료 공유, root 시간/predict·plan edit/undo·입찰/공사 행동군의 의존성을 명시했다. 독립 정보 유지와 누락 행동군만 제한하는 것은 적용 전 계약/검증이 필요한 목표다.
- EX-05/16: CALCULATING 모델 표본과 실제 pending 참조를 별도 조건부 구획으로 이동했다. **일반 S01 동기 계획·시간 제어·예측에 대기 문구를 붙이지 않는다**. 응찰/공사 pending은 해당 requests/ID/효력/최신 대상의 조건부 참조이며 다른 화면의 자동 적용/재설계는 아니다.
- EX-11/12: CP-S11 제목을 “확정 보고 자료 없음”으로 정리했다. UNAVAILABLE만으로 미마감을 단정하지 않고 확인된 첫날 문맥에서만 부연한다. FAILED는 key가 남아도 실패로 유지하며 디스크/네트워크 복구를 약속하지 않는다.
- EX-14/19/20: 같은 Session의 표시판 역행, 새 Session 수신 귀속, 보고 런타임 key/day 및 관측판 종류를 구분했다. 기존 reset만으로 자식 소비자 전체 초기화·지연 응답 검증이 해결됐다고 보지 않는다.
- stale CP-S20 검토 진단과 당시 거부/현재 허용 구획 분리를 유지했다. 새 재조회/취소/재시도·타임아웃·전역 잠금/시계정지·영구ID/세이브 기능은 추가하지 않았다.

JSON schema2는 **Design 검토 파일의 구조 버전**이다. 사례별 review_notes와 history/review_status는 검토 메타데이터이며 엔진 payload·상태 enum·공급 계약이 아니다. 읽는 도구가 있다면 schema2를 명시적으로 처리해야 하며 기존 제품에 연결하지 않는다. 새 결과의 기술 설명을 제품 안내 문구로 일괄 노출하지 않는다.

## 4. 검증·증거

- .venv/Scripts/python.exe tools/policy.py doctor: PASS (local hooks/tooling). 원격 보호·승인/신원 인증 검사가 아니다.
- node --check .local/copy-revision/check_board.cjs 및 추출 내장 JS node --check: PASS.
- node .local/copy-revision/check_board.cjs: **652 checks PASS / runtime JavaScript exception0**, 최종 개정 후 재실행. Windows 전용 headless Chrome 프로필, 로컬 HTML 파일, 20사례×1280/760/375/320 CSS px.
- 검사 범위: 내장 JSON 일치·현재/과거/영향/근거·행동/유지/복귀·참조 문구·전체38문구·가로 넘침 없음·제품 조작 버튼 없음, 모든 사례의 적용/의존/구현 설명·EX-05/16 조건부 구획 분리. stale 진단·과거 거부·유효0/기간·보고 없음·실제 pending 조건·보고 식별 guard 미구현·F-08/NOT_RUN 분리를 별도 확인했다.
- 시각 확인: EX-16 1280/320px 및 EX-19 1280px 캡처를 확인했다. 최종 미해결/NOT_RUN 구획을 문구 전체 목록 앞에 배치하고 전 검사 재실행했다. 브라우저 레이아웃 점검이며 실제 제품 접근성/가독성 인수가 아니다.
- PowerShell의 .venv/Scripts/python.exe - 정적 대조: 원본 CP-R 사유18개 완전 동일, 20사례 ID/문구 참조 동일, 기존489검사 이력 보존, JSON/내장 동일, 새 제품 조작·네트워크 요청·브라우저 저장 API 없음 확인. 최종 파일의 형식/링크·범위도 별도 확인한다.
- .venv/Scripts/python.exe tools/policy.py check: PASS (worktree files=547, GDScript=39). git diff --check: PASS. 최종 패키지 검사에서 변경된 추적 파일은 JSON/HTML2개만, 미추적은 기존 로컬 문서3개+이번 결과1개만임을 확인했다. 최종 JSON/HTML 및 결과의 UTF-8/LF·링크·해시/검증 결과 정합성을 확인했다.

| 최종 개정 파일 | SHA256 |
| --- | --- |
| JSON | ff474aa286e4e0514413bd3faffb06b5f4c4f1d8b8efe9f2cdecb43a056be24f |
| HTML | 30d9e388318bc30654d6d357bce1f3c4e4c5187126ce35aac4ce3a2611a95fc7 |

기존 v0.1의 JSON 3f180e19b21f6729bb44a1e412f328ba182843f05544e7197a858182f157c5e4 / HTML fccdda7ec184f1229bcf8076ccb505ea5c1a140281ba1f55ab8b974b0b88b998와489검사는 PR #103 당시 기록으로 보존한다. 새652검사로 과거 실행 결과를 덮지 않는다. 기존 W07/제품 증거도 이번 실행으로 재분류하지 않는다.

생성/검증 보조 스크립트·원시 validation.json·전용 프로필·캡처는 제외 경로 .local/copy-revision에만 보존했다. 다른 clone에 자동 제공되지 않는다.

## 5. 미해결과 NOT_RUN

| 협의/적용 항목 | 상태 |
| --- | --- |
| EX-Q01 | 정적 설명 수신. 준비/구조·버전/행동군 계약, 부분 guard·새 Session/자식 소비자 경계의 적용·검증 OPEN |
| EX-Q02 | 동기/실제 pending 경로 설명 수신. Design의 적용 제외/조건부 참조는 반영. 해당 제품 경로 연결·인수는 미수행 |
| EX-Q03 | 원인 중립 안내·런타임 식별 경계는 정리. 부분 입력/보고 소속·현재 입력 guard 및 복구 검증 OPEN |
| F08-01 | 환경·창/DPI·폰트/배율·가독성·배포 근거 OPEN |
| F08-02 | 픽셀/텍스트 필터·정수/비정수 배율 OPEN |
| F08-03 | 지도 밀집·긴 문자열·입력/포커스 OPEN |
| F08-04 | 재사용·인계·성능 측정 OPEN |
| DEV 실행/HQ·Owner | 별도 정확한 실행 패킷·권한 필요. HQ 조정/Owner 최종 규격 결정 PENDING |

[Issue #104](https://github.com/wisberry2022/MetroManager/issues/104)는 회신 수신과 구현/인수 완료를 구분한다. [#92](https://github.com/wisberry2022/MetroManager/issues/92)와 [DEV-025 #97](https://github.com/wisberry2022/MetroManager/issues/97)의 F-08을 이 개정으로 종료하지 않는다. Track A 최소 UI 전체를 일괄 차단하지 않는다.

| 제품 검증 | 이번 상태 |
| --- | --- |
| 게임 자동 테스트 | NOT_RUN |
| Godot 프로젝트 로드 | NOT_RUN |
| 실제 GUI/키보드·게임 플레이 | NOT_RUN |
| 부분 자료/잘못된 타입·버전·새 Session/지연 응답·실제 복구/포커스 실험 | NOT_RUN |
| Windows 빌드·대상 PC 성능·폰트/DPI/필터 비교 | NOT_RUN |
| 제품 접근성·외부 사용성 인수 | NOT_RUN |

미해결 협의/적용 승인 대기와 테스트 NOT_RUN을 혼합하지 않는다. **최종 글꼴·치수·최소창·배율·배치·필터·FPS·표현 상한은 미확정**이다. 게임 규칙/세이브 명세 변경 필요는 현재 NONE이며 기술 계약 보완은 DEV와 별도 확정한다. DSG-008 전체·S2-D01·Stage DONE이나 제품 합격을 선언하지 않는다.

## 6. 로컬 검수 요청

조건부 표본/현재 동기 S01 적용 제외 표시, 보고 원인 중립 문구, 자료/행동 의존성과 미구현 경계, F-08/NOT_RUN 구분을 검토해주기를 요청한다. 이번은 정적 카탈로그·열람기 개정 검수이며 실제 제품 적용·DEV 실험 실행·Git 제출 승인을 대신하지 않는다.

## 7. 후속 Git 제출 승인·범위

Owner 후속 승인 원문:

> DSG-008 v0.2 개정 산출물과 승인한 후속 문서 3개의 커밋·푸시 및 PR 생성을 승인합니다. 과거 승인·검증 기록을 보존하고, F-08 미해결 항목과 NOT_RUN, 최종 규격 미확정 상태를 PR에 명시해주세요. main 병합은 하지 마세요.

대상은 wisberry2022/MetroManager / DSG-008 / AGT-DSG-0003 / codex/DSG-008-ex01-response-review의 §2 개정 산출물3개와 §1 후속 문서3개, 합계6개다. Commit·해당 브랜치 일반 Push·base=main PR 생성과 같은 범위 검증만 승인되었다. main/자동 병합·강제 푸시·릴리스/배포·제품 적용·타 부서/정책 변경·추가 DEV 실험 권한은 포함하지 않는다.

제출 전 main 62bfd068bcef7c87513d7639d232b62f7c748d5c의 PR #106 변경을 정적 비교했다. 공사 화면 포커스/스크롤·행동 사유 가시성 보완이며 이번 S01 문구·보고·예측·Session 공급 핵심 분기는 유지된다. 카탈로그의 원래 분석/개정 기준과 JSON/HTML 검토본·652검사 기록은 그대로 보존한다. 공사 화면의 새로운 제품 검증을 수행했다고 주장하지 않는다.

후속 문서3개는 당시 상태/내용 그대로 제출한다. 현재 승인·실제 제출 SHA/정상 훅·preflight/원격 CI 결과는 이 절과 제출 PR/검증 댓글에서 확인하며, 과거 미수행·NOT_RUN 기록을 소급 삭제하지 않는다. F08-01~04 및 EX 적용/검증은 계속 미해결이며 최종 규격 미확정·NOT_DONE을 유지한다. Provenance manifest는 승인된6개에 포함되지 않아 추가하지 않으며 REPORT_ONLY의 실제 진단을 PR에 별도 기록한다.
