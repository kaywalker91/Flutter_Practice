# Quick Reference Guide

## 🚀 Essential Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Analyze code
flutter analyze

# Format code
dart format .

# Generate splash screens (after updating config)
flutter pub run flutter_native_splash:create

# Clean build (if issues occur)
flutter clean && flutter pub get && flutter run
```

## 📐 ScreenUtil Cheat Sheet

### Basic Usage
```dart
// Width and Height
width: 100.w     // Responsive width based on screen width
height: 50.h     // Responsive height based on screen height

// Font Size
fontSize: 16.sp  // Responsive font size

// Border Radius
radius: 12.r     // Responsive radius

// Screen dimensions
1.sw             // Full screen width (0.0 - 1.0)
1.sh             // Full screen height (0.0 - 1.0)
0.5.sw           // Half screen width
```

### Device Info
```dart
ScreenUtil().screenWidth          // Screen width in pixels
ScreenUtil().screenHeight         // Screen height in pixels
ScreenUtil().statusBarHeight      // Status bar height
ScreenUtil().bottomBarHeight      // Bottom navigation bar height
ScreenUtil().pixelRatio           // Device pixel ratio
ScreenUtil().textScaleFactor      // Text scale factor
ScreenUtil().orientation          // Portrait or Landscape
```

### Common Patterns
```dart
// Padding
padding: EdgeInsets.all(16.w)
padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)
padding: EdgeInsets.only(left: 16.w, top: 8.h)

// Sized Box
SizedBox(width: 16.w, height: 16.h)

// Container
Container(
  width: 100.w,
  height: 50.h,
  padding: EdgeInsets.all(16.w),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.r),
  ),
)
```

## 🌍 Localization Cheat Sheet

### Using Translations
```dart
// Get localization instance
final l10n = AppLocalizations.of(context)!;

// Use translated strings
Text(l10n.appTitle)
Text(l10n.welcomeMessage)
Text(l10n.counterDescription)

// In input decorations
decoration: InputDecoration(
  labelText: l10n.language,
  hintText: l10n.settings,
)
```

### Adding New Translations

1. **Add to all ARB files** (`app_ko.arb`, `app_en.arb`, `app_ja.arb`):

```json
{
  "newKey": "Translation text",
  "@newKey": {
    "description": "Description of what this text is for"
  }
}
```

2. **Run code generation**:
```bash
flutter pub get
```

3. **Use in code**:
```dart
Text(l10n.newKey)
```

### Common Translation Keys

| Key | Korean | English | Japanese |
|-----|--------|---------|----------|
| `appTitle` | Flutter 데모 | Flutter Demo | Flutterデモ |
| `settings` | 설정 | Settings | 設定 |
| `language` | 언어 | Language | 言語 |
| `theme` | 테마 | Theme | テーマ |

## 🎨 Design System Quick Reference

### Colors
```dart
// Import
import 'package:untitled1/core/constants/app_colors.dart';

// Usage
color: AppColors.primary
color: AppColors.background
color: AppColors.textPrimary
color: AppColors.error
color: AppColors.success
```

### Sizes
```dart
// Import
import 'package:untitled1/core/constants/app_sizes.dart';

// Spacing
SizedBox(height: AppSizes.spaceMD)     // 16dp
SizedBox(height: AppSizes.spaceLG)     // 24dp

// Padding
padding: EdgeInsets.all(AppSizes.paddingMD)  // 16dp

// Radius
BorderRadius.circular(AppSizes.radiusMD)     // 12dp

// Icons
Icon(Icons.star, size: AppSizes.iconMD)      // 24dp

// Buttons
height: AppSizes.buttonHeightLG              // 48dp
```

### Text Styles
```dart
// Import
import 'package:untitled1/core/constants/app_text_styles.dart';

// Usage
Text('Title', style: AppTextStyles.titleLarge)
Text('Body', style: AppTextStyles.bodyMedium)
Text('Label', style: AppTextStyles.labelSmall)

// With modifications
Text(
  'Custom',
  style: AppTextStyles.bodyLarge.copyWith(
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
  ),
)
```

## 📱 Responsive Widgets

### ResponsiveBuilder
```dart
ResponsiveBuilder(
  mobile: MobileWidget(),    // < 600dp
  tablet: TabletWidget(),    // 600dp - 1024dp
  desktop: DesktopWidget(),  // > 1024dp
)
```

### Context Extensions
```dart
if (context.isMobile) {
  // Mobile-specific code
}

if (context.isTablet) {
  // Tablet-specific code
}

if (context.isDesktop) {
  // Desktop-specific code
}

// Responsive value
final padding = context.responsiveValue(
  mobile: 16.w,
  tablet: 24.w,
  desktop: 32.w,
);
```

### ResponsivePadding
```dart
ResponsivePadding(
  mobilePadding: EdgeInsets.all(16.w),
  tabletPadding: EdgeInsets.all(24.w),
  desktopPadding: EdgeInsets.all(32.w),
  child: YourWidget(),
)
```

### ResponsiveContainer
```dart
ResponsiveContainer(
  mobileMaxWidth: null,      // No limit
  tabletMaxWidth: 800,       // Max 800dp
  desktopMaxWidth: 1200,     // Max 1200dp
  child: YourWidget(),
)
```

### ResponsiveGrid
```dart
ResponsiveGrid(
  mobileColumns: 1,
  tabletColumns: 2,
  desktopColumns: 3,
  spacing: 16,
  runSpacing: 16,
  children: [
    Card1(),
    Card2(),
    Card3(),
  ],
)
```

## 🎭 Theme & Dark Mode

### Accessing Theme
```dart
// Current theme
Theme.of(context).colorScheme.primary
Theme.of(context).textTheme.bodyLarge

// Brightness
final isDark = Theme.of(context).brightness == Brightness.dark;

if (isDark) {
  color: AppColors.textPrimaryDark
} else {
  color: AppColors.textPrimary
}
```

### Setting Theme Mode
```dart
// In MaterialApp (main.dart)
MaterialApp(
  theme: lightTheme,         // Light theme
  darkTheme: darkTheme,      // Dark theme
  themeMode: ThemeMode.system,  // Follow system
  // themeMode: ThemeMode.light,  // Always light
  // themeMode: ThemeMode.dark,   // Always dark
)
```

## 🖼️ Native Splash Screen

### Configuration File: `flutter_native_splash.yaml`

```yaml
flutter_native_splash:
  # Background colors
  color: "#6750A4"              # Light mode
  color_dark: "#4A3779"         # Dark mode

  # Logo image (uncomment to use)
  # image: assets/images/splash_logo.png
  # image_size: 200

  # Android 12+
  android_12:
    color: "#6750A4"
    color_dark: "#4A3779"
    icon_background_color: "#FFFFFF"
    icon_background_color_dark: "#1C1B1F"
```

### Generate Splash Screens
```bash
flutter pub run flutter_native_splash:create
```

### Remove Splash Screen (in code)
```dart
// Import
import 'package:flutter_native_splash/flutter_native_splash.dart';

// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Preserve splash
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsBinding.ensureInitialized()
  );

  // Your initialization
  await initializeApp();

  // Remove splash
  FlutterNativeSplash.remove();

  runApp(MyApp());
}
```

## 📂 Project Structure

```
lib/
├── core/                          # Core utilities
│   └── constants/                 # App-wide constants
│       ├── app_colors.dart        # Color palette
│       ├── app_sizes.dart         # Spacing, sizes
│       └── app_text_styles.dart   # Typography
├── l10n/                          # Localization
│   ├── app_ko.arb                 # Korean
│   ├── app_en.arb                 # English
│   └── app_ja.arb                 # Japanese
├── presentation/                  # UI Layer
│   ├── screens/                   # Page-level widgets
│   └── widgets/                   # Reusable widgets
└── main.dart                      # App entry
```

## 🔨 Common Tasks

### Add a New Screen
```dart
// 1. Create file in lib/presentation/screens/
// 2. Import dependencies
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 3. Use responsive sizing and localization
class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.screenTitle)),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.paddingMD),
        child: Text(
          l10n.screenContent,
          style: AppTextStyles.bodyLarge,
        ),
      ),
    );
  }
}
```

### Add a New Widget
```dart
// Use constants for consistency
Widget buildCard() {
  return Card(
    elevation: AppSizes.cardElevation,
    child: Padding(
      padding: EdgeInsets.all(AppSizes.paddingLG),
      child: Column(
        children: [
          Text('Title', style: AppTextStyles.titleMedium),
          SizedBox(height: AppSizes.spaceSM),
          Text('Body', style: AppTextStyles.bodyMedium),
        ],
      ),
    ),
  );
}
```

## 🐛 Troubleshooting

### App not showing translations
```bash
flutter clean
flutter pub get
flutter run
```

### ScreenUtil not working
- Ensure `ScreenUtilInit` wraps `MaterialApp`
- Check design size matches your specs
- Use hot restart (not hot reload)

### Splash screen not appearing
```bash
flutter pub run flutter_native_splash:create
flutter clean
flutter run
```

## 📚 Import Statements Template

```dart
// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Core
import 'package:untitled1/core/constants/app_colors.dart';
import 'package:untitled1/core/constants/app_sizes.dart';
import 'package:untitled1/core/constants/app_text_styles.dart';

// Widgets
import 'package:untitled1/presentation/widgets/responsive_builder.dart';
```

---

**Keep this guide handy for quick reference during development! 📌**
