import 'package:flutter/material.dart';
import '../game_data.dart'; 

class FlashcardDisplay extends StatelessWidget {
  final AlphabetLesson lesson; // We pass the current lesson data here

  const FlashcardDisplay({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF1E90FF), width: 6),
        boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 8))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              lesson.word, 
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E90FF), letterSpacing: 2)
            ),
          ),
          Container(height: 4, color: const Color(0xFF1E90FF)),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(19), bottomRight: Radius.circular(19)),
              child: Image.asset(
                lesson.imagePath, 
                width: double.infinity, 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}