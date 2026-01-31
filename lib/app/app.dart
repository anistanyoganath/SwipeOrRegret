import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:swipeorregret/app/app_routes.dart';
import 'package:swipeorregret/app/app_theme.dart';
import 'package:swipeorregret/core/provider/local_provider.dart';
import 'package:swipeorregret/l10n/app_localizations.dart';

class SwipeOrRegretApp extends StatelessWidget {
  const SwipeOrRegretApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          title: 'Swipe or Regret',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getLightTheme(localeProvider.locale),
          darkTheme: AppTheme.getDarkTheme(localeProvider.locale),
          locale: localeProvider.locale,
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
      },
    );
  }
}
