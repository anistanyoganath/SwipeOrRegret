import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeorregret/app/app_routes.dart';
import 'package:swipeorregret/app/app_theme.dart';
import 'package:swipeorregret/core/widgets/primary_button.dart';
import 'package:swipeorregret/features/home/hero_illustration.dart';
import 'package:swipeorregret/features/home/home_controller.dart';
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

                        // Daily streak
                        Column(
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
                                    controller.streakDays,
                                    theme,
                                  ),
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.primaryColor.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    controller.streakDays >= 7
                                        ? Icons.local_fire_department
                                        : Icons.emoji_events,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Day ${controller.streakDays}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (controller.streakDays > 0) ...[
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => _showStreakInfo(
                                        context,
                                        controller.streakDays,
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
                            if (controller.streakDays > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Play ${_getNextMilestone(controller.streakDays)! - controller.streakDays} more days for bonus!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ),
                          ],
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
                        variant:
                            ButtonVariant.outlined, // This gives it a border
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
                              controller.loadStats(); // Refresh stats on return
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
                            onPressed: () {
                              _showLeaderboard(context);
                            },
                            icon: Icon(
                              Icons.leaderboard,
                              color: theme.colorScheme.primary,
                            ),
                            label: Text(
                              'Rank',
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

  void _showLeaderboard(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: theme.cardColor,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              Text(
                'Global Leaderboard',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              // Leaderboard list
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(
                    Icons.emoji_events,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                title: Text('You', style: theme.textTheme.bodyLarge),
                subtitle: Text(
                  'Score: 1250',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                trailing: Chip(
                  label: Text('#1'),
                  backgroundColor: Colors.amber,
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'CLOSE',
                onPressed: () => Navigator.pop(context),
                backgroundColor: theme.primaryColor,
              ),
            ],
          ),
        );
      },
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
    final locale = Localizations.localeOf(context);

    final rewards = {
      3: '+10 starting money 💰',
      7: '+20 starting money 💰 & -5 stress 🧠',
      14: '+30 starting money 💰 & +5 reputation ⭐',
      30: '+50 starting money 💰 & +10 reputation ⭐ & -10 stress 🧠',
    };

    // Find achieved and upcoming rewards
    final achievedRewards = <String>[];
    final upcomingRewards = <String>[];

    rewards.forEach((days, reward) {
      if (currentStreak >= days) {
        achievedRewards.add('$days days: $reward ✅');
      } else {
        upcomingRewards.add('$days days: $reward');
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
                  'Daily Streak Rewards',
                  style: AppTheme.getTextStyle(
                    locale: locale,
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
                              'Current Streak: $currentStreak days',
                              style: AppTheme.getTextStyle(
                                locale: locale,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            if (currentStreak > 0)
                              Text(
                                'Play daily to maintain your streak!',
                                style: AppTheme.getTextStyle(
                                  locale: locale,
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
                  'How Streaks Work',
                  style: AppTheme.getTextStyle(
                    locale: locale,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Play at least once every 24 hours to maintain your streak\n'
                  '• If you miss a day, your streak resets to 1\n'
                  '• Higher streaks give you better starting bonuses',
                  style: AppTheme.getTextStyle(
                    locale: locale,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 24),

                // Achieved rewards
                if (achievedRewards.isNotEmpty) ...[
                  Text(
                    'Achieved Rewards',
                    style: AppTheme.getTextStyle(
                      locale: locale,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...achievedRewards.map(
                    (reward) => Padding(
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
                              reward,
                              style: AppTheme.getTextStyle(
                                locale: locale,
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
                    'Upcoming Rewards',
                    style: AppTheme.getTextStyle(
                      locale: locale,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...upcomingRewards.map(
                    (reward) => Padding(
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
                              reward,
                              style: AppTheme.getTextStyle(
                                locale: locale,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (rewards.keys.firstWhere(
                                    (key) => reward.contains('$key days'),
                                  ) -
                                  currentStreak >
                              0)
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
                                '${rewards.keys.firstWhere((key) => reward.contains('$key days')) - currentStreak} days left',
                                style: AppTheme.getTextStyle(
                                  locale: locale,
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
                        '💡 Pro Tip',
                        style: AppTheme.getTextStyle(
                          locale: locale,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bonuses are applied automatically when you start a new game. '
                        'The higher your streak, the better your starting position!',
                        style: AppTheme.getTextStyle(
                          locale: locale,
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
                  text: 'GOT IT',
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
