import 'package:flutter/material.dart';   //fultter's UI toolkit import
import 'games.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //prepares Flutter before app starts
    runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, //remove debug banner
      //call the game 
      home: PremiumKidsGameScreen(), 
    ));
  
}