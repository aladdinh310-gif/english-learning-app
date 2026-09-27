import 'package:flutter/material.dart';

import '../../../lesson/data/lesson_data.dart';
import '../../../lesson/presentation/screens/lesson_complete_screen.dart';
import '../../../screens/practice_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return PracticeScreen(
      level: lesson.level,
      lessonTitle: lesson.title,
      onCompleted: (score, total) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LessonCompleteScreen(
              lesson: lesson,
              score: score,
              total: total,
            ),
          ),
        );
      },
    );
  }
}
