# PLN-001 Gate 2 변경·결정 요청 요약

- 작성일: 2026-10-31
- 제공본: **PLN-001-C.md v0.2-draft**, **PLN-001-D.md v0.5-draft**
- 상태: Owner 검토용 수정 초안 완료. Gate 2 승인 PENDING / 최종 승인 상정 BLOCKED.

## 수정 기준

Downloads 실제 검토 ZIP의 C v0.1·D v0.4-draft만 수정 출발점으로 사용했다. 개발·디자인·HQ 원본 회신과 로컬 Gate 1 A/B v0.3·Owner QD/P 원문을 직접 대조했다. 별도 PLN-001-Gate2-DRAFT는 입력으로 사용하지 않았다. SOURCE_MANIFEST.json에 경로/해시를 기록했다. 원본 파일은 모두 보존했으며 원격 최신 상태는 재확인하지 않았다.

## 주요 변경

| 위치 | 변경·이유 |
| --- | --- |
| C §2·5-3 | 시간 의존성, 행정 부모·관할·후보역 순서/중복/단절 규칙 보강 |
| C §5-4 | 입찰·정부 심사·설득·동일 사업·신규 사실·실패 후 행동과 중복 처리 추천안 |
| C §5-5 | 정부 사업비 지급·기성 집행·잔액 제한·초과/부족, 총현금/제한자금/자유자금/약정/가용액 및 검산 예시 |
| C §5-6 | 자정 동시 사건·부분 영업일·시범운행/안전검증 실패와 재시험 추천안 |
| C §5-7·8 | 수요→OD 이동시간→탑승→운임/만족도 최소 계산·난수 재현 및 집계+열차+승하차 추천 |
| C §5-9·6 | 저장/파산 SHOULD 검토, 시간/거래 작업 선행, AC-01~10 정상/실패/경계/중복/재현과 독립 VP-01·VP-02 보강 |
| C §7~10 / D 전체 | 회신 접수와 재검수/승인 분리, 추천/대안/영향·블로커 해소 증거·견적 한계·완료 조건 갱신 |

## Owner 결정 요청

1. **P0 — G2-Q01·04·05·06:** 쉬움 시철 MVP 기준, 심사/입찰 및 음수 사업성·동일 사업·신규 사실, 시간 경계, 사업비 지급/집행·잔액·초과/부족 정책. 최우선은 DEV-R05 BLOCKER인 Q06.
2. **P1 — G2-Q02·03·05·07·08:** 콘텐츠/후보역 자유도, 수요·운임·만족도 변수, 저장/파산 포함 범위·음수 운영비, 집계+열차/승하차 최소 표현 및 성능 기준.
3. **P2:** 결정 반영→부서 재검토→HQ 통합→Owner Gate 2 최종 승인. 질문별 선택지·추천·영향은 D §3, 구체 규칙은 C §5 참조.

쉬움 시청 수익성 0 통과는 보존하고 음수는 미확인으로 남겼다. 사업비 회사 매출/현금 원칙을 보존하되 잔액 자동 자유 사용은 허용하지 않았다. 파산 기간/지원 횟수·인피니트 기본 OFF·시청 최초 포함 제출 횟수 등 이미 승인된 사항은 재결정 대상으로 올리지 않았다. 문서의 계산식·새 정책·예시 수치는 승인 대기이며 문서 수정 승인만으로 확정하지 않았다.

## 검증 및 상태

- 정적 검사 통과: C 필수 10장, D 필수 7장; ZIP와 같은 MUST 11개, AC-01~10, G2-Q01~08, BLOCK-G2-01~07, VP-01·VP-02 유지.
- ZIP의 8개 영역 목록 및 SHOULD/WON’T 본문 보존 확인. 원본 ZIP·회신·Gate 1 파일 해시 불변 확인.
- Development/Design 회신 RECEIVED·CONDITIONAL, HQ 1차 RECEIVED·CONDITIONAL. 수정본 부서 재검토/HQ 통합/Owner 승인 PENDING. 블로커 7개 OPEN.
- 문서 검산은 구현 테스트가 아니다. Godot·플레이·빌드·게임 테스트 NOT_RUN. 성능·사용성 및 확정 일정 보장 없음.
- Git 명령·설정·인덱스 변경·commit/push/PR/merge 일절 수행하지 않았다. 외부 부서 발송도 수행하지 않았다.

## 원격 제출 작업 기록 (후속 요청)

- 작업 ID / 담당 / 상태: PLN-001 / Planning / REVIEW.
- 승인자: Owner. 원문 위치: 현재 Codex 채팅 2026-10-31 후속 사용자 메시지.
- 승인 원문: “그럼 현재까지 수정된 PLN-001-C/D와 변경/Owner 결정 요청 요약을 원격 git 레포지토리에 PR로 생성해줘”.
- 대상 저장소: wisberry2022/MetroManager. 브랜치: `codex/PLN-001-gate2-review`. base: `main`.
- 허용 범위·종료: C/D와 본 변경 요약의 작업 브랜치 commit·push 및 PR 생성·검사 확인까지. main 직접 변경·병합·릴리스는 포함하지 않는다.
- 근거: docs/hq/tasks/PLN-001.md 및 현재 Owner 요청. 선행 Gate 1 A/B v0.3, 기준 main `d48507169e747c3d66c384f8dda4e145a4778e91`.
- 산출물/포함 범위: `docs/planning/PLN-001-C.md` v0.2-draft, `docs/planning/PLN-001-D.md` v0.5-draft, `docs/planning/tasks/PLN-001_GATE2_RESULT.md`.
- 제외 범위: A/B·Owner 결정 원문·타 부서·게임 소스·정책/CI 수정, 새로운 게임 규칙 확정.
- 수용 기준: 세 문서만 변경, 필수 장·식별자·미승인 상태 보존, base main PR 생성, policy/department-policy 확인.
- 기존 Gate 1 D v0.3은 기준 커밋의 [원본](https://github.com/wisberry2022/MetroManager/blob/d48507169e747c3d66c384f8dda4e145a4778e91/docs/planning/PLN-001-D.md)으로 보존된다.
- 제출 검증: UTF-8/BOM 없음·LF·마지막 개행 및 C 10장/D 7장·11 MUST·10 AC·8 질문·7 블로커·두 VP 확인. 원격 파일 비교와 CI 결과는 PR에 기록한다.
- 로컬 policy.py doctor/check 및 로컬 Git 훅: NOT_RUN (로컬 저장소 없이 DEPARTMENT_WORKFLOW의 GitHub API 제출 절차 사용). API 제출은 로컬 훅을 실행하지 않으므로 원격 policy/department-policy 결과를 별도로 확인한다.
- Godot 로드/게임 테스트/플레이/Windows 빌드: NOT_RUN, 문서 전용 제출.
- 앞 절의 Git 미실행 기록은 로컬 수정 당시 이력이며 이번 후속 제출 상태와 구분한다. PR 생성/CI 통과로 Gate 2 승인 또는 DONE 처리하지 않는다.

### 기준 자료 SHA-256

| 자료 | SHA-256 |
| --- | --- |
| MetroManager_Gate2_Review_Package_v0.1.zip | `bbc3d74e978893e76e6420937d699da9cc84df2dbf78df8bc1b6ce342d1c7853` |
| PLN-001_GATE2_DEV_RESPONSE.md | `27cb0f025f4ad11b819533c1affa32a4562664586713685489de9606b9caf2b8` |
| PLN-001_GATE2_DESIGN_RESPONSE.md | `9680b226819c3d529b286971a03f1a747a4b6486dfe43e9cc09d9164bc913472` |
| PLN-001_GATE2_HQ_REVIEW.md | `30d4e88379efea4a6073636e318e6f836097bca7affc1dac4591e3574d1f94a8` |
| PLN-001-A.md | `261712e0dd28eabdb12567c6aafc188b1f999fbf0b51e6c640cc80da59d0c9fc` |
| PLN-001-B.md | `5fe6338041b7f0b6f76ef148af4bfa4401e2c022baaf3257f619005f4561d193` |
| PLN-001_OWNER_DECISIONS.md | `175ee7b3b9e71836b8e3652f0c9fc4e92b326e674b53e6c547be2f8ccfedd898` |
| MetroManager_Gate2_Review_Package_v0.1/sources/PLN-001-C.md | `903e7e4178768161b2782ccdfaf449a62c388fcdd7f9d593a0bb77116ecf4818` |
| MetroManager_Gate2_Review_Package_v0.1/sources/PLN-001-D.md | `bb2c8ee3b7afdd61c0903e2b8464efc41942654c9dd08ad974c7360201878c8f` |
