import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  final AudioPlayer _sfxPlayer = AudioPlayer();

  Future<void> playCorrectSound() async {
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('sounds/correct.mp3'));
  }

  Future<void> playWrongSound() async {
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('sounds/wrong.mp3'));
  }
}
