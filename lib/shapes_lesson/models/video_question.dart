class VideoQuestion {
  final int triggerSecond; // The exact second the video should pause
  final String questionText;
  final List<String> options; // Example: ['circle', 'square', 'triangle']
  final int correctIndex;
  bool isAsked =
      false; // Prevents the video from pausing at the same second twice

  VideoQuestion({
    required this.triggerSecond,
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });
}
