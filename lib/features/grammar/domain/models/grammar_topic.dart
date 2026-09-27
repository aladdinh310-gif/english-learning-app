class GrammarQuestion {
  const GrammarQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

class GrammarTopic {
  const GrammarTopic({
    required this.level,
    required this.title,
    required this.explanation,
    required this.example,
    required this.progress,
    required this.questions,
  });

  final String level;
  final String title;
  final String explanation;
  final String example;
  final double progress;
  final List<GrammarQuestion> questions;
}
