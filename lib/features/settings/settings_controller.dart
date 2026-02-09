import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeorregret/core/services/audio_service.dart';
import 'package:swipeorregret/features/home/streak_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends ChangeNotifier {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _vibrationEnabled = true;
  bool _showTimer = true;
  ThemeMode _themeMode = ThemeMode.system;

  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get showTimer => _showTimer;
  ThemeMode get themeMode => _themeMode;
  StreakController get streakController => StreakController.getInstance();

  SettingsController() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _musicEnabled = prefs.getBool('music_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _showTimer = prefs.getBool('show_timer') ?? true;

      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    _saveSetting('theme_mode', themeMode.index);
    notifyListeners();
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> toggleSound(bool value) async {
    _soundEnabled = value;
    AudioService().toggleSound(value);
    notifyListeners();
  }

  Future<void> toggleMusic(bool value) async {
    _musicEnabled = value;
    AudioService().toggleMusic(value);
    notifyListeners();
  }

  Future<void> toggleVibration(bool value) async {
    _vibrationEnabled = value;
    await _saveSetting('vibration_enabled', value);
    notifyListeners();
  }

  Future<void> toggleShowTimer(bool value) async {
    _showTimer = value;
    await _saveSetting('show_timer', value);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear all game progress
      await prefs.remove('high_score');
      await prefs.remove('total_games');
      await prefs.remove('streak_days');
      await prefs.remove('game_state');
      await prefs.remove('has_saved_game');

      // Reset to default values
      await prefs.setInt('high_score', 0);
      await prefs.setInt('total_games', 0);
      await prefs.setInt('streak_days', 1);
      await prefs.setBool('has_saved_game', false);

      streakController.resetStreak();

      // Reload settings
      await _loadSettings();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> loadMoreScenarios() async {
    // Implement scenario download logic
    // This could fetch from Firebase or API
  }

  Future<void> rateApp() async {
    final url = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.adavii.swipeorregret',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> shareApp() async {
    const text =
        'Check out Swipe or Regret - A rapid decision-making game '
        'where every choice matters! '
        '\n\nOne choice. No undo. '
        '\n\nDownload now!';

    await SharePlus.instance.share(ShareParams(text: text));
  }

  Future<void> openPrivacyPolicy() async {
    final url = Uri.parse('https://adavii.com/privacy');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
