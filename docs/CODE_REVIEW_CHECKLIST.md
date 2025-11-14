# Flutter Code Review Checklist

> **목적**: Flutter 프로젝트의 코드 품질 보장 및 일관성 유지

---

## 🎯 레이아웃 & UI (Layout & UI)

### 오버플로우 방지 (Overflow Prevention)
- [ ] `Column`/`Row` 사용 시 스크롤 컨테이너(`SingleChildScrollView`, `ListView`) 검토
- [ ] `mainAxisAlignment.center` 사용 시 컨텐츠 높이가 화면의 **80% 이하**인지 확인
- [ ] 고정 높이(`height: xxx`) 사용 최소화, 동적 높이 선호
- [ ] `Flexible`, `Expanded` 적절히 사용하여 공간 분배

### 반응형 디자인 (Responsive Design)
- [ ] 다양한 화면 크기(작은 폰 ~ 태블릿)에서 테스트 완료
- [ ] `MediaQuery` 또는 `LayoutBuilder` 사용하여 화면 크기 감지
- [ ] `flutter_screenutil` 사용 시 일관성 있는 단위 사용 (`.w`, `.h`, `.sp`)
- [ ] 가로/세로 모드 모두 고려

### 접근성 (Accessibility)
- [ ] `Semantics` 위젯으로 스크린 리더 지원
- [ ] 충분한 터치 영역 크기 (최소 48x48 픽셀)
- [ ] 색상 대비 비율 준수 (WCAG 기준)
- [ ] 폰트 크기 확대 시 레이아웃 깨지지 않는지 확인

---

## 🏗️ 아키텍처 & 구조 (Architecture & Structure)

### 코드 구조 (Code Structure)
- [ ] 위젯을 작은 단위로 분리 (Single Responsibility Principle)
- [ ] `build()` 메서드가 200줄 이하인지 확인
- [ ] 재사용 가능한 위젯은 별도 파일로 분리
- [ ] 비즈니스 로직과 UI 분리 (MVVM, BLoC, Riverpod 등)

### 상태 관리 (State Management)
- [ ] 상태 관리 패턴 일관성 유지 (Provider, Riverpod, BLoC 등)
- [ ] `StatelessWidget` vs `StatefulWidget` 적절히 선택
- [ ] 불필요한 `setState()` 호출 방지 (성능 최적화)
- [ ] `const` 생성자 사용하여 재빌드 최소화

### 파일 조직 (File Organization)
- [ ] 명확한 폴더 구조 (`lib/presentation`, `lib/core`, `lib/domain` 등)
- [ ] 파일명은 snake_case 사용 (`home_page.dart`)
- [ ] 클래스명은 PascalCase 사용 (`HomePage`)
- [ ] Import 순서: Dart SDK → Flutter → 외부 패키지 → 내부 파일

---

## ⚡ 성능 & 최적화 (Performance & Optimization)

### 렌더링 최적화 (Rendering Optimization)
- [ ] `const` 생성자 최대한 사용
- [ ] 불필요한 `build()` 재호출 방지
- [ ] `ListView.builder()` 사용하여 긴 리스트 최적화
- [ ] 무거운 연산은 `compute()` 사용하여 백그라운드 처리

### 메모리 관리 (Memory Management)
- [ ] `dispose()` 메서드에서 리소스 해제 (Controller, Stream, Listener)
- [ ] 이미지 캐싱 전략 적용 (`CachedNetworkImage`)
- [ ] 큰 객체는 약한 참조 고려
- [ ] 메모리 누수 검사 (DevTools)

### 네트워크 최적화 (Network Optimization)
- [ ] API 호출 중복 방지 (캐싱, Debouncing)
- [ ] 에러 핸들링 및 재시도 로직 구현
- [ ] 로딩 상태 UI 제공
- [ ] 타임아웃 설정

---

## 🛡️ 안정성 & 에러 처리 (Stability & Error Handling)

### 에러 처리 (Error Handling)
- [ ] try-catch 블록으로 예외 처리
- [ ] 사용자 친화적인 에러 메시지 표시
- [ ] 에러 로깅 (Crashlytics, Sentry 등)
- [ ] Null Safety 준수 (`??`, `?.`, `!` 적절히 사용)

### 데이터 검증 (Data Validation)
- [ ] 사용자 입력 검증 (Form Validation)
- [ ] API 응답 데이터 검증
- [ ] Null 체크 철저히
- [ ] 엣지 케이스 처리 (빈 리스트, 네트워크 오류 등)

---

## 🧪 테스트 (Testing)

### 테스트 커버리지 (Test Coverage)
- [ ] Widget 테스트 작성 (주요 화면)
- [ ] Unit 테스트 작성 (비즈니스 로직)
- [ ] Integration 테스트 작성 (핵심 워크플로우)
- [ ] 오버플로우 검증 테스트 포함

### 테스트 품질 (Test Quality)
- [ ] 테스트가 독립적으로 실행 가능한가?
- [ ] 다양한 화면 크기에서 테스트 완료
- [ ] 엣지 케이스 테스트 포함
- [ ] Golden 테스트로 UI 회귀 방지 (선택 사항)

---

## 📝 코드 품질 (Code Quality)

### 가독성 (Readability)
- [ ] 명확한 변수/함수 이름 사용
- [ ] 주석으로 복잡한 로직 설명
- [ ] 매직 넘버 대신 상수 사용
- [ ] Dart 코드 포맷팅 준수 (`dart format .`)

### 일관성 (Consistency)
- [ ] 프로젝트 코딩 스타일 가이드 준수
- [ ] Lint 규칙 준수 (`flutter analyze`)
- [ ] Import 정리 및 미사용 import 제거
- [ ] 동일한 패턴 반복적으로 사용

### 문서화 (Documentation)
- [ ] 공개 API에 주석 작성 (`///` 사용)
- [ ] README.md 업데이트
- [ ] CHANGELOG.md 작성 (버전 변경 시)
- [ ] 복잡한 위젯은 사용 예시 제공

---

## 🔒 보안 (Security)

### 데이터 보안 (Data Security)
- [ ] API 키는 환경 변수로 관리 (`.env` 파일)
- [ ] 민감한 데이터는 암호화 저장
- [ ] HTTPS 사용 강제
- [ ] 로그에 민감한 정보 출력 금지

### 권한 관리 (Permission Management)
- [ ] 필요한 권한만 요청
- [ ] 권한 거부 시 대체 UI 제공
- [ ] 런타임 권한 체크 구현 (Android 6.0+)

---

## 🚀 배포 준비 (Deployment Readiness)

### 빌드 검증 (Build Verification)
- [ ] `flutter build apk --release` 성공
- [ ] `flutter build ios --release` 성공 (iOS)
- [ ] ProGuard 설정 (Android)
- [ ] 서명 키 관리 (Keystore)

### 성능 검증 (Performance Verification)
- [ ] 앱 시작 시간 측정
- [ ] 메모리 사용량 모니터링
- [ ] 배터리 소모 테스트
- [ ] FPS 60fps 유지 확인

### 최종 점검 (Final Check)
- [ ] 버전 번호 업데이트 (`pubspec.yaml`)
- [ ] 앱 아이콘 및 스플래시 스크린 검증
- [ ] 다국어 지원 검증 (해당 시)
- [ ] 오프라인 모드 동작 확인 (해당 시)

---

## 📋 체크리스트 사용 가이드

### PR (Pull Request) 생성 시
1. 위 체크리스트 항목을 PR 템플릿에 포함
2. 해당하는 항목에 체크 표시
3. 검토자는 체크되지 않은 항목 확인

### 코드 리뷰 시
1. 리뷰어는 체크리스트 기준으로 코드 검토
2. 미준수 항목은 코멘트로 피드백
3. 모든 항목 통과 후 승인

### 정기 점검 시
1. 주요 화면/기능에 대해 분기별 점검
2. 새로운 베스트 프랙티스 발견 시 체크리스트 업데이트
3. 팀 회고에서 체크리스트 개선 사항 논의

---

**최종 업데이트**: 2025-11-14
**버전**: 1.0.0
