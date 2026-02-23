# ScreenUtil Plus Benchmark Suite Results - Web (Chrome)

## Overview

A comprehensive benchmark suite was executed on Google Chrome (Web platform) to measure the overhead and performance profile of `flutter_screenutil_plus`, standard `flutter_screenutil`, and pure Flutter native layout.

### Areas Profiled

1. **Microbenchmarks**: High frequency loops measuring the isolated Dart overhead of breakpoint resolution (`DeviceType`, constraints computation) and mathematical scaling extensions (`.w`, `.h`, `.sp`, etc.).
2. **Integration Benchmarks**: Driver-powered timeline tests measuring the widget-tree layout bounds and frame drop percentages of three identical applications driven by different scale providers (`flutter_screenutil`, `flutter_screenutil_plus`, and native `MediaQuery`).

## Results Summary

### Web (Chrome) Microbenchmark Report

This table demonstrates the raw CPU overhead in large layout cascades on the web platform:

| Microbenchmark | Iterations | ScreenUtil Standard | ScreenUtilPlus | Improvement |
|---|---|---|---|---|
| Scaling Computation | 100K | 6822 us | 6035 us | 11.5% |
| Breakpoint Resolution | 1K | N/A (Standard lacks API) | 46.70 us | N/A |

### Web (Chrome) Integration Driver Report

This table demonstrates the Flutter rendering engine's ability to rasterize deep trees, lists, and perform bulk layout rebuilds when orientation/size changes, executed on the Web (lower is better):

| Framework | Deep Tree Build (ms) | Scrolling Build (ms) | Orientation Rebuild (ms) |
|---|---|---|---|
| Standard Flutter | 1 | 233 | 190 |
| flutter_screenutil | 1 | 186 | 168 |
| flutter_screenutil_plus | 1 | 155 | 59 |

---

> **Note**: Both packages hold up very well on Web compared to native Flutter, with `flutter_screenutil_plus` dominating orientation/screen resizing logic heavily (a critical factor in responsive Web apps).
