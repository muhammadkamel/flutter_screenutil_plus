import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as su;
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart' as sup;
import 'package:flutter_test/flutter_test.dart';

const Size designSize = Size(390, 844);
const Size physicalSize = Size(428, 926);

void main() {
  testWidgets('Run Scaling Benchmarks explicitly', (WidgetTester tester) async {
    // 1. Setup a real widget tree to get a valid BuildContext
    late BuildContext realContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            realContext = context;
            return const SizedBox();
          },
        ),
      ),
    );

    // 2. Initialize Standard ScreenUtil
    su.ScreenUtil.init(realContext, designSize: designSize, minTextAdapt: true);

    // 3. Initialize ScreenUtilPlus
    sup.ScreenUtilPlus.configure(
      data: MediaQuery.of(realContext),
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: false,
    );

    const iterations = 100000;

    // --- Benchmark Standard ScreenUtil ---
    final suStopwatch = Stopwatch()..start();
    double suTotal = 0;
    for (var i = 0; i < iterations; i++) {
      final double w = su.SizeExtension(i).w;
      final double h = su.SizeExtension(i).h;
      final double sp = su.SizeExtension(i).sp;
      final double r = su.SizeExtension(i).r;
      suTotal += w + h + sp + r;
    }
    suStopwatch.stop();

    // --- Benchmark ScreenUtilPlus ---
    final supStopwatch = Stopwatch()..start();
    double supTotal = 0;
    for (var i = 0; i < iterations; i++) {
      final double w = sup.SizeExtension(i).w;
      final double h = sup.SizeExtension(i).h;
      final double sp = sup.SizeExtension(i).sp;
      final double r = sup.SizeExtension(i).r;
      supTotal += w + h + sp + r;
    }
    supStopwatch.stop();

    // To prevent dead-code elimination
    expect(suTotal > 0, isTrue);
    expect(supTotal > 0, isTrue);

    print(
      'ScreenUtil Standard Scaling (RunTime for $iterations iterations): ${suStopwatch.elapsedMicroseconds} us',
    );
    print(
      'ScreenUtilPlus Scaling (RunTime for $iterations iterations): ${supStopwatch.elapsedMicroseconds} us',
    );
  });
}
