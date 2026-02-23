import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

class BreakpointResolutionBenchmark extends BenchmarkBase {
  BreakpointResolutionBenchmark()
    : super('ScreenUtilPlus Breakpoint Resolution');

  final List<Size> sizesToTest = const [
    Size(390, 844), // Phone
    Size(600, 900), // Small tablet
    Size(1024, 1366), // Large tablet
    Size(1920, 1080), // Desktop
  ];

  @override
  void setup() {
    // Setup environment if necessary
  }

  @override
  void run() {
    var count = 0;
    for (var i = 0; i < 1000; i++) {
      for (final Size size in sizesToTest) {
        // Resolve breakpoints based on constraints
        final sizeClasses = SizeClasses.fromSize(size);

        final bool isDesktop =
            sizeClasses.horizontal == SizeClass.regular &&
            sizeClasses.vertical == SizeClass.compact;
        final bool isTablet =
            sizeClasses.horizontal == SizeClass.regular &&
            sizeClasses.vertical == SizeClass.regular;
        final isMobile = sizeClasses.horizontal == SizeClass.compact;

        // Resolve generic breakpoints
        final Breakpoint bp = const Breakpoints().getBreakpoint(size.width);

        if (isDesktop || isTablet || isMobile || bp != null) {
          count++;
        }
      }
    }
    // Prevent dead-code elimination
    if (count == 0) throw Exception();
  }
}

void main() {
  test('Run Breakpoint Resolution Benchmark', () {
    BreakpointResolutionBenchmark().report();
  });
}
