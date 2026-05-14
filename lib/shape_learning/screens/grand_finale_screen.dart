import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/local_storage.dart';
import '../logic/sound_manager.dart';

class GrandFinaleScreen extends StatefulWidget {
  const GrandFinaleScreen({super.key});

  @override
  State<GrandFinaleScreen> createState() => _GrandFinaleScreenState();
}

class _GrandFinaleScreenState extends State<GrandFinaleScreen>
    with TickerProviderStateMixin {
  final LocalStorage _storage = LocalStorage();
  final SoundManager _soundManager = SoundManager();

  late AnimationController _danceController;
  late AnimationController _entryController;
  late AnimationController _confettiController;
  late AnimationController _pulseController;

  late Animation<double> _titleScale;
  late Animation<double> _cardSlide;
  late Animation<double> _buttonFade;

  int _finalScore = 0;
  final List<_ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _finalScore = _storage.getTotalScore();

    _soundManager.playCorrectSound();
    Future.delayed(
      const Duration(milliseconds: 500),
      () => _soundManager.playCorrectSound(),
    );

    // Bouncy dance for shapes
    _danceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    // Entry animation
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _titleScale = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    );

    _cardSlide = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.3, 0.75, curve: Curves.easeOutBack),
    );

    _buttonFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    _entryController.forward();

    // Confetti controller
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Pulse for score
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Generate confetti particles
    final rng = Random();
    for (int i = 0; i < 30; i++) {
      _particles.add(
        _ConfettiParticle(
          x: rng.nextDouble(),
          startY: -0.1 - rng.nextDouble() * 0.5,
          speed: 0.15 + rng.nextDouble() * 0.25,
          size: 6 + rng.nextDouble() * 10,
          color: [
            const Color(0xFFFF6B6B),
            const Color(0xFFFFD93D),
            const Color(0xFF6BCB77),
            const Color(0xFF4D96FF),
            const Color(0xFFFF922B),
            const Color(0xFFCC5DE8),
          ][rng.nextInt(6)],
          shape: rng.nextBool(),
          phase: rng.nextDouble(),
          wobble: (rng.nextDouble() - 0.5) * 0.04,
        ),
      );
    }
  }

  @override
  void dispose() {
    _danceController.dispose();
    _entryController.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/level1_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark overlay for contrast
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurple.withOpacity(0.55),
                  Colors.indigo.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Confetti layer
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, _) {
              return CustomPaint(
                size: Size(size.width, size.height),
                painter: _ConfettiPainter(
                  particles: _particles,
                  progress: _confettiController.value,
                ),
              );
            },
          ),

          // Main content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Title badge ──
                ScaleTransition(
                  scale: _titleScale,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD93D), Color(0xFFFF922B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF922B).withOpacity(0.6),
                          blurRadius: 28,
                          spreadRadius: 4,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Text(
                      'සුබ පැතුම්!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.deepOrange,
                            blurRadius: 8,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Dancing shapes row ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDancingShape(
                      Icons.circle,
                      const Color(0xFFFF6B6B),
                      0,
                    ),
                    _buildDancingShape(
                      Icons.star,
                      const Color(0xFFFFD93D),
                      200,
                    ),
                    _buildDancingShape(
                      Icons.square,
                      const Color(0xFF4D96FF),
                      400,
                    ),
                    _buildDancingShape(
                      Icons.change_history,
                      const Color(0xFF6BCB77),
                      100,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Score card ──
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(_cardSlide),
                  child: FadeTransition(
                    opacity: _cardSlide,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 28),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: const Color(0xFF6BCB77),
                          width: 5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6BCB77).withOpacity(0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Trophy icon
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD93D), Color(0xFFFF922B)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF922B,
                                  ).withOpacity(0.4),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.emoji_events_rounded,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'You Won!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D9E5F),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Divider line
                          Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF6BCB77).withOpacity(0.6),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Score with pulse
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, _) {
                              final scale = 1.0 + _pulseController.value * 0.06;
                              return Transform.scale(
                                scale: scale,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '⭐',
                                      style: TextStyle(fontSize: 34),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'මුළු ලකුණු: $_finalScore',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFFFF922B),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '⭐',
                                      style: TextStyle(fontSize: 34),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Finish button ──
                FadeTransition(
                  opacity: _buttonFade,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(_buttonFade),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
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
                          onPressed: () => SystemNavigator.pop(),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4D96FF), Color(0xFF845EF7)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4D96FF,
                                  ).withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'අවසන් කරන්න  ✓',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDancingShape(IconData icon, Color color, int delayMs) {
    return AnimatedBuilder(
      animation: _danceController,
      builder: (context, child) {
        double t = _danceController.value;
        // Each shape gets a different phase so they don't all move identically
        double phase = delayMs / 800.0;
        double offset = sin((t + phase) * pi) * 18;
        double rotationAngle = sin((t + phase) * pi) * 0.15;
        return Transform.translate(
          offset: Offset(0, -offset),
          child: Transform.rotate(
            angle: rotationAngle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.5), width: 2),
                ),
                child: Icon(icon, size: 52, color: color),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Confetti system ────────────────────────────────────────────────────────────

class _ConfettiParticle {
  final double x;
  final double startY;
  final double speed;
  final double size;
  final Color color;
  final bool shape; // true = circle, false = rect
  final double phase;
  final double wobble;

  _ConfettiParticle({
    required this.x,
    required this.startY,
    required this.speed,
    required this.size,
    required this.color,
    required this.shape,
    required this.phase,
    required this.wobble,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      double t = (progress + p.phase) % 1.0;
      double y = (p.startY + t * p.speed * 3.5) % 1.2;
      double x = p.x + sin(t * pi * 4 + p.phase * 10) * p.wobble;
      final paint = Paint()..color = p.color.withOpacity(0.85);
      final cx = x * size.width;
      final cy = y * size.height;
      if (p.shape) {
        canvas.drawCircle(Offset(cx, cy), p.size / 2, paint);
      } else {
        canvas.save();
        canvas.translate(cx, cy);
        canvas.rotate(t * pi * 2);
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.55,
          ),
          paint,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => true;
}
