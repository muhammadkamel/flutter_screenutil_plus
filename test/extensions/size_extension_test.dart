import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SizeExtension', () {
    const deviceSize = Size(720, 1380); // 2x scale

    setUp(() {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        minTextAdapt: true,
        splitScreenMode: false,
      );
    });

    test('Numeric extensions should scale correctly', () {
      // Width (scale = 2)
      expect(10.w, 20);
      // Height (scale = 2)
      expect(10.h, 20);
      // Radius (min(scaleW, scaleH) = 2)
      expect(10.r, 20);
      // Diagonal (scaleW * scaleH = 4)
      expect(10.dg, 40); // 10 * 2 * 2
      // Diameter (max(scaleW, scaleH) = 2)
      expect(10.dm, 20);
      // SP (scaleText = 2)
      expect(10.sp, 20);

      // spMin/spMax
      // 10.sp is 20.
      // spMin = min(10, 20) = 10
      expect(10.spMin, 10);
      // spMax = max(10, 20) = 20
      expect(10.spMax, 20);

      // sw/sh
      expect(0.5.sw, 360); // 0.5 * 720
      expect(0.5.sh, 690); // 0.5 * 1380
    });

    test('SizedBox getters should return correct SizedBox', () {
      expect(10.verticalSpace.height, 20);
      expect(10.verticalSpaceFromWidth.height, 20); // uses setWidth -> 20
      expect(10.horizontalSpace.width, 20);
      expect(10.horizontalSpaceRadius.width, 20);
      expect(10.verticalSpacingRadius.height, 20);
      expect(10.horizontalSpaceDiameter.width, 20);
      expect(10.verticalSpacingDiameter.height, 20);
      expect(10.horizontalSpaceDiagonal.width, 40);
      expect(10.verticalSpacingDiagonal.height, 40);
    });

    test('EdgeInsetsExtension should scale correctly', () {
      const insets = EdgeInsets.all(10);

      // .r -> scale 2
      expect(insets.r, const EdgeInsets.all(20));
      // .dm -> scale 2
      expect(insets.dm, const EdgeInsets.all(20));
      // .dg -> scale 4
      expect(insets.dg, const EdgeInsets.all(40));
      // .w -> scale 2
      expect(insets.w, const EdgeInsets.all(20));
      // .h -> scale 2
      expect(insets.h, const EdgeInsets.all(20));
    });

    test('BorderRadiusExtension should scale correctly', () {
      final radius = BorderRadius.circular(10);

      // .r -> scale 2
      expect(radius.r.topLeft.x, 20);
      // .w -> scale 2
      expect(radius.w.topLeft.x, 20);
      // .h -> scale 2
      expect(radius.h.topLeft.x, 20);
    });

    test('RadiusExtension should scale correctly', () {
      const radius = Radius.circular(10);

      // .r -> scale 2
      expect(radius.r.x, 20);
      // .dm -> scale 2
      expect(radius.dm.x, 20);
      // .dg -> scale 4
      expect(radius.dg.x, 40);
      // .w -> scale 2
      expect(radius.w.x, 20);
      // .h -> scale 2
      expect(radius.h.x, 20);
    });

    test('BoxConstraintsExtension should scale correctly', () {
      const constraints = BoxConstraints(
        minWidth: 10,
        maxWidth: 20,
        minHeight: 10,
        maxHeight: 20,
      );

      // .r -> scale 2
      final BoxConstraints r = constraints.r;
      expect(r.minWidth, 20);
      expect(r.maxWidth, 40);
      expect(r.minHeight, 20);
      expect(r.maxHeight, 40);

      // .hw -> width uses w (2), height uses h (2) - equivalent here
      final BoxConstraints hw = constraints.hw;
      expect(hw.minWidth, 20);
      expect(hw.maxWidth, 40);
      expect(hw.minHeight, 20);
      expect(hw.maxHeight, 40);

      // .w -> scale 2
      final BoxConstraints w = constraints.w;
      expect(w.minWidth, 20);
      expect(w.maxWidth, 40);
      expect(w.minHeight, 20);
      expect(w.maxHeight, 40);

      // .h -> scale 2
      final BoxConstraints h = constraints.h;
      expect(h.minHeight, 20);
      expect(h.maxHeight, 40);
      // Also check other dimensions scaled by h
      expect(h.minWidth, 20);
      expect(h.maxWidth, 40);
    });

    group('Edge Cases', () {
      test('Zero values should scale to zero', () {
        expect(0.w, 0);
        expect(0.h, 0);
        expect(0.r, 0);
        expect(0.sp, 0);
      });

      test('Negative values should scale correctly', () {
        expect((-10).w, -20);
        expect((-10).h, -20);
        expect((-10).r, -20);
      });

      test('Large values should scale correctly', () {
        expect(1000.w, 2000);
        expect(1000.h, 2000);
        expect(1000.sp, 2000);
      });

      test('Decimal values should scale correctly', () {
        expect(10.5.w, 21);
        expect(10.5.h, 21);
        expect(10.5.sp, 21);
      });

      test('Deprecated sm method should work like spMin', () {
        // ignore: deprecated_member_use_from_same_package
        expect(10.sm, 10.spMin);
        // ignore: deprecated_member_use_from_same_package
        expect(20.sm, 20.spMin);
      });

      test('Asymmetric EdgeInsets should scale correctly', () {
        const insets = EdgeInsets.only(
          left: 10,
          top: 20,
          right: 30,
          bottom: 40,
        );

        final EdgeInsets scaled = insets.r;
        expect(scaled.left, 20);
        expect(scaled.top, 40);
        expect(scaled.right, 60);
        expect(scaled.bottom, 80);
      });

      test('Asymmetric BorderRadius should scale correctly', () {
        const radius = BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(40),
        );

        final BorderRadius scaled = radius.r;
        expect(scaled.topLeft.x, 20);
        expect(scaled.topRight.x, 40);
        expect(scaled.bottomLeft.x, 60);
        expect(scaled.bottomRight.x, 80);
      });

      test('Elliptical Radius should scale both x and y', () {
        const radius = Radius.elliptical(10, 20);

        final Radius scaled = radius.r;
        expect(scaled.x, 20);
        expect(scaled.y, 40);
      });

      test('BoxConstraints with infinity should handle correctly', () {
        const constraints = BoxConstraints(minWidth: 10, minHeight: 10);

        final BoxConstraints scaled = constraints.r;
        expect(scaled.minWidth, 20);
        expect(scaled.maxWidth, double.infinity);
        expect(scaled.minHeight, 20);
        expect(scaled.maxHeight, double.infinity);
      });
    });
  });
}
