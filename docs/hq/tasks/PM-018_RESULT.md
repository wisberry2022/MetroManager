# PM-018 — DEV-023 완료·S2 갱신·후속 이관 결과

- HQ / AGT-PM-0002 / 2026-11-15 / REVIEW / MAIN_MERGE_PENDING.
- 기준 main: `6e8e5869d13a7e14dc2d70ef35d5340ab2967e41`.
- [티켓·Owner 결정](PM-018_DEV023_CLOSEOUT.md) / [S2 통합 인수표](../STAGE2_ACCEPTANCE_MATRIX.md).

## 처리 결과

Owner의 명시 결정에 따라 DEV-023을 OWNER_ACCEPTED / DONE으로 기록하고 [#79](https://github.com/wisberry2022/MetroManager/issues/79)를 CLOSED/completed로 종료했다. 최신 근거·DEV-024/HQ 이관을 본문 앞에 추가했으며 최초 본문과 기존댓글5개·라벨을 보존했다. 종료 시각 `2026-11-15T02:51:52Z`는 GitHub 처리 시각이며 별도의 소급 효력 시각을 생성하지 않는다.

S2-06/07/08/09에 DEV-023 해당 화면·조작의 Design 대기 해소를, S2-11에 구현·L2·24조건·DEV 수신·Owner DONE 근거를 연결했다. 기존21+보완3 조건과 P07 stale·525자 사유·P05 234 복귀의 범위를 구별한다. S2-09 실제 제품 조작 수용을 반영하면서 모델 경로 준비 후 GUI와 자연 전체 VS-01을 구별했다. 다음 필수 경로는 DEV-024 실제 표준 완주·최종 영향 회귀, HQ S2-01~11 통합과 Owner 최종 Stage 인수다.

Q12 원래6범위 대조 완료와 상위 PARTIAL, Q12 28조건 및 기존 QA/W05/OBS/A02-11을 보존했다. W06·VS-01을 P05 종료의 새 선행조건으로 만들지 않았다. DEV-023 개별 승인 원문은 공개 티켓에서 확인했고, DEV-024의 현재 지정 담당·고정 시험본·개별 권한 원문은 NOT_VERIFIED로 남겼다. 기존 유효 권한을 재승인 대상으로 돌리지 않는다.

변경 파일은 티켓에 기재한 HQ5개다. 타 부서·게임 소스·도구·정책은 변경하지 않았다. 게임 명세 변경 필요 없음.

## 검증과 한계

- 공식 main·#79의 L2/21+3/DEV 수신·#81 연결·#80 현재 상태, PR #127/#128 main 병합/제출 head의 필수 policy·department-policy SUCCESS 확인. GUI 시험 SHA 이후 기준 main까지 제품 소스 변경 없음(Planning3·Design2 문서).
- #79 readback: CLOSED/completed, 최초 본문·댓글5개·라벨 보존 확인. 다른 Issue 상태 변경 없음.
- 격리 사본에 기존 고정 `.venv` Python을 사용해 `tools/install_hooks.py`·`tools/policy.py doctor`: PASS. 공유 작업 트리의 브랜치와 기존 파일 보존.
- 문서·출처 정적 검사 및 `git diff --check`: PASS. UTF-8/LF·마지막 개행·표 열 수·상대 링크·S2 11행·Q12 6행·근거15개·HQ5경로·출처 blob을 대조한다.
- `../../.venv/Scripts/python.exe tools/policy.py check`: PASS (files=651, GDScript=48; formatter/linter 정상). 격리 사본의 `.local/policy-temp`를 검사 프로세스 TEMP/TMP로 사용한다.
- GitHub API 제출 시 실제 base/tree·단일 부모·파일 모드/범위·blob과 expected SHA를 대조한다. API의 로컬 Commit/Push 훅은 NOT_RUN. 실제 제출 head·preflight·필수 CI와 provenance REPORT_ONLY 의미는 PR에서 확인한다. 출처 일관성은 신원/승인 인증이 아니다.
- HQ 신규 게임 자동검사·Godot 프로젝트 로드·GUI/플레이·Design 독립 실행·빌드/export·성능은 **NOT_RUN**. 기존 DEV 자동/GUI·Design 심사를 새 HQ 실행으로 계상하지 않는다.
- Owner 보관 ZIP 직접 재해시·DEV 미게시 후속 로컬 문서3개 직접 검증은 **NOT_VERIFIED**. ZIP manifest 일치는 Design 보고로 연결했다. 추가 문서 PR이나 전면 GUI를 종료의 새 조건으로 요구하지 않는다.
- 이번 PM-018 main 병합은 **NOT_RUN**. DEV-023 DONE 및 #79 종료와 문서 PR의 미병합 상태를 구별한다.

## 후속과 보존

DEV-024/#80 담당·시험본·유효 실행/Git 승인 연결 후 실제 초기 상태의 B01→입찰/계약→표준 공사→시범/안전→개통→실제 영업→첫 유효 실적 보고→다음 사업 조회를 완주한다. 실제 완료 통행/영업 실적과 입력·명령·효력시각·원장·도착·보고·종료코드·해시 및 최종 회귀/영향을 연결한다. 자동 러너·강제 fixture·하위 수용 합계로 대체하지 않고 관측 범위 안에서 같은 증거를 S2-08/09/10에 공동 사용한다. 두 번째 수주·빠른 별도 전체 E2E는 추가 의무가 아니다.

HQ는 S2-01~11 부서 수용·필수 CI·미해결/이월을 종합한다. 전체 S2 PASS·Stage DONE과 #77/#81 종료는 이번 처리에 포함하지 않는다. 환경/물리 DPI/과거 보조 도구 바이트/Q12 ERROR 2→7 인계 정정 완료 NOT_VERIFIED, 최초 콘솔/Q12 R02 NOT_CAPTURED, 과거 timeout/비정상 종료를 보존한다. Track B/F-08 별도 소유·승인 및 DEV-026 구현·제품 검증 HOLD를 유지한다.

이미 수용한24조건은 실제 변경 영향·새 결함·증거 신뢰성 문제가 확인될 때 영향 행만 재개방한다. SHA 진전이나 기록 정정만으로 반복하지 않는다.
