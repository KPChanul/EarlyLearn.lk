import 'package:flutter/material.dart';

class FirstLession extends StatelessWidget {
  const FirstLession({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          style: TextStyle(
            color: Colors.blue,
          ),
          "first_lession",
        
        ),
      ),
    );
  }
}