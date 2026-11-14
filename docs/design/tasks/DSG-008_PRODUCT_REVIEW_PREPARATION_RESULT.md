# DSG-008 — v0.2 제품 검수 준비 결과

- 담당: Design Track B / AGT-DSG-0003 / 2026-11-14
- 상태: LOCAL_REVIEW / FINAL_SPEC_PENDING / NOT_DONE
- 기준 main: 7c7476b5425dfe3a24c7bc79e1a624436b472a10
- 브랜치: codex/DSG-008-acceptance-preparation
- 기록 구분: 아래 로컬 작성·검증 기록은 당시 상태로 보존한다. 후속 제출 승인·실제 Git/원격 검증은 마지막 절과 제출 PR에서 확인한다.

## 승인과 작업 선택

Owner 지시:

> 디자이너 에이전트. 원격 저장소를 확인하여 현재 단계에서 진행할 수 있는 업무를 계속해주세요

원격 main·최근 PR·Issue #104/#97의 댓글을 확인했다. DEV는 v0.2 수신 및 새 디자인 blocker 없음, 다음 협의는 구체 계약 제안 시점이라고 회신했다. 이에 기존 승인된 DSG-008 후속 범위 내의 검수 기대/증거 준비를 진행했다. 제품 구현/실험이나 새 서비스 화면·Track A 독립 QA를 대신 수행하지 않았다. 신규 Git/외부 전달 승인을 추정하지 않는다.

## 변경 파일 — 신규3개

| 파일 | 내용 |
| --- | --- |
| [DSG-008_PRODUCT_REVIEW_PREPARATION.md](DSG-008_PRODUCT_REVIEW_PREPARATION.md) | 검수 순서·20사례 묶음·증거·후속 협의/부서 경계 |
| [s01_acceptance_checklist.json](../assets/source/dsg_008/copy_exceptions/s01_acceptance_checklist.json) | v0.2의20사례/문구 참조에 연결한 전제·기대 표시/행동·복귀/포커스·증거 요구. 실제 결과 비움 |
| 본 결과 | 승인·변경·검증·미해결/NOT_RUN·로컬 검수 요청 |

기존 v0.2 JSON/HTML·승인/검증/과거 결과·게임/설정·타 부서 파일은 수정하지 않았다. 공유 main 작업 디렉터리 대신 최신 main 기반 새 worktree에서 작성했다.

## 검증

- 원격 main 7c7476b, PR #108/109의 변경이 기획 문서7개뿐임을 확인. 원격 Issue #104의 DEV 수신 댓글 ID6868246151 및 #97 댓글0개 확인.
- 공통 지침·Design README·GOV-001 DRAFT/승인 원칙·RFC 양식·project.godot·PLN-005/006 결과/관련 후속 경계 읽기.
- 루트 .venv/Scripts/python.exe로 tools/policy.py doctor: PASS (local hooks/tooling). 신원·승인 인증/원격 보호 검사 아님.
- PowerShell에서 루트 .venv/Scripts/python.exe - 로 패키지 정적 검사: PASS. 정확한 신규 Design3개·추적/스테이징 무변경·UTF-8/LF/끝공백/상대 링크,20개 고유 사례와 v0.2의 ID/문구 참조/적용·구현 경계 일치, 원본 SHA256·기준 SHA, 실제 결과 비움/NOT_RUN·F-08 OPEN·최종 미확정을 확인했다.
- 루트 .venv/Scripts/python.exe tools/policy.py check: PASS (worktree files=562, GDScript=39). git diff --check: PASS. 빈 tracked diff와 별도로 신규 파일은 위 패키지 검사로 확인했다.
- 기존652브라우저 검사·기존 DEV/OBS-01 증거는 원래 범위로 보존하며 이번에 재실행/제품 인수했다고 주장하지 않는다. 신규 HTML/제품 코드가 없어 새 브라우저/게임 테스트를 작성하지 않았다.

## 미해결과 NOT_RUN

EX-Q01~03 기술 설명·v0.2 수신은 완료, 지역 guard·새 Session/자식 소비자·보고 식별/예측 소속의 계약·제품 적용/검증은 OPEN. DEV 실행 패킷의 정확한 ID/경로·입력/기대 동작·권한은 별도 준비 대상이다.

F08-01~04는 별도 OPEN이며 새 측정 결과는 확인되지 않았다. 신규 서비스 정책 문서의 Design 표현8개는 향후 작업 배정 대상이지 이번 S01 검수 범위가 아니다. OBS-01 독립 재검수도 별도 담당/승인 경계다.

게임 자동 테스트·Godot 프로젝트 로드·실제 GUI/플레이/키보드·부분 자료/새 Session/복구 실험·Windows 빌드·성능·폰트/DPI/필터·외부 사용성/제품 접근성은 **NOT_RUN**이다. JSON 모든 행도 실행 NOT_RUN, actual_result=null, evidence_refs=[]이다. 협의 OPEN/PENDING과 테스트 미실행을 구분한다.

최종 규격은 미확정, 게임 규칙/세이브 명세 변경 필요 현재 NONE. 기술 계약은 후속 협의 대상이며 본 문서는 실행 스키마가 아니다. Commit·Push·PR·외부 이슈 댓글·main 병합·전체 DSG-008 DONE은 수행하지 않았다.

## 로컬 검수 요청

20사례의 기대 표시·허용 행동/독립 정보·복귀/선택/포커스·필요 증거 구성이 적절한지 검토를 요청한다. DEV 구체 계약 수신 후 차이가 있는 행만 L2 대조하고, 승인된 구현/검증 뒤 해당 표현을 검수하는 데 사용한다.

## 후속 Git 제출 승인

Owner 승인 원문:

> DSG-008 제품 검수 준비 산출물 3개의 커밋·푸시 및 PR 생성을 승인합니다. F-08 미해결 항목과 NOT_RUN, 최종 규격 미확정 상태를 PR에 명시하고 과거 승인·검증 기록을 보존해주세요. main 병합은 하지 마세요.

대상은 wisberry2022/MetroManager / DSG-008 / AGT-DSG-0003 / codex/DSG-008-acceptance-preparation의 위 신규3개 파일이다. Commit·해당 작업 브랜치 일반 Push·base=main PR 생성·동일 범위 검증만 승인되었다. main/자동 병합·강제 푸시·릴리스/배포·제품 적용·추가 DEV 실험·타 부서/정책 변경·외부 이슈 전달 권한은 포함하지 않는다.

제출 기준 main은 7c7476b5425dfe3a24c7bc79e1a624436b472a10이며 분석·검수표 기준과 동일하다. 기존 문구 카탈로그/열람기와 과거 승인·검증 기록을 수정하지 않는다. 제출 SHA·정상 훅·커밋 후 fetch/preflight·원격 CI 실제 결과는 PR/검증 댓글에 기록한다. 검수표의 실제 결과 비움·NOT_RUN, F08-01~04 OPEN과 EX 적용/검증 미해결, 최종 규격 미확정·NOT_DONE을 유지한다.

Provenance manifest는 승인된3개에 포함되지 않아 추가하지 않는다. REPORT_ONLY 실제 진단은 PR에 기록하고 신원·승인 인증 또는 정책 강제 적용 PASS로 해석하지 않는다.
