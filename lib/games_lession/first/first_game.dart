import 'package:early_learn/shape_learning/screens/shape_game_screen.dart';
import 'package:flutter/material.dart';

class FirstGame extends StatefulWidget {
  const FirstGame({super.key});

  @override
  State<FirstGame> createState() => _FirstGameState();
}

class _FirstGameState extends State<FirstGame> {
  @override
  Widget build(BuildContext context) {
    return ShapeGameScreen();
  }
}