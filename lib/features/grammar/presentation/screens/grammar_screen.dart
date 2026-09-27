import 'package:flutter/material.dart';

import '../../../../core/data/mock_learning_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/grammar_data.dart';
import '../../domain/models/grammar_topic.dart';
import '../widgets/grammar_topic_card.dart';
import '../../../progress/data/progress_data.dart';

class GrammarScreen extends StatefulWidget {
  const GrammarScreen({super.key, this.level = MockLearningData.currentLevel});

  final String level;

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  late String _selectedLevel = widget.level;

  @override
  Widget build(BuildContext context) {
    final topics = GrammarData.forLevel(_selectedLevel);
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Grammar',
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
            'Build clear, correct English sentences.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 20),
          _levelSelector(),
          const SizedBox(height: 24),
          for (final topic in topics) ...[
            GrammarTopicCard(topic: topic, onTap: () => _openPractice(topic)),
            const SizedBox(height: 12),
          ],
          if (topics.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Center(
                child: Text(
                  'Grammar topics are being prepared for this level.',
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

  void _openPractice(GrammarTopic topic) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GrammarPracticeScreen(topic: topic)),
    );
  }
}

class GrammarPracticeScreen extends StatefulWidget {
  const GrammarPracticeScreen({super.key, required this.topic});

  final GrammarTopic topic;

  @override
  State<GrammarPracticeScreen> createState() => _GrammarPracticeScreenState();
}

class _GrammarPracticeScreenState extends State<GrammarPracticeScreen> {
  int _questionIndex = 0;
  int? _selectedIndex;
  int _score = 0;

  GrammarQuestion get _question => widget.topic.questions[_questionIndex];
  bool get _hasAnswered => _selectedIndex != null;

  void _selectAnswer(int index) {
    if (_hasAnswered) return;
    setState(() {
      _selectedIndex = index;
      if (index == _question.correctIndex) _score++;
    });
  }

  void _next() {
    if (!_hasAnswered) return;
    if (_questionIndex == widget.topic.questions.length - 1) {
      ProgressManager.instance.recordGrammarPractice();
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Practice complete'),
          content: Text(
            'You scored $_score/${widget.topic.questions.length}. Keep practising to build confidence.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('Done'),
            ),
          ],
        ),
      );
      return;
    }
    setState(() {
      _questionIndex++;
      _selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _question;
    final isCorrect = _selectedIndex == question.correctIndex;
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${widget.topic.level} • ${widget.topic.title}',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_questionIndex + 1} of ${widget.topic.questions.length}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  'Score: $_score',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: (_questionIndex + 1) / widget.topic.questions.length,
              minHeight: 7,
              color: AppColors.primary,
              backgroundColor: AppColors.divider,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 28),
            Text(
              question.question,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 22),
            for (var index = 0; index < question.options.length; index++)
              _option(index, question.options[index]),
            const Spacer(),
            if (_hasAnswered)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: (isCorrect ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${isCorrect ? 'Correct!' : 'Not quite.'} ${question.explanation}',
                  style: TextStyle(
                    color: isCorrect ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _hasAnswered ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  disabledBackgroundColor: AppColors.divider,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _questionIndex == widget.topic.questions.length - 1
                      ? 'Finish'
                      : 'Next question',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _option(int index, String option) {
    final selected = _selectedIndex == index;
    final correct = _hasAnswered && index == _question.correctIndex;
    final incorrect = selected && _hasAnswered && !correct;
    final color = correct
        ? AppColors.success
        : incorrect
        ? AppColors.error
        : selected
        ? AppColors.primary
        : AppColors.divider;
    return GestureDetector(
      onTap: () => _selectAnswer(index),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: selected || correct
              ? color.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color,
            width: selected || correct ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: color,
              child: Text(
                String.fromCharCode(65 + index),
                style: TextStyle(
                  color: selected || correct
                      ? AppColors.onPrimary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
