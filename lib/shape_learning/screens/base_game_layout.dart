import 'package:flutter/material.dart';
import '../controllers/base_game_controller.dart';

class BaseGameLayout extends StatelessWidget {
  final BaseGameController controller;
  final String title;
  final Widget child;

  const BaseGameLayout({
    super.key,
    required this.controller,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/level1_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- UNIVERSAL HUD ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBadge(
                          'Level ${controller.currentLevel}',
                          Colors.blueAccent,
                        ),
                        const SizedBox(height: 5),
                        _buildBadge(
                          'Score: ${controller.score} ⭐',
                          Colors.orangeAccent,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              '⏱️ ${controller.timeElapsedInSeconds}s',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Row(
                              children: List.generate(
                                controller.maxLives,
                                (index) => Icon(
                                  index < controller.currentLives
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.redAccent,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: controller.togglePause,
                          child: _buildBadge(
                            controller.isPaused ? 'Resume ▶️' : 'Pause ⏸️',
                            controller.isPaused ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- TITLE CARD ---
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // --- GAME CONTENT ---
              Expanded(
                child: controller.isPaused
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pause_circle_filled,
                              size: 100,
                              color: Colors.white,
                            ),
                            Text(
                              'Paused',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : controller.isGameOver
                    ? const Center(
                        child: Text(
                          'Game Over 💀',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
