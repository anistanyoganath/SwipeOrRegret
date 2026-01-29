import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeorregret/app/game_constants.dart';
import 'package:swipeorregret/data/repository/scenario_repository.dart';
import 'package:swipeorregret/features/game/models/game_state.dart';
import 'package:swipeorregret/features/game/models/scenario.dart';

class GameController extends ChangeNotifier {
  GameState _gameState = GameState();
  List<Scenario> _scenarios = [];
  int _currentScenarioIndex = 0;
  bool _isLoading = true;
  String? _lastDecisionOutcome;

  GameState get gameState => _gameState;
  Scenario get currentScenario => _scenarios[_currentScenarioIndex];
  bool get isLoading => _isLoading;
  bool get isGameOver => _gameState.isGameOver;
  String? get lastDecisionOutcome => _lastDecisionOutcome;

  final ScenarioRepository _scenarioRepository = ScenarioRepository();

  Future<void> loadGame() async {
    _isLoading = true;
    notifyListeners();

    try {
      _scenarios = await _scenarioRepository.getScenarios();

      // Try to load saved game state
      await _loadSavedGameState();

      // Check for daily streak
      await _checkDailyStreak();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _loadSavedGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if we have a saved game
      bool hasSavedGame = prefs.getBool('has_saved_game') ?? false;
      bool isGameOver = prefs.getBool('is_game_over') ?? false;

      if (hasSavedGame && !isGameOver) {
        // Load saved stats
        _gameState = GameState(
          money: prefs.getInt('money') ?? GameConstants.initialMoney,
          relationship:
              prefs.getInt('relationship') ?? GameConstants.initialRelationship,
          stress: prefs.getInt('stress') ?? GameConstants.initialStress,
          reputation:
              prefs.getInt('reputation') ?? GameConstants.initialReputation,
          score: prefs.getInt('score') ?? 0,
          currentScenarioIndex: prefs.getInt('current_scenario_index') ?? 0,
          streakDays: prefs.getInt('streak_days') ?? 1,
        );

        // Load last played date
        String? lastPlayedString = prefs.getString('last_played');
        if (lastPlayedString != null) {
          _gameState.lastPlayed = DateTime.parse(lastPlayedString);
        }
      } else {
        // Start new game
        _gameState = GameState();
        await _saveGameState();
      }
    } catch (e) {
      print('Error loading saved game: $e');
      _gameState = GameState();
    }
  }

  Future<void> _saveGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('money', _gameState.money);
      await prefs.setInt('relationship', _gameState.relationship);
      await prefs.setInt('stress', _gameState.stress);
      await prefs.setInt('reputation', _gameState.reputation);
      await prefs.setInt('score', _gameState.score);
      await prefs.setInt('current_scenario_index', _currentScenarioIndex);
      await prefs.setInt('streak_days', _gameState.streakDays);

      if (_gameState.lastPlayed != null) {
        await prefs.setString(
          'last_played',
          _gameState.lastPlayed!.toIso8601String(),
        );
      }

      // Mark that we have a saved game
      await prefs.setBool('has_saved_game', true);
      await prefs.setBool('is_game_over', false);
    } catch (e) {
      print('Error saving game state: $e');
    }
  }

  Future<void> _checkDailyStreak() async {
    final now = DateTime.now();
    final lastPlayed = _gameState.lastPlayed;

    if (lastPlayed == null) {
      _gameState.streakDays = 1;
    } else {
      final difference = now.difference(lastPlayed).inDays;

      if (difference == 1) {
        _gameState.streakDays++;
        _applyStreakBonus();
      } else if (difference > 1) {
        _gameState.streakDays = 1;
      }
    }

    _gameState.lastPlayed = now;
  }

  void _applyStreakBonus() {
    // Add bonus to all stats for streak
    _gameState.money = (_gameState.money + GameConstants.streakReward).clamp(
      0,
      GameConstants.maxStats,
    );
    _gameState.relationship =
        (_gameState.relationship + GameConstants.streakReward).clamp(
          0,
          GameConstants.maxStats,
        );
    _gameState.reputation = (_gameState.reputation + GameConstants.streakReward)
        .clamp(0, GameConstants.maxStats);
    _gameState.stress = (_gameState.stress - GameConstants.streakReward).clamp(
      0,
      GameConstants.maxStats,
    );
  }

  void makeDecision(bool isRightSwipe) {
    final scenario = currentScenario;
    final consequences = isRightSwipe
        ? scenario.rightConsequences
        : scenario.leftConsequences;

    // Apply consequences
    _gameState.updateStats(consequences);

    // Save game state after each decision
    _saveGameState();

    // Track scenarios played
    _trackScenarioPlayed();

    // Create outcome message
    _createOutcomeMessage(consequences);

    // Move to next scenario or end game
    if (!_gameState.isGameOver) {
      _currentScenarioIndex = (_currentScenarioIndex + 1) % _scenarios.length;
    } else {
      // Mark game as over
      _markGameAsOver();
    }

    notifyListeners();
  }

  Future<void> _markGameAsOver() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_game_over', true);
  }

  Future<void> _trackScenarioPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    int scenariosPlayed = prefs.getInt('scenarios_played') ?? 0;
    scenariosPlayed++;
    await prefs.setInt('scenarios_played', scenariosPlayed);
  }

  void _createOutcomeMessage(Map<String, int> consequences) {
    final messages = <String>[];

    if (consequences['money'] != null) {
      final change = consequences['money']!;
      messages.add('${change > 0 ? '+' : ''}$change 💰');
    }

    if (consequences['relationship'] != null) {
      final change = consequences['relationship']!;
      messages.add('${change > 0 ? '+' : ''}$change ❤️');
    }

    if (consequences['stress'] != null) {
      final change = consequences['stress']!;
      messages.add('${change > 0 ? '+' : ''}$change 🧠');
    }

    if (consequences['reputation'] != null) {
      final change = consequences['reputation']!;
      messages.add('${change > 0 ? '+' : ''}$change ⭐');
    }

    _lastDecisionOutcome = messages.join('  ');
  }

  void resetGame() {
    _gameState = GameState();
    _currentScenarioIndex = 0;
    _lastDecisionOutcome = null;
    notifyListeners();
  }
}
