import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:untitled1/presentation/screens/home_page.dart';

/// Widget tests for HomePage overflow prevention
///
/// These tests verify that the HomePage does not overflow
/// on various screen sizes, preventing rendering errors.
void main() {
  group('HomePage Overflow Tests', () {

    /// Helper function to create testable widget with ScreenUtil
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
              Locale('ko'),
            ],
            home: child,
          );
        },
        child: child,
      );
    }

    testWidgets('HomePage should not overflow on small screen (iPhone SE)',
        (WidgetTester tester) async {
      // Simulate iPhone SE screen size (smallest common iOS device)
      await tester.binding.setSurfaceSize(const Size(320, 568));

      // Build HomePage
      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Verify no rendering exceptions occurred
      expect(tester.takeException(), isNull,
          reason: 'No overflow errors should occur on small screens');

      // Cleanup
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('HomePage should not overflow on standard phone (iPhone X)',
        (WidgetTester tester) async {
      // Simulate iPhone X screen size
      await tester.binding.setSurfaceSize(const Size(375, 812));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull,
          reason: 'No overflow errors should occur on standard screens');

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('HomePage should not overflow on large phone (Pixel XL)',
        (WidgetTester tester) async {
      // Simulate Google Pixel XL screen size
      await tester.binding.setSurfaceSize(const Size(411, 731));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull,
          reason: 'No overflow errors should occur on large screens');

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('HomePage should not overflow on tablet (iPad)',
        (WidgetTester tester) async {
      // Simulate iPad screen size
      await tester.binding.setSurfaceSize(const Size(768, 1024));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull,
          reason: 'No overflow errors should occur on tablet screens');

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('HomePage should be scrollable on small screens',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Find the SingleChildScrollView
      final scrollViewFinder = find.byType(SingleChildScrollView);
      expect(scrollViewFinder, findsWidgets,
          reason: 'HomePage should contain scrollable containers');

      // Verify scroll physics
      final scrollView = tester.widget<SingleChildScrollView>(scrollViewFinder.first);
      expect(scrollView.physics, isA<BouncingScrollPhysics>(),
          reason: 'Should use BouncingScrollPhysics for better UX');

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('HomePage should contain all expected widgets',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Verify key widgets are present
      expect(find.byType(Card), findsWidgets,
          reason: 'Should contain Card widgets');
      expect(find.byType(FloatingActionButton), findsOneWidget,
          reason: 'Should have increment button');
      expect(find.byIcon(Icons.add), findsOneWidget,
          reason: 'Should have add icon in FAB');

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('Counter should increment when FAB is tapped',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Find initial counter value (should be 0)
      expect(find.text('0'), findsOneWidget);

      // Tap the FloatingActionButton
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      // Verify counter incremented to 1
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('HomePage should render correctly in landscape mode',
        (WidgetTester tester) async {
      // Simulate landscape orientation
      await tester.binding.setSurfaceSize(const Size(812, 375));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull,
          reason: 'No overflow errors should occur in landscape mode');

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('HomePage should have SafeArea for system UI protection',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 812));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Verify SafeArea is present
      expect(find.byType(SafeArea), findsWidgets,
          reason: 'SafeArea should protect content from system UI');

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('HomePage should handle rapid scrolling without errors',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();

      // Perform rapid scroll gestures
      await tester.fling(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -500),
        1000,
      );
      await tester.pumpAndSettle();

      // Verify no errors occurred during scrolling
      expect(tester.takeException(), isNull,
          reason: 'Rapid scrolling should not cause rendering errors');

      await tester.binding.setSurfaceSize(null);
    });
  });
}
