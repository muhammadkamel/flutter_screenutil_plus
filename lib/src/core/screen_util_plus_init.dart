import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../flutter_screenutil_plus.dart';
import '_constants.dart';

/// A helper widget that initializes [ScreenUtilPlus] and provides responsive
/// screen utilities for Flutter applications.
///
/// This widget should be placed at the root of your widget tree to enable
/// screen size adaptation based on design specifications. It configures
/// [ScreenUtilPlus] with the provided design size and other settings, and
/// automatically handles screen size changes and responsive widget rebuilding.
///
/// Example usage:
/// ```dart
/// ScreenUtilPlusInit(
///   designSize: const Size(375, 812),
///   child: MyApp(),
/// )
/// ```
///
/// See also:
/// - [ScreenUtilPlus] for the underlying utility class
/// - [RebuildFactor] for controlling when widgets rebuild
/// - [FontSizeResolver] for font size scaling strategies
class ScreenUtilPlusInit extends StatefulWidget {
  /// Creates a [ScreenUtilPlusInit] widget.
  ///
  /// The [designSize] parameter specifies the design draft size in dp.
  /// The [child] or [builder] parameter must be provided to build the widget tree.
  const ScreenUtilPlusInit({
    super.key,
    this.builder,
    this.child,
    this.rebuildFactor = RebuildFactors.size,
    this.designSize = defaultSize,
    this.splitScreenMode = false,
    this.minTextAdapt = false,
    this.ensureScreenSize = false,
    this.enableScaleWH,
    this.enableScaleText,
    this.fontSizeResolver = FontSizeResolvers.width,
    this.autoRebuild = true,
  });

  /// Optional builder function that receives the [BuildContext] and [child]
  /// widget, allowing custom widget tree construction.
  final ScreenUtilInitBuilder? builder;

  /// The child widget to be displayed. Either [child] or [builder] must be
  /// provided.
  final Widget? child;

  /// Whether to enable split screen mode, which adjusts scaling behavior
  /// for devices in split-screen or multi-window mode.
  final bool splitScreenMode;

  /// Whether to use minimum text adaptation, which ensures text scales
  /// based on the smaller dimension to prevent text from becoming too large.
  final bool minTextAdapt;

  /// Whether to ensure the screen size is initialized before building.
  /// When `true`, the widget will wait for the screen size to be available
  /// before rendering its child.
  final bool ensureScreenSize;

  /// Optional function that determines whether width and height scaling
  /// should be enabled. When `null` or returns `true`, scaling is enabled.
  final bool Function()? enableScaleWH;

  /// Optional function that determines whether text scaling should be enabled.
  /// When `null` or returns `true`, text scaling is enabled.
  final bool Function()? enableScaleText;

  /// A function that determines when widgets should rebuild based on changes
  /// in [MediaQueryData]. Defaults to [RebuildFactors.size].
  final RebuildFactor rebuildFactor;

  /// The strategy for resolving font sizes. Defaults to [FontSizeResolvers.width].
  final FontSizeResolver fontSizeResolver;

  /// The [Size] of the device in the design draft, in dp.
  final Size designSize;

  /// Whether to automatically rebuild the widget tree when screen metrics change.
  ///
  /// Defaults to `true` for backward compatibility. Note that this rebuilds
  /// widgets that depend on [ScreenUtilPlusScope].
  final bool autoRebuild;

  @override
  State<ScreenUtilPlusInit> createState() => _ScreenUtilPlusInitState();
}

class _ScreenUtilPlusInitState extends State<ScreenUtilPlusInit>
    with WidgetsBindingObserver {
  MediaQueryData? _mediaQueryData;
  final WidgetsBinding _binding = WidgetsBinding.instance;
  final _screenSizeCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();

    ScreenUtilPlus.enableScale(
      enableWH: widget.enableScaleWH,
      enableText: widget.enableScaleText,
    );

    if (widget.ensureScreenSize) {
      ScreenUtilPlus.ensureScreenSize().then(_screenSizeCompleter.complete);
    } else {
      _screenSizeCompleter.complete();
    }

    _binding.addObserver(this);

    // Ensure _revalidate() is called as soon as context is available
    // Use scheduleMicrotask to call it after initState completes but before widget tree construction
    scheduleMicrotask(() {
      if (mounted) {
        _revalidate();
      }
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _revalidate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _revalidate();
  }

  MediaQueryData? _getMediaQueryData() {
    return context.mediaQueryData;
  }

  void _revalidate([void Function()? callback]) {
    final MediaQueryData? newData = _getMediaQueryData();
    if (newData == null) {
      return;
    }

    final MediaQueryData? oldData = _mediaQueryData;
    final bool shouldUpdate =
        oldData == null || widget.rebuildFactor(oldData, newData);

    if (shouldUpdate) {
      setState(() {
        _mediaQueryData = newData;
        callback?.call();
      });
    }
  }

  void _configureScreenUtil(MediaQueryData mediaQueryData) {
    ScreenUtilPlus.configure(
      data: mediaQueryData,
      designSize: widget.designSize,
      splitScreenMode: widget.splitScreenMode,
      minTextAdapt: widget.minTextAdapt,
      fontSizeResolver: widget.fontSizeResolver,
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData? mediaQueryData = _mediaQueryData;
    if (mediaQueryData == null) {
      return const SizedBox.shrink();
    }

    _configureScreenUtil(mediaQueryData);

    final Widget result =
        widget.builder?.call(context, widget.child) ?? widget.child!;

    if (!widget.ensureScreenSize) {
      return ScreenUtilPlusScope(
        metrics: ScreenUtilPlus().metrics,
        child: result,
      );
    }

    return FutureBuilder<void>(
      future: _screenSizeCompleter.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ScreenUtilPlusScope(
            metrics: ScreenUtilPlus().metrics,
            child: result,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    _binding.removeObserver(this);
    super.dispose();
  }
}
