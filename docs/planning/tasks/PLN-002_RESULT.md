# PLN-002 — Gate 3-1 기획 결과·첫 Stage 인계

- Planning / 2026-11-01 / v1.0 / REVIEW.
- 기준 main: `177c2e4af3e15e15b15888c40eecb0f3ea983213` (DEV PR #33 병합; 최초 조회는 HQ PR #32의 b1a8a1f981d066fce6f5ca516e821e4ff018daf8); [티켓·이번 권한](PLN-002_GATE3_1_PLANNING.md), [Issue #26](https://github.com/wisberry2022/MetroManager/issues/26).
- **PLANNING_READY / NO_RULE_CHANGE_REQUIRED / NO_NEW_L3_REQUEST.** 문서 정적 대조 결과이며 Stage 실행·게임 인수·DONE 판정이 아니다.

## 1. PR 작성 전 의존성·Owner 판단 감사

| 직접 확인 근거 | 현재 상태·기획 영향 | 분류·필요 시점 |
| --- | --- | --- |
| [DEV PR #33](https://github.com/wisberry2022/MetroManager/pull/33), head `ea9d107e818c149c036c2dcaf77e548ce46fb2ae`, base `b1a8a1f981d066fce6f5ca516e821e4ff018daf8` | 최초 조회 OPEN → 제출 전 **MERGED** / merge `177c2e4af3e15e15b15888c40eecb0f3ea983213` / 문서7개. patch 직접 대조: W01→W02/W03→최소 UI, UI 계약 v0.2.1 표·검토 상태 정정. §1·3~7의 공급 의미와 기존 SEM/CLOSE 유지. 해당 head의 policy/department-policy success 직접 확인 | 최신 main에 반영된 v0.2.1로 참조. 기존 v0.2 의미 revision 유지; 승인 기획/공통 정책 변경 없음 |
| [DSG → DEV 수용 #25](https://github.com/wisberry2022/MetroManager/issues/25#issuecomment-6555800425) / [DEV → DSG 확인 #24](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6555812161) | DSG_SCOPE_ACCEPTED / DEV_STAGE_UI_BOUNDARY_CONFIRMED. 전용 메뉴 불필요, 장부 읽기 전용과 실제 정지/배속 조작, 지도/목록·최소 예측, 실제 공급 시점 호환 | 기존 L2 계획 의미. DSG 수용은 DEV #24 답변보다 먼저 게시되었으므로 나중의 재수용이라고 주장하지 않음. 현재 추가 규칙 질문 없음 |
| [DSG의 Owner 결정 기록 #24](https://github.com/wisberry2022/MetroManager/issues/24#issuecomment-6555874135) | “최소한의 실제 조작 UI”와 “자동 검증 및 화면 조작 결과” 종료 조건에 Owner “동의합니다” 기록. **이 요청은 결정 대기 아님**. 자동 규칙/회귀 및 실제 입력·표시/오류 복구 증거를 기획 인수 입력에 연결 | Stage 범위/증거 선택. 기획 규칙 변경 없음. 개별 실행/Git·merge 승인으로 확대하지 않음 |
| #24에 남은 PC/뷰포트·폰트·배율·FPS/연출 상한 | Dev+DSG 대안→HQ→Owner 선택 PENDING; 1280×720/40px은 승인 제품값 아님 | 규격 종속 제작/성능 인수 전 차단. 기획 문서 제출 차단 아님 |
| #24에 남은 외부 사용성 표본·합격선·예산 | HQ/Design→Owner PENDING | 모집/테스트·비용 집행 전 차단. 기획 문서 제출 차단 아님 |
| Stage 실행·W02 공통 시간/원장 L3 영향 | HQ 통합·Owner 실행 티켓/권한 판단 PENDING. 기존 SEM/CLOSE 재선택이나 새 규칙 충돌 요청은 없음 | 실제 구현 착수 전 차단. 이번 문서 제출 권한은 현 Owner 직접 요청에 한정 |

#24의 최신 Owner 결정 기록과 양 부서 회신은 현재 main을 기준으로 한 Issue 증거다. Issue가 OPEN이라는 사실만으로 해당 Owner 질문 전체를 미결로 분류하지 않는다. 반대로 댓글의 동의로 Stage 실행 권한을 생성하지 않는다. 이번 기획 산출물을 바꾸게 하는 **미결 신규 규칙 결정·중대한 부서 충돌은 미발견**이므로 PR 제출 진행 가능하다.

## 2. PM-010-PLN 체크리스트

| 항목 | 판정 | 근거·책임·필요 시점 |
| --- | --- | --- |
| 기준선·범위 | READY | 승인 8영역·11 MUST·AC-01~10·독립 VP-01 회사제안/VP-02 입찰 유지. 첫 Stage는 부분 기능/부분 증거. HQ Stage 통합 시 보존 |
| 승인 규칙 입력 | READY | C v0.6/D v0.9/DATA v1.3·PAR/SEM/CLOSE로 W01~W03 의미 입력 충족. Planning 새 수치·도형·규칙 제공 대기 없음 |
| 구체 협업 질문 | READY | 신규 기획 질문 0건. 기존 PLN-R01~05는 [#26 의미 재확인](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6555112937) 재사용. 달라진 의미 행만 영향 부서 L2 확인 |
| 수용 기준 | READY / 실행 NOT_RUN | 아래 정적 기대/반례와 실제 자동·GUI 증거를 비교. 부분 성공을 전체 AC·두 VP 성공으로 집계하지 않음 |
| Owner 규칙 선택 | NOT_APPLICABLE | NO_RULE_CHANGE_REQUIRED. 최소 UI/종료 증거 동의는 §1과 같이 추적; 후속 실행·제품 목표 선택과 구분 |
| 차단 시점 | READY | 각 통합·규격·테스트·인수 이벤트에만 조건 적용. 기획 전체를 타 부서 병렬 분석의 선행으로 만들지 않음 |

Gate 3-0 근거는 `4bdf65f9b832ab8235f818441bddae6423951585`의 [PLN-R01~05 최초 요청](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6554791565) → DSG PR #30 merge `8ef97626ba96844648a6de2e2cb9654e6816ce40` → DEV PR #31 merge `5a24ddb375b5859a033055566353e932754a525e` → #26 의미 재확인 → [PM-010 기획 회신](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6555458896)이다. R01 계약 당시/현재 여력, R02 동일 T 탑승, R03 공급·소비 매핑, R04 예측·cohort·시각, R05 관할/도형 분리는 정적 의미 해소 상태를 유지한다. 게임 구현 인수는 별도다.

## 3. 첫 Stage 승인 규칙 입력·부분 검수

| 입력/기존 기능·AC | 보존할 규칙·정적 기대값 및 반례 | 실제 증거 책임 |
| --- | --- | --- |
| W01 / F-COMP-001·공통 기반 | DATA 버전·안정 ID·초기 C=1,000,000/R=K=B=0, 시작일06:00. 잘못된 버전/ID 거부, 재조회 효과0 | DEV 정상/오류 초기화·실패 종료코드·엔진 로드와 GUI 진입 각각 확인 |
| W02 / F-TIME/COMP/FIN, AC-06·08·09·10 일부 | F=C−ΣRᵢ, A=max(0,F−ΣKᵢ). 발생비와 지급 분리; R/K 보호. C50/K48 비용3→C48/K48/B1, 운임11→C58/K48/B0/A10. 비용 재인식·타사업 전용 금지 | DEV 초기/기대/실제 원장·보고 diff, 사업별 격리·부분지급·중복 명령/조회 불변 검사 |
| W02 / SEM-03·R01 | [이전,T) 비용/공정→자정 전일보고 고정/날짜변경→T 계약/정부지급→기성/완공→시험/개통→T 도착운임→B 우선정산→같은 T 신규탑승 판정. 계약 당시 가용79,000/약정80,000은 거부; 뒤 운임1,000으로 현재80,000이어도 소급 승인 없음 | DEV 동일 T 사건 fixture·거부 당시와 현재 snapshot/명령 결과 분리. 실제 계약/영업 루프는 후속 |
| W02 / SEM-01·02/CLOSE-01 | B>0은 신규탑승만 제한; B 자체/6개월은 계약제재 아님. 23:59 탑승8→00:09 완료8/운임800·잔여도착 비용0; B500 정산 뒤 B0/자유현금 순증300·전일보고 불변. 00:09는 비영업이므로 B0이어도 신규탑승 불가 | DEV 자정·분할/일괄·부분분·정지/1·2·4배속 동등성. 기존 서비스 구간 비용은 면제하지 않음 |
| W03 / F-ADM/CITY/PROP, AC-01·02·04 일부 | 도→시→구→동과 광역시/특별시→구→동 구별. 승인 4구/8동/12역·부모/좌표/양방향 허용간선으로 판정. 정상6/8역, 5/9·중복/재방문·단절·타관할 거부; 정부발주 포함 소속시 공고 필터 | DEV 안정ID·행정/그래프 오류 및 정상 경로 검사. 타관할/다른 위계는 별도 검증 fixture이며 제품 도시 확장 아님 |
| W03 / PAR-05·R04·05 | 동일 동 수요를 역마다 복제하지 않음. 최소 OD 역쌍·동률 ID순·역순 대칭·q의5/10분 경계. 현재 입력revision의 유효 READY만 현재 예측; 실제0/미계산/실패/이전값 구분 | DEV 계산 기대/실제·낡은 응답 대조; DSG 대상 계획·기간·단위·오류/사유 소비. 표시 도형으로 관할 재판정 금지 |
| 최소 UI / UI-DC-01·02·05 현재자금·07 부분집합 | 동일 snapshot의 시각·현재장부·마감기록, 실제 정지/재개·배속, 지도↔목록 동일 ID/순서/선택·제거·정렬/되돌리기, 예측 갱신·거부/복구. 읽기 전용 장부는 시간/노선 조작 제외를 뜻하지 않음 | DEV 권위 값/reason/allowed_actions 공급; DSG 표현·동등 조작 대조. 자동 규칙/회귀 **및 실제 GUI 입력/표시·오류복구 증거** 필수. 이미지·정적 fixture·headless만으로 대체 불가 |

W02에서 계약·도착·B정산·탑승 경계를 자동 검증할 사건 주입은 검증 전용이다. 이를 실제 사업 취득·시공·영업 루프 완료나 제품용 지급 버튼으로 만들지 않는다. 첫 Stage의 본격 입찰/제안/심사·시공/안전/개통·실제 운행·전체 P07/완성 아트·열차 연출·두 VP 완주는 후속 범위다. Stage 단축을 위해 승인 기간/비용/규칙을 바꾸지 않는다.

VS-01 입찰 B01 우선은 구현 순서 제안이며 VP-01 제외가 아니다. MVP 인수 전 **독립 초기 상태에서 VP-01 회사제안과 VP-02 입찰** 각각 첫 실제 영업보고·다음 사업·정상 난수/시드·명령/원장 재현 증거 및 전체 AC 검증을 유지한다. 직접취소·정산토글·미지급 계약제재와 새 대출/지원·개별 시민 시스템을 추가하지 않는다.

## 4. 의존성·차단조건과 HQ 인계

| 대상 | 담당 → 필요한 입력 | 판정·차단 시점 |
| --- | --- | --- |
| W01→W02/W03 | DEV → 버전·안정 ID·초기상태·명령/결과·snapshot/fixture 기반 | 계획 READY. W01 이후 독립 기술 작업 병행 판단은 DEV. Planning 전체 결과/새 경계 폴리곤 대기 없음 |
| 실제 Stage 착수 / G3-04 | HQ 통합→Owner → 범위/부분 종료조건·실행 티켓·W02 L3 영향·개별 Git 권한 | PENDING. 실제 소스·씬·아트 착수 차단. 이번 PLN 문서 PR은 현 요청으로 별도 허용 |
| 해당 최소 UI 통합 / G3-01 | DEV 공급→DSG 소비 → 같은 revision의 실제 값/기간/게임분·reason/allowed_actions·정상/오류/낡은응답 fixture | PENDING. 해당 화면 연결/동작 검수 전. 독립 모델 검증·DSG 정보구조 검토 전체는 차단하지 않음 |
| 후속 P05/P06/P07/다음사업 | DEV+DSG → 전체 실제 공급/화면 매핑·초기/기대/실제·현재/과거/없음/0 | PENDING. 해당 통합 티켓 확정 전 계약 대조, 실제 통합/인수 시 실행 증거. 기획 의미가 달라진 행만 Planning 재확인 |
| 지도/역 / G3-02 | DSG+DEV → 12후보 밀집·6/8역·오류·지도/목록 동등 조작 | PENDING. 상세 지도·역 에셋 확정 전; Stage 최소 지도 통합에서도 실제 조작 대조 |
| 제품 목표 / G3-03 | DEV+DSG→HQ→Owner → PC/뷰포트/배율/폰트·FPS/연출 상한·측정 장면 | PENDING. 규격 종속 제작·성능 인수 전. 미결만으로 기획 제출/순수 규칙 검증 전체 차단 안 함 |
| 외부 사용성 / G3-06 | DSG/HQ→Owner → 표본·합격선·예산 | PENDING. 모집/테스트·집행 전 |
| 게임 인수 / G3-05 | DEV 실행·DSG 관찰·Planning 기대값·HQ 인수 → 코드/엔진/규칙/데이터 버전·시드/명령/초기/기대/실제·원장/화면 | PENDING. 첫 Stage 부분 인수 및 후속 전체 AC/독립 VP 인수에서 해당 증거 확보 |

현재 신규 RFC·기획 정책 질문 없음. 이후 실제 승인 규칙 변경·MVP 확대/축소·중대한 부서 충돌이 발견되면 해당 ID/AC/VP·대안·대상 SHA로 HQ/Owner에 상정하고 해당 변경을 중단한다. 계획 READY는 실행 승인이나 후속 검증 면제가 아니다. #24/#25/#26은 후속 검증 추적을 위해 OPEN 유지하며 자동 종료하지 않는다.

## 5. 검증·제출 한계

| 구분 | 이번 수행 |
| --- | --- |
| 원격 main/전체 tree·AGENTS·부서/기획 규칙·HQ 요청·승인 C/D/DATA·Issue 전체 댓글·DEV #33 patch | 직접 조회·정적 의미 대조 수행. 원격 main protected / 필수 policy·department-policy 설정 확인 |
| 문서 검증 | 신규 2파일 경로·ID·상호/기준 링크·UTF-8/LF·말미 개행·공백, 승인 규칙/값·범위 및 권한 대조 후 API 제출 |
| DEV #33 CI | head ea9d107의 두 success 기록 확인. 이번 PLN CI와 구별 |
| 로컬 clone | 시도 FAILED: getaddrinfo() thread failed to start. 로컬 checkout 확보 못함; 기존 사용자 파일 보존 |
| 로컬 훅·tools/policy.py doctor/check·도구 unittest | NOT_RUN: clone 네트워크 오류로 저장소/실행환경 미확보. API 방식은 로컬 훅을 실행하지 않음 |
| 이번 PR의 policy / department-policy | PR 이벤트에서 실행. 실제 head SHA·job URL·결과는 PR 본문에 기록; 이 문서에서 사전 PASS 선언하지 않음 |
| 게임 자동/회귀·Godot 프로젝트 로드·게임 진입·실제 GUI/지도 목업·Windows 빌드·성능·외부 사용성·VP E2E | 각각 NOT_RUN. 정책 CI·정적 산술로 게임 PASS 대체 금지 |
| main merge·실제 Stage 구현·릴리스 | NOT_RUN / 이번 권한 밖 |

두 필수 workflow는 PR 생성 이벤트가 필요하므로 PR 생성 후 동일 head의 두 CI를 확인하고 결과를 본문에 연결한다. 실패 시 우회하지 않고 허용 범위에서 원인 수정 또는 보고한다. 원격 제출 commit/tree·PR 링크와 실제 CI 결과는 PR 본문 및 Owner 완료 보고가 최종 추적점이다.

## 6. 고정 원본·Blob SHA

아래 파일은 모두 commit `177c2e4af3e15e15b15888c40eecb0f3ea983213`에서 직접 확인했다. Blob은 파일 내용 식별자이며 PR head/merge commit과 구분한다. 최신 문서의 REVIEW/DRAFT 표기는 승인 원문·병합 사실과 함께 해석한다.

| 원본 | Blob SHA |
| --- | --- |
| [AGENTS.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/AGENTS.md) | `806d52fdce959ce9066272089e33bd7a3fa72439` |
| [docs/engineering/DEPARTMENT_WORKFLOW.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/engineering/DEPARTMENT_WORKFLOW.md) | `681fecac1144f6fd5db01745c39fb928cd906d0b` |
| [docs/engineering/GIT_WORKFLOW.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/engineering/GIT_WORKFLOW.md) | `1b3f365647eee2f7fbbed3f50466f35a9d19d973` |
| [docs/engineering/CODE_CONVENTIONS.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/engineering/CODE_CONVENTIONS.md) | `ced20d50ed02798ff7963354be8517f8352b1ad1` |
| [docs/engineering/ENFORCEMENT.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/engineering/ENFORCEMENT.md) | `0babec56fe5c12c51c0fab5e3ef975f61c6c7d83` |
| [docs/planning/README.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/planning/README.md) | `1d425a2f68b655d6cf429962ee3a231fd5e90c4d` |
| [docs/hq/PM-008.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/hq/PM-008.md) | `fb2d3d388a56523a300f5c95874f1e1c06f543b5` |
| [docs/hq/requests/PM-008-PLN.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/hq/requests/PM-008-PLN.md) | `375e76c26e7d52fcf64f7e21296b73e9e6b32e43` |
| [docs/hq/PM-010_GATE3_1_REQUESTS.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/hq/PM-010_GATE3_1_REQUESTS.md) | `1d61d47546e4b050cd7215046d81fed74a94a36c` |
| [docs/hq/requests/PM-010_PLANNING_CHECKLIST.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/hq/requests/PM-010_PLANNING_CHECKLIST.md) | `9e55c7eda6068eccf441e6b68cbd7708b01c45b4` |
| [docs/planning/PLN-001-C.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/planning/PLN-001-C.md) | `44c671303573da4116336aa60288207bc8d7a0ef` |
| [docs/planning/PLN-001-D.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/planning/PLN-001-D.md) | `95c9ecbaeab2ad9f4ee3d87b5100af7fab1970d1` |
| [docs/planning/PLN-001_GATE2_DATA_v1_DRAFT.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/planning/PLN-001_GATE2_DATA_v1_DRAFT.md) | `359408ee058bae3e350defb45e594df4ee5c78d9` |
| [docs/planning/PLN-001_GATE2_FINAL_APPROVAL.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/planning/PLN-001_GATE2_FINAL_APPROVAL.md) | `6bd6ba4b898bf467c478e7a2281266a73572fd2a` |
| [docs/planning/tasks/PLN-001_GATE2_FINAL_HANDOFF.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/planning/tasks/PLN-001_GATE2_FINAL_HANDOFF.md) | `36063fab0d3ff59fb3e083cf025a1a797a3b583b` |
| [docs/engineering/gate3/DEV-006_UI_DATA_CONTRACT.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/engineering/gate3/DEV-006_UI_DATA_CONTRACT.md) | `1919586799d9a7e67cf0662063eac96b2b6b29ec` |
| [docs/engineering/gate3/DEV-006_DEVELOPMENT_PLAN.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/engineering/gate3/DEV-006_DEVELOPMENT_PLAN.md) | `56c59e75a53a9c0fe8a2b4877a4c84db1fd5e93a` |
| [docs/design/tasks/DSG-002_UI_PRESENTATION_DECISIONS.md](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/design/tasks/DSG-002_UI_PRESENTATION_DECISIONS.md) | `ac1304f127b52433529428f07a76c6c97c9a8be5` |

제출 직전 갱신: main `b1a8a1f981d066fce6f5ca516e821e4ff018daf8` → `177c2e4af3e15e15b15888c40eecb0f3ea983213`는 DEV #33의 1커밋/개발 문서7개뿐임을 compare/tree로 확인했다. 위 규칙·정책 원본은 동일 Blob이며 변경된 개발 계획·UI 계약과 신규 [Gate 3-1 분석](https://github.com/wisberry2022/MetroManager/blob/177c2e4af3e15e15b15888c40eecb0f3ea983213/docs/engineering/gate3/DEV-006_GATE3_1_ANALYSIS.md) Blob `9a918dd973164ed02b9b808c995ea406abc4f1f0`를 최신 commit에서 직접 재조회했다.
