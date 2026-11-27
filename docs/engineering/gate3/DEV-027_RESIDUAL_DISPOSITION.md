# DEV-027 — K01 수용 후 공동 잔여 처분표

- 작성: Development / AGT-DEV-0004 / 2026-11-27 KST.
- 상태: LOCAL_REVIEW / A_B_DISPOSITION_REVIEW_PENDING / OVERALL_PARTIAL.
- 대상: 현재 W04B/DEV027 비의존 범위. DI03 포함 제품 전체·Stage 최종 완료와 구분한다.
- 기준: main b0447defe57abe173d10dcc05784f79313ff69ca / PR177. 기존 증거는 각 시험 SHA를 유지한다.
- 이 문서는 DEV의 공동 검토안이다. A/B의 실제 한정 수용을 연결하되 미확인 제외/후속 이관/최종 면제를 자체 승인하지 않는다.

## 1. 판정 출처와 식별

| 기호 | 근거·시험 식별 |
| --- | --- |
| A0 | [Track A 자연 VS02·UI행 수용](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075072443), 시험37596bd6d646f9d0454280477e60a2e652f06613 |
| B0 | [Track B 관측18행·PARTIAL2/NOT_RUN5](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7075447846), 시험37596bd |
| A1 | [Track A K01 수정본 수용·종료 조건](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7077287550), 시험b0447de |
| B1 | [Track B K01 재수용·F02~04 기대·종료 조건](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7077351699), 시험b0447de |
| D0 | [P3-B 자동/회귀·소스](../evidence/DEV-027_SCREEN_INTEGRATION_EVIDENCE.md) 및 [기존 GUI 매핑](../evidence/DEV-027_GUI_REVIEW_FOLLOWUP.md). 자동/fixture/OS를 구분 |
| D1 | [키보드/포커스 증거 §4·6·7](../evidence/DEV-027_KEYBOARD_FOCUS_EVIDENCE.md) 및 [원 JSON](../evidence/DEV-027_KEYBOARD_FOCUS_RESULTS.json). view-05-final737/0 및 followup819/0은 당시 실행 |
| N1 | [#92 공급 인계](https://github.com/wisberry2022/MetroManager/issues/92#issuecomment-7073024413). NR01~13·DA01~08 수신 완료, 실제 입력/규격 잔여 |

필수는 승인 범위에서 충족/처분해야 하는 동작을 뜻한다. 동일한 OS 시험을 추가 수행해야 한다는 뜻은 아니다. 자동 증거 재사용은 원 범위만 인정하며 OS 미관측은 그대로 남긴다. 아래 새 필수/대체 판단은 DEV 제안이며 공동 확인 전 승인 처분으로 쓰지 않는다.

## 2. 공동 잔여 처분표

| 조건/행 | 현재 판정·근거/SHA | 필수 여부·해소 방법 | 남은 필수 조건·차단 시점 | 후속 담당 |
| --- | --- | --- | --- | --- |
| UI01~03/L01·B01-01~05 | P3-A 공급·A0/B0의 선택/편집/예측/정보 읽기 관측 한정 수용.37596bd | 비의존 기능 필수, 기존 D0/수용 재사용. 실제 역명은 N1과 별도 | 현재 관측 수용 유지; 모든 Control/실제 이름 전체 PASS는 아님 | DEV 매핑, A 기능·B 표현 |
| UI04~07/L02~04·B02-01~03 | 시청/정부 요청·실제 접수·잠금·과거/현재 의미 수용.A0/B0 | 기존 기능/표시 근거 재사용. 의미 변화 없으면 반복 구현0 | 해당 필수 의미의 새 불일치 확인 없음 | DEV/A/B |
| UI08~10/L05~06·B03-01~04 | 허가/계약/지급·보류/설득·야간 접수대기 수용.A0/B0 및A1/B1 국소 보완 | 관측된 기능 필수 충족 근거 연결. A/B 실행 시각/설득 결과/지급 범위 분리 | 내부 exactly-once/RNG 전수는 아래 별도 | DEV/A/B |
| UI11/L07·B03-05 | DI03 미공급/재접수 제한 표시 수용.A0/B0 | 비의존 제한 표시는 재사용. 미공급을 적격 사실0건으로 바꾸지 않음 | UI12 실제 기능까지 완료 아님 | DEV/A/B |
| UI12/W4B-15~17·DI03 | 정책A1+B1 완료 / 실제 사건·동OD·수요carry·소비·성공 재접수 HOLD/NOT_RUN | 현재 비의존 범위 제외/보류라는 기존 Owner 경계 유지 | DI03 포함 제품 인수 전 구현/검증·수용 필요. 이번 비의존 착수 차단으로 확대0 | HQ/Owner, Planning/DEV/Design |
| UI13~14/L09·B05-01~04 | 동일 사업 P05→영업→첫 유효 일4 보고·후보 왕복.A0/B0 관측 수용 | 기존 자연 VS02/자동/QUERY 재사용 | 마지막 왕복 카운터·일1/경쟁·P07 일반/저장 구분은 별도. 전체 재완주0 | DEV/A/B |
| K01-12 편집·대기/심사중 skip | A1/B1의 지정 실제 Tab 경로 한정 수용.b0447de | 원 FAIL 보존 후 후속 수용 기록. 현재 지정 경로 추가 GUI 불필요 | 전체 키보드·모든 상태 인증 아님 | DEV 기록 / A/B 수용 완료 |
| K01-13 계약·K01-14 설득 | A1/B1 순수 키보드 접근·명시 입력 수용.b0447de | 지정 경로의 과거 NOT_VERIFIED 해소를 후속 추가. 허가·실제지급 분리 | 내부/모든 분기 수용으로 확대0 | DEV 기록 / A/B |
| K01-04 마지막 행 | A1/B1 S08→S12 마지막 행 전체 가시성·안정 수용.b0447de | 지정 잘림 PARTIAL 해소. 원본 보존 | 지원환경/장문 전체 인증과 별도 | DEV/B |
| 나머지 K01~12 필수 접근 묶음 | D1 합성 Tab/명령 근거와A0/B0/A1/B1 해당 OS 관측 | 기능 접근 계약 필수. 미관측 필수 Control은 실제 목록/근거로 대조하고 차이만 선정 | OS 전수 미확인을 일괄 FAIL로 만들지 않음. 필수 공백이 특정되면 해당 경로 수용 전 | DEV 목록 매핑 / A/B |
| P05 저장 복귀·안정 읽기 | A1/B1 관측 한정 수용.b0447de | 무입력 복원·완료 후 Home/End/휠·새Tab 수용 재사용 | F01/F04 경쟁 전체 해소는 아님 | DEV/B |
| F02 지연 ensure + 유효 읽기 키 | D1 구성요소 자동에서 새0/430 유지 | 기존 자동 재사용 + 공통 Host 변경 영향 회귀 | OS1frame 동기화 인증은 별도. 신규 결함으로 간주0 | DEV/B |
| F04 same-owner restore5행 | D1 실제0/430→저장215 덮임; B1 기대에 불일치 | 필수 보완 대상. [계획 §3~5](DEV-027_F04_RESTORE_PLAN.md)의 전후 검증 | 해당 복귀 동작 최종 수용 전 해결 또는 HQ/Owner 명시 범위 처분.819/0으로 상쇄0 | DEV 구현안 / B·A 수용 |
| F03/F04 휠6·return4 | D1 INCONCLUSIVE10 | §3에 각각 필수성/대체 가능성/전제 분류. 원판정 유지 | 필요한 유효 읽기 증거 또는 명시 처분 전 관련 최종 수용 대기; 전부 PASS/N/A 처리0 | DEV 전제 / B·A 충분성 |
| F01 OS RACE | A1/B1 안정 관측만,1~2frame 동기화 미입증 | 경쟁 계약은 필요. 정확한 OS 동기화 반복은 필수로 확정되지 않음. 결정적 자동부터 재사용 | 자동 충분성/최소 OS 영향행 공동 판단 전 RACE INCONCLUSIVE 유지 | DEV/B·A |
| F05/F06 다른 owner·화면 보호·Tab 재개 | D1 자동 및B0/A1/B1 안정 입력 수용 범위 | 변경 영향 회귀 필수. 기존 안전 보호 제거 금지 | 새 F04 수정이 기존 동작을 깨면 해당 행 보완 | DEV/B |
| B06-02 전체 포커스/읽기/복귀 | K01·안정 일부 수용 / F04·RACE 잔여 PARTIAL | 부분 해소를 기록하고 위F행의 최종 처분 연결 | 전체 해소·최종 수용 아직 아님 | B 주관 / DEV·A |
| 보조 Tab 제3안정 캡처 | B1 일부 PARTIAL, 핵심 결함 세트 확보 | 필요한 지속성 공백이 특정된 필수 경로만 보완 | 모든 Tab3장 전수 의무0, K01 수용 취소0 | A/B |
| 중복 효과·마지막 후보 왕복 카운터 | A0 마지막 종료 뒤 raw 카운터 NOT_VERIFIED; D0/D1 자동·QUERY 있음 | 후보 query_no_rng·읽기 snapshot·명령 검증 원범위 재사용 | 마지막시점 추가 OS 필수 여부 공동확인. 자동이 과거 raw를 생성하지 않음 | DEV/A |
| seed0/8/1 raw RNG·내부 exactly-once | A0/B1 OS 내부 전수 NOT_VERIFIED | 고정 엔진 RNG·멱등 자동과 명령1회/가시 효과 별도 매핑 | 특정 필드/시점이 필수일 때만 추가 수단. 분기 전체 E2E 반복0 | DEV/A |
| L08·B04-01~03 root/지역·scope·옛callback | D0/D1 자동/fixture 있음, 새 OS NOT_RUN | 유효성/수명 계약 필수, 기존 자동 원범위 재사용 | Host 수정의 scope/세대 회귀는 필요. 추가 OS 필수 필드 미특정 | DEV/B |
| L10·B02-04 유효0/실패 | D0 zero_is_number/failed_is_not_zero fixture, OS NOT_RUN | 표시 의미 기존 자동 재사용 | 실제 표현 변경/필수 OS 부족 특정 전 새 GUI 차단0 | DEV/B |
| B05-05 고정일1 비영점 중첩 복귀 | DEV026 기존 PARTIAL/미관측·B0 NOT_RUN | 일4 증거로 대체0. 현재 변경의 공유 복귀 영향은 자동 회귀로 점검 | 정확한 일1 OS 조건이 최종 필수인지 별도 처분. 조건 미충족을 삭제0 | DEV/B·HQ/Owner |
| B06-01/03·F08-01~04 | B0 관측 환경 한정 수용 / B1·N1 PARTIAL·FINAL_SPEC_PENDING | 실제 이름/PC/폰트·최종 규격 필요한 인수 단계에 공급/검증 또는 권한 있는 한정 처분 | 비의존 W04B 전체 차단으로 확대0. 전환경/배포 인증 전에는 잔여 적용 | HQ/Owner 공급조정 / DEV·A/B |
| 오류·원본/정정 신뢰성 | A1 GUI오류0, B1 cache ERROR실행별1/합계2, 과거실행별4 별도 | 원본·중복 집계·exit와ERROR 구분. 실제 관측을 막는 오류만 보완 | 원인/제품 연관·영구 해결 NOT_VERIFIED. 오류0으로 합산 대체0 | 실행자/DEV/Design |
| S3-10-C·S3-12/HQ·Owner | 최종 인수 대기 | 합의 범위의 필수 해결 또는 권한 있는 제외/이관 + A/B 판정·잔여 위험 인계 | PR/CI/이 문서만으로 Stage DONE·이슈/RFC 종료·릴리스 불가 | HQ/Owner |

## 3. INCONCLUSIVE10 — 행별 필수 여부와 최소 증거

현재 원 결과는10행 모두 INCONCLUSIVE다. 아래는 최종 처리 제안이며 A/B 확정/Owner 승인된 면제가 아니다. 읽기 계약에 해당하는 유효 사용자 이동의 보호는 필수지만, 입력이 실제로 성립하지 않은 특정 합성 시도 자체를 PASS로 만들 의무는 없다.

| 원 행 ID | 확인된 전제 부족 | 필수성 제안 | 최소 보완/재사용과 처분 경계 |
| --- | --- | --- | --- |
| F03:wheel_up:0:ensure | 유효P-A owner, 실제delta0;215→자동178 | ensure 전 유효 바깥휠 보호는 계약상 필요. 이 합성 시도의 재실행 자체는 대체 가능 | hit영역·전달/소비·실제delta/순서를 기존runner에서 확인. 안정 OS휠은 지연경쟁 증거 아님 |
| F03:wheel_down:0:ensure | 유효owner,delta0;215→178 | 위와 같음, 반대방향 경계 | 반대방향 실제 이동 확인. 손으로 scroll을 바꾼 결과는 휠 PASS 아님 |
| F04:wheel_up:0:restore | 유효owner,delta0;215 유지 | restore 전 유효휠 보호는 계약상 필요. 원probe 대체 가능 |5행 키검사는 휠 event경로를 대체하지 않음. 입력 전제 성립 여부부터 한정 확인 |
| F04:wheel_down:0:restore | 유효owner,delta0;215 유지 | 위와 같음, 반대방향 경계 | scroll 불변을 새 읽기 보존 성공으로 세지 않음 |
| F04:wheel_down:1:restore |1frame 후에도delta0 | restore 직전 유효 입력 보호의 경계 증거 필요 | 실제 처리시점이 입증된 대표 증거로 대체 가능 여부 B/A 확인. 시간만 기다린 반복0 |
| F04:wheel_down:3:restore | 복원 후delta0 | 안정 휠 읽기 계약은 필요; 지연경쟁 필수행은 아님 | A1/B1 안정 OS휠 수용을 원범위 재사용하는 안. 이 합성행 자체는 INCONCLUSIVE 보존 |
| F04:end:1:return_p05 | 실제복귀 예약 후 owner=null,delta0;뒤에462복원 | 해당 null구간은 same-owner 읽기 전제 비적용 후보. P05 복귀 계약은 필수 | null/비소비를 근거로 정확한 시점 N/A 제안 가능, 전체P05 면제 아님. 유효owner 획득 후 순서만 필요시 보완 |
| F04:wheel_down:1:return_p05 | owner=null,delta0;뒤에462복원 | 유효문맥 휠처리 여부 미입증. owner null만으로 휠 비적용 확정 불가 | 실제 소비/이동을 별도 확인. 키의 non-consume 결론을 휠에 전용0 |
| F04:end:1:return_p07 | owner=null,delta0;22→215복원 | 해당 null구간은 same-owner 키 기대 비적용 후보. 저장복귀 계약은 필수 | 기존 무입력복귀/새focus 보호 재사용 + 유효 입력구간 부족분만. 일반P07 재진입과 구별 |
| F04:wheel_down:1:return_p07 | owner=null,delta0;22→215복원 | 유효문맥 휠처리 여부 미입증. 특정probe 대체 가능 | 실제 hit/소비/delta와복귀순서 확인. 일1·일4·일반/저장 의미를 섞지 않음 |

DEV의 권고는 휠6행을 단순 비필수로 제외하지 않고, 복귀4행을 null==null이므로 same-owner 성공으로 세지 않는 것이다. 수정 착수안에서는10행의 전제를 기존runner로 확인하되, 새 계측/GUI/휠 제품 확장이 필요한 경우 최소 부족분과 권한을 별도 제시한다. 제품이 받아들이는 유효 읽기 경로의 미충족은 최종 동작 수용 전 해결/명시 처분이 필요하다. 기술적으로 비적용인 특정 시도와 승인된 범위 제외를 구별한다.

## 4. 다음 제출·공동 확인·최종 인수

1. DEV: K01 A/B 후속 기록과 본 표·F04 최소안을 로컬 검토 요청. 현재 단계.
2. Owner 승인 후 DEV: 계획의 최대10경로 안에서5행 수정·결정적 전후·10행 전제분류·공통 영향회귀/로드. 원본/정정·자동/fixture/OS 범위 보존.
3. A/B: 실제 필수 공백·대체 증거 충분성과 변경 영향만 검토. A 행동/사업 흐름, B RP/EX·읽기/수명/복귀 판정을 각각 연결. 필요한 국소 OS는 한 패킷으로 공유.
4. HQ/Owner: 최종 비의존 인수 범위와 실제 미해결 필수의 처분, F08/DI03 적용 시점 결정. 승인 없는 후속 이관으로 전체 PASS를 만들지 않음.

공수/일정은 NOT_ESTIMATED. 현재 신규 제품/검사·게임 자동·Godot 로드·GUI/플레이·빌드/export·성능·계측/반입·Git 제출은 NOT_RUN/미수행이다. 문서/해시 정적 확인은 [결과 §18](../tasks/DEV-027_RESULT.md)에 기록한다.

Agent-ID: AGT-DEV-0004
Task-ID: DEV-027


## 5. 승인된 F04 보완과10행 전제 확인 후속 — 2026-11-27

§2~4의 원판정/처분 제안은 보존한다. [실행 결과](../evidence/DEV-027_F04_RESTORE_RESULTS.json)의 동일 runner 전후209검사에서 F04 키5행+원위치 재이동1행은6실패→0실패다. DEV 자동 보완 완료이며 A/B 재수용은 PENDING이다. 기존 K01·안정 P05 수용을 취소하거나 새 수용으로 재작성하지 않는다.

| 원 INCONCLUSIVE 행 ID | 새 입력 전제·scroll(입력 전→직후→최종) | 필수 여부·현재 처분·담당 |
| --- | --- | --- |
| F03:wheel_up:0:ensure | 유효 동일owner, handled=true,215→110→110 | 유효 이동 보존 관측. B/A 자동 충분성 판정 대기. 과거 원판정은 보존 |
| F03:wheel_down:0:ensure | 유효 동일owner, handled=true,215→320→178 | 실제 필수 휠 보완1. DEV 최소안/Owner 별도 구현 승인, B 수용 |
| F04:wheel_up:0:restore | 유효 동일owner, handled=true,215→110→215 | 실제 필수 휠 보완2. 위와 같음 |
| F04:wheel_down:0:restore | 유효 동일owner, handled=true,215→320→215 | 실제 필수 휠 보완3. 위와 같음 |
| F04:wheel_down:1:restore | 유효 동일owner, handled=true,215→320→215 | 실제 필수 휠 보완4. 위와 같음 |
| F04:wheel_down:3:restore | 유효 동일owner, handled=true,215→320→320 | 복원 완료 후 안정 이동 보존 관측. 기존 OS 안정 수용과 범위를 구별하여 B/A 확인 |
| F04:end:1:return_p05 | owner=null, handled=false,0→0→462 | 해당 시점 키 경쟁 전제 미성립. 원 INCONCLUSIVE 보존·비적용/대체 충분성 제안은 B/A 확인. P05 전체 면제 아님 |
| F04:wheel_down:1:return_p05 | owner=null, handled=true,0→105→462 | 휠은 실제 이동 후 덮임. null만으로 비적용 불가. 입력 우선 기대/필수 적용 범위 B/A 확인 후 DEV·Owner 최소 보완 승인 |
| F04:end:1:return_p07 | owner=null, handled=false,22→22→215 | 해당 시점 키 경쟁 전제 미성립. 원 INCONCLUSIVE 보존. 저장 P07 전체 면제 아님 |
| F04:wheel_down:1:return_p07 | owner=null, handled=true,22→127→215 | 휠 이동 후 덮임. P07 일반 재진입과 저장 복귀·일1/일4 구분 유지. 위 null-owner 휠 판단 대기 |

따라서 “10행 전제 확인 완료”와 “10행 기능 수용 완료”는 다르다. 유효owner 휠4행은 관련 읽기 최종 수용을 차단하는 실제 보완이며, F04 키5행의 성공이나846개 단언 성공으로 상쇄하지 않는다. null-owner 휠2행은 적용 기대/필수 여부 판단 대기다. 나머지2개 보존 관측/2개 키 전제 미성립도 과거 상태를 PASS로 덮지 않는다.

[F04 계획 §9](DEV-027_F04_RESTORE_PLAN.md)에 정확한 추가 후보10경로와 승인 경계를 제시했다. 현재 독립 GUI·신규 Design 재수용·휠 제품 확장·원격 게시/제출은 미수행이다. DI03 HOLD, 기존 PARTIAL/미관측·F08 최종규격·S3-10-C/S3-12/HQ·Owner 최종 인수 대기는 유지한다.


## 6. 최신 회신 적용·제출 시점 상태 — 2026-11-27

[Track B B2](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7216115783), [Track A A2](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7216152833), [Planning P2](https://github.com/wisberry2022/MetroManager/issues/146#issuecomment-7216239510)를 제출 전 확인했다. B2는 유효 바깥휠 이동이면 owner=null에도 보호 계약이 적용된다고 명시한다. 새 자동 trace의 return_p05/return_p07 휠2행은 proposal 화면·동일 scope·generation3, handled=true, 각각0→105→462 및22→127→215다. 따라서 앞선 “적용 기대 판단 대기”는 당시 검토 기록으로 보존하고, 최신 계약에 따른 DEV 판단은 기존4행과 합친 **휠6행 실제 보완 잔여**로 갱신한다. 수정본 Design 수용은 별도다. 기대 재승인 요청은 없으며 기술 보완 범위의 Owner 승인만 남는다. End return2행의 정확한 null-owner 시점 비적용과 안정휠 재사용도 B2 원범위로 연결한다.

키5행의 전후 성공·공통 회귀/로드와 원 INCONCLUSIVE10을 보존한다. B2/A2는 신규 OS timing 인증·전체 자연VS02 반복을 종료 조건으로 요구하지 않는다. P2는 A1+B1 정책 해결과 DI03 실제 구현 HOLD를 구분한다. 이 제출은 게임/경제/시간/세이브 명세를 변경하지 않는다.

최종 분류: 키 F04 5행 DEV 자동 보완 완료/Design 대기; 휠6행 실제 보완 필요; 휠2행 이동 보존 관측(안정행은 기존 수용 재사용); End2행 해당 시점 전제 비적용, 원 INCONCLUSIVE 보존. 독립 GUI는 Owner 선택에 따라 Track A/B 대기다. 전체 PARTIAL·DI03 HOLD·F08/S3-12 최종 인수는 유지한다.
