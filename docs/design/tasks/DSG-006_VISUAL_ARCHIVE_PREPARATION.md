# DSG-006 — 시각 원본 공용 보관 준비

- 담당: Design / Track B / Agent-ID: AGT-DSG-0003 / v0.1 / 2026-11-08
- 상태: REVIEW / OWNER_GIT_SUBMISSION_APPROVED / MAIN_PUBLICATION_PENDING / FINAL_SPEC_PENDING / NOT_DONE
- 기준 main: `7735ccff22952dabdf1371c2b29d81b620f4a9c0`
- 작업 브랜치: `codex/DSG-006-visual-archive`
- 관련: [과거 결과 v0.1](DSG-006_RESULT.md), [최신 현황 snapshot](DSG-006_TRACK_B_PROGRESS_SNAPSHOT.md), [이번 결과](DSG-006_VISUAL_ARCHIVE_RESULT.md)
- 열람: [오프라인 열람기](../assets/source/dsg_006/archive_viewer.html), [보관 명세](../assets/source/dsg_006/archive_manifest.json)

## 1. 승인·작업 경계

Owner의 현재 Track B 지시:

> 우선 DSG-006 시각 원본 공용 보관 준비와 디자인 진행 현황 정리를 진행해주세요. 과거 승인·검증 기록은 보존하고, 최종 규격은 미확정으로 유지한 채 로컬 산출물로 먼저 검토 요청해주세요.

최초 보고는 로컬 보관 패킷9개였고 신규 Commit·Push·PR·원격 게시·외부 전달을 수행하지 않았다. 최종 제품 규격·S2-D01 인수·Stage DONE·게임 규칙을 결정하지 않는다. main 공용 보관 반영은 미완료다.

후속 Owner 제출 승인:

> DSG-006 시각 원본 보관 및 디자인 현황 정리 산출물 9개의 커밋·푸시 및 PR 생성을 승인합니다. 과거 승인·검증 기록 보존과 최종 규격 미확정, 미해결 항목 및 NOT_RUN을 PR에 명시하고 main 병합은 하지 마세요.

대상은 `wisberry2022/MetroManager` / DSG-006 / 현재 브랜치 `codex/DSG-006-visual-archive` / 결과서의 신규 디자인 파일9개다. 정상 훅·정책·preflight 후 Commit·일반 Push·base=main PR 생성 및 원격 검증을 수행한다. 이번 제출·동일 범위 검증 보완까지 유효하며 별도 날짜 만료는 제시되지 않았다. main 직접 수정·병합·자동병합·릴리스·배포·force push·타 부서/정책/CI·제품 적용은 제외한다. 신규 이슈/다른 채팅 전달도 이번 승인 범위에 추가하지 않는다. 제출 head/base·원격 파일 검증·CI/REPORT_ONLY 진단은 PR에 기록한다.

기존 DSG-006/007/008·INF·HQ·기획·개발 파일은 수정하지 않는다. 과거 저자·Agent 미등록·브라우저 실패/NOT_RUN·Owner 선택/제출/병합 승인을 지우거나 현재 상태로 소급 덮지 않는다. 최신 정보는 별도 snapshot과 이번 결과에 추가한다.

## 2. 보관 원본과 파생물

| 종류 | 파일·식별 | 보존·해석 |
| --- | --- | --- |
| 원본1 | [metro-concept-comparison.html](../assets/source/dsg_006/metro-concept-comparison.html) | 최초3안 HTML fragment, 바이트 무변경 |
| 원본2 | [metro-four-more-concepts.html](../assets/source/dsg_006/metro-four-more-concepts.html) | 추가4안 HTML fragment, 바이트 무변경 |
| 파생 열람기 | [archive_viewer.html](../assets/source/dsg_006/archive_viewer.html) | 두 원본의 내부 사본+새 호스트 기본 스타일·자료/후보 선택 UI. 원본과 구별 |
| 파생 캡처 | [최초 자료 기본](../assets/exports/dsg_006/first_three_default.png), [디오라마 기본](../assets/exports/dsg_006/diorama_default.png) | 이번 열람기에서 새로 캡처한 대표2장. 당시 채팅 스크린샷 아님 |
| 보관 명세 | [archive_manifest.json](../assets/source/dsg_006/archive_manifest.json) | 원본/파생물 해시·길이·캡처 조건·의존성/제약 |
| 문서3개 | 본 문서·현황 snapshot·이번 결과 | 승인/범위·최신 상태·검증/미해결을 분리 |

원본 해시는 [과거 결과 §6](DSG-006_RESULT.md#6-시각-자료와-증거의-보관-한계)와 일치한다.

| 원본 | SHA-256 |
| --- | --- |
| 최초3안 | f8f4db0e7361c102bb17201b7faeb22fd1ddad91778f31cd85b3fdbc827af0aa |
| 추가4안 | 4efa91904ef3a963d4f14009adb7238dd441a74dbbd07667dc116955c0089676 |

이 사본의 보관 작성자는 현재 AGT-DSG-0003이다. 원본 작성 당시 등록이 확인됐다고 주장하거나 효력 시각 이전 저자를 재귀속하지 않는다.

## 3. 열람·재현 범위

파일을 로컬로 열고 자료(최초3안/추가4안)→후보를 선택한다. 각 원본 안의 장면 A/B 버튼으로 기본/잠금·조회실패를 전환하고 지도 또는 순서 목록에서 정보 선택을 바꿀 수 있다. 노선 편집·시간·예측 계산 버튼은 외관 예시이며 게임에 연결하지 않는다.

- 최초3안: 생활 도시 / 철도 관제반 / 도시 계획 도면.
- 추가4안: 철도 모형 디오라마 / 역무실 업무 책상 / 레트로 PC 경영 / 공공교통 안내.
- 공통 P-A: S01→S02→S03→S04→S08→S12, 후보12, C/F/A=1000000·R/K/B=0. 1일06:00·정지.
- 열람기 원본 사본은 JSON 내부에 이스케이프해 넣고 srcdoc iframe으로 실행한다. 네트워크·외부 라이브러리·폰트 파일 없이 열린다.
- 원본은 채팅 호스트의 viz-carousel 전환·공통 버튼 스타일과 선택적 openai 상태 복원/저장·Tweak 배경 토글을 사용했다. 새 열람기는 자료/후보 선택과 최소 기본 스타일만 제공한다. openai/Tweak API를 구현하거나 외부 연결하지 않는다.
- 소스 기본 배경을 유지하며 Tweak 토글·채팅 선택 상태·과거 사용자 조작 이력은 복원하지 않는다. 당시 호스트의 폰트·스타일·레이아웃을 픽셀 단위로 완전 재현한다는 보장은 없다.
- 열람기는 자체 신뢰 원본만 내부 iframe에서 실행한다. 임의 파일/URL 입력·업로드 기능은 없다.
- 대표 PNG는 1200 CSS px·deviceScaleFactor1, 각 자료의 첫 후보·normal·정보 S03이다. 최초자료 PNG는 생활 도시, 추가자료 PNG는 디오라마다. 다른5개 후보·warning 장면은 HTML에서 열람한다.
- 시스템 글꼴의 실제 선택은 환경에 따라 다르다. 글꼴 가용성/배포·Godot 렌더링·최종 해상도·배율을 확정하지 않는다.

## 4. 승인·인수와 현재 상태의 분리

Owner의 **철도 모형 디오라마 MVP 방향 선택**과 **MVP 이후 UI 재배치·콘셉트 변경 가능성 유지**를 그대로 따른다. 최초 Design 권고가 생활 도시였다는 탐색 이력도 보존한다. 원본 보관이 과거 후보 평가·선택을 다시 시행하거나 최종 스타일을 변경하는 작업은 아니다.

과거 결과의 “HTML/PNG 공용 보관 미완료”와 “브라우저 렌더링 NOT_RUN”은 그때의 문서-only 제출 사실이다. 이번에 로컬 사본·새 열람기/캡처·실행 증거를 준비했지만 원격 공용 보관 완료·당시 QA 성공·S2-D01 실질 시각 비교의 공식 인수로 소급 처리하지 않는다.

최종 환경·글꼴·정밀 치수·최소창·배율·필터·배치·FPS·표현 상한은 FINAL_SPEC_PENDING이다. F08-01~04 실제 실험과 Owner 선택은 별도다. 게임 명세 변경 필요: NONE.
