import 'package:early_learn/pages/acc_page/account_page.dart';
import 'package:early_learn/pages/home_page/home_page.dart';
import 'package:early_learn/pages/map_page/map_page.dart';
import 'package:early_learn/pages/reward_page/reward_page.dart';
import 'package:flutter/material.dart';
// import 'package:mine/pages/acc_page/account_page.dart';
// import 'package:mine/pages/home_page/home_page.dart';
// import 'package:mine/pages/map_page/map_page.dart';
// import 'package:mine/pages/reward_page/reward_page.dart';



class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

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
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 2, 103, 7),
          selectedItemColor: const Color.fromARGB(255, 250, 232, 172),
          unselectedItemColor: const Color.fromARGB(255, 182, 246, 185),
          currentIndex: _maincurrentIndex,
          onTap: (index) {
            setState(() {
              _maincurrentIndex = index;
            });
          },

          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "HOME"),
            BottomNavigationBarItem(icon: Icon(Icons.map),label: "MAP"),
            BottomNavigationBarItem(icon: Icon(Icons.redeem),label: "REWARD"),
            BottomNavigationBarItem(icon: Icon(Icons.person),label: "PROFILE"),
          ],
        ),
        body: pages[_maincurrentIndex],
      ),
    );
  }
}