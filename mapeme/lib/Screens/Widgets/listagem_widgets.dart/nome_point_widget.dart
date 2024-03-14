import 'package:flutter/material.dart';

class NomePoint extends StatelessWidget {
  final String nomePoint;
  final int numLines;
  const NomePoint({super.key, required this.nomePoint, this.numLines = 1});

  @override
  Widget build(BuildContext context) {
    return Text(
      nomePoint,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
      maxLines: numLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
