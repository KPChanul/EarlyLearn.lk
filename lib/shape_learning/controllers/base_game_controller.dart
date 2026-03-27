import 'dart:async';
import 'package:flutter/material.dart';
import '../data/local_storage.dart';
import '../logic/sound_manager.dart';
import '../logic/reward_manager.dart';

abstract class BaseGameController extends ChangeNotifier {
  final LocalStorage storage = LocalStorage();
  final SoundManager soundManager = SoundManager();
  final RewardManager rewardManager = RewardManager();

  // --- CORE STATE ---
  int currentLevel = 1;
  int score = 0;
  bool isGameWon = false;
  bool isGameOver = false;
  bool isPaused = false;

  // --- HEALTH & TIME ---
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
    notifyListeners(); // Tells the UI to redraw!
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

  // --- TIMER LOGIC ---
  void _startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused && !isGameOver && !isGameWon) {
        timeElapsedInSeconds++;
        notifyListeners(); // Updates the clock on the screen every second
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

  // --- THE RULES EVERY GAME MUST FOLLOW ---
  void setupGameData();
  bool checkWinCondition();
}
