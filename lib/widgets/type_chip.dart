import 'package:flutter/material.dart';

class TypeChip extends StatelessWidget {
  final String type;
  const TypeChip({super.key, required this.type});

  Color _typeColor() {
    if (type.contains('Fire')) return Colors.red;
    if (type.contains('Steel')) return Colors.blueGrey;
    if (type.contains('Water')) return Colors.blue;
    if (type.contains('Earth')) return Colors.brown;
    if (type.contains('Wind')) return Colors.green;
    if (type.contains('Shadow')) return Colors.grey;
    if (type.contains('Lightning')) return Colors.amber;
    if (type.contains('Sky')) return Colors.pink;
    if (type.contains('Light')) return Colors.yellow;
    if (type.contains('Psychic')) return Colors.purple;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: _typeColor().withOpacity(0.15),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _typeColor(), width: 1)
      ),
      child: Text(type),
    );
  }
}