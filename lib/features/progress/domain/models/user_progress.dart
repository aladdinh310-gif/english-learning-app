import 'skill_progress.dart';
import 'achievement.dart';

class UserProgress {
  const UserProgress({
    required this.xp,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastLearningDate,
    required this.lessonsCompleted,
    required this.vocabularyLearned,
    required this.quizCount,
    required this.correctAnswers,
    required this.quizQuestions,
    required this.speakingPractices,
    required this.listeningLessonsCompleted,
    required this.grammarPractices,
    required this.readingLessonsCompleted,
    required this.skills,
    required this.achievements,
  });

  final int xp;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastLearningDate;
  final int lessonsCompleted;
  final int vocabularyLearned;
  final int quizCount;
  final int correctAnswers;
  final int quizQuestions;
  final int speakingPractices;
  final int listeningLessonsCompleted;
  final int grammarPractices;
  final int readingLessonsCompleted;
  final List<SkillProgress> skills;
  final List<Achievement> achievements;

  double get quizAccuracy =>
      quizQuestions == 0 ? 0 : correctAnswers / quizQuestions;
}
