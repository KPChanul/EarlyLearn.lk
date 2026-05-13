/*  import 'package:audioplayers/audioplayers.dart';

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
 */
import 'package:audioplayers/audioplayers.dart';

/// Manages all audio playback for the game.
/// OOP: Encapsulation — AudioPlayer is kept private inside this class.
class AudioManager {
  final AudioPlayer _player = AudioPlayer(); // private field (encapsulation)

  /// Plays the word associated with the current question.
  Future<void> playWord(String audioPath) async {
    await _player.play(AssetSource(audioPath));
  }

  /// Plays a success or failure sound effect based on answer correctness.
  /// OOP: Polymorphic behaviour — same method, different outcome per input.
  Future<void> playSfx(bool isCorrect) async {
    final sfxPath = isCorrect ? 'audio/success.mp3' : 'audio/wrong.mp3';
    await _player.play(AssetSource(sfxPath));
  }

  /// Releases audio resources. Always call this in dispose().
  void dispose() {
    _player.dispose();
  }
}
