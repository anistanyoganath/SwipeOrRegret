import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:swipeorregret/app/app_routes.dart';
import 'package:swipeorregret/app/app_theme.dart';
import 'package:swipeorregret/l10n/app_localizations.dart';

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
      routes: AppRoutes.routes,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('si', ''), // Sinhala
        Locale('ta', ''), // Tamil
      ],
    );
  }
}
