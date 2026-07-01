import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/learning_controller.dart';
import 'package:early_learn/shape_learning/screens/shape_game_screen.dart';

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
    _controller.initializeVideo('1SklXEjUvTA');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text(
          'පිටවෙන්නද? (Exit?)',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'ඔබට නිසැකවම පාඩමෙන් ඉවත් වීමට අවශ්‍යද?',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'නැත (No)',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text(
              'ඔව් (Yes)',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

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
      case 'diamond':
        return Icons.diamond;
      case 'rectangle':
        return Icons.rectangle;
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
      case 'diamond':
        return Colors.orange;
      case 'rectangle':
        return const Color.fromARGB(255, 211, 224, 21);
      default:
        return Colors.grey;
    }
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.purpleAccent, width: 4),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: const Text(
        'හැඩතල ඉගෙන ගනිමු',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: YoutubePlayer(
          controller: _controller.youtubeController,
          showVideoProgressIndicator: true,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionArea(bool isLandscape) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (_controller.activeQuestion == null) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.purple.shade200, width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 50,
                  color: Colors.purple.shade300,
                ),
                const SizedBox(height: 15),
                const Text(
                  'වීඩියෝව හොඳින් නරඹන්න...\nසැඟවුණු හැඩතල සොයමු!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '(Watch carefully to find the shapes!)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.redAccent.withOpacity(0.6),
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Icon(
                      Icons.square,
                      color: Colors.blueAccent.withOpacity(0.6),
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Icon(
                      Icons.change_history,
                      color: Colors.green.withOpacity(0.6),
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Icon(
                      Icons.diamond,
                      color: Colors.orange.withOpacity(0.6),
                      size: 30,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber, width: 4),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.help_outline, size: 40, color: Colors.amber),
              const SizedBox(height: 10),
              Text(
                _controller.activeQuestion!.questionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: List.generate(
                  _controller.activeQuestion!.options.length,
                  (index) {
                    String shapeName =
                        _controller.activeQuestion!.options[index];
                    return GestureDetector(
                      onTap: () {
                        bool correct = _controller.checkAnswer(index);
                        if (correct) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'නියමයි! (Great job!)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'නැවත උත්සාහ කරන්න! (Try again!)',
                                style: TextStyle(fontSize: 16),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _getIconColor(shapeName),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _getIconColor(shapeName).withOpacity(0.3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          _getIcon(shapeName),
                          size: 35,
                          color: _getIconColor(shapeName),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: _confirmExit,
            icon: const Icon(Icons.exit_to_app, color: Colors.white, size: 20),
            label: const Text(
              'පිටවෙන්න',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShapeGameScreen(),
                ),
              );
            },
            child: const Row(
              children: [
                Text(
                  'ඊළඟට',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            bool isLandscape = orientation == Orientation.landscape;

            if (!isLandscape) {
              return Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildVideoPlayer(),
                          _buildQuestionArea(false),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomNavigation(),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: SingleChildScrollView(child: _buildVideoPlayer()),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildHeader(),
                        Expanded(
                          child: SingleChildScrollView(
                            child: _buildQuestionArea(true),
                          ),
                        ),
                        _buildBottomNavigation(),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
