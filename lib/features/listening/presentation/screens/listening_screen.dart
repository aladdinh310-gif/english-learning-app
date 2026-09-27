import 'package:flutter/material.dart';

import '../../../../core/data/mock_learning_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/listening_data.dart';
import '../../domain/models/listening_lesson.dart';
import '../widgets/listening_lesson_card.dart';
import 'listening_player_screen.dart';

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({
    super.key,
    this.level = MockLearningData.currentLevel,
  });

  final String level;

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  late String _selectedLevel = widget.level;

  @override
  Widget build(BuildContext context) {
    final lessons = ListeningData.forLevel(_selectedLevel);
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Listening',
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
            'Listen carefully and understand more English.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 20),
          _levelSelector(),
          const SizedBox(height: 22),
          for (final lesson in lessons) ...[
            ListeningLessonCard(
              lesson: lesson,
              onTap: () => _openPlayer(lesson),
            ),
            const SizedBox(height: 12),
          ],
          if (lessons.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Center(
                child: Text(
                  'Listening lessons are being prepared for this level.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _levelSelector() {
    const levels = ['A1', 'A2', 'B1', 'B2', 'C1'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final level in levels)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(level),
                selected: level == _selectedLevel,
                onSelected: (_) => setState(() => _selectedLevel = level),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                side: BorderSide.none,
                labelStyle: TextStyle(
                  color: level == _selectedLevel
                      ? AppColors.onPrimary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openPlayer(ListeningLesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ListeningPlayerScreen(lesson: lesson)),
    );
  }
}
