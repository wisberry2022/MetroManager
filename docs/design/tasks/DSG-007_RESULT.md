# DSG-007 — MVP 디오라마 최소 디자인 시스템 본제작 결과

- Design / Track B / v0.1 / 2026-11-08
- 상태: REVIEW / DESIGN_REFERENCE_READY / OWNER_GIT_SUBMISSION_APPROVED / DEV_TECHNICAL_REVIEW_PENDING / NOT_DONE
- 기준 main: `c81b29585496fd291cfc4aeb443ed3e5ff14c588`
- 브랜치: `codex/DSG-007-mvp-design-system`
- Agent-ID: Track B 발급·등록 미확인. 기존 Track A `AGT-DSG-0001` 미승계.
- 근거: [승인 제안서](DSG-007_MVP_DESIGN_SYSTEM_PROPOSAL.md), [시스템 명세](DSG-007_MVP_DESIGN_SYSTEM.md), [상태표](DSG-007_COMPONENT_STATES.md), [DSG-006 결정](DSG-006_RESULT.md).

## 1. 병합 확인과 실행 범위

Owner는 본 Track B 세션에서 “PR #86과 #87의 main 병합을 승인합니다. 병합 후 승인된 범위에 따라 DSG-007 디자인 시스템 작업을 진행해주세요.”라고 지시했다. 조회 시 이미 두 PR의 `merged=true`를 확인했다. 동일 PR을 다시 병합하지 않았다.

| PR | 실제 병합 SHA | 확인 당시 최종 필수 CI |
| --- | --- | --- |
| [DSG-006 #86](https://github.com/wisberry2022/MetroManager/pull/86) | `1a5d0632711c1472e514ab19f04fe0b87b257ec1` | policy / department-policy success |
| [DSG-007 제안서 #87](https://github.com/wisberry2022/MetroManager/pull/87) | `c81b29585496fd291cfc4aeb443ed3e5ff14c588` | 갱신된 head `dc612688b15ceb3199b44f97f6b5e8a88e747e28`의 두 검사 success |

fetch 후 두 문서가 포함된 최신 main에서 독립 worktree를 만들었다. 공유 main 작업 디렉터리의 브랜치·파일은 변경하지 않았다. 승인된 DS-01~07의 명세·토큰·샘플·정적 인계본·결과를 작성하고 최초 보고 시에는 미커밋으로 보존했다.

후속 Owner는 2026-11-08 본 Track B 세션에서 “DSG-007 산출물 6개의 커밋·푸시 및 PR 생성을 승인합니다. 현재 작업 브랜치에서 제출하고, 미해결 기술 협의와 NOT_RUN 항목을 PR에 명시해주세요. main 병합은 하지 마세요.”라고 지시했다. 이 승인으로 현재 브랜치의 아래 6개 파일에 한해 정상 훅·검사·Commit·일반 Push·PR 제출을 진행한다. 공개 원문 URL은 제공되지 않았다. 정확한 제출 head·원격 CI는 제출 PR에 기록하며 main 병합·자동병합·릴리스는 수행하지 않는다. 기존 #86/#87 병합 승인과 신규 PR 제출·병합 권한을 혼용하지 않는다.

## 2. 변경 파일과 산출물

아래 디자인 소관 6개 파일을 새로 작성했다. 기존 제안서·다른 부서·게임 소스·씬·설정·정책·CI·등록부는 수정하지 않는다.

| 파일 | 용도·상태 |
| --- | --- |
| [DSG-007_MVP_DESIGN_SYSTEM.md](DSG-007_MVP_DESIGN_SYSTEM.md) | 표현 원칙·잠정 토큰·요소와 배치 분리·인계·F-08 질문 |
| [DSG-007_COMPONENT_STATES.md](DSG-007_COMPONENT_STATES.md) | C01~08, M01~02의 필수 정보·상태·경계·샘플 적용 수준 |
| [DSG-007_RESULT.md](DSG-007_RESULT.md) | 이번 실행·검증·미해결·수용 상태 |
| [mvp_design_tokens.json](../assets/source/dsg_007/mvp_design_tokens.json) | v0.1 역할별 색상·글자·간격·윤곽 가설. production_ready=false |
| [component_board.html](../assets/source/dsg_007/component_board.html) | 외부 의존성 없이 열리는 샘플 원본, 토큰 내부 사본 포함 |
| [component_board.png](../assets/exports/dsg_007/component_board.png) | 기본 장면·오른쪽 패널·배경 장식 켬·S03 정보 선택의 정적 인계본 |

PNG는 **1200×1982px / 144,580 bytes / 불투명 배경 / 정적 1장**이다. 크기는 이번 캡처의 결과이며 제품 해상도 규격이 아니다. 프레임·피벗·투명 컷아웃·게임용 스프라이트 용도는 없다. 샘플 HTML의 다른 상태·상호작용은 PNG에 포함되지 않는다.

| 원본·인계본 | SHA-256 |
| --- | --- |
| 토큰 JSON | `76622a91d56f1ef3a526c79b69b7870e4b924321a0e5061332c83eb4422bef2f` |
| 샘플 HTML | `54957e3a96fb1211731f31994de92245efeeb2d5a9239c8850c44abfc0f218a0` |
| 인계 PNG | `fd1b57d2ffe0ecfc55185abe1c9c9367abc3425df6bdb71b9580c652286878a0` |

소유 범위의 도형·텍스트·캔버스 표현을 사용했으며 제3자 이미지·라이브러리·폰트 바이너리는 포함하지 않는다. 시스템 글꼴 참조의 제품 배포/가용성 검토는 별도다. source→exports의 대응은 HTML 기본 장면→PNG이며 실제 게임 assets 적용은 NOT_CREATED다.

## 3. DS-01~07 및 수용 기준 추적

| 기준 | 이번 증거·판정 | 남은 범위 |
| --- | --- | --- |
| DS-01 / DS-AC-01 | 모형 도시 위계·2D 경계·가림 방지 원칙과 버전·잠정 상태 기록 / 문서 작성 완료 | 최종 도시·역 에셋 제작 별도 |
| DS-02 / DS-AC-02 | 역할별 토큰, 표제·기호·윤곽·상태 문구·포커스, 지정 색 쌍 대비 계산 / 정적 검토 PASS | 실제 게임·사용자 접근성 인수 아님 |
| DS-03~05 / DS-AC-03·04 | 공통 상태표·버튼·탭·목록·HUD·현재 자금·과거/현재 분리 예시, 12역·P-A 순서·정보 선택 일치 / 보드 범위 PASS | 역/간선 오류·대기/수락/전체 과거보고 연결은 명세·정적 예시, 게임 모델 미연결 |
| DS-06 / DS-AC-05 | 동일 요소 오른쪽/하단 재배치, ID·순서·자금·정보 선택 보존 / 브라우저 PASS | 최종 S01 배치 또는 향후 개편 구현 아님 |
| DS-06 / DS-AC-06 | 4개 폭, 긴 한국어 사유·15자리 금액 표시, 마커 구별·최소 대상·키보드·overflow 확인 / 보드 범위 PASS | 실제 Godot 밀집·글꼴·입력·접근성·성능은 NOT_RUN |
| DS-AC-07 | DEV 질문·F-08·미검증 책임 명시 / PARTIAL | DEV 기술 의견 미수신. 해당 수용 기준 전체 PASS 아님 |
| DS-07 / DS-AC-08 | 원본/PNG 크기·상태·해시·변경 영향·후속 부서 경계 추적 / 문서 작성 완료 | Owner 최종 결과 수용·실제 게임 인계/검수 PENDING |

디자인 참고 자료는 검토 가능하지만 모든 기준을 ACCEPTED/DONE으로 선언하지 않는다. MVP 이후 재배치·콘셉트 변경 가능성을 보존하며 현재 수치·색·폰트를 영구 제품 규격으로 확정하지 않는다.

## 4. 브라우저·시각 검증

실행 환경은 로컬 Windows Chrome headless CDP, 전용 제외 프로필, 외부 페이지·라이브러리 없음이다. 개인 브라우저 세션을 사용하지 않았다. 이 검증은 실제 Godot 제품이나 사용자 연구가 아니다.

로컬 제외 경로의 명령:

```powershell
.venv/Scripts/python.exe .local/dsg007/bake_board.py
node --check .local/dsg007/board_script.js
node .local/dsg007/check_board.cjs
```

- 토큰 내부 사본 동기화 및 JS 구문: PASS.
- 최종 브라우저 결과: **77 checks PASS / runtime exception 0**.
- 1200/760/375/320 CSS px × 오른쪽/하단 × 정상/잠금·조회실패: 가로 넘침 없음, 마커 각각 44px 이상·상호 겹침 없음, 고정 자금·노선 순서 유지, 올바른 상태 문구 확인.
- 후보 12개·고유 ID, 공식 P-A 순서, 재무 6계열 확인.
- 키보드 Enter로 S12 정보 선택→G04/D08 소속, 목록에서 S01 선택→지도 동일 대상, 재배치 후 정보 선택 유지 확인.
- 배경 장식 토글이 역/데이터를 제거하지 않음, 현재/과거 탭 분리·키보드 이동 확인.
- 320px에서 표시 전용 스트레스 값 `999,999,999,999,999`와 긴 한국어 사유를 임시 주입해 가로 넘침 없이 원문 값 보존 확인. 이 값은 게임 허용 금액·상한 또는 경제 fixture를 정의하지 않는다. 검사 후 기본 데이터로 복원했다.
- 기본 PNG와 경고/하단·좁은 폭 캡처를 열어 읽기·줄바꿈·선/역/패널 분리를 시각 확인했다. 한정 장면의 작성자 검토이며 외부 사용성 PASS가 아니다.

초기 검증 러너에서 Node 20의 WebSocket API 미지원과 headless 입력 포커스 미설정으로 실행/Enter 검사가 실패했다. 로컬 CDP 연결·포커스 설정을 보완하고 최종 파일로 재실행해 위 77개를 통과했다. 검증 우회나 게임 코드 변경은 없다. 러너·원시 검증 JSON·추가 QA 캡처는 `.local/dsg007/`에 보존하며 정식 산출물 6개에 포함하지 않는다. 다른 clone에는 이 로컬 보조 도구가 자동 제공되지 않는다.

## 5. 지정 색상 쌍의 대비 산술

토큰 RGB를 선형화해 상대 명도를 계산하고 `(밝은 명도+0.05)/(어두운 명도+0.05)`로 비교했다. 아래는 한정 색 쌍의 수학적 검토이며 접근성 표준 전체 인증·실제 가독성 합격이 아니다.

| 전경 / 배경 역할 | 비율 | 내부 잠정 목표 | 판정 |
| --- | ---: | ---: | --- |
| text_primary / surface_panel | 10.804 | 4.5 | PASS |
| text_secondary / surface_panel | 5.706 | 4.5 | PASS |
| action_on_primary / action_primary | 8.954 | 4.5 | PASS |
| warning_text / warning_surface | 7.411 | 4.5 | PASS |
| error_text / error_surface | 6.980 | 4.5 | PASS |
| disabled_text / disabled_surface | 5.612 | 4.5 | PASS |
| info_text / info_surface | 7.796 | 4.5 | PASS |
| focus_ring / map_ground | 4.637 | 3.0 | PASS |
| map_candidate_edge / map_ground | 3.663 | 3.0 | PASS |

폰트 크기·굵기·안티앨리어싱·색각·디스플레이·최종 배율·지도 장식 위의 모든 조합을 검증한 것은 아니다. 토큰 변경 시 사용 쌍과 실제 화면을 다시 확인한다.

## 6. 저장소 검증과 실행 수준

| 구분 | 결과 |
| --- | --- |
| worktree doctor / policy check | `.venv/Scripts/python.exe tools/policy.py doctor` PASS / `check` PASS (`worktree files=467, GDScript=31`, formatter/linter 정상) |
| UTF-8/LF·상대 링크·JSON/내부 토큰 일치·파일 경로/해시·PNG 크기·git diff --check | `.venv/Scripts/python.exe .local/dsg007/check_package.py` PASS — 정확한 신규 6파일·기존 추적 파일 무변경·오프라인 의존성·위 77검사 및 9대비 쌍 확인. `git diff --check` PASS |
| 새 본제작 Commit·Push·PR·원격 CI | Owner 개별 승인 수신. fetch·Commit 후 `policy.py preflight`, 제출 head·정상 pre-commit/commit-msg/pre-push 및 실제 원격 policy/department-policy 결과를 제출 PR에 기록. main 병합은 수행하지 않음 |
| 자동 게임 테스트 | NOT_RUN — 디자인 참고 자료, 게임 변경 없음 |
| Godot 프로젝트 로드 | NOT_RUN — 소스/씬/설정 변경 없음 |
| 게임 플레이 | NOT_RUN — 브라우저 보드는 게임 미연결 |
| Windows 빌드 | NOT_RUN — 게임 적용·릴리스 범위 밖 |
| 타깃 PC 성능·외부 사용자/접근성 실측 | NOT_RUN — F-08·후속 검증 필요 |

## 7. 미해결·인계·명세 변경

- DEV 기술 의견·F-08: 한글 폰트/배율/렌더링, 실제 밀집·클릭, 재사용·임포트, 측정 장면은 질문안으로 정리했으며 미발송·미수신이다. 규격 종속 최종 제작·제품 성능 인수 전에 협의한다.
- Track B Agent-ID 발급·등록은 미확인이다. 등록부·타 세션 ID를 변경하거나 신원을 자체 확정하지 않는다.
- DSG-006 채팅 시각 원본의 공용 보관 문제는 이번 DSG-007 보드 작성으로 소급 해소하지 않는다.
- 후속 DSG-008 최종 화면, DSG-009 대량 에셋, 별도 DEV의 실제 Godot 적용·Design 실제 검수, Owner 결과 수용은 각각 별도 책임이다.
- 새로운 게임 규칙·승인 의미·부서 범위 변경 필요는 NONE이다. 디자인 표현과 잠정값을 기록했으며 새로운 정책 충돌은 발견하지 못했다. 충돌 발견 시 해당 항목의 RFC로 보고한다.
- REVIEW 상태이며 S2-D01·DSG-007·Stage 2 공식 DONE 또는 게임 적용 완료를 선언하지 않는다.
