import 'package:flutter/material.dart';
import 'math_game_engine.dart';
import 'math_question_model.dart';

class MathGameUI extends StatelessWidget {
  final MathGameEngine engine;
  const MathGameUI({super.key, required this.engine});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: engine,
      builder: (context, child) {
        if (engine.isGameOver) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Game Over!",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Final Score: ${engine.score}",
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // Branding at the top
              const SizedBox(height: 10),
              _buildInfoBubble(
                "Early Learn",
                color: Colors.blue.shade100,
                textColor: Colors.blue.shade900,
              ),
              const SizedBox(height: 20),

              // Question Area
              SizedBox(
                height: 100,
                child: FittedBox(
                  child: engine.currentStage == 1
                      ? _buildEmojiVisual(
                          engine.currentQuestion,
                          engine.currentEmoji,
                        )
                      : _buildNumberVisual(engine.currentQuestion),
                ),
              ),
              const SizedBox(height: 20),

              // Answer Buttons
              Expanded(
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) => _buildAnswerButton(index),
                ),
              ),

              // Score at the bottom
              const SizedBox(height: 10),
              _buildInfoBubble(
                "Score: ${engine.score}",
                color: Colors.purple.shade100,
                textColor: Colors.purple.shade900,
              ),
              const SizedBox(height: 10),

              // Next Question Button
              if (engine.isFeedbackVisible)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () => engine.nextQuestion(),
                    child: const Text(
                      "Next Question",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoBubble(
    String text, {
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildAnswerButton(int index) {
    int val = engine.currentQuestion.options[index];
    bool isSelected = engine.selectedIndex == index;
    bool isCorrect = index == engine.currentQuestion.correctIndex;

    Color? backgroundColor;
    if (engine.isFeedbackVisible) {
      if (isCorrect) {
        backgroundColor = Colors.green.shade100;
      } else if (isSelected)
        backgroundColor = Colors.red.shade100;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
        onPressed: engine.isFeedbackVisible
            ? null
            : () => engine.checkAnswer(index),
        child: Row(
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: engine.currentStage == 1
                    ? (val == 0
                          ? const Text("0")
                          : Row(
                              children: List.generate(
                                val,
                                (i) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  child: Text(
                                    engine.currentEmoji,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                            ))
                    : Text("$val", style: const TextStyle(fontSize: 30)),
              ),
            ),
            if (engine.isFeedbackVisible && (isSelected || isCorrect))
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 35,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiVisual(MathQuestion q, String emoji) {
    String op = q.operation == MathOperation.addition ? "+" : "-";
    return Text(
      "${q.operand1 == 0 ? "0" : emoji * q.operand1} $op ${q.operand2 == 0 ? "0" : emoji * q.operand2} = ?",
      style: const TextStyle(fontSize: 60),
    );
  }

  Widget _buildNumberVisual(MathQuestion q) {
    return Text(
      "${q.operand1} ${q.operation == MathOperation.addition ? "+" : "-"} ${q.operand2} = ?",
      style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
    );
  }
}
