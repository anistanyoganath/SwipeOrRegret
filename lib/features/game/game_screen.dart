import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeorregret/app/app_routes.dart';
import 'package:swipeorregret/app/app_theme.dart';
import 'package:swipeorregret/app/game_constants.dart';
import 'package:swipeorregret/core/provider/local_provider.dart';
import 'package:swipeorregret/core/widgets/swipe_card.dart';
import 'package:swipeorregret/features/game/game_controller.dart';
import 'package:swipeorregret/features/game/models/game_state.dart';
import 'package:swipeorregret/core/services/audio_service.dart';
import 'package:swipeorregret/core/services/vibration_service.dart';
import 'package:swipeorregret/core/widgets/animated_stat_bar.dart';
import 'package:swipeorregret/l10n/app_localizations.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController _controller;
  int _timeLeft = GameConstants.decisionTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = GameController();
    _loadGame();
  }

  Future<void> _loadGame() async {
    final localeCode = context.read<LocaleProvider>().locale.languageCode;
    await _controller.loadGame(localeCode);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = GameConstants.decisionTime;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        // Time's up - random decision
        _timer?.cancel();
        _controller.makeDecision(false);
        _startTimer();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _resumeTimer() {
    if (!_controller.isGameOver) {
      _startTimer();
    }
  }

  void _onSwipeLeft() {
    _timer?.cancel();

    // Play effects
    AudioService().playSwipeSound();
    VibrationService().vibrateSwipe();

    // Animate card
    _animateCardSwipe(false);

    // Delay for animation then make decision
    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.makeDecision(false);
      _startTimer();
    });
  }

  void _onSwipeRight() {
    _timer?.cancel();

    // Play effects
    AudioService().playSwipeSound();
    VibrationService().vibrateSwipe();

    // Animate card
    _animateCardSwipe(true);

    // Delay for animation then make decision
    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.makeDecision(true);
      _startTimer();
    });
  }

  // Add card animation
  void _animateCardSwipe(bool isRight) {
    // You can implement card swipe animation here
    // Using Transform.translate or other animation methods
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getGameOverReason(GameState gameState) {
    if (gameState.money <= 0) return 'You went bankrupt!';
    if (gameState.relationship <= 0) return 'You died alone!';
    if (gameState.stress >= 100) return 'Stress overwhelmed you!';
    if (gameState.reputation <= 0) return 'Your reputation was destroyed!';
    return 'You regret everything!';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);

    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<GameController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Scaffold(
              backgroundColor: colorScheme.background,
              body: Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              ),
            );
          }

          if (controller.isGameOver) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final gameState = controller.gameState;
              final reason = _getGameOverReason(gameState);

              Navigator.pushReplacementNamed(
                context,
                AppRoutes.gameOver,
                arguments: {
                  'finalScore': gameState.score,
                  'reason': reason,
                  'finalStats': {
                    'money': gameState.money,
                    'relationship': gameState.relationship,
                    'stress': gameState.stress,
                    'reputation': gameState.reputation,
                  },
                },
              );
            });
          }

          return Scaffold(
            backgroundColor: colorScheme.background,
            appBar: AppBar(
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurface,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              title: Text(
                localizations?.appTitle ?? 'Swipe or Regret',
                style: AppTheme.getTextStyle(
                  locale: locale,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings, color: colorScheme.onSurface),
                  onPressed: () async {
                    // Pause the timer
                    _pauseTimer();

                    // Navigate to settings
                    await Navigator.pushNamed(context, AppRoutes.settings);

                    // Resume timer only if we returned normally
                    if (mounted) {
                      _resumeTimer();
                    }
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                // Stats Panel
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.emoji_events, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            'Score: ${controller.gameState.score}',
                            style: AppTheme.getTextStyle(
                              locale: locale,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.calendar_today,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${localizations?.day ?? "Day "}${controller.gameState.streakDays}',
                            style: AppTheme.getTextStyle(
                              locale: locale,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: [
                          AnimatedStatBar(
                            label: localizations?.money ?? 'Money',
                            value: controller.gameState.money,
                            color: Colors.green,
                            icon: Icons.attach_money,
                            locale: locale,
                          ),
                          AnimatedStatBar(
                            label:
                                localizations?.relationship ?? 'Relationship',
                            value: controller.gameState.relationship,
                            color: Colors.pink,
                            icon: Icons.favorite,
                            locale: locale,
                          ),
                          AnimatedStatBar(
                            label: localizations?.stress ?? 'Stress',
                            value: controller.gameState.stress,
                            color: Colors.orange,
                            icon: Icons.psychology,
                            locale: locale,
                          ),
                          AnimatedStatBar(
                            label: localizations?.reputation ?? 'Reputation',
                            value: controller.gameState.reputation,
                            color: Colors.blue,
                            icon: Icons.star,
                            locale: locale,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Outcome Message
                if (controller.lastDecisionOutcome != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        controller.lastDecisionOutcome!,
                        style: AppTheme.getTextStyle(
                          locale: locale,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Game Card
                Expanded(
                  child: SwipeCard(
                    text: controller.currentScenario.text,
                    leftChoice: controller.currentScenario.leftText,
                    rightChoice: controller.currentScenario.rightText,
                    onSwipeLeft: _onSwipeLeft,
                    onSwipeRight: _onSwipeRight,
                    timeLeft: _timeLeft,
                  ),
                ),

                // Swipe Hint
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    localizations?.swipeToDecide ??
                        'Swipe left or right to decide',
                    style: AppTheme.getTextStyle(
                      locale: locale,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
