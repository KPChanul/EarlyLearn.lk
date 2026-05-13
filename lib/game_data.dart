
class AlphabetLesson {
  final String letter;
  final String word;
  final String imagePath;
  final String tracingGuidePath;
  final String letterAudioPath;
  final String animalAudioPath;

  AlphabetLesson({
    required this.letter, 
    required this.word, 
    required this.imagePath, 
    required this.tracingGuidePath,
    required this.letterAudioPath,
    required this.animalAudioPath,
  });
}
final List<AlphabetLesson> sinhalaAlphabet = [
  AlphabetLesson(
    letter: "අ",
    word: "අම්මා",
    imagePath: "assets/images/amma final.png", 
    tracingGuidePath: "assets/images/a1guide.png", 
    letterAudioPath: "a1.mp3", 
    animalAudioPath: "amma audio.mp3",
  ),
  AlphabetLesson(
    letter: "ආ",
    word: "ආච්චි", 
    imagePath: "assets/images/grandmother.png",
    tracingGuidePath: "assets/images/a2guide.png",
    letterAudioPath: "a2.mp3",
    animalAudioPath: "grandmother audio.mp3",
  ),
  AlphabetLesson(
    letter: "ඇ",
    word: "ඇතා", 
    imagePath: "assets/images/tuskerpic.png",
    tracingGuidePath: "assets/images/a3guide.png",
    letterAudioPath: "a3.mp3",
    animalAudioPath: "tusker.mp3",
  ),

];