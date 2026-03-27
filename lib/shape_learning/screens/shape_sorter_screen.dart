import 'package:flutter/material.dart';
import '../logic/sound_manager.dart';

class ShapeSorterScreen extends StatefulWidget {
  const ShapeSorterScreen({super.key});

  @override
  State<ShapeSorterScreen> createState() => _ShapeSorterScreenState();
}

class _ShapeSorterScreenState extends State<ShapeSorterScreen> {
  final SoundManager _soundManager = SoundManager();
  Map<IconData, bool> placedShapes = {
    Icons.circle: false,
    Icons.square: false,
    Icons.change_history: false,
  };

  void _checkWinCondition() {
    if (placedShapes.values.every((isPlaced) => isPlaced == true)) {
      _soundManager.playCorrectSound();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Text(
            'නියමයි! 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          content: const Text(
            'ඔබ සියලු හැඩතල ගැලපුවා!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'අවසන් කරන්න 🌟',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/level1_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Level 2',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text(
                  'නිවැරදි තැනට අදින්න!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDragTarget(Icons.circle, Colors.redAccent),
                  _buildDragTarget(Icons.square, Colors.blueAccent),
                  _buildDragTarget(Icons.change_history, Colors.green.shade600),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDraggable(
                      Icons.change_history,
                      Colors.green.shade600,
                    ),
                    _buildDraggable(Icons.circle, Colors.redAccent),
                    _buildDraggable(Icons.square, Colors.blueAccent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragTarget(IconData shapeIcon, Color color) {
    bool isPlaced = placedShapes[shapeIcon]!;
    return DragTarget<IconData>(
      onWillAccept: (data) => data == shapeIcon,
      onAccept: (data) {
        setState(() => placedShapes[shapeIcon] = true);
        _soundManager.playCorrectSound();
        _checkWinCondition();
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: isPlaced
                ? color.withOpacity(0.3)
                : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPlaced ? color : Colors.white,
              width: 4,
              style: isPlaced ? BorderStyle.solid : BorderStyle.none,
            ),
          ),
          child: Icon(
            shapeIcon,
            size: 80,
            color: isPlaced ? color : Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildDraggable(IconData shapeIcon, Color color) {
    bool isPlaced = placedShapes[shapeIcon]!;
    if (isPlaced) return const SizedBox(width: 100, height: 100);
    return Draggable<IconData>(
      data: shapeIcon,
      feedback: Material(
        color: Colors.transparent,
        child: Icon(shapeIcon, size: 110, color: color.withOpacity(0.8)),
      ),
      childWhenDragging: Icon(
        shapeIcon,
        size: 100,
        color: Colors.grey.withOpacity(0.3),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(shapeIcon, size: 80, color: color),
      ),
    );
  }
}
