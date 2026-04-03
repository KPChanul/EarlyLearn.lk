import 'package:flutter/material.dart';
import '../models/alphabet_game_logic.dart';
import '../services/audio_manager.dart';

class AlphabetGameScreen extends StatefulWidget {
  const AlphabetGameScreen({super.key});

  @override
  State<AlphabetGameScreen> createState() => _AlphabetGameScreenState();
}

class _AlphabetGameScreenState extends State<AlphabetGameScreen> {
  final AlphabetGameLogic _game = AlphabetGameLogic();
  final AudioManager _audioManager = AudioManager();
  
  String _feedbackMessage = "Listen to the word and choose the letter!";

  @override
  void initState() {
    super.initState();
    _game.startGame();
  }

  @override
  void dispose() {
    _audioManager.dispose(); // Clean up audio memory
    super.dispose();
  }

  void _handleAnswer(String selected) {
    var currentQ = _game.getCurrentQuestion()!;
    bool isCorrect = _game.checkAnswer(selected, currentQ.correctAnswer);

    _audioManager.playSfx(isCorrect);

    setState(() {
      if (isCorrect) {
        _feedbackMessage = "Correct! 🎉";
        _game.nextQuestion();
        
        if (_game.getCurrentQuestion() == null) {
          _feedbackMessage = "Game Over! You scored ${_game.score}";
          _game.endGame();
        }
      } else {
        _feedbackMessage = "Oops, try again! ❌";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentQ = _game.getCurrentQuestion();

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(_game.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: currentQ == null
            ? Text(_feedbackMessage, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Score: ${_game.score}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  const SizedBox(height: 30),
                  
                  // Image and Audio Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                        ),
                        clipBehavior: Clip.antiAlias,
                        // Make sure you have these images in your assets folder!
                        child: Image.asset(currentQ.imagePath, fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Center(child: Text("Image Missing")),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 40,
                          color: Colors.white,
                          icon: const Icon(Icons.volume_up),
                          onPressed: () => _audioManager.playWord(currentQ.audioPath),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Answer Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: currentQ.options.map((option) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                          ),
                          onPressed: () => _handleAnswer(option),
                          child: Text(option, style: const TextStyle(fontSize: 40, color: Colors.white)),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 40),
                  Text(
                    _feedbackMessage,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _feedbackMessage.contains("Correct") ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}