import 'package:YugoAuto/MyCustomWebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'YugoAuto',
      theme: CupertinoThemeData(),
      home: LoaderOverlay(child: new MyCustomWebView()),
    );
  }
}
