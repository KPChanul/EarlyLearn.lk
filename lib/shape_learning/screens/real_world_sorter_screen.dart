import 'package:flutter/material.dart';
import 'dart:math';
import '../controllers/base_game_controller.dart';
import 'base_game_layout.dart';
import 'grand_finale_screen.dart';

class RealWorldSorterController extends BaseGameController {
  final List<Map<String, dynamic>> _allItems = [
    {'emoji': '🍕', 'type': Icons.change_history, 'name': 'පීසා (Pizza)'},
    {'emoji': '⚽', 'type': Icons.circle, 'name': 'බෝලය (Ball)'},
    {'emoji': '🎁', 'type': Icons.square, 'name': 'තෑග්ග (Gift)'},
    {'emoji': '⏰', 'type': Icons.circle, 'name': 'ඔරලෝසුව (Clock)'},
    {'emoji': '📺', 'type': Icons.square, 'name': 'රූපවාහිනිය (TV)'},
  ];

  late List<Map<String, dynamic>> gameQueue;
  int currentItemIndex = 0;

  @override
  void setupGameData() {
    gameQueue = List.from(_allItems)..shuffle(Random());
    currentItemIndex = 0;
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

class RealWorldSorterScreen extends StatefulWidget {
  const RealWorldSorterScreen({super.key});

  @override
  State<RealWorldSorterScreen> createState() => _RealWorldSorterScreenState();
}

class _RealWorldSorterScreenState extends State<RealWorldSorterScreen> {
  final RealWorldSorterController _controller = RealWorldSorterController();

  @override
  void initState() {
    super.initState();
    _controller.loadLevel(2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        var currentItem = _controller.getCurrentItem();

        return BaseGameLayout(
          controller: _controller,
          title: 'මෙය කුමන හැඩයක්ද?',
          onNextLevel: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const GrandFinaleScreen()),
          ),
          onRetry: () => _controller.loadLevel(2),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: currentItem == null
                      ? const SizedBox()
                      : Draggable<String>(
                          data: currentItem['emoji'],
                          feedback: Material(
                            color: Colors.transparent,
                            child: Text(
                              currentItem['emoji'],
                              style: const TextStyle(fontSize: 120),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: Text(
                              currentItem['emoji'],
                              style: const TextStyle(fontSize: 100),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 15,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Text(
                              currentItem['emoji'],
                              style: const TextStyle(fontSize: 100),
                            ),
                          ),
                        ),
                ),
              ),

              if (currentItem != null)
                Text(
                  currentItem['name'],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 5)],
                  ),
                ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBucket(Icons.circle, Colors.redAccent),
                    _buildBucket(Icons.square, Colors.blueAccent),
                    _buildBucket(Icons.change_history, Colors.green.shade600),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBucket(IconData targetShape, Color color) {
    return DragTarget<String>(
      onWillAccept: (data) => true,
      onAccept: (data) => _controller.processDrop(targetShape),
      builder: (context, candidateData, rejectedData) {
        bool isHovered = candidateData.isNotEmpty;
        return GestureDetector(
          onTap: () => _controller.processDrop(targetShape),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isHovered ? 120 : 100,
            height: isHovered ? 120 : 100,
            decoration: BoxDecoration(
              color: isHovered ? color.withOpacity(0.5) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color, width: 5),
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Icon(targetShape, size: isHovered ? 80 : 60, color: color),
            ),
          ),
        );
      },
    );
  }
}
