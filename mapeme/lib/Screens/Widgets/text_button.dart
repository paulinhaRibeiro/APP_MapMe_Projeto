import 'package:flutter/material.dart';

class ScreenTextButtonStyle extends StatelessWidget {
  final String text;
  const ScreenTextButtonStyle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 19,//20,
        fontWeight: FontWeight.bold,
        // color: Color.fromARGB(255, 0, 63, 6),
      ),
    );
  }
}
