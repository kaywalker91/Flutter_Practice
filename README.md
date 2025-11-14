# Flutter Practice - Responsive UI & State Management

A comprehensive Flutter practice project showcasing modern responsive UI patterns, multi-language support, and state management using Riverpod.

[![Flutter](https://img.shields.io/badge/Flutter-3.3.4+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.3.4+-0175C2?logo=dart)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.5.1-blue)](https://riverpod.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Features

### 🎨 Responsive Design
- **Adaptive Layouts**: Automatically adjusts for phones, tablets, and desktops
- **Orientation Support**: Seamless portrait/landscape transitions
- **Device Detection**: Smart device type detection with custom breakpoints
- **Responsive Widgets**: Custom grid layouts with auto-column calculation
- **Screen Scaling**: flutter_screenutil for consistent UI across devices

### 🌍 Multi-Language Support
- **3 Languages**: English (default), Korean, Japanese
- **Hot Switching**: Instant language change without app restart
- **Type-Safe**: Code generation for compile-time safety
- **Persistent**: Language preference saved locally

### 🎭 Theme Management
- **Light/Dark Mode**: Full theme support with Material 3
- **System Following**: Auto-detect system theme preference
- **Custom Colors**: Carefully crafted color schemes for both themes
- **Persistent**: Theme preference saved across sessions

### ⚡ State Management
- **Riverpod**: Type-safe, compile-time state management
- **Auto Updates**: Reactive UI updates on state changes
- **Clean Architecture**: Separation of business logic and UI
- **Provider Pattern**: Scalable and testable architecture

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # Color palette (light/dark)
│   │   ├── app_sizes.dart             # Spacing & breakpoints
│   │   └── app_text_styles.dart       # Typography system
│   ├── providers/
│   │   ├── locale_provider.dart       # Language state
│   │   └── theme_provider.dart        # Theme state
│   ├── services/
│   │   ├── locale_service.dart        # Locale persistence
│   │   └── theme_service.dart         # Theme persistence
│   ├── utils/
│   │   └── responsive_helper.dart     # Device detection utilities
│   └── widgets/
│       ├── responsive_layout.dart     # Adaptive layout widgets
│       ├── responsive_grid.dart       # Responsive grids
│       └── responsive_builder.dart    # Builder utilities
├── presentation/
│   ├── screens/
│   │   ├── home_page.dart             # Main screen
│   │   ├── settings_page.dart         # Language & theme settings
│   │   └── responsive_demo_page.dart  # Responsive showcase
│   └── widgets/
│       └── responsive_builder.dart    # Custom widgets
└── l10n/                              # Localization files
    ├── app_en.arb                     # English
    ├── app_ko.arb                     # Korean
    └── app_ja.arb                     # Japanese
```

## Getting Started

### Prerequisites

- Flutter SDK: 3.3.4 or higher
- Dart SDK: 3.3.4 or higher

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/kaywalker91/Flutter_Practice.git
cd Flutter_Practice
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

## Key Technologies

| Package | Version | Purpose |
|---------|---------|---------|
| [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) | ^2.5.1 | State management |
| [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) | ^5.9.3 | Responsive UI scaling |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | ^2.2.3 | Local storage |
| [flutter_localizations](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization) | SDK | Internationalization |
| [intl](https://pub.dev/packages/intl) | ^0.18.1 | Formatting & localization |

## Usage Examples

### Responsive Sizing
```dart
// Responsive sizing with ScreenUtil
Container(
  width: 300.w,      // 300 design units
  height: 200.h,     // 200 design units
  padding: EdgeInsets.all(16.w),
  child: Text(
    'Responsive Text',
    style: TextStyle(fontSize: 16.sp),
  ),
)
```

### Device-Specific Layouts
```dart
// Different layouts for different devices
ResponsiveLayout(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

### State Management
```dart
// Watch and update state with Riverpod
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state (rebuilds on change)
    final locale = ref.watch(localeProvider);

    // Update state
    ref.read(localeProvider.notifier).setLocale(Locale('ko'));

    return Text('Language: ${locale.languageCode}');
  }
}
```

### Localization
```dart
// Access localized strings
final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle)
```

## Responsive Design System

### Device Breakpoints
- **Phone**: < 600dp (2 grid columns)
- **Tablet**: 600-1023dp (3-4 grid columns)
- **Desktop**: ≥ 1024dp (4-6 grid columns)

### Design Baselines
- **Phone Portrait**: 375×812 (iPhone X)
- **Phone Landscape**: 812×375
- **Tablet Portrait**: 768×1024 (iPad mini)
- **Tablet Landscape**: 1024×768

### Adaptive Features
- Auto-switching design size based on device type
- Orientation-aware layout changes
- Dynamic grid column calculation
- Responsive spacing and typography

## Building

### Android
```bash
# Debug APK
flutter build apk

# Release APK
flutter build apk --release

# App Bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web
```

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code
dart format .
```

## Documentation

For detailed implementation guides, see:
- `RIVERPOD_IMPLEMENTATION.md` - State management setup
- `RESPONSIVE_UI_IMPLEMENTATION.md` - Responsive system details
- `QUICK_REFERENCE.md` - Quick reference guide
- `CLAUDE.md` - Claude Code integration guide

## Learning Resources

This project demonstrates:
- Clean Architecture principles
- SOLID design patterns
- Responsive UI best practices
- Type-safe state management
- Internationalization workflows
- Theme customization
- Local data persistence

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [ScreenUtil Package](https://pub.dev/packages/flutter_screenutil)
- Material Design 3 Guidelines

## Contact

Created by [@kaywalker91](https://github.com/kaywalker91)

---

**Made with ❤️ using Flutter**
