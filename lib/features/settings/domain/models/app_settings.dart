enum ThemePreference { system, light, dark }

class AppSettings {
  const AppSettings({
    required this.dailyGoalMinutes,
    required this.learningReminders,
    required this.dailyReminder,
    required this.achievementNotifications,
    required this.lessonNotifications,
    required this.soundEffects,
    required this.theme,
  });

  final int dailyGoalMinutes;
  final bool learningReminders;
  final bool dailyReminder;
  final bool achievementNotifications;
  final bool lessonNotifications;
  final bool soundEffects;
  final ThemePreference theme;

  AppSettings copyWith({
    int? dailyGoalMinutes,
    bool? learningReminders,
    bool? dailyReminder,
    bool? achievementNotifications,
    bool? lessonNotifications,
    bool? soundEffects,
    ThemePreference? theme,
  }) {
    return AppSettings(
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      learningReminders: learningReminders ?? this.learningReminders,
      dailyReminder: dailyReminder ?? this.dailyReminder,
      achievementNotifications:
          achievementNotifications ?? this.achievementNotifications,
      lessonNotifications: lessonNotifications ?? this.lessonNotifications,
      soundEffects: soundEffects ?? this.soundEffects,
      theme: theme ?? this.theme,
    );
  }
}
