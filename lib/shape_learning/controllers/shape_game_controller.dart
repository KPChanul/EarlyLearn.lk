import 'package:flutter/material.dart';
import 'base_game_controller.dart';

class ShapeGameController extends BaseGameController {
  List<Map<String, dynamic>> _questions = [];
  int currentQuestionIndex = 0;
  int comboCount = 0;
  bool hintUsedForCurrent = false;

  @override
  void setupGameData() {
    var rawDatabaseData = storage.getLevelData(currentLevel);

    _questions = rawDatabaseData.map((q) {
      List<String> stringOptions = List<String>.from(q['options']);
      List<IconData> iconOptions = stringOptions
          .map((str) => _getIconFromString(str))
          .toList();
      return {
        'question': q['question'],
        'options': iconOptions,
        'correctIndex': q['correctIndex'],
        'hint': q['hint'],
      };
    }).toList();

    currentQuestionIndex = 0;
    comboCount = 0;
    hintUsedForCurrent = false;
  }

  @override
  bool checkWinCondition() {
    return score >= (_questions.length * 10) / 2;
  }

  IconData _getIconFromString(String name) {
    switch (name) {
      case 'circle':
        return Icons.circle;
      case 'square':
        return Icons.square;
      case 'triangle':
        return Icons.change_history;
      case 'star':
        return Icons.star;
      case 'heart':
        return Icons.favorite;
      default:
        return Icons.help;
    }
  }

  Map<String, dynamic> getCurrentQuestion() => _questions[currentQuestionIndex];

  String getHint() {
    hintUsedForCurrent = true;
    notifyListeners();
    return _questions[currentQuestionIndex]['hint'];
  }

  bool checkAnswer(int selectedIndex) {
    bool isCorrect =
        selectedIndex == _questions[currentQuestionIndex]['correctIndex'];

    if (isCorrect) {
      comboCount++;
      int pointsEarned = 10 + (comboCount * 5);
      if (hintUsedForCurrent) pointsEarned = (pointsEarned / 2).round();
      addScore(pointsEarned);
      soundManager.playCorrectSound();
    } else {
      comboCount = 0;
      decreaseLife();
    }
    return isCorrect;
  }

  bool nextQuestion() {
    if (currentQuestionIndex < _questions.length - 1) {
      currentQuestionIndex++;
      hintUsedForCurrent = false;
      notifyListeners();
      return true;
    }

    stopTimer();
    isGameWon = checkWinCondition();
    if (isGameWon) rewardManager.processGameResult(true, score);
    notifyListeners();
    return false;
  }
}
