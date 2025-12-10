import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RPadding and REdgeInsets Tests', () {
    const deviceSize = Size(720, 1380); // 2x scale

    setUp(() {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        minTextAdapt: true,
        splitScreenMode: false,
      );
    });

    group('REdgeInsets', () {
      test('fromLTRB should scale all values', () {
        final insets = REdgeInsets.fromLTRB(10, 20, 30, 40);
        expect(insets.left, 20); // 10 * 2
        expect(insets.top, 40); // 20 * 2
        expect(insets.right, 60); // 30 * 2
        expect(insets.bottom, 80); // 40 * 2
      });

      test('all should scale value', () {
        final insets = REdgeInsets.all(10);
        expect(insets.left, 20);
        expect(insets.top, 20);
        expect(insets.right, 20);
        expect(insets.bottom, 20);
      });

      test('symmetric should scale vertical and horizontal', () {
        final insets = REdgeInsets.symmetric(vertical: 10, horizontal: 20);
        expect(insets.top, 20); // 10 * 2
        expect(insets.bottom, 20);
        expect(insets.left, 40); // 20 * 2
        expect(insets.right, 40);
      });

      test('symmetric with only vertical should scale correctly', () {
        final insets = REdgeInsets.symmetric(vertical: 10);
        expect(insets.top, 20);
        expect(insets.bottom, 20);
        expect(insets.left, 0);
        expect(insets.right, 0);
      });

      test('symmetric with only horizontal should scale correctly', () {
        final insets = REdgeInsets.symmetric(horizontal: 10);
        expect(insets.top, 0);
        expect(insets.bottom, 0);
        expect(insets.left, 20);
        expect(insets.right, 20);
      });

      test('only should scale specified values', () {
        final insets = REdgeInsets.only(left: 10, top: 20);
        expect(insets.left, 20);
        expect(insets.top, 40);
        expect(insets.right, 0);
        expect(insets.bottom, 0);
      });

      test('only with all parameters should scale correctly', () {
        final insets = REdgeInsets.only(
          left: 10,
          top: 20,
          right: 30,
          bottom: 40,
        );
        expect(insets.left, 20);
        expect(insets.top, 40);
        expect(insets.right, 60);
        expect(insets.bottom, 80);
      });
    });

    group('REdgeInsetsDirectional', () {
      test('all should scale value', () {
        final insets = REdgeInsetsDirectional.all(10);
        expect(insets.start, 20);
        expect(insets.top, 20);
        expect(insets.end, 20);
        expect(insets.bottom, 20);
      });

      test('only should scale specified values', () {
        final insets = REdgeInsetsDirectional.only(start: 10, top: 20);
        expect(insets.start, 20);
        expect(insets.top, 40);
        expect(insets.end, 0);
        expect(insets.bottom, 0);
      });

      test('only with all parameters should scale correctly', () {
        final insets = REdgeInsetsDirectional.only(
          start: 10,
          top: 20,
          end: 30,
          bottom: 40,
        );
        expect(insets.start, 20);
        expect(insets.top, 40);
        expect(insets.end, 60);
        expect(insets.bottom, 80);
      });

      test('fromSTEB should scale all values', () {
        final insets = REdgeInsetsDirectional.fromSTEB(10, 20, 30, 40);
        expect(insets.start, 20);
        expect(insets.top, 40);
        expect(insets.end, 60);
        expect(insets.bottom, 80);
      });

      test('only with no parameters should result in zero values', () {
        final insets = REdgeInsetsDirectional.only();
        expect(insets.start, 0);
        expect(insets.top, 0);
        expect(insets.end, 0);
        expect(insets.bottom, 0);
      });
    });

    group('REdgeInsets Additional Coverage', () {
      test('all with zero should be zero', () {
        final insets = REdgeInsets.all(0);
        expect(insets.left, 0);
        expect(insets.top, 0);
        expect(insets.right, 0);
        expect(insets.bottom, 0);
      });

      test('only default values', () {
        final insets = REdgeInsets.only(left: 10);
        expect(insets.left, 20);
        expect(insets.right, 0);
      });
    });

    group('RPadding Widget', () {
      testWidgets('should apply scaled padding with EdgeInsets', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: RPadding(
              padding: const EdgeInsets.all(10),
              child: Container(),
            ),
          ),
        );

        final RenderPadding renderPadding = tester.renderObject(
          find.byType(RPadding),
        );

        // EdgeInsets.all(10) should be scaled to 20 via .r extension
        final padding = renderPadding.padding as EdgeInsets;
        expect(padding.left, 20);
        expect(padding.top, 20);
        expect(padding.right, 20);
        expect(padding.bottom, 20);
      });

      testWidgets('should apply scaled padding with REdgeInsets', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: RPadding(padding: REdgeInsets.all(10), child: Container()),
          ),
        );

        final RenderPadding renderPadding = tester.renderObject(
          find.byType(RPadding),
        );

        // REdgeInsets.all(10) already scales to 20, so it should stay 20
        final padding = renderPadding.padding as EdgeInsets;
        expect(padding.left, 20);
        expect(padding.top, 20);
        expect(padding.right, 20);
        expect(padding.bottom, 20);
      });

      testWidgets('should apply asymmetric padding correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: RPadding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: Container(),
            ),
          ),
        );

        final RenderPadding renderPadding = tester.renderObject(
          find.byType(RPadding),
        );

        final padding = renderPadding.padding as EdgeInsets;
        expect(padding.left, 20);
        expect(padding.top, 40);
        expect(padding.right, 0);
        expect(padding.bottom, 0);
      });

      testWidgets('should handle child widget correctly', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: RPadding(
              padding: EdgeInsets.all(10),
              child: Text('Test Child'),
            ),
          ),
        );

        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('should work with Directionality', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: RPadding(
                padding: const EdgeInsets.all(10),
                child: Container(),
              ),
            ),
          ),
        );

        final RenderPadding renderPadding = tester.renderObject(
          find.byType(RPadding),
        );

        expect(renderPadding.textDirection, TextDirection.rtl);
      });
    });
  });
}
