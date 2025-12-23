import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveTextStyleExtension Tests', () {
    testWidgets('adaptiveTextStyle should work with xxl breakpoint', (
      tester,
    ) async {
      TextStyle? result;

      // Create a very large screen to trigger xxl breakpoint (>= 1920px)
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(2000, 1200)),
          child: ScreenUtilPlusInit(
            designSize: const Size(375, 812),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  result = context.adaptiveTextStyle(
                    fontSizeXxl: 32,
                    lineHeightXxl: 1.8,
                    fontWeightXxl: FontWeight.bold,
                    colorXxl: Colors.red,
                    letterSpacingXxl: 2.0,
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(result, isNotNull);
      expect(result?.fontWeight, FontWeight.bold);
      expect(result?.color, Colors.red);
      expect(result?.letterSpacing, 2.0);
      expect(result?.height, 1.8);
    });

    testWidgets(
      'adaptiveTextStyle should fallback from xxl to smaller breakpoints',
      (tester) async {
        TextStyle? result;

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(2000, 1200)),
            child: ScreenUtilPlusInit(
              designSize: const Size(375, 812),
              child: MaterialApp(
                home: Builder(
                  builder: (context) {
                    // Only provide xs value, should fallback to it from xxl
                    result = context.adaptiveTextStyle(
                      fontSizeXs: 14,
                      fontWeightXs: FontWeight.normal,
                    );
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result?.fontWeight, FontWeight.normal);
      },
    );

    testWidgets('adaptiveTextStyle should work with all breakpoints', (
      tester,
    ) async {
      final results = <String, TextStyle>{};

      final breakpointSizes = {
        'xs': const Size(400, 800),
        'sm': const Size(700, 800),
        'md': const Size(1000, 800),
        'lg': const Size(1400, 800),
        'xl': const Size(1700, 800),
        'xxl': const Size(2000, 800),
      };

      for (final MapEntry<String, Size> entry in breakpointSizes.entries) {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(size: entry.value),
            child: ScreenUtilPlusInit(
              designSize: const Size(375, 812),
              child: MaterialApp(
                home: Builder(
                  builder: (context) {
                    results[entry.key] = context.adaptiveTextStyle(
                      fontSizeXs: 12,
                      fontSizeSm: 14,
                      fontSizeMd: 16,
                      fontSizeLg: 18,
                      fontSizeXl: 20,
                      fontSizeXxl: 24,
                    );
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );
      }

      // Verify all breakpoints were tested
      expect(results.length, 6);
      expect(results.keys, containsAll(['xs', 'sm', 'md', 'lg', 'xl', 'xxl']));
    });

    testWidgets('adaptiveTextStyle should merge with baseStyle', (
      tester,
    ) async {
      TextStyle? result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.adaptiveTextStyle(
                  fontSizeXs: 16,
                  baseStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    decoration: TextDecoration.underline,
                  ),
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, isNotNull);
      expect(result?.fontFamily, 'Roboto');
      expect(result?.decoration, TextDecoration.underline);
    });

    testWidgets('adaptiveTextStyle should handle all style properties', (
      tester,
    ) async {
      TextStyle? result;

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = context.adaptiveTextStyle(
                  fontSizeXs: 16,
                  lineHeightXs: 1.5,
                  fontWeightXs: FontWeight.w600,
                  colorXs: Colors.blue,
                  letterSpacingXs: 1.2,
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, isNotNull);
      expect(result?.fontWeight, FontWeight.w600);
      expect(result?.color, Colors.blue);
      expect(result?.letterSpacing, 1.2);
      expect(result?.height, 1.5);
    });
  });
}
