import 'package:flutter/material.dart';
import 'package:swipeorregret/features/splash/splash_screen.dart';
import 'package:swipeorregret/features/home/home_screen.dart';
import 'package:swipeorregret/features/game/game_screen.dart';
import 'package:swipeorregret/features/game_over/game_over_screen.dart';
import 'package:swipeorregret/features/settings/settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String game = '/game';
  static const String gameOver = '/game-over';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      home: (context) => const HomeScreen(),
      game: (context) => const GameScreen(),
      gameOver: (context) {
        // Get arguments passed when navigating
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

        return GameOverScreen(
          finalScore: args?['finalScore'] ?? 0,
          reason: args?['reason'],
          finalStats: Map<String, int>.from(args?['finalStats'] ?? {}),
        );
      },
      settings: (context) => const SettingsScreen(),
    };
  }

  // Helper methods for navigation
  static void goToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, home, (route) => false);
  }

  static void goToGame(BuildContext context) {
    Navigator.pushNamed(context, game);
  }

  static void goToGameOver(
    BuildContext context, {
    required int finalScore,
    String? reason,
    Map<String, int> finalStats = const {},
  }) {
    Navigator.pushNamed(
      context,
      gameOver,
      arguments: {
        'finalScore': finalScore,
        'reason': reason,
        'finalStats': finalStats,
      },
    );
  }

  static void goToSettings(BuildContext context) {
    Navigator.pushNamed(context, settings);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
