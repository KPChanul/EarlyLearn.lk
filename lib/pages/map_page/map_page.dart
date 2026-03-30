import 'package:early_learn/games_lession/first/first_game.dart';
import 'package:early_learn/games_lession/first/first_lession.dart';
import 'package:early_learn/games_lession/second/second_game.dart';
import 'package:early_learn/games_lession/second/second_lession.dart';
import 'package:early_learn/games_lession/third/third_game.dart';
import 'package:early_learn/games_lession/third/third_lession.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
// import 'package:mine/games_lession/first/first_game.dart';
// import 'package:mine/games_lession/first/first_lession.dart';
// import 'package:mine/games_lession/second/second_game.dart';
// import 'package:mine/games_lession/second/second_lession.dart';
// import 'package:mine/games_lession/third/third_game.dart';
// import 'package:mine/games_lession/third/third_lession.dart';
import '../../data/node_data.dart';
import '../../models/node_model/node_model.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nodes = NodeData().nodeDataList;

    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            double worldHeight = 1400;
            double width = constraints.maxWidth;

            return SingleChildScrollView(
              reverse: true,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/map.jpg',
                    width: width,
                    height: worldHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: width,
                      height: worldHeight,
                      color: Colors.green[200],
                      child: const Center(child: Text("Loading Map...")),
                    ),
                  ),

                  ..._buildPathDots(nodes, width, worldHeight),

                  ...nodes.map((node) {
                    double xPos =
                        (width * 0.5 - 40) +
                        (math.sin(node.number * 1.2) * (width * 0.28));
                    double yPos = worldHeight - (node.number * 180) - 100;

                    return Positioned(
                      left: xPos,
                      top: yPos,
                      child: GestureDetector(
                        onTap: () => _navigateToPage(context, node.number),
                        child: _build3DNode(node),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _build3DNode(NodeModel node) {
    bool isLesson = node.name.toLowerCase() == "lession";

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: node.color,
            shape: isLesson ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isLesson ? null : BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // ignore: deprecated_member_use
              colors: [node.color.withOpacity(0.6), node.color],
            ),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 10),
                blurRadius: 8,
              ),
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.4),
                offset: const Offset(-2, -2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              isLesson
                  ? Icons.menu_book_rounded
                  : Icons.videogame_asset_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: node.color, width: 2),
          ),
          child: Text(
            "${node.number}. ${node.name.toUpperCase()}",
            style: TextStyle(
              // ignore: deprecated_member_use
              color: node.color.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToPage(BuildContext context, int nodeNumber) {
    Widget target;
    switch (nodeNumber) {
      case 1:
        target = const FirstLession();
        break;
      case 2:
        target = const FirstGame();
        break;
      case 3:
        target = const SecondLession();
        break;
      case 4:
        target = const SecondGame();
        break;
      case 5:
        target = const ThirdLession();
        break;
      case 6:
        target = const ThirdGame();
        break;
      default:
        target = const MapPage();
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => target));
  }
}

Widget _smallNodeball() {
  return Container(
    width: 23,
    height: 23,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      // ignore: deprecated_member_use
      color: Colors.white.withOpacity(0.8),
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
  );
}

List<Widget> _buildPathDots(
  List<NodeModel> nodes,
  double width,
  double worldHeight,
) {
  List<Widget> dots = [];

  for (var node in nodes) {
    for (int i = 1; i <= 3; i++) {
      double step = node.number - (i * 0.25);

      if (step < 0.5) continue;

      double xPos =
          (width * 0.5 - 11.5) + (math.sin(step * 1.2) * (width * 0.28));
      double yPos = worldHeight - (step * 180) - 60;

      dots.add(Positioned(left: xPos, top: yPos, child: _smallNodeball()));
    }
  }
  return dots;
}
