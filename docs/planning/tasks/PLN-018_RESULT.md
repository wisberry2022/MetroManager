# PLN-018 결과 조직 결속도 1차 기준선 회사 설계서 통합

- 담당: Planning / 기록일: 2026-11-22 (Asia/Seoul)
- 상태: OWNER_DOCUMENT_PR_REQUESTED / REVIEW / IMPLEMENTATION_NOT_AUTHORIZED
- 작업: [PLN-018 티켓](PLN-018_ORGANIZATIONAL_COHESION.md)
- 제출 base: main `1a24e3346d0ec46ca692fe54d5de5656913c3450`
- 제출 브랜치: `codex/PLN-018-organizational-cohesion-design`
- 기존 회사 문서: v0.17 / blob `b8e4d130f893712c55e6b6ecd2438ea7b40c93f5`

## 변경 결과

[회사 내부 상태값 설계서](../PLN-004_POST_MVP_COMPANY_STATE_V0_7.md)를 v0.18로 갱신하고 조직 결속도 1차 기준선 v1.0을 §91~99에 통합했다. 평가 E 8개·실제 기준 C 8개·적용/승계 M 8개·정보 전달 I 5개, 총 29개 정책과 관련 세칙을 유지한다. 현재 1차 정책 미결 0개, 별도 콘텐츠/조건부 기획, 개발 확인 18개·디자인 확인 10개·검증 기대 사례 152개를 구분했다.

회사 설계서의 현재 미결 표와 대내적 평판/직원 만족도/경영진 신뢰도 절에 남아 있던 조직 결속도 후속 표기를 이번 승인과 연결했다. 기존 정책 본문과 과거 개정 기록은 보존했다. 내부 점수·산식·가중·정밀 기여도·단계 안 변화·점수용 진행률의 비공개는 모든 플레이어 경로에 유지한다.

[채택 당시 통합본](../PLN-018_ORGANIZATIONAL_COHESION_BASELINE.md)에는 제출 연결 배너만 추가했다. [평가](../PLN-018_ORGANIZATIONAL_COHESION_EVALUATION_PROPOSAL.md)·[실제 기준](../PLN-018_ORGANIZATIONAL_COHESION_CRITERIA_PROPOSAL.md)·[승계](../PLN-018_ORGANIZATIONAL_COHESION_MIGRATION_PROPOSAL.md)·[표시](../PLN-018_ORGANIZATIONAL_COHESION_INFORMATION_PROPOSAL.md) 네 원문은 채택 배너를 포함해 원래 로컬 승인본과 동일하게 제출한다. 원래 로컬 7파일은 수정하지 않는다.

제출 대상은 회사 설계서 1개, 기준선/원문 5개, 티켓/결과 2개, 총 8개다. Gate 2 C/D/DATA·기존 E01 PLN-016·경영진 신뢰도 PLN-017·아이디어·게임 소스·타 부서 산출물·공통 도구/CI는 변경하지 않는다.

## 검증 기록

문서 정적 검사와 로컬 저장소 정책 검사는 PASS다. 대표 시간·단계 예시는 승인 원문과 함께 보존하며 제품 실행 시험과 구분한다.

| 검사 | 실제 결과와 범위 |
|---|---|
| 원격/로컬 기준 | main 1a24e334와 회사 v0.17 blob 확인. 게시 직전 PR #172의 개발 문서 7파일 진전을 포함해 로컬 작업 브랜치를 fast-forward했으며 기획/정책 변경은 없음 |
| 기존 회사 정책 | 84개 절 전체와 직원 만족도 §74.2~74.8 불변 확인. 나머지 기존 변경은 허용한 상태/참조/개정 이력만 |
| 채택 원문·원래 자료 | 원래 로컬 7파일 불변, 네 제출 원문 전체 동일, 기준선은 제출 연결 배너 제외 본문 동일 PASS |
| 통합 문서·링크·추적 | 기획 8파일·회사 §1~99·승인 29개·개발 18/디자인 10·기대 사례 152개·상대 링크 113개·표 223개·UTF-8/LF·개인 경로 미포함 PASS |
| 로컬 정책 | doctor PASS, 최신 base에서 policy check PASS(files=791, GDScript=65), git diff --check PASS. 최초 staged snapshot 검사 PASS(790파일), 이후 main 문서 진전과 제출 메타데이터 변경의 경로/티켓/메시지를 다시 확인 |
| 제출 검사 | API 게시 이후 실제 부모/tree/경로·원격 CI·커밋 후 preflight를 PR 설명에 기록 |

로컬 보조 검증은 승인 ID 29개·개발 18개/디자인 10개·원문 사례 36+36+40+40, 회사 §1~99, 상대 링크/표·UTF-8/LF·개인 경로 미포함을 확인한다. 기존 회사 본문은 허용된 상태/이력 수정만 역변환한 결과가 base와 일치하는지 확인한다. 원래 로컬 7파일의 SHA-256과 제출용 기준선의 배너 제외 본문, 네 원문의 전체 파일 일치를 대조한다.

상세 원문 해시와 제출 파일별 SHA-256/Git blob, 기존 문서 보존 증거는 로컬 보조 검증 기록 `MetroManager_Organizational_Cohesion_PR_Validation_20261122.json`으로 보관한다. 개인 경로·보조 스크립트·가상 환경은 제출하지 않는다. 실제 검증 결과와 커밋/PR 링크는 PR 설명 및 OWNER 회신에 기록한다.

## 원격 제출과 권한 경계

OWNER가 이번 작업의 원격 기존 설계서 반영·PR 생성을 직접 요청했다. 최신 main에 대한 단일 부모 commit, 기존 base tree 보존, 명시 작업 브랜치·expected head·force=false로 게시하고 draft PR을 생성한다. 이 과정이 로컬 commit/push 훅을 실행했다고 주장하지 않는다. 실제 head의 policy·department-policy와 provenance 진단, 로컬 preflight 결과는 게시 후 확인하여 PR에 기록한다.

현재 세션의 Agent-ID는 미확인으로 유지하며 다른 담당자 ID나 가짜 Manifest를 사용하지 않는다. main이 진전하면 실제 base/head와 영향 범위를 재확인한다. 같은 브랜치의 다른 변경을 덮어쓰거나 강제 push하지 않는다.

## 후속과 미실행

| 구분 | 현재 상태 |
|---|---|
| 조직 결속도 1차 정책 | 29개 채택·통합 완료, 이 범위의 추가 결정 0개 |
| 별도 콘텐츠 기획 | 실제 직원·직무·자격/권한·작업시간·고용/배치·근무/휴식, 실제 공동 준비·담당 교대·지원 업무의 최소 도입 범위 |
| 조건부 기획 | 같은 의미로 승계 불가한 책임/자료, 새 협력 유형·평가 기준의 실질 개정·새로운 회사 효과 필요 시 별도 상세안 |
| 부서 확인 | 개발 18개·디자인 10개 준비만. 자료 공급·화면 검증 미확인, 요청 NOT_SENT |
| 검증 기대 사례 | 총 152개. 실제 테스트 152개 통과 기록이 아님 |
| 제품 실행 | 자동 게임 테스트·Godot 로드·플레이·세이브 전환/복원·UI/접근성·성능·밸런스·빌드·독립 검수 NOT_RUN — 문서 통합 작업 |
| 금지/보류 동작 | 개발/디자인 메시지·리뷰어 지정·검토/착수 요청 NOT_SENT. main 직접 쓰기/병합·auto-merge·릴리스/배포 NOT_PERFORMED |

문서 통합과 PR 제출은 실제 콘텐츠 공급·개발/디자인 인수·공식 DONE을 뜻하지 않는다.
