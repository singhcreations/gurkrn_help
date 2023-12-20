import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gurbani_app/routes/index.dart';
import 'package:gurbani_app/utils/theme.dart';

import 'firebase_options.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  FlutterError.onError = (errorDetails) {
    try{
      if(errorDetails.library == 'image resource service'){
        return;
      }

      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    } catch(e){
      //
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // If you wish to record a "non-fatal" exception, please remove the "fatal" parameter
    try{
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    } catch(e){
      return true;
    }

  };
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



