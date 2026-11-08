# INF-003 — Track A Art Director 세대교체 등록

- 담당: INF / 제출 선언 `AGT-INF-0001` / 2026-11-08
- 상태: OWNER_APPROVED_FOR_SUBMISSION / REVIEW / MAIN_MERGE_PENDING / NOT_DONE
- 저장소: `wisberry2022/MetroManager`
- 브랜치: `codex/INF-003-track-a-designer-succession`
- 검토 기준 main: `3b61628bc2e733452ed0448450d00fb3beff784d`
- 기준 등록부 blob: `bb2feea7ec788ddec029949b058b8ccad5cdbdb0`
- 정본: [registry.json](../agents/registry.json) / 검증: [INF-003_RESULT.md](INF-003_RESULT.md)

## 1. 승인 근거와 Git 실행 범위

Owner는 기존 INF 대화에서 Track A 후임의 인수인계 완료를 수용하고, 후속 결정에서 Track A 우선 등록·Track B 별도 ID 배정 및 INF-003 승인 요청을 수락했다. 2026-11-08 이 INF-003 실행 요청에서 `AGT-DSG-0002` ACTIVE, `AGT-DSG-0001` RETIRED, Track B `AGT-DSG-0003` 예약과 실제 등록 유보를 명시적으로 재확인했다.

승인 원본 위치는 Owner가 보관하는 INF 승인 대화 및 이번 INF-003 실행 요청이다. 공개 원문 URL은 제공되지 않았다. 이 문서는 확인한 결정의 최소 공개 요약이며 내부 세션 URL·대화 전문·개별 진단 점수는 게시하지 않는다. 참조 문자열이나 같은 계정의 Git 실행이 Owner 신원을 기술적으로 인증하는 것은 아니다.

<a id="owner-activation"></a>
### Owner 역할·상태 결정

- `AGT-DSG-0002`를 Track A 후임으로 먼저 발급하고 `generation=2`, `predecessor_agent_id=AGT-DSG-0001`, `status=ACTIVE`로 기록한다.
- 기존 `AGT-DSG-0001`은 `RETIRED`로 전환한다. 과거 신원·승인·작성자·QA 이력을 보존하고 신규 Track A 배정을 종료한다.
- 두 상태 전환의 승인 효력은 HQ가 확정한 `2026-11-08T15:49:28+09:00`이다.
- Track B 독립 세션의 `AGT-DSG-0003` 배정 예약은 승인되었으나 이번 공식 ACTIVE 등록 대상은 아니다.

<a id="git-approval"></a>
### INF-003 Git 실행 승인

| 항목 | 승인된 범위 |
| --- | --- |
| 승인자·기록일 | Owner / 2026-11-08, 위 승인 원본 및 현재 실행 요청 |
| 저장소·작업 | `wisberry2022/MetroManager` / INF-003 |
| 브랜치 | `codex/INF-003-track-a-designer-succession` |
| 수정 경로 | `docs/infra/agents/registry.json`, `docs/infra/tasks/INF-003_*.md`만 |
| 허용 동작 | 위 파일 작성·검증·Commit·해당 작업 브랜치 일반 Push·base=main PR 생성 |
| 기간·종료 조건 | 이번 INF-003 제출과 동일 범위 검증 보완까지. 다른 작업으로 자동 연장하지 않음 |
| 제외 | main 직접 수정·병합·자동병합·릴리스, force push·검사 우회, CI/정책/도구/타 부서 변경, 후임 신규 제작·포괄 Git 권한 부여 |

Owner 별도 main 병합 승인과 기존 squash·필수 `policy`/`department-policy` 정책을 유지한다. 이번 실행 승인이 신규 디자이너의 작업별 Commit/Push/PR 권한으로 승계되지는 않는다.

## 2. 수용·HQ 전환 근거

<a id="handoff-acceptance"></a>
### INF 수용 및 Owner 인수인계 수용

기존 INF의 후임 수용 검증 완료와 Owner의 인수인계 완료 수용을 승인 원본에서 확인했다. 이번 실행은 그 수용 결과를 계승하며 수용시험을 반복하지 않는다. 상세 시험 응답·평가 원본은 Owner 제한 보관한다. 에이전트 업무 연속성 수용은 게임 기능·Godot GUI 검수 PASS가 아니다.

<a id="pm-switch"></a>
### HQ 업무 전환 확인

HQ / Project Manager는 Owner의 인수인계 수용을 전제로 `TRACK_A_RESPONSIBILITY_CONFIRMED`, `TRACK_B_OWNERSHIP_PRESERVED`, `PM_SWITCH_CONFIRMED`, `DEPENDENCIES_ACKNOWLEDGED`, `PER_TICKET_AUTH_REQUIRED`를 회신했다. 회신 기준은 main `c81b29585496fd291cfc4aeb443ed3e5ff14c588` 및 PM-014 Stage 2 VS-01 계획이다.

HQ가 지정한 공식 업무 전환 효력은 `2026-11-08T15:49:28+09:00`이다. 기존 세션의 실제 오류·기능 중단·마지막 메시지·시험 완료 시각을 추정한 값이 아니다. 기록일, 커밋, PR, 검사 또는 향후 병합 시각과 혼용하거나 그 시각으로 덮어쓰지 않는다.

| 역할 | 등록부 변경 | 보존 |
| --- | --- | --- |
| 기존 Track A `AGT-DSG-0001` | ACTIVE → RETIRED, retired_at=위 효력, 종료 관찰일 2026-11-08, record_version 1→2, 전환 근거 추가 | activated_at=null, 기존 role/scope/kind·세대·선행자·초기 승인·인계 필드 및 기존 근거 |
| 후임 Track A `AGT-DSG-0002` | 신규 ACTIVE, generation=2, predecessor=0001, activated_at=위 효력, retired_at=null, record_version=1 | Track A만 승계; 기존 산출물의 저자 치환 없음 |
| 나머지 기존 7개 ID | 변경 없음 | 초기 8개 ID 모두 activated_at=null 보존; 기획 전임 retired_at=null도 보존 |

## 3. Track A 책임 및 기존 의존성

승계 범위는 Stage 2 Track A UI/UX 정보 구조·상태·조작·가독성, DEV의 권위 게임 상태·명령·재무·오류 화면 소비 계약 검토, 실제 Godot GUI 독립 검수·재검수, DSG-010 인수 기록 유지, W04A 잔여 A01-Q03·04·05·12, DEV-020·021 연계 W05 A-02 P05 설계·공급 계약·GUI 인수 및 이후 별도 승인된 Track A 업무다.

게임 규칙 변경·Godot 구현 구조/기술 아키텍처·Stage 통합·Owner 전용 결정 권한은 승계하지 않는다. Track B DSG-006·007의 업무 소유권과 철도 모형 디오라마 선택·승인 이력도 유지한다.

HQ 인계 snapshot의 QA-001·002 `FIX_VERIFIED`, A01-Q03·04·05·12 `PARTIAL`을 교체만으로 재판정하지 않는다. 실제 후속 GUI 증거 없이 PASS로 올리지 않는다. 추적점은 [DSG-010 #81](https://github.com/wisberry2022/MetroManager/issues/81), [DEV-019 #75](https://github.com/wisberry2022/MetroManager/issues/75), [DEV-020 #76](https://github.com/wisberry2022/MetroManager/issues/76), [DEV-021 #77](https://github.com/wisberry2022/MetroManager/issues/77)이다. 이 문서는 각 이슈의 새 검수 결과를 발행하지 않는다.

## 4. Track B 0003 예약과 별도 등록 조건

- 상태: `OWNER_ID_RESERVATION_APPROVED / SEPARATE_REGISTRATION_PENDING`. 이번에는 registry의 agents에 0003 행을 추가하지 않는다. PENDING 또는 ACTIVE 등록을 완료했다는 뜻이 아니다.
- 예약 ID는 네 자리 표준의 `AGT-DSG-0003`이다. 등록 순서에 따른 번호이며 세대 번호가 아니다. 독립 Track B의 향후 값은 `generation=1`, `predecessor_agent_id=null`이다. 0001/0002를 공유하거나 Track A 후임으로 연결하지 않는다.
- 실제 등록은 Track A 제출의 Owner 검수·main 반영 후 별도 INF 등록 작업에서 진행한다. 실행 시 최신 main/등록부/열린 등록 PR을 다시 확인하고 예약 충돌을 점검한다. 0003을 다른 세션에 재배정하지 않는다.
- Owner가 지정한 독립 세션의 공개 역할·범위·세션 종류, DSG-006·007 소유 근거, INF의 식별·중복·계보·필요 수용 검토, HQ/PM의 업무 담당 및 등록 효력 시각, Owner의 실제 ACTIVE 등록 결정과 해당 Git 제출 범위를 확인한다. ID 예약 승인을 다시 요구하는 절차는 아니다.
- Track B의 정확한 activated_at과 등록 실행일은 현재 미확정이다. 별도 확인된 오프셋 포함 승인 효력 시각을 사용하며 Track A 시각·과거 산출물 날짜·커밋/PR 시각을 복사하거나 추정하지 않는다.
- 예약은 이 승인 기록으로 관리한다. 기존 자동 PENDING 제안기는 문서 예약을 기계적으로 강제하지 않으므로 다음 DSG 발급 전 INF가 이 기록을 대조해야 한다. 스키마·도구 변경은 별도 결정 대상이다.

## 5. DEV-017 계약 적용과 검증 한계

[RFC-DEV-017-01](../../engineering/provenance/RFC-DEV-017-01_REGISTRY_CONTRACT.md)은 OPEN 계약 제안이다. [등록 실행 계획](../../engineering/provenance/DEV-017_REGISTRATION_RUN_PLAN.md)의 자동 경로는 PENDING/null 후보 PR만 생성한다. 이번 Owner 승인 사건은 수용·PM 전환·ACTIVE/RETIRED 결정이 이미 확인된 수동 INF 제출이며 해당 자동 workflow를 실행하지 않는다.

- 기존 ID/부서/세대/선행자/role/scope/kind 불변, 레거시 null 보존, record_version 정확히 +1, 신규 번호 0002·세대 연결·고유 ACTIVE scope·ISO 8601 효력을 검사한다.
- registry root 메타데이터는 전부 보존한다. 오래된 `registry_state=OWNER_APPROVED_PENDING_MAIN_MERGE`, 최초 `source_main_sha`와 승인 참조의 정리는 별도 후속이다. 이번 검토 SHA·승인·전환은 이 티켓으로 추적한다.
- 새 event schema/필드·validator 예외·ENFORCE·필수 체크 변경을 도입하지 않는다. 기존 일반 전환 비교는 `REGISTRY_TRANSITION_REVIEW_REQUIRED`를 반환한다. 신규 ACTIVE 역시 자동 PENDING-only 계약의 통과 대상이 아니다.
- 구조 검사 통과, 승인 내용 대조, 전환 진단, 필수 CI 성공을 구분한다. REPORT_ONLY job 성공은 자동 전환 승인·신원 인증·`DECLARATION_CONSISTENT`를 뜻하지 않는다.
- 제출 주체는 trusted base에서 ACTIVE인 `AGT-INF-0001`이며 신규 0002로 이 PR을 자기 인증하지 않는다. 승인 경로 밖 `_PROVENANCE.json` Manifest를 추가하지 않는다. 출처 검사가 첫 전환 진단 뒤에 진행되지 않으면 Manifest/후속 선언 전체 검증을 통과했다고 표현하지 않는다.

완료 조건은 승인 경로만의 diff·구조 및 정책 검증·일반 Commit/Push·PR·실제 head CI와 진단 보고다. main 반영·공식 DONE·Track B 등록은 이번 제출 완료 조건에 포함되지 않는다.
