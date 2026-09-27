import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/linear_progress_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../lesson/data/lesson_data.dart';
import '../../../quiz/presentation/screens/quiz_screen.dart';

class ReadingLessonScreen extends StatelessWidget {
  const ReadingLessonScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          lesson.title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Row(
            children: [
              _badge(lesson.level),
              const SizedBox(width: 10),
              const Text(
                'Reading',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const LinearProgressBar(value: 0.5),
          const SizedBox(height: 22),
          const Text(
            'Read the passage',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _card(
            child: Text(
              lesson.passage,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                height: 1.65,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Important vocabulary',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final word in lesson.importantVocabulary)
                Chip(
                  label: Text(word),
                  backgroundColor: AppColors.surface,
                  side: BorderSide.none,
                  labelStyle: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 26),
          PrimaryButton(
            label: 'Next',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => QuizScreen(lesson: lesson)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _badge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}
