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
    with SingleTickerProviderStateMixin {
  final LocalStorage _storage = LocalStorage();
  final SoundManager _soundManager = SoundManager();

  late AnimationController _danceController;
  int _finalScore = 0;

  @override
  void initState() {
    super.initState();
    _finalScore = _storage.getTotalScore();

    _soundManager.playCorrectSound();
    Future.delayed(
      const Duration(milliseconds: 500),
      () => _soundManager.playCorrectSound(),
    );

    _danceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _danceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/level1_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: Tween(begin: 0.9, end: 1.1).animate(
                  CurvedAnimation(
                    parent: _danceController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.orange,
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Text(
                    'සුබ පැතුම්! 🎉',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w900,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDancingShape(Icons.circle, Colors.redAccent, 0),
                  _buildDancingShape(Icons.star, Colors.orangeAccent, 200),
                  _buildDancingShape(Icons.square, Colors.blueAccent, 400),
                ],
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.greenAccent, width: 6),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'ඔබ හැඩතල වීරයෙක්!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'මුළු ලකුණු: $_finalScore ⭐',
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text(
                  'අවසන් කරන්න (Finish)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDancingShape(IconData icon, Color color, int delay) {
    return AnimatedBuilder(
      animation: _danceController,
      builder: (context, child) {
        double offset =
            (delay == 0
                ? _danceController.value
                : (1 - _danceController.value)) *
            30;
        return Transform.translate(
          offset: Offset(0, -offset),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(icon, size: 80, color: color),
          ),
        );
      },
    );
  }
}
