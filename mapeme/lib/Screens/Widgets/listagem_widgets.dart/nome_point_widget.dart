import 'package:flutter/material.dart';

class NomePoint extends StatelessWidget {
  final String nomePoint;
  const NomePoint({super.key, required this.nomePoint});

  @override
  Widget build(BuildContext context) {
    return Text(
      nomePoint,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color.fromARGB(255, 0, 63, 6),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}
