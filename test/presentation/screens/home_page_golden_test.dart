import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_practice/l10n/app_localizations.dart';

import 'package:flutter_practice/presentation/screens/home_page.dart';

/// Golden tests for HomePage visual regression testing
///
/// Golden tests capture screenshots of widgets and compare them
/// against reference images to detect unintended visual changes.
///
/// To update golden files when intentional changes are made:
/// ```
/// flutter test --update-goldens
/// ```
void main() {
  group('HomePage Golden Tests', () {

    /// Helper function to create testable widget
    Widget createTestableWidget(Widget child) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
            ],
            locale: const Locale('en'), // Force English for consistent golden files
            home: child,
          );
        },
        child: child,
      );
    }

    testWidgets('HomePage renders correctly on iPhone SE',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomePage),
        matchesGoldenFile('goldens/home_page_iphone_se.png'),
      );

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('HomePage renders correctly on iPhone X',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomePage),
        matchesGoldenFile('goldens/home_page_iphone_x.png'),
      );

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('HomePage renders correctly on iPad',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(768, 1024));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomePage),
        matchesGoldenFile('goldens/home_page_ipad.png'),
      );

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('HomePage renders correctly in landscape mode',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(812, 375));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomePage),
        matchesGoldenFile('goldens/home_page_landscape.png'),
      );

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('HomePage counter incremented state',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Tap increment button 5 times
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();
      }

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomePage),
        matchesGoldenFile('goldens/home_page_counter_5.png'),
      );

      await tester.binding.setSurfaceSize(null);
    });

    /// Test scrolled state
    testWidgets('HomePage scrolled to bottom',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Scroll to bottom
      final scrollView = find.byType(SingleChildScrollView).first;
      await tester.drag(scrollView, const Offset(0, -1000));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomePage),
        matchesGoldenFile('goldens/home_page_scrolled.png'),
      );

      await tester.binding.setSurfaceSize(null);
    });
  });
}
