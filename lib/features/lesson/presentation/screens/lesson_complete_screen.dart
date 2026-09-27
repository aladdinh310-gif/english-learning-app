import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/lesson_data.dart';
import '../../../progress/data/progress_data.dart';

class LessonCompleteScreen extends StatefulWidget {
  const LessonCompleteScreen({
    super.key,
    required this.lesson,
    required this.score,
    required this.total,
  });

  final Lesson lesson;
  final int score;
  final int total;

  @override
  State<LessonCompleteScreen> createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends State<LessonCompleteScreen> {
  @override
  void initState() {
    super.initState();
    ProgressManager.instance.recordLessonCompleted();
    if (widget.lesson.activity == LessonActivity.reading) {
      ProgressManager.instance.recordReadingCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.total == 0
        ? 0
        : ((widget.score / widget.total) * 100).round();

    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
          child: Column(
            children: [
              const Spacer(),
              const Icon(
                Icons.emoji_events_outlined,
                color: AppColors.primary,
                size: 78,
              ),
              const SizedBox(height: 20),
              const Text(
                'Lesson Complete!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.lesson.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 26),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '+25 XP',
                      style: const TextStyle(
                        color: AppColors.warning,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.score} / ${widget.total} correct',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Keep practicing to improve your English.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Continue Learning',
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
