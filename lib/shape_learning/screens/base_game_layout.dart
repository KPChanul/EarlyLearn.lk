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
                        config: _MenuConfig.pause(),
                        subtitle: null,
                        buttons: [
                          _buildMenuButton(
                            label: 'නැවත අරඹන්න',
                            sublabel: 'Resume',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                            ),
                            onPressed: controller.togglePause,
                          ),
                          _buildMenuButton(
                            label: 'මුල සිට',
                            sublabel: 'Restart',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF922B), Color(0xFFFFD93D)],
                            ),
                            onPressed: () {
                              controller.togglePause();
                              onRetry();
                            },
                          ),
                        ],
                      )
                    : controller.isGameWon
                    ? _buildMenuScreen(
                        title: '',
                        config: _MenuConfig.win(),
                        subtitle:
                            'ලකුණු: ${controller.score}  •  ⏱ ${controller.timeElapsedInSeconds}s',
                        buttons: [
                          _buildMenuButton(
                            label: 'ඊළඟ මට්ටම',
                            sublabel: 'Next Level →',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4D96FF), Color(0xFF845EF7)],
                            ),
                            onPressed: onNextLevel,
                          ),
                          _buildMenuButton(
                            label: 'නැවත ක්‍රීඩා',
                            sublabel: 'Play Again',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF922B), Color(0xFFFFD93D)],
                            ),
                            onPressed: onRetry,
                          ),
                        ],
                      )
                    : controller.isGameOver
                    ? _buildMenuScreen(
                        title: 'අයියෝ! 😢',
                        config: _MenuConfig.lose(),
                        subtitle: 'ජීවිත අවසන් — නැවත උත්සාහ කරන්න!',
                        buttons: [
                          _buildMenuButton(
                            label: 'නැවත උත්සාහ',
                            sublabel: 'Try Again',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFFF922B)],
                            ),
                            onPressed: onRetry,
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

  // ── Beautiful menu overlay ────────────────────────────────────────────────
  Widget _buildMenuScreen({
    required String title,
    required _MenuConfig config,
    String? subtitle,
    required List<Widget> buttons,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: config.glowColor.withOpacity(0.35),
              blurRadius: 36,
              spreadRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Stack(
            children: [
              // Gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: config.bgGradient,
                  ),
                ),
              ),

              // Decorative top-right circle
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),

              // Decorative bottom-left circle
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon in glowing circle
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: Icon(config.icon, size: 60, color: Colors.white),
                    ),

                    const SizedBox(height: 16),

                    // Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),

                    // Subtitle / stats
                    if (subtitle != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Buttons
                    ...buttons.map(
                      (btn) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: btn,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Gradient button ───────────────────────────────────────────────────────
  Widget _buildMenuButton({
    required String label,
    required String sublabel,
    required LinearGradient gradient,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                Text(
                  sublabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.85),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Menu config helper ────────────────────────────────────────────────────────

class _MenuConfig {
  final List<Color> bgGradient;
  final Color glowColor;
  final IconData icon;

  const _MenuConfig({
    required this.bgGradient,
    required this.glowColor,
    required this.icon,
  });

  factory _MenuConfig.win() => const _MenuConfig(
    bgGradient: [Color(0xFF2DC653), Color(0xFF1A9E4A)],
    glowColor: Color(0xFF2DC653),
    icon: Icons.emoji_events_rounded,
  );

  factory _MenuConfig.lose() => const _MenuConfig(
    bgGradient: [Color(0xFFE8384F), Color(0xFFBD1E30)],
    glowColor: Color(0xFFE8384F),
    icon: Icons.sentiment_very_dissatisfied_rounded,
  );

  factory _MenuConfig.pause() => const _MenuConfig(
    bgGradient: [Color(0xFF4D96FF), Color(0xFF2563D8)],
    glowColor: Color(0xFF4D96FF),
    icon: Icons.pause_circle_filled_rounded,
  );
}
