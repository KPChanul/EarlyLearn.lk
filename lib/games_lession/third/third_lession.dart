import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ThirdLession extends StatelessWidget {
  const ThirdLession({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Math Lesson 3")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          _LessonVideoPlayer(
            videoId: '50Yn7L_RNAE', // Extracted from your addition link
            title: "Part 1: Addition",
          ),
          Divider(height: 50, color: Colors.grey),
          _LessonVideoPlayer(
            videoId: 'Xl8kJSOnyDo', // Extracted from your subtraction link
            title: "Part 2: Subtraction",
          ),
        ],
      ),
    );
  }
}

// A simple local widget to handle the player lifecycle
class _LessonVideoPlayer extends StatefulWidget {
  final String videoId;
  final String title;

  const _LessonVideoPlayer({required this.videoId, required this.title});

  @override
  State<_LessonVideoPlayer> createState() => _LessonVideoPlayerState();
}

class _LessonVideoPlayerState extends State<_LessonVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        YoutubePlayer(controller: _controller),
      ],
    );
  }
}
