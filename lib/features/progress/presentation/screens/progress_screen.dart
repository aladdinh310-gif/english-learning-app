import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/progress_data.dart';
import '../../domain/models/skill_progress.dart';
import '../../domain/models/user_progress.dart';
import '../widgets/achievement_badge.dart';
import '../widgets/progress_stat_card.dart';
import '../widgets/skill_progress_tile.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ProgressManager.instance,
      builder: (context, _) {
        final manager = ProgressManager.instance;
        final data = manager.progress;
        return Scaffold(
          backgroundColor: AppColors.backgroundStart,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Your Progress',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              _levelCard(manager),
              const SizedBox(height: 18),
              Row(
                children: [
                  ProgressStatCard(
                    label: 'Lessons',
                    value: '${data.lessonsCompleted}',
                    icon: Icons.menu_book_outlined,
                  ),
                  const SizedBox(width: 10),
                  ProgressStatCard(
                    label: 'Vocabulary',
                    value: '${data.vocabularyLearned}',
                    icon: Icons.translate_outlined,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 10),
                  ProgressStatCard(
                    label: 'Accuracy',
                    value: '${(data.quizAccuracy * 100).round()}%',
                    icon: Icons.insights_outlined,
                    color: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ProgressStatCard(
                    label: 'Speaking',
                    value: '${data.speakingPractices}',
                    icon: Icons.mic_none_outlined,
                    color: AppColors.accentPink,
                  ),
                  const SizedBox(width: 10),
                  ProgressStatCard(
                    label: 'Listening',
                    value: '${data.listeningLessonsCompleted}',
                    icon: Icons.headphones_outlined,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 10),
                  ProgressStatCard(
                    label: 'Streak',
                    value: '${data.currentStreak} days',
                    icon: Icons.local_fire_department_outlined,
                    color: AppColors.accentPink,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Skills',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              _skillsCard(data.skills),
              const SizedBox(height: 28),
              const Text(
                'Achievements',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              _achievementGrid(data.achievements),
              const SizedBox(height: 28),
              _statisticsCard(data),
            ],
          ),
        );
      },
    );
  }

  Widget _levelCard(ProgressManager manager) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${manager.currentLevel} • ${manager.currentLevelTitle}',
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${manager.progress.xp} XP total',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: manager.levelProgress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            manager.xpToNextLevel == 0
                ? 'Highest level reached'
                : '${manager.levelProgressXp} / ${manager.nextLevelThreshold - ProgressManager.levelThresholds[manager.currentLevel]!} XP • ${manager.xpToNextLevel} XP to next level',
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Longest streak: ${manager.progress.longestStreak} days',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _skillsCard(List<SkillProgress> skills) {
    const icons = {
      'vocabulary': Icons.translate_outlined,
      'grammar': Icons.spellcheck_outlined,
      'reading': Icons.menu_book_outlined,
      'listening': Icons.headphones_outlined,
      'speaking': Icons.mic_none_outlined,
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (final skill in skills)
            SkillProgressTile(
              skill: skill,
              icon: icons[skill.id] ?? Icons.insights_outlined,
            ),
        ],
      ),
    );
  }

  Widget _achievementGrid(List achievements) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.25,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final achievement in achievements)
          AchievementBadge(achievement: achievement),
      ],
    );
  }

  Widget _statisticsCard(UserProgress data) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _statRow(
            'Quiz questions answered',
            '${data.quizQuestions}',
            Icons.quiz_outlined,
          ),
          const Divider(height: 24, color: AppColors.divider),
          _statRow(
            'Correct answers',
            '${data.correctAnswers}',
            Icons.check_circle_outline,
          ),
          const Divider(height: 24, color: AppColors.divider),
          _statRow(
            'Grammar practices',
            '${data.grammarPractices}',
            Icons.spellcheck_outlined,
          ),
          const Divider(height: 24, color: AppColors.divider),
          _statRow(
            'Reading lessons',
            '${data.readingLessonsCompleted}',
            Icons.menu_book_outlined,
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
