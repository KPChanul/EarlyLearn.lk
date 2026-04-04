import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/video_question.dart';

class LearningController extends ChangeNotifier {
  late YoutubePlayerController youtubeController;

  VideoQuestion? activeQuestion;
  bool isCorrectAnswerGiven = false;

  // These questions perfectly match the DP Education video!
  final List<VideoQuestion> _questions = [
    VideoQuestion(
      triggerSecond: 26,
      questionText:
          'ඔබ දැක්කද? කාර් එකේ රෝද මොන හැඩයෙන්ද තිබුණේ?\n(What shape were the car wheels?)',
      options: ['square', 'triangle', 'circle'],
      correctIndex: 2,
    ),
    VideoQuestion(
      triggerSecond: 57,
      questionText:
          'බෝට්ටුවේ රුවල මොන හැඩයක්ද?\n(What shape was the boat sail?)',
      options: ['triangle', 'heart', 'star'],
      correctIndex: 0,
    ),
  ];

  void initializeVideo(String videoId) {
    youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: false,
      ),
    );

    youtubeController.addListener(_videoListener);
  }

  void _videoListener() {
    if (activeQuestion == null) {
      int currentSecond = youtubeController.value.position.inSeconds;

      for (var question in _questions) {
        if (currentSecond == question.triggerSecond && !question.isAsked) {
          question.isAsked = true;
          youtubeController.pause();

          activeQuestion = question;
          isCorrectAnswerGiven = false;
          notifyListeners();
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
      youtubeController.play();
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    youtubeController.removeListener(_videoListener);
    youtubeController.dispose();
    super.dispose();
  }
}
