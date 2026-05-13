import 'package:flutter/material.dart';
import 'screens/alphabet_game_screen.dart';

void main() {
  runApp(const MyApp());
}

//Root application widget.
// Extends StatelessWidget --Inheritance.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EarlyLearn.lk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), 
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        ),
      ),
      home: const AlphabetGameScreen(),
    );
  }
}