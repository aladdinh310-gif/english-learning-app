class ListeningLesson {
  const ListeningLesson({
    required this.id,
    required this.level,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.audioAsset,
    required this.transcript,
    required this.duration,
    required this.vocabulary,
    required this.progress,
    required this.completed,
  });

  final String id;
  final String level;
  final String title;
  final String description;
  final String difficulty;
  final String audioAsset;
  final String transcript;
  final Duration duration;
  final List<String> vocabulary;
  final double progress;
  final bool completed;
}
