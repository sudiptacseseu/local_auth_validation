import 'package:flutter/material.dart';

import 'file:///C:/Users/Sudipta_CST/Flutter%20Projects/FlutterAuthFaceID-FingerPrint/lib/views/home.dart';

void main() => runApp(LocalAuthApp());

class LocalAuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      theme: ThemeData(),
      home: Home(title: 'Local Auth (Face ID/Touch ID)'),
    );
  }
}
