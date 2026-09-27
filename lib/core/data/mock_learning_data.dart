/// Temporary local data for the app shell.
///
/// Keep this boundary small so the values can later be replaced by a
/// repository backed by Supabase, an API, or a local database.
class MockLearningData {
  MockLearningData._();

  static const userName = 'Ali';
  static const currentLevel = 'A1';
  static const currentLevelTitle = 'Beginner';
  static const xp = 340;
  static const dailyStreak = 3;
  static const overallProgress = 0.25;
  static const lessonProgress = 0.45;
  static const dailyGoalProgress = 0.40;
  static const dailyGoalMinutes = 20;
  static const completedGoalMinutes = 8;
  static const lessonTitle = 'Greetings';
  static const lessonDescription = 'Learn basic greetings and introductions.';
  static const recommendedLesson = 'Introducing Yourself';
  static const recommendedDescription =
      'Practice talking about your name, home, and interests.';
}
