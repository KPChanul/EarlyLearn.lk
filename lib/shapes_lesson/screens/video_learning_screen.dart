import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/learning_controller.dart';

class VideoLearningScreen extends StatefulWidget {
  const VideoLearningScreen({super.key});

  @override
  State<VideoLearningScreen> createState() => _VideoLearningScreenState();
}

class _VideoLearningScreenState extends State<VideoLearningScreen> {
  final LearningController _controller = LearningController();

  @override
  void initState() {
    super.initState();
    // DP Education Video ID
    _controller.initializeVideo('1SklXEjUvTA');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Visual Helpers
  IconData _getIcon(String name) {
    switch (name) {
      case 'circle':
        return Icons.circle;
      case 'square':
        return Icons.square;
      case 'triangle':
        return Icons.change_history;
      case 'star':
        return Icons.star;
      case 'heart':
        return Icons.favorite;
      default:
        return Icons.help;
    }
  }

  Color _getIconColor(String name) {
    switch (name) {
      case 'circle':
        return Colors.redAccent;
      case 'square':
        return Colors.blueAccent;
      case 'triangle':
        return Colors.green;
      case 'star':
        return Colors.amber;
      case 'heart':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
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
            children: [
              // --- HEADER ---
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.purpleAccent, width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text(
                  'හැඩතල ඉගෙන ගනිමු (Learn Shapes)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- YOUTUBE PLAYER & QUESTION OVERLAY ---
              ListenableBuilder(
                listenable: _controller,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 5),
                      boxShadow: const [
                        BoxShadow(color: Colors.black45, blurRadius: 15),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. The Video Player (At the bottom)
                          YoutubePlayer(
                            controller: _controller.youtubeController,
                            showVideoProgressIndicator: true,
                          ),

                          // 2. The Question Pop-Up (Draws on top of video if active)
                          if (_controller.activeQuestion != null)
                            Container(
                              color: Colors.black.withOpacity(
                                0.8,
                              ), // Darkens background
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.help_outline,
                                    size: 60,
                                    color: Colors.yellowAccent,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _controller.activeQuestion!.questionText,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(
                                      _controller
                                          .activeQuestion!
                                          .options
                                          .length,
                                      (index) {
                                        String shapeName = _controller
                                            .activeQuestion!
                                            .options[index];
                                        return GestureDetector(
                                          onTap: () {
                                            bool correct = _controller
                                                .checkAnswer(index);
                                            if (correct) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'නියමයි! (Great job!)',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'නැවත උත්සාහ කරන්න! (Try again!)',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: _getIconColor(shapeName),
                                                width: 4,
                                              ),
                                            ),
                                            child: Icon(
                                              _getIcon(shapeName),
                                              size: 40,
                                              color: _getIconColor(shapeName),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              // --- NAVIGATION BUTTON ---
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Connect this to your Game Engine navigation later!
                  },
                  child: const Text(
                    'ක්‍රීඩාවට යන්න (Go to Games) ➡️',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
