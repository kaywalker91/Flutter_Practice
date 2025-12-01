import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_practice/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_sizes.dart';
import 'core/constants/app_text_styles.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'presentation/screens/home_page.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Note: Uncomment below lines when flutter_native_splash is fully configured
  // final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Perform any necessary initialization
  await _initializeApp();

  // Run app with ProviderScope for Riverpod
  // Override sharedPreferencesProvider with actual instance
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

/// Initialize app dependencies and services
Future<void> _initializeApp() async {
  // Add initialization logic here
  // For example: database, preferences, services, etc.
  await Future.delayed(const Duration(milliseconds: 500));

  // Remove splash screen after initialization
  // FlutterNativeSplash.remove();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch locale changes from Riverpod provider
    final locale = ref.watch(localeProvider);

    // Watch theme mode changes from Riverpod provider
    final themeMode = ref.watch(themeProvider);

    // ScreenUtilInit wraps MaterialApp for responsive sizing
    return ScreenUtilInit(
      // Design size based on iPhone X (375 x 812) - will be updated dynamically
      designSize: const Size(375, 812),
      // Enable automatic text size adaptation
      minTextAdapt: true,
      // Enable split screen mode support
      splitScreenMode: true,
      builder: (context, child) {
        return OrientationBuilder(
          builder: (context, orientation) {
            // Reinitialize ScreenUtil with adaptive design size based on device type and orientation
            ScreenUtil.init(
              context,
              designSize: _getAdaptiveDesignSize(context, orientation),
            );

            return MaterialApp(
              // Localization delegates - using generated list
              localizationsDelegates: AppLocalizations.localizationsDelegates,

              // Supported locales - using generated list
              supportedLocales: AppLocalizations.supportedLocales,

              // Current locale from Riverpod provider (default: English)
              locale: locale,

              // App title using localization
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,

              // Theme configuration
              theme: _buildLightTheme(),
              darkTheme: _buildDarkTheme(),
              themeMode: themeMode,
              // Dynamic theme mode from provider

              // Remove debug banner
              debugShowCheckedModeBanner: false,

              // Home page
              home: const HomePage(),
            );
          },
        );
      },
    );
  }

  /// Get adaptive design size based on device type and orientation
  ///
  /// Strategy:
  /// - Detects tablet vs phone using 600dp threshold (shortest side)
  /// - Returns appropriate design baseline for each form factor
  /// - Handles orientation changes dynamically
  ///
  /// Baseline sizes:
  /// - Phone portrait: 375x812 (iPhone X)
  /// - Phone landscape: 812x375 (iPhone X rotated)
  /// - Tablet portrait: 768x1024 (iPad mini)
  /// - Tablet landscape: 1024x768 (iPad mini rotated)
  Size _getAdaptiveDesignSize(BuildContext context, Orientation orientation) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;

    // Tablet detection threshold: 600dp (Material Design breakpoint)
    if (shortestSide >= 600) {
      // Tablet: Use iPad mini as baseline (768x1024)
      return orientation == Orientation.portrait
          ? const Size(768, 1024) // Tablet portrait
          : const Size(1024, 768); // Tablet landscape
    } else {
      // Phone: Use iPhone X as baseline (375x812)
      return orientation == Orientation.portrait
          ? const Size(375, 812) // Phone portrait
          : const Size(812, 375); // Phone landscape
    }
  }

  /// Build light theme with Material 3
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: AppTextStyles.titleLarge,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      cardTheme: CardThemeData(
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, AppSizes.buttonHeightLG),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMD,
          vertical: AppSizes.paddingMD,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }

  /// Build dark theme with Material 3
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      // 명시적 ColorScheme 정의 (fromSeed 대신)
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.primaryDarkMode,
        onPrimary: AppColors.textPrimaryDark,
        secondary: AppColors.secondaryDarkMode,
        onSecondary: AppColors.textPrimaryDark,
        surface: AppColors.backgroundDark,
        onSurface: AppColors.textPrimaryDark,
        error: AppColors.error,
        onError: AppColors.white,
        surfaceContainerHighest: AppColors.surfaceVariantDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
        outline: AppColors.borderDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0, // Flat design for dark mode
        color: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          side: const BorderSide(
            color: AppColors.borderDark,
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, AppSizes.buttonHeightLG),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantDark,
        // 더 밝은 배경
        hintStyle: const TextStyle(color: AppColors.textTertiaryDark),
        labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMD,
          vertical: AppSizes.paddingMD,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          borderSide:
              const BorderSide(color: AppColors.primaryDarkMode, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
