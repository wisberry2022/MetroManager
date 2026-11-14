# PLN-005 — Gate 2 C/DATA의 승인된 W05 정책 동기화

- 담당: Planning 추적 / `AGT-PLN-0003` (기준 main 등록부 ACTIVE)
- 작업일: 2026-11-14 / Asia/Seoul
- 상태: `OWNER_SPEC_APPROVED / OWNER_COMMIT_PUSH_PR_APPROVED / REVIEW / MAIN_MERGE_PENDING`
- 저장소: `wisberry2022/MetroManager`
- 브랜치: `codex/PLN-005-gate2-w05-spec-sync`
- 반영 기준 main: `73a1ada09f15c72e9bb68efbd3c54ca605952012`
- 결과: [PLN-005_RESULT.md](PLN-005_RESULT.md)

## Owner 승인과 Git 실행 범위

Owner는 2026-11-14 현재 Planning 추적 대화에서 제출된 개정안을 승인하고 다음 실행을 지시했다. 이 대화의 공개 URL은 없으며 원문은 Owner 보관 대화에서 확인한다.

> 좋습니다. 개정안을 승인합니다. 최신 원격 main과 변경 여부를 다시 확인한 뒤 C/DATA 문서에 반영하고 커밋·푸시·PR을 생성해주세요. main 병합은 별도 승인하겠습니다.

승인 대상은 2026-11-08 제출한 `G2-CDATA-R01R03-REV-20261108` 개정안이다. 이번 작업에서는 그 문안을 그대로 적용하고, C v0.7-review / DATA v1.4-review의 버전·상태·날짜·교차참조를 C v0.7 / DATA v1.4 승인 상태로 갱신한다. 기존 Gate 2 승인과 실제 제품 인수 상태는 별도로 보존한다.

허용 동작은 위 저장소의 작업 브랜치에서 이 개정안을 반영하는 Commit·일반 Push·PR 생성이다. 유효 범위는 이번 제출 작업이며 이후 신규 작업에 재사용하지 않는다. main 병합·자동 병합·강제 Push·릴리스·배포는 포함하지 않는다. 검사 통과나 PR 제출은 병합 승인 또는 Stage DONE이 아니다.

작업 ID `PLN-005`는 최신 원격 트리·전체 Issue/PR 목록·원격 브랜치와 로컬 참조를 조회하여 기존 사용이 없음을 확인하고 부여했다. [부서 작업 절차](../../engineering/DEPARTMENT_WORKFLOW.md)에 필요한 티켓과 결과 기록을 함께 제출한다.

## 최신 기준선 재확인

- 개정안 검토 main: `4b3f73c5d8b87630cc96eb90f950761f79bb861b`.
- 최초 대조 main `62bfd068bcef7c87513d7639d232b62f7c748d5c`까지의 후속 변경은 [INF-008 PR #105](https://github.com/wisberry2022/MetroManager/pull/105), [DEV-021 포커스 보완 PR #106](https://github.com/wisberry2022/MetroManager/pull/106)이다. 두 커밋의 18개 변경 파일에 C/DATA는 없다.
- 제출 직전 [DSG-008 PR #107](https://github.com/wisberry2022/MetroManager/pull/107)의 병합을 추가 확인했다. Design 6개 파일만 변경되어 C/DATA·기획 정책·공통 지침에 충돌이 없으며, 작업 브랜치만 최신 main으로 fast-forward했다. 총 3개 후속 커밋을 대조했다.
- C 원본 Blob: `44c671303573da4116336aa60288207bc8d7a0ef`.
- DATA 원본 Blob: `359408ee058bae3e350defb45e594df4ee5c78d9`.
- [Issue #26의 Owner 결정](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6719007539)과 후속 댓글을 재조회했으며 R01~03 여섯 정책을 뒤집는 후속 결정은 확인되지 않았다.
- [DEV-020 PR #95](https://github.com/wisberry2022/MetroManager/pull/95)의 모델 구현·검증은 참고 증거이며 정책을 추가 승인하는 근거로 사용하지 않는다.

## 포함 범위

| 파일 | 변경 |
|---|---|
| [PLN-001-C.md](../PLN-001-C.md) | v0.7. 승인 상태, §2-4·5-4~5-6·6 및 개정 이력에 R01~03 반영 |
| [PLN-001_GATE2_DATA_v1_DRAFT.md](../PLN-001_GATE2_DATA_v1_DRAFT.md) | v1.4. §1·3~6 및 이력, W05 정적 경계 사례 11개 반영. 기존 파일명 유지 |
| 본 티켓 | 이번 Owner 승인·작업/경로/권한·검증 범위 기록 |
| [PLN-005_RESULT.md](PLN-005_RESULT.md) | 실제 대조·검산·검사 결과 및 NOT_RUN 기록 |

정책 반영의 핵심은 다음과 같다.

1. R01: 사업계약이 아닌 실제 착공 효력부터 표준2880·빠른1440게임분. 대기·자금 중단은 유효 공정으로 계산하지 않는다.
2. R02: 빠른 공사 첫 안전 결함 수리20000은 동일 사업 R 우선·부족분 A, 착수 전 전액 지급. 부족하면 부분 차감·착수 없음.
3. R03: 수행 공정과 발생 기성을 보존하고 실지급·공사 미지급을 운영비 B와 분리. 미지급 해소 후 재개하며 중복 비용·지급 없음.
4. R03: 공사계약은06:00~24:00, 현장 명령은 선행조건 충족 시24시간. 각 유효 시작 T에서 N분 후 T+N 완료, 요청·효력·완료를 구분.

공사비600000/720000, 기간2880/1440, 누적 floor 기성, 시범60·안전60·수리20000/30·재시험60, 기존 원장·SEM/CLOSE/APP·MVP 8개 영역/MUST 11개/AC-01~10/독립 VP-01·02를 보존한다.

## 제외 및 중단 조건

게임 소스·런타임 데이터·API·UI·다른 부서 문서·공통 정책/CI는 변경하지 않는다. 문서 DATA v1.4를 런타임 `data_version=1.3` 또는 `rules_version=RFC-DEV-020-01-OWNER-20261108`의 변경 승인으로 해석하지 않는다. A/B·D·Gate 2 최종 승인 원본과 과거 감사 이력을 보존한다.

미지급 기성 부분 변제, 보편적 최소 착공잔액, 미래 초과 공사비 예약, 지체상금·납기 제재·해지·대출/이자, POST-MVP 상태값의 현재 MVP 적용은 추가하지 않는다. 정책 충돌·범위 확대·최신 main 충돌이 발견되면 해당 반영을 중단하고 근거를 Owner에게 보고한다.

## 검증·인수

승인 패키지 해시와 원본 Blob, 30개 승인 문안 변경 및 20개 승인 메타데이터 변경을 대조하고, 금액·T+N·기성·자금 보호 경계 사례를 정적으로 검산한다. Markdown 링크·과거 감사 블록·허용 경로·공유 작업물 보존도 확인한다.

로컬 `doctor`, `check`, 정상 Git hooks, 커밋 후 최신 fetch 및 `preflight`, PR의 `policy`·`department-policy`를 확인한다. 실제 명령·결과는 결과서와 PR 본문에 기록한다. 문서 개정만으로 게임 자동 테스트·Godot 로드·GUI·Design 독립 인수·빌드를 PASS 처리하지 않는다.
