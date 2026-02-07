import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swipeorregret/app/app.dart';
import 'package:swipeorregret/core/provider/local_provider.dart';
import 'package:swipeorregret/core/provider/theme_provider.dart';
import 'package:swipeorregret/features/home/streak_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Optional: Preload fonts for better performance
  await _preloadFonts();

  // Create and load locale provider
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  // Initialize the streak controller
  final streakController = StreakController.getInstance();
  await streakController.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: streakController),
      ],
      child: const SwipeOrRegretApp(),
    ),
  );
}

Future<void> _preloadFonts() async {
  try {
    // Preload fonts for better performance
    await GoogleFonts.pendingFonts([
      // English font
      GoogleFonts.getFont('Inter'),
      // Sinhala font
      GoogleFonts.getFont('Noto Sans Sinhala'),
      // Tamil font
      GoogleFonts.getFont('Noto Sans Tamil'),
    ]);
  } catch (e) {
    print('Error preloading fonts: $e');
  }
}
