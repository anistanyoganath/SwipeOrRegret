import 'package:flutter/material.dart';
import 'package:swipeorregret/app/app_routes.dart';
import 'package:swipeorregret/app/app_theme.dart';
import 'package:swipeorregret/features/game/game_screen.dart';
import 'package:swipeorregret/features/game_over/game_over_screen.dart';
import 'package:swipeorregret/features/home/home_screen.dart';
import 'package:swipeorregret/features/settings/settings_screen.dart';
import 'package:swipeorregret/features/splash/splash_screen.dart';

class SwipeOrRegretApp extends StatelessWidget {
  const SwipeOrRegretApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe or Regret',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.game: (context) => const GameScreen(),
        AppRoutes.gameOver: (context) => const GameOverScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
      },
    );
  }
}
