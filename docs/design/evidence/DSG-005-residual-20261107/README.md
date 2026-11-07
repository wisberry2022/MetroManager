# DSG-005 독립 QA 증거 제출

- 검증 SHA: `bc495d66e99414e6e734df45de283e5d186829c5`, Godot 4.7.2.stable.official.ed1daf0bf.
- 판정: **ACCEPTANCE_PENDING**. Design 권고이며 HQ/Owner Stage 승인이 아니다.
- `*.jpg`: 이번 실제 GUI 캡처 63장. `actual-inputs.json`, `input-supplement.txt`: 실제 입력 기록.
- `fixture-*`, `product-*`: 이번 fixture/제품 GUI 실행 명령과 로그.
- `prior/automatic`: 동일 SHA에서 앞서 실행한 902개 자동 단언 PASS. 이번 재실행 아님.
- `prior/gui`: 동일 SHA의 선행 DSG-QA-01·02 및 경계 검수 21장. 이번 재검수 아님.
- `<USER_HOME>`: 원래 로컬 계정 홈 경로를 치환한 공개 제출 별칭. 원본은 Owner 로컬에 보존했다.
- 로그의 command_id, revision, 게임분과 이미지 바이트는 보존했다. UTF-8 BOM/개행 및 로컬 경로만 정규화했다.
- 제품/fixture launcher, 패키징 스크립트, runtime/cache, 이전 대화·앱 진단 정보는 제출하지 않는다.
- `SHA256SUMS.txt`: 두 보고서와 공개 증거의 해시. 경로는 저장소 루트 기준.
- `DSG-005_RESIDUAL_QA_BUNDLE.zip`: 위 보고서·증거와 목록을 묶은 공개 전달본. 원래 로컬 ZIP과 내용/해시는 다르다.

## 보고서

- [잔여 QA 보고서](../../tasks/DSG-005_RESIDUAL_QA_REPORT.md)
- [HQ 인수 권고](../../tasks/DSG-005_HQ_ACCEPTANCE_RECOMMENDATION.md)
- [제출 및 승인 근거](../../tasks/DSG-005_QA_SUBMISSION.md)
