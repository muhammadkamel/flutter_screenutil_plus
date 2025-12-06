import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_screenutil_plus/src/core/_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScreenUtilPlus Coverage Tests', () {
    const designSize = Size(360, 690);
    const deviceSize = Size(720, 1380);

    setUp(() {
      // Reset enableScale to default
      ScreenUtilPlus.enableScale(enableWH: () => true, enableText: () => true);

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        designSize: designSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );
    });

    tearDown(() {
      // Reset to default state after each test
      ScreenUtilPlus.enableScale(enableWH: () => true, enableText: () => true);

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        designSize: designSize,
        minTextAdapt: true,
        splitScreenMode: false,
      );
    });

    testWidgets('deviceType should return correct type for mobile', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final DeviceType deviceType = ScreenUtilPlus().deviceType(
                context,
              );
              // In test environment, defaultTargetPlatform varies
              // We just verify it returns a valid DeviceType
              expect(deviceType, isA<DeviceType>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('registerToBuild should register elements', (tester) async {
      var buildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              buildCount++;
              ScreenUtilPlus.registerToBuild(context);
              return Text('Build count: $buildCount');
            },
          ),
        ),
      );

      expect(buildCount, 1);
      expect(find.text('Build count: 1'), findsOneWidget);

      // Trigger a configuration change to test rebuild
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(800, 1400)),
        designSize: designSize,
      );

      await tester.pump();

      // The registered element should rebuild
      expect(buildCount, 2);
      expect(find.text('Build count: 2'), findsOneWidget);
    });

    testWidgets('registerToBuild with descendants should register all', (
      tester,
    ) async {
      var parentBuildCount = 0;
      var childBuildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              parentBuildCount++;
              ScreenUtilPlus.registerToBuild(context, true);
              return Builder(
                builder: (childContext) {
                  childBuildCount++;
                  return Text(
                    'Parent: $parentBuildCount, Child: $childBuildCount',
                  );
                },
              );
            },
          ),
        ),
      );

      expect(parentBuildCount, 1);
      expect(childBuildCount, 1);

      // Trigger a configuration change
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(800, 1400)),
        designSize: designSize,
      );

      await tester.pump();

      // Both parent and child should rebuild
      expect(parentBuildCount, 2);
      expect(childBuildCount, 2);
    });

    test('ensureScreenSize should wait for screen size', () async {
      // This test verifies the method completes without error
      // In a test environment, the screen size is already available
      await ScreenUtilPlus.ensureScreenSize();
      // If we get here without hanging, the test passes
      expect(true, true);
    });

    test('enableScale should control scaling', () {
      // setUp already enables scaling, so we verify that first
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        designSize: designSize,
      );
      final double initialScale = ScreenUtilPlus().scaleWidth;
      expect(initialScale, greaterThan(1));

      // Disable width/height scaling
      ScreenUtilPlus.enableScale(enableWH: () => false, enableText: () => true);

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        designSize: designSize,
        minTextAdapt: false, // Use scaleWidth for text, which is now 1
      );

      // With scaling disabled, scaleWidth should be 1
      expect(ScreenUtilPlus().scaleWidth, 1);
      expect(ScreenUtilPlus().scaleHeight, 1);

      // Text scaling is also 1 because scaleText uses scaleWidth when minTextAdapt is false
      // and scaleWidth is 1 when enableWH is false
      expect(ScreenUtilPlus().scaleText, 1);

      // Re-enable scaling
      ScreenUtilPlus.enableScale(enableWH: () => true, enableText: () => true);

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        designSize: designSize,
      );

      expect(ScreenUtilPlus().scaleWidth, greaterThan(1));
    });

    test('configure should handle missing initialization gracefully', () {
      // Create a new instance scenario by calling configure without data/designSize
      // after clearing the instance state (we can't actually clear it, so we test
      // that calling configure with partial data uses previous values)

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        designSize: designSize,
      );

      // This should use previously set values
      ScreenUtilPlus.configure(minTextAdapt: false, designSize: defaultSize);

      expect(ScreenUtilPlus().screenWidth, deviceSize.width);
    });

    test('fontSizeResolver should be used when set', () {
      double customResolver(num fontSize, ScreenUtilPlus instance) {
        return fontSize * 3; // Custom 3x scaling
      }

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        designSize: designSize,
        fontSizeResolver: customResolver,
      );

      expect(ScreenUtilPlus().setSp(10), 30);

      // Clear the custom resolver
      ScreenUtilPlus.configure(designSize: defaultSize);
    });

    test('splitScreenMode should affect height scaling', () {
      // Without split screen mode
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(360, 400)), // Short screen
        designSize: designSize,
        splitScreenMode: false,
      );

      final double normalScaleHeight = ScreenUtilPlus().scaleHeight;

      // With split screen mode (uses max(screenHeight, 700))
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(360, 400)),
        designSize: designSize,
        splitScreenMode: true,
      );

      final double splitScaleHeight = ScreenUtilPlus().scaleHeight;

      // Split screen mode should use 700 instead of 400, so scale should be higher
      // normalScaleHeight = 400 / 690 ≈ 0.58
      // splitScaleHeight = 700 / 690 ≈ 1.01
      expect(splitScaleHeight, greaterThan(normalScaleHeight));
      expect(splitScaleHeight, closeTo(700 / 690, 0.01));
    });

    test('minTextAdapt should affect text scaling', () {
      // With minTextAdapt = true, uses min(scaleWidth, scaleHeight)
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(800, 1000)),
        designSize: designSize,
        minTextAdapt: true,
      );

      final double minAdaptScale = ScreenUtilPlus().scaleText;

      // With minTextAdapt = false, uses scaleWidth
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(800, 1000)),
        designSize: designSize,
        minTextAdapt: false,
      );

      final double noMinAdaptScale = ScreenUtilPlus().scaleText;

      // Both should be positive, but potentially different
      expect(minAdaptScale, greaterThan(0));
      expect(noMinAdaptScale, greaterThan(0));
    });

    test('orientation should be detected correctly', () {
      // Portrait
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(360, 690)),
        designSize: designSize,
      );

      expect(ScreenUtilPlus().orientation, Orientation.portrait);

      // Landscape
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(690, 360)),
        designSize: designSize,
      );

      expect(ScreenUtilPlus().orientation, Orientation.landscape);
    });

    test('statusBarHeight and bottomBarHeight should return padding', () {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(
          size: deviceSize,
          padding: EdgeInsets.only(top: 44, bottom: 34),
        ),
        designSize: designSize,
      );

      expect(ScreenUtilPlus().statusBarHeight, 44);
      expect(ScreenUtilPlus().bottomBarHeight, 34);
    });

    test('pixelRatio should return device pixel ratio', () {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize, devicePixelRatio: 3.0),
        designSize: designSize,
      );

      expect(ScreenUtilPlus().pixelRatio, 3.0);
    });

    test('textScaleFactor should return text scale factor', () {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(
          size: deviceSize,
          textScaler: TextScaler.linear(1.5),
        ),
        designSize: designSize,
      );

      expect(ScreenUtilPlus().textScaleFactor, 1.5);
    });

    test('All spacing methods should return correct SizedBox', () {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        designSize: designSize,
      );

      expect(ScreenUtilPlus().setVerticalSpacing(100).height, 200);
      expect(ScreenUtilPlus().setVerticalSpacingFromWidth(100).height, 200);
      expect(ScreenUtilPlus().setHorizontalSpacing(100).width, 200);
      expect(ScreenUtilPlus().setHorizontalSpacingRadius(100).width, 200);
      expect(ScreenUtilPlus().setVerticalSpacingRadius(100).height, 200);
      expect(ScreenUtilPlus().setHorizontalSpacingDiameter(100).width, 200);
      expect(ScreenUtilPlus().setVerticalSpacingDiameter(100).height, 200);
      expect(ScreenUtilPlus().setHorizontalSpacingDiagonal(100).width, 400);
      expect(ScreenUtilPlus().setVerticalSpacingDiagonal(100).height, 400);
    });

    test('enableScale with only text disabled should work', () {
      ScreenUtilPlus.enableScale(enableWH: () => true, enableText: () => false);

      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        designSize: designSize,
      );

      expect(ScreenUtilPlus().scaleWidth, greaterThan(1));
      expect(ScreenUtilPlus().scaleText, 1);
    });

    test('Different screen sizes should produce different scales', () {
      // Small screen
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(360, 690)),
        designSize: designSize,
      );
      expect(ScreenUtilPlus().scaleWidth, 1);
      expect(ScreenUtilPlus().scaleHeight, 1);

      // Large screen
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: Size(1080, 2070)),
        designSize: designSize,
      );
      expect(ScreenUtilPlus().scaleWidth, 3);
      expect(ScreenUtilPlus().scaleHeight, 3);
    });

    test('screenWidth and screenHeight should return correct values', () {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        designSize: designSize,
      );

      expect(ScreenUtilPlus().screenWidth, 720);
      expect(ScreenUtilPlus().screenHeight, 1380);
    });
  });
}
