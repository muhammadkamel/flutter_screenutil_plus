import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveText', () {
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

    testWidgets('adapts font size based on breakpoint', (tester) async {
      // XS breakpoint (320px)
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(320, 568),
                textScaler: TextScaler.noScaling,
              ),
              child: AdaptiveText(
                'Test',
                fontSizeXs: 12,
                fontSizeMd: 16,
                fontSizeLg: 20,
              ),
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      final util = ScreenUtilPlus();
      expect(text.style?.fontSize, closeTo(12 * util.scaleText, 0.001));
    });

    testWidgets('falls back to next breakpoint when value not provided', (
      tester,
    ) async {
      // MD breakpoint but only XS and LG defined
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(768, 1024),
                textScaler: TextScaler.noScaling,
              ),
              child: AdaptiveText('Test', fontSizeXs: 12, fontSizeLg: 20),
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      final util = ScreenUtilPlus();
      // Should fall back to XS value (MD not defined, falls back to XS)
      expect(text.style?.fontSize, closeTo(12 * util.scaleText, 0.001));
    });

    testWidgets('adapts font weight based on breakpoint', (tester) async {
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(1920, 1080),
                textScaler: TextScaler.noScaling,
              ),
              child: AdaptiveText(
                'Test',
                fontSizeXs: 14,
                fontWeightXs: FontWeight.normal,
                fontWeightLg: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('adapts color based on breakpoint', (tester) async {
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(768, 1024),
                textScaler: TextScaler.noScaling,
              ),
              child: AdaptiveText(
                'Test',
                fontSizeXs: 14,
                colorXs: Colors.blue,
                colorMd: Colors.red,
              ),
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.color, Colors.red);
    });

    testWidgets('adapts line height based on breakpoint', (tester) async {
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(992, 768),
                textScaler: TextScaler.noScaling,
              ),
              child: AdaptiveText(
                'Test',
                fontSizeXs: 14,
                lineHeightXs: 1.2,
                lineHeightLg: 1.8,
              ),
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.height, 1.8);
    });

    testWidgets('adapts letter spacing based on breakpoint', (tester) async {
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(1200, 900),
                textScaler: TextScaler.noScaling,
              ),
              child: AdaptiveText(
                'Test',
                fontSizeXs: 14,
                letterSpacingXs: 0.5,
                letterSpacingXl: 1.5,
              ),
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.letterSpacing, 1.5);
    });

    testWidgets('merges with base style', (tester) async {
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(400, 800),
                textScaler: TextScaler.noScaling,
              ),
              child: AdaptiveText(
                'Test',
                fontSizeXs: 14,
                baseStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontStyle, FontStyle.italic);
      expect(text.style?.decoration, TextDecoration.underline);
    });

    testWidgets('passes through text widget properties', (tester) async {
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          child: MaterialApp(
            home: AdaptiveText(
              'Test',
              fontSizeXs: 14,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.textAlign, TextAlign.center);
      expect(text.maxLines, 2);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('handles xxl breakpoint', (tester) async {
      await tester.pumpWidget(
        const ScreenUtilPlusInit(
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(1920, 1080),
                textScaler: TextScaler.noScaling,
              ),
              child: AdaptiveText('Test', fontSizeXs: 12, fontSizeXxl: 24),
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      final util = ScreenUtilPlus();
      expect(text.style?.fontSize, closeTo(24 * util.scaleText, 0.001));
    });
  });

  group('AdaptiveTextStyleExtension', () {
    setUp(() {
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

    testWidgets('creates adaptive text style', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return MediaQuery(
                  data: const MediaQueryData(
                    size: Size(768, 1024),
                    textScaler: TextScaler.noScaling,
                  ),
                  child: Builder(
                    builder: (context) {
                      final TextStyle style = context.adaptiveTextStyle(
                        fontSizeXs: 12,
                        fontSizeMd: 16,
                        fontSizeLg: 20,
                      );

                      return Text('Test', style: style);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      final util = ScreenUtilPlus();
      expect(text.style?.fontSize, closeTo(16 * util.scaleText, 0.001));
    });

    testWidgets('merges with base style in extension', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final TextStyle style = context.adaptiveTextStyle(
                  fontSizeXs: 14,
                  baseStyle: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Roboto',
                  ),
                );

                return Text('Test', style: style);
              },
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontStyle, FontStyle.italic);
      expect(text.style?.fontFamily, 'Roboto');
    });

    testWidgets('handles all adaptive properties in extension', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return MediaQuery(
                  data: const MediaQueryData(
                    size: Size(992, 768),
                    textScaler: TextScaler.noScaling,
                  ),
                  child: Builder(
                    builder: (context) {
                      final TextStyle style = context.adaptiveTextStyle(
                        fontSizeXs: 12,
                        fontSizeLg: 18,
                        lineHeightXs: 1.2,
                        lineHeightLg: 1.6,
                        fontWeightXs: FontWeight.normal,
                        fontWeightLg: FontWeight.bold,
                        colorXs: Colors.blue,
                        colorLg: Colors.red,
                        letterSpacingLg: 1.2,
                      );

                      return Text('Test', style: style);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      final Text text = tester.widget<Text>(find.byType(Text));
      final util = ScreenUtilPlus();

      expect(text.style?.fontSize, closeTo(18 * util.scaleText, 0.001));
      expect(text.style?.height, 1.6);
      expect(text.style?.fontWeight, FontWeight.bold);
      expect(text.style?.color, Colors.red);
      expect(text.style?.letterSpacing, 1.2);
    });
  });
}
