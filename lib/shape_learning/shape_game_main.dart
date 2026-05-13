import 'package:flutter/material.dart';
import 'data/local_storage.dart';
import 'screens/shape_game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localStorage = LocalStorage();
  await localStorage.init();

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
      home: const ShapeGameScreen(),
    );
  }
}
