import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'practice_screen.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({
    super.key,
    required this.level,
    required this.levelTitle,
  });

  final String level;
  final String levelTitle;

  @override
  Widget build(BuildContext context) {
    final lessons = _getLessons();

    return Scaffold(
      backgroundColor: AppColors.backgroundStart,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          '$level • $levelTitle',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Your Lessons',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Complete each lesson to improve your English.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),

          const SizedBox(height: 24),

          ...List.generate(lessons.length, (index) {
            final lesson = lessons[index];

            return _lessonCard(
              context,
              number: index + 1,
              title: lesson['title']!,
              description: lesson['description']!,
              isLocked: index > 0,
            );
          }),
        ],
      ),
    );
  }

  Widget _lessonCard(
    BuildContext context, {
    required int number,
    required String title,
    required String description,
    required bool isLocked,
  }) {
    return GestureDetector(
      onTap: isLocked
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonContentScreen(
                    level: level,
                    lessonTitle: title,
                    lessonNumber: number,
                  ),
                ),
              );
            },

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),

        child: Row(
          children: [
            // Lesson number
            Container(
              width: 52,
              height: 52,

              decoration: BoxDecoration(
                color: isLocked
                    ? AppColors.divider
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),

              child: Center(
                child: isLocked
                    ? const Icon(
                        Icons.lock_outline,
                        color: AppColors.textSecondary,
                      )
                    : Text(
                        '$number',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 16),

            // Lesson information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lesson $number',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              isLocked ? Icons.lock_outline : Icons.arrow_forward_ios_rounded,
              size: 17,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getLessons() {
    switch (level) {
      case 'A1':
        return [
          {
            'title': 'Greetings',
            'description': 'Learn basic greetings and introductions.',
          },
          {
            'title': 'Introducing Yourself',
            'description': 'Talk about your name and where you are from.',
          },
          {
            'title': 'Numbers & Time',
            'description': 'Learn numbers, dates and telling the time.',
          },
          {
            'title': 'At the Café',
            'description': 'Learn useful English for ordering food.',
          },
          {
            'title': 'Daily Activities',
            'description': 'Talk about your everyday routine.',
          },
        ];

      case 'A2':
        return [
          {
            'title': 'Everyday Conversations',
            'description': 'Practice common daily conversations.',
          },
          {
            'title': 'Shopping',
            'description': 'Learn useful English for shopping.',
          },
          {'title': 'Travel', 'description': 'Learn English for travelling.'},
          {
            'title': 'Past Events',
            'description': 'Talk about things that happened.',
          },
          {
            'title': 'Future Plans',
            'description': 'Talk about your plans and intentions.',
          },
        ];

      case 'B1':
        return [
          {
            'title': 'Real Conversations',
            'description': 'Understand and practice natural conversations.',
          },
          {
            'title': 'Expressing Opinions',
            'description': 'Learn how to give your opinion.',
          },
          {
            'title': 'Storytelling',
            'description': 'Learn to tell stories clearly.',
          },
          {
            'title': 'Work & Career',
            'description': 'Practice English for work situations.',
          },
          {
            'title': 'Social English',
            'description': 'Communicate naturally with other people.',
          },
        ];

      case 'B2':
        return [
          {
            'title': 'Advanced Conversations',
            'description': 'Practice longer and more natural conversations.',
          },
          {'title': 'Debates', 'description': 'Express and defend your ideas.'},
          {
            'title': 'Idioms',
            'description': 'Understand common English expressions.',
          },
          {
            'title': 'Professional English',
            'description': 'Improve your English for professional situations.',
          },
          {
            'title': 'Natural Speaking',
            'description': 'Speak more naturally and confidently.',
          },
        ];

      case 'C1':
        return [
          {
            'title': 'Advanced Vocabulary',
            'description': 'Build a strong advanced vocabulary.',
          },
          {
            'title': 'Complex Grammar',
            'description': 'Master advanced grammar structures.',
          },
          {
            'title': 'Academic English',
            'description': 'Practice formal and academic English.',
          },
          {
            'title': 'Fluent Conversations',
            'description': 'Practice complex real-life conversations.',
          },
          {
            'title': 'Master English',
            'description': 'Challenge yourself with advanced English.',
          },
        ];

      default:
        return [
          {
            'title': 'Getting Started',
            'description': 'Start your English learning journey.',
          },
        ];
    }
  }
}

class LessonContentScreen extends StatelessWidget {
  const LessonContentScreen({
    super.key,
    required this.level,
    required this.lessonTitle,
    required this.lessonNumber,
  });

  final String level;
  final String lessonTitle;
  final int lessonNumber;

  @override
  Widget build(BuildContext context) {
    final content = _lessonContent();
    final vocabulary = content['vocabulary'] as List<Map<String, String>>?;
    final examples = content['examples'] as List<Map<String, String>>?;
    final idioms = content['idioms'] as List<Map<String, String>>?;
    final grammar = content['grammar'] as List<Map<String, String>>?;
    final conversation = content['conversation'] as List<String>?;
    final questions = content['questions'] as List<String>?;

    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          '$level • Lesson $lessonNumber',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lessonTitle,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content['description'] as String,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 28),
            if (vocabulary != null) ...[
              _sectionTitle('Vocabulary'),
              const SizedBox(height: 12),
              _wordList(vocabulary),
              const SizedBox(height: 28),
            ],
            if (examples != null) ...[
              _sectionTitle('Examples'),
              const SizedBox(height: 12),
              for (final example in examples) ...[
                _exampleCard(example),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 18),
            ],
            if (grammar != null) ...[
              _sectionTitle('Grammar Examples'),
              const SizedBox(height: 12),
              for (final item in grammar) ...[
                _exampleCard(item),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 18),
            ],
            if (idioms != null) ...[
              _sectionTitle('Idioms'),
              const SizedBox(height: 12),
              for (final idiom in idioms) ...[
                _idiomCard(idiom),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 18),
            ],
            if (conversation != null) ...[
              _sectionTitle('Conversation'),
              const SizedBox(height: 12),
              _conversationCard(conversation),
              const SizedBox(height: 28),
            ],
            if (content['reading'] != null) ...[
              _sectionTitle('Reading'),
              const SizedBox(height: 12),
              _readingCard(content['reading'] as String),
              const SizedBox(height: 28),
            ],
            if (questions != null) ...[
              _sectionTitle('Comprehension Questions'),
              const SizedBox(height: 12),
              for (var index = 0; index < questions.length; index++)
                _questionCard(index + 1, questions[index]),
              const SizedBox(height: 18),
            ],
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PracticeScreen(
                        level: level,
                        lessonTitle: lessonTitle,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Start Practice',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Map<String, dynamic> _lessonContent() {
    if (level == 'A1' && lessonTitle == 'Greetings') {
      return _content(
        'Learn how to greet people in English.',
        vocabulary: _vocab([
          ['Hello', 'مرحبًا'],
          ['Hi', 'أهلًا'],
          ['Good morning', 'صباح الخير'],
          ['Good afternoon', 'مساء الخير'],
          ['Good evening', 'مساء الخير'],
          ['Goodbye', 'إلى اللقاء'],
          ['See you later', 'أراك لاحقًا'],
          ['How are you?', 'كيف حالك؟'],
          ["I'm fine", 'أنا بخير'],
          ['Nice to meet you', 'سعيد بلقائك'],
        ]),
        conversation: [
          "A: Hello! What's your name?",
          'B: Hi! My name is Ali.',
          'A: Nice to meet you.',
          'B: Nice to meet you too.',
          'A: How are you?',
          "B: I'm fine, thank you.",
        ],
      );
    }

    if (level == 'A2') {
      switch (lessonTitle) {
        case 'Everyday Conversations':
          return _content(
            'Practice common daily conversations.',
            vocabulary: _vocab([
              ["How's it going?", 'كيف تسير الأمور؟'],
              ['What are you doing?', 'ماذا تفعل؟'],
              ["I'm just relaxing.", 'أنا فقط أسترخي.'],
              ['What do you mean?', 'ماذا تقصد؟'],
              ['That sounds good.', 'هذا يبدو جيدًا.'],
              ['See you soon.', 'أراك قريبًا.'],
              ['No problem.', 'لا مشكلة.'],
              ['Of course.', 'بالطبع.'],
            ]),
            conversation: [
              "A: Hey! How's it going?",
              "B: I'm good. How about you?",
              "A: I'm doing well. What are you doing?",
              "B: I'm just relaxing at home.",
              'A: That sounds good.',
              'B: See you soon!',
            ],
          );
        case 'Shopping':
          return _content(
            'Learn useful English for shopping.',
            vocabulary: _vocab([
              ['How much is this?', 'كم سعر هذا؟'],
              ['Can I try it on?', 'هل يمكنني تجربته؟'],
              ['Do you have a larger size?', 'هل لديكم مقاس أكبر؟'],
              ["I'm just looking.", 'أنا فقط أتصفح.'],
              ["It's too expensive.", 'إنه غالي جدًا.'],
              ["I'll take it.", 'سآخذه.'],
              ['Do you accept cards?', 'هل تقبلون البطاقات؟'],
              ['Can I have a receipt?', 'هل يمكنني الحصول على إيصال؟'],
            ]),
            conversation: [
              'A: Excuse me. How much is this shirt?',
              "B: It's twenty dollars.",
              'A: Can I try it on?',
              'B: Of course.',
              'A: Do you have a larger size?',
              'B: Yes, here you are.',
              "A: Great. I'll take it.",
            ],
          );
        case 'Travel':
          return _content(
            'Learn English for travelling.',
            vocabulary: _vocab([
              ['Airport', 'المطار'],
              ['Boarding pass', 'بطاقة الصعود'],
              ['Flight', 'رحلة جوية'],
              ['Luggage', 'أمتعة'],
              ['Passport', 'جواز سفر'],
              ['Hotel', 'فندق'],
              ['Reservation', 'حجز'],
              ['Ticket', 'تذكرة'],
            ]),
            conversation: [
              'A: Excuse me, where is the check-in desk?',
              "B: It's over there.",
              'A: Thank you. Where is the security check?',
              "B: It's next to the entrance.",
              'A: Thanks for your help.',
              "B: You're welcome.",
            ],
          );
        case 'Past Events':
          return _content(
            'Talk about things that happened.',
            examples: _examples([
              ['yesterday', 'I visited my grandmother yesterday.'],
              ['last week', 'We watched a movie last week.'],
              ['visited', 'She visited the museum.'],
              ['watched', 'They watched a football match.'],
              ['went', 'I went to the park.'],
              ['saw', 'We saw a beautiful sunset.'],
              ['bought', 'He bought a new book.'],
              ['enjoyed', 'We enjoyed the weekend.'],
            ]),
          );
        case 'Future Plans':
          return _content(
            'Talk about your plans and intentions.',
            examples: _examples([
              ['tomorrow', 'I will call you tomorrow.'],
              ['next week', 'We are travelling next week.'],
              ['plan', 'My plan is to study tonight.'],
              ['going to', 'I am going to visit my family.'],
              ['will', 'She will help us.'],
              ['visit', 'They will visit the new museum.'],
              ['study', 'I am going to study English.'],
              ['travel', 'We will travel in the summer.'],
            ]),
          );
      }
    }

    if (level == 'B1') {
      switch (lessonTitle) {
        case 'Real Conversations':
          return _content(
            'Understand and practice natural conversations.',
            conversation: [
              'A: How was your weekend?',
              'B: It was great. I met some friends.',
              'A: What did you do?',
              'B: We had dinner and talked for hours.',
              'A: That sounds like fun.',
              'B: It was. We should do it again soon.',
            ],
          );
        case 'Expressing Opinions':
          return _content(
            'Learn how to give your opinion.',
            vocabulary: _vocab([
              ['I think...', 'أعتقد...'],
              ['In my opinion...', 'في رأيي...'],
              ['I believe...', 'أؤمن بأن...'],
              ['I agree.', 'أوافق.'],
              ["I don't agree.", 'لا أوافق.'],
              ["I'm not sure about that.", 'لست متأكدًا من ذلك.'],
              ["That's a good point.", 'هذه نقطة جيدة.'],
            ]),
          );
        case 'Storytelling':
          return _content(
            'Learn to tell stories clearly.',
            vocabulary: _vocab([
              ['first', 'أولًا'],
              ['then', 'ثم'],
              ['after that', 'بعد ذلك'],
              ['suddenly', 'فجأة'],
              ['finally', 'أخيرًا'],
              ['because', 'لأن'],
              ['although', 'على الرغم من أن'],
            ]),
          );
        case 'Work & Career':
          return _content(
            'Practice English for work situations.',
            vocabulary: _vocab([
              ['job', 'وظيفة'],
              ['career', 'مسيرة مهنية'],
              ['interview', 'مقابلة'],
              ['experience', 'خبرة'],
              ['skills', 'مهارات'],
              ['manager', 'مدير'],
              ['colleague', 'زميل'],
              ['meeting', 'اجتماع'],
            ]),
          );
        case 'Social English':
          return _content(
            'Communicate naturally with other people.',
            vocabulary: _vocab([
              ['Nice to meet you.', 'للقاء أشخاص جدد'],
              ['Are you free this weekend?', 'لوضع خطط'],
              ['Would you like to join us?', 'لدعوة شخص'],
              ['That sounds great!', 'لقبول دعوة'],
              ["I'd love to, but I can't.", 'للرفض بأدب'],
            ]),
          );
      }
    }

    if (level == 'B2') {
      switch (lessonTitle) {
        case 'Advanced Conversations':
          return _content(
            'Practice longer and more natural conversations.',
            conversation: [
              'A: Have you considered changing your daily routine?',
              'B: Yes, I have been trying to make more time for exercise.',
              'A: That sounds sensible. What has worked so far?',
              'B: Walking to work has made a surprising difference.',
              'A: Small changes can have a lasting effect.',
              'B: Exactly. I already feel more energetic.',
            ],
          );
        case 'Debates':
          return _content(
            'Express and defend your ideas.',
            vocabulary: _vocab([
              ['I strongly believe...', 'أؤمن بشدة...'],
              ['From my perspective...', 'من وجهة نظري...'],
              ['I see your point, but...', 'أفهم وجهة نظرك، لكن...'],
              ['However...', 'ومع ذلك...'],
              ['On the other hand...', 'من ناحية أخرى...'],
              ["That's a valid argument.", 'هذه حجة وجيهة.'],
            ]),
          );
        case 'Idioms':
          return _content(
            'Understand common English expressions.',
            idioms: [
              {
                'term': 'Break the ice',
                'meaning': 'Start a friendly conversation.',
                'example': 'A joke helped break the ice.',
              },
              {
                'term': 'Piece of cake',
                'meaning': 'Something very easy.',
                'example': 'The test was a piece of cake.',
              },
              {
                'term': 'Under the weather',
                'meaning': 'Feeling slightly ill.',
                'example': "I'm under the weather today.",
              },
              {
                'term': 'Once in a blue moon',
                'meaning': 'Very rarely.',
                'example': 'We eat out once in a blue moon.',
              },
              {
                'term': 'Hit the nail on the head',
                'meaning': 'Describe something exactly.',
                'example': 'You hit the nail on the head.',
              },
              {
                'term': 'Cost an arm and a leg',
                'meaning': 'Be very expensive.',
                'example': 'That car costs an arm and a leg.',
              },
            ],
          );
        case 'Professional English':
          return _content(
            'Improve your English for professional situations.',
            vocabulary: _vocab([
              ['schedule', 'جدول زمني'],
              ['deadline', 'موعد نهائي'],
              ['project', 'مشروع'],
              ['presentation', 'عرض تقديمي'],
              ['client', 'عميل'],
              ['report', 'تقرير'],
              ['responsibility', 'مسؤولية'],
              ['feedback', 'ملاحظات'],
            ]),
          );
        case 'Natural Speaking':
          return _content(
            'Speak more naturally and confidently.',
            vocabulary: _vocab([
              ['You know...', 'كما تعلم...'],
              ['Actually...', 'في الواقع...'],
              ['I mean...', 'أعني...'],
              ['Well...', 'حسنًا...'],
              ['Let me think...', 'دعني أفكر...'],
              ['It depends...', 'هذا يعتمد...'],
              ['What I mean is...', 'ما أعنيه هو...'],
            ]),
          );
      }
    }

    if (level == 'C1') {
      switch (lessonTitle) {
        case 'Advanced Vocabulary':
          return _content(
            'Build a strong advanced vocabulary.',
            examples: [
              {
                'term': 'coherent',
                'definition': 'Clear and logically connected.',
                'arabic': 'مترابط',
                'example': 'She gave a coherent explanation.',
              },
              {
                'term': 'substantial',
                'definition': 'Large or important in amount.',
                'arabic': 'كبير أو مهم',
                'example': 'The project requires substantial funding.',
              },
              {
                'term': 'inevitable',
                'definition': 'Certain to happen.',
                'arabic': 'حتمي',
                'example': 'Change is inevitable.',
              },
              {
                'term': 'versatile',
                'definition': 'Useful in many different ways.',
                'arabic': 'متعدد الاستخدامات',
                'example': 'This is a versatile tool.',
              },
              {
                'term': 'reluctant',
                'definition': 'Not willing to do something.',
                'arabic': 'متردد',
                'example': 'He was reluctant to leave.',
              },
            ],
          );
        case 'Complex Grammar':
          return _content(
            'Master advanced grammar structures.',
            grammar: [
              {
                'term': 'Conditionals',
                'example': 'If I had known, I would have helped.',
              },
              {
                'term': 'Passive voice',
                'example': 'The report was completed by the research team.',
              },
              {
                'term': 'Relative clauses',
                'example':
                    'The book, which I borrowed yesterday, is fascinating.',
              },
              {
                'term': 'Reported speech',
                'example': 'She said that she was feeling tired.',
              },
              {
                'term': 'Modal verbs',
                'example': 'You should have told me earlier.',
              },
            ],
          );
        case 'Academic English':
          return _content(
            'Practice formal and academic English.',
            vocabulary: _vocab([
              ['analyze', 'يحلل'],
              ['evaluate', 'يقيّم'],
              ['significant', 'مهم / ذو دلالة'],
              ['evidence', 'دليل'],
              ['research', 'بحث'],
              ['conclusion', 'استنتاج'],
              ['argument', 'حجة'],
              ['consequently', 'وبالتالي'],
            ]),
          );
        case 'Fluent Conversations':
          return _content(
            'Practice complex real-life conversations.',
            conversation: [
              'A: What do you think is the biggest challenge facing cities today?',
              'B: In my view, managing growth without losing community is difficult.',
              'A: I agree, especially when housing becomes unaffordable.',
              'B: Exactly. Local governments need long-term solutions.',
              'A: Public transport could make a significant difference.',
              'B: It could, provided that it is reliable and accessible.',
              'A: That requires investment as well as careful planning.',
              'B: Yes, but the benefits would extend far beyond transportation.',
            ],
          );
        case 'Master English':
          return _content(
            'Challenge yourself with advanced English.',
            examples: [
              {
                'term': 'by and large',
                'example': 'By and large, the plan was successful.',
              },
              {
                'term': 'take something into account',
                'example': 'We must take the costs into account.',
              },
              {
                'term': 'in light of',
                'example':
                    'In light of the evidence, we changed our conclusion.',
              },
            ],
            reading: 'Although technology has transformed the way people communicate, meaningful understanding still depends on patience, context, and the willingness to consider perspectives that differ from our own. In an increasingly connected world, these skills are essential for thoughtful decisions and lasting cooperation.',
            questions: [
              'What has technology transformed?',
              'What does meaningful understanding depend on?',
              'Why are these skills essential in a connected world?',
            ],
          );
      }
    }

    return _content('Explore useful English for this lesson.');
  }

  Map<String, dynamic> _content(
    String description, {
    List<Map<String, String>>? vocabulary,
    List<Map<String, String>>? examples,
    List<String>? conversation,
    List<Map<String, String>>? idioms,
    List<Map<String, String>>? grammar,
    String? reading,
    List<String>? questions,
  }) {
    return {
      'description': description,
      ...?vocabulary == null ? null : {'vocabulary': vocabulary},
      ...?examples == null ? null : {'examples': examples},
      ...?conversation == null ? null : {'conversation': conversation},
      ...?idioms == null ? null : {'idioms': idioms},
      ...?grammar == null ? null : {'grammar': grammar},
      ...?reading == null ? null : {'reading': reading},
      ...?questions == null ? null : {'questions': questions},
    };
  }

  List<Map<String, String>> _vocab(List<List<String>> items) {
    return [
      for (final item in items) {'english': item[0], 'arabic': item[1]},
    ];
  }

  List<Map<String, String>> _examples(List<List<String>> items) {
    return [
      for (final item in items) {'term': item[0], 'example': item[1]},
    ];
  }

  Widget _wordList(List<Map<String, String>> words) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (var index = 0; index < words.length; index++)
            _vocabularyRow(words[index], index, words.length),
        ],
      ),
    );
  }

  Widget _vocabularyRow(Map<String, String> word, int index, int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border: index == total - 1
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            word['english']!,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            word['arabic']!,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _exampleCard(Map<String, String> item) {
    return _detailCard(
      item['term']!,
      item['definition'],
      item['arabic'],
      item['example'],
    );
  }

  Widget _idiomCard(Map<String, String> item) {
    return _detailCard(item['term']!, item['meaning'], null, item['example']);
  }

  Widget _detailCard(
    String title,
    String? detail,
    String? translation,
    String? example,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (translation != null) ...[
            const SizedBox(height: 5),
            Text(
              translation,
              style: const TextStyle(color: AppColors.primary, fontSize: 14),
            ),
          ],
          if (detail != null) ...[
            const SizedBox(height: 8),
            Text(
              detail,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
          if (example != null) ...[
            const SizedBox(height: 8),
            Text(
              'Example: $example',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _conversationCard(List<String> conversation) {
    return _detailCard('Dialogue', null, null, conversation.join('\n'));
  }

  Widget _readingCard(String reading) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        reading,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _questionCard(int number, String question) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$number. $question',
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      ),
    );
  }
}
