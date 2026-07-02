import 'package:audioplayers/audioplayers.dart';

class MathSoundService {
  final AudioPlayer _player = AudioPlayer();

  // Make sure these match the filenames in your assets/sounds/ folder
  void playCorrect() async {
    await _player.play(AssetSource('sounds/correct.mp3'));
  }

  void playWrong() async {
    await _player.play(AssetSource('sounds/wrong.mp3'));
  }
}
