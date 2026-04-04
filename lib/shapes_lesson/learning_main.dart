import 'package:flutter/material.dart';
import 'screens/video_learning_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShapesLessonApp());
}

class ShapesLessonApp extends StatelessWidget {
  const ShapesLessonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shapes Lesson',
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
      home: const VideoLearningScreen(),
    );
  }
}
