# INF-006 — Planning 3세대 후임 Agent-ID PENDING 등록 검토

- 소관: INF / 제안 작성 주체 `AGT-INF-0001`
- 작성: 2026-11-08 / Asia/Seoul
- 상태: `OWNER_PR_PREPARATION_AUTHORIZED / INF_ACCEPTANCE_VERIFIED / HQ_PM_SWITCH_CONFIRMED / OWNER_FINAL_APPOINTMENT_PENDING / NOT_ACTIVE`
- 저장소: `wisberry2022/MetroManager`
- 기준 main: `7735ccff22952dabdf1371c2b29d81b620f4a9c0`
- 기준 등록부 blob: `8382d273d9723ba7e4771926f3aeb2eb278a91f0`
- 브랜치: `codex/INF-006-agent-registration`
- 공개 등록부: [registry.json](../agents/registry.json)

<a id="candidate-preparation"></a>
## 1. Owner 요청과 이번 제출의 제한

Owner는 MetroManager Planning의 정식 세대교체 절차를 요청했고, 기존 `AGT-PLN-0002`가 제출한 자기보고·4계층 인계서 및 후임 후보의 T1~T10 답변을 INF가 독립 검토했다. Owner는 HQ의 전환 확인 문서를 INF에 전달하고 **“확인하여 이상 없을 시 PR 생성해주세요”**라고 이번 INF 등록 검토·PR 제출을 요청했다.

**이 요청은 실제 후임 임명·`ACTIVE` 활성화 승인 또는 기존 담당 `RETIRED` 변경 승인이 아니다.** HQ 회신도 `OWNER_TRANSFER_PENDING`임을 명시한다. 따라서 본 PR은 신규 `AGT-PLN-0003` **PENDING 제안만 제출**한다. 이 PR 자체가 정식 ID 발급·예약·권한 부여 또는 `main` 병합이 아니다.

현재 승인된 원격 Git 동작은 이 INF-006 제안의 두 INF 파일 작성·단일 부모 Commit·작업 브랜치 생성·PR 제출 및 같은 범위 검수 대응에 한정한다. 게임 규칙/Planning 산출물/PM·DEV·Design 경로·CI/정책/도구 수정, 자동 Merge, force push, 릴리스는 제외한다.

<a id="inf-acceptance"></a>
## 2. 후임 인수 및 HQ 전환 확인

- 현직 `AGT-PLN-0002`의 제한용 자기보고·4계층 인계서를 INF가 검토하여 인계 패키지를 수용했다.
- 후임 후보 T1~T10은 INF 독립 평가로 `SUCCESSOR_ACCEPTANCE_VERIFIED`를 받았다. 별도 점수·비공개 세션 원문은 Owner 제한 보관하고 공개 Git에 게시하지 않는다.
- HQ 담당 `AGT-PM-0002`는 기존 Planning의 Gate 2·Stage 2 W04A/W05/W06 의미 검토·PLN-004 POST-MVP 후속 기획을 신규 후보가 이어받을 범위로 확인했다. 다른 부서의 전문 판단과 Owner 승인권은 승계하지 않는다.
- HQ 회신 상태는 `PLANNING_HANDOFF_ACCEPTED / SUCCESSOR_ACCEPTANCE_VERIFIED / PM_SWITCH_CONFIRMED / OWNER_TRANSFER_PENDING`이다.
- HQ는 Owner가 **2026-11-08 18:49 KST**를 양쪽 담당 전환 시각으로 지정했다고 보고했다. 확인된 시각 표현은 `2026-11-08T18:49:00+09:00`이다. 이 값은 **후속 Owner 활성화 승인이 내려질 때 사용할 공식 전환 기준**으로만 보존한다. 이번 PENDING 레코드의 `activated_at`이나 기존 행의 `retired_at`에 미리 쓰지 않는다.
- HQ 회신의 Owner 직접 발언 원문 URL은 제공되지 않았다. 이 문서는 제한 전달 확인의 공개 운영 요약이며 GitHub 계정·문자열로 실제 Owner/세션 신원을 기술적으로 인증하지 않는다.

## 3. PENDING 등록 제안의 정확한 범위

| 필드 | 제안 값 |
| --- | --- |
| `agent_id` | `AGT-PLN-0003` |
| `status` | `PENDING` |
| `department` | `PLN` |
| `generation` | 3 |
| `predecessor_agent_id` | `AGT-PLN-0002` |
| `session_kind` | `UNCONFIRMED` (최종 Owner 역할 지정 시 확인) |
| `activated_at` / `retired_at` | `null` / `null` |
| `record_version` | 1 |

이번 변경에서 현직 `AGT-PLN-0002`는 **ACTIVE 그대로 유지**한다. 나머지 10개 기존 등록부 행과 전체 root 메타데이터는 바꾸지 않는다. `main`에 PENDING 상태가 병합되기 전에는 ID 발급·예약이 공식 확정되지 않는다.

### 권한 및 후속 기획 경계

- 기존 Planning의 과거 PLN-002·003·004 작업별 Git 권한은 후임에게 자동 승계되지 않는다.
- 최신 Owner 결정 R01~03은 이미 확정됐으며, PLN-001-C·DATA v1.3 공식 문서 개정과 DEV-020/021 GUI 의미·표현 정합화는 후속 책임이다. 이번 등록 PR은 기획 원본을 수정하지 않는다.
- PLN-004 POST-MVP 회사 내부 상태값 v0.7과 FIN-01~07의 승인 내용은 유지하되 현재 MVP에 자동 구현하지 않는다.
- DEV·Design 자동검사/실 GUI/독립 인수 및 Stage 2 DONE을 이 등록으로 새로 선언하지 않는다.

## 4. Owner 최종 전환 전 필수 확인

1. Owner가 **후임 `AGT-PLN-0003`의 정식 임명·ACTIVE 등록 및 기존 `AGT-PLN-0002` RETIRED 전환**을 명시 승인한다.
2. Owner가 HQ 보고된 양쪽 `2026-11-08T18:49:00+09:00` 효력을 최종 활성화 결정에 적용할지 명시 확인한다. 다른 시각을 선택하면 해당 값을 정확히 기록한다.
3. INF가 새 승인 근거를 확인하고, 등록부 변경본과 record_version·구 효력 시각 null 보존·범위·고유 ID를 재검토한다. `PENDING→ACTIVE`와 `ACTIVE→RETIRED`는 현 DEV-017 계약에서 자동 통과가 아닌 별도 수동 검토 대상이다.
4. 해당 변경의 Git Commit·Push·PR 수정 승인 범위 및 필수 `policy`·`department-policy` 검증, 출처 REPORT_ONLY 진단을 확인한다.
5. **Owner가 별도로 `main` 병합을 승인하기 전에는 실제 등록부 활성화 또는 역할 권한 승계를 선언하지 않는다.**

## 5. 검사·미실행

- GitHub 공식 main·현재 등록부·열린 PR·동일 브랜치 확인, 신규 ID 0003의 사용 여부·계보·현직 ACTIVE 상태를 대조했다.
- Git Data API 제출 전 JSON 파싱 및 기존 기록 전부 불변·root 불변·PENDING 활성화 시각 null을 구조 점검한다.
- GitHub API는 로컬 Git hooks, `doctor/check/preflight`, Game/Godot GUI·빌드/성능 검사를 실행하지 않는다: `NOT_RUN`.
- 제출 head의 두 필수 원격 CI는 PR 생성 후 별도 확인한다. `agent-provenance-report`는 REPORT_ONLY이며 신원 인증·Owner 승인 인증이 아니다.
- PR은 Draft 검토용이며 이번 제출 범위 밖의 등록부 활성화/상태 전환·CI/도구 정책 변경을 수행하지 않는다.

**현재 판단:** `INF006_PENDING_PR_PROPOSED / OWNER_FINAL_TRANSFER_PENDING / NO_AUTHORITY_TRANSFER`.
