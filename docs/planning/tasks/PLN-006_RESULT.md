# PLN-006 — 회사 내부 상태값 서비스 설계 통합 결과

- **상태:** REVIEW / DRAFT_SUBMISSION. Owner 정책 채택 완료, 문서·구현 인수/DONE 아님.
- **기록일:** 2026-11-14 (Asia/Seoul)
- **담당:** Planning / 현재 세션 Agent-ID 미확인. 기존 ID 사칭·등록부 변경 없음.
- **근거/권한:** [PLN-006 티켓](PLN-006_COMPANY_STATE_SERVICE_DESIGN.md)의 이번 Owner 직접 지시 범위.
- **원격 기준 main:** `6fbb9e400f9c185814c465935c30c9739d49f6db`.
- **작업 브랜치:** `codex/PLN-006-company-state-service-design`.

## 변경 내용

| 파일 | 결과 |
|---|---|
| [회사 내부 상태값 문서](../PLN-004_POST_MVP_COMPANY_STATE_V0_7.md) | 기존 경로에 v0.8을 통합. 공통/재정 보존, 서비스 기준선 v1.0 §9~18 추가, 과거 '서비스 후속 상세화' 안내 갱신 |
| [PLN-006 티켓](PLN-006_COMPANY_STATE_SERVICE_DESIGN.md) | 승인·범위·산출물·수용 기준 명시 |
| 이 결과 파일 | 확인한 증거와 미실행/미확인 범위 구분 |

서비스 수준 47개 정책은 채택 완료이며 잔여 정책 결정은 0건이다. 향후 DEV 데이터 확인 14개, Design 표현 확인 8개, 검증 항목 24개를 별도로 정리했다. 이 개수는 다시 승인받을 정책 결정 수가 아니다. 다른 회사 카테고리와 FIN의 기존 미결 사항은 원래 범위를 유지한다.

## 검증 기록

아래 제출 전 검증은 실제 실행 결과다. GitHub API로 게시하며, 로컬 commit/push 훅 실행과 원격 CI를 구분한다. 커밋 생성 후 확인할 SHA·CI는 자기 커밋을 수정하는 대신 PR 본문과 최종 제출 보고에 기록한다.

| 검사 | 결과·증거 |
|---|---|
| 원격 기준 확인 | main/기존 회사 문서/C/DATA blob을 읽고 티켓에 고정. 독립 작업 디렉터리 사용 |
| 로컬 환경 | `.venv/Scripts/python.exe tools/policy.py doctor` PASS: 저장소 로컬 훅 활성·gdtoolkit 4.5.0 |
| 문서 보존·구조 | PASS: 기준 HEAD와 기존 §1~5 본문 완전 일치. 결정 ID 47개 연속/묶음 8·8·6·5·6·8·6, DEV14/Design8/검증24 확인 |
| 문서 형식·링크 | PASS: UTF-8/BOM 없음/마지막 개행/후행 공백, 상대 링크17개 존재, 개인 로컬 경로 비포함. `git diff --check` PASS |
| 정적 산술 | PASS: 세 지표 앵커·부모6.5·가중 집계5 및 50/19·환승 요청200/탑승180/운임8000·지역 분모4700/6100/7000/7300·부분일720분·경로9/11분을 유리수로 대조 |
| 저장소 정적 검사 | `.venv/Scripts/python.exe tools/policy.py check` PASS / files=559 / GDScript=39. 제한 환경의 임시 폴더 접근 오류 후 동일 검사를 허용된 실행 환경에서 재실행해 통과 |
| 제출 구조 | 변경 대상은 기획 경로3개, base tree 보존/일반 부모1개/작업 브랜치/expected SHA·force=false로 API 게시. 실제 커밋의 `preflight` 결과·SHA는 PR 본문에 기록 |
| 로컬 commit/push 훅 | NOT_RUN — GitHub Git Data API 제출. 로컬 훅 활성 확인/정적 검사와 동일시하지 않음. 원격 부서/정책 검사를 별도 확인 |
| 원격 CI | PR 생성 후 실제 head의 `policy`·`department-policy`를 PR 본문/최종 보고에 기록. 이 커밋 자체에서는 미실행 |

## 실행하지 않은 것과 한계

- 게임/Godot 프로젝트 로드·실제 플레이·다노선/세이브 변환·UI·성능·밸런스 실측·Windows 빌드·AC/VP 인수: **NOT_RUN**. 정적 기대값은 구현 PASS가 아니다.
- DEV/Design 데이터 공급·현재 구현 지원 여부 확인 및 검토 요청: **NOT_REQUESTED / NOT_VERIFIED**. 부서 메시지·리뷰어 지정·새 실행 티켓 없음.
- Agent-ID 신원 인증: **UNVERIFIED**. Provenance REPORT_ONLY의 한계를 유지하고 다른 담당자의 ID/Manifest를 사용하지 않는다.
- main 병합·auto-merge·릴리스/배포: **NOT_PERFORMED**. 원격 브랜치 보호의 완전한 강제 적용은 이 문서 검사로 증명하지 않는다.
- 공개 산출물은 승인 정책을 요약한 설계이며 비공개 인수인계서/대화 원문·개인 경로를 첨부하지 않는다.

## 후속 처리

추후 Owner/HQ가 실제 작업을 배정할 때 설계서 §16의 자료/표현 확인, §17의 검증을 사용한다. 확인 결과가 기존 정책과 충돌할 때만 해당 결정 ID와 영향을 명시한 변경안을 작성한다. 이번 PR로 부서에 착수/검토를 요청하지 않는다.
