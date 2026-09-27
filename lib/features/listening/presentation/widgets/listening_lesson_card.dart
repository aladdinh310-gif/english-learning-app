import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/linear_progress_bar.dart';
import '../../domain/models/listening_lesson.dart';

class ListeningLessonCard extends StatelessWidget {
  const ListeningLessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
  });

  final ListeningLesson lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final minutes = lesson.duration.inMinutes;
    final seconds = lesson.duration.inSeconds % 60;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.headphones_outlined,
                    color: AppColors.primary,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
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
                Icon(
                  lesson.completed
                      ? Icons.check_circle
                      : Icons.play_circle_outline,
                  color: lesson.completed
                      ? AppColors.success
                      : AppColors.primary,
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text(
                  lesson.difficulty,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$minutes:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            LinearProgressBar(value: lesson.progress),
          ],
        ),
      ),
    );
  }
}
