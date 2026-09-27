import 'package:flutter/material.dart';

import '../domain/models/achievement.dart';
import '../domain/models/skill_progress.dart';
import '../domain/models/user_progress.dart';

class ProgressManager extends ChangeNotifier {
  ProgressManager._() : _progress = _initialProgress();

  static final ProgressManager instance = ProgressManager._();

  UserProgress _progress;

  UserProgress get progress => _progress;

  static const levelThresholds = <String, int>{
    'A1': 0,
    'A2': 500,
    'B1': 1500,
    'B2': 3000,
    'C1': 5000,
  };

  static const levelTitles = <String, String>{
    'A1': 'Beginner',
    'A2': 'Elementary',
    'B1': 'Intermediate',
    'B2': 'Upper Intermediate',
    'C1': 'Advanced',
  };

  String get currentLevel {
    var selected = 'A1';
    for (final entry in levelThresholds.entries) {
      if (_progress.xp >= entry.value) selected = entry.key;
    }
    return selected;
  }

  String get currentLevelTitle => levelTitles[currentLevel]!;

  int get nextLevelThreshold {
    final levels = levelThresholds.entries.toList();
    final index = levels.indexWhere((entry) => entry.key == currentLevel);
    return index < levels.length - 1
        ? levels[index + 1].value
        : levels.last.value;
  }

  int get levelProgressXp => _progress.xp - levelThresholds[currentLevel]!;

  double get levelProgress {
    final start = levelThresholds[currentLevel]!;
    final next = nextLevelThreshold;
    if (next <= start) return 1;
    return ((_progress.xp - start) / (next - start)).clamp(0.0, 1.0);
  }

  int get xpToNextLevel => nextLevelThreshold <= _progress.xp
      ? 0
      : nextLevelThreshold - _progress.xp;

  void awardXp(int amount) {
    if (amount <= 0) return;
    _progress = _progress.copyWith(xp: _progress.xp + amount);
    _saveLearningDay();
    _refreshAchievements();
    notifyListeners();
  }

  void recordLessonCompleted() {
    _progress = _progress.copyWith(
      lessonsCompleted: _progress.lessonsCompleted + 1,
    );
    awardXp(50);
  }

  void recordQuizCompleted({required int score, required int total}) {
    _progress = _progress.copyWith(
      quizCount: _progress.quizCount + 1,
      correctAnswers: _progress.correctAnswers + score,
      quizQuestions: _progress.quizQuestions + total,
    );
    awardXp(score == total ? 50 : 30);
  }

  void recordVocabularyPractice() {
    _progress = _progress.copyWith(
      vocabularyLearned: _progress.vocabularyLearned + 1,
    );
    _increaseSkill('vocabulary', 0.02);
    awardXp(10);
  }

  void recordGrammarPractice() {
    _progress = _progress.copyWith(
      grammarPractices: _progress.grammarPractices + 1,
    );
    _increaseSkill('grammar', 0.03);
    awardXp(20);
  }

  void recordListeningCompleted() {
    _progress = _progress.copyWith(
      listeningLessonsCompleted: _progress.listeningLessonsCompleted + 1,
    );
    _increaseSkill('listening', 0.03);
    awardXp(30);
  }

  void recordSpeakingPractice() {
    _progress = _progress.copyWith(
      speakingPractices: _progress.speakingPractices + 1,
    );
    _increaseSkill('speaking', 0.03);
    awardXp(30);
  }

  void recordReadingCompleted() {
    _progress = _progress.copyWith(
      readingLessonsCompleted: _progress.readingLessonsCompleted + 1,
    );
    _increaseSkill('reading', 0.03);
    awardXp(25);
  }

  void _increaseSkill(String id, double amount) {
    _progress = _progress.copyWith(
      skills: [
        for (final skill in _progress.skills)
          skill.id == id
              ? SkillProgress(
                  id: skill.id,
                  name: skill.name,
                  level: skill.level,
                  progress: (skill.progress + amount)
                      .clamp(0.0, 1.0)
                      .toDouble(),
                  description: skill.description,
                )
              : skill,
      ],
    );
  }

  void _saveLearningDay() {
    final today = DateTime.now();
    final last = _progress.lastLearningDate;
    var streak = _progress.currentStreak;
    if (last == null) {
      streak = 1;
    } else if (!_sameDay(last, today)) {
      final yesterday = today.subtract(const Duration(days: 1));
      streak = _sameDay(last, yesterday) ? streak + 1 : 1;
    }
    _progress = _progress.copyWith(
      currentStreak: streak,
      longestStreak: streak > _progress.longestStreak
          ? streak
          : _progress.longestStreak,
      lastLearningDate: today,
    );
  }

  void _refreshAchievements() {
    final now = DateTime.now();
    final unlocked = _progress.achievements.map((achievement) {
      final reached = switch (achievement.id) {
        'first_lesson' => _progress.lessonsCompleted >= 1,
        'vocabulary_builder' => _progress.vocabularyLearned >= 50,
        'quiz_master' =>
          _progress.quizCount > 0 && _progress.quizAccuracy >= 0.9,
        'speaking_starter' => _progress.speakingPractices >= 1,
        'listening_explorer' => _progress.listeningLessonsCompleted >= 10,
        'seven_day_streak' => _progress.currentStreak >= 7,
        'grammar_explorer' => _progress.grammarPractices >= 10,
        'reading_habit' => _progress.readingLessonsCompleted >= 10,
        _ => false,
      };
      if (reached && !achievement.unlocked) {
        return achievement.copyWith(unlocked: true, unlockDate: now);
      }
      return achievement.copyWith(
        progress: _achievementProgress(achievement.id),
      );
    }).toList();
    _progress = _progress.copyWith(achievements: unlocked);
  }

  String _achievementProgress(String id) {
    return switch (id) {
      'first_lesson' => '${_progress.lessonsCompleted} / 1',
      'vocabulary_builder' => '${_progress.vocabularyLearned} / 50',
      'quiz_master' => '${(_progress.quizAccuracy * 100).round()}% accuracy',
      'speaking_starter' => '${_progress.speakingPractices} / 1',
      'listening_explorer' => '${_progress.listeningLessonsCompleted} / 10',
      'seven_day_streak' => '${_progress.currentStreak} / 7 days',
      'grammar_explorer' => '${_progress.grammarPractices} / 10',
      'reading_habit' => '${_progress.readingLessonsCompleted} / 10',
      _ => 'Locked',
    };
  }

  bool _sameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  static UserProgress _initialProgress() {
    return UserProgress(
      xp: 340,
      currentStreak: 3,
      longestStreak: 5,
      lastLearningDate: DateTime.now(),
      lessonsCompleted: 2,
      vocabularyLearned: 28,
      quizCount: 5,
      correctAnswers: 20,
      quizQuestions: 25,
      speakingPractices: 0,
      listeningLessonsCompleted: 1,
      grammarPractices: 3,
      readingLessonsCompleted: 2,
      skills: const [
        SkillProgress(
          id: 'vocabulary',
          name: 'Vocabulary',
          level: 'A1',
          progress: 0.56,
          description: 'Build a strong everyday word foundation',
        ),
        SkillProgress(
          id: 'grammar',
          name: 'Grammar',
          level: 'A1',
          progress: 0.34,
          description: 'Make clearer and more accurate sentences',
        ),
        SkillProgress(
          id: 'reading',
          name: 'Reading',
          level: 'A1',
          progress: 0.42,
          description: 'Understand the main ideas in short texts',
        ),
        SkillProgress(
          id: 'listening',
          name: 'Listening',
          level: 'A1',
          progress: 0.28,
          description: 'Catch useful details in everyday English',
        ),
        SkillProgress(
          id: 'speaking',
          name: 'Speaking',
          level: 'A1',
          progress: 0.18,
          description: 'Practise speaking with more confidence',
        ),
      ],
      achievements: [
        Achievement(
          id: 'first_lesson',
          title: 'First Lesson',
          description: 'Complete your first lesson.',
          icon: Icons.school_outlined,
          xpReward: 50,
          unlocked: true,
          progress: '2 / 1',
          unlockDate: null,
        ),
        Achievement(
          id: 'vocabulary_builder',
          title: 'Vocabulary Builder',
          description: 'Learn 50 vocabulary words.',
          icon: Icons.translate_outlined,
          xpReward: 50,
          unlocked: false,
          progress: '28 / 50',
        ),
        Achievement(
          id: 'quiz_master',
          title: 'Quiz Master',
          description: 'Achieve 90% or higher in a quiz.',
          icon: Icons.quiz_outlined,
          xpReward: 75,
          unlocked: false,
          progress: '80% accuracy',
        ),
        Achievement(
          id: 'speaking_starter',
          title: 'Speaking Starter',
          description: 'Complete your first speaking practice.',
          icon: Icons.mic_none_outlined,
          xpReward: 50,
          unlocked: false,
          progress: '0 / 1',
        ),
        Achievement(
          id: 'listening_explorer',
          title: 'Listening Explorer',
          description: 'Complete 10 listening lessons.',
          icon: Icons.headphones_outlined,
          xpReward: 100,
          unlocked: false,
          progress: '1 / 10',
        ),
        Achievement(
          id: 'seven_day_streak',
          title: '7 Day Streak',
          description: 'Study for 7 consecutive days.',
          icon: Icons.local_fire_department_outlined,
          xpReward: 100,
          unlocked: false,
          progress: '3 / 7 days',
        ),
        Achievement(
          id: 'grammar_explorer',
          title: 'Grammar Explorer',
          description: 'Complete 10 grammar practices.',
          icon: Icons.spellcheck_outlined,
          xpReward: 75,
          unlocked: false,
          progress: '3 / 10',
        ),
        Achievement(
          id: 'reading_habit',
          title: 'Reading Habit',
          description: 'Complete 10 reading lessons.',
          icon: Icons.menu_book_outlined,
          xpReward: 75,
          unlocked: false,
          progress: '2 / 10',
        ),
      ],
    );
  }
}

extension on UserProgress {
  UserProgress copyWith({
    int? xp,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastLearningDate,
    int? lessonsCompleted,
    int? vocabularyLearned,
    int? quizCount,
    int? correctAnswers,
    int? quizQuestions,
    int? speakingPractices,
    int? listeningLessonsCompleted,
    int? grammarPractices,
    int? readingLessonsCompleted,
    List<SkillProgress>? skills,
    List<Achievement>? achievements,
  }) {
    return UserProgress(
      xp: xp ?? this.xp,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastLearningDate: lastLearningDate ?? this.lastLearningDate,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      vocabularyLearned: vocabularyLearned ?? this.vocabularyLearned,
      quizCount: quizCount ?? this.quizCount,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      quizQuestions: quizQuestions ?? this.quizQuestions,
      speakingPractices: speakingPractices ?? this.speakingPractices,
      listeningLessonsCompleted:
          listeningLessonsCompleted ?? this.listeningLessonsCompleted,
      grammarPractices: grammarPractices ?? this.grammarPractices,
      readingLessonsCompleted:
          readingLessonsCompleted ?? this.readingLessonsCompleted,
      skills: skills ?? this.skills,
      achievements: achievements ?? this.achievements,
    );
  }
}
