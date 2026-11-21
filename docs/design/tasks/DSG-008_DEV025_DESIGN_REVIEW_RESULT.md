# DSG-008 — DEV-025 디자인 검토·Owner 선택안 로컬 결과

- 담당: Design Track B / AGT-DSG-0003 / 2026-11-21 / v0.1
- 상태: **LOCAL_REVIEW_REQUESTED / FINAL_SPEC_PENDING / NOT_DONE**
- base: `c699f7d0f191aebd9ecb912895e9f34c0aef8cda`
- 브랜치: `codex/DSG-008-dev025-design-options`

## 1. 승인 근거와 범위

Owner 원문:

> 디자이너 에이전트. 다음으로 DEV-025 실험 결과를 바탕으로 F-08 미결 항목의 디자인 검토와 Owner 선택안을 정리해주세요. 최종 규격은 미확정으로 유지하고, 로컬 산출물로 먼저 검토 요청해주세요.

이번 허용 범위는 원격/로컬 근거 읽기, 기존 결과·입력/화면의 Design 심사, 별도 로컬 작업 브랜치의 디자인 문서 작성·정적 검사·검토 요청이다. 제품/폰트 반입·설정·데이터·타 부서 문서·기존 증거 수정, 신규 게임/GUI 실험·성능 측정·Commit/Push/PR·병합·이슈 게시·배포는 수행하지 않는다.

공유 root는 기존 main과 DATA2개 수정을 보존했다. fetch 후 별도 worktree를 만들었으며 공유 브랜치를 전환/자동 stash/reset/pull하지 않았다. fetch는 읽기 동기화이며 커밋/푸시 승인이 아니다. 과거 승인/검증·NOT_RUN/실패는 덮지 않는다.

## 2. 신규 산출물4개

| 파일 | 내용 |
| --- | --- |
| [DSG-008_DEV025_DESIGN_REVIEW.md](DSG-008_DEV025_DESIGN_REVIEW.md) | T01~04/F08-01~04/RD-01~08의 조건별 Design 판정·보완·적용 경계 |
| [DSG-008_F08_OWNER_OPTIONS.md](DSG-008_F08_OWNER_OPTIONS.md) | O-01~07 선택지·권고·tradeoff·결정 전제/담당·미선택 기록 |
| [DSG-008_DEV025_DESIGN_EVIDENCE_AUDIT.json](DSG-008_DEV025_DESIGN_EVIDENCE_AUDIT.json) | 대표8·manual7·입력로그2·CSV1의18개 해시, 원본 복사/입력 무효과·PAIR 동등성 감사 |
| 본 결과서 | 작업 근거·변경 파일·정적 검증·NOT_RUN·미해결·검토 요청 |

기존 승인 토큰/카탈로그/열람기·DEV 실행/그림·과거 보고서는 수정하지 않았다. 시각 원본/새 폰트는 반입하지 않았다.

## 3. 검증과 증거 구분

- 작업 전 root `.venv/Scripts/python.exe tools/policy.py doctor`: PASS. 새 worktree도 별도로 doctor를 확인한다. 원격 보호/Owner 승인 인증은 아님.
- 기존 근거 감사: 대표PNG8개가 DEV raw 복사와 같음. manual7개 PNG·events/actions2개·CSV1개를 합친 **18개 해시 모두 일치**. CSV2639행, PAIR12개 내용/권위 동등성, 정보 선택6회·reset 아닌 제어12회의 authority 불변 확인. 실행 결과를 새로 생산한 테스트가 아닌 원본 정적 재검산이다.
- 직접 시각 심사: 대표8장·B전환 직후 원본1장·상태 표본5장. 전체53조건×전환경을 모두 육안/OS 검수했다고 하지 않는다.
- 정책 doctor/check·문서 UTF-8/LF·링크·허용경로·JSON 구조·기존 추적파일 불변·`git diff --check`는 로컬 제출 전 확인한다. 실제 결과는 아래 최종 확인에 기록한다.
- 신규 자동 게임 테스트 / Godot 프로젝트 로드 / 실제 GUI·독립 입력 / 폰트·DPI·export·장시간 프로파일 / 빌드·성능 인수: **각각 NOT_RUN**.
- 과거 DEV 정상497·렌더53·실제입력7캡처·프로파일22/2639와 실패/제외는 원 실행 범위로 사용한다. DEV025 JSON의 과거 Design acceptance NOT_RUN은 심사 전 이력이며 이 문서는 후속 증거 심사다. 새 독립 실행/제품 수용으로 전용하지 않는다.

## 4. 미해결·명세 변경 필요 여부

| 구분 | 잔여·판단 |
| --- | --- |
| ISSUE_OBSERVED | RD03/07 B전환 직후 화면 밖 포커스, 겹친 마커 가림. 격리 대안 관측이며 현재 제품 전체 결함 아님 |
| INCONCLUSIVE | 전 상태/환경 최종 의미·가독성·전체 읽기순서, 타PC/유효DPI·폰트배포, 최종 성능/표현 상한 |
| F-08 OPEN | O01~07 미선택·폰트/지원환경/필터/배치/목록/재사용/성능의 규격 및 제품 적용/인수 미확정 |
| 조건부 보완 | M01~05는 해당 선택·제품 적용 전 최소 범위. 전체 실험 반복/DEV026 수용 재개방 요구 없음 |
| Owner 검토 | 권고 묶음·보완 방향, 실제 규격 후보와 후속 범위 준비의 우선순위 |
| Git·외부 전달 | Commit/Push/PR/병합/이슈 댓글 미수행·이번 권한 없음 |
| 규칙 변경 | 게임/경제/시간/세이브 변경 필요 NONE. 디자인 방향·기술 표현 제안이며 최종 규격 변경 승인 아님 |

[DEV026 Owner 승인](https://github.com/wisberry2022/MetroManager/issues/104#issuecomment-7057161624)·Stage2 DONE·기존 수용/실패/미확인은 보존한다. S3-12·Stage 최종 인수는 별도 유지한다. #97 공급 완료와 #92 디자인 선택/적용 잔여를 구분한다.

## 5. 검토 요청

4개 로컬 산출물의 근거 연결·RD 판정 및 Owner 선택안의 검토를 요청한다. 권고는 선택을 돕는 제안이며 현재 O01~07 모두 미선택이다. 최종 규격은 **FINAL_SPEC_PENDING**이다. 별도 승인 전 원격 게시/제품 적용을 하지 않는다.

### 최종 로컬 확인

| 명령·확인 | 실제 결과 |
| --- | --- |
| 공용 가상환경 Python으로 새 worktree의 `tools/policy.py doctor` | PASS, 훅/도구 확인. 원격 보호 검증 아님 |
| 같은 Python으로 `tools/policy.py check` | PASS, files724 / GDScript57 formatter·linter 정상 |
| `git diff --check` | PASS. 기존 추적 파일 diff 없음 |
| 신규4개 별도 정적 대조 | PASS, UTF-8 BOM 없음/LF·마지막 개행·상대 링크12개 존재·JSON 파싱·FINAL_SPEC_PENDING 및18해시 감사 |
| `git status --short` | 디자인 tasks 아래 신규4개만 untracked, 기존 추적 파일 변경0·커밋0 |

정책 검사는 문서 품질/경로 확인이며 GUI·최종 규격 인수 또는 Git 실행 승인이 아니다. 로컬 문서의 상태 확인을 위해 게임 테스트를 새로 실행하지 않았다.

## 6. Owner 제출 승인 후속 — 2026-11-21

> DSG-008 DEV-025 디자인 검토·Owner 선택안 산출물 4개의 커밋·푸시 및 PR 생성을 승인합니다. 선택안은 미선택, 최종 규격은 미확정으로 유지하고, F-08 미결과 NOT_RUN을 구분해 PR에 명시해주세요. 과거 승인·검증 기록을 보존하고 main 병합은 하지 마세요.

이 후속으로 **위 신규4개 파일만** 현재 브랜치 `codex/DSG-008-dev025-design-options`에서 정상 훅 Commit·일반 Push·base=main PR 생성과 필수 CI 확인을 수행한다. 대상은 `wisberry2022/MetroManager` / DSG-008 / AGT-DSG-0003이며 이번 제출·동일 범위 검수 대응 종료 또는 Owner 철회까지다. 이전 절의 Git 미승인/미실행은 로컬 검토 당시 이력으로 보존한다.

O01~07은 모두 미선택이고 FINAL_SPEC_PENDING 유지다. 제품/폰트 반입·새 실험·타 부서/기존 원본·main 병합·auto-merge·릴리스·배포·force push·이슈 댓글은 포함하지 않는다. 제출 head·실제 훅/preflight·원격 CI 결과는 PR에 연결한다. 게임/GUI는 문서 제출 때문에 반복하지 않는다. 출처 REPORT_ONLY의 별도 manifest 파일은 이번4개 승인 경로에 추가하지 않으며 해당 진단이 있으면 필수 정책 검사와 구분해 PR에 명시한다.

Agent-ID: AGT-DSG-0003
Task-ID: DSG-008
