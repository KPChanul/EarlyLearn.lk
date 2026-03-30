import 'package:flutter/material.dart';

class SecondGame extends StatelessWidget {
  const SecondGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          style: TextStyle(
            color: Colors.blue,
          ),
          "Second Game",
        
        ),
      ),
    );
  }
}