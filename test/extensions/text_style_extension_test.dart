import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    // Configure ScreenUtilPlus for testing
    const data = MediaQueryData(
      size: Size(400, 800),
      textScaler: TextScaler.noScaling,
    );
    ScreenUtilPlus.configure(
      data: data,
      designSize: const Size(360, 690),
      minTextAdapt: false,
      splitScreenMode: false,
    );
  });

  group('TextStyleExtension', () {
    group('.r getter', () {
      test('scales font size using .sp', () {
        const style = TextStyle(fontSize: 16);
        final TextStyle responsiveStyle = style.r;

        final util = ScreenUtilPlus();
        final double expectedFontSize = 16 * util.scaleText;

        expect(responsiveStyle.fontSize, closeTo(expectedFontSize, 0.001));
      });

      test('preserves height multiplier', () {
        const style = TextStyle(fontSize: 16, height: 1.5);
        final TextStyle responsiveStyle = style.r;

        // Height multiplier should be preserved
        expect(responsiveStyle.height, 1.5);
      });

      test('returns unchanged style when fontSize is null', () {
        const style = TextStyle(color: Colors.red);
        final TextStyle responsiveStyle = style.r;

        expect(responsiveStyle.fontSize, isNull);
        expect(responsiveStyle.color, Colors.red);
      });

      test('preserves other properties', () {
        const style = TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          letterSpacing: 1.2,
        );
        final TextStyle responsiveStyle = style.r;

        expect(responsiveStyle.fontWeight, FontWeight.bold);
        expect(responsiveStyle.color, Colors.blue);
        expect(responsiveStyle.letterSpacing, 1.2);
      });

      test('handles null height correctly', () {
        const style = TextStyle(fontSize: 16);
        final TextStyle responsiveStyle = style.r;

        // Height should remain null (not set to a default)
        expect(responsiveStyle.height, isNull);
      });
    });

    group('.withLineHeight()', () {
      test('scales font size and sets custom line height', () {
        const style = TextStyle(fontSize: 16);
        final TextStyle responsiveStyle = style.withLineHeight(1.8);

        final util = ScreenUtilPlus();
        final double expectedFontSize = 16 * util.scaleText;

        expect(responsiveStyle.fontSize, closeTo(expectedFontSize, 0.001));
        expect(responsiveStyle.height, 1.8);
      });

      test('overrides existing height with new value', () {
        const style = TextStyle(fontSize: 16, height: 1.2);
        final TextStyle responsiveStyle = style.withLineHeight(2.0);

        expect(responsiveStyle.height, 2.0);
      });

      test('sets height even when fontSize is null', () {
        const style = TextStyle(color: Colors.red);
        final TextStyle responsiveStyle = style.withLineHeight(1.5);

        expect(responsiveStyle.fontSize, isNull);
        expect(responsiveStyle.height, 1.5);
      });

      test('preserves other properties', () {
        const style = TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.green,
        );
        final TextStyle responsiveStyle = style.withLineHeight(1.6);

        expect(responsiveStyle.fontWeight, FontWeight.w600);
        expect(responsiveStyle.color, Colors.green);
      });
    });

    group('.withAutoLineHeight()', () {
      test('scales font size and applies default line height multiplier', () {
        const style = TextStyle(fontSize: 16);
        final TextStyle responsiveStyle = style.withAutoLineHeight();

        final util = ScreenUtilPlus();
        final double expectedFontSize = 16 * util.scaleText;

        expect(responsiveStyle.fontSize, closeTo(expectedFontSize, 0.001));
        expect(responsiveStyle.height, 1.2); // default multiplier
      });

      test('uses custom default multiplier when provided', () {
        const style = TextStyle(fontSize: 16);
        final TextStyle responsiveStyle = style.withAutoLineHeight(1.5);

        expect(responsiveStyle.height, 1.5);
      });

      test('preserves existing height if already set', () {
        const style = TextStyle(fontSize: 16, height: 1.8);
        final TextStyle responsiveStyle = style.withAutoLineHeight();

        // Existing height should be preserved
        expect(responsiveStyle.height, 1.8);
      });

      test('applies default when height is null', () {
        const style = TextStyle(fontSize: 16);
        final TextStyle responsiveStyle = style.withAutoLineHeight(1.3);

        expect(responsiveStyle.height, 1.3);
      });

      test('handles null fontSize correctly', () {
        const style = TextStyle(color: Colors.blue);
        final TextStyle responsiveStyle = style.withAutoLineHeight(1.4);

        expect(responsiveStyle.fontSize, isNull);
        expect(responsiveStyle.height, 1.4);
      });

      test('preserves other properties', () {
        const style = TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        );
        final TextStyle responsiveStyle = style.withAutoLineHeight();

        expect(responsiveStyle.fontStyle, FontStyle.italic);
        expect(responsiveStyle.decoration, TextDecoration.underline);
      });
    });

    group('.withLineHeightFromFigma()', () {
      test('calculates height from Figma values correctly', () {
        // Figma: fontSize: 20px, lineHeight: 14px
        // Calculation: height = 14 / 20 = 0.7
        const style = TextStyle(fontSize: 20);
        final TextStyle responsiveStyle = style.withLineHeightFromFigma(14);

        final util = ScreenUtilPlus();
        final double expectedFontSize = 20 * util.scaleText;

        expect(responsiveStyle.fontSize, closeTo(expectedFontSize, 0.001));
        expect(responsiveStyle.height, closeTo(0.7, 0.001));
      });

      test('calculates height correctly for different Figma values', () {
        final testCases = [
          {'fontSize': 16.0, 'lineHeight': 24.0, 'expectedHeight': 1.5},
          {'fontSize': 20.0, 'lineHeight': 14.0, 'expectedHeight': 0.7},
          {'fontSize': 24.0, 'lineHeight': 32.0, 'expectedHeight': 1.333},
          {'fontSize': 12.0, 'lineHeight': 18.0, 'expectedHeight': 1.5},
        ];

        for (final testCase in testCases) {
          final double fontSize = testCase['fontSize']!;
          final double lineHeight = testCase['lineHeight']!;
          final double expectedHeight = testCase['expectedHeight']!;

          final style = TextStyle(fontSize: fontSize);
          final TextStyle responsiveStyle = style.withLineHeightFromFigma(
            lineHeight,
          );

          final util = ScreenUtilPlus();
          final double expectedFontSize = fontSize * util.scaleText;

          expect(
            responsiveStyle.fontSize,
            closeTo(expectedFontSize, 0.001),
            reason: 'Font size should scale for fontSize=$fontSize',
          );
          expect(
            responsiveStyle.height,
            closeTo(expectedHeight, 0.001),
            reason:
                'Height should be calculated correctly for fontSize=$fontSize, lineHeight=$lineHeight',
          );
        }
      });

      test('throws error when fontSize is null', () {
        const style = TextStyle(color: Colors.blue);

        expect(() => style.withLineHeightFromFigma(14), throwsArgumentError);
      });

      test('overrides existing height when overrideExisting is true', () {
        const style = TextStyle(fontSize: 20, height: 1.5);
        final TextStyle responsiveStyle = style.withLineHeightFromFigma(
          14,
          overrideExisting: true,
        );

        expect(responsiveStyle.height, closeTo(0.7, 0.001));
      });

      test('preserves existing height when overrideExisting is false', () {
        const style = TextStyle(fontSize: 20, height: 1.5);
        final TextStyle responsiveStyle = style.withLineHeightFromFigma(14);

        final util = ScreenUtilPlus();
        final double expectedFontSize = 20 * util.scaleText;

        expect(responsiveStyle.fontSize, closeTo(expectedFontSize, 0.001));
        expect(responsiveStyle.height, 1.5); // Preserved
      });

      test('preserves other properties', () {
        const style = TextStyle(
          fontSize: 20,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        );
        final TextStyle responsiveStyle = style.withLineHeightFromFigma(14);

        expect(responsiveStyle.color, Colors.red);
        expect(responsiveStyle.fontWeight, FontWeight.bold);
      });
    });

    group('Integration with different screen sizes', () {
      test('scales correctly on larger screen', () {
        const largeScreenData = MediaQueryData(
          size: Size(800, 1600),
          textScaler: TextScaler.noScaling,
        );
        ScreenUtilPlus.configure(
          data: largeScreenData,
          designSize: const Size(360, 690),
          minTextAdapt: false,
          splitScreenMode: false,
        );

        const style = TextStyle(fontSize: 16, height: 1.5);
        final TextStyle responsiveStyle = style.r;

        final util = ScreenUtilPlus();
        final double expectedFontSize = 16 * util.scaleText;

        expect(responsiveStyle.fontSize, closeTo(expectedFontSize, 0.001));
        expect(responsiveStyle.height, 1.5); // multiplier preserved
      });

      test('scales correctly on smaller screen', () {
        const smallScreenData = MediaQueryData(
          size: Size(320, 568),
          textScaler: TextScaler.noScaling,
        );
        ScreenUtilPlus.configure(
          data: smallScreenData,
          designSize: const Size(360, 690),
          minTextAdapt: false,
          splitScreenMode: false,
        );

        const style = TextStyle(fontSize: 16, height: 1.5);
        final TextStyle responsiveStyle = style.r;

        final util = ScreenUtilPlus();
        final double expectedFontSize = 16 * util.scaleText;

        expect(responsiveStyle.fontSize, closeTo(expectedFontSize, 0.001));
        expect(responsiveStyle.height, 1.5); // multiplier preserved
      });
    });

    group('Edge cases', () {
      test('handles zero font size', () {
        const style = TextStyle(fontSize: 0);
        final TextStyle responsiveStyle = style.r;

        expect(responsiveStyle.fontSize, 0.0);
      });

      test('handles very large font size', () {
        const style = TextStyle(fontSize: 1000);
        final TextStyle responsiveStyle = style.r;

        final util = ScreenUtilPlus();
        final double expectedFontSize = 1000 * util.scaleText;

        expect(responsiveStyle.fontSize, closeTo(expectedFontSize, 0.001));
      });

      test('handles very small line height', () {
        const style = TextStyle(fontSize: 16, height: 0.1);
        final TextStyle responsiveStyle = style.r;

        expect(responsiveStyle.height, 0.1);
      });

      test('handles very large line height', () {
        const style = TextStyle(fontSize: 16, height: 10.0);
        final TextStyle responsiveStyle = style.r;

        expect(responsiveStyle.height, 10.0);
      });
    });
  });
}
