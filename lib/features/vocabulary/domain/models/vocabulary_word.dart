class VocabularyWord {
  const VocabularyWord({
    required this.level,
    required this.category,
    required this.word,
    required this.pronunciation,
    required this.partOfSpeech,
    required this.definition,
    required this.example,
    required this.relatedWords,
    this.synonym,
  });

  final String level;
  final String category;
  final String word;
  final String pronunciation;
  final String partOfSpeech;
  final String definition;
  final String example;
  final List<String> relatedWords;
  final String? synonym;
}
