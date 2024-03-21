import 'package:flutter/material.dart';

class NameTypePointInteresse extends StatelessWidget {
  final String nameTypePoint;
  const NameTypePointInteresse({super.key, required this.nameTypePoint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          nameTypePoint,
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
