# DSG-010 — Track A A-01 P01/P02 공공입찰·사업 계약 저충실도 설계

- 담당: Design / Art Director & UI/UX Designer / AGT-DSG-0001.
- 날짜: 2026-11-08 (Asia/Seoul). 상태: REVIEW / 정식 문서 제출, Owner 검수 대기.
- 별칭: A-01. DSG-006 Track B와 DSG-007~009 후속 예약을 보존하고 DSG-010을 사용한다.
- 기준 main: b48dd82a9b93d062d1a3bcfdf8750cb260c83e3e. 브랜치: codex/DSG-010-a01-tender-contract-lowfi, base=main.
- 범위 등급: 정보구조·문구·조작 L1, DEV 공급·실제 GUI 인수 L2. 신규 L3/게임 규칙 변경 없음.
- 연결: W04A, F-BID-001, AC-02·03·09, VP-02 관련 VS-01 부분, S2-02·03·08·11, F-03·10·11. 전체 VP/Stage 인수 아님.

## Owner 실행·Git 승인

2026-11-08 현재 A-01 이관 요청에서 Owner가 정식 등록, 승인 기준에 따른 디자인 문서·검수 계획 작성, 독립 브랜치 Commit/Push, PR 생성 및 필수 CI 확인을 직접 지시했다. 핵심 승인 문구는 “독립 브랜치 Commit/Push, PR 생성 및 필수 CI 확인까지 진행해 주세요”다. 이전 ArtDirector 대화의 A-01 v0.1은 설계 입력이며 실행 권한은 이번 직접 요청을 근거로 한다.

대상은 wisberry2022/MetroManager / DSG-010 / 아래 docs/design/ 산출물이다. 유효 범위는 이번 문서 제출 및 동일 범위 검수 대응까지. Git Data API의 단일 부모 commit과 expected_sha·force=false ref 갱신을 작업 브랜치 Push에 해당하는 공유 방식으로 사용한다. Issue 등록·PR 본문과 결과 추적은 이번 등록/제출 범위다. main merge/직접 쓰기, force push, 릴리스/배포, Godot 코드/씬·데이터·기획 원본·타 부서·정책/CI 변경은 제외한다.

작업 착수 승인은 최종 디자인 승인 또는 제품 ACCEPTED/DONE이 아니다. 승인된 기획 의미를 디자인 검수안 v0.1로 문서화하여 REVIEW에 제출한다.

## 승인 기준선

모든 링크는 위 main commit으로 고정한다. Blob SHA는 commit SHA와 구분한다.

| 원본 | Blob SHA |
| --- | --- |
| [PM-014_STAGE2_VS01_EXECUTION_PLAN.md](https://github.com/wisberry2022/MetroManager/blob/b48dd82a9b93d062d1a3bcfdf8750cb260c83e3e/docs/hq/PM-014_STAGE2_VS01_EXECUTION_PLAN.md) | 7a48171d379f14d58d92074507f9a65108d360d5 |
| [PLN-001-C.md](https://github.com/wisberry2022/MetroManager/blob/b48dd82a9b93d062d1a3bcfdf8750cb260c83e3e/docs/planning/PLN-001-C.md) | 44c671303573da4116336aa60288207bc8d7a0ef |
| [PLN-001-D.md](https://github.com/wisberry2022/MetroManager/blob/b48dd82a9b93d062d1a3bcfdf8750cb260c83e3e/docs/planning/PLN-001-D.md) | 95c9ecbaeab2ad9f4ee3d87b5100af7fab1970d1 |
| [PLN-001_GATE2_DATA_v1_DRAFT.md](https://github.com/wisberry2022/MetroManager/blob/b48dd82a9b93d062d1a3bcfdf8750cb260c83e3e/docs/planning/PLN-001_GATE2_DATA_v1_DRAFT.md) | 359408ee058bae3e350defb45e594df4ee5c78d9 |
| [DEV-006_UI_DATA_CONTRACT.md](https://github.com/wisberry2022/MetroManager/blob/b48dd82a9b93d062d1a3bcfdf8750cb260c83e3e/docs/engineering/gate3/DEV-006_UI_DATA_CONTRACT.md) | 1919586799d9a7e67cf0662063eac96b2b6b29ec |

- Gate 2 최종 승인: [OWNER_APPROVED 기록](../../planning/PLN-001_GATE2_FINAL_APPROVAL.md).
- UI 계약 v0.2.1: 의미 revision DEV006-UI-v0.2-decision-1, UI-DC-03·05·07.
- [Planning RFC-DEV-018-01 회신](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6716236853): PLANNING_L2_RULE_INPUT_CONFIRMED / NO_RULE_CHANGE_REQUIRED.
- [DEV SUP-01~08](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6716315597), [DEV-018 착수 회신](https://github.com/wisberry2022/MetroManager/issues/74#issuecomment-6716316170).
- [DEV-018 #74](https://github.com/wisberry2022/MetroManager/issues/74) 모델, [DEV-019 #75](https://github.com/wisberry2022/MetroManager/issues/75) 실제 UI(실행 승인 대기). 공급안과 실제 구현을 구분한다.
- AGENTS.md, DEPARTMENT_WORKFLOW, 디자인 README, CODE_CONVENTIONS, GIT_WORKFLOW, ENFORCEMENT, GITHUB_SUBMISSION을 main에서 직접 확인했다.
- 등록부의 AGT-DSG-0001은 기존 Design 역할의 출처 선언이다. Codex 이관을 새 Agent-ID 발급/후임 활성화나 기술적 신원 인증으로 해석하지 않는다.

## 포함·제외·산출물

포함: P01 목록/선택/빈 목록/조회 오류, P02 조건·자격·응찰·마감·판정·사업 계약/지급, 최신/당시 snapshot 구분, 텍스트 와이어프레임, 키보드·오류 복구, SUP 매핑, 12개 QA 계획과 증거 양식.

산출물:
- [저충실도 설계 v0.1](DSG-010_A01_P01_P02_DESIGN.md)
- [독립 검수 계획 v0.1](DSG-010_A01_QA_PLAN.md)
- [결과·한계](DSG-010_RESULT.md)
- 본 티켓 및 DSG-010_PROVENANCE.json

제외: W04B 정부 심사/설득·자체 제안, 공사/영업 UI 전체 제작, 고충실도/PNG/콘셉트 후보, 제품 해상도·폰트·FPS 확정, Godot 실행·실GUI 검수의 이번 실행, 새 규칙·API enum 확정. DSG-003/004의 공통 패턴·DSG-005 QA 방법은 재사용하되 원본은 보존한다.

## 수용 기준·담당·차단

1. P01/P02 각 정보·행동·상태를 SUP/UI-DC와 연결한다.
2. [360,1800)·야간 접수·T1800 신규 거부/기존 판정, 86:80/80:80, 현재/접수/판정 기록을 구분한다.
3. 고정 조건 읽기 전용, 중복/변경/역순 응답·없음/0/오류와 복구를 명시한다.
4. A01-Q01~12에 초기 상태·입력·기대·증거·담당·NOT_RUN을 기록한다.
5. 변경은 docs/design/의 일반 파일만, 단일 부모·메시지/티켓·manifest 검토 후 PR 두 필수 CI를 확인한다. CI 링크/head는 PR에 기록한다.

DEV-018은 실제 snapshot/명령/모델 fixture를, DEV-019는 GUI 소비/오류/입력을, DEV-020은 공사 계약 연결을 공급한다. Design은 문구·위계·조작 및 후속 독립 GUI 검수를 담당한다. 최초 차단은 DEV-019 실제 데이터 통합/해당 GUI 인수 전이며 독립 설계는 계속 가능하다. SUP-08은 부분 수용이다. Planning은 실제 의미 차이만, HQ는 통합·중대 충돌, Owner는 최종 수용/병합을 맡는다.

Agent-ID: AGT-DSG-0001
Task-ID: DSG-010
