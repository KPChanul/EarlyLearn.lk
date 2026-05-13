import 'package:early_learn/screens/alphabet_game_screen.dart';
import 'package:flutter/material.dart';

class SecondGame extends StatefulWidget {
  const SecondGame({super.key});

  @override
  State<SecondGame> createState() => _SecondGameState();
}

class _SecondGameState extends State<SecondGame> {
  @override
  Widget build(BuildContext context) {
    return AlphabetGameScreen();
  }
}