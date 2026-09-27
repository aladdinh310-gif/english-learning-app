import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/app_settings.dart';

class SettingsData extends ChangeNotifier {
  SettingsData._() : _settings = _defaults() {
    _load();
  }

  static final SettingsData instance = SettingsData._();

  AppSettings _settings;

  AppSettings get settings => _settings;

  static AppSettings _defaults() {
    return const AppSettings(
      dailyGoalMinutes: 15,
      learningReminders: false,
      dailyReminder: false,
      achievementNotifications: false,
      lessonNotifications: false,
      soundEffects: true,
      theme: ThemePreference.system,
    );
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final themeName = preferences.getString('settings.theme');
    _settings = _settings.copyWith(
      dailyGoalMinutes: preferences.getInt('settings.dailyGoalMinutes'),
      learningReminders: preferences.getBool('settings.learningReminders'),
      dailyReminder: preferences.getBool('settings.dailyReminder'),
      achievementNotifications: preferences.getBool(
        'settings.achievementNotifications',
      ),
      lessonNotifications: preferences.getBool('settings.lessonNotifications'),
      soundEffects: preferences.getBool('settings.soundEffects'),
      theme: ThemePreference.values.firstWhere(
        (value) => value.name == themeName,
        orElse: () => _settings.theme,
      ),
    );
    notifyListeners();
  }

  Future<void> update(AppSettings settings) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(
      'settings.dailyGoalMinutes',
      settings.dailyGoalMinutes,
    );
    await preferences.setBool(
      'settings.learningReminders',
      settings.learningReminders,
    );
    await preferences.setBool('settings.dailyReminder', settings.dailyReminder);
    await preferences.setBool(
      'settings.achievementNotifications',
      settings.achievementNotifications,
    );
    await preferences.setBool(
      'settings.lessonNotifications',
      settings.lessonNotifications,
    );
    await preferences.setBool('settings.soundEffects', settings.soundEffects);
    await preferences.setString('settings.theme', settings.theme.name);
    _settings = settings;
    notifyListeners();
  }

  Future<void> updateField(AppSettings Function(AppSettings) change) {
    return update(change(_settings));
  }
}
