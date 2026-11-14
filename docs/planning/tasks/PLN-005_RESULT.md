# PLN-005 — Gate 2 C/DATA W05 정책 반영 결과

- 담당: Planning 추적 / `AGT-PLN-0003`
- 작업일: 2026-11-14 / Asia/Seoul
- 티켓·Owner 승인: [PLN-005_GATE2_W05_SPEC_SYNC.md](PLN-005_GATE2_W05_SPEC_SYNC.md)
- 상태: `REVIEW / OWNER_SPEC_APPROVED / MAIN_MERGE_PENDING`
- 기준 main: `73a1ada09f15c72e9bb68efbd3c54ca605952012`
- 브랜치: `codex/PLN-005-gate2-w05-spec-sync`

## 결과와 영향

기존 C/DATA에는 사업계약 효력부터 공기를 기산하는 문구와 수리 재원·선지급·공정 중단·명령 시간의 누락이 있었다. [Owner R01~03 결정](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6719007539)을 반영해 실제 착공 기산, R 우선+A 수리 전액 선지급, 수행 공정/발생/지급 분리, 공사계약과 현장 명령의 시간 구분을 정리했다.

변경 파일은 C·DATA·작업 티켓·본 결과서의 4개이며 모두 `docs/planning/`에 있다. C는 v0.7, DATA는 v1.4로 기록했다. 기존 `DRAFT` 파일명은 경로 호환성을 위해 유지한다. AC-06·07과 W05 경계 사례11개에 기대값을 연결했으며 기존 AC/VP의 범위를 확대하지 않았다.

## 승인안과 최신 main 대조

검토 당시 main `4b3f73c5d8b87630cc96eb90f950761f79bb861b`에서 최초 대조 main `62bfd068bcef7c87513d7639d232b62f7c748d5c`까지 2개 커밋·18개 파일 변경을 확인했다. 제출 직전 DSG-008 PR #107의 Design 6개 파일 변경을 추가 확인하고 작업 브랜치를 최종 기준 main으로 fast-forward했다. 총 3개 후속 커밋에 C/DATA·이번 정책·공통 지침 변경은 없다. 승인 패키지의 30개 문안 변경(C15·DATA15)을 원본에 정확히 적용한 결과가 승인된 proposed 파일과 일치했다. 그 위에 승인일·버전·상태·기준 SHA·작업 참조 등 메타데이터만 파일별10곳 갱신했다.

| 대상 | 식별자 |
|---|---|
| 원본 C Blob | `44c671303573da4116336aa60288207bc8d7a0ef` |
| 원본 DATA Blob | `359408ee058bae3e350defb45e594df4ee5c78d9` |
| 승인안 C SHA-256 | `1fb8fe78252dbbf68b0530a3d2012812b9c312127be91efb5d5adb6a20def77a` |
| 승인안 DATA SHA-256 | `dfafbcd22eab4a33f12a80ffe7f2c0bdd2ab964c728690e71767f09f8b401426` |
| 최종 C SHA-256 (UTF-8/LF) | `a0b2d01ff783f08eef0c30251679ab80ab2a4f9806367470f3fe5588f231e3d2` |
| 최종 DATA SHA-256 (UTF-8/LF) | `4acbf616948a7096fb3159834a00bc26d78d1e69a6389d6560e87ecffc12b024` |

## 검증 기록

| 검증 | 결과·증거 |
|---|---|
| 승인 패키지 무결성·원본 Blob·30개 문안 재구성·20개 메타데이터 변경 | PASS — Owner 보관 패키지의 파일별 SHA-256 및 각 치환의 단일 일치를 확인 |
| 과거 감사 코드 블록 | PASS — 기존 `markdown` 블록 내용을 그대로 보존 |
| `.venv/Scripts/python.exe tools/policy.py doctor` | PASS — 작업 worktree의 hooks·tooling 확인 |
| 문서 경계값·상대 링크·허용 파일 검산 | PASS — W05 11개 사례의 시간/자금/floor 계산, 상대 링크26개, 허용 파일4개, 도시/APP/기존 AC·VP 보존 확인 |
| `.venv/Scripts/python.exe tools/policy.py check` | PASS — 최종 기준 main에서 worktree files=557, GDScript=39. formatter/linter 정상. 최초 기준의 files=553 검사는 이전 실행 기록 |
| `git diff --check` | PASS — 공백·패치 오류 없음 |
| 정상 commit/pre-push hooks, 최신 fetch 후 `policy.py preflight` | 커밋 이후 실행 결과와 head SHA를 PR 본문에 기록 |
| 원격 `policy`·`department-policy` | PR 생성 후 해당 head의 실제 결과를 PR 본문·Owner 회신에 기록 |
| 게임 자동 테스트·Godot 프로젝트 로드 | NOT_RUN — 기획 문서만 변경 |
| 게임 플레이·실제 GUI·Design 독립 인수·성능·Windows 빌드 | NOT_RUN — 이번 문서 제출의 실행 범위 밖 |

검산은 문서 기대값 확인이며 DEV 자동 테스트나 제품 인수의 대체 증거가 아니다. 로컬 작업은 공유 디렉터리의 브랜치를 변경하지 않는 별도 worktree에서 수행했다. 승인 패키지·검산 보조 스크립트는 Owner 로컬 보관이며 Git 제출 파일에 포함하지 않는다.

## 미결·후속 경계

- 이번 명세 개정은 Owner 승인 문안의 반영이다. 범위 내 추가 게임 정책 결정 요청은 없다.
- 부분 변제·미래 예약·지체상금·해지 등 승인 밖의 세칙은 계속 미결로 남긴다.
- C/DATA 개정은 런타임 `data_version`·API 계약·W05/W06 실제 GUI 인수 또는 VS-01/Stage DONE을 변경하지 않는다. 구현 인수는 해당 SHA·DEV/Design/HQ 증거로 별도 판단한다.
- main 병합 승인: PENDING. Commit·Push·PR 승인을 병합·릴리스 승인으로 확대하지 않는다.
