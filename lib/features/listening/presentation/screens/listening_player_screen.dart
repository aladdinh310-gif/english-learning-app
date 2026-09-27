import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../screens/practice_screen.dart';
import '../../data/listening_audio_service.dart';
import '../../domain/models/listening_lesson.dart';
import '../../../progress/data/progress_data.dart';

class ListeningPlayerScreen extends StatefulWidget {
  const ListeningPlayerScreen({super.key, required this.lesson});

  final ListeningLesson lesson;

  @override
  State<ListeningPlayerScreen> createState() => _ListeningPlayerScreenState();
}

class _ListeningPlayerScreenState extends State<ListeningPlayerScreen> {
  late final ListeningAudioService _audioService;
  late final Future<bool> _loadFuture;
  bool _showTranscript = false;
  bool _completionRecorded = false;

  @override
  void initState() {
    super.initState();
    _audioService = ListeningAudioService();
    _loadFuture = _audioService.load(widget.lesson.audioAsset);
  }

  @override
  void dispose() {
    _audioService.stop();
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Listening Player',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Row(
            children: [
              _badge(widget.lesson.level),
              const SizedBox(width: 10),
              Text(
                widget.lesson.difficulty,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            widget.lesson.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.lesson.description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 26),
          FutureBuilder<bool>(
            future: _loadFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return _playerCard(
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }
              if (snapshot.data != true) {
                return _audioUnavailableCard();
              }
              return _playerCard(child: _loadedPlayer());
            },
          ),
          const SizedBox(height: 22),
          SwitchListTile(
            value: _showTranscript,
            onChanged: (value) => setState(() => _showTranscript = value),
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.primary,
            title: const Text(
              'Show transcript',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (_showTranscript) ...[
            const SizedBox(height: 8),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transcript',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.lesson.transcript,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 22),
          const Text(
            'Vocabulary',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final word in widget.lesson.vocabulary)
                Chip(
                  label: Text(word),
                  backgroundColor: AppColors.surface,
                  side: BorderSide.none,
                ),
            ],
          ),
          const SizedBox(height: 26),
          PrimaryButton(
            label: 'Take Quiz',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PracticeScreen(
                  level: widget.lesson.level,
                  lessonTitle: widget.lesson.title,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadedPlayer() {
    return StreamBuilder<PlayerState>(
      stream: _audioService.player.playerStateStream,
      builder: (context, stateSnapshot) {
        final playerState = stateSnapshot.data;
        final isPlaying = playerState?.playing ?? false;
        final isCompleted =
            playerState?.processingState == ProcessingState.completed;
        if (isCompleted && !_completionRecorded) {
          _completionRecorded = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ProgressManager.instance.recordListeningCompleted();
            }
          });
        }
        return StreamBuilder<Duration>(
          stream: _audioService.player.positionStream,
          initialData: Duration.zero,
          builder: (context, positionSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;
            return StreamBuilder<Duration?>(
              stream: _audioService.player.durationStream,
              initialData: widget.lesson.duration,
              builder: (context, durationSnapshot) {
                final duration =
                    durationSnapshot.data ?? widget.lesson.duration;
                final safePosition = position > duration ? duration : position;
                final value = duration.inMilliseconds == 0
                    ? 0.0
                    : (safePosition.inMilliseconds / duration.inMilliseconds)
                          .clamp(0.0, 1.0);
                return Column(
                  children: [
                    Icon(
                      isPlaying
                          ? Icons.graphic_eq_rounded
                          : Icons.headphones_rounded,
                      color: AppColors.primary,
                      size: 64,
                    ),
                    const SizedBox(height: 18),
                    Slider(
                      value: value,
                      onChanged: (next) {
                        _audioService.seek(duration * next);
                      },
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.divider,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatTime(safePosition)),
                        Text(_formatTime(duration)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    IconButton(
                      onPressed: () {
                        if (isCompleted) {
                          _audioService.seek(Duration.zero);
                          _audioService.play();
                        } else if (isPlaying) {
                          _audioService.pause();
                        } else {
                          _audioService.play();
                        }
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                      ),
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 32,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _audioUnavailableCard() {
    return _playerCard(
      child: Column(
        children: [
          const Icon(
            Icons.audiotrack_outlined,
            color: AppColors.warning,
            size: 52,
          ),
          const SizedBox(height: 12),
          const Text(
            'Audio unavailable',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please add the required audio file to the assets/audio folder.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            widget.lesson.audioAsset,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => setState(() => _showTranscript = true),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
            ),
            child: const Text('Continue with transcript'),
          ),
        ],
      ),
    );
  }

  Widget _playerCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(22),
      constraints: const BoxConstraints(minHeight: 190),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _badge(String level) {
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

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
