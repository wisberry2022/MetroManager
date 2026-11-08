# DSG-006 — 시각 원본 보관 준비·현황 정리 결과

- 담당: Design / Track B / AGT-DSG-0003 / 2026-11-08
- 상태: REVIEW / OWNER_GIT_SUBMISSION_APPROVED / MAIN_PUBLICATION_PENDING / FINAL_SPEC_PENDING / NOT_DONE
- 기준 main: `7735ccff22952dabdf1371c2b29d81b620f4a9c0`
- 브랜치: `codex/DSG-006-visual-archive`
- 승인·범위·보존 방침: [보관 준비](DSG-006_VISUAL_ARCHIVE_PREPARATION.md)
- 최신 현황: [진행 snapshot](DSG-006_TRACK_B_PROGRESS_SNAPSHOT.md)

## 1. 산출물 — 신규9개

보관 준비·진행snapshot·본 결과의 Markdown3개, 무수정 원본 HTML2개, 파생 열람기1개, 대표 PNG2개, archive_manifest.json1개다. 상세 목록·해시/바이트·원본/파생 구별은 [보관 명세](../assets/source/dsg_006/archive_manifest.json)에 기록한다.

기존 추적 파일·원래 로컬 원본은 수정하지 않았다. 최초 보고는 디자인 경로의 로컬 검토본이었으며 후속 Owner가 위9개 제출을 승인했다. [보관 준비 §1](DSG-006_VISUAL_ARCHIVE_PREPARATION.md#1-승인작업-경계)에 승인 문장·브랜치·범위를 기록했다. 과거 문서·Agent 등록부·HQ/DEV 결과·승인 기록·QA 결과를 덮지 않았다.

## 2. 실제 검증

- `.venv/Scripts/python.exe tools/policy.py doctor`: PASS (변경 전). 원격 보호·Owner 승인 진위 검증은 아니다.
- `.venv/Scripts/python.exe .local/archive/build_archive.py`: 원본2개의 바이트/과거 SHA 일치 후 사본·열람기 생성.
- `.venv/Scripts/python.exe .local/archive/prepare_qa.py`, `node --check .local/archive/check_archive.cjs`, `node .local/archive/check_archive.cjs`: **173 checks PASS / JavaScript runtime exception0**.
- 독립 Windows Chrome headless CDP·전용 프로필에서 로컬 파일로 실행했다. 1200/760 CSS px×7후보×기본/경고의 후보 전환·12역/공식6역 순서·재무값·예측 구분·S12 정보/소속·보고 분리를 확인했다. 가로 넘침 관찰은0건이었다. 좁은 폭 전체 수용이나 제품 해상도 검증은 아니다.
- 열람기 높이가 전환할 때 누적되는 여백을 수정한 뒤 전수 재실행·대표 캡처를 갱신했다. 원본은 변경하지 않았다.
- PNG2개는1200px·DSF1·normal·S03 정보 선택, 최초3안의 생활 도시와 추가4안의 디오라마다. 각각1200×1444,1200×1446이다. 이번 새 캡처이며 과거 채팅 화면이나 게임 에셋이 아니다.
- 두 대표 캡처를 작성자가 시각 확인했다. 나머지5후보의 개별 시각 전수 검수·외부 검수는 별도다.
- QA 보조 코드·원시 결과·브라우저 프로필은 제외 경로 .local/archive에 보존하며 신규9개에 포함하지 않는다. 다른 clone에서 자동 제공되지 않는다.
- .venv/Scripts/python.exe .local/archive/check_package.py: PASS. 정확한 신규9개·기존 추적 파일 무변경, 원본 바이트/과거 해시·내장 사본 일치, 파생물 해시·PNG 크기/CRC·UTF-8/LF·링크·173개 결과를 확인했다.
- .venv/Scripts/python.exe tools/policy.py check: PASS (worktree files=512, GDScript=35, formatter/linter 정상). git diff --check: PASS. 신규 텍스트는 별도 인코딩 검증으로 확인했다.

## 3. 과거·현재 검증 구분

과거 DSG006 결과의 브라우저 실행 실패/NOT_RUN은 그 당시 사실로 보존한다. 이번173개 검사는 새 호스트 열람기의 제한된 재현성 확인이다. 과거 실행 성공·전체 사용성·기술 성능 또는 실제 제품 규격 합격으로 소급하지 않는다.

DSG007/008의 기존 브라우저·패키지 검증은 해당 결과서/PR에 연결하며 이번 보관 작업에서 재실행했다고 하지 않는다. 공식 Agent 등록과 DEV 기술 의견 수신은 최신snapshot에서만 갱신했다.

## 4. 미해결·NOT_RUN

공용 보관 패킷은 **제출 승인됨/main 반영 대기**다. 작업 브랜치·PR을 통해 공유하며 실제 제출 head·원격 파일 검증·CI 결과는 PR에 기록한다. 후임이 main에서 바로 열람할 수 있다고 표시하지 않는다. main 반영·Owner/HQ의 S2-D01 인수는 남아 있다. Tweak/openai 호스트·당시 스타일/선택상태의 완전 복원은 제공하지 않는다.

| 항목 | 상태 |
| --- | --- |
| 자동 게임 테스트 | NOT_RUN — 원본 보관·상태 문서 작업 |
| Godot 프로젝트 로드 | NOT_RUN — 게임·설정 미변경 |
| 게임 플레이·실제 제품 GUI | NOT_RUN — 콘셉트 시안은 모델 미연결 |
| Windows 빌드/export | NOT_RUN — 후속 W09 |
| 실제 폰트·DPI/필터·CPU/메모리/FPS·가림/키보드 제품 인수 | NOT_RUN — F08 실제 실험/제품 검증 필요 |
| 외부 사용성·접근성 실측 | NOT_RUN |
| 이슈/다른 채팅 전달 | 미수행 — 이번은9개 파일의 Git 제출 승인 |
| main 병합·릴리스·배포 | 미수행 |

최초 보고의 Commit·Push·PR·CI 미수행과 후속 승인된 Git 제출 결과를 분리한다. 정상 훅·preflight·원격 필수 policy/department-policy 및 REPORT_ONLY 출처 진단은 제출 PR에 남긴다. AGT-DSG-0003은 현재 보관 작성자로 선언하며 과거 저자를 소급 재귀속하지 않는다. archive_manifest.json은 보관 목록이고 별도 Agent provenance Manifest가 아니다. 승인된9개 범위에 출처 파일을 임의 추가하지 않으며 진단이 있으면 그대로 보고한다.

F08-01~04 OPEN, 최종 환경·폰트·치수·배율·필터·배치·FPS·표현 상한은 미확정이다. MVP 디오라마 선택과 이후 개편 가능성 조건은 유지한다. 게임 명세 변경 필요: NONE. DSG006 시각자료 공식 인수·DSG008 전체·S2-D01·Stage2 DONE은 선언하지 않는다.
