import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakController with ChangeNotifier {
  static StreakController? _instance;
  late SharedPreferences _prefs;

  String get _streakKey => 'daily_streak';
  String get _lastPlayDateKey => 'last_play_date';

  int _streakDays = 0;
  DateTime? _lastPlayDate;

  // Private constructor
  StreakController._();

  // Factory constructor - always returns the same instance
  factory StreakController.getInstance() {
    return _instance ??= StreakController._();
  }

  // Initialize (call once at app startup)
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
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

  Future<void> updateStreak() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastPlayDate == null) {
      _streakDays = 1;
    } else {
      final lastPlayDay = DateTime(
        _lastPlayDate!.year,
        _lastPlayDate!.month,
        _lastPlayDate!.day,
      );

      final difference = today.difference(lastPlayDay).inDays;

      if (difference == 0) {
        return;
      } else if (difference == 1) {
        _streakDays++;
      } else {
        _streakDays = 1;
      }
    }

    await _prefs.setInt(_streakKey, _streakDays);
    await _prefs.setString(_lastPlayDateKey, today.toIso8601String());
    _lastPlayDate = today;
    notifyListeners();
  }

  Future<void> resetStreak() async {
    _streakDays = 0;
    _lastPlayDate = null;
    await _prefs.remove(_streakKey);
    await _prefs.remove(_lastPlayDateKey);
    notifyListeners();
  }

  bool get hasPlayedToday {
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
}
