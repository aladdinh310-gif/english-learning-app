import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../grammar/presentation/screens/grammar_screen.dart';
import '../listening/presentation/screens/listening_screen.dart';
import '../vocabulary/presentation/screens/vocabulary_screen.dart';
import '../progress/data/progress_data.dart';
import 'reading_screen.dart';
import 'speaking_screen.dart';

class PracticeHubScreen extends StatelessWidget {
  const PracticeHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Practice',
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
            'Build confidence with focused practice.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 22),
          _practiceCard(
            context,
            icon: Icons.mic_none_outlined,
            title: 'Speaking',
            description: 'Have level-based conversations with speech feedback.',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SpeakingScreen()),
            ),
          ),
          const SizedBox(height: 14),
          _practiceCard(
            context,
            icon: Icons.translate_outlined,
            title: 'Vocabulary',
            description: 'Review useful words and practise pronunciation.',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VocabularyScreen()),
            ),
          ),
          const SizedBox(height: 14),
          _practiceCard(
            context,
            icon: Icons.spellcheck_outlined,
            title: 'Grammar',
            description: 'Build accurate sentences with focused questions.',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GrammarScreen()),
            ),
          ),
          const SizedBox(height: 14),
          _practiceCard(
            context,
            icon: Icons.headphones_outlined,
            title: 'Listening',
            description: 'Listen to level-based lessons and transcripts.',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ListeningScreen()),
            ),
          ),
          const SizedBox(height: 14),
          _practiceCard(
            context,
            icon: Icons.menu_book_outlined,
            title: 'Reading',
            description: 'Read level-based texts and test comprehension.',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReadingScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _practiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class PracticeScreen extends StatefulWidget {
  final String level;
  final String lessonTitle;
  final void Function(int score, int total)? onCompleted;

  const PracticeScreen({
    super.key,
    required this.level,
    required this.lessonTitle,
    this.onCompleted,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int currentQuestion = 0;
  int selectedAnswer = -1;
  int score = 0;
  bool showResult = false;
  bool isFinished = false;

  List<Map<String, dynamic>> get questions => _getQuestions();

  void checkAnswer() {
    if (selectedAnswer == -1 || showResult) return;
    setState(() {
      showResult = true;
      if (selectedAnswer == questions[currentQuestion]['correct']) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestion == questions.length - 1) {
      setState(() {
        isFinished = true;
      });
      ProgressManager.instance.recordQuizCompleted(
        score: score,
        total: questions.length,
      );
      final onCompleted = widget.onCompleted;
      if (onCompleted != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            onCompleted(score, questions.length);
          }
        });
      }
      return;
    }

    setState(() {
      currentQuestion++;
      selectedAnswer = -1;
      showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isFinished) return _buildFinalResult(context);

    final question = questions[currentQuestion];
    final answers = question['answers'] as List<String>;
    final correctAnswer = question['correct'] as int;
    final isCorrect = selectedAnswer == correctAnswer;

    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Practice',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.level} • ${widget.lessonTitle}',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${currentQuestion + 1} of ${questions.length}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Score: $score',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: (currentQuestion + 1) / questions.length,
              backgroundColor: AppColors.divider,
              color: AppColors.primary,
              minHeight: 7,
              borderRadius: BorderRadius.circular(8),
            ),

            const SizedBox(height: 24),

            Text(
              question['question'] as String,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (question['translation'] != null) ...[
              const SizedBox(height: 8),
              Text(
                question['translation'] as String,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],

            const SizedBox(height: 24),

            ...List.generate(
              answers.length,
              (index) => _answerCard(index, answers[index]),
            ),

            const Spacer(),

            if (showResult)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isCorrect
                      ? 'Correct! ${answers[correctAnswer]} is the right answer.'
                      : 'Not quite. The correct answer is ${answers[correctAnswer]}',
                  style: TextStyle(
                    color: isCorrect ? AppColors.success : AppColors.error,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: selectedAnswer == -1
                    ? null
                    : showResult
                    ? nextQuestion
                    : checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.divider,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  showResult && currentQuestion == questions.length - 1
                      ? 'Finish'
                      : showResult
                      ? 'Next Question'
                      : 'Check Answer',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _answerCard(int index, String answer) {
    final bool isSelected = selectedAnswer == index;

    return GestureDetector(
      onTap: showResult
          ? null
          : () {
              setState(() {
                selectedAnswer = index;
              });
            },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : AppColors.divider,
              ),
              child: Text(
                String.fromCharCode(65 + index),
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                answer,
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

  Widget _buildFinalResult(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Practice Complete',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events_outlined,
              color: AppColors.primary,
              size: 64,
            ),
            const SizedBox(height: 20),
            const Text(
              'Great work!',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your final score is $score/${questions.length}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Finish',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getQuestions() {
    final questions = _questionsForLesson();
    return questions ?? _fallbackQuestions();
  }

  List<Map<String, dynamic>>? _questionsForLesson() {
    switch ('${widget.level}:${widget.lessonTitle}') {
      case 'A1:Greetings':
        return _set([
          _q('How do you greet someone in the morning?', [
            'Good night',
            'Good morning',
            'Goodbye',
            'See you later',
          ], 1),
          _q('What do you say when you meet someone for the first time?', [
            'Nice to meet you',
            'Good night',
            'See you later',
            'No problem',
          ], 0),
          _q('Which phrase asks about a person’s health?', [
            'What is your name?',
            'Where are you?',
            'How are you?',
            'Good evening',
          ], 2),
          _q('What can you say before leaving?', [
            'Hello',
            'Goodbye',
            'Good morning',
            'Nice to meet you',
          ], 1),
          _q('What is a friendly response to “How are you?”', [
            'I’m fine, thank you.',
            'Goodbye.',
            'My name is Ali.',
            'Good night.',
          ], 0),
        ]);
      case 'A1:Introducing Yourself':
        return _set([
          _q('Which sentence tells someone your name?', [
            'I am fine.',
            'My name is Sara.',
            'Good morning.',
            'See you soon.',
          ], 1),
          _q('How do you ask someone where they are from?', [
            'What is your name?',
            'How old are you?',
            'Where are you from?',
            'How are you?',
          ], 2),
          _q('Complete: “I ___ from Egypt.”', ['am', 'is', 'are', 'be'], 0),
          _q('What is a polite answer to “Nice to meet you”?', [
            'Nice to meet you too.',
            'I am from Cairo.',
            'Good night.',
            'I am twelve.',
          ], 0),
          _q('Which sentence gives your age?', [
            'I live in Amman.',
            'I am thirteen years old.',
            'My name is Omar.',
            'I like tea.',
          ], 1),
        ]);
      case 'A1:Numbers & Time':
        return _set([
          _q('What number comes after nine?', [
            'Eight',
            'Ten',
            'Seven',
            'Twelve',
          ], 1),
          _q('How do you ask about the time?', [
            'What time is it?',
            'What is your name?',
            'Where is it?',
            'How are you?',
          ], 0),
          _q('What time is 7:00?', [
            'Seven o’clock',
            'Eight o’clock',
            'Half past seven',
            'Seven thirty',
          ], 0),
          _q('Which day comes after Monday?', [
            'Sunday',
            'Tuesday',
            'Friday',
            'Saturday',
          ], 1),
          _q('How many days are in one week?', [
            'Five',
            'Six',
            'Seven',
            'Ten',
          ], 2),
        ]);
      case 'A1:At the Café':
        return _set([
          _q('What do you say when you want coffee?', [
            'I’d like a coffee, please.',
            'Goodbye coffee.',
            'Where are you?',
            'I am coffee.',
          ], 0),
          _q('What do you ask to see before ordering?', [
            'The menu',
            'The passport',
            'The ticket',
            'The bedroom',
          ], 0),
          _q('Which phrase asks for the price?', [
            'How much is it?',
            'What is your name?',
            'How old is it?',
            'Where are you from?',
          ], 0),
          _q('What do you ask for after eating?', [
            'The bill, please.',
            'A boarding pass.',
            'A lesson.',
            'A suitcase.',
          ], 0),
          _q('Which word means a drink made from tea leaves?', [
            'Coffee',
            'Tea',
            'Bread',
            'Rice',
          ], 1),
        ]);
      case 'A1:Daily Activities':
        return _set([
          _q('What do you usually do after waking up?', [
            'Have breakfast',
            'Go to bed',
            'Buy a ticket',
            'Say goodbye to sleep',
          ], 0),
          _q('Complete: “I ___ to school every day.”', [
            'go',
            'goes',
            'going',
            'went',
          ], 0),
          _q('When do people usually sleep?', [
            'In the morning',
            'At night',
            'At lunch',
            'At noon only',
          ], 1),
          _q('Which activity can you do in the evening?', [
            'Watch television',
            'Buy a passport',
            'Check in',
            'Order a ticket',
          ], 0),
          _q('What do you do when you are hungry?', [
            'Eat a meal',
            'Take a ticket',
            'Open a passport',
            'Say hello',
          ], 0),
        ]);
      case 'A2:Everyday Conversations':
        return _set([
          _q('What is a casual way to ask “How are you?”', [
            "How's it going?",
            'What is your passport?',
            'How much is it?',
            'Where is the hotel?',
          ], 0),
          _q('What does “I’m just relaxing” mean?', [
            'I am resting.',
            'I am travelling.',
            'I am shopping.',
            'I am working late.',
          ], 0),
          _q('Which phrase means you do not have a problem?', [
            'Of course.',
            'No problem.',
            'See you soon.',
            'What do you mean?',
          ], 1),
          _q('Complete: “What are you ___?”', [
            'doing',
            'do',
            'does',
            'done',
          ], 0),
          _q('What can you say before seeing someone again soon?', [
            'See you soon.',
            'Good night forever.',
            'I am a student.',
            'How much?',
          ], 0),
        ]);
      case 'A2:Shopping':
        return _set([
          _q('What do you say when you want to know the price?', [
            'How much is this?',
            'How are you?',
            'Where do you live?',
            'See you later.',
          ], 0),
          _q('Which phrase asks to wear clothing before buying it?', [
            'Can I try it on?',
            'Can I book a flight?',
            'Can I see the menu?',
            'Can I meet you?',
          ], 0),
          _q('What do you ask if the clothing is too small?', [
            'Do you have a larger size?',
            'Do you have a passport?',
            'Is the hotel nearby?',
            'Are you relaxing?',
          ], 0),
          _q('What does “I’ll take it” mean in a shop?', [
            'I will buy it.',
            'I will return it.',
            'I will wash it.',
            'I will describe it.',
          ], 0),
          _q('What do you ask for after paying?', [
            'A receipt',
            'A boarding pass',
            'A conversation',
            'A reservation',
          ], 0),
        ]);
      case 'A2:Travel':
        return _set([
          _q('Where do you usually check in before a flight?', [
            'At the check-in desk',
            'At the hotel room',
            'At the café',
            'At the meeting',
          ], 0),
          _q('What document do you show before boarding a plane?', [
            'A boarding pass',
            'A menu',
            'A receipt',
            'A report',
          ], 0),
          _q('What does “luggage” mean?', [
            'Bags for travelling',
            'A plane ticket',
            'A hotel room',
            'A passport office',
          ], 0),
          _q('Where do you sleep when travelling?', [
            'At a hotel',
            'At a boarding pass',
            'At a security check',
            'At a ticket',
          ], 0),
          _q('What do you need to enter another country?', [
            'A passport',
            'A menu',
            'A receipt',
            'A schedule',
          ], 0),
        ]);
      case 'A2:Past Events':
        return _set([
          _q('Which word tells us an event happened before today?', [
            'Tomorrow',
            'Yesterday',
            'Next week',
            'Soon',
          ], 1),
          _q('Complete: “We ___ a film last week.”', [
            'watched',
            'watch',
            'will watch',
            'watching',
          ], 0),
          _q('Which sentence is about the past?', [
            'I went to the museum.',
            'I will go tomorrow.',
            'I am going now.',
            'I go every day.',
          ], 0),
          _q('Complete: “She ___ a new book yesterday.”', [
            'bought',
            'buy',
            'buys',
            'will buy',
          ], 0),
          _q('Which word means “had a good time”?', [
            'Visited',
            'Enjoyed',
            'Went',
            'Saw',
          ], 1),
        ]);
      case 'A2:Future Plans':
        return _set([
          _q('Which word refers to the day after today?', [
            'Yesterday',
            'Tomorrow',
            'Last week',
            'Ago',
          ], 1),
          _q('Complete: “I am ___ to study tonight.”', [
            'going',
            'went',
            'goes',
            'gone',
          ], 0),
          _q('Which word can introduce a future decision?', [
            'Will',
            'Watched',
            'Yesterday',
            'Bought',
          ], 0),
          _q('Complete: “They plan to ___ next summer.”', [
            'travel',
            'travelled yesterday',
            'travels now',
            'travelling yesterday',
          ], 0),
          _q('Which phrase refers to the week after this week?', [
            'Last week',
            'Next week',
            'Yesterday',
            'At the moment',
          ], 1),
        ]);
      case 'B1:Real Conversations':
        return _set([
          _q('Which response naturally answers “How was your weekend?”', [
            'It was great; I met some friends.',
            'It is a passport.',
            'At three o’clock.',
            'No, I am a manager.',
          ], 0),
          _q('What does “We should do it again soon” express?', [
            'A future suggestion',
            'A past event',
            'A complaint',
            'A price',
          ], 0),
          _q('Which question asks for more detail about an activity?', [
            'What did you do?',
            'How much is it?',
            'What is your name?',
            'Where is the airport?',
          ], 0),
          _q('Which reply agrees with “That sounds like fun”?', [
            'It was.',
            'No, it is a passport.',
            'Yesterday morning.',
            'I am from Spain.',
          ], 0),
          _q('Which phrase keeps a conversation friendly?', [
            'That sounds interesting.',
            'Close the door immediately.',
            'This is the wrong ticket.',
            'I do not understand numbers.',
          ], 0),
        ]);
      case 'B1:Expressing Opinions':
        return _set([
          _q('Which phrase is used to give your opinion?', [
            'In my opinion...',
            'See you later.',
            'Good morning.',
            'Take a seat.',
          ], 0),
          _q('Which phrase shows agreement?', [
            'I agree.',
            'I do not agree.',
            'I am not sure about that.',
            'What do you mean?',
          ], 0),
          _q('Which phrase politely shows uncertainty?', [
            "I'm not sure about that.",
            'I strongly believe.',
            'That is impossible.',
            'Goodbye.',
          ], 0),
          _q('What can you say when someone makes a useful observation?', [
            "That's a good point.",
            'See you tomorrow.',
            'I need a ticket.',
            'It is two o’clock.',
          ], 0),
          _q('Which phrase introduces a personal belief?', [
            'I believe...',
            'I bought...',
            'I went...',
            'I am boarding...',
          ], 0),
        ]);
      case 'B1:Storytelling':
        return _set([
          _q('Which word usually starts the first event in a story?', [
            'First',
            'Finally',
            'Suddenly',
            'Although',
          ], 0),
          _q('Which word introduces the next event?', [
            'Then',
            'Because',
            'Finally',
            'Although',
          ], 0),
          _q('What does “suddenly” show?', [
            'An unexpected event',
            'The final result only',
            'A person’s job',
            'A price',
          ], 0),
          _q('Which word shows a reason?', [
            'Because',
            'Then',
            'First',
            'Finally',
          ], 0),
          _q('Which word commonly ends a sequence of events?', [
            'Finally',
            'Although',
            'Because',
            'Then',
          ], 0),
        ]);
      case 'B1:Work & Career':
        return _set([
          _q('What is a job?', [
            'Work that a person does',
            'A holiday',
            'A suitcase',
            'A greeting',
          ], 0),
          _q('What do you discuss in an interview?', [
            'Your experience and skills',
            'Your boarding pass',
            'A café menu',
            'The weather only',
          ], 0),
          _q('Who usually leads a team at work?', [
            'A manager',
            'A ticket',
            'A client card',
            'A passenger',
          ], 0),
          _q('Who works with you in the same organization?', [
            'A colleague',
            'A passport',
            'A reservation',
            'A deadline',
          ], 0),
          _q('What is a career?', [
            'A person’s working life',
            'A single meeting',
            'A shopping receipt',
            'A travel bag',
          ], 0),
        ]);
      case 'B1:Social English':
        return _set([
          _q('Which phrase is useful when meeting someone new?', [
            'Nice to meet you.',
            'The deadline is Friday.',
            'I strongly believe.',
            'The flight is delayed.',
          ], 0),
          _q('Which question can help make a plan?', [
            'Are you free this weekend?',
            'What is your passport number?',
            'How much is this shirt?',
            'Where is the check-in desk?',
          ], 0),
          _q('Which phrase invites someone?', [
            'Would you like to join us?',
            'I am under the weather.',
            'The report was completed.',
            'I went yesterday.',
          ], 0),
          _q('Which response accepts an invitation?', [
            'That sounds great!',
            'I cannot agree with the evidence.',
            'It costs an arm and a leg.',
            'First, then, finally.',
          ], 0),
          _q('Which is a polite way to decline?', [
            "I'd love to, but I can't.",
            'No, leave now.',
            'That is my passport.',
            'I strongly believe.',
          ], 0),
        ]);
      case 'B2:Advanced Conversations':
        return _set([
          _q('What does “make a lasting effect” mean?', [
            'Create a result that continues',
            'Spend money quickly',
            'End a conversation',
            'Buy a ticket',
          ], 0),
          _q(
            'Which reply naturally completes “Have you considered changing your routine?”',
            [
              'Yes, I have been trying to exercise more.',
              'It is next to the entrance.',
              'Good morning, my name is Ali.',
              'I would like a receipt.',
            ],
            0,
          ),
          _q('What does “provided that” mean?', [
            'On the condition that',
            'Because of yesterday',
            'At the same time as',
            'In place of',
          ], 0),
          _q('Which phrase introduces a thoughtful opinion?', [
            'In my view',
            'How much is this?',
            'See you later',
            'Good night',
          ], 0),
          _q('What can small changes have?', [
            'A lasting effect',
            'A boarding pass',
            'A larger size',
            'A receipt',
          ], 0),
        ]);
      case 'B2:Debates':
        return _set([
          _q('Which phrase strongly introduces an opinion?', [
            'I strongly believe...',
            'See you soon.',
            'I am just relaxing.',
            'Good evening.',
          ], 0),
          _q('Which phrase acknowledges an opposing idea?', [
            'I see your point, but...',
            'I will take it.',
            'What is your name?',
            'I am fine.',
          ], 0),
          _q('Which connector presents a contrast?', [
            'However...',
            'Because...',
            'Yesterday...',
            'Finally...',
          ], 0),
          _q('Which phrase introduces a different side?', [
            'On the other hand...',
            'At the airport...',
            'How much is this?',
            'Nice to meet you.',
          ], 0),
          _q('What does “That’s a valid argument” communicate?', [
            'Respect for a reasonable point',
            'Refusal to listen',
            'A travel plan',
            'A shopping request',
          ], 0),
        ]);
      case 'B2:Idioms':
        return _set([
          _q("What does 'piece of cake' mean?", [
            'Something very easy',
            'A type of food',
            'Something expensive',
            'Something dangerous',
          ], 0),
          _q("What does 'break the ice' mean?", [
            'Start a friendly conversation',
            'Break a window',
            'End a meeting',
            'Feel ill',
          ], 0),
          _q("If someone is 'under the weather', how do they feel?", [
            'Slightly ill',
            'Very wealthy',
            'Extremely early',
            'Very hungry',
          ], 0),
          _q("What does 'once in a blue moon' mean?", [
            'Very rarely',
            'Every evening',
            'Very loudly',
            'Without thinking',
          ], 0),
          _q("If something 'costs an arm and a leg', what is it?", [
            'Very expensive',
            'Very easy',
            'Free',
            'Made of food',
          ], 0),
        ]);
      case 'B2:Professional English':
        return _set([
          _q('What is a deadline?', [
            'The time by which work must be finished',
            'A team member',
            'A presentation slide',
            'A client’s address',
          ], 0),
          _q('What do you give to a client?', [
            'A professional report or presentation',
            'A boarding pass',
            'A café menu',
            'A personal passport',
          ], 0),
          _q('What does responsibility mean at work?', [
            'A duty you are expected to handle',
            'A holiday plan',
            'A shopping size',
            'A casual greeting',
          ], 0),
          _q('What is feedback?', [
            'Comments that help improve work',
            'A travel ticket',
            'A job interview room',
            'A project deadline',
          ], 0),
          _q('What should you check before a meeting?', [
            'The schedule',
            'The idiom',
            'The boarding pass only',
            'The weather yesterday',
          ], 0),
        ]);
      case 'B2:Natural Speaking':
        return _set([
          _q('Which expression gives you time to think?', [
            'Let me think...',
            'Goodbye forever.',
            'How much is it?',
            'I am from Cairo.',
          ], 0),
          _q('Which expression introduces a correction or fact?', [
            'Actually...',
            'See you later.',
            'Good morning.',
            'I will take it.',
          ], 0),
          _q('What does “It depends” communicate?', [
            'The answer changes according to the situation',
            'The answer is always no',
            'The speaker is leaving',
            'The price is cheap',
          ], 0),
          _q('Which phrase clarifies your meaning?', [
            'What I mean is...',
            'Under the weather...',
            'Break the ice...',
            'At the airport...',
          ], 0),
          _q('Which word can soften the start of a reply?', [
            'Well...',
            'Passport...',
            'Deadline...',
            'Yesterday...',
          ], 0),
        ]);
      case 'C1:Advanced Vocabulary':
        return _set([
          _q('What does “coherent” mean?', [
            'Clear and logically connected',
            'Very expensive',
            'Difficult to carry',
            'Happening rarely',
          ], 0),
          _q('What does “substantial” mean?', [
            'Large or important in amount',
            'Unwilling to help',
            'Easy to break',
            'Not connected',
          ], 0),
          _q('What does “inevitable” mean?', [
            'Certain to happen',
            'Impossible to explain',
            'Easy to avoid',
            'Very informal',
          ], 0),
          _q('What does “versatile” describe?', [
            'Useful in many different ways',
            'Always late',
            'Unable to change',
            'Only academic',
          ], 0),
          _q('What does “reluctant” mean?', [
            'Not willing to do something',
            'Very confident',
            'Clearly connected',
            'Large in amount',
          ], 0),
        ]);
      case 'C1:Complex Grammar':
        return _set([
          _q('Which sentence uses a conditional?', [
            'If I had known, I would have helped.',
            'The report was completed.',
            'She said she was tired.',
            'This is the book I borrowed.',
          ], 0),
          _q('Which sentence uses the passive voice?', [
            'The report was completed by the team.',
            'The team completed the report.',
            'The team is completing work.',
            'Complete the report.',
          ], 0),
          _q('Which sentence contains a relative clause?', [
            'The book, which I borrowed, is fascinating.',
            'I read the book yesterday.',
            'The book is blue.',
            'Please read the book.',
          ], 0),
          _q('Which sentence uses reported speech?', [
            'She said that she was tired.',
            'She is tired now.',
            'She feels tired.',
            'She will rest.',
          ], 0),
          _q('Which sentence uses a modal verb correctly?', [
            'You should have told me earlier.',
            'You told should me earlier.',
            'You earlier should told me.',
            'You have should tell me.',
          ], 0),
        ]);
      case 'C1:Academic English':
        return _set([
          _q('Which word is commonly used in academic writing?', [
            'Consequently',
            'Yeah',
            'Cool',
            'Hey',
          ], 0),
          _q('What does “analyze” mean?', [
            'Examine something in detail',
            'Agree immediately',
            'Travel abroad',
            'Finish a meeting',
          ], 0),
          _q('What is evidence?', [
            'Information that supports an idea',
            'A casual greeting',
            'A future plan',
            'A type of luggage',
          ], 0),
          _q('What is a conclusion?', [
            'A final judgment or summary',
            'The first question',
            'A work schedule',
            'A shopping receipt',
          ], 0),
          _q('Which word means “important or meaningful”?', [
            'Significant',
            'Suddenly',
            'Relaxing',
            'Friendly',
          ], 0),
        ]);
      case 'C1:Fluent Conversations':
        return _set([
          _q('What challenge do the speakers discuss?', [
            'Managing growth in cities',
            'Buying a shirt',
            'Learning greetings',
            'Booking a hotel',
          ], 0),
          _q('What can make housing difficult?', [
            'Unaffordable prices',
            'A good presentation',
            'A short conversation',
            'A boarding pass',
          ], 0),
          _q('What solution do they mention?', [
            'Reliable and accessible public transport',
            'More shopping receipts',
            'Fewer vocabulary words',
            'A later meeting',
          ], 0),
          _q('What does “provided that” mean in the conversation?', [
            'On the condition that',
            'For example',
            'At the same time',
            'In contrast',
          ], 0),
          _q('What would the proposed solution benefit?', [
            'The city beyond transportation',
            'Only one passenger',
            'Only a café',
            'No one',
          ], 0),
        ]);
      case 'C1:Master English':
        return _set([
          _q('What does “by and large” mean?', [
            'Generally',
            'Suddenly',
            'Very rarely',
            'At great expense',
          ], 0),
          _q('What does “take costs into account” mean?', [
            'Consider the costs',
            'Pay no costs',
            'Hide the costs',
            'Increase the costs',
          ], 0),
          _q('What does “in light of the evidence” mean?', [
            'Considering the evidence',
            'Without any evidence',
            'Before researching',
            'Ignoring the conclusion',
          ], 0),
          _q('According to the reading, what has technology transformed?', [
            'The way people communicate',
            'The cost of flights',
            'The size of classrooms',
            'The weather',
          ], 0),
          _q('What does meaningful understanding require?', [
            'Patience, context, and considering other perspectives',
            'Only speed',
            'A larger vocabulary list',
            'A travel reservation',
          ], 0),
        ]);
    }
    return null;
  }

  List<Map<String, dynamic>> _fallbackQuestions() {
    final beginner = widget.level == 'A1' || widget.level == 'A2';
    return _set([
      _q(
        beginner
            ? 'Which phrase is a polite greeting?'
            : 'Which phrase gives a clear opinion?',
        beginner
            ? ['Hello', 'Deadline', 'Evidence', 'Although']
            : ['In my opinion...', 'Boarding pass', 'Good night', 'Receipt'],
        0,
      ),
      _q(
        beginner
            ? 'Which word describes something happening now?'
            : 'Which word connects a reason?',
        beginner
            ? ['Today', 'Yesterday', 'Tomorrow', 'Last week']
            : ['Because', 'Ticket', 'Manager', 'Goodbye'],
        0,
      ),
      _q('Which answer is written in English?', [
        'Hello',
        'مرحبا',
        'شكرا',
        'مع السلامة',
      ], 0),
      _q('Which phrase is useful in a conversation?', [
        'That sounds good.',
        'Boarding pass',
        'Yesterday only',
        'The conclusion',
      ], 0),
      _q('Which answer is a complete sentence?', [
        'I am learning English.',
        'English learning?',
        'Learning.',
        'English!',
      ], 0),
    ]);
  }

  List<Map<String, dynamic>> _set(List<Map<String, dynamic>> items) => items;

  Map<String, dynamic> _q(
    String question,
    List<String> answers,
    int correct, {
    String? translation,
  }) {
    return {
      'question': question,
      'answers': answers,
      'correct': correct,
      'translation': translation,
    };
  }
}
