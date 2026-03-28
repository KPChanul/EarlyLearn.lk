import 'package:flutter/material.dart';
import '../controllers/shape_game_controller.dart';
import 'base_game_layout.dart';
import 'shape_sorter_screen.dart';

// HERE IT IS! The ShapeGameScreen class!
class ShapeGameScreen extends StatefulWidget {
  const ShapeGameScreen({super.key});

  @override
  State<ShapeGameScreen> createState() => _ShapeGameScreenState();
}

class _ShapeGameScreenState extends State<ShapeGameScreen> {
  final ShapeGameController _controller = ShapeGameController();
  int _highlightedIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller.loadLevel(1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _useHint() {
    String hintText = _controller.getHint();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'උදව්වක්! (Hint)',
          style: TextStyle(color: Colors.orange),
        ),
        content: Text(
          hintText,
          style: const TextStyle(fontSize: 24, color: Colors.deepPurple),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('හරි'),
          ),
        ],
      ),
    );
    setState(
      () =>
          _highlightedIndex = _controller.getCurrentQuestion()['correctIndex'],
    );
  }

  void onAnswerSelected(int index) {
    bool isCorrect = _controller.checkAnswer(index);

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() => _highlightedIndex = -1);

      if (!_controller.nextQuestion() &&
          (_controller.isGameWon || _controller.isGameOver)) {
        _showLevelCompleteDialog();
      }
    });
  }

  void _showLevelCompleteDialog() {
    bool passed = _controller.isGameWon;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          passed ? 'නියමයි! මට්ටම සමත්! 🎉' : 'අයියෝ! අසමත්! 😢',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            color: passed ? Colors.green : Colors.red,
          ),
        ),
        content: Text(
          'මුළු ලකුණු: ${_controller.score}\nකාලය: ${_controller.timeElapsedInSeconds}s',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (passed) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ShapeSorterScreen(),
                    ),
                  );
                } else {
                  _controller.loadLevel(1);
                }
              },
              child: Text(
                passed ? 'ඊළඟ මට්ටම ➡️' : 'නැවත උත්සාහ කරන්න 🔄',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (_controller.getCurrentQuestion().isEmpty)
          return const CircularProgressIndicator();

        var questionData = _controller.getCurrentQuestion();
        List<IconData> options = questionData['options'];

        // It puts the game inside the BaseGameLayout here!
        return BaseGameLayout(
          controller: _controller,
          title: questionData['question'],
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.lightbulb,
                    color: Colors.orange,
                    size: 40,
                  ),
                  onPressed: _useHint,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(options.length, (index) {
                  return GestureDetector(
                    onTap: () => onAnswerSelected(index),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _highlightedIndex == index
                            ? Colors.yellow
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent, width: 4),
                      ),
                      child: Icon(
                        options[index],
                        size: 60,
                        color: Colors.blueAccent,
                      ),
                    ),
                  );
                }),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
