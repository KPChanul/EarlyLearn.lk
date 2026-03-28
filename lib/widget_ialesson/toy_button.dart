import 'package:flutter/material.dart';

class ToyButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  final bool isActive;
  final IconData icon;

  const ToyButton({super.key, required this.text, required this.color, required this.onTap, required this.isActive, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isActive ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 6))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(text, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}