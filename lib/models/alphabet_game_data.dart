import 'alphabet_questions.dart';

final List<AlphabetQuestion> alphabetQuestionsData = [
  AlphabetQuestion(
    imagePath: 'assets/images/apple_1.png', // Add a picture of an apple
    audioPath: 'audio/apple_s.ogg',        // Add audio saying the word
    options: ['ඇ', 'අ', 'ඉ'],
    correctAnswer: 'ඇ', 
  ),
  AlphabetQuestion(
    imagePath: 'assets/images/elephant_2_.jpg', // Add a picture of an elephant
    audioPath: 'audio/aliya.ogg',             // Add audio saying the word
    options: ['එ', 'අ', 'ඔ'],
    correctAnswer: 'අ', 
  ),
  // adding pending.....
   AlphabetQuestion(
    imagePath: 'assets/images/goat_3.jpg', // Add a picture of an elephant
    audioPath: 'audio/eluwa.ogg',             // Add audio saying the word
    options: ['ඉ', 'උ', 'එ'],
    correctAnswer: 'එ', 
  ),
]; 
