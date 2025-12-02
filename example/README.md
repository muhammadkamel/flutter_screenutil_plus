# Flutter ScreenUtil Plus Example

This example demonstrates how to use the `flutter_screenutil_plus` package to create responsive UIs that adapt to different screen sizes.

## Features Demonstrated

- **Size Extensions**: Using `.w`, `.h`, `.r` for responsive width, height, and radius
- **Text Scaling**: Using `.sp` for responsive font sizes
- **TextStyle Extensions**: Using `.r`, `.withLineHeight()`, `.withAutoLineHeight()` for responsive text styles
- **Responsive Widgets**: `RPadding`, `RSizedBox`, `RContainer`, and `RText` widgets
- **Breakpoints & Size Classes**: CSS-like breakpoints and SwiftUI-like size classes
- **Adaptive Layouts**: `ResponsiveBuilder`, `AdaptiveContainer`, and adaptive values
- **Screen Information**: Displaying screen metrics and scaling factors
- **Shapes & Borders**: Responsive border radius and spacing

## Running the Example

1. Navigate to the example directory:

   ```bash
   cd example
   ```

2. Get dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

## Key Concepts

### ScreenUtilInit

The app is initialized with `ScreenUtilInit` which sets the design size (360x690 dp) and enables text adaptation.

### Extension Methods

#### Size Extensions

- `50.w` - Adapts to screen width
- `50.h` - Adapts to screen height
- `50.r` - Adapts to the smaller of width or height (for squares/circles)
- `16.sp` - Adapts font size to screen width

#### TextStyle Extensions

- `TextStyle(...).r` - Scales font size while preserving height multiplier
- `TextStyle(...).withLineHeight(1.5)` - Scales font size with custom line height
- `TextStyle(...).withAutoLineHeight()` - Scales font size with default line height (1.2)

### Responsive Widgets

- `RText` - Text widget with automatic font size scaling
- `RContainer` - Container with responsive dimensions
- `RPadding` - Padding that automatically scales
- `RSizedBox` - SizedBox with responsive dimensions
- `REdgeInsets` - EdgeInsets with responsive values

## Design Size

The example uses a design size of 360x690 dp, which is a common mobile phone screen size. All measurements in the app are based on this design size and will scale proportionally to different device screens.
