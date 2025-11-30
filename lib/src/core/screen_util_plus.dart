import 'dart:math' show min, max;
import 'dart:ui' as ui show FlutterView;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/widgets.dart';

import '../utils/device_type.dart';
import '../utils/media_query_extension.dart';

typedef FontSizeResolver =
    double Function(num fontSize, ScreenUtilPlus instance);

class ScreenUtilPlus {
  static const Size defaultSize = Size(360, 690);
  static final ScreenUtilPlus _instance = ScreenUtilPlus._();

  static bool Function() _enableScaleWH = () => true;
  static bool Function() _enableScaleText = () => true;

  /// Size of the phone in UI Design, in dp
  late Size _uiSize;

  /// Screen orientation
  late Orientation _orientation;

  late bool _minTextAdapt;
  late MediaQueryData _data;
  late bool _splitScreenMode;
  FontSizeResolver? fontSizeResolver;

  ScreenUtilPlus._();

  factory ScreenUtilPlus() => _instance;

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
    final binding = WidgetsFlutterBinding.ensureInitialized();
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

  static void configure({
    MediaQueryData? data,
    Size? designSize,
    bool? splitScreenMode,
    bool? minTextAdapt,
    FontSizeResolver? fontSizeResolver,
  }) {
    // Get or set data
    try {
      if (data != null) {
        _instance._data = data;
      } else {
        data = _instance._data;
      }

      if (designSize != null) {
        _instance._uiSize = designSize;
      } else {
        designSize = _instance._uiSize;
      }
    } catch (_) {
      throw StateError(
        'ScreenUtilPlus must be initialized with data and designSize. '
        'Use ScreenUtilPlus.init() or ScreenUtilPlusInit widget first.',
      );
    }

    // Capture previous state for change detection
    final previousMetrics = _instance._metrics;
    final previousResolver = _instance.fontSizeResolver;

    final deviceData = data.nonEmptySizeOrNull();
    final deviceSize = deviceData?.size ?? designSize;

    final orientation =
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
    final view = View.maybeOf(context);
    return configure(
      data: view != null ? MediaQueryData.fromView(view) : null,
      designSize: designSize,
      splitScreenMode: splitScreenMode,
      minTextAdapt: minTextAdapt,
      fontSizeResolver: fontSizeResolver,
    );
  }

  static Future<void> ensureScreenSizeAndInit(
    BuildContext context, {
    Size designSize = defaultSize,
    bool splitScreenMode = false,
    bool minTextAdapt = false,
    FontSizeResolver? fontSizeResolver,
  }) {
    return ScreenUtilPlus.ensureScreenSize().then((_) {
      if (!context.mounted) return;
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

  DeviceType deviceType(BuildContext context) {
    if (kIsWeb) {
      return DeviceType.web;
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final orientation = mediaQuery.orientation;

    final isMobilePlatform =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;

    if (isMobilePlatform) {
      final isTablet =
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
      default:
        return DeviceType.web;
    }
  }

  SizedBox setVerticalSpacing(num height) =>
      SizedBox(height: setHeight(height));

  SizedBox setVerticalSpacingFromWidth(num height) =>
      SizedBox(height: setWidth(height));

  SizedBox setHorizontalSpacing(num width) => SizedBox(width: setWidth(width));

  SizedBox setHorizontalSpacingRadius(num width) =>
      SizedBox(width: radius(width));

  SizedBox setVerticalSpacingRadius(num height) =>
      SizedBox(height: radius(height));

  SizedBox setHorizontalSpacingDiameter(num width) =>
      SizedBox(width: diameter(width));

  SizedBox setVerticalSpacingDiameter(num height) =>
      SizedBox(height: diameter(height));

  SizedBox setHorizontalSpacingDiagonal(num width) =>
      SizedBox(width: diagonal(width));

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
