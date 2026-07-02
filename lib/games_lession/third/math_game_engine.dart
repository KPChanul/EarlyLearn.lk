import 'dart:math';
import 'package:flutter/foundation.dart';
import 'math_question_model.dart';
import 'math_sound_service.dart';

class MathGameEngine extends ChangeNotifier {
  final Random _random = Random();
  final MathSoundService _soundService = MathSoundService();
  final List<String> _emojiList = [
    "🍎",
    "🐶",
    "🐱",
    "🚗",
    "⭐",
    "⚽",
    "🎈",
    "🦋",
  ];

  String currentEmoji = "🍎";
  int score = 0;
  int currentStage = 1;
  int questionsAnswered = 0;
  bool isGameOver = false;
  late MathQuestion currentQuestion;

  // New feedback state
  int? selectedIndex;
  bool isFeedbackVisible = false;

  MathGameEngine() {
    generateNextQuestion();
  }

  void generateNextQuestion() {
    if (isGameOver) return;
    currentEmoji = _emojiList[_random.nextInt(_emojiList.length)];
    int maxRange = (currentStage == 1) ? 5 : 10;
    int o1 = _random.nextInt(maxRange) + 1;
    int o2 = _random.nextInt(maxRange) + 1;

    int stepInStage = questionsAnswered % 10;
    MathOperation op = (stepInStage < 5)
        ? MathOperation.addition
        : MathOperation.subtraction;

    if (op == MathOperation.subtraction && o1 < o2) {
      int temp = o1;
      o1 = o2;
      o2 = temp;
    }

    int answer = (op == MathOperation.addition) ? o1 + o2 : o1 - o2;
    List<int> opts = _generateOptions(answer);

    currentQuestion = MathQuestion(
      operand1: o1,
      operand2: o2,
      operation: op,
      options: opts,
      correctIndex: opts.indexOf(answer),
    );
    notifyListeners();
  }

  List<int> _generateOptions(int answer) {
    Set<int> opts = {answer};
    while (opts.length < 4) {
      opts.add(_random.nextInt(11));
    }
    List<int> result = opts.toList();
    result.shuffle();
    return result;
  }

  void checkAnswer(int index) {
    if (isGameOver || isFeedbackVisible) return;

    selectedIndex = index;
    isFeedbackVisible = true;

    if (index == currentQuestion.correctIndex) {
      score += (currentStage == 1 ? 30 : 50);
      _soundService.playCorrect();
    } else {
      _soundService.playWrong();
    }
    notifyListeners();
  }

  void nextQuestion() {
    isFeedbackVisible = false;
    selectedIndex = null;
    questionsAnswered++;
    if (questionsAnswered >= 20) {
      isGameOver = true;
    } else {
      if (questionsAnswered == 10) currentStage = 2;
      generateNextQuestion();
    }
    notifyListeners();
  }
}
