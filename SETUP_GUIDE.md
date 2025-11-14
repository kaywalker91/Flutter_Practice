# Flutter App Setup Guide

## 🎯 Overview

This Flutter app has been refactored to production-level quality with the following features:

- **flutter_screenutil**: Responsive UI with adaptive sizing
- **flutter_localizations**: Multi-language support (Korean, English, Japanese)
- **flutter_native_splash**: Native splash screens for iOS and Android

## 📦 Installation & Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Localization Files

The localization files will be generated automatically when you run the app. If you need to generate them manually:

```bash
flutter gen-l10n
```

Or simply run:

```bash
flutter pub get
```

### 3. Generate Native Splash Screens

To generate the native splash screens for iOS and Android:

```bash
flutter pub run flutter_native_splash:create
```

**Note**: You can customize the splash screen by editing `flutter_native_splash.yaml`:
- Add your logo image to `assets/images/splash_logo.png`
- Uncomment the `image` line in the yaml file
- Adjust colors and settings as needed
- Run the command again to regenerate

### 4. Run the App

```bash
flutter run
```

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart        # Color constants
│   │   ├── app_sizes.dart         # Size constants with ScreenUtil
│   │   └── app_text_styles.dart   # Text style constants
│   └── utils/
├── l10n/
│   ├── app_ko.arb                 # Korean translations (default)
│   ├── app_en.arb                 # English translations
│   └── app_ja.arb                 # Japanese translations
├── presentation/
│   ├── screens/
│   │   ├── home_page.dart         # Home page with counter
│   │   └── settings_page.dart     # Settings page (language/theme)
│   └── widgets/
│       └── responsive_builder.dart # Responsive layout widgets
└── main.dart                       # App entry point
```

## 🎨 Features

### 1. Responsive Sizing (flutter_screenutil)

All UI elements use responsive sizing:

```dart
// Width and Height
Container(
  width: 100.w,   // Responsive width
  height: 50.h,   // Responsive height
)

// Font Size
Text(
  'Hello',
  style: TextStyle(fontSize: 16.sp), // Responsive font size
)

// Border Radius
BorderRadius.circular(12.r)  // Responsive radius

// Screen dimensions
1.sw  // Screen width (0.0 - 1.0)
1.sh  // Screen height (0.0 - 1.0)
```

### 2. Multi-Language Support (flutter_localizations)

The app supports 3 languages:
- 🇰🇷 Korean (default)
- 🇺🇸 English
- 🇯🇵 Japanese

**Using Localization in Code**:

```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle)  // Returns localized text
```

**Adding New Translations**:
1. Add key-value pairs to all ARB files (`app_ko.arb`, `app_en.arb`, `app_ja.arb`)
2. Run `flutter pub get` to regenerate localization files
3. Use the new key in your code

### 3. Native Splash Screen (flutter_native_splash)

The app includes native splash screens for both iOS and Android with:
- Brand colors (light and dark mode)
- Android 12+ support
- Customizable logo and branding

**Customization**:
1. Edit `flutter_native_splash.yaml`
2. Add your logo to `assets/images/splash_logo.png`
3. Run `flutter pub run flutter_native_splash:create`

### 4. Responsive Layouts

The app includes responsive widgets for different screen sizes:

```dart
ResponsiveBuilder(
  mobile: MobileWidget(),    // < 600dp
  tablet: TabletWidget(),    // 600dp - 1024dp
  desktop: DesktopWidget(),  // > 1024dp
)

// Context extensions
if (context.isMobile) { /* mobile code */ }
if (context.isTablet) { /* tablet code */ }
if (context.isDesktop) { /* desktop code */ }
```

## 🎯 Design System

### Colors
- Primary: `#6750A4` (Purple)
- Background: `#FFFBFE` (Light), `#1C1B1F` (Dark)
- Text: `#1C1B1F` (Light), `#E6E1E5` (Dark)
- Semantic: Error, Success, Warning, Info

### Spacing Scale
- XS: 4dp
- SM: 8dp
- MD: 16dp (default)
- LG: 24dp
- XL: 32dp
- XXL: 48dp

### Typography
Material 3 typography scale:
- Display (Large, Medium, Small)
- Headline (Large, Medium, Small)
- Title (Large, Medium, Small)
- Body (Large, Medium, Small)
- Label (Large, Medium, Small)

### Breakpoints
- Mobile: < 600dp
- Tablet: 600dp - 1024dp
- Desktop: > 1024dp

## 🔧 Configuration

### ScreenUtil Setup (main.dart)

```dart
ScreenUtilInit(
  designSize: const Size(375, 812),  // iPhone X base size
  minTextAdapt: true,                // Auto text adaptation
  splitScreenMode: true,             // Split screen support
  builder: (context, child) {
    return MaterialApp(...);
  },
)
```

### Localization Setup (pubspec.yaml)

```yaml
flutter:
  generate: true  # Enable code generation

# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_ko.arb
output-localization-file: app_localizations.dart
```

## 🧪 Testing

### Run Tests

```bash
flutter test
```

### Test Different Screen Sizes

```bash
# iPhone SE (small screen)
flutter run -d "iPhone SE"

# iPad (tablet)
flutter run -d "iPad Pro"

# Custom device
flutter run -d "custom-device-id"
```

### Test Different Locales

Change your device/emulator language settings to test different locales, or use:

```dart
MaterialApp(
  locale: Locale('ja'),  // Force Japanese
  ...
)
```

## 📱 Platform-Specific Setup

### Android

Minimum SDK version is set in `android/app/build.gradle`:
```gradle
minSdkVersion 21  // Android 5.0+
```

### iOS

Minimum deployment target is set in `ios/Podfile`:
```ruby
platform :ios, '12.0'
```

## 🐛 Troubleshooting

### Localization Not Working
```bash
flutter clean
flutter pub get
flutter run
```

### Splash Screen Not Showing
```bash
flutter pub run flutter_native_splash:create
flutter clean
flutter run
```

### ScreenUtil Not Working
- Ensure `ScreenUtilInit` wraps `MaterialApp`
- Check that design size matches your design specs
- Restart the app (hot restart, not hot reload)

## 📚 Additional Resources

- [flutter_screenutil Documentation](https://pub.dev/packages/flutter_screenutil)
- [flutter_localizations Guide](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization)
- [flutter_native_splash Documentation](https://pub.dev/packages/flutter_native_splash)
- [Material 3 Design](https://m3.material.io/)

## 🚀 Next Steps

To fully productionize this app, consider adding:

1. **State Management**: Provider, Riverpod, Bloc, or GetX
2. **API Integration**: Dio, http with retry logic
3. **Local Storage**: SharedPreferences, Hive, or SQLite
4. **Error Handling**: Global error handling and logging
5. **Analytics**: Firebase Analytics or similar
6. **CI/CD**: Automated builds and deployments
7. **Testing**: Unit tests, widget tests, integration tests
8. **Performance Monitoring**: Firebase Performance or Sentry

## 📝 Notes

- The Settings page shows language/theme options but doesn't persist changes
- To implement persistent settings, add state management (Provider/Riverpod)
- The splash screen uses placeholder colors; customize in `flutter_native_splash.yaml`
- Add your app logo to `assets/images/` and update the configuration

---

**Happy Coding! 🎉**
