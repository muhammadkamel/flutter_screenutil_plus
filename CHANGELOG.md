<!-- markdownlint-disable MD024 -->

# Changelog

All notable changes to this project will be documented in this file.

## [1.4.0] - 2025-12-23

### Added

- **InheritedWidget-Based Scope**: Introduced `ScreenUtilPlusScope` for efficient, targeted rebuilds

  - New `autoRebuild` parameter in `ScreenUtilPlusInit` (defaults to `true` for backward compatibility)
  - When `autoRebuild: false`, only widgets that explicitly depend on `ScreenUtilPlusScope` rebuild
  - Significantly improves performance by avoiding unnecessary tree-wide rebuilds
  - Accessible via `ScreenUtilPlus.of(context)` or `context.su`

- **Context-Aware Extensions**: New `ResponsiveSizeContext` extension on `BuildContext`

  - `context.w(value)` - Scale width
  - `context.h(value)` - Scale height
  - `context.r(value)` - Scale radius
  - `context.sp(value)` - Scale font size
  - `context.spMin(value)` - Scale font size with minimum
  - `context.dg(value)` - Scale diagonal
  - `context.dm(value)` - Scale diameter
  - `context.verticalSpace(value)` - Create vertical spacing
  - `context.horizontalSpace(value)` - Create horizontal spacing
  - `context.edgeInsets(...)` - Create scaled EdgeInsets
  - `context.borderRadius(...)` - Create scaled BorderRadius
  - These extensions work efficiently with `autoRebuild: false` by registering InheritedWidget dependencies

- **Example App Enhancements**:

  - New `ScopeDemoPage` showcasing `ScreenUtilPlusScope` features and performance benefits
  - Interactive demo comparing rebuild behavior with `autoRebuild` on/off
  - Visual demonstrations of context-aware extensions

- **Comprehensive Test Coverage**:
  - Added 25+ new tests across 6 new test files
  - Achieved **99.2% code coverage** (1574/1586 lines) with **619 total tests**
  - New test files:
    - `screen_util_plus_scope_test.dart` - InheritedWidget functionality
    - `responsive_size_context_test.dart` - Context-aware extensions
    - `context_extension_test.dart` - Context extension methods
    - `adaptive_text_style_test.dart` - Adaptive text styles including xxl breakpoint
    - `screen_util_plus_desktop_test.dart` - Desktop platform support
    - `screen_util_plus_edge_cases_test.dart` - Edge case scenarios

### Changed

- **Simplified Context Extension**: Refactored `mediaQueryData` getter in `ScreenUtilContextExtension`

  - Removed unreachable `View.maybeOf` fallback for cleaner code
  - Now simply returns `MediaQuery.maybeOf(this)`
  - Achieved 100% test coverage for this file

- **R-Widgets Enhancement**: Updated `RContainer` and `RText` to be context-aware

  - Now use `context.su` to register InheritedWidget dependencies
  - Benefit from efficient rebuilds when `autoRebuild: false`

- **Code Quality Improvements**:
  - Removed unused imports across multiple files
  - Added explicit braces to single-line if statements for better readability
  - Improved code formatting and consistency

### Performance

- **Rebuild Optimization**: With `autoRebuild: false`, only widgets that explicitly use:

  - `ScreenUtilPlus.of(context)` or `context.su`
  - Context-aware extensions (`context.w()`, `context.h()`, etc.)
  - R-widgets (`RContainer`, `RText`, etc.)

  will rebuild when screen metrics change, significantly reducing unnecessary rebuilds

### Migration Guide

For existing users, no changes are required. The default behavior (`autoRebuild: true`) maintains backward compatibility.

To opt into the new performance optimizations:

1. Set `autoRebuild: false` in `ScreenUtilPlusInit`
2. Use context-aware extensions (`context.w()`) instead of num extensions (`100.w`)
3. Or use R-widgets (`RContainer`, `RText`) which are already context-aware

See the new `ScopeDemoPage` in the example app for a complete demonstration.

## [1.3.1] - 2025-12-10

### Changed

- **Refactoring**: Core logic improvements for better maintainability and performance.
  - Simplified `ScreenUtilPlus` singleton and initialization logic.
  - Optimized `AdaptiveContainer` property handling.
- **Robustness**: Improved `ScreenUtilPlusInit` to robustly handle nested `MediaQuery` data, falling back to `View.maybeOf` only when necessary.

### Added

- **Tests**: Added dedicated tests for initialization fallback logic to ensure correct behavior in various widget tree configurations.

## [1.3.0] - 2025-12-07

### Added

- **Default Initialization**: `ScreenUtilPlus` fields now initialize with default values (`defaultSize` of 360x690) instead of empty/zero values, preventing issues when accessed before explicit configuration.
- **Optional Configuration**: `designSize` parameter in `init`, `configure`, and `ScreenUtilPlusInit` is now optional, defaulting to 360x690. This allows for simpler setup when using standard defaults.

## [1.2.2] - 2025-12-07

### Changed

- **Revert**: `designSize` parameter in `ScreenUtilPlus.init` and `ScreenUtilPlusInit` is now **required** again. The previous change to make it optional was reverted to ensure explicit configuration.

### Fixed

- **Crash Fix**: Fixed `LateInitializationError` in `ScreenUtilPlus.configure` when called with null parameters before initialization. Added default values for internal flags to prevent this crash.

## [1.2.1] - 2025-12-03

### Added

- **Comprehensive Test Suite**: Added extensive test coverage for all new features
  - Unit tests for `AdaptiveValues` class (100% coverage)
  - Unit tests for `AdaptiveContainer` and `SimpleAdaptiveContainer` widgets (94.7% coverage)
  - Unit tests for `Breakpoints` class (95% coverage)
  - Unit tests for `ResponsiveQuery` class (100% coverage)
  - Additional tests for `SizeClassBuilder` and `ConditionalBuilder` widgets
  - **Achieved 98.3% overall code coverage** with 500+ tests

### Changed

- **Documentation**: Comprehensive pub.dev documentation update
  - Complete README.md rewrite with all features documented
  - Added CSS-like breakpoints documentation section
  - Added SwiftUI-like size classes documentation section
  - Added adaptive widgets documentation with examples
  - Added API reference tables
  - Added best practices guide
  - Enhanced package description in `pubspec.yaml`

### Fixed

- Fixed test failures in `AdaptiveContainer` tests by properly handling `.w` and `.h` scaling
- Fixed `SizeClassBuilder` test to use appropriate screen sizes for compact/regular detection
- Fixed padding fallback behavior in `AdaptiveValues` tests to match actual implementation

## [1.2.0] - 2025-12-02

### Added

- **CSS-like Breakpoints System**: Added comprehensive breakpoint system with predefined sets (Bootstrap, Tailwind, Material Design, Mobile-first)
  - `Breakpoints` class with configurable breakpoint values
  - `Breakpoint` enum (xs, sm, md, lg, xl, xxl)
  - Context extensions for easy breakpoint checking (`context.breakpoint`, `context.isAtLeast()`, etc.)
  - Breakpoint comparison methods (`isAtLeast()`, `isLessThan()`, `isBetween()`, `isExactly()`)
- **SwiftUI-like Size Classes**: Added size class system for adaptive layouts

  - `SizeClass` enum (compact, regular) for horizontal and vertical dimensions
  - `SizeClasses` class with helper methods
  - Context extensions (`context.sizeClasses`, `context.horizontalSizeClass`, etc.)
  - Customizable threshold for size class determination

- **Responsive Query Utilities**: Added utilities for responsive design queries

  - `ResponsiveQuery` class for breakpoint-based value selection
  - `AdaptiveValues` class for responsive sizing with breakpoints (width, height, fontSize, radius, padding, margin)
  - Context extensions for convenient access
  - Value selection with automatic fallback to larger/smaller breakpoints

- **Adaptive Text Styles**: Added extensions for creating adaptive text styles

  - `AdaptiveTextStyleExtension` on `BuildContext` for breakpoint-based text styles
  - `TextStyleExtension` on `TextStyle` with responsive methods (`.r`, `withLineHeight()`, `withAutoLineHeight()`, `withLineHeightFromFigma()`)

- **Adaptive Widgets**: Added new responsive widgets

  - `AdaptiveContainer` and `SimpleAdaptiveContainer` - Containers that adapt properties based on breakpoints
  - `AdaptiveText` - Text widget that adapts style properties based on breakpoints
  - `ResponsiveBuilder` - Builder widget for different breakpoints with fallback chain
  - `SizeClassBuilder` - Builder widget for size classes (compact/regular, horizontal/vertical)
  - `ConditionalBuilder` - Conditional rendering based on breakpoint conditions

- **Comprehensive Test Coverage**: Added extensive test suite

  - Integration tests for all adaptive features
  - Unit tests for breakpoints, size classes, responsive queries, and adaptive values
  - Widget tests for all adaptive widgets
  - **98.3% code coverage** with 500+ tests

- **Documentation**: Comprehensive pub.dev documentation
  - Complete README with all features documented
  - API reference tables
  - Usage examples for all features
  - Best practices guide

### Changed

- Updated `ResponsiveTheme` to use new `TextStyleExtension.r` for responsive text styles
- Enhanced `RText` widget with improved responsive text handling
- Improved package description in `pubspec.yaml` to highlight new features
- Enhanced library documentation comments for better API documentation on pub.dev

### Fixed

- Fixed test failures in adaptive container tests by properly handling scaling
- Fixed size class builder test to use appropriate screen sizes
- Fixed padding fallback behavior in adaptive values tests

## [1.1.2] - 2025

### Changed

- Updated README.md with comprehensive documentation improvements

## [1.1.1] - 2025

### Added

- Implemented change detection for screen metrics using Equatable to optimize rebuilds
- Added `_ScreenMetrics` class with value-based equality comparison for efficient configuration change detection

### Changed

- Optimized rebuild behavior: registered elements now only rebuild when screen metrics or fontSizeResolver actually change
- Improved performance by preventing unnecessary rebuilds when configuration remains functionally identical

## [1.1.0] - 2025

### Added

- New `ScreenUtilMode` behavior refactor with responsive rebuilding improvements
- Additional unit tests covering new utilities, rebuild flow, and registerToBuild edge cases

### Changed

- Refactored `ScreenUtilPlusInit` to reduce duplication and improve responsiveness
- Extracted `DeviceType` enum and `MediaQueryData` extension into dedicated utility files
- Improved `ScreenUtilPlus.configure` error handling and rebuilt element management

## [1.0.2] - 2025

### Added

- Comprehensive example app demonstrating all package features
- Library-level documentation with usage examples
- Documentation for `BorderRadiusExtension` and its methods (`.r`, `.w`, `.h`)
- Documentation for `BoxConstraintsExtension` and its methods (`.r`, `.hw`, `.w`, `.h`)
- Example directory with complete working demo

### Changed

- Improved pub.dev score with complete API documentation

## [1.0.1] - 2025

### Changed

- Reorganized package structure for better maintainability
- Improved folder organization with logical subdirectories (core, widgets, extensions, mixins, utils, internal)

## [1.0.0] - 2025

### Added

- Comprehensive unit test coverage (114+ tests)
- Fixed deprecation warning: replaced `textScaleFactor` with `textScaler.scale(1.0)`
- Improved error handling for defunct elements in `configure` method

### Fixed

- Fixed assertion error when trying to rebuild defunct elements
- Fixed `sp` extension test by properly handling fontSizeResolver
