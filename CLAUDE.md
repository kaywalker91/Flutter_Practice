# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**untitled1** is a Flutter application showcasing modern responsive UI patterns, multi-language support, and theme management using Riverpod state management.

**Flutter SDK**: Dart >=3.3.4 <4.0.0

## Essential Commands

### Development
```bash
# Install dependencies
flutter pub get

# Run the application
flutter run

# Run on specific device
flutter run -d <device_id>

# List available devices
flutter devices

# Hot reload (press 'r' in terminal while app is running)
# Hot restart (press 'R' in terminal)
```

### Building
```bash
# Build APK (Android)
flutter build apk --release

# Build App Bundle (Android)
flutter build appbundle --release

# Build iOS
flutter build ios --release

# Build for web
flutter build web
```

### Testing & Quality
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code for issues
flutter analyze

# Format code
dart format .

# Check for outdated packages
flutter pub outdated
```

### Maintenance
```bash
# Clean build artifacts (use when encountering build issues)
flutter clean
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Check Flutter installation
flutter doctor
```

## Architecture Overview

### State Management
Uses **Flutter Riverpod** (^2.5.1) for type-safe, compile-time state management.

**Key Providers**:
- `localeProvider`: Manages app language state with SharedPreferences persistence
- `themeProvider`: Manages theme mode (light/dark/system) with persistence
- `sharedPreferencesProvider`: Global SharedPreferences instance (overridden in main.dart)

**Provider Initialization**:
```dart
// In main.dart
runApp(
  ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: const MyApp(),
  ),
);
```

### Responsive UI System
Built on **flutter_screenutil** (^5.9.3) with adaptive design sizes for different device categories.

**Design Baselines**:
- **Phone**: 375×812 (iPhone X) - portrait, 812×375 - landscape
- **Tablet**: 768×1024 (iPad mini) - portrait, 1024×768 - landscape
- **Detection Threshold**: 600dp (Material Design standard)

**Adaptive Initialization**:
```dart
// In main.dart - _getAdaptiveDesignSize()
// Automatically adjusts design size based on device type and orientation
// Wrapped with OrientationBuilder for dynamic reinit on rotation
```

**Core Utilities** (`lib/core/utils/responsive_helper.dart`):
- Device detection: `isPhone()`, `isTablet()`, `isDesktop()`
- Adaptive values: `valueByDevice()`, `valueByWidth()`, `valueByOrientation()`
- Grid helpers: `getGridColumnCount()`, `getCustomGridColumnCount()`
- Spacing helpers: `getHorizontalPadding()`, `getVerticalPadding()`

**Responsive Widgets**:
- `ResponsiveLayout`: Device-specific layouts (mobile/tablet/desktop)
- `ResponsiveOrientationLayout`: Orientation-aware layouts (6 variants)
- `ResponsiveGrid`: Auto-adaptive grids with column count calculation
- `ResponsiveGridBuilder`: Infinite scrolling grid with device-adaptive columns

### Localization System
Uses Flutter's official **flutter_localizations** with code generation.

**Configuration** (`l10n.yaml`):
- ARB files location: `lib/l10n/`
- Template: `app_ko.arb`
- Generated file: `app_localizations.dart`

**Supported Languages**:
- English (en) - **default**
- Korean (ko)
- Japanese (ja)

**Localization Architecture**:
```
User changes language
  ↓
LocaleNotifier.setLocale(locale)
  ↓
1. Validates locale
2. Updates Riverpod state (triggers rebuild)
3. Persists to SharedPreferences
  ↓
MaterialApp rebuilds with new locale
```

**Usage**:
```dart
// In any widget
final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle)

// Change language
ref.read(localeProvider.notifier).setLocale(Locale('ko'));
```

### Theme System
Dual theme support (light/dark) with system-following capability.

**Theme Architecture**:
- Material 3 design system
- Custom color scheme in `lib/core/constants/app_colors.dart`
- Responsive text styles in `lib/core/constants/app_text_styles.dart`
- Design tokens in `lib/core/constants/app_sizes.dart`

**Theme Modes**:
- `ThemeMode.light`: Light theme
- `ThemeMode.dark`: Dark theme with explicit ColorScheme
- `ThemeMode.system`: Follows system setting (default)

**Dark Mode Colors**:
- Uses explicit dark color palette (not fromSeed)
- Flat card design with borders
- Increased contrast for readability

## Project Structure

```
lib/
├── main.dart                           # App entry point with adaptive ScreenUtil
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # Color palette (light/dark)
│   │   ├── app_sizes.dart             # Spacing, breakpoints, design tokens
│   │   └── app_text_styles.dart       # Typography system
│   ├── providers/
│   │   ├── locale_provider.dart       # Language state management
│   │   └── theme_provider.dart        # Theme state management
│   ├── services/
│   │   ├── locale_service.dart        # Locale persistence (SharedPreferences)
│   │   └── theme_service.dart         # Theme persistence (SharedPreferences)
│   ├── utils/
│   │   └── responsive_helper.dart     # Device detection & adaptive helpers
│   └── widgets/
│       ├── responsive_layout.dart     # Device-specific layout widgets
│       ├── responsive_grid.dart       # Adaptive grid layouts
│       └── responsive_builder.dart    # Responsive builder utilities
├── presentation/
│   ├── screens/
│   │   ├── home_page.dart             # Main screen with device info
│   │   ├── settings_page.dart         # Language & theme settings
│   │   └── responsive_demo_page.dart  # Responsive UI showcase
│   └── widgets/
│       └── responsive_builder.dart    # Custom responsive widgets
└── l10n/                              # Localization ARB files
    ├── app_en.arb                     # English translations
    ├── app_ko.arb                     # Korean translations
    └── app_ja.arb                     # Japanese translations
```

## Dependencies

### Core Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| flutter_riverpod | ^2.5.1 | State management |
| flutter_screenutil | ^5.9.3 | Responsive UI scaling |
| shared_preferences | ^2.2.3 | Local storage for settings |
| flutter_localizations | SDK | Internationalization support |
| intl | ^0.18.1 | Internationalization utilities |
| cupertino_icons | ^1.0.6 | iOS-style icons |

### Dev Dependencies
- **flutter_lints** (^3.0.0): Code quality and linting
- **flutter_native_splash** (^2.4.0): Native splash screen generator

## Key Features

### 1. Responsive Design
- Adaptive layouts for phones (< 600dp), tablets (600-1023dp), and desktops (≥ 1024dp)
- Orientation-aware design size switching
- Automatic grid column calculation
- Responsive spacing and typography

### 2. Multi-Language Support
- Instant language switching without restart
- Persistent language preference
- Type-safe localization with code generation
- Default language: English

### 3. Theme Management
- Light/dark mode with system following
- Material 3 design
- Persistent theme preference
- Custom color scheme with proper dark mode support

### 4. Type-Safe State Management
- Compile-time safety with Riverpod
- Automatic UI updates on state changes
- Clean separation of business logic
- Testable architecture

## Development Guidelines

### Adding New Language

1. Create ARB file: `lib/l10n/app_[locale].arb`
2. Add all translation keys from existing ARB files
3. Update `locale_service.dart` supported locales list
4. Add language option in `settings_page.dart`
5. Run `flutter pub get` to regenerate localization files

### Using Responsive Values

```dart
// Responsive sizing
Container(
  width: 300.w,      // 300 design units
  height: 200.h,     // 200 design units
  padding: EdgeInsets.all(16.w),
  child: Text(
    'Responsive Text',
    style: TextStyle(fontSize: 16.sp), // Responsive font size
  ),
)

// Device-specific values
final padding = ResponsiveHelper.valueByDevice(
  context,
  phone: 16.0,
  tablet: 24.0,
  desktop: 32.0,
);

// Adaptive grid
ResponsiveGridBuilder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
  // Auto columns: phone(2), tablet(3-4), desktop(4-6)
)
```

### Accessing State

```dart
// In ConsumerWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state (rebuilds on change)
    final locale = ref.watch(localeProvider);
    final theme = ref.watch(themeProvider);

    // Read state (no rebuild)
    final currentLocale = ref.read(localeProvider);

    // Update state
    ref.read(localeProvider.notifier).setLocale(Locale('ko'));
    ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);

    return Text('Current language: ${locale.languageCode}');
  }
}
```

### Creating Adaptive Layouts

```dart
// Device-specific layouts
ResponsiveLayout(
  mobile: MobileLayout(),
  tablet: TabletLayout(),    // Optional, falls back to mobile
  desktop: DesktopLayout(),  // Optional, falls back to tablet/mobile
)

// Orientation-specific layouts
ResponsiveOrientationLayout(
  mobilePortrait: MobilePortraitLayout(),
  mobileLandscape: MobileLandscapeLayout(),
  tabletPortrait: TabletPortraitLayout(),
  tabletLandscape: TabletLandscapeLayout(),
  // ... desktop variants
)
```

## Common Issues & Solutions

### Build Failures
```bash
# Universal fix for most issues
flutter clean
flutter pub get
flutter run
```

### Localization Not Updating
```bash
# Regenerate localization files
flutter pub get

# Verify ARB files have matching keys
# Check l10n.yaml configuration
```

### Responsive UI Issues
- Ensure `ScreenUtilInit` wraps MaterialApp in main.dart
- Verify `OrientationBuilder` is present for dynamic adaptation
- Check that responsive values use `.w`, `.h`, `.sp`, `.r` extensions
- Avoid hardcoded pixel values

### State Not Persisting
- Verify SharedPreferences initialization in main.dart
- Check that provider overrides are set correctly
- Ensure service layer save methods are called
- Test with `flutter run --verbose` for debug logs

## Testing Devices

Recommended test devices in Android Studio:
- **Phone Portrait**: Nexus 5X (1080×1920) or Pixel 4 (1080×2280)
- **Phone Landscape**: Same device rotated
- **Tablet Portrait**: Nexus 9 (2048×1536) or Pixel C (2560×1800)
- **Tablet Landscape**: Same device rotated

Test checklist:
- No overflow errors on any device
- Smooth orientation changes
- Grid columns adjust correctly (2/3/4/6 columns)
- Text sizes scale appropriately
- Language switching works instantly
- Theme changes apply immediately
- Settings persist across app restarts

## Documentation Files

- `RIVERPOD_IMPLEMENTATION.md`: Detailed Riverpod integration guide
- `RESPONSIVE_UI_IMPLEMENTATION.md`: Responsive system implementation details
- `QUICK_REFERENCE.md`: Quick reference for common patterns
- `SETUP_GUIDE.md`: Initial setup instructions
- `BEFORE_AFTER.md`: Before/after implementation comparison
