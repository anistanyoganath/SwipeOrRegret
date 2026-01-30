import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    try {
      String jsonString = await rootBundle.loadString(
        'assets/l10n/${locale.languageCode}.json',
      );
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      return true;
    } catch (e) {
      print('Error loading localization: $e');
      // Fallback to English
      if (locale.languageCode != 'en') {
        return await _loadFallback();
      }
      return false;
    }
  }

  Future<bool> _loadFallback() async {
    try {
      String jsonString = await rootBundle.loadString('assets/l10n/en.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      return true;
    } catch (e) {
      print('Error loading fallback localization: $e');
      return false;
    }
  }

  String translate(String key) {
    return _localizedStrings?[key] ?? key;
  }

  // Convenience methods for common strings
  String get appTitle => translate('app_title');
  String get tagline => translate('tagline');
  String get play => translate('play');
  String get continueGame => translate('continue_game');
  String get settings => translate('settings');
  String get leaderboard => translate('leaderboard');
  String get highScore => translate('high_score');
  String get gamesPlayed => translate('games_played');
  String get day => translate('day');
  String get money => translate('money');
  String get relationship => translate('relationship');
  String get stress => translate('stress');
  String get reputation => translate('reputation');
  String get gameOver => translate('game_over');
  String get youRegretEverything => translate('you_regret_everything');
  String get finalScore => translate('final_score');
  String get playAgain => translate('play_again');
  String get share => translate('share');
  String get revive => translate('revive');
  String get backToHome => translate('back_to_home');
  String get sound => translate('sound');
  String get music => translate('music');
  String get vibration => translate('vibration');
  String get language => translate('language');
  String get english => translate('english');
  String get sinhala => translate('sinhala');
  String get tamil => translate('tamil');
  String get resetProgress => translate('reset_progress');
  String get version => translate('version');
  String get rateApp => translate('rate_app');
  String get shareApp => translate('share_app');
  String get privacyPolicy => translate('privacy_policy');
  String get yes => translate('yes');
  String get no => translate('no');
  String get swipeToDecide => translate('swipe_to_decide');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'si', 'ta'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
