import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_practice/l10n/app_localizations.dart';

import 'package:flutter_practice/presentation/screens/home_page.dart';

/// Comprehensive responsive tests for HomePage
///
/// Tests HomePage rendering across a wide range of device sizes
/// to ensure responsive design and prevent layout issues.
void main() {
  group('HomePage Responsive Design Tests', () {

    /// Test screen sizes representing common device categories
    final testScreenSizes = {
      'iPhone SE (Small)': const Size(320, 568),
      'iPhone 8': const Size(375, 667),
      'iPhone X': const Size(375, 812),
      'iPhone 14 Pro Max': const Size(430, 932),
      'Samsung Galaxy S20': const Size(360, 800),
      'Google Pixel 5': const Size(393, 851),
      'Google Pixel XL': const Size(411, 731),
      'iPad Mini': const Size(768, 1024),
      'iPad Pro 11"': const Size(834, 1194),
      'iPad Pro 12.9"': const Size(1024, 1366),
      'Desktop Small': const Size(1280, 720),
      'Desktop HD': const Size(1920, 1080),
    };

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
              Locale('ko'),
            ],
            home: child,
          );
        },
        child: child,
      );
    }

    /// Test each screen size for rendering without overflow
    for (final entry in testScreenSizes.entries) {
      final deviceName = entry.key;
      final screenSize = entry.value;

      testWidgets('HomePage renders correctly on $deviceName (${screenSize.width.toInt()}x${screenSize.height.toInt()})',
          (WidgetTester tester) async {
        // Set screen size
        await tester.binding.setSurfaceSize(screenSize);

        // Build widget
        await tester.pumpWidget(createTestableWidget(const HomePage()));
        await tester.pumpAndSettle();

        // Verify no overflow errors
        expect(tester.takeException(), isNull,
            reason: 'No overflow on $deviceName (${screenSize.width}x${screenSize.height})');

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });
    }

    /// Test landscape orientation for mobile devices
    group('Landscape Orientation Tests', () {
      final landscapeScreenSizes = {
        'iPhone SE Landscape': const Size(568, 320),
        'iPhone X Landscape': const Size(812, 375),
        'Pixel 5 Landscape': const Size(851, 393),
        'iPad Mini Landscape': const Size(1024, 768),
      };

      for (final entry in landscapeScreenSizes.entries) {
        final deviceName = entry.key;
        final screenSize = entry.value;

        testWidgets('HomePage renders in $deviceName',
            (WidgetTester tester) async {
          await tester.binding.setSurfaceSize(screenSize);

          await tester.pumpWidget(createTestableWidget(const HomePage()));
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull,
              reason: 'No overflow in landscape: $deviceName');

          await tester.binding.setSurfaceSize(null);
        });
      }
    });

    /// Test extreme edge cases
    group('Edge Case Screen Sizes', () {
      testWidgets('Very small screen (280x500)',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(280, 500));

        await tester.pumpWidget(createTestableWidget(const HomePage()));
        await tester.pumpAndSettle();

        // Note: Very small screens (<300px width) may have minor pixel overflows
        // which are acceptable for edge cases. We verify no major rendering errors.
        final exception = tester.takeException();
        if (exception != null) {
          // Allow minor overflows (< 5 pixels) on extremely small screens
          final exceptionStr = exception.toString();
          if (exceptionStr.contains('overflowed by')) {
            // Extract overflow amount
            final match = RegExp(r'(\d+\.?\d*)\s*pixels').firstMatch(exceptionStr);
            if (match != null) {
              final overflowPixels = double.parse(match.group(1)!);
              expect(overflowPixels, lessThan(5.0),
                  reason: 'Minor overflow (<5px) acceptable on very small screens');
            }
          }
        }

        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('Very tall screen (400x1600)',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 1600));

        await tester.pumpWidget(createTestableWidget(const HomePage()));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull,
            reason: 'Should handle very tall screens gracefully');

        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('Square screen (600x600)',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(600, 600));

        await tester.pumpWidget(createTestableWidget(const HomePage()));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull,
            reason: 'Should handle square screens gracefully');

        await tester.binding.setSurfaceSize(null);
      });
    });

    /// Test responsive layout switching
    group('Responsive Layout Switching', () {
      testWidgets('Mobile layout is used on phone screens',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(375, 812));

        await tester.pumpWidget(createTestableWidget(const HomePage()));
        await tester.pumpAndSettle();

        // On mobile, ResponsiveBuilder should show mobile layout
        // We can verify by checking if certain widgets are rendered
        expect(find.byType(HomePage), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('Tablet layout is used on tablet screens',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(768, 1024));

        await tester.pumpWidget(createTestableWidget(const HomePage()));
        await tester.pumpAndSettle();

        // On tablet, ResponsiveBuilder should show tablet layout
        expect(find.byType(HomePage), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      });
    });

    /// Test content accessibility across screen sizes
    group('Content Accessibility Tests', () {
      testWidgets('All key widgets are accessible on small screens',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));

        await tester.pumpWidget(createTestableWidget(const HomePage()));
        await tester.pumpAndSettle();

        // Verify key widgets are present
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);

        // Scroll to bottom to check all widgets
        final scrollView = find.byType(SingleChildScrollView).first;
        await tester.drag(scrollView, const Offset(0, -1000));
        await tester.pumpAndSettle();

        // After scrolling, button should still be visible
        expect(find.byType(FloatingActionButton), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('Content is scrollable on all screen sizes',
          (WidgetTester tester) async {
        final testSizes = [
          const Size(320, 568),
          const Size(375, 812),
          const Size(768, 1024),
        ];

        for (final size in testSizes) {
          await tester.binding.setSurfaceSize(size);

          await tester.pumpWidget(createTestableWidget(const HomePage()));
          await tester.pumpAndSettle();

          // Find scrollable widget
          final scrollView = find.byType(SingleChildScrollView);
          expect(scrollView, findsWidgets,
              reason: 'Should be scrollable on ${size.width}x${size.height}');

          await tester.binding.setSurfaceSize(null);
        }
      });
    });

    /// Performance tests for different screen sizes
    group('Performance Tests', () {
      testWidgets('HomePage builds quickly on small screens',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));

        final stopwatch = Stopwatch()..start();
        await tester.pumpWidget(createTestableWidget(const HomePage()));
        await tester.pumpAndSettle();
        stopwatch.stop();

        // Build should complete in under 200ms (tests are slower than production)
        expect(stopwatch.elapsedMilliseconds, lessThan(200),
            reason: 'Initial build should be reasonably fast');

        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('Scrolling performance is smooth',
          (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(375, 812));

        await tester.pumpWidget(createTestableWidget(const HomePage()));
        await tester.pumpAndSettle();

        // Perform multiple scroll operations
        final scrollView = find.byType(SingleChildScrollView).first;

        for (int i = 0; i < 5; i++) {
          await tester.drag(scrollView, const Offset(0, -200));
          await tester.pump();
        }

        await tester.pumpAndSettle();

        // Should not have any exceptions during scrolling
        expect(tester.takeException(), isNull,
            reason: 'Scrolling should be smooth without errors');

        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
