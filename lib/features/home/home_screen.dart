import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:provider/provider.dart';
import 'package:swipeorregret/app/app_routes.dart';
import 'package:swipeorregret/app/app_theme.dart';
import 'package:swipeorregret/app/game_constants.dart';
import 'package:swipeorregret/core/widgets/primary_button.dart';
import 'package:swipeorregret/features/home/hero_illustration.dart';
import 'package:swipeorregret/features/home/home_controller.dart';
import 'package:swipeorregret/features/home/streak_controller.dart';
import 'package:swipeorregret/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: Consumer<HomeController>(
        builder: (context, controller, child) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with streak
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations?.appTitle ?? 'SWIPE OR REGRET',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localizations?.tagline ?? 'One choice. No undo.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Daily streak - using Consumer
                        Consumer<StreakController>(
                          builder: (context, streakController, child) {
                            final nextMilestone = _getNextMilestone(
                              streakController.streakDays,
                            );

                            return Column(
                              children: [
                                // Streak indicator
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _getStreakGradient(
                                        streakController.streakDays,
                                        theme,
                                      ),
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.primaryColor.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        streakController.streakDays >= 7
                                            ? Icons.local_fire_department
                                            : streakController.streakDays > 0
                                            ? Icons.emoji_events
                                            : Icons.star_border,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        streakController.streakDays > 0
                                            ? (localizations?.dayCount(
                                                    streakController.streakDays,
                                                  ) ??
                                                  'Day ${streakController.streakDays}')
                                            : localizations?.startStreak ??
                                                  'Start Streak',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (streakController.streakDays > 0) ...[
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => _showStreakInfo(
                                            context,
                                            streakController.streakDays,
                                          ),
                                          child: const Icon(
                                            Icons.info_outline,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                // Streak benefits preview
                                if (streakController.streakDays > 0 &&
                                    nextMilestone != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      localizations?.playMoreDays(
                                            nextMilestone -
                                                streakController.streakDays,
                                            nextMilestone,
                                          ) ??
                                          'Play ${nextMilestone - streakController.streakDays} more days for bonus!',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Hero illustration
                    Expanded(
                      child: Center(
                        child: LiquidSwipeAnimation(isDarkMode: isDarkMode),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Play button
                    PrimaryButton(
                      text: localizations?.play ?? 'START GAME',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.game);
                      },
                    ),

                    const SizedBox(height: 16),

                    if (controller.hasSavedGame)
                      PrimaryButton(
                        text: localizations?.continueGame ?? 'CONTINUE',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.game);
                        },
                        variant: ButtonVariant.outlined,
                      ),

                    if (controller.hasSavedGame) const SizedBox(height: 16),

                    // Stats and buttons row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.emoji_events,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${controller.highScore}',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  localizations?.highScore ?? 'High Score',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.timelapse,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${controller.totalGames}',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  localizations?.gamesPlayed ?? 'Games Played',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Bottom buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                AppRoutes.settings,
                              );
                              controller.loadStats();
                            },
                            icon: Icon(
                              Icons.settings,
                              color: theme.colorScheme.primary,
                            ),
                            label: Text(
                              localizations?.settings ?? 'Settings',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                              side: BorderSide(
                                color: theme.colorScheme.primary,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await showLeaderboard();
                            },
                            icon: Icon(
                              Icons.leaderboard,
                              color: theme.colorScheme.primary,
                            ),
                            label: Text(
                              localizations?.rank ?? 'Rank',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                              side: BorderSide(
                                color: theme.colorScheme.primary,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> showLeaderboard() async {
    await GamesServices.showLeaderboards(
      iOSLeaderboardID: GameConstants.iOSLeaderboardID,
      androidLeaderboardID: GameConstants.androidLeaderboardID,
    );
  }

  List<Color> _getStreakGradient(int streakDays, ThemeData theme) {
    if (streakDays >= 30) {
      return [theme.primaryColor, Colors.amber];
    } else if (streakDays >= 14) {
      return [Colors.purple, theme.primaryColor];
    } else if (streakDays >= 7) {
      return [theme.primaryColor, Colors.purple];
    } else {
      return [theme.primaryColor, Colors.blue];
    }
  }

  int? _getNextMilestone(int currentStreak) {
    final milestones = [3, 7, 14, 30];
    try {
      return milestones.firstWhere((milestone) => milestone > currentStreak);
    } catch (e) {
      return null;
    }
  }

  void _showStreakInfo(BuildContext context, int currentStreak) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);

    final rewards = {
      3: localizations?.reward3Days ?? '+10 starting money 💰',
      7: localizations?.reward7Days ?? '+20 starting money 💰 & -5 stress 🧠',
      14:
          localizations?.reward14Days ??
          '+30 starting money 💰 & +5 reputation ⭐',
      30:
          localizations?.reward30Days ??
          '+50 starting money 💰 & +10 reputation ⭐ & -10 stress 🧠',
    };

    // Find achieved and upcoming rewards
    final achievedRewards = <MapEntry<int, String>>[];
    final upcomingRewards = <MapEntry<int, String>>[];

    rewards.forEach((days, reward) {
      if (currentStreak >= days) {
        achievedRewards.add(MapEntry(days, reward));
      } else {
        upcomingRewards.add(MapEntry(days, reward));
      }
    });

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag indicator
                Center(
                  child: Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  localizations?.dailyStreakRewards ?? 'Daily Streak Rewards',
                  style: AppTheme.getTextStyle(
                    locale: localizations!.locale,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),

                // Current streak info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getStreakGradient(currentStreak, theme),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        currentStreak >= 7
                            ? Icons.local_fire_department
                            : Icons.emoji_events,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.currentStreak(currentStreak),
                              style: AppTheme.getTextStyle(
                                locale: localizations.locale,
                              ),
                            ),
                            if (currentStreak > 0)
                              Text(
                                localizations.playDailyMaintain,
                                style: AppTheme.getTextStyle(
                                  locale: localizations.locale,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // How streaks work
                Text(
                  localizations.howStreaksWork,
                  style: AppTheme.getTextStyle(
                    locale: localizations.locale,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.streakRules,
                  style: AppTheme.getTextStyle(
                    locale: localizations.locale,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 24),

                // Achieved rewards
                if (achievedRewards.isNotEmpty) ...[
                  Text(
                    localizations.achievedRewards,
                    style: AppTheme.getTextStyle(
                      locale: localizations.locale,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...achievedRewards.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${entry.key} ${localizations?.days}: ${entry.value} ✅',
                              style: AppTheme.getTextStyle(
                                locale: localizations!.locale,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Upcoming rewards
                if (upcomingRewards.isNotEmpty) ...[
                  Text(
                    localizations.upcomingRewards,
                    style: AppTheme.getTextStyle(
                      locale: localizations.locale,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...upcomingRewards.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle_outlined,
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${entry.key} ${localizations?.days}: ${entry.value}',
                              style: AppTheme.getTextStyle(
                                locale: localizations!.locale,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (entry.key - currentStreak > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                localizations?.daysLeft(
                                      entry.key - currentStreak,
                                    ) ??
                                    '${entry.key - currentStreak} days left',
                                style: AppTheme.getTextStyle(
                                  locale: localizations.locale,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Bonus tips
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(
                      isDarkMode ? 0.1 : 0.05,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.proTip,
                        style: AppTheme.getTextStyle(
                          locale: localizations.locale,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localizations.streakBonusInfo,
                        style: AppTheme.getTextStyle(
                          locale: localizations.locale,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Close button
                PrimaryButton(
                  text: localizations?.gotIt ?? 'GOT IT',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
