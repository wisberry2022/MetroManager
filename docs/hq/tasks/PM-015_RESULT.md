# PM-015 — 검수 운영 지침 문서화 결과

- HQ / AGT-PM-0002 / 2026-11-14 / REVIEW.
- 기준 main: `49590f3f1b870fac2af7c77bb4cf179933699b8d`.
- [티켓·Owner 승인 범위](PM-015_GUI_REVIEW_PROTOCOL.md), [공통 지침](../GUI_REVIEW_PROTOCOL.md).

## 변경과 판정 범위

수용된 GUI 증거의 재사용, 영향 범위 재검수, 개발 패킷·피드백 일괄 전달, 독립 실행/Design 심사 분리, 통합 증거 공동 사용을 정리했다. HQ README와 PM-014에 진입 링크를 추가했다. HQ의 Markdown 5개와 출처 JSON 1개만 변경한다.

PM-014의 승인 수용 기준은 링크 추가 외 보존한다. Q12 28조건의 한정 수용을 유지하고 상위 PARTIAL을 새 PASS로 바꾸지 않는다. Q03~Q05 시험 방법 재승인을 요구하지 않으며 실제 실행·Git 승인과 공급 의존성을 보존한다. Q05 12조합·필수 예외·독립 GUI·Owner 최종 인수 및 Git 규칙은 유지한다. 게임 명세 변경 필요 없음.

## 검증

- 문서 내용·범위·상대 링크18개·Markdown 5개 UTF-8/LF·기존 PM-014 본문 전체 보존 및 README 원문 보존: PASS. `git diff --check`: PASS.
- 로컬 `tools/policy.py doctor` 및 `check`: PASS, GDScript 39개 formatter/linter 정상. 기존 `.venv/Scripts/python.exe`를 읽기 전용 실행기로 사용했다. 최초 `check`는 샌드박스 TEMP 접근 거부로 실패했고, 이 검증 사본 안의 제외된 임시 경로로 TEMP/TMP를 지정해 같은 검사를 통과했다. 검사 로직·훅은 변경하지 않았다.
- GitHub API 제출: 단일 부모·최신 main 포함·base tree 보존·HQ 6파일·원격 blob 일치 확인 후 게시. 로컬 Commit/Push 훅은 NOT_RUN(API 제출).
- 원격 `policy` / `department-policy`: 이 결과서 작성 뒤 생성하는 PR의 실제 head 검사 결과를 정본으로 연결한다. 완료 전 PASS로 간주하지 않는다.
- provenance: Agent-ID/Task-ID와 Manifest는 실제 작성 출처 선언이다. REPORT_ONLY 결과와 신원·승인 인증을 구분한다.
- 게임 자동검사·Godot 로드·실제 GUI·독립 제품 검수·빌드/export/성능: NOT_RUN — HQ 문서 작업.

공유 루트의 브랜치·기존 작업물은 보존하고 별도 로컬 사본에서 문서를 검증한다. 초기 로컬 복사는 Windows 샌드박스의 Git 보조 프로세스 제한으로 실패했으며, 승인된 격리 복사를 샌드박스 밖에서 수행해 준비했다. 검사 우회·코드 수정은 하지 않았다.

## 후속

Owner의 별도 main 병합 승인·배포 SHA 안내가 남는다. 이후 각 부서는 이 지침과 자기 티켓의 유효한 권한·최신 판정을 확인한다. HQ의 상세 미충족 행 매핑, DEV-019 보완 입력/증거, W05/W06/VS-01 인수는 기존 책임에서 이어간다. 비용 절감률은 NOT_MEASURED이며 본 PR이 인수시험/ID 정책이나 새 제작·Git 권한을 승인하지 않는다.
