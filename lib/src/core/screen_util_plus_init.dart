import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';

import '../extensions/context_extension.dart';
import '../internal/_flutter_widgets.dart';
import '../mixins/screenutil_mixin.dart';
import '../utils/font_size_resolvers.dart';
import '../utils/rebuild_factor.dart';
import '../utils/rebuild_factors.dart';
import '../utils/screen_util_init_builder.dart';
import '_constants.dart';
import 'screen_util_plus.dart';

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
    this.responsiveWidgets,
    this.fontSizeResolver = FontSizeResolvers.width,
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

  /// Optional list of widget type names that should be marked for rebuilding
  /// when screen metrics change. If `null`, all widgets (except Flutter
  /// framework widgets and private widgets) will be rebuilt.
  final Iterable<String>? responsiveWidgets;

  @override
  State<ScreenUtilPlusInit> createState() => _ScreenUtilPlusInitState();
}

class _ScreenUtilPlusInitState extends State<ScreenUtilPlusInit>
    with WidgetsBindingObserver {
  final _canMarkedToBuild = HashSet<String>();
  MediaQueryData? _mediaQueryData;
  final WidgetsBinding _binding = WidgetsBinding.instance;
  final _screenSizeCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();

    if (widget.responsiveWidgets != null) {
      _canMarkedToBuild.addAll(widget.responsiveWidgets!);
    }

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

  bool _shouldMarkForBuild(Element element) {
    final widgetName = element.widget.runtimeType.toString();

    // Always rebuild if widget uses SU mixin
    if (element.widget is SU) {
      return true;
    }

    // Rebuild if explicitly in responsive widgets list
    if (_canMarkedToBuild.contains(widgetName)) {
      return true;
    }

    // Don't rebuild Flutter widgets or private widgets
    if (widgetName.startsWith('_') || flutterWidgets.contains(widgetName)) {
      return false;
    }

    return true;
  }

  void _markNeedsBuildIfAllowed(Element element) {
    if (_shouldMarkForBuild(element)) {
      element.markNeedsBuild();
    }
  }

  void _updateTree(Element el) {
    _markNeedsBuildIfAllowed(el);
    el.visitChildren(_updateTree);
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
        _updateTree(context as Element);
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

    if (!widget.ensureScreenSize) {
      return widget.builder?.call(context, widget.child) ?? widget.child!;
    }

    return FutureBuilder<void>(
      future: _screenSizeCompleter.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.builder?.call(context, widget.child) ?? widget.child!;
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
