import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeorregret/app/app_colors.dart';
import 'package:swipeorregret/app/app_routes.dart';
import 'package:swipeorregret/core/widgets/primary_button.dart';
import 'package:swipeorregret/features/game_over/game_over_controller.dart';

class GameOverScreen extends StatelessWidget {
  final int finalScore;
  final String? reason;
  final Map<String, int> finalStats;

  const GameOverScreen({
    super.key,
    required this.finalScore,
    this.reason,
    this.finalStats = const {},
  });

  @override
  Widget build(BuildContext context) {
    void showReviveSuccessDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Revived!'),
          content: const Text(
            'You have been revived with partial stats restored.\n'
            'Continue your journey...',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.game,
                  (route) => false,
                );
              },
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => GameOverController(
        finalScore: finalScore,
        reason: reason,
        finalStats: finalStats,
      ),
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: SafeArea(
          child: Column(
            children: [
              // Top fixed content (Header and Icon)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.home,
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.home, color: Colors.white),
                        ),
                        const Spacer(),
                        const Text(
                          'GAME OVER',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.sentiment_dissatisfied,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable middle content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      // Game Over Reason
                      Consumer<GameOverController>(
                        builder: (context, controller, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'You Regret Everything',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  controller.reason ??
                                      'You ran out of resources!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Final Score
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple, Colors.deepPurple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'FINAL SCORE',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$finalScore',
                              style: const TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Consumer<GameOverController>(
                              builder: (context, controller, child) {
                                return Text(
                                  'Day ${controller.daysSurvived}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Stats Grid
                      Consumer<GameOverController>(
                        builder: (context, controller, child) {
                          return SizedBox(
                            height: 180,
                            child: GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              children: [
                                _StatItem(
                                  label: 'Money',
                                  value: controller.finalStats['money'] ?? 0,
                                  color: AppColors.money,
                                  icon: Icons.attach_money,
                                ),
                                _StatItem(
                                  label: 'Relationship',
                                  value:
                                      controller.finalStats['relationship'] ??
                                      0,
                                  color: AppColors.relationship,
                                  icon: Icons.favorite,
                                ),
                                _StatItem(
                                  label: 'Stress',
                                  value: controller.finalStats['stress'] ?? 0,
                                  color: AppColors.stress,
                                  icon: Icons.psychology,
                                ),
                                _StatItem(
                                  label: 'Reputation',
                                  value:
                                      controller.finalStats['reputation'] ?? 0,
                                  color: AppColors.reputation,
                                  icon: Icons.star,
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Bottom fixed buttons
              Container(
                padding: const EdgeInsets.all(24),
                color: Colors.transparent,
                child: Consumer<GameOverController>(
                  builder: (context, controller, child) {
                    return Column(
                      children: [
                        PrimaryButton(
                          text: 'PLAY AGAIN',
                          onPressed: () {
                            controller.playAgain();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.game,
                              (route) => false,
                            );
                          },
                          backgroundColor: Colors.white,
                          textColor: Colors.deepPurple,
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  controller.shareResult();
                                },
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'SHARE',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: const BorderSide(color: Colors.white),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  controller.watchAdForRevive(context, () {
                                    showReviveSuccessDialog(context);
                                  });
                                },
                                icon: const Icon(
                                  Icons.replay,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'REVIVE',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: const BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.home,
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'BACK TO HOME',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
