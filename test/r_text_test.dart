import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RText', () {
    setUp(() {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(
          size: Size(400, 800),
          textScaler: TextScaler.linear(1.0),
        ),
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    testWidgets('scales font size when style is provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: RText('Hello', style: const TextStyle(fontSize: 16))),
      );

      final text = tester.widget<Text>(find.byType(Text));
      final util = ScreenUtilPlus();

      expect(text.style?.fontSize, closeTo(16 * util.scaleText, 0.001));
    });

    testWidgets('scales default font size when no style provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DefaultTextStyle(
            style: TextStyle(fontSize: 14),
            child: RText('Hello'),
          ),
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));
      final util = ScreenUtilPlus();

      expect(text.style?.fontSize, closeTo(14 * util.scaleText, 0.001));
    });

    testWidgets('preserves other text properties', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RText(
            'Hello',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));

      expect(text.style?.color, Colors.red);
      expect(text.style?.fontWeight, FontWeight.bold);
      expect(text.textAlign, TextAlign.center);
      expect(text.maxLines, 2);
    });
  });
}
