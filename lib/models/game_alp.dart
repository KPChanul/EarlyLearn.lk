abstract class Game {
  String title;
  int score = 0;

  Game(this.title);

  void startGame();
  void endGame();
  bool checkAnswer(String selectedOption, String correctAnswer);
} 