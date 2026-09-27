import 'package:just_audio/just_audio.dart';

class ListeningAudioService {
  ListeningAudioService() : player = AudioPlayer();

  final AudioPlayer player;

  Future<bool> load(String assetPath) async {
    try {
      await player.setAsset(assetPath);
      return true;
    } on Object {
      await player.stop();
      return false;
    }
  }

  Future<void> play() => player.play();

  Future<void> pause() => player.pause();

  Future<void> stop() => player.stop();

  Future<void> seek(Duration position) => player.seek(position);

  Future<void> dispose() => player.dispose();
}
