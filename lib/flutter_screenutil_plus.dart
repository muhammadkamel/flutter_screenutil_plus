/// A Flutter plugin for adapting screen and font size.
///
/// This library provides utilities to make your Flutter app responsive across
/// different screen sizes. It allows you to define a design size and automatically
/// scales your UI elements (width, height, font size, etc.) to match different
/// device screens.
///
/// ## Getting Started
///
/// Wrap your app with [ScreenUtilPlusInit] to initialize the library:
///
/// ```dart
/// ScreenUtilPlusInit(
///   designSize: defaultSize,
///   builder: (context, child) {
///     return MaterialApp(home: child);
///   },
///   child: HomePage(),
/// )
/// ```
///
/// Then use the extension methods throughout your app:
///
/// ```dart
/// Container(
///   width: 50.w,   // Responsive width
///   height: 100.h, // Responsive height
///   child: Text('Hello', style: TextStyle(fontSize: 16.sp)),
/// )
/// ```
///
/// ## Features
///
/// - Responsive width, height, and radius using `.w`, `.h`, `.r` extensions
/// - Responsive font sizes using `.sp` extension
/// - Responsive widgets: [RPadding], [RSizedBox], [RContainer], [RText]
/// - Responsive theme generation with [ResponsiveTheme]
/// - Screen metrics and information
/// - Support for different screen orientations
/// - **CSS-like breakpoints**: Media query-style breakpoints for responsive design
/// - **SwiftUI-like size classes**: Compact/Regular size classes for adaptive layouts
/// - **Breakpoint-aware widgets**: [ResponsiveBuilder], [SizeClassBuilder], [AdaptiveContainer]
/// - **Responsive queries**: Easy breakpoint checking and conditional rendering
library;

// Core classes
export 'src/core/screen_util_plus.dart';
export 'src/core/screen_util_plus_init.dart';
export 'src/core/screen_util_plus_scope.dart';
export 'src/extensions/adaptive_text_style.dart';
export 'src/extensions/context_extension.dart';
export 'src/extensions/responsive_size_context.dart';
// Extensions
export 'src/extensions/size_extension.dart';
export 'src/extensions/text_style_extension.dart';
// Mixins
export 'src/mixins/screenutil_mixin.dart';
// Theme
export 'src/theme/responsive_theme.dart';
export 'src/utils/adaptive_values.dart';
// Breakpoints and responsive utilities (CSS & SwiftUI-like)
export 'src/utils/breakpoints.dart';
// Utilities and types
export 'src/utils/device_type.dart';
export 'src/utils/font_size_resolvers.dart';
export 'src/utils/media_query_extension.dart';
export 'src/utils/rebuild_factor.dart';
export 'src/utils/rebuild_factors.dart';
export 'src/utils/responsive_query.dart';
export 'src/utils/screen_util_init_builder.dart';
export 'src/utils/size_class.dart';
export 'src/widgets/adaptive_container.dart';
export 'src/widgets/adaptive_text.dart';
// Widgets
export 'src/widgets/r_container.dart';
export 'src/widgets/r_padding.dart';
export 'src/widgets/r_sizedbox.dart';
export 'src/widgets/r_text.dart';
export 'src/widgets/responsive_builder.dart';
