 import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final AudioPlayer _player = AudioPlayer();

  // Plays the word audio    //async - ensures audio is played asynchronously without blocking UI.
  Future<void> playWord(String audioPath) async {
    await _player.play(AssetSource(audioPath));
  }

  // Plays the success or fail sound effect
  Future<void> playSfx(bool isCorrect) async {
    String sfxPath = isCorrect ? 'audio/success.mp3' : 'audio/wrong.mp3';
    await _player.play(AssetSource(sfxPath));
  }

  // Always dispose of players when done
  void dispose() {
    _player.dispose(); //private variable (only accessible inside this class).
  }
} 


