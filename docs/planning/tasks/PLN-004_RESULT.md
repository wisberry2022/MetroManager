# PLN-004 — POST-MVP 회사 내부 상태값 인계 문서 제출 결과

- **담당:** Planning / 현행 후임 Game Designer
- **작업:** PLN-004 / 2026-11-08
- **상태:** `REVIEW / OWNER_PR_MERGE_APPROVAL_PENDING / POST_MVP_IMPLEMENTATION_NOT_STARTED`
- **근거:** Owner가 2026-11-08 현재 대화에서 회사 내부 상태값 정의의 후임 인계 및 **별도 PR** 제출을 명시 요청.
- **기준 main:** `98d56eb97f8a030912bea534ff1c330e9c40188e`.
- **브랜치:** `codex/PLN-004-post-mvp-company-states`.

## 변경 결과

| 파일 | 목적 |
|---|---|
| [PLN-004_POST_MVP_COMPANY_STATE_V0_7.md](../PLN-004_POST_MVP_COMPANY_STATE_V0_7.md) | 7개 카테고리/21개 하위, 재정6개 말단 및 FIN-01~07의 Owner 승인 기준·산식·미승인 예외의 정본 인계 |
| [PLN-004_COMPANY_STATE_HANDOFF.md](PLN-004_COMPANY_STATE_HANDOFF.md) | Owner 요청·범위·역할·수용/후속·권한 경계 |
| 본 결과서 | 제출 범위·검증·NOT_RUN 상태 |

- 원래 승인된 Gate 2 C/D/DATA를 수정하지 않았다.
- W04A/W05/W06·원장/게임 시간·입찰 점수/승객 만족도에 새 효과를 적용하지 않았다.
- 다른 부서 경로, 공통 정책·CI·도구, 실제 게임 코드·에셋은 변경하지 않았다.

## 승인·미결정 추적

**Owner 확정:** 7/21 최초 계층, depth/자식 수 무제한, 정확한 내부 숫자 비공개, 0~10 소수, 5.0·미관측 분리, 난이도별 차등 초기값 방향, 평가형5/규모형2, 기관 규모/호감 구별, 재정6개, FIN-01~06 초기 평가 기준선 및 FIN-07 미래 상세 산식 이월.

**후속 미승인:** 현재 MVP에 0~10 점수 즉시 연결, 직간접 이벤트 보너스·기관 혜택·입찰 확률/자격 변경, 부족한 관측 기간의 데이터 유지/리밸런싱, 기준 투자비 M·정밀도, FIN-07 채무 산식, 다음 6개 영역 상세 평가, 진짜 게임 테스트/GUI.

## 검증 수준

- 승인/미결정 명세: 기존 Owner 대화 및 현행 Gate 2 문서의 의미를 정적 대조.
- 문서 형식·경로·Markdown 상대 링크: 제출 전 텍스트 점검(검증 결과는 PR 설명에 명시).
- 원격 Commit/부모/변경 파일/두 필수 CI: 실제 PR 생성 이후 확인하여 PR 설명 또는 검수 회신에 기록.
- 로컬 hooks/doctor/check/preflight: **NOT_RUN** (GitHub 플러그인/API 제출이며 로컬 실행 환경 사용 안 함). CI 성공으로 로컬 hooks 실행을 주장하지 않음.
- Godot 자동/프로젝트 로드·제품 GUI·Windows 빌드·성능/사용성·회사 점수 실제 계산: **NOT_RUN** (문서-only).
- 후임 교체/새 Agent-ID 등록: **NOT_RUN** (INF/HQ/Owner 별도).

## 인수·권한

이번 제출은 **후임 읽기용 공식 기획 기준 문서의 PR 검수 요청**이며, 승인된 상태값의 실제 구현·배포/Stage 완료 또는 후임 Planning의 권한 자동 승계를 뜻하지 않는다.

`main` 병합·릴리스/실제 구현 및 FIN 외 후속 상세 수치 승인은 Owner/담당 부서의 별도 결정으로 진행한다.
