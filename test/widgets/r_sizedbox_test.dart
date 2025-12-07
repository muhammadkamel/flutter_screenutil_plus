import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RSizedBox', () {
    const deviceSize = Size(720, 1380); // 2x scale

    setUp(() {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        minTextAdapt: true,
        splitScreenMode: false,
      );
    });

    testWidgets('RSizedBox default constructor should scale width and height', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: RSizedBox(width: 100, height: 50)),
      );

      final RenderConstrainedBox renderBox = tester.renderObject(
        find.byType(RSizedBox),
      );

      // RSizedBox extends SizedBox but applies scaling in createRenderObject via additionalConstraints
      // The widget properties themselves (width/height) are passed as is to super,
      // but the RenderConstrainedBox has the scaled constraints.

      // Wait, RSizedBox overrides createRenderObject to use _additionalConstraints.
      // _additionalConstraints uses .hw for default constructor.
      // .hw uses .w for width and .h for height.

      expect(renderBox.additionalConstraints.minWidth, 200); // 100 * 2
      expect(renderBox.additionalConstraints.maxWidth, 200);
      expect(renderBox.additionalConstraints.minHeight, 100); // 50 * 2
      expect(renderBox.additionalConstraints.maxHeight, 100);
    });

    testWidgets('RSizedBox.vertical should scale height only', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: RSizedBox.vertical(50)));

      final RenderConstrainedBox renderBox = tester.renderObject(
        find.byType(RSizedBox),
      );

      expect(renderBox.additionalConstraints.minHeight, 100); // 50 * 2
      expect(renderBox.additionalConstraints.maxHeight, 100);
      // Width should be unconstrained (0.0 to infinity)
      expect(renderBox.additionalConstraints.minWidth, 0.0);
      expect(renderBox.additionalConstraints.maxWidth, double.infinity);
    });

    testWidgets('RSizedBox.horizontal should scale width only', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RSizedBox.horizontal(100)),
      );

      final RenderConstrainedBox renderBox = tester.renderObject(
        find.byType(RSizedBox),
      );

      expect(renderBox.additionalConstraints.minWidth, 200); // 100 * 2
      expect(renderBox.additionalConstraints.maxWidth, 200);
      // Height should be unconstrained
      expect(renderBox.additionalConstraints.minHeight, 0.0);
      expect(renderBox.additionalConstraints.maxHeight, double.infinity);
    });

    testWidgets('RSizedBox.square should scale dimension using .r', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: RSizedBox.square(dimension: 100)),
      );

      final RenderConstrainedBox renderBox = tester.renderObject(
        find.byType(RSizedBox),
      );

      // .square uses .r extension
      // .r uses min(scaleW, scaleH) = 2
      expect(renderBox.additionalConstraints.minWidth, 200);
      expect(renderBox.additionalConstraints.maxWidth, 200);
      expect(renderBox.additionalConstraints.minHeight, 200);
      expect(renderBox.additionalConstraints.maxHeight, 200);
    });

    testWidgets('RSizedBox.fromSize should scale size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: RSizedBox.fromSize(size: const Size(100, 50))),
      );

      final RenderConstrainedBox renderBox = tester.renderObject(
        find.byType(RSizedBox),
      );

      // .fromSize uses default constructor logic (.hw)
      expect(renderBox.additionalConstraints.minWidth, 200);
      expect(renderBox.additionalConstraints.maxWidth, 200);
      expect(renderBox.additionalConstraints.minHeight, 100);
      expect(renderBox.additionalConstraints.maxHeight, 100);
    });

    testWidgets('RSizedBox should update constraints when rebuilt', (
      tester,
    ) async {
      // Initial build
      await tester.pumpWidget(
        const MaterialApp(home: RSizedBox(width: 100, height: 50)),
      );

      RenderConstrainedBox renderBox = tester.renderObject(
        find.byType(RSizedBox),
      );

      expect(renderBox.additionalConstraints.minWidth, 200);
      expect(renderBox.additionalConstraints.minHeight, 100);

      // Rebuild with different dimensions
      await tester.pumpWidget(
        const MaterialApp(home: RSizedBox(width: 200, height: 100)),
      );

      renderBox = tester.renderObject(find.byType(RSizedBox));

      // updateRenderObject should have been called
      expect(renderBox.additionalConstraints.minWidth, 400);
      expect(renderBox.additionalConstraints.minHeight, 200);
    });

    testWidgets('RSizedBox with null dimensions should be unconstrained', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RSizedBox()));

      final RenderConstrainedBox renderBox = tester.renderObject(
        find.byType(RSizedBox),
      );

      expect(renderBox.additionalConstraints.minWidth, 0);
      expect(renderBox.additionalConstraints.maxWidth, double.infinity);
      expect(renderBox.additionalConstraints.minHeight, 0);
      expect(renderBox.additionalConstraints.maxHeight, double.infinity);
    });

    testWidgets('RSizedBox with child should render child correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RSizedBox(width: 100, height: 50, child: Text('Test Child')),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);

      final RenderConstrainedBox renderBox = tester.renderObject(
        find.byType(RSizedBox),
      );

      expect(renderBox.additionalConstraints.minWidth, 200);
      expect(renderBox.additionalConstraints.minHeight, 100);
    });

    testWidgets('RSizedBox.square with zero dimension', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RSizedBox.square(dimension: 0)),
      );

      final RenderConstrainedBox renderBox = tester.renderObject(
        find.byType(RSizedBox),
      );

      expect(renderBox.additionalConstraints.minWidth, 0);
      expect(renderBox.additionalConstraints.maxWidth, 0);
      expect(renderBox.additionalConstraints.minHeight, 0);
      expect(renderBox.additionalConstraints.maxHeight, 0);
    });
  });
}
