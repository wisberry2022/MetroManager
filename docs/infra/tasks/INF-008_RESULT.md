# INF-008 — 제출 및 검증 결과

- 작업: INF-008 / 실제 작성·제출자: HQ `AGT-PM-0002` / 2026-11-14
- 상태: `OWNER_TRANSFER_APPROVED / OWNER_PR_SUBMISSION_APPROVED / MAIN_MERGE_PENDING / NOT_DONE`
- 기준 main: `4b3f73c5d8b87630cc96eb90f950761f79bb861b`
- 기준 registry blob: `884cf3efd03bacc0e7e5004b4897f2c251a0bb13`
- 브랜치: `codex/INF-008-infra-succession`
- [결정·작업 범위](INF-008_INFRA_SUCCESSION.md)

## 변경 결과

- AGT-INF-0001: RETIRED, retired_at=`2026-11-14T07:47:00+09:00`, record_version 1→2. activated_at=null 및 과거 identity·승인·근거 보존.
- AGT-INF-0002: 신규 ACTIVE, generation=2, predecessor=AGT-INF-0001, activated_at=`2026-11-14T07:47:00+09:00`, retired_at=null, record_version=1.
- 신규 session_kind=UNCONFIRMED. 확인되지 않은 기술적 세션 정보를 추정하지 않음.
- 총 13 ID / ACTIVE 8 / RETIRED 5 / PENDING 0. 다른 기존 11개 행·root·레거시 null·기존 문서 보존.
- 변경은 registry 및 INF-008 티켓·결과의 세 INF 파일뿐이다.

## 검증

제출 전 Owner 제한 폴더의 `validate_inf008.py`를 기존 `.venv/Scripts/python.exe`로 실행했다. 이 보조 검사는 위 고정 main의 `department_policy.py`, `agent_provenance.py`, `agent_registry.py`, `policy.py`를 Git 객체에서 읽어 메모리로 로드하고 제출 데이터에 적용했다. 코드·정책·원본 Git 상태는 변경하지 않았다. 보조 검사기는 제출 세 파일에 포함하지 않는다.

실제 원격 PR head·부모·경로·필수 CI·출처 결과는 PR 본문에 연결한다.

| 항목 | 결과 |
| --- | --- |
| 로컬 tools/policy.py doctor | PASS — 기존 checkout의 훅·도구 확인. 제출 snapshot/원격 승인 인증 아님 |
| 제출 데이터·명세 대조 | PASS — 13개 ID/ACTIVE 8/RETIRED 5, 양쪽 명시 효력, 계보·버전·기존 11개 행/root/legacy null 보존, 정확한 세 경로·UTF-8/LF·참조/앵커 |
| 실제 base 코드의 구조·부서 검사 | PASS — registry.validate, 부서의 branch/message/path/ticket 및 policy.file_check. 신원·위임 인증 또는 전체 출처 PASS 아님 |
| 실제 base registry.compare | DIAGNOSTICS — REGISTRY_TRANSITION_REVIEW_REQUIRED. PASS로 변경하지 않음 |
| 실제 작성자 PM/업무 INF의 별도 agent_check | DIAGNOSTICS — AGENT_DEPARTMENT. Owner 사건 한정 제출 지시와 현행 일반 검사 계약의 차이를 공개 |
| 로컬 commit/push hooks·preflight | NOT_RUN — GitHub API 제출 |
| 원격 policy·department-policy | PR 생성 후 실제 head 확인 |
| 원격 provenance | REPORT_ONLY 실제 진단 확인 예정. 구조/CI 성공과 구분 |
| 게임 자동검사·Godot 로드·플레이·GUI·빌드·성능 | NOT_RUN — 등록부·문서 작업 |
| QA 원본·접근·백업 복구 | NOT_VERIFIED / 복구 NOT_RUN |
| 자동 등록 workflow_dispatch·main 병합·릴리스 | NOT_RUN |

## 진단·후속 의무

- 승인된 lifecycle 전환의 REGISTRY_TRANSITION_REVIEW_REQUIRED 및 실제 작성자 PM/업무 INF 선언의 AGENT_DEPARTMENT는 현행 출처 계약 한계다. 정상 검사로 우회하거나 INF ID를 대신 기입하지 않는다.
- 출처가 첫 registry_delta 진단에서 멈추면 뒤 선언·Manifest 검사는 통과한 것이 아니다. REPORT_ONLY와 세 false 플래그를 유지한다.
- 신규 ID는 이번 등록의 제출 주체가 아니며, 현직 INF ID도 재사용하지 않는다. Owner가 직접 지정한 HQ 제출 사실을 공개한다.
- root 정리·general lifecycle/event·ENFORCE·DEV-017 실운영·F-11/F-12는 기존 의무로 남는다.
- 기존 두 필수 CI의 실패를 무시하지 않는다. 실제 head 결과 확인 후 검수 요청하며 main 병합은 Owner 별도 승인 대상이다.
- 후임의 향후 개별 Git 권한은 자동 승계하지 않는다. 게임 명세 변경 필요: 없음.
