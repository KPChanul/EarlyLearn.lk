import 'package:flutter/material.dart';

class GameBackground extends StatelessWidget {
  const GameBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // --- BACKGROUND ---
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF87CEEB), Color(0xFFE0F6FF)], 
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
            ),
          ),
        ),

        // --- THE CLOUDS ---
        const Positioned(top: 30, left: 60, child: Opacity(opacity: 0.8, child: Icon(Icons.cloud, color: Colors.white, size: 100))),
        const Positioned(top: 20, right: 120, child: Opacity(opacity: 0.6, child: Icon(Icons.cloud, color: Colors.white, size: 70))),
        const Positioned(top: 15, right: 350, child: Opacity(opacity: 0.5, child: Icon(Icons.cloud, color: Colors.white, size: 60))),
        const Positioned(bottom: 110, right: 50, child: Opacity(opacity: 0.7, child: Icon(Icons.cloud, color: Colors.white, size: 40))),

        // --- THE GRASS ---
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFF7CFC00),
              borderRadius: BorderRadius.only(topLeft: Radius.elliptical(200, 40), topRight: Radius.elliptical(200, 40)),
            ),
          ),
        ),
      ],
    );
  }
}