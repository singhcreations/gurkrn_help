import 'package:go_router/go_router.dart';
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
      builder: (context, state) => const HomeScreen(offset: 0),
    ),
  ],
);
