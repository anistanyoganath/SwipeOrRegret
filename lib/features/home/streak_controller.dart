import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakController with ChangeNotifier {
  final SharedPreferences _prefs;

  String get _streakKey => 'daily_streak';
  String get _lastPlayDateKey => 'last_play_date';

  int _streakDays = 0;
  DateTime? _lastPlayDate;

  StreakController(this._prefs) {
    _loadStreak();
  }

  int get streakDays => _streakDays;

  void _loadStreak() {
    _streakDays = _prefs.getInt(_streakKey) ?? 0;
    final lastPlayString = _prefs.getString(_lastPlayDateKey);
    _lastPlayDate = lastPlayString != null
        ? DateTime.parse(lastPlayString)
        : null;
  }

  void updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastPlayDate == null) {
      // First time playing
      _streakDays = 1;
    } else {
      final lastPlayDay = DateTime(
        _lastPlayDate!.year,
        _lastPlayDate!.month,
        _lastPlayDate!.day,
      );

      final difference = today.difference(lastPlayDay).inDays;

      if (difference == 0) {
        // Already played today, no change
        return;
      } else if (difference == 1) {
        // Consecutive day - increase streak
        _streakDays++;
      } else {
        // Streak broken - reset to 1
        _streakDays = 1;
      }
    }

    // Save streak and today's date
    _prefs.setInt(_streakKey, _streakDays);
    _prefs.setString(_lastPlayDateKey, today.toIso8601String());
    notifyListeners();
  }

  bool isStreakMaintainedToday() {
    if (_lastPlayDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastPlayDay = DateTime(
      _lastPlayDate!.year,
      _lastPlayDate!.month,
      _lastPlayDate!.day,
    );

    return today.isAtSameMomentAs(lastPlayDay);
  }

  void resetStreak() {
    _streakDays = 0;
    _prefs.setInt(_streakKey, _streakDays);
    notifyListeners();
  }
}
