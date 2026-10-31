# DEV-003 결과 보고

- 상태: REVIEW / 담당: Convention Team / 2026-10-31
- 기준: 8405c455233121a6ad44195c2680a6a25e3f1a82, 시작 clean main.
- Owner 지시와 적용 범위: DEC-0002. 게임 명세 변경 없음.

## 조사 결론

현재 GitHub 플러그인은 Contents/Git Data API로 쓰며 로컬 pre-commit/pre-push는 호출하지 않는다. GitHub API 쓰기에도 main 보호/필수 PR 검사로 통합을 제한할 수 있다. 작업 브랜치 업로드 전의 PC 훅 강제 실행은 불가능하다. 같은 GitHub 계정으로 연결된 채팅의 실제 소속은 구별할 수 없으므로 부서 표기·티켓·경로의 일관성까지 자동 검사한다.

## 변경 파일

- AGENTS.md, README.md: 전 부서 진입점.
- docs/engineering/{DEPARTMENT_WORKFLOW,GIT_WORKFLOW,ENFORCEMENT,README}.md: 조사·규칙·설치.
- docs/{hq,planning,design}/README.md: 부서 경로와 플러그인 지침.
- tools/department_policy.py: 부서·메시지·경로·커밋별 검사, base 예외 목록.
- tools/policy.py: 동일 검사를 로컬 훅/기존 CI에 연결.
- .github/workflows/department-policy.yml: base의 코드만 실행하는 PR 검사.
- tests/tooling/test_department_policy.py, test_policy.py: 회귀 검증.
- docs/governance/path_exceptions.json: 빈 예외 목록.
- docs/governance/DEC-0002_DEPARTMENT_POLICY.md: Owner 지시와 구현 판단 구분.
- tasks/DEV-003_DEPARTMENT_POLICY.md, DEV-003_RESULT.md: 티켓·결과.

## 검증

- `.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v`: PASS, 19 tests (4.253s). 네 부서 정상 메시지/문서, 부서 불일치, 소스·CI·타 부서 경로 거부, rename, 경로 우회, 만료 예외, symlink, API 방식 commit-tree의 정상/부정 사례와 자기 예외 승인 거부 검증. 중간 위반을 이후 복구해도 거부.
- `.venv/Scripts/python.exe tools/policy.py check`, `git diff --check`: PASS.
- 초기 샌드박스에서 임시 Git 생성 제한으로 두 테스트 실패. 승인된 권한으로 재실행하여 전체 통과.
- GitHub 플러그인 읽기: PASS. 공개 개인 저장소, 연결 계정 wisberry2022, 최초 main protected=false, rulesets=[].
- 브라우저 관리자 접근: NOT_RUN, 컴퓨터 사용 승인 대기 만료. 대체로 기존 Git 인증의 API 읽기 성공(admin=true, protection=null). 자격증명 출력/파일 저장 없음.
- 자동 게임 테스트 / Godot 프로젝트 로드 / 게임 플레이 / Windows 빌드: NOT_RUN, 게임 코드/설정 변경 없음.
- 원격 PR CI·서버 보호 적용 결과: 후속 실행 후 이 보고서 또는 채팅에 기록. 파일 작성만으로 원격 강제 완료로 간주하지 않는다.

## 한계와 후속 조건

동일 계정의 DEV 사칭까지 기술적으로 막으려면 계정/App 분리가 필요하다. 현재 자기 PR 승인은 불가능하므로 필수 리뷰 0 + PR/필수 검사로 운영하며 Owner의 승인 원칙은 유지한다. CODEOWNERS 자체는 디렉터리 쓰기 권한이 아니다. 서버 보호를 바꿀 수 있는 관리자 본인까지 영구적으로 제한하는 구조는 아니다.

ChatGPT 타 부서에 자동 메시지는 전송하지 않는다. 각 채팅의 지침에 DEPARTMENT_WORKFLOW의 시작 문구를 적용하고 원격 문서를 명시적으로 읽어야 한다. 기존 HQ DRAFT 및 과거 승인 문서는 이동하거나 승인 상태를 변경하지 않았다.

## 원격 적용 후속 기록

- PR #1: policy CI 성공 후 squash 통합, main SHA `4254dd5aad0fadee9ce3a2b165f7e3489595c658`.
- main 보호 적용 및 API 읽기 확인: PR 필수, policy/department-policy 필수, strict=true, enforce_admins=true, 선형 이력, force push/삭제 금지, 대화 해결 필수.
- 저장소 병합 방식: squash만 허용, merge commit/rebase merge/auto-merge 비활성.
- 필수 리뷰 0: 현재 동일 계정 구조를 반영. 독립 승인·부서 신원 분리는 후속 조건이다.
- 이 후속 결과 문서는 GitHub 플러그인의 create_branch와 update_file(Contents API)로 작업 브랜치에 직접 기록했다. 로컬 훅 없는 API 쓰기의 실제 경로를 검증한다.
- 후속 PR에서 department-policy 정상 실행과 잘못된 제목 거부를 확인하고 최종 결과를 채팅에 보고한다.
