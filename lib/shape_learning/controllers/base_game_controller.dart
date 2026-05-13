import 'dart:async';
import 'package:flutter/material.dart';
import '../data/local_storage.dart';
import '../logic/sound_manager.dart';
import '../logic/reward_manager.dart';

abstract class BaseGameController extends ChangeNotifier {
  final LocalStorage storage = LocalStorage();
  final SoundManager soundManager = SoundManager();
  final RewardManager rewardManager = RewardManager();

  int currentLevel = 1;
  int score = 0;
  bool isGameWon = false;
  bool isGameOver = false;
  bool isPaused = false;

  int maxLives = 3;
  int currentLives = 3;
  Timer? _gameTimer;
  int timeElapsedInSeconds = 0;

  void loadLevel(int level) {
    currentLevel = level;
    score = 0;
    isGameWon = false;
    isGameOver = false;
    isPaused = false;
    currentLives = maxLives;
    timeElapsedInSeconds = 0;

    setupGameData();
    _startGameTimer();
    notifyListeners();
  }

  void togglePause() {
    isPaused = !isPaused;
    notifyListeners();
  }

  void decreaseLife() {
    if (currentLives > 0 && !isGameOver) {
      currentLives--;
      soundManager.playWrongSound();
      if (currentLives == 0) {
        isGameOver = true;
        stopTimer();
      }
      notifyListeners();
    }
  }

  void addScore(int points) {
    score += points;
    notifyListeners();
  }

  void _startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused && !isGameOver && !isGameWon) {
        timeElapsedInSeconds++;
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _gameTimer?.cancel();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  void setupGameData();
  bool checkWinCondition();
}
