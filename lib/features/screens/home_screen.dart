import 'package:flutter/material.dart';

import '../../core/data/mock_learning_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/avatar_with_level_badge.dart';
import '../../core/widgets/linear_progress_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/stat_chip.dart';
import '../progress/data/progress_data.dart';
import 'lessons_screen.dart';
import 'speaking_screen.dart';
import '../grammar/presentation/screens/grammar_screen.dart';
import '../listening/presentation/screens/listening_screen.dart';
import '../vocabulary/presentation/screens/vocabulary_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openLessons(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonsScreen(
          level: ProgressManager.instance.currentLevel,
          levelTitle: ProgressManager.instance.currentLevelTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ProgressManager.instance,
      builder: (context, _) => Scaffold(
        backgroundColor: AppColors.backgroundStart,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning, ${MockLearningData.userName}!',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Ready to improve your English today?',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AvatarWithLevelBadge(
                    level: ProgressManager.instance.currentLevel,
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  StatChip(
                    label: 'Current level',
                    value: ProgressManager.instance.currentLevel,
                    icon: Icons.trending_up_rounded,
                  ),
                  const SizedBox(width: 10),
                  StatChip(
                    label: 'XP',
                    value: '${ProgressManager.instance.progress.xp}',
                    icon: Icons.bolt_rounded,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 10),
                  StatChip(
                    label: 'Day streak',
                    value: '${ProgressManager.instance.progress.currentStreak}',
                    icon: Icons.local_fire_department_outlined,
                    color: AppColors.accentPink,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const SectionHeader(title: 'Continue Learning'),
              const SizedBox(height: 12),
              _continueLearningCard(context),
              const SizedBox(height: 28),
              const SectionHeader(title: "Today's Goal"),
              const SizedBox(height: 12),
              _dailyGoalCard(),
              const SizedBox(height: 28),
              const SectionHeader(title: 'Quick Access'),
              const SizedBox(height: 12),
              _quickAccessGrid(context),
              const SizedBox(height: 28),
              const SectionHeader(title: 'Recommended Lesson'),
              const SizedBox(height: 12),
              _recommendedCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _continueLearningCard(BuildContext context) {
    return _surfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBox(Icons.menu_book_outlined),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lesson 1',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      MockLearningData.lessonTitle,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      MockLearningData.lessonDescription,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '45% complete',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ProgressManager.instance.currentLevel,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const LinearProgressBar(value: 0.45),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Continue',
            onPressed: () => _openLessons(context),
          ),
        ],
      ),
    );
  }

  Widget _dailyGoalCard() {
    return _surfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${MockLearningData.dailyGoalMinutes} minutes',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Daily learning target',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                '${MockLearningData.completedGoalMinutes}/${MockLearningData.dailyGoalMinutes}',
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const LinearProgressBar(
            value: MockLearningData.dailyGoalProgress,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _quickAccessGrid(BuildContext context) {
    const items = [
      (Icons.translate_outlined, 'Vocabulary'),
      (Icons.spellcheck_outlined, 'Grammar'),
      (Icons.headphones_outlined, 'Listening'),
      (Icons.mic_none_outlined, 'Speaking'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final item in items)
          InkWell(
            onTap: () {
              if (item.$2 == 'Speaking') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SpeakingScreen()),
                );
              } else {
                final screen = switch (item.$2) {
                  'Vocabulary' => const VocabularyScreen(),
                  'Grammar' => const GrammarScreen(),
                  'Listening' => const ListeningScreen(),
                  _ => null,
                };
                if (screen != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => screen),
                  );
                }
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: _surfaceCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(item.$1, color: AppColors.primary, size: 23),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.$2,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _recommendedCard(BuildContext context) {
    return _surfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _iconBox(Icons.auto_awesome_outlined),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ProgressManager.instance.currentLevel,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  MockLearningData.recommendedLesson,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  MockLearningData.recommendedDescription,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 14),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _openLessons(context),
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: AppColors.primary, size: 27),
    );
  }

  Widget _surfaceCard({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(18),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}
