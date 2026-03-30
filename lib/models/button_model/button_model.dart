import 'package:flutter/material.dart';

class ButtonModel {
  // final List<Color> btnColor = [Colors.red , Colors.yellow , Colors.pink , Colors.orange];
  // final double width = 75;
  // final double height = 40;
  // final double borderRadius = 10;

  final List<Color> btnColors;
  final double width;
  final double height;
  final double borderRadius;
  final Color borderColor;
  final double borderwidth;
  final String name;

  ButtonModel({
    required this.btnColors,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.borderColor,
    required this.borderwidth,
    required this.name,
  });
}
