import 'package:go_router/go_router.dart';
import 'package:gurbani_app/UI/ak.dart';
import 'package:gurbani_app/screens/home_screen.dart';
import 'package:gurbani_app/screens/splash_screen.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(pageNo: 1,),
    ),
   
   
    // GoRoute(
      // path: '/name',
      // builder: (context, state) => const SelectlanguageScreen(),
    // ),
    // GoRoute(
    //   path: '/dataentry',
    // //   builder: (context, state) => const AuthPage(),
    // // ),
    // GoRoute(
    //   path: '/language',
    //   builder: (context, state) => const SelectlanguageScreen(),
    // ),
    // GoRoute(
    //   path: '/timeslot',
    //   builder: (context, state) => const TimeSlotSelectionScreen(),
    // ),
    GoRoute(
      path: '/sucess',
      builder: (context, state) => const SucessScreen(),
    ),
    // GoRoute(
    //   path: '/number',
    //   builder: (context, state) => const MyStepperScreen(),
    // ),
  ],
);
