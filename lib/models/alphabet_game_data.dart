/* import 'alphabet_questions.dart';

final List<AlphabetQuestion> alphabetQuestionsData = [
  AlphabetQuestion(
    imagePath: 'assets/images/apple.png', // Add a picture of an apple
    audioPath: 'audio/annasi.mp3',        // Add audio saying the word
    options: ['අ', 'ඇ', 'ඉ'],
    correctAnswer: 'අ', 
  ),
  AlphabetQuestion(
    imagePath: 'assets/images/elephant.png', // Add a picture of an elephant
    audioPath: 'audio/etha.mp3',             // Add audio saying the word
    options: ['එ', 'ඇ', 'ඔ'],
    correctAnswer: 'ඇ', 
  ),
  // adding pending.....
]; */
import 'alphabet_questions.dart';

// ─── Alphabet Questions Data ───────────────────────────────────────────────────
// Central data store for all Sinhala alphabet questions.
// Organised by DifficultyLevel for progressive difficulty support.

final List<AlphabetQuestion> alphabetQuestionsData = [

  // ── Easy ──────────────────────────────────────────────────────────────────
  AlphabetQuestion(
    imagePath:     'assets/images/apple.png',
    audioPath:     'audio/annasi.mp3',
    options:       ['අ', 'ඇ', 'ඉ'],
    correctAnswer: 'අ',
    wordLabel:     'අන්නාසි',          // Pineapple
    difficulty:    DifficultyLevel.easy,
    hintText:      'Starts like "A" in English!',
  ),

  AlphabetQuestion(
    imagePath:     'assets/images/elephant.png',
    audioPath:     'audio/etha.mp3',
    options:       ['ඇ', 'එ', 'ඔ'],
    correctAnswer: 'ඇ',
    wordLabel:     'ඇත්තා',            // Elephant
    difficulty:    DifficultyLevel.easy,
    hintText:      'Listen carefully to the beginning sound!',
  ),

  AlphabetQuestion(
    imagePath:     'assets/images/fish.png',
    audioPath:     'audio/issa.mp3',
    options:       ['ඉ', 'අ', 'උ'],
    correctAnswer: 'ඉ',
    wordLabel:     'ඉස්සා',            // Prawn / Shrimp
    difficulty:    DifficultyLevel.easy,
    hintText:      'Short "i" sound!',
  ),

  AlphabetQuestion(
    imagePath:     'assets/images/owl.png',
    audioPath:     'audio/ulama.mp3',
    options:       ['උ', 'ඉ', 'ඊ'],
    correctAnswer: 'උ',
    wordLabel:     'උලමා',             // Owl
    difficulty:    DifficultyLevel.easy,
    hintText:      'Sounds like "oo"!',
  ),

  // ── Medium ────────────────────────────────────────────────────────────────
  AlphabetQuestion(
    imagePath:     'assets/images/dog.png',
    audioPath:     'audio/balla.mp3',
    options:       ['බ', 'ප', 'ද', 'ත'],
    correctAnswer: 'බ',
    wordLabel:     'බල්ලා',            // Dog
    difficulty:    DifficultyLevel.medium,
    hintText:      'Think of the letter that sounds like "ba"!',
  ),

  AlphabetQuestion(
    imagePath:     'assets/images/cat.png',
    audioPath:     'audio/poosa.mp3',
    options:       ['ප', 'ෆ', 'බ', 'ම'],
    correctAnswer: 'ප',
    wordLabel:     'පූසා',             // Cat
    difficulty:    DifficultyLevel.medium,
    hintText:      'Starts with a "p" sound!',
  ),

  AlphabetQuestion(
    imagePath:     'assets/images/mango.png',
    audioPath:     'audio/amba.mp3',
    options:       ['ම', 'ත', 'ද', 'බ'],
    correctAnswer: 'ම',
    wordLabel:     'අඹ',               // Mango
    difficulty:    DifficultyLevel.medium,
    hintText:      'A sweet fruit beginning with "m"!',
  ),

  // ── Hard ──────────────────────────────────────────────────────────────────
  AlphabetQuestion(
    imagePath:     'assets/images/butterfly.png',
    audioPath:     'audio/leli.mp3',
    options:       ['ල', 'ශ', 'ළ', 'ල'],
    correctAnswer: 'ළ',
    wordLabel:     'ළමා',              // Child (uses retroflex ළ)
    difficulty:    DifficultyLevel.hard,
    hintText:      'Two letters look similar — listen carefully!',
  ),

  AlphabetQuestion(
    imagePath:     'assets/images/star.png',
    audioPath:     'audio/tharaka.mp3',
    options:       ['ත', 'ට', 'ථ', 'ඩ'],
    correctAnswer: 'ත',
    wordLabel:     'තාරකා',            // Star
    difficulty:    DifficultyLevel.hard,
    hintText:      'Soft "t" sound, not the hard one!',
  ),
];

// ── Filtered helpers (used by AlphabetGameLogic for level selection) ──────────
List<AlphabetQuestion> getQuestionsByDifficulty(DifficultyLevel level) =>
    alphabetQuestionsData.where((q) => q.difficulty == level).toList();

List<AlphabetQuestion> getEasyQuestions()   => getQuestionsByDifficulty(DifficultyLevel.easy);
List<AlphabetQuestion> getMediumQuestions() => getQuestionsByDifficulty(DifficultyLevel.medium);
List<AlphabetQuestion> getHardQuestions()   => getQuestionsByDifficulty(DifficultyLevel.hard);