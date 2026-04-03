import 'package:flutter/material.dart';
import '../controllers/shape_game_controller.dart';
import 'base_game_layout.dart';
import 'real_world_sorter_screen.dart';

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
    _controller.checkAnswer(index);
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() => _highlightedIndex = -1);
      _controller.nextQuestion();
    });
  }

  Color _getShapeColor(IconData icon) {
    if (icon == Icons.favorite) return Colors.redAccent;
    if (icon == Icons.square) return Colors.blueAccent;
    if (icon == Icons.change_history) return Colors.green.shade600;
    if (icon == Icons.star) return Colors.amber;
    if (icon == Icons.circle) return Colors.orangeAccent;
    return Colors.purpleAccent;
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

        return BaseGameLayout(
          controller: _controller,
          title: questionData['question'],
          onNextLevel: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const RealWorldSorterScreen()),
          ),
          onRetry: () {
            _controller.loadLevel(1);
            setState(() => _highlightedIndex = -1);
          },
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.lightbulb,
                    color: Colors.orangeAccent,
                    size: 45,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 5)],
                  ),
                  onPressed: _useHint,
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Colors.blueAccent.withOpacity(0.3),
                      width: 5,
                    ),
                  ),
                ),
                child: Wrap(
                  spacing: 25,
                  runSpacing: 25,
                  alignment: WrapAlignment.center,
                  children: List.generate(options.length, (index) {
                    Color shapeColor = _getShapeColor(options[index]);

                    return GestureDetector(
                      onTap: () => onAnswerSelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 120,
                        height: 120,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: _highlightedIndex == index
                              ? Colors.yellow.shade100
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: shapeColor.withOpacity(0.6),
                            width: 6,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: shapeColor.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 3,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: FittedBox(
                          child: Icon(options[index], color: shapeColor),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
