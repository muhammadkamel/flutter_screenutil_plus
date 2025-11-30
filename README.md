<div align="center">
  <img src="https://raw.githubusercontent.com/muhammadkamel/flutter_screenutil_plus/master/assets/logo.png" alt="flutter_screenutil_plus" width="200"/>
</div>

# flutter_screenutil_plus

[![Flutter Package](https://img.shields.io/pub/v/flutter_screenutil_plus.svg)](https://pub.dev/packages/flutter_screenutil_plus)
[![Pub Points](https://img.shields.io/pub/points/flutter_screenutil_plus)](https://pub.dev/packages/flutter_screenutil_plus/score)

**A flutter plugin for adapting screen and font size.Let your UI display a reasonable layout on different screen sizes!**

## Usage

### Add dependency

Please check the latest version before installation.
If there is any problem with the new version, please use the previous version

```yaml
dependencies:
  flutter:
    sdk: flutter
  # add flutter_screenutil_plus
  flutter_screenutil_plus: ^{latest version}
```

### Add the following imports to your Dart code

```dart
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
```

### Properties

| Property          | Type             | Default Value | Description                                                                                                                                   |
| ----------------- | ---------------- | ------------- |-----------------------------------------------------------------------------------------------------------------------------------------------|
| designSize        | Size             | Size(360,690) | The size of the device screen in the design draft, in dp                                                                                      |
| builder           | Function         | null          | Return widget that uses the library in a property (ex: MaterialApp's theme)                                                                   |
| child             | Widget           | null          | A part of builder that its dependencies/properties don't use the library                                                                      |
| rebuildFactor     | RebuildFactor    | RebuildFactors.size | Function that takes old and new screen metrics and returns whether to rebuild or not when changes occur. See [RebuildFactors](#rebuild-factors) |
| splitScreenMode   | bool             | false         | Support for split screen mode                                                                                                                 |
| minTextAdapt      | bool             | false         | Whether to adapt the text according to the minimum of width and height                                                                        |
| ensureScreenSize  | bool             | false         | Whether to wait for screen size to be initialized before building (useful for web/desktop)                                                    |
| fontSizeResolver  | FontSizeResolver | FontSizeResolvers.width | Function that specifies how font size should be adapted. See [FontSizeResolvers](#font-size-resolvers) |
| responsiveWidgets | Iterable<String> | null          | List/Set of widget names that should be included in rebuilding tree. (See [How flutter_screenutil_plus marks a widget needs build](#rebuild-list)) |
| enableScaleWH     | Function         | null          | Function to enable/disable scaling of width and height                                                                                        |
| enableScaleText   | Function         | null          | Function to enable/disable scaling of text                                                                                                     |


**Note : You must either provide builder, child or both.**

### Rebuild Factors

The `rebuildFactor` parameter controls when the widget tree should rebuild based on MediaQuery changes. Available options:

- `RebuildFactors.size` (default) - Rebuild when screen size changes
- `RebuildFactors.orientation` - Rebuild when orientation changes
- `RebuildFactors.sizeAndViewInsets` - Rebuild when view insets change
- `RebuildFactors.change` - Rebuild on any MediaQuery change
- `RebuildFactors.always` - Always rebuild
- `RebuildFactors.none` - Never rebuild automatically

You can also provide a custom function:
```dart
rebuildFactor: (oldData, newData) => oldData.size != newData.size
```

### Font Size Resolvers

The `fontSizeResolver` parameter controls how font sizes are calculated. Available options:

- `FontSizeResolvers.width` (default) - Scale based on screen width
- `FontSizeResolvers.height` - Scale based on screen height
- `FontSizeResolvers.radius` - Scale based on the smaller of width/height
- `FontSizeResolvers.diameter` - Scale based on the larger of width/height
- `FontSizeResolvers.diagonal` - Scale based on diagonal calculation

You can also provide a custom function:
```dart
fontSizeResolver: (fontSize, instance) => instance.setWidth(fontSize * 0.9)
```

### Rebuild list
Starting from version 1.0.0, ScreenUtilInit won't rebuild the whole widget tree, instead it will mark widget needs build only if:
- Widget is not a flutter widget (widgets are available in [Flutter Docs](https://docs.flutter.dev/reference/widgets))
- Widget does not start with underscore (`_`)
- Widget does not declare `SU` mixin
- `responsiveWidgets` does not contains widget name

If you have a widget that uses the library and doesn't meet these options you can either add `SU` mixin or add widget name in responsiveWidgets list.

#### Using the SU Mixin

To mark a custom widget for automatic rebuilding, use the `SU` mixin:

```dart
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class MyCustomWidget extends StatelessWidget with SU {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 50.h,
      child: Text('Responsive', style: TextStyle(fontSize: 16.sp)),
    );
  }
}
```

### Initialize and set the fit size and font size to scale according to the system's "font size" accessibility option 

Please set the size of the design draft before use, the width and height of the design draft.

#### The first way (Recommended - Use it once in your app)

```dart
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilPlusInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilPlusInit context
      builder: (_ , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child: const HomePage(title: 'First Method'),
    );
  }
}
```

#### Using ResponsiveTheme

For easier theme management, you can use `ResponsiveTheme` to automatically scale all text styles:

```dart
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

ScreenUtilPlusInit(
  designSize: const Size(360, 690),
  builder: (context, child) {
    return MaterialApp(
      theme: ResponsiveTheme.fromTheme(
        ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            headlineLarge: TextStyle(fontSize: 24),
            bodyLarge: TextStyle(fontSize: 16),
          ),
        ),
      ),
      home: child,
    );
  },
  child: HomePage(),
)
```

#### The second way:You need a trick to support font adaptation in the textTheme of app theme

**Hybrid development uses the second way**

not support this:

```dart
MaterialApp(
  ...
  //To support the following, you need to use the first initialization method
  theme: ThemeData(
    textTheme: TextTheme(
      button: TextStyle(fontSize: 45.sp)
    ),
  ),
)
```

but you can do this:

```dart
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

void main() async {
  // Add this line to wait for screen size initialization (useful for web/desktop)
  await ScreenUtilPlus.ensureScreenSize();
  runApp(MyApp());
}
...
MaterialApp(
  ...
  builder: (ctx, child) {
    ScreenUtilPlus.init(ctx);
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(bodyLarge: TextStyle(fontSize: 30.sp)),
      ),
      child: HomePage(title: 'FlutterScreenUtil Demo'),
    );
  },
)
```

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter_ScreenUtil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'FlutterScreenUtil Demo'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //Set the fit size (fill in the screen size of the device in the design) 
    //If the design is based on the size of the 360*690(dp)
    ScreenUtilPlus.init(context, designSize: const Size(360, 690));
    ...
  }
}
```

**Note: calling `ScreenUtilPlus.init` a second time, any non-provided parameter will not be replaced with default value. Use `ScreenUtilPlus.configure` instead**

#### Using ensureScreenSize in ScreenUtilPlusInit

For web and desktop apps, you can use the `ensureScreenSize` parameter:

```dart
ScreenUtilPlusInit(
  designSize: const Size(360, 690),
  ensureScreenSize: true, // Waits for screen size before building
  builder: (context, child) {
    return MaterialApp(home: child);
  },
  child: HomePage(),
)
```

### API

#### Enable or disable scale

```dart
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      enableScaleWH: () => false,  // Disable width/height scaling
      enableScaleText: () => false, // Disable text scaling
      //...
    );
  }
```

or

```dart
ScreenUtilPlus.enableScale(
  enableWH: () => false, 
  enableText: () => false
);
```

#### Device Type Detection

You can detect the device type for platform-specific UI adjustments:

```dart
final deviceType = ScreenUtilPlus().deviceType(context);
switch (deviceType) {
  case DeviceType.mobile:
    // Mobile-specific UI
    break;
  case DeviceType.tablet:
    // Tablet-specific UI
    break;
  case DeviceType.web:
    // Web-specific UI
    break;
  // ... other device types
}
```

#### Register Elements for Rebuild (Experimental)

For web and desktop apps, you can manually register elements to rebuild:

```dart
// Register current widget and descendants
ScreenUtilPlus.registerToBuild(context, withDescendants: true);

// Or register only the current widget
ScreenUtilPlus.registerToBuild(context);
```


#### Pass the dp size of the design draft

```dart
    // Size extensions
    ScreenUtilPlus().setWidth(540)  (dart sdk>=2.6 : 540.w) //Adapted to screen width
    ScreenUtilPlus().setHeight(200) (dart sdk>=2.6 : 200.h) //Adapted to screen height
    ScreenUtilPlus().radius(200)    (dart sdk>=2.6 : 200.r) //Adapt according to the smaller of width or height
    ScreenUtilPlus().diagonal(200)  (dart sdk>=2.6 : 200.dg) //Adapt according to diagonal calculation
    ScreenUtilPlus().diameter(200)  (dart sdk>=2.6 : 200.dm) //Adapt according to the larger of width/height
    ScreenUtilPlus().setSp(24)      (dart sdk>=2.6 : 24.sp) //Adapter font
    12.spMin   //return min(12,12.sp) - prevents font from being too large
    12.spMax   //return max(12,12.sp) - ensures minimum font size

    // Screen properties
    ScreenUtilPlus().pixelRatio       //Device pixel density
    ScreenUtilPlus().screenWidth   (dart sdk>=2.6 : 1.sw)    //Device width
    ScreenUtilPlus().screenHeight  (dart sdk>=2.6 : 1.sh)    //Device height
    ScreenUtilPlus().bottomBarHeight  //Bottom safe zone distance, suitable for buttons with full screen
    ScreenUtilPlus().statusBarHeight  //Status bar height, Notch will be higher
    ScreenUtilPlus().textScaleFactor  //System font scaling factor
    ScreenUtilPlus().scaleWidth //The ratio of actual width to UI design
    ScreenUtilPlus().scaleHeight //The ratio of actual height to UI design
    ScreenUtilPlus().orientation  //Screen orientation

    // Spacing helpers
    0.2.sw  //0.2 times the screen width
    0.5.sh  //50% of screen height
    20.verticalSpace  // SizedBox(height: 20 * scaleHeight)
    20.horizontalSpace  // SizedBox(width: 20 * scaleWidth)
    20.verticalSpaceFromWidth  // SizedBox(height: 20 * scaleWidth)
    20.horizontalSpaceRadius  // SizedBox(width: 20.r)
    20.verticalSpacingRadius  // SizedBox(height: 20.r)
    20.horizontalSpaceDiameter  // SizedBox(width: 20.dm)
    20.verticalSpacingDiameter  // SizedBox(height: 20.dm)
    20.horizontalSpaceDiagonal  // SizedBox(width: 20.dg)
    20.verticalSpacingDiagonal  // SizedBox(height: 20.dg)

    // Responsive widgets
    const RPadding.all(8)   // Padding.all(8.r) - take advantage of const keyword
    REdgeInsets.all(8)       // EdgeInsets.all(8.r)
    REdgeInsets.only(left: 8, right: 8) // EdgeInsets.only(left: 8.r, right: 8.r)
    REdgeInsets.symmetric(vertical: 8, horizontal: 16) // Symmetric padding
    REdgeInsetsDirectional.all(8) // Directional padding
    RSizedBox(width: 100, height: 50) // Responsive SizedBox
    RSizedBox.square(dimension: 50) // Square SizedBox
    RContainer(width: 100, height: 50) // Responsive Container
    RText('Hello', style: TextStyle(fontSize: 16)) // Responsive Text (auto-scales fontSize)

    // Extension methods on existing widgets
    EdgeInsets.all(10).w    //EdgeInsets.all(10.w)
    EdgeInsets.all(10).h    //EdgeInsets.all(10.h)
    EdgeInsets.all(10).r    //EdgeInsets.all(10.r)
    EdgeInsets.all(10).dm   //EdgeInsets.all(10.dm)
    EdgeInsets.all(10).dg   //EdgeInsets.all(10.dg)
    EdgeInsets.only(left:8,right:8).r // EdgeInsets.only(left:8.r,right:8.r)
    BoxConstraints(maxWidth: 100, minHeight: 100).w    //BoxConstraints(maxWidth: 100.w, minHeight: 100.w)
    BoxConstraints(maxWidth: 100, minHeight: 100).h    //BoxConstraints(maxWidth: 100.h, minHeight: 100.h)
    BoxConstraints(maxWidth: 100, minHeight: 100).r    //BoxConstraints(maxWidth: 100.r, minHeight: 100.r)
    BoxConstraints(maxWidth: 100, minHeight: 100).hw   //BoxConstraints(maxWidth: 100.w, minHeight: 100.h)
    Radius.circular(16).w          //Radius.circular(16.w)
    Radius.circular(16).h          //Radius.circular(16.h)
    Radius.circular(16).r          //Radius.circular(16.r)
    BorderRadius.circular(16).w    //BorderRadius with width-based radius
    BorderRadius.circular(16).h    //BorderRadius with height-based radius
    BorderRadius.circular(16).r    //BorderRadius with radius-based scaling  
```

#### Adapt screen size

Pass the dp size of the design draft (The unit is the same as the unit at initialization):

- Adapted to screen width: `ScreenUtilPlus().setWidth(540)` or `540.w`
- Adapted to screen height: `ScreenUtilPlus().setHeight(200)` or `200.h`
- Adapted to radius (smaller of width/height): `ScreenUtilPlus().radius(200)` or `200.r`
- Adapted to diagonal: `ScreenUtilPlus().diagonal(200)` or `200.dg`
- Adapted to diameter (larger of width/height): `ScreenUtilPlus().diameter(200)` or `200.dm`

In general, the height is best to adapt to the width to avoid deformation.

If your dart sdk>=2.6, you can use extension functions:

example:

instead of :

```dart
Container(
  width: ScreenUtil().setWidth(50),
  height:ScreenUtil().setHeight(200),
)
```

you can use it like this:

```dart
Container(
  width: 50.w,
  height:200.h
)
```

#### `Note`

The height can also use setWidth to ensure that it is not deformed(when you want a square)

The setHeight method is mainly to adapt to the height, which is used when you want to control the height of a screen on the UI to be the same as the actual display.

Generally speaking, 50.w!=50.h.

```dart
//for example:

//If you want to display a rectangle:
Container(
  width: 375.w,
  height: 375.h,
),
            
//If you want to display a square based on width:
Container(
  width: 300.w,
  height: 300.w,
),

//If you want to display a square based on height:
Container(
  width: 300.h,
  height: 300.h,
),

//If you want to display a square based on minimum(height, width):
Container(
  width: 300.r,
  height: 300.r,
),
```

#### Adapter font

```dart
//Incoming font size (The unit is the same as the unit at initialization)
ScreenUtilPlus().setSp(28) 
28.sp

// Smart font sizing
12.spMin  // Returns min(12, 12.sp) - prevents font from being too large
12.spMax  // Returns max(12, 12.sp) - ensures minimum font size

//for example:
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    Text(
      '16sp, will not change with the system.',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
      ),
      textScaler: TextScaler.linear(1.0), // Use textScaler instead of textScaleFactor
    ),
    Text(
      '16sp, if data is not set in MediaQuery, my font size will change with the system.',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
      ),
    ),
    // Using RText for automatic font scaling
    RText(
      'Auto-scaled text',
      style: TextStyle(fontSize: 16), // Automatically converted to 16.sp
    ),
  ],
)
```

#### Setting font does not change with system font size

APP global:

```dart
MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Flutter_ScreenUtil',
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
  builder: (context, widget) {
    return MediaQuery(
      ///Setting font does not change with system font size
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(1.0), // Use textScaler instead of textScaleFactor
      ),
      child: widget,
    );
  },
  home: HomePage(title: 'FlutterScreenUtil Demo'),
),
```

Specified Text:

```dart
Text("text", textScaler: TextScaler.linear(1.0))
```

Specified Widget:

```dart
MediaQuery(
  // If there is no context available you can wrap [MediaQuery] with [Builder]
  data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
  child: AnyWidget(),
)
```

### Responsive Widgets

The package provides several responsive widgets that automatically apply scaling:

#### RContainer

A responsive Container that automatically scales width, height, padding, and margin:

```dart
RContainer(
  width: 100,
  height: 50,
  padding: EdgeInsets.all(8), // Automatically converted to 8.r
  margin: EdgeInsets.symmetric(horizontal: 16), // Automatically scaled
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8.r),
  ),
  child: Text('Responsive Container'),
)
```

#### RPadding

A responsive Padding widget:

```dart
RPadding(
  padding: EdgeInsets.all(16), // Automatically converted to 16.r
  child: Text('Padded content'),
)

// Or use REdgeInsets for const constructors
const RPadding(
  padding: REdgeInsets.all(8),
  child: Text('Const padding'),
)
```

#### RSizedBox

A responsive SizedBox:

```dart
RSizedBox(
  width: 100,  // Automatically scaled
  height: 50,  // Automatically scaled
  child: Text('Sized content'),
)

// Square SizedBox
RSizedBox.square(
  dimension: 50, // Automatically scaled
  child: Icon(Icons.star),
)
```

#### RText

A responsive Text widget that automatically scales font size:

```dart
RText(
  'Hello World',
  style: TextStyle(fontSize: 16), // Automatically converted to 16.sp
)
```

### Performance Optimizations

Starting from version 1.1.1, the package includes intelligent change detection using Equatable to optimize rebuilds:

- **Automatic change detection**: Only rebuilds registered elements when screen metrics actually change
- **Value-based equality**: Uses Equatable to compare screen configuration state efficiently
- **Reduced unnecessary rebuilds**: Prevents rebuilds when configuration remains functionally identical

This optimization is automatic and requires no code changes. The package will only trigger rebuilds when:

- Screen size changes
- Orientation changes
- Split screen mode changes
- Minimum text adaptation setting changes
- Font size resolver function changes
