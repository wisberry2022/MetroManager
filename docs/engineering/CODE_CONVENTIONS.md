# 코드 컨벤션 v1.0

- 작업: DEV-002 / 작성: Convention Team / 날짜: 2026-10-31
- 상태: REVIEW. Owner가 부여한 코드 컨벤션 결정·운영 업무의 구현 결과이며 최종 검수·DONE은 아님.
- 적용: 새로 작성하거나 수정하는 코드. 기획·디자인 명세 및 Godot 버전을 변경하지 않는다.

## 기준과 자동 검사

Godot 공식 GDScript 스타일을 기본으로 하며, `gdtoolkit==4.5.0`의 `gdformat --check`와 `gdlint` 기본 설정을 자동 기준으로 사용한다. 검사 도구 업그레이드는 별도 작업으로 버전·출력 변화와 프로젝트 호환성을 검증한다. Godot 4.7.2 엔진 검증을 도구의 문법 파싱으로 대체하지 않는다. 현재 게임 코드는 없으며 최신 엔진 문법과 gdtoolkit 간 차이가 발생하면 RFC로 처리한다.

- UTF-8(BOM 없음), LF, 마지막 개행. GDScript 들여쓰기는 탭, 한 줄 최대 100자.
- `.gd` 파일·함수·변수·신호: `snake_case`. 클래스·노드 이름: `PascalCase`. 상수·열거 값: `UPPER_SNAKE_CASE`. 내부 멤버는 `_` 접두어.
- 클래스 내부 순서: `@tool` 등 클래스 지시문 → `class_name` → `extends` → 문서 → signal → enum → const → static 변수 → export 변수 → 일반 변수 → onready 변수 → 엔진 콜백 → 공개 함수 → 내부 함수. gdtoolkit이 지원하는 순서를 우선한다.
- 함수 사이 빈 줄 2개. 포매터를 사용하고 임의의 스타일 억제 주석으로 검사를 피하지 않는다.
- 파일은 책임 하나를 중심으로 작성한다. 범용 프레임워크, Autoload, 전역 상태를 필요 없이 추가하지 않는다.
- 함수 인수·반환값과 공개 데이터에는 타입을 명시한다. 값으로 명확한 지역 변수는 `:=`를 사용한다. 동적 Variant가 꼭 필요하면 이유를 설명한다.
- `class_name`은 다른 코드에서 참조할 타입에 사용한다. 외부 노드 접근은 명시적 참조·신호를 사용하고, 불안정한 부모 탐색·문자열 경로 의존성을 늘리지 않는다.
- 경제·시간·세이브·난수 정책은 승인 명세를 따른다. 스타일 정리를 이유로 게임 동작이나 데이터 형식을 바꾸지 않는다.
- 주석은 의도·제약을 설명한다. 공개 API는 `##` 문서를 사용한다. 식별자는 영어, 설명은 한국어 허용.
- 씬·리소스·소스 에셋은 Git으로 관리하고 `.godot/`·빌드 출력은 제외한다. Godot가 생성한 UID 파일은 소스와 함께 보존한다. 에셋 이름·경로 변경 시 참조를 검증한다.
- 제3자 코드는 출처·라이선스·버전을 기록한다. 검사 제외가 필요하면 명시적인 경로와 사유로 RFC를 제출한다.

## 검사와 사람이 검토할 부분

`policy.py`는 파일 이름·기초 텍스트 규칙·formatter/linter 결과를 검사한다. 타입의 설계 적절성, 책임 분리, 성능, 명세 준수, 승인 진위는 Project Leader/Owner가 검토한다. 자동 검사 범위를 모든 컨벤션의 완전 강제로 표현하지 않는다.

```powershell
.venv/Scripts/python.exe tools/policy.py check
.venv/Scripts/gdformat.exe scripts/example.gd
```

두 번째 명령은 실제 코드가 생긴 뒤 지정 파일에만 사용한다. 기능 변경에는 관련 경계 사례 테스트, 프로젝트 로드, 필요 시 플레이·빌드를 구분하여 결과를 남긴다. 미실행은 NOT_RUN으로 보고한다.

## 근거

- [Godot 공식 GDScript 스타일](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [gdtoolkit 원본 프로젝트](https://github.com/Scony/godot-gdscript-toolkit)

2026-10-31 확인. 상기 규칙 중 타입 의무·프로젝트 책임 구분은 프로젝트 자체 결정이다.
