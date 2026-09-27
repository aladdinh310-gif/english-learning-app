import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../../core/data/mock_learning_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/linear_progress_bar.dart';
import '../../data/vocabulary_data.dart';
import '../../domain/models/vocabulary_word.dart';
import '../widgets/vocabulary_word_card.dart';
import 'vocabulary_detail_screen.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({
    super.key,
    this.level = MockLearningData.currentLevel,
  });

  final String level;

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favorites = {};
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _tts.stop();
    super.dispose();
  }

  List<VocabularyWord> get _filteredWords {
    final query = _query.trim().toLowerCase();
    return VocabularyData.forLevel(widget.level)
        .where(
          (word) =>
              query.isEmpty ||
              word.word.toLowerCase().contains(query) ||
              word.definition.toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> _speak(String text) async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.42);
    await _tts.speak(text);
  }

  void _openWord(VocabularyWord word) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VocabularyDetailScreen(
          word: word,
          isFavorite: _favorites.contains(word.word),
          onFavoriteChanged: (isFavorite) {
            setState(() {
              if (isFavorite) {
                _favorites.add(word.word);
              } else {
                _favorites.remove(word.word);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final words = _filteredWords;
    final total = VocabularyData.forLevel(widget.level).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Vocabulary',
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
          Row(
            children: [
              _levelBadge(widget.level),
              const SizedBox(width: 10),
              const Text(
                'Everyday English',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Search words',
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.clear),
                    ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your progress',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(total * 0.35).round()} / $total learned',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const LinearProgressBar(value: 0.35),
          const SizedBox(height: 22),
          if (words.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Center(
                child: Text(
                  'No words match your search.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            for (final word in words) ...[
              VocabularyWordCard(
                word: word,
                isFavorite: _favorites.contains(word.word),
                onTap: () => _openWord(word),
                onFavorite: () {
                  setState(() {
                    if (_favorites.contains(word.word)) {
                      _favorites.remove(word.word);
                    } else {
                      _favorites.add(word.word);
                    }
                  });
                },
                onSpeak: () => _speak(word.word),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  Widget _levelBadge(String level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        level,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
