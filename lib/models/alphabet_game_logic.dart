import 'game_alp.dart';
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
}