# Adaptive UI Features (CSS & SwiftUI-like)

This package now includes adaptive UI features inspired by CSS media queries and SwiftUI's size classes.

## Breakpoints (CSS-like)

Breakpoints allow you to create responsive designs similar to CSS media queries.

### Using Breakpoints

```dart
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// Get current breakpoint
final breakpoint = context.breakpoint;

// Check breakpoints
if (context.isAtLeast(Breakpoint.md)) {
  // Tablet and larger
}

if (context.isLessThan(Breakpoint.lg)) {
  // Smaller than desktop
}

// Use ResponsiveBuilder for different layouts
ResponsiveBuilder(
  xs: (context) => MobileLayout(),
  md: (context) => TabletLayout(),
  lg: (context) => DesktopLayout(),
)
```

### Predefined Breakpoint Sets

```dart
// Bootstrap 5 breakpoints (default)
Breakpoints.bootstrap

// Tailwind CSS breakpoints
Breakpoints.tailwind

// Material Design breakpoints
Breakpoints.material

// Mobile-first breakpoints
Breakpoints.mobileFirst

// Custom breakpoints
const customBreakpoints = Breakpoints(
  xs: 0,
  sm: 480,
  md: 768,
  lg: 1024,
  xl: 1440,
);
```

## Size Classes (SwiftUI-like)

Size classes provide a way to describe view sizes independent of specific devices.

### Using Size Classes

```dart
// Get size classes
final sizeClasses = context.sizeClasses;

// Check size classes
if (sizeClasses.isRegular) {
  // Regular size (e.g., iPad)
}

if (sizeClasses.isCompact) {
  // Compact size (e.g., iPhone in portrait)
}

// Use SizeClassBuilder
SizeClassBuilder(
  compact: (context) => CompactLayout(),
  regular: (context) => RegularLayout(),
)

// Or with horizontal/vertical size classes
SizeClassBuilder(
  horizontal: (context, horizontal) {
    return horizontal == SizeClass.regular
        ? WideLayout()
        : NarrowLayout();
  },
)
```

## Responsive Queries

Responsive queries provide a convenient way to get values based on breakpoints.

### Getting Values by Breakpoint

```dart
final query = ResponsiveQuery.of(context);

// Get value based on breakpoint
final padding = query.value(
  xs: 8.0,
  sm: 12.0,
  md: 16.0,
  lg: 24.0,
);

// Get value based on size class
final columns = query.valueBySizeClass(
  compact: 1,
  regular: 3,
);
```

### Using Context Extensions

```dart
// Direct context extensions
final padding = context.responsive().value(
  xs: 8.0,
  md: 16.0,
  lg: 24.0,
);

// Check breakpoints
if (context.isAtLeast(Breakpoint.md)) {
  // Medium and larger
}
```

## Adaptive Widgets

### ResponsiveBuilder

Builds different widgets based on breakpoints:

```dart
ResponsiveBuilder(
  xs: (context) => MobileLayout(),
  sm: (context) => SmallTabletLayout(),
  md: (context) => TabletLayout(),
  lg: (context) => DesktopLayout(),
  xl: (context) => LargeDesktopLayout(),
)
```

### SizeClassBuilder

Builds different widgets based on size classes:

```dart
SizeClassBuilder(
  compact: (context) => CompactLayout(),
  regular: (context) => RegularLayout(),
)

// Or with full size class information
SizeClassBuilder(
  builder: (context, sizeClasses) {
    if (sizeClasses.isRegular) {
      return RegularLayout();
    }
    return CompactLayout();
  },
)
```

### ConditionalBuilder

Conditional rendering based on breakpoint conditions:

```dart
ConditionalBuilder(
  condition: (context) => context.isAtLeast(Breakpoint.md),
  builder: (context) => DesktopLayout(),
  fallback: (context) => MobileLayout(),
)
```

### AdaptiveContainer

Container that adapts properties based on breakpoints:

```dart
AdaptiveContainer(
  width: {
    Breakpoint.xs: 100,
    Breakpoint.md: 200,
    Breakpoint.lg: 300,
  },
  padding: {
    Breakpoint.xs: EdgeInsets.all(8),
    Breakpoint.md: EdgeInsets.all(16),
  },
  child: Text('Adaptive Container'),
)

// Or use SimpleAdaptiveContainer
SimpleAdaptiveContainer(
  widthXs: 100,
  widthMd: 200,
  widthLg: 300,
  paddingXs: 8,
  paddingMd: 16,
  child: Text('Simple Adaptive'),
)
```

## Adaptive Values

Get responsive values that combine breakpoints with responsive sizing:

```dart
final adaptive = AdaptiveValues.of(context);

// Get responsive width
final width = adaptive.width(
  xs: 50,
  md: 100,
  lg: 150,
);

// Get responsive font size
final fontSize = adaptive.fontSize(
  xs: 14,
  md: 16,
  lg: 18,
);

// Get responsive padding
final padding = adaptive.padding(
  xs: EdgeInsets.all(8),
  md: EdgeInsets.all(16),
  lg: EdgeInsets.all(24),
);
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ResponsiveExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      xs: (context) => _MobileLayout(),
      md: (context) => _TabletLayout(),
      lg: (context) => _DesktopLayout(),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final padding = context.responsive().value(
      xs: 8.0,
      sm: 12.0,
    );
    
    return Container(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          Text('Mobile Layout', style: TextStyle(fontSize: 16.sp)),
          // ... mobile-specific UI
        ],
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          Expanded(child: Text('Tablet Layout', style: TextStyle(fontSize: 18.sp))),
          // ... tablet-specific UI
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('Sidebar', style: TextStyle(fontSize: 16.sp))),
          Expanded(flex: 3, child: Text('Desktop Layout', style: TextStyle(fontSize: 20.sp))),
        ],
      ),
    );
  }
}
```

