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
///   designSize: const Size(360, 690),
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
/// - Responsive widgets: [RPadding], [RSizedBox]
/// - Screen metrics and information
/// - Support for different screen orientations
library;

// Core classes
export 'src/core/screen_util_plus.dart';
export 'src/core/screen_util_plus_init.dart';
// Extensions
export 'src/extensions/size_extension.dart';
// Mixins
export 'src/mixins/screenutil_mixin.dart';
// Utilities and types
export 'src/utils/font_size_resolvers.dart';
export 'src/utils/rebuild_factor.dart';
export 'src/utils/rebuild_factors.dart';
export 'src/utils/screen_util_init_builder.dart';
// Widgets
export 'src/widgets/r_padding.dart';
export 'src/widgets/r_sizedbox.dart';
