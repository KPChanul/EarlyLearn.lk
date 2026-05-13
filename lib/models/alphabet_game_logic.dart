import 'game_alp.dart';
import 'alphabet_questions.dart';
import 'alphabet_game_data.dart';


//Inheritance — extends the abstract Game class.
//Polymorphism — overrides startGame, endGame, and checkAnswer.
class AlphabetGameLogic extends Game {
  List<AlphabetQuestion> questions = []; // encapsulated question list
  int currentQuestionIndex = 0;

  // Calls the parent constructor via super() — demonstrates inheritance.
  AlphabetGameLogic() : super("Find the Starting Letter") {
    questions = alphabetQuestionsData; // Load question bank
  }

  @override
  void startGame() {
    score = 0;
    currentQuestionIndex = 0;
  }

  @override
  void endGame() {
    
    print("Game ended! Final Score: $score");
  }

  // Awards 10 points per correct answer.
  @override
  bool checkAnswer(String selectedOption, String correctAnswer) {
    if (selectedOption == correctAnswer) {
      score += 10;
      return true;
    }
    return false;
  }

  //Returns the current question, or null when all questions are done.
  AlphabetQuestion? getCurrentQuestion() {
    if (currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  // Advances to the next question.
  void nextQuestion() {
    currentQuestionIndex++;
  }
}