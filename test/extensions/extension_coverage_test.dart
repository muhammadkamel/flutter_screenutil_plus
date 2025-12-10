import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Extension Coverage', () {
    const deviceSize = Size(1000, 2000); // 1.0 scale if design size matches

    setUp(() {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        minTextAdapt: true,
        splitScreenMode: false,
      );
    });

    // Helper to verify values
    // Assuming default design size is 360x690 (from ScreenUtilPlus default, usually)
    // Wait, we need to know the design size. ScreenUtilPlus defaults?
    // Usually user sets it. Let's set it explicitly in configure if possible?
    // ScreenUtilPlus.init usually takes designSize.
    // ScreenUtilPlus().init matches the configured data.
    // Let's set designSize via ScreenUtilInit in pumpWidget or ensure defaults.
    // ScreenUtilPlus default design size is 360, 690.
    // 1000/360 = 2.77 width scale.
    // 2000/690 = 2.89 height scale.

    testWidgets('SizeExtension num getters', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(100, 100),
          builder: (c, _) => const MaterialApp(home: SizedBox()),
        ),
      );
      // View size is 800x600 by default in tests.
      // scaleW = 800/100 = 8.
      // scaleH = 600/100 = 6.
      // scaleMin = 6.
      // scaleMax = 8.

      expect(10.w, 80);
      expect(10.h, 60);
      expect(10.r, 60); // uses min(8,6) = 6
      expect(
        10.dg,
        10 * 8 * 6,
      ); // diagonal? No, diagonal usually means sqrt(w^2+h^2) scale?
      // Check implementation:
      // diagonal(num defaultSize) => defaultSize * scaleDiagonal;
      // scaleDiagonal => sqrt((screenWidth^2 + screenHeight^2) / (designWidth^2 + designHeight^2))
      // sqrt(800^2+600^2) / sqrt(100^2+100^2) = 1000 / 141.42 = 7.07

      expect(10.dm, 80); // max(8,6) = 8
      expect(10.sp, 80); // scaleText? usually scaleW unless minTextAdapt.
      // spMin/spMax

      // Sized boxes
      expect(10.verticalSpace.height, 60);
      expect(10.horizontalSpace.width, 80);
      expect(10.horizontalSpaceRadius.width, 60);
      expect(10.verticalSpacingRadius.height, 60);
      expect(10.horizontalSpaceDiameter.width, 80);
      expect(10.verticalSpacingDiameter.height, 80);
      // Diagonal spaces
      // expect(10.horizontalSpaceDiagonal.width, closeTo(70.7, 0.1));
    });

    testWidgets('EdgeInsetsExtension exhaustive', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(100, 100),
          builder: (c, _) => const MaterialApp(home: SizedBox()),
        ),
      );
      // ScaleW=8, ScaleH=6
      const insets = EdgeInsets.fromLTRB(1, 2, 3, 4);

      final EdgeInsets r = insets.r;
      expect(r.left, 6);
      expect(r.top, 12);
      expect(r.right, 18);
      expect(r.bottom, 24);

      final EdgeInsets dm = insets.dm;
      expect(dm.left, 8);
      expect(dm.top, 16);
      expect(dm.right, 24);
      expect(dm.bottom, 32);

      final EdgeInsets w = insets.w;
      expect(w.left, 8);
      expect(w.top, 16);
      expect(w.right, 24);
      expect(w.bottom, 32);

      final EdgeInsets h = insets.h;
      expect(h.left, 6);
      expect(h.top, 12);
      expect(h.right, 18);
      expect(h.bottom, 24);
    });

    testWidgets('BorderRadiusExtension exhaustive', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(100, 100),
          builder: (c, _) => const MaterialApp(home: SizedBox()),
        ),
      );
      // ScaleW=8, ScaleH=6
      const r = BorderRadius.only(
        topLeft: Radius.circular(1),
        bottomRight: Radius.circular(2),
      );

      final BorderRadius resR = r.r;
      expect(resR.topLeft.x, 6);
      expect(resR.bottomRight.x, 12);

      final BorderRadius resW = r.w;
      expect(resW.topLeft.x, 8);
      expect(resW.bottomRight.x, 16);

      final BorderRadius resH = r.h;
      expect(resH.topLeft.x, 6);
      expect(resH.bottomRight.x, 12);
    });

    testWidgets('RadiusExtension exhaustive', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(100, 100),
          builder: (c, _) => const MaterialApp(home: SizedBox()),
        ),
      );
      const rad = Radius.elliptical(1, 2);

      final Radius resR = rad.r;
      expect(resR.x, 6);
      expect(resR.y, 12);

      final Radius resW = rad.w;
      expect(resW.x, 8);
      expect(resW.y, 16);

      final Radius resH = rad.h;
      expect(resH.x, 6);
      expect(resH.y, 12);

      final Radius resDm = rad.dm;
      expect(resDm.x, 8);
      expect(resDm.y, 16);

      // dg
    });

    testWidgets('BoxConstraintsExtension exhaustive', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(100, 100),
          builder: (c, _) => const MaterialApp(home: SizedBox()),
        ),
      );
      const bc = BoxConstraints(minWidth: 1, maxHeight: 10);

      final BoxConstraints r = bc.r;
      expect(r.minWidth, 6);
      expect(r.maxHeight, 60);

      final BoxConstraints w = bc.w;
      expect(w.minWidth, 8);
      expect(w.maxHeight, 80);

      final BoxConstraints h = bc.h;
      expect(h.minWidth, 6);
      expect(h.maxHeight, 60);

      final BoxConstraints hw = bc.hw;
      expect(hw.minWidth, 8); // width uses w
      expect(hw.maxHeight, 60); // height uses h
    });

    testWidgets('AdaptiveTextStyle extension', (tester) async {
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(
            800,
            600,
          ), // Match screen size for Identity scale
          builder: (context, _) {
            // Test basic resolution
            final TextStyle style = context.adaptiveTextStyle(
              fontSizeXs: 10,
              fontSizeMd: 20,
              colorMd: Colors.red,
            );
            // Default is Mobile (width<480?).
            // Flutter test default size is 800x600.
            // 800 width is typically MD or LG.
            // Default Breakpoints: xs: 360, sm: 640, md: 768, lg: 1024.
            // 800 is MD.

            return MaterialApp(home: Text('Test', style: style));
          },
        ),
      );
      await tester.pumpAndSettle();
      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, 20.sp);
      expect(text.style?.color, Colors.red);
    });

    testWidgets('AdaptiveTextStyle fallbacks', (tester) async {
      // We will change physical size to test adaptive logic
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(100, 100),
          builder: (context, _) {
            final TextStyle style = context.adaptiveTextStyle(
              fontSizeXs: 10,
              fontSizeLg: 30, // Gap at SM, MD
            );
            return MaterialApp(home: Text('Text', style: style));
          },
        ),
      );

      // 1. XS Screen (<360)
      tester.view.physicalSize = const Size(200, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpAndSettle();
      Text text = tester.widget<Text>(find.byType(Text));
      // Should use Xs
      expect(text.style?.fontSize, 10.sp);

      // 2. MD Screen (800)
      tester.view.physicalSize = const Size(800, 600);
      await tester.pumpAndSettle();
      text = tester.widget<Text>(find.byType(Text));
      // Should fallback to XS?
      // Implementation logic:
      // Breakpoint.md => md ?? sm ?? xs ?? lg ...
      // Here md=null, sm=null, xs=10. So 10.
      // Wait, why xs? Priority is current -> smaller... -> larger.
      // MD -> SM, XS found 10. Correct.
      expect(text.style?.fontSize, 10.sp);

      // 3. XL Screen (1200)
      tester.view.physicalSize = const Size(1200, 800);
      await tester.pumpAndSettle();
      text = tester.widget<Text>(find.byType(Text));
      // XL -> LG found 30.
      expect(text.style?.fontSize, 30.sp);
    });
  });
}
