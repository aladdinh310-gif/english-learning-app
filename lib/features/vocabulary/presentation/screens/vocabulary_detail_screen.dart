import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/models/vocabulary_word.dart';
import '../../../progress/data/progress_data.dart';

class VocabularyDetailScreen extends StatefulWidget {
  const VocabularyDetailScreen({
    super.key,
    required this.word,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  final VocabularyWord word;
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;

  @override
  State<VocabularyDetailScreen> createState() => _VocabularyDetailScreenState();
}

class _VocabularyDetailScreenState extends State<VocabularyDetailScreen> {
  final FlutterTts _tts = FlutterTts();
  late bool _isFavorite = widget.isFavorite;

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.42);
    await _tts.speak(widget.word.word);
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.word;
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Word Details',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
              widget.onFavoriteChanged(_isFavorite);
            },
            icon: Icon(
              _isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Center(
            child: Text(
              word.word,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '${word.pronunciation}  •  ${word.partOfSpeech}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: OutlinedButton.icon(
              onPressed: _speak,
              icon: const Icon(Icons.volume_up_outlined),
              label: const Text('Listen'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 22),
          _detailCard('Definition', word.definition),
          const SizedBox(height: 12),
          _detailCard('Example', word.example),
          const SizedBox(height: 12),
          _detailCard('Related words', word.relatedWords.join('  •  ')),
          if (word.synonym != null) ...[
            const SizedBox(height: 12),
            _detailCard('Synonym', word.synonym!),
          ],
          const SizedBox(height: 26),
          PrimaryButton(
            label: 'Practice this word',
            onPressed: () {
              ProgressManager.instance.recordVocabularyPractice();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vocabulary practice recorded.')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _detailCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
