# PM-014 — Gate 3-2 Stage 2 공식 실행 계획 제출

- HQ / Project Manager / 2026-11-08 (Asia/Seoul); 상태 REVIEW. 계획 구성은 OWNER_APPROVED, 본 문서 PR main 병합은 별도 승인 대기.
- 저장소: wisberry2022/MetroManager. base main: `626a870d80fb4b68af8fbadb7db876ffacc95120`; 브랜치: `codex/PM-014-stage2-vs01-plan`.
- 승인 출처: [HQ(PM) 대화](https://chatgpt.com/c/6ae545e7-5c98-83e8-86fd-15b5854397b2)의 계획/Track B 검토 및 “해당 구성을 승인합니다 … 계획서에 해당 내용을 반영하여, 원격 저장소에 PR을 생성해주세요”. 현재 Codex 직접 요청에서 문서 작성·Commit·작업 브랜치 Push·base main PR 생성·CI 확인을 명시 승인했다.
- 유효 범위/종료: 이번 PM-014 HQ 3파일 제출·검증과 같은 범위 검수 대응까지. 다른 부서/향후 티켓으로 승계하지 않는다.
- 허용 파일: 본 티켓, [실행 계획](../PM-014_STAGE2_VS01_EXECUTION_PLAN.md), [결과](PM-014_RESULT.md). HQ Markdown 신규 3개만.
- 포함: 원문 S2-01~11/F-01~12·책임/차단/AC·VP·티켓 가이드 보존, 필수 Track A와 병렬·비차단 Track B/S2-D01·우선순위·인수/선택 분리 반영.
- 금지: 타 부서 파일·게임 코드·정책/CI 원본 수정, 신규 개발/아트 제작 실행, Issue 변경, main 직접 쓰기/병합·릴리스·배포·Stage 2 DONE 선언.
- 소관 기준 직접 확인: 최신 main AGENTS, HQ README, DEPARTMENT_WORKFLOW, CODE_CONVENTIONS, GIT_WORKFLOW, ENFORCEMENT, GITHUB_SUBMISSION, HQ_OPERATING_RULES, PM-008/GIT, PM-011 승인 계획/실행 지침, PM-012/013 인수·종료/결과, DEV-006 WBS/UI 계약과 Gate 2 C v0.6/D v0.9/DATA v1.3.
- 중복: main 전체 파일/텍스트 및 원격 PM-014 제목 한정 PR·Issue, PM-014 브랜치·Stage 2 유사 기록 확인. 기존 Stage 1 기록과 Stage 2 언급은 후속 의무/초안이며 PM-014 공식 계획 중복 없음.
- 제출 방식: 별도 worktree에 개별 파일 작성·정적/정책 확인 후 GitHub API 작업 브랜치에 명시적으로 게시한다. API는 로컬 훅을 실행하지 않으며 부모1개·경로·메시지/티켓·최신 main·필수 원격 CI를 별도 확인한다.
- 역할 표기는 HQ/PM 연속 업무 문맥이다. Agent-ID는 기존 등록부 AGT-PM-0001의 역할 연결 참고이며 별도 기술 신원 인증·등록/권한 변경은 수행하지 않는다.

## 수용 기준

1. Track A B01 공고→낙찰→표준 공사→시범/안전→실제 운행/첫 유효 일일보고→다음 사업의 실GUI 인수와 회귀/교차 검수 책임이 연결된다.
2. S2-01~11 보존, S2-D01 독립 진행·인수/Owner 콘셉트 선택 분리, F-06/08·DSG-007~009 별도 승인과 최종 에셋 비범위를 기록한다.
3. VP-01 자체제안/VP-02 공공입찰 구분, 전체 MVP 최종 AC/VP와 Stage 결과 구분, 티켓별 제작/Git·Owner 병합 권한을 유지한다.
4. HQ 3파일의 UTF-8/LF·참조·범위·정책 결과, 원격 PR/head SHA/실제 변경 파일·필수 CI와 NOT_RUN을 보고한다.

권한 확인은 현재 직접 지시에 근거하며 검사 PASS를 승인으로 간주하지 않는다.
