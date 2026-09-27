import '../domain/models/grammar_topic.dart';

class GrammarData {
  GrammarData._();

  static const topics = <GrammarTopic>[
    GrammarTopic(
      level: 'A1',
      title: 'Verb to be',
      explanation: 'Use am, is, and are to describe people and things.',
      example: 'I am a student. She is from Spain.',
      progress: 0.35,
      questions: [
        GrammarQuestion(
          question: 'She ___ from Canada.',
          options: ['am', 'is', 'are', 'be'],
          correctIndex: 1,
          explanation: 'Use “is” with she, he, and it.',
        ),
        GrammarQuestion(
          question: 'They ___ happy today.',
          options: ['is', 'am', 'are', 'be'],
          correctIndex: 2,
          explanation: 'Use “are” with they, we, and you.',
        ),
      ],
    ),
    GrammarTopic(
      level: 'A1',
      title: 'Present Simple',
      explanation: 'Use the present simple for routines and facts.',
      example: 'He works every day. I like tea.',
      progress: 0.2,
      questions: [
        GrammarQuestion(
          question: 'She ___ to work every day.',
          options: ['go', 'goes', 'going', 'gone'],
          correctIndex: 1,
          explanation: 'Add -s to the verb with he, she, or it.',
        ),
        GrammarQuestion(
          question: 'We ___ English on Mondays.',
          options: ['study', 'studies', 'studying', 'studied'],
          correctIndex: 0,
          explanation: 'Use the base verb with we.',
        ),
      ],
    ),
    GrammarTopic(
      level: 'A2',
      title: 'Past Simple',
      explanation: 'Use the past simple for finished actions in the past.',
      example: 'We visited Rome last year.',
      progress: 0.1,
      questions: [
        GrammarQuestion(
          question: 'They ___ a film last night.',
          options: ['watch', 'watches', 'watched', 'watching'],
          correctIndex: 2,
          explanation: '“Watched” is the past simple form of watch.',
        ),
        GrammarQuestion(
          question: 'I ___ my friend yesterday.',
          options: ['see', 'saw', 'seen', 'seeing'],
          correctIndex: 1,
          explanation: '“Saw” is the irregular past form of see.',
        ),
      ],
    ),
    GrammarTopic(
      level: 'B1',
      title: 'Present Perfect',
      explanation: 'Use have or has with a past participle for experiences and recent results.',
      example: 'She has already finished her work.',
      progress: 0.15,
      questions: [
        GrammarQuestion(
          question: 'I ___ never been to Japan.',
          options: ['have', 'has', 'am', 'did'],
          correctIndex: 0,
          explanation: 'Use have with I, you, we, and they.',
        ),
        GrammarQuestion(
          question: 'He has ___ the report.',
          options: ['write', 'wrote', 'written', 'writing'],
          correctIndex: 2,
          explanation: 'The past participle of write is written.',
        ),
      ],
    ),
    GrammarTopic(
      level: 'B2',
      title: 'Passive Voice',
      explanation:
          'Use the passive when the action is more important than the doer.',
      example: 'The bridge was built in 1920.',
      progress: 0.05,
      questions: [
        GrammarQuestion(
          question: 'The documents ___ yesterday.',
          options: ['signed', 'were signed', 'are sign', 'signing'],
          correctIndex: 1,
          explanation: 'Use be + past participle for the past passive.',
        ),
        GrammarQuestion(
          question: 'The results will ___ tomorrow.',
          options: ['announce', 'be announced', 'announced', 'announcing'],
          correctIndex: 1,
          explanation: 'Use will be + past participle for the future passive.',
        ),
      ],
    ),
    GrammarTopic(
      level: 'C1',
      title: 'Hedging',
      explanation:
          'Use cautious language when a statement is not completely certain.',
      example: 'This may suggest that the policy needs review.',
      progress: 0.0,
      questions: [
        GrammarQuestion(
          question: 'The evidence ___ indicate a change in public opinion.',
          options: ['might', 'must to', 'is', 'does'],
          correctIndex: 0,
          explanation: '“Might” introduces a cautious possibility.',
        ),
        GrammarQuestion(
          question: 'It would ___ that more research is needed.',
          options: ['appear', 'appears', 'appearing', 'appeared'],
          correctIndex: 0,
          explanation: 'Use the base verb after would.',
        ),
      ],
    ),
  ];

  static List<GrammarTopic> forLevel(String level) =>
      topics.where((topic) => topic.level == level).toList();
}
