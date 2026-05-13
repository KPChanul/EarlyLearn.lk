import 'package:audioplayers/audioplayers.dart';

// Encapsulation 
class AudioManager {
  final AudioPlayer _player = AudioPlayer(); // encapsulation

  /// Plays the word associated with the current question.
  Future<void> playWord(String audioPath) async {
    await _player.play(AssetSource(audioPath));
  }

  // Plays a success or failure sound effect based on answer correctness.
  //Polymorphic behaviour
  Future<void> playSfx(bool isCorrect) async {
    final sfxPath = isCorrect ? 'audio/success.mp3' : 'audio/wrong.mp3';
    await _player.play(AssetSource(sfxPath));
  }

  //Releases audio resources
  void dispose() {
    _player.dispose();
  }
}
