# DEV-024 — Design 수용·DOC-01 HQ 인계용 요약

- 작성: Development / AGT-DEV-0004 / 2026-11-15 (Asia/Seoul).
- 상태: **LOCAL_REVIEW / OWNER_COPY_READY / NOT_SENT**. 아래 본문은 Owner가 로컬 검토 후 HQ에 복사·붙여넣기할 문안이다. HQ의 공식 인수표나 Owner 최종 결정 기록을 대신하지 않는다.
- 상세: [DEV 결과 §15](../tasks/DEV-024_RESULT.md), [DOC-01 정정문](DEV-024_DOC-01_PACKET_README_CORRECTION.md).

## 복사·붙여넣기 본문 시작

[DEV → HQ / DEV-024] VS-01 독립 GUI Design 수용 및 DOC-01 기록 정정 인계

Design Track A / AGT-DSG-0002가 **F1~F3 PASS·OBS-V05-01/V05-3 보완을 수용**했습니다. 기존 V01~V04·V05-1/2와 연결해 **합의된 DEV-024·VS-01 독립 GUI 검수 단계를 종료**했습니다. 추가 필수 GUI·제품 보완·증거 재공급 요청은 없습니다.

- 판정 정본: https://github.com/wisberry2022/MetroManager/issues/80#issuecomment-6890415230
- DSG-010 연결: https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6890437629
- PR #135: https://github.com/wisberry2022/MetroManager/pull/135
- 보완 시험 main: `324faf9b7d81540240217d2757f26de6f07460ba`.
- PR head: `f508d88281dc84b1a9d7e4399f5eba06a89d3ce6`. 2026-11-15 15:01:42 KST 병합 확인, head와 병합 main tree 동일.
- 필수 CI: [policy SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/43683416572/job/132718747793), [department-policy SUCCESS](https://github.com/wisberry2022/MetroManager/actions/runs/43683416561/job/132718749518). 위 PR head 기준이며 이번 후속 문서의 새 CI가 아닙니다.

**수용 증거와 계보**

기존 독립 자연 run `DEV024-IG-20261115-1115A`는 SHA `0865e5a2cdf168dac14167922c9e59b16796fa81`에서 V01~V04·V05-1/2가 수용됐습니다. 새 독립 보완 run `DEV024-V05-IG-20261115-1115B`는 위 병합 main에서 MODEL_CHAIN_SETUP 뒤 실제 입력으로 F1~F3를 검수했습니다. 새 SHA의 전체 자연 완주를 다시 실행했다는 뜻은 아닙니다.

재개 후 A36→B38→C40에서 표시 보고 QUERY accepted·즉시 P01/목록/refresh 포커스·추가 탐색0, 원래 P07 보고/포커스/scroll605 복귀, minute5760/효과 해시 불변이 수용됐습니다. 중단 중 입력7~25·캡처8~27·첫 QUERY는 주체/개입 NOT_VERIFIED로 제외했습니다. 기존 DEV 자동1185·프로젝트 로드·자체 GUI, 제출자 오프라인 감사130, Design 원본 심사, 이번 DEV 문서 정적 검사는 각각 별도입니다. Design은 새 GUI를 실행하지 않았습니다.

**DOC-01 — 원본 보존 방식의 기록 정정**

대상은 저장소 루트가 아닌 검수 패킷 README §2입니다. 외부 `v05r/packet/README.md` / 내부 정본 ZIP 루트 `README.md`의 “실제 PNG40개1100×900”을 아래 실측으로 정정해 연결합니다.

- 01~11 및28~40: **1100×900 24개**.
- 12~27: **2880×1659 16개**. 중단 중 구간으로 수용 근거에서 제외.
- raw viewport12~27=1152×663, 재개28~40=1152×942. 크기 변화 주체는 NOT_VERIFIED.
- 재개 후 수용28~40은 모두1100×900이므로 수용 영향·추가 GUI·새 ZIP 재제출 조건이 없습니다.

원본 외부 `v05r.zip`:13,831,128 bytes / SHA-256 `4f282f8561517b58b7dadb3b59b1e9bf7fc0a8bc925ce198cbc3da77512d4610`.
내부 `DEV-024-V05-INDEPENDENT-RETEST-20261115-1115B.zip`:6,937,676 bytes / SHA-256 `708c4f8df69109f0ec6c52d08eda367388d82d6b577237fa32340ac73fe1f12d`.

DEV는 원본을 읽어 ZIP·manifest·PNG 치수를 확인했고 원본230파일의 경로/크기/해시를 보존했습니다. 별도 정정문은 `docs/engineering/gate3/DEV-024_DOC-01_PACKET_README_CORRECTION.md` 로컬 검토안이며 아직 원격에 게시하지 않았습니다. **HQ/원본 보관·작성 담당은 위 정정 내용을 원본 README §2의 후속 기록으로 함께 보관·전달해 주세요.** 원본 ZIP/README를 덮어쓰거나 새 ZIP을 만들 필요는 없습니다. 원본의 당시 PENDING/FAIL/PARTIAL도 이력으로 남깁니다.

**HQ 인수표 연결 요청**

| 항목 | 연결 근거·판단 경계 |
| --- | --- |
| S2-08 실제 GUI | 기존 수용 + 이번 F1~F3 연결, V05-3 GUI 차단 해소 |
| S2-09 보고→공고 조회 | 원래 유효 보고/QUERY와 새 즉시 P01·보고 복귀·무효과 수용 연결 |
| S2-10 VS-01 | 원래 SHA 자연 완주 + 새 SHA 직접 영향 국소 보완으로 표기. 새 SHA의 전체 자연 재실행으로 승격하지 않음 |
| S2-11 교차 인수 | 기존/직접 영향 회귀·PR 필수 CI·부서 수용·DOC-01·미해결/이월을 HQ가 취합. Owner 최종 인수는 별도 |

HQ 인수표의 기존 NOT_RUN/PENDING은 당시 스냅샷으로 남기고 후속 수용을 연결해 주세요. DEV가 HQ 문서를 수정하거나 S2 전체 PASS를 선언하지 않았습니다.

**그대로 유지할 잔여**

A01-Q12 상위 PARTIAL, 중단 구간 주체/물리 신원·등록 Agent-ID/전체 console→GUI 연결/DPI·OS 배율/native 크기 NOT_VERIFIED를 유지합니다. 실제 process exit0·오류0과 EXIT PNG NOT_CAPTURED·runner requested_exit NOT_PROVIDED를 구분합니다. 기존1115A PROV-01·최초 콘솔/Q12 R02 종료 NOT_CAPTURED, 과거 환경/보조 도구 바이트·Q12 ERROR2→7 인계 정정 연결 NOT_VERIFIED, 실패/중단·UNKNOWN/NOT_RUN도 유지합니다.

기존 DEV-02324조건·Q03~05·W05/Q12 수용을 재개방하지 않습니다. 이번 새 자연 전체 완주·전체 게임 회귀·빌드/export/FPS·모든 키/배속/창 조합·빠른 별도 E2E·두 번째 수주/Track B는 NOT_RUN입니다. **DEV-026 구현·제품 검증 HOLD**와 Track B 별도 소유·승인을 유지합니다.

HQ가 최종 회귀/CI·부서 수용·잔여·정정을 취합한 뒤, Owner가 **DEV-024 전체 DONE·Issue 종료·Stage 인수**를 별도로 결정해 주세요. 이번 후속 문서는 로컬 검토안이며 새 Commit·Push·PR·main 병합·외부 게시를 수행하지 않았습니다.

## 복사·붙여넣기 본문 끝
