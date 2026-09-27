enum LessonActivity { reading, speaking }

class Lesson {
  const Lesson({
    required this.level,
    required this.levelTitle,
    required this.category,
    required this.title,
    required this.description,
    required this.estimatedMinutes,
    required this.whatYouWillLearn,
    required this.vocabularyCount,
    required this.grammarFocus,
    required this.activity,
    required this.passage,
    required this.importantVocabulary,
  });

  final String level;
  final String levelTitle;
  final String category;
  final String title;
  final String description;
  final int estimatedMinutes;
  final List<String> whatYouWillLearn;
  final int vocabularyCount;
  final String grammarFocus;
  final LessonActivity activity;
  final String passage;
  final List<String> importantVocabulary;
}

class LessonData {
  LessonData._();

  static const levels = [
    ('A1', 'Beginner'),
    ('A2', 'Elementary'),
    ('B1', 'Intermediate'),
    ('B2', 'Upper Intermediate'),
    ('C1', 'Advanced'),
  ];

  static const categories = [
    ('Vocabulary', 'Learn useful everyday words', 'translate_outlined'),
    ('Grammar', 'Build correct English sentences', 'spellcheck_outlined'),
    ('Listening', 'Improve your listening skills', 'headphones_outlined'),
    ('Speaking', 'Practice speaking naturally', 'mic_none_outlined'),
    ('Conversation', 'Practice real conversations', 'chat_bubble_outline'),
    ('Reading', 'Read and understand English', 'menu_book_outlined'),
  ];

  static const lessons = <Lesson>[
    Lesson(
      level: 'A1',
      levelTitle: 'Beginner',
      category: 'Vocabulary',
      title: 'Greetings and Introductions',
      description: 'Learn how to greet people and introduce yourself.',
      estimatedMinutes: 10,
      whatYouWillLearn: [
        'introduce yourself',
        "ask someone's name",
        'say where you are from',
        'use simple greetings',
      ],
      vocabularyCount: 12,
      grammarFocus: 'The verb “to be” in simple sentences',
      activity: LessonActivity.reading,
      passage: 'Hello! My name is Alex. I am from Canada. I live in Toronto with my family. I work at a small company. In my free time, I like playing football.',
      importantVocabulary: ['hello', 'name', 'from', 'family', 'free time'],
    ),
    Lesson(
      level: 'A1',
      levelTitle: 'Beginner',
      category: 'Speaking',
      title: 'At the Café',
      description: 'Practice ordering a drink and speaking politely.',
      estimatedMinutes: 12,
      whatYouWillLearn: [
        'order a drink',
        'ask for the price',
        'use polite requests',
      ],
      vocabularyCount: 15,
      grammarFocus: 'Can I have...? and polite requests',
      activity: LessonActivity.speaking,
      passage: '',
      importantVocabulary: ['menu', 'coffee', 'please', 'price', 'thank you'],
    ),
    Lesson(
      level: 'A1',
      levelTitle: 'Beginner',
      category: 'Reading',
      title: 'My Daily Routine',
      description: 'Read about a simple day and understand the main actions.',
      estimatedMinutes: 10,
      whatYouWillLearn: [
        'describe daily activities',
        'find key details',
        'use simple present verbs',
      ],
      vocabularyCount: 14,
      grammarFocus: 'Simple present for daily routines',
      activity: LessonActivity.reading,
      passage: 'I wake up at seven o’clock. I have breakfast with my family and go to school by bus. In the afternoon, I do my homework. In the evening, I read a book and go to bed at ten.',
      importantVocabulary: [
        'wake up',
        'breakfast',
        'school',
        'homework',
        'evening',
      ],
    ),
    Lesson(
      level: 'A2',
      levelTitle: 'Elementary',
      category: 'Reading',
      title: 'Weekend Plans',
      description: 'Talk and read about plans for the weekend.',
      estimatedMinutes: 12,
      whatYouWillLearn: [
        'talk about future plans',
        'understand arrangements',
        'use going to',
      ],
      vocabularyCount: 18,
      grammarFocus: 'Going to for plans',
      activity: LessonActivity.reading,
      passage: 'This weekend, I am going to visit my cousin. We are going to walk around the city and try a new restaurant. On Sunday, I will stay home and prepare for work.',
      importantVocabulary: [
        'weekend',
        'visit',
        'cousin',
        'restaurant',
        'prepare',
      ],
    ),
    Lesson(
      level: 'A2',
      levelTitle: 'Elementary',
      category: 'Vocabulary',
      title: 'Shopping',
      description: 'Learn useful language for shops and prices.',
      estimatedMinutes: 10,
      whatYouWillLearn: [
        'ask about prices',
        'describe clothes',
        'make a choice',
      ],
      vocabularyCount: 20,
      grammarFocus: 'Countable and uncountable nouns',
      activity: LessonActivity.reading,
      passage: 'Maya needs a new jacket. She goes to a shop and finds a blue jacket. It is comfortable and not too expensive, so she buys it.',
      importantVocabulary: [
        'jacket',
        'comfortable',
        'expensive',
        'shop',
        'buy',
      ],
    ),
    Lesson(
      level: 'B1',
      levelTitle: 'Intermediate',
      category: 'Reading',
      title: 'Goals and Experiences',
      description: 'Read about goals and explain experiences clearly.',
      estimatedMinutes: 15,
      whatYouWillLearn: [
        'describe personal goals',
        'explain past experiences',
        'give supporting details',
      ],
      vocabularyCount: 24,
      grammarFocus: 'Present perfect and past experiences',
      activity: LessonActivity.reading,
      passage: 'Nadia has always wanted to learn another language. She has joined an evening course and has already made several new friends. Her goal is to use English confidently at work.',
      importantVocabulary: [
        'goal',
        'experience',
        'confidently',
        'course',
        'already',
      ],
    ),
    Lesson(
      level: 'B2',
      levelTitle: 'Upper Intermediate',
      category: 'Conversation',
      title: 'Technology',
      description: 'Discuss how technology changes the way we communicate.',
      estimatedMinutes: 18,
      whatYouWillLearn: [
        'express an opinion',
        'support an argument',
        'consider another viewpoint',
      ],
      vocabularyCount: 28,
      grammarFocus: 'Linking ideas with although, however, and therefore',
      activity: LessonActivity.speaking,
      passage: '',
      importantVocabulary: [
        'impact',
        'privacy',
        'convenient',
        'reliable',
        'access',
      ],
    ),
    Lesson(
      level: 'C1',
      levelTitle: 'Advanced',
      category: 'Conversation',
      title: 'Critical Thinking',
      description: 'Explore complex ideas and develop a balanced argument.',
      estimatedMinutes: 20,
      whatYouWillLearn: [
        'evaluate different perspectives',
        'qualify an argument',
        'respond to counterpoints',
      ],
      vocabularyCount: 32,
      grammarFocus: 'Hedging and nuanced academic language',
      activity: LessonActivity.speaking,
      passage: '',
      importantVocabulary: [
        'perspective',
        'assumption',
        'evidence',
        'nuanced',
        'consequence',
      ],
    ),
  ];

  static List<Lesson> forLevel(String level) {
    final matches = lessons.where((lesson) => lesson.level == level).toList();
    return matches.isEmpty
        ? lessons.where((lesson) => lesson.level == 'A1').toList()
        : matches;
  }

  static List<Lesson> forCategory(String level, String category) {
    final matches = lessons
        .where((lesson) => lesson.level == level && lesson.category == category)
        .toList();
    return matches.isEmpty ? forLevel(level) : matches;
  }
}
