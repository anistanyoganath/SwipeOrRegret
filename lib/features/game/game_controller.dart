import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeorregret/app/game_constants.dart';
import 'package:swipeorregret/core/utils/streak_benifits.dart';
import 'package:swipeorregret/data/repository/scenario_repository.dart';
import 'package:swipeorregret/features/game/models/game_state.dart';
import 'package:swipeorregret/features/game/models/scenario.dart';
import 'package:swipeorregret/features/home/streak_controller.dart';

class GameController extends ChangeNotifier {
  GameState _gameState = GameState();
  List<Scenario> _scenarios = [];
  int _currentScenarioIndex = 0;
  bool _isLoading = true;
  String? _lastDecisionOutcome;
  String? _streakBonusMessage;

  GameState get gameState => _gameState;
  List<Scenario> get scenarios => _scenarios;
  Scenario get currentScenario => _scenarios[_currentScenarioIndex];
  bool get isLoading => _isLoading;
  bool get isGameOver => _gameState.isGameOver;
  String? get lastDecisionOutcome => _lastDecisionOutcome;
  String? get streakBonusMessage => _streakBonusMessage; // Add getter

  final ScenarioRepository _scenarioRepository = ScenarioRepository();
  late StreakController streakController;

  Future<void> loadGame(String languageCode) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Initialize streak controller with SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      streakController = StreakController(prefs);

      // Load scenarios
      _scenarios = await _scenarioRepository.getScenarios(
        languageCode: languageCode,
      );

      // Try to load saved game state
      await _loadSavedGameState();

      // Check for daily streak and apply bonuses
      await _checkAndApplyStreakBonus();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading game: $e');
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

        _currentScenarioIndex = _gameState.currentScenarioIndex;

        // Load last played date
        String? lastPlayedString = prefs.getString('last_played');
        if (lastPlayedString != null) {
          _gameState.lastPlayed = DateTime.parse(lastPlayedString);
        }
      } else {
        // Start new game with base stats
        _gameState = GameState();
        await _saveGameState();
      }
    } catch (e) {
      print('Error loading saved game: $e');
      _gameState = GameState();
    }
  }

  Future<void> _checkAndApplyStreakBonus() async {
    // Update streak based on last play date
    streakController.updateStreak();

    // Get streak bonus if streak changed
    if (streakController.streakDays > (_gameState.streakDays)) {
      // This is a new streak day, apply bonuses
      final streakBonus = StreakRewardSystem.getStreakBonus(
        streakController.streakDays,
      );

      // Apply bonuses to current stats (or initial stats for new game)
      if (!_gameState.hasSavedGame) {
        // New game, add to initial stats
        _gameState = GameState(
          money: GameConstants.initialMoney + streakBonus['money']!,
          relationship: GameConstants.initialRelationship,
          stress: GameConstants.initialStress + streakBonus['stress']!,
          reputation:
              GameConstants.initialReputation + streakBonus['reputation']!,
          score: 0,
          currentScenarioIndex: 0,
          streakDays: streakController.streakDays,
        );
      } else {
        // Existing game, add to current stats
        _gameState.money = (_gameState.money + streakBonus['money']!).clamp(
          0,
          GameConstants.maxMoney,
        );
        _gameState.stress = (_gameState.stress + streakBonus['stress']!).clamp(
          0,
          GameConstants.maxStress,
        );
        _gameState.reputation =
            (_gameState.reputation + streakBonus['reputation']!).clamp(
              0,
              GameConstants.maxReputation,
            );
        _gameState.streakDays = streakController.streakDays;
      }

      // Get streak message if any
      final message = StreakRewardSystem.getStreakMessage(
        streakController.streakDays,
      );
      if (message != null) {
        _streakBonusMessage = message;

        // Clear the message after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          _streakBonusMessage = null;
          notifyListeners();
        });
      }

      // Save updated game state
      await _saveGameState();
    }

    // Update game state's streak days
    _gameState.streakDays = streakController.streakDays;
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

      // Save streak to both game state and streak controller
      await prefs.setInt('streak_days', streakController.streakDays);
      _gameState.streakDays = streakController.streakDays;

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

  void makeDecision(bool isRightSwipe) {
    final scenario = currentScenario;
    final consequences = isRightSwipe
        ? scenario.rightConsequences
        : scenario.leftConsequences;

    // Apply consequences
    _gameState.updateStats(consequences);

    // Update last played date
    _gameState.lastPlayed = DateTime.now();

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
    _streakBonusMessage = null;
    notifyListeners();
  }

  // Method to show streak message in UI (call this from your UI)
  void showStreakBonusMessage(BuildContext context) {
    if (_streakBonusMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_streakBonusMessage!),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Add this to your GameState model
  bool get hasSavedGame {
    // Add this property to your GameState model
    return _gameState.money != GameConstants.initialMoney ||
        _gameState.score > 0;
  }
}
