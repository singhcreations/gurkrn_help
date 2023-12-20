import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gurbani_app/services/data_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
//run krke dikhao

class _SplashScreenState extends State<SplashScreen> {
  bool initializingDatabase = false;

  void callDataInit() async{
    setState(() {
      initializingDatabase = true;
    });
    await DataService.instance.initDatabase();
    setState(() {
      initializingDatabase = false;
    });
    await Future.delayed(const Duration(microseconds: 100), () {
      GoRouter.of(context).replace('/landing');
    });
  }


  @override
  void initState() {
    // print("======================== on init ==================================");
    super.initState();
    callDataInit();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                width: 0.3.sw,
                child: const Image(
                  image: AssetImage('assets/images/play_store_512.png'),
                ),
              ),
            ),
            SizedBox(
              height: 38.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "The ਗੁਰਬਾਣੀ App",
                  style: TextStyle(
                    fontFamily: "Gurmukhi-Bold",
                    fontSize: 32.sp,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.sp,
            ),
            Container(
              width: 1.sw,
              height: 80.sp,
              padding: EdgeInsets.symmetric(horizontal: 28.sp),
              child: initializingDatabase
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Please wait, initializing..",
                              style: TextStyle(
                                  fontFamily: "Montserrat-Regular",
                                  fontSize: 14.sp,
                                  color: Colors.black54),
                            ),
                            SizedBox(
                              width: 12.sp,
                            ),
                            SizedBox(
                              width: 16.sp,
                              height: 16.sp,
                              child: const CircularProgressIndicator(
                                strokeWidth: 1.6,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12.sp,
                        ),
                        DefaultTextStyle(
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Montserrat-Regular',
                              color: Colors.black),
                          textAlign: TextAlign.center,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              RotateAnimatedText(
                                  'Initiating divine connection'),
                              RotateAnimatedText(
                                  'Fetching insights from Gurbani'),
                              RotateAnimatedText(
                                  'Bringing eternal wisdom to your fingertips'),
                              RotateAnimatedText(
                                  'Loading interpretations from Sri Guru Granth Sahib Ji'),
                              RotateAnimatedText(
                                  'Gathering celestial blessings'),
                              RotateAnimatedText(
                                  'Loading spiritual discourses'),
                              RotateAnimatedText(
                                  'Your gateway to divine understanding is unfolding'),
                              RotateAnimatedText('Aligning sacred teachings'),
                              RotateAnimatedText(
                                  'Almost there, holding the blessings...'),
                            ],
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Please wait",
                          style: TextStyle(
                              fontFamily: "Montserrat-Regular",
                              fontSize: 14.sp),
                        ),
                        SizedBox(
                          width: 12.sp,
                        ),
                        SizedBox(
                          width: 16.sp,
                          height: 16.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 1.6,
                          ),
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
