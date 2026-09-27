import 'package:flutter/material.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/data/profile_data.dart';
import '../../../progress/data/progress_data.dart';
import '../../data/settings_data.dart';
import '../../domain/models/app_settings.dart';
import '../widgets/settings_list_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        SettingsData.instance,
        ProfileData.instance,
        ProgressManager.instance,
      ]),
      builder: (context, _) {
        final settings = SettingsData.instance.settings;
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
            children: [
              _section('Account', [
                SettingsListTile(
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.editProfile),
                ),
                const Divider(height: 1),
                const SettingsListTile(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  subtitle: 'Available when authentication is connected',
                  enabled: false,
                ),
                const Divider(height: 1),
                SettingsListTile(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: ProfileData.instance.profile.email,
                  enabled: false,
                ),
              ]),
              _section('Learning', [
                SettingsListTile(
                  icon: Icons.flag_outlined,
                  title: 'Daily Goal',
                  subtitle: '${settings.dailyGoalMinutes} minutes',
                  onTap: () => _chooseDailyGoal(context, settings),
                ),
                const Divider(height: 1),
                SettingsListTile(
                  icon: Icons.school_outlined,
                  title: 'Current Level',
                  subtitle:
                      '${ProgressManager.instance.currentLevel} • ${ProgressManager.instance.currentLevelTitle}',
                  enabled: false,
                ),
                const Divider(height: 1),
                const SettingsListTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Learning Reminders',
                  subtitle: 'Notification scheduling is coming later',
                  enabled: false,
                ),
              ]),
              _section('Notifications', [
                _switchTile(
                  icon: Icons.alarm_outlined,
                  title: 'Daily Reminder',
                  value: settings.dailyReminder,
                  enabled: false,
                  onChanged: (value) =>
                      _update(settings.copyWith(dailyReminder: value)),
                ),
                const Divider(height: 1),
                _switchTile(
                  icon: Icons.emoji_events_outlined,
                  title: 'Achievement Notifications',
                  value: settings.achievementNotifications,
                  enabled: false,
                  onChanged: (value) => _update(
                    settings.copyWith(achievementNotifications: value),
                  ),
                ),
                const Divider(height: 1),
                _switchTile(
                  icon: Icons.menu_book_outlined,
                  title: 'Lesson Notifications',
                  value: settings.lessonNotifications,
                  enabled: false,
                  onChanged: (value) =>
                      _update(settings.copyWith(lessonNotifications: value)),
                ),
              ]),
              _section('App', [
                SettingsListTile(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: 'English',
                  enabled: false,
                ),
                const Divider(height: 1),
                SettingsListTile(
                  icon: Icons.brightness_6_outlined,
                  title: 'Theme',
                  subtitle: _themeLabel(settings.theme),
                  onTap: () => _chooseTheme(context, settings),
                ),
                const Divider(height: 1),
                _switchTile(
                  icon: Icons.volume_up_outlined,
                  title: 'Sound Effects',
                  value: settings.soundEffects,
                  enabled: true,
                  onChanged: (value) =>
                      _update(settings.copyWith(soundEffects: value)),
                ),
                const Divider(height: 1),
                SettingsListTile(
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.about),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          color: AppColors.surface,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required bool enabled,
    required ValueChanged<bool> onChanged,
  }) {
    return SettingsListTile(
      icon: icon,
      title: title,
      subtitle: enabled ? null : 'Notification scheduling is coming later',
      enabled: enabled,
      trailing: Switch(value: value, onChanged: enabled ? onChanged : null),
    );
  }

  Future<void> _chooseDailyGoal(
    BuildContext context,
    AppSettings settings,
  ) async {
    final selected = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Daily learning goal'),
        children: [5, 10, 15, 30]
            .map(
              (minutes) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, minutes),
                child: Text('$minutes minutes'),
              ),
            )
            .toList(),
      ),
    );
    if (selected != null) {
      await SettingsData.instance.update(
        settings.copyWith(dailyGoalMinutes: selected),
      );
    }
  }

  Future<void> _chooseTheme(BuildContext context, AppSettings settings) async {
    final selected = await showDialog<ThemePreference>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Theme preference'),
        children: ThemePreference.values
            .map(
              (theme) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, theme),
                child: Text(_themeLabel(theme)),
              ),
            )
            .toList(),
      ),
    );
    if (selected != null) {
      await SettingsData.instance.update(settings.copyWith(theme: selected));
      if (selected == ThemePreference.dark) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dark mode is saved as a preference for now.'),
            ),
          );
        }
      }
    }
  }

  String _themeLabel(ThemePreference theme) {
    return switch (theme) {
      ThemePreference.system => 'System',
      ThemePreference.light => 'Light',
      ThemePreference.dark => 'Dark (coming later)',
    };
  }

  Future<void> _update(AppSettings settings) {
    return SettingsData.instance.update(settings);
  }
}
