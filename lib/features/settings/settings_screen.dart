import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeorregret/app/app_routes.dart';
import 'package:swipeorregret/core/provider/local_provider.dart';
import 'package:swipeorregret/core/provider/theme_provider.dart';
import 'package:swipeorregret/features/settings/settings_controller.dart';
import 'package:swipeorregret/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => SettingsController(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            localizations?.settings ?? 'Settings',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<SettingsController>(
            builder: (context, controller, child) {
              return ListView(
                children: [
                  // Appearance Card
                  Card(
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appearance',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Theme toggle with proper listening
                          Consumer<ThemeProvider>(
                            builder: (context, themeProvider, child) {
                              return SwitchListTile(
                                title: Text(
                                  'Dark Mode',
                                  style: theme.textTheme.bodyLarge,
                                ),
                                value: themeProvider.isDarkMode,
                                onChanged: (value) {
                                  themeProvider.setThemeMode(
                                    value ? ThemeMode.dark : ThemeMode.light,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sound Settings Card
                  Card(
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Audio',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: Text(
                              'Sound Effects',
                              style: theme.textTheme.bodyLarge,
                            ),
                            value: controller.soundEnabled,
                            onChanged: controller.toggleSound,
                          ),
                          SwitchListTile(
                            title: Text(
                              'Background Music',
                              style: theme.textTheme.bodyLarge,
                            ),
                            value: controller.musicEnabled,
                            onChanged: controller.toggleMusic,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Game Settings Card
                  Card(
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Game Settings',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: Text(
                              'Vibration',
                              style: theme.textTheme.bodyLarge,
                            ),
                            value: controller.vibrationEnabled,
                            onChanged: controller.toggleVibration,
                          ),
                          SwitchListTile(
                            title: Text(
                              'Show Timer',
                              style: theme.textTheme.bodyLarge,
                            ),
                            value: controller.showTimer,
                            onChanged: controller.toggleShowTimer,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Data Management Card
                  Card(
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: Icon(
                              Icons.delete,
                              color: theme.iconTheme.color,
                            ),
                            title: Text(
                              'Reset Game Data',
                              style: theme.textTheme.bodyLarge,
                            ),
                            subtitle: Text(
                              'Clear all progress and start fresh',
                              style: theme.textTheme.bodySmall,
                            ),
                            onTap: () => _showResetDialog(context, controller),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.cloud_download,
                              color: theme.iconTheme.color,
                            ),
                            title: Text(
                              'Load More Scenarios',
                              style: theme.textTheme.bodyLarge,
                            ),
                            subtitle: Text(
                              'Download additional content',
                              style: theme.textTheme.bodySmall,
                            ),
                            onTap: controller.loadMoreScenarios,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // About Card
                  Card(
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: Icon(
                              Icons.info,
                              color: theme.iconTheme.color,
                            ),
                            title: Text(
                              'Version',
                              style: theme.textTheme.bodyLarge,
                            ),
                            subtitle: Text(
                              '1.0.0',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.star,
                              color: theme.iconTheme.color,
                            ),
                            title: Text(
                              'Rate App',
                              style: theme.textTheme.bodyLarge,
                            ),
                            onTap: controller.rateApp,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.share,
                              color: theme.iconTheme.color,
                            ),
                            title: Text(
                              'Share App',
                              style: theme.textTheme.bodyLarge,
                            ),
                            onTap: controller.shareApp,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.privacy_tip,
                              color: theme.iconTheme.color,
                            ),
                            title: Text(
                              'Privacy Policy',
                              style: theme.textTheme.bodyLarge,
                            ),
                            onTap: () => controller.openPrivacyPolicy(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Language Card
                  Card(
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations?.language ?? 'Language',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Consumer<LocaleProvider>(
                            builder: (context, localeProvider, child) {
                              return ListTile(
                                leading: Icon(
                                  Icons.language,
                                  color: theme.iconTheme.color,
                                ),
                                title: Text(
                                  localizations?.language ?? 'Language',
                                  style: theme.textTheme.bodyLarge,
                                ),
                                subtitle: Text(
                                  _getLanguageName(localeProvider.locale),
                                  style: theme.textTheme.bodySmall,
                                ),
                                trailing: DropdownButton<Locale>(
                                  value: localeProvider.locale,
                                  onChanged: (Locale? newLocale) {
                                    if (newLocale != null) {
                                      localeProvider.setLocale(newLocale);
                                    }
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      value: const Locale('en'),
                                      child: Text(
                                        localizations?.english ?? 'English',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: const Locale('si'),
                                      child: Text(
                                        localizations?.sinhala ?? 'සිංහල',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: const Locale('ta'),
                                      child: Text(
                                        localizations?.tamil ?? 'தமிழ்',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ),
                                  ],
                                  dropdownColor: theme.cardColor,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Back to Home Button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(color: theme.colorScheme.primary),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('BACK TO HOME'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, SettingsController controller) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: Text('Reset Progress', style: theme.textTheme.titleLarge),
          content: Text(
            'Are you sure you want to reset all game progress? '
            'This action cannot be undone.',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CANCEL', style: theme.textTheme.bodyLarge),
            ),
            TextButton(
              onPressed: () {
                controller.resetProgress();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Progress reset successfully',
                      style: theme.textTheme.bodyMedium,
                    ),
                    backgroundColor: theme.colorScheme.errorContainer,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'RESET',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'si':
        return 'සිංහල';
      case 'ta':
        return 'தமிழ்';
      default:
        return 'English';
    }
  }
}
