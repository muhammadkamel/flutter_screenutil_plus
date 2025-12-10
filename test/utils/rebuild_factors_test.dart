import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil_plus/src/utils/rebuild_factors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RebuildFactors', () {
    const baseData = MediaQueryData(size: Size(360, 690));

    test('size returns true only when size changes', () {
      expect(
        RebuildFactors.size(
          baseData,
          baseData.copyWith(size: const Size(360, 700)),
        ),
        true,
      );
      expect(RebuildFactors.size(baseData, baseData), false);
    });

    test('orientation returns true only when orientation changes', () {
      // Portrait
      const p = MediaQueryData(size: Size(100, 200));
      // Landscape
      const l = MediaQueryData(size: Size(200, 100));

      expect(RebuildFactors.orientation(p, l), true);
      expect(RebuildFactors.orientation(p, p), false);
    });

    test('sizeAndViewInsets returns true only when viewInsets changes', () {
      // Logic only checks viewInsets
      expect(
        RebuildFactors.sizeAndViewInsets(
          baseData,
          baseData.copyWith(viewInsets: const EdgeInsets.only(bottom: 100)),
        ),
        true,
      );
      expect(RebuildFactors.sizeAndViewInsets(baseData, baseData), false);

      // Verify it does NOT return true for just size change (based on current implementation)
      expect(
        RebuildFactors.sizeAndViewInsets(
          baseData,
          baseData.copyWith(size: const Size(100, 100)),
        ),
        false,
      );
    });

    test('change returns true when any property changes', () {
      expect(
        RebuildFactors.change(
          baseData,
          baseData.copyWith(textScaler: const TextScaler.linear(1.5)),
        ),
        true,
      );
      expect(RebuildFactors.change(baseData, baseData), false);
    });

    test('always returns true', () {
      expect(RebuildFactors.always(baseData, baseData), true);
      expect(
        RebuildFactors.always(baseData, baseData.copyWith(size: Size.zero)),
        true,
      );
    });

    test('none returns false', () {
      expect(RebuildFactors.none(baseData, baseData), false);
      expect(
        RebuildFactors.none(baseData, baseData.copyWith(size: Size.zero)),
        false,
      );
    });
  });
}
