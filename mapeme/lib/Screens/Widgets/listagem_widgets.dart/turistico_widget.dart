import 'package:flutter/material.dart';

class TuristicPoint extends StatelessWidget {
  final int pontoTuristico;
  const TuristicPoint({super.key, required this.pontoTuristico});

  @override
  Widget build(BuildContext context) {
    return Text(
      pontoTuristico == 1 ? "Ponto Turístico" : "",
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 93, 9)),
    );
  }
}
