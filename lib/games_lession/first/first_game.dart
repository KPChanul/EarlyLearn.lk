import 'package:flutter/material.dart';

class FirstGame extends StatelessWidget {
  const FirstGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          style: TextStyle(
            color: Colors.blue,
          ),
          "First Game",
        
        ),
      ),
    );
  }
}