import 'package:early_learn/shapes_lesson/screens/video_learning_screen.dart';
import 'package:flutter/material.dart';

class FirstLession extends StatefulWidget {
  const FirstLession({super.key});

  @override
  State<FirstLession> createState() => _FirstLessionState();
}

class _FirstLessionState extends State<FirstLession> {
  @override
  Widget build(BuildContext context) {
    return VideoLearningScreen();
  }
}