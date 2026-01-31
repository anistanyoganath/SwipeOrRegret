import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeorregret/app/app_routes.dart';
import 'package:swipeorregret/core/provider/local_provider.dart';
import 'package:swipeorregret/core/widgets/primary_button.dart';
import 'package:swipeorregret/features/settings/settings_controller.dart';
import 'package:swipeorregret/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return ChangeNotifierProvider(
      create: (_) => SettingsController(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations?.settings ?? 'Settings'),
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
                  // Sound Settings
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Audio',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('Sound Effects'),
                            value: controller.soundEnabled,
                            onChanged: controller.toggleSound,
                          ),
                          SwitchListTile(
                            title: const Text('Background Music'),
                            value: controller.musicEnabled,
                            onChanged: controller.toggleMusic,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Game Settings
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Game Settings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('Vibration'),
                            value: controller.vibrationEnabled,
                            onChanged: controller.toggleVibration,
                          ),
                          SwitchListTile(
                            title: const Text('Show Timer'),
                            value: controller.showTimer,
                            onChanged: controller.toggleShowTimer,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Data Management
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('Reset Game Data'),
                            subtitle: const Text(
                              'Clear all progress and start fresh',
                            ),
                            onTap: () => _showResetDialog(context, controller),
                          ),
                          ListTile(
                            leading: const Icon(Icons.cloud_download),
                            title: const Text('Load More Scenarios'),
                            subtitle: const Text('Download additional content'),
                            onTap: controller.loadMoreScenarios,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // About
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.info),
                            title: const Text('Version'),
                            subtitle: const Text('1.0.0'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.star),
                            title: const Text('Rate App'),
                            onTap: controller.rateApp,
                          ),
                          ListTile(
                            leading: const Icon(Icons.share),
                            title: const Text('Share App'),
                            onTap: controller.shareApp,
                          ),
                          ListTile(
                            leading: const Icon(Icons.privacy_tip),
                            title: const Text('Privacy Policy'),
                            onTap: () => controller.openPrivacyPolicy(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations?.language ?? 'Language',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.language),
                            title: Text(localizations?.language ?? 'Language'),
                            subtitle: Consumer<LocaleProvider>(
                              builder: (context, localeProvider, child) {
                                return Text(
                                  _getLanguageName(localeProvider.locale),
                                );
                              },
                            ),
                            trailing: Consumer<LocaleProvider>(
                              builder: (context, localeProvider, child) {
                                return DropdownButton<Locale>(
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
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: const Locale('si'),
                                      child: Text(
                                        localizations?.sinhala ?? 'සිංහල',
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: const Locale('ta'),
                                      child: Text(
                                        localizations?.tamil ?? 'தமிழ்',
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

                  const SizedBox(height: 32),

                  // Reset and Logout buttons
                  PrimaryButton(
                    text: 'RESET PROGRESS',
                    onPressed: () => _showResetDialog(context, controller),
                    backgroundColor: Colors.red,
                  ),

                  const SizedBox(height: 16),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Progress'),
          content: const Text(
            'Are you sure you want to reset all game progress? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                controller.resetProgress();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Progress reset successfully')),
                );
              },
              child: const Text('RESET', style: TextStyle(color: Colors.red)),
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
