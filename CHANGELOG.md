# Changelog

All notable changes to this project will be documented in this file.

## [1.0.1] - 2025

### Added

- Comprehensive example app demonstrating all package features
- Library-level documentation with usage examples
- Documentation for `BorderRadiusExtension` and its methods (`.r`, `.w`, `.h`)
- Documentation for `BoxConstraintsExtension` and its methods (`.r`, `.hw`, `.w`, `.h`)
- Example directory with complete working demo

### Changed

- Reorganized package structure for better maintainability
- Improved folder organization with logical subdirectories (core, widgets, extensions, mixins, utils, internal)
- Improved pub.dev score with complete API documentation

## [1.0.0] - 2025

### Added

- Comprehensive unit test coverage (114+ tests)
- Fixed deprecation warning: replaced `textScaleFactor` with `textScaler.scale(1.0)`
- Improved error handling for defunct elements in `configure` method

### Fixed

- Fixed assertion error when trying to rebuild defunct elements
- Fixed `sp` extension test by properly handling fontSizeResolver
