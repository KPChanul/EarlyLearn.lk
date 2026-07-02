import 'package:flutter/material.dart';
import 'math_game_engine.dart';
import 'math_game_ui.dart';

class ThirdGame extends StatefulWidget {
  const ThirdGame({super.key});

  @override
  State<ThirdGame> createState() => _ThirdGameState();
}

class _ThirdGameState extends State<ThirdGame> {
  // Initializing the engine
  final MathGameEngine _engine = MathGameEngine();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Using the frame as the background
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.avif"),
            fit: BoxFit.fill,
          ),
        ),
        // Padding ensures the game UI stays inside the white center of the frame
        child: Padding(
          padding: const EdgeInsets.only(
            top: 80.0, // Adjust based on the top frame elements
            bottom: 60.0, // Adjust based on the bottom frame elements
            left: 30.0,
            right: 30.0,
          ),
          child: Center(child: MathGameUI(engine: _engine)),
        ),
      ),
    );
  }
}
