# Flutter ScreenUtil Plus Example

This example demonstrates how to use the `flutter_screenutil_plus` package to create responsive UIs that adapt to different screen sizes.

## Features Demonstrated

- **Size Extensions**: Using `.w`, `.h`, `.r` for responsive width, height, and radius
- **Text Scaling**: Using `.sp` for responsive font sizes
- **Responsive Widgets**: `RPadding` and `RSizedBox` widgets
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

- `50.w` - Adapts to screen width
- `50.h` - Adapts to screen height
- `50.r` - Adapts to the smaller of width or height (for squares/circles)
- `16.sp` - Adapts font size to screen width

### Responsive Widgets

- `RPadding` - Padding that automatically scales
- `RSizedBox` - SizedBox with responsive dimensions
- `REdgeInsets` - EdgeInsets with responsive values

## Design Size

The example uses a design size of 360x690 dp, which is a common mobile phone screen size. All measurements in the app are based on this design size and will scale proportionally to different device screens.
