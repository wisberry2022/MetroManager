# DSG-006 후속 — Track B 디자인 진행 현황 snapshot

- 작성: Design / Track B / AGT-DSG-0003 / 2026-11-08 / v0.1
- 상태: REVIEW / OWNER_GIT_SUBMISSION_APPROVED / STATUS_SNAPSHOT / FINAL_SPEC_PENDING / NOT_DONE
- 기준 main: `7735ccff22952dabdf1371c2b29d81b620f4a9c0`
- 작업: DSG-006 원본 공용 보관 준비와 디자인 진행 현황 정리
- 브랜치: `codex/DSG-006-visual-archive`
- 현재 승인: [보관 준비 §1](DSG-006_VISUAL_ARCHIVE_PREPARATION.md#1-승인작업-경계)
- 본 문서는 위 시점의 읽기 전용 근거를 정리한 Design snapshot이며 HQ의 일정/Stage 정본·타 부서 결과·기존 역사 문서를 대체하지 않는다.

## 1. 현재 도달 지점

철도 모형 디오라마가 Owner 선택 MVP 방향이다. MVP 이후 UI 재배치·콘셉트 변경을 포함한 개편 가능성을 유지한다. DSG-007 최소 시스템과 DSG-008 S01 정보 구조/잠정 배치·DEV-025 실험 입력은 main에 제출됐다. 최종 제품 규격이나 실제 제품 적용·인수를 완료한 상태는 아니다.

| 업무 | 현재 확인된 진척 | 남은 항목 |
| --- | --- | --- |
| DSG-006 탐색 | 7후보 비교·선택/조건 문서 PR86 병합 | 원본 공용 보관·S2-D01 공식 인수. 이번 패킷은 로컬 보관 준비만 |
| DSG-007 | 제안 PR87·산출물6개 PR88 병합, 의미 역할/토큰/상태/변경 기준 | Godot 실제 적용·F08 종속 규격·최종 결과 수용/제품 검증 |
| DSG-008 1단계 | 산출물6개 PR90 병합, IA/15상태/잠정A·B 비교 | 정밀 규격·최종 배치·실제 제품 동등성 |
| DSG-008 기술 협의 준비 | 후속문서2개 PR93 병합, Issue92 DEV 요청/회신 | 의견 수신과 실제 실험 완료 구분. F08 네 항목 OPEN |
| DSG-008 DEV025 입력 | 산출물5개 PR98 병합, Issue92 전달 댓글 연결 | DEV 실험 결과 수신→Design 조건별 판정→HQ/Owner 선택 |
| DSG-009 | 이번 확인 범위에서 정식 제작 착수 근거 없음 | 에셋 목록/역할 준비안은 제안 가능, 대량 아트·애니메이션/규격종속 제작은 별도 승인 |
| Track A | 별도 담당·수용 경계 유지 | 본 Track B가 실제 제품 QA/DSG010 책임을 인수하거나 DONE 선언하지 않음 |

## 2. 병합·등록 근거

아래는 GitHub 실제 병합 조회 결과다. 병합 여부와 제품 합격·전체 티켓 DONE을 혼동하지 않는다. 모든 날짜는 2026-11-08이며 시각은 UTC다.

| PR | 내용 | merged_at UTC | main 반영 SHA |
| --- | --- | --- | --- |
| [86](https://github.com/wisberry2022/MetroManager/pull/86) | DSG006 결과 | 06:09:52 | 1a5d0632711c1472e514ab19f04fe0b87b257ec1 |
| [87](https://github.com/wisberry2022/MetroManager/pull/87) | DSG007 제안 | 06:11:13 | c81b29585496fd291cfc4aeb443ed3e5ff14c588 |
| [88](https://github.com/wisberry2022/MetroManager/pull/88) | DSG007 시스템 | 06:45:27 | 3b61628bc2e733452ed0448450d00fb3beff784d |
| [90](https://github.com/wisberry2022/MetroManager/pull/90) | DSG008 1단계 | 07:24:17 | 96139dfb1fd26f449e84e7f08986b0ab17e06787 |
| [91](https://github.com/wisberry2022/MetroManager/pull/91) | INF004 TrackB 등록 | 07:38:45 | 29d8d05a3a6b134bb89c0e4f500d0f52cc09d660 |
| [93](https://github.com/wisberry2022/MetroManager/pull/93) | DSG008 F08 후속문서 | 07:53:14 | 98d56eb97f8a030912bea534ff1c330e9c40188e |
| [98](https://github.com/wisberry2022/MetroManager/pull/98) | DSG008 DEV025 입력 | 09:32:47 | 7735ccff22952dabdf1371c2b29d81b620f4a9c0 |

[INF004 Owner 활성화](../../infra/tasks/INF-004_TRACK_B_AGENT_REGISTRATION.md#owner-activation)와 [등록부](../../infra/agents/registry.json)에서 AGT-DSG-0003 / DSG / ACTIVE / generation1 / predecessor=null을 확인한다. 효력은 2026-11-08T16:25:00+09:00이다. Track A 후임 AGT-DSG-0002와 독립이며 등록은 포괄 Git 권한·기술적 신원 인증이 아니다.

기존 문서의 “Agent-ID 미발급/미확인”은 당시 사실로 보존한다. PR90의 PRIMARY_COUNT와 PR93/98의 REPORT_ONLY MANIFEST_NOT_FOUND도 당시 진단이며 등록/병합만으로 소급 수정하지 않는다. 이번 로컬 패킷의 신규 출처 CI는 실행하지 않았다.

## 3. DEV 협의·F-08

[DEV 회신](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-6719657980)을 수신했다. [입력 전달](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-6719822789)로 PR98과 고정 자료를 연결했다. 무회신·미발송이라는 과거 문구를 현재 사실로 재사용하지 않는다.

| ID | 현재 상태 | 다음 책임·확정 조건 |
| --- | --- | --- |
| F08-01 | 기술 의견 수신 / OPEN | DEV 실제 창/DPI·폰트/fallback/글리프·배포 검토→Design 대조→Owner 선택 |
| F08-02 | 기술 대안 수신 / OPEN | DEV 실제 필터·배율/위상 비교→Design 시각 판정→최종 아트 방식 선택 |
| F08-03 | 기존 자동/부분 GUI 근거 설명 수신 / OPEN | 긴 라벨·밀집·키보드·대상/명령 동등성의 추가 실제 입력 검증 |
| F08-04 | 재사용/측정 대안 수신 / OPEN | DEV 환경/장면/원시 성능 기록→Design 정보 보존 대조→HQ/Owner |

DEV-025 [Issue97](https://github.com/wisberry2022/MetroManager/issues/97)은 확인한 공개 본문에서 실행/Git 승인 대기·실험 NOT_RUN이다. 공개 댓글은 확인 시0개다. 공개 기록 밖 Owner 승인/DEV 진행 여부를 추정하지 않으며 실제 착수/결과는 담당 부서가 최신 근거로 갱신한다. 실험 입력 전달을 DEV 실험 완료로 표시하지 않는다.

최소 기능 UI를 F08 전체로 일괄 차단하지 않는다. Windows export·최종 FPS·제품 GUI 인수·외부 사용성은 각각 별도 후속이다.

## 4. 기록 보존과 잔여 업무

| 구분 | 상태·후속 |
| --- | --- |
| 과거 승인·QA | 원문/버전/기준 SHA 그대로 보존. 현재 snapshot을 덧붙이는 방식 |
| DSG006 공용 원본 | 바이트 사본·오프라인 열람기·대표 PNG·명세 로컬 준비. 원격 게시/공식 인수는 미완료 |
| S01 문구·미수신/예외 정적 설계 | 후속 가능한 제안. 이번에는 착수하지 않음 |
| 제품 최종 규격/배치 | FINAL_SPEC_PENDING. A는 Design 잠정 우선이며 최종 Owner 선택 아님 |
| 실제 게임 적용·Design 검수 | DEV/Track A·후속 승인 범위. 이번 보관 작업에서 NOT_RUN |
| 새 Git 제출 | 최초 보고는 로컬 검토본. 후속 Owner가 이 패킷9개 Commit·Push·PR을 승인했으며 실제 결과는 제출 PR에 기록. main 병합·새 외부 전달은 제외 |

기존 브라우저620개(DSG008 1단계)·1466개(DEV025 입력), 신규 보관 열람기173개는 서로 다른 시점/대상의 검증이다. 이 snapshot 작성에서 앞의 검사를 재실행한 것으로 보고하지 않는다. 실제 Godot·게임·빌드·성능 PASS로 바꾸지 않는다.

현재 명세 변경 필요: NONE. S2-D01·DSG008 전체·Stage2 DONE은 이 문서에서 선언하지 않는다.
