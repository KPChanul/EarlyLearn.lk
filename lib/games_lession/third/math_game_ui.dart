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
                const SizedBox(height: 20),
                Text(
                  "Final Score: ${engine.score}",
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Text(
              "Score: ${engine.score}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            engine.currentStage == 1
                ? _buildEmojiVisual(engine.currentQuestion, engine.currentEmoji)
                : _buildNumberVisual(engine.currentQuestion),

            const SizedBox(height: 50),

            // 2x2 Grid Layout
            Column(
              children: [
                Row(children: [_buildAnswerButton(0), _buildAnswerButton(1)]),
                Row(children: [_buildAnswerButton(2), _buildAnswerButton(3)]),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnswerButton(int index) {
    return Expanded(
      child: Container(
        height: 100,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () => engine.checkAnswer(index),
          child: Text(
            "${engine.currentQuestion.options[index]}",
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiVisual(MathQuestion q, String emoji) {
    String op = q.operation == MathOperation.addition ? "+" : "-";
    return Column(
      children: [
        Text(
          "${emoji * q.operand1}  $op  ${emoji * q.operand2}",
          style: const TextStyle(fontSize: 60),
          textAlign: TextAlign.center,
        ),
        const Text(
          "= ?",
          style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildNumberVisual(MathQuestion q) {
    String op = q.operation == MathOperation.addition ? "+" : "-";
    return Text(
      "${q.operand1} $op ${q.operand2} = ?",
      style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
    );
  }
}
