import 'package:early_learn/pages/acc_page/account_page.dart';
import 'package:early_learn/pages/home_page/home_page.dart';
import 'package:early_learn/pages/map_page/map_page.dart';
import 'package:early_learn/pages/reward_page/reward_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:mine/pages/acc_page/account_page.dart';
// import 'package:mine/pages/home_page/home_page.dart';
// import 'package:mine/pages/map_page/map_page.dart';
// import 'package:mine/pages/reward_page/reward_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _maincurrentIndex = 0;

  final List <Widget> pages = [
    HomePage(),
    MapPage(),
    RewardPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Early Learn",
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _maincurrentIndex,
          onTap: (index) {
            setState(() {
              _maincurrentIndex = index;
            });
          },

          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "HOME"),
            BottomNavigationBarItem(icon: Icon(Icons.map),label: "MAP"),
            BottomNavigationBarItem(icon: Icon(Icons.gif_box_sharp),label: "REWARD"),
            BottomNavigationBarItem(icon: Icon(Icons.person),label: "PROFILE"),
          ],
        ),
        body: pages[_maincurrentIndex],
      ),
    );
  }
}