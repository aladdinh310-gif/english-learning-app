import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  static const List<Map<String, String>> levels = [
    {
      'level': 'A1',
      'title': 'Beginner',
      'description': 'Read short and simple English texts.',
    },
    {
      'level': 'A2',
      'title': 'Elementary',
      'description': 'Practice reading everyday English.',
    },
    {
      'level': 'B1',
      'title': 'Intermediate',
      'description': 'Read longer texts and understand main ideas.',
    },
    {
      'level': 'B2',
      'title': 'Upper Intermediate',
      'description': 'Improve comprehension with detailed texts.',
    },
    {
      'level': 'C1',
      'title': 'Advanced',
      'description': 'Challenge yourself with advanced English.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Reading',
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
            'Choose your level',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Build your comprehension one text at a time.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 22),
          for (final item in levels)
            _levelCard(
              context,
              level: item['level']!,
              title: item['title']!,
              description: item['description']!,
            ),
        ],
      ),
    );
  }

  Widget _levelCard(
    BuildContext context, {
    required String level,
    required String title,
    required String description,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReadingListScreen(level: level, levelTitle: title),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                color: AppColors.primary,
                size: 27,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$level • $title',
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
                  const SizedBox(height: 6),
                  const Text(
                    '5 texts',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class ReadingListScreen extends StatelessWidget {
  const ReadingListScreen({
    super.key,
    required this.level,
    required this.levelTitle,
  });

  final String level;
  final String levelTitle;

  @override
  Widget build(BuildContext context) {
    final titles = _titlesForLevel(level);

    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
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
            'Reading Texts',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose a text and test your understanding.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 22),
          for (var index = 0; index < titles.length; index++)
            _readingCard(context, index + 1, titles[index]),
        ],
      ),
    );
  }

  List<String> _titlesForLevel(String value) {
    switch (value) {
      case 'A1':
        return const [
          'My Daily Routine',
          'My Family',
          'At the Market',
          'My Favorite Food',
          'A Busy Morning',
        ];
      case 'A2':
        return const [
          'A Trip to the City',
          'My Weekend',
          'A New Job',
          'Going Shopping',
          'A Day at the Park',
        ];
      case 'B1':
        return const [
          'Learning from Mistakes',
          'The Importance of Exercise',
          'Life in a Big City',
          'Learning a New Skill',
          'The Value of Friendship',
        ];
      case 'B2':
        return const [
          'Technology in Everyday Life',
          'The Future of Education',
          'Social Media and Communication',
          'Healthy Habits',
          'The Changing Workplace',
        ];
      case 'C1':
        return const [
          'The Impact of Technology',
          'Education and Society',
          'The Psychology of Learning',
          'Global Communication',
          'The Future of Work',
        ];
      default:
        return const ['Getting Started'];
    }
  }

  Widget _readingCard(BuildContext context, int number, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReadingContentScreen(
              level: level,
              levelTitle: levelTitle,
              title: title,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$number',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class ReadingContentScreen extends StatefulWidget {
  const ReadingContentScreen({
    super.key,
    required this.level,
    required this.levelTitle,
    required this.title,
  });

  final String level;
  final String levelTitle;
  final String title;

  @override
  State<ReadingContentScreen> createState() => _ReadingContentScreenState();
}

class _ReadingContentScreenState extends State<ReadingContentScreen> {
  final Map<int, int> selectedAnswers = {};
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    final content = _readingContent(widget.level, widget.title);
    final questions = content['questions'] as List<Map<String, dynamic>>;
    final score = _score(questions);

    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          widget.level,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '${widget.level} • ${widget.levelTitle}',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          _passageCard(content['passage'] as String),
          const SizedBox(height: 28),
          const Text(
            'Comprehension Questions',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          for (var index = 0; index < questions.length; index++)
            _questionCard(index, questions[index]),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: selectedAnswers.length == questions.length
                  ? _checkAnswers
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.divider,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Check Answers',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (checked) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$score / ${questions.length} correct',
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _passageCard(String passage) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        passage,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          height: 1.55,
        ),
      ),
    );
  }

  Widget _questionCard(int index, Map<String, dynamic> question) {
    final answers = question['answers'] as List<String>;
    final selected = selectedAnswers[index];
    final correct = question['correct'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ${question['question']}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          for (var answerIndex = 0; answerIndex < answers.length; answerIndex++)
            _answerOption(
              index,
              answerIndex,
              answers[answerIndex],
              selected,
              correct,
            ),
        ],
      ),
    );
  }

  Widget _answerOption(
    int questionIndex,
    int answerIndex,
    String answer,
    int? selected,
    int correct,
  ) {
    final isSelected = selected == answerIndex;
    final showCorrect = checked && answerIndex == correct;
    final showWrong = checked && isSelected && answerIndex != correct;
    final color = showCorrect
        ? AppColors.success
        : showWrong
        ? AppColors.error
        : isSelected
        ? AppColors.primary
        : AppColors.divider;

    return GestureDetector(
      onTap: checked
          ? null
          : () {
              setState(() {
                selectedAnswers[questionIndex] = answerIndex;
              });
            },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 27,
              height: 27,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : AppColors.divider,
              ),
              child: Text(
                String.fromCharCode(65 + answerIndex),
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                answer,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _score(List<Map<String, dynamic>> questions) {
    return questions.asMap().entries.where((entry) {
      return selectedAnswers[entry.key] == entry.value['correct'];
    }).length;
  }

  void _checkAnswers() {
    setState(() {
      checked = true;
    });
  }

  Map<String, dynamic> _readingContent(String level, String title) {
    final passages = _passages[level] ?? _passages['A1']!;
    final passage = passages[title] ?? passages.values.first;
    return {'passage': passage, 'questions': _questions(level, title)};
  }

  List<Map<String, dynamic>> _questions(String level, String title) {
    final key = '$level:$title';
    return _questionSets[key] ??
        [
          _question('What is the passage mainly about?', [
            'An everyday topic',
            'A sports result',
            'A train schedule',
            'A recipe',
          ], 0),
          _question('Which detail is mentioned in the passage?', [
            'A useful example',
            'A mountain race',
            'A new passport',
            'A music lesson',
          ], 0),
          _question('What does the key idea mean in context?', [
            'It is useful and important',
            'It is very expensive',
            'It is impossible',
            'It is finished',
          ], 0),
        ];
  }

  Map<String, dynamic> _question(
    String question,
    List<String> answers,
    int correct,
  ) {
    return {'question': question, 'answers': answers, 'correct': correct};
  }
}

const Map<String, Map<String, String>> _passages = {
  'A1': {
    'My Daily Routine': 'I wake up at seven o\'clock every morning. I wash my face and have breakfast with my family. Then I walk to school. My classes start at eight o\'clock. In the afternoon, I come home and do my homework. I also play with my little brother. After dinner, I read a short book. I go to bed at ten o\'clock. I like my daily routine because it is simple and comfortable.',
    'My Family': 'My family is small. I live with my mother, father, and sister. My father works in a shop, and my mother is a teacher. My sister is ten years old. We eat dinner together every evening. At the weekend, we visit our grandparents. My grandmother makes delicious bread. I love spending time with my family because everyone is kind and helpful.',
    'At the Market': 'On Saturday morning, I go to the market with my mother. We buy vegetables, fruit, and bread. The market is busy, but it is colorful and friendly. I choose red apples and yellow bananas. My mother talks to the bread seller. Then we carry our bags home. We are tired, but we are happy because we have fresh food for the week.',
    'My Favorite Food': 'My favorite food is pasta. I like it because it is easy to cook and tastes good. My mother makes pasta with tomatoes, cheese, and vegetables. We usually eat it on Friday evening. I also like salad with my meal. After dinner, I drink water and help clean the table. Pasta is simple, warm, and perfect for my family.',
    'A Busy Morning': 'Today I have a busy morning. I get up early because I have a doctor\'s appointment. I make tea and eat a banana. Then I take the bus to the clinic. After the appointment, I go to the library to return two books. I meet my friend there, and we talk for ten minutes. Finally, I go home before lunch.',
  },
  'A2': {
    'A Trip to the City': 'Last Saturday, my cousin and I took a train to the city. We visited a museum, walked through the old streets, and ate lunch in a small restaurant. The city was crowded, but the buildings were beautiful. In the afternoon, we bought a few gifts for our family. We were tired on the way home, yet we enjoyed the trip and plan to return next month.',
    'My Weekend': 'My weekend was relaxing. On Saturday, I cleaned my room and watched a film with my brother. In the evening, some friends visited us, so we cooked dinner together. On Sunday, I went for a long walk and prepared my schoolwork for Monday. I did not travel anywhere, but I felt happy because I had enough time to rest and talk with people I care about.',
    'A New Job': 'Last month, Sara started a new job at a small hotel. At first, she felt nervous because she had to speak with visitors from different countries. Her manager showed her how to answer questions and organize reservations. After two weeks, Sara became more confident. She enjoys meeting guests and learning new expressions. In the future, she hopes to work in a larger hotel abroad.',
    'Going Shopping': 'This afternoon, I am going shopping with my brother. We need a jacket, a notebook, and some fruit. We are going to compare prices before we buy anything. My brother will look for a blue jacket, while I will choose a notebook for school. If we finish early, we will have coffee near the market. We have a clear list, so shopping should be easy.',
    'A Day at the Park': 'Yesterday, our class spent the day at a large park. We played games, ate sandwiches, and watched birds near the lake. Our teacher asked us to keep the park clean, so everyone collected paper and plastic before leaving. The weather was warm but not too hot. We took photographs and talked about visiting the park again in spring.',
  },
  'B1': {
    'Learning from Mistakes': 'Making mistakes can feel uncomfortable, but mistakes often teach us more than success does. When I first learned to cook, I added too much salt to a meal and could not eat it. Instead of giving up, I wrote down what had gone wrong and tried again the next day. Gradually, I learned to measure ingredients and taste the food while cooking. The experience showed me that improvement comes from paying attention, accepting feedback, and trying again with a better plan.',
    'The Importance of Exercise': 'Regular exercise benefits both the body and the mind. People who walk, cycle, or play a sport often have more energy during the day. Exercise can also reduce stress because it gives people time away from screens and busy schedules. It does not have to be difficult or expensive. A short daily walk can improve fitness if it becomes a regular habit. The most successful routine is one that is enjoyable enough to continue.',
    'Life in a Big City': 'Living in a big city offers many opportunities. Residents can find universities, cultural events, restaurants, and jobs in one place. Public transport makes it possible to travel without a car, although buses and trains can become crowded. City life can also feel noisy and expensive, especially for people who need a large home. For many residents, the advantages are worth the challenges because the city connects them with people, ideas, and possibilities.',
    'Learning a New Skill': 'Learning a new skill requires patience and consistent practice. When I decided to learn photography, I expected to take good pictures immediately. Instead, I needed to understand light, composition, and the settings on my camera. I studied examples and practiced in different places. Each mistake gave me useful information. After several months, I could see clear improvement. The experience reminded me that confidence usually follows practice rather than appearing before it.',
    'The Value of Friendship': 'Good friendships are built through trust, attention, and shared experiences. A friend does not need to agree with every decision, but should be able to listen honestly and offer support. Strong friendships also require effort. People may live far apart or have busy schedules, yet regular messages and thoughtful visits can keep a relationship alive. Friendship matters because it gives people a sense of belonging during both easy and difficult periods.',
  },
  'B2': {
    'Technology in Everyday Life': 'Technology has become part of almost every ordinary activity. People use digital tools to communicate, manage money, study, and organize their time. These tools save effort and make information available quickly, but they can also encourage constant distraction. A message that arrives during a conversation may seem urgent even when it is not. Using technology effectively therefore requires boundaries. Turning off unnecessary alerts and choosing specific times to check devices can protect attention without rejecting useful innovation.',
    'The Future of Education': 'Education is likely to become more flexible as digital resources develop. Students can already attend lessons from different locations, review recorded explanations, and use interactive tools to practice difficult ideas. However, technology cannot replace every part of a classroom. Discussion, cooperation, and personal guidance remain important for deep learning. The most effective future may combine convenient online resources with teachers who understand individual needs and help students evaluate information critically.',
    'Social Media and Communication': 'Social media allows people to maintain relationships across considerable distances, yet fast communication is not always meaningful communication. Short posts can remove important context, and algorithms may repeatedly show users opinions similar to their own. As a result, people can become confident in incomplete views of a complicated issue. Responsible users pause before sharing information, check reliable sources, and remember that disagreement does not automatically indicate bad intentions.',
    'Healthy Habits': 'Healthy habits are more sustainable when they are treated as practical routines rather than dramatic promises. Preparing simple meals, sleeping at consistent times, and moving regularly can improve well-being over time. Many people abandon a plan because they expect immediate results or choose goals that do not fit their lives. A smaller habit that can be repeated is often more valuable than an ambitious routine that disappears after a week. Long-term health depends on consistency, flexibility, and informed choices.',
    'The Changing Workplace': 'The modern workplace is changing as organizations adopt remote collaboration, flexible schedules, and new digital systems. These developments can improve access to employment and allow teams to work across borders. They also require employees to communicate clearly and manage their time independently. Managers must create trust without losing accountability, while workers need opportunities to learn unfamiliar tools. Adaptability is becoming less about accepting every change and more about developing the judgment to respond to change thoughtfully.',
  },
  'C1': {
    'The Impact of Technology': 'Technology has transformed contemporary life by altering how people work, communicate, and make decisions. Digital systems can process enormous quantities of information and connect individuals who would otherwise remain distant. Nevertheless, convenience can conceal significant costs. Personal data may be collected without meaningful understanding, while automated recommendations can influence choices in subtle ways. The challenge is not simply to accept or reject technological progress, but to establish habits and policies that preserve autonomy, privacy, and human judgment. Progress is most valuable when its benefits are distributed fairly and its risks are openly examined.',
    'Education and Society': 'Education serves purposes that extend beyond the transfer of knowledge. It enables individuals to participate in civic life, assess competing claims, and contribute creatively to their communities. When access to high-quality education is unequal, social divisions can deepen because opportunity becomes connected to family circumstances rather than ability or effort. Consequently, education policy must consider resources, teacher preparation, and the conditions in which students learn. A society that invests in thoughtful, inclusive education invests in its capacity to solve problems collectively.',
    'The Psychology of Learning': 'Learning is influenced by attention, prior knowledge, emotion, and the expectation that effort will produce progress. A learner who views ability as fixed may interpret difficulty as evidence of failure and withdraw from the task. By contrast, a learner who regards ability as developable is more likely to use feedback productively. This does not mean that motivation alone guarantees success; effective learning also requires suitable strategies, deliberate practice, and opportunities to retrieve information. Understanding these principles allows teachers and learners to design environments in which challenge becomes informative rather than discouraging.',
    'Global Communication': 'Global communication has increased the speed at which ideas, discoveries, and cultural practices circulate. Yet successful communication across borders involves more than translating vocabulary. Participants must recognize differences in assumptions, politeness, historical experience, and the meaning of silence. A phrase that sounds direct in one context may seem aggressive in another. International cooperation therefore depends on curiosity and interpretive patience. Rather than treating one style as universally correct, communicators can ask clarifying questions and create shared meanings through dialogue.',
    'The Future of Work': 'The future of work will be shaped by automation, demographic change, and the continuing development of artificial intelligence. Some tasks will become faster or disappear, while new roles will require skills that combine technical knowledge with creativity, ethical reasoning, and collaboration. Predicting the exact occupations that will exist is less useful than preparing people to adapt throughout their careers. Education systems and employers may need to support continuous learning, not as a temporary response to disruption, but as a permanent feature of professional life.',
  },
};

final Map<String, List<Map<String, dynamic>>> _questionSets = {
  'A1:My Daily Routine': _basicQuestions(
    'What is the passage mainly about?',
    'The writer\'s daily schedule',
    'The writer\'s holiday',
  ),
  'A1:My Family': _basicQuestions(
    'Who does the writer live with?',
    'Their parents and sister',
    'Their teacher',
  ),
  'A1:At the Market': _basicQuestions(
    'What does the writer buy?',
    'Fruit, vegetables, and bread',
    'Books and clothes',
  ),
  'A1:My Favorite Food': _basicQuestions(
    'What food does the writer like best?',
    'Pasta',
    'Rice',
  ),
  'A1:A Busy Morning': _basicQuestions(
    'Why does the writer get up early?',
    'For a doctor\'s appointment',
    'For a football game',
  ),
  'A2:A Trip to the City': _basicQuestions(
    'Where did the writer go?',
    'To the city',
    'To the countryside',
  ),
  'A2:My Weekend': _basicQuestions(
    'How was the writer\'s weekend?',
    'Relaxing',
    'Very dangerous',
  ),
  'A2:A New Job': _basicQuestions(
    'Where does Sara work?',
    'At a hotel',
    'At a school',
  ),
  'A2:Going Shopping': _basicQuestions(
    'What is the writer going to buy?',
    'A jacket, notebook, and fruit',
    'A bicycle and a camera',
  ),
  'A2:A Day at the Park': _basicQuestions(
    'What did the class do at the park?',
    'Played games and watched birds',
    'Built a house',
  ),
  'B1:Learning from Mistakes': _basicQuestions(
    'What does the passage say mistakes can do?',
    'Teach us',
    'Always stop progress',
  ),
  'B1:The Importance of Exercise': _basicQuestions(
    'What can regular exercise reduce?',
    'Stress',
    'The need for sleep',
  ),
  'B1:Life in a Big City': _basicQuestions(
    'What is one advantage of city life?',
    'Many opportunities',
    'No public transport',
  ),
  'B1:Learning a New Skill': _basicQuestions(
    'What helped the writer improve photography?',
    'Practice and study',
    'Avoiding feedback',
  ),
  'B1:The Value of Friendship': _basicQuestions(
    'What helps keep a friendship alive?',
    'Regular contact',
    'Never speaking',
  ),
  'B2:Technology in Everyday Life': _basicQuestions(
    'What does the passage recommend protecting?',
    'Attention',
    'Every notification',
  ),
  'B2:The Future of Education': _basicQuestions(
    'What should future education combine?',
    'Online resources and guidance',
    'Only recorded lessons',
  ),
  'B2:Social Media and Communication': _basicQuestions(
    'What should responsible users do?',
    'Check reliable sources',
    'Share everything immediately',
  ),
  'B2:Healthy Habits': _basicQuestions(
    'What kind of habit is often more valuable?',
    'A repeatable small habit',
    'An impossible routine',
  ),
  'B2:The Changing Workplace': _basicQuestions(
    'What skill is increasingly important?',
    'Adaptability',
    'Avoiding new tools',
  ),
  'C1:The Impact of Technology': _basicQuestions(
    'What challenge does the passage identify?',
    'Balancing progress and risk',
    'Rejecting all information',
  ),
  'C1:Education and Society': _basicQuestions(
    'What can unequal education deepen?',
    'Social divisions',
    'Personal sleep',
  ),
  'C1:The Psychology of Learning': _basicQuestions(
    'What influences learning?',
    'Attention, knowledge, and emotion',
    'Luck alone',
  ),
  'C1:Global Communication': _basicQuestions(
    'What does global communication require?',
    'Interpretive patience',
    'One universal style',
  ),
  'C1:The Future of Work': _basicQuestions(
    'What should education support?',
    'Continuous learning',
    'Only one career skill',
  ),
};

List<Map<String, dynamic>> _basicQuestions(
  String mainQuestion,
  String correctMain,
  String detailDistractor,
) {
  return [
    {
      'question': mainQuestion,
      'answers': [
        correctMain,
        detailDistractor,
        'A shopping list',
        'A weather report',
      ],
      'correct': 0,
    },
    {
      'question': 'Which detail is included in the passage?',
      'answers': [
        detailDistractor,
        'A visit to the moon',
        'A lost passport',
        'A cooking competition',
      ],
      'correct': 0,
    },
    {
      'question': 'What does the key idea mean in context?',
      'answers': [
        'It is useful and important',
        'It is impossible',
        'It is very expensive',
        'It is finished',
      ],
      'correct': 0,
    },
  ];
}
