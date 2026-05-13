/* import 'game_alp.dart';
import 'alphabet_questions.dart';
import 'alphabet_game_data.dart';

class AlphabetGameLogic extends Game {
  List<AlphabetQuestion> questions = [];
  int currentQuestionIndex = 0;

  AlphabetGameLogic() : super("Find the Starting Letter") //Call parent(Game) constructor
   {
    questions = alphabetQuestionsData; //Load all the questions
  }

  @override
  void startGame() {
    score = 0;
    currentQuestionIndex = 0;
  }

  @override
  void endGame() {
    // Will connect this to the RewardManager later
    print("Game ended! Final Score: $score");
  }

  @override
  bool checkAnswer(String selectedOption, String correctAnswer) {
    if (selectedOption == correctAnswer) {
      score += 10;
      return true;
    }
    return false;
  }

  AlphabetQuestion? getCurrentQuestion() {
    if (currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  void nextQuestion() {
    currentQuestionIndex++;
  }
} */
import 'game_alp.dart';
import 'alphabet_questions.dart';
import 'alphabet_game_data.dart';

// ─── AlphabetGameLogic ────────────────────────────────────────────────────────
// Concrete implementation of Game for the Sinhala alphabet quiz.
// Adds: lives system, difficulty progression, hint tracking, shuffle support.

class AlphabetGameLogic extends Game {
  // ── Game configuration constants ──────────────────────────────────────────
  static const int maxLives         = 3;
  static const int baseScorePerQ    = 10;
  static const Duration autoAdvance = Duration(milliseconds: 1500);

  // ── State ─────────────────────────────────────────────────────────────────
  List<AlphabetQuestion> questions = [];
  int currentQuestionIndex = 0;
  int lives = maxLives;
  bool hintUsed = false;           // Was a hint used for the current question?
  int hintsUsedTotal = 0;

  // ── OOP: Override base score per question ─────────────────────────────────
  @override
  int get _baseScore => baseScorePerQ;

  // ── Identity (implements abstract getters from Game) ──────────────────────
  @override
  String get subtitle => 'Find the Starting Letter';

  @override
  String get emoji => '🔤';

  // ── Constructor ───────────────────────────────────────────────────────────
  AlphabetGameLogic() : super('Find the Starting Letter') {
    questions = List.from(alphabetQuestionsData); // copy so we can shuffle safely
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void startGame() {
    super.startGame();         // Resets score, streak, counters from base class
    lives = maxLives;
    currentQuestionIndex = 0;
    hintUsed = false;
    hintsUsedTotal = 0;
    questions.shuffle();       // Randomise order for replay variety
  }

  @override
  void endGame() {
    super.endGame();
    // Future hook: trigger RewardManager, save high score to local storage, etc.
    // ignore: avoid_print
    print('Game ended! Final Score: $score | Grade: $grade | Accuracy: ${accuracy.toStringAsFixed(0)}%');
  }

  // ── Core game logic ───────────────────────────────────────────────────────
  @override
  bool checkAnswer(String selectedOption, String correctAnswer) {
    final isCorrect = super.checkAnswer(selectedOption, correctAnswer);
    if (!isCorrect) {
      lives = (lives - 1).clamp(0, maxLives);
    }
    hintUsed = false; // Reset hint flag for next question
    return isCorrect;
  }

  void nextQuestion() {
    currentQuestionIndex++;
    hintUsed = false;
  }

  /// Reveal a hint for the current question.
  /// Returns the hint text, or empty string if no hint available.
  String useHint() {
    final q = getCurrentQuestion();
    if (q == null || !q.hasHint) return '';
    hintUsed = true;
    hintsUsedTotal++;
    return q.hintText;
  }

  // ── Query helpers ─────────────────────────────────────────────────────────
  AlphabetQuestion? getCurrentQuestion() {
    if (currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  bool get hasMoreQuestions => currentQuestionIndex < questions.length;

  bool get isOutOfLives => lives <= 0;

  bool get isGameOver => !hasMoreQuestions || isOutOfLives;

  int get questionsRemaining => questions.length - currentQuestionIndex;

  int get totalQuestions => questions.length;

  double get progressPercent =>
      questions.isEmpty ? 0 : currentQuestionIndex / questions.length;

  // ── Extended summary (overrides base) ─────────────────────────────────────
  @override
  Map<String, dynamic> getSummary() {
    final base = super.getSummary();
    return {
      ...base,
      'livesLeft':    lives,
      'hintsUsed':    hintsUsedTotal,
      'totalQ':       totalQuestions,
    };
  }
}