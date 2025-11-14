# Flutter Layout Guidelines

> **목적**: 렌더링 오버플로우 방지 및 반응형 레이아웃 베스트 프랙티스

---

## 📌 핵심 원칙

### 1. **항상 스크롤 가능한 컨테이너 고려**

**문제 상황**:
```dart
// ❌ BAD: 고정 높이 컨텐츠를 Column에 직접 배치
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    LargeWidget1(),  // 높이 예측 불가
    LargeWidget2(),
    LargeWidget3(),
  ],
)
```

**해결 방법**:
```dart
// ✅ GOOD: SingleChildScrollView로 래핑
SafeArea(
  child: SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LargeWidget1(),
          LargeWidget2(),
          LargeWidget3(),
        ],
      ),
    ),
  ),
)
```

---

## 🚨 오버플로우 위험 시나리오

### 시나리오 1: 다양한 화면 크기
- **위험**: 작은 화면(iPhone SE, 소형 Android)에서 오버플로우
- **해결**: `SingleChildScrollView` 또는 `ListView` 사용

### 시나리오 2: 동적 컨텐츠
- **위험**: API에서 받은 데이터 크기에 따라 높이 변화
- **해결**: `Flexible`, `Expanded`, 또는 스크롤 컨테이너

### 시나리오 3: mainAxisAlignment.center 사용
- **위험**: 중앙 정렬 시 컨텐츠가 화면 높이를 초과하면 오버플로우
- **해결**:
  - `crossAxisAlignment.center`로 수평 중앙 정렬만 사용
  - 수직 중앙 정렬이 필요하면 `Spacer()` 사용

---

## ✅ 레이아웃 체크리스트

### 설계 단계
- [ ] 컨텐츠 총 높이가 화면 높이의 **80% 이하**인가?
- [ ] 동적 컨텐츠(API 데이터, 사용자 입력)가 포함되어 있는가?
- [ ] `Column`/`Row`가 고정 크기 부모 안에 있는가?

### 구현 단계
- [ ] `SingleChildScrollView` 또는 `ListView` 사용했는가?
- [ ] `SafeArea`로 시스템 UI 영역 보호했는가?
- [ ] `mainAxisAlignment.center` 사용 시 오버플로우 가능성 검토했는가?

### 테스트 단계
- [ ] 작은 화면(320x568)에서 테스트 완료
- [ ] 큰 화면(태블릿)에서 테스트 완료
- [ ] 가로/세로 모드 모두 테스트 완료
- [ ] Widget 테스트에 오버플로우 검증 포함

---

## 🎨 추천 레이아웃 패턴

### 패턴 1: 기본 스크롤 레이아웃
```dart
Scaffold(
  body: SafeArea(
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your widgets here
          ],
        ),
      ),
    ),
  ),
)
```

### 패턴 2: 리스트 기반 레이아웃
```dart
Scaffold(
  body: SafeArea(
    child: ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(16.0),
      children: [
        // Your widgets here
      ],
    ),
  ),
)
```

### 패턴 3: 빌더를 사용한 동적 리스트
```dart
Scaffold(
  body: SafeArea(
    child: ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemWidget(items[index]);
      },
    ),
  ),
)
```

### 패턴 4: 고정 헤더 + 스크롤 컨텐츠
```dart
Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        // 고정 헤더
        Container(
          height: 60,
          child: HeaderWidget(),
        ),
        // 스크롤 가능한 컨텐츠
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Your scrollable content
              ],
            ),
          ),
        ),
      ],
    ),
  ),
)
```

---

## 🔍 디버깅 가이드

### 오버플로우 에러 발생 시

1. **에러 메시지 확인**:
   ```
   A RenderFlex overflowed by XXX pixels on the bottom/right.
   ```

2. **원인 파악**:
   - 에러 메시지에서 파일명과 라인 번호 확인
   - 해당 위젯의 부모-자식 관계 분석

3. **해결 방법 적용**:
   - `SingleChildScrollView` 추가
   - `Flexible` 또는 `Expanded` 사용
   - 고정 높이를 동적 높이로 변경

4. **검증**:
   - Hot Reload (`r` 키)로 즉시 확인
   - 다양한 화면 크기에서 테스트

---

## 📱 반응형 디자인 권장사항

### 화면 크기별 대응

```dart
// 화면 크기에 따라 다른 레이아웃 사용
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else if (constraints.maxWidth < 1200) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  },
)
```

### 반응형 패딩/여백

```dart
// flutter_screenutil 사용 예시
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: 16.w,  // 화면 너비에 비례
    vertical: 8.h,     // 화면 높이에 비례
  ),
  child: YourWidget(),
)
```

---

## 🧪 테스트 전략

### 1. Widget 테스트
```dart
testWidgets('Layout should not overflow on small screens', (tester) async {
  await tester.binding.setSurfaceSize(Size(320, 568));
  await tester.pumpWidget(MaterialApp(home: YourPage()));
  expect(tester.takeException(), isNull);
});
```

### 2. 다양한 화면 크기 테스트
```dart
final testSizes = [
  Size(320, 568),  // iPhone SE
  Size(375, 812),  // iPhone X
  Size(768, 1024), // iPad
];

for (final size in testSizes) {
  testWidgets('renders on ${size.width}x${size.height}', (tester) async {
    await tester.binding.setSurfaceSize(size);
    await tester.pumpWidget(MaterialApp(home: YourPage()));
    expect(tester.takeException(), isNull);
  });
}
```

---

## 📚 참고 자료

- [Flutter Layout Cheat Sheet](https://medium.com/flutter-community/flutter-layout-cheat-sheet-5363348d037e)
- [Understanding Constraints](https://docs.flutter.dev/ui/layout/constraints)
- [Building Adaptive Apps](https://docs.flutter.dev/ui/layout/responsive-adaptive)

---

**최종 업데이트**: 2025-11-14
**버전**: 1.0.0
