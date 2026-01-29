import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends ChangeNotifier {
  int _highScore = 0;
  int _totalGames = 0;
  int _streakDays = 1;
  bool _hasSavedGame = false;

  int get highScore => _highScore;
  int get totalGames => _totalGames;
  int get streakDays => _streakDays;
  bool get hasSavedGame => _hasSavedGame;

  HomeController() {
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _highScore = prefs.getInt('high_score') ?? 0;
      _totalGames = prefs.getInt('total_games') ?? 0;
      _streakDays = prefs.getInt('streak_days') ?? 1;
      _hasSavedGame = prefs.getBool('has_saved_game') ?? false;

      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateHighScore(int newScore) async {
    if (newScore > _highScore) {
      _highScore = newScore;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('high_score', _highScore);
      notifyListeners();
    }
  }

  Future<void> incrementTotalGames() async {
    _totalGames++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_games', _totalGames);
    notifyListeners();
  }

  Future<void> updateStreak(int days) async {
    _streakDays = days;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak_days', _streakDays);
    notifyListeners();
  }

  Future<void> setHasSavedGame(bool value) async {
    _hasSavedGame = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_saved_game', value);
    notifyListeners();
  }
}
