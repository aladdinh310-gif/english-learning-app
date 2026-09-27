import 'package:flutter/material.dart';

import '../../../../core/data/mock_learning_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../lesson/data/lesson_data.dart';
import '../../../lesson/presentation/screens/lesson_detail_screen.dart';
import '../../../grammar/presentation/screens/grammar_screen.dart';
import '../../../listening/presentation/screens/listening_screen.dart';
import '../../../vocabulary/presentation/screens/vocabulary_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _selectedLevel = MockLearningData.currentLevel;

  void _openCategory(String category) {
    if (category == 'Vocabulary') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VocabularyScreen()),
      );
      return;
    }
    if (category == 'Grammar') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GrammarScreen()),
      );
      return;
    }
    if (category == 'Listening') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ListeningScreen()),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            _CategoryLessonsScreen(level: _selectedLevel, category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Learn English',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          const Text(
            'Choose a skill and improve step by step.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 22),
          const Text(
            'Your level',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final level in LessonData.levels)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(level.$1),
                      selected: _selectedLevel == level.$1,
                      onSelected: (_) {
                        setState(() => _selectedLevel = level.$1);
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: _selectedLevel == level.$1
                            ? AppColors.onPrimary
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                      side: BorderSide.none,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Categories',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          for (final category in LessonData.categories)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CategoryTile(
                title: category.$1,
                description: category.$2,
                icon: _iconFor(category.$3),
                onTap: () => _openCategory(category.$1),
              ),
            ),
        ],
      ),
    );
  }

  IconData _iconFor(String name) {
    switch (name) {
      case 'translate_outlined':
        return Icons.translate_outlined;
      case 'spellcheck_outlined':
        return Icons.spellcheck_outlined;
      case 'headphones_outlined':
        return Icons.headphones_outlined;
      case 'mic_none_outlined':
        return Icons.mic_none_outlined;
      case 'chat_bubble_outline':
        return Icons.chat_bubble_outline;
      default:
        return Icons.menu_book_outlined;
    }
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryLessonsScreen extends StatelessWidget {
  const _CategoryLessonsScreen({required this.level, required this.category});

  final String level;
  final String category;

  @override
  Widget build(BuildContext context) {
    final lessons = LessonData.forCategory(level, category);

    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '$level • $category',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            '${lessons.length} lesson${lessons.length == 1 ? '' : 's'} available',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          for (var index = 0; index < lessons.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _LessonTile(
                lesson: lessons[index],
                lessonNumber: index + 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.lesson, required this.lessonNumber});

  final Lesson lesson;
  final int lessonNumber;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LessonDetailScreen(lesson: lesson)),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                '$lessonNumber',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    lesson.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
