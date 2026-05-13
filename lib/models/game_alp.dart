/* abstract class Game {
  String title;
  int score = 0;

  Game(this.title);

  void startGame();
  void endGame();
  bool checkAnswer(String selectedOption, String correctAnswer);
} */

// ─── Abstract Game Base Class ─────────────────────────────────────────────────
// Defines the common contract for ALL games in the EarlyLearn.lk platform.
// Every new game (NumberGame, ShapeGame, etc.) must extend this class.

enum GameState { idle, playing, paused, finished }

abstract class Game {
  // ── Identity ──────────────────────────────────────────────────────────────
  String title;
  String get subtitle;           // Each game provides its own subtitle
  String get emoji;              // Visual identity icon for the game card

  // ── Scoring ───────────────────────────────────────────────────────────────
  int score = 0;
  int streak = 0;               // Consecutive correct answers
  int bestStreak = 0;
  int totalAnswered = 0;
  int correctAnswered = 0;

  // ── State ─────────────────────────────────────────────────────────────────
  GameState gameState = GameState.idle;
  bool get isPlaying  => gameState == GameState.playing;
  bool get isFinished => gameState == GameState.finished;

  // ── Derived stats (computed properties — OOP encapsulation) ───────────────
  double get accuracy =>
      totalAnswered == 0 ? 0 : (correctAnswered / totalAnswered) * 100;

  String get grade {
    if (accuracy >= 90) return 'S';
    if (accuracy >= 75) return 'A';
    if (accuracy >= 60) return 'B';
    if (accuracy >= 40) return 'C';
    return 'D';
  }

  String get gradeEmoji {
    switch (grade) {
      case 'S': return '🏆';
      case 'A': return '⭐';
      case 'B': return '😊';
      case 'C': return '💪';
      default:  return '🌱';
    }
  }

  // ── Bonus points for streaks ───────────────────────────────────────────────
  int get _streakBonus {
    if (streak >= 5) return 20;
    if (streak >= 3) return 10;
    return 0;
  }

  // ── Constructor ───────────────────────────────────────────────────────────
  Game(this.title);

  // ── Abstract lifecycle hooks ───────────────────────────────────────────────
  void startGame() {
    score = 0;
    streak = 0;
    bestStreak = 0;
    totalAnswered = 0;
    correctAnswered = 0;
    gameState = GameState.playing;
  }

  void endGame() {
    gameState = GameState.finished;
  }

  // ── Core answer checking with streak logic ────────────────────────────────
  // Subclasses override _baseScore to customise points per question.
  int get _baseScore => 10;

  bool checkAnswer(String selectedOption, String correctAnswer) {
    totalAnswered++;
    if (selectedOption == correctAnswer) {
      correctAnswered++;
      streak++;
      if (streak > bestStreak) bestStreak = streak;
      score += _baseScore + _streakBonus;
      return true;
    } else {
      streak = 0; // Reset streak on wrong answer
      return false;
    }
  }

  // ── Summary helper used by the result screen ──────────────────────────────
  Map<String, dynamic> getSummary() {
    return {
      'title':       title,
      'score':       score,
      'accuracy':    accuracy.toStringAsFixed(0),
      'grade':       grade,
      'gradeEmoji':  gradeEmoji,
      'bestStreak':  bestStreak,
      'totalQ':      totalAnswered,
      'correct':     correctAnswered,
    };
  }
}