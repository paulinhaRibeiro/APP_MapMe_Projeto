import 'package:flutter/material.dart';

class TuristicPoint extends StatelessWidget {
  final int pontoTuristico;
  const TuristicPoint({super.key, required this.pontoTuristico});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          pontoTuristico == 1 ? "Ponto Turístico" : "",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            color: Color.fromARGB(255, 0, 93, 9),
          ),
        ),
      ),
    );
  }
}
