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

  // String interpolation helper
  String translateWithParams(String key, Map<String, String> params) {
    String text = translate(key);
    params.forEach((key, value) {
      text = text.replaceAll('{$key}', value);
    });
    return text;
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

  // Day count with parameter
  String dayCount(int count) =>
      translateWithParams('day_count', {'count': count.toString()});

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
  String get appearance => translate('appearance');
  String get darkMode => translate('dark_mode');
  String get audio => translate('audio');
  String get soundEffects => translate('sound_effects');
  String get backgroundMusic => translate('background_music');
  String get gameSettings => translate('game_settings');
  String get showTimer => translate('show_timer');
  String get data => translate('data');
  String get resetGameData => translate('reset_game_data');
  String get clearAllProgress => translate('clear_all_progress');
  String get loadMoreScenarios => translate('load_more_scenarios');
  String get downloadContent => translate('download_content');
  String get about => translate('about');
  String get confirmReset => translate('confirm_reset');
  String get cancel => translate('cancel');
  String get reset => translate('reset');
  String get progressResetSuccess => translate('progress_reset_success');
  String get info => translate('info');
  String get appVersion => translate('app_version');

  // Streak related
  String get dailyStreakRewards => translate('daily_streak_rewards');
  String currentStreak(int count) =>
      translateWithParams('current_streak_format', {'count': count.toString()});

  String get playDailyMaintain => translate('play_daily_maintain');
  String get howStreaksWork => translate('how_streaks_work');
  String get streakRules => translate('streak_rules');
  String get achievedRewards => translate('achieved_rewards');
  String get upcomingRewards => translate('upcoming_rewards');
  String get proTip => translate('pro_tip');
  String get streakBonusInfo => translate('streak_bonus_info');
  String get gotIt => translate('got_it');
  String daysLeft(int count) =>
      translateWithParams('days_left_format', {'count': count.toString()});
  String get startStreak => translate('start_streak');
  String playMoreDays(int count, int bonus) => translateWithParams(
    'play_more_days',
    {'count': count.toString(), 'bonus': bonus.toString()},
  );
  String get moreForBonus => translate('more_for_bonus');
  String get rank => translate('rank');

  // Days word
  String get days => translate('days');

  // Streak rewards
  String get reward3Days => translate('reward_3_days');
  String get reward7Days => translate('reward_7_days');
  String get reward14Days => translate('reward_14_days');
  String get reward30Days => translate('reward_30_days');

  // Game Over Screen
  String get revived => translate('revived');
  String get reviveMessage => translate('revive_message');
  String get continueButton => translate('continue');
  String get ranOutOfResources => translate('ran_out_of_resources');
  String daySurvived(int count) =>
      translateWithParams('day_survived', {'count': count.toString()});
  String get moneyStat => translate('money_stat');
  String get relationshipStat => translate('relationship_stat');
  String get stressStat => translate('stress_stat');
  String get reputationStat => translate('reputation_stat');
  String get playAgainButton => translate('play_again_button');
  String get shareButton => translate('share_button');
  String get reviveButton => translate('revive_button');
  String get backToHomeButton => translate('back_to_home_button');

  // Additional missing getters
  String get ok => translate('ok');
  String get close => translate('close');
  String get error => translate('error');
  String get success => translate('success');
  String get warning => translate('warning');
  String get loading => translate('loading');
  String get noInternet => translate('no_internet');
  String get tryAgain => translate('try_again');
  String get comingSoon => translate('coming_soon');
  String get updateAvailable => translate('update_available');
  String get updateNow => translate('update_now');
  String get later => translate('later');
  String get search => translate('search');
  String get filter => translate('filter');
  String get sort => translate('sort');
  String get ascending => translate('ascending');
  String get descending => translate('descending');
  String get all => translate('all');
  String get none => translate('none');
  String get selectAll => translate('select_all');
  String get deselectAll => translate('deselect_all');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get save => translate('save');
  String get discard => translate('discard');
  String get confirm => translate('confirm');
  String get proceed => translate('proceed');
  String get back => translate('back');
  String get next => translate('next');
  String get skip => translate('skip');
  String get done => translate('done');
  String get finish => translate('finish');
  String get start => translate('start');
  String get stop => translate('stop');
  String get pause => translate('pause');
  String get resume => translate('resume');
  String get restart => translate('restart');
  String get exit => translate('exit');
  String get quit => translate('quit');

  // Game specific
  String get swipeLeft => translate('swipe_left');
  String get swipeRight => translate('swipe_right');
  String get thinkFast => translate('think_fast');
  String get timeUp => translate('time_up');
  String get decisionMade => translate('decision_made');
  String get scenarioComplete => translate('scenario_complete');
  String get newHighScore => translate('new_high_score');
  String get congratulations => translate('congratulations');
  String get betterLuckNextTime => translate('better_luck_next_time');
  String get achievements => translate('achievements');
  String get achievementsUnlocked => translate('achievements_unlocked');
  String get viewAchievements => translate('view_achievements');
  String get dailyChallenges => translate('daily_challenges');
  String get challengeCompleted => translate('challenge_completed');
  String get claimReward => translate('claim_reward');
  String get rewardClaimed => translate('reward_claimed');

  // Stats
  String get totalScore => translate('total_score');
  String get averageScore => translate('average_score');
  String get bestStreak => translate('best_streak');
  String get winRate => translate('win_rate');
  String get decisionsMade => translate('decisions_made');
  String get scenariosPlayed => translate('scenarios_played');
  String get timePlayed => translate('time_played');
  String get hours => translate('hours');
  String get minutes => translate('minutes');
  String get seconds => translate('seconds');

  // Tutorial
  String get tutorialTitle => translate('tutorial_title');
  String get tutorialStep1 => translate('tutorial_step_1');
  String get tutorialStep2 => translate('tutorial_step_2');
  String get tutorialStep3 => translate('tutorial_step_3');
  String get tutorialStep4 => translate('tutorial_step_4');
  String get skipTutorial => translate('skip_tutorial');

  // Shop/IAP
  String get shop => translate('shop');
  String get store => translate('store');
  String get purchase => translate('purchase');
  String get buy => translate('buy');
  String get price => translate('price');
  String get free => translate('free');
  String get owned => translate('owned');
  String get equipped => translate('equipped');
  String get equip => translate('equip');
  String get unequip => translate('unequip');
  String get coins => translate('coins');
  String get gems => translate('gems');
  String get insufficientFunds => translate('insufficient_funds');
  String get purchaseSuccessful => translate('purchase_successful');
  String get purchaseFailed => translate('purchase_failed');
  String get restorePurchases => translate('restore_purchases');
  String get restoring => translate('restoring');
  String get restoreComplete => translate('restore_complete');

  // Notifications
  String get notifications => translate('notifications');
  String get enableNotifications => translate('enable_notifications');
  String get dailyReminder => translate('daily_reminder');
  String get reminderTime => translate('reminder_time');
  String get streakReminder => translate('streak_reminder');
  String get newContentAvailable => translate('new_content_available');

  // Accessibility
  String get accessibility => translate('accessibility');
  String get reduceMotion => translate('reduce_motion');
  String get highContrast => translate('high_contrast');
  String get largeText => translate('large_text');
  String get screenReader => translate('screen_reader');
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
