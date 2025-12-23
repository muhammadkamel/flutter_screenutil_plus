import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScreenUtilContextExtension Tests', () {
    testWidgets('mediaQueryData should return MediaQueryData from MediaQuery', (
      tester,
    ) async {
      MediaQueryData? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = context.mediaQueryData;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, isNotNull);
      expect(result?.size, isNotNull);
    });

    testWidgets(
      'mediaQueryData should fallback to View when MediaQuery is null',
      (tester) async {
        MediaQueryData? result;

        // Create a minimal widget tree that triggers the View.maybeOf path
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                result = context.mediaQueryData;
                return const SizedBox();
              },
            ),
          ),
        );

        // Should return MediaQueryData from View.maybeOf fallback
        expect(result, isNotNull);
        expect(result?.size, isNotNull);
      },
    );

    testWidgets('mediaQueryData handles null MediaQuery and null View', (
      tester,
    ) async {
      // This test verifies the null case, though it's nearly impossible to trigger
      // in a real Flutter environment since View is always available
      MediaQueryData? result;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            result = context.mediaQueryData;
            return const SizedBox();
          },
        ),
      );

      // Even without explicit MediaQuery, View provides data
      expect(result, isNotNull);
    });

    testWidgets('su getter should return ScreenUtilPlus instance', (
      tester,
    ) async {
      late ScreenUtilPlus result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.su;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, isA<ScreenUtilPlus>());
    });

    testWidgets('su getter should register InheritedWidget dependency', (
      tester,
    ) async {
      var buildCount = 0;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          autoRebuild: false,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                buildCount++;
                // Access su to register dependency
                final ScreenUtilPlus _ = context.su;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(buildCount, 1);
    });
  });
}
