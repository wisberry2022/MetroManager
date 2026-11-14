# DSG-008 — DEV-026 L2 디자인 검토·재대조 준비 결과

- 담당: Design Track B / AGT-DSG-0003 / 2026-11-14 / v0.1.
- 상태: **LOCAL_REVIEW / DESIGN_OPINION_PROPOSED / RECOMPARE_REQUIRED / FINAL_SPEC_PENDING / NOT_DONE**.
- 기준 main: `2507cda419ed27e96c5d64ced7666ed7a2e58227`.
- 브랜치: `codex/DSG-008-dev026-l2-review` / 공유 root main은 전환하지 않음.

## 1. Owner 지시·범위

> DEV-026 계약안의 L2-A/B/C에 대한 디자인 검토 의견과 선행 작업 이후 재대조할 항목을 로컬 문서로 정리해주세요. F-08 미해결 항목과 NOT_RUN은 구분하고, 최종 규격은 미확정으로 유지한 채 먼저 검토 요청해주세요.

이번 승인은 위 범위의 로컬 문서 작성·정적 검증이다. Commit·Push·PR·외부 이슈/부서 전달·병합·릴리스/배포·제품 구현/실험은 포함하지 않는다. 이전 산출물의 Git 승인이나 DEV-026 문서 PR의 승인을 재사용하지 않는다.

## 2. 신규 산출물 2개

| 파일 | 내용 |
| --- | --- |
| [DSG-008_DEV026_L2_DESIGN_REVIEW.md](DSG-008_DEV026_L2_DESIGN_REVIEW.md) | L2-A/B/C 의미 대조·유지 조건·필요 증거, DEV-022~025 후 재대조, RFC 로컬 회신 초안, F-08 OPEN과 NOT_RUN 구분 |
| 본 결과서 | 승인 범위·변경·검증·미해결·Owner 검토 요청 |

두 파일 모두 docs/design/tasks/ 아래 신규 추가다. 기존 작업표/카탈로그38문구·20사례/열람기·과거 승인/검증·게임/설정·DEV/HQ/기획/INF 문서를 수정하지 않았다. 별도 worktree를 최신 origin/main에서 생성했고 로컬 검토본은 미커밋 상태다.

## 3. 검토 결론·남은 일

[PR #120](https://github.com/wisberry2022/MetroManager/pull/120)의 DEV-026은 사전 계약안이며 구현·제품 검증은 OWNER_IMPLEMENTATION_DEFERRED다. L2-A의 지역 제한, L2-B의 새 Session 전체 View 경계, L2-C의 문구·복귀 의도에는 의미상 이견이 없다. 제안한 fallback 순서는 실제 가시성·탭/읽기·스크롤·사용자 포커스 이동 보존 확인 전 잠정으로 남긴다.

이번 의견은 LOCAL_REVIEW이고 원격 RFC-DEV-026-01은 OPEN이다. Owner의 DEV-022~025 선행 순서를 유지하며, 선행 결과 후 최신 계약·직접 영향 행·실행 증거만 재대조한다. 계약안 수신 완료를 실제 제품 적용·수용 완료로 처리하지 않는다.

게임/경제/시간/세이브 명세 변경 필요는 현재 NONE이다. 기술 계약 확정·L2 구현/증거 대조는 남아 있다. 최종 규격 결정과 범위 변경은 해당 협의·HQ/Owner 절차를 따른다. 새 전체 테스트 행렬이나 반복 승인 요구는 추가하지 않았다.

## 4. 검증 기록

아래는 이번 로컬 문서 검증 결과다. 문서 검사와 게임 자동 테스트를 구별한다. worktree에서 root의 `.venv/Scripts/python.exe`를 읽기 재사용했고 TEMP/TMP는 worktree의 `.local/temp`로 지정했다.

- 공통 AGENTS·코드/Git/강제 적용·부서 지침·Design README·GOV-001 DRAFT/승인 운영 원칙·RFC 양식·PM-015·프로젝트 설정과 대상 문서를 직접 읽었다.
- root `.venv/Scripts/python.exe tools/policy.py doctor`: PASS (local hooks/tooling). 원격 보호·Owner 승인/신원 인증 검사가 아니다.
- 원격 main 읽기와 `git fetch origin`: 위 기준 SHA와 일치. 최초 sandbox fetch는 FETCH_HEAD 접근 거부로 실패했고 승인된 권한 경로로 재실행 성공했다. 정책/훅 우회 없음.
- 위 Python으로 `tools/policy.py check`: PASS / exit0 / worktree files=604, GDScript=39. 로그: `.local/validation/DSG-008_L2_POLICY.log`. 포맷/린트·저장소 검사 결과이며 게임 자동 테스트가 아니다.
- 위 Python의 `-` 표준입력 일회성 정적 감사: PASS. 신규2개 UTF-8/BOM 없음·LF·끝개행/공백·상대 파일 링크13개·기준 SHA/브랜치·L2와 선행4업무/F08-01~04 상태를 확인했다. DEV 검증 계획의20개 case_id/copy_ids와 기존 확인표가 일치하고 카탈로그38문구 및 원래20행의 actual_result=null / evidence_refs=[] / execution_status=NOT_RUN을 보존했다. 결과/파일 해시: `.local/validation/DSG-008_L2_STATIC_AUDIT.json`.
- `git diff --check`, `git diff --name-only`, `git diff --cached --name-only`, `git ls-files --others --exclude-standard`: PASS. 기존 추적/스테이징 변경0개, 신규 Design 문서2개만 확인했다. 공유 root 상태도 변경 없음이다.
- 원격 CI·커밋 후 preflight: NOT_RUN (미커밋 로컬 검토 단계). 검사 통과를 Git 실행 권한이나 Owner 승인으로 해석하지 않는다.

## 5. 미해결과 NOT_RUN·검토 요청

미해결: 선행 결과 후 계약 재대조, L2-A/B/C 실제 지역/생명주기/복귀 검증과 제품 수용, F08-01~04 OPEN, 최종 규격 결정. 기술 협의 상태를 테스트 실패/성공으로 바꾸지 않는다.

게임 자동 테스트, Godot 프로젝트 로드, 실제 GUI/키보드·플레이·부분 자료/새 Session/복구 실험, Windows 빌드/export, 성능·폰트/DPI/필터·제품 접근성/외부 사용성은 **NOT_RUN**이다. HTML/제품 변경이 없어 새 브라우저 검사도 NOT_RUN이다. 기존652브라우저 검사·Q03~05·Q12 한정 수용·상위 PARTIAL과 과거 실패/미실행은 원래 범위로 보존한다.

**최종 규격은 미확정이며 NOT_DONE이다.** L2-A/B/C의 디자인 의견·유지 조건, 선행 결과 후 재대조 범위, RFC 로컬 회신 초안에 대한 Owner 검토를 요청한다. 외부 전달·Git 제출은 이번에 수행하지 않는다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008

## 6. 후속 Git 제출 승인·기록 보존

Owner는 위 로컬 검토 후 본 Design 대화에서 다음과 같이 승인했다.

> DSG-008 DEV-026 L2 디자인 검토 산출물 2개의 커밋·푸시 및 PR 생성을 승인합니다. 과거 승인·검증 기록을 보존하고, F-08 미해결 항목과 NOT_RUN, 최종 규격 미확정 상태를 PR에 명시해주세요. main 병합은 하지 마세요.

대상은 `wisberry2022/MetroManager` / DSG-008 / AGT-DSG-0003 / `codex/DSG-008-dev026-l2-review`의 위 신규2개다. 이번 정상 Commit·해당 브랜치 일반 Push·base=main PR 생성·필수 검사 및 같은 범위 검수 대응만 승인되었다. main/자동 병합·강제 푸시·릴리스/배포·외부 이슈 전달·제품 구현/실험·타 부서/정책 변경은 포함하지 않는다. 이 제출 또는 Owner 철회까지의 개별 승인이고 미래 작업 포괄 위임이 아니다.

앞 절의 LOCAL_REVIEW·미커밋·원격 CI/preflight NOT_RUN·외부 미전달은 최초 로컬 검토 시점의 기록으로 보존한다. 이번 후속 승인으로 원격 공유 범위만 갱신하고, 의견 본문·기존 문구/검수표·과거 승인/검증은 바꾸지 않는다. 제출 전 fetch 확인 main은 최초 검토 기준과 같은 `2507cda419ed27e96c5d64ced7666ed7a2e58227`이다.

전용 worktree의 정상 훅을 위한 `.venv` 준비에서 기본 TEMP의 ensurepip가 실패했고 작업 영역 TEMP/TMP로 재실행해 준비했다. 최초 제한 네트워크 pip는 DNS 오류로 실패했으며 정상 네트워크 경로로 저장소 고정 요구사항 설치를 완료했다. 이는 환경 준비 실패이며 정책 우회나 제품 테스트 실패가 아니다. 실제 최종 제출 SHA·정상 훅·check/preflight·필수 CI 결과는 PR에 후속 기록한다. 커밋/푸시 이후 결과를 이 문서에 미리 PASS로 적지 않는다.

F08-01~04 OPEN, L2-A/B/C 제품 적용·수용과 선행 후 재대조 미완료, 제품 자동·Godot 로드·GUI/플레이·빌드/성능 NOT_RUN, 최종 규격 미확정·NOT_DONE을 유지한다. 승인된2개 외 provenance manifest는 추가하지 않으며 REPORT_ONLY 진단이 있으면 PR에 별도 기록한다. Agent/Task 자기신고는 신원·Owner 승인 인증이 아니다.
