import 'package:flutter/material.dart';

class ChildAvatar extends StatelessWidget {
  final String name;
  final double size;
  final List<Color>? colors;

  const ChildAvatar(this.name, {super.key, this.size = 40, this.colors});

  String getInitials() {
    if (name.isEmpty) return 'NC';
    List<String> parts = name.split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (parts[0].length >= 2) {
      return parts[0].substring(0, 2).toUpperCase();
    } else {
      return parts[0][0].toUpperCase();
    }
  }

  Color _getColorForName(String name, BuildContext context) {
    if (colors != null && colors!.isNotEmpty) {
      return colors![name.hashCode % colors!.length];
    }
    final baseColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
    ];
    return baseColors[name.hashCode % baseColors.length];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: _getColorForName(name, context),
      child: Text(
        getInitials(),
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
