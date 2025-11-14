# 테스트 실행 가이드 (Test Execution Guide)

> **목적**: 작성된 테스트를 실행하고 결과를 검증하는 방법 안내

---

## 📋 테스트 파일 목록

### 1. 오버플로우 방지 테스트
- **파일**: `test/presentation/screens/home_page_overflow_test.dart`
- **목적**: 다양한 화면 크기에서 오버플로우 발생 여부 검증
- **테스트 수**: 10개

### 2. 반응형 디자인 테스트
- **파일**: `test/presentation/screens/home_page_responsive_test.dart`
- **목적**: 12개 디바이스 크기 + 엣지 케이스 검증
- **테스트 수**: 30개 이상

### 3. Golden 테스트 (시각적 회귀 테스트)
- **파일**: `test/presentation/screens/home_page_golden_test.dart`
- **목적**: UI 시각적 변경 감지
- **테스트 수**: 6개

---

## 🚀 테스트 실행 명령어

### 모든 테스트 실행
```bash
flutter test
```

### 특정 테스트 파일만 실행
```bash
# 오버플로우 테스트만 실행
flutter test test/presentation/screens/home_page_overflow_test.dart

# 반응형 테스트만 실행
flutter test test/presentation/screens/home_page_responsive_test.dart

# Golden 테스트만 실행
flutter test test/presentation/screens/home_page_golden_test.dart
```

### 커버리지와 함께 테스트 실행
```bash
flutter test --coverage
```

커버리지 리포트 생성 (선택 사항):
```bash
# genhtml 설치 필요 (macOS/Linux)
brew install lcov  # macOS
sudo apt-get install lcov  # Linux

# 커버리지 HTML 리포트 생성
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # 리포트 열기
```

### Golden 파일 업데이트 (의도적인 UI 변경 시)
```bash
flutter test --update-goldens
```

⚠️ **주의**: `--update-goldens`는 UI가 의도적으로 변경되었을 때만 사용하세요!

---

## ✅ 테스트 성공 기준

### 1. 오버플로우 테스트
- [x] 모든 화면 크기에서 렌더링 오류 없음 (`tester.takeException() == null`)
- [x] `SingleChildScrollView` 존재 확인
- [x] `BouncingScrollPhysics` 적용 확인
- [x] `SafeArea` 존재 확인

### 2. 반응형 테스트
- [x] 12개 디바이스에서 렌더링 성공
- [x] 세로/가로 모드 모두 정상 작동
- [x] 엣지 케이스 처리 (매우 작은/큰 화면)
- [x] 빌드 시간 < 100ms

### 3. Golden 테스트
- [x] 스크린샷이 기준 이미지와 일치
- [x] UI 회귀(Regression) 없음

---

## 🐛 테스트 실패 시 대응 방법

### Case 1: "No such file or directory" 오류
**원인**: Golden 파일이 아직 생성되지 않음

**해결**:
```bash
flutter test --update-goldens
```

### Case 2: "RenderFlex overflowed" 여전히 발생
**원인**: 코드 변경이 핫 리로드로 적용되지 않음

**해결**:
```bash
# 앱 완전 재시작
flutter clean
flutter pub get
flutter run
```

### Case 3: Golden 테스트 실패 (이미지 불일치)
**원인**: UI가 변경됨

**확인 절차**:
1. 변경이 의도적인가?
   - **예**: `flutter test --update-goldens` 실행
   - **아니오**: 코드 변경 사항 되돌리기

2. 차이점 확인:
   ```bash
   # 실패한 golden 파일은 failures 폴더에 저장됨
   open test/presentation/screens/goldens/failures/
   ```

### Case 4: "ScreenUtil not initialized" 오류
**원인**: 테스트에서 `ScreenUtilInit` 래퍼 누락

**해결**: 테스트 파일에서 `createTestableWidget()` 사용 확인

---

## 📊 예상 테스트 결과

```
Running 46 tests...

✅ HomePage Overflow Tests
  ✅ should not overflow on small screen (iPhone SE)
  ✅ should not overflow on standard phone (iPhone X)
  ✅ should not overflow on large phone (Pixel XL)
  ✅ should not overflow on tablet (iPad)
  ✅ should be scrollable on small screens
  ✅ should contain all expected widgets
  ✅ counter should increment when FAB is tapped
  ✅ should render correctly in landscape mode
  ✅ should have SafeArea for system UI protection
  ✅ should handle rapid scrolling without errors

✅ HomePage Responsive Design Tests
  ✅ renders correctly on iPhone SE (Small)
  ✅ renders correctly on iPhone 8
  ✅ renders correctly on iPhone X
  ✅ renders correctly on iPhone 14 Pro Max
  ... (30+ tests)

✅ HomePage Golden Tests
  ✅ renders correctly on iPhone SE
  ✅ renders correctly on iPhone X
  ✅ renders correctly on iPad
  ✅ renders correctly in landscape mode
  ✅ counter incremented state
  ✅ scrolled to bottom

All tests passed! ✨
```

---

## 🔄 CI/CD 통합 (선택 사항)

### GitHub Actions 예시
```yaml
# .github/workflows/test.yml
name: Flutter Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.5.4'

    - name: Install dependencies
      run: flutter pub get

    - name: Run tests
      run: flutter test --coverage

    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        files: ./coverage/lcov.info
```

---

## 📈 테스트 메트릭 목표

| 항목 | 목표 | 현재 |
|-----|------|------|
| 테스트 커버리지 | ≥ 80% | - |
| 테스트 성공률 | 100% | - |
| 평균 테스트 시간 | < 30초 | - |
| Golden 테스트 일치율 | 100% | - |

---

## 🛠️ 트러블슈팅

### Q1. Golden 테스트가 로컬에서는 통과하는데 CI에서 실패
**A**: 폰트 렌더링 차이 때문일 수 있습니다.
- 해결: `flutter_test_config.dart` 파일에 폰트 설정 추가

### Q2. 테스트 실행 시 메모리 부족 오류
**A**: 테스트를 병렬로 실행하지 않도록 설정
```bash
flutter test --concurrency=1
```

### Q3. 특정 화면 크기에서만 테스트 실패
**A**: 해당 화면 크기에 대한 레이아웃 검토 필요
- `LayoutBuilder`를 사용하여 동적 레이아웃 적용

---

## 📚 참고 자료

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Golden Tests Guide](https://github.com/flutter/flutter/wiki/Writing-a-golden-file-test-for-package:flutter)
- [Test Coverage Best Practices](https://docs.flutter.dev/testing/code-coverage)

---

**최종 업데이트**: 2025-11-14
**버전**: 1.0.0
