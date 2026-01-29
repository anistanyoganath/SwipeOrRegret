import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeorregret/app/game_constants.dart';
import 'package:swipeorregret/core/widgets/stat_bar.dart';
import 'package:swipeorregret/core/widgets/swipe_card.dart';
import 'package:swipeorregret/features/game/game_controller.dart';

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
    await _controller.loadGame();
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

  void _onSwipeLeft() {
    _timer?.cancel();
    _controller.makeDecision(false);
    _startTimer();
  }

  void _onSwipeRight() {
    _timer?.cancel();
    _controller.makeDecision(true);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<GameController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (controller.isGameOver) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/game-over');
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Swipe or Regret'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
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
                          const Icon(Icons.emoji_events, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            'Score: ${controller.gameState.score}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.calendar_today, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Day ${controller.gameState.streakDays}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                          StatBar(
                            label: 'Money',
                            value: controller.gameState.money,
                            color: Colors.green,
                            icon: Icons.attach_money,
                          ),
                          StatBar(
                            label: 'Relationship',
                            value: controller.gameState.relationship,
                            color: Colors.pink,
                            icon: Icons.favorite,
                          ),
                          StatBar(
                            label: 'Stress',
                            value: controller.gameState.stress,
                            color: Colors.orange,
                            icon: Icons.psychology,
                          ),
                          StatBar(
                            label: 'Reputation',
                            value: controller.gameState.reputation,
                            color: Colors.blue,
                            icon: Icons.star,
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
                        color: Colors.deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.deepPurple.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        controller.lastDecisionOutcome!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
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
                    'Swipe left or right to decide',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
