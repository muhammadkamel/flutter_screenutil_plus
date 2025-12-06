import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_screenutil_plus/src/core/_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveTheme', () {
    setUp(() {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(
          size: Size(400, 800),
          textScaler: TextScaler.noScaling,
        ),
        designSize: defaultSize,
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    test('scales all text theme styles', () {
      final baseTheme = ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 96),
          displayMedium: TextStyle(fontSize: 60),
          displaySmall: TextStyle(fontSize: 48),
          headlineLarge: TextStyle(fontSize: 40),
          headlineMedium: TextStyle(fontSize: 34),
          headlineSmall: TextStyle(fontSize: 24),
          titleLarge: TextStyle(fontSize: 20),
          titleMedium: TextStyle(fontSize: 16),
          titleSmall: TextStyle(fontSize: 14),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
          labelLarge: TextStyle(fontSize: 14),
          labelMedium: TextStyle(fontSize: 12),
          labelSmall: TextStyle(fontSize: 10),
        ),
      );

      final ThemeData responsiveTheme = ResponsiveTheme.fromTheme(baseTheme);
      final util = ScreenUtilPlus();

      expect(
        responsiveTheme.textTheme.displayLarge?.fontSize,
        closeTo(96 * util.scaleText, 0.001),
      );
      expect(
        responsiveTheme.textTheme.bodyMedium?.fontSize,
        closeTo(14 * util.scaleText, 0.001),
      );
      expect(
        responsiveTheme.textTheme.labelSmall?.fontSize,
        closeTo(10 * util.scaleText, 0.001),
      );
    });

    test('preserves other text style properties', () {
      final baseTheme = ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      final ThemeData responsiveTheme = ResponsiveTheme.fromTheme(baseTheme);

      expect(responsiveTheme.textTheme.bodyLarge?.color, Colors.blue);
      expect(responsiveTheme.textTheme.bodyLarge?.fontWeight, FontWeight.bold);
    });

    test('handles text styles without fontSize', () {
      final baseTheme = ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          // bodyMedium will have default values from ThemeData
        ),
      );

      final ThemeData responsiveTheme = ResponsiveTheme.fromTheme(baseTheme);
      final util = ScreenUtilPlus();

      // bodyLarge should be scaled
      expect(
        responsiveTheme.textTheme.bodyLarge?.fontSize,
        closeTo(16 * util.scaleText, 0.001),
      );

      // bodyMedium exists but if it has no explicit fontSize, it should be preserved
      expect(responsiveTheme.textTheme.bodyMedium, isNotNull);
    });
  });
}
