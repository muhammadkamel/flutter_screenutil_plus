import 'dart:math' show max, min;
import 'dart:ui' as ui show FlutterView;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/widgets.dart';

import '../core/_constants.dart';
import '../utils/device_type.dart';
import '../utils/media_query_extension.dart';

/// A function type for resolving font sizes based on the original font size
/// and the [ScreenUtilPlus] instance.
///
/// This allows custom font scaling strategies beyond the default text scaling.
/// The function receives the original [fontSize] in dp and the [instance]
/// of [ScreenUtilPlus], and should return the scaled font size.
typedef FontSizeResolver =
    double Function(num fontSize, ScreenUtilPlus instance);

/// A utility class for responsive screen adaptation in Flutter applications.
///
/// This class provides methods to adapt UI elements (width, height, font size,
/// spacing) based on a design size, ensuring consistent appearance across
/// different screen sizes and orientations.
///
/// The class uses a singleton pattern - access the instance using the
/// factory constructor [ScreenUtilPlus()].
///
/// Example usage:
/// ```dart
/// ScreenUtilPlus.init(context, designSize: const Size(375, 812));
/// final width = ScreenUtilPlus().setWidth(100);
/// final height = ScreenUtilPlus().setHeight(50);
/// final fontSize = ScreenUtilPlus().setSp(16);
/// ```
class ScreenUtilPlus {
  /// Returns the singleton instance of [ScreenUtilPlus].
  factory ScreenUtilPlus() => _instance;

  ScreenUtilPlus._();

  static final ScreenUtilPlus _instance = ScreenUtilPlus._();

  static bool Function() _enableScaleWH = () => true;
  static bool Function() _enableScaleText = () => true;

  /// Size of the phone in UI Design, in dp
  Size _uiSize = defaultSize;

  /// Screen orientation
  Orientation _orientation = Orientation.portrait;

  bool _minTextAdapt = false;

  /// The [MediaQueryData] from the device.
  ///
  /// Initialize with default size to avoid null checks or 0 size issues
  /// before [configure] or [init] is called.
  MediaQueryData _data = const MediaQueryData(size: defaultSize);
  bool _splitScreenMode = false;

  /// Optional custom font size resolver function.
  ///
  /// When set, this function is used instead of the default text scaling
  /// strategy to determine font sizes. If `null`, the default scaling based
  /// on [scaleText] is used.
  FontSizeResolver? fontSizeResolver;

  /// Enable scale
  ///
  /// If [enableWH] returns false, the width and height scale ratio will be 1.
  /// If [enableText] returns false, the text scale ratio will be 1.
  ///
  static void enableScale({
    bool Function()? enableWH,
    bool Function()? enableText,
  }) {
    _enableScaleWH = enableWH ?? () => true;
    _enableScaleText = enableText ?? () => true;
  }

  /// Manually wait for window size to be initialized
  ///
  /// Recommended to use before you need access to window size
  /// or in custom splash/bootstrap screen [FutureBuilder].
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ScreenUtil.init(context, ...);
  /// ...
  ///   FutureBuilder(
  ///     future: Future.wait([..., ensureScreenSize(), ...]),
  ///     builder: (context, snapshot) {
  ///       if (snapshot.hasData) return const HomeScreen();
  ///       return Material(
  ///         child: LayoutBuilder(
  ///           ...
  ///         ),
  ///       );
  ///     },
  ///   )
  /// ```
  static Future<void> ensureScreenSize([
    ui.FlutterView? window,
    Duration duration = const Duration(milliseconds: 10),
  ]) async {
    final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
    binding.deferFirstFrame();

    await Future.doWhile(() async {
      window ??= binding.platformDispatcher.implicitView;

      if (window == null || window!.physicalSize.isEmpty) {
        await Future.delayed(duration);
        return true;
      }

      return false;
    });

    binding.allowFirstFrame();
  }

  Set<Element>? _elementsToRebuild;
  _ScreenMetrics? _metrics;

  /// ### Experimental
  /// Registers the current page and all its descendants to rebuild.
  /// Helpful when building for web and desktop.
  static void registerToBuild(
    BuildContext context, [
    bool withDescendants = false,
  ]) {
    (_instance._elementsToRebuild ??= {}).add(context as Element);

    if (withDescendants) {
      context.visitChildren((element) {
        registerToBuild(element, true);
      });
    }
  }

  /// Configures the [ScreenUtilPlus] instance with the provided parameters.
  ///
  /// This method updates the internal state of the singleton instance with
  /// new screen metrics, design size, and configuration options. It also
  /// triggers rebuilds of registered widgets when the configuration changes.
  ///
  /// Parameters:
  /// - [data]: The [MediaQueryData] containing screen information. If `null`,
  ///   uses the previously set data.
  /// - [designSize]: The design size in dp. If `null`, uses the previously
  ///   set design size.
  /// - [splitScreenMode]: Whether to enable split screen mode. If `null`,
  ///   keeps the current setting.
  /// - [minTextAdapt]: Whether to use minimum text adaptation. If `null`,
  ///   keeps the current setting.
  /// - [fontSizeResolver]: Custom font size resolver function. If `null`,
  ///   keeps the current resolver.
  static void configure({
    MediaQueryData? data,
    Size designSize = defaultSize,
    bool? splitScreenMode,
    bool? minTextAdapt,
    FontSizeResolver? fontSizeResolver,
  }) {
    // Get or set data
    if (data != null) {
      _instance._data = data;
    }

    _instance._uiSize = designSize;

    // Capture previous state for change detection
    final _ScreenMetrics? previousMetrics = _instance._metrics;
    final FontSizeResolver? previousResolver = _instance.fontSizeResolver;

    final MediaQueryData? deviceData = data.nonEmptySizeOrNull();
    final Size deviceSize = deviceData?.size ?? designSize;

    final Orientation orientation =
        deviceData?.orientation ??
        (deviceSize.width > deviceSize.height
            ? Orientation.landscape
            : Orientation.portrait);

    // Update instance properties
    _instance
      ..fontSizeResolver = fontSizeResolver ?? _instance.fontSizeResolver
      .._minTextAdapt = minTextAdapt ?? _instance._minTextAdapt
      .._splitScreenMode = splitScreenMode ?? _instance._splitScreenMode
      .._orientation = orientation;

    // Create new metrics snapshot for change detection
    final metrics = _ScreenMetrics(
      size: deviceSize,
      designSize: _instance._uiSize,
      orientation: _instance._orientation,
      splitScreenMode: _instance._splitScreenMode,
      minTextAdapt: _instance._minTextAdapt,
    );

    _instance._metrics = metrics;

    // Detect changes using Equatable's value equality
    // Note: fontSizeResolver uses reference equality - a new function instance
    // will trigger a rebuild even if functionally identical
    final metricsChanged = metrics != previousMetrics;
    final resolverChanged = _instance.fontSizeResolver != previousResolver;

    if (metricsChanged || resolverChanged) {
      // Rebuild registered elements only when underlying configuration changes.
      _instance._rebuildRegisteredElements();
    }
  }

  void _rebuildRegisteredElements() {
    _elementsToRebuild?.removeWhere((element) {
      try {
        element.markNeedsBuild();
        return false; // Element is valid, keep it
      } catch (_) {
        return true; // Element is defunct, remove it
      }
    });
  }

  /// Initializes the library.
  static void init(
    BuildContext context, {
    Size designSize = defaultSize,
    bool splitScreenMode = false,
    bool minTextAdapt = false,
    FontSizeResolver? fontSizeResolver,
  }) {
    final ui.FlutterView? view = View.maybeOf(context);
    return configure(
      data: view != null ? MediaQueryData.fromView(view) : null,
      designSize: designSize,
      splitScreenMode: splitScreenMode,
      minTextAdapt: minTextAdapt,
      fontSizeResolver: fontSizeResolver,
    );
  }

  /// Ensures the screen size is initialized and then initializes the library.
  ///
  /// This method first waits for the screen size to be available using
  /// [ensureScreenSize], then initializes [ScreenUtilPlus] with the provided
  /// parameters. This is useful when you need to ensure the window size is
  /// ready before initializing screen utilities.
  ///
  /// Parameters:
  /// - [context]: The [BuildContext] to get screen information from.
  /// - [designSize]: The design size in dp. Defaults to [defaultSize].
  /// - [splitScreenMode]: Whether to enable split screen mode.
  /// - [minTextAdapt]: Whether to use minimum text adaptation.
  /// - [fontSizeResolver]: Custom font size resolver function.
  static Future<void> ensureScreenSizeAndInit(
    BuildContext context, {
    Size designSize = defaultSize,
    bool splitScreenMode = false,
    bool minTextAdapt = false,
    FontSizeResolver? fontSizeResolver,
  }) {
    return ScreenUtilPlus.ensureScreenSize().then((_) {
      if (!context.mounted) {
        return;
      }
      return init(
        context,
        designSize: designSize,
        minTextAdapt: minTextAdapt,
        splitScreenMode: splitScreenMode,
        fontSizeResolver: fontSizeResolver,
      );
    });
  }

  /// Get screen orientation
  Orientation get orientation => _orientation;

  /// The number of font pixels for each logical pixel.
  double get textScaleFactor => _data.textScaler.scale(1.0);

  /// The size of the media in logical pixels (e.g., the size of the screen).
  double? get pixelRatio => _data.devicePixelRatio;

  /// The horizontal extent of this size.
  double get screenWidth => _data.size.width;

  /// The vertical extent of this size.
  double get screenHeight => _data.size.height;

  /// The offset from the top, in dp
  double get statusBarHeight => _data.padding.top;

  /// The offset from the bottom, in dp
  double get bottomBarHeight => _data.padding.bottom;

  /// The ratio of actual width to UI design.
  double get scaleWidth => !_enableScaleWH() ? 1 : screenWidth / _uiSize.width;

  /// The ratio of actual height to UI design.
  double get scaleHeight => !_enableScaleWH()
      ? 1
      : (_splitScreenMode ? max(screenHeight, 700) : screenHeight) /
            _uiSize.height;

  /// The ratio for text scaling.
  ///
  /// Returns 1 if text scaling is disabled, otherwise returns the appropriate
  /// scale factor based on [minTextAdapt] setting:
  /// - If [minTextAdapt] is `true`, uses the minimum of [scaleWidth] and
  ///   [scaleHeight] to prevent text from becoming too large.
  /// - If [minTextAdapt] is `false`, uses [scaleWidth].
  double get scaleText => !_enableScaleText()
      ? 1
      : (_minTextAdapt ? min(scaleWidth, scaleHeight) : scaleWidth);

  /// Adapted to the device width of the UI Design.
  /// Height can also be adapted according to this to ensure no deformation,
  /// if you want a square.
  double setWidth(num width) => width * scaleWidth;

  /// Highly adaptable to the device according to UI Design.
  /// It is recommended to use this method to achieve a high degree of adaptation
  /// when it is found that one screen in the UI design
  /// does not match the current style effect, or if there is a difference in shape.
  double setHeight(num height) => height * scaleHeight;

  /// Adapt according to the smaller of width or height.
  double radius(num r) => r * min(scaleWidth, scaleHeight);

  /// Adapt according to both width and height.
  double diagonal(num d) => d * scaleHeight * scaleWidth;

  /// Adapt according to the maximum value of scale width and scale height.
  double diameter(num d) => d * max(scaleWidth, scaleHeight);

  /// Font size adaptation method.
  /// - [fontSize] The size of the font on the UI design, in dp.
  double setSp(num fontSize) =>
      fontSizeResolver?.call(fontSize, _instance) ?? fontSize * scaleText;

  /// Determines the device type based on the platform and screen size.
  ///
  /// Returns [DeviceType.mobile], [DeviceType.tablet], [DeviceType.web],
  /// or a platform-specific desktop type (e.g., [DeviceType.mac],
  /// [DeviceType.windows], [DeviceType.linux]) based on the current
  /// platform and screen dimensions.
  ///
  /// For mobile platforms (iOS/Android), a device is considered a tablet
  /// if the screen width (portrait) or height (landscape) is at least 600 dp.
  DeviceType deviceType(BuildContext context) {
    if (kIsWeb) {
      return DeviceType.web;
    }

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final Orientation orientation = mediaQuery.orientation;

    final bool isMobilePlatform =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;

    if (isMobilePlatform) {
      final bool isTablet =
          (orientation == Orientation.portrait && screenWidth >= 600) ||
          (orientation == Orientation.landscape && screenHeight >= 600);
      return isTablet ? DeviceType.tablet : DeviceType.mobile;
    }

    return _getDesktopDeviceType();
  }

  DeviceType _getDesktopDeviceType() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.linux:
        return DeviceType.linux;
      case TargetPlatform.macOS:
        return DeviceType.mac;
      case TargetPlatform.windows:
        return DeviceType.windows;
      case TargetPlatform.fuchsia:
        return DeviceType.fuchsia;
      case TargetPlatform.iOS:
      case TargetPlatform.android:
        // These should not occur in this method, but handle for completeness
        return DeviceType.web;
    }
  }

  /// Creates a vertical [SizedBox] with height adapted using [setHeight].
  SizedBox setVerticalSpacing(num height) =>
      SizedBox(height: setHeight(height));

  /// Creates a vertical [SizedBox] with height adapted using [setWidth].
  SizedBox setVerticalSpacingFromWidth(num height) =>
      SizedBox(height: setWidth(height));

  /// Creates a horizontal [SizedBox] with width adapted using [setWidth].
  SizedBox setHorizontalSpacing(num width) => SizedBox(width: setWidth(width));

  /// Creates a horizontal [SizedBox] with width adapted using [radius].
  SizedBox setHorizontalSpacingRadius(num width) =>
      SizedBox(width: radius(width));

  /// Creates a vertical [SizedBox] with height adapted using [radius].
  SizedBox setVerticalSpacingRadius(num height) =>
      SizedBox(height: radius(height));

  /// Creates a horizontal [SizedBox] with width adapted using [diameter].
  SizedBox setHorizontalSpacingDiameter(num width) =>
      SizedBox(width: diameter(width));

  /// Creates a vertical [SizedBox] with height adapted using [diameter].
  SizedBox setVerticalSpacingDiameter(num height) =>
      SizedBox(height: diameter(height));

  /// Creates a horizontal [SizedBox] with width adapted using [diagonal].
  SizedBox setHorizontalSpacingDiagonal(num width) =>
      SizedBox(width: diagonal(width));

  /// Creates a vertical [SizedBox] with height adapted using [diagonal].
  SizedBox setVerticalSpacingDiagonal(num height) =>
      SizedBox(height: diagonal(height));
}

/// Internal class to track screen configuration state for change detection.
///
/// Uses [Equatable] to enable value-based equality comparison, allowing
/// efficient detection of configuration changes without unnecessary rebuilds.
/// All properties are compared using their value equality (Flutter's [Size]
/// and [Orientation] implement proper equality).
class _ScreenMetrics extends Equatable {
  const _ScreenMetrics({
    required this.size,
    required this.designSize,
    required this.orientation,
    required this.splitScreenMode,
    required this.minTextAdapt,
  });

  /// Current device screen size
  final Size size;

  /// Design size used for scaling calculations
  final Size designSize;

  /// Current screen orientation
  final Orientation orientation;

  /// Whether split screen mode is enabled
  final bool splitScreenMode;

  /// Whether minimum text adaptation is enabled
  final bool minTextAdapt;

  @override
  List<Object> get props => [
    size,
    designSize,
    orientation,
    splitScreenMode,
    minTextAdapt,
  ];
}
