
abstract class Game {
  String title;  
  int score = 0;

  Game(this.title); // Constructor for subclasses to call via super()

  //Initialises the game state. Must overridden this.
  void startGame();

  // Called when the game ends. must be overridden.
  void endGame();

  
  // OOP: Polymorphism 
  bool checkAnswer(String selectedOption, String correctAnswer);
}