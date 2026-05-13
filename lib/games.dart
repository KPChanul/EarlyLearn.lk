import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'game_data.dart'; 
import 'widget_ialesson/toy_button.dart';
import 'widget_ialesson/letter_painter.dart';
import 'widget_ialesson/ialesson_bg.dart';
import 'widget_ialesson/flashcard_display.dart';

// MAIN GAME SCREEN

class PremiumKidsGameScreen extends StatefulWidget {
  const PremiumKidsGameScreen({super.key});

  @override
  State<PremiumKidsGameScreen> createState() => _PremiumKidsGameScreenState();
}

class _PremiumKidsGameScreenState extends State<PremiumKidsGameScreen> {
  int currentIndex = 0; 
  List<Offset?> points = [];
  bool hasTraced = false;
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  //Runs when the game opens
  @override
  void initState() {
    super.initState();
    // Force the phone into Landscape mode for the game
      SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  // RUNS WHEN THE GAME CLOSES
  @override
  void dispose() {
    // Force the phone back into Portrait mode for the main menu
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _audioPlayer.dispose(); // Always clean up audio to prevent memory leaks!
    super.dispose();
  }
  void _playAudio(String fileName) async {
    await _audioPlayer.play(AssetSource('audio/$fileName'));
  }

  void _nextLetter() {
    if (currentIndex < sinhalaAlphabet.length - 1) {
      setState(() {
        currentIndex++;
        points.clear();
        hasTraced = false;
      });
    }
  }

  void _previousLetter() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        points.clear();
        hasTraced = false;
      });
    }
  }
  // EXIT CONFIRMATION DIALOG 
  void confirmExit() {
    showDialog(
      context: context,
      barrierDismissible: false, // Forces them to tap a button
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Exit Game?", 
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 26)
            )
          ),
          content: const Text(
            "Are you sure you want to leave?", 
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.black87)
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            // THE "NO" BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Just close the popup!
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text("No", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            
            // THE "YES" BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              onPressed: () {
                _audioPlayer.stop(); // Stop any audio
                Navigator.of(dialogContext).pop(); // 1. Close the popup
                Navigator.of(context).pop();       // 2. Close the game
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text("Yes", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }
@override
  Widget build(BuildContext context) {
    final currentLesson = sinhalaAlphabet[currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          // 1. THIS REPLACES ALL THE OLD BACKGROUND, CLOUDS, AND GRASS CODE!
          const GameBackground(), 

          // --- FOREGROUND (Game Elements) ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 45.0, left: 15.0, right: 15.0, bottom: 15.0),
              child: Row(
                children: [
                  
                  // === LEFT SIDE ===
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        
                        // 2. THIS REPLACES THAT MASSIVE FLASHCARD CONTAINER!
                        Expanded(
                          child: FlashcardDisplay(lesson: currentLesson)
                        ),
                        
                        const SizedBox(height: 15),

                        ToyButton(
                          icon: Icons.volume_up, 
                          text: "Word", 
                          color: const Color(0xFFE91E63),
                          isActive: hasTraced,
                          onTap: () => _playAudio(currentLesson.animalAudioPath),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 25),

                  // === RIGHT SIDE: TRACING BOARD & LETTER BUTTON ===
                  // (This side stays exactly the same so your drawing logic still works)
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFA500), 
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: const [BoxShadow(color: Colors.black38, offset: Offset(0, 10))],
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Opacity(
                                          opacity: 0.3, 
                                          child: Image.asset(
                                            currentLesson.tracingGuidePath,
                                            width: 250, 
                                            height: 250,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) => Text(currentLesson.letter, style: const TextStyle(fontSize: 200, color: Colors.black12)),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onPanUpdate: (details) {
                                          setState(() {
                                            points.add(details.localPosition);
                                            hasTraced = true;
                                          });
                                        },
                                        onPanEnd: (details) => setState(() => points.add(null)),
                                        child: Container(
                                          color: Colors.transparent,
                                          width: double.infinity, height: double.infinity,
                                          child: CustomPaint(painter: LetterPainter(points)),
                                        ),
                                      ),
                                      Positioned(
                                        top: 15, right: 15,
                                        child: GestureDetector(
                                          onTap: () => setState(() { points.clear(); hasTraced = false; }),
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: const BoxDecoration(
                                              color: Colors.redAccent, shape: BoxShape.circle,
                                              boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, 4))],
                                            ),
                                            child: const Icon(Icons.delete_forever, color: Colors.white, size: 32),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              if (currentIndex > 0)
                                Positioned(
                                  left: -20, top: 0, bottom: 0,
                                  child: Center(
                                    child: FloatingActionButton(
                                      backgroundColor: Colors.blueAccent,
                                      onPressed: _previousLetter,
                                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                                    ),
                                  ),
                                ),
                              
                              if (currentIndex < sinhalaAlphabet.length - 1)
                                Positioned(
                                  right: -20, top: 0, bottom: 0,
                                  child: Center(
                                    child: FloatingActionButton(
                                      backgroundColor: Colors.green,
                                      onPressed: _nextLetter,
                                      child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 15),

                        ToyButton(
                          icon: Icons.record_voice_over,
                          text: "Letter", 
                          color: const Color(0xFFFF9800),
                          isActive: hasTraced,
                          onTap: () => _playAudio(currentLesson.letterAudioPath), 
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // THE EXIT BUTTON
          Positioned(
            top: -18,
            left: -40,
            child: SafeArea(
              child: GestureDetector(
                onTap:confirmExit,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [BoxShadow(color: Colors.black38, offset: Offset(0, 4))],
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 30),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}

