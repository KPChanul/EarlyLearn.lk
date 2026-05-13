/*  import 'package:flutter/material.dart';
import 'screens/alphabet_game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EarlyLearn.lk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const AlphabetGameScreen(), 
    );
  }
} 
 */

import 'package:flutter/material.dart';
import 'screens/alphabet_game_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Root application widget.
/// OOP: Extends StatelessWidget (Inheritance).
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EarlyLearn.lk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // deep green seed
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // Slightly rounded default text theme for a child-friendly feel
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        ),
      ),
      home: const AlphabetGameScreen(),
    );
  }
}