import 'package:flutter/material.dart';
import '../controllers/base_game_controller.dart';

class BaseGameLayout extends StatelessWidget {
  final BaseGameController controller;
  final String title;
  final Widget child;
  final VoidCallback onNextLevel;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const BaseGameLayout({
    super.key,
    required this.controller,
    required this.title,
    required this.child,
    required this.onNextLevel,
    required this.onRetry,
    required this.onExit,
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
              // --- TOP HUD BAR ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT SIDE: Exit Button, Level, and Score
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // --- NEW PERSISTENT EXIT BUTTON ---
                            GestureDetector(
                              onTap: onExit,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // ----------------------------------
                            _buildBadge(
                              'Level ${controller.currentLevel}',
                              Colors.blueAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        _buildBadge(
                          'Score: ${controller.score} ⭐',
                          Colors.orangeAccent,
                        ),
                      ],
                    ),

                    // RIGHT SIDE: Timer, Hearts, and Pause
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

              // --- THE GAME AREA ---
              Expanded(
                child: controller.isPaused
                    ? _buildMenuScreen(
                        title: 'විවේකයක් ⏸️',
                        color: Colors.blue,
                        icon: Icons.pause_circle_filled,
                        buttons: [
                          _buildMenuButton(
                            'නැවත අරඹන්න (Resume)',
                            Colors.green,
                            controller.togglePause,
                          ),
                          _buildMenuButton(
                            'මුල සිට පටන් ගන්න (Restart)',
                            Colors.orange,
                            () {
                              controller.togglePause();
                              onRetry();
                            },
                          ),
                        ],
                      )
                    : controller.isGameWon
                    ? _buildMenuScreen(
                        title: 'නියමයි! මට්ටම සමත්! 🎉',
                        color: Colors.green,
                        icon: Icons.star,
                        subtitle:
                            'මුළු ලකුණු: ${controller.score}\nගතවූ කාලය: ${controller.timeElapsedInSeconds}s',
                        buttons: [
                          _buildMenuButton(
                            'ඊළඟ මට්ටම ➡️',
                            Colors.blue,
                            onNextLevel,
                          ),
                          _buildMenuButton(
                            'නැවත ක්‍රීඩා කරන්න 🔄',
                            Colors.orange,
                            onRetry,
                          ),
                        ],
                      )
                    : controller.isGameOver
                    ? _buildMenuScreen(
                        title: 'අයියෝ! අසමත්! 😢',
                        color: Colors.red,
                        icon: Icons.sentiment_very_dissatisfied,
                        subtitle: 'ඔබගේ ජීවිත අවසන්.',
                        buttons: [
                          _buildMenuButton(
                            'නැවත උත්සාහ කරන්න 🔄',
                            Colors.orange,
                            onRetry,
                          ),
                        ],
                      )
                    : child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the top HUD badges
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

  // Helper widget to draw the menus
  Widget _buildMenuScreen({
    required String title,
    required Color color,
    required IconData icon,
    String? subtitle,
    required List<Widget> buttons,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: color, width: 6),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 15),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
            const SizedBox(height: 30),
            ...buttons.map(
              (btn) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: btn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the big buttons
  Widget _buildMenuButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
