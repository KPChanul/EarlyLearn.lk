import 'package:flutter/material.dart';
import 'shape_learning/data/local_storage.dart';
import 'shape_learning/screens/shape_game_screen.dart';

void main() async {
  // 1. Ensure Flutter bindings are ready before interacting with the database
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize the isolated Hive databases for the Shape Game
  final localStorage = LocalStorage();
  await localStorage.init();

  // 3. Boot up the mini-app!
  runApp(const ShapeGamePreviewApp());
}

class ShapeGamePreviewApp extends StatelessWidget {
  const ShapeGamePreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shape Game Preview',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Makes sure the app uses modern Material 3 design
        useMaterial3: true,
      ),
      // Automatically starts you at Level 1
      home: const ShapeGameScreen(),
    );
  }
}
