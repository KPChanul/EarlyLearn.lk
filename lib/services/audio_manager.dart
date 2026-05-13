/* import 'package:audioplayers/audioplayers.dart';

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
} */
import 'package:audioplayers/audioplayers.dart';

// ─── AudioManager ─────────────────────────────────────────────────────────────
// Encapsulates all audio playback logic.
// Uses two separate players so word audio and SFX never interrupt each other.

enum SfxType { correct, wrong, gameOver, levelUp }

class AudioManager {
  // ── Private fields (encapsulation) ────────────────────────────────────────
  final AudioPlayer _wordPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer  = AudioPlayer();

  bool _isMuted = false;

  // ── Asset paths (constants — single source of truth) ─────────────────────
  static const Map<SfxType, String> _sfxPaths = {
    SfxType.correct:  'audio/success.mp3',
    SfxType.wrong:    'audio/wrong.mp3',
    SfxType.gameOver: 'audio/game_over.mp3',
    SfxType.levelUp:  'audio/level_up.mp3',
  };

  // ── Mute toggle (child-friendly feature) ─────────────────────────────────
  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _wordPlayer.setVolume(0);
      _sfxPlayer.setVolume(0);
    } else {
      _wordPlayer.setVolume(1.0);
      _sfxPlayer.setVolume(1.0);
    }
  }

  // ── Playback methods ──────────────────────────────────────────────────────

  /// Plays the word pronunciation audio
  Future<void> playWord(String audioPath) async {
    if (_isMuted) return;
    await _wordPlayer.stop();
    await _wordPlayer.play(AssetSource(audioPath));
  }

  /// Plays a sound effect by type
  Future<void> playSfx(SfxType type) async {
    if (_isMuted) return;
    final path = _sfxPaths[type];
    if (path == null) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource(path));
  }

  /// Convenience wrapper used by the game screen
  Future<void> playAnswerSfx(bool isCorrect) =>
      playSfx(isCorrect ? SfxType.correct : SfxType.wrong);

  /// Stops all audio immediately (e.g., when navigating away)
  Future<void> stopAll() async {
    await _wordPlayer.stop();
    await _sfxPlayer.stop();
  }

  /// Must be called in the widget's dispose() to free native resources
  void dispose() {
    _wordPlayer.dispose();
    _sfxPlayer.dispose();
  }
}