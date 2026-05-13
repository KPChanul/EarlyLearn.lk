/* abstract class Game {
  String title;
  int score = 0;

  Game(this.title);

  void startGame();
  void endGame();
  bool checkAnswer(String selectedOption, String correctAnswer);
}  */

/// Abstract base class for all game types in EarlyLearn.lk.
/// OOP: Abstraction — defines a contract without a concrete implementation.
/// OOP: Inheritance — subclasses must implement startGame, endGame, checkAnswer.
abstract class Game {
  String title;  // Shared state accessible to all subclasses
  int score = 0;

  Game(this.title); // Constructor for subclasses to call via super()

  /// Initialises the game state. Must be overridden.
  void startGame();

  /// Called when the game ends. Must be overridden.
  void endGame();

  /// Returns true if the selected option matches the correct answer.
  /// OOP: Polymorphism — each game type can define its own scoring logic.
  bool checkAnswer(String selectedOption, String correctAnswer);
}