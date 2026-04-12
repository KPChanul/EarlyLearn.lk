import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/video_question.dart';

class LearningController extends ChangeNotifier {
  late YoutubePlayerController youtubeController;

  VideoQuestion? activeQuestion;
  bool isCorrectAnswerGiven = false;

  // --- UPDATED: Perfect Timestamps for the DP Education Video ---
  final List<VideoQuestion> _questions = [
    VideoQuestion(
      triggerSecond:
          26, // Pops up right after the car and traffic lights (Circles)
      questionText:
          'ඔබ දැක්කද? කාර් එකේ රෝද මොන හැඩයෙන්ද තිබුණේ?\n(What shape were the car wheels?)',
      options: ['square', 'triangle', 'circle'],
      correctIndex: 2,
    ),
    VideoQuestion(
      triggerSecond: 36, // Pops up right after the house and gift box (Squares)
      questionText: 'තෑගි පෙට්ටිය මොන හැඩයක්ද?\n(What shape was the gift box?)',
      options: ['circle', 'square', 'star'],
      correctIndex: 1,
    ),
    VideoQuestion(
      triggerSecond: 60, // Pops up right after the bridge and boat (Triangles)
      questionText:
          'බෝට්ටුවේ රුවල මොන හැඩයක්ද?\n(What shape was the boat sail?)',
      options: ['triangle', 'heart', 'circle'],
      correctIndex: 0,
    ),

    VideoQuestion(
      triggerSecond:
          45, // Pops up right after they look at the house windows (Squares)
      questionText:
          'ඔබ දැක්කද? පිහිනුම් තටාකය මොන හැඩයෙන්ද තිබුණේ?\n(What shape was the swimming pool?)',
      options: ['circle', 'rectangle', 'triangle'],
      correctIndex: 1, // 'square'
    ),
    // VideoQuestion(
    //   triggerSecond:
    //       72, // Pops up right after the kids flying kites (Rhombus/Diamond)
    //   questionText: 'සරුංගලය මොන හැඩයක්ද?\n(What shape is the kite?)',
    //   options: [
    //     'rhombus',
    //     'triangle',
    //     'square',
    //   ], // Using standard shapes, maybe introduce Diamond later if you add the icon!
    //   correctIndex: 0,
    // ),
    VideoQuestion(
      triggerSecond:
          98, // Pops up right after they look closely at the number 8 on the cap (Circles)
      questionText:
          'තොප්පියේ තියෙන අංක 8 හැදිලා තියෙන්නේ මොන හැඩයෙන්ද?\n(What shape makes up the number 8 on the cap?)',
      options: ['circle', 'heart', 'square'],
      correctIndex: 0, // 'circle'
    ),
  ];

  void initializeVideo(String videoId) {
    youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: false,
        enableCaption: false,
        disableDragSeek: true, // <-- NEW: Stops kids from skipping ahead
      ),
    );

    youtubeController.addListener(_videoListener);
  }

  void _videoListener() {
    // Safety check: Make sure the video is actually loaded before checking the time
    if (!youtubeController.value.isReady) return;

    if (activeQuestion == null) {
      int currentSecond = youtubeController.value.position.inSeconds;

      for (var question in _questions) {
        // BUG FIX: Changed '==' to '>=' so it never misses the timestamp!
        if (currentSecond >= question.triggerSecond && !question.isAsked) {
          question.isAsked = true;
          youtubeController.pause(); // Stop the video

          activeQuestion = question;
          isCorrectAnswerGiven = false;
          notifyListeners(); // Draw the pop-up UI
          break;
        }
      }
    }
  }

  bool checkAnswer(int selectedIndex) {
    if (activeQuestion != null &&
        selectedIndex == activeQuestion!.correctIndex) {
      activeQuestion = null;
      isCorrectAnswerGiven = true;
      youtubeController.play(); // Resume the video
      notifyListeners();
      return true;
    }
    return false; // Wrong answer!
  }

  @override
  void dispose() {
    youtubeController.removeListener(_videoListener);
    youtubeController.dispose();
    super.dispose();
  }
}
