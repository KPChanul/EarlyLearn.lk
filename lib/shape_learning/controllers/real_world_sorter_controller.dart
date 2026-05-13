import 'package:flutter/material.dart';
import 'dart:math';
import 'base_game_controller.dart';

class RealWorldSorterController extends BaseGameController {
  late List<Map<String, dynamic>> gameQueue;
  int currentItemIndex = 0;

  @override
  void setupGameData() {
    // 1. Fetch the raw data from Hive
    var rawDatabaseData = storage.getLevelData(currentLevel);

    // 2. Translate the text 'type' back into Flutter Icons
    List<Map<String, dynamic>> parsedItems = rawDatabaseData.map((item) {
      return {
        'emoji': item['emoji'],
        'type': _getIconFromString(item['type']),
        'name': item['name'],
      };
    }).toList();

    // 3. Shuffle the items
    gameQueue = List.from(parsedItems)..shuffle(Random());
    currentItemIndex = 0;
  }

  // Translates database text into UI icons
  IconData _getIconFromString(String name) {
    switch (name) {
      case 'circle':
        return Icons.circle;
      case 'square':
        return Icons.square;
      case 'triangle':
        return Icons.change_history;
      default:
        return Icons.help;
    }
  }

  @override
  bool checkWinCondition() {
    return currentItemIndex >= gameQueue.length;
  }

  Map<String, dynamic>? getCurrentItem() {
    if (currentItemIndex < gameQueue.length) {
      return gameQueue[currentItemIndex];
    }
    return null;
  }

  void processDrop(IconData targetShape) {
    var currentItem = getCurrentItem();
    if (currentItem == null) return;

    if (currentItem['type'] == targetShape) {
      addScore(20);
      soundManager.playCorrectSound();
      currentItemIndex++;

      if (checkWinCondition()) {
        isGameWon = true;
        stopTimer();
        rewardManager.processGameResult(true, score);
      }
    } else {
      decreaseLife();
    }
    notifyListeners();
  }
}
