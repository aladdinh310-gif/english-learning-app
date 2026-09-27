import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart' as stt_result;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../core/theme/app_colors.dart';
import '../progress/data/progress_data.dart';

class SpeakingQuestion {
  final String question;
  final List<String> keywords;
  final List<String> requiredPhrases;
  final int minimumWords;
  final int targetWords;
  final List<String> followUpQuestions;
  final bool requiresReason;
  final bool requiresExample;
  final bool requiresOpinion;

  const SpeakingQuestion({
    required this.question,
    required this.keywords,
    required this.requiredPhrases,
    required this.minimumWords,
    required this.targetWords,
    required this.followUpQuestions,
    this.requiresReason = false,
    this.requiresExample = false,
    this.requiresOpinion = false,
  });
}

class SpeakingConversationLevel {
  final String level;
  final String topic;
  final List<SpeakingQuestion> questions;

  const SpeakingConversationLevel({
    required this.level,
    required this.topic,
    required this.questions,
  });
}

class SpeakingEvaluation {
  final int score;
  final String feedback;
  final String encouragement;
  final bool shouldContinue;

  const SpeakingEvaluation({
    required this.score,
    required this.feedback,
    required this.encouragement,
    required this.shouldContinue,
  });
}

class SpeakingScreen extends StatelessWidget {
  const SpeakingScreen({super.key});

  static const List<Map<String, String>> levels = [
    {
      'level': 'A1',
      'title': 'Beginner',
      'description': 'Practice simple everyday sentences.',
    },
    {
      'level': 'A2',
      'title': 'Elementary',
      'description': 'Practice common conversations.',
    },
    {
      'level': 'B1',
      'title': 'Intermediate',
      'description': 'Speak about everyday topics.',
    },
    {
      'level': 'B2',
      'title': 'Upper Intermediate',
      'description': 'Practice natural and longer conversations.',
    },
    {
      'level': 'C1',
      'title': 'Advanced',
      'description': 'Practice complex conversations and opinions.',
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
          'Speaking',
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
            'Practice speaking English with confidence.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
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
            builder: (_) =>
                SpeakingPracticeScreen(level: level, levelTitle: title),
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
                Icons.mic_none_outlined,
                color: AppColors.primary,
                size: 28,
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

class SpeakingPracticeScreen extends StatefulWidget {
  const SpeakingPracticeScreen({
    super.key,
    required this.level,
    required this.levelTitle,
  });

  final String level;
  final String levelTitle;

  @override
  State<SpeakingPracticeScreen> createState() => _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState extends State<SpeakingPracticeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final List<Map<String, String>> messages = [];

  late final Map<String, SpeakingConversationLevel> _conversations;
  late final List<SpeakingQuestion> _questions;
  int _questionIndex = 0;
  int _followUpIndex = 0;
  bool _isProcessing = false;
  bool _speechReady = false;
  bool _speechInitializing = false;
  bool isListening = false;
  bool isSpeaking = false;
  String recognizedText = '';
  bool _practiceRecorded = false;

  @override
  void initState() {
    super.initState();
    _conversations = _buildConversations();
    _questions =
        _conversations[widget.level]?.questions ??
        _conversations['A1']!.questions;
    _configureTts();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSpeech();
      _pushAppMessage(_questions.first.question);
      _playVoice(_questions.first.question);
    });
  }

  @override
  void dispose() {
    _speech.stop();
    _speech.cancel();
    flutterTts.stop();
    super.dispose();
  }

  SpeakingQuestion get _currentQuestion => _questions[_questionIndex];

  void _pushAppMessage(String text) {
    if (!mounted) return;
    setState(() {
      messages.add({'speaker': 'APP', 'text': text});
    });
  }

  Future<void> _initializeSpeech() async {
    if (_speechInitializing || _speechReady) return;

    if (mounted) {
      setState(() => _speechInitializing = true);
    }

    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          debugPrint('Speech status: $status');
          if (mounted && (status == 'done' || status == 'notListening')) {
            setState(() => isListening = false);
          }
        },
        onError: (error) {
          debugPrint('Speech error: ${error.errorMsg}');
        },
        debugLogging: true,
      );

      if (!mounted) return;
      setState(() => _speechReady = available);
    } catch (e) {
      debugPrint('Speech initialization exception: $e');
      if (!mounted) return;
      setState(() => _speechReady = false);
    } finally {
      if (mounted) {
        setState(() => _speechInitializing = false);
      }
    }
  }

  Future<void> _configureTts() async {
    try {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.42);
      await flutterTts.setPitch(1.0);
      flutterTts.setStartHandler(() {
        if (mounted) setState(() => isSpeaking = true);
      });
      flutterTts.setCompletionHandler(() {
        if (mounted) setState(() => isSpeaking = false);
      });
      flutterTts.setCancelHandler(() {
        if (mounted) setState(() => isSpeaking = false);
      });
      flutterTts.setErrorHandler((_) {
        if (mounted) {
          setState(() => isSpeaking = false);
          _showMessage('Text-to-speech could not play.');
        }
      });
    } catch (_) {
      _showMessage('Text-to-speech is not available.');
    }
  }

  Future<void> _playVoice(String text) async {
    if (text.trim().isEmpty) return;

    try {
      await flutterTts.stop();
      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.42);
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(text);
    } catch (_) {
      _showMessage('Text-to-speech could not play.');
    }
  }

  Future<void> _toggleListening() async {
    if (isListening) {
      await _stopListening();
      return;
    }
    if (isSpeaking) {
      await flutterTts.stop();
    }
    await _startListening();
  }

  Future<void> _startListening() async {
    if (_speechInitializing) {
      _showMessage('Please wait. Speech recognition is initializing.');
      return;
    }

    if (!_speechReady) {
      await _initializeSpeech();
    }

    if (!mounted) return;
    if (!_speechReady) {
      _showMessage('Speech recognition is not available on this device.');
      return;
    }

    if (_speech.isListening) {
      _showMessage('Speech recognition is already listening.');
      return;
    }

    setState(() {
      recognizedText = '';
      isListening = true;
    });

    try {
      await _speech.listen(
        onResult: _onSpeechResult,
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
        ),
      );
    } catch (e) {
      debugPrint('Start listening error: $e');
      if (!mounted) return;
      setState(() => isListening = false);
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    if (!mounted) return;
    setState(() => isListening = false);
  }

  void _onSpeechResult(stt_result.SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() => recognizedText = result.recognizedWords);

    if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
      _handleFinalSpeech(result.recognizedWords);
    }
  }

  Future<void> _handleFinalSpeech(String text) async {
    if (_isProcessing) return;
    _isProcessing = true;

    await _speech.stop();
    final evaluation = _evaluateAnswer(text, _currentQuestion);
    final cleanedText = text.trim();

    if (!mounted) {
      _isProcessing = false;
      return;
    }

    setState(() {
      isListening = false;
      messages.add({'speaker': 'YOU', 'text': cleanedText});
      messages.add({'speaker': 'APP', 'text': evaluation.feedback});
      messages.add({'speaker': 'APP', 'text': evaluation.encouragement});
      recognizedText = '';
    });

    await _playVoice('${evaluation.feedback} ${evaluation.encouragement}');

    final nextPrompt = _nextPromptAfterEvaluation(evaluation.score);
    if (nextPrompt != null && mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      setState(() => messages.add({'speaker': 'APP', 'text': nextPrompt}));
      await _playVoice(nextPrompt);
    }

    _isProcessing = false;
  }

  String? _nextPromptAfterEvaluation(int score) {
    final question = _questions[_questionIndex];
    if (score < 75 && _followUpIndex < question.followUpQuestions.length) {
      final prompt = question.followUpQuestions[_followUpIndex];
      _followUpIndex += 1;
      return prompt;
    }

    _followUpIndex = 0;
    if (_questionIndex < _questions.length - 1) {
      _questionIndex += 1;
      return _questions[_questionIndex].question;
    }

    if (!_practiceRecorded) {
      _practiceRecorded = true;
      ProgressManager.instance.recordSpeakingPractice();
    }
    return 'You have completed the ${widget.level} speaking challenge. Great work. You can try it again to improve your fluency.';
  }

  SpeakingEvaluation _evaluateAnswer(String text, SpeakingQuestion question) {
    final normalized = text.trim().toLowerCase();
    final words = text
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
    final keywordMatches = question.keywords.where(
      (keyword) => normalized.contains(keyword.toLowerCase()),
    );
    final phraseMatches = question.requiredPhrases.where(
      (phrase) => normalized.contains(phrase.toLowerCase()),
    );

    final hasReason =
        !question.requiresReason ||
        normalized.contains('because') ||
        normalized.contains('so ') ||
        normalized.contains('since') ||
        normalized.contains('therefore');
    final hasExample =
        !question.requiresExample ||
        normalized.contains('for example') ||
        normalized.contains('for instance') ||
        normalized.contains('such as');
    final hasOpinion =
        !question.requiresOpinion ||
        normalized.contains('i think') ||
        normalized.contains('in my opinion') ||
        normalized.contains('i believe') ||
        normalized.contains('i feel');

    int score = 30;
    score += words >= question.minimumWords ? 25 : (words * 4).clamp(0, 25);
    if (words >= question.targetWords) {
      score += 15;
    }
    score += (keywordMatches.length * 8).clamp(0, 24);
    score += (phraseMatches.length * 7).clamp(0, 21);
    if (hasReason) score += 10;
    if (hasExample) score += 10;
    if (hasOpinion) score += 10;
    if (normalized.contains('i ') || normalized.contains('my ')) {
      score += 5;
    }
    score = score.clamp(0, 100);

    final needsReason = question.requiresReason && !hasReason;
    final needsExample = question.requiresExample && !hasExample;
    final needsOpinion = question.requiresOpinion && !hasOpinion;
    final hasEnoughDetail =
        words >= question.minimumWords || keywordMatches.isNotEmpty;

    return SpeakingEvaluation(
      score: score,
      feedback: _buildFeedback(
        score: score,
        needsReason: needsReason,
        needsExample: needsExample,
        needsOpinion: needsOpinion,
        hasEnoughDetail: hasEnoughDetail,
        level: widget.level,
      ),
      encouragement: _buildEncouragement(
        score: score,
        needsReason: needsReason,
        needsExample: needsExample,
        needsOpinion: needsOpinion,
        hasEnoughDetail: hasEnoughDetail,
        level: widget.level,
      ),
      shouldContinue: score >= 60,
    );
  }

  String _buildFeedback({
    required int score,
    required bool needsReason,
    required bool needsExample,
    required bool needsOpinion,
    required bool hasEnoughDetail,
    required String level,
  }) {
    if (score >= 85) {
      return _pick(level, {
        'A1': [
          'Nice answer!',
          'Well done!',
          'That is clear!',
          'Great, I understand.',
        ],
        'A2': [
          'That is a clear answer.',
          'Nice detail.',
          'Good explanation.',
          'I understand. Let’s keep going.',
        ],
        'B1': [
          'That is a good explanation.',
          'Interesting point. Your answer is clear.',
          'Your idea is well explained.',
          'That is a useful response.',
        ],
        'B2': [
          'That is a clear position.',
          'Interesting argument. You support it well.',
          'That is a thoughtful answer.',
          'Nice perspective.',
        ],
        'C1': [
          'That is a well-developed idea.',
          'You presented a clear and thoughtful argument.',
          'This is a strong analysis.',
          'Excellent reasoning and structure.',
        ],
      });
    }

    if (needsReason) {
      return 'Your answer is clear, but explain why this matters to you.';
    }
    if (needsExample) {
      return 'Your idea is understandable. Add one example to support it.';
    }
    if (needsOpinion) {
      return 'Your position is clear, but give a stronger opinion with a reason.';
    }
    if (!hasEnoughDetail) {
      return 'Your answer is understandable, but try to add one more detail.';
    }

    if (score >= 65) {
      return _pick(level, {
        'A1': [
          'Nice answer!',
          'That works well.',
          'Good effort!',
          'I understand your idea.',
        ],
        'A2': [
          'That is a clear answer.',
          'Nice! Can you add one more detail?',
          'Good explanation.',
          'That is understandable.',
        ],
        'B1': [
          'That is a good explanation.',
          'Your idea is clear. Add one example.',
          'Good point. Can you explain why?',
          'That is useful information.',
        ],
        'B2': [
          'That is a clear position.',
          'Good argument. Add one example.',
          'Interesting point. Can you support it further?',
          'Your answer is strong, but add more detail.',
        ],
        'C1': [
          'Your idea is clear. Expand it slightly.',
          'That is a solid starting point.',
          'Good reasoning. Add more nuance.',
          'You have a valid argument. Go deeper.',
        ],
      });
    }

    return _pick(level, {
      'A1': [
        'Good start.',
        'Nice try.',
        'Your answer is understandable.',
        'A little more detail will help.',
      ],
      'A2': [
        'Your answer is understandable.',
        'You can add one more detail.',
        'Try to say when and where.',
        'Good start. Add more information.',
      ],
      'B1': [
        'Your answer is clear, but explain why.',
        'Good start. Add one reason.',
        'Try to include an example.',
        'A stronger answer adds detail and support.',
      ],
      'B2': [
        'Your opinion is clear. Add one reason and one example.',
        'You need more support for your point.',
        'Try to explain the advantage or disadvantage.',
        'A stronger answer would include evidence.',
      ],
      'C1': [
        'Your position is clear, but it needs more depth.',
        'This question needs more explanation and nuance.',
        'Add a benefit, a risk, and a counterargument.',
        'Try to build a more complete argument.',
      ],
    });
  }

  String _buildEncouragement({
    required int score,
    required bool needsReason,
    required bool needsExample,
    required bool needsOpinion,
    required bool hasEnoughDetail,
    required String level,
  }) {
    if (score >= 85) {
      return _pick(level, {
        'A1': [
          'Your sentence is simple and correct.',
          'You answered clearly and with the right information.',
          'Great work. Your answer is easy to understand.',
        ],
        'A2': [
          'Your answer is clear and includes useful details.',
          'You used the right tense and added helpful information.',
          'Nice work. Your response is more detailed and natural.',
        ],
        'B1': [
          'Your answer is well organized and easy to follow.',
          'You explained your idea with a clear reason.',
          'That is a strong response with useful support.',
        ],
        'B2': [
          'Your opinion is clear and well supported.',
          'This is a balanced answer with a strong argument.',
          'You gave a thoughtful response with enough detail.',
        ],
        'C1': [
          'That is a well-developed answer with clear reasoning.',
          'You presented a thoughtful position and supported it well.',
          'This response shows strong analysis and good structure.',
        ],
      });
    }

    if (needsReason) {
      return 'You can say why this matters, such as because it helps you improve or gives you more confidence.';
    }
    if (needsExample) {
      return 'Try adding one example, such as a place, event, or person you remember.';
    }
    if (needsOpinion) {
      return 'A stronger response includes your opinion, one reason, and one example.';
    }
    if (!hasEnoughDetail) {
      return _pick(level, {
        'A1': [
          'You could add one simple detail, like your city, your job, or a hobby.',
          'Try saying one more sentence with your city, country, or favorite activity.',
        ],
        'A2': [
          'You could add the time, the place, or who you were with.',
          'Try including one more detail about when, where, or how you felt.',
        ],
        'B1': [
          'Try to explain why it matters and give one example.',
          'Add a reason and a short example to make your answer stronger.',
        ],
        'B2': [
          'A stronger answer includes one advantage, one disadvantage, and an example.',
          'Try adding a benefit, a drawback, and a concrete example.',
        ],
        'C1': [
          'A stronger answer should include one benefit, one risk, and a conclusion.',
          'Consider another perspective and support your point with evidence.',
        ],
      });
    }

    if (score >= 65) {
      return _pick(level, {
        'A1': [
          'You can add another simple detail.',
          'Try saying your city or your hobby.',
        ],
        'A2': [
          'Add one more detail about the time or the place.',
          'Try to say who was there or what happened.',
        ],
        'B1': [
          'Add one reason and one example.',
          'A more complete answer includes why and how.',
        ],
        'B2': [
          'A stronger answer includes your point, a reason, and an example.',
          'Try to mention a benefit and a challenge.',
        ],
        'C1': [
          'Add a second reason and a counterargument.',
          'A deeper answer includes more nuance and evidence.',
        ],
      });
    }

    return _pick(level, {
      'A1': [
        'Try to use a simple sentence with one extra detail.',
        'You can say your name, your city, or your hobby.',
      ],
      'A2': [
        'Use a time word like yesterday, today, or next weekend.',
        'Try to say what happened and when.',
      ],
      'B1': [
        'Try to say why this matters and give an example.',
        'Your answer needs a reason and more detail.',
      ],
      'B2': [
        'Your opinion needs a reason and an example.',
        'Add one advantage, one disadvantage, or a comparison.',
      ],
      'C1': [
        'This question needs a more developed argument.',
        'Add a benefit, a drawback, and a conclusion.',
      ],
    });
  }

  String _pick(String level, Map<String, List<String>> options) {
    final list = options[level] ?? options['B1'] ?? ['Good answer.'];
    final index = (level.length + widget.level.length) % list.length;
    return list[index];
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final topic = _topicForLevel(widget.level);

    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Speaking Practice',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            '$topic • ${widget.level} ${widget.levelTitle}',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Speak English and practice your conversation.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 22),
          _chatMessages(),
          const SizedBox(height: 18),
          _voiceControls(),
          const SizedBox(height: 12),
          Text(
            _speechStatusText(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          if (recognizedText.isNotEmpty) ...[
            const SizedBox(height: 16),
            _recognizedTextCard(),
          ],
        ],
      ),
    );
  }

  Widget _chatMessages() {
    return Column(
      children: [
        for (final message in messages)
          _messageBubble(speaker: message['speaker']!, text: message['text']!),
      ],
    );
  }

  Widget _messageBubble({required String speaker, required String text}) {
    final isApp = speaker == 'APP';
    return Align(
      alignment: isApp ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isApp
              ? AppColors.surface
              : AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isApp ? AppColors.divider : AppColors.primary,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              speaker,
              style: TextStyle(
                color: isApp ? AppColors.primary : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                height: 1.35,
              ),
            ),
            if (isApp) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => _playVoice(text),
                  tooltip: 'Play voice',
                  icon: Icon(
                    isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _voiceControls() {
    return Column(
      children: [
        Material(
          color: isListening ? AppColors.success : AppColors.primary,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: _toggleListening,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 54,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _speechStatusText(),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isSpeaking) ...[
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.volume_up, color: AppColors.primary, size: 18),
              SizedBox(width: 6),
              Text(
                'Speaking...',
                style: TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _speechStatusText() {
    if (_speechInitializing) return 'Initializing microphone...';
    if (_speech.isListening || isListening) return 'Listening...';
    if (!_speechReady) return 'Speech recognition is not available.';
    return 'Tap the microphone and speak.';
  }

  Widget _recognizedTextCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            height: 1.4,
          ),
          children: [
            const TextSpan(
              text: 'You said:\n',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: '"$recognizedText"'),
          ],
        ),
      ),
    );
  }

  Map<String, SpeakingConversationLevel> _buildConversations() {
    return {
      'A1': const SpeakingConversationLevel(
        level: 'A1',
        topic: 'Introducing Yourself',
        questions: [
          SpeakingQuestion(
            question: 'Hello! What is your name?',
            keywords: ['name', 'my name is', 'i am', 'aladdin'],
            requiredPhrases: ['my name is', "i'm"],
            minimumWords: 3,
            targetWords: 6,
            followUpQuestions: ['Nice! Can you tell me your country and city?'],
          ),
          SpeakingQuestion(
            question: 'Where are you from?',
            keywords: ['from', 'rwanda', 'uganda', 'kenya', 'city', 'country'],
            requiredPhrases: ['i am from', "i'm from"],
            minimumWords: 4,
            targetWords: 8,
            followUpQuestions: [
              'Great. Can you say your country and your city?',
            ],
          ),
          SpeakingQuestion(
            question: 'What do you do?',
            keywords: ['student', 'teacher', 'job', 'school', 'work'],
            requiredPhrases: ['i am a', "i'm a", 'i study'],
            minimumWords: 3,
            targetWords: 8,
            followUpQuestions: [
              'Nice. Tell me a little more about your studies or work.',
            ],
          ),
          SpeakingQuestion(
            question: 'What do you like to do in your free time?',
            keywords: [
              'music',
              'football',
              'read',
              'watch',
              'cook',
              'dance',
              'travel',
            ],
            requiredPhrases: ['i like', 'i enjoy'],
            minimumWords: 5,
            targetWords: 10,
            followUpQuestions: ['Good. What is your favorite hobby?'],
          ),
        ],
      ),
      'A2': const SpeakingConversationLevel(
        level: 'A2',
        topic: 'Daily Life and Weekend',
        questions: [
          SpeakingQuestion(
            question: 'What do you usually do in the morning?',
            keywords: [
              'wake up',
              'breakfast',
              'school',
              'work',
              'morning',
              'coffee',
            ],
            requiredPhrases: ['i usually', 'i wake up', 'i have breakfast'],
            minimumWords: 8,
            targetWords: 15,
            followUpQuestions: [
              'Can you add one more detail, such as the time or the food you eat?',
            ],
          ),
          SpeakingQuestion(
            question: 'What did you do last weekend?',
            keywords: [
              'last weekend',
              'visited',
              'watched',
              'went',
              'movie',
              'friend',
              'family',
            ],
            requiredPhrases: [
              'last weekend',
              'i went',
              'i visited',
              'i watched',
            ],
            minimumWords: 8,
            targetWords: 18,
            followUpQuestions: [
              'Good. What did you enjoy most about that day?',
            ],
          ),
          SpeakingQuestion(
            question: 'What are you going to do next weekend?',
            keywords: [
              'next weekend',
              'go',
              'visit',
              'study',
              'party',
              'travel',
              'will',
            ],
            requiredPhrases: ['next weekend', 'i am going to', "i'm going to"],
            minimumWords: 8,
            targetWords: 18,
            followUpQuestions: [
              'Nice. Who are you going with, or where are you going?',
            ],
          ),
          SpeakingQuestion(
            question: 'What do you usually eat for lunch?',
            keywords: [
              'rice',
              'beans',
              'salad',
              'bread',
              'fruit',
              'soup',
              'lunch',
            ],
            requiredPhrases: ['for lunch', 'i usually eat', 'i eat'],
            minimumWords: 7,
            targetWords: 14,
            followUpQuestions: [
              'Good. Do you prefer healthy food or fast food?',
            ],
          ),
        ],
      ),
      'B1': const SpeakingConversationLevel(
        level: 'B1',
        topic: 'Goals, Experiences and Opinions',
        questions: [
          SpeakingQuestion(
            question: 'What is one goal you would like to achieve this year?',
            keywords: [
              'goal',
              'english',
              'improve',
              'travel',
              'job',
              'study',
              'learn',
            ],
            requiredPhrases: ['i want to', 'because', 'so that'],
            minimumWords: 15,
            targetWords: 25,
            followUpQuestions: [
              'Can you explain why this goal is important to you?',
            ],
            requiresReason: true,
          ),
          SpeakingQuestion(
            question: 'What are you doing to achieve that goal?',
            keywords: [
              'study',
              'practice',
              'read',
              'listen',
              'speak',
              'write',
              'learn',
            ],
            requiredPhrases: ['i am', 'i practice', 'because', 'every day'],
            minimumWords: 15,
            targetWords: 25,
            followUpQuestions: [
              'Nice. What has been the most difficult part so far?',
            ],
            requiresReason: true,
          ),
          SpeakingQuestion(
            question: 'Describe a difficult experience you had and how you dealt with it.',
            keywords: [
              'difficult',
              'challenge',
              'problem',
              'learned',
              'stress',
              'worked',
              'solved',
            ],
            requiredPhrases: ['because', 'at first', 'in the end', 'i learned'],
            minimumWords: 20,
            targetWords: 35,
            followUpQuestions: [
              'How did that experience change your way of thinking?',
            ],
            requiresReason: true,
            requiresExample: true,
          ),
          SpeakingQuestion(
            question:
                'What is the best way to improve English speaking skills?',
            keywords: [
              'practice',
              'speaking',
              'listening',
              'reading',
              'writing',
              'conversation',
              'friends',
            ],
            requiredPhrases: [
              'i think',
              'in my opinion',
              'because',
              'for example',
            ],
            minimumWords: 20,
            targetWords: 30,
            followUpQuestions: [
              'Can you give an example of how you practice in real life?',
            ],
            requiresOpinion: true,
            requiresReason: true,
          ),
        ],
      ),
      'B2': const SpeakingConversationLevel(
        level: 'B2',
        topic: 'Technology, Society and Opinions',
        questions: [
          SpeakingQuestion(
            question: 'Do you think social media has improved communication? Why or why not?',
            keywords: [
              'social media',
              'communication',
              'internet',
              'phone',
              'people',
              'friends',
              'message',
            ],
            requiredPhrases: [
              'in my opinion',
              'i think',
              'because',
              'for example',
              'however',
            ],
            minimumWords: 30,
            targetWords: 50,
            followUpQuestions: [
              'Now explain one advantage and one disadvantage of social media.',
            ],
            requiresOpinion: true,
            requiresReason: true,
            requiresExample: true,
          ),
          SpeakingQuestion(
            question: 'Is technology making life easier or more difficult? Explain your view.',
            keywords: [
              'technology',
              'easier',
              'difficult',
              'internet',
              'phones',
              'work',
              'education',
            ],
            requiredPhrases: [
              'on the other hand',
              'however',
              'for example',
              'in my opinion',
            ],
            minimumWords: 30,
            targetWords: 55,
            followUpQuestions: [
              'Give an example from daily life to support your opinion.',
            ],
            requiresOpinion: true,
            requiresReason: true,
            requiresExample: true,
          ),
          SpeakingQuestion(
            question: 'Should students use their phones in class? Give reasons and examples.',
            keywords: [
              'students',
              'phones',
              'class',
              'study',
              'distraction',
              'learning',
              'school',
            ],
            requiredPhrases: ['i believe', 'for example', 'however', 'because'],
            minimumWords: 30,
            targetWords: 50,
            followUpQuestions: ['Now consider the opposite point of view.'],
            requiresOpinion: true,
            requiresReason: true,
            requiresExample: true,
          ),
        ],
      ),
      'C1': const SpeakingConversationLevel(
        level: 'C1',
        topic: 'Complex Issues and Critical Discussion',
        questions: [
          SpeakingQuestion(
            question: 'Artificial intelligence is changing the workplace. Do you think its long-term effects will be mostly positive or negative?',
            keywords: [
              'artificial intelligence',
              'ai',
              'workplace',
              'jobs',
              'automation',
              'technology',
              'efficiency',
            ],
            requiredPhrases: [
              'in my opinion',
              'however',
              'for example',
              'therefore',
              'on the other hand',
            ],
            minimumWords: 50,
            targetWords: 80,
            followUpQuestions: [
              'Can you consider one possible disadvantage and explain how society might respond?',
            ],
            requiresOpinion: true,
            requiresReason: true,
            requiresExample: true,
          ),
          SpeakingQuestion(
            question: 'Should governments do more to protect the environment, even if it reduces economic growth?',
            keywords: [
              'government',
              'environment',
              'climate',
              'growth',
              'jobs',
              'pollution',
              'economy',
            ],
            requiredPhrases: [
              'i believe',
              'however',
              'for example',
              'in contrast',
              'therefore',
            ],
            minimumWords: 50,
            targetWords: 90,
            followUpQuestions: [
              'What would be the strongest argument against your position?',
            ],
            requiresOpinion: true,
            requiresReason: true,
            requiresExample: true,
          ),
          SpeakingQuestion(
            question: 'Is globalization more beneficial or harmful to society in the long term?',
            keywords: [
              'globalization',
              'economy',
              'culture',
              'trade',
              'jobs',
              'technology',
              'society',
            ],
            requiredPhrases: [
              'overall',
              'for instance',
              'however',
              'on balance',
              'therefore',
            ],
            minimumWords: 50,
            targetWords: 90,
            followUpQuestions: [
              'Can you conclude by explaining what needs to be improved in the current system?',
            ],
            requiresOpinion: true,
            requiresReason: true,
            requiresExample: true,
          ),
        ],
      ),
    };
  }

  String _topicForLevel(String level) {
    switch (level) {
      case 'A1':
        return 'Introducing Yourself';
      case 'A2':
        return 'Daily Life and Weekend';
      case 'B1':
        return 'Goals, Experiences and Opinions';
      case 'B2':
        return 'Technology, Society and Opinions';
      case 'C1':
        return 'Complex Issues and Critical Discussion';
      default:
        return 'Speaking Practice';
    }
  }
}
