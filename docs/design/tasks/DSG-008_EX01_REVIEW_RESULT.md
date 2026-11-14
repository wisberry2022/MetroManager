# DSG-008 — EX-01 DEV 회신 검토·후속 범위 정리 결과

- 담당: Design Track B / AGT-DSG-0003 / v0.1 / 2026-11-08
- 상태: LOCAL_REVIEW / FINAL_SPEC_PENDING / NOT_DONE
- 기준 main: 4b3f73c5d8b87630cc96eb90f950761f79bb861b
- 브랜치: codex/DSG-008-ex01-response-review
- 승인: [회신 검토 §1](DSG-008_EX01_RESPONSE_REVIEW.md)의 Owner 로컬 정리 지시

## 1. 변경 파일 — 신규3개

| 파일 | 이번 내용 |
| --- | --- |
| [DSG-008_EX01_RESPONSE_REVIEW.md](DSG-008_EX01_RESPONSE_REVIEW.md) | DEV 회신 고정 링크/시점·기준·EX-Q01~03 수신 내용·정적 사실/권고/미구현 구분 |
| [DSG-008_EX01_FOLLOWUP_SCOPE.md](DSG-008_EX01_FOLLOWUP_SCOPE.md) | EX-01~20 문구 영향표·자료/행동 의존표·후속 단계·EX/F-08 별도 미해결·검증 게이트 |
| 본 결과 | 변경 범위·검증 증거·NOT_RUN·검수 요청 |

공유 main의 작업 디렉터리를 변경하지 않고 최신 origin/main의 새 worktree에서 작성했다. 기존 추적 파일·승인/검증 기록·카탈로그38문구/20사례·열람기는 변경하지 않았다. 새 문서는 기존 문서의 NOT_SENT/RESPONSE_PENDING을 지우는 대신 후속 기술 회신 수신 사실을 연결한다.

## 2. 반영 결과와 미해결

DEV의 [댓글 6720694698](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-6720694698)을 수신했다. EX-Q01~03의 현행 기술 설명은 수신 완료로 기록하되, RFC는 OPEN / DEV_STATIC_RESPONSE_RECEIVED / DESIGN_FOLLOWUP_REVIEW / IMPLEMENTATION_PENDING으로 유지한다. Issue #104를 종료하지 않았다.

- 반영 범위 제안: 초기 실패/부분 미수신 분리, 판 종류/Session 경계 구분, 일반 동기 S01의 CP-S13 대기 제외와 실제 pending의 조건부 참조, 보고 원인 중립 안내, 런타임 보고 key와 소비 검증의 구분, 현재/이전 예측·유효0/없음/실패 의미 보존.
- EX 미해결: 공급/중개 경계·자료/버전/행동군·부분 guard·새 Session/자식 소비자 초기화·보고 원인/식별·현재 입력 일치·실제 복구/포커스 검증.
- 실행 준비: 별도 DEV 티켓 ID/정확한 파일·계약·검증/권한은 미확정. 후보 경로를 승인 목록으로 삼지 않는다.
- F08-01~04: 별도 OPEN. #92의 기존 의견 수신과 #97의 실험 준비를 보존한다. 이번 회신으로 닫지 않는다.
- 최종 글꼴·치수·최소창·배율·배치·필터·FPS·표현 상한: 미확정. 제품/Track A GUI 인수·DSG-008 전체·S2-D01·Stage DONE을 선언하지 않는다.

게임 규칙/경제/시각/원장/세이브 명세 변경 필요: 현재 NONE. 기술 계약 보완 필요는 존재하며 정확한 공급/guard 계약은 DEV 후속 범위에서 제안·협의한다. 새 부서 충돌/추가 규칙 결정 사유는 이번 검토에서 발견하지 않았다.

## 3. 검증 기록

- 원격 Issue #104 OPEN, 댓글1개의 DEV 원문·ID/수정 시점과 기준 SHA 확인. 원격 main과 DEV 회신 기준 SHA 일치.
- 매 작업 필수 지침·Design README·GOV-001 승인 상태·RFC 양식·Godot 설정 읽기. root와 이번 기준의 공통 지침 파일 차이 없음 확인.
- 해당 코드의 정적 읽기 및 기존 20사례/38문구 매핑 대조 완료. 모든 게임/GUI 경로 실행 검증 아님.
- .venv/Scripts/python.exe tools/policy.py doctor: PASS (local hooks/tooling). 원격 보호·신원·Owner 승인 진위 검사 아님.
- PowerShell에서 .venv/Scripts/python.exe - 로 패키지 정적 검사: PASS. 신규3개만 존재, 추적/스테이징 파일 무변경, UTF-8/BOM 없음·LF/끝개행/끝공백·상대 링크, 기준 SHA 및 EX-01~20의20행을 확인했다. 문구 참조는 기존 JSON과 대조했다.
- .venv/Scripts/python.exe tools/policy.py check: PASS (worktree files=544, GDScript=39, formatter/linter 정상). git diff --check: PASS. 이 명령의 빈 tracked diff와 별도로 신규 문서의 형식/링크를 위 패키지 검사로 확인했다.
- 브라우저489검사·DEV 인용 W07 322단언·QA-X01은 과거 범위의 기록이며 이번에 재실행하거나 새 guard 인수 증거로 승격하지 않았다.

## 4. NOT_RUN과 협의 상태

| 구분 | 이번 상태 |
| --- | --- |
| 게임 자동 테스트 | NOT_RUN — 로컬 회신 검토 문서만 |
| Godot 프로젝트 로드 | NOT_RUN — 제품/씬/설정 미변경 |
| 게임 플레이·실제 GUI/키보드 | NOT_RUN |
| 부분 자료/잘못된 타입·버전/새 Session/지연 응답·보고/복구 실험 | NOT_RUN — 후속 DEV 승인 패킷 필요 |
| 브라우저/열람기 재검증 | NOT_RUN — 원본 미변경, 신규 HTML 없음 |
| Windows 빌드·대상 PC 성능·폰트/DPI/필터 | NOT_RUN — F-08/W09 후속 |
| 제품 가독성/접근성·외부 사용성 인수 | NOT_RUN |
| DEV 회신 | STATIC_RESPONSE_RECEIVED — 실험 PASS와 별개 |
| 공급 계약/제품 적용·후속 DEV 실행 승인 | OPEN / PENDING — 테스트 상태와 별개 |
| HQ 조정·Owner 최종 규격 결정 | PENDING — 미확정 유지 |
| Commit·Push·PR·이슈 댓글/종료·main 병합 | 미수행 — 이번 지시는 로컬 검토 |

## 5. 로컬 검수 요청

EX-Q01~03을 무응답으로 남기지 않으면서 구현/인수 완료와 구분한 상태 표현, 20사례 영향표와 허용 행동 의존표, 별도 DEV 실행 패킷의 경계가 적절한지 검토를 요청한다. 기존 카탈로그·제품 변경은 이번에 수행하지 않았다. 이 결과는 검수 요청이며 공식 승인/DONE이나 신규 Git 실행 권한이 아니다.
