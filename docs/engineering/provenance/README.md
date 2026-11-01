# Agent Provenance — DEV-013 실험·설계 진입점

- 상태: DESIGN_PROPOSAL / REPORT_ONLY 시제품. 운영 정책·실제 에이전트 등록부·필수 CI가 아니다.
- [구현 계획·R&R·AC 추적](DEV-013_IMPLEMENTATION_PLAN.md)
- [INF/Owner 정책 결정 RFC](RFC-DEV-013-01_POLICY_DECISIONS.md)
- [티켓](../tasks/DEV-013_AGENT_PROVENANCE_FOUNDATION.md) / [검증 결과](../tasks/DEV-013_RESULT.md)

## 현재 사용할 수 있는 범위

독립 `tools/agent_provenance.py`는 기존 부서 검사 후 pinned base의 등록부와 각 커밋의 Trailer/Manifest를 읽는다. fixture는 모두 미발급 synthetic ID이며 실제 INF 데이터를 만들지 않는다. base에 registry가 없으면 REGISTRY_NOT_CONFIGURED 진단이다.

인수·활성화 이력, 승인 참조 진위, historical contributor/created_by·은퇴 예외, 실제 source_refs 승인, 정식 CI/훅/생성기·squash 보존은 아직 완성되지 않았다. 운영 게이트로 호출하지 않는다. 경고가 없다는 사실도 신원 인증/승인/품질 검증을 뜻하지 않는다.

## 로컬 실행 후보

PowerShell 예시의 변수는 검토자가 확인한 full SHA와 파일로 채운다. 아래 명령은 네트워크·Git 쓰기를 하지 않는다. PR 본문은 공개 Git 파일로 저장하지 말고 필요 시 로컬 제외 경로에 둔다.

```powershell
.venv/Scripts/python.exe tools/agent_provenance.py `
  --base $trustedBaseSha --head $reviewHeadSha `
  --task $reviewTaskId --branch $reviewBranch --title $reviewTitle `
  --pr-body-file $localPrBodyPath `
  --registry docs/infra/agents/registry.json `
  --manifest $reviewManifestPath
```

출력은 mode=REPORT_ONLY, result=DIAGNOSTICS 또는 DECLARATION_CONSISTENT, 정해진 diagnostics 코드와 identity_authenticated=false다. 진단이 있어도 exit0이며 기존 정책 검사를 대신하지 않는다. code0만 보고 PASS로 처리하지 않는다. --enforce 옵션은 없다.

```powershell
.venv/Scripts/python.exe -m unittest discover -s tests/tooling -v
.venv/Scripts/python.exe tools/policy.py check
```

## GitHub API·후속 적용

현재 로컬 시제품은 GitHub API를 직접 호출하거나 webhook을 설치하지 않는다. GitHub 파일에 헤더를 넣거나 PR 본문을 자동 수정하지 않는다. 후속 승인된 단계에서는 검증된 base 코드가 GitHub event JSON의 제목/본문과 fetched Git objects를 데이터로 읽는 독립 CI adapter를 구성한다. 커넥터 쓰기에는 기존 branch/expected SHA/Owner 권한 확인을 그대로 적용한다.

실제 INF 등록부 main 반영→승인 스키마 전체 구현→REPORT_ONLY 원격 시범→Owner 전환 SHA/legacy 예외 승인→새 필수 CI 등록 순서다. 지금은 기존 PR과 Project Leader B의 구현을 새 출처 정보 누락으로 차단하지 않는다.
