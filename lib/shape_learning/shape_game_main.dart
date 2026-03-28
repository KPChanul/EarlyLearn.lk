import 'package:flutter/material.dart';

// Because this file is inside the shape_learning folder,
// it can find these files easily!
import 'data/local_storage.dart';
import 'screens/shape_game_screen.dart';

void main() async {
  // 1. Ensure Flutter is ready to talk to the device
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Wake up the Hive database and load the Level 1 & 2 data
  final localStorage = LocalStorage();
  await localStorage.init();

  // 3. Launch the game!
  runApp(const ShapeGamePreviewApp());
}

class ShapeGamePreviewApp extends StatelessWidget {
  const ShapeGamePreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shape Arcade',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // This boots you directly into Level 1!
      home: const ShapeGameScreen(),
    );
  }
}
