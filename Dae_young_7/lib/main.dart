import 'package:flutter/material.dart';

import 'package:flutter_cfmid_1/user/view/splash_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(fontFamily: 'NotoSnas'),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen());
  }
}
