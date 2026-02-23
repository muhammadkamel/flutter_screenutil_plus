import 'package:flutter/material.dart';

const Size _designSize = Size(390, 844);

void main() => runApp(const StandardApp());

class StandardApp extends StatelessWidget {
  const StandardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: StandardHomePage());
  }
}

class StandardHomePage extends StatefulWidget {
  const StandardHomePage({super.key});
  @override
  State<StandardHomePage> createState() => _StandardHomePageState();
}

class _StandardHomePageState extends State<StandardHomePage> {
  bool _isDeepTree = true;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final widthRatio = mq.size.width / _designSize.width;
    final heightRatio = mq.size.height / _designSize.height;

    // Standard scaling formulas manually crafted for the benchmark
    double scaleW(double w) => w * widthRatio;
    double scaleH(double h) => h * heightRatio;
    double scaleSp(double sp) => sp * widthRatio * mq.textScaler.scale(1);

    return Scaffold(
      appBar: AppBar(
        title: Text('Standard App', style: TextStyle(fontSize: scaleSp(20))),
        actions: [
          IconButton(
            key: const ValueKey('toggle_view'),
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => setState(() => _isDeepTree = !_isDeepTree),
          ),
        ],
      ),
      body: _isDeepTree
          ? StandardDeepTree(
              depth: 50,
              scaleW: scaleW,
              scaleH: scaleH,
              scaleSp: scaleSp,
            )
          : StandardList(scaleW: scaleW, scaleH: scaleH, scaleSp: scaleSp),
    );
  }
}

class StandardDeepTree extends StatelessWidget {
  final int depth;
  final double Function(double) scaleW;
  final double Function(double) scaleH;
  final double Function(double) scaleSp;

  const StandardDeepTree({
    super.key,
    required this.depth,
    required this.scaleW,
    required this.scaleH,
    required this.scaleSp,
  });

  @override
  Widget build(BuildContext context) {
    if (depth == 0) {
      return Container(
        width: scaleW(100),
        height: scaleH(100),
        color: Colors.blue,
        child: Center(
          child: Text('Deep', style: TextStyle(fontSize: scaleSp(16))),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scaleW(2), vertical: scaleH(2)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(scaleW(5)),
          border: Border.all(width: scaleW(1), color: Colors.grey),
        ),
        child: StandardDeepTree(
          depth: depth - 1,
          scaleW: scaleW,
          scaleH: scaleH,
          scaleSp: scaleSp,
        ),
      ),
    );
  }
}

class StandardList extends StatelessWidget {
  final double Function(double) scaleW;
  final double Function(double) scaleH;
  final double Function(double) scaleSp;

  const StandardList({
    super.key,
    required this.scaleW,
    required this.scaleH,
    required this.scaleSp,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const ValueKey('list_view'),
      itemCount: 1000,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(scaleW(8)),
          child: Container(
            height: scaleH(50),
            color: index.isEven
                ? Colors.red.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            child: Row(
              children: [
                SizedBox(width: scaleW(10)),
                Text('Item $index', style: TextStyle(fontSize: scaleSp(14))),
                SizedBox(width: scaleW(10)),
                Container(
                  width: scaleW(20),
                  height: scaleW(20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(scaleW(10)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
