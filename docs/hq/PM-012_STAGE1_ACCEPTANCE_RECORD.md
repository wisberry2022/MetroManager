# PM-012 — Gate 3-2 Stage 1 공식 인수·후속 의무 인계 기록

- 담당: HQ / Project Manager / 2026-11-08 (Asia/Seoul).
- 상태: `OWNER_CONDITIONAL_ACCEPTANCE_CONFIRMED / STAGE1_HANDOFF_COMPLETED / S1_09_REVIEW / STAGE1_DONE_PENDING`.
- 문서 제출은 S1-09 공식 기록의 검수 요청이다. PR 제출·CI 성공·문서 병합만으로 S1-09 또는 Stage 1을 DONE 처리하지 않는다. 별도 Owner 병합 승인 및 최종 종료 근거 확인이 남는다.
- 운영 기준: [PM-008](PM-008.md), [PM-008-GIT](PM-008-GIT.md), [PM-011 승인 계획](PM-011_GATE3_2_APPROVED_PLAN.md), [실행 프로토콜](PM-011_GATE3_2_EXECUTION_PROTOCOL.md). 과거 초안의 상태·금지 문구를 임의 개정하지 않는다. Git 동기화에는 최신 main의 [DEV-014 반영 규칙](../engineering/GITHUB_SUBMISSION.md)이 우선하며 검증된 무충돌 base-sync 예외를 보존한다.

## 1. 승인·수신 근거와 출처 한계

Owner는 [HQ(PM) 대화](https://chatgpt.com/c/6ae545e7-5c98-83e8-86fd-15b5854397b2)에서 S1-01~08을 조건부 수용하고 S1-09 공식 기록과 후속 의무 인계 이후 종료하도록 지시했다. 2026-11-08 HQ의 원본 검사 보고와 5개 부서 회신 수용 보고가 이 대화에 남아 있으며, 마지막 Owner 지시는 “PM 에이전트. 원격 저장소에 PR 생성해주세요”이다. 현재 PM-012 실행 지시에서도 이 수용 상태와 문서·Commit·작업 브랜치 Push·base=main PR·CI 범위가 명시적으로 재확인되었다.

이번 세션에서 읽은 대화 요약은 Owner의 과거 조건부 수용을 보고한 HQ 기록이다. 최초 수용 발언 전문 및 첨부물 바이트는 도구 응답에 포함되지 않았으므로 새로 직접 확인했다고 표현하지 않는다. 이 문서는 그 승인·수신 결과를 공식 색인화하며 대화 전체나 비공개 부서 회신 원문을 공개 Git에 복제하지 않는다. 대화 링크는 접근 권한이 필요한 보조 근거이며 공개 GitHub 증거와 구별한다.

| 근거 | 이번 확인 범위 |
| --- | --- |
| [Planning #26 후속 책임 수락](https://github.com/wisberry2022/MetroManager/issues/26#issuecomment-6715020356) | 원격 댓글 직접 조회. F-01/03/04/05/07 전부 수락, NO_RULE_CHANGE_REQUIRED / NO_NEW_L3 |
| [Planning W02 최종 의미 수용](https://github.com/wisberry2022/MetroManager/issues/48#issuecomment-6714008926) | 원격 댓글 직접 조회. PLANNING_SEMANTICS_ACCEPTED / NO_RULE_CHANGE_REQUIRED / NO_NEW_L3. 전체 기획 재심사나 VP 완료를 뜻하지 않음 |
| [Design #59 최종 인수](https://github.com/wisberry2022/MetroManager/issues/59#issuecomment-6714538942) | 원격 댓글 직접 조회. DSG005_STAGE1_MINIMUM_UI_DESIGN_ACCEPTED / HQ_STAGE_ACCEPTANCE_PENDING |
| [Issue #63 Design→DEV 최종 L2 회신](https://github.com/wisberry2022/MetroManager/issues/63#issuecomment-6714542339) | 원격 댓글 직접 조회. R-01/02 PASS, R-03 현재 범위 수용, 신규 코드 수정 요청 없음 |
| Development·Design·INF·Convention 후속 책임 회신 | Owner가 HQ 대화에 전달한 첨부와 HQ 수용 보고를 근거로 수락 기록. 이번 세션에서 첨부 원문 재열람은 NOT_RUN. 각 부서의 GitHub 공식 수락 댓글이 있다고 주장하지 않음 |

## 2. 제품 인수 기준과 문서 제출 기준

| 구분 | 고정 기준 |
| --- | --- |
| Stage 1 제품 검증·Owner 조건부 수용 | [main fba3fd575c83e1eae234dc77aa9207898e0849b3](https://github.com/wisberry2022/MetroManager/commit/fba3fd575c83e1eae234dc77aa9207898e0849b3), PR #69 병합, tree `341ae6778c972cbaef25020177a34d17b8899c11` |
| PM-012 작성·제출 base | [main 8fd329773965ff9b4c725a2f1934770a5d56346b](https://github.com/wisberry2022/MetroManager/commit/8fd329773965ff9b4c725a2f1934770a5d56346b), PR #70 병합 |

원격 main 및 로컬 fetch 결과를 대조했다. 후자의 부모는 전자 하나이며 [두 기준 비교](https://github.com/wisberry2022/MetroManager/compare/fba3fd575c83e1eae234dc77aa9207898e0849b3...8fd329773965ff9b4c725a2f1934770a5d56346b)는 운영 도구·관련 tooling 테스트·engineering 문서 15파일에 한정된다. scripts/·scenes/·assets/·tests/game/·project.godot 및 Gate 2 기획 원본 변경은 0이다. [PR #70](https://github.com/wisberry2022/MetroManager/pull/70)의 출처 진단/등록 복구 보완을 새 제품 검증으로 계상하지 않는다. 제출 직전 main 재확인과 실제 head의 필수 CI는 PM-012 PR에 기록한다.

## 3. S1-01~09 통합 인수표

S1-01~08의 상태는 **Owner 조건부 수용 유지**이며 아래 증거 범위에 한정한다. 제품 검증을 이번 문서 작성 중 재실행한 것은 아니다.

| 기준 | 근거·수용 내용 | 한계·후속 |
| --- | --- | --- |
| S1-01 | PR #47 W01 초기화, #65/#69 제품 진입·headless editor와 실제 Windows GUI 기록; 최종 Design #59 제품 GUI 종료0 | 엔진 로드와 GUI 입력을 별도 증거로 유지 |
| S1-02 | #47 승인 데이터·행정 부모·12후보·초기 C=1000000/R=K=B=0·06:00 및 부정 입력 검증, W01 219단언 | 승인 Gate 2 DATA v1.3 범위 |
| S1-03 | #57 W03 정상6/8역·5/9역·중복/단절/관할외 거부, W03 101단언; #67 포커스·단절 목록 수정 | 현재 게임 RNG 비사용. 미래 RNG 상태/시퀀스 검증은 F-01 |
| S1-04 | #57 예측4860/정상0·없음/실패·revision, #69 CALCULATING/READY의 old fail 거부·전체 snapshot 보존 | late-fail은 직접 자동검사; GUI 결함 주입을 수행한 것으로 쓰지 않음 |
| S1-05 | #55 보호 원장, #69 당일 발생·지급·누적 B 분리, Design 최종 GUI의 3/2/B1·C48/K48/A0 및 과거 B 정산 확인 | 지급=payment+debt_payment, B=당일 발생−지급으로 계산하지 않음. 상세 설명은 F-02 |
| S1-06 | #62 W02 309단언, 전일3/3·마감C97·익일정부80/기성60·최종C117/R20, 마감1회/일괄·분할·배속/조회 불변; Planning 의미 수용 | 내부 확정 지급은 테스트 fixture. 실제 계약·시공·운행 제품 구현 완료가 아님 |
| S1-07 | #65 시간 제어와 실제 입력, #68 잔여 독립 검수, 최종 #59 실제 마우스·스크롤·제품 정지 분417/관측 일치 | 배속 정밀 계측은 자동 회귀 근거. 모든 플랫폼/DPI 수용 아님 |
| S1-08 | #67 기존 역 정보 포커스·단절 역쌍/사유, [독립 GUI 재수용](https://github.com/wisberry2022/MetroManager/issues/59#issuecomment-6698776407); #69 재무 및 최종 #59 14 QA 수용 | 최소 저충실도 S01. 고충실도/상세 지도·전 화면 사용성은 F-06~10 |
| S1-09 | 본 기록에 승인·SHA·티켓·PR/CI·결함 수용·NOT_RUN·증거 보관·후속 책임을 통합 | **REVIEW**. 이번 PR의 CI, Owner 별도 병합 승인, 실제 main 반영 및 종료 근거 확인 전 DONE 아님 |

[DEV-015 결과 §7](../engineering/tasks/DEV-015_RESULT.md)와 PR #69는 W01 219 / W02 309 / W03 101 / W07 322 = **951단언 실패0**을 보고한다. 최종 독립 QA 묶음의 새 실행은 **W07 322/0**이며 W01~03을 그 묶음에서 재실행한 것으로 확대하지 않는다. R-01은 독립 GUI, R-02는 독립 자동, R-03은 현재 게임 RNG 비사용의 소스/호출 경계 근거다. 엔진/렌더러 내부 RNG 부재를 주장하지 않는다. 기존 DSG-QA-01·02 수용은 유지하고, #68의 과거 ACCEPTANCE_PENDING은 #69 이후 최종 댓글로 갱신된 이력으로 읽는다.

## 4. 최종 Design QA 원본·보관 색인

- 최종 파일: `DSG-005_PR69_FINAL_UI_RETEST_EVIDENCE.zip`.
- SHA-256: `2aa4ab7ea76903304167e05b7fadf4d66e08318c3bf24166a515cfcf8a86e235`.
- 별도 `.sha256.txt`, 내부 `SHA256SUMS.txt` 42항목, `DSG-005_PR69_FINAL_UI_RETEST_REPORT.md`, `logs/gui-actions.json`, 11 JPEG(722×480), fixture/제품 종료 로그·W07 원시 로그를 [Design 최종 댓글](https://github.com/wisberry2022/MetroManager/issues/59#issuecomment-6714538942)이 특정한다.
- 기존 HQ는 Owner가 HQ 대화에 첨부한 ZIP·해시 파일을 직접 검사하여 SHA 일치, ZIP CRC PASS, 42/42 일치, JPEG 디코딩 정상과 GUI 종료0·W07 322/0 로그 포함을 보고했다. 이는 **당시 HQ 검사 기록**이며 이번 Codex 세션의 재해시·압축 검사·Godot 재실행은 NOT_RUN이다.
- 보관 출처는 **Owner 로컬 원본 및 위 HQ(PM) 대화의 Owner 첨부물**이다. 장기 원본 보관은 Owner, Design은 QA 판정/증거 해설, HQ는 본 색인과 인수 기록 유지 담당으로 인계한다. 재열람은 Owner에게 동일 파일·해시를 요청해 제공본을 대조하는 방식이다.
- 정확한 로컬 절대 경로, 영구 외부 저장소 URL, 보존 기간·백업/복구 시험은 확인되지 않았다. 대화 첨부를 영구 보존 저장소나 공개 다운로드로 간주하지 않는다. 이번 제출이 원본의 영구 가용성을 보증하지 않으며 장기 위치 확정은 남은 관리 사항이다.
- PR #68의 [공개 잔여 증거](../design/evidence/DSG-005-residual-20261107/README.md)는 **#69 전 묶음**이다. 이 공개 ZIP을 위 최종 ZIP과 동일한 것으로 대체하지 않는다. 이번 PR에는 원본 ZIP 재업로드·이동·사본 생성이 없다.

## 5. F-01~12 책임 수락과 최초 차단 시점

F-ID는 후속 의무의 식별자이며 실행 티켓이나 기능 완료 표시가 아니다. **12/12 인계 수락, 5/5 부서 Owner 경유 수신**이라는 기존 HQ 판정을 기록한다. Development F-01/03/04/05/07/08/10/11, Design F-02/06/07/08/09/10, Planning F-01/03/04/05/07, INF·Convention F-11 지원/F-12를 수락했다. HQ가 통합 추적하고 후속 티켓 발급 시 해당 F-ID를 연결한다. 미발급 티켓을 존재하는 것으로 표시하거나 이번에 Issue를 만들지 않는다.

| ID | 주관 / 지원 및 수락 범위 | 완료 증거·최초 차단 시점 | 추적점 |
| --- | --- | --- | --- |
| F-01 | DEV / Planning, HQ 추적: 최초 게임 RNG seed/state·시퀀스, 조회·거부·중복 불변 | 최초 RNG 기능 **통합 전**, 실제 RNG 상태/시퀀스와 재현 로그. 현재 비사용 판정으로 미래 의무 소멸 안 됨 | #26 수락 및 향후 최초 RNG DEV 티켓 |
| F-02 | Design / DEV 공급: 발생·즉시 지급·과거 미지급 후정산 설명 | 해당 **상세 재무 UI 인수 전**, 승인 의미와 실제 화면 대조. Stage 1 비차단 도움말 권고 | #59 최종 권고 → 후속 재무 UI 티켓 |
| F-03 | DEV / Planning: W04A 공공입찰·계약 | **VS-01 관련 기능 인수 전**, 자격/점수/동점/공고·계약·중복 및 실제 경로 증거 | #25/#26 → W04A 티켓(미발급) |
| F-04 | DEV / Planning: W04B 회사제안·정부 심사·RNG/사실 소비 | **독립 VS-02 인수 전**, 승인 3분기·설득/재접수·사실 소비/재현. 최초 RNG는 F-01 선행 | #25/#26 → W04B 티켓(미발급) |
| F-05 | DEV / Planning: W05 시공·안전·개통/W06 실제 운행·보고 | 각각 **통합 검증·해당 사업 경로 인수 전**, 보호/지급·안전·실제 승객/운임·보고 로그 | #25/#26 → W05/06 티켓(미발급) |
| F-06 | Design / DEV 기술 협의, Owner 주요 콘셉트 승인 | 별도 승인된 **제작·게임 적용 전**, 실제 콘셉트 비교·아트 디렉션/에셋 사양·제작물 검수 | Design #24 및 신규 DSG 티켓 필요 |
| F-07 | HQ 통합 / DEV·Design·Planning | **MVP 최종 인수 전**, W08 AC-01~10과 독립 초기 상태 VP-01 회사제안/VP-02 공공입찰 각각 E2E·원장·사용성 증거 | #24/#25/#26 및 향후 통합 인수 기록 |
| F-08 | DEV+Design / HQ→Owner 규격 결정 | **규격 종속 고충실도 제작·성능 인수 전**, W09 해상도/폰트/배율/표현 상한·Windows export·측정 장면/FPS | #24/#25 및 후속 규격 티켓. 1280×720/40px는 승인 제품 규격 아님 |
| F-09 | Design / HQ·Owner | **외부 참가자 모집·예산 집행 전**, 표본/합격선/예산 승인 후 실제 외부 사용성 증거 | #24 및 후속 외부 검증 티켓 필요 |
| F-10 | DEV 공급+Design 검수 / HQ 의존성 관리 | **해당 화면 통합·상세 아트 확정 전**, 안정 ID·동일 revision/관측·정상/오류 fixture·지도/목록 가독성/동등 조작 | #59/#63 및 실제 후속 UI 티켓 |
| F-11 | 각 실행 부서(DEV 수락) / INF·Convention 지원, HQ 추적 | **각 신규 제작·Git 실행 전**, 개별 Owner 승인/경로/동작/기간과 역할·Agent-ID 확인. 등록 상태와 실행 권한 분리 | 승인된 해당 티켓·PR; 등록부 읽기 근거만 사용 |
| F-12 | HQ 회고 주관 / INF·Convention 수락 | **첫 Stage 종료 후 회고**, 상태 정합성·QA 보존/재열람·세션/출처/권한 연속성 점검. 실제 정책 변경/등록/ENFORCE **적용 전 별도 승인** | PM-008, [협업 #38](https://github.com/wisberry2022/MetroManager/issues/38), 실제 개선 시 소관 신규 티켓 |

기존 추적점은 대화에서 언급한 관련 원장이지 모든 F-ID의 새 실행 승인이 아니다. 후속 구현·검증은 현재 NOT_RUN/미착수이며 각 담당 부서는 실제 적용 직전에 필요한 티켓과 증거를 연결해야 한다. Design의 DSG-006 콘셉트 후보3안 비교→DSG-007 시스템→DSG-008 S01→DSG-009 에셋은 **권고 분할안**이며 승인·발급·제작 착수가 아니다. 고충실도 제작을 Stage 1 종료 조건으로 소급 추가하지 않는다. F-12 회고·운영 개선 역시 Stage 1의 새 차단 조건이 아니다.

## 6. 병합·CI 근거 색인

2026-11-08 원격 API로 아래 PR의 MERGED 및 **실제 최종 head SHA**의 두 검사 SUCCESS를 재조회했다. 과거 실패/대체 이력은 삭제하지 않으며 현재 성공을 과거 모든 시도의 성공으로 바꾸지 않는다.

| PR | 범위 | 최종 head | 원격 검사 |
| --- | --- | --- | --- |
| [#47](https://github.com/wisberry2022/MetroManager/pull/47) | DEV-010 W01 실행과 승인 데이터 초기화 기반을 구현합니다 | `914eac65b6870a5e66d30e68d8748632e7f6851f` | [policy](https://github.com/wisberry2022/MetroManager/actions/runs/41297560176/job/124821510300) / [department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/41297560272/job/124821511198) SUCCESS |
| [#55](https://github.com/wisberry2022/MetroManager/pull/55) | DEV-011 W02 시간·명령·원장을 최신 main 기준으로 재제출합니다 | `09c5b2629bd171af87e5128ee967780caabde621` | [policy](https://github.com/wisberry2022/MetroManager/actions/runs/41301121496/job/124832055755) / [department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/41301121787/job/124832057628) SUCCESS |
| [#57](https://github.com/wisberry2022/MetroManager/pull/57) | DEV-012 W03 충돌 해소와 협업 오류 보고를 제출합니다 | `41962346a04c7ccc012d22d6a6a2d360f1c63b27` | [policy](https://github.com/wisberry2022/MetroManager/actions/runs/41302063860/job/124834903658) / [department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/41302063879/job/124834904334) SUCCESS |
| [#62](https://github.com/wisberry2022/MetroManager/pull/62) | DEV-011 자정 복합 경계 원장·보고 회귀를 보완합니다 | `711900768f00fc4d1da8c391c842929ab13a5709` | [policy](https://github.com/wisberry2022/MetroManager/actions/runs/41306057023/job/124846545805) / [department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/41306057016/job/124846546737) SUCCESS |
| [#65](https://github.com/wisberry2022/MetroManager/pull/65) | DEV-015 W07 최소 S01 UI를 통합합니다 | `93fdf32dc376ac9819434c5605cf2fbfe15318c5` | [policy](https://github.com/wisberry2022/MetroManager/actions/runs/41438665017/job/125254739298) / [department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/41438664839/job/125254741394) SUCCESS |
| [#67](https://github.com/wisberry2022/MetroManager/pull/67) | DEV-015 검수의 역 포커스와 단절 구간 표시를 보완합니다 | `a77ece72c38e63a27248f9139b471e617d565a72` | [policy](https://github.com/wisberry2022/MetroManager/actions/runs/41447976063/job/125285735983) / [department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/41447976061/job/125285738499) SUCCESS |
| [#68](https://github.com/wisberry2022/MetroManager/pull/68) | DSG-005 잔여 UX 검수 보고서와 독립 실행 증거를 제출합니다 | `a497bdec7bb4f2be956621a6fceca0af43bdfd6b` | [policy](https://github.com/wisberry2022/MetroManager/actions/runs/42315908414/job/128228313585) / [department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/42315909163/job/128228318803) SUCCESS |
| [#69](https://github.com/wisberry2022/MetroManager/pull/69) | DEV-015 당일 운영비 요약과 늦은 실패 회귀를 보완합니다 | `dd2f1b4f2644b1c2a5f197302dcdf68473ec05bf` | [policy](https://github.com/wisberry2022/MetroManager/actions/runs/42424360389/job/128559344697) / [department-policy](https://github.com/wisberry2022/MetroManager/actions/runs/42424360139/job/128559344877) SUCCESS |

main 조회에서 protected=true 및 필수 `policy`/`department-policy`를 확인했다. 전체 보호 설정·권한 위임·독립 신원을 이 값만으로 검증했다고 주장하지 않는다. `agent-provenance-report`는 REPORT_ONLY이며 job 성공은 선언 진단의 실행 성공일 뿐 신원·승인 인증이나 ENFORCE 승인이 아니다. PM-012에서 등록부/CI/출처 정책을 변경하지 않는다.

## 7. 남은 종료 절차와 NOT_RUN

본 기록 검수 → 정확한 PM-012 head의 두 CI 확인 → **Owner 별도 main 병합 승인** → 실제 병합 SHA와 이 기록/보관·인계 근거 재확인 → 권한 있는 별도 최종 종료 판단 순서를 유지한다. Issue 수정·Close, main Merge, 릴리스, `STAGE1_DONE` 선언은 이번 권한에 없다. S1-09는 REVIEW로 유지한다.

이번 HQ 문서 작업에서 Godot 로드·게임 자동/GUI·실플레이·빌드/export·성능·외부 사용성·전체 AC/VP 재실행은 NOT_RUN이다. 과거 Stage 1 자동/GUI 증거를 연결했을 뿐이며 W04~06/전체 MVP 완료를 주장하지 않는다. 장기 원본 보관 위치의 정확한 경로/지속 가용성과 Owner 제한 첨부 원문 재열람 한계는 §1·4대로 남긴다. 새 규칙·수치·범위 변경/RFC 요청은 없고 미해결 운영 계약/등록/ENFORCE는 Convention/INF의 별도 소관이다.
