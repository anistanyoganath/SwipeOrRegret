import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeorregret/core/services/audio_service.dart';
import 'package:swipeorregret/core/utils/ads/ads_manager.dart';

class GameOverController extends ChangeNotifier {
  int finalScore;
  final String? reason;
  final Map<String, int> finalStats;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  int get daysSurvived => (finalScore / 100).ceil();

  // Store original game state for revival
  Map<String, dynamic>? _originalGameState;

  GameOverController({
    required this.finalScore,
    this.reason,
    this.finalStats = const {},
  }) {
    _saveHighScore();
    _incrementGamesPlayed();
    _saveGameStateForRevival();
    AudioService().playGameOverSound();
  }

  Future<void> _saveGameStateForRevival() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _originalGameState = {
        'score': finalScore,
        'money': finalStats['money'] ?? 0,
        'relationship': finalStats['relationship'] ?? 0,
        'stress': finalStats['stress'] ?? 0,
        'reputation': finalStats['reputation'] ?? 0,
        'scenarioIndex': prefs.getInt('current_scenario_index') ?? 0,
        'scenariosPlayed': prefs.getInt('scenarios_played') ?? 0,
        'revivesUsed': prefs.getInt('revives_used') ?? 0,
      };
    } catch (e) {
      print('Error saving game state for revival: $e');
    }
  }

  Future<void> watchAdForRevive(
    BuildContext context,
    Function onReviveSuccess,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await AdsManager().showRewardedAd(
        onRewarded: () async {
          // Apply revive logic
          await _applyRevive();

          // Track revive usage
          await _trackReviveUsage();

          // Call the success callback
          onReviveSuccess();
        },
      );
    } catch (e) {
      _showError(context, 'Failed to load ad. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _applyRevive() async {
    if (_originalGameState == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Restore stats with a penalty or partial restoration
      int revivePenalty = 30; // Percentage penalty

      // Calculate revived stats (e.g., restore to 50% of original)
      int revivedMoney =
          ((_originalGameState!['money'] ?? 0) * (100 - revivePenalty) / 100)
              .ceil();
      int revivedRelationship =
          ((_originalGameState!['relationship'] ?? 0) *
                  (100 - revivePenalty) /
                  100)
              .ceil();
      int revivedReputation =
          ((_originalGameState!['reputation'] ?? 0) *
                  (100 - revivePenalty) /
                  100)
              .ceil();
      int revivedStress = ((_originalGameState!['stress'] ?? 0) * (50) / 100)
          .ceil(); // Reduce stress by 50%

      // Apply minimum values to ensure game is playable
      revivedMoney = revivedMoney.clamp(20, 100);
      revivedRelationship = revivedRelationship.clamp(20, 100);
      revivedReputation = revivedReputation.clamp(20, 100);
      revivedStress = revivedStress.clamp(0, 80);

      // Save revived state
      await prefs.setInt('money', revivedMoney);
      await prefs.setInt('relationship', revivedRelationship);
      await prefs.setInt('stress', revivedStress);
      await prefs.setInt('reputation', revivedReputation);

      // Keep the same score or apply penalty
      int scorePenalty = 100; // Deduct 100 points for revive
      int revivedScore = (_originalGameState!['score'] ?? 0) - scorePenalty;
      if (revivedScore < 0) revivedScore = 0;

      await prefs.setInt('score', revivedScore);

      // Mark game as active
      await prefs.setBool('has_saved_game', true);
      await prefs.setBool('is_game_over', false);

      // Add revive used marker
      await prefs.setBool('revived_this_session', true);

      print(
        'Revive applied: Money=$revivedMoney, Relationship=$revivedRelationship, '
        'Stress=$revivedStress, Reputation=$revivedReputation, Score=$revivedScore',
      );
    } catch (e) {
      print('Error applying revive: $e');
    }
  }

  Future<void> _trackReviveUsage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int revivesUsed = prefs.getInt('revives_used') ?? 0;
      revivesUsed++;
      await prefs.setInt('revives_used', revivesUsed);

      // You can also track in analytics
      // AnalyticsService.logEvent('revive_used', {'count': revivesUsed});
    } catch (e) {
      print('Error tracking revive usage: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentHighScore = prefs.getInt('high_score') ?? 0;

      if (finalScore > currentHighScore) {
        await prefs.setInt('high_score', finalScore);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _incrementGamesPlayed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final totalGames = (prefs.getInt('total_games') ?? 0) + 1;
      await prefs.setInt('total_games', totalGames);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> shareResult() async {
    final text =
        'I survived $daysSurvived days in Swipe or Regret '
        'with a score of $finalScore! '
        'Can you beat my score? '
        '\n\n#SwipeOrRegret';

    await SharePlus.instance.share(ShareParams(text: text));
  }

  void playAgain() {
    // Clear any saved game state
    _clearSavedGame();
  }

  Future<void> _clearSavedGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('game_state');
      await prefs.setBool('has_saved_game', false);
    } catch (e) {
      // Handle error
    }
  }
}
