# PM-016 — S2 증거 연결·잔여 업무 정리 결과

- HQ / AGT-PM-0002 / 2026-11-14 / REVIEW / MAIN_MERGE_PENDING.
- 기준 main: `9e6154e926d44cdbbb2fb117fb7d3fc56d152eac`.
- [티켓·요청 범위](PM-016_STAGE2_ACCEPTANCE_UPDATE.md) / [통합 인수표](../STAGE2_ACCEPTANCE_MATRIX.md).

## 변경 결과

Q03~05의 합의된 잔여 종료를 S2-02·03·08에 연결하고 DEV 제출·Design 수용을 S2-11에 연결했다. W05 정상/반례, OBS-01, Q12 28조건의 기존 수용을 재사용했다. Q12 원래 P05 인계 조건의 공개 요약상 개별 증거 대응은 NOT_VERIFIED로 분리하고 새 GUI 요청으로 취급하지 않았다.

우선순위는 DEV-022 실행 패킷/권한 확인 → 실제 운행 모델 → DEV-023 UI → DEV-024 실제 VS-01 → HQ/Owner 통합 인수다. 기존 R01~03 결정과 PLN-005 개정 완료를 반영했으며 DEV-022 새 실행 승인·Stage DONE을 선언하지 않았다. HQ Markdown 5개와 제출 출처 JSON 1개만 변경. PM-014 승인 기준과 타 부서 산출물·제품 코드는 보존했다. 게임 명세 변경 필요 없음.

## 검증

- 원격 main·관련 공식 수용 댓글·PR·승인 명세·DEV-022~024 티켓 대조: 완료. 현재 main과 Q03~05 시험본 사이 Planning 문서3개 외 제품 변경 없음 확인.
- `tools/policy.py doctor`: PASS — 격리 사본의 저장소 훅과 기존 고정 gdtoolkit 실행기 확인. 원격 보호 검증을 대신하지 않음.
- 문서 정적 검사: 로컬 초안 PASS — Markdown 5개, 상대 링크30개, S2 행11개·근거 항목10개, UTF-8/LF·표 열 수·기존 README/PM-014 본문 보존·시험본 이후 Planning 문서3개만 변경 확인. 제출본은 같은 범위와 출처 JSON의 blob·기존 blob을 재검증하고 실제 결과를 PR에 연결한다.
- `git diff --check`: PASS. 신규 파일의 후행 공백·최종 개행도 별도 정적 검사.
- `tools/policy.py check`: 로컬 초안 PASS — worktree files=594, GDScript=39, formatter/linter 정상. 출처 JSON을 포함한 제출본도 같은 검사로 확인하고 실제 결과를 PR에 연결한다. 기존 고정 `.venv` Python을 실행기로 사용하고 이 격리 사본의 제외된 `.local/policy-temp`를 검사 프로세스 TEMP/TMP로 지정했다. 검사기·제품 코드·정책 변경 없음.
- 제품 자동 테스트·Godot 프로젝트 로드·실제 GUI/게임 플레이·Design 독립 실행·빌드/export/성능: NOT_RUN — HQ 문서 작업.
- Owner 보관 원본 ZIP의 직접 바이트/해시 재검증, DEV의 미게시 로컬 문서4개 검사: NOT_VERIFIED. 공식 Design 판정과 자기보고를 구분.
- GitHub API 제출: 최신 main·단일 부모·기존 base tree·허용 HQ 경로·파일 모드·예상 blob을 확인한 뒤 작업 브랜치에 게시한다. API에서는 로컬 Commit/Push 훅은 NOT_RUN이며 원격 필수 검사를 대신하지 않는다.
- 제출 head의 `policy` / `department-policy` 및 출처 REPORT_ONLY 결과는 PM-016 PR의 실제 CI와 본문을 정본으로 연결한다. 이 결과서만으로 아직 실행하지 않은 CI를 PASS로 표시하지 않는다. Agent-ID/Manifest는 출처 선언이며 신원·승인 인증이 아니다.
- main 병합: NOT_RUN / OWNER_APPROVAL_PENDING. 브랜치 게시·PR 검토와 main 반영을 구별한다.

## 남은 사항

PM-016 제출은 Owner의 후속 Commit·Push·PR 승인에 따른다. main 병합은 별도 Owner 결정 대상이다. DEV-022 실행 권한은 해당 Owner 결정/유효 승계 범위를 대조하며 이미 유효한 권한을 재승인받는 절차는 만들지 않는다. Q12 기존 증거 색인 확인은 개발 모델 착수와 병행한다. 미래 공통 코드 변경·새 결함·증거 신뢰성 문제는 영향 행만 재개방한다.
