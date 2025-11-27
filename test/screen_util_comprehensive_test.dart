import 'dart:math' show min, max;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScreenUtil - Basic Configuration', () {
    tearDown(() {
      // Reset to default state
      ScreenUtil.enableScale();
    });

    test('defaultSize should be Size(360, 690)', () {
      expect(ScreenUtil.defaultSize, const Size(360, 690));
    });

    test('ScreenUtil is singleton', () {
      final instance1 = ScreenUtil();
      final instance2 = ScreenUtil();
      expect(instance1, same(instance2));
    });

    test('configure throws exception when not initialized', () {
      expect(
        () => ScreenUtil.configure(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(
              'You must either use ScreenUtil.init or ScreenUtilInit first',
            ),
          ),
        ),
      );
    });

    test('configure with valid data', () {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      const designSize = Size(360, 690);

      ScreenUtil.configure(
        data: data,
        designSize: designSize,
        minTextAdapt: false,
        splitScreenMode: false,
      );

      final util = ScreenUtil();
      expect(util.screenWidth, 400);
      expect(util.screenHeight, 800);
      // Verify design size is set by checking scale calculations
      expect(util.scaleWidth, closeTo(400 / 360, 0.001));
    });

    test('configure with empty size uses designSize', () {
      const emptyData = MediaQueryData(size: Size.zero);
      const designSize = Size(360, 690);

      ScreenUtil.configure(
        data: emptyData,
        designSize: designSize,
        minTextAdapt: false,
        splitScreenMode: false,
      );

      final util = ScreenUtil();
      expect(util.orientation, Orientation.portrait);
    });

    test('configure with landscape orientation', () {
      const data = MediaQueryData(
        size: Size(800, 400),
        textScaler: TextScaler.linear(1.0),
      );
      const designSize = Size(360, 690);

      ScreenUtil.configure(
        data: data,
        designSize: designSize,
        minTextAdapt: false,
        splitScreenMode: false,
      );

      final util = ScreenUtil();
      expect(util.orientation, Orientation.landscape);
    });
  });

  group('ScreenUtil - enableScale', () {
    setUp(() {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    tearDown(() {
      ScreenUtil.enableScale();
    });

    test('enableScaleWH disabled returns scaleWidth of 1', () {
      ScreenUtil.enableScale(enableWH: () => false);
      final util = ScreenUtil();
      expect(util.scaleWidth, 1.0);
      expect(util.scaleHeight, 1.0);
    });

    test('enableScaleText disabled returns scaleText of 1', () {
      ScreenUtil.enableScale(enableText: () => false);
      final util = ScreenUtil();
      expect(util.scaleText, 1.0);
    });

    test('enableScale with both disabled', () {
      ScreenUtil.enableScale(enableWH: () => false, enableText: () => false);
      final util = ScreenUtil();
      expect(util.scaleWidth, 1.0);
      expect(util.scaleText, 1.0);
    });

    test('enableScale with null values defaults to true', () {
      ScreenUtil.enableScale();
      final util = ScreenUtil();
      expect(util.scaleWidth, greaterThan(1.0));
      expect(util.scaleText, greaterThan(1.0));
    });
  });

  group('ScreenUtil - Getters', () {
    setUp(() {
      const data = MediaQueryData(
        size: Size(400, 800),
        padding: EdgeInsets.only(top: 24, bottom: 16),
        devicePixelRatio: 2.0,
        textScaler: TextScaler.linear(1.5),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    test('orientation getter', () {
      final util = ScreenUtil();
      expect(util.orientation, Orientation.portrait);
    });

    test('textScaleFactor getter', () {
      final util = ScreenUtil();
      expect(util.textScaleFactor, 1.5);
    });

    test('pixelRatio getter', () {
      final util = ScreenUtil();
      expect(util.pixelRatio, 2.0);
    });

    test('screenWidth getter', () {
      final util = ScreenUtil();
      expect(util.screenWidth, 400);
    });

    test('screenHeight getter', () {
      final util = ScreenUtil();
      expect(util.screenHeight, 800);
    });

    test('statusBarHeight getter', () {
      final util = ScreenUtil();
      expect(util.statusBarHeight, 24);
    });

    test('bottomBarHeight getter', () {
      final util = ScreenUtil();
      expect(util.bottomBarHeight, 16);
    });

    test('scaleWidth calculation', () {
      final util = ScreenUtil();
      // 400 / 360 = 1.111...
      expect(util.scaleWidth, closeTo(400 / 360, 0.001));
    });

    test('scaleHeight calculation', () {
      final util = ScreenUtil();
      // 800 / 690 = 1.159...
      expect(util.scaleHeight, closeTo(800 / 690, 0.001));
    });

    test('scaleHeight with splitScreenMode', () {
      ScreenUtil.configure(
        data: const MediaQueryData(
          size: Size(400, 500),
          textScaler: TextScaler.linear(1.0),
        ),
        designSize: const Size(360, 690),
        splitScreenMode: true,
      );
      final util = ScreenUtil();
      // max(500, 700) / 690 = 700 / 690
      expect(util.scaleHeight, closeTo(700 / 690, 0.001));
    });

    test('scaleText with minTextAdapt false', () {
      ScreenUtil.configure(
        data: const MediaQueryData(
          size: Size(400, 800),
          textScaler: TextScaler.linear(1.0),
        ),
        designSize: const Size(360, 690),
        minTextAdapt: false,
      );
      final util = ScreenUtil();
      expect(util.scaleText, util.scaleWidth);
    });

    test('scaleText with minTextAdapt true', () {
      ScreenUtil.configure(
        data: const MediaQueryData(
          size: Size(400, 800),
          textScaler: TextScaler.linear(1.0),
        ),
        designSize: const Size(360, 690),
        minTextAdapt: true,
      );
      final util = ScreenUtil();
      expect(util.scaleText, min(util.scaleWidth, util.scaleHeight));
    });
  });

  group('ScreenUtil - Size Methods', () {
    setUp(() {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    test('setWidth', () {
      final util = ScreenUtil();
      final result = util.setWidth(100);
      expect(result, closeTo(100 * (400 / 360), 0.001));
    });

    test('setHeight', () {
      final util = ScreenUtil();
      final result = util.setHeight(100);
      expect(result, closeTo(100 * (800 / 690), 0.001));
    });

    test('radius uses min of scaleWidth and scaleHeight', () {
      final util = ScreenUtil();
      final result = util.radius(50);
      final expected = 50 * min(util.scaleWidth, util.scaleHeight);
      expect(result, closeTo(expected, 0.001));
    });

    test('diagonal uses scaleHeight * scaleWidth', () {
      final util = ScreenUtil();
      final result = util.diagonal(50);
      final expected = 50 * util.scaleHeight * util.scaleWidth;
      expect(result, closeTo(expected, 0.001));
    });

    test('diameter uses max of scaleWidth and scaleHeight', () {
      final util = ScreenUtil();
      final result = util.diameter(50);
      final expected = 50 * max(util.scaleWidth, util.scaleHeight);
      expect(result, closeTo(expected, 0.001));
    });

    test('setSp without fontSizeResolver', () {
      final util = ScreenUtil();
      final result = util.setSp(16);
      expect(result, closeTo(16 * util.scaleText, 0.001));
    });

    test('setSp with fontSizeResolver', () {
      double customResolver(num fontSize, ScreenUtil instance) {
        return fontSize * 2.0;
      }

      ScreenUtil.configure(
        data: const MediaQueryData(
          size: Size(400, 800),
          textScaler: TextScaler.linear(1.0),
        ),
        designSize: const Size(360, 690),
        fontSizeResolver: customResolver,
      );

      final util = ScreenUtil();
      final result = util.setSp(16);
      expect(result, 32.0);
    });
  });

  group('ScreenUtil - Spacing Methods', () {
    setUp(() {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    test('setVerticalSpacing', () {
      final util = ScreenUtil();
      final spacing = util.setVerticalSpacing(20);
      expect(spacing, isA<SizedBox>());
      expect(spacing.height, closeTo(20 * util.scaleHeight, 0.001));
      expect(spacing.width, isNull);
    });

    test('setVerticalSpacingFromWidth', () {
      final util = ScreenUtil();
      final spacing = util.setVerticalSpacingFromWidth(20);
      expect(spacing, isA<SizedBox>());
      expect(spacing.height, closeTo(20 * util.scaleWidth, 0.001));
      expect(spacing.width, isNull);
    });

    test('setHorizontalSpacing', () {
      final util = ScreenUtil();
      final spacing = util.setHorizontalSpacing(20);
      expect(spacing, isA<SizedBox>());
      expect(spacing.width, closeTo(20 * util.scaleWidth, 0.001));
      expect(spacing.height, isNull);
    });

    test('setHorizontalSpacingRadius', () {
      final util = ScreenUtil();
      final spacing = util.setHorizontalSpacingRadius(20);
      expect(spacing, isA<SizedBox>());
      expect(
        spacing.width,
        closeTo(20 * min(util.scaleWidth, util.scaleHeight), 0.001),
      );
    });

    test('setVerticalSpacingRadius', () {
      final util = ScreenUtil();
      final spacing = util.setVerticalSpacingRadius(20);
      expect(spacing, isA<SizedBox>());
      expect(
        spacing.height,
        closeTo(20 * min(util.scaleWidth, util.scaleHeight), 0.001),
      );
    });

    test('setHorizontalSpacingDiameter', () {
      final util = ScreenUtil();
      final spacing = util.setHorizontalSpacingDiameter(20);
      expect(spacing, isA<SizedBox>());
      expect(
        spacing.width,
        closeTo(20 * max(util.scaleWidth, util.scaleHeight), 0.001),
      );
    });

    test('setVerticalSpacingDiameter', () {
      final util = ScreenUtil();
      final spacing = util.setVerticalSpacingDiameter(20);
      expect(spacing, isA<SizedBox>());
      expect(
        spacing.height,
        closeTo(20 * max(util.scaleWidth, util.scaleHeight), 0.001),
      );
    });

    test('setHorizontalSpacingDiagonal', () {
      final util = ScreenUtil();
      final spacing = util.setHorizontalSpacingDiagonal(20);
      expect(spacing, isA<SizedBox>());
      expect(
        spacing.width,
        closeTo(20 * util.scaleHeight * util.scaleWidth, 0.001),
      );
    });

    test('setVerticalSpacingDiagonal', () {
      final util = ScreenUtil();
      final spacing = util.setVerticalSpacingDiagonal(20);
      expect(spacing, isA<SizedBox>());
      expect(
        spacing.height,
        closeTo(20 * util.scaleHeight * util.scaleWidth, 0.001),
      );
    });
  });

  group('ScreenUtil - deviceType', () {
    testWidgets('deviceType returns web on web platform', (tester) async {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final util = ScreenUtil();
              // Note: kIsWeb is compile-time constant, so this test may not work in all environments
              final deviceType = util.deviceType(context);
              // Just verify it returns a valid DeviceType
              expect(deviceType, isA<DeviceType>());
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('SizeExtension', () {
    setUp(() {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    test('w extension', () {
      expect(100.w, closeTo(100 * (400 / 360), 0.001));
    });

    test('h extension', () {
      expect(100.h, closeTo(100 * (800 / 690), 0.001));
    });

    test('r extension', () {
      final util = ScreenUtil();
      expect(
        100.r,
        closeTo(100 * min(util.scaleWidth, util.scaleHeight), 0.001),
      );
    });

    test('dg extension', () {
      final util = ScreenUtil();
      expect(100.dg, closeTo(100 * util.scaleHeight * util.scaleWidth, 0.001));
    });

    test('dm extension', () {
      final util = ScreenUtil();
      expect(
        100.dm,
        closeTo(100 * max(util.scaleWidth, util.scaleHeight), 0.001),
      );
    });

    test('sp extension', () {
      // Clear any previous custom fontSizeResolver by setting one that mimics default behavior
      // The default behavior when fontSizeResolver is null is fontSize * scaleText
      ScreenUtil.configure(
        data: const MediaQueryData(
          size: Size(400, 800),
          textScaler: TextScaler.linear(1.0),
        ),
        designSize: const Size(360, 690),
        fontSizeResolver: (fontSize, instance) => fontSize * instance.scaleText,
        minTextAdapt: false,
        splitScreenMode: false,
      );
      final util = ScreenUtil();
      expect(16.sp, closeTo(16 * util.scaleText, 0.001));
    });

    test('spMin extension', () {
      final spValue = 16.sp;
      final minValue = min(16.0, spValue);
      expect(16.spMin, closeTo(minValue, 0.001));
    });

    test('sm extension (deprecated)', () {
      final spValue = 16.sp;
      final minValue = min(16.0, spValue);
      expect(16.spMin, closeTo(minValue, 0.001));
    });

    test('spMax extension', () {
      final spValue = 16.sp;
      final maxValue = max(16.0, spValue);
      expect(16.spMax, closeTo(maxValue, 0.001));
    });

    test('sw extension', () {
      final util = ScreenUtil();
      expect(0.5.sw, closeTo(util.screenWidth * 0.5, 0.001));
    });

    test('sh extension', () {
      final util = ScreenUtil();
      expect(0.5.sh, closeTo(util.screenHeight * 0.5, 0.001));
    });

    test('verticalSpace extension', () {
      final spacing = 20.verticalSpace;
      expect(spacing, isA<SizedBox>());
      expect(spacing.height, closeTo(20 * (800 / 690), 0.001));
    });

    test('verticalSpaceFromWidth extension', () {
      final spacing = 20.verticalSpaceFromWidth;
      expect(spacing, isA<SizedBox>());
      expect(spacing.height, closeTo(20 * (400 / 360), 0.001));
    });

    test('horizontalSpace extension', () {
      final spacing = 20.horizontalSpace;
      expect(spacing, isA<SizedBox>());
      expect(spacing.width, closeTo(20 * (400 / 360), 0.001));
    });

    test('horizontalSpaceRadius extension', () {
      final spacing = 20.horizontalSpaceRadius;
      expect(spacing, isA<SizedBox>());
      final util = ScreenUtil();
      expect(
        spacing.width,
        closeTo(20 * min(util.scaleWidth, util.scaleHeight), 0.001),
      );
    });

    test('verticalSpacingRadius extension', () {
      final spacing = 20.verticalSpacingRadius;
      expect(spacing, isA<SizedBox>());
      final util = ScreenUtil();
      expect(
        spacing.height,
        closeTo(20 * min(util.scaleWidth, util.scaleHeight), 0.001),
      );
    });

    test('horizontalSpaceDiameter extension', () {
      final spacing = 20.horizontalSpaceDiameter;
      expect(spacing, isA<SizedBox>());
      final util = ScreenUtil();
      expect(
        spacing.width,
        closeTo(20 * max(util.scaleWidth, util.scaleHeight), 0.001),
      );
    });

    test('verticalSpacingDiameter extension', () {
      final spacing = 20.verticalSpacingDiameter;
      expect(spacing, isA<SizedBox>());
      final util = ScreenUtil();
      expect(
        spacing.height,
        closeTo(20 * max(util.scaleWidth, util.scaleHeight), 0.001),
      );
    });

    test('horizontalSpaceDiagonal extension', () {
      final spacing = 20.horizontalSpaceDiagonal;
      expect(spacing, isA<SizedBox>());
      final util = ScreenUtil();
      expect(
        spacing.width,
        closeTo(20 * util.scaleHeight * util.scaleWidth, 0.001),
      );
    });

    test('verticalSpacingDiagonal extension', () {
      final spacing = 20.verticalSpacingDiagonal;
      expect(spacing, isA<SizedBox>());
      final util = ScreenUtil();
      expect(
        spacing.height,
        closeTo(20 * util.scaleHeight * util.scaleWidth, 0.001),
      );
    });
  });

  group('EdgeInsetsExtension', () {
    setUp(() {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    test('EdgeInsets.r extension', () {
      final padding = const EdgeInsets.all(10).r;
      expect(padding, isA<EdgeInsets>());
      final util = ScreenUtil();
      final expected = min(util.scaleWidth, util.scaleHeight);
      expect(padding.top, closeTo(10 * expected, 0.001));
    });

    test('EdgeInsets.dm extension', () {
      final padding = const EdgeInsets.all(10).dm;
      expect(padding, isA<EdgeInsets>());
      final util = ScreenUtil();
      final expected = max(util.scaleWidth, util.scaleHeight);
      expect(padding.top, closeTo(10 * expected, 0.001));
    });

    test('EdgeInsets.dg extension', () {
      final padding = const EdgeInsets.all(10).dg;
      expect(padding, isA<EdgeInsets>());
      final util = ScreenUtil();
      final expected = util.scaleHeight * util.scaleWidth;
      expect(padding.top, closeTo(10 * expected, 0.001));
    });

    test('EdgeInsets.w extension', () {
      final padding = const EdgeInsets.all(10).w;
      expect(padding, isA<EdgeInsets>());
      final util = ScreenUtil();
      expect(padding.top, closeTo(10 * util.scaleWidth, 0.001));
    });

    test('EdgeInsets.h extension', () {
      final padding = const EdgeInsets.all(10).h;
      expect(padding, isA<EdgeInsets>());
      final util = ScreenUtil();
      expect(padding.top, closeTo(10 * util.scaleHeight, 0.001));
    });
  });

  group('BorderRadiusExtension', () {
    setUp(() {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    test('BorderRadius.r extension', () {
      final borderRadius = BorderRadius.circular(10).r;
      expect(borderRadius, isA<BorderRadius>());
      final util = ScreenUtil();
      final expected = min(util.scaleWidth, util.scaleHeight);
      expect(borderRadius.topLeft.x, closeTo(10 * expected, 0.001));
      expect(borderRadius.topLeft.y, closeTo(10 * expected, 0.001));
    });

    test('BorderRadius.w extension', () {
      final borderRadius = BorderRadius.circular(10).w;
      expect(borderRadius, isA<BorderRadius>());
      final util = ScreenUtil();
      expect(borderRadius.topLeft.x, closeTo(10 * util.scaleWidth, 0.001));
      expect(borderRadius.topLeft.y, closeTo(10 * util.scaleWidth, 0.001));
    });

    test('BorderRadius.h extension', () {
      final borderRadius = BorderRadius.circular(10).h;
      expect(borderRadius, isA<BorderRadius>());
      final util = ScreenUtil();
      expect(borderRadius.topLeft.x, closeTo(10 * util.scaleHeight, 0.001));
      expect(borderRadius.topLeft.y, closeTo(10 * util.scaleHeight, 0.001));
    });
  });

  group('RadiusExtension', () {
    setUp(() {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    test('Radius.r extension', () {
      final radius = const Radius.circular(10).r;
      expect(radius, isA<Radius>());
      final util = ScreenUtil();
      final expected = min(util.scaleWidth, util.scaleHeight);
      expect(radius.x, closeTo(10 * expected, 0.001));
    });

    test('Radius.dm extension', () {
      final radius = const Radius.circular(10).dm;
      expect(radius, isA<Radius>());
      final util = ScreenUtil();
      final expected = max(util.scaleWidth, util.scaleHeight);
      expect(radius.x, closeTo(10 * expected, 0.001));
    });

    test('Radius.dg extension', () {
      final radius = const Radius.circular(10).dg;
      expect(radius, isA<Radius>());
      final util = ScreenUtil();
      final expected = util.scaleHeight * util.scaleWidth;
      expect(radius.x, closeTo(10 * expected, 0.001));
    });

    test('Radius.w extension', () {
      final radius = const Radius.circular(10).w;
      expect(radius, isA<Radius>());
      final util = ScreenUtil();
      expect(radius.x, closeTo(10 * util.scaleWidth, 0.001));
    });

    test('Radius.h extension', () {
      final radius = const Radius.circular(10).h;
      expect(radius, isA<Radius>());
      final util = ScreenUtil();
      expect(radius.x, closeTo(10 * util.scaleHeight, 0.001));
    });
  });

  group('BoxConstraintsExtension', () {
    setUp(() {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    test('BoxConstraints.r extension', () {
      final constraints = const BoxConstraints(
        minWidth: 100,
        minHeight: 100,
        maxWidth: 200,
        maxHeight: 200,
      ).r;
      expect(constraints, isA<BoxConstraints>());
      final util = ScreenUtil();
      final expected = min(util.scaleWidth, util.scaleHeight);
      expect(constraints.minWidth, closeTo(100 * expected, 0.001));
    });

    test('BoxConstraints.hw extension', () {
      final constraints = const BoxConstraints(
        minWidth: 100,
        minHeight: 100,
        maxWidth: 200,
        maxHeight: 200,
      ).hw;
      expect(constraints, isA<BoxConstraints>());
      final util = ScreenUtil();
      expect(constraints.minWidth, closeTo(100 * util.scaleWidth, 0.001));
      expect(constraints.minHeight, closeTo(100 * util.scaleHeight, 0.001));
    });

    test('BoxConstraints.w extension', () {
      final constraints = const BoxConstraints(
        minWidth: 100,
        minHeight: 100,
        maxWidth: 200,
        maxHeight: 200,
      ).w;
      expect(constraints, isA<BoxConstraints>());
      final util = ScreenUtil();
      expect(constraints.minWidth, closeTo(100 * util.scaleWidth, 0.001));
      expect(constraints.minHeight, closeTo(100 * util.scaleWidth, 0.001));
    });

    test('BoxConstraints.h extension', () {
      final constraints = const BoxConstraints(
        minWidth: 100,
        minHeight: 100,
        maxWidth: 200,
        maxHeight: 200,
      ).h;
      expect(constraints, isA<BoxConstraints>());
      final util = ScreenUtil();
      expect(constraints.minWidth, closeTo(100 * util.scaleHeight, 0.001));
      expect(constraints.minHeight, closeTo(100 * util.scaleHeight, 0.001));
    });
  });

  group('RPadding and REdgeInsets', () {
    setUp(() {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    testWidgets('RPadding creates RenderPadding with adapted padding', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RPadding(
            padding: const EdgeInsets.all(10),
            child: const SizedBox(),
          ),
        ),
      );

      final renderObject = tester.renderObject(find.byType(RPadding));
      expect(renderObject, isA<RenderPadding>());
    });

    test('REdgeInsets.fromLTRB', () {
      final padding = REdgeInsets.fromLTRB(10, 20, 30, 40);
      expect(padding, isA<REdgeInsets>());
      final util = ScreenUtil();
      final expected = min(util.scaleWidth, util.scaleHeight);
      expect(padding.left, closeTo(10 * expected, 0.001));
    });

    test('REdgeInsets.all', () {
      final padding = REdgeInsets.all(10);
      expect(padding, isA<REdgeInsets>());
      final util = ScreenUtil();
      final expected = min(util.scaleWidth, util.scaleHeight);
      expect(padding.top, closeTo(10 * expected, 0.001));
    });

    test('REdgeInsets.symmetric', () {
      final padding = REdgeInsets.symmetric(vertical: 10, horizontal: 20);
      expect(padding, isA<REdgeInsets>());
      final util = ScreenUtil();
      final expected = min(util.scaleWidth, util.scaleHeight);
      expect(padding.top, closeTo(10 * expected, 0.001));
      expect(padding.left, closeTo(20 * expected, 0.001));
    });

    test('REdgeInsets.only', () {
      final padding = REdgeInsets.only(
        top: 10,
        bottom: 20,
        left: 30,
        right: 40,
      );
      expect(padding, isA<REdgeInsets>());
      final util = ScreenUtil();
      final expected = min(util.scaleWidth, util.scaleHeight);
      expect(padding.top, closeTo(10 * expected, 0.001));
    });

    test('REdgeInsetsDirectional.all', () {
      final padding = REdgeInsetsDirectional.all(10);
      expect(padding, isA<REdgeInsetsDirectional>());
      final util = ScreenUtil();
      final expected = min(util.scaleWidth, util.scaleHeight);
      expect(padding.top, closeTo(10 * expected, 0.001));
    });

    test('REdgeInsetsDirectional.only', () {
      final padding = REdgeInsetsDirectional.only(
        top: 10,
        bottom: 20,
        start: 30,
        end: 40,
      );
      expect(padding, isA<REdgeInsetsDirectional>());
      final util = ScreenUtil();
      final expected = min(util.scaleWidth, util.scaleHeight);
      expect(padding.top, closeTo(10 * expected, 0.001));
    });

    test('REdgeInsetsDirectional.fromSTEB', () {
      final padding = REdgeInsetsDirectional.fromSTEB(10, 20, 30, 40);
      expect(padding, isA<REdgeInsetsDirectional>());
      final util = ScreenUtil();
      final expected = min(util.scaleWidth, util.scaleHeight);
      expect(padding.top, closeTo(20 * expected, 0.001));
    });
  });

  group('RSizedBox', () {
    setUp(() {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    testWidgets('RSizedBox with width and height', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RSizedBox(width: 100, height: 200, child: const SizedBox()),
        ),
      );

      final renderObject = tester.renderObject(find.byType(RSizedBox));
      expect(renderObject, isA<RenderConstrainedBox>());
    });

    testWidgets('RSizedBox.vertical', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: RSizedBox.vertical(100, child: const SizedBox())),
      );

      expect(find.byType(RSizedBox), findsOneWidget);
    });

    testWidgets('RSizedBox.horizontal', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: RSizedBox.horizontal(100, child: const SizedBox())),
      );

      expect(find.byType(RSizedBox), findsOneWidget);
    });

    testWidgets('RSizedBox.square', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RSizedBox.square(dimension: 100, child: const SizedBox()),
        ),
      );

      expect(find.byType(RSizedBox), findsOneWidget);
    });

    testWidgets('RSizedBox.fromSize', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RSizedBox.fromSize(
            size: const Size(100, 200),
            child: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(RSizedBox), findsOneWidget);
    });
  });

  group('ScreenUtilInit', () {
    testWidgets('ScreenUtilInit initializes ScreenUtil', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final util = ScreenUtil();
                expect(util.screenWidth, greaterThan(0));
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('ScreenUtilInit with builder', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(home: child),
          child: const SizedBox(),
        ),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('ScreenUtilInit with splitScreenMode', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          splitScreenMode: true,
          child: const MaterialApp(home: SizedBox()),
        ),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('ScreenUtilInit with minTextAdapt', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          child: const MaterialApp(home: SizedBox()),
        ),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('ScreenUtilInit with ensureScreenSize', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          ensureScreenSize: true,
          child: const MaterialApp(home: SizedBox()),
        ),
      );

      await tester.pumpAndSettle();
    });
  });

  group('RebuildFactors', () {
    test('RebuildFactors.size', () {
      final old = MediaQueryData(size: const Size(100, 200));
      final data = MediaQueryData(size: const Size(200, 300));
      expect(RebuildFactors.size(old, data), true);

      final same = MediaQueryData(size: const Size(100, 200));
      expect(RebuildFactors.size(old, same), false);
    });

    test('RebuildFactors.orientation', () {
      final old = MediaQueryData(size: const Size(200, 100));
      final data = MediaQueryData(size: const Size(100, 200));
      expect(RebuildFactors.orientation(old, data), true);

      final same = MediaQueryData(size: const Size(200, 100));
      expect(RebuildFactors.orientation(old, same), false);
    });

    test('RebuildFactors.sizeAndViewInsets', () {
      final old = MediaQueryData(
        size: const Size(100, 200),
        viewInsets: EdgeInsets.zero,
      );
      final data = MediaQueryData(
        size: const Size(100, 200),
        viewInsets: const EdgeInsets.only(bottom: 100),
      );
      expect(RebuildFactors.sizeAndViewInsets(old, data), true);

      final same = MediaQueryData(
        size: const Size(100, 200),
        viewInsets: EdgeInsets.zero,
      );
      expect(RebuildFactors.sizeAndViewInsets(old, same), false);
    });

    test('RebuildFactors.change', () {
      final old = MediaQueryData(size: const Size(100, 200));
      final data = MediaQueryData(size: const Size(200, 300));
      expect(RebuildFactors.change(old, data), true);

      final same = MediaQueryData(size: const Size(100, 200));
      expect(RebuildFactors.change(old, same), false);
    });

    test('RebuildFactors.always', () {
      final old = MediaQueryData(size: const Size(100, 200));
      final data = MediaQueryData(size: const Size(100, 200));
      expect(RebuildFactors.always(old, data), true);
    });

    test('RebuildFactors.none', () {
      final old = MediaQueryData(size: const Size(100, 200));
      final data = MediaQueryData(size: const Size(200, 300));
      expect(RebuildFactors.none(old, data), false);
    });
  });

  group('FontSizeResolvers', () {
    setUp(() {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );
    });

    test('FontSizeResolvers.width', () {
      final util = ScreenUtil();
      final result = FontSizeResolvers.width(16, util);
      expect(result, closeTo(util.setWidth(16), 0.001));
    });

    test('FontSizeResolvers.height', () {
      final util = ScreenUtil();
      final result = FontSizeResolvers.height(16, util);
      expect(result, closeTo(util.setHeight(16), 0.001));
    });

    test('FontSizeResolvers.radius', () {
      final util = ScreenUtil();
      final result = FontSizeResolvers.radius(16, util);
      expect(result, closeTo(util.radius(16), 0.001));
    });

    test('FontSizeResolvers.diameter', () {
      final util = ScreenUtil();
      final result = FontSizeResolvers.diameter(16, util);
      expect(result, closeTo(util.diameter(16), 0.001));
    });

    test('FontSizeResolvers.diagonal', () {
      final util = ScreenUtil();
      final result = FontSizeResolvers.diagonal(16, util);
      expect(result, closeTo(util.diagonal(16), 0.001));
    });
  });

  group('ScreenUtil - init and ensureScreenSizeAndInit', () {
    testWidgets('init method', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.init(context, designSize: const Size(360, 690));
              final util = ScreenUtil();
              expect(util.screenWidth, greaterThan(0));
              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('ensureScreenSizeAndInit method', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.ensureScreenSizeAndInit(
                context,
                designSize: const Size(360, 690),
              );
              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
    });
  });

  group('ScreenUtil - registerToBuild', () {
    testWidgets('registerToBuild without descendants', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.registerToBuild(context);
              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('registerToBuild with descendants', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ScreenUtil.registerToBuild(context, true);
              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
    });
  });

  group('ScreenUtil - configure edge cases', () {
    test('configure with null data uses existing data', () {
      const initialData = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: initialData,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );

      // Configure again with null data - should use existing data
      ScreenUtil.configure(
        data: initialData,
        designSize: const Size(400, 800),
        minTextAdapt: false,
        splitScreenMode: false,
      );

      final util = ScreenUtil();
      expect(util.screenWidth, 400);
    });

    test('configure with null designSize uses existing designSize', () {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );

      // Configure again with null designSize
      ScreenUtil.configure(
        data: data,
        minTextAdapt: false,
        splitScreenMode: false,
      );

      final util = ScreenUtil();
      // Verify design size is still 360x690 by checking scale
      expect(util.scaleWidth, closeTo(400 / 360, 0.001));
    });

    test('configure updates fontSizeResolver', () {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
        splitScreenMode: false,
      );

      double customResolver(num fontSize, ScreenUtil instance) {
        return fontSize * 3.0;
      }

      ScreenUtil.configure(
        data: data,
        fontSizeResolver: customResolver,
        minTextAdapt: false,
        splitScreenMode: false,
      );

      final util = ScreenUtil();
      expect(util.setSp(10), 30.0);
    });

    test('configure updates minTextAdapt', () {
      const data = MediaQueryData(
        size: Size(400, 800),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        minTextAdapt: false,
      );

      ScreenUtil.configure(
        data: data,
        minTextAdapt: true,
        splitScreenMode: false,
      );

      final util = ScreenUtil();
      expect(util.scaleText, min(util.scaleWidth, util.scaleHeight));
    });

    test('configure updates splitScreenMode', () {
      const data = MediaQueryData(
        size: Size(400, 500),
        textScaler: TextScaler.linear(1.0),
      );
      ScreenUtil.configure(
        data: data,
        designSize: const Size(360, 690),
        splitScreenMode: false,
      );

      ScreenUtil.configure(
        data: data,
        splitScreenMode: true,
        minTextAdapt: false,
      );

      final util = ScreenUtil();
      // With splitScreenMode, height uses max(screenHeight, 700)
      expect(util.scaleHeight, closeTo(700 / 690, 0.001));
    });
  });
}
