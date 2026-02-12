import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends ChangeNotifier {
  int _highScore = 0;
  int _totalGames = 0;
  bool _hasSavedGame = false;

  int get highScore => _highScore;
  int get totalGames => _totalGames;
  bool get hasSavedGame => _hasSavedGame;
  Function get loadStats => _loadStats;

  HomeController() {
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await gameServiceSignIn();

      _highScore = prefs.getInt('high_score') ?? 0;
      _totalGames = prefs.getInt('total_games') ?? 0;
      _hasSavedGame = prefs.getBool('has_saved_game') ?? false;

      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> refreshStats() async {
    await _loadStats();
  }

  Future<void> gameServiceSignIn() async {
    try {
      await GamesServices.signIn();
    } catch (e) {
      debugPrint('Sign-in failed: $e');
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

  Future<void> setHasSavedGame(bool value) async {
    _hasSavedGame = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_saved_game', value);
    notifyListeners();
  }
}
