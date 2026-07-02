import 'package:flutter/material.dart';
import 'math_game_engine.dart';
import 'math_game_ui.dart';

class ThirdGame extends StatefulWidget {
  const ThirdGame({super.key});

  @override
  State<ThirdGame> createState() => _ThirdGameState();
}

class _ThirdGameState extends State<ThirdGame> {
  // We initialize the engine here. This creates the "Brain" when the screen opens.
  final MathGameEngine _engine = MathGameEngine();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Math Game")),
      body: Center(
        child: MathGameUI(
          engine: _engine,
        ), // This connects your UI to the Engine
      ),
    );
  }
}
