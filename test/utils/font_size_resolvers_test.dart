import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FontSizeResolvers', () {
    const deviceSize = Size(720, 1380); // 2x scale

    setUp(() {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        minTextAdapt: true,
        splitScreenMode: false,
      );
    });

    test('width resolver should scale based on width', () {
      // Scale width = 2
      expect(FontSizeResolvers.width(10, ScreenUtilPlus()), 20);
    });

    test('height resolver should scale based on height', () {
      // Scale height = 2
      expect(FontSizeResolvers.height(10, ScreenUtilPlus()), 20);
    });

    test('radius resolver should scale based on min dimension', () {
      // min(scaleW, scaleH) = 2
      expect(FontSizeResolvers.radius(10, ScreenUtilPlus()), 20);
    });

    test('diameter resolver should scale based on max dimension', () {
      // max(scaleW, scaleH) = 2
      expect(FontSizeResolvers.diameter(10, ScreenUtilPlus()), 20);
    });

    test('diagonal resolver should scale based on diagonal', () {
      // scaleW * scaleH = 4
      expect(FontSizeResolvers.diagonal(10, ScreenUtilPlus()), 40);
    });
  });

  group('FontSizeResolvers Asymmetric', () {
    // Width: 720 / 360 = 2.0
    // Height: 690 / 690 = 1.0
    const deviceSize = Size(720, 690);

    setUp(() {
      ScreenUtilPlus.configure(
        data: const MediaQueryData(size: deviceSize),
        minTextAdapt: true,
        splitScreenMode: false,
      );
    });

    test('width resolver should follow width scale (2.0)', () {
      expect(FontSizeResolvers.width(10, ScreenUtilPlus()), 20);
    });

    test('height resolver should follow height scale (1.0)', () {
      expect(FontSizeResolvers.height(10, ScreenUtilPlus()), 10);
    });

    test('radius resolver should follow min scale (1.0)', () {
      expect(FontSizeResolvers.radius(10, ScreenUtilPlus()), 10);
    });

    test('diameter resolver should follow max scale (2.0)', () {
      expect(FontSizeResolvers.diameter(10, ScreenUtilPlus()), 20);
    });

    test('diagonal resolver should combine scales (2.0 * 1.0)', () {
      expect(FontSizeResolvers.diagonal(10, ScreenUtilPlus()), 20);
    });
  });
}
