# DEV-024 — DOC-01 검수 패킷 README §2 정정문

- Development / AGT-DEV-0004 / 2026-11-15 (Asia/Seoul).
- 상태: **LOCAL_REVIEW / GUI_NON_BLOCKING_CORRIGENDUM**. 별도 정정문 준비·원본 불변·외부 미전달.
- 작업 권한: [DEV-024 티켓 §11](../tasks/DEV-024_VS01_INTEGRATION_EVIDENCE.md).
- 정정 요청: [Design #80 정본](https://github.com/wisberry2022/MetroManager/issues/80#issuecomment-6890415230), [#81 연결](https://github.com/wisberry2022/MetroManager/issues/81#issuecomment-6890437629).

## 1. 적용 대상과 보존

대상은 `DEV024-V05-IG-20261115-1115B` 검수 패킷 **README.md §2**다. 저장소 루트 README가 아니다. 외부 묶음의 `v05r/packet/README.md`와 내부 정본 ZIP 루트의 `README.md`에 이 정정문을 연결한다.

| 원본 | bytes | SHA-256 |
| --- | --- | --- |
| `v05r.zip` | 13,831,128 | `4f282f8561517b58b7dadb3b59b1e9bf7fc0a8bc925ce198cbc3da77512d4610` |
| `DEV-024-V05-INDEPENDENT-RETEST-20261115-1115B.zip` | 6,937,676 | `708c4f8df69109f0ec6c52d08eda367388d82d6b577237fa32340ac73fe1f12d` |
| 원본 `README.md` | 원본 바이트 유지 | `6c266ad68240f134bd47d2d4c22239af7f3a61bee4fd7e9f856c44ec4e790e1c` |

원본 ZIP·추출 README·PNG·로그·manifest를 그대로 보존한다. 이 문서는 별도 정정문이며 원본 파일이나 SHA를 대체하지 않는다. 새 ZIP은 생성하지 않았다. 원본의 당시 Design PENDING/전체 PARTIAL도 이력이며 최신 판정은 위 Design 수용 댓글에 연결한다.

## 2. DOC-01 정정 내역

원본 §2의 `실제 PNG40개1100×900` 문구가 전체40장을 같은 크기로 일반화했다. 실제 PNG IHDR와 기존 `png-integrity.json`·`environment.json`·capture 로그는 아래 크기를 보존한다.

| 캡처 번호 | 실제 PNG 크기 | 개수 | 범위 |
| --- | --- | --- | --- |
| 01~11 및28~40 | 1100×900 | 24 | 재개 후 수용 범위28~40 포함. 이 행 전체를 모두 수용 근거로 주장하지 않음 |
| 12~27 | 2880×1659 | 16 | 중단 중 생성. F1~F3 수용 근거에서 제외 |

12~27의 raw viewport는1152×663, 재개28~40은1152×942다. 요청 해상도1100×900, runner root1100×900, raw viewport, PNG pixel, Computer Use 논리 캡처552×480은 서로 다른 값이다. 크기 변화의 실제 조작자 및 물리 DPI·OS 배율/native outer 크기는 **NOT_VERIFIED**로 유지한다.

원본 §2의 환경/크기 설명에 적용할 정정 문단:

> Godot 4.7.2-stable / Windows11 / D3D12 12_0 / Forward+ / Intel Iris Xe 환경입니다. 요청 해상도와 runner root는1100×900입니다. 실제 PNG40장은01~11 및28~40의1100×900 24장과12~27의2880×1659 16장으로 나뉩니다. raw viewport는12~27에서1152×663, 재개28~40에서1152×942입니다. Computer Use552×480 논리 캡처는 이 PNG pixel 값과 구분합니다. 중단 구간12~27은 F1~F3 수용 근거에서 제외하며 크기 변화의 조작자·물리 DPI·OS 배율/native outer 크기는 NOT_VERIFIED입니다.

## 3. 확인 방법과 원본 보존 증거

이번 DEV 작업은 원본을 읽어 두 ZIP의 크기/SHA-256·CRC, 내외부 정본 바이트, manifest221파일의 해시/크기, 추출 패킷222파일, PNG40개의 IHDR·기존 색인·환경·raw viewport를 대조했다. 실패0이다. 원본 묶음/추출물230파일의 작업 전후 경로·크기·SHA-256도 일치한다.

명령·로컬 감사 위치는 [결과서 §15.5](../tasks/DEV-024_RESULT.md)에 있다. 이는 문서 정정을 위한 읽기 검사이며 새 게임 실행·독립 GUI·Design 재심사·신원 인증이 아니다. Design의 소스125개 대조와 실행자의 tracked661개 무변경 보고를 이번 DEV 메타데이터 검사로 대체하지 않는다.

## 4. 수용 영향과 전달 상태

Design은 F1~F3 및 OBS-V05-01/V05-3를 수용하고 합의된 DEV-024·VS-01 독립 GUI 검수 단계를 종료했다. 수용에 사용한 재개 후28~40은 모두1100×900이므로 DOC-01은 수용 결과를 바꾸지 않는다. 제품 수정·추가 GUI·단계 재개방·새 ZIP 재제출이 필요하지 않다.

Owner 로컬 검토 후 원본 보관·작성 담당에게 이 정정문을 원본 README §2의 후속 기록으로 함께 보관/전달하도록 요청할 예정이다. [HQ 인계용 요약](DEV-024_DESIGN_ACCEPTANCE_HQ_HANDOFF.md)에 전달 문안을 포함했다. 현재 외부 게시·전달 및 원본 담당의 연결 완료는 미실행이다.

원본을 보존하는 본 정정문 방식으로 처리한다. 나중에 별도 정정 ZIP을 만들기로 결정할 경우에만 새 파일명/버전·SHA를 부여하며 기존 ZIP 해시를 소급 변경하지 않는다. A01-Q12 상위 PARTIAL·기존 미확인/미포착·HQ/Owner 최종 인수 판단은 별도이며 **DEV-026 구현·제품 검증 HOLD**다.
