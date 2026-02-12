import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeorregret/app/app_colors.dart';
import 'package:swipeorregret/app/app_routes.dart';
import 'package:swipeorregret/core/utils/ads/banner_ad.dart';
import 'package:swipeorregret/core/widgets/primary_button.dart';
import 'package:swipeorregret/features/game_over/game_over_controller.dart';
import 'package:swipeorregret/l10n/app_localizations.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final localizations = AppLocalizations.of(context);

    void showReviveSuccessDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            localizations?.revived ?? 'Revived!',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            localizations?.reviveMessage ??
                'You have been revived with partial stats restored.\nContinue your journey...',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          backgroundColor: colorScheme.surface,
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
              child: Text(
                localizations?.continueButton ?? 'CONTINUE',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Fixed header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (route) => false,
                        );
                      },
                      icon: Icon(Icons.home, color: colorScheme.onSurface),
                    ),
                    const Spacer(),
                    Text(
                      localizations?.gameOver ?? 'GAME OVER',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // For symmetry
                  ],
                ),
              ),

              // Scrollable content with buttons at the end
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    // Game over icon
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 32),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.sentiment_dissatisfied,
                          size: 60,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),

                    // Game Over Reason
                    Consumer<GameOverController>(
                      builder: (context, controller, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          margin: const EdgeInsets.only(bottom: 32),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                localizations?.youRegretEverything ??
                                    'You Regret Everything',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.reason ??
                                    (localizations?.ranOutOfResources ??
                                        'You ran out of resources!'),
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.8),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Final Score
                    Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            localizations?.finalScore ?? 'FINAL SCORE',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$finalScore',
                            style: textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onPrimary,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Consumer<GameOverController>(
                            builder: (context, controller, child) {
                              return Text(
                                localizations?.daySurvived(
                                      controller.daysSurvived,
                                    ) ??
                                    'Day ${controller.daysSurvived}',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimary.withOpacity(0.8),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Stats Grid
                    Consumer<GameOverController>(
                      builder: (context, controller, child) {
                        return Container(
                          height: 180,
                          margin: const EdgeInsets.only(bottom: 32),
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            children: [
                              _StatItem(
                                label: localizations?.moneyStat ?? 'Money',
                                value: controller.finalStats['money'] ?? 0,
                                color: AppColors.money,
                                icon: Icons.attach_money,
                              ),
                              _StatItem(
                                label:
                                    localizations?.relationshipStat ??
                                    'Relationship',
                                value:
                                    controller.finalStats['relationship'] ?? 0,
                                color: AppColors.relationship,
                                icon: Icons.favorite,
                              ),
                              _StatItem(
                                label: localizations?.stressStat ?? 'Stress',
                                value: controller.finalStats['stress'] ?? 0,
                                color: AppColors.stress,
                                icon: Icons.psychology,
                              ),
                              _StatItem(
                                label:
                                    localizations?.reputationStat ??
                                    'Reputation',
                                value: controller.finalStats['reputation'] ?? 0,
                                color: AppColors.reputation,
                                icon: Icons.star,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Action Buttons Section
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      child: Consumer<GameOverController>(
                        builder: (context, controller, child) {
                          return Column(
                            children: [
                              // Play Again Button
                              PrimaryButton(
                                text:
                                    localizations?.playAgainButton ??
                                    'PLAY AGAIN',
                                onPressed: () {
                                  controller.playAgain();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.game,
                                    (route) => false,
                                  );
                                },
                                backgroundColor: colorScheme.primary,
                                textColor: colorScheme.onPrimary,
                              ),
                              const SizedBox(height: 16),

                              // Share and Revive Row
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        controller.shareResult();
                                      },
                                      icon: Icon(
                                        Icons.share,
                                        color: colorScheme.primary,
                                      ),
                                      label: Text(
                                        localizations?.shareButton ?? 'SHARE',
                                        style: textTheme.labelLarge?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        side: BorderSide(
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        controller.watchAdForRevive(
                                          context,
                                          () {
                                            showReviveSuccessDialog(context);
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.replay,
                                        color: colorScheme.primary,
                                      ),
                                      label: Text(
                                        localizations?.reviveButton ?? 'REVIVE',
                                        style: textTheme.labelLarge?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        side: BorderSide(
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Back to Home Button
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.home,
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  localizations?.backToHomeButton ??
                                      'BACK TO HOME',
                                  style: textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.7,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // Add some extra padding at the bottom for visual comfort
                    const SizedBox(height: 20),
                    BannerAdvert(),
                  ],
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$value',
                  style: theme.textTheme.titleMedium?.copyWith(
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
