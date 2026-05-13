/* class AlphabetQuestion {
  final String imagePath;
  final String audioPath;
  final List<String> options;
  final String correctAnswer;

  AlphabetQuestion({
    required this.imagePath,
    required this.audioPath,
    required this.options,
    required this.correctAnswer,
  });
} */
// ─── AlphabetQuestion Model ───────────────────────────────────────────────────
// Immutable value object representing a single quiz question.
// Uses named parameters and final fields to enforce immutability (OOP best practice).

enum DifficultyLevel { easy, medium, hard }

class AlphabetQuestion {
  final String imagePath;
  final String audioPath;
  final List<String> options;
  final String correctAnswer;
  final String wordLabel;          // Sinhala/English label shown under the image
  final DifficultyLevel difficulty;
  final String hintText;           // Optional hint shown after a wrong attempt

  const AlphabetQuestion({
    required this.imagePath,
    required this.audioPath,
    required this.options,
    required this.correctAnswer,
    required this.wordLabel,
    this.difficulty = DifficultyLevel.easy,
    this.hintText = '',
  });

  // ── Convenience getters ────────────────────────────────────────────────────
  bool get hasHint => hintText.isNotEmpty;

  int get optionCount => options.length;

  /// Returns a human-readable difficulty label
  String get difficultyLabel {
    switch (difficulty) {
      case DifficultyLevel.easy:   return 'Easy';
      case DifficultyLevel.medium: return 'Medium';
      case DifficultyLevel.hard:   return 'Hard';
    }
  }

  /// Colour associated with difficulty for UI use
  int get difficultyColorValue {
    switch (difficulty) {
      case DifficultyLevel.easy:   return 0xFF2ECC71; // green
      case DifficultyLevel.medium: return 0xFFF39C12; // amber
      case DifficultyLevel.hard:   return 0xFFE74C3C; // red
    }
  }

  // ── copyWith pattern (useful for future game variations) ──────────────────
  AlphabetQuestion copyWith({
    String? imagePath,
    String? audioPath,
    List<String>? options,
    String? correctAnswer,
    String? wordLabel,
    DifficultyLevel? difficulty,
    String? hintText,
  }) {
    return AlphabetQuestion(
      imagePath:     imagePath     ?? this.imagePath,
      audioPath:     audioPath     ?? this.audioPath,
      options:       options       ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      wordLabel:     wordLabel     ?? this.wordLabel,
      difficulty:    difficulty    ?? this.difficulty,
      hintText:      hintText      ?? this.hintText,
    );
  }

  @override
  String toString() =>
      'AlphabetQuestion(word: $wordLabel, answer: $correctAnswer, difficulty: $difficultyLabel)';
}