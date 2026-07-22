import 'dart:io';

import 'package:flutter/foundation.dart';

Future<void> main() async {
  debugPrint('=======================================');
  debugPrint('Starting ScreenUtilPlus Benchmark Suite');
  debugPrint('=======================================');

  // 1. Run Microbenchmarks
  debugPrint(r'\n--- Running Microbenchmarks ---');
  final ProcessResult microScaling = await Process.run('flutter', [
    'test',
    'benchmark/micro/scaling_computation_benchmark.dart',
  ]);
  final ProcessResult microBreakpoint = await Process.run('flutter', [
    'test',
    'benchmark/micro/breakpoint_resolution_benchmark.dart',
  ]);

  debugPrint(
    '| Microbenchmark | Iterations | ScreenUtil Standard | ScreenUtilPlus | Improvement |',
  );
  debugPrint('|---|---|---|---|---|');

  final String scalingOutput =
      microScaling.stdout.toString() + microScaling.stderr.toString();
  final RegExpMatch? suMatch = RegExp(
    r'ScreenUtil Standard Scaling \(RunTime[^:]*:\s+(\d+)',
  ).firstMatch(scalingOutput);
  final RegExpMatch? supMatch = RegExp(
    r'ScreenUtilPlus Scaling \(RunTime[^:]*:\s+(\d+)',
  ).firstMatch(scalingOutput);

  if (suMatch != null && supMatch != null) {
    final int suTime = int.parse(suMatch.group(1)!);
    final int supTime = int.parse(supMatch.group(1)!);
    final String improvement = ((suTime - supTime) / suTime * 100)
        .toStringAsFixed(1);
    debugPrint(
      '| Scaling Computation | 100K | $suTime us | $supTime us | $improvement% |',
    );
  } else {
    debugPrint('| Scaling Computation | 100K | N/A | N/A | N/A |');
  }

  final String breakpointOutput =
      microBreakpoint.stdout.toString() + microBreakpoint.stderr.toString();
  final RegExpMatch? bpMatch = RegExp(
    r'\(RunTime\):\s+([\d.]+)\s+us',
  ).firstMatch(breakpointOutput);
  if (bpMatch != null) {
    debugPrint(
      '| Breakpoint Resolution | 1K | N/A (Standard lacks API) | ${bpMatch.group(1)} us | N/A |',
    );
  } else {
    debugPrint('| Breakpoint Resolution | 1K | N/A | N/A | N/A |');
  }

  // 2. Run Integration Tests
  debugPrint(r'\n--- Running Integration Tests ---');
  final tests = [
    'deep_tree_test.dart',
    'scrolling_test.dart',
    'orientation_test.dart',
  ];

  final Map<String, String> finalResults = {};

  for (final test in tests) {
    debugPrint('Running $test...');
    final ProcessResult result = await Process.run('flutter', [
      'test',
      '-d',
      'chrome',
      '../integration_test/benchmarks/$test',
    ], workingDirectory: 'example');

    final output = result.stdout.toString();
    final regex = RegExp(r'([a-z_]+):\s+(\d+)\s+ms');
    for (final RegExpMatch match in regex.allMatches(output)) {
      finalResults[match.group(1)!] = match.group(2)!;
    }
  }

  // 3. Print the Markdown Output
  debugPrint(r'\n## Setup Overhead & Rebuild Performance');
  debugPrint(
    '| Framework | Deep Tree Build (ms) | Scrolling Build (ms) | Orientation Rebuild (ms) |',
  );
  debugPrint('|---|---|---|---|');

  void printTableRow(String framework, String keyPrefix) {
    final String deepTree = finalResults['${keyPrefix}_deep_tree'] ?? 'N/A';
    final String scrolling = finalResults['${keyPrefix}_scrolling'] ?? 'N/A';
    final String orientation =
        finalResults['${keyPrefix}_orientation'] ?? 'N/A';

    debugPrint('| $framework | $deepTree | $scrolling | $orientation |');
  }

  printTableRow('Standard Flutter', 'standard');
  printTableRow('flutter_screenutil', 'su');
  printTableRow('flutter_screenutil_plus', 'su_plus');

  debugPrint(r'\nBenchmarks Completed!');
}
