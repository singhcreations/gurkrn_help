import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gurbani_app/routes/index.dart';
import 'package:gurbani_app/utils/theme.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: themeData
    );
  }
}



