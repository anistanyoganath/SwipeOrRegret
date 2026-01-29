import 'package:flutter/material.dart';
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

    // Create outcome message
    _createOutcomeMessage(consequences);

    // Move to next scenario or end game
    if (!_gameState.isGameOver) {
      _currentScenarioIndex = (_currentScenarioIndex + 1) % _scenarios.length;
    }

    notifyListeners();
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
