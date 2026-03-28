import 'package:flutter/material.dart';
import '../controllers/base_game_controller.dart';
import 'base_game_layout.dart';
import 'grand_finale_screen.dart';

// ============================================================================
// 1. THE LEVEL 2 CONTROLLER (Engine Logic)
// ============================================================================
class ShapeSorterController extends BaseGameController {
  Map<IconData, bool> placedShapes = {};

  @override
  void setupGameData() {
    // Start the level with all 3 shapes NOT placed
    placedShapes = {
      Icons.circle: false,
      Icons.square: false,
      Icons.change_history: false,
    };
  }

  @override
  bool checkWinCondition() {
    // You win if every shape in the map is marked as 'true'
    return placedShapes.values.every((isPlaced) => isPlaced == true);
  }

  void placeShape(IconData shape) {
    if (!placedShapes[shape]!) {
      placedShapes[shape] = true;
      addScore(30); // Give them 30 points for a correct match!
      soundManager.playCorrectSound();

      if (checkWinCondition()) {
        isGameWon = true;
        stopTimer();
        rewardManager.processGameResult(true, score);
      }
      notifyListeners();
    }
  }

  void wrongDrop() {
    decreaseLife(); // Automatically handles the hearts and game over!
  }
}

// ============================================================================
// 2. THE LEVEL 2 UI SCREEN
// ============================================================================
class ShapeSorterScreen extends StatefulWidget {
  const ShapeSorterScreen({super.key});

  @override
  State<ShapeSorterScreen> createState() => _ShapeSorterScreenState();
}

class _ShapeSorterScreenState extends State<ShapeSorterScreen> {
  final ShapeSorterController _controller = ShapeSorterController();

  @override
  void initState() {
    super.initState();
    _controller.loadLevel(2);

    // Listen for when the game ends so we can trigger dialogs or navigation!
    _controller.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onGameStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onGameStateChanged() {
    // If they won, wait 1 second and teleport to the Grand Finale!
    if (_controller.isGameWon) {
      _controller.removeListener(_onGameStateChanged); // Stop listening
      Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GrandFinaleScreen()),
        );
      });
    }
    // If they lost all their hearts, show Game Over dialog
    else if (_controller.isGameOver) {
      _controller.removeListener(_onGameStateChanged);
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'අයියෝ! අසමත්! 😢',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'ඔබගේ ජීවිත අවසන්. නැවත උත්සාහ කරන්න!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              onPressed: () {
                Navigator.pop(context);
                // Reload the level to try again!
                _controller.loadLevel(2);
                _controller.addListener(_onGameStateChanged);
              },
              child: const Text(
                'නැවත උත්සාහ කරන්න 🔄',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder forces the UI to redraw when the timer ticks or a shape is dropped
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return BaseGameLayout(
          controller: _controller,
          title: 'නිවැරදි තැනට අදින්න!', // "Drag to the correct place!"
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Spacer(),

              // --- THE EMPTY TARGETS ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDragTarget(Icons.circle, Colors.redAccent),
                  _buildDragTarget(Icons.square, Colors.blueAccent),
                  _buildDragTarget(Icons.change_history, Colors.green.shade600),
                ],
              ),

              const Spacer(),

              // --- THE DRAGGABLE SHAPES (At the bottom of the screen) ---
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
        );
      },
    );
  }

  // --- WIDGET: The Empty Outlines ---
  Widget _buildDragTarget(IconData shapeIcon, Color color) {
    bool isPlaced = _controller.placedShapes[shapeIcon]!;

    return DragTarget<IconData>(
      // Check if they are dropping the correct shape
      onWillAccept: (data) => data == shapeIcon,
      // If it is correct, lock it in!
      onAccept: (data) => _controller.placeShape(shapeIcon),

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

  // --- WIDGET: The Solid Shapes to Drag ---
  Widget _buildDraggable(IconData shapeIcon, Color color) {
    bool isPlaced = _controller.placedShapes[shapeIcon]!;

    // If it's already placed, leave an empty space so the layout doesn't break
    if (isPlaced) return const SizedBox(width: 100, height: 100);

    return Draggable<IconData>(
      data: shapeIcon, // The invisible data being carried
      feedback: Material(
        color: Colors.transparent,
        child: Icon(shapeIcon, size: 110, color: color.withOpacity(0.8)),
      ), // What it looks like while dragging
      childWhenDragging: Icon(
        shapeIcon,
        size: 100,
        color: Colors.grey.withOpacity(0.3),
      ), // What is left behind while dragging
      onDraggableCanceled: (velocity, offset) {
        // Optional: If they drop it outside a target, play the wrong sound!
        _controller.soundManager.playWrongSound();
      },
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
