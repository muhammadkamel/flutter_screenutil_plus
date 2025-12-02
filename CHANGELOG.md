<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

## [1.2.0] - 2025

### Added

- **CSS-like Breakpoints System**: Added comprehensive breakpoint system with predefined sets (Bootstrap, Tailwind, Material Design, Mobile-first)
  - `Breakpoints` class with configurable breakpoint values
  - `Breakpoint` enum (xs, sm, md, lg, xl, xxl)
  - Context extensions for easy breakpoint checking (`context.breakpoint`, `context.isAtLeast()`, etc.)
  
- **SwiftUI-like Size Classes**: Added size class system for adaptive layouts
  - `SizeClass` enum (compact, regular) for horizontal and vertical dimensions
  - `SizeClasses` class with helper methods
  - Context extensions (`context.sizeClasses`, `context.horizontalSizeClass`, etc.)

- **Responsive Query Utilities**: Added utilities for responsive design queries
  - `ResponsiveQuery` class for breakpoint-based value selection
  - `AdaptiveValues` class for responsive sizing with breakpoints
  - Context extensions for convenient access

- **Adaptive Text Styles**: Added extensions for creating adaptive text styles
  - `AdaptiveTextStyleExtension` on `BuildContext` for breakpoint-based text styles
  - `TextStyleExtension` on `TextStyle` with responsive methods (`.r`, `withLineHeight()`, `withAutoLineHeight()`, `withLineHeightFromFigma()`)

- **Adaptive Widgets**: Added new responsive widgets
  - `AdaptiveContainer` and `SimpleAdaptiveContainer` - Containers that adapt properties based on breakpoints
  - `AdaptiveText` - Text widget that adapts style properties based on breakpoints
  - `ResponsiveBuilder` - Builder widget for different breakpoints
  - `SizeClassBuilder` - Builder widget for size classes
  - `ConditionalBuilder` - Conditional rendering based on breakpoint conditions

- **Integration Tests**: Added comprehensive integration tests
  - `adaptive_widgets_integration_test.dart` - Tests for adaptive widgets
  - `breakpoints_integration_test.dart` - Tests for breakpoint system
  - `extensions_integration_test.dart` - Tests for extensions
  - `responsive_widgets_integration_test.dart` - Tests for responsive widgets
  - `theme_integration_test.dart` - Tests for responsive theme

- **Unit Tests**: Added unit tests for new features
  - `adaptive_text_test.dart` - Tests for AdaptiveText widget
  - `text_style_extension_test.dart` - Tests for TextStyle extensions

### Changed

- Updated `ResponsiveTheme` to use new `TextStyleExtension.r` for responsive text styles
- Enhanced `RText` widget with improved responsive text handling

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
